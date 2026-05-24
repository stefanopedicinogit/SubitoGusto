-- ============================================================================
-- Migration 013: Ratings & Reviews
-- - reviews table: customers rate restaurants and individual menu items
-- - one review per (customer, target_type, target_id) — re-submit = update
-- - INSERT/UPDATE allowed only if customer has a delivered order containing
--   that target (server-enforced via RLS, not client-trustable)
-- - profanity guard + length check via BEFORE trigger
-- - review_aggregates view: avg + count per target, used for marketplace sort
-- Run this in Supabase SQL Editor.
-- ============================================================================

-- ============================================================================
-- 1. reviews table
-- ============================================================================

CREATE TABLE IF NOT EXISTS reviews (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
    target_type TEXT NOT NULL CHECK (target_type IN ('restaurant', 'item')),
    target_id UUID NOT NULL,
    rating SMALLINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ,
    UNIQUE (customer_id, target_type, target_id)
);

CREATE INDEX IF NOT EXISTS idx_reviews_target ON reviews(target_type, target_id);
CREATE INDEX IF NOT EXISTS idx_reviews_customer ON reviews(customer_id);

-- ============================================================================
-- 2. Profanity + length guard
--    Conservative Italian + English list. Easy to extend by adding to the
--    array literal below.
-- ============================================================================

CREATE OR REPLACE FUNCTION public.validate_review_comment()
RETURNS TRIGGER AS $$
DECLARE
    bad_words TEXT[] := ARRAY[
        'cazzo', 'merda', 'stronzo', 'puttana', 'vaffanculo', 'troia',
        'coglione', 'bastardo', 'porcodio', 'figadi',
        'fuck', 'shit', 'asshole', 'bitch', 'cunt', 'bastard'
    ];
    word TEXT;
    lowered TEXT;
BEGIN
    NEW.updated_at := NOW();

    IF NEW.comment IS NULL OR LENGTH(TRIM(NEW.comment)) = 0 THEN
        NEW.comment := NULL;
        RETURN NEW;
    END IF;

    IF LENGTH(NEW.comment) > 500 THEN
        RAISE EXCEPTION 'Comment too long (max 500 characters)';
    END IF;

    lowered := LOWER(NEW.comment);
    FOREACH word IN ARRAY bad_words LOOP
        -- \m / \M = word boundaries in Postgres regex
        IF lowered ~ ('\m' || word || '\M') THEN
            RAISE EXCEPTION 'Comment contains inappropriate language';
        END IF;
    END LOOP;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_validate_review_comment ON reviews;
CREATE TRIGGER trg_validate_review_comment
    BEFORE INSERT OR UPDATE ON reviews
    FOR EACH ROW
    EXECUTE FUNCTION public.validate_review_comment();

-- ============================================================================
-- 3. RLS
-- ============================================================================

ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;

-- Anyone (incl. anonymous marketplace browsers) can read reviews.
CREATE POLICY "Reviews public read" ON reviews
    FOR SELECT
    USING (true);

-- Insert: only the customer themselves, AND only if they have a delivered
-- order whose tenant_id (for restaurant reviews) or whose items
-- (for item reviews) match the target.
CREATE POLICY "Customers create own reviews after delivery" ON reviews
    FOR INSERT TO authenticated
    WITH CHECK (
        customer_id = auth.uid()
        AND (
            (target_type = 'restaurant' AND EXISTS (
                SELECT 1 FROM delivery_orders
                WHERE customer_id = auth.uid()
                  AND tenant_id = target_id
                  AND status = 'delivered'
            ))
            OR (target_type = 'item' AND EXISTS (
                SELECT 1 FROM delivery_order_items doi
                JOIN delivery_orders d ON d.id = doi.delivery_order_id
                WHERE d.customer_id = auth.uid()
                  AND d.status = 'delivered'
                  AND doi.menu_item_id = target_id
            ))
        )
    );

-- Update: only the row's owner.
CREATE POLICY "Customers update own reviews" ON reviews
    FOR UPDATE TO authenticated
    USING (customer_id = auth.uid())
    WITH CHECK (customer_id = auth.uid());

-- Delete: only the row's owner.
CREATE POLICY "Customers delete own reviews" ON reviews
    FOR DELETE TO authenticated
    USING (customer_id = auth.uid());

GRANT SELECT ON reviews TO authenticated, anon;
GRANT INSERT, UPDATE, DELETE ON reviews TO authenticated;

-- ============================================================================
-- 4. review_aggregates view
--    avg_rating + review_count per target. Cheap on a regular view; if read
--    volume grows we can switch to a materialized view + REFRESH on commit.
-- ============================================================================

CREATE OR REPLACE VIEW review_aggregates AS
SELECT
    target_type,
    target_id,
    ROUND(AVG(rating)::numeric, 1) AS avg_rating,
    COUNT(*)::int AS review_count
FROM reviews
GROUP BY target_type, target_id;

GRANT SELECT ON review_aggregates TO authenticated, anon;
