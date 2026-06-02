-- YOLO HAPPY: Avatar storage bucket + CMS content preview config

-- avatars bucket (user-uploaded profile photos)
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'avatars',
  'avatars',
  TRUE,
  2097152,  -- 2 MB
  ARRAY['image/jpeg', 'image/png', 'image/webp']
)
ON CONFLICT (id) DO NOTHING;

-- Each user can only write to their own folder: avatars/{user_id}/...
DROP POLICY IF EXISTS "Users upload own avatar" ON storage.objects;
CREATE POLICY "Users upload own avatar"
  ON storage.objects FOR INSERT
  TO authenticated
  WITH CHECK (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = auth.uid()::text
  );

DROP POLICY IF EXISTS "Users update own avatar" ON storage.objects;
CREATE POLICY "Users update own avatar"
  ON storage.objects FOR UPDATE
  TO authenticated
  USING (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = auth.uid()::text
  );

DROP POLICY IF EXISTS "Users delete own avatar" ON storage.objects;
CREATE POLICY "Users delete own avatar"
  ON storage.objects FOR DELETE
  TO authenticated
  USING (
    bucket_id = 'avatars'
    AND (storage.foldername(name))[1] = auth.uid()::text
  );

DROP POLICY IF EXISTS "Public read avatars" ON storage.objects;
CREATE POLICY "Public read avatars"
  ON storage.objects FOR SELECT
  USING (bucket_id = 'avatars');

-- Add content preview config to app_settings (CMS-controlled free preview limits)
ALTER TABLE app_settings
  ADD COLUMN IF NOT EXISTS free_text_preview_chars INT NOT NULL DEFAULT 80,
  ADD COLUMN IF NOT EXISTS free_visitor_tips_count INT NOT NULL DEFAULT 1;

COMMENT ON COLUMN app_settings.free_text_preview_chars IS 'Number of plain-text characters shown before the text paywall. Default 80.';
COMMENT ON COLUMN app_settings.free_visitor_tips_count IS 'Number of visitor tips shown for free before the paywall. Default 1.';
