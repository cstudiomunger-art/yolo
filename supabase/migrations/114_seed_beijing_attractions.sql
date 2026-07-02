-- Seed: beijing attractions from Desktop Markdown
-- Text fields = verbatim English sections from source docs.
-- practical_info = Ticket / Duration / Opening Hours / Closed / Metro from MD sections.
-- Idempotent: ON CONFLICT (id) DO UPDATE

INSERT INTO attractions (
  id, city_id, name, chinese_name, category, cover_image_path, summary, introduction,
  priority, ticket_price, recommended_duration, opening_hours, closed_days,
  requires_advance_booking, metro_access, practical_info, western_visitor_tips, nearby_places,
  address_en, address_zh, audio_guide_count, iap_product_id, display_order, is_published
) VALUES (
  'beijing_forbidden_city', 'beijing', 'The Forbidden City (Palace Museum)', '故宫',
  'palace', 'attractions/beijing_forbidden_city.png', 'The largest and most completely preserved ancient wooden structural complex in the world, the royal palace of 24 emperors of the Ming and Qing dynasties. With red walls and yellow tiles, resplendent and magnificent, it is the highest symbol of five thousand years of Chinese civilization and the "cultural totem" in every Chinese person''s heart.', 'The Forbidden City is located in the center of Beijing, formerly known as the Purple Forbidden City. It was first built in the fourth year of the Yongle period of the Ming Dynasty (1406 AD), taking 14 years to complete.',
  'P0', '- Peak season (April 1-October 31): 60 RMB/person
- Off season (November 1-March 31 next year): 40 RMB/person
- Treasure Gallery: 10 RMB/person (recommended visit, where you can see the Nine Dragon Screen, Zhenfei Well, and various treasures)
- Clock and Watch Gallery: 10 RMB/person (recommended visit, where you can see various Chinese and foreign clocks and watches collected by the Qing court)
- Discounted Tickets: Students, seniors (over 60), military personnel, etc. can enjoy half-price or free admission with valid ID
- Important Note: The Forbidden City implements real-name staggered time slot reservation ticket purchase, which requires reservation on the official website (www.dpm.org.cn) or the "Palace Museum" WeChat Mini Program 10 days in advance; on-site ticket sales are no longer available; daily visitor flow is limited to 80,000 people, and tickets for holidays are extremely tight; it is recommended to plan your itinerary in advance and make reservations as early as possible', 'Note: Visiting the Forbidden City requires at least 3-4 hours; if you want to savor it carefully, it is recommended to allow a full day; recommended visiting route: Meridian Gate (entrance) → Wumen Square → Hall of Supreme Harmony → Hall of Central Harmony → Hall of Preserving Harmony → Palace of Heavenly Purity → Hall of Union → Palace of Earthly Tranquility → Imperial Garden → Gate of Divine Might (exit); it is recommended to arrange visiting the Treasure Gallery and Clock and Watch Gallery in the afternoon',
  '- Peak season (April 1-October 31): 08:30-17:00 (last entry at 16:00)
- Off season (November 1-March 31 next year): 08:30-16:30 (last entry at 15:30)
- Closed on Mondays (except for legal holidays)
- Note: Visiting the Forbidden City requires at least 3-4 hours; if you want to savor it carefully, it is recommended to allow a full day; recommended visiting route: Meridian Gate (entrance) → Wumen Square → Hall of Supreme Harmony → Hall of Central Harmony → Hall of Preserving Harmony → Palace of Heavenly Purity → Hall of Union → Palace of Earthly Tranquility → Imperial Garden → Gate of Divine Might (exit); it is recommended to arrange visiting the Treasure Gallery and Clock and Watch Gallery in the afternoon', 'Closed on Mondays (except for legal holidays)',
  TRUE, '- Rail Transit:
  - Subway Line 1: Get off at Tiananmen East Station, walk about 10 minutes from Exit A (Northwest Exit) to the Meridian Gate (Forbidden City entrance)
  - Subway Line 1: Get off at Tiananmen West Station, walk about 15 minutes from Exit B (Northeast Exit) to the Meridian Gate
- Bus:
  - Tiananmen East Station: Take buses 1, 2, 10, 20, 52, 59, 82, 90, 99, 120, 126, 203, 205, 210, 728, Special Line 1, Special Line 2, etc., get off and walk about 10 minutes
  - Tiananmen West Station: Take buses 1, 5, 10, 22, 52, 90, 99, 205, 728, etc., get off and walk about 15 minutes
- Taxi/Ride-hailing: Directly tell the driver "Forbidden City" or "Tiananmen"; after getting off, you need to walk to the Meridian Gate (Forbidden City entrance); Note: Roads around the Forbidden City are frequently under traffic control, and vehicles cannot reach the Meridian Gate directly
- Note: The entrance of the Forbidden City is at the Meridian Gate (south side), and the exit is at the Gate of Divine Might (north side); after finishing the visit, you can exit from the Gate of Divine Might, walk to Jingshan Park to overlook the panoramic view of the Forbidden City, or continue visiting places such as Shichahai and Nanluoguxiang; parking spaces around the Forbidden City are extremely tight; it is strongly recommended to take rail transit or bus',
  '[{"icon": "🎫", "label": "Ticket", "value": "- Peak season (April 1-October 31): 60 RMB/person\n- Off season (November 1-March 31 next year): 40 RMB/person\n- Treasure Gallery: 10 RMB/person (recommended visit, where you can see the Nine Dragon Screen, Zhenfei Well, and various treasures)\n- Clock and Watch Gallery: 10 RMB/person (recommended visit, where you can see various Chinese and foreign clocks and watches collected by the Qing court)\n- Discounted Tickets: Students, seniors (over 60), military personnel, etc. can enjoy half-price or free admission with valid ID\n- Important Note: The Forbidden City implements real-name staggered time slot reservation ticket purchase, which requires reservation on the official website (www.dpm.org.cn) or the \"Palace Museum\" WeChat Mini Program 10 days in advance; on-site ticket sales are no longer available; daily visitor flow is limited to 80,000 people, and tickets for holidays are extremely tight; it is recommended to plan your itinerary in advance and make reservations as early as possible"}, {"icon": "🕐", "label": "Duration", "value": "Note: Visiting the Forbidden City requires at least 3-4 hours; if you want to savor it carefully, it is recommended to allow a full day; recommended visiting route: Meridian Gate (entrance) → Wumen Square → Hall of Supreme Harmony → Hall of Central Harmony → Hall of Preserving Harmony → Palace of Heavenly Purity → Hall of Union → Palace of Earthly Tranquility → Imperial Garden → Gate of Divine Might (exit); it is recommended to arrange visiting the Treasure Gallery and Clock and Watch Gallery in the afternoon"}, {"icon": "🕘", "label": "Opening Hours", "value": "- Peak season (April 1-October 31): 08:30-17:00 (last entry at 16:00)\n- Off season (November 1-March 31 next year): 08:30-16:30 (last entry at 15:30)\n- Closed on Mondays (except for legal holidays)\n- Note: Visiting the Forbidden City requires at least 3-4 hours; if you want to savor it carefully, it is recommended to allow a full day; recommended visiting route: Meridian Gate (entrance) → Wumen Square → Hall of Supreme Harmony → Hall of Central Harmony → Hall of Preserving Harmony → Palace of Heavenly Purity → Hall of Union → Palace of Earthly Tranquility → Imperial Garden → Gate of Divine Might (exit); it is recommended to arrange visiting the Treasure Gallery and Clock and Watch Gallery in the afternoon"}, {"icon": "❌", "label": "Closed", "value": "Closed on Mondays (except for legal holidays)"}, {"icon": "🚇", "label": "Metro", "value": "- Rail Transit:\n  - Subway Line 1: Get off at Tiananmen East Station, walk about 10 minutes from Exit A (Northwest Exit) to the Meridian Gate (Forbidden City entrance)\n  - Subway Line 1: Get off at Tiananmen West Station, walk about 15 minutes from Exit B (Northeast Exit) to the Meridian Gate\n- Bus:\n  - Tiananmen East Station: Take buses 1, 2, 10, 20, 52, 59, 82, 90, 99, 120, 126, 203, 205, 210, 728, Special Line 1, Special Line 2, etc., get off and walk about 10 minutes\n  - Tiananmen West Station: Take buses 1, 5, 10, 22, 52, 90, 99, 205, 728, etc., get off and walk about 15 minutes\n- Taxi/Ride-hailing: Directly tell the driver \"Forbidden City\" or \"Tiananmen\"; after getting off, you need to walk to the Meridian Gate (Forbidden City entrance); Note: Roads around the Forbidden City are frequently under traffic control, and vehicles cannot reach the Meridian Gate directly\n- Note: The entrance of the Forbidden City is at the Meridian Gate (south side), and the exit is at the Gate of Divine Might (north side); after finishing the visit, you can exit from the Gate of Divine Might, walk to Jingshan Park to overlook the panoramic view of the Forbidden City, or continue visiting places such as Shichahai and Nanluoguxiang; parking spaces around the Forbidden City are extremely tight; it is strongly recommended to take rail transit or bus"}]'::jsonb, '[]'::jsonb, '[]'::jsonb,
  'No. 4 Jingshan Front Street, Dongcheng District, Beijing (north side of Tiananmen Square)', '北京市东城区景山前街4号（天安门广场北侧）',
  0, 'com.chinago.travel.attraction.beijing_forbidden_city', 0, TRUE
) ON CONFLICT (id) DO UPDATE SET
  city_id = EXCLUDED.city_id, name = EXCLUDED.name, chinese_name = EXCLUDED.chinese_name,
  category = EXCLUDED.category, cover_image_path = EXCLUDED.cover_image_path,
  summary = EXCLUDED.summary, introduction = EXCLUDED.introduction,
  priority = EXCLUDED.priority, ticket_price = EXCLUDED.ticket_price,
  recommended_duration = EXCLUDED.recommended_duration, opening_hours = EXCLUDED.opening_hours,
  closed_days = EXCLUDED.closed_days, requires_advance_booking = EXCLUDED.requires_advance_booking,
  metro_access = EXCLUDED.metro_access, practical_info = EXCLUDED.practical_info,
  western_visitor_tips = EXCLUDED.western_visitor_tips, nearby_places = EXCLUDED.nearby_places,
  address_en = EXCLUDED.address_en, address_zh = EXCLUDED.address_zh,
  audio_guide_count = EXCLUDED.audio_guide_count, iap_product_id = EXCLUDED.iap_product_id,
  display_order = EXCLUDED.display_order, is_published = EXCLUDED.is_published, updated_at = NOW();

