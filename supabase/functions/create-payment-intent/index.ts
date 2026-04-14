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

    const supabase = createClient(supabaseUrl, supabaseServiceKey, {
      auth: { autoRefreshToken: false, persistSession: false },
      global: { headers: { Authorization: authHeader } },
    })

    // Verify the user from the JWT
    const token = authHeader.replace('Bearer ', '')
    const { data: { user }, error: userError } = await createClient(
      supabaseUrl, supabaseServiceKey,
      { auth: { autoRefreshToken: false, persistSession: false } }
    ).auth.getUser(token)

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

    // Calculate platform fee (e.g., 5%)
    const platformFeePercent = 5
    const platformFee = Math.round(total * platformFeePercent)

    // Amount in cents
    const amountInCents = Math.round(total * 100)

    // Generate order number
    const orderNumber = `D-${Date.now().toString(36).toUpperCase()}`

    // Create PaymentIntent with destination charge
    const paymentIntent = await stripe.paymentIntents.create({
      amount: amountInCents,
      currency: 'eur',
      automatic_payment_methods: { enabled: true },
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

    // Create delivery order in pending state
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
        total: total,
        delivery_street: addressSnapshot?.street,
        delivery_city: addressSnapshot?.city,
        delivery_postal_code: addressSnapshot?.postalCode,
        delivery_notes: addressSnapshot?.notes,
        stripe_payment_intent_id: paymentIntent.id,
        notes: notes || null,
      })
      .select()
      .single()

    if (orderError) {
      await stripe.paymentIntents.cancel(paymentIntent.id)
      throw new Error('Failed to create order: ' + orderError.message)
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
