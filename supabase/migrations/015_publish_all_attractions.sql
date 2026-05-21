-- Publish CMS attractions that were saved with is_published = false (App only reads published rows).

UPDATE attractions
SET is_published = TRUE,
    updated_at = NOW()
WHERE is_published = FALSE;

-- Normalize city_id casing for lookups
UPDATE attractions
SET city_id = lower(trim(city_id)),
    updated_at = NOW()
WHERE city_id <> lower(trim(city_id));

UPDATE attractions
SET chinese_name = name
WHERE chinese_name IS NULL OR trim(chinese_name) = '';

-- Refresh per-city counts shown in the cities grid
UPDATE cities c
SET attraction_count = sub.cnt,
    updated_at = NOW()
FROM (
  SELECT city_id, COUNT(*)::int AS cnt
  FROM attractions
  WHERE is_published = TRUE
  GROUP BY city_id
) sub
WHERE c.id = sub.city_id;