INSERT INTO attractions (
  id, city_id, name, chinese_name, category, cover_image_path, summary, introduction,
  priority, ticket_price, recommended_duration, opening_hours, closed_days,
  requires_advance_booking, metro_access, practical_info, western_visitor_tips, nearby_places,
  address_en, address_zh, audio_guide_count, iap_product_id, display_order, is_published
) VALUES (
  'beijing_temple_of_heaven', 'beijing', 'Temple of Heaven', '天坛',
  'temple', 'attractions/beijing_temple_of_heaven.png', 'The sacred site where emperors of the Ming and Qing dynasties offered sacrifices to heaven and prayed for good harvests. With the "round heaven and square earth" cosmology as its design soul, the triple-tiered blue-tiled circular roof of the Hall of Prayer for Good Harvests, the acoustic wonder of the Echo Wall, and the ninefold heavenly intent of the Circular Mound Altar together compose a magnificent architectural epic of "dialogue between man and heaven."', 'The Temple of Heaven is located on the east side of Yongdingmen Inner Street in Dongcheng District, Beijing.',
  'P0', '- Peak season (April 1-October 31): 15 RMB/person (including Hall of Prayer for Good Harvests, Echo Wall, Circular Mound Altar)
- Off season (November 1-March 31 next year): 10 RMB/person (including Hall of Prayer for Good Harvests, Echo Wall, Circular Mound Altar)
- Hall of Prayer for Good Harvests, Echo Wall, Circular Mound Altar: Separate tickets required for entry (already included in combo ticket)
- Discounted Tickets: Students, seniors (over 60), military personnel, etc. can enjoy half-price or free admission with valid ID
- Note: It is recommended to purchase tickets in advance on the official website or WeChat account for discounts and to avoid on-site queuing; Tiantan covers a large area, so it is recommended to allow 2-3 hours for visiting; if you want to experience the leisure life of old Beijing citizens, it is recommended to go in the early morning or evening', NULL,
  '- Peak season (April 1-October 31): 06:00-21:00 (attraction ticket sales deadline is 20:00, last entry at 17:30)
- Off season (November 1-March 31 next year): 06:30-21:00 (attraction ticket sales deadline is 19:00, last entry at 16:30)
- Opening hours for Hall of Prayer for Good Harvests, Echo Wall, Circular Mound Altar: 08:00-17:30 (peak season) / 08:00-17:00 (off season)
- Note: The best visiting time for Tiantan is early morning or evening, when you can avoid tour groups and experience the leisure life of old Beijing citizens; there will be a light show at the Hall of Prayer for Good Harvests at night (separate ticket purchase required), which is an excellent spot for taking photos and checking in', NULL,
  FALSE, '- Rail Transit:
  - Subway Line 5: Get off at Tiantan East Gate Station, exit from Exit A (Northwest Exit) or Exit B (Southeast Exit) to reach Tiantan East Gate directly
  - Subway Line 14: Get off at Jingtai Station, walk about 10 minutes from Exit C (Southeast Exit) to Tiantan South Gate
  - Subway Line 8: Get off at Tianqiao Station, walk about 15 minutes from Exit A (Northwest Exit) to Tiantan West Gate
- Bus:
  - Tiantan East Gate Station: Take buses 6, 34, 35, 36, 39, 41, 43, 60, 116, 128, 525, 610, 684, 685, 707, 814, 958, Special 11, Special 30, etc., get off and arrive directly
  - Tiantan South Gate Station: Take buses 53, 122, 525, 830, 958, Special 3, Special 11, Special 30, etc., get off and arrive directly
  - Tiantan West Gate Station: Take buses 2, 20, 35, 36, 69, 71, 93, 120, 210, 610, 707, 729, 814, Special 11, etc., get off and arrive directly
  - Tiantan North Gate Station: Take buses 6, 34, 35, 36, 72, 106, 110, 687, 707, 743, 814, Special 11, etc., get off and arrive directly
- Taxi/Ride-hailing: Directly tell the driver "Tiantan"; you will arrive directly; it is recommended to enter from the East Gate or South Gate
- Note: Transportation around Tiantan is extremely convenient, with dense rail transit and bus routes; it is strongly recommended to take public transportation; Tiantan has multiple entrances, and you can choose the most convenient entrance to enter according to your subsequent itinerary arrangements',
  '[{"icon": "🎫", "label": "Ticket", "value": "- Peak season (April 1-October 31): 15 RMB/person (including Hall of Prayer for Good Harvests, Echo Wall, Circular Mound Altar)\n- Off season (November 1-March 31 next year): 10 RMB/person (including Hall of Prayer for Good Harvests, Echo Wall, Circular Mound Altar)\n- Hall of Prayer for Good Harvests, Echo Wall, Circular Mound Altar: Separate tickets required for entry (already included in combo ticket)\n- Discounted Tickets: Students, seniors (over 60), military personnel, etc. can enjoy half-price or free admission with valid ID\n- Note: It is recommended to purchase tickets in advance on the official website or WeChat account for discounts and to avoid on-site queuing; Tiantan covers a large area, so it is recommended to allow 2-3 hours for visiting; if you want to experience the leisure life of old Beijing citizens, it is recommended to go in the early morning or evening"}, {"icon": "🕘", "label": "Opening Hours", "value": "- Peak season (April 1-October 31): 06:00-21:00 (attraction ticket sales deadline is 20:00, last entry at 17:30)\n- Off season (November 1-March 31 next year): 06:30-21:00 (attraction ticket sales deadline is 19:00, last entry at 16:30)\n- Opening hours for Hall of Prayer for Good Harvests, Echo Wall, Circular Mound Altar: 08:00-17:30 (peak season) / 08:00-17:00 (off season)\n- Note: The best visiting time for Tiantan is early morning or evening, when you can avoid tour groups and experience the leisure life of old Beijing citizens; there will be a light show at the Hall of Prayer for Good Harvests at night (separate ticket purchase required), which is an excellent spot for taking photos and checking in"}, {"icon": "🚇", "label": "Metro", "value": "- Rail Transit:\n  - Subway Line 5: Get off at Tiantan East Gate Station, exit from Exit A (Northwest Exit) or Exit B (Southeast Exit) to reach Tiantan East Gate directly\n  - Subway Line 14: Get off at Jingtai Station, walk about 10 minutes from Exit C (Southeast Exit) to Tiantan South Gate\n  - Subway Line 8: Get off at Tianqiao Station, walk about 15 minutes from Exit A (Northwest Exit) to Tiantan West Gate\n- Bus:\n  - Tiantan East Gate Station: Take buses 6, 34, 35, 36, 39, 41, 43, 60, 116, 128, 525, 610, 684, 685, 707, 814, 958, Special 11, Special 30, etc., get off and arrive directly\n  - Tiantan South Gate Station: Take buses 53, 122, 525, 830, 958, Special 3, Special 11, Special 30, etc., get off and arrive directly\n  - Tiantan West Gate Station: Take buses 2, 20, 35, 36, 69, 71, 93, 120, 210, 610, 707, 729, 814, Special 11, etc., get off and arrive directly\n  - Tiantan North Gate Station: Take buses 6, 34, 35, 36, 72, 106, 110, 687, 707, 743, 814, Special 11, etc., get off and arrive directly\n- Taxi/Ride-hailing: Directly tell the driver \"Tiantan\"; you will arrive directly; it is recommended to enter from the East Gate or South Gate\n- Note: Transportation around Tiantan is extremely convenient, with dense rail transit and bus routes; it is strongly recommended to take public transportation; Tiantan has multiple entrances, and you can choose the most convenient entrance to enter according to your subsequent itinerary arrangements"}]'::jsonb, '[]'::jsonb, '[]'::jsonb,
  'No. 7 Tiantan Neidong Li, Dongcheng District, Beijing (east side of Yongdingmen Inner Street)', '北京市东城区天坛内东里7号（永定门内大街东侧）',
  0, 'com.chinago.travel.attraction.beijing_temple_of_heaven', 1, TRUE
) ON CONFLICT (id) DO UPDATE SET
  city_id = EXCLUDED.city_id, name = EXCLUDED.name, chinese_name = EXCLUDED.chinese_name,
  category = EXCLUDED.category, cover_image_path = EXCLUDED.cover_image_path,
  summary = EXCLUDED.summary, introduction = EXCLUDED.introduction,
  priority = EXCLUDED.priority, ticket_price = EXCLUDED.ticket_price,
  recommended_duration = EXCLUDED.recommended_duration, opening_hours = EXCLUDED.opening_hours,
  closed_days = EXCLUDED.closed_days, requires_advance_booking = EXCLUDED.requires_advance_booking,
  metro_access = EXCLUDED.metro_access, practical_info = EXCLUDED.practical_info,
  western_visitor_tips = EXCLUDED.western_visitor_tips, nearby_places = EXCLUDED.nearby_places,
  address_en = EXCLUDED.address_en, address_zh = EXCLUDED.address_zh,
  audio_guide_count = EXCLUDED.audio_guide_count, iap_product_id = EXCLUDED.iap_product_id,
  display_order = EXCLUDED.display_order, is_published = EXCLUDED.is_published, updated_at = NOW();

