-- CMS admins: upload support-agent avatars (avatars/agents/...) and user avatars on behalf of users.

DROP POLICY IF EXISTS "Admins upload avatars" ON storage.objects;
CREATE POLICY "Admins upload avatars"
  ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (bucket_id = 'avatars' AND public.is_admin());

DROP POLICY IF EXISTS "Admins update avatars" ON storage.objects;
CREATE POLICY "Admins update avatars"
  ON storage.objects FOR UPDATE
  TO authenticated
  USING (bucket_id = 'avatars' AND public.is_admin())
  WITH CHECK (bucket_id = 'avatars' AND public.is_admin());

DROP POLICY IF EXISTS "Admins delete avatars" ON storage.objects;
CREATE POLICY "Admins delete avatars"
  ON storage.objects FOR DELETE
  TO authenticated
  USING (bucket_id = 'avatars' AND public.is_admin());
