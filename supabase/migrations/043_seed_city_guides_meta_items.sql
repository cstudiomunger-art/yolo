-- Upsert Beijing hutong meta_items after 042 (optional refresh for meta_items-native seed)
-- Safe to run after 041 + 042; updates hutong row meta_items directly.

UPDATE city_guides
SET meta_items = '[
  {"icon": "⏱", "label": "Duration", "value": "~90 min"},
  {"icon": "📏", "label": "Distance", "value": "3.2 km"},
  {"icon": "📍", "label": "Stops", "value": "5"}
]'::jsonb,
updated_at = NOW()
WHERE id = 'beijing_hutong_citywalk';