INSERT INTO attractions (
  id, city_id, name, chinese_name, category, cover_image_path, summary, introduction,
  priority, ticket_price, recommended_duration, opening_hours, closed_days,
  requires_advance_booking, metro_access, practical_info, western_visitor_tips, nearby_places,
  address_en, address_zh, audio_guide_count, iap_product_id, display_order, is_published
) VALUES (
  'beijing_summer_palace', 'beijing', 'Summer Palace', '颐和园',
  'garden', 'attractions/beijing_summer_palace.png', '"The Museum of Imperial Gardens," built on the basis of Kunming Lake and Longevity Hill, absorbing the essence of Jiangnan gardens and bringing together the quintessence of garden art from across the country. The colored paintings of the Long Corridor, the towering majesty of the Buddha Fragrance Pavilion, and the graceful elegance of the Seventeen-Arch Bridge together paint an iconic long scroll of landscape poetry.', 'The Summer Palace is located in Haidian District, Beijing, about 15 kilometers from Beijing urban area, about 40-60 minutes'' drive.',
  'P0', '- Peak season (April 1-October 31): 30 RMB/person
- Off season (November 1-March 31 next year): 20 RMB/person
- Deheyuan (Crosstellane): 5 RMB/person
- Buddha Fragrance Pavilion: 10 RMB/person
- Suzhou Street: 10 RMB/person
- Summer Palace Museum: 20 RMB/person
- Combo Ticket (including park ticket + Deheyuan + Buddha Fragrance Pavilion + Suzhou Street + Summer Palace Museum): Peak season 60 RMB/person; Off season 50 RMB/person (recommended, high cost-performance)
- Discounted Tickets: Students, seniors (over 60), military personnel, etc. can enjoy half-price or free admission with valid ID
- Note: It is recommended to purchase tickets in advance on the official website or WeChat account for discounts and to avoid on-site queuing; the Summer Palace covers a large area, so it is recommended to allow at least 3-4 hours for visiting, and it is best to arrange a full day if you want to savor it carefully', NULL,
  '- Peak season (April 1-October 31): 06:30-18:00 (last entry at 17:00)
- Off season (November 1-March 31 next year): 07:00-17:00 (last entry at 16:00)
- Gardens within the Garden (Buddha Fragrance Pavilion, Deheyuan, Suzhou Street, Summer Palace Museum): 08:30-17:00 (peak season) / 09:00-16:00 (off season)
- Note: The best visiting time for the Summer Palace is spring (April-May) and autumn (September-October), with hundreds of flowers in spring and red leaves in autumn; in summer, you can take a boat to tour Kunming Lake, but need to pay attention to heat prevention; in winter, you can experience ice cariage, but some water-related attractions may be closed', NULL,
  FALSE, '- Rail Transit:
  - Subway Line 4: Get off at Xiyuan Station, walk about 10 minutes from Exit C2 (Southeast Exit) to the Summer Palace New Jian Gongmen (New Palace Gate)
  - Subway Line 4: Get off at Beigongmen Station, exit from Exit A (Northwest Exit) or Exit B (Northeast Exit) to reach the Summer Palace Beigongmen (North Palace Gate) directly
  - Subway Line 10: Get off at Bago Station, transfer to the Xijiao Line (tram) to the Summer Palace West Gate Station, to reach the Summer Palace West Gate directly
- Bus:
  - Summer Palace New Jian Gongmen Station: Take buses 303, 332, 346, 384, 394, 563, 584, 594, 601, 608, 683, 718, 731, 737, 808, 817, 921, 932, Special 5, Special 10, Yuntong 106 Line, Yuntong 108 Line, Yuntong 114 Line, etc., get off and arrive directly
  - Summer Palace Beigongmen Station: Take buses 303, 330, 331, 346, 375, 384, 563, 601, 608, 683, 718, 731, 737, 808, 817, 921, 932, Special 5, Special 10, Yuntong 106 Line, Yuntong 108 Line, Yuntong 114 Line, etc., get off and arrive directly
  - Summer Palace Donggongmen Station: Take buses 726, 808, 817, 921, 932, Special 5, Yuntong 106 Line, Yuntong 108 Line, etc., get off and arrive directly
- Taxi/Ride-hailing: Directly tell the driver "Summer Palace"; you will arrive directly; it is recommended to enter from the New Jian Gongmen or Beigongmen
- Note: The Summer Palace has multiple entrances, and you can choose the most convenient entrance to enter according to your subsequent itinerary arrangements; roads in the surrounding area are extremely prone to congestion on weekends and holidays, and parking spaces are tight; it is strongly recommended to take rail transit or bus; entering from Beigongmen is closest to the Buddha Fragrance Pavilion',
  '[{"icon": "🎫", "label": "Ticket", "value": "- Peak season (April 1-October 31): 30 RMB/person\n- Off season (November 1-March 31 next year): 20 RMB/person\n- Deheyuan (Crosstellane): 5 RMB/person\n- Buddha Fragrance Pavilion: 10 RMB/person\n- Suzhou Street: 10 RMB/person\n- Summer Palace Museum: 20 RMB/person\n- Combo Ticket (including park ticket + Deheyuan + Buddha Fragrance Pavilion + Suzhou Street + Summer Palace Museum): Peak season 60 RMB/person; Off season 50 RMB/person (recommended, high cost-performance)\n- Discounted Tickets: Students, seniors (over 60), military personnel, etc. can enjoy half-price or free admission with valid ID\n- Note: It is recommended to purchase tickets in advance on the official website or WeChat account for discounts and to avoid on-site queuing; the Summer Palace covers a large area, so it is recommended to allow at least 3-4 hours for visiting, and it is best to arrange a full day if you want to savor it carefully"}, {"icon": "🕘", "label": "Opening Hours", "value": "- Peak season (April 1-October 31): 06:30-18:00 (last entry at 17:00)\n- Off season (November 1-March 31 next year): 07:00-17:00 (last entry at 16:00)\n- Gardens within the Garden (Buddha Fragrance Pavilion, Deheyuan, Suzhou Street, Summer Palace Museum): 08:30-17:00 (peak season) / 09:00-16:00 (off season)\n- Note: The best visiting time for the Summer Palace is spring (April-May) and autumn (September-October), with hundreds of flowers in spring and red leaves in autumn; in summer, you can take a boat to tour Kunming Lake, but need to pay attention to heat prevention; in winter, you can experience ice cariage, but some water-related attractions may be closed"}, {"icon": "🚇", "label": "Metro", "value": "- Rail Transit:\n  - Subway Line 4: Get off at Xiyuan Station, walk about 10 minutes from Exit C2 (Southeast Exit) to the Summer Palace New Jian Gongmen (New Palace Gate)\n  - Subway Line 4: Get off at Beigongmen Station, exit from Exit A (Northwest Exit) or Exit B (Northeast Exit) to reach the Summer Palace Beigongmen (North Palace Gate) directly\n  - Subway Line 10: Get off at Bago Station, transfer to the Xijiao Line (tram) to the Summer Palace West Gate Station, to reach the Summer Palace West Gate directly\n- Bus:\n  - Summer Palace New Jian Gongmen Station: Take buses 303, 332, 346, 384, 394, 563, 584, 594, 601, 608, 683, 718, 731, 737, 808, 817, 921, 932, Special 5, Special 10, Yuntong 106 Line, Yuntong 108 Line, Yuntong 114 Line, etc., get off and arrive directly\n  - Summer Palace Beigongmen Station: Take buses 303, 330, 331, 346, 375, 384, 563, 601, 608, 683, 718, 731, 737, 808, 817, 921, 932, Special 5, Special 10, Yuntong 106 Line, Yuntong 108 Line, Yuntong 114 Line, etc., get off and arrive directly\n  - Summer Palace Donggongmen Station: Take buses 726, 808, 817, 921, 932, Special 5, Yuntong 106 Line, Yuntong 108 Line, etc., get off and arrive directly\n- Taxi/Ride-hailing: Directly tell the driver \"Summer Palace\"; you will arrive directly; it is recommended to enter from the New Jian Gongmen or Beigongmen\n- Note: The Summer Palace has multiple entrances, and you can choose the most convenient entrance to enter according to your subsequent itinerary arrangements; roads in the surrounding area are extremely prone to congestion on weekends and holidays, and parking spaces are tight; it is strongly recommended to take rail transit or bus; entering from Beigongmen is closest to the Buddha Fragrance Pavilion"}]'::jsonb, '[]'::jsonb, '[]'::jsonb,
  'No. 19 Xinjiangongmen Road, Haidian District, Beijing (central part of Haidian District, outside the Fourth Ring Road)', '北京市海淀区新建宫门路19号（海淀区中部，四环外）',
  0, 'com.chinago.travel.attraction.beijing_summer_palace', 2, TRUE
) ON CONFLICT (id) DO UPDATE SET
  city_id = EXCLUDED.city_id, name = EXCLUDED.name, chinese_name = EXCLUDED.chinese_name,
  category = EXCLUDED.category, cover_image_path = EXCLUDED.cover_image_path,
  summary = EXCLUDED.summary, introduction = EXCLUDED.introduction,
  priority = EXCLUDED.priority, ticket_price = EXCLUDED.ticket_price,
  recommended_duration = EXCLUDED.recommended_duration, opening_hours = EXCLUDED.opening_hours,
  closed_days = EXCLUDED.closed_days, requires_advance_booking = EXCLUDED.requires_advance_booking,
  metro_access = EXCLUDED.metro_access, practical_info = EXCLUDED.practical_info,
  western_visitor_tips = EXCLUDED.western_visitor_tips, nearby_places = EXCLUDED.nearby_places,
  address_en = EXCLUDED.address_en, address_zh = EXCLUDED.address_zh,
  audio_guide_count = EXCLUDED.audio_guide_count, iap_product_id = EXCLUDED.iap_product_id,
  display_order = EXCLUDED.display_order, is_published = EXCLUDED.is_published, updated_at = NOW();

