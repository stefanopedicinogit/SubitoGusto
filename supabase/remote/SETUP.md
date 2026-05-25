# SubitoGusto — Backend Setup (First Project Start)

This folder is the **authoritative, complete snapshot of the production backend**.
Use it to stand up a brand-new Supabase project from zero.

Why this folder exists: the live database contains objects that were created
directly in the SQL editor / dashboard and were never captured in the
`../migrations/` history (e.g. `rls_auto_enable`, `get_table_by_qr`, several
`SECURITY DEFINER` helpers, the push **webhook**, and all **Storage** config).
`schema.sql` + `storage.sql` here ARE complete and reproduce the real DB.
Treat the `../migrations/` files as historical reference only.

## Contents

| File | What it creates |
|------|-----------------|
| `schema.sql` | All tables, constraints, indexes, helper functions, triggers, RLS policies, realtime publication, grants |
| `storage.sql` | The `tenant-assets` bucket + its storage RLS policies |
| `SETUP.md` | This guide |

> The edge functions live in `../functions/` (verified identical to what is
> deployed in production). They are deployed in Step 4 below.

---

## Step 0 — Prerequisites

- A [Supabase](https://supabase.com) account + a new (empty) project
- [Supabase CLI](https://supabase.com/docs/guides/cli) (`npm i -g supabase` or `npx supabase`)
- A [Stripe](https://stripe.com) account (Connect enabled) for payments
- A [Firebase](https://firebase.google.com) project for push notifications (FCM HTTP v1)

Note your new project's **ref** (e.g. `abcdxyz...`) and the keys from
**Project Settings → API**: the `anon` key and the `service_role` key.

---

## Step 1 — Create the database schema

In the new project: **SQL Editor → New query**, paste the entire contents of
`schema.sql`, and run it. This creates every table, function, trigger, RLS
policy, and grant.

> The push webhook trigger inside `schema.sql` is **redacted** — it has
> placeholders `<YOUR_PROJECT_REF>` and `<YOUR_SERVICE_ROLE_JWT>`. Leave it as
> the placeholder for now; you'll recreate the webhook properly in Step 6.

## Step 2 — Create storage

In the SQL Editor, run the entire contents of `storage.sql`. This creates the
public `tenant-assets` bucket and the upload/update/read policies.

## Step 3 — Link the CLI to your project

```bash
supabase login
supabase link --project-ref <YOUR_PROJECT_REF>
```

## Step 4 — Deploy the edge functions

From the repo root:

```bash
supabase functions deploy --project-ref <YOUR_PROJECT_REF>
```

This deploys all 9 functions:
`create-payment-intent`, `delete-user`, `register-consumer`, `register-tenant`,
`send-order-push`, `stripe-connect-onboard`, `stripe-webhook`,
`upload-menu-image`, `validate-promo-code`.

## Step 5 — Set edge function secrets

`SUPABASE_URL`, `SUPABASE_ANON_KEY`, and `SUPABASE_SERVICE_ROLE_KEY` are
**injected automatically** by Supabase — do NOT set them.

You only need to provide these three:

```bash
supabase secrets set STRIPE_SECRET_KEY="sk_live_or_test_..." --project-ref <YOUR_PROJECT_REF>
supabase secrets set STRIPE_WEBHOOK_SECRET="whsec_..."        --project-ref <YOUR_PROJECT_REF>
supabase secrets set FCM_SERVICE_ACCOUNT_JSON='{...firebase service account json...}' --project-ref <YOUR_PROJECT_REF>
```

| Secret | Used by | Where to get it |
|--------|---------|-----------------|
| `STRIPE_SECRET_KEY` | create-payment-intent, stripe-connect-onboard, stripe-webhook | Stripe Dashboard → Developers → API keys |
| `STRIPE_WEBHOOK_SECRET` | stripe-webhook | Stripe Dashboard → Developers → Webhooks (signing secret) |
| `FCM_SERVICE_ACCOUNT_JSON` | send-order-push | Firebase Console → Project settings → Service accounts → Generate private key (paste the whole JSON) |

## Step 6 — Recreate the push webhook

The order-status push notification is driven by a database webhook on the
`delivery_orders` table (it was redacted out of `schema.sql` because it
embedded a service-role key).

**Dashboard → Database → Webhooks → Create a new hook:**

- **Table:** `delivery_orders`
- **Events:** `UPDATE`
- **Type:** HTTP Request → `POST`
- **URL:** `https://<YOUR_PROJECT_REF>.supabase.co/functions/v1/send-order-push`
- **HTTP Headers:**
  - `Content-type: application/json`
  - `Authorization: Bearer <YOUR_SERVICE_ROLE_JWT>`  ← your own service_role key
- **Timeout:** `5000` ms

## Step 7 — Configure Auth

- **Authentication → Providers:** enable **Email**.
- **Authentication → URL Configuration:** add your app's redirect URLs
  (web origin and/or the mobile deep-link scheme).
- The DB trigger `handle_new_user` auto-creates a staff `users` row for new
  staff signups. **Heads-up:** it hardcodes a default tenant id
  (`a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11`). Review/replace this for your own
  tenant onboarding flow.

## Step 8 — Point the Flutter app at the new project

In the app config (Supabase `url` + `anonKey` passed to `Supabase.initialize`),
replace with the new project's URL and **anon** key. Rebuild the app.

---

## Post-setup smoke test

1. Register a staff account → confirm a row appears in `public.users`.
2. Create a tenant, a category, and a menu item with an image →
   confirm the file lands in `tenant-assets/<tenant_id>/...`.
3. Place a delivery order → confirm `create-payment-intent` succeeds and the
   `stripe-webhook` marks it paid.
4. Change an order status → confirm the webhook fires `send-order-push`.
