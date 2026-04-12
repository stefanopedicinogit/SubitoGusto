# Boutique Manager - Architettura del Progetto

## Indice
1. [Stack Tecnologico](#stack-tecnologico)
2. [Struttura delle Cartelle](#struttura-delle-cartelle)
4. [Architettura e Pattern](#architettura-e-pattern)
5. [Dipendenze](#dipendenze)
6. [Data Layer](#data-layer)
7. [State Management](#state-management)
8. [Navigazione](#navigazione)
9. [Design Responsivo](#design-responsivo)
10. [Autenticazione](#autenticazione)
11. [Features/Moduli](#featuresmoduli)
12. [Generazione Codice](#generazione-codice)
13. [Multi-tenancy](#multi-tenancy)


## Stack Tecnologico

| Categoria | Tecnologia | Versione |
|-----------|------------|----------|
| **Framework** | Flutter | SDK ^3.11.4 |
| **Linguaggio** | Dart | 3.x |
| **Backend** | Supabase | - |
| **Database Locale** | Drift (SQLite) | ^2.28.2 |
| **State Management** | Riverpod | ^2.5.1 |
| **Routing** | GoRouter | ^14.0.1 |
| **HTTP Client** | Dio | ^5.4.0 |
| **Modelli Dati** | Freezed + JsonSerializable | ^2.4.1 |

---

## Struttura delle Cartelle

```
lib/
├── main.dart                    # Entry point dell'applicazione
├── app.dart                     # Configurazione app, routing, tema
│
├── core/                        # Componenti core riutilizzabili
│   ├── theme/
│   │   └── app_theme.dart       # Palette colori, tipografia, ThemeData
│   │
│   ├── utils/
│   │   └── responsive.dart      # Breakpoints, DeviceType, utilities responsive
│   │
│   └── widgets/                 # Widget globali riutilizzabili
│       ├── app_shell.dart       # Shell desktop (Sidebar + Topbar + Content)
│       ├── app_shell_mobile.dart # Shell mobile (Drawer + AppBar + BottomNav)
│       ├── sidebar.dart         # Sidebar navigazione desktop
│       ├── topbar.dart          # Topbar desktop
│       ├── topbar_mobile.dart   # AppBar mobile
│       ├── mobile_drawer.dart   # Drawer navigazione mobile
│       ├── mobile_bottom_nav.dart # Bottom navigation mobile
│       ├── status_chip.dart     # Chip di stato riutilizzabile
│       ├── filter_bar.dart      # Barra filtri generica
│       └── form_dialog.dart     # Dialog form base
│
├── data/                        # Layer dati
│   ├── models/                  # Modelli dati (Freezed)
│   │   ├── models.dart        # + .freezed.dart + .g.dart
│   │   └── base_model.dart      # Interfaccia base comune
│   │
│   ├── repositories/
│   │   ├── supabase_repository.dart  # Repository generico Supabase
│   │   └── repositories.dart         # Export barrel
│   │
│   ├── providers/               # Riverpod providers
│   │   ├── supabase_provider.dart     # Auth provider, Supabase client
│   │   ├── supabase_repositories.dart # Repository providers per ogni entita
│   │   ├── database_provider.dart     # Provider database locale (Drift)
│   │   └── providers.dart             # Export barrel
│   │
│   ├── api/
│   │   └── supabase_auth_service.dart # Servizio autenticazione
│   │
│   └── database/
│       ├── database.dart        # Schema Drift
│       └── database.g.dart      # Generato
│
├── features/                    # Feature modules
│   ├── auth/
│   │   ├── login_page.dart
│   │   └── auth_state.dart
│   │
│   ├── feature/
│   │   ├── feature_page.dart         # Desktop
│   │   ├── feature_page_mobile.dart  # Mobile
│   │   ├── widgets/
│   │   │   ├── widgets.dart
│   │   └── widgets_mobile/
│   │       └── widgets_mobile.dart

│
└── assets/
    └── images/                  # Immagini e loghi
```

---

## Architettura e Pattern

### Pattern Architetturale: Feature-First + Repository Pattern

```
┌───────────────────────────────────────────────────────────────┐
│                         UI Layer                              │
│  ┌──────────────────┐  ┌─────────────────┐  ┌──────────────┐  │
│  │   Desktop Page   │  │   Mobile Page   │  │   Widgets    │  │
│  └────────┬─────────┘  └────────┬────────┘  └──────┬───────┘  │
└───────────┼─────────────────────┼───────────────────┼─────────┘
            │                     │                   │
            ▼                     ▼                   ▼
┌──────────────────────────────────────────────────────────────┐
│                    State Management Layer                    │
│  ┌─────────────────────────────────────────────────────────┐ │
│  │                   Riverpod Providers                    │ │
│  │  - FutureProvider (dati async)                          │ │
│  │  - StreamProvider (realtime)                            │ │
│  │  - Provider (repository instances)                      │ │
│  │  - StateNotifierProvider (stato mutabile)               │ │
│  └────────────────────────────┬────────────────────────────┘ │
└───────────────────────────────┼──────────────────────────────┘
                                │
                                ▼
┌───────────────────────────────────────────────────────────────┐
│                      Data Layer                               │
│  ┌──────────────────────┐  ┌───────────────────────────────┐  │
│  │  SupabaseRepository  │  │    Data Models (Freezed)      │  │
│  │   - getAll()         │  │  - Immutabili                 │  │
│  │   - getById()        │  │  - copyWith()                 │  │
│  │   - insert()         │  │  - fromJson() / toJson()      │  │
│  │   - update()         │  │  - Computed properties        │  │
│  │   - delete()         │  │                               │  │
│  │   - query()          │  │                               │  │
│  │   - watchAll()       │  │                               │  │
│  └──────────┬───────────┘  └───────────────────────────────┘  │
└─────────────┼─────────────────────────────────────────────────┘
              │
              ▼
┌──────────────────────────────────────────────────────────────┐
│                    Backend (Supabase)                        │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐  ┌─────────┐ │
│  │  PostgreSQL│  │    Auth    │  │  Realtime  │  │   RLS   │ │
│  └────────────┘  └────────────┘  └────────────┘  └─────────┘ │
└──────────────────────────────────────────────────────────────┘
```

### Principi Applicati

1. **Separation of Concerns**: UI, logica di stato e dati sono separati
2. **Single Responsibility**: Ogni classe/file ha una responsabilita specifica
3. **Dependency Injection**: Tramite Riverpod providers
4. **Immutability**: Modelli dati immutabili con Freezed
5. **DRY (Don't Repeat Yourself)**: Repository generico riutilizzabile

---

## Dipendenze

### Dipendenze di Produzione

#### Architettura e Navigazione
```yaml
go_router: ^14.0.1          # Routing dichiarativo con deep linking
flutter_riverpod: ^2.5.1    # State management e DI
```

#### UI e Design
```yaml
flutter_svg: ^2.0.9                    # Icone SVG
fl_chart: ^0.68.0                      # Grafici (bar, line, donut)
responsive_framework: ^1.2.0           # Layout responsivo
animations: ^2.0.8                     # Animazioni fluide
material_design_icons_flutter: ^7.0.7296  # Icone aggiuntive
table_calendar: ^3.0.9                 # Calendario appuntamenti
```

#### API e Serializzazione
```yaml
dio: ^5.4.0                  # HTTP client
json_annotation: ^4.9.0      # Annotazioni JSON
freezed_annotation: ^2.4.1   # Annotazioni Freezed
```

#### Database
```yaml
drift: ^2.28.2               # SQLite ORM
drift_flutter: ^0.2.7        # Flutter support per Drift
supabase_flutter: ^2.12.2    # Backend Supabase
```

#### Utilities
```yaml
intl: 0.20.2                 # Formattazione date/numeri
path: ^1.9.0                 # Gestione path
path_provider: ^2.1.1        # Directory sistema
jwt_decoder: ^2.0.1          # Decodifica JWT
flutter_dotenv: ^6.0.0       # Variabili ambiente
```

### Dipendenze di Sviluppo
```yaml
build_runner: ^2.4.8        # Code generation runner
json_serializable: ^6.8.0   # Generazione toJson/fromJson
freezed: ^2.4.1             # Generazione classi immutabili
flutter_lints: ^6.0.0       # Regole lint
drift_dev: ^2.28.0          # Generazione Drift
```

---

## Data Layer

### Repository Pattern

Il `SupabaseRepository<T>` e un repository generico che incapsula tutte le operazioni CRUD:

```dart
class SupabaseRepository<T> {
  final String tableName;
  final T Function(Map<String, dynamic>) fromJson;
  final Map<String, dynamic> Function(T) toJson;
  
  // Operazioni CRUD
  Future<List<T>> getAll({String? orderBy, bool ascending, int? limit});
  Future<T?> getById(String id);
  Future<T> insert(T item);
  Future<T> update(String id, T item);
  Future<void> delete(String id);
  
  // Query avanzate
  Future<List<T>> query({Map<String, dynamic>? equals, ...});
  Future<List<T>> search({required String column, required String searchTerm});
  Future<int> count({Map<String, dynamic>? filters});
  
  // Realtime
  Stream<List<T>> watchAll();
  
  // Batch operations
  Future<List<T>> insertMany(List<T> items);
  Future<void> deleteMany(List<String> ids);
  Future<T> upsert(T item, {String? onConflict});
}
```

### Modelli Dati (Freezed)

Ogni modello utilizza Freezed per:
- **Immutabilita**: Oggetti non modificabili dopo la creazione
- **copyWith()**: Creazione di copie modificate
- **Equality**: Confronto per valore automatico
- **Serializzazione**: JSON con JsonSerializable

Esempio struttura modello:
```dart
@freezed
class Model with _$Model {
  const Model._();  // Per metodi custom
  
  const factory Model({
    required String id,
    String? tenantId,
    required DateTime createdAt,
    DateTime? updatedAt,
    // ...
  }) = _Model;

  factory Model.fromJson(Map<String, dynamic> json) => 
      _$ModelFromJson(json);

  // Computed properties
  double get remainingAmount => totalAmount - paidAmount;
  bool get isPaid => remainingAmount <= 0;
}
```

## State Management

### Riverpod Providers

L'applicazione usa diversi tipi di providers:

#### 1. Repository Providers
```dart
// Provider per istanza repository
final supabaseCustomerRepositoryProvider = 
    Provider<SupabaseRepository<Customer>>((ref) {
  return SupabaseRepository<Customer>(
    tableName: 'customers',
    fromJson: (json) => Customer(...),
    toJson: (customer) => {...},
  );
});
```

#### 2. Data Providers
```dart
// FutureProvider per dati async
final supabaseCustomersProvider = FutureProvider<List<Customer>>((ref) async {
  ref.watch(supabaseAuthProvider);  // Ricarica su cambio auth
  final repo = ref.watch(supabaseCustomerRepositoryProvider);
  return repo.getAll(orderBy: 'last_name');
});

// StreamProvider per realtime
final supabaseCustomersStreamProvider = StreamProvider<List<Customer>>((ref) {
  final repo = ref.watch(supabaseCustomerRepositoryProvider);
  return repo.watchAll();
});
```

#### 3. Auth Provider
```dart
final supabaseAuthProvider = StreamProvider<AuthState>((ref) {
  return Supabase.instance.client.auth.onAuthStateChange.map((event) {
    return AuthState(
      isAuthenticated: event.session != null,
      user: event.session?.user,
    );
  });
});
```

### Pattern di Invalidazione

Dopo operazioni CRUD, i dati vengono ricaricati:
```dart
// Dopo insert/update/delete
ref.invalidate(supabaseCustomersProvider);
```

---

## Navigazione

### GoRouter Configuration

Routing dichiarativo con shell route per layout persistente:

```dart
GoRouter(
  initialLocation: '/login',
  redirect: (context, state) {
    // Redirect logic per auth
    if (!auth.isAuthenticated && !loggingIn) return '/login';
    if (auth.isAuthenticated && loggingIn) return '/';
    return null;
  },
  routes: [
    GoRoute(path: '/login', builder: (...) => LoginPage()),
    ShellRoute(
      builder: (...) => _AdaptiveShellWrapper(child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (...) => _AdaptivePage(
            desktop: DashboardPage(),
            mobile: DashboardPageMobile(),
          ),
        ),
        GoRoute(
          path: '/model',
          routes: [
            GoRoute(
              path: ':modelId',  // Nested route
              builder: (...) => _AdaptivePage(...),
            ),
          ],
        ),
        // ... altre routes
      ],
    ),
  ],
);
```

## Design Responsivo

### Breakpoints

```dart
class Breakpoints {
  static const double mobile = 600;   // < 600px
  static const double tablet = 1024;  // 600-1024px
  static const double desktop = 1440; // > 1024px
}
```

### Utilities Responsive

```dart
class Responsive {
  static DeviceType getDeviceType(BuildContext context);
  static bool isMobile(BuildContext context);
  static bool isTablet(BuildContext context);
  static bool isDesktop(BuildContext context);
  static bool useMobileLayout(BuildContext context);  // mobile + tablet
  
  static T value<T>(context, {required T mobile, T? tablet, required T desktop});
  static EdgeInsets padding(BuildContext context);
}
```

### Adaptive Layout Pattern

```dart
// Nel router
class _AdaptivePage extends StatelessWidget {
  final Widget desktop;
  final Widget mobile;

  @override
  Widget build(BuildContext context) {
    if (Responsive.useMobileLayout(context)) {
      return mobile;
    }
    return desktop;
  }
}

// Nell'app shell
class _AdaptiveShellWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Responsive.useMobileLayout(context)) {
      return AppShellMobile(child: child);
    }
    return AppShell(child: child);
  }
}
```

### Struttura Layout

**Desktop (AppShell)**:
```
┌─────────────────────────────────────────────┐
│ Sidebar │           Topbar                  │
│         ├───────────────────────────────────┤
│  Menu   │                                   │
│         │           Content                 │
│         │                                   │
│         │                                   │
└─────────┴───────────────────────────────────┘
```

**Mobile (AppShellMobile)**:
```
┌─────────────────────────────────────────────┐
│              AppBar + Drawer                │
├─────────────────────────────────────────────┤
│                                             │
│                 Content                     │
│                                             │
│                                             │
├─────────────────────────────────────────────┤
│            Bottom Navigation                │
└─────────────────────────────────────────────┘
```

---

## Autenticazione

### Flusso Auth con Supabase

```
┌─────────────┐      ┌──────────────┐      ┌────────────────┐
│  LoginPage  │ ───► │ Supabase Auth │ ───► │ Session/JWT   │
└─────────────┘      └──────────────┘      └────────────────┘
                              │
                              ▼
                     ┌────────────────┐
                     │  supabaseAuth  │
                     │    Provider    │
                     └────────┬───────┘
                              │
              ┌───────────────┼───────────────┐
              ▼               ▼               ▼
         ┌─────────┐    ┌──────────┐    ┌──────────┐
         │ Redirect │    │ Refresh  │    │ tenant_id│
         │ to /     │    │ Providers│    │ in RLS   │
         └─────────┘    └──────────┘    └──────────┘
```

### Protezione Routes

GoRouter redirect automatico basato su auth state:
```dart
redirect: (context, state) {
  final auth = ref.read(supabaseAuthProvider).valueOrNull;
  if (auth == null || !auth.isAuthenticated) {
    if (state.uri.path != '/login') return '/login';
  }
  return null;
}
```

---

## Features/Moduli

### Struttura Feature Module

Ogni feature segue la stessa struttura:
```
feature_name/
├── feature_page.dart           # Pagina desktop
├── feature_page_mobile.dart    # Pagina mobile
├── widgets/                    # Widget desktop
│   ├── feature_table.dart      # Tabella dati
│   ├── feature_form_dialog.dart # Form CRUD
│   └── widgets.dart            # Export barrel
└── widgets_mobile/             # Widget mobile
    ├── feature_list_item.dart  # Item lista
    ├── feature_form_sheet.dart # Bottom sheet form
    └── widgets_mobile.dart     # Export barrel
```

### Pattern CRUD UI

**Desktop**: Dialog + DataTable
**Mobile**: BottomSheet + ListView

```dart
// Desktop - Dialog
showDialog(
  context: context,
  builder: (context) => ProductFormDialog(product: product),
);

// Mobile - Bottom Sheet
showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  builder: (context) => ProductFormSheet(product: product),
);
```

---

### Design System

- **Cards**: Background bianco, border radius 12px, subtle border
- **Buttons**: Primary nero, secondary outlined
- **Inputs**: Filled con background grey50, border radius 8px
- **Spacing**: 8px grid system (8, 16, 24, 32)
- **Typography**: Material 3 text theme

---

## Generazione Codice

### Build Runner

Per generare i file `.freezed.dart` e `.g.dart`:

```bash
# Generazione singola
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (sviluppo)
flutter pub run build_runner watch --delete-conflicting-outputs
```

### File Generati

| Sorgente | Generati |
|----------|----------|
| `model.dart` | `model.freezed.dart`, `model.g.dart` |
| `database.dart` | `database.g.dart` |

---

## Multi-tenancy

### Architettura Multi-tenant

L'applicazione supporta multi-tenancy tramite:

1. **tenant_id in ogni tabella**: Ogni record appartiene a un tenant
2. **Row Level Security (RLS)**: Postgres filtra automaticamente per tenant
3. **Repository auto-filter**: Il repository aggiunge filtro tenant_id

```dart
Future<List<T>> getAll(...) async {
  final tenantId = await _getCurrentTenantId();
  
  PostgrestFilterBuilder query = _client.from(tableName).select();
  
  if (tenantId != null) {
    query = query.eq('tenant_id', tenantId);
  }
  // ...
}
```

### Tabella Users

```sql
users (
  id UUID PRIMARY KEY,
  tenant_id UUID NOT NULL,
  email TEXT,
  role TEXT,  -- 'admin' | 'employee'
  ...
)
```

---

## Convenzioni e Best Practices

### Naming Conventions

| Tipo | Convenzione | Esempio |
|------|-------------|---------|
| File | snake_case | `customer_form_dialog.dart` |
| Classi | PascalCase | `CustomerFormDialog` |
| Variabili | camelCase | `selectedCustomer` |
| Costanti | SCREAMING_SNAKE_CASE | `MAX_ITEMS` |
| Provider | camelCase + Provider | `supabaseCustomersProvider` |

### Organizzazione Import

```dart
// 1. Dart SDK
import 'dart:async';

// 2. Flutter
import 'package:flutter/material.dart';

// 3. Packages esterni
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// 4. Import locali (relativi)
import '../../data/models/customer.dart';
import '../../data/providers/supabase_repositories.dart';
import 'widgets/customer_table.dart';
```

### Widget Structure

```dart
class MyPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyPage> createState() => _MyPageState();
}

class _MyPageState extends ConsumerState<MyPage> {
  // 1. State variables
  String _searchQuery = '';
  
  // 2. Lifecycle methods
  @override
  void initState() { ... }
  
  @override
  void dispose() { ... }
  
  // 3. Business logic methods
  Future<void> _handleSave() async { ... }
  
  // 4. Build method
  @override
  Widget build(BuildContext context) {
    final dataAsync = ref.watch(myDataProvider);
    return dataAsync.when(
      loading: () => ...,
      error: (e, _) => ...,
      data: (data) => ...,
    );
  }
  
  // 5. Helper methods
  String _formatDate(DateTime date) { ... }
}

// 6. Private widgets (in fondo al file)
class _MyPrivateWidget extends StatelessWidget { ... }
```

---

## Comandi Utili

```bash
# Avvio app
flutter run

# Build runner
flutter pub run build_runner build --delete-conflicting-outputs

# Analisi codice
flutter analyze

# Test
flutter test

# Build release
flutter build apk --release
flutter build ios --release
flutter build web --release
flutter build windows --release
```