INSERT INTO attractions (
  id, city_id, name, chinese_name, category, cover_image_path, summary, introduction,
  priority, ticket_price, recommended_duration, opening_hours, closed_days,
  requires_advance_booking, metro_access, practical_info, western_visitor_tips, nearby_places,
  address_en, address_zh, audio_guide_count, iap_product_id, display_order, is_published
) VALUES (
  'beijing_national_museum', 'beijing', 'National Museum of China', '国博',
  'museum', 'attractions/beijing_national_museum.png', 'One of the largest museums in the world, collecting over 1.4 million artifacts spanning China''s general history. From the teeth of Yuanmou Man to the contemporary achievements of the "Road to Rejuvenation," it is a "standing five-thousand-year civilization history of China."', 'The National Museum of China (abbreviated as "National Museum") is located on the east side of Tiananmen Square in the center of Beijing, facing the Great Hall of the People to the east and west.',
  'P0', '- Admission: Free admission (advance reservation required)
- Special Exhibitions: Some special exhibitions may charge separately (about 30-50 RMB/person)
- Guide Service: Chinese guide about 200-300 RMB/group; English guide about 300-400 RMB/group; electronic guide device rental also available (about 20-30 RMB/unit) or download the "National Museum" APP to use free audio guide
- Important Note: The National Museum implements real-name reservation for visiting, which requires reservation on the official website (www.chnmuseum.cn) or the "National Museum" WeChat account/Mini Program 7 days in advance. Each day is divided into morning session (09:00-13:00) and afternoon session (13:00-17:00), and reservations close once full; valid ID must be brought when entering the museum, and security checks are required', 'Note: Visiting the National Museum requires at least 3-4 hours; if you want to visit all exhibition halls carefully, it is recommended to allow a full day; it is recommended to prioritize visiting the two major basic exhibitions "Ancient China" and "Road to Rejuvenation"; visitor flow is larger on weekends and holidays, so weekday visits are recommended',
  '- Tuesday to Sunday: 09:00-17:00 (last entry at 16:30)
- Closed on Mondays (except for legal holidays)
- Note: Visiting the National Museum requires at least 3-4 hours; if you want to visit all exhibition halls carefully, it is recommended to allow a full day; it is recommended to prioritize visiting the two major basic exhibitions "Ancient China" and "Road to Rejuvenation"; visitor flow is larger on weekends and holidays, so weekday visits are recommended', 'Closed on Mondays (except for legal holidays)',
  TRUE, '- Rail Transit:
  - Subway Line 1: Get off at Tiananmen East Station, walk about 5 minutes from Exit C (Southwest Exit) or Exit D (Northwest Exit)
  - Subway Line 2: Get off at Qianmen Station, walk about 10 minutes from Exit A (Northeast Exit)
- Bus:
  - Tiananmen East Station: Take buses 1, 2, 10, 20, 52, 59, 82, 90, 99, 120, 126, 203, 205, 210, 728, Special Line 1, Special Line 2, etc., get off and arrive directly
  - Qianmen Station: Take buses 5, 8, 17, 22, 48, 59, 66, 67, 69, 71, 82, 93, 120, 126, 301, 337, 608, 623, Special 4, Special 7, BRT Line 1, etc., get off and walk about 10 minutes
- Taxi/Ride-hailing: Directly tell the driver "National Museum" or "east side of Tiananmen Square"; you will arrive directly
- Note: The National Museum is located on the east side of Tiananmen Square; roads in the surrounding area are frequently under traffic control, and parking spaces are extremely tight; it is strongly recommended to take rail transit or bus; after visiting the National Museum, you can顺便 visit attractions such as Tiananmen Square, the Forbidden City, Zhongshan Park, and Beihai Park',
  '[{"icon": "🎫", "label": "Ticket", "value": "- Admission: Free admission (advance reservation required)\n- Special Exhibitions: Some special exhibitions may charge separately (about 30-50 RMB/person)\n- Guide Service: Chinese guide about 200-300 RMB/group; English guide about 300-400 RMB/group; electronic guide device rental also available (about 20-30 RMB/unit) or download the \"National Museum\" APP to use free audio guide\n- Important Note: The National Museum implements real-name reservation for visiting, which requires reservation on the official website (www.chnmuseum.cn) or the \"National Museum\" WeChat account/Mini Program 7 days in advance. Each day is divided into morning session (09:00-13:00) and afternoon session (13:00-17:00), and reservations close once full; valid ID must be brought when entering the museum, and security checks are required"}, {"icon": "🕐", "label": "Duration", "value": "Note: Visiting the National Museum requires at least 3-4 hours; if you want to visit all exhibition halls carefully, it is recommended to allow a full day; it is recommended to prioritize visiting the two major basic exhibitions \"Ancient China\" and \"Road to Rejuvenation\"; visitor flow is larger on weekends and holidays, so weekday visits are recommended"}, {"icon": "🕘", "label": "Opening Hours", "value": "- Tuesday to Sunday: 09:00-17:00 (last entry at 16:30)\n- Closed on Mondays (except for legal holidays)\n- Note: Visiting the National Museum requires at least 3-4 hours; if you want to visit all exhibition halls carefully, it is recommended to allow a full day; it is recommended to prioritize visiting the two major basic exhibitions \"Ancient China\" and \"Road to Rejuvenation\"; visitor flow is larger on weekends and holidays, so weekday visits are recommended"}, {"icon": "❌", "label": "Closed", "value": "Closed on Mondays (except for legal holidays)"}, {"icon": "🚇", "label": "Metro", "value": "- Rail Transit:\n  - Subway Line 1: Get off at Tiananmen East Station, walk about 5 minutes from Exit C (Southwest Exit) or Exit D (Northwest Exit)\n  - Subway Line 2: Get off at Qianmen Station, walk about 10 minutes from Exit A (Northeast Exit)\n- Bus:\n  - Tiananmen East Station: Take buses 1, 2, 10, 20, 52, 59, 82, 90, 99, 120, 126, 203, 205, 210, 728, Special Line 1, Special Line 2, etc., get off and arrive directly\n  - Qianmen Station: Take buses 5, 8, 17, 22, 48, 59, 66, 67, 69, 71, 82, 93, 120, 126, 301, 337, 608, 623, Special 4, Special 7, BRT Line 1, etc., get off and walk about 10 minutes\n- Taxi/Ride-hailing: Directly tell the driver \"National Museum\" or \"east side of Tiananmen Square\"; you will arrive directly\n- Note: The National Museum is located on the east side of Tiananmen Square; roads in the surrounding area are frequently under traffic control, and parking spaces are extremely tight; it is strongly recommended to take rail transit or bus; after visiting the National Museum, you can顺便 visit attractions such as Tiananmen Square, the Forbidden City, Zhongshan Park, and Beihai Park"}]'::jsonb, '[]'::jsonb, '[]'::jsonb,
  'No. 16 East Chang''an Street, Dongcheng District, Beijing (east side of Tiananmen Square, opposite the Great Hall of the People)', '北京市东城区东长安街16号（天安门广场东侧，人民大会堂对面）',
  0, 'com.chinago.travel.attraction.beijing_national_museum', 3, TRUE
) ON CONFLICT (id) DO UPDATE SET
  city_id = EXCLUDED.city_id, name = EXCLUDED.name, chinese_name = EXCLUDED.chinese_name,
  category = EXCLUDED.category, cover_image_path = EXCLUDED.cover_image_path,
  summary = EXCLUDED.summary, introduction = EXCLUDED.introduction,
  priority = EXCLUDED.priority, ticket_price = EXCLUDED.ticket_price,
  recommended_duration = EXCLUDED.recommended_duration, opening_hours = EXCLUDED.opening_hours,
  closed_days = EXCLUDED.closed_days, requires_advance_booking = EXCLUDED.requires_advance_booking,
  metro_access = EXCLUDED.metro_access, practical_info = EXCLUDED.practical_info,
  western_visitor_tips = EXCLUDED.western_visitor_tips, nearby_places = EXCLUDED.nearby_places,
  address_en = EXCLUDED.address_en, address_zh = EXCLUDED.address_zh,
  audio_guide_count = EXCLUDED.audio_guide_count, iap_product_id = EXCLUDED.iap_product_id,
  display_order = EXCLUDED.display_order, is_published = EXCLUDED.is_published, updated_at = NOW();

