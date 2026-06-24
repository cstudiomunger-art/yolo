-- Re-run the practical_info backfill for attractions seeded AFTER migration 031
-- (e.g. chengdu_wuhou_shrine): their practical_info is still '[]' while the legacy
-- scalar columns (ticket_price / recommended_duration / opening_hours / closed_days /
-- metro_access) are populated, so the App shows them via fallback but the CMS list is
-- empty. This UPDATE is idempotent — it only touches rows where practical_info = '[]'.

UPDATE attractions
SET practical_info = (
  SELECT COALESCE(jsonb_agg(item ORDER BY ord), '[]'::jsonb)
  FROM (
    SELECT 1 AS ord, jsonb_build_object('icon', '🎫', 'label', 'Ticket', 'value', ticket_price) AS item
    WHERE ticket_price IS NOT NULL AND btrim(ticket_price) <> ''
    UNION ALL
    SELECT 2, jsonb_build_object('icon', '🕐', 'label', 'Duration', 'value', recommended_duration)
    WHERE recommended_duration IS NOT NULL AND btrim(recommended_duration) <> ''
    UNION ALL
    SELECT 3, jsonb_build_object('icon', '🕘', 'label', 'Opening Hours', 'value', opening_hours)
    WHERE opening_hours IS NOT NULL AND btrim(opening_hours) <> ''
    UNION ALL
    SELECT 4, jsonb_build_object('icon', '❌', 'label', 'Closed', 'value', closed_days)
    WHERE closed_days IS NOT NULL AND btrim(closed_days) <> ''
    UNION ALL
    SELECT 5, jsonb_build_object('icon', '🚇', 'label', 'Metro', 'value', metro_access)
    WHERE metro_access IS NOT NULL AND btrim(metro_access) <> ''
  ) rows
)
WHERE practical_info = '[]'::jsonb
  AND (
    (ticket_price IS NOT NULL AND btrim(ticket_price) <> '')
    OR (recommended_duration IS NOT NULL AND btrim(recommended_duration) <> '')
    OR (opening_hours IS NOT NULL AND btrim(opening_hours) <> '')
    OR (closed_days IS NOT NULL AND btrim(closed_days) <> '')
    OR (metro_access IS NOT NULL AND btrim(metro_access) <> '')
  );
