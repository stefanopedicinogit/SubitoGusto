-- Fix RLS policies for fixed menu tables
-- The nested subqueries in choices policy don't resolve correctly for anon role.
-- Also add explicit GRANT for anon/authenticated roles.
-- Run this in Supabase SQL Editor.

-- Grant table access to anon and authenticated roles
GRANT SELECT ON fixed_menus TO anon, authenticated;
GRANT SELECT ON fixed_menu_courses TO anon, authenticated;
GRANT SELECT ON fixed_menu_choices TO anon, authenticated;
GRANT ALL ON fixed_menus TO authenticated;
GRANT ALL ON fixed_menu_courses TO authenticated;
GRANT ALL ON fixed_menu_choices TO authenticated;

-- Drop the old problematic choices policy (deeply nested subquery)
DROP POLICY IF EXISTS "Users can view choices" ON fixed_menu_choices;

-- Recreate with a simpler policy that doesn't rely on nested RLS evaluation
-- Choices are visible if they belong to an available course (is_available flag)
CREATE POLICY "Public can view choices" ON fixed_menu_choices
    FOR SELECT USING (is_available = true);
