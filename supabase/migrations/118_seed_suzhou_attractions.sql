-- Seed: suzhou attractions from Desktop Markdown
-- Text fields = verbatim English sections from source docs.
-- practical_info = Ticket / Duration / Opening Hours / Closed / Metro from MD sections.
-- Idempotent: ON CONFLICT (id) DO UPDATE

INSERT INTO attractions (
  id, city_id, name, chinese_name, category, cover_image_path, summary, introduction,
  priority, ticket_price, recommended_duration, opening_hours, closed_days,
  requires_advance_booking, metro_access, practical_info, western_visitor_tips, nearby_places,
  address_en, address_zh, audio_guide_count, iap_product_id, display_order, is_published
) VALUES (
  'suzhou_humble_administrators_garden', 'suzhou', 'Humble Administrator''s Garden', '拙政园',
  'garden', 'attractions/suzhou_humble_administrators_garden.png', 'The foremost of China''s four greatest classical gardens and the icon of Suzhou gardens, celebrated for its water-centered landscape and title as the “Mother of All Gardens.”', 'Located at No. 178 Northeast Street, Gusu District, Suzhou, the Humble Administrator''s Garden was founded in the early Zhengde reign of the Ming Dynasty by censor Wang Xianchen after his retirement. Its name comes from Pan Yue''s “Fu on Living in Retirement” in the Jin Dynasty: “Irrigating the garden and selling vegetables to supply daily meals... this is the governance of the unambitious.” It is the foremost of China''s four greatest classical gardens and the largest surviving classical garden in Suzhou, inscribed on the UNESCO World Heritage List in 1997.

Covering about 5.2 hectares, the garden is centered on water, which occupies about one-third of the total area. It is divided into eastern, central, and western sections. The central section is the essence of the garden, with Yuanxiang Hall as the main building, surrounded by Xiaofeihong Bridge, Xiangzhou Boat, Hefeng Simian Pavilion, Jianshan Tower, and Xuexiang Yunwei Pavilion. The eastern section is bright and open, featuring Lanxue Hall, Furong Pavilion, and Tianquan Pavilion amid grass and trees. The western section is winding and secluded, with Yu Shui Tong Zuo Xuan, Yi Liang Pavilion, and Daoying Tower built along the water.

The garden embodies the essence of Jiangnan garden design, employing borrowed scenery, opposite scenery, framed views, and concealed views with masterful skill. Spring brings azaleas, summer lotus, autumn chrysanthemums, and winter plum blossoms. Its couplets and plaques are the work of famous scholars, adding rich cultural depth. As the outstanding representative of Suzhou gardens, the Humble Administrator''s Garden is both the top destination for visitors to Suzhou and an essential model for studying Chinese classical garden art.',
  'P0', '- Adult ticket: CNY 80 in peak season, CNY 70 in off-season
- Discount ticket: CNY 40 in peak season, CNY 35 in off-season (students, seniors aged 60-69 with valid ID)
- Free admission: children under 6 or under 1.4m, seniors aged 70+, active servicemen, and people with disabilities (valid ID required)
- Peak season: April, May, July, August, September, October; off-season: January, February, March, June, November, December
- Note: Real-name time-slot reservations are required. Advance booking through official channels is strongly recommended', NULL,
  '- Peak season (March 1 – November 15): 07:30–17:30 (ticket sales and entry stop at 17:00)
- Off-season (November 16 – February 28): 07:30–17:00 (ticket sales and entry stop at 16:30)', NULL,
  TRUE, '- Metro: Take Metro Line 4 to Beisi Pagoda Station and walk 10–15 minutes; or take Line 6 to Humble Administrator''s Garden Station and walk 5–8 minutes
- Bus: Take tourist lines 1, 2, or 5, or bus routes 55, 178, 202, 301, 305, 313, 529, 923, or 925 to Humble Administrator''s Garden, Suzhou Museum, or Lion Grove Garden stops
- Driving: Navigate to “Humble Administrator''s Garden Scenic Area.” Parking is available nearby but old city roads are narrow and spaces are limited on holidays; public transport is recommended
- Taxi/ride-hailing: Set destination to “No. 178 Northeast Street, Humble Administrator''s Garden”',
  '[{"icon": "🎫", "label": "Ticket", "value": "- Adult ticket: CNY 80 in peak season, CNY 70 in off-season\n- Discount ticket: CNY 40 in peak season, CNY 35 in off-season (students, seniors aged 60-69 with valid ID)\n- Free admission: children under 6 or under 1.4m, seniors aged 70+, active servicemen, and people with disabilities (valid ID required)\n- Peak season: April, May, July, August, September, October; off-season: January, February, March, June, November, December\n- Note: Real-name time-slot reservations are required. Advance booking through official channels is strongly recommended"}, {"icon": "🕘", "label": "Opening Hours", "value": "- Peak season (March 1 – November 15): 07:30–17:30 (ticket sales and entry stop at 17:00)\n- Off-season (November 16 – February 28): 07:30–17:00 (ticket sales and entry stop at 16:30)"}, {"icon": "🚇", "label": "Metro", "value": "- Metro: Take Metro Line 4 to Beisi Pagoda Station and walk 10–15 minutes; or take Line 6 to Humble Administrator''s Garden Station and walk 5–8 minutes\n- Bus: Take tourist lines 1, 2, or 5, or bus routes 55, 178, 202, 301, 305, 313, 529, 923, or 925 to Humble Administrator''s Garden, Suzhou Museum, or Lion Grove Garden stops\n- Driving: Navigate to “Humble Administrator''s Garden Scenic Area.” Parking is available nearby but old city roads are narrow and spaces are limited on holidays; public transport is recommended\n- Taxi/ride-hailing: Set destination to “No. 178 Northeast Street, Humble Administrator''s Garden”"}]'::jsonb, '[]'::jsonb, '[]'::jsonb,
  'No. 178 Northeast Street, Gusu District, Suzhou, Jiangsu Province, China', '江苏省苏州市姑苏区东北街178号',
  0, 'com.chinago.travel.attraction.suzhou_humble_administrators_garden', 0, TRUE
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
  'suzhou_lingering_garden', 'suzhou', 'Lingering Garden Scenic Area', '留园景区',
  'garden', 'attractions/suzhou_lingering_garden.png', 'One of China''s four greatest classical gardens, celebrated for its exquisite architecture, ingenious spatial design, and the famous “Cloud-Capped Peak” rock.', 'Located at No. 338 Liuyuan Road, Gusu District, Suzhou, Lingering Garden was first built during the Wanli reign of the Ming Dynasty. Originally called Dongyuan, it was later acquired by Liu Shu in the Qing Dynasty, renamed Hanbi Mountain Villa, popularly known as Liuyuan, and finally officially named Lingering Garden. As one of China''s four greatest classical gardens, it was inscribed on the UNESCO World Heritage List in 1997.

Covering about 2.33 hectares, the garden is divided into central, eastern, western, and northern sections. The central section features hills and water, with Hanbi Mountain House, Mingshe Tower, and Lüyin Pavilion surrounding the pond—the essence of the garden. The eastern section focuses on grand architecture, including Guanyun Tower and the Hall of Eminent Elders. The western section offers natural woodland charm, especially in autumn when maple leaves turn red. The northern section is rustic, with bamboo fences and thatched cottages evoking rural life.

The garden''s most celebrated feature is the Cloud-Capped Peak, a 6.5-meter Taihu stone masterpiece, accompanied by the Auspicious Peak and the Misty Peak. With its high density of buildings, rich spatial layers, and diverse landscaping techniques, Lingering Garden represents the peak of Jiangnan garden art, offering visitors an ever-changing visual experience at every turn.',
  'P0', '- Adult ticket: CNY 55 in peak season, CNY 45 in off-season
- Discount ticket: CNY 27.5 in peak season, CNY 22.5 in off-season (students, seniors aged 60-69 with valid ID)
- Free admission: children under 6 or under 1.4m, seniors aged 70+, active servicemen, and people with disabilities (valid ID required)
- Peak season: April, May, July, August, September, October; off-season: January, February, March, June, November, December
- Note: Advance booking via official channels is recommended. Prices are subject to on-site announcement', NULL,
  '- Peak season (April, May, July–October): 07:30–17:30 (ticket sales and entry stop at 17:00)
- Off-season (January–March, June, November, December): 07:30–17:00 (ticket sales and entry stop at 16:30)', NULL,
  FALSE, '- Metro: Take Metro Line 2 to Shilu Station and walk 10–15 minutes; or take Line 1 to Guangjinan Road Station and transfer to bus or walk about 20 minutes
- Bus: Take tourist lines 1, 2, or 5, or bus routes 7, 22, 34, 44, 50, 64, 85, 161, 204, 304, 311, 315, 317, 318, 406, 415, 522, 800, 921, 933, or 949 to Liuyuan or Liuyuan Road stops
- Driving: Navigate to “Lingering Garden Scenic Area.” Parking is available nearby but limited on holidays; arrive early or use public transport
- Taxi/ride-hailing: Set destination to “No. 338 Liuyuan Road, Lingering Garden Scenic Area”',
  '[{"icon": "🎫", "label": "Ticket", "value": "- Adult ticket: CNY 55 in peak season, CNY 45 in off-season\n- Discount ticket: CNY 27.5 in peak season, CNY 22.5 in off-season (students, seniors aged 60-69 with valid ID)\n- Free admission: children under 6 or under 1.4m, seniors aged 70+, active servicemen, and people with disabilities (valid ID required)\n- Peak season: April, May, July, August, September, October; off-season: January, February, March, June, November, December\n- Note: Advance booking via official channels is recommended. Prices are subject to on-site announcement"}, {"icon": "🕘", "label": "Opening Hours", "value": "- Peak season (April, May, July–October): 07:30–17:30 (ticket sales and entry stop at 17:00)\n- Off-season (January–March, June, November, December): 07:30–17:00 (ticket sales and entry stop at 16:30)"}, {"icon": "🚇", "label": "Metro", "value": "- Metro: Take Metro Line 2 to Shilu Station and walk 10–15 minutes; or take Line 1 to Guangjinan Road Station and transfer to bus or walk about 20 minutes\n- Bus: Take tourist lines 1, 2, or 5, or bus routes 7, 22, 34, 44, 50, 64, 85, 161, 204, 304, 311, 315, 317, 318, 406, 415, 522, 800, 921, 933, or 949 to Liuyuan or Liuyuan Road stops\n- Driving: Navigate to “Lingering Garden Scenic Area.” Parking is available nearby but limited on holidays; arrive early or use public transport\n- Taxi/ride-hailing: Set destination to “No. 338 Liuyuan Road, Lingering Garden Scenic Area”"}]'::jsonb, '[]'::jsonb, '[]'::jsonb,
  'No. 338 Liuyuan Road, Gusu District, Suzhou, Jiangsu Province, China', '江苏省苏州市姑苏区留园路338号',
  0, 'com.chinago.travel.attraction.suzhou_lingering_garden', 1, TRUE
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
  'suzhou_lion_grove_garden', 'suzhou', 'Lion Grove Garden', '狮子林',
  'garden', 'attractions/suzhou_lion_grove_garden.png', 'A Suzhou classical garden famous as the “Kingdom of Rockeries,” where towering lake-stones, winding caves, and Buddhist charm create a playful yet serene experience.', 'Located at No. 23 Yuanlin Road, Gusu District, Suzhou, Lion Grove Garden was founded in 1342 during the Yuan Dynasty. It was originally the garden of the Bodhi Orthodox Temple, built by disciples of the monk Tianru. The garden was named “Lion Grove” because its Taihu stone peaks were thought to resemble lions and because Tianru had received dharma transmission at Lion Rock on Tianmu Mountain in Zhejiang. As a key part of the Classical Gardens of Suzhou UNESCO World Heritage site, it is famous both at home and abroad for its distinctive lake-rock mountain.

The garden''s main attraction is its vast rockery, covering about 0.15 hectares and built from Taihu stones. With 21 caves and 9 winding paths, visitors can wander through it like a labyrinth. The peaks take on countless forms—some rearing like lions, others crouching like beasts. The Qing Emperor Qianlong visited the garden repeatedly during his southern tours and inscribed the characters “Zhen Qu” (True Delight), which still grace the Zhenqu Pavilion today.

The garden is divided into ancestral hall, residence, and garden sections. Yanyu Hall is the main hall, bright and spacious; Zhibai Pavilion faces the water with ancient cypresses overhead; Feipu Pavilion, Wenmei Pavilion, and Lixue Hall each have their own character. Lion Grove Garden integrates Zen meaning, literati refinement, and the beauty of strange rocks, combining Jiangnan elegance with fantasy and playfulness in a truly unique way.',
  'P0', '- Adult ticket: CNY 40 in peak season, CNY 30 in off-season
- Discount ticket: CNY 20 in peak season, CNY 15 in off-season (students, seniors aged 60-69 with valid ID)
- Free admission: children under 6 or under 1.4m, seniors aged 70+, active servicemen, and people with disabilities (valid ID required)
- Peak season: April, May, July, August, September, October; off-season: January, February, March, June, November, December
- Note: Prices are subject to on-site announcement. Advance booking is recommended', NULL,
  '- Peak season (April, May, July–October): 07:30–17:30 (ticket sales and entry stop at 17:00)
- Off-season (January–March, June, November, December): 07:30–17:00 (ticket sales and entry stop at 16:30)', NULL,
  FALSE, '- Metro: Take Metro Line 4 to Beisi Pagoda Station and walk about 15 minutes; or take Line 1 to Lindun Road Station and transfer to bus or walk 15–20 minutes
- Bus: Take tourist lines 1, 2, or 5, or bus routes 55, 178, 202, 301, 305, 313, 529, 923, or 925 to Suzhou Museum, Lion Grove Garden, Suzhou Municipal Hospital East District, or Pingjiang Road stops
- Driving: Navigate to “Lion Grove Garden Scenic Area.” Parking is available nearby but the old city roads are narrow and spaces are tight on holidays; public transport is recommended
- Taxi/ride-hailing: Set destination to “No. 23 Yuanlin Road, Lion Grove Garden”',
  '[{"icon": "🎫", "label": "Ticket", "value": "- Adult ticket: CNY 40 in peak season, CNY 30 in off-season\n- Discount ticket: CNY 20 in peak season, CNY 15 in off-season (students, seniors aged 60-69 with valid ID)\n- Free admission: children under 6 or under 1.4m, seniors aged 70+, active servicemen, and people with disabilities (valid ID required)\n- Peak season: April, May, July, August, September, October; off-season: January, February, March, June, November, December\n- Note: Prices are subject to on-site announcement. Advance booking is recommended"}, {"icon": "🕘", "label": "Opening Hours", "value": "- Peak season (April, May, July–October): 07:30–17:30 (ticket sales and entry stop at 17:00)\n- Off-season (January–March, June, November, December): 07:30–17:00 (ticket sales and entry stop at 16:30)"}, {"icon": "🚇", "label": "Metro", "value": "- Metro: Take Metro Line 4 to Beisi Pagoda Station and walk about 15 minutes; or take Line 1 to Lindun Road Station and transfer to bus or walk 15–20 minutes\n- Bus: Take tourist lines 1, 2, or 5, or bus routes 55, 178, 202, 301, 305, 313, 529, 923, or 925 to Suzhou Museum, Lion Grove Garden, Suzhou Municipal Hospital East District, or Pingjiang Road stops\n- Driving: Navigate to “Lion Grove Garden Scenic Area.” Parking is available nearby but the old city roads are narrow and spaces are tight on holidays; public transport is recommended\n- Taxi/ride-hailing: Set destination to “No. 23 Yuanlin Road, Lion Grove Garden”"}]'::jsonb, '[]'::jsonb, '[]'::jsonb,
  'No. 23 Yuanlin Road, Gusu District, Suzhou, Jiangsu Province, China', '江苏省苏州市姑苏区园林路23号',
  0, 'com.chinago.travel.attraction.suzhou_lion_grove_garden', 2, TRUE
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
  'suzhou_canglang_pavilion', 'suzhou', 'Canglang Pavilion Scenic Area / Surging Wave Pavilion', '沧浪亭景区',
  'garden', 'attractions/suzhou_canglang_pavilion.png', 'The oldest surviving classical garden in Suzhou, renowned for its open waterfront layout and Song-dynasty elegance where scenery greets visitors before they even enter.', 'Located in Gusu District, Suzhou, Canglang Pavilion is the city''s oldest surviving classical garden. Founded during the Northern Song Dynasty by poet Su Shunqin, it takes its name from the verse "If the Canglang water is clear, I can wash my tassels in it" in the Chu Ci. As a key component of the Classical Gardens of Suzhou UNESCO World Heritage site, it is celebrated for its open layout where water and greenery greet visitors before they enter the garden.

The garden is centered on an earthen hill crowned by the Canglang Pavilion, the highest point of the garden. Its columns bear a famous couplet by Qing scholar Liang Zhangju: "The clear breeze and bright moon are priceless; the nearby water and distant mountains all hold affection." A covered corridor runs east-west, ingeniously borrowing the water view from outside the walls to blend inner and outer scenery. Structures such as Cui Linglong, Mian Shui Xuan, Wen Miao Xiang Shi, and Guan Yu Chu are arranged along the corridor, each with its own charm. The garden''s 108 unique lattice windows are a masterpiece of Suzhou garden art.

Canglang Pavilion preserves the spacious, natural style of Song-dynasty gardens while embodying the literati ideal of reclusion. Strolling along its stone paths among ancient trees, visitors can appreciate both the garden-making wisdom of creating a world within a small space and the Chinese scholarly pursuit of spiritual transcendence through nature.',
  'P1', '- Adult ticket: CNY 20 per person
- Discount ticket: CNY 10 per person (students, seniors aged 60-69 with valid ID)
- Free admission: children under 6 or under 1.4m, seniors aged 70+, active servicemen, and people with disabilities (valid ID required)
- Note: Prices are subject to on-site announcement', NULL,
  '- March 1 – October 31: 07:30–17:30 (ticket sales and entry stop at 17:00)
- November 1 – February 28: 07:30–17:00 (ticket sales and entry stop at 16:30)', NULL,
  FALSE, '- Metro: Take Metro Line 3 or Line 4 to Canglangting Station, then walk about 5–8 minutes
- Bus: Take tourist lines 2, 4, or 5, or bus routes 1, 5, 27, 30, 47, 101, 102, 103, 218, 309, or 932 to Gongren Wenhua Gong (Workers'' Cultural Palace) or Canglangting stops
- Driving: Navigate to “Canglang Pavilion Scenic Area.” Public parking is available nearby, but spaces are limited on holidays; public transport is recommended
- Taxi/ride-hailing: Set destination to “No. 3 Canglangting Street” or “Canglang Pavilion Scenic Area”',
  '[{"icon": "🎫", "label": "Ticket", "value": "- Adult ticket: CNY 20 per person\n- Discount ticket: CNY 10 per person (students, seniors aged 60-69 with valid ID)\n- Free admission: children under 6 or under 1.4m, seniors aged 70+, active servicemen, and people with disabilities (valid ID required)\n- Note: Prices are subject to on-site announcement"}, {"icon": "🕘", "label": "Opening Hours", "value": "- March 1 – October 31: 07:30–17:30 (ticket sales and entry stop at 17:00)\n- November 1 – February 28: 07:30–17:00 (ticket sales and entry stop at 16:30)"}, {"icon": "🚇", "label": "Metro", "value": "- Metro: Take Metro Line 3 or Line 4 to Canglangting Station, then walk about 5–8 minutes\n- Bus: Take tourist lines 2, 4, or 5, or bus routes 1, 5, 27, 30, 47, 101, 102, 103, 218, 309, or 932 to Gongren Wenhua Gong (Workers'' Cultural Palace) or Canglangting stops\n- Driving: Navigate to “Canglang Pavilion Scenic Area.” Public parking is available nearby, but spaces are limited on holidays; public transport is recommended\n- Taxi/ride-hailing: Set destination to “No. 3 Canglangting Street” or “Canglang Pavilion Scenic Area”"}]'::jsonb, '[]'::jsonb, '[]'::jsonb,
  'No. 3 Canglangting Street, Gusu District, Suzhou, Jiangsu Province, China', '江苏省苏州市姑苏区沧浪亭街3号',
  0, 'com.chinago.travel.attraction.suzhou_canglang_pavilion', 3, TRUE
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
  'suzhou_master_of_nets_garden', 'suzhou', 'Master-of-Nets Garden / Wangshi Garden', '网师园',
  'garden', 'attractions/suzhou_master_of_nets_garden.png', 'The ultimate example of a small-scale Suzhou classical garden, celebrated for its exquisite compact design and the famous Night Garden performances.', 'Located at No. 11 Kuojiatou Lane, Gusu District, Suzhou, Master-of-Nets Garden was founded during the Chunxi reign of the Southern Song Dynasty on the former site of “Wanjuan Hall,” the residence of official Shi Zhengzhi. It was rebuilt during the Qianlong reign of the Qing Dynasty by Song Zongyuan, who named it “Master-of-Nets Garden” to evoke the hermit ideal of the fisherman. In 1997, it was inscribed on the UNESCO World Heritage List as a representative of Suzhou classical gardens.

Covering only about 0.54 hectares, it is the smallest yet most exquisite of Suzhou gardens. The layout centers on a middle pond, surrounded by halls, pavilions, studies, and rockeries, creating an integrated residence-garden space. Key buildings include the Sedan Chair Hall, Wanjuan Hall, Xiexiu Tower, Yungang Rockery, Zhuoying Water Pavilion, Yue Dao Feng Lai Pavilion, Zhuwai Yizhi Xuan, Kansong Duhua Xuan, and Dianchun Yi. The Dianchun Yi courtyard was replicated in 1980 at the Metropolitan Museum of Art in New York as “The Astor Court,” a landmark in the global spread of Chinese gardens.

The garden is celebrated for the art of “seeing the large within the small.” Its buildings, rockeries, pond, and plants are proportioned with exquisite precision, creating a sense of depth and vastness within a tiny space. From March to November, the “Night Garden” combines Kunqu opera, Pingtan, guqin, Jiangnan silk-bamboo music, and flute performances with the garden''s night scenery. Recommended by UNESCO as a special tourism program, it is one of the best ways to experience Suzhou''s evening culture.',
  'P1', '- Adult ticket: CNY 40 in peak season, CNY 30 in off-season
- Discount ticket: CNY 20 in peak season, CNY 15 in off-season (students, seniors aged 60-69 with valid ID)
- Free admission: children under 6 or under 1.4m, seniors aged 70+, active servicemen, and people with disabilities (valid ID required)
- Night Garden: approximately CNY 100 per person (includes night garden visit and traditional performances); subject to official announcement
- Peak season: April, May, July, August, September, October; off-season: January, February, March, June, November, December
- Note: Prices are subject to on-site announcement', NULL,
  '- Daytime:
  - Peak season (April, May, July–October): 07:30–17:30 (ticket sales and entry stop at 17:00)
  - Off-season (January–March, June, November, December): 07:30–17:00 (ticket sales and entry stop at 16:30)
- Night Garden: generally open from around March to November, approximately 19:30–22:00; specific sessions subject to official announcement', NULL,
  FALSE, '- Metro: Take Metro Line 5 to Nanyuan North Road Station and walk 8–10 minutes; or take Line 4 to Sanyuanfang Station and walk about 15 minutes
- Bus: Take tourist lines 2, 4, or 5, or bus routes 2, 4, 5, 9, 27, 30, 47, 101, 102, 103, 202, 204, 218, 309, 529, 931, 932, or 933 to Master-of-Nets Garden, Daichengqiao Road, or Nanyuan Bridge North stops
- Driving: Navigate to “Master-of-Nets Garden.” Roads nearby are narrow and parking is limited; public transport is recommended
- Taxi/ride-hailing: Set destination to “No. 11 Kuojiatou Lane, Master-of-Nets Garden”',
  '[{"icon": "🎫", "label": "Ticket", "value": "- Adult ticket: CNY 40 in peak season, CNY 30 in off-season\n- Discount ticket: CNY 20 in peak season, CNY 15 in off-season (students, seniors aged 60-69 with valid ID)\n- Free admission: children under 6 or under 1.4m, seniors aged 70+, active servicemen, and people with disabilities (valid ID required)\n- Night Garden: approximately CNY 100 per person (includes night garden visit and traditional performances); subject to official announcement\n- Peak season: April, May, July, August, September, October; off-season: January, February, March, June, November, December\n- Note: Prices are subject to on-site announcement"}, {"icon": "🕘", "label": "Opening Hours", "value": "- Daytime:\n  - Peak season (April, May, July–October): 07:30–17:30 (ticket sales and entry stop at 17:00)\n  - Off-season (January–March, June, November, December): 07:30–17:00 (ticket sales and entry stop at 16:30)\n- Night Garden: generally open from around March to November, approximately 19:30–22:00; specific sessions subject to official announcement"}, {"icon": "🚇", "label": "Metro", "value": "- Metro: Take Metro Line 5 to Nanyuan North Road Station and walk 8–10 minutes; or take Line 4 to Sanyuanfang Station and walk about 15 minutes\n- Bus: Take tourist lines 2, 4, or 5, or bus routes 2, 4, 5, 9, 27, 30, 47, 101, 102, 103, 202, 204, 218, 309, 529, 931, 932, or 933 to Master-of-Nets Garden, Daichengqiao Road, or Nanyuan Bridge North stops\n- Driving: Navigate to “Master-of-Nets Garden.” Roads nearby are narrow and parking is limited; public transport is recommended\n- Taxi/ride-hailing: Set destination to “No. 11 Kuojiatou Lane, Master-of-Nets Garden”"}]'::jsonb, '[]'::jsonb, '[]'::jsonb,
  'No. 11 Kuojiatou Lane, Gusu District, Suzhou, Jiangsu Province, China', '江苏省苏州市姑苏区阔家头巷11号',
  0, 'com.chinago.travel.attraction.suzhou_master_of_nets_garden', 4, TRUE
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
  'suzhou_huanxiu_mountain_villa', 'suzhou', 'Huanxiu Mountain Villa', '环秀山庄',
  'garden', 'attractions/suzhou_huanxiu_mountain_villa.png', 'Famed for its “thousand-li landscape within a foot” lake-rock mountain, it is regarded as the pinnacle of rockery art in Chinese gardens.', 'Located at No. 272 Jingde Road, Gusu District, Suzhou, Huanxiu Mountain Villa sits in the bustling old city yet offers tranquil seclusion. It is a UNESCO World Heritage site combining residence, garden, and artificial mountain. Its history dates back to the Wuyue period of the Five Dynasties, when it was the site of the Qian family''s Jingu Garden. After repeated renovations during the Ming and Qing dynasties, the present garden layout was largely formed in the Qing Dynasty.

The villa''s greatest treasure is the lake-rock mountain created by Qing-dynasty rockery master Ge Yuliang. Occupying less than half an acre, this miniature mountain is celebrated as the king of Chinese garden rockeries for its “boundless grandeur within an arm''s reach.” Built from Taihu stones, it features a towering main peak embraced by secondary peaks, with caves, bridges, and winding paths that make visitors feel as if they are wandering through real mountains. Qing scholar Yu Yue praised it as “a thousand-li landscape within a foot.”

Buildings such as Bu Qiu Fang, Ban Tan Qiu Shui Yi Fang Shan, and You Gu Tang are arranged according to the terrain, blending with the rockery to form a three-dimensional landscape painting. Though compact, Huanxiu Mountain Villa epitomizes the Jiangnan garden principle of “seeing the large within the small,” making it an invaluable example for studying classical Chinese rockery art.',
  'P1', '- Adult ticket: CNY 15 per person
- Discount ticket: CNY 7.5 per person (students, seniors aged 60-69 with valid ID)
- Free admission: children under 6 or under 1.4m, seniors aged 70+, active servicemen, and people with disabilities (valid ID required)
- Note: Closed on Mondays (except public holidays). Prices are subject to on-site announcement', NULL,
  '- Year-round: 08:30–16:30 (ticket sales and entry stop at 16:00)
- Closed on Mondays (except public holidays)', 'Closed on Mondays (except public holidays)',
  FALSE, '- Metro: Take Metro Line 1 to Yangyuxiang or Lindun Road station and walk 10–15 minutes; or take Line 4 to Chayuanchang station and walk about 8 minutes
- Bus: Take tourist lines 1 or 2, or bus routes 38, 46, 50, 69, 101, 102, 103, 202, 262, 301, 313, 501, or 933 to Chayuanchang, Jingde Road, or Children''s Hospital Jingde Road Campus stops
- Driving: Navigate to “Huanxiu Mountain Villa” or “Suzhou Embroidery Museum.” Roads nearby are narrow and parking is limited; public transport is recommended
- Taxi/ride-hailing: Set destination to “No. 272 Jingde Road, Huanxiu Mountain Villa”',
  '[{"icon": "🎫", "label": "Ticket", "value": "- Adult ticket: CNY 15 per person\n- Discount ticket: CNY 7.5 per person (students, seniors aged 60-69 with valid ID)\n- Free admission: children under 6 or under 1.4m, seniors aged 70+, active servicemen, and people with disabilities (valid ID required)\n- Note: Closed on Mondays (except public holidays). Prices are subject to on-site announcement"}, {"icon": "🕘", "label": "Opening Hours", "value": "- Year-round: 08:30–16:30 (ticket sales and entry stop at 16:00)\n- Closed on Mondays (except public holidays)"}, {"icon": "❌", "label": "Closed", "value": "Closed on Mondays (except public holidays)"}, {"icon": "🚇", "label": "Metro", "value": "- Metro: Take Metro Line 1 to Yangyuxiang or Lindun Road station and walk 10–15 minutes; or take Line 4 to Chayuanchang station and walk about 8 minutes\n- Bus: Take tourist lines 1 or 2, or bus routes 38, 46, 50, 69, 101, 102, 103, 202, 262, 301, 313, 501, or 933 to Chayuanchang, Jingde Road, or Children''s Hospital Jingde Road Campus stops\n- Driving: Navigate to “Huanxiu Mountain Villa” or “Suzhou Embroidery Museum.” Roads nearby are narrow and parking is limited; public transport is recommended\n- Taxi/ride-hailing: Set destination to “No. 272 Jingde Road, Huanxiu Mountain Villa”"}]'::jsonb, '[]'::jsonb, '[]'::jsonb,
  'No. 272 Jingde Road, Gusu District, Suzhou, Jiangsu Province, China (inside Suzhou Embroidery Museum)', '江苏省苏州市姑苏区景德路272号（苏州刺绣博物馆内）',
  0, 'com.chinago.travel.attraction.suzhou_huanxiu_mountain_villa', 5, TRUE
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
  'suzhou_ou_garden', 'suzhou', 'Couple''s Retreat Garden / Ou Yuan', '耦园（又称藕园）',
  'garden', 'attractions/suzhou_ou_garden.png', 'Suzhou''s most romantic “garden of love,” whose name and paired eastern-western layout symbolize conjugal harmony.', 'Located at No. 6 Xiaoxinqiao Lane, Cang Street, Gusu District, Suzhou, Couple''s Retreat Garden sits in the northeast corner of the old city, facing the city moat to the east and Pingjiang Road to the west. Its history dates to the early Qing Dynasty, when it was originally called Sheyuan. It was later purchased and renovated by official Shen Bingcheng, who renamed it “Ou Yuan” (Couple''s Garden), evoking the ideal of a husband and wife farming and living together in harmony. In 2000, it was added to the UNESCO World Heritage List as an extension of the Classical Gardens of Suzhou.

Covering about 0.8 hectares, the garden features a residence in the center with an eastern and a western garden on either side, forming a unique “one residence, two gardens” layout that echoes the meaning of “couple.” The eastern garden centers on a yellow-rock hill, accompanied by Chengqü Thatched Cottage, Shuangzhao Tower, and Tinglu Tower, presenting an open and bright atmosphere. The western garden centers on a pond, with Zhilian Old House, the library, and Heshou Pavilion built along the water, offering a serene and elegant setting. A winding corridor connects the two gardens, symbolizing a couple walking hand in hand.

Couple''s Retreat Garden is not only one of Suzhou''s most distinctive gardens but also a vivid expression of the Jiangnan literati ideal of retirement. Its steles, couplets, and lattice windows exude scholarly charm. The famous couplet “Ou Yuan houses a fine couple; the city corner builds a poetic city” captures the owners'' vision of harmonious married life. Today, the garden is a popular spot for wedding photography and romantic visits.',
  'P1', '- Adult ticket: CNY 25 per person
- Discount ticket: CNY 12.5 per person (students, seniors aged 60-69 with valid ID)
- Free admission: children under 6 or under 1.4m, seniors aged 70+, active servicemen, and people with disabilities (valid ID required)
- Note: Prices are subject to on-site announcement. Advance booking via official channels is recommended', NULL,
  '- Peak season (March 1 – October 31): 07:30–17:30 (ticket sales and entry stop at 17:00)
- Off-season (November 1 – February 28): 07:30–17:00 (ticket sales and entry stop at 16:30)', NULL,
  FALSE, '- Metro: Take Metro Line 1 to Xiangmen Station and walk about 10 minutes along Cang Street; or take Line 6 to Lindun Road Station and walk about 8 minutes
- Bus: Take tourist lines 1, 2, or 5, or bus routes 2, 5, 9, 40, 60, 89, 146, 178, 200, 202, 204, 261, 305, 307, 311, 529, 800, 900, 923, or 925 to Xiangmen, Pingjiang Road, or Cang Street stops
- Driving: Navigate to “Couple''s Retreat Garden.” Roads in the old city are narrow and parking is limited; metro or bus is recommended
- Taxi/ride-hailing: Set destination to “No. 6 Xiaoxinqiao Lane, Cang Street, Couple''s Retreat Garden”',
  '[{"icon": "🎫", "label": "Ticket", "value": "- Adult ticket: CNY 25 per person\n- Discount ticket: CNY 12.5 per person (students, seniors aged 60-69 with valid ID)\n- Free admission: children under 6 or under 1.4m, seniors aged 70+, active servicemen, and people with disabilities (valid ID required)\n- Note: Prices are subject to on-site announcement. Advance booking via official channels is recommended"}, {"icon": "🕘", "label": "Opening Hours", "value": "- Peak season (March 1 – October 31): 07:30–17:30 (ticket sales and entry stop at 17:00)\n- Off-season (November 1 – February 28): 07:30–17:00 (ticket sales and entry stop at 16:30)"}, {"icon": "🚇", "label": "Metro", "value": "- Metro: Take Metro Line 1 to Xiangmen Station and walk about 10 minutes along Cang Street; or take Line 6 to Lindun Road Station and walk about 8 minutes\n- Bus: Take tourist lines 1, 2, or 5, or bus routes 2, 5, 9, 40, 60, 89, 146, 178, 200, 202, 204, 261, 305, 307, 311, 529, 800, 900, 923, or 925 to Xiangmen, Pingjiang Road, or Cang Street stops\n- Driving: Navigate to “Couple''s Retreat Garden.” Roads in the old city are narrow and parking is limited; metro or bus is recommended\n- Taxi/ride-hailing: Set destination to “No. 6 Xiaoxinqiao Lane, Cang Street, Couple''s Retreat Garden”"}]'::jsonb, '[]'::jsonb, '[]'::jsonb,
  'No. 6 Xiaoxinqiao Lane, Cang Street, Gusu District, Suzhou, Jiangsu Province, China', '江苏省苏州市姑苏区仓街小新桥巷6号',
  0, 'com.chinago.travel.attraction.suzhou_ou_garden', 6, TRUE
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
  'suzhou_yi_garden', 'suzhou', 'Arts Garden / Yi Pu', '艺圃',
  'garden', 'attractions/suzhou_yi_garden.png', 'A Ming-dynasty garden hidden deep in Suzhou''s old city lanes, celebrated for its tranquil simplicity, mirror-like pond, and authentic literati atmosphere.', 'Located at No. 5 Wenya Lane, Gusu District, Suzhou, Arts Garden is hidden in a deep alley inside Changmen. It was founded during the Jiajing reign of the Ming Dynasty by Yuan Zugeng as a residential garden named Zuiying Hall. It later changed hands several times, becoming known as Yaopu and then Yi Pu. The present layout was largely formed during the Ming and Qing dynasties. In 2000, it was added to the UNESCO World Heritage List as an extension of the Classical Gardens of Suzhou.

Covering about 0.38 hectares, Arts Garden is one of Suzhou''s smallest yet most refined gardens. Its layout centers on a middle pond with clear, mirror-like water, surrounded by Ruyu Pavilion, Qinlu, Boya Hall, Yanguang Pavilion, Ailian Wo, and Nanzhai. The northern side is dominated by a rockery with rugged stones and ancient trees, while the southern side features halls and studies that are elegant and serene. Plants such as banana, crape myrtle, osmanthus, and wintersweet provide seasonal interest throughout the year.

The garden''s greatest charm lies in its “hidden in the city” character. Unlike more famous Suzhou gardens, it has no grand entrance and is tucked away in a narrow lane; visitors must wander through old alleys to find it. Once inside, the noise of the city fades, replaced by the sounds of water and birds. This unadorned, secluded atmosphere makes Arts Garden a favorite among locals and an ideal place to experience the authentic spirit of Jiangnan literati gardens.',
  'P1', '- Adult ticket: CNY 10 per person
- Discount ticket: CNY 5 per person (students, seniors aged 60-69 with valid ID)
- Free admission: children under 6 or under 1.4m, seniors aged 70+, active servicemen, and people with disabilities (valid ID required)
- Note: Prices are subject to on-site announcement', NULL,
  '- Peak season (March 1 – October 31): 07:30–17:30 (ticket sales and entry stop at 17:00)
- Off-season (November 1 – February 28): 07:30–17:00 (ticket sales and entry stop at 16:30)', NULL,
  FALSE, '- Metro: Take Metro Line 1 to Guangjinan Road Station and walk 10–15 minutes; or take Line 2 to Shilu Station and walk about 15 minutes
- Bus: Take bus routes 31, 54, or 501 to Changmen Hengjie stop, or routes 33, 88, 262, 301, or 313 to Children''s Hospital Jingde Road Campus stop, then walk 5–8 minutes
- Driving: Navigate to “Arts Garden.” Old city roads are narrow and parking is limited; public transport is recommended
- Taxi/ride-hailing: Set destination to “No. 5 Wenya Lane, Arts Garden”',
  '[{"icon": "🎫", "label": "Ticket", "value": "- Adult ticket: CNY 10 per person\n- Discount ticket: CNY 5 per person (students, seniors aged 60-69 with valid ID)\n- Free admission: children under 6 or under 1.4m, seniors aged 70+, active servicemen, and people with disabilities (valid ID required)\n- Note: Prices are subject to on-site announcement"}, {"icon": "🕘", "label": "Opening Hours", "value": "- Peak season (March 1 – October 31): 07:30–17:30 (ticket sales and entry stop at 17:00)\n- Off-season (November 1 – February 28): 07:30–17:00 (ticket sales and entry stop at 16:30)"}, {"icon": "🚇", "label": "Metro", "value": "- Metro: Take Metro Line 1 to Guangjinan Road Station and walk 10–15 minutes; or take Line 2 to Shilu Station and walk about 15 minutes\n- Bus: Take bus routes 31, 54, or 501 to Changmen Hengjie stop, or routes 33, 88, 262, 301, or 313 to Children''s Hospital Jingde Road Campus stop, then walk 5–8 minutes\n- Driving: Navigate to “Arts Garden.” Old city roads are narrow and parking is limited; public transport is recommended\n- Taxi/ride-hailing: Set destination to “No. 5 Wenya Lane, Arts Garden”"}]'::jsonb, '[]'::jsonb, '[]'::jsonb,
  'No. 5 Wenya Lane, inside Changmen, Gusu District, Suzhou, Jiangsu Province, China', '江苏省苏州市姑苏区阊门内文衙弄5号',
  0, 'com.chinago.travel.attraction.suzhou_yi_garden', 7, TRUE
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
  'suzhou_tuisi_garden', 'suzhou', 'Retreat & Reflection Garden / Tuisi Garden', '退思园',
  'garden', 'attractions/suzhou_tuisi_garden.png', 'A UNESCO World Heritage garden inside Tongli Ancient Town, celebrated for its philosophy of “retreating to reflect” and its delicate waterside layout.', 'Located at No. 1 Renjia Lane, Zhuhang Street, Tongli Town, Wujiang District, Suzhou, Retreat & Reflection Garden was built between 1885 and 1887 during the Guangxu reign of the Qing Dynasty. It was created by Ren Lansheng, a former military official who returned home after being dismissed from office. Its name is drawn from the Zuo Zhuan: “When advancing, think of loyalty; when retreating, think of mending faults,” reflecting the owner''s mood of introspection and retirement after political setbacks. In 2000, it was added to the UNESCO World Heritage List as an extension of the Classical Gardens of Suzhou.

Covering about 0.65 hectares, the garden breaks from traditional symmetrical layouts, unfolding horizontally from west to east with residence, courtyard, and garden sections. The garden centers on a pond, surrounded by Shuixiang Pavilion, Mianyun Pavilion, Guyushengliang Pavilion, Tian Bridge, Xin Terrace, and Retreat & Reflection Thatched Cottage. Because the buildings are constructed almost at water level, their reflections merge with the structures themselves, earning the garden the nickname “Waterside Garden.”

Despite its small size, Retreat & Reflection Garden is exquisitely conceived, with every rockery, plant, pavilion, and corridor carefully designed. The garden also preserves fine brick, wood, and stone carvings that reflect the high craftsmanship of late-Qing Jiangnan private gardens. It is not only the highlight of Tongli Ancient Town but also an important window into the complex psychology of traditional Chinese literati balancing public service and reclusion.',
  'P1', '- Separate ticket: CNY 30 per person
- Tongli Ancient Town combo ticket: CNY 100 per person (includes Retreat & Reflection Garden, Pearl Tower, Chongben Hall, Jiayin Hall, and other attractions)
- Discount ticket: CNY 15 per person (students, seniors aged 60–69 with valid ID)
- Free admission: children under 6 or under 1.4m, seniors aged 70+, active servicemen, and people with disabilities (valid ID required)
- Note: Prices are subject to on-site announcement', NULL,
  '- Year-round: 08:00–20:30
- Entry to attractions inside Tongli Ancient Town stops after 17:15
- Specific hours are subject to Tongli Ancient Town announcements', NULL,
  FALSE, '- Metro + bus: Take Metro Line 4 to Tongli Station, then transfer to bus 720, 725, or 735 to Tongli Ancient Town Shipailou stop, and walk into the ancient town along Zhuhang Street
- Bus: Take a bus from Suzhou South Bus Station to Tongli, departing about every 15 minutes with a journey of about 30 minutes; or take the ancient town shuttle
- Driving: Navigate to “Tongli Ancient Town Scenic Area,” park outside the ancient town, and walk in
- Taxi/ride-hailing: Set destination to “Retreat & Reflection Garden, Tongli Ancient Town” or “No. 1 Renjia Lane, Zhuhang Street, Tongli”',
  '[{"icon": "🎫", "label": "Ticket", "value": "- Separate ticket: CNY 30 per person\n- Tongli Ancient Town combo ticket: CNY 100 per person (includes Retreat & Reflection Garden, Pearl Tower, Chongben Hall, Jiayin Hall, and other attractions)\n- Discount ticket: CNY 15 per person (students, seniors aged 60–69 with valid ID)\n- Free admission: children under 6 or under 1.4m, seniors aged 70+, active servicemen, and people with disabilities (valid ID required)\n- Note: Prices are subject to on-site announcement"}, {"icon": "🕘", "label": "Opening Hours", "value": "- Year-round: 08:00–20:30\n- Entry to attractions inside Tongli Ancient Town stops after 17:15\n- Specific hours are subject to Tongli Ancient Town announcements"}, {"icon": "🚇", "label": "Metro", "value": "- Metro + bus: Take Metro Line 4 to Tongli Station, then transfer to bus 720, 725, or 735 to Tongli Ancient Town Shipailou stop, and walk into the ancient town along Zhuhang Street\n- Bus: Take a bus from Suzhou South Bus Station to Tongli, departing about every 15 minutes with a journey of about 30 minutes; or take the ancient town shuttle\n- Driving: Navigate to “Tongli Ancient Town Scenic Area,” park outside the ancient town, and walk in\n- Taxi/ride-hailing: Set destination to “Retreat & Reflection Garden, Tongli Ancient Town” or “No. 1 Renjia Lane, Zhuhang Street, Tongli”"}]'::jsonb, '[]'::jsonb, '[]'::jsonb,
  'No. 1 Renjia Lane, Zhuhang Street, Tongli Town, Wujiang District, Suzhou, Jiangsu Province, China (inside Tongli Ancient Town)', '江苏省苏州市吴江区同里镇竹行街任家弄1号（同里古镇内）',
  0, 'com.chinago.travel.attraction.suzhou_tuisi_garden', 8, TRUE
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
  'suzhou_museum', 'suzhou', 'Suzhou Museum', '苏州博物馆',
  'museum', 'attractions/suzhou_museum.png', 'A modern garden-style museum designed by master architect I. M. Pei, blending Suzhou''s history, art, and architectural beauty.', 'Located at No. 204 Northeast Street, Gusu District, Suzhou, Suzhou Museum was founded in 1960 and is one of China''s renowned comprehensive history and art museums. In October 2006, a new building designed by world-famous architect I. M. Pei opened, connected to the former mansion of Li Xiucheng of the Taiping Heavenly Kingdom, a national key cultural relic protection site. This creates a unique dialogue between old and new, past and present.

The museum holds nearly 40,000 sets of artifacts, with notable strengths in Wu-culture archaeological finds, Ming and Qing paintings and calligraphy, ancient crafts, Suzhou-style furniture, jade, and porcelain. Treasures include the sword of King Fuchai of Wu, the secret-color celadon lotus bowl, and the pearl-and-relic pagoda. Thematic exhibitions such as “Relics of the Wu Land,” “National Treasures from Wu Pagodas,” “Elegance of Wu,” and “Paintings and Calligraphy of the Wu School” trace thousands of years of Suzhou''s civilization and artistic achievements.

The building itself is one of the museum''s greatest highlights. I. M. Pei''s design concept was “Chinese yet new, Suzhou yet new,” combining traditional Suzhou garden features—white walls, black tiles, rockeries, and ponds—with modern geometric forms, steel structures, and glass lighting. The central courtyard''s stone hill, built from cut Taishan stones, evokes an ink-wash landscape. Skylights flood the central hall and galleries with soft natural light. Suzhou Museum is both a window into the city''s history and culture and a masterpiece of contemporary architecture integrated with classical gardens.',
  'P0', '- Suzhou Museum main building: free admission
- Suzhou Museum West Wing: free admission
- Reservation required: Visitors must book online in advance through the museum''s official website, WeChat official account, or “Suzhou Museum Reservation” mini-program, and enter with valid ID
- Note: Entry without reservation is not permitted. Booking 7 days in advance is recommended for holidays', NULL,
  '- Tuesday to Sunday: 09:00–17:00 (entry stops at 16:00)
- Closed on Mondays (except public holidays)
- Special events or night openings are subject to official announcements', 'Closed on Mondays (except public holidays)',
  TRUE, '- Metro: Take Metro Line 4 to Beisi Pagoda Station and walk 10–15 minutes; or take Line 6 to Humble Administrator''s Garden Station and walk about 8 minutes
- Bus: Take tourist lines 1, 2, or 5, or bus routes 55, 178, 202, 301, 305, 313, 529, 923, or 925 to Suzhou Museum, Humble Administrator''s Garden, or Lion Grove Garden stops
- Driving: Navigate to “Suzhou Museum.” Parking is available nearby but limited in the old city; public transport is recommended
- Taxi/ride-hailing: Set destination to “No. 204 Northeast Street, Suzhou Museum”',
  '[{"icon": "🎫", "label": "Ticket", "value": "- Suzhou Museum main building: free admission\n- Suzhou Museum West Wing: free admission\n- Reservation required: Visitors must book online in advance through the museum''s official website, WeChat official account, or “Suzhou Museum Reservation” mini-program, and enter with valid ID\n- Note: Entry without reservation is not permitted. Booking 7 days in advance is recommended for holidays"}, {"icon": "🕘", "label": "Opening Hours", "value": "- Tuesday to Sunday: 09:00–17:00 (entry stops at 16:00)\n- Closed on Mondays (except public holidays)\n- Special events or night openings are subject to official announcements"}, {"icon": "❌", "label": "Closed", "value": "Closed on Mondays (except public holidays)"}, {"icon": "🚇", "label": "Metro", "value": "- Metro: Take Metro Line 4 to Beisi Pagoda Station and walk 10–15 minutes; or take Line 6 to Humble Administrator''s Garden Station and walk about 8 minutes\n- Bus: Take tourist lines 1, 2, or 5, or bus routes 55, 178, 202, 301, 305, 313, 529, 923, or 925 to Suzhou Museum, Humble Administrator''s Garden, or Lion Grove Garden stops\n- Driving: Navigate to “Suzhou Museum.” Parking is available nearby but limited in the old city; public transport is recommended\n- Taxi/ride-hailing: Set destination to “No. 204 Northeast Street, Suzhou Museum”"}]'::jsonb, '[]'::jsonb, '[]'::jsonb,
  'No. 204 Northeast Street, Gusu District, Suzhou, Jiangsu Province, China', '江苏省苏州市姑苏区东北街204号',
  0, 'com.chinago.travel.attraction.suzhou_museum', 9, TRUE
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
  'suzhou_pingjiang_road', 'suzhou', 'Pingjiang Road Historical Block / Pingjiang Historic District', '平江路历史街区',
  'market', 'attractions/suzhou_pingjiang_road.png', 'The best-preserved and largest historic district in Suzhou''s old city, hailed as “a miniature of Suzhou''s ancient city.”', 'Located in Gusu District, Suzhou, Pingjiang Road Historical Block occupies the northeast corner of Suzhou''s old city. It is the best-preserved and largest historic cultural district in Suzhou and one of China''s first historic cultural blocks. Centered on the Pingjiang River, the street runs over 1,600 meters, bordered by the outer moat to the east, Lindun Road to the west, Ganjiang Road to the south, and Baita East Road to the north, covering about 116.5 hectares.

Pingjiang Road''s history dates back to the Song Dynasty, when Suzhou had a “three horizontal and four vertical” waterway system. Pingjiang Road and the north-south Pingjiang River were one of the “four verticals.” The district preserves the unique checkerboard layout where roads and waterways run parallel, with white-walled, black-tiled houses, ancient trees, stone bridges, and boatwomen rowing beneath—an authentic Jiangnan water-town scene.

The street is lined with historic sites and cultural spaces, including Couple''s Retreat Garden, the Shanxi Guild Hall, the Kunqu Opera Museum, the Pingtan Museum, and the Number One Scholar Museum. Today, Pingjiang Road blends traditional crafts, time-honored brands, and Suzhou-style snacks with independent bookstores, cafés, creative shops, and boutique guesthouses. Whether it''s morning tea fragrance, afternoon Pingtan performances, or lantern-lit riverbanks at night, Pingjiang Road offers a vivid taste of Suzhou''s unhurried lifestyle and cultural depth.',
  'P1', '- The street is open to the public free of charge, 24 hours a day
- Some internal attractions, museums, guild halls, and gardens charge separate admission fees; check on-site notices
- Boat rides: charged separately according to posted rates', NULL,
  '- The street is open 24 hours a day
- Shops, restaurants, and museums along the street generally operate from 09:00 to 22:00; hours vary by venue', NULL,
  FALSE, '- Metro: Take Metro Line 1 to Xiangmen or Lindun Road station and walk 5–10 minutes to Pingjiang Road
- Bus: Take tourist lines 1, 2, or 5, or bus routes 2, 5, 9, 40, 60, 89, 146, 178, 200, 202, 204, 261, 305, 307, 311, 529, 800, 900, 923, or 925 to Xiangmen, Pingjiang Road, Lindun Road, or Suzhou Municipal Hospital East District stops
- Driving: Navigate to “Pingjiang Road Historical Block.” Roads in the old city are narrow and parking is scarce; park in nearby lots and walk
- Taxi/ride-hailing: Set destination to “Pingjiang Road” or “Pingjiang Road Historical Block (Xiangmen Entrance)”',
  '[{"icon": "🎫", "label": "Ticket", "value": "- The street is open to the public free of charge, 24 hours a day\n- Some internal attractions, museums, guild halls, and gardens charge separate admission fees; check on-site notices\n- Boat rides: charged separately according to posted rates"}, {"icon": "🕘", "label": "Opening Hours", "value": "- The street is open 24 hours a day\n- Shops, restaurants, and museums along the street generally operate from 09:00 to 22:00; hours vary by venue"}, {"icon": "🚇", "label": "Metro", "value": "- Metro: Take Metro Line 1 to Xiangmen or Lindun Road station and walk 5–10 minutes to Pingjiang Road\n- Bus: Take tourist lines 1, 2, or 5, or bus routes 2, 5, 9, 40, 60, 89, 146, 178, 200, 202, 204, 261, 305, 307, 311, 529, 800, 900, 923, or 925 to Xiangmen, Pingjiang Road, Lindun Road, or Suzhou Municipal Hospital East District stops\n- Driving: Navigate to “Pingjiang Road Historical Block.” Roads in the old city are narrow and parking is scarce; park in nearby lots and walk\n- Taxi/ride-hailing: Set destination to “Pingjiang Road” or “Pingjiang Road Historical Block (Xiangmen Entrance)”"}]'::jsonb, '[]'::jsonb, '[]'::jsonb,
  'Pingjiang Road, Gusu District, Suzhou, Jiangsu Province, China (from Ganjiang Road in the south to Baita East Road in the north)', '江苏省苏州市姑苏区平江路（南起干将路，北至白塔东路）',
  0, 'com.chinago.travel.attraction.suzhou_pingjiang_road', 10, TRUE
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
  'suzhou_zhouzhuang_ancient_town', 'suzhou', 'Zhouzhuang Ancient Town', '周庄古镇',
  'sight', 'attractions/suzhou_zhouzhuang_ancient_town.png', 'Known as China''s Number One Water Town, famed for its well-shaped waterways, Ming-Qing bridges, and grand waterside mansions such as Shen Hall and Zhang Hall.', 'Located in Zhouzhuang Town, Kunshan City, Suzhou, between Shanghai, Suzhou, and Hangzhou, Zhouzhuang Ancient Town is one of the six great ancient water towns of Jiangnan and one of China''s earliest and best-known water towns. Founded in 1086 during the Northern Song Dynasty, it was originally called Zhenfeng Li and was later renamed Zhouzhuang in honor of local official Zhou Digong, who donated land for a temple.

Zhouzhuang''s most distinctive feature is its well-shaped canal layout. Four main waterways divide the town into eight long streets, connected by 14 ancient bridges, creating the classic Jiangnan scene of “small bridges, flowing water, and households.” The Twin Bridges—Shide Bridge and Yong''an Bridge—became world-famous through the painting “Memory of Hometown” by Chinese-American artist Chen Yifei, and they remain the symbol of Zhouzhuang. Other notable bridges include Fu''an Bridge, Zhenfeng Bridge, and Taiping Bridge.

The town preserves numerous Ming and Qing residences, ancestral halls, gardens, and temples. Shen Hall is a grand mansion built by descendants of Shen Wansan, the richest man in Jiangnan during the Ming Dynasty. Zhang Hall is a Ming official''s residence famous for the layout where “sedan chairs enter through the gate while boats pass through the house.” Other attractions include Milou, Chengxu Taoist Temple, Quanfu Temple, and Nanhu Qiuyue Garden. Local delicacies such as Wansan Pork Hock, Grandma''s Tea, Qingtuan rice balls, and Sock-Sole Crisp are not to be missed. Whether boating by day or wandering lantern-lit alleys at night, Zhouzhuang offers the purest experience of Jiangnan water-town culture.',
  'P0', '- Day ticket: CNY 100 per person
- Night ticket: subject to on-site announcement
- Half-price ticket: CNY 50 per person (minors aged 6–18, full-time undergraduate students and below, seniors aged 60–69 with valid ID)
- Free admission: children under 6 or under 1.4m, seniors aged 70+, active servicemen, and people with disabilities (valid ID required)
- Note: Tickets are valid on the day of purchase and allow multiple entries within ticket-selling hours. Prices are subject to on-site announcement', NULL,
  '- Scenic area: 08:00–21:00
- Ticket sales: 08:00–17:00
- Opening hours of individual attractions vary; check on-site notices
- Night tours are subject to official announcements', NULL,
  FALSE, '- High-speed/regular train: Take a high-speed train to Kunshan South Station and transfer by bus or taxi to Zhouzhuang, about 40 minutes; or take a regular train to Kunshan Station and transfer to bus 133 or tourist line 7
- Bus: Take a bus from Suzhou North Bus Station or Kunshan Bus Station to Zhouzhuang; from Kunshan city center, take bus 130, 133, or tourist line 7 to Zhouzhuang Bus Station
- Driving: Navigate to “Zhouzhuang Ancient Town Scenic Area.” From Shanghai or Suzhou, take the S58 highway and exit at Zhouzhuang; several parking lots are available nearby
- Taxi/ride-hailing: Set destination to “No. 43 Quanfu Road, Zhouzhuang Ancient Town” or “Zhouzhuang Ancient Archway”',
  '[{"icon": "🎫", "label": "Ticket", "value": "- Day ticket: CNY 100 per person\n- Night ticket: subject to on-site announcement\n- Half-price ticket: CNY 50 per person (minors aged 6–18, full-time undergraduate students and below, seniors aged 60–69 with valid ID)\n- Free admission: children under 6 or under 1.4m, seniors aged 70+, active servicemen, and people with disabilities (valid ID required)\n- Note: Tickets are valid on the day of purchase and allow multiple entries within ticket-selling hours. Prices are subject to on-site announcement"}, {"icon": "🕘", "label": "Opening Hours", "value": "- Scenic area: 08:00–21:00\n- Ticket sales: 08:00–17:00\n- Opening hours of individual attractions vary; check on-site notices\n- Night tours are subject to official announcements"}, {"icon": "🚇", "label": "Metro", "value": "- High-speed/regular train: Take a high-speed train to Kunshan South Station and transfer by bus or taxi to Zhouzhuang, about 40 minutes; or take a regular train to Kunshan Station and transfer to bus 133 or tourist line 7\n- Bus: Take a bus from Suzhou North Bus Station or Kunshan Bus Station to Zhouzhuang; from Kunshan city center, take bus 130, 133, or tourist line 7 to Zhouzhuang Bus Station\n- Driving: Navigate to “Zhouzhuang Ancient Town Scenic Area.” From Shanghai or Suzhou, take the S58 highway and exit at Zhouzhuang; several parking lots are available nearby\n- Taxi/ride-hailing: Set destination to “No. 43 Quanfu Road, Zhouzhuang Ancient Town” or “Zhouzhuang Ancient Archway”"}]'::jsonb, '[]'::jsonb, '[]'::jsonb,
  'No. 43 Quanfu Road, Zhouzhuang Town, Kunshan City, Suzhou, Jiangsu Province, China', '江苏省苏州市昆山市周庄镇全福路43号',
  0, 'com.chinago.travel.attraction.suzhou_zhouzhuang_ancient_town', 11, TRUE
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
  'suzhou_tongli_ancient_town', 'suzhou', 'Tongli Ancient Town', '同里古镇',
  'sight', 'attractions/suzhou_tongli_ancient_town.png', 'One of the six great ancient water towns of Jiangnan, famed for its “small bridges, flowing water, and households” layout and Ming-Qing gardens such as the Retreat & Reflection Garden.', 'Located in Wujiang District, Suzhou, about 18 kilometers from downtown, Tongli Ancient Town lies beside Taihu Lake and the Beijing-Hangzhou Grand Canal. It is one of the six great ancient water towns of Jiangnan, a famous Chinese historical and cultural town, and a national 5A tourist attraction. Founded in the Song Dynasty over 1,000 years ago, it was originally called “Futu” and later renamed “Tongli,” symbolizing a close-knit community working together.

Tongli is best known for its distinctive water-town layout. Surrounded by five lakes—Tongli, Jiuli, Yeze, Nanxing, and Panshan—the town is crisscrossed by 15 rivers that naturally divide it into seven islets, connected by 49 ancient bridges. Houses, shops, temples, and gardens line the waterways, bringing to life the poetic image of “small bridges, flowing water, and households.”

The town is rich in cultural relics. The Retreat & Reflection Garden is its crown jewel and a UNESCO World Heritage site. Other highlights include Chongben Hall, Jiayin Hall, the Three Bridges (Taiping, Jili, and Changqing), Pearl Tower Garden, Gengle Hall, and Songshi Wuyuan. Ming-Qing Street is lined with shops offering local delicacies such as Taihu''s “three whites” (whitefish, white shrimp, and whitebait), Sock-Sole Crisp, and Scholar''s Trotter. Whether boating along the canals, strolling across stone bridges, or staying in a waterside inn, Tongli offers an immersive experience of Jiangnan''s gentle beauty and tranquility.',
  'P1', '- Ancient town ticket: CNY 100 per person (valid on the day of purchase; includes access to paid attractions within the town)
- Advance booking: approximately CNY 80 per person (recommended to book online one day in advance)
- Discount ticket: CNY 50 per person (minors aged 6–18, full-time undergraduate students and below, seniors aged 60–69 with valid ID)
- Free admission: children under 6 or under 1.4m, seniors aged 70+, active servicemen, and people with disabilities (valid ID required)
- Note: Prices and policies are subject to on-site announcement', NULL,
  '- Scenic area: 08:00–17:15 year-round
- Opening hours of individual attractions within the town vary; check on-site notices
- Night tours and evening activities are subject to official announcements', NULL,
  FALSE, '- Metro: Take Metro Line 4 to Tongli Station, then transfer to Wujiang Smart Rail T1 or bus routes 725, 735, 720, or 759 to Tongli Ancient Town or Shipailou stops
- Bus: Take a bus from Suzhou South Bus Station to Tongli, departing about every 15 minutes with a journey of about 30 minutes; or take city bus routes 735, 725, 720, or 759 directly to the ancient town
- Driving: Navigate to “Tongli Ancient Town Scenic Area.” Several parking lots are available nearby; arrive early on holidays
- Taxi/ride-hailing: Set destination to “No. 1 Zhongchuan South Road, Tongli Ancient Town” or “Tongli Ancient Town Shipailou”',
  '[{"icon": "🎫", "label": "Ticket", "value": "- Ancient town ticket: CNY 100 per person (valid on the day of purchase; includes access to paid attractions within the town)\n- Advance booking: approximately CNY 80 per person (recommended to book online one day in advance)\n- Discount ticket: CNY 50 per person (minors aged 6–18, full-time undergraduate students and below, seniors aged 60–69 with valid ID)\n- Free admission: children under 6 or under 1.4m, seniors aged 70+, active servicemen, and people with disabilities (valid ID required)\n- Note: Prices and policies are subject to on-site announcement"}, {"icon": "🕘", "label": "Opening Hours", "value": "- Scenic area: 08:00–17:15 year-round\n- Opening hours of individual attractions within the town vary; check on-site notices\n- Night tours and evening activities are subject to official announcements"}, {"icon": "🚇", "label": "Metro", "value": "- Metro: Take Metro Line 4 to Tongli Station, then transfer to Wujiang Smart Rail T1 or bus routes 725, 735, 720, or 759 to Tongli Ancient Town or Shipailou stops\n- Bus: Take a bus from Suzhou South Bus Station to Tongli, departing about every 15 minutes with a journey of about 30 minutes; or take city bus routes 735, 725, 720, or 759 directly to the ancient town\n- Driving: Navigate to “Tongli Ancient Town Scenic Area.” Several parking lots are available nearby; arrive early on holidays\n- Taxi/ride-hailing: Set destination to “No. 1 Zhongchuan South Road, Tongli Ancient Town” or “Tongli Ancient Town Shipailou”"}]'::jsonb, '[]'::jsonb, '[]'::jsonb,
  'No. 1 Zhongchuan South Road, Wujiang District, Suzhou, Jiangsu Province, China (Tongli Ancient Town Scenic Area)', '江苏省苏州市吴江区中川南路1号（同里古镇景区）',
  0, 'com.chinago.travel.attraction.suzhou_tongli_ancient_town', 12, TRUE
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
