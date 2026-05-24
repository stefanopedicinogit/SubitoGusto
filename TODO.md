# SubitoGusto - Marketplace & Delivery TODO LIST

## Completed Phases

### Phase 1: Database Schema + Auth Foundation
- [x] Migrate schemas
- [x] Delivery columns on tenants table
- [x] RLS policies for consumer data
- [x] Fixed `handle_new_user` trigger for consumer signups
- [x] `is_consumer()` SQL helper function
- [x] Auth changes: UserType enum, isStaff/isConsumer detection in supabase_provider
- [x] Freezed models: Customer, DeliveryAddress, DeliveryOrder, DeliveryOrderItem

### Phase 2: Consumer Auth Pages + Navigation
- [x] Consumer login page (email/password + Google/Apple OAuth)
- [x] Consumer register page + `register-consumer` Edge Function
- [x] ConsumerShell with bottom navigation (Ristoranti, Ordini, Profilo)
- [x] Router updated with consumer routes and redirect logic

### Phase 3: Marketplace
- [x] Consumer providers (marketplace restaurants, restaurant menu/categories, customer profile, addresses, order history)
- [x] Marketplace page (restaurant list with delivery info)
- [x] Restaurant detail page (menu browsing by category, add to cart)
- [x] Delivery cart provider + cart sheet
- [x] Migration `007_grant_consumer_access.sql` (RLS fix for consumer browsing)

### Phase 4: Restaurant Delivery Settings (Staff Side)
- [x] Delivery settings section in settings_page.dart (desktop)
- [x] Delivery settings section in settings_page_mobile.dart (mobile)
- [x] Toggle, fee, radius, min order, estimated time inputs
- [x] Stripe Connect status indicator + onboarding button
- [x] Migration `008_fix_rls_tenant_segregation.sql` (RLS tenant segregation fix)

### Phase 5: Stripe Payments + Checkout
- [x] flutter_stripe added to pubspec.yaml
- [x] Stripe initialized in main.dart (mobile + web)
- [x] Stripe.js in web/index.html
- [x] Edge Function: create-payment-intent (PaymentIntent + delivery order creation)
- [x] Edge Function: stripe-webhook (payment success/failure handling)
- [x] Edge Function: stripe-connect-onboard (restaurant Stripe Connect setup)
- [x] Checkout page (order summary, address selection, Stripe PaymentSheet)
- [x] Order confirmation page (success screen with order details)
- [x] Routes wired up (/checkout, /order-confirmation/:orderId)
- [x] Cart sheet "Vai al pagamento" navigates to checkout

---

### Phase 6: Consumer Order Management
- [x] `consumer_orders_page.dart` — list of past/active delivery orders with status badges
- [x] `consumer_order_detail_page.dart` — single order detail with status timeline, items, address, total
- [x] `consumer_profile_page.dart` — fleshed out profile: edit display name, phone, manage addresses
- [x] `addresses_page.dart` — list/add/edit/delete delivery addresses with bottom sheet form
- [x] Route for `/consumer/orders/:orderId` (order detail)
- [x] Route for `/consumer/addresses` (address management)
- [x] Staff side: add delivery orders tab/filter to `orders_page.dart` and `orders_page_mobile.dart`
- [x] Staff side: delivery-specific status transitions (confirmed -> preparing -> out_for_delivery -> delivered)

---

### Phase 7: QR Flow Enhancement
- [x] `welcome_page.dart` — "Accedi per salvare la cronologia ordini" link, only when no consumer session, pre-encodes `?returnTo=/scan/<qrCode>`
- [x] `?returnTo=...` honored in: app.dart redirect logic, `consumer_login_page.dart` post-login navigation, `consumer_register_page.dart` post-register handoff, plus the cross-links between login ↔ register preserve the param
- [x] Dine-in orders link to consumer profile when signed in — `cart_sheet.dart` writes `customer_id` if `isConsumer && isAuthenticated`. The `orders.customer_id` column was already added by migration 006, so no new migration is needed.

---

### Phase 8: Polish quick wins
- [x] `cached_network_image` for restaurant covers & menu item images with mem/disk caps (540/800/288, sized for 3x DPR + 20%)
- [x] Long-cache + cache-bust on Supabase uploads (`Cache-Control: max-age=31536000` + `?v={ts}` so re-uploads invalidate)
- [x] Shimmer skeleton loaders (`lib/core/widgets/skeletons.dart`) wired into marketplace, restaurant detail, consumer orders, location prompt
- [x] Friendlier Italian error messages via `humanizeError()` (`lib/core/utils/error_messages.dart`) mapping AuthException / PostgrestException / StorageException / network errors — wired across consumer-facing surfaces
- [x] Optimistic favorites toggle (AsyncNotifier with rollback on failure); cart already pure local state

