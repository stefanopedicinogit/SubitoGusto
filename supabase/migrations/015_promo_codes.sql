-- ============================================================================
-- Migration 015: Promotions & discount codes
-- - promo_codes: defined per-tenant (or global if tenant_id IS NULL)
-- - promo_redemptions: append-only log of who used what code on which order,
--   used to enforce per_customer_limit and for restaurant analytics
-- - all validation is enforced server-side in the edge function (RLS keeps
--   customers from reading the code table directly to prevent enumeration)
-- Run this in Supabase SQL Editor.
-- ============================================================================

-- ============================================================================
-- 1. promo_codes
-- ============================================================================

CREATE TABLE IF NOT EXISTS promo_codes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    -- Code is stored UPPERCASE so lookups are case-insensitive without a
    -- functional index. The edge function uppercases the user's input.
    code TEXT NOT NULL UNIQUE,
    tenant_id UUID REFERENCES tenants(id) ON DELETE CASCADE,
    type TEXT NOT NULL CHECK (type IN ('percent', 'fixed')),
    -- For 'percent' value is 0-100. For 'fixed' value is an absolute amount
    -- in the order's currency.
    value DECIMAL(10,2) NOT NULL CHECK (value > 0),
    min_order DECIMAL(10,2) NOT NULL DEFAULT 0,
    valid_from TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    valid_until TIMESTAMPTZ,
    max_uses INT,
    uses_count INT NOT NULL DEFAULT 0,
    per_customer_limit INT NOT NULL DEFAULT 1,
    active BOOLEAN NOT NULL DEFAULT true,
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_promo_codes_code ON promo_codes(code);
CREATE INDEX IF NOT EXISTS idx_promo_codes_tenant ON promo_codes(tenant_id)
    WHERE tenant_id IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_promo_codes_active
    ON promo_codes(tenant_id, active) WHERE active = true;

-- ============================================================================
-- 2. promo_redemptions
-- ============================================================================

CREATE TABLE IF NOT EXISTS promo_redemptions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    promo_code_id UUID NOT NULL REFERENCES promo_codes(id) ON DELETE CASCADE,
    customer_id UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
    delivery_order_id UUID NOT NULL REFERENCES delivery_orders(id) ON DELETE CASCADE,
    discount_amount DECIMAL(10,2) NOT NULL,
    redeemed_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    -- One promo per order — keeps math simple and matches user expectations.
    UNIQUE (delivery_order_id)
);

CREATE INDEX IF NOT EXISTS idx_redemptions_customer
    ON promo_redemptions(customer_id);
CREATE INDEX IF NOT EXISTS idx_redemptions_promo
    ON promo_redemptions(promo_code_id);

-- ============================================================================
-- 3. RLS
-- ============================================================================

ALTER TABLE promo_codes ENABLE ROW LEVEL SECURITY;
ALTER TABLE promo_redemptions ENABLE ROW LEVEL SECURITY;

-- Staff CRUD their own tenant's codes.
CREATE POLICY "Staff manage own tenant promo codes" ON promo_codes
    FOR ALL TO authenticated
    USING (tenant_id = public.get_user_restaurant_id())
    WITH CHECK (tenant_id = public.get_user_restaurant_id());

-- Customers cannot SELECT codes directly — prevents enumeration. They submit
-- the code at checkout and the edge function (service role) validates it.

-- Customers can see their own redemption history (for analytics / "promo usata").
CREATE POLICY "Customers view own redemptions" ON promo_redemptions
    FOR SELECT TO authenticated
    USING (customer_id = auth.uid());

-- Staff can see redemptions for their own tenant's codes (for analytics).
CREATE POLICY "Staff view own tenant redemptions" ON promo_redemptions
    FOR SELECT TO authenticated
    USING (
        promo_code_id IN (
            SELECT id FROM promo_codes
            WHERE tenant_id = public.get_user_restaurant_id()
        )
    );

GRANT SELECT, INSERT, UPDATE, DELETE ON promo_codes TO authenticated;
GRANT SELECT ON promo_redemptions TO authenticated;
-- Service role inserts redemptions from the edge function.
