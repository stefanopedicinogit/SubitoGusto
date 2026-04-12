-- ============================================================================
-- SUBITO GUSTO - Database Schema
-- Esegui questo script nel SQL Editor di Supabase
-- ============================================================================

-- ============================================================================
-- TABELLE
-- ============================================================================

-- Restaurants (tenant principale)
CREATE TABLE IF NOT EXISTS restaurants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    description TEXT,
    logo_url TEXT,
    cover_image_url TEXT,
    address TEXT,
    phone TEXT,
    email TEXT,
    opening_hours JSONB DEFAULT '{}',
    settings JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ
);

-- Categories (categorie menu)
CREATE TABLE IF NOT EXISTS categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    restaurant_id UUID NOT NULL REFERENCES restaurants(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    image_url TEXT,
    sort_order INT DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ
);

-- Menu Items (piatti/bevande)
CREATE TABLE IF NOT EXISTS menu_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    restaurant_id UUID NOT NULL REFERENCES restaurants(id) ON DELETE CASCADE,
    category_id UUID NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    image_url TEXT,
    allergens TEXT[] DEFAULT '{}',
    tags TEXT[] DEFAULT '{}',
    is_available BOOLEAN DEFAULT true,
    is_active BOOLEAN DEFAULT true,
    preparation_time INT,
    calories INT,
    sort_order INT DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ
);

-- Tables (tavoli ristorante)
CREATE TABLE IF NOT EXISTS tables (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    restaurant_id UUID NOT NULL REFERENCES restaurants(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    qr_code TEXT NOT NULL UNIQUE,
    capacity INT DEFAULT 4,
    zone TEXT,
    status TEXT DEFAULT 'available' CHECK (status IN ('available', 'occupied', 'reserved')),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ
);

-- Orders (ordini)
CREATE TABLE IF NOT EXISTS orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    restaurant_id UUID NOT NULL REFERENCES restaurants(id) ON DELETE CASCADE,
    table_id UUID NOT NULL REFERENCES tables(id),
    order_number TEXT NOT NULL,
    status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'preparing', 'ready', 'served', 'paid', 'cancelled')),
    subtotal DECIMAL(10,2) DEFAULT 0,
    discount DECIMAL(10,2) DEFAULT 0,
    total DECIMAL(10,2) DEFAULT 0,
    notes TEXT,
    customer_name TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ,
    confirmed_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ
);

-- Order Items (righe ordine)
CREATE TABLE IF NOT EXISTS order_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    menu_item_id UUID NOT NULL REFERENCES menu_items(id),
    menu_item_name TEXT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    notes TEXT,
    status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'preparing', 'ready', 'served')),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ
);

-- Users (utenti staff - estende auth.users)
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    restaurant_id UUID NOT NULL REFERENCES restaurants(id) ON DELETE CASCADE,
    email TEXT NOT NULL,
    role TEXT NOT NULL DEFAULT 'waiter' CHECK (role IN ('admin', 'manager', 'waiter', 'kitchen')),
    first_name TEXT,
    last_name TEXT,
    avatar_url TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ,
    last_login_at TIMESTAMPTZ
);

-- ============================================================================
-- INDICI
-- ============================================================================

CREATE INDEX IF NOT EXISTS idx_categories_restaurant ON categories(restaurant_id);
CREATE INDEX IF NOT EXISTS idx_menu_items_restaurant ON menu_items(restaurant_id);
CREATE INDEX IF NOT EXISTS idx_menu_items_category ON menu_items(category_id);
CREATE INDEX IF NOT EXISTS idx_tables_restaurant ON tables(restaurant_id);
CREATE INDEX IF NOT EXISTS idx_tables_qr_code ON tables(qr_code);
CREATE INDEX IF NOT EXISTS idx_orders_restaurant ON orders(restaurant_id);
CREATE INDEX IF NOT EXISTS idx_orders_table ON orders(table_id);
CREATE INDEX IF NOT EXISTS idx_orders_status ON orders(status);
CREATE INDEX IF NOT EXISTS idx_order_items_order ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_users_restaurant ON users(restaurant_id);

