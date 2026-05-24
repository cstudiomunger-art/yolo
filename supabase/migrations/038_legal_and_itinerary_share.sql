-- Legal copy (CMS) + itinerary public sharing (B-tier)

ALTER TABLE app_settings
  ADD COLUMN IF NOT EXISTS privacy_policy_body TEXT NOT NULL DEFAULT '',
  ADD COLUMN IF NOT EXISTS terms_of_service_body TEXT NOT NULL DEFAULT '',
  ADD COLUMN IF NOT EXISTS share_web_base_url TEXT NOT NULL DEFAULT 'https://yolohappy.app';

UPDATE app_settings SET
  privacy_policy_body = COALESCE(NULLIF(privacy_policy_body, ''), ''),
  terms_of_service_body = COALESCE(NULLIF(terms_of_service_body, ''), ''),
  support_email = CASE WHEN support_email = 'support@chinago.app' THEN 'support@yolohappy.app' ELSE support_email END
WHERE id = 'global';

ALTER TABLE user_itineraries
  ADD COLUMN IF NOT EXISTS share_slug TEXT,
  ADD COLUMN IF NOT EXISTS is_shared BOOLEAN NOT NULL DEFAULT FALSE,
  ADD COLUMN IF NOT EXISTS shared_at TIMESTAMPTZ;

CREATE UNIQUE INDEX IF NOT EXISTS user_itineraries_share_slug_idx
  ON user_itineraries (share_slug)
  WHERE share_slug IS NOT NULL AND NOT is_deleted;

DROP POLICY IF EXISTS "Public read shared itineraries" ON user_itineraries;
CREATE POLICY "Public read shared itineraries" ON user_itineraries
  FOR SELECT TO anon, authenticated
  USING (
    is_shared = TRUE
    AND share_slug IS NOT NULL
    AND NOT is_deleted
  );
