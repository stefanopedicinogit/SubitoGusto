import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2"

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  // Handle CORS preflight
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const supabaseUrl = Deno.env.get('SUPABASE_URL')
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')

    if (!supabaseUrl || !supabaseServiceKey) {
      console.error('Missing environment variables')
      throw new Error('Server configuration error')
    }

    // Admin client (bypasses RLS)
    const supabaseAdmin = createClient(supabaseUrl, supabaseServiceKey, {
      auth: { autoRefreshToken: false, persistSession: false }
    })

    const { email, password, displayName, phone } = await req.json()

    if (!email || !password) {
      throw new Error('Missing required fields: email, password')
    }

    console.log('Creating consumer auth user for:', email)

    // 1. Create auth user with user_type = 'consumer' in metadata
    //    This prevents the handle_new_user trigger from creating a staff row
    const { data: authData, error: authError } = await supabaseAdmin.auth.admin.createUser({
      email,
      password,
      email_confirm: true,
      user_metadata: { user_type: 'consumer' },
    })

    if (authError || !authData.user) {
      console.error('Auth error:', authError?.message)
      throw new Error(authError?.message || 'Failed to create user')
    }

    const userId = authData.user.id
    console.log('Created consumer auth user:', userId)

    // 2. Create customer profile
    const { error: customerError } = await supabaseAdmin
      .from('customers')
      .insert({
        id: userId,
        email,
        display_name: displayName || null,
        phone: phone || null,
      })

    if (customerError) {
      console.error('Customer insert error:', customerError.message)
      // Cleanup: delete the auth user we just created
      await supabaseAdmin.auth.admin.deleteUser(userId)
      throw new Error(customerError.message || 'Failed to create customer profile')
    }

    console.log('Consumer registration complete for:', email)

    return new Response(
      JSON.stringify({
        success: true,
        message: 'Consumer registered successfully',
        userId,
      }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )

  } catch (error) {
    console.error('Registration error:', error.message)
    return new Response(
      JSON.stringify({ success: false, error: error.message }),
      {
        status: 400,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' }
      }
    )
  }
})
