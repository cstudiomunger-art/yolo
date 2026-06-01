-- City guides: per-city modular content (list card → detail with carousel, audio, rich text)

CREATE TABLE IF NOT EXISTS city_guides (
  id                      TEXT PRIMARY KEY,
  city_id                 TEXT NOT NULL REFERENCES cities (id) ON DELETE CASCADE,
  title_en                TEXT NOT NULL,
  title_zh                TEXT,
  subtitle                TEXT,
  icon                    TEXT,
  badge                   TEXT,
  cover_images            TEXT[] NOT NULL DEFAULT '{}',
  body                    TEXT,
  audio_url               TEXT,
  audio_title             TEXT,
  audio_duration_seconds  INT NOT NULL DEFAULT 0,
  audio_quote             TEXT,
  audio_transcript        TEXT,
  meta_duration           TEXT,
  meta_distance           TEXT,
  meta_stops              INT,
  display_order           INT NOT NULL DEFAULT 0,
  is_published            BOOLEAN NOT NULL DEFAULT TRUE,
  updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS city_guides_city_id_idx ON city_guides (city_id);
CREATE INDEX IF NOT EXISTS city_guides_city_order_idx ON city_guides (city_id, display_order);

ALTER TABLE city_guides ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Public read city_guides" ON city_guides;
CREATE POLICY "Public read city_guides" ON city_guides FOR SELECT
  USING (is_published = TRUE OR public.is_admin());

DROP POLICY IF EXISTS "Admin insert city_guides" ON city_guides;
CREATE POLICY "Admin insert city_guides" ON city_guides FOR INSERT TO authenticated
  WITH CHECK (public.is_admin());

DROP POLICY IF EXISTS "Admin update city_guides" ON city_guides;
CREATE POLICY "Admin update city_guides" ON city_guides FOR UPDATE TO authenticated
  USING (public.is_admin()) WITH CHECK (public.is_admin());

DROP POLICY IF EXISTS "Admin delete city_guides" ON city_guides;
CREATE POLICY "Admin delete city_guides" ON city_guides FOR DELETE TO authenticated
  USING (public.is_admin());
