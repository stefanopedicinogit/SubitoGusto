import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2"

// ============================================================================
// validate-promo-code
// Stateless dry-run of the same checks `create-payment-intent` runs when a
// code is supplied. Lets the checkout UI show "Sconto applicato -€X" before
// the user commits to paying. `create-payment-intent` re-validates server-
// side, so this endpoint is purely advisory — it cannot grant discounts.
// ============================================================================

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const supabaseUrl = Deno.env.get('SUPABASE_URL')
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')
    if (!supabaseUrl || !supabaseServiceKey) {
      throw new Error('Server configuration error')
    }

    const authHeader = req.headers.get('Authorization')
    if (!authHeader) throw new Error('Missing authorization')

    const supabase = createClient(supabaseUrl, supabaseServiceKey, {
      auth: { autoRefreshToken: false, persistSession: false },
    })

    const { data: { user }, error: userError } = await supabase.auth.getUser(
      authHeader.replace('Bearer ', ''),
    )
    if (userError || !user) throw new Error('Unauthorized')

    const { code, restaurantId, subtotal } = await req.json()

    if (!code || !restaurantId || subtotal == null) {
      throw new Error('Missing required fields')
    }

    const codeUpper = String(code).trim().toUpperCase()
    const { data: promo, error: promoErr } = await supabase
      .from('promo_codes')
      .select('*')
      .eq('code', codeUpper)
      .maybeSingle()

    if (promoErr) throw promoErr
    if (!promo) throw new Error('Codice promozionale non valido')
    if (!promo.active) throw new Error('Codice promozionale disattivato')

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

    if (Number(subtotal) < Number(promo.min_order)) {
      throw new Error(
        `Ordine minimo € ${Number(promo.min_order).toFixed(2)} per usare questo codice`,
      )
    }

    const { count: prevRedemptions } = await supabase
      .from('promo_redemptions')
      .select('id', { count: 'exact', head: true })
      .eq('promo_code_id', promo.id)
      .eq('customer_id', user.id)

    if (prevRedemptions != null && prevRedemptions >= promo.per_customer_limit) {
      throw new Error('Hai già usato questo codice il numero massimo di volte')
    }

    let discountAmount = 0
    if (promo.type === 'percent') {
      discountAmount = Math.round(Number(subtotal) * Number(promo.value)) / 100
    } else {
      discountAmount = Number(promo.value)
    }
    discountAmount = Math.min(discountAmount, Number(subtotal))
    discountAmount = Math.round(discountAmount * 100) / 100

    return new Response(
      JSON.stringify({
        valid: true,
        code: codeUpper,
        type: promo.type,
        value: Number(promo.value),
        discountAmount,
        description: promo.description ?? null,
      }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } },
    )
  } catch (error) {
    // Validation failures (bad code, min order not met, expired, etc.) are a
    // *successful* call from the client's POV — they just need the message.
    // Return 200 so the supabase-dart client doesn't wrap this in a
    // FunctionException and the body reaches `response.data` cleanly.
    return new Response(
      JSON.stringify({ valid: false, error: error.message }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } },
    )
  }
})
