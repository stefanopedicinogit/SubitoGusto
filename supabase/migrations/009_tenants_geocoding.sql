-- ============================================================================
-- 009 - Tenant geocoding columns
-- Adds lat/lng to tenants so marketplace can compute distance to consumer.
-- delivery_addresses already has latitude/longitude (from migration 006).
-- ============================================================================

ALTER TABLE tenants ADD COLUMN IF NOT EXISTS latitude DOUBLE PRECISION;
ALTER TABLE tenants ADD COLUMN IF NOT EXISTS longitude DOUBLE PRECISION;

CREATE INDEX IF NOT EXISTS idx_tenants_geo ON tenants(latitude, longitude)
    WHERE latitude IS NOT NULL AND longitude IS NOT NULL;
