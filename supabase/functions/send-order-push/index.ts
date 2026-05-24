import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2"

// ============================================================================
// send-order-push
// Triggered by a Supabase Database Webhook on `delivery_orders` UPDATE.
// Sends FCM push notifications to all of the customer's registered devices
// when the order status changes.
// ============================================================================

interface WebhookPayload {
  type: 'INSERT' | 'UPDATE' | 'DELETE'
  table: string
  schema: string
  record: any
  old_record: any
}

const STATUS_COPY_IT: Record<string, { title: string; body: string }> = {
  confirmed: {
    title: 'Ordine confermato',
    body: 'Il ristorante ha accettato il tuo ordine.',
  },
  preparing: {
    title: 'In preparazione',
    body: 'Il tuo ordine è in preparazione.',
  },
  ready_for_delivery: {
    title: 'Pronto per la consegna',
    body: 'Il tuo ordine è pronto e in attesa del corriere.',
  },
  out_for_delivery: {
    title: 'In consegna',
    body: 'Il corriere è in arrivo con il tuo ordine!',
  },
  delivered: {
    title: 'Consegnato',
    body: 'Buon appetito!',
  },
  cancelled: {
    title: 'Ordine annullato',
    body: 'Il tuo ordine è stato annullato.',
  },
  refunded: {
    title: 'Ordine rimborsato',
    body: 'Il rimborso è stato emesso.',
  },
}

// ============================================================================
// FCM OAuth helper — exchanges a service-account JWT for an access token.
// ============================================================================

function base64url(input: string | Uint8Array): string {
  const str = typeof input === 'string'
    ? btoa(input)
    : btoa(String.fromCharCode(...input))
  return str.replace(/=/g, '').replace(/\+/g, '-').replace(/\//g, '_')
}

async function getAccessToken(serviceAccount: any): Promise<string> {
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
    'pkcs8',
    binaryDer,
    { name: 'RSASSA-PKCS1-v1_5', hash: 'SHA-256' },
    false,
    ['sign'],
  )

  const signature = await crypto.subtle.sign(
    'RSASSA-PKCS1-v1_5',
    key,
    new TextEncoder().encode(signingInput),
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

  if (!tokenRes.ok) {
    throw new Error(`OAuth token request failed: ${await tokenRes.text()}`)
  }

  const data = await tokenRes.json()
  return data.access_token
}

// ============================================================================
// FCM send helper — returns the FCM status code so the caller can prune.
// ============================================================================

async function sendFcm(
  accessToken: string,
  projectId: string,
  token: string,
  title: string,
  body: string,
  data: Record<string, string>,
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
          data,
          android: { priority: 'HIGH' },
          apns: {
            payload: { aps: { sound: 'default', 'content-available': 1 } },
          },
          webpush: {
            headers: { Urgency: 'high' },
            fcm_options: { link: `/consumer/orders` },
          },
        },
      }),
    },
  )

  return res.status
}

// ============================================================================
// Main handler
// ============================================================================

serve(async (req) => {
  try {
    const supabaseUrl = Deno.env.get('SUPABASE_URL')
    const serviceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')
    const fcmServiceAccountRaw = Deno.env.get('FCM_SERVICE_ACCOUNT_JSON')

    if (!supabaseUrl || !serviceKey || !fcmServiceAccountRaw) {
      throw new Error('Server configuration error: missing env vars')
    }

    const payload: WebhookPayload = await req.json()
    console.log('Invoked:', payload.type, payload.table)

    // Only react to status changes on delivery_orders updates.
    if (payload.type !== 'UPDATE' || payload.table !== 'delivery_orders') {
      console.log('Skipped: wrong event')
      return new Response(JSON.stringify({ skipped: 'wrong event' }), {
        headers: { 'Content-Type': 'application/json' },
      })
    }

    const newStatus = payload.record?.status as string
    const oldStatus = payload.old_record?.status as string

    if (!newStatus || newStatus === oldStatus) {
      console.log(`Skipped: no status change (${oldStatus} -> ${newStatus})`)
      return new Response(JSON.stringify({ skipped: 'no status change' }), {
        headers: { 'Content-Type': 'application/json' },
      })
    }

    console.log(`Status change: ${oldStatus} -> ${newStatus}`)

    const copy = STATUS_COPY_IT[newStatus]
    if (!copy) {
      console.log(`Skipped: status "${newStatus}" not notifiable`)
      return new Response(JSON.stringify({ skipped: 'status not notifiable' }), {
        headers: { 'Content-Type': 'application/json' },
      })
    }

    const supabase = createClient(supabaseUrl, serviceKey, {
      auth: { autoRefreshToken: false, persistSession: false },
    })

    const customerId = payload.record.customer_id as string
    const orderId = payload.record.id as string
    const orderNumber = payload.record.order_number as string

    // Check opt-in
    const { data: customer, error: customerErr } = await supabase
      .from('customers')
      .select('push_notifications_enabled')
      .eq('id', customerId)
      .maybeSingle()

    if (customerErr) throw customerErr
    if (!customer || customer.push_notifications_enabled === false) {
      console.log(`Skipped: customer ${customerId} opted out`)
      return new Response(JSON.stringify({ skipped: 'customer opted out' }), {
        headers: { 'Content-Type': 'application/json' },
      })
    }

    // Load tokens
    const { data: tokens, error: tokensErr } = await supabase
      .from('push_tokens')
      .select('id, token')
      .eq('customer_id', customerId)

    if (tokensErr) throw tokensErr
    if (!tokens || tokens.length === 0) {
      console.log(`Skipped: no tokens for customer ${customerId}`)
      return new Response(JSON.stringify({ skipped: 'no tokens' }), {
        headers: { 'Content-Type': 'application/json' },
      })
    }

    console.log(`Sending to ${tokens.length} token(s)`)

    // FCM auth
    const serviceAccount = JSON.parse(fcmServiceAccountRaw)
    const accessToken = await getAccessToken(serviceAccount)
    const projectId = serviceAccount.project_id as string

    const titleWithOrder = `${copy.title} · #${orderNumber}`
    const dataPayload = {
      order_id: orderId,
      status: newStatus,
      type: 'delivery_order_status',
    }

    // Send + collect dead tokens
    const deadTokenIds: string[] = []
    let sent = 0
    for (const t of tokens) {
      const status = await sendFcm(
        accessToken,
        projectId,
        t.token,
        titleWithOrder,
        copy.body,
        dataPayload,
      )
      if (status === 200) {
        sent++
      } else if (status === 404 || status === 410) {
        deadTokenIds.push(t.id)
      } else {
        console.warn(`FCM send failed (token ${t.id}): ${status}`)
      }
    }

    if (deadTokenIds.length > 0) {
      await supabase.from('push_tokens').delete().in('id', deadTokenIds)
    }

    return new Response(
      JSON.stringify({
        sent,
        pruned: deadTokenIds.length,
        total: tokens.length,
      }),
      { headers: { 'Content-Type': 'application/json' } },
    )
  } catch (error) {
    console.error('send-order-push error:', error.message)
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { 'Content-Type': 'application/json' } },
    )
  }
})
