-- Replace fixed meta_duration / meta_distance / meta_stops with flexible meta_items JSONB

ALTER TABLE city_guides
  ADD COLUMN IF NOT EXISTS meta_items JSONB NOT NULL DEFAULT '[]'::jsonb;

UPDATE city_guides
SET meta_items = COALESCE(
  (
    SELECT jsonb_agg(item ORDER BY ord)
    FROM (
      SELECT 0 AS ord,
        jsonb_strip_nulls(jsonb_build_object(
          'icon', '⏱',
          'label', 'Duration',
          'value', meta_duration
        )) AS item
      WHERE meta_duration IS NOT NULL AND btrim(meta_duration) <> ''
      UNION ALL
      SELECT 1,
        jsonb_strip_nulls(jsonb_build_object(
          'icon', '📏',
          'label', 'Distance',
          'value', meta_distance
        ))
      WHERE meta_distance IS NOT NULL AND btrim(meta_distance) <> ''
      UNION ALL
      SELECT 2,
        jsonb_strip_nulls(jsonb_build_object(
          'icon', '📍',
          'label', 'Stops',
          'value', meta_stops::text
        ))
      WHERE meta_stops IS NOT NULL
    ) AS rows
  ),
  '[]'::jsonb
)
WHERE (meta_items IS NULL OR meta_items = '[]'::jsonb)
  AND (
    (meta_duration IS NOT NULL AND btrim(meta_duration) <> '')
    OR (meta_distance IS NOT NULL AND btrim(meta_distance) <> '')
    OR meta_stops IS NOT NULL
  );

ALTER TABLE city_guides DROP COLUMN IF EXISTS meta_duration;
ALTER TABLE city_guides DROP COLUMN IF EXISTS meta_distance;
ALTER TABLE city_guides DROP COLUMN IF EXISTS meta_stops;
