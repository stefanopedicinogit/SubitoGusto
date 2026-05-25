import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2"
import Stripe from "https://esm.sh/stripe@14.14.0?target=deno"

// ── FCM helper (inlined — edge functions can't share modules) ────────────────

function base64url(input: string | Uint8Array): string {
  const str = typeof input === 'string'
    ? btoa(input)
    : btoa(String.fromCharCode(...input))
  return str.replace(/=/g, '').replace(/\+/g, '-').replace(/\//g, '_')
}

async function getFcmAccessToken(serviceAccount: any): Promise<string> {
  const header = { alg: 'RS256', typ: 'JWT' }
  const now = Math.floor(Date.now() / 1000)
  const claim = {
    iss: serviceAccount.client_email,
    scope: 'https://www.googleapis.com/auth/firebase.messaging',
    aud: 'https://oauth2.googleapis.com/token',
    iat: now,
    exp: now + 3600,
  }
  const signingInput =
    `${base64url(JSON.stringify(header))}.${base64url(JSON.stringify(claim))}`
  const pem = serviceAccount.private_key
    .replace(/-----BEGIN PRIVATE KEY-----/, '')
    .replace(/-----END PRIVATE KEY-----/, '')
    .replace(/\s/g, '')
  const binaryDer = Uint8Array.from(atob(pem), (c) => c.charCodeAt(0))
  const key = await crypto.subtle.importKey(
    'pkcs8', binaryDer,
    { name: 'RSASSA-PKCS1-v1_5', hash: 'SHA-256' },
    false, ['sign'],
  )
  const signature = await crypto.subtle.sign(
    'RSASSA-PKCS1-v1_5', key, new TextEncoder().encode(signingInput),
  )
  const jwt = `${signingInput}.${base64url(new Uint8Array(signature))}`
  const tokenRes = await fetch('https://oauth2.googleapis.com/token', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: new URLSearchParams({
      grant_type: 'urn:ietf:params:oauth:grant-type:jwt-bearer',
      assertion: jwt,
    }),
  })
  if (!tokenRes.ok) throw new Error(`FCM OAuth failed: ${await tokenRes.text()}`)
  return (await tokenRes.json()).access_token
}

async function sendFcmToToken(
  accessToken: string,
  projectId: string,
  token: string,
  title: string,
  body: string,
): Promise<number> {
  const res = await fetch(
    `https://fcm.googleapis.com/v1/projects/${projectId}/messages:send`,
    {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${accessToken}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        message: {
          token,
          notification: { title, body },
          android: { priority: 'HIGH' },
          apns: { payload: { aps: { sound: 'default', 'content-available': 1 } } },
          webpush: {
            headers: { Urgency: 'high' },
            fcm_options: { link: '/orders' },
          },
        },
      }),
    },
  )
  return res.status
}

// ── Webhook handler ──────────────────────────────────────────────────────────

serve(async (req) => {
  try {
    const stripeSecretKey = Deno.env.get('STRIPE_SECRET_KEY')
    const stripeWebhookSecret = Deno.env.get('STRIPE_WEBHOOK_SECRET')
    const supabaseUrl = Deno.env.get('SUPABASE_URL')
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')
    const fcmServiceAccountRaw = Deno.env.get('FCM_SERVICE_ACCOUNT_JSON')

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

        // 1. Mark the order as paid + confirmed
        const { data: updatedOrders, error } = await supabase
          .from('delivery_orders')
          .update({
            payment_status: 'paid',
            status: 'confirmed',
            stripe_payment_intent_id: paymentIntent.id,
          })
          .eq('stripe_payment_intent_id', paymentIntent.id)
          .select('id, tenant_id, order_number, total')

        if (error) {
          console.error('Failed to update order on payment success:', error.message)
          break
        }

        console.log('Order confirmed for payment:', paymentIntent.id)

        // 2. Notify staff of the restaurant that a new order arrived
        if (!fcmServiceAccountRaw || !updatedOrders?.length) break

        const order = updatedOrders[0]
        const tenantId = order.tenant_id as string
        const orderNumber = order.order_number as string
        const total = Number(order.total).toFixed(2)

        // Fetch FCM tokens for all staff of this tenant
        const { data: staffRows } = await supabase
          .from('users')
          .select('fcm_token')
          .eq('tenant_id', tenantId)
          .not('fcm_token', 'is', null)

        if (!staffRows?.length) {
          console.log('No staff FCM tokens for tenant', tenantId)
          break
        }

        try {
          const serviceAccount = JSON.parse(fcmServiceAccountRaw)
          const accessToken = await getFcmAccessToken(serviceAccount)
          const projectId = serviceAccount.project_id as string

          let sent = 0
          const staleIds: string[] = []
          for (const row of staffRows) {
            const token = row.fcm_token as string
            const status = await sendFcmToToken(
              accessToken, projectId, token,
              `Nuovo ordine · #${orderNumber}`,
              `€ ${total} — conferma e inizia la preparazione`,
            )
            if (status === 200) {
              sent++
            } else if (status === 404 || status === 410) {
              staleIds.push(token)
            } else {
              console.warn(`FCM staff send failed (${token}): ${status}`)
            }
          }

          // Clear stale tokens so we don't retry them
          if (staleIds.length > 0) {
            await supabase
              .from('users')
              .update({ fcm_token: null })
              .in('fcm_token', staleIds)
          }

          console.log(`Staff notifications sent: ${sent}/${staffRows.length}`)
        } catch (fcmErr: any) {
          console.error('FCM staff notify error:', fcmErr.message)
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