-- ============================================================================
-- FUNZIONI HELPER PER RLS (evita ricorsione)
-- ============================================================================

-- Funzione per ottenere restaurant_id dell'utente corrente (bypassa RLS)
CREATE OR REPLACE FUNCTION public.get_user_restaurant_id()
RETURNS UUID AS $$
    SELECT restaurant_id FROM public.users WHERE id = auth.uid()
$$ LANGUAGE SQL SECURITY DEFINER STABLE;

-- Funzione per verificare se utente è admin
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN AS $$
    SELECT EXISTS (
        SELECT 1 FROM public.users
        WHERE id = auth.uid() AND role = 'admin'
    )
$$ LANGUAGE SQL SECURITY DEFINER STABLE;

-- ============================================================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================================================

-- Abilita RLS su tutte le tabelle
ALTER TABLE restaurants ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE menu_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE tables ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Drop existing policies (per re-esecuzione sicura)
DROP POLICY IF EXISTS "Staff can view own restaurant" ON restaurants;
DROP POLICY IF EXISTS "Staff can update own restaurant" ON restaurants;
DROP POLICY IF EXISTS "Staff can view categories" ON categories;
DROP POLICY IF EXISTS "Staff can manage categories" ON categories;
DROP POLICY IF EXISTS "Public can view active menu" ON menu_items;
DROP POLICY IF EXISTS "Staff can manage menu" ON menu_items;
DROP POLICY IF EXISTS "Public can view active categories" ON categories;
DROP POLICY IF EXISTS "Public can view active tables" ON tables;
DROP POLICY IF EXISTS "Staff can manage tables" ON tables;
DROP POLICY IF EXISTS "Public can create orders" ON orders;
DROP POLICY IF EXISTS "Public can view own orders" ON orders;
DROP POLICY IF EXISTS "Staff can manage orders" ON orders;
DROP POLICY IF EXISTS "Public can create order items" ON order_items;
DROP POLICY IF EXISTS "Public can view order items" ON order_items;
DROP POLICY IF EXISTS "Staff can manage order items" ON order_items;
DROP POLICY IF EXISTS "Users can view own profile" ON users;
DROP POLICY IF EXISTS "Users can update own profile" ON users;
DROP POLICY IF EXISTS "Admin can manage users" ON users;

-- Policy: Staff vede solo il proprio ristorante
CREATE POLICY "Staff can view own restaurant" ON restaurants
    FOR SELECT USING (id = public.get_user_restaurant_id());

CREATE POLICY "Staff can update own restaurant" ON restaurants
    FOR UPDATE USING (id = public.get_user_restaurant_id());

-- Policy: Staff vede categorie del proprio ristorante
CREATE POLICY "Staff can view categories" ON categories
    FOR SELECT USING (restaurant_id = public.get_user_restaurant_id());

CREATE POLICY "Staff can manage categories" ON categories
    FOR ALL USING (restaurant_id = public.get_user_restaurant_id());

-- Policy: Tutti possono vedere menu attivi (per clienti)
CREATE POLICY "Public can view active menu" ON menu_items
    FOR SELECT USING (is_active = true);

CREATE POLICY "Staff can manage menu" ON menu_items
    FOR ALL USING (restaurant_id = public.get_user_restaurant_id());

-- Policy: Tutti possono vedere categorie attive
CREATE POLICY "Public can view active categories" ON categories
    FOR SELECT USING (is_active = true);

-- Policy: Tavoli visibili a tutti (per QR scan)
CREATE POLICY "Public can view active tables" ON tables
    FOR SELECT USING (is_active = true);

CREATE POLICY "Staff can manage tables" ON tables
    FOR ALL USING (restaurant_id = public.get_user_restaurant_id());

-- Policy: Clienti possono creare ordini
CREATE POLICY "Public can create orders" ON orders
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Public can view own orders" ON orders
    FOR SELECT USING (true);

CREATE POLICY "Staff can manage orders" ON orders
    FOR ALL USING (restaurant_id = public.get_user_restaurant_id());

-- Policy: Order items seguono le policy degli ordini
CREATE POLICY "Public can create order items" ON order_items
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Public can view order items" ON order_items
    FOR SELECT USING (true);

