-- Supabase Storage bucket for CMS-uploaded city / attraction cover images

INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'cover-images',
  'cover-images',
  TRUE,
  10485760,
  ARRAY['image/jpeg', 'image/png', 'image/webp', 'image/gif']::text[]
)
ON CONFLICT (id) DO UPDATE SET
  public = EXCLUDED.public,
  file_size_limit = EXCLUDED.file_size_limit,
  allowed_mime_types = EXCLUDED.allowed_mime_types;

DROP POLICY IF EXISTS "Public read cover images" ON storage.objects;
CREATE POLICY "Public read cover images"
  ON storage.objects FOR SELECT
  USING (bucket_id = 'cover-images');

DROP POLICY IF EXISTS "Admins upload cover images" ON storage.objects;
CREATE POLICY "Admins upload cover images"
  ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (bucket_id = 'cover-images' AND public.is_admin());

DROP POLICY IF EXISTS "Admins update cover images" ON storage.objects;
CREATE POLICY "Admins update cover images"
  ON storage.objects FOR UPDATE
  TO authenticated
  USING (bucket_id = 'cover-images' AND public.is_admin())
  WITH CHECK (bucket_id = 'cover-images' AND public.is_admin());

DROP POLICY IF EXISTS "Admins delete cover images" ON storage.objects;
CREATE POLICY "Admins delete cover images"
  ON storage.objects FOR DELETE
  TO authenticated
  USING (bucket_id = 'cover-images' AND public.is_admin());
