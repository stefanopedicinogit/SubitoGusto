-- ============================================================================
-- Migration 011: Vacation Mode for Tenants
-- Allows a restaurant to temporarily pause receiving orders without
-- disabling delivery entirely.
-- Run this in Supabase SQL Editor
-- ============================================================================

ALTER TABLE tenants ADD COLUMN IF NOT EXISTS vacation_mode BOOLEAN DEFAULT false;

CREATE INDEX IF NOT EXISTS idx_tenants_vacation_mode ON tenants(vacation_mode)
    WHERE vacation_mode = true;
