-- ============================================================================
-- Migration 014: Tenant discovery metadata
-- Adds cuisine_type (single) and dietary_tags (array) to tenants so the
-- marketplace can filter by cuisine and dietary preferences.
-- Values are free-form strings — the UI constrains them to a curated list;
-- no DB-level enum so we can add new options without migrations.
-- Run this in Supabase SQL Editor.
-- ============================================================================

ALTER TABLE tenants
    ADD COLUMN IF NOT EXISTS cuisine_type TEXT,
    ADD COLUMN IF NOT EXISTS dietary_tags TEXT[] DEFAULT ARRAY[]::TEXT[];

-- Indexes to keep filter queries fast as the marketplace grows.
CREATE INDEX IF NOT EXISTS idx_tenants_cuisine_type
    ON tenants(cuisine_type)
    WHERE delivery_enabled = true;

CREATE INDEX IF NOT EXISTS idx_tenants_dietary_tags
    ON tenants USING GIN (dietary_tags)
    WHERE delivery_enabled = true;
