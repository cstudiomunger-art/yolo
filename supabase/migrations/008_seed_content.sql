-- ChinaGo: initial content seed (from YOLO/Resources/Static/*.json)
-- Run after 001–007, 009_align_content_columns.sql, and 010_fix_text_primary_keys.sql.
-- Regenerate: node scripts/generate-seed-sql.mjs
-- column missing → 009 | uuid id error → 010

BEGIN;

-- app_settings
UPDATE app_settings SET
  use_remote_content = TRUE,
  use_remote_ai = FALSE,
  use_remote_iap = FALSE,
  updated_at = NOW()
WHERE id = 'global';

-- cities
INSERT INTO cities (
  id, name, chinese_name, emoji, cover_image_path, description,
  best_for, season_note, best_time_to_visit, avg_days_recommended,
  attraction_count, display_order, is_published
) VALUES (
  'beijing', 'Beijing', '北京', '🏯',
  NULL, 'Imperial palaces, hutongs, and world-class museums.',
  ARRAY['History', 'Culture', 'Food'], 'Cold winters (−5°C), hot summers (35°C)', 'Apr–May, Sep–Oct',
  4, 12, 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  chinese_name = EXCLUDED.chinese_name,
  emoji = EXCLUDED.emoji,
  description = EXCLUDED.description,
  best_for = EXCLUDED.best_for,
  season_note = EXCLUDED.season_note,
  best_time_to_visit = EXCLUDED.best_time_to_visit,
  avg_days_recommended = EXCLUDED.avg_days_recommended,
  attraction_count = EXCLUDED.attraction_count,
  display_order = EXCLUDED.display_order,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();
INSERT INTO cities (
  id, name, chinese_name, emoji, cover_image_path, description,
  best_for, season_note, best_time_to_visit, avg_days_recommended,
  attraction_count, display_order, is_published
) VALUES (
  'shanghai', 'Shanghai', '上海', '🌆',
  NULL, 'Art deco Bund, futuristic skyline, and vibrant food scene.',
  ARRAY['Modern', 'Food', 'Nightlife'], 'Humid summers, mild winters', 'Mar–May, Sep–Nov',
  3, 8, 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  chinese_name = EXCLUDED.chinese_name,
  emoji = EXCLUDED.emoji,
  description = EXCLUDED.description,
  best_for = EXCLUDED.best_for,
  season_note = EXCLUDED.season_note,
  best_time_to_visit = EXCLUDED.best_time_to_visit,
  avg_days_recommended = EXCLUDED.avg_days_recommended,
  attraction_count = EXCLUDED.attraction_count,
  display_order = EXCLUDED.display_order,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();
INSERT INTO cities (
  id, name, chinese_name, emoji, cover_image_path, description,
  best_for, season_note, best_time_to_visit, avg_days_recommended,
  attraction_count, display_order, is_published
) VALUES (
  'xian', 'Xi''an', '西安', '🏺',
  NULL, 'Terracotta Warriors and ancient Silk Road heritage.',
  ARRAY['History', 'Culture'], NULL, 'Mar–May, Sep–Oct',
  2, 6, 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  chinese_name = EXCLUDED.chinese_name,
  emoji = EXCLUDED.emoji,
  description = EXCLUDED.description,
  best_for = EXCLUDED.best_for,
  season_note = EXCLUDED.season_note,
  best_time_to_visit = EXCLUDED.best_time_to_visit,
  avg_days_recommended = EXCLUDED.avg_days_recommended,
  attraction_count = EXCLUDED.attraction_count,
  display_order = EXCLUDED.display_order,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();
INSERT INTO cities (
  id, name, chinese_name, emoji, cover_image_path, description,
  best_for, season_note, best_time_to_visit, avg_days_recommended,
  attraction_count, display_order, is_published
) VALUES (
  'chengdu', 'Chengdu', '成都', '🐼',
  NULL, 'Pandas, spicy Sichuan cuisine, and tea houses.',
  ARRAY['Food', 'Nature'], NULL, 'Mar–Jun, Sep–Nov',
  3, 5, 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  chinese_name = EXCLUDED.chinese_name,
  emoji = EXCLUDED.emoji,
  description = EXCLUDED.description,
  best_for = EXCLUDED.best_for,
  season_note = EXCLUDED.season_note,
  best_time_to_visit = EXCLUDED.best_time_to_visit,
  avg_days_recommended = EXCLUDED.avg_days_recommended,
  attraction_count = EXCLUDED.attraction_count,
  display_order = EXCLUDED.display_order,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();
INSERT INTO cities (
  id, name, chinese_name, emoji, cover_image_path, description,
  best_for, season_note, best_time_to_visit, avg_days_recommended,
  attraction_count, display_order, is_published
) VALUES (
  'suzhou', 'Suzhou', '苏州', '🌸',
  NULL, 'Classical gardens and canal towns.',
  ARRAY['Culture', 'Nature'], NULL, 'Mar–May',
  2, 5, 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  chinese_name = EXCLUDED.chinese_name,
  emoji = EXCLUDED.emoji,
  description = EXCLUDED.description,
  best_for = EXCLUDED.best_for,
  season_note = EXCLUDED.season_note,
  best_time_to_visit = EXCLUDED.best_time_to_visit,
  avg_days_recommended = EXCLUDED.avg_days_recommended,
  attraction_count = EXCLUDED.attraction_count,
  display_order = EXCLUDED.display_order,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();
INSERT INTO cities (
  id, name, chinese_name, emoji, cover_image_path, description,
  best_for, season_note, best_time_to_visit, avg_days_recommended,
  attraction_count, display_order, is_published
) VALUES (
  'hangzhou', 'Hangzhou', '杭州', '🌊',
  NULL, 'West Lake scenery and Longjing tea culture.',
  ARRAY['Nature', 'Culture'], NULL, 'Mar–May',
  2, 4, 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  chinese_name = EXCLUDED.chinese_name,
  emoji = EXCLUDED.emoji,
  description = EXCLUDED.description,
  best_for = EXCLUDED.best_for,
  season_note = EXCLUDED.season_note,
  best_time_to_visit = EXCLUDED.best_time_to_visit,
  avg_days_recommended = EXCLUDED.avg_days_recommended,
  attraction_count = EXCLUDED.attraction_count,
  display_order = EXCLUDED.display_order,
  is_published = EXCLUDED.is_published,
  updated_at = NOW();

-- city_routes
INSERT INTO city_routes (id, city_id, title, days, summary, sort_order)
VALUES ('route_beijing_classic', 'beijing', 'Classic Beijing', 3, 'Forbidden City → Hutongs → Temple of Heaven. The essential first-timer route, manageable on foot and subway.', 1)
ON CONFLICT (id) DO UPDATE SET
  city_id = EXCLUDED.city_id, title = EXCLUDED.title, days = EXCLUDED.days,
  summary = EXCLUDED.summary, sort_order = EXCLUDED.sort_order, updated_at = NOW();
INSERT INTO city_routes (id, city_id, title, days, summary, sort_order)
VALUES ('route_beijing_history', 'beijing', 'History Deep Dive', 5, 'Add a Great Wall day trip (Mutianyu), Summer Palace, and National Museum to the Classic route.', 2)
ON CONFLICT (id) DO UPDATE SET
  city_id = EXCLUDED.city_id, title = EXCLUDED.title, days = EXCLUDED.days,
  summary = EXCLUDED.summary, sort_order = EXCLUDED.sort_order, updated_at = NOW();
INSERT INTO city_routes (id, city_id, title, days, summary, sort_order)
VALUES ('route_beijing_food', 'beijing', 'Food & Culture', 3, 'Focus on hutong neighbourhoods, Wangfujing night market, 798 Art Zone, and street food trails.', 3)
ON CONFLICT (id) DO UPDATE SET
  city_id = EXCLUDED.city_id, title = EXCLUDED.title, days = EXCLUDED.days,
  summary = EXCLUDED.summary, sort_order = EXCLUDED.sort_order, updated_at = NOW();

-- attractions
INSERT INTO attractions (
  id, city_id, name, chinese_name, category, cover_image_path, summary, introduction,
  priority, ticket_price, recommended_duration, opening_hours, closed_days,
  requires_advance_booking, metro_access, western_visitor_tips, nearby_places,
  audio_guide_count, iap_product_id, display_order, is_published
) VALUES (
  'beijing_forbidden_city', 'beijing', 'Forbidden City', '故宫',
  'palace', NULL, 'Imperial palace for 24 emperors across nearly five centuries.',
  'The Forbidden City served as the imperial palace for 24 emperors across nearly five centuries. Once forbidden to all commoners, today it receives more visitors than any museum on earth.\n\nConstruction began in 1406 under the Yongle Emperor and took fourteen years, employing over a million workers. The complex comprises 980 buildings and covers 180 acres — a city within a city.', 'P0', '¥60 (~$8)',
  '3–4 hours', '8:30 AM – 5:00 PM', 'Mondays',
  TRUE, 'Line 1 · Tiananmen E/W',
  '["Arrive at 9 AM to avoid the midday crowds.","The ¥40 audio guide at the entrance is dry — ours covers the same ground with far more cultural depth.","Exit via the north gate to Jingshan Park for the best aerial view."]'::jsonb, '[{"name":"Jingshan Park","distance":"5 min walk"},{"name":"Nanluogu Xiang","distance":"20 min walk"}]'::jsonb,
  1, 'com.chinago.travel.attraction.beijing_forbidden_city', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  city_id = EXCLUDED.city_id, name = EXCLUDED.name, chinese_name = EXCLUDED.chinese_name,
  category = EXCLUDED.category, summary = EXCLUDED.summary, introduction = EXCLUDED.introduction,
  priority = EXCLUDED.priority, ticket_price = EXCLUDED.ticket_price,
  western_visitor_tips = EXCLUDED.western_visitor_tips, nearby_places = EXCLUDED.nearby_places,
  audio_guide_count = EXCLUDED.audio_guide_count, is_published = EXCLUDED.is_published,
  updated_at = NOW();
INSERT INTO attractions (
  id, city_id, name, chinese_name, category, cover_image_path, summary, introduction,
  priority, ticket_price, recommended_duration, opening_hours, closed_days,
  requires_advance_booking, metro_access, western_visitor_tips, nearby_places,
  audio_guide_count, iap_product_id, display_order, is_published
) VALUES (
  'beijing_temple_of_heaven', 'beijing', 'Temple of Heaven', '天坛',
  'temple', NULL, 'Where emperors prayed for good harvests.',
  'A masterpiece of Ming architecture where emperors performed annual ceremonies to ensure good harvests.', 'P1', '¥35',
  '2–3 hrs', '6:00 AM – 9:00 PM', NULL,
  FALSE, 'Line 5',
  '[]'::jsonb, '[]'::jsonb,
  1, NULL, 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  city_id = EXCLUDED.city_id, name = EXCLUDED.name, chinese_name = EXCLUDED.chinese_name,
  category = EXCLUDED.category, summary = EXCLUDED.summary, introduction = EXCLUDED.introduction,
  priority = EXCLUDED.priority, ticket_price = EXCLUDED.ticket_price,
  western_visitor_tips = EXCLUDED.western_visitor_tips, nearby_places = EXCLUDED.nearby_places,
  audio_guide_count = EXCLUDED.audio_guide_count, is_published = EXCLUDED.is_published,
  updated_at = NOW();

-- audio_guides
INSERT INTO audio_guides (
  id, attraction_id, title_en, description, duration_seconds, audio_url, quote,
  segments, is_main_guide, sort_order, is_active
) VALUES (
  'ag_forbidden_main', 'beijing_forbidden_city', 'Literary Audio Tour', 'Main palace walkthrough',
  754, '', 'In the winter of 1420, as the last craftsmen cleared their scaffolding from the Hall of Supreme Harmony...',
  '[{"id":"intro","title":"Intro 0:00","start_seconds":0},{"id":"history","title":"History 1:30","start_seconds":90},{"id":"halls","title":"The Halls 5:00","start_seconds":300},{"id":"hidden","title":"Hidden 9:30","start_seconds":570}]'::jsonb, TRUE, 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id, title_en = EXCLUDED.title_en,
  duration_seconds = EXCLUDED.duration_seconds, audio_url = EXCLUDED.audio_url,
  segments = EXCLUDED.segments, updated_at = NOW();

-- checklist_items
INSERT INTO checklist_items (
  id, city_id, phase, group_title, title_en, estimated_minutes, display_tags,
  cultural_tip, sort_order, is_active
) VALUES (
  'cl_vpn', NULL, 'before_departure', 'Essential — Before You Fly',
  'Download a VPN app', 15, ARRAY[]::TEXT[],
  NULL, 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  title_en = EXCLUDED.title_en, phase = EXCLUDED.phase, group_title = EXCLUDED.group_title,
  estimated_minutes = EXCLUDED.estimated_minutes, cultural_tip = EXCLUDED.cultural_tip,
  updated_at = NOW();
INSERT INTO checklist_items (
  id, city_id, phase, group_title, title_en, estimated_minutes, display_tags,
  cultural_tip, sort_order, is_active
) VALUES (
  'cl_alipay', NULL, 'before_departure', 'Essential — Before You Fly',
  'Set up Alipay International', 20, ARRAY[]::TEXT[],
  NULL, 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  title_en = EXCLUDED.title_en, phase = EXCLUDED.phase, group_title = EXCLUDED.group_title,
  estimated_minutes = EXCLUDED.estimated_minutes, cultural_tip = EXCLUDED.cultural_tip,
  updated_at = NOW();
INSERT INTO checklist_items (
  id, city_id, phase, group_title, title_en, estimated_minutes, display_tags,
  cultural_tip, sort_order, is_active
) VALUES (
  'cl_esim', NULL, 'before_departure', 'Essential — Before You Fly',
  'Get a China eSIM', 10, ARRAY[]::TEXT[],
  NULL, 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  title_en = EXCLUDED.title_en, phase = EXCLUDED.phase, group_title = EXCLUDED.group_title,
  estimated_minutes = EXCLUDED.estimated_minutes, cultural_tip = EXCLUDED.cultural_tip,
  updated_at = NOW();
INSERT INTO checklist_items (
  id, city_id, phase, group_title, title_en, estimated_minutes, display_tags,
  cultural_tip, sort_order, is_active
) VALUES (
  'cl_amap', NULL, 'before_departure', 'Essential — Before You Fly',
  'Download Amap (高德地图)', 5, ARRAY['key'],
  NULL, 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  title_en = EXCLUDED.title_en, phase = EXCLUDED.phase, group_title = EXCLUDED.group_title,
  estimated_minutes = EXCLUDED.estimated_minutes, cultural_tip = EXCLUDED.cultural_tip,
  updated_at = NOW();
INSERT INTO checklist_items (
  id, city_id, phase, group_title, title_en, estimated_minutes, display_tags,
  cultural_tip, sort_order, is_active
) VALUES (
  'cl_didi', NULL, 'before_departure', 'Essential — Before You Fly',
  'Install and set up Didi', 10, ARRAY['key'],
  NULL, 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  title_en = EXCLUDED.title_en, phase = EXCLUDED.phase, group_title = EXCLUDED.group_title,
  estimated_minutes = EXCLUDED.estimated_minutes, cultural_tip = EXCLUDED.cultural_tip,
  updated_at = NOW();
INSERT INTO checklist_items (
  id, city_id, phase, group_title, title_en, estimated_minutes, display_tags,
  cultural_tip, sort_order, is_active
) VALUES (
  'cl_forbidden_tickets', 'beijing', 'before_departure', 'Beijing — City Specific',
  'Book Forbidden City tickets NOW', NULL, ARRAY['urgent'],
  'The palace was forbidden to commoners for 500 years — you''ll walk where only emperors walked.', 6, TRUE
) ON CONFLICT (id) DO UPDATE SET
  title_en = EXCLUDED.title_en, phase = EXCLUDED.phase, group_title = EXCLUDED.group_title,
  estimated_minutes = EXCLUDED.estimated_minutes, cultural_tip = EXCLUDED.cultural_tip,
  updated_at = NOW();
INSERT INTO checklist_items (
  id, city_id, phase, group_title, title_en, estimated_minutes, display_tags,
  cultural_tip, sort_order, is_active
) VALUES (
  'cl_great_wall', 'beijing', 'before_departure', 'Beijing — City Specific',
  'Download the Great Wall shuttle schedule', 5, ARRAY[]::TEXT[],
  NULL, 7, TRUE
) ON CONFLICT (id) DO UPDATE SET
  title_en = EXCLUDED.title_en, phase = EXCLUDED.phase, group_title = EXCLUDED.group_title,
  estimated_minutes = EXCLUDED.estimated_minutes, cultural_tip = EXCLUDED.cultural_tip,
  updated_at = NOW();
INSERT INTO checklist_items (
  id, city_id, phase, group_title, title_en, estimated_minutes, display_tags,
  cultural_tip, sort_order, is_active
) VALUES (
  'cl_pleco', NULL, 'before_departure', 'Recommended',
  'Download Pleco dictionary', 5, ARRAY[]::TEXT[],
  NULL, 8, TRUE
) ON CONFLICT (id) DO UPDATE SET
  title_en = EXCLUDED.title_en, phase = EXCLUDED.phase, group_title = EXCLUDED.group_title,
  estimated_minutes = EXCLUDED.estimated_minutes, cultural_tip = EXCLUDED.cultural_tip,
  updated_at = NOW();

-- shopping_items
INSERT INTO shopping_items (id, city_id, title_en, note_en, sort_order, is_active)
VALUES ('shop_pain', NULL, 'Pain relief (ibuprofen)', 'Brand names look unfamiliar in China — bring your own', 1, TRUE)
ON CONFLICT (id) DO UPDATE SET title_en = EXCLUDED.title_en, note_en = EXCLUDED.note_en, updated_at = NOW();
INSERT INTO shopping_items (id, city_id, title_en, note_en, sort_order, is_active)
VALUES ('shop_spf', NULL, 'SPF 50+ sunscreen', 'Chinese formulas are very different — bring a trusted brand', 2, TRUE)
ON CONFLICT (id) DO UPDATE SET title_en = EXCLUDED.title_en, note_en = EXCLUDED.note_en, updated_at = NOW();
INSERT INTO shopping_items (id, city_id, title_en, note_en, sort_order, is_active)
VALUES ('shop_meds', NULL, 'Antihistamine & diarrhea medicine', 'Food changes can surprise your stomach', 3, TRUE)
ON CONFLICT (id) DO UPDATE SET title_en = EXCLUDED.title_en, note_en = EXCLUDED.note_en, updated_at = NOW();

-- reading_list
INSERT INTO reading_list (id, city_ids, title, author, genre, synopsis_en, sort_order, is_active)
VALUES ('read_beijing_1', ARRAY['beijing'], 'The Last Days of Old Beijing', 'Michael Meyer', 'Non-fiction', 'A firsthand account of hutong demolition and the changing face of Beijing before the 2008 Olympics.', 1, TRUE)
ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title, author = EXCLUDED.author, synopsis_en = EXCLUDED.synopsis_en, updated_at = NOW();
INSERT INTO reading_list (id, city_ids, title, author, genre, synopsis_en, sort_order, is_active)
VALUES ('read_beijing_2', ARRAY['beijing'], 'Oracle Bones', 'Peter Hessler', 'Non-fiction', 'A journalist''s exploration of China''s rapid transformation, rooted in history and street-level observation.', 2, TRUE)
ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title, author = EXCLUDED.author, synopsis_en = EXCLUDED.synopsis_en, updated_at = NOW();

-- hotels
INSERT INTO hotels (
  id, city_id, name, chinese_name, stars, price_min_usd, has_english_staff,
  english_staff_note, language_tip, location_note, booking_platforms, sort_order, is_active
) VALUES (
  'hotel_beijing_hyatt', 'beijing', 'Grand Hyatt', '北京东方君悦大酒店',
  5, 195, TRUE,
  '24h English concierge', NULL,
  'City centre · 0.8km from Day 1 activities', ARRAY['Booking.com', 'Trip.com', 'Agoda'],
  0, TRUE
) ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name, chinese_name = EXCLUDED.chinese_name, updated_at = NOW();
INSERT INTO hotels (
  id, city_id, name, chinese_name, stars, price_min_usd, has_english_staff,
  english_staff_note, language_tip, location_note, booking_platforms, sort_order, is_active
) VALUES (
  'hotel_beijing_novotel', 'beijing', 'Novotel', '诺富特',
  4, 120, TRUE,
  'English-speaking front desk', NULL,
  'City centre · 1.2km from main sights', ARRAY['Booking.com', 'Trip.com'],
  1, TRUE
) ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name, chinese_name = EXCLUDED.chinese_name, updated_at = NOW();
INSERT INTO hotels (
  id, city_id, name, chinese_name, stars, price_min_usd, has_english_staff,
  english_staff_note, language_tip, location_note, booking_platforms, sort_order, is_active
) VALUES (
  'hotel_beijing_ibis', 'beijing', 'Ibis', '宜必思',
  3, 65, FALSE,
  NULL, 'Save in Chinese to show your Didi driver: 宜必思酒店',
  'City centre', ARRAY['Booking.com', 'Trip.com'],
  2, TRUE
) ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name, chinese_name = EXCLUDED.chinese_name, updated_at = NOW();

-- home_tips (requires TEXT id column from migration 004)
INSERT INTO home_tips (
  id, city_id, kicker, headline, body, link_label, link_attraction_id, link_url, sort_order, is_active
) VALUES (
  'tip_forbidden_booking', 'beijing', 'Heads Up', 'Book the Forbidden City now.',
  'Timed-entry tickets sell out three weeks ahead during your travel dates. Required via the official WeChat mini-program.', 'Booking instructions →', 'beijing_forbidden_city',
  NULL, 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  headline = EXCLUDED.headline, body = EXCLUDED.body, link_label = EXCLUDED.link_label,
  link_attraction_id = EXCLUDED.link_attraction_id, updated_at = NOW();

-- culture_tips
INSERT INTO culture_tips (id, emoji, title, preview, body, sort_order, is_active)
VALUES ('culture_restaurant', '🍜', 'Restaurant Etiquette', 'Scan QR codes at your table to order. Tipping is not expected and can sometimes cause confusion.', 'Most restaurants use QR ordering at the table. Staff may not speak English — point at pictures or use translation apps. Tipping is not customary. Splitting bills is common among friends; as a visitor, offering to pay once is polite but not required.', 0, TRUE)
ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title, preview = EXCLUDED.preview, body = EXCLUDED.body, updated_at = NOW();
INSERT INTO culture_tips (id, emoji, title, preview, body, sort_order, is_active)
VALUES ('culture_transport', '🚇', 'Getting Around', 'Queue properly at subway entrances. Priority seats are taken seriously — offer yours to elderly passengers.', 'Subway systems are extensive and signage is increasingly bilingual. Have your metro QR ready before the gate. Didi works like Uber — save your hotel address in Chinese for the driver.', 1, TRUE)
ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title, preview = EXCLUDED.preview, body = EXCLUDED.body, updated_at = NOW();
INSERT INTO culture_tips (id, emoji, title, preview, body, sort_order, is_active)
VALUES ('culture_photo', '📸', 'Photography & Social Rules', 'Military installations and some government buildings are strictly off-limits. Always ask before photographing people.', 'Avoid photographing military sites, airports security areas, and police without permission. Many locals are happy to be in tourist photos if you ask first.', 2, TRUE)
ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title, preview = EXCLUDED.preview, body = EXCLUDED.body, updated_at = NOW();
INSERT INTO culture_tips (id, emoji, title, preview, body, sort_order, is_active)
VALUES ('culture_shopping', '🛍', 'Shopping & Bargaining', 'Markets like Silk Market expect negotiation. Fixed-price stores (malls, chain stores) do not. Start at 30% of the asking price.', 'In tourist markets, bargaining is expected. In malls and supermarkets, prices are fixed. Mobile payment is preferred — cash is backup.', 3, TRUE)
ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title, preview = EXCLUDED.preview, body = EXCLUDED.body, updated_at = NOW();
INSERT INTO culture_tips (id, emoji, title, preview, body, sort_order, is_active)
VALUES ('culture_gifts', '🎁', 'Gifts & Hosting', 'Gifts are often not opened immediately. Avoid clocks (symbolise death) and green hats. Bring something from your home country.', 'Small gifts from your home country are appreciated. Present with both hands. Avoid clocks, umbrellas, and green hats as gifts. White wrapping can imply funerals — red or gold is safer.', 4, TRUE)
ON CONFLICT (id) DO UPDATE SET title = EXCLUDED.title, preview = EXCLUDED.preview, body = EXCLUDED.body, updated_at = NOW();

-- assistant_replies
INSERT INTO assistant_replies (scenario_id, user_message, assistant_message, is_active)
VALUES ('payment', 'My Alipay verification is taking too long. What are my options?', 'Alipay verification typically takes 24–72 hours. In the meantime:\n\nPrimary backup — WeChat Pay accepts the same international cards and verification is often faster.\n\nSecondary backup — UnionPay cards are accepted at most hotels and larger establishments.\n\nCash — Carry ¥500–800 RMB. International chain hotels accept foreign cards directly.', TRUE)
ON CONFLICT (scenario_id) DO UPDATE SET assistant_message = EXCLUDED.assistant_message, updated_at = NOW();
INSERT INTO assistant_replies (scenario_id, user_message, assistant_message, is_active)
VALUES ('emergency', 'I need emergency help.', 'Open the Emergency toolkit from the chip above for offline numbers. For police dial 110, ambulance 120. Your embassy can assist with lost passports.', TRUE)
ON CONFLICT (scenario_id) DO UPDATE SET assistant_message = EXCLUDED.assistant_message, updated_at = NOW();
INSERT INTO assistant_replies (scenario_id, user_message, assistant_message, is_active)
VALUES ('food', 'How do I order food without speaking Chinese?', 'Scan the QR code on your table — most restaurants use mobile ordering. Use picture menus or translation app camera mode. Point at what others are eating!', TRUE)
ON CONFLICT (scenario_id) DO UPDATE SET assistant_message = EXCLUDED.assistant_message, updated_at = NOW();
INSERT INTO assistant_replies (scenario_id, user_message, assistant_message, is_active)
VALUES ('subway', 'How do I use the Beijing subway?', 'Buy a transit card or use Alipay/WeChat transit QR at station gates. Lines are colour-coded; station names appear in English on newer lines. Avoid rush hour 7:30–9:30 and 17:30–19:30 if possible.', TRUE)
ON CONFLICT (scenario_id) DO UPDATE SET assistant_message = EXCLUDED.assistant_message, updated_at = NOW();
INSERT INTO assistant_replies (scenario_id, user_message, assistant_message, is_active)
VALUES ('didi', 'How do I use Didi as a foreigner?', 'Download Didi (滴滴出行) and link Alipay or WeChat Pay. Enable English in settings. You can paste your destination from a map app. Show the driver your hotel address in Chinese if needed.', TRUE)
ON CONFLICT (scenario_id) DO UPDATE SET assistant_message = EXCLUDED.assistant_message, updated_at = NOW();
INSERT INTO assistant_replies (scenario_id, user_message, assistant_message, is_active)
VALUES ('etiquette', 'What etiquette should I know in China?', 'Greet with a slight nod; handshakes are fine in business. Avoid loud voices in temples and museums. Gift-giving is appreciated but not required. Tipping is not expected except at some high-end hotels.', TRUE)
ON CONFLICT (scenario_id) DO UPDATE SET assistant_message = EXCLUDED.assistant_message, updated_at = NOW();
INSERT INTO assistant_replies (scenario_id, user_message, assistant_message, is_active)
VALUES ('great_wall', 'Which Great Wall section is best for first-timers?', 'Mutianyu balances scenery and crowds — cable car available. Badaling is closest to Beijing but busiest. Jinshanling is best for hiking if you have a full day. Book transport the night before.', TRUE)
ON CONFLICT (scenario_id) DO UPDATE SET assistant_message = EXCLUDED.assistant_message, updated_at = NOW();
INSERT INTO assistant_replies (scenario_id, user_message, assistant_message, is_active)
VALUES ('passport', 'I lost my passport. What should I do?', 'File a police report (110) and get a report number. Contact your embassy immediately for an emergency travel document. Keep copies of your passport and visa separately from the original.', TRUE)
ON CONFLICT (scenario_id) DO UPDATE SET assistant_message = EXCLUDED.assistant_message, updated_at = NOW();

-- visa_rules
INSERT INTO visa_rules (country_code, country_name, flag, visa_free, stay_days, headline, details, is_active)
VALUES ('GB', 'United Kingdom', '🇬🇧', TRUE, 30, 'Visa-free entry for 30 days', '[{"label":"Stay","value":"30 days per visit"},{"label":"Passport","value":"6+ months validity"},{"label":"Purpose","value":"Tourism, business, transit"},{"label":"Register","value":"Hotel registers you automatically"}]'::jsonb, TRUE)
ON CONFLICT (country_code) DO UPDATE SET headline = EXCLUDED.headline, details = EXCLUDED.details, updated_at = NOW();
INSERT INTO passport_countries (code, name, flag, display_order, is_active)
VALUES ('GB', 'United Kingdom', '🇬🇧', 0, TRUE)
ON CONFLICT (code) DO UPDATE SET name = EXCLUDED.name, flag = EXCLUDED.flag, display_order = EXCLUDED.display_order, updated_at = NOW();
INSERT INTO visa_rules (country_code, country_name, flag, visa_free, stay_days, headline, details, is_active)
VALUES ('US', 'United States', '🇺🇸', FALSE, NULL, 'Visa required before travel', '[{"label":"Type","value":"L visa (tourism)"},{"label":"Processing","value":"Apply at Chinese embassy"},{"label":"Stay","value":"As stated on visa"},{"label":"Tip","value":"Allow 2–4 weeks processing"}]'::jsonb, TRUE)
ON CONFLICT (country_code) DO UPDATE SET headline = EXCLUDED.headline, details = EXCLUDED.details, updated_at = NOW();
INSERT INTO passport_countries (code, name, flag, display_order, is_active)
VALUES ('US', 'United States', '🇺🇸', 1, TRUE)
ON CONFLICT (code) DO UPDATE SET name = EXCLUDED.name, flag = EXCLUDED.flag, display_order = EXCLUDED.display_order, updated_at = NOW();

-- emergency_config
INSERT INTO emergency_config (id, embassy_note, contacts)
VALUES ('global', 'Contact your embassy for lost passport assistance.', '[{"label":"Police","number":"110","note":"24/7 emergency"},{"label":"Ambulance","number":"120","note":"Medical emergency"}]'::jsonb)
ON CONFLICT (id) DO UPDATE SET embassy_note = EXCLUDED.embassy_note, contacts = EXCLUDED.contacts, updated_at = NOW();

-- content_itineraries (sample)
INSERT INTO content_itineraries (
  id, kind, title, meta, route_summary, estimated_budget, days, sort_order, is_active
) VALUES (
  'itin_sample_10day', 'sample', '10-Day Beijing → Shanghai', 'Jun 15 – 25, 2026 · Couple · $900–$1,400 est.',
  'Beijing 3d → Xi''an 2d → Shanghai 3d', '$900–$1,400',
  '[{"id":"day_1","day_index":1,"date_label":"Jun 15 · Monday","city_name":"Beijing","cost_estimate":"~$80–$130","activities":[{"id":"a1","time_slot":"AM","name":"Forbidden City","detail":"9:00 AM · 3–4 hrs · ¥60 · Book required","attraction_id":"beijing_forbidden_city","has_audio":true},{"id":"a2","time_slot":"PM","name":"Tiananmen Square → Nanluogu Xiang","detail":"1:30 PM · 2 hrs · Free entry · Walk","attraction_id":null,"has_audio":false},{"id":"a3","time_slot":"EVE","name":"Hutong dinner, Nanluogu Xiang","detail":"¥80–150 per person","attraction_id":null,"has_audio":false}]},{"id":"day_2","day_index":2,"date_label":"Jun 16 · Tuesday","city_name":"Beijing","cost_estimate":"~$60–$100","activities":[{"id":"a4","time_slot":"AM","name":"Temple of Heaven","detail":"8:00 AM · 2 hrs · ¥15 · Park walk","attraction_id":null,"has_audio":false},{"id":"a5","time_slot":"PM","name":"Summer Palace","detail":"2:00 PM · 3 hrs · ¥30 · Boat optional","attraction_id":null,"has_audio":false}]},{"id":"day_3","day_index":3,"date_label":"Jun 17 · Wednesday","city_name":"Beijing","cost_estimate":"~$90–$150","activities":[{"id":"a6","time_slot":"AM","name":"Mutianyu Great Wall","detail":"7:30 AM · Full day · ¥45 + cable car","attraction_id":null,"has_audio":false}]},{"id":"day_4","day_index":4,"date_label":"Jun 18 · Thursday","city_name":"Xi''an","cost_estimate":"~$70–$110","activities":[{"id":"a7","time_slot":"AM","name":"Terracotta Warriors","detail":"9:00 AM · 3 hrs · ¥120 · High-speed rail from Beijing","attraction_id":null,"has_audio":false},{"id":"a8","time_slot":"EVE","name":"Muslim Quarter street food","detail":"¥50–80 per person","attraction_id":null,"has_audio":false}]}]'::jsonb, 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title, meta = EXCLUDED.meta, days = EXCLUDED.days, updated_at = NOW();
-- content_itineraries (planning)
INSERT INTO content_itineraries (
  id, kind, title, meta, route_summary, estimated_budget, days, sort_order, is_active
) VALUES (
  'plan_beijing_4d', 'planning', 'Your Beijing Plan · 4 days', 'Jun 15–18 · Mid budget · History + Food',
  'Beijing', '$320–480',
  '[{"id":"pd1","day_index":1,"date_label":"Day 1 · Jun 15 · Beijing","city_name":"Beijing","cost_estimate":null,"activities":[{"id":"pa1","time_slot":"AM","name":"🏯 Forbidden City","detail":"9:00 AM · 3–4 hrs · ¥60 · Book ahead","attraction_id":"beijing_forbidden_city","has_audio":true},{"id":"pa2","time_slot":"PM","name":"🍜 Hutong lunch, Nanluogu Xiang","detail":"1:00 PM · ¥60–100","attraction_id":null,"has_audio":false},{"id":"pa3","time_slot":"EVE","name":"🛕 Temple of Heaven","detail":"3:30 PM · 2 hrs · ¥35","attraction_id":"beijing_temple_of_heaven","has_audio":true}]},{"id":"pd2","day_index":2,"date_label":"Day 2 · Jun 16 · Beijing","city_name":"Beijing","cost_estimate":null,"activities":[{"id":"pa4","time_slot":"AM","name":"🏔 Great Wall — Mutianyu","detail":"7:30 AM · Half day · ¥65","attraction_id":null,"has_audio":false}]}]'::jsonb, 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title, meta = EXCLUDED.meta, days = EXCLUDED.days, updated_at = NOW();

COMMIT;
