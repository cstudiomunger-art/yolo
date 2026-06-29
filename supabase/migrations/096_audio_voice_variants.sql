-- Multi-voice narration variants for audio guides, sub-areas, and city guides.

CREATE TABLE IF NOT EXISTS audio_voice_variants (
  id               TEXT PRIMARY KEY,
  owner_type       TEXT NOT NULL CHECK (owner_type IN ('audio_guide', 'sub_area', 'city_guide')),
  owner_id         TEXT NOT NULL,
  voice_label      TEXT NOT NULL,
  audio_url        TEXT NOT NULL DEFAULT '',
  duration_seconds INT NOT NULL DEFAULT 0,
  segments         JSONB NOT NULL DEFAULT '[]'::jsonb,
  sort_order       INT NOT NULL DEFAULT 0,
  is_default       BOOLEAN NOT NULL DEFAULT FALSE,
  is_active        BOOLEAN NOT NULL DEFAULT TRUE,
  updated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS audio_voice_variants_owner_idx
  ON audio_voice_variants (owner_type, owner_id);

CREATE UNIQUE INDEX IF NOT EXISTS audio_voice_variants_owner_label_idx
  ON audio_voice_variants (owner_type, owner_id, voice_label);

-- Backfill from existing single-file audio rows.
INSERT INTO audio_voice_variants (
  id, owner_type, owner_id, voice_label, audio_url, duration_seconds, segments,
  sort_order, is_default, is_active
)
SELECT
  'avv_ag_' || ag.id,
  'audio_guide',
  ag.id,
  '默认',
  ag.audio_url,
  ag.duration_seconds,
  COALESCE(ag.segments, '[]'::jsonb),
  0,
  TRUE,
  ag.is_active
FROM audio_guides ag
WHERE TRIM(COALESCE(ag.audio_url, '')) <> ''
  AND NOT EXISTS (
    SELECT 1 FROM audio_voice_variants v
    WHERE v.owner_type = 'audio_guide' AND v.owner_id = ag.id
  );

INSERT INTO audio_voice_variants (
  id, owner_type, owner_id, voice_label, audio_url, duration_seconds, segments,
  sort_order, is_default, is_active
)
SELECT
  'avv_sa_' || sa.id,
  'sub_area',
  sa.id,
  '默认',
  sa.audio_url,
  0,
  '[]'::jsonb,
  0,
  TRUE,
  sa.is_active
FROM sub_areas sa
WHERE TRIM(COALESCE(sa.audio_url, '')) <> ''
  AND NOT EXISTS (
    SELECT 1 FROM audio_voice_variants v
    WHERE v.owner_type = 'sub_area' AND v.owner_id = sa.id
  );

INSERT INTO audio_voice_variants (
  id, owner_type, owner_id, voice_label, audio_url, duration_seconds, segments,
  sort_order, is_default, is_active
)
SELECT
  'avv_cg_' || cg.id,
  'city_guide',
  cg.id,
  '默认',
  cg.audio_url,
  COALESCE(cg.audio_duration_seconds, 0),
  '[]'::jsonb,
  0,
  TRUE,
  cg.is_published
FROM city_guides cg
WHERE TRIM(COALESCE(cg.audio_url, '')) <> ''
  AND NOT EXISTS (
    SELECT 1 FROM audio_voice_variants v
    WHERE v.owner_type = 'city_guide' AND v.owner_id = cg.id
  );

-- RLS (same pattern as audio_guides).
ALTER TABLE audio_voice_variants ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Public read audio_voice_variants" ON audio_voice_variants;
CREATE POLICY "Public read audio_voice_variants" ON audio_voice_variants
  FOR SELECT USING (is_active = TRUE OR public.is_admin());

DROP POLICY IF EXISTS "Admin insert audio_voice_variants" ON audio_voice_variants;
CREATE POLICY "Admin insert audio_voice_variants" ON audio_voice_variants
  FOR INSERT TO authenticated WITH CHECK (public.is_admin());

DROP POLICY IF EXISTS "Admin update audio_voice_variants" ON audio_voice_variants;
CREATE POLICY "Admin update audio_voice_variants" ON audio_voice_variants
  FOR UPDATE TO authenticated
  USING (public.is_admin()) WITH CHECK (public.is_admin());

DROP POLICY IF EXISTS "Admin delete audio_voice_variants" ON audio_voice_variants;
CREATE POLICY "Admin delete audio_voice_variants" ON audio_voice_variants
  FOR DELETE TO authenticated USING (public.is_admin());
