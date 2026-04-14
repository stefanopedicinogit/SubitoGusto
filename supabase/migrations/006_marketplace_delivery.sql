-- ============================================================================
-- Migration 006: Marketplace & Delivery Support
-- Run this in Supabase SQL Editor
-- ============================================================================

-- ============================================================================
-- 1. CUSTOMERS TABLE (consumer profiles, separate from staff users)
-- ============================================================================

CREATE TABLE IF NOT EXISTS customers (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT NOT NULL,
    display_name TEXT,
    phone TEXT,
    avatar_url TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ
);

-- ============================================================================
-- 2. DELIVERY ADDRESSES
-- ============================================================================

CREATE TABLE IF NOT EXISTS delivery_addresses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
    label TEXT DEFAULT 'Casa',
    street TEXT NOT NULL,
    city TEXT NOT NULL,
    postal_code TEXT NOT NULL,
    province TEXT,
    country TEXT DEFAULT 'IT',
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    notes TEXT,
    is_default BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ
);

-- ============================================================================
-- 3. DELIVERY COLUMNS ON TENANTS
-- ============================================================================

ALTER TABLE tenants ADD COLUMN IF NOT EXISTS delivery_enabled BOOLEAN DEFAULT false;
ALTER TABLE tenants ADD COLUMN IF NOT EXISTS delivery_fee DECIMAL(10,2) DEFAULT 0;
ALTER TABLE tenants ADD COLUMN IF NOT EXISTS delivery_radius_km DECIMAL(5,1) DEFAULT 5.0;
ALTER TABLE tenants ADD COLUMN IF NOT EXISTS delivery_min_order DECIMAL(10,2) DEFAULT 0;
ALTER TABLE tenants ADD COLUMN IF NOT EXISTS delivery_estimated_time_min INT DEFAULT 45;
ALTER TABLE tenants ADD COLUMN IF NOT EXISTS stripe_account_id TEXT;

-- ============================================================================
-- 4. DELIVERY ORDERS
-- ============================================================================

CREATE TABLE IF NOT EXISTS delivery_orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
    customer_id UUID NOT NULL REFERENCES customers(id),
    order_number TEXT NOT NULL,
    status TEXT DEFAULT 'pending' CHECK (status IN (
        'pending', 'confirmed', 'preparing', 'ready_for_delivery',
        'out_for_delivery', 'delivered', 'cancelled', 'refunded'
    )),
    subtotal DECIMAL(10,2) DEFAULT 0,
    delivery_fee DECIMAL(10,2) DEFAULT 0,
    discount DECIMAL(10,2) DEFAULT 0,
    total DECIMAL(10,2) DEFAULT 0,
    notes TEXT,
    -- Delivery address (denormalized snapshot at order time)
    delivery_street TEXT NOT NULL,
    delivery_city TEXT NOT NULL,
    delivery_postal_code TEXT NOT NULL,
    delivery_province TEXT,
    delivery_latitude DOUBLE PRECISION,
    delivery_longitude DOUBLE PRECISION,
    delivery_notes TEXT,
    -- Payment
    stripe_payment_intent_id TEXT,
    payment_status TEXT DEFAULT 'pending' CHECK (payment_status IN (
        'pending', 'paid', 'failed', 'refunded'
    )),
    -- Timestamps
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ,
    confirmed_at TIMESTAMPTZ,
    delivered_at TIMESTAMPTZ,
    estimated_delivery_at TIMESTAMPTZ
);

-- ============================================================================
-- 5. DELIVERY ORDER ITEMS
-- ============================================================================

CREATE TABLE IF NOT EXISTS delivery_order_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    delivery_order_id UUID NOT NULL REFERENCES delivery_orders(id) ON DELETE CASCADE,
    menu_item_id UUID REFERENCES menu_items(id),
    menu_item_name TEXT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    notes TEXT,
    status TEXT DEFAULT 'pending',
    fixed_menu_id UUID REFERENCES fixed_menus(id),
    fixed_menu_selections JSONB,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ
);

-- ============================================================================
-- 6. INDEXES
-- ============================================================================

CREATE INDEX IF NOT EXISTS idx_customers_email ON customers(email);
CREATE INDEX IF NOT EXISTS idx_delivery_addresses_customer ON delivery_addresses(customer_id);
CREATE INDEX IF NOT EXISTS idx_delivery_orders_tenant ON delivery_orders(tenant_id);
CREATE INDEX IF NOT EXISTS idx_delivery_orders_customer ON delivery_orders(customer_id);
CREATE INDEX IF NOT EXISTS idx_delivery_orders_status ON delivery_orders(status);
CREATE INDEX IF NOT EXISTS idx_delivery_order_items_order ON delivery_order_items(delivery_order_id);
CREATE INDEX IF NOT EXISTS idx_tenants_delivery_enabled ON tenants(delivery_enabled) WHERE delivery_enabled = true;

-- ============================================================================
-- 7. HELPER FUNCTION: detect consumer
-- ============================================================================

CREATE OR REPLACE FUNCTION public.is_consumer()
RETURNS BOOLEAN AS $$
    SELECT EXISTS (
        SELECT 1 FROM public.customers WHERE id = auth.uid()
    )
$$ LANGUAGE SQL SECURITY DEFINER STABLE;

-- ============================================================================
-- 8. RLS POLICIES
-- ============================================================================

-- Customers table
ALTER TABLE customers ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Customers can view own profile" ON customers
    FOR SELECT USING (id = auth.uid());

CREATE POLICY "Customers can update own profile" ON customers
    FOR UPDATE USING (id = auth.uid());

CREATE POLICY "Customers can insert own profile" ON customers
    FOR INSERT WITH CHECK (id = auth.uid());

-- Delivery addresses
ALTER TABLE delivery_addresses ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Customers manage own addresses" ON delivery_addresses
    FOR ALL USING (customer_id = auth.uid());

-- Tenants: allow public to see delivery-enabled restaurants (marketplace)
CREATE POLICY "Public can view delivery restaurants" ON tenants
    FOR SELECT USING (delivery_enabled = true);

-- Delivery orders
ALTER TABLE delivery_orders ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Customers view own delivery orders" ON delivery_orders
    FOR SELECT USING (customer_id = auth.uid());

CREATE POLICY "Customers create delivery orders" ON delivery_orders
    FOR INSERT WITH CHECK (customer_id = auth.uid());

CREATE POLICY "Staff manage restaurant delivery orders" ON delivery_orders
    FOR ALL USING (tenant_id = public.get_user_restaurant_id());

-- Delivery order items
ALTER TABLE delivery_order_items ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Customers view own delivery order items" ON delivery_order_items
    FOR SELECT USING (
        delivery_order_id IN (SELECT id FROM delivery_orders WHERE customer_id = auth.uid())
    );

CREATE POLICY "Customers create delivery order items" ON delivery_order_items
    FOR INSERT WITH CHECK (
        delivery_order_id IN (SELECT id FROM delivery_orders WHERE customer_id = auth.uid())
    );

CREATE POLICY "Staff manage delivery order items" ON delivery_order_items
    FOR ALL USING (
        delivery_order_id IN (
            SELECT id FROM delivery_orders WHERE tenant_id = public.get_user_restaurant_id()
        )
    );

-- ============================================================================
-- 9. REALTIME for delivery orders
-- ============================================================================

DO $$
BEGIN
    ALTER PUBLICATION supabase_realtime ADD TABLE delivery_orders;
EXCEPTION WHEN duplicate_object THEN
    NULL;
END $$;

DO $$
BEGIN
    ALTER PUBLICATION supabase_realtime ADD TABLE delivery_order_items;
EXCEPTION WHEN duplicate_object THEN
    NULL;
END $$;

-- ============================================================================
-- 10. FIX handle_new_user TRIGGER
-- Only create staff user row if metadata indicates staff registration.
-- Consumer signups should NOT get a row in the users table.
-- ============================================================================

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    -- Only create staff user if user_type is 'staff' or not specified
    -- (backwards compatible: existing staff signups without metadata still work)
    IF NEW.raw_user_meta_data->>'user_type' IS NULL
       OR NEW.raw_user_meta_data->>'user_type' = 'staff' THEN
        INSERT INTO public.users (id, email, restaurant_id, role)
        VALUES (
            NEW.id,
            NEW.email,
            'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',
            'waiter'
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================================
-- 11. Optional: link dine-in orders to consumer profiles
-- ============================================================================

ALTER TABLE orders ADD COLUMN IF NOT EXISTS customer_id UUID REFERENCES customers(id);
CREATE INDEX IF NOT EXISTS idx_orders_customer ON orders(customer_id) WHERE customer_id IS NOT NULL;

-- Grant access tables to anon/authenticated for marketplace browsing
GRANT SELECT ON customers TO authenticated;
GRANT SELECT ON delivery_addresses TO authenticated;
GRANT SELECT, INSERT ON delivery_orders TO authenticated;
GRANT SELECT, INSERT ON delivery_order_items TO authenticated;
GRANT SELECT ON tenants TO anon;
GRANT SELECT ON tenants TO authenticated;