CREATE POLICY "Staff can manage order items" ON order_items
    FOR ALL USING (
        order_id IN (
            SELECT id FROM orders WHERE restaurant_id = public.get_user_restaurant_id()
        )
    );

-- Policy: Users (semplificata per evitare ricorsione)
CREATE POLICY "Users can view own profile" ON users
    FOR SELECT USING (id = auth.uid());

CREATE POLICY "Users can update own profile" ON users
    FOR UPDATE USING (id = auth.uid());

-- Per admin: gestire tramite service_role key o funzioni SECURITY DEFINER

-- ============================================================================
-- REALTIME
-- ============================================================================

-- Abilita realtime per ordini (notifiche staff)
-- Usa DO block per ignorare errore se già esistente
DO $$
BEGIN
    ALTER PUBLICATION supabase_realtime ADD TABLE orders;
EXCEPTION WHEN duplicate_object THEN
    NULL;
END $$;

DO $$
BEGIN
    ALTER PUBLICATION supabase_realtime ADD TABLE order_items;
EXCEPTION WHEN duplicate_object THEN
    NULL;
END $$;

-- ============================================================================
-- DATI DI ESEMPIO (opzionale)
-- ============================================================================

-- Inserisci un ristorante di esempio
INSERT INTO restaurants (id, name, description, address, phone, email) VALUES (
    'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',
    'SubitoGusto Demo',
    'Cucina italiana tradizionale con un tocco moderno',
    'Via Roma 123, Milano',
    '+39 02 1234567',
    'info@subitogusto.it'
) ON CONFLICT DO NOTHING;

-- Inserisci categorie di esempio
INSERT INTO categories (restaurant_id, name, description, sort_order) VALUES
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'Antipasti', 'Per iniziare con gusto', 1),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'Primi Piatti', 'Pasta e risotti della tradizione', 2),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'Secondi Piatti', 'Carne e pesce selezionati', 3),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'Contorni', 'Verdure di stagione', 4),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'Dolci', 'Per concludere in dolcezza', 5),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'Bevande', 'Vini, birre e soft drinks', 6)
ON CONFLICT DO NOTHING;