INSERT INTO attractions (
  id, city_id, name, chinese_name, category, cover_image_path, summary, introduction,
  priority, ticket_price, recommended_duration, opening_hours, closed_days,
  requires_advance_booking, metro_access, practical_info, western_visitor_tips, nearby_places,
  address_en, address_zh, audio_guide_count, iap_product_id, display_order, is_published
) VALUES (
  'beijing_mutianyu_great_wall', 'beijing', 'Mutianyu Great Wall', '慕田峪长城',
  'wall', 'attractions/beijing_mutianyu_great_wall.png', '"Of the ten-thousand-li Great Wall, Mutianyu stands out alone." This well-preserved section of the Ming Great Wall is famous for its dense watchtowers, beautiful mountain forest scenery, and as a filming location for "If You Are the One 2." It offers a more tranquil and pristine Great Wall experience than Badaling.', 'Mutianyu Great Wall is located in Huairou District, Beijing, about 90 kilometers from Beijing urban area, about 1.5-2 hours'' drive.',
  'P0', '- Admission: 45 RMB/person
- Cable Car: Round-trip 120 RMB/person; One-way 100 RMB/person (recommended, saves physical strength)
- Chairlift: Round-trip 120 RMB/person; One-way 100 RMB/person
- Alpine Slide (Toboggan): 100 RMB/person (strongly recommended, unique experience of sliding down from the Great Wall)
- Discounted Tickets: Students, seniors (over 60), military personnel, etc. can enjoy half-price or free admission with valid ID
- Combo Ticket: Admission + round-trip cable car + alpine slide, about 260 RMB/person (relatively cost-effective)
- Note: It is recommended to purchase admission and chairlift/cable car tickets in advance on the official website or travel platforms for discounts and to avoid on-site queuing; visitor flow is larger on weekends and holidays, so weekday visits are recommended', 'Note: Visiting Mutianyu Great Wall takes about 3-4 hours (including cable car up and down the mountain and Great Wall strolling); it is recommended to go in the morning to avoid the tour group peak in the afternoon; autumn (mid-October to early November) is the most beautiful season for Mutianyu Great Wall, with red leaves covering the mountains and layers of forests dyed',
  '- April 1-October 31: 07:30-18:00 (last entry at 17:00)
- November 1-March 31 next year: 08:00-17:30 (last entry at 16:30)
- Cable Car/Chairlift/Alpine Slide operating hours: Usually synchronized with the scenic area''s opening hours, but may be temporarily closed due to weather conditions
- Note: Visiting Mutianyu Great Wall takes about 3-4 hours (including cable car up and down the mountain and Great Wall strolling); it is recommended to go in the morning to avoid the tour group peak in the afternoon; autumn (mid-October to early November) is the most beautiful season for Mutianyu Great Wall, with red leaves covering the mountains and layers of forests dyed', NULL,
  FALSE, '- Self-driving:
  - Route: Depart from Beijing urban area, drive along the Beijing-Chengde Expressway (G45) to Exit 13 (Beitai Road/Huairou Urban Area Exit), drive along Huaihuang Road (X009) to the Mutianyu Roundabout, follow signs to the scenic area parking lot, about 1.5-2 hours'' drive
  - Parking: The scenic area has a large parking lot; parking fee is about 20 RMB/vehicle (small car)
- Public Transportation:
  - There is no direct rail transit or bus from Beijing urban area to Mutianyu Great Wall. The most common options are:
    1. Take subway or bus from Beijing urban area to Dongzhimen Hub Station, transfer to the "Mutianyu Great Wall Tourist Special Line" bus (about 20-30 RMB/person, about 1.5-2 hours'' drive; special line buses usually only operate from spring to autumn, and may suspend service in winter)
    2. Sign up for a Mutianyu Great Wall one-day tour group in Beijing urban area (about 150-300 RMB/person, including round-trip transportation, admission, tour guide)
    3. Take urban rail transit to Huairou North Station, then transfer to bus or taxi to Mutianyu Great Wall (more troublesome, not recommended)
- Taxi/Ride-hailing: Taking a taxi from Beijing urban area to Mutianyu Great Wall costs about 250-350 RMB one-way (excluding return trip), suitable for visitors traveling in groups
- Note: Mutianyu Great Wall is far from Beijing urban area and inconvenient for transportation; it is strongly recommended to plan round-trip transportation in advance; if you choose to take the tourist special line bus, be sure to remember the return assembly time and place clearly to avoid missing the last bus',
  '[{"icon": "🎫", "label": "Ticket", "value": "- Admission: 45 RMB/person\n- Cable Car: Round-trip 120 RMB/person; One-way 100 RMB/person (recommended, saves physical strength)\n- Chairlift: Round-trip 120 RMB/person; One-way 100 RMB/person\n- Alpine Slide (Toboggan): 100 RMB/person (strongly recommended, unique experience of sliding down from the Great Wall)\n- Discounted Tickets: Students, seniors (over 60), military personnel, etc. can enjoy half-price or free admission with valid ID\n- Combo Ticket: Admission + round-trip cable car + alpine slide, about 260 RMB/person (relatively cost-effective)\n- Note: It is recommended to purchase admission and chairlift/cable car tickets in advance on the official website or travel platforms for discounts and to avoid on-site queuing; visitor flow is larger on weekends and holidays, so weekday visits are recommended"}, {"icon": "🕐", "label": "Duration", "value": "Note: Visiting Mutianyu Great Wall takes about 3-4 hours (including cable car up and down the mountain and Great Wall strolling); it is recommended to go in the morning to avoid the tour group peak in the afternoon; autumn (mid-October to early November) is the most beautiful season for Mutianyu Great Wall, with red leaves covering the mountains and layers of forests dyed"}, {"icon": "🕘", "label": "Opening Hours", "value": "- April 1-October 31: 07:30-18:00 (last entry at 17:00)\n- November 1-March 31 next year: 08:00-17:30 (last entry at 16:30)\n- Cable Car/Chairlift/Alpine Slide operating hours: Usually synchronized with the scenic area''s opening hours, but may be temporarily closed due to weather conditions\n- Note: Visiting Mutianyu Great Wall takes about 3-4 hours (including cable car up and down the mountain and Great Wall strolling); it is recommended to go in the morning to avoid the tour group peak in the afternoon; autumn (mid-October to early November) is the most beautiful season for Mutianyu Great Wall, with red leaves covering the mountains and layers of forests dyed"}, {"icon": "🚇", "label": "Metro", "value": "- Self-driving:\n  - Route: Depart from Beijing urban area, drive along the Beijing-Chengde Expressway (G45) to Exit 13 (Beitai Road/Huairou Urban Area Exit), drive along Huaihuang Road (X009) to the Mutianyu Roundabout, follow signs to the scenic area parking lot, about 1.5-2 hours'' drive\n  - Parking: The scenic area has a large parking lot; parking fee is about 20 RMB/vehicle (small car)\n- Public Transportation:\n  - There is no direct rail transit or bus from Beijing urban area to Mutianyu Great Wall. The most common options are:\n    1. Take subway or bus from Beijing urban area to Dongzhimen Hub Station, transfer to the \"Mutianyu Great Wall Tourist Special Line\" bus (about 20-30 RMB/person, about 1.5-2 hours'' drive; special line buses usually only operate from spring to autumn, and may suspend service in winter)\n    2. Sign up for a Mutianyu Great Wall one-day tour group in Beijing urban area (about 150-300 RMB/person, including round-trip transportation, admission, tour guide)\n    3. Take urban rail transit to Huairou North Station, then transfer to bus or taxi to Mutianyu Great Wall (more troublesome, not recommended)\n- Taxi/Ride-hailing: Taking a taxi from Beijing urban area to Mutianyu Great Wall costs about 250-350 RMB one-way (excluding return trip), suitable for visitors traveling in groups\n- Note: Mutianyu Great Wall is far from Beijing urban area and inconvenient for transportation; it is strongly recommended to plan round-trip transportation in advance; if you choose to take the tourist special line bus, be sure to remember the return assembly time and place clearly to avoid missing the last bus"}]'::jsonb, '[]'::jsonb, '[]'::jsonb,
  'Mutianyu Village, Bohai Town, Huairou District, Beijing (along the Great Wall in the northern part of Huairou District)', '北京市怀柔区渤海镇慕田峪村（怀柔区北部长城沿线）',
  0, 'com.chinago.travel.attraction.beijing_mutianyu_great_wall', 4, TRUE
) ON CONFLICT (id) DO UPDATE SET
  city_id = EXCLUDED.city_id, name = EXCLUDED.name, chinese_name = EXCLUDED.chinese_name,
  category = EXCLUDED.category, cover_image_path = EXCLUDED.cover_image_path,
  summary = EXCLUDED.summary, introduction = EXCLUDED.introduction,
  priority = EXCLUDED.priority, ticket_price = EXCLUDED.ticket_price,
  recommended_duration = EXCLUDED.recommended_duration, opening_hours = EXCLUDED.opening_hours,
  closed_days = EXCLUDED.closed_days, requires_advance_booking = EXCLUDED.requires_advance_booking,
  metro_access = EXCLUDED.metro_access, practical_info = EXCLUDED.practical_info,
  western_visitor_tips = EXCLUDED.western_visitor_tips, nearby_places = EXCLUDED.nearby_places,
  address_en = EXCLUDED.address_en, address_zh = EXCLUDED.address_zh,
  audio_guide_count = EXCLUDED.audio_guide_count, iap_product_id = EXCLUDED.iap_product_id,
  display_order = EXCLUDED.display_order, is_published = EXCLUDED.is_published, updated_at = NOW();

