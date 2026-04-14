import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2"

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

const BUCKET = 'tenant-assets'

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

    const supabaseAdmin = createClient(supabaseUrl, supabaseServiceKey, {
      auth: { autoRefreshToken: false, persistSession: false }
    })

    // Verify the user is authenticated
    const authHeader = req.headers.get('Authorization')
    if (!authHeader) {
      return new Response(
        JSON.stringify({ error: 'Missing authorization header' }),
        { status: 401, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    const { data: { user }, error: authError } = await supabaseAdmin.auth.getUser(
      authHeader.replace('Bearer ', '')
    )

    if (authError || !user) {
      return new Response(
        JSON.stringify({ error: 'Unauthorized' }),
        { status: 401, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Get the user's tenant_id
    const { data: profile } = await supabaseAdmin
      .from('users')
      .select('tenant_id')
      .eq('id', user.id)
      .single()

    if (!profile?.tenant_id) {
      return new Response(
        JSON.stringify({ error: 'User has no tenant' }),
        { status: 403, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    const tenantId = profile.tenant_id

    // Parse multipart form data
    const formData = await req.formData()
    const file = formData.get('file') as File | null
    const menuItemId = formData.get('menu_item_id') as string | null
    const categoryId = formData.get('category_id') as string | null

    if (!file) {
      return new Response(
        JSON.stringify({ error: 'No file provided' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Validate file type
    const allowedTypes = ['image/jpeg', 'image/png', 'image/webp']
    if (!allowedTypes.includes(file.type)) {
      return new Response(
        JSON.stringify({ error: 'Invalid file type. Allowed: jpeg, png, webp' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Max 5MB
    if (file.size > 5 * 1024 * 1024) {
      return new Response(
        JSON.stringify({ error: 'File too large. Max 5MB' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Build storage path: tenant-assets/{tenantId}/menu/{menuItemId|categoryId}.{ext}
    const ext = file.name.split('.').pop() || 'jpg'
    let storagePath: string
    let updateTable: string
    let updateId: string

    if (menuItemId) {
      storagePath = `${tenantId}/menu/${menuItemId}.${ext}`
      updateTable = 'menu_items'
      updateId = menuItemId
    } else if (categoryId) {
      storagePath = `${tenantId}/categories/${categoryId}.${ext}`
      updateTable = 'categories'
      updateId = categoryId
    } else {
      return new Response(
        JSON.stringify({ error: 'Provide menu_item_id or category_id' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Upload to storage (upsert to overwrite existing)
    const fileBuffer = await file.arrayBuffer()
    const { error: uploadError } = await supabaseAdmin.storage
      .from(BUCKET)
      .upload(storagePath, fileBuffer, {
        contentType: file.type,
        upsert: true,
      })

    if (uploadError) {
      console.error('Upload error:', uploadError)
      return new Response(
        JSON.stringify({ error: `Upload failed: ${uploadError.message}` }),
        { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Build public URL
    const publicUrl = `${supabaseUrl}/storage/v1/object/public/${BUCKET}/${storagePath}`

    // Update the record's image_url
    const { error: updateError } = await supabaseAdmin
      .from(updateTable)
      .update({ image_url: publicUrl, updated_at: new Date().toISOString() })
      .eq('id', updateId)
      .eq('restaurant_id', tenantId)

    if (updateError) {
      console.error('DB update error:', updateError)
      return new Response(
        JSON.stringify({ error: `DB update failed: ${updateError.message}` }),
        { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    return new Response(
      JSON.stringify({
        url: publicUrl,
        path: storagePath,
        table: updateTable,
        id: updateId,
      }),
      { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )

  } catch (err) {
    console.error('Error:', err)
    return new Response(
      JSON.stringify({ error: err.message }),
      { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  }
})
