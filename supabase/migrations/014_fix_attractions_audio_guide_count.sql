-- Repair rows where CMS sent NULL into NOT NULL column (before admin fix)

UPDATE attractions
SET audio_guide_count = COALESCE(
  (
    SELECT COUNT(*)::int
    FROM audio_guides ag
    WHERE ag.attraction_id = attractions.id
      AND ag.is_active = TRUE
  ),
  0
)
WHERE audio_guide_count IS NULL;

ALTER TABLE attractions
  ALTER COLUMN audio_guide_count SET DEFAULT 0;

ALTER TABLE attractions
  ALTER COLUMN audio_guide_count SET NOT NULL;
