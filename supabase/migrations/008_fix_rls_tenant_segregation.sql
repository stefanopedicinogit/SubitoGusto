-- Fix RLS tenant segregation regression
-- Problem: migration 007 created "FOR SELECT TO anon, authenticated USING (is_active = true)"
-- which lets staff see ALL active menu items across all tenants (PostgreSQL ORs same-role policies).
-- Fix: public SELECT → anon only. Add consumer-specific policy using is_consumer() check.
-- Staff see only their tenant's items via existing FOR ALL policy.

-- ============================================================================
-- menu_items
-- ============================================================================

-- Drop the overly permissive policy from migration 007
DROP POLICY IF EXISTS "Public can view active menu" ON menu_items;

-- Anon (QR guests): see all active items
CREATE POLICY "Anon can view active menu" ON menu_items
    FOR SELECT TO anon
    USING (is_active = true);

-- Consumers (authenticated, no tenant): see all active items for marketplace
CREATE POLICY "Consumer can view active menu" ON menu_items
    FOR SELECT TO authenticated
    USING (is_active = true AND public.is_consumer());

-- Staff already covered by existing "Staff can manage menu" FOR ALL policy

-- ============================================================================
-- categories
-- ============================================================================

DROP POLICY IF EXISTS "Public can view active categories" ON categories;

CREATE POLICY "Anon can view active categories" ON categories
    FOR SELECT TO anon
    USING (is_active = true);

CREATE POLICY "Consumer can view active categories" ON categories
    FOR SELECT TO authenticated
    USING (is_active = true AND public.is_consumer());

-- Staff already covered by existing "Staff can view/manage categories" policies

-- ============================================================================
-- tenants (marketplace browsing)
-- ============================================================================

-- Ensure consumers can browse delivery-enabled restaurants
-- but staff only see their own tenant
DROP POLICY IF EXISTS "Public can view delivery restaurants" ON tenants;
DROP POLICY IF EXISTS "Consumer can view delivery restaurants" ON tenants;

CREATE POLICY "Consumer can view delivery restaurants" ON tenants
    FOR SELECT TO authenticated
    USING (delivery_enabled = true AND public.is_consumer());

-- ============================================================================
-- fixed_menus, fixed_menu_courses, fixed_menu_choices
-- ============================================================================

-- Same pattern: anon + consumer can view, staff use existing tenant-scoped policies
DROP POLICY IF EXISTS "Public can view active fixed menus" ON fixed_menus;

CREATE POLICY "Anon can view active fixed menus" ON fixed_menus
    FOR SELECT TO anon
    USING (is_active = true);

CREATE POLICY "Consumer can view active fixed menus" ON fixed_menus
    FOR SELECT TO authenticated
    USING (is_active = true AND public.is_consumer());

-- Courses and choices: anon/consumer can view all (no is_active filter on these)
DROP POLICY IF EXISTS "Users can view courses" ON fixed_menu_courses;

CREATE POLICY "Anon can view courses" ON fixed_menu_courses
    FOR SELECT TO anon
    USING (true);

CREATE POLICY "Consumer can view courses" ON fixed_menu_courses
    FOR SELECT TO authenticated
    USING (public.is_consumer());

DROP POLICY IF EXISTS "Users can view choices" ON fixed_menu_choices;

CREATE POLICY "Anon can view choices" ON fixed_menu_choices
    FOR SELECT TO anon
    USING (true);

CREATE POLICY "Consumer can view choices" ON fixed_menu_choices
    FOR SELECT TO authenticated
    USING (public.is_consumer());