### Phase 9: Realtime status + push notifications
- [x] FCM (web-android) setup — `firebase_core` + `firebase_messaging`, VAPID key wired, service worker at `web/firebase-messaging-sw.js`
- [x] Server-side trigger on `delivery_orders` status change — Supabase Database Webhook → `send-order-push` Edge Function → FCM HTTP v1 API
- [x] `push_tokens` table + RLS + opt-in column on `customers` (migration 012)
- [x] Per-customer opt-in toggle in `consumer_profile_page.dart`
- [x] `activeDeliveryOrdersProvider` invalidated on foreground push so badges/lists refresh immediately
- [x] Foreground SnackBar (dismissable, "Vedi" deep-links to order detail)
- [x] Background OS notification + tap → navigate to order detail (verified on web)
- [ ] iOS — deferred (needs Apple Developer account + APNs key in Firebase)

---

### Phase 10: Marketplace discovery (filters + sort)
- [x] Migration 014: `cuisine_type` + `dietary_tags` columns on `tenants` + indexes
- [x] Curated option lists (IT-localized) in `marketplace_filters.dart` — cuisines + dietary tags
- [x] `MarketplaceFilters` state model + `marketplaceFiltersProvider` with **SharedPreferences persistence** (key `marketplace_filters_v1`)
- [x] `MarketplaceFilterSheet` — bottom-sheet UI with sort + cuisine + dietary + max delivery time + free-delivery toggle + reset
- [x] Marketplace page: "Filtri" button in AppBar with active-count badge; filters applied to `withDistance` pipeline; sort overrides default distance sort
- [x] Sort options wired: distance / delivery time / rating / price (delivery fee)
- [x] Staff settings UI (`DiscoverySettingsSection`) — cuisine picker + dietary chips, on both desktop + mobile settings pages

---

### Phase 11: Ratings & reviews
- [x] DB: `reviews` table (customer_id, target_type, target_id, rating 1-5, comment) + RLS (migration 013)
- [x] `review_aggregates` view (avg rating + count) per restaurant / item
- [x] RLS rule: INSERT/UPDATE allowed only when customer has a `delivered` order containing the target — server-enforced
- [x] Profanity + length guard via BEFORE trigger (IT + EN word list, max 500 chars)
- [x] Display stars on marketplace cards (`_AggregateBadge`), restaurant detail header (`_InfoChip` with ⭐), menu item cards (`RatingStars` under description)
- [x] Bulk aggregate providers — no N+1 (`allRestaurantAggregatesProvider`, `itemAggregatesForRestaurantProvider`)
- [x] Post-delivery rating prompt — `ReviewPromptDialog` triggered from foreground FCM push when status flips to `delivered`
- [x] Manual fallback — `_ReviewSection` on `consumer_order_detail_page` for delivered orders shows "Lascia recensione" button (or existing review + "Modifica")

### Phase 12: Promotions & discount codes
- [x] Migration 015: `promo_codes` + `promo_redemptions` tables + RLS (staff CRUD own tenant; customers cannot SELECT codes — anti-enumeration; customers see own redemptions)
- [x] Freezed models `PromoCode` + `PromoRedemption`
- [x] Edge function `validate-promo-code` — dry-run preview for "Applica" button on checkout
- [x] Edge function `create-payment-intent` extended: validates + applies discount, writes `promo_redemptions` row, bumps `uses_count`, persists `discount` + post-discount `total` on the delivery order
- [x] Checkout UI: code input + "Applica" button + discount line in totals + dynamic pay button label
- [x] Staff `PromoCodesPage` at `/promo-codes` — list with status badges (Attivo/Scaduto/Esaurito/Disattivato), bottom-sheet editor (create/edit/delete), entry tile in settings
- [x] **Deploy edge functions** — `validate-promo-code` and `create-payment-intent`

---

### Phase 13: Internationalization (i18n)
- [x] `flutter_localizations` + `generate: true` in pubspec, `l10n.yaml` config
- [x] `lib/l10n/app_it.arb` (template, 100+ keys) + `lib/l10n/app_en.arb` (full English mirror)
- [x] `lib/l10n/generated/app_localizations.dart` autogenerated (~200 string getters across both locales)
- [x] `localeProvider` (StateNotifier + SharedPreferences persistence under `app_locale_v1`)
- [x] `MaterialApp.router` wired with `locale`, `supportedLocales`, `localizationsDelegates`
- [x] `LanguageSwitcher` widget — globe icon + popup menu — reachable from **everywhere**: consumer login (top-right), staff login desktop (AppBar action), staff login mobile (top-right of form), staff settings (Lingua card), consumer profile (drop-down tile). Same SharedPreferences-only model as Just Eat / Glovo / Deliveroo — device-scoped, no DB sync.
- [x] Curated cuisine + dietary lists translated via `labelForCuisine(context, value)` / `labelForDietary(context, value)`
- [x] `MarketplaceSort` extension takes `BuildContext` and returns localized label
- [x] Central `localizedOrderStatus(context, status)` helper used across orders + confirmation
- [x] Migrated: consumer login + register, marketplace + filter sheet, restaurant detail (badges), cart sheet, checkout + order confirmation, consumer orders + order detail (status timeline + sections + review section), consumer profile, addresses page (title + empty state), favorites page, scan welcome page, review prompt dialog, rating-stars "Nuovo" placeholder, staff discovery settings (cuisine/dietary picker)
- [x] Staff-side translated:
  - Staff app shell (sidebar + topbar title — desktop) + mobile shell (bottom nav + drawer)
  - Staff login (desktop + mobile) + language switcher in AppBar
  - Staff register tenant page (title, all form labels, submit button, success message) + language switcher
  - Dashboard (desktop + mobile): KPI tiles (Active / Preparing / Ready / Pending), "Recent orders" section header + see-all button + empty state, status label uses localized helper
  - Orders page (desktop + mobile): tab labels (All / Pending / Preparing / Ready / Delivery / Dine-in), payment status (Paid / Awaiting payment)
  - Settings page section headers + Language card + Promo codes entry
  - Notifications panel (title, empty state, mark-all-read, clear-all)
  - Promo codes page (title, empty state, status badges, full editor sheet)
- [x] **All error messages localized** — `humanizeError(error, context)` returns IT/EN based on current locale across 14 call sites (auth, postgrest, storage, network, timeout). Falls back to Italian if context is null (e.g. background jobs).
- [x] **`LanguageSwitcher` widget available pre-auth** — globe icon on consumer login, staff login (desktop + mobile), register tenant page, plus dedicated card in staff settings + drop-down in consumer profile.
- [x] Staff secondary surfaces translated end-to-end:
  - Menu management page (desktop + mobile) — sidebar/grid headers, empty states, add buttons, availability badge, edit tooltip
  - Menu item dialog — full editor (Name, Category, Description, Price, Prep time, Calories, Image, Tags, Allergens, Available/Active switches, delete confirm, success toasts)
  - Tables page (desktop + mobile) — title, add button, empty, status pills (Free/Occupied/Reserved), delete confirmation dialog, action popup menu (Edit/Show QR/Delete)
  - Users page — title, add button, data column headers, delete confirmation, deactivate/activate confirmations, toast
  - Kitchen display — legend chips (Confirmed/Preparing/Ready), empty state, empty-items state
  - Manual order dialog — title, section titles (Select items, Order summary), table dropdown label, customer name field, empty cart state, notes field, total label, submit button (Creating.../Create Order)
  - Order detail dialog — title, next-action buttons (Confirm/Start preparing/Mark ready/Mark delivered), table loading state, empty items, total, cancel order dialog (Yes/No)
  - Fixed menu management — title, add button, empty state, create button
  - Analytics page — period filter, refresh tooltip, KPI cards (Completed orders/Avg ticket/Items sold), section titles (Revenue trend/Orders by status/Top items/Peak hours/By category)
  - Customer menu page (QR consumer flow) — subtitle, "All" / "Set menus" chips, empty menu and category states
  - Location prompt page — title
- [x] **All residual dialogs translated end-to-end (2026-05-23):**
  - `table_dialog.dart`, `category_dialog.dart`, `user_dialog.dart` — full forms (title, fields, validation, switches, delete confirm, success/error toasts via `humanizeError(e, context)`); status/role labels resolved through `_statusKeys`/`_roleKeys` arrays + per-context label helpers
  - `fixed_menu_dialog.dart` — name/description/price (+ validation), image URL, availability (Always/Lunch/Dinner), days (Mon–Sun via `_dayKeys` + `_dayLabel(context, key)` helper), active toggle, delete dialog with `{name}` placeholder
  - `fixed_menu_courses_dialog.dart` — full course-and-choices manager: title, add/edit course dialog (name/description/required toggle), choice picker with search, supplement & default checkbox, delete confirmations, all error snackbars
  - `fixed_menu_customer_card.dart` — availability badge (Lunch/Dinner) + "Choose your courses" CTA
  - `fixed_menu_selection_sheet.dart` — menu-not-found, required-courses warning, "Add to cart" with price placeholder, "Optional" badge, "Recommended" tag, "added to cart" toast with `{name}` placeholder
  - `edit_address_dialog.dart` — title, use-my-location flow (with permission/unavailable/reverse-fail messages), address field, format help, save/cancel
  - Settings page (desktop + mobile) — sections (Restaurant, Notifications, Orders Management, Delivery, Discovery, Promo codes, Language, Appearance, Account), all switches/subtitles, Stripe Connect status + onboarding dialog (with `{url}` placeholder), Geocoding warning (retry + set address + missing-coords hints), Change Password sheet (new/confirm fields, min-chars validator, mismatch error, success toast), Brand Colors editor (primary/secondary/background hints + Accent preview + Save Colors), Sign Out confirmation, app version line
- [ ] Edge-function copy (FCM push titles/bodies in `send-order-push`) — **deferred (intentional, 2026-05-24)**: 7 short status strings, IT-only product, and localizing would require breaking the Phase 13 device-scoped locale model (SharedPreferences-only, no DB sync — matches Just Eat / Glovo / Deliveroo). If revisited, store locale on `push_tokens` per-device, not on `customers`.

---