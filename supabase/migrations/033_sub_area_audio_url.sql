-- Sub-area: direct audio URL (no audio_guides association required)

ALTER TABLE sub_areas ADD COLUMN IF NOT EXISTS audio_url TEXT NOT NULL DEFAULT '';

UPDATE sub_areas sa
SET audio_url = ag.audio_url
FROM audio_guides ag
WHERE sa.audio_guide_id = ag.id
  AND COALESCE(trim(sa.audio_url), '') = ''
  AND COALESCE(trim(ag.audio_url), '') <> '';
