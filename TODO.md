# SubitoGusto - Marketplace & Delivery TODO

## Deployment Steps (Phase 5)

### Edge Functions to deploy
```bash
npx supabase functions deploy create-payment-intent --no-verify-jwt -- DONE
npx supabase functions deploy stripe-webhook --no-verify-jwt -- DONE 
npx supabase functions deploy stripe-connect-onboard --no-verify-jwt -- DONE
```

### Migration to run in Supabase SQL Editor
- `supabase/migrations/008_fix_rls_tenant_segregation.sql` — fixes RLS regression where staff could see menu items from all tenants  -- DONE


-------------------------------------------------------------------------------------------------------------------------------------- FROM HERE

### Supabase Secrets to set (Settings > Edge Functions > Secrets)
- `STRIPE_SECRET_KEY` — your Stripe secret key (`sk_test_...`)
- `STRIPE_WEBHOOK_SECRET` — from Stripe webhook endpoint setup (`whsec_...`)

### Flutter .env
- Replace `STRIPE_PUBLISHABLE_KEY=pk_test_REPLACE_WITH_YOUR_KEY` with your actual Stripe publishable key


---

## Completed Phases

### Phase 1: Database Schema + Auth Foundation
- [x] Migration `006_marketplace_delivery.sql` (customers, delivery_addresses, delivery_orders, delivery_order_items tables)
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

## Remaining Phases

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

## Testing Checklist (Phase 5 + 6)

### Phase 5 — Stripe Payments + Checkout
- [ ] **Redeploy `create-payment-intent`** edge function (has `menu_item_name` fix + removed `total_price`)
- [ ] Consumer: browse marketplace, add items to cart, open checkout
- [ ] Consumer (web): Stripe Payment Element loads, enter test card `4242 4242 4242 4242`, payment succeeds
- [ ] Consumer (mobile): Stripe PaymentSheet opens, test card works
- [ ] After payment: redirect to order confirmation page with correct order details
- [ ] Verify delivery_orders row created in Supabase with correct items, address, totals
- [ ] Verify delivery_order_items rows match cart contents (`menu_item_name` populated)
- [ ] Stripe webhook: payment_intent.succeeded updates `payment_status` to `paid` and `status` to `confirmed`
- [ ] Test payment failure: use card `4000 0000 0000 0002` — order stays `pending`, payment_status `failed`
- [ ] Stripe Connect: staff settings page shows Stripe status, onboarding button works (needs live Connect account)

### Phase 6 — Consumer Order Management
- [ ] Consumer: `/consumer/orders` shows active orders (realtime) + order history
- [ ] Consumer: tap order card -> order detail page with status timeline, items, price breakdown, address
- [ ] Consumer: status timeline updates in realtime as staff changes status
- [ ] Consumer: profile page shows name/email, edit display name + phone works
- [ ] Consumer: addresses page — add new address, edit, delete, set default
- [ ] Consumer: address set as default shows "Predefinito" badge

### Phase 6 — Staff Delivery Orders
- [ ] Staff (desktop): "Consegne" tab visible in orders page with active count badge
- [ ] Staff (desktop): delivery order cards show address, payment status, notes, total
- [ ] Staff (desktop): status flow works: Conferma -> Prepara -> Pronto -> In consegna -> Consegnato
- [ ] Staff (mobile): "Sala" / "Consegne" tabs, swipeable
- [ ] Staff (mobile): delivery order cards with same status transitions
- [ ] Staff: cancel delivery order (confirmation dialog) from pending/confirmed state
- [ ] Staff: completed orders appear in "Completati di recente" section
- [ ] Verify realtime: staff sees new delivery orders appear without refresh

### Known Issues / Polish (post-testing)
- [ ] Stripe Payment Element height on mobile — country dropdown can cover pay button
- [ ] Stripe "Salva le mie informazioni" overlay on desktop can cover pay button
- [ ] General UI/graphic bug pass across consumer + staff pages

---

### Phase 7: QR Flow Enhancement
- [ ] Modify `welcome_page.dart` — add "Accedi per salvare la cronologia ordini" link
- [ ] Login with `returnTo` query param to return to QR flow after auth
- [ ] Link dine-in orders to consumer profiles when logged in (optional `customer_id` on `orders` table)