-- Inserisci tavoli di esempio
INSERT INTO tables (restaurant_id, name, qr_code, capacity, zone) VALUES
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'Tavolo 1', 'TBL001', 4, 'Sala Principale'),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'Tavolo 2', 'TBL002', 4, 'Sala Principale'),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'Tavolo 3', 'TBL003', 6, 'Sala Principale'),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'Tavolo 4', 'TBL004', 2, 'Terrazza'),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'Tavolo 5', 'TBL005', 4, 'Terrazza'),
    ('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'Tavolo 6', 'TBL006', 8, 'Sala Privata')
ON CONFLICT DO NOTHING;

-- Inserisci piatti di esempio
-- Prima otteniamo gli ID delle categorie
DO $$
DECLARE
    cat_antipasti UUID;
    cat_primi UUID;
    cat_secondi UUID;
    cat_contorni UUID;
    cat_dolci UUID;
    cat_bevande UUID;
    rest_id UUID := 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11';
BEGIN
    SELECT id INTO cat_antipasti FROM categories WHERE restaurant_id = rest_id AND name = 'Antipasti';
    SELECT id INTO cat_primi FROM categories WHERE restaurant_id = rest_id AND name = 'Primi Piatti';
    SELECT id INTO cat_secondi FROM categories WHERE restaurant_id = rest_id AND name = 'Secondi Piatti';
    SELECT id INTO cat_contorni FROM categories WHERE restaurant_id = rest_id AND name = 'Contorni';
    SELECT id INTO cat_dolci FROM categories WHERE restaurant_id = rest_id AND name = 'Dolci';
    SELECT id INTO cat_bevande FROM categories WHERE restaurant_id = rest_id AND name = 'Bevande';

    -- ANTIPASTI
    INSERT INTO menu_items (restaurant_id, category_id, name, description, price, allergens, tags, sort_order) VALUES
    (rest_id, cat_antipasti, 'Bruschetta Classica', 'Pane tostato con pomodori freschi, basilico e olio EVO', 6.50, ARRAY['glutine']::TEXT[], ARRAY['vegetariano']::TEXT[], 1),
    (rest_id, cat_antipasti, 'Carpaccio di Manzo', 'Fettine di manzo con rucola, grana e tartufo nero', 14.00, ARRAY['latte']::TEXT[], ARRAY['chefs_choice']::TEXT[], 2),
    (rest_id, cat_antipasti, 'Burrata Pugliese', 'Burrata fresca con pomodorini e pesto', 12.00, ARRAY['latte']::TEXT[], ARRAY['vegetariano']::TEXT[], 3),
    (rest_id, cat_antipasti, 'Tagliere di Salumi', 'Selezione di salumi italiani DOP con focaccia', 16.00, ARRAY['glutine', 'latte']::TEXT[], ARRAY[]::TEXT[], 4),
    (rest_id, cat_antipasti, 'Caprese', 'Mozzarella di bufala, pomodoro cuore di bue e basilico', 10.00, ARRAY['latte']::TEXT[], ARRAY['vegetariano']::TEXT[], 5),
    (rest_id, cat_antipasti, 'Frittura di Calamari', 'Calamari freschi in pastella leggera', 13.00, ARRAY['glutine', 'molluschi']::TEXT[], ARRAY[]::TEXT[], 6)
    ON CONFLICT DO NOTHING;

    -- PRIMI PIATTI
    INSERT INTO menu_items (restaurant_id, category_id, name, description, price, allergens, tags, sort_order) VALUES
    (rest_id, cat_primi, 'Spaghetti alla Carbonara', 'Guanciale croccante, tuorlo d''uovo, pecorino romano DOP', 14.00, ARRAY['glutine', 'uova', 'latte']::TEXT[], ARRAY['chefs_choice']::TEXT[], 1),
    (rest_id, cat_primi, 'Rigatoni all''Amatriciana', 'Guanciale, pomodoro San Marzano, pecorino', 13.00, ARRAY['glutine', 'latte']::TEXT[], ARRAY[]::TEXT[], 2),
    (rest_id, cat_primi, 'Tagliatelle al Ragù', 'Ragù bolognese cotto 6 ore con pasta fresca', 14.00, ARRAY['glutine', 'uova', 'latte']::TEXT[], ARRAY[]::TEXT[], 3),
    (rest_id, cat_primi, 'Risotto ai Funghi Porcini', 'Carnaroli mantecato con porcini freschi', 16.00, ARRAY['latte']::TEXT[], ARRAY['vegetariano']::TEXT[], 4),
    (rest_id, cat_primi, 'Lasagna della Nonna', 'Strati di pasta fresca con ragù e besciamella', 14.00, ARRAY['glutine', 'uova', 'latte']::TEXT[], ARRAY[]::TEXT[], 5),
    (rest_id, cat_primi, 'Gnocchi al Gorgonzola', 'Gnocchi di patate con crema di gorgonzola e noci', 13.00, ARRAY['glutine', 'latte', 'frutta_guscio']::TEXT[], ARRAY['vegetariano']::TEXT[], 6),
    (rest_id, cat_primi, 'Penne all''Arrabbiata', 'Pomodoro, aglio, peperoncino piccante', 11.00, ARRAY['glutine']::TEXT[], ARRAY['vegetariano', 'vegano', 'piccante']::TEXT[], 7),
    (rest_id, cat_primi, 'Spaghetti alle Vongole', 'Vongole veraci, aglio, prezzemolo, vino bianco', 16.00, ARRAY['glutine', 'molluschi']::TEXT[], ARRAY[]::TEXT[], 8)
    ON CONFLICT DO NOTHING;

    -- SECONDI PIATTI
    INSERT INTO menu_items (restaurant_id, category_id, name, description, price, allergens, tags, sort_order) VALUES
    (rest_id, cat_secondi, 'Tagliata di Manzo', 'Controfiletto alla brace con rucola e grana', 24.00, ARRAY['latte']::TEXT[], ARRAY['chefs_choice']::TEXT[], 1),
    (rest_id, cat_secondi, 'Filetto al Pepe Verde', 'Filetto di manzo con salsa al pepe verde', 26.00, ARRAY['latte']::TEXT[], ARRAY[]::TEXT[], 2),
    (rest_id, cat_secondi, 'Branzino al Forno', 'Branzino intero con patate e olive taggiasche', 22.00, ARRAY['pesce']::TEXT[], ARRAY[]::TEXT[], 3),
    (rest_id, cat_secondi, 'Saltimbocca alla Romana', 'Scaloppine di vitello con prosciutto e salvia', 20.00, ARRAY['latte']::TEXT[], ARRAY[]::TEXT[], 4),
    (rest_id, cat_secondi, 'Pollo alla Cacciatora', 'Pollo ruspante con pomodoro, olive e capperi', 18.00, ARRAY[]::TEXT[], ARRAY[]::TEXT[], 5),
    (rest_id, cat_secondi, 'Orata all''Acqua Pazza', 'Orata con pomodorini, capperi e olive', 22.00, ARRAY['pesce']::TEXT[], ARRAY[]::TEXT[], 6),
    (rest_id, cat_secondi, 'Cotoletta alla Milanese', 'Costoletta di vitello impanata con osso', 24.00, ARRAY['glutine', 'uova', 'latte']::TEXT[], ARRAY[]::TEXT[], 7)
    ON CONFLICT DO NOTHING;

    -- CONTORNI
    INSERT INTO menu_items (restaurant_id, category_id, name, description, price, allergens, tags, sort_order) VALUES
    (rest_id, cat_contorni, 'Patate al Forno', 'Patate arrosto con rosmarino', 5.00, ARRAY[]::TEXT[], ARRAY['vegetariano', 'vegano']::TEXT[], 1),
    (rest_id, cat_contorni, 'Verdure Grigliate', 'Zucchine, melanzane, peperoni alla griglia', 6.00, ARRAY[]::TEXT[], ARRAY['vegetariano', 'vegano']::TEXT[], 2),
    (rest_id, cat_contorni, 'Insalata Mista', 'Lattuga, pomodori, carote, mais', 5.00, ARRAY[]::TEXT[], ARRAY['vegetariano', 'vegano']::TEXT[], 3),
    (rest_id, cat_contorni, 'Spinaci Saltati', 'Spinaci freschi con aglio e peperoncino', 5.50, ARRAY[]::TEXT[], ARRAY['vegetariano', 'vegano', 'piccante']::TEXT[], 4),
    (rest_id, cat_contorni, 'Patatine Fritte', 'Patate fritte croccanti', 5.00, ARRAY[]::TEXT[], ARRAY['vegetariano', 'vegano']::TEXT[], 5)
    ON CONFLICT DO NOTHING;

    -- DOLCI
    INSERT INTO menu_items (restaurant_id, category_id, name, description, price, allergens, tags, sort_order) VALUES
    (rest_id, cat_dolci, 'Tiramisù', 'Classico tiramisù con mascarpone e caffè', 7.00, ARRAY['glutine', 'uova', 'latte']::TEXT[], ARRAY['chefs_choice']::TEXT[], 1),
    (rest_id, cat_dolci, 'Panna Cotta', 'Panna cotta con frutti di bosco', 6.50, ARRAY['latte']::TEXT[], ARRAY[]::TEXT[], 2),
    (rest_id, cat_dolci, 'Cannolo Siciliano', 'Cannolo con ricotta e gocce di cioccolato', 6.00, ARRAY['glutine', 'latte']::TEXT[], ARRAY[]::TEXT[], 3),
    (rest_id, cat_dolci, 'Torta al Cioccolato', 'Torta fondente con cuore morbido', 7.50, ARRAY['glutine', 'uova', 'latte']::TEXT[], ARRAY[]::TEXT[], 4),
    (rest_id, cat_dolci, 'Gelato Artigianale', 'Tre gusti a scelta', 5.50, ARRAY['latte']::TEXT[], ARRAY[]::TEXT[], 5),
    (rest_id, cat_dolci, 'Sorbetto al Limone', 'Sorbetto con limoni di Sorrento', 5.00, ARRAY[]::TEXT[], ARRAY['vegano']::TEXT[], 6)
    ON CONFLICT DO NOTHING;

    -- BEVANDE
    INSERT INTO menu_items (restaurant_id, category_id, name, description, price, allergens, tags, sort_order) VALUES
    (rest_id, cat_bevande, 'Acqua Naturale', 'Bottiglia 75cl', 3.00, ARRAY[]::TEXT[], ARRAY[]::TEXT[], 1),
    (rest_id, cat_bevande, 'Acqua Frizzante', 'Bottiglia 75cl', 3.00, ARRAY[]::TEXT[], ARRAY[]::TEXT[], 2),
    (rest_id, cat_bevande, 'Coca Cola', 'Bottiglia 33cl', 3.50, ARRAY[]::TEXT[], ARRAY[]::TEXT[], 3),
    (rest_id, cat_bevande, 'Fanta / Sprite', 'Bottiglia 33cl', 3.50, ARRAY[]::TEXT[], ARRAY[]::TEXT[], 4),
    (rest_id, cat_bevande, 'Birra Moretti', 'Bottiglia 33cl', 4.50, ARRAY['glutine']::TEXT[], ARRAY[]::TEXT[], 5),
    (rest_id, cat_bevande, 'Birra Peroni', 'Bottiglia 33cl', 4.50, ARRAY['glutine']::TEXT[], ARRAY[]::TEXT[], 6),
    (rest_id, cat_bevande, 'Vino Rosso della Casa', 'Calice', 5.00, ARRAY['solfiti']::TEXT[], ARRAY[]::TEXT[], 7),
    (rest_id, cat_bevande, 'Vino Bianco della Casa', 'Calice', 5.00, ARRAY['solfiti']::TEXT[], ARRAY[]::TEXT[], 8),
    (rest_id, cat_bevande, 'Prosecco', 'Calice', 6.00, ARRAY['solfiti']::TEXT[], ARRAY[]::TEXT[], 9),
    (rest_id, cat_bevande, 'Caffè Espresso', 'Caffè italiano', 1.50, ARRAY[]::TEXT[], ARRAY[]::TEXT[], 10),
    (rest_id, cat_bevande, 'Caffè Macchiato', 'Espresso con latte', 1.80, ARRAY['latte']::TEXT[], ARRAY[]::TEXT[], 11),
    (rest_id, cat_bevande, 'Amaro / Digestivo', 'A scelta', 4.00, ARRAY[]::TEXT[], ARRAY[]::TEXT[], 12)
    ON CONFLICT DO NOTHING;

END $$;

-- ============================================================================
-- UTENTE ADMIN DI ESEMPIO
-- ============================================================================
-- NOTA: Prima crea l'utente in Supabase Authentication con:
--   Email: admin@subitogusto.it
--   Password: Admin123!
-- Poi esegui questo INSERT con l'UUID generato da Supabase Auth

-- Per trovare l'UUID dell'utente appena creato:
-- SELECT id, email FROM auth.users WHERE email = 'admin@subitogusto.it';

-- Poi inserisci l'utente nella tabella users (sostituisci l'UUID):
-- INSERT INTO users (id, restaurant_id, email, role, first_name, last_name) VALUES (
--     'UUID-DELL-UTENTE-DA-AUTH',
--     'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',
--     'admin@subitogusto.it',
--     'admin',
--     'Admin',
--     'Marc'
-- );

-- ============================================================================
-- FUNZIONE: Crea utente staff dopo registrazione auth
-- ============================================================================

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.users (id, email, restaurant_id, role)
    VALUES (
        NEW.id,
        NEW.email,
        'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',  -- Restaurant ID di default
        'waiter'  -- Ruolo di default
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger per creare utente automaticamente
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();



  INSERT INTO users (id, restaurant_id, email, role, first_name, last_name)
  VALUES (
      '05b2eb90-bf80-4014-98d6-0959bf4f7fb9',
      'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',
      'admin@subitogusto.it',
      'admin',
      'Admin',
      'Marc'
  );