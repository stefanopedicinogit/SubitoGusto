-- Fix fixed menu RLS: tenant segregation is broken because the "Public" SELECT
-- policies (no tenant filter) override the tenant-scoped policies.
-- In PostgreSQL RLS, access is granted if ANY matching policy passes.
--
-- Fix: restrict public (no-tenant-filter) policies to the 'anon' role only,
-- so authenticated staff only sees their own tenant's data.
-- Run this in Supabase SQL Editor.

-- ============================================================================
-- fixed_menus
-- ============================================================================

-- Drop the overly permissive public policy
DROP POLICY IF EXISTS "Public can view active fixed menus" ON fixed_menus;

-- Recreate it for anon role only (customers scanning QR codes)
CREATE POLICY "Anon can view active fixed menus" ON fixed_menus
    FOR SELECT TO anon
    USING (is_active = true);

-- ============================================================================
-- fixed_menu_courses
-- ============================================================================

-- Drop the overly permissive courses policy
DROP POLICY IF EXISTS "Users can view courses" ON fixed_menu_courses;

-- Recreate for anon role only
CREATE POLICY "Anon can view courses" ON fixed_menu_courses
    FOR SELECT TO anon
    USING (
        fixed_menu_id IN (SELECT id FROM fixed_menus WHERE is_active = true)
    );

-- Add tenant-scoped policy for authenticated staff
CREATE POLICY "Staff can view own tenant courses" ON fixed_menu_courses
    FOR SELECT TO authenticated
    USING (
        fixed_menu_id IN (
            SELECT id FROM fixed_menus
            WHERE tenant_id = (SELECT tenant_id FROM users WHERE id = auth.uid())
        )
    );

-- ============================================================================
-- fixed_menu_choices
-- ============================================================================

-- Drop the overly permissive choices policy (from migration 005)
DROP POLICY IF EXISTS "Public can view choices" ON fixed_menu_choices;

-- Recreate for anon role only
CREATE POLICY "Anon can view choices" ON fixed_menu_choices
    FOR SELECT TO anon
    USING (is_available = true);

-- Add tenant-scoped policy for authenticated staff
CREATE POLICY "Staff can view own tenant choices" ON fixed_menu_choices
    FOR SELECT TO authenticated
    USING (
        course_id IN (
            SELECT fmc.id FROM fixed_menu_courses fmc
            JOIN fixed_menus fm ON fmc.fixed_menu_id = fm.id
            WHERE fm.tenant_id = (SELECT tenant_id FROM users WHERE id = auth.uid())
        )
    );
