-- Attraction extensions + sub-areas for Guide

ALTER TABLE attractions ADD COLUMN IF NOT EXISTS short_description TEXT;
ALTER TABLE attractions ADD COLUMN IF NOT EXISTS cover_images TEXT[] NOT NULL DEFAULT '{}';
ALTER TABLE attractions ADD COLUMN IF NOT EXISTS address_en TEXT;
ALTER TABLE attractions ADD COLUMN IF NOT EXISTS address_zh TEXT;
ALTER TABLE attractions ADD COLUMN IF NOT EXISTS paywall_subtitle_override TEXT;

UPDATE attractions
SET cover_images = ARRAY[cover_image_path]
WHERE cover_image_path IS NOT NULL
  AND cover_image_path <> ''
  AND cardinality(cover_images) = 0;

CREATE TABLE IF NOT EXISTS sub_areas (
  id              TEXT PRIMARY KEY,
  attraction_id   TEXT NOT NULL REFERENCES attractions (id) ON DELETE CASCADE,
  name_en         TEXT NOT NULL,
  name_zh         TEXT,
  cover_image_path TEXT,
  content_blocks  JSONB NOT NULL DEFAULT '[]'::jsonb,
  audio_guide_id  TEXT REFERENCES audio_guides (id) ON DELETE SET NULL,
  sort_order      INT NOT NULL DEFAULT 0,
  is_active       BOOLEAN NOT NULL DEFAULT TRUE,
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS sub_areas_attraction_idx ON sub_areas (attraction_id);

ALTER TABLE sub_areas ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Public read sub_areas" ON sub_areas;
CREATE POLICY "Public read sub_areas" ON sub_areas FOR SELECT
  USING (is_active = TRUE OR public.is_admin());
DROP POLICY IF EXISTS "Admin write sub_areas" ON sub_areas;
CREATE POLICY "Admin write sub_areas" ON sub_areas FOR ALL TO authenticated
  USING (public.is_admin()) WITH CHECK (public.is_admin());

ALTER TABLE hotels ADD COLUMN IF NOT EXISTS booking_links JSONB NOT NULL DEFAULT '[]'::jsonb;
ALTER TABLE hotels ADD COLUMN IF NOT EXISTS accepts_foreigners BOOLEAN NOT NULL DEFAULT TRUE;
ALTER TABLE hotels ADD COLUMN IF NOT EXISTS is_active BOOLEAN NOT NULL DEFAULT TRUE;
