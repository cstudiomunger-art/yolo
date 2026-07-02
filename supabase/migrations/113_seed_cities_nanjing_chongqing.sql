-- Seed: Nanjing + Chongqing cities and attraction_count updates
-- Idempotent: ON CONFLICT (id) DO UPDATE

INSERT INTO cities (
  id, name, chinese_name, emoji, cover_image_path, description, best_for,
  season_note, best_time_to_visit, avg_days_recommended, attraction_count,
  display_order, is_published
) VALUES (
  'nanjing', 'Nanjing', '南京', '🏛️',
  NULL, 'Ming tombs, city walls, and modern Chinese history.', ARRAY['History', 'Culture']::TEXT[],
  NULL, 'Mar–May, Sep–Nov', 3, 0,
  6, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name, chinese_name = EXCLUDED.chinese_name, emoji = EXCLUDED.emoji,
  description = EXCLUDED.description, best_for = EXCLUDED.best_for,
  season_note = EXCLUDED.season_note, best_time_to_visit = EXCLUDED.best_time_to_visit,
  avg_days_recommended = EXCLUDED.avg_days_recommended, display_order = EXCLUDED.display_order,
  is_published = EXCLUDED.is_published, updated_at = NOW();

INSERT INTO cities (
  id, name, chinese_name, emoji, cover_image_path, description, best_for,
  season_note, best_time_to_visit, avg_days_recommended, attraction_count,
  display_order, is_published
) VALUES (
  'chongqing', 'Chongqing', '重庆', '🌶️',
  NULL, 'Mountain city hotpot, river views, and dramatic skylines.', ARRAY['Food', 'Sightseeing', 'Nightlife']::TEXT[],
  'Humid summers; foggy winters', 'Mar–May, Sep–Nov', 3, 0,
  7, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name, chinese_name = EXCLUDED.chinese_name, emoji = EXCLUDED.emoji,
  description = EXCLUDED.description, best_for = EXCLUDED.best_for,
  season_note = EXCLUDED.season_note, best_time_to_visit = EXCLUDED.best_time_to_visit,
  avg_days_recommended = EXCLUDED.avg_days_recommended, display_order = EXCLUDED.display_order,
  is_published = EXCLUDED.is_published, updated_at = NOW();

UPDATE cities SET attraction_count = 9, updated_at = NOW() WHERE id = 'beijing';
UPDATE cities SET attraction_count = 17, updated_at = NOW() WHERE id = 'chongqing';
UPDATE cities SET attraction_count = 12, updated_at = NOW() WHERE id = 'nanjing';
UPDATE cities SET attraction_count = 15, updated_at = NOW() WHERE id = 'hangzhou';
UPDATE cities SET attraction_count = 13, updated_at = NOW() WHERE id = 'suzhou';
