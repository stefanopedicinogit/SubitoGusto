-- ============================================================================
-- Migration 013: Staff FCM Token
-- Adds a nullable fcm_token column to the users (staff) table so the backend
-- can push "new order" notifications to restaurant staff devices.
-- One token per staff row — the last device to log in wins.
-- ============================================================================

ALTER TABLE users
    ADD COLUMN IF NOT EXISTS fcm_token TEXT;