INSERT INTO attractions (
  id, city_id, name, chinese_name, category, cover_image_path, summary, introduction,
  priority, ticket_price, recommended_duration, opening_hours, closed_days,
  requires_advance_booking, metro_access, practical_info, western_visitor_tips, nearby_places,
  address_en, address_zh, audio_guide_count, iap_product_id, display_order, is_published
) VALUES (
  'beijing_ming_tombs', 'beijing', 'Ming Tombs (Thirteen Tombs of the Ming Dynasty)', '十三陵',
  'sight', 'attractions/beijing_ming_tombs.png', 'The largest existing imperial tomb architectural complex in the world and the one with the most emperor and empress tombs. The resting place of Ming Chengzu Zhu Di, the mystery of Dingling Underground Palace, the grandeur of Changing Ling''en Hall, and the solemnity of the Sacred Way stone statues together weave this "open-air magnificent historical masterpiece of the Ming Dynasty."', 'The Ming Tombs are located at the foot of Tianshou Mountain in Changping District, Beijing, about 50 kilometers from Beijing urban area.',
  'P1', '- Changing (Tomb of Chengzu Zhu Di): 45 RMB/person
- Dingling (Tomb of Shenzong Zhu Yijun): 60 RMB/person
- Zhaoling (Tomb of Muzong Zhu Zaichen): 30 RMB/person
- Sacred Way: 30 RMB/person
- Combo Ticket: Changing + Dingling + Zhaoling + Sacred Way, about 110 RMB/person (relatively cost-effective, recommended)
- Discounted Tickets: Students, seniors (over 60), military personnel, etc. can enjoy half-price or free admission with valid ID
- Note: It is recommended to purchase tickets in advance on the official website or travel platforms for discounts and to avoid on-site queuing; the Ming Tombs scenic area covers a large area, and the distances between tombs are far; it is recommended to allow a full day for visiting and take internal transportation within the scenic area (electric shuttle bus or tourist bus)', 'Note: Visiting the Ming Tombs requires at least 4-5 hours (if visiting all open tombs and the Sacred Way); it is recommended to go in the morning; the temperature inside Dingling Underground Palace is relatively low (about 15-18°C), so even if visiting in summer, bringing a thin jacket is recommended',
  '- April 1-October 31: 08:00-17:30 (last entry at 17:00)
- November 1-March 31 next year: 08:30-17:00 (last entry at 16:30)
- Note: Visiting the Ming Tombs requires at least 4-5 hours (if visiting all open tombs and the Sacred Way); it is recommended to go in the morning; the temperature inside Dingling Underground Palace is relatively low (about 15-18°C), so even if visiting in summer, bringing a thin jacket is recommended', NULL,
  FALSE, '- Self-driving:
  - Route: Depart from Beijing urban area, drive along the Beijing-Tibet Expressway (G6) to the Changping Xiguan Roundabout Exit, drive along Beijing-Yinchuan Road (G110) to the Ming Tombs scenic area sign, follow signs to each tomb, about 1-1.5 hours'' drive
  - Parking: Each tomb has a parking lot; parking fee is about 10-20 RMB/vehicle (small car)
- Public Transportation:
  - The most common options for traveling from Beijing urban area to the Ming Tombs are:
    1. Take subway or bus from Beijing urban area to Deshengmen, transfer to "Changping Route 33" bus to Dingling Road Intersection stop, walk or transfer to the scenic area electric shuttle bus to each tomb (about 1.5-2 hours'' drive, more troublesome)
    2. Sign up for a Ming Tombs one-day tour group in Beijing urban area (about 150-250 RMB/person, including round-trip transportation, admission, tour guide)
    3. Take urban rail transit to Changping Xishankou Station (Subway Changping Line), then transfer to bus or taxi to the Ming Tombs scenic area (more troublesome, not recommended)
- Taxi/Ride-hailing: Taking a taxi from Beijing urban area to the Ming Tombs costs about 200-300 RMB one-way (excluding return trip), suitable for visitors traveling in groups
- Note: The Ming Tombs are far from Beijing urban area and inconvenient for transportation; it is strongly recommended to plan round-trip transportation in advance; if you choose self-driving, you can arrange visiting the Ming Tombs and Badaling Great Wall or Juyongguan Great Wall in Yanqing on the same day (the two places are about 40 kilometers apart)',
  '[{"icon": "🎫", "label": "Ticket", "value": "- Changing (Tomb of Chengzu Zhu Di): 45 RMB/person\n- Dingling (Tomb of Shenzong Zhu Yijun): 60 RMB/person\n- Zhaoling (Tomb of Muzong Zhu Zaichen): 30 RMB/person\n- Sacred Way: 30 RMB/person\n- Combo Ticket: Changing + Dingling + Zhaoling + Sacred Way, about 110 RMB/person (relatively cost-effective, recommended)\n- Discounted Tickets: Students, seniors (over 60), military personnel, etc. can enjoy half-price or free admission with valid ID\n- Note: It is recommended to purchase tickets in advance on the official website or travel platforms for discounts and to avoid on-site queuing; the Ming Tombs scenic area covers a large area, and the distances between tombs are far; it is recommended to allow a full day for visiting and take internal transportation within the scenic area (electric shuttle bus or tourist bus)"}, {"icon": "🕐", "label": "Duration", "value": "Note: Visiting the Ming Tombs requires at least 4-5 hours (if visiting all open tombs and the Sacred Way); it is recommended to go in the morning; the temperature inside Dingling Underground Palace is relatively low (about 15-18°C), so even if visiting in summer, bringing a thin jacket is recommended"}, {"icon": "🕘", "label": "Opening Hours", "value": "- April 1-October 31: 08:00-17:30 (last entry at 17:00)\n- November 1-March 31 next year: 08:30-17:00 (last entry at 16:30)\n- Note: Visiting the Ming Tombs requires at least 4-5 hours (if visiting all open tombs and the Sacred Way); it is recommended to go in the morning; the temperature inside Dingling Underground Palace is relatively low (about 15-18°C), so even if visiting in summer, bringing a thin jacket is recommended"}, {"icon": "🚇", "label": "Metro", "value": "- Self-driving:\n  - Route: Depart from Beijing urban area, drive along the Beijing-Tibet Expressway (G6) to the Changping Xiguan Roundabout Exit, drive along Beijing-Yinchuan Road (G110) to the Ming Tombs scenic area sign, follow signs to each tomb, about 1-1.5 hours'' drive\n  - Parking: Each tomb has a parking lot; parking fee is about 10-20 RMB/vehicle (small car)\n- Public Transportation:\n  - The most common options for traveling from Beijing urban area to the Ming Tombs are:\n    1. Take subway or bus from Beijing urban area to Deshengmen, transfer to \"Changping Route 33\" bus to Dingling Road Intersection stop, walk or transfer to the scenic area electric shuttle bus to each tomb (about 1.5-2 hours'' drive, more troublesome)\n    2. Sign up for a Ming Tombs one-day tour group in Beijing urban area (about 150-250 RMB/person, including round-trip transportation, admission, tour guide)\n    3. Take urban rail transit to Changping Xishankou Station (Subway Changping Line), then transfer to bus or taxi to the Ming Tombs scenic area (more troublesome, not recommended)\n- Taxi/Ride-hailing: Taking a taxi from Beijing urban area to the Ming Tombs costs about 200-300 RMB one-way (excluding return trip), suitable for visitors traveling in groups\n- Note: The Ming Tombs are far from Beijing urban area and inconvenient for transportation; it is strongly recommended to plan round-trip transportation in advance; if you choose self-driving, you can arrange visiting the Ming Tombs and Badaling Great Wall or Juyongguan Great Wall in Yanqing on the same day (the two places are about 40 kilometers apart)"}]'::jsonb, '[]'::jsonb, '[]'::jsonb,
  'Shisanling Town, Changping District, Beijing (foot of Tianshou Mountain, northern part of Changping District)', '北京市昌平区十三陵镇（天寿山麓，昌平区北部）',
  0, 'com.chinago.travel.attraction.beijing_ming_tombs', 5, TRUE
) ON CONFLICT (id) DO UPDATE SET
  city_id = EXCLUDED.city_id, name = EXCLUDED.name, chinese_name = EXCLUDED.chinese_name,
  category = EXCLUDED.category, cover_image_path = EXCLUDED.cover_image_path,
  summary = EXCLUDED.summary, introduction = EXCLUDED.introduction,
  priority = EXCLUDED.priority, ticket_price = EXCLUDED.ticket_price,
  recommended_duration = EXCLUDED.recommended_duration, opening_hours = EXCLUDED.opening_hours,
  closed_days = EXCLUDED.closed_days, requires_advance_booking = EXCLUDED.requires_advance_booking,
  metro_access = EXCLUDED.metro_access, practical_info = EXCLUDED.practical_info,
  western_visitor_tips = EXCLUDED.western_visitor_tips, nearby_places = EXCLUDED.nearby_places,
  address_en = EXCLUDED.address_en, address_zh = EXCLUDED.address_zh,
  audio_guide_count = EXCLUDED.audio_guide_count, iap_product_id = EXCLUDED.iap_product_id,
  display_order = EXCLUDED.display_order, is_published = EXCLUDED.is_published, updated_at = NOW();

