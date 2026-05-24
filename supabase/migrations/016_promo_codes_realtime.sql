-- ============================================================================
-- Migration 016: Add promo_codes to Supabase Realtime
-- Lets the staff "Codici promozionali" page receive live UPDATEs when a
-- customer's checkout bumps `uses_count` via the create-payment-intent
-- edge function. RLS still applies — staff only see their own tenant's rows.
-- Run this in Supabase SQL Editor.
-- ============================================================================

DO $$
BEGIN
    ALTER PUBLICATION supabase_realtime ADD TABLE promo_codes;
EXCEPTION WHEN duplicate_object THEN
    NULL;
END $$;
