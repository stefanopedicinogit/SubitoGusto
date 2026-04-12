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
    // Get the authorization header
    const authHeader = req.headers.get('Authorization') || req.headers.get('authorization')
    console.log('All headers:', JSON.stringify(Object.fromEntries(req.headers.entries())))

    if (!authHeader) {
      console.error('No authorization header found')
      throw new Error('Missing authorization header')
    }

    console.log('Auth header received:', authHeader.substring(0, 50) + '...')

    // Create Supabase client with user's JWT
    const supabaseUrl = Deno.env.get('SUPABASE_URL')
    const supabaseAnonKey = Deno.env.get('SUPABASE_ANON_KEY')
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')

    console.log('Supabase URL:', supabaseUrl)
    console.log('Anon key exists:', !!supabaseAnonKey)
    console.log('Service key exists:', !!supabaseServiceKey)

    if (!supabaseUrl || !supabaseAnonKey || !supabaseServiceKey) {
      console.error('Missing environment variables')
      throw new Error('Server configuration error')
    }

    // Client with user's auth to check permissions
    const supabaseUser = createClient(supabaseUrl, supabaseAnonKey, {
      global: { headers: { Authorization: authHeader } },
      auth: { autoRefreshToken: false, persistSession: false }
    })

    // Admin client for deleting auth users
    const supabaseAdmin = createClient(supabaseUrl, supabaseServiceKey, {
      auth: { autoRefreshToken: false, persistSession: false }
    })

    // Get current user
    const { data: { user: currentUser }, error: authError } = await supabaseUser.auth.getUser()
    console.log('Auth result - user:', currentUser?.id, 'error:', authError?.message)
    if (authError || !currentUser) {
      throw new Error(`Unauthorized: ${authError?.message || 'No user'}`)
    }

    // Check if current user is admin
    const { data: adminCheck, error: adminError } = await supabaseUser
      .from('users')
      .select('role, tenant_id')
      .eq('id', currentUser.id)
      .single()

    if (adminError || adminCheck?.role !== 'admin') {
      throw new Error('Only admins can delete users')
    }

    // Get user ID to delete from request body
    const { userId } = await req.json()
    if (!userId) {
      throw new Error('Missing userId in request body')
    }

    // Verify the user to delete belongs to same tenant
    const { data: userToDelete, error: userError } = await supabaseUser
      .from('users')
      .select('id, tenant_id')
      .eq('id', userId)
      .single()

    if (userError || !userToDelete) {
      throw new Error('User not found')
    }

    if (userToDelete.tenant_id !== adminCheck.tenant_id) {
      throw new Error('Cannot delete users from other tenants')
    }

    // Prevent self-deletion
    if (userId === currentUser.id) {
      throw new Error('Cannot delete yourself')
    }

    // Delete from public.users first (due to foreign key)
    const { error: deletePublicError } = await supabaseAdmin
      .from('users')
      .delete()
      .eq('id', userId)

    if (deletePublicError) {
      throw new Error(`Failed to delete user profile: ${deletePublicError.message}`)
    }

    // Delete from auth.users
    const { error: deleteAuthError } = await supabaseAdmin.auth.admin.deleteUser(userId)

    if (deleteAuthError) {
      // Log but don't fail - profile is already deleted
      console.error('Failed to delete auth user:', deleteAuthError.message)
    }

    return new Response(
      JSON.stringify({ success: true, message: 'User deleted successfully' }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )

  } catch (error) {
    return new Response(
      JSON.stringify({ success: false, error: error.message }),
      {
        status: 400,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' }
      }
    )
  }
})