INSERT INTO attractions (
  id, city_id, name, chinese_name, category, cover_image_path, summary, introduction,
  priority, ticket_price, recommended_duration, opening_hours, closed_days,
  requires_advance_booking, metro_access, practical_info, western_visitor_tips, nearby_places,
  address_en, address_zh, audio_guide_count, iap_product_id, display_order, is_published
) VALUES (
  'beijing_lama_temple', 'beijing', 'Yonghe Temple (Lama Temple)', '雍和宫',
  'temple', 'attractions/beijing_lama_temple.png', 'A royal temple that originated as the residence of Emperor Yongzheng of the Qing Dynasty before he ascended the throne, later converted to a Gelug school of Tibetan Buddhism temple. The resplendent halls, lingering butter lamp fragrance, rotating prayer wheels, and devout believers together create the most sacred and tranquil "snow land pure land" within Beijing city.', 'Yonghe Temple is located on Yonghe Temple Street in Dongcheng District, Beijing. It is the largest and most completely preserved Tibetan Buddhist temple in the Beijing area, and one of the highest-specification and most influential Tibetan Buddhist temples in inland China.',
  'P1', '- Admission: 25 RMB/person
- Discounted Tickets: Students, seniors (over 60), military personnel, etc. can enjoy half-price or free admission with valid ID
- Free Incense: The admission ticket includes one free stick of incense (can be collected at the entrance); it is not recommended to purchase high-priced incense in the surrounding area
- Note: Yonghe Temple is a religious site; please respect religious beliefs and customs; photography is prohibited inside the halls, and loud noise is prohibited; it is recommended to purchase tickets in advance on the official website or WeChat account for discounts and to avoid on-site queuing; visiting time for Yonghe Temple is about 1.5-2 hours', NULL,
  '- April 1-October 31: 09:00-16:30 (ticket sales stop at 16:00, last entry at 16:30)
- November 1-March 31 next year: 09:00-16:00 (ticket sales stop at 15:30, last entry at 16:00)
- Note: The best visiting time for Yonghe Temple is morning, which can avoid the tour group peak in the afternoon; on the first and fifteenth day of each lunar month, as well as traditional festivals such as the Laba Festival and Spring Festival, Yonghe Temple will hold religious assembly activities, which will be very lively but also have large crowds; winter temperatures in Beijing are low, please pay attention to keeping warm', NULL,
  FALSE, '- Rail Transit:
  - Subway Line 2 and 5: Get off at Yonghe Temple Station, exit from Exit C (Southeast Exit) or Exit F (Northwest Exit) to reach the main gate of Yonghe Temple directly
- Bus:
  - Yonghe Temple Station: Take buses 13, 18, 44, 62, 75, 116, 117, 800, 813, 814, Special 2, Special 12, etc., get off and arrive directly
  - Yonghe Temple Bridge East Station: Take buses 13, 18, 44, 62, 75, 116, 117, 800, 813, 814, Special 2, Special 12, etc., get off and walk about 5 minutes
- Taxi/Ride-hailing: Directly tell the driver "Yonghe Temple"; you will arrive directly
- Note: Yonghe Temple is located in the center of Beijing, with extremely convenient transportation in the surrounding area; it is strongly recommended to take rail transit or bus; after visiting Yonghe Temple, you can顺便 visit attractions such as Ditan Park (south side), Nanluoguxiang (west side), and Guozijian Street (west side); there are many characteristic restaurants and snack shops around Yonghe Temple, and it is recommended to try the Tibetan restaurants and vegetarian restaurants near Yonghe Temple',
  '[{"icon": "🎫", "label": "Ticket", "value": "- Admission: 25 RMB/person\n- Discounted Tickets: Students, seniors (over 60), military personnel, etc. can enjoy half-price or free admission with valid ID\n- Free Incense: The admission ticket includes one free stick of incense (can be collected at the entrance); it is not recommended to purchase high-priced incense in the surrounding area\n- Note: Yonghe Temple is a religious site; please respect religious beliefs and customs; photography is prohibited inside the halls, and loud noise is prohibited; it is recommended to purchase tickets in advance on the official website or WeChat account for discounts and to avoid on-site queuing; visiting time for Yonghe Temple is about 1.5-2 hours"}, {"icon": "🕘", "label": "Opening Hours", "value": "- April 1-October 31: 09:00-16:30 (ticket sales stop at 16:00, last entry at 16:30)\n- November 1-March 31 next year: 09:00-16:00 (ticket sales stop at 15:30, last entry at 16:00)\n- Note: The best visiting time for Yonghe Temple is morning, which can avoid the tour group peak in the afternoon; on the first and fifteenth day of each lunar month, as well as traditional festivals such as the Laba Festival and Spring Festival, Yonghe Temple will hold religious assembly activities, which will be very lively but also have large crowds; winter temperatures in Beijing are low, please pay attention to keeping warm"}, {"icon": "🚇", "label": "Metro", "value": "- Rail Transit:\n  - Subway Line 2 and 5: Get off at Yonghe Temple Station, exit from Exit C (Southeast Exit) or Exit F (Northwest Exit) to reach the main gate of Yonghe Temple directly\n- Bus:\n  - Yonghe Temple Station: Take buses 13, 18, 44, 62, 75, 116, 117, 800, 813, 814, Special 2, Special 12, etc., get off and arrive directly\n  - Yonghe Temple Bridge East Station: Take buses 13, 18, 44, 62, 75, 116, 117, 800, 813, 814, Special 2, Special 12, etc., get off and walk about 5 minutes\n- Taxi/Ride-hailing: Directly tell the driver \"Yonghe Temple\"; you will arrive directly\n- Note: Yonghe Temple is located in the center of Beijing, with extremely convenient transportation in the surrounding area; it is strongly recommended to take rail transit or bus; after visiting Yonghe Temple, you can顺便 visit attractions such as Ditan Park (south side), Nanluoguxiang (west side), and Guozijian Street (west side); there are many characteristic restaurants and snack shops around Yonghe Temple, and it is recommended to try the Tibetan restaurants and vegetarian restaurants near Yonghe Temple"}]'::jsonb, '[]'::jsonb, '[]'::jsonb,
  'No. 12 Yonghe Temple Street, Dongcheng District, Beijing (Beixin Bridge area, south side of Ditan Park)', '北京市东城区雍和宫大街12号（北新桥地区，地坛公园南侧）',
  0, 'com.chinago.travel.attraction.beijing_lama_temple', 6, TRUE
) ON CONFLICT (id) DO UPDATE SET
  city_id = EXCLUDED.city_id, name = EXCLUDED.name, chinese_name = EXCLUDED.chinese_name,
  category = EXCLUDED.category, cover_image_path = EXCLUDED.cover_image_path,
  summary = EXCLUDED.summary, introduction = EXCLUDED.introduction,
  priority = EXCLUDED.priority, ticket_price = EXCLUDED.ticket_price,
  recommended_duration = EXCLUDED.recommended_duration, opening_hours = EXCLUDED.opening_hours,
  closed_days = EXCLUDED.closed_days, requires_advance_booking = EXCLUDED.requires_advance_booking,
  metro_access = EXCLUDED.metro_access, practical_info = EXCLUDED.practical_info,
  western_visitor_tips = EXCLUDED.western_visitor_tips, nearby_places = EXCLUDED.nearby_places,
  address_en = EXCLUDED.address_en, address_zh = EXCLUDED.address_zh,
  audio_guide_count = EXCLUDED.audio_guide_count, iap_product_id = EXCLUDED.iap_product_id,
  display_order = EXCLUDED.display_order, is_published = EXCLUDED.is_published, updated_at = NOW();

INSERT INTO attractions (
  id, city_id, name, chinese_name, category, cover_image_path, summary, introduction,
  priority, ticket_price, recommended_duration, opening_hours, closed_days,
  requires_advance_booking, metro_access, practical_info, western_visitor_tips, nearby_places,
  address_en, address_zh, audio_guide_count, iap_product_id, display_order, is_published
) VALUES (
  'beijing_prince_gong_mansion', 'beijing', 'Prince Gong''s Mansion', '恭王府',
  'palace', 'attractions/beijing_prince_gong_mansion.png', 'The largest and most completely preserved prince''s mansion from the Qing Dynasty, once the "Heshen Villa," famous for the "99 and a Half Rooms" Xijin Hall, the exquisite Western-style gate, and the "Number One Blessing Under Heaven" Fu character stele. It is a living fossil of "One Prince Gong''s Mansion, Half of Qing Dynasty History."', 'Prince Gong''s Mansion is located on Qianhai West Street in Xicheng District, Beijing, adjacent to Shichahai. It is the largest and most completely preserved prince''s mansion from the Qing Dynasty, first built in the middle and late Qianlong period of the Qing Dynasty (around 1776).',
  'P1', '- Admission: 40 RMB/person (including mansion + garden)
- Discounted Tickets: Students, seniors (over 60), military personnel, etc. can enjoy half-price or free admission with valid ID
- Guide Service: Chinese guide about 200-300 RMB/group; English guide about 300-400 RMB/group; electronic guide device rental also available (about 20 RMB/unit)
- Note: Prince Gong''s Mansion has a large number of visitors; it is recommended to make a reservation and purchase tickets in advance on the official website or WeChat account, especially on weekends and holidays; daily visitor flow is limited, and there may be no on-site tickets available', 'Note: Visiting time for Prince Gong''s Mansion is about 1.5-2 hours; it is recommended to go in the morning to avoid the tour group peak in the afternoon; the garden is especially beautiful in autumn, and the photo effect is excellent when ginkgo leaves turn yellow',
  '- April 1-October 31: 08:30-17:00 (ticket sales stop at 16:10, last entry at 16:30)
- November 1-March 31 next year: 09:00-16:30 (ticket sales stop at 15:40, last entry at 16:00)
- Note: Visiting time for Prince Gong''s Mansion is about 1.5-2 hours; it is recommended to go in the morning to avoid the tour group peak in the afternoon; the garden is especially beautiful in autumn, and the photo effect is excellent when ginkgo leaves turn yellow', NULL,
  TRUE, '- Rail Transit:
  - Subway Line 6: Get off at Beihai North Station, walk about 5 minutes from Exit B (Northeast Exit)
  - Subway Line 8: Get off at Nanluoguxiang Station, walk about 8 minutes from Exit E
  - Subway Line 4: Get off at Ping''anli Station, walk about 10 minutes from Exit C
- Bus:
  - Beihai North Gate Station: Take buses 13, 42, 90, 107, 111, 118, 204, 609, 612, 623, 701, etc., get off and walk about 5 minutes
  - Prince Gong''s Mansion Station: Take buses 5, 58, Sightseeing Line 3, etc., get off and arrive directly
  - Di''anmen Outer Station: Take buses 60, 82, 90, 107, etc., get off and walk about 5 minutes
- Taxi/Ride-hailing: Directly tell the driver "Prince Gong''s Mansion" or "Shichahai Prince Gong''s Mansion"; you will arrive directly
- Note: Prince Gong''s Mansion is located within the Shichahai scenic area; roads in the surrounding area are narrow and parking spaces are extremely tight; it is strongly recommended to take rail transit or bus; after visiting Prince Gong''s Mansion, you can顺便 visit attractions such as Shichahai, Yandai Skewed Street, and Nanluoguxiang',
  '[{"icon": "🎫", "label": "Ticket", "value": "- Admission: 40 RMB/person (including mansion + garden)\n- Discounted Tickets: Students, seniors (over 60), military personnel, etc. can enjoy half-price or free admission with valid ID\n- Guide Service: Chinese guide about 200-300 RMB/group; English guide about 300-400 RMB/group; electronic guide device rental also available (about 20 RMB/unit)\n- Note: Prince Gong''s Mansion has a large number of visitors; it is recommended to make a reservation and purchase tickets in advance on the official website or WeChat account, especially on weekends and holidays; daily visitor flow is limited, and there may be no on-site tickets available"}, {"icon": "🕐", "label": "Duration", "value": "Note: Visiting time for Prince Gong''s Mansion is about 1.5-2 hours; it is recommended to go in the morning to avoid the tour group peak in the afternoon; the garden is especially beautiful in autumn, and the photo effect is excellent when ginkgo leaves turn yellow"}, {"icon": "🕘", "label": "Opening Hours", "value": "- April 1-October 31: 08:30-17:00 (ticket sales stop at 16:10, last entry at 16:30)\n- November 1-March 31 next year: 09:00-16:30 (ticket sales stop at 15:40, last entry at 16:00)\n- Note: Visiting time for Prince Gong''s Mansion is about 1.5-2 hours; it is recommended to go in the morning to avoid the tour group peak in the afternoon; the garden is especially beautiful in autumn, and the photo effect is excellent when ginkgo leaves turn yellow"}, {"icon": "🚇", "label": "Metro", "value": "- Rail Transit:\n  - Subway Line 6: Get off at Beihai North Station, walk about 5 minutes from Exit B (Northeast Exit)\n  - Subway Line 8: Get off at Nanluoguxiang Station, walk about 8 minutes from Exit E\n  - Subway Line 4: Get off at Ping''anli Station, walk about 10 minutes from Exit C\n- Bus:\n  - Beihai North Gate Station: Take buses 13, 42, 90, 107, 111, 118, 204, 609, 612, 623, 701, etc., get off and walk about 5 minutes\n  - Prince Gong''s Mansion Station: Take buses 5, 58, Sightseeing Line 3, etc., get off and arrive directly\n  - Di''anmen Outer Station: Take buses 60, 82, 90, 107, etc., get off and walk about 5 minutes\n- Taxi/Ride-hailing: Directly tell the driver \"Prince Gong''s Mansion\" or \"Shichahai Prince Gong''s Mansion\"; you will arrive directly\n- Note: Prince Gong''s Mansion is located within the Shichahai scenic area; roads in the surrounding area are narrow and parking spaces are extremely tight; it is strongly recommended to take rail transit or bus; after visiting Prince Gong''s Mansion, you can顺便 visit attractions such as Shichahai, Yandai Skewed Street, and Nanluoguxiang"}]'::jsonb, '[]'::jsonb, '[]'::jsonb,
  'No. 17 Qianhai West Street, Xicheng District, Beijing (Shichahai area, west side of Di''anmen Outer Street)', '北京市西城区前海西街17号（什刹海地区，地安门外大街西侧）',
  0, 'com.chinago.travel.attraction.beijing_prince_gong_mansion', 7, TRUE
) ON CONFLICT (id) DO UPDATE SET
  city_id = EXCLUDED.city_id, name = EXCLUDED.name, chinese_name = EXCLUDED.chinese_name,
  category = EXCLUDED.category, cover_image_path = EXCLUDED.cover_image_path,
  summary = EXCLUDED.summary, introduction = EXCLUDED.introduction,
  priority = EXCLUDED.priority, ticket_price = EXCLUDED.ticket_price,
  recommended_duration = EXCLUDED.recommended_duration, opening_hours = EXCLUDED.opening_hours,
  closed_days = EXCLUDED.closed_days, requires_advance_booking = EXCLUDED.requires_advance_booking,
  metro_access = EXCLUDED.metro_access, practical_info = EXCLUDED.practical_info,
  western_visitor_tips = EXCLUDED.western_visitor_tips, nearby_places = EXCLUDED.nearby_places,
  address_en = EXCLUDED.address_en, address_zh = EXCLUDED.address_zh,
  audio_guide_count = EXCLUDED.audio_guide_count, iap_product_id = EXCLUDED.iap_product_id,
  display_order = EXCLUDED.display_order, is_published = EXCLUDED.is_published, updated_at = NOW();

