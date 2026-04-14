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

    const token = authHeader.replace('Bearer ', '')
    const supabaseAdmin = createClient(supabaseUrl, supabaseServiceKey, {
      auth: { autoRefreshToken: false, persistSession: false },
    })

    const { data: { user }, error: userError } = await supabaseAdmin.auth.getUser(token)
    if (userError || !user) throw new Error('Unauthorized')

    // Get user's tenant
    const { data: staffUser, error: staffError } = await supabaseAdmin
      .from('users')
      .select('tenant_id')
      .eq('id', user.id)
      .single()

    if (staffError || !staffUser) throw new Error('Staff user not found')

    const tenantId = staffUser.tenant_id

    // Get current tenant data
    const { data: tenant, error: tenantError } = await supabaseAdmin
      .from('tenants')
      .select('stripe_account_id, name, email')
      .eq('id', tenantId)
      .single()

    if (tenantError || !tenant) throw new Error('Restaurant not found')

    const { returnUrl } = await req.json()

    let accountId = tenant.stripe_account_id

    // Create Stripe Connect account if none exists
    if (!accountId) {
      const account = await stripe.accounts.create({
        type: 'standard',
        email: tenant.email || user.email,
        business_profile: {
          name: tenant.name,
        },
        metadata: {
          tenant_id: tenantId,
        },
      })
      accountId = account.id

      // Save the Stripe account ID
      await supabaseAdmin
        .from('tenants')
        .update({ stripe_account_id: accountId })
        .eq('id', tenantId)

      console.log('Created Stripe Connect account:', accountId, 'for tenant:', tenantId)
    }

    // Create account link for onboarding
    const accountLink = await stripe.accountLinks.create({
      account: accountId,
      refresh_url: returnUrl || `${supabaseUrl}/settings`,
      return_url: returnUrl || `${supabaseUrl}/settings`,
      type: 'account_onboarding',
    })

    console.log('Created onboarding link for account:', accountId)

    return new Response(
      JSON.stringify({
        url: accountLink.url,
        accountId,
      }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )

  } catch (error) {
    console.error('Stripe Connect onboard error:', error.message)
    return new Response(
      JSON.stringify({ error: error.message }),
      {
        status: 400,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      }
    )
  }
})
