# SubitoGusto

Un'elegante applicazione Flutter per la gestione ordini da tavolo tramite QR code. Design ispirato all'atmosfera raffinata dei ristoranti italiani.

---

## Indice

1. [Panoramica](#panoramica)
2. [Features](#features)
3. [Design System](#design-system)
4. [Entità del Progetto](#entità-del-progetto)
5. [Schema Database](#schema-database)
6. [Architettura](#architettura)
7. [Installazione](#installazione)
8. [Configurazione Supabase](#configurazione-supabase)

---

## Panoramica

**SubitoGusto** rivoluziona l'esperienza di ordinazione al ristorante:

- I clienti scansionano un QR code posizionato sul tavolo
- Visualizzano un menu elegante e interattivo
- Ordinano direttamente dal proprio smartphone
- Il personale riceve gli ordini in tempo reale

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│   📱 CLIENTE                        💻 STAFF                    │
│                                                                 │
│   ┌───────────┐                    ┌───────────────────────┐   │
│   │  Scan QR  │                    │  Dashboard Ordini     │   │
│   │     ↓     │                    │  (Realtime Updates)   │   │
│   │  Menu     │     ══════════►    ├───────────────────────┤   │
│   │     ↓     │      Supabase      │  Gestione Menu        │   │
│   │  Carrello │      Realtime      ├───────────────────────┤   │
│   │     ↓     │                    │  Gestione Tavoli      │   │
│   │  Ordine   │                    └───────────────────────┘   │
│   └───────────┘                                                 │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Features

### Per il Cliente (Mobile)

| Feature | Descrizione |
|---------|-------------|
| **QR Scan** | Scansione rapida per identificare il tavolo |
| **Menu Interattivo** | Navigazione per categorie con immagini HD |
| **Filtri Allergeni** | Visualizzazione allergeni e diete speciali |
| **Carrello Smart** | Modifica quantità, note speciali per ogni piatto |
| **Ordine Condiviso** | Più persone allo stesso tavolo possono ordinare |
| **Stato Realtime** | Notifica quando l'ordine è in preparazione/pronto |
| **Multilingua** | Supporto IT/EN/FR/DE |

### Per lo Staff (Desktop)

| Feature | Descrizione |
|---------|-------------|
| **Dashboard Live** | Ordini in arrivo con notifiche sonore |
| **Gestione Menu** | CRUD completo piatti, categorie, prezzi |
| **Gestione Tavoli** | Creazione tavoli e generazione QR codes |
| **Reportistica** | Statistiche vendite, piatti più ordinati |
| **Multi-tenant** | Supporto per catene di ristoranti |

---

## Design System

### Filosofia

Design **"Italian Elegance"**: calore, raffinatezza e semplicità. Ispirato all'atmosfera di una trattoria toscana moderna.

### Palette Colori

```
┌────────────────────────────────────────────────────────────────┐
│                                                                │
│   PRIMARY        SECONDARY      BACKGROUND     SURFACE         │
│   ┌────────┐     ┌────────┐     ┌────────┐     ┌────────┐     │
│   │████████│     │████████│     │████████│     │████████│     │
│   │████████│     │████████│     │████████│     │████████│     │
│   └────────┘     └────────┘     └────────┘     └────────┘     │
│   Burgundy       Gold           Cream          White           │
│   #722F37        #D4AF37        #FDF5E6        #FFFFFF         │
│                                                                │
│   TEXT           SUCCESS        WARNING        ERROR           │
│   ┌────────┐     ┌────────┐     ┌────────┐     ┌────────┐     │
│   │████████│     │████████│     │████████│     │████████│     │
│   │████████│     │████████│     │████████│     │████████│     │
│   └────────┘     └────────┘     └────────┘     └────────┘     │
│   Charcoal       Sage           Amber          Terracotta      │
│   #36454F        #8B9A6B        #FFBF00        #C04000         │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

### Tipografia

| Uso | Font | Peso |
|-----|------|------|
| Titoli | Playfair Display | Bold |
| Sottotitoli | Lato | SemiBold |
| Body | Lato | Regular |
| Prezzi | Lato | Bold |

### Componenti UI

- **Cards**: Sfondo bianco, ombra soft, border-radius 16px
- **Bottoni Primary**: Burgundy con hover gold
- **Bottoni Secondary**: Outlined con bordo burgundy
- **Input**: Filled con sfondo cream, focus border gold
- **Chips**: Bordi arrotondati, colori semantici per allergeni

### Animazioni

- Page transitions: Fade + Slide (300ms)
- Card hover: Scale 1.02 + Shadow elevation
- Add to cart: Bounce + Particle effect
- Order status: Pulse animation

---

## Entità del Progetto

### Restaurant (Ristorante)

Configurazione del ristorante. Supporta multi-tenancy per catene.

```dart
@freezed
class Restaurant with _$Restaurant {
  const factory Restaurant({
    required String id,
    required String name,
    String? description,
    String? logoUrl,
    String? coverImageUrl,
    String? address,
    String? phone,
    String? email,
    Map<String, dynamic>? openingHours,  // {"mon": "12:00-23:00", ...}
    Map<String, dynamic>? settings,       // Configurazioni varie
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _Restaurant;
}
```

| Campo | Tipo | Descrizione |
|-------|------|-------------|
| `id` | UUID | Identificativo univoco |
| `name` | String | Nome del ristorante |
| `description` | String? | Descrizione/motto |
| `logoUrl` | String? | URL logo |
| `coverImageUrl` | String? | Immagine di copertina |
| `address` | String? | Indirizzo completo |
| `phone` | String? | Telefono |
| `email` | String? | Email contatto |
| `openingHours` | JSON | Orari di apertura |
| `settings` | JSON | Configurazioni (valuta, lingua default, etc.) |

---

### Category (Categoria Menu)

Categorie per organizzare il menu (Antipasti, Primi, Secondi, etc.)

```dart
@freezed
class Category with _$Category {
  const factory Category({
    required String id,
    required String restaurantId,
    required String name,
    String? description,
    String? imageUrl,
    required int sortOrder,
    @Default(true) bool isActive,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _Category;
}
```

| Campo | Tipo | Descrizione |
|-------|------|-------------|
| `id` | UUID | Identificativo univoco |
| `restaurantId` | UUID | FK al ristorante |
| `name` | String | Nome categoria (es. "Primi Piatti") |
| `description` | String? | Descrizione opzionale |
| `imageUrl` | String? | Immagine categoria |
| `sortOrder` | int | Ordine di visualizzazione |
| `isActive` | bool | Visibile nel menu cliente |

---

### MenuItem (Piatto/Bevanda)

Singolo elemento del menu con tutte le informazioni.

```dart
@freezed
class MenuItem with _$MenuItem {
  const factory MenuItem({
    required String id,
    required String restaurantId,
    required String categoryId,
    required String name,
    String? description,
    required double price,
    String? imageUrl,
    @Default([]) List<String> allergens,     // ["glutine", "lattosio", ...]
    @Default([]) List<String> tags,          // ["vegano", "piccante", "chef's choice"]
    @Default(true) bool isAvailable,
    @Default(true) bool isActive,
    int? preparationTime,                    // Minuti stimati
    int? calories,
    required int sortOrder,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _MenuItem;
}
```

| Campo | Tipo | Descrizione |
|-------|------|-------------|
| `id` | UUID | Identificativo univoco |
| `restaurantId` | UUID | FK al ristorante |
| `categoryId` | UUID | FK alla categoria |
| `name` | String | Nome piatto |
| `description` | String? | Descrizione e ingredienti |
| `price` | double | Prezzo in EUR |
| `imageUrl` | String? | Foto del piatto |
| `allergens` | List<String> | Lista allergeni |
| `tags` | List<String> | Tag speciali (vegano, bio, etc.) |
| `isAvailable` | bool | Disponibile oggi |
| `isActive` | bool | Attivo nel menu |
| `preparationTime` | int? | Tempo preparazione (min) |
| `calories` | int? | Kcal (opzionale) |
| `sortOrder` | int | Ordine nella categoria |

**Allergeni Supportati:**
- Glutine, Crostacei, Uova, Pesce, Arachidi, Soia
- Latte, Frutta a guscio, Sedano, Senape, Sesamo
- Anidride solforosa, Lupini, Molluschi

---

### Table (Tavolo)

Tavoli del ristorante con QR code univoco.

```dart
@freezed
class Table with _$Table {
  const factory Table({
    required String id,
    required String restaurantId,
    required String name,                    // "Tavolo 1", "Terrazza A3"
    required String qrCode,                  // Codice univoco per QR
    @Default(4) int capacity,                // Posti a sedere
    String? zone,                            // "Interno", "Terrazza", "Giardino"
    @Default('available') String status,     // available, occupied, reserved
    @Default(true) bool isActive,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _Table;
}
```

| Campo | Tipo | Descrizione |
|-------|------|-------------|
| `id` | UUID | Identificativo univoco |
| `restaurantId` | UUID | FK al ristorante |
| `name` | String | Nome/numero tavolo |
| `qrCode` | String | Codice univoco per generare QR |
| `capacity` | int | Numero posti |
| `zone` | String? | Zona del ristorante |
| `status` | String | Stato: available/occupied/reserved |
| `isActive` | bool | Tavolo attivo |

**Stati Tavolo:**
- `available`: Libero
- `occupied`: Occupato con ordine attivo
- `reserved`: Prenotato

---

### Order (Ordine)

Ordine effettuato da un tavolo.

```dart
@freezed
class Order with _$Order {
  const factory Order({
    required String id,
    required String restaurantId,
    required String tableId,
    required String orderNumber,             // "ORD-2024-001234"
    required String status,                  // pending, confirmed, preparing, ready, served, paid
    required double subtotal,
    @Default(0) double discount,
    required double total,
    String? notes,                           // Note generali ordine
    String? customerName,                    // Nome opzionale cliente
    required DateTime createdAt,
    DateTime? updatedAt,
    DateTime? confirmedAt,
    DateTime? completedAt,
  }) = _Order;
  
  const Order._();
  
  // Computed properties
  bool get isPending => status == 'pending';
  bool get isActive => ['pending', 'confirmed', 'preparing', 'ready'].contains(status);
}
```

| Campo | Tipo | Descrizione |
|-------|------|-------------|
| `id` | UUID | Identificativo univoco |
| `restaurantId` | UUID | FK al ristorante |
| `tableId` | UUID | FK al tavolo |
| `orderNumber` | String | Numero ordine leggibile |
| `status` | String | Stato dell'ordine |
| `subtotal` | double | Totale senza sconti |
| `discount` | double | Sconto applicato |
| `total` | double | Totale finale |
| `notes` | String? | Note dell'ordine |
| `customerName` | String? | Nome cliente (opzionale) |
| `confirmedAt` | DateTime? | Quando confermato |
| `completedAt` | DateTime? | Quando completato |

**Stati Ordine:**
```
┌─────────┐    ┌───────────┐    ┌───────────┐    ┌───────┐    ┌────────┐    ┌──────┐
│ PENDING │ -> │ CONFIRMED │ -> │ PREPARING │ -> │ READY │ -> │ SERVED │ -> │ PAID │
└─────────┘    └───────────┘    └───────────┘    └───────┘    └────────┘    └──────┘
  Cliente        Staff            Cucina          Cucina        Sala         Cassa
  ordina         conferma         prepara         pronto        servito      pagato
```

---

### OrderItem (Riga Ordine)

Singola riga di un ordine.

```dart
@freezed
class OrderItem with _$OrderItem {
  const factory OrderItem({
    required String id,
    required String orderId,
    required String menuItemId,
    required String menuItemName,            // Snapshot nome al momento ordine
    required double unitPrice,               // Snapshot prezzo al momento ordine
    required int quantity,
    String? notes,                           // "Senza cipolla", "Ben cotto"
    @Default('pending') String status,       // pending, preparing, ready, served
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _OrderItem;
  
  const OrderItem._();
  
  double get totalPrice => unitPrice * quantity;
}
```

| Campo | Tipo | Descrizione |
|-------|------|-------------|
| `id` | UUID | Identificativo univoco |
| `orderId` | UUID | FK all'ordine |
| `menuItemId` | UUID | FK al piatto |
| `menuItemName` | String | Nome piatto (snapshot) |
| `unitPrice` | double | Prezzo unitario (snapshot) |
| `quantity` | int | Quantità ordinata |
| `notes` | String? | Note specifiche piatto |
| `status` | String | Stato preparazione |

---

### User (Utente Staff)

Utenti dello staff per accesso al pannello di gestione.

```dart
@freezed
class User with _$User {
  const factory User({
    required String id,
    required String restaurantId,
    required String email,
    required String role,                    // admin, manager, waiter, kitchen
    String? firstName,
    String? lastName,
    String? avatarUrl,
    @Default(true) bool isActive,
    required DateTime createdAt,
    DateTime? updatedAt,
    DateTime? lastLoginAt,
  }) = _User;
  
  const User._();
  
  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();
  bool get isAdmin => role == 'admin';
}
```

| Campo | Tipo | Descrizione |
|-------|------|-------------|
| `id` | UUID | Auth user ID (Supabase) |
| `restaurantId` | UUID | FK al ristorante |
| `email` | String | Email login |
| `role` | String | Ruolo utente |
| `firstName` | String? | Nome |
| `lastName` | String? | Cognome |
| `avatarUrl` | String? | Avatar |
| `isActive` | bool | Account attivo |
| `lastLoginAt` | DateTime? | Ultimo accesso |

**Ruoli:**
- `admin`: Accesso completo, gestione utenti
- `manager`: Gestione menu, tavoli, reportistica
- `waiter`: Visualizzazione ordini, cambio stato
- `kitchen`: Solo visualizzazione ordini cucina

---

## Schema Database

### Diagramma ER

```
┌──────────────┐       ┌──────────────┐       ┌──────────────┐
│  RESTAURANT  │       │   CATEGORY   │       │  MENU_ITEM   │
├──────────────┤       ├──────────────┤       ├──────────────┤
│ id           │──┐    │ id           │──┐    │ id           │
│ name         │  │    │ restaurant_id│◄─┤    │ restaurant_id│
│ description  │  │    │ name         │  │    │ category_id  │◄──┘
│ logo_url     │  │    │ description  │  │    │ name         │
│ ...          │  │    │ image_url    │  │    │ price        │
└──────────────┘  │    │ sort_order   │  │    │ allergens    │
                  │    │ is_active    │  │    │ tags         │
                  │    └──────────────┘  │    │ is_available │
                  │                      │    └──────────────┘
                  │    ┌──────────────┐  │
                  │    │    TABLE     │  │    ┌──────────────┐
                  │    ├──────────────┤  │    │    ORDER     │
                  ├───►│ id           │  │    ├──────────────┤
                  │    │ restaurant_id│◄─┤    │ id           │
                  │    │ name         │  ├───►│ restaurant_id│
                  │    │ qr_code      │  │    │ table_id     │◄──┐
                  │    │ capacity     │──┼────│ order_number │   │
                  │    │ status       │  │    │ status       │   │
                  │    └──────────────┘  │    │ total        │   │
                  │                      │    └──────────────┘   │
                  │    ┌──────────────┐  │           │           │
                  │    │    USER      │  │           │           │
                  │    ├──────────────┤  │           ▼           │
                  └───►│ id           │  │    ┌──────────────┐   │
                       │ restaurant_id│◄─┘    │  ORDER_ITEM  │   │
                       │ email        │       ├──────────────┤   │
                       │ role         │       │ id           │   │
                       │ first_name   │       │ order_id     │◄──┘
                       │ last_name    │       │ menu_item_id │
                       └──────────────┘       │ quantity     │
                                              │ unit_price   │
                                              │ notes        │
                                              └──────────────┘
```

### SQL Schema

```sql
-- Restaurants
CREATE TABLE restaurants (
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

-- Categories
CREATE TABLE categories (
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

-- Menu Items
CREATE TABLE menu_items (
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

-- Tables
CREATE TABLE tables (
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

-- Orders
CREATE TABLE orders (
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

-- Order Items
CREATE TABLE order_items (
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

-- Users (extends Supabase auth.users)
CREATE TABLE users (
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

-- Indexes
CREATE INDEX idx_categories_restaurant ON categories(restaurant_id);
CREATE INDEX idx_menu_items_restaurant ON menu_items(restaurant_id);
CREATE INDEX idx_menu_items_category ON menu_items(category_id);
CREATE INDEX idx_tables_restaurant ON tables(restaurant_id);
CREATE INDEX idx_tables_qr_code ON tables(qr_code);
CREATE INDEX idx_orders_restaurant ON orders(restaurant_id);
CREATE INDEX idx_orders_table ON orders(table_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_users_restaurant ON users(restaurant_id);
```

---

## Architettura

Vedi `architettura.md` per i dettagli completi.

### Struttura Cartelle

```
lib/
├── main.dart
├── app.dart
│
├── core/
│   ├── theme/
│   │   └── app_theme.dart
│   ├── utils/
│   │   ├── responsive.dart
│   │   └── constants.dart
│   └── widgets/
│       ├── app_shell.dart
│       ├── app_shell_mobile.dart
│       └── ...
│
├── data/
│   ├── models/
│   │   ├── restaurant.dart
│   │   ├── category.dart
│   │   ├── menu_item.dart
│   │   ├── table.dart
│   │   ├── order.dart
│   │   ├── order_item.dart
│   │   ├── user.dart
│   │   └── models.dart
│   ├── repositories/
│   │   └── supabase_repository.dart
│   └── providers/
│       ├── supabase_provider.dart
│       └── providers.dart
│
└── features/
    ├── auth/
    │   ├── login_page.dart
    │   └── login_page_mobile.dart
    │
    ├── menu/                        # Cliente: visualizzazione menu
    │   ├── menu_page_mobile.dart
    │   └── widgets_mobile/
    │
    ├── cart/                        # Cliente: carrello
    │   ├── cart_page_mobile.dart
    │   └── widgets_mobile/
    │
    ├── order_status/                # Cliente: stato ordine
    │   ├── order_status_page_mobile.dart
    │   └── widgets_mobile/
    │
    ├── dashboard/                   # Staff: dashboard ordini
    │   ├── dashboard_page.dart
    │   ├── dashboard_page_mobile.dart
    │   └── widgets/
    │
    ├── menu_management/             # Staff: gestione menu
    │   ├── menu_management_page.dart
    │   └── widgets/
    │
    ├── tables_management/           # Staff: gestione tavoli
    │   ├── tables_management_page.dart
    │   └── widgets/
    │
    └── reports/                     # Staff: reportistica
        ├── reports_page.dart
        └── widgets/
```

---

## Installazione

### Prerequisiti

- Flutter SDK 3.11.4+
- Dart 3.x
- Account Supabase
- IDE (VS Code / Android Studio)

### Setup

```bash
# 1. Clona il repository
git clone https://github.com/your-repo/subito-gusto.git
cd subito-gusto

# 2. Installa dipendenze
flutter pub get

# 3. Crea file .env
cp .env.example .env
# Modifica .env con le tue credenziali Supabase

# 4. Genera codice (Freezed, etc.)
flutter pub run build_runner build --delete-conflicting-outputs

# 5. Avvia l'app
flutter run
```

### File .env

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
```

---

## Configurazione Supabase

### 1. Crea Progetto

1. Vai su [supabase.com](https://supabase.com)
2. Crea un nuovo progetto
3. Copia URL e anon key nel file `.env`

### 2. Esegui Migrations

Esegui lo schema SQL nel SQL Editor di Supabase.

### 3. Configura RLS

```sql
-- Enable RLS
ALTER TABLE restaurants ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE menu_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE tables ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Policy esempio: staff vede solo il proprio ristorante
CREATE POLICY "Users can view own restaurant" ON restaurants
    FOR SELECT USING (
        id IN (SELECT restaurant_id FROM users WHERE id = auth.uid())
    );

-- Policy: clienti possono leggere menu attivi
CREATE POLICY "Public can view active menu" ON menu_items
    FOR SELECT USING (is_active = true AND is_available = true);

-- Policy: clienti possono creare ordini
CREATE POLICY "Public can create orders" ON orders
    FOR INSERT WITH CHECK (true);
```

### 4. Abilita Realtime

Nel pannello Supabase:
1. Database → Replication
2. Abilita realtime per: `orders`, `order_items`

---

## Licenza

MIT License - Vedi [LICENSE](LICENSE) per dettagli.

---

**SubitoGusto** - *L'eleganza dell'ordinazione digitale*