INSERT INTO attractions (
  id, city_id, name, chinese_name, category, cover_image_path, summary, introduction,
  priority, ticket_price, recommended_duration, opening_hours, closed_days,
  requires_advance_booking, metro_access, practical_info, western_visitor_tips, nearby_places,
  address_en, address_zh, audio_guide_count, iap_product_id, display_order, is_published
) VALUES (
  'beijing_beihai_park', 'beijing', 'Beihai Park', '北海公园',
  'park', 'attractions/beijing_beihai_park.png', 'Located to the northwest of the Forbidden City, it is an imperial garden with the White Dagoba on Qionghua Island as its symbol. With lake reflections, pagoda shadows, and swaying lotus flowers, it is the most poetic "urban oasis" in the heart of Beijing.', 'Beihai Park is located in the center of Beijing, to the northwest of the Forbidden City. Together with Zhonghua and Nanhai, it is called the "Three Seas." It is one of the oldest, most complete, most comprehensive, and most representative imperial gardens in China, first built in the Liao Dynasty (938 AD), and expanded through the Jin, Yuan, Ming, and Qing dynasties, with a history of nearly 1,100 years.',
  'P1', '- Peak season (April 1-October 31): 10 RMB/person
- Off season (November 1-March 31 next year): 5 RMB/person
- Qionghua Island (White Dagoba): Peak season 10 RMB/person; Off season 5 RMB/person
- Shanin Hall: 2 RMB/person
- Combo Ticket (including park ticket + Qionghua Island + Shanin Hall): Peak season 20 RMB/person; Off season 15 RMB/person
- Discounted Tickets: Students, seniors (over 60), military personnel, etc. can enjoy half-price or free admission with valid ID
- Note: It is recommended to purchase tickets in advance through the official WeChat account of "Beihai Park" or platforms such as Meituan and Ctrip to avoid on-site queuing; the park covers a large area, so it is recommended to allow 2-3 hours for visiting', NULL,
  '- Peak season (April 1-October 31): 06:30-21:00 (last entry at 20:30)
- Off season (November 1-March 31 next year): 06:30-20:00 (last entry at 19:30)
- Qionghua Island: 08:30-17:00 (last island access at 16:30)
- Note: Summer evening is the most beautiful time in Beihai Park, with the sunset shining on the lake and the White Dagoba glowing in the golden afterglow; in winter, after the lake surface freezes, you can experience ice cariage (additional fee required)', NULL,
  FALSE, '- Rail Transit:
  - Subway Line 6: Get off at Beihai North Station, walk about 5 minutes from Exit B (Northeast Exit)
  - Subway Line 4: Get off at Xisi Station, walk about 10 minutes from Exit D (Southwest Exit)
- Bus:
  - Beihai North Gate Station: Take buses 13, 42, 90, 107, 111, 118, 204, 609, 612, 623, 701, etc., get off and arrive directly
  - Beihai Station: Take buses 5, 101, 103, 109, 124, 128, 614, etc., get off and arrive directly
  - Forbidden City West Gate Station: Take buses 5, 58, get off and walk about 5 minutes
- Taxi/Ride-hailing: Directly tell the driver "Beihai Park"; you will arrive directly; it is recommended to enter from the North Gate or South Gate
- Note: Roads around Beihai Park are narrow and parking spaces are extremely tight; it is strongly recommended to take rail transit or bus; entering from the North Gate is closest to Qionghua Island',
  '[{"icon": "🎫", "label": "Ticket", "value": "- Peak season (April 1-October 31): 10 RMB/person\n- Off season (November 1-March 31 next year): 5 RMB/person\n- Qionghua Island (White Dagoba): Peak season 10 RMB/person; Off season 5 RMB/person\n- Shanin Hall: 2 RMB/person\n- Combo Ticket (including park ticket + Qionghua Island + Shanin Hall): Peak season 20 RMB/person; Off season 15 RMB/person\n- Discounted Tickets: Students, seniors (over 60), military personnel, etc. can enjoy half-price or free admission with valid ID\n- Note: It is recommended to purchase tickets in advance through the official WeChat account of \"Beihai Park\" or platforms such as Meituan and Ctrip to avoid on-site queuing; the park covers a large area, so it is recommended to allow 2-3 hours for visiting"}, {"icon": "🕘", "label": "Opening Hours", "value": "- Peak season (April 1-October 31): 06:30-21:00 (last entry at 20:30)\n- Off season (November 1-March 31 next year): 06:30-20:00 (last entry at 19:30)\n- Qionghua Island: 08:30-17:00 (last island access at 16:30)\n- Note: Summer evening is the most beautiful time in Beihai Park, with the sunset shining on the lake and the White Dagoba glowing in the golden afterglow; in winter, after the lake surface freezes, you can experience ice cariage (additional fee required)"}, {"icon": "🚇", "label": "Metro", "value": "- Rail Transit:\n  - Subway Line 6: Get off at Beihai North Station, walk about 5 minutes from Exit B (Northeast Exit)\n  - Subway Line 4: Get off at Xisi Station, walk about 10 minutes from Exit D (Southwest Exit)\n- Bus:\n  - Beihai North Gate Station: Take buses 13, 42, 90, 107, 111, 118, 204, 609, 612, 623, 701, etc., get off and arrive directly\n  - Beihai Station: Take buses 5, 101, 103, 109, 124, 128, 614, etc., get off and arrive directly\n  - Forbidden City West Gate Station: Take buses 5, 58, get off and walk about 5 minutes\n- Taxi/Ride-hailing: Directly tell the driver \"Beihai Park\"; you will arrive directly; it is recommended to enter from the North Gate or South Gate\n- Note: Roads around Beihai Park are narrow and parking spaces are extremely tight; it is strongly recommended to take rail transit or bus; entering from the North Gate is closest to Qionghua Island"}]'::jsonb, '[]'::jsonb, '[]'::jsonb,
  'No. 1 Wenjin Street, Xicheng District, Beijing (northwest side of the Forbidden City, west side of Shichahai)', '北京市西城区文津街1号（故宫西北侧，什刹海西侧）',
  0, 'com.chinago.travel.attraction.beijing_beihai_park', 8, TRUE
) ON CONFLICT (id) DO UPDATE SET
  city_id = EXCLUDED.city_id, name = EXCLUDED.name, chinese_name = EXCLUDED.chinese_name,
  category = EXCLUDED.category, cover_image_path = EXCLUDED.cover_image_path,
  summary = EXCLUDED.summary, introduction = EXCLUDED.introduction,
  priority = EXCLUDED.priority, ticket_price = EXCLUDED.ticket_price,
  recommended_duration = EXCLUDED.recommended_duration, opening_hours = EXCLUDED.opening_hours,
  closed_days = EXCLUDED.closed_days, requires_advance_booking = EXCLUDED.requires_advance_booking,
  metro_access = EXCLUDED.metro_access, practical_info = EXCLUDED.practical_info,
  western_visitor_tips = EXCLUDED.western_visitor_tips, nearby_places = EXCLUDED.nearby_places,
  address_en = EXCLUDED.address_en, address_zh = EXCLUDED.address_zh,
  audio_guide_count = EXCLUDED.audio_guide_count, iap_product_id = EXCLUDED.iap_product_id,
  display_order = EXCLUDED.display_order, is_published = EXCLUDED.is_published, updated_at = NOW();
