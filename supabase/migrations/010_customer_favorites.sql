-- ============================================================================
-- Migration 010: Customer Favorites (liked restaurants and menu items)
-- Run this in Supabase SQL Editor
-- ============================================================================

-- ============================================================================
-- 1. FAVORITE RESTAURANTS
-- ============================================================================

CREATE TABLE IF NOT EXISTS customer_favorite_restaurants (
    customer_id UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
    tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (customer_id, tenant_id)
);

CREATE INDEX IF NOT EXISTS idx_fav_restaurants_customer
    ON customer_favorite_restaurants(customer_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_fav_restaurants_tenant
    ON customer_favorite_restaurants(tenant_id);

-- ============================================================================
-- 2. FAVORITE MENU ITEMS
-- ============================================================================

CREATE TABLE IF NOT EXISTS customer_favorite_items (
    customer_id UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
    menu_item_id UUID NOT NULL REFERENCES menu_items(id) ON DELETE CASCADE,
    tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (customer_id, menu_item_id)
);

CREATE INDEX IF NOT EXISTS idx_fav_items_customer
    ON customer_favorite_items(customer_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_fav_items_tenant
    ON customer_favorite_items(tenant_id);

-- ============================================================================
-- 3. RLS POLICIES
-- ============================================================================

ALTER TABLE customer_favorite_restaurants ENABLE ROW LEVEL SECURITY;
ALTER TABLE customer_favorite_items ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Customers manage own favorite restaurants" ON customer_favorite_restaurants
    FOR ALL USING (customer_id = auth.uid()) WITH CHECK (customer_id = auth.uid());

CREATE POLICY "Customers manage own favorite items" ON customer_favorite_items
    FOR ALL USING (customer_id = auth.uid()) WITH CHECK (customer_id = auth.uid());

-- ============================================================================
-- 4. GRANTS
-- ============================================================================

GRANT SELECT, INSERT, DELETE ON customer_favorite_restaurants TO authenticated;
GRANT SELECT, INSERT, DELETE ON customer_favorite_items TO authenticated;
