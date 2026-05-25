import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2"
import Stripe from "https://esm.sh/stripe@14.14.0?target=deno"

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const stripeSecretKey = Deno.env.get('STRIPE_SECRET_KEY')
    const supabaseUrl = Deno.env.get('SUPABASE_URL')
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')

    if (!stripeSecretKey || !supabaseUrl || !supabaseServiceKey) {
      throw new Error('Server configuration error')
    }

    const stripe = new Stripe(stripeSecretKey, {
      apiVersion: '2023-10-16',
      httpClient: Stripe.createFetchHttpClient(),
    })

    // Authenticate the caller
    const authHeader = req.headers.get('Authorization')
    if (!authHeader) throw new Error('Missing authorization')

    // User-scoped client: enforces RLS as the caller. Used for inserts where
    // the customer must be authorized (e.g., delivery_orders).
    const supabase = createClient(supabaseUrl, supabaseServiceKey, {
      auth: { autoRefreshToken: false, persistSession: false },
      global: { headers: { Authorization: authHeader } },
    })

    // Service-role client: bypasses RLS. Required for operations that
    // customers must NOT be able to do via direct SQL — looking up promo
    // codes (no read policy → prevents enumeration), inserting redemptions,
    // and bumping uses_count.
    const supabaseAdmin = createClient(supabaseUrl, supabaseServiceKey, {
      auth: { autoRefreshToken: false, persistSession: false },
    })

    // Verify the user from the JWT
    const token = authHeader.replace('Bearer ', '')
    const { data: { user }, error: userError } =
        await supabaseAdmin.auth.getUser(token)

    if (userError || !user) throw new Error('Unauthorized')

    const {
      restaurantId,
      items,
      deliveryFee,
      subtotal,
      total,
      deliveryAddressId,
      addressSnapshot,
      notes,
      promoCode,  // optional, user-entered string
    } = await req.json()

    if (!restaurantId || !items?.length || !total) {
      throw new Error('Missing required fields')
    }

    // Get restaurant's Stripe Connect account
    const { data: tenant, error: tenantError } = await supabase
      .from('tenants')
      .select('stripe_account_id, name')
      .eq('id', restaurantId)
      .single()

    if (tenantError || !tenant) {
      throw new Error('Restaurant not found')
    }

    if (!tenant.stripe_account_id) {
      throw new Error('Restaurant has not set up payment processing')
    }

    // ========================================================================
    // Promo code validation (optional).
    // Discount applies to the subtotal only — delivery fee is not discounted.
    // Errors thrown here surface to the user as humanized messages.
    // ========================================================================
    let promoRow: any = null
    let discountAmount = 0
    if (promoCode && typeof promoCode === 'string' && promoCode.trim().length > 0) {
      const codeUpper = promoCode.trim().toUpperCase()
      // Use the service-role client so RLS doesn't hide the code from us.
      const { data: promo, error: promoErr } = await supabaseAdmin
        .from('promo_codes')
        .select('*')
        .eq('code', codeUpper)
        .maybeSingle()

      if (promoErr) throw promoErr
      if (!promo) throw new Error('Codice promozionale non valido')
      if (!promo.active) throw new Error('Codice promozionale disattivato')

      // Tenant scope: either global (NULL) or must match the order's restaurant.
      if (promo.tenant_id && promo.tenant_id !== restaurantId) {
        throw new Error('Codice non valido per questo ristorante')
      }

      const now = new Date()
      if (promo.valid_from && new Date(promo.valid_from) > now) {
        throw new Error('Codice promozionale non ancora attivo')
      }
      if (promo.valid_until && new Date(promo.valid_until) < now) {
        throw new Error('Codice promozionale scaduto')
      }

      if (promo.max_uses != null && promo.uses_count >= promo.max_uses) {
        throw new Error('Codice promozionale esaurito')
      }

      if (subtotal < promo.min_order) {
        throw new Error(
          `Ordine minimo € ${Number(promo.min_order).toFixed(2)} per usare questo codice`,
        )
      }

      // Per-customer limit — use admin client to count all redemptions
      // (the customer-scoped policy would also work, but admin is consistent
      // with the rest of the promo block).
      const { count: prevRedemptions } = await supabaseAdmin
        .from('promo_redemptions')
        .select('id', { count: 'exact', head: true })
        .eq('promo_code_id', promo.id)
        .eq('customer_id', user.id)

      if (prevRedemptions != null && prevRedemptions >= promo.per_customer_limit) {
        throw new Error('Hai già usato questo codice il numero massimo di volte')
      }

      // Compute discount on subtotal only.
      if (promo.type === 'percent') {
        discountAmount = Math.round(subtotal * Number(promo.value)) / 100
      } else {
        discountAmount = Number(promo.value)
      }
      // Never exceed the subtotal.
      discountAmount = Math.min(discountAmount, subtotal)
      // Round to 2 decimals.
      discountAmount = Math.round(discountAmount * 100) / 100

      promoRow = promo
    }

    // Final amount the customer actually pays.
    const finalTotal = Math.max(0, total - discountAmount)
    const amountInCents = Math.round(finalTotal * 100)

    // Calculate platform fee on the final amount (5%).
    const platformFeePercent = 5
    const platformFee = Math.round(amountInCents * platformFeePercent / 100)

    // Generate order number
    const orderNumber = `D-${Date.now().toString(36).toUpperCase()}`

    // Create PaymentIntent with destination charge. Card only.
    // PayPal pending Stripe Connect eligibility approval — see
    // https://docs.stripe.com/payments/paypal#connect.
    const paymentIntent = await stripe.paymentIntents.create({
      amount: amountInCents,
      currency: 'eur',
      payment_method_types: ['card'],
      application_fee_amount: platformFee,
      transfer_data: {
        destination: tenant.stripe_account_id,
      },
      metadata: {
        restaurant_id: restaurantId,
        customer_id: user.id,
        restaurant_name: tenant.name,
      },
    })

    // Create delivery order in pending state. `total` is the post-discount
    // amount the customer is actually charged, `discount` records what was
    // shaved off (lets the order detail page show "-€X" cleanly).
    const { data: order, error: orderError } = await supabase
      .from('delivery_orders')
      .insert({
        tenant_id: restaurantId,
        customer_id: user.id,
        order_number: orderNumber,
        status: 'pending',
        payment_status: 'pending',
        subtotal: subtotal,
        delivery_fee: deliveryFee,
        discount: discountAmount,
        total: finalTotal,
        delivery_street: addressSnapshot?.street,
        delivery_city: addressSnapshot?.city,
        delivery_postal_code: addressSnapshot?.postalCode,
        delivery_notes: addressSnapshot?.notes,
        delivery_latitude: addressSnapshot?.latitude,
        delivery_longitude: addressSnapshot?.longitude,
        stripe_payment_intent_id: paymentIntent.id,
        notes: notes || null,
      })
      .select()
      .single()

    if (orderError) {
      await stripe.paymentIntents.cancel(paymentIntent.id)
      throw new Error('Failed to create order: ' + orderError.message)
    }

    // Record the promo redemption + bump uses_count. We log failures rather
    // than rolling back because the order itself succeeded — analytics counts
    // are eventually consistent. UNIQUE(delivery_order_id) makes the insert
    // idempotent against accidental retries.
    if (promoRow && discountAmount > 0) {
      // Use admin client — customers don't have INSERT permission on
      // promo_redemptions (only staff own-tenant SELECT is granted) and they
      // can't UPDATE promo_codes either.
      const { error: redErr } = await supabaseAdmin.from('promo_redemptions').insert({
        promo_code_id: promoRow.id,
        customer_id: user.id,
        delivery_order_id: order.id,
        discount_amount: discountAmount,
      })
      if (redErr) {
        console.error('Failed to insert promo redemption:', redErr.message)
      } else {
        const { error: bumpErr } = await supabaseAdmin
          .from('promo_codes')
          .update({ uses_count: (promoRow.uses_count ?? 0) + 1 })
          .eq('id', promoRow.id)
        if (bumpErr) {
          console.error('Failed to bump uses_count:', bumpErr.message)
        }
      }
    }

    // Insert order items
    const orderItems = items.map((item: any) => ({
      delivery_order_id: order.id,
      menu_item_id: item.menuItemId,
      menu_item_name: item.name,
      quantity: item.quantity,
      unit_price: item.unitPrice,
      notes: item.notes || null,
    }))

    const { error: itemsError } = await supabase
      .from('delivery_order_items')
      .insert(orderItems)

    if (itemsError) {
      console.error('Failed to insert order items:', itemsError.message)
    }

    console.log('Payment intent created:', paymentIntent.id, 'Order:', order.id)

    return new Response(
      JSON.stringify({
        clientSecret: paymentIntent.client_secret,
        paymentIntentId: paymentIntent.id,
        orderId: order.id,
        discountAmount,
        finalTotal,
      }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )

  } catch (error) {
    console.error('Payment error:', error.message)
    return new Response(
      JSON.stringify({ error: error.message }),
      {
        status: 400,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      }
    )
  }
})
