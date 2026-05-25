-- =====================================================================
-- SubitoGusto — Supabase Storage setup (buckets + RLS policies)
-- =====================================================================
-- A plain `supabase db dump` does NOT capture Storage. This file
-- recreates the buckets and the storage.objects RLS policies exactly as
-- they exist on the production project.
--
-- Run this in the SQL Editor of a fresh project AFTER schema.sql.
-- (The `storage` schema and its tables already exist on every Supabase
-- project — we only insert the bucket row and the access policies.)
-- =====================================================================

-- ---------------------------------------------------------------------
-- Bucket: tenant-assets (PUBLIC)
-- ---------------------------------------------------------------------
-- Holds menu-item and category images. Public-read so the app can use
-- plain public URLs. File-size (5 MB) and MIME validation (jpeg/png/webp)
-- are enforced in the `upload-menu-image` edge function, not at the
-- bucket level — so no bucket-level limits are set here.
INSERT INTO storage.buckets (id, name, public)
VALUES ('tenant-assets', 'tenant-assets', true)
ON CONFLICT (id) DO UPDATE SET public = EXCLUDED.public;

-- ---------------------------------------------------------------------
-- RLS policies on storage.objects
-- ---------------------------------------------------------------------
-- Tenant isolation mirrors the DB: an object's first path segment must
-- equal the uploader's tenant_id, e.g. "<tenant_id>/menu/<item>.jpg".

-- Anyone may read assets (public images).
CREATE POLICY "Public read access on tenant-assets"
    ON storage.objects FOR SELECT
    TO public
    USING (bucket_id = 'tenant-assets');

-- Staff may upload only into their own tenant folder.
CREATE POLICY "Tenant users can upload assets"
    ON storage.objects FOR INSERT
    TO authenticated
    WITH CHECK (
        bucket_id = 'tenant-assets'
        AND (storage.foldername(name))[1] = (
            SELECT users.tenant_id::text FROM users WHERE users.id = auth.uid()
        )
    );

-- Staff may overwrite/update only within their own tenant folder.
CREATE POLICY "Tenant users can update assets"
    ON storage.objects FOR UPDATE
    TO authenticated
    USING (
        bucket_id = 'tenant-assets'
        AND (storage.foldername(name))[1] = (
            SELECT users.tenant_id::text FROM users WHERE users.id = auth.uid()
        )
    );

-- NOTE: there is intentionally no DELETE policy for authenticated users.
-- Object deletion/overwrite is performed by the `upload-menu-image` edge
-- function using the service-role key (which bypasses RLS).
