import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2"
import Stripe from "https://esm.sh/stripe@14.14.0?target=deno"

serve(async (req) => {
  try {
    const stripeSecretKey = Deno.env.get('STRIPE_SECRET_KEY')
    const stripeWebhookSecret = Deno.env.get('STRIPE_WEBHOOK_SECRET')
    const supabaseUrl = Deno.env.get('SUPABASE_URL')
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')

    if (!stripeSecretKey || !stripeWebhookSecret || !supabaseUrl || !supabaseServiceKey) {
      throw new Error('Server configuration error')
    }

    const stripe = new Stripe(stripeSecretKey, {
      apiVersion: '2023-10-16',
      httpClient: Stripe.createFetchHttpClient(),
    })

    const supabase = createClient(supabaseUrl, supabaseServiceKey, {
      auth: { autoRefreshToken: false, persistSession: false },
    })

    // Verify webhook signature
    const body = await req.text()
    const signature = req.headers.get('stripe-signature')

    if (!signature) throw new Error('Missing stripe-signature header')

    const event = stripe.webhooks.constructEvent(body, signature, stripeWebhookSecret)

    console.log('Webhook event:', event.type, event.id)

    switch (event.type) {
      case 'payment_intent.succeeded': {
        const paymentIntent = event.data.object as Stripe.PaymentIntent

        const { error } = await supabase
          .from('delivery_orders')
          .update({
            payment_status: 'paid',
            status: 'confirmed',
            stripe_payment_intent_id: paymentIntent.id,
          })
          .eq('stripe_payment_intent_id', paymentIntent.id)

        if (error) {
          console.error('Failed to update order on payment success:', error.message)
        } else {
          console.log('Order confirmed for payment:', paymentIntent.id)
        }
        break
      }

      case 'payment_intent.payment_failed': {
        const paymentIntent = event.data.object as Stripe.PaymentIntent

        const { error } = await supabase
          .from('delivery_orders')
          .update({
            payment_status: 'failed',
            status: 'cancelled',
          })
          .eq('stripe_payment_intent_id', paymentIntent.id)

        if (error) {
          console.error('Failed to update order on payment failure:', error.message)
        } else {
          console.log('Order cancelled due to payment failure:', paymentIntent.id)
        }
        break
      }

      case 'checkout.session.completed': {
        const session = event.data.object as any
        const orderId = session.metadata?.order_id

        if (orderId && session.payment_status === 'paid') {
          // Update the order: set payment as paid and update stripe_payment_intent_id
          const { error } = await supabase
            .from('delivery_orders')
            .update({
              payment_status: 'paid',
              status: 'confirmed',
              stripe_payment_intent_id: session.payment_intent || session.id,
            })
            .eq('id', orderId)

          if (error) {
            console.error('Failed to update order on checkout completion:', error.message)
          } else {
            console.log('Order confirmed via checkout session:', orderId)
          }
        }
        break
      }

      default:
        console.log('Unhandled event type:', event.type)
    }

    return new Response(JSON.stringify({ received: true }), {
      headers: { 'Content-Type': 'application/json' },
    })

  } catch (error) {
    console.error('Webhook error:', error.message)
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 400, headers: { 'Content-Type': 'application/json' } }
    )
  }
})
