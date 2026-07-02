-- Inspect and dedupe Beijing attractions.
-- Canonical set comes from 114_seed_beijing_attractions.sql.
-- Safe scope: only remove rows in city_id='beijing' that share the same chinese_name
-- with canonical attractions but use a non-canonical id.

-- 1) View all Beijing attractions before cleanup
SELECT
  id,
  city_id,
  name,
  chinese_name,
  is_published,
  display_order,
  updated_at
FROM attractions
WHERE city_id = 'beijing'
ORDER BY chinese_name, id;

-- 2) Remove duplicate Beijing rows (same chinese_name as canonical, but wrong id)
WITH canonical AS (
  SELECT *
  FROM (
    VALUES
      ('beijing_forbidden_city', '故宫'),
      ('beijing_temple_of_heaven', '天坛'),
      ('beijing_summer_palace', '颐和园'),
      ('beijing_national_museum', '国博'),
      ('beijing_mutianyu_great_wall', '慕田峪长城'),
      ('beijing_ming_tombs', '十三陵'),
      ('beijing_lama_temple', '雍和宫'),
      ('beijing_prince_gong_mansion', '恭王府'),
      ('beijing_beihai_park', '北海公园')
  ) AS t(id, chinese_name)
)
DELETE FROM attractions a
USING canonical c
WHERE a.city_id = 'beijing'
  AND a.chinese_name = c.chinese_name
  AND a.id <> c.id;

-- 3) View all Beijing attractions after cleanup
SELECT
  id,
  city_id,
  name,
  chinese_name,
  is_published,
  display_order,
  updated_at
FROM attractions
WHERE city_id = 'beijing'
ORDER BY chinese_name, id;

-- 4) Extra verification: should return 0 rows
SELECT
  COALESCE(NULLIF(chinese_name, ''), name) AS display_name,
  COUNT(*) AS cnt,
  ARRAY_AGG(id ORDER BY id) AS ids
FROM attractions
WHERE city_id = 'beijing'
GROUP BY COALESCE(NULLIF(chinese_name, ''), name)
HAVING COUNT(*) > 1
ORDER BY cnt DESC, display_name;
