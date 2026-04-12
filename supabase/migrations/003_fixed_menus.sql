-- Fixed Menus (Menu Fisso / Prix Fixe)
-- Run this in Supabase SQL Editor

-- Main fixed menu table
CREATE TABLE fixed_menus (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    image_url TEXT,
    price DECIMAL(10,2) NOT NULL,
    available_for TEXT DEFAULT 'all' CHECK (available_for IN ('lunch', 'dinner', 'all')),
    available_days TEXT[] DEFAULT NULL, -- ['mon', 'tue', ...] or null for all
    valid_from TIMESTAMPTZ DEFAULT NULL,
    valid_to TIMESTAMPTZ DEFAULT NULL,
    sort_order INT DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ
);

-- Courses within a fixed menu (Primo, Secondo, Dolce, etc.)
CREATE TABLE fixed_menu_courses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    fixed_menu_id UUID NOT NULL REFERENCES fixed_menus(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    sort_order INT DEFAULT 0,
    is_required BOOLEAN DEFAULT true,
    max_choices INT DEFAULT 1,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ
);

-- Available choices for each course (links to menu_items)
CREATE TABLE fixed_menu_choices (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    course_id UUID NOT NULL REFERENCES fixed_menu_courses(id) ON DELETE CASCADE,
    menu_item_id UUID NOT NULL REFERENCES menu_items(id) ON DELETE CASCADE,
    menu_item_name TEXT NOT NULL, -- Cached for display
    supplement DECIMAL(10,2) DEFAULT 0, -- Extra cost
    is_default BOOLEAN DEFAULT false,
    sort_order INT DEFAULT 0,
    is_available BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ
);

-- Indexes for performance
CREATE INDEX idx_fixed_menus_tenant ON fixed_menus(tenant_id);
CREATE INDEX idx_fixed_menus_active ON fixed_menus(is_active, tenant_id);
CREATE INDEX idx_fixed_menu_courses_menu ON fixed_menu_courses(fixed_menu_id);
CREATE INDEX idx_fixed_menu_choices_course ON fixed_menu_choices(course_id);
CREATE INDEX idx_fixed_menu_choices_item ON fixed_menu_choices(menu_item_id);

-- Enable RLS
ALTER TABLE fixed_menus ENABLE ROW LEVEL SECURITY;
ALTER TABLE fixed_menu_courses ENABLE ROW LEVEL SECURITY;
ALTER TABLE fixed_menu_choices ENABLE ROW LEVEL SECURITY;

-- RLS Policies for fixed_menus
CREATE POLICY "Users can view own tenant fixed menus" ON fixed_menus
    FOR SELECT USING (
        tenant_id IN (SELECT tenant_id FROM users WHERE id = auth.uid())
    );

CREATE POLICY "Public can view active fixed menus" ON fixed_menus
    FOR SELECT USING (is_active = true);

CREATE POLICY "Staff can manage fixed menus" ON fixed_menus
    FOR ALL USING (
        tenant_id IN (SELECT tenant_id FROM users WHERE id = auth.uid())
    );

-- RLS Policies for fixed_menu_courses
CREATE POLICY "Users can view courses" ON fixed_menu_courses
    FOR SELECT USING (
        fixed_menu_id IN (SELECT id FROM fixed_menus WHERE is_active = true)
    );

CREATE POLICY "Staff can manage courses" ON fixed_menu_courses
    FOR ALL USING (
        fixed_menu_id IN (
            SELECT id FROM fixed_menus
            WHERE tenant_id IN (SELECT tenant_id FROM users WHERE id = auth.uid())
        )
    );

-- RLS Policies for fixed_menu_choices
CREATE POLICY "Users can view choices" ON fixed_menu_choices
    FOR SELECT USING (
        course_id IN (
            SELECT id FROM fixed_menu_courses
            WHERE fixed_menu_id IN (SELECT id FROM fixed_menus WHERE is_active = true)
        )
    );

CREATE POLICY "Staff can manage choices" ON fixed_menu_choices
    FOR ALL USING (
        course_id IN (
            SELECT fmc.id FROM fixed_menu_courses fmc
            JOIN fixed_menus fm ON fmc.fixed_menu_id = fm.id
            WHERE fm.tenant_id IN (SELECT tenant_id FROM users WHERE id = auth.uid())
        )
    );

-- Enable realtime for these tables
ALTER PUBLICATION supabase_realtime ADD TABLE fixed_menus;
ALTER PUBLICATION supabase_realtime ADD TABLE fixed_menu_courses;
ALTER PUBLICATION supabase_realtime ADD TABLE fixed_menu_choices;
