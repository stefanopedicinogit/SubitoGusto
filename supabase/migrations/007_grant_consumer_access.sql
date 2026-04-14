-- Fix RLS policies for consumer marketplace browsing
-- Consumers are authenticated but not staff — public policies need explicit role targeting

GRANT SELECT ON menu_items TO authenticated;
GRANT SELECT ON categories TO authenticated;
GRANT SELECT ON tenants TO authenticated;
GRANT SELECT ON fixed_menus TO authenticated;
GRANT SELECT ON fixed_menu_courses TO authenticated;
GRANT SELECT ON fixed_menu_choices TO authenticated;

-- Recreate public policies with explicit role targeting
DROP POLICY IF EXISTS "Public can view active menu" ON menu_items;
CREATE POLICY "Public can view active menu" ON menu_items
    FOR SELECT TO anon, authenticated
    USING (is_active = true);

DROP POLICY IF EXISTS "Public can view active categories" ON categories;
CREATE POLICY "Public can view active categories" ON categories
    FOR SELECT TO anon, authenticated
    USING (is_active = true);
