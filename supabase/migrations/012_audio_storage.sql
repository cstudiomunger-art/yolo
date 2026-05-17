-- Supabase Storage bucket for CMS-uploaded audio guides

INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'audio-guides',
  'audio-guides',
  TRUE,
  52428800,
  ARRAY['audio/mpeg', 'audio/mp4', 'audio/m4a', 'audio/wav', 'audio/x-m4a']::text[]
)
ON CONFLICT (id) DO UPDATE SET
  public = EXCLUDED.public,
  file_size_limit = EXCLUDED.file_size_limit,
  allowed_mime_types = EXCLUDED.allowed_mime_types;

DROP POLICY IF EXISTS "Public read audio guides" ON storage.objects;
CREATE POLICY "Public read audio guides"
  ON storage.objects FOR SELECT
  USING (bucket_id = 'audio-guides');

DROP POLICY IF EXISTS "Admins upload audio guides" ON storage.objects;
CREATE POLICY "Admins upload audio guides"
  ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (bucket_id = 'audio-guides' AND public.is_admin());

DROP POLICY IF EXISTS "Admins update audio guides" ON storage.objects;
CREATE POLICY "Admins update audio guides"
  ON storage.objects FOR UPDATE
  TO authenticated
  USING (bucket_id = 'audio-guides' AND public.is_admin())
  WITH CHECK (bucket_id = 'audio-guides' AND public.is_admin());

DROP POLICY IF EXISTS "Admins delete audio guides" ON storage.objects;
CREATE POLICY "Admins delete audio guides"
  ON storage.objects FOR DELETE
  TO authenticated
  USING (bucket_id = 'audio-guides' AND public.is_admin());
