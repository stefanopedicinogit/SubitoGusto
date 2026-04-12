-- Add fixed menu support to order_items
-- Run this in Supabase SQL Editor

-- Make menu_item_id nullable (fixed menu orders don't reference a single menu item)
ALTER TABLE order_items ALTER COLUMN menu_item_id DROP NOT NULL;

-- Add fixed menu columns
ALTER TABLE order_items ADD COLUMN IF NOT EXISTS fixed_menu_id UUID REFERENCES fixed_menus(id) ON DELETE SET NULL;
ALTER TABLE order_items ADD COLUMN IF NOT EXISTS fixed_menu_selections JSONB;

-- Index for fixed menu lookups
CREATE INDEX IF NOT EXISTS idx_order_items_fixed_menu ON order_items(fixed_menu_id) WHERE fixed_menu_id IS NOT NULL;
