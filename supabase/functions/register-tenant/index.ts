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

    // Get request body
    const {
      tenantName,
      tenantPhone,
      tenantAddress,
      tenantEmail,
      adminEmail,
      adminPassword,
      adminFirstName,
      adminLastName
    } = await req.json()

    if (!tenantName || !adminEmail || !adminPassword) {
      throw new Error('Missing required fields: tenantName, adminEmail, adminPassword')
    }

    console.log('Creating auth user for:', adminEmail)

    // 1. Create auth user
    const { data: authData, error: authError } = await supabaseAdmin.auth.admin.createUser({
      email: adminEmail,
      password: adminPassword,
      email_confirm: true, // Auto-confirm email
    })

    if (authError || !authData.user) {
      console.error('Auth error:', authError?.message)
      throw new Error(authError?.message || 'Failed to create user')
    }

    const userId = authData.user.id
    console.log('Created auth user:', userId)

    // 2. Create tenant
    const { data: tenantData, error: tenantError } = await supabaseAdmin
      .from('tenants')
      .insert({
        name: tenantName,
        phone: tenantPhone || null,
        address: tenantAddress || null,
        email: tenantEmail || null,
        settings: {
          currency: 'EUR',
          language: 'it',
        },
      })
      .select()
      .single()

    if (tenantError || !tenantData) {
      console.error('Tenant error:', tenantError?.message)
      // Cleanup: delete the auth user we just created
      await supabaseAdmin.auth.admin.deleteUser(userId)
      throw new Error(tenantError?.message || 'Failed to create tenant')
    }

    const tenantId = tenantData.id
    console.log('Created tenant:', tenantId)

    // 3. Check if user record exists (from trigger) and update, or insert
    const { data: existingUser } = await supabaseAdmin
      .from('users')
      .select('id')
      .eq('id', userId)
      .maybeSingle()

    if (existingUser) {
      // Update existing record
      const { error: updateError } = await supabaseAdmin
        .from('users')
        .update({
          tenant_id: tenantId,
          email: adminEmail,
          role: 'admin',
          first_name: adminFirstName || null,
          last_name: adminLastName || null,
          is_active: true,
        })
        .eq('id', userId)

      if (updateError) {
        console.error('User update error:', updateError.message)
      }
    } else {
      // Insert new user record
      const { error: insertError } = await supabaseAdmin
        .from('users')
        .insert({
          id: userId,
          tenant_id: tenantId,
          email: adminEmail,
          role: 'admin',
          first_name: adminFirstName || null,
          last_name: adminLastName || null,
          is_active: true,
        })

      if (insertError) {
        console.error('User insert error:', insertError.message)
      }
    }

    console.log('Registration complete for tenant:', tenantName)

    return new Response(
      JSON.stringify({
        success: true,
        message: 'Tenant registered successfully',
        tenantId: tenantId,
        userId: userId,
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
