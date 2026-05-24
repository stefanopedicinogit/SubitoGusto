-- ============================================================================
-- Migration 012: Push Notifications
-- Adds per-customer push opt-in flag and a table to store FCM device tokens
-- (one customer can have many tokens — phone, tablet, web browsers).
-- Run this in Supabase SQL Editor.
-- ============================================================================

-- ============================================================================
-- 1. Opt-in flag on customers
-- ============================================================================

ALTER TABLE customers
    ADD COLUMN IF NOT EXISTS push_notifications_enabled BOOLEAN DEFAULT true;

-- ============================================================================
-- 2. push_tokens table
-- ============================================================================

CREATE TABLE IF NOT EXISTS push_tokens (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id UUID NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
    token TEXT NOT NULL,
    platform TEXT NOT NULL CHECK (platform IN ('android', 'ios', 'web')),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    last_seen_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE (token)
);

CREATE INDEX IF NOT EXISTS idx_push_tokens_customer ON push_tokens(customer_id);

-- ============================================================================
-- 3. RLS — a customer can only see/manage its own tokens
-- ============================================================================

ALTER TABLE push_tokens ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Customers manage own push tokens" ON push_tokens
    FOR ALL USING (customer_id = auth.uid())
    WITH CHECK (customer_id = auth.uid());

GRANT SELECT, INSERT, UPDATE, DELETE ON push_tokens TO authenticated;
