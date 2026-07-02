-- Seed: hangzhou attractions from Desktop Markdown
-- Text fields = verbatim English sections from source docs.
-- practical_info = Ticket / Duration / Opening Hours / Closed / Metro from MD sections.
-- Idempotent: ON CONFLICT (id) DO UPDATE

INSERT INTO attractions (
  id, city_id, name, chinese_name, category, cover_image_path, summary, introduction,
  priority, ticket_price, recommended_duration, opening_hours, closed_days,
  requires_advance_booking, metro_access, practical_info, western_visitor_tips, nearby_places,
  address_en, address_zh, audio_guide_count, iap_product_id, display_order, is_published
) VALUES (
  'hangzhou_west_lake', 'hangzhou', 'West Lake (Xi Hu)', '西湖',
  'park', 'attractions/hangzhou_west_lake.png', 'West Lake is the soul of Hangzhou and China''s most famous urban lake, renowned for its ''Ten Scenes.'' Inscribed as a UNESCO World Heritage Site in 2011, it is China''s only lake-type World Cultural Heritage property.', 'West Lake, in Xihu District, Hangzhou, surrounded by hills on three sides with the lake at center, covers ~60 km² (water surface 6.39 km²). It was designated a National Key Scenic Spot (1982) and 5A Tourist Attraction (2007). On June 24, 2011, West Lake Cultural Landscape was UNESCO World Heritage-listed — China''s only lake-type World Cultural Heritage. The lake''s layout comprises ''one mountain (Solitary Hill), two pagodas (Baochu and Leifeng), three islets, three causeways (Bai, Su, Yanggong), and five lake sections.'' The Ten Scenes, dating to the Southern Song, capture different moods across seasons and times of day. The 15 km lakeside loop connects 100+ parks and 60+ cultural sites. Key attractions: Bai Causeway/Broken Bridge (where White Snake legend lovers met), Su Causeway (built by governor Su Shi), Three Pools Mirroring the Moon (1 RMB banknote image), Leifeng Pagoda, Yue Fei Temple, Solitary Hill (Xiling Seal Society), and more. Free to explore by walking, cycling (public bike rentals), or boating. The nightly musical fountain show is a must-see spectacle.',
  'P0', 'West Lake lakeside area is FREE. Individual attractions charge separately: Leifeng Pagoda 40 RMB, Yue Fei Temple 25 RMB, Three Pools Mirroring the Moon (incl. boat) 55 RMB, Lingyin Feilai Peak 45 RMB, Liuhe Pagoda 20 RMB (+10 RMB to climb), Guo''s Villa 10 RMB, Hupao Spring 15 RMB, etc.', NULL,
  'West Lake lakeside area: open 24/7. Paid attractions generally 7:00-17:30 (winter) or 7:00-18:30 (summer). Check individual attraction notices for specifics.', NULL,
  FALSE, 'Metro Line 1 to Longxiangqiao or Fengqi Road stations, walk to lakeside; Line 7 to Wushan Square. Bus: Inner/Outer Lake Circle routes, plus Routes 4, 7, 12, 27, 31, 51 with lakeside stops. Public bicycles (red bikes) available at rental points around the lake. Hop-on hop-off sightseeing buses circle the lake (pay by segment).',
  '[{"icon": "🎫", "label": "Ticket", "value": "West Lake lakeside area is FREE. Individual attractions charge separately: Leifeng Pagoda 40 RMB, Yue Fei Temple 25 RMB, Three Pools Mirroring the Moon (incl. boat) 55 RMB, Lingyin Feilai Peak 45 RMB, Liuhe Pagoda 20 RMB (+10 RMB to climb), Guo''s Villa 10 RMB, Hupao Spring 15 RMB, etc."}, {"icon": "🕘", "label": "Opening Hours", "value": "West Lake lakeside area: open 24/7. Paid attractions generally 7:00-17:30 (winter) or 7:00-18:30 (summer). Check individual attraction notices for specifics."}, {"icon": "🚇", "label": "Metro", "value": "Metro Line 1 to Longxiangqiao or Fengqi Road stations, walk to lakeside; Line 7 to Wushan Square. Bus: Inner/Outer Lake Circle routes, plus Routes 4, 7, 12, 27, 31, 51 with lakeside stops. Public bicycles (red bikes) available at rental points around the lake. Hop-on hop-off sightseeing buses circle the lake (pay by segment)."}]'::jsonb, '[]'::jsonb, '[]'::jsonb,
  'No.1 Longjing Road, Xihu District, Hangzhou, Zhejiang Province (West Lake Scenic Area)', '浙江省杭州市西湖区龙井路1号（西湖风景名胜区）',
  0, 'com.chinago.travel.attraction.hangzhou_west_lake', 0, TRUE
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
  'hangzhou_lingyin_temple', 'hangzhou', 'Lingyin Temple (Temple of Soul''s Retreat)', '灵隐寺',
  'temple', 'attractions/hangzhou_lingyin_temple.png', 'Lingyin Temple, Hangzhou''s oldest Buddhist monastery founded in 326 AD (Eastern Jin Dynasty), has approximately 1,700 years of history. One of China''s Ten Great Chan Buddhist Temples, it is world-famous for the Feilai Peak grotto sculptures and its profound Zen atmosphere.', 'Lingyin Temple, at No.1 Fayun Lane, Lingyin Road, Xihu District, sits in the Lingyin foothills flanked by Feilai Peak and Beigao Peak. One of China''s Ten Great Chan Buddhist Temples, it was founded in 326 AD by the Indian monk Huili. Legend holds that upon reaching Feilai Peak, Huili exclaimed, ''This is a small peak from Vulture Peak in Central India — how did it fly here?'' Hence the name ''Feilai Peak'' (Peak that Flew Here), and the temple was named ''Lingyin'' — ''the retreat of the soul.'' The temple reached its zenith during the Wuyue Kingdom with nine towers, eighteen pavilions, and over 3,000 monks. Most existing structures date from the Qing Dynasty, arrayed along the central axis. Feilai Peak preserves 345 Buddhist grotto carvings from the 10th-14th centuries, with Yuan Dynasty Tibetan Buddhist-style carvings being especially precious. The temple is intimately associated with the legendary monk Jigong, who took vows here. Ancient camphor trees over a thousand years old stand among yellow-walled halls. Note: visitors typically purchase a Feilai Peak scenic area ticket (45 RMB) first, then a separate Lingyin Temple incense ticket (30 RMB).',
  'P0', 'Feilai Peak Scenic Area: 45 RMB; Lingyin Temple Incense Ticket: 30 RMB. Total: 75 RMB. Half-price for seniors, children, and students. Hangzhou Temple Annual Pass waives the incense fee.', NULL,
  'Daily 7:30-18:00 (last entry 17:00). Hours may adjust during special Dharma assemblies.', NULL,
  FALSE, 'Bus Routes 7, 278, 324M, 505 to Lingyin Station. Metro Line 3 to Dongyue Station, then transfer to bus or 10-min taxi. Lingyin Road can be heavily congested during holidays; metro + bus recommended. Scenic shuttle from Faxi Temple to Lingyin Temple (10 RMB).',
  '[{"icon": "🎫", "label": "Ticket", "value": "Feilai Peak Scenic Area: 45 RMB; Lingyin Temple Incense Ticket: 30 RMB. Total: 75 RMB. Half-price for seniors, children, and students. Hangzhou Temple Annual Pass waives the incense fee."}, {"icon": "🕘", "label": "Opening Hours", "value": "Daily 7:30-18:00 (last entry 17:00). Hours may adjust during special Dharma assemblies."}, {"icon": "🚇", "label": "Metro", "value": "Bus Routes 7, 278, 324M, 505 to Lingyin Station. Metro Line 3 to Dongyue Station, then transfer to bus or 10-min taxi. Lingyin Road can be heavily congested during holidays; metro + bus recommended. Scenic shuttle from Faxi Temple to Lingyin Temple (10 RMB)."}]'::jsonb, '[]'::jsonb, '[]'::jsonb,
  'No.1 Fayun Lane, Lingyin Road, Xihu District, Hangzhou, Zhejiang Province', '浙江省杭州市西湖区灵隐路法云弄1号',
  0, 'com.chinago.travel.attraction.hangzhou_lingyin_temple', 1, TRUE
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
  'hangzhou_leifeng_pagoda', 'hangzhou', 'Leifeng Pagoda (Leifeng Tower)', '雷峰塔',
  'temple', 'attractions/hangzhou_leifeng_pagoda.png', 'Leifeng Pagoda, site of West Lake''s iconic ''Leifeng Pagoda in Evening Glow,'' was first built in 977 AD. World-famous for the Legend of the White Snake, it was rebuilt in 2002, offering 360-degree panoramic views of West Lake.', 'Leifeng Pagoda, at No.15 Nanshan Road in the West Lake Scenic Area, stands on Sunset Hill on West Lake''s southern shore. Originally named Huangfei Pagoda, it was built in 977 AD by Qian Chu, the last king of the Wuyue Kingdom, to enshrine the Buddha''s hair relic. The original seven-story octagonal brick-and-wood pagoda was burned by Japanese pirates during the Ming Jiajing reign, leaving only the brick core. On September 25, 1924, the millennium-old pagoda finally collapsed. The new pagoda, rebuilt in 2002, uses an innovative steel-frame, bronze-clad structure that restores Southern Song architectural form while showcasing bronze culture through modern techniques. Standing 71.679 meters with five above-ground and two underground floors, it displays national treasures including the gilt-silver Ashoka Stupa. Immortalized by the Legend of the White Snake — the story of Bai Suzhen imprisoned beneath the pagoda by Monk Fahai — it carries a romantic yet tragic cultural aura. From the top, a 360-degree panorama unfolds: Baochu Pagoda north, lakeside east, Jingci Temple south, and Su Causeway west. At dusk, ''Leifeng Pagoda in Evening Glow'' is breathtaking.',
  'P0', 'Adult: 40 RMB. Combo tickets: Pagoda + Yue Fei Temple 60 RMB; Pagoda + Lake Cruise 75 RMB. Half-price for seniors, children, and students.', NULL,
  'Nov 1-Mar 15: 8:00-17:30; Mar 16-Apr 30: 8:00-19:00; May 1-Oct 31: 8:00-20:00. Ticket sales stop 30 minutes before closing.', NULL,
  FALSE, 'Bus Routes 4, 12, 31, 51, 52, 315 to Jingci Temple or Leifeng Pagoda Station. West Lake sightseeing bus also stops here. Metro Line 7 to Wushan Square Station, then transfer to bus or walk about 20 min.',
  '[{"icon": "🎫", "label": "Ticket", "value": "Adult: 40 RMB. Combo tickets: Pagoda + Yue Fei Temple 60 RMB; Pagoda + Lake Cruise 75 RMB. Half-price for seniors, children, and students."}, {"icon": "🕘", "label": "Opening Hours", "value": "Nov 1-Mar 15: 8:00-17:30; Mar 16-Apr 30: 8:00-19:00; May 1-Oct 31: 8:00-20:00. Ticket sales stop 30 minutes before closing."}, {"icon": "🚇", "label": "Metro", "value": "Bus Routes 4, 12, 31, 51, 52, 315 to Jingci Temple or Leifeng Pagoda Station. West Lake sightseeing bus also stops here. Metro Line 7 to Wushan Square Station, then transfer to bus or walk about 20 min."}]'::jsonb, '[]'::jsonb, '[]'::jsonb,
  'No.15 Nanshan Road, Xihu District, Hangzhou, Zhejiang Province', '浙江省杭州市西湖区南山路15号',
  0, 'com.chinago.travel.attraction.hangzhou_leifeng_pagoda', 2, TRUE
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
  'hangzhou_xixi_wetland', 'hangzhou', 'Xixi National Wetland Park', '西溪国家湿地公园',
  'park', 'attractions/hangzhou_xixi_wetland.png', 'Xixi Wetland is China''s first national wetland park, located in western Hangzhou less than 5 km from West Lake. A rare urban secondary wetland, it is renowned for its poetic charm and pristine waterscape, designated a national 5A tourist attraction.', 'Xixi National Wetland Park, at No.518 Tianmushan Road, Xihu District, western Hangzhou, less than 5 km from West Lake and 6 km from Wulinmen, covers ~11.5 km². It is China''s first wetland park integrating urban, agricultural, and cultural wetlands — the only site simultaneously holding national wetland park, national 5A attraction, and internationally important wetland status. Approximately 70% of the park comprises waterways, ponds, lakes, and marshes, with six main rivers crisscrossing to form a unique misty waterscape. The park is divided into East Area and West Area (Hong Garden). East Area highlights include Green Causeway (Flower Festival venue, spectacular spring blooms), Fu Causeway (main north-south trail), Shou Causeway, and an underwater ecological corridor. West Area''s Hong Garden features Hong family culture and traditional opera, with historic buildings including Hong Mansion and ancestral hall. A bird paradise, 186 species have been recorded, including endangered Oriental White Storks and Black-faced Spoonbills. Visitors can explore by electric boat or hand-rowed boat, drifting through reed marshes in poetic serenity. Xixi gained fame as a filming location for ''If You Are the One.'' Traditional dragon boat races are held here during the annual Dragon Boat Festival.',
  'P1', 'Adult: 80 RMB. Seniors/children/students: half-price 40 RMB. Electric boat: 60 RMB/person. Hand-rowed boat: ~100 RMB/hour. Some areas (e.g., Green Causeway) offer free admission during special periods like the Flower Festival.', NULL,
  'Summer (Apr 1-Oct 31): 7:30-18:30 (tickets until 17:30, last entry 18:00); Winter (Nov 1-Mar 31): 8:00-17:30 (tickets until 16:30, last entry 17:00).', NULL,
  FALSE, 'Metro Line 3 to Xixi Wetland South or Huawu Station; Line 19 to Xixi Wetland North Station. Bus Routes 83, 86, 149, 193, 310 to Xixi Wetland Zhoujiacun. By car: navigate to ''Zhoujiacun Entrance Parking.''',
  '[{"icon": "🎫", "label": "Ticket", "value": "Adult: 80 RMB. Seniors/children/students: half-price 40 RMB. Electric boat: 60 RMB/person. Hand-rowed boat: ~100 RMB/hour. Some areas (e.g., Green Causeway) offer free admission during special periods like the Flower Festival."}, {"icon": "🕘", "label": "Opening Hours", "value": "Summer (Apr 1-Oct 31): 7:30-18:30 (tickets until 17:30, last entry 18:00); Winter (Nov 1-Mar 31): 8:00-17:30 (tickets until 16:30, last entry 17:00)."}, {"icon": "🚇", "label": "Metro", "value": "Metro Line 3 to Xixi Wetland South or Huawu Station; Line 19 to Xixi Wetland North Station. Bus Routes 83, 86, 149, 193, 310 to Xixi Wetland Zhoujiacun. By car: navigate to ''Zhoujiacun Entrance Parking.''"}]'::jsonb, '[]'::jsonb, '[]'::jsonb,
  'No.518 Tianmushan Road, Xihu District, Hangzhou, Zhejiang Province (Zhoujiacun Entrance)', '浙江省杭州市西湖区天目山路518号（周家村入口）',
  0, 'com.chinago.travel.attraction.hangzhou_xixi_wetland', 3, TRUE
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
  'hangzhou_qiandao_lake', 'hangzhou', 'Qiandao Lake (Thousand Island Lake)', '千岛湖景区',
  'park', 'attractions/hangzhou_qiandao_lake.png', 'Qiandao Lake is an artificial lake formed in 1959 by the Xin''an River hydropower station, featuring 1,078 islands scattered across crystal-clear emerald waters. A national 5A tourist attraction, it is the most popular eco-resort destination in the Yangtze River Delta region.', 'Qiandao Lake Scenic Area, in Chun''an County, Hangzhou, is located in the Yangtze River Delta hinterland, about 150 km from Hangzhou and 140 km from Huangshan. Formed in 1959 when the Xin''an River Dam was completed, the dendritic lake covers 573 km² with an average depth of 34 meters (maximum over 100 meters). Its 1,078 islands give it the name ''Thousand Island Lake.'' The lake is famous for its unique landscape — water quality consistently meets national Grade I standards with visibility of 7-12 meters, earning the title ''Number One Beautiful Water Under Heaven.'' The Central and Southeast lake districts are the main tourist areas. Central District features Meifeng Island (panoramic views), Moonlight Island (romance-themed island group), Dragon Mountain Island (home to Hai Rui Shrine), and Yule Island. Southeast District boasts Huangshan Peak (famous for its ''Tian Xia Wei Gong'' four-character island formation), Tianchi Island, and Osmanthus Island. Remarkably, two ancient cities — Shi Cheng and He Cheng — lie submerged beneath the lake, nicknamed ''Underwater Pyramids.'' A 150 km lakeside greenway encircles the lake, perfect for cycling. The lake is renowned for its organic fish head soup, a must-try local delicacy. Best visiting season: March to November.',
  'P0', 'Central District: Adult 130 RMB + boat 65 RMB (total 195 RMB); Southeast District: same pricing. Half-price admission for seniors, children, and students. Advance online reservation and ticket purchase required.', NULL,
  'Lake area: 8:00-16:00 (boat departures mainly in the morning; arrive at pier by 8:00-10:00 recommended). Individual island hours may vary.', NULL,
  TRUE, 'High-speed rail: Hangzhou East/West Station to Qiandao Lake Station, ~1 hour, ~70 RMB. Shuttle Bus 1 from station to lake pier (15 RMB, ~45 min). By car: ~2 hours via Hangzhou-Qiandao Expressway. Long-distance bus: Hangzhou West Bus Station to Qiandao Lake, ~2.5 hours.',
  '[{"icon": "🎫", "label": "Ticket", "value": "Central District: Adult 130 RMB + boat 65 RMB (total 195 RMB); Southeast District: same pricing. Half-price admission for seniors, children, and students. Advance online reservation and ticket purchase required."}, {"icon": "🕘", "label": "Opening Hours", "value": "Lake area: 8:00-16:00 (boat departures mainly in the morning; arrive at pier by 8:00-10:00 recommended). Individual island hours may vary."}, {"icon": "🚇", "label": "Metro", "value": "High-speed rail: Hangzhou East/West Station to Qiandao Lake Station, ~1 hour, ~70 RMB. Shuttle Bus 1 from station to lake pier (15 RMB, ~45 min). By car: ~2 hours via Hangzhou-Qiandao Expressway. Long-distance bus: Hangzhou West Bus Station to Qiandao Lake, ~2.5 hours."}]'::jsonb, '[]'::jsonb, '[]'::jsonb,
  'Qiandaohu Town, Chun''an County, Hangzhou, Zhejiang Province (Central District Pier: No.348 Menggu Road)', '浙江省杭州市淳安县千岛湖镇（中心湖区旅游码头：梦姑路348号）',
  0, 'com.chinago.travel.attraction.hangzhou_qiandao_lake', 4, TRUE
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
  'hangzhou_zhejiang_museum', 'hangzhou', 'Zhejiang Provincial Museum', '浙江省博物馆',
  'museum', 'attractions/hangzhou_zhejiang_museum.png', 'The Zhejiang Provincial Museum is Zhejiang''s largest comprehensive humanities museum, with two main venues — Zhijiang and Gushan. Housing over 100,000 artifacts, it is renowned for its Liangzhu jades, Yue kiln celadon, and the masterpiece painting ''Dwelling in the Fuchun Mountains.''', 'Founded in 1929, the Zhejiang Provincial Museum is Zhejiang''s largest comprehensive humanities museum and a National First-Class Museum, operating two main venues with over 100,000 artifacts. The **Gushan Venue** at No.25 Gushan Road, Xihu District, sits on Solitary Hill''s southern slope by West Lake. Comprising several historic Sino-Western buildings, it is known as ''the museum by West Lake.'' It focuses on thematic displays of ceramics, celadon, and lacquerware, with a garden layout harmonizing with the lake scenery. The Wenlan Pavilion within is one of the seven Qing Dynasty imperial libraries housing the ''Complete Library of the Four Treasuries.'' The **Zhijiang Venue** at Bibo Road, Zhijiang Cultural Center, opened in August 2023 with 100,000 m² of floor space — one of Zhejiang''s largest public cultural facilities. It features ''Zhejiang Through Ten Thousand Years,'' a comprehensive historical exhibition tracing Zhejiang from prehistory to modern times, plus thematic galleries for Liangzhu jades, Yue kiln celadon, Song Dynasty culture, and maritime culture. Collection highlights: the Liangzhu ''King of Jade Cong'' (~6.5 kg, the pinnacle of deity-and-beast motif art); Huang Gongwang''s Yuan Dynasty ''Dwelling in the Fuchun Mountains: Surviving Mountain Scroll'' (one of China''s Ten Great Masterpieces); a Warring States King Zhe sword; Northern Song painted clay Bodhisattva statues; and a Five Dynasties gilt-bronze Guanyin. Both venues offer free admission with advance reservation via the museum''s WeChat account. Zhijiang is closed Mondays (except holidays); Gushan is open year-round.',
  'P1', 'FREE. Advance reservation required via the museum''s WeChat account (up to 7 days ahead). Special temporary exhibitions may charge separately.', NULL,
  'Zhijiang Venue: Tue-Sun 9:00-17:00 (last entry 16:30), closed Mon (except holidays). Gushan Venue: Tue-Sun 9:00-17:00 (last entry 16:30), closed Mon (except holidays).', NULL,
  TRUE, 'Zhijiang: Metro Line 6 to Zhijiang Cultural Center or Fenghua West Road (~10 min walk). Bus Routes 149, 324M to Zhijiang Cultural Center. Gushan: Bus Routes WE1314 and West Lake Outer Circle to Zhejiang Provincial Museum Station. Underground parking available at both venues.',
  '[{"icon": "🎫", "label": "Ticket", "value": "FREE. Advance reservation required via the museum''s WeChat account (up to 7 days ahead). Special temporary exhibitions may charge separately."}, {"icon": "🕘", "label": "Opening Hours", "value": "Zhijiang Venue: Tue-Sun 9:00-17:00 (last entry 16:30), closed Mon (except holidays). Gushan Venue: Tue-Sun 9:00-17:00 (last entry 16:30), closed Mon (except holidays)."}, {"icon": "🚇", "label": "Metro", "value": "Zhijiang: Metro Line 6 to Zhijiang Cultural Center or Fenghua West Road (~10 min walk). Bus Routes 149, 324M to Zhijiang Cultural Center. Gushan: Bus Routes WE1314 and West Lake Outer Circle to Zhejiang Provincial Museum Station. Underground parking available at both venues."}]'::jsonb, '[]'::jsonb, '[]'::jsonb,
  'Zhijiang Venue: Bibo Road, Zhijiang Cultural Center, Xihu District; Gushan Venue: No.25 Gushan Road, Xihu District, Hangzhou, Zhejiang', '之江馆区：杭州市西湖区碧波路之江文化中心；孤山馆区：杭州市西湖区孤山路25号',
  0, 'com.chinago.travel.attraction.hangzhou_zhejiang_museum', 5, TRUE
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
  'hangzhou_grand_canal', 'hangzhou', 'Beijing-Hangzhou Grand Canal (Hangzhou Section)', '京杭大运河（杭州段）',
  'sight', 'attractions/hangzhou_grand_canal.png', 'The Hangzhou section of the Beijing-Hangzhou Grand Canal is the southern highlight of the world''s longest man-made waterway, stretching about 7.3 km with Gongchen Bridge at its heart, linking three historical blocks and numerous museums — inscribed as a UNESCO World Heritage Site in 2014.', 'The Beijing-Hangzhou Grand Canal Hangzhou Scenic Area, located in Gongshu District, is an open linear scenic area stretching approximately 7.3 km from Wulinmen Pier to Shixiang Road, covering 4.1 square kilometers. Designated a national AAAA tourist attraction in 2012, the Grand Canal itself runs about 1,794 km from Beijing to Hangzhou — the world''s earliest, longest, and largest ancient canal project, standing alongside the Great Wall as one of China''s two great ancient engineering feats. In June 2014, the Grand Canal was inscribed as a UNESCO World Heritage Site. The Hangzhou section uses Gongchen Bridge as its geographical and cultural anchor, connecting three major cultural zones: Qiaoxi Historical Block, Xiaohe Straight Street, and Dadou Road Historical Block. The best way to explore is via the water bus from Wulinmen Pier, with the full journey taking 30-60 minutes for just 3 RMB. At night, the canal transforms as lights illuminate both banks and cruise boats glide through glittering reflections.',
  'P1', 'Canal-side blocks are free. Water bus: 3 RMB/person. Night cruise: approx. 100-150 RMB/person. All museums free.', NULL,
  'Canal banks: 24/7. Water bus: approx. 7:00-18:00 (varies by route). Museums: Tue-Sun 9:00-16:30.', NULL,
  FALSE, '- **Metro:** Lines 1/3/19 to West Lake Cultural Square Station; Line 3 to Xiangji Temple Station.
- **Water Bus:** Line 1 from Wulinmen Pier, 30-60 min cruise along the canal, fare 3 RMB.
- **Bus:** Multiple routes to Wulinmen or Gongchen Bridge stations.
- **By Car:** Navigate to "Wulinmen Pier" or "Canal World." Paid parking available.',
  '[{"icon": "🎫", "label": "Ticket", "value": "Canal-side blocks are free. Water bus: 3 RMB/person. Night cruise: approx. 100-150 RMB/person. All museums free."}, {"icon": "🕘", "label": "Opening Hours", "value": "Canal banks: 24/7. Water bus: approx. 7:00-18:00 (varies by route). Museums: Tue-Sun 9:00-16:30."}, {"icon": "🚇", "label": "Metro", "value": "- **Metro:** Lines 1/3/19 to West Lake Cultural Square Station; Line 3 to Xiangji Temple Station.\n- **Water Bus:** Line 1 from Wulinmen Pier, 30-60 min cruise along the canal, fare 3 RMB.\n- **Bus:** Multiple routes to Wulinmen or Gongchen Bridge stations.\n- **By Car:** Navigate to \"Wulinmen Pier\" or \"Canal World.\" Paid parking available."}]'::jsonb, '[]'::jsonb, '[]'::jsonb,
  'No.226 Huancheng North Road, Gongshu District, Hangzhou, Zhejiang (Wulinmen Pier)', '浙江省杭州市拱墅区环城北路226号（武林门码头）',
  0, 'com.chinago.travel.attraction.hangzhou_grand_canal', 6, TRUE
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
  'hangzhou_gongchen_bridge', 'hangzhou', 'Gongchen Bridge of the Grand Canal', '大运河拱宸桥',
  'sight', 'attractions/hangzhou_gongchen_bridge.png', 'Gongchen Bridge is the iconic three-arch stone bridge marking the southern terminus of the Beijing-Hangzhou Grand Canal, first built in 1631 (Ming Dynasty) and the oldest and tallest stone arch bridge in Hangzhou.', 'Gongchen Bridge, located at the northern end of Gongshu District in Hangzhou, connects Canal Cultural Square to the east and Qiaonong Street to the west. As the southern terminus of the Beijing-Hangzhou Grand Canal, it is the largest surviving stone arch bridge in urban Hangzhou. First built in 1631 (the fourth year of the Chongzhen reign, Ming Dynasty), rebuilt during the Kangxi period, widened during the Yongzheng period, and reconstructed in 1885 (the eleventh year of the Guangxu reign, Qing Dynasty), the bridge has a history of nearly 400 years. It measures about 92 meters long and 5.9 meters wide, with a central arch span of 15.8 meters and two side spans of 11.9 meters each — a classic three-arch stone bridge design. The bridge body is built with staggered stone blocks and long keystones, forming a gently curved deck. To protect the piers from boat collisions, each pier is guarded by a stone-carved mythical beast called "Paxia" (one of the dragon''s nine sons), exuding ancient solemnity. Gongchen Bridge is not only an important transport node but also the geographical origin point of the canal cultural belt — waterways extend north to Beijing and south to the Qiantang River and eastern Zhejiang water networks. To the west lies the lively Qiaoxi Historical Block, preserving late-Qing and early-Republican lane architecture; to the east, the spacious Canal Cultural Square offers a popular recreational space. The three national-level intangible cultural heritage museums nearby — the China Knives & Scissors Museum, China Umbrella Museum, and China Fan Museum — are all free to visit and offer excellent insights into Hangzhou''s traditional crafts. In 2014, the Grand Canal was inscribed as a UNESCO World Heritage Site, with Gongchen Bridge recognized as "living cultural heritage."',
  'P1', 'Free. The bridge itself is open 24/7 with no admission fee. The surrounding museum complex (Knives & Scissors Museum, Umbrella Museum, Fan Museum) is also free to visit.', NULL,
  'The bridge: open 24/7 year-round. Nearby museums: Tuesday–Sunday, 9:00–16:30 (closed Mondays, except public holidays).', NULL,
  FALSE, '- **Metro:** Take Line 5 to "Grand Canal Station" Exit D, about a 10-minute walk; or Line 3 to "Xiangji Temple Station," about a 15-minute walk.
- **Bus:** Routes 1, 79, 98, 129 to "Gongchen Bridge West Station"; or take Water Bus Line 1 to "Gongchen Bridge" Pier.
- **Water Bus:** Take Water Bus Line 1 from Wulinmen Pier, a scenic 30-minute cruise along the canal to Gongchen Bridge Pier. Fare: 3 RMB. A fantastic way to experience the canal.
- **By Car:** Navigate to "Gongchen Bridge" or "Canal Cultural Square." Paid parking available nearby.',
  '[{"icon": "🎫", "label": "Ticket", "value": "Free. The bridge itself is open 24/7 with no admission fee. The surrounding museum complex (Knives & Scissors Museum, Umbrella Museum, Fan Museum) is also free to visit."}, {"icon": "🕘", "label": "Opening Hours", "value": "The bridge: open 24/7 year-round. Nearby museums: Tuesday–Sunday, 9:00–16:30 (closed Mondays, except public holidays)."}, {"icon": "🚇", "label": "Metro", "value": "- **Metro:** Take Line 5 to \"Grand Canal Station\" Exit D, about a 10-minute walk; or Line 3 to \"Xiangji Temple Station,\" about a 15-minute walk.\n- **Bus:** Routes 1, 79, 98, 129 to \"Gongchen Bridge West Station\"; or take Water Bus Line 1 to \"Gongchen Bridge\" Pier.\n- **Water Bus:** Take Water Bus Line 1 from Wulinmen Pier, a scenic 30-minute cruise along the canal to Gongchen Bridge Pier. Fare: 3 RMB. A fantastic way to experience the canal.\n- **By Car:** Navigate to \"Gongchen Bridge\" or \"Canal Cultural Square.\" Paid parking available nearby."}]'::jsonb, '[]'::jsonb, '[]'::jsonb,
  'No.1 Qiaonong Street, Gongshu District, Hangzhou, Zhejiang Province (connected to Canal Cultural Square on the east and Qiaonong Street on the west)', '浙江省杭州市拱墅区桥弄街1号（东连运河文化广场，西接桥弄街）',
  0, 'com.chinago.travel.attraction.hangzhou_gongchen_bridge', 7, TRUE
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
  'hangzhou_liuhe_pagoda', 'hangzhou', 'Liuhe Pagoda (Six Harmonies Pagoda)', '六和塔',
  'temple', 'attractions/hangzhou_liuhe_pagoda.png', 'Liuhe Pagoda stands on Yuelun Hill by the Qiantang River, first built in 970 AD. As Hangzhou''s tallest ancient pagoda (59.89 m), it is renowned for calming the tides, guiding navigation, and providing the best vantage point for the famous Qiantang tidal bore.', 'Liuhe Pagoda, at No.16 Zhijiang Road, Xihu District, on Yuelun Hill by the Qiantang River, is an outstanding masterpiece of ancient Chinese architecture and a National Protected Cultural Relic. First built in 970 AD by Wuyue King Qian Chu to subdue the tidal bore, the original nine-story pagoda stood over 150 meters tall. The name ''Liuhe'' derives from the Buddhist principle of sixfold harmony: harmony in body, speech, mind, precepts, views, and benefits. Destroyed in war in 1121 and rebuilt in 1156, the current octagonal brick pagoda appears 13 stories externally but contains 7 actual floors, reaching 59.89 meters. Inside, 174 sets of exquisite brick carvings depict flowers, birds, beasts, celestial beings, and musicians. Important Song Dynasty stelae are preserved on the ground floor. From the top, the Qiantang River winds eastward and the bridge arches like a rainbow. Since ancient times, Liuhe Pagoda has served as a vital navigation landmark. During the annual tidal bore around the 18th day of the 8th lunar month, it becomes the premier viewing spot drawing immense crowds.',
  'P1', 'Liuhe Pagoda Cultural Park: 20 RMB; climbing the pagoda: additional 10 RMB. Total: 30 RMB. Half-price for seniors, children, and students.', NULL,
  'Summer (approx. Apr-Oct): 7:00-17:30; Winter (approx. Nov-Mar): 7:00-16:55.', NULL,
  FALSE, 'Bus Routes 4, 39, 308, 318, 334 to Liuhe Pagoda Station. Metro Line 4 to Shuichengqiao Station, then transfer to bus or walk about 15 minutes.',
  '[{"icon": "🎫", "label": "Ticket", "value": "Liuhe Pagoda Cultural Park: 20 RMB; climbing the pagoda: additional 10 RMB. Total: 30 RMB. Half-price for seniors, children, and students."}, {"icon": "🕘", "label": "Opening Hours", "value": "Summer (approx. Apr-Oct): 7:00-17:30; Winter (approx. Nov-Mar): 7:00-16:55."}, {"icon": "🚇", "label": "Metro", "value": "Bus Routes 4, 39, 308, 318, 334 to Liuhe Pagoda Station. Metro Line 4 to Shuichengqiao Station, then transfer to bus or walk about 15 minutes."}]'::jsonb, '[]'::jsonb, '[]'::jsonb,
  'No.16 Zhijiang Road, Xihu District, Hangzhou, Zhejiang Province', '浙江省杭州市西湖区之江路16号',
  0, 'com.chinago.travel.attraction.hangzhou_liuhe_pagoda', 8, TRUE
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
  'hangzhou_faxi_temple', 'hangzhou', 'Faxi Temple (Shangtianzhu Fajing Temple)', '法喜寺',
  'temple', 'attractions/hangzhou_faxi_temple.png', 'Faxi Temple, the largest of Hangzhou''s three Tianzhu Temples, is a thousand-year-old Buddhist monastery famous for its 500-year-old magnolia tree and matchmaking blessings, with yellow walls and black tiles nestled in the lush Tianzhu Mountains.', 'Faxi Temple, officially named Shangtianzhu Fajing Temple, is located at No.338 Tianzhu Road in Xihu District, Hangzhou, at the foot of Baiyun Peak in the Tianzhu Mountains. Founded during the Later Jin Dynasty (936–944 AD) by Master Daoyi, the temple has stood for over a thousand years. As the foremost of the "Three Tianzhu Temples" (Shangtianzhu Faxi Temple, Zhongtianzhu Fajing Temple, and Xiatianzhu Fajing Temple), it is the largest in scale, with halls rising in tiers along the mountain slope. Dedicated primarily to Guanyin (Avalokitesvara), Faxi Temple has flourished as a pilgrimage site for centuries and is known as the "Foremost Guanyin Sanctuary in Southeast China." In recent years, the temple has gained viral popularity among young people for its "matchmaking efficacy," with its omamori (amulets) becoming trendy cultural souvenirs. A Ming Dynasty magnolia tree, over 500 years old, blooms spectacularly each March, its snowy-white blossoms filling the mountain with fragrance — one of Hangzhou''s most anticipated spring floral events. The temple''s architecture features a classic palette of yellow walls, red pillars, black tiles, and upturned eaves, cascading up the hillside in harmony with the verdant surroundings. From the Hall of Heavenly Kings through the Hall of Perfect Penetration to the Grand Hall, ascending the stone steps feels like traveling through a millennium. The rear terrace offers breathtaking views of the Tianzhu peaks shrouded in mist.',
  'P1', '10 RMB per person. Free with Hangzhou Temple Annual Pass. Free admission for seniors over 70, retired officials, active military personnel, and persons with disabilities (ID required).', NULL,
  'Daily 6:30–18:00 (last entry at 18:00)', NULL,
  FALSE, '- **Bus:** Routes 103, 121, 324M to "Shangtianzhu Station." Or take the scenic shuttle from Lingyin Temple directly to Faxi Temple (10 RMB one way).
- **Metro + Bus:** Metro Line 3 to "Dongyue Station," transfer to Bus 103 to "Shangtianzhu Station."
- **By Car:** Navigate to "Faxi Temple Parking Lot." Parking: 10 RMB/hour. Limited spaces on weekends/holidays; public transport recommended.
- **Walking:** A pleasant 2 km walk from Lingyin Temple along Tianzhu Road, passing Zhongtianzhu and Xiatianzhu temples, takes about 30 minutes through bamboo groves and streams.',
  '[{"icon": "🎫", "label": "Ticket", "value": "10 RMB per person. Free with Hangzhou Temple Annual Pass. Free admission for seniors over 70, retired officials, active military personnel, and persons with disabilities (ID required)."}, {"icon": "🕘", "label": "Opening Hours", "value": "Daily 6:30–18:00 (last entry at 18:00)"}, {"icon": "🚇", "label": "Metro", "value": "- **Bus:** Routes 103, 121, 324M to \"Shangtianzhu Station.\" Or take the scenic shuttle from Lingyin Temple directly to Faxi Temple (10 RMB one way).\n- **Metro + Bus:** Metro Line 3 to \"Dongyue Station,\" transfer to Bus 103 to \"Shangtianzhu Station.\"\n- **By Car:** Navigate to \"Faxi Temple Parking Lot.\" Parking: 10 RMB/hour. Limited spaces on weekends/holidays; public transport recommended.\n- **Walking:** A pleasant 2 km walk from Lingyin Temple along Tianzhu Road, passing Zhongtianzhu and Xiatianzhu temples, takes about 30 minutes through bamboo groves and streams."}]'::jsonb, '[]'::jsonb, '[]'::jsonb,
  'No.338 Tianzhu Road, Xihu District, Hangzhou, Zhejiang Province', '浙江省杭州市西湖区天竺路338号',
  0, 'com.chinago.travel.attraction.hangzhou_faxi_temple', 9, TRUE
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
  'hangzhou_liangzhu_ancient_city', 'hangzhou', 'Archaeological Ruins of Liangzhu City', '良渚古城遗址公园',
  'museum', 'attractions/hangzhou_liangzhu_ancient_city.png', 'The Archaeological Ruins of Liangzhu City is the sacred site that substantiates China''s 5,000-year civilization, dating back 5,300-4,300 years. Known as ''China''s First City,'' it was inscribed as a UNESCO World Heritage Site in 2019.', 'Liangzhu Ancient City Archaeological Site Park, on Fengdu Road, Pingyao Town, Yuhang District, is the core site of Liangzhu Culture dating back 5,300-4,300 years, spanning approximately 1,000 years of the late Neolithic period. Archaeological discoveries began in 1936, and over eighty years of excavation have revealed more than 300 sites including high-ranking cemeteries, altars, jade ritual systems, large palace foundations, and ancient city walls. Archaeologists have hailed it as ''China''s First City.'' On July 6, 2019, Liangzhu Ancient City was inscribed as a UNESCO World Heritage Site. The park covers 42 km² across three areas. Key exhibition zones include: Mojiao Hill Palace Area (the city core, ~300,000 m²); Fanshan Royal Cemetery (where the ''King of Jade Cong'' was unearthed); ancient city wall remains; and China''s earliest known large-scale water conservancy system. Liangzhu Culture is world-renowned for exquisite jade craftsmanship. The park features beautiful seasonal landscapes and free-roaming sika deer. On June 15, 2023, the 19th Asian Games flame was kindled at Great Mojiao Hill.',
  'P1', 'Adult: 60 RMB (Hangzhou residents ~30 RMB with ID). Children/seniors/students: 30 RMB. Free during Hangzhou Liangzhu Day (Jul 5-13). Advance reservation via official WeChat account required.', NULL,
  'Daily 9:00-17:00 (last entry 16:00). Open year-round; check announcements for special closures.', NULL,
  TRUE, 'Metro Line 2 to Liangzhu Station Exit D, transfer to Bus 430M or 1222M to Liangzhu Ancient City Park Station. By car: navigate to South Entrance (parking available). Express Bus 348 from Hangzhou East Railway Station.',
  '[{"icon": "🎫", "label": "Ticket", "value": "Adult: 60 RMB (Hangzhou residents ~30 RMB with ID). Children/seniors/students: 30 RMB. Free during Hangzhou Liangzhu Day (Jul 5-13). Advance reservation via official WeChat account required."}, {"icon": "🕘", "label": "Opening Hours", "value": "Daily 9:00-17:00 (last entry 16:00). Open year-round; check announcements for special closures."}, {"icon": "🚇", "label": "Metro", "value": "Metro Line 2 to Liangzhu Station Exit D, transfer to Bus 430M or 1222M to Liangzhu Ancient City Park Station. By car: navigate to South Entrance (parking available). Express Bus 348 from Hangzhou East Railway Station."}]'::jsonb, '[]'::jsonb, '[]'::jsonb,
  'Fengdu Road, Pingyao Town, Yuhang District, Hangzhou, Zhejiang (South Entrance of Liangzhu Ancient City Park)', '浙江省杭州市余杭区瓶窑镇凤都路（良渚古城遗址公园南入口）',
  0, 'com.chinago.travel.attraction.hangzhou_liangzhu_ancient_city', 10, TRUE
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
  'hangzhou_hefang_street', 'hangzhou', 'Hefang Street (Qinghefang Historical Block)', '河坊街（清河坊历史街区）',
  'market', 'attractions/hangzhou_hefang_street.png', 'Hefang Street is the best-preserved Ming-Qing commercial street in Hangzhou, home to century-old brands and vibrant marketplace culture — the essential destination for experiencing Southern Song heritage and local folk traditions.', 'Hefang Street, also known as Qinghefang Historical Block, sits at the northern foot of Wushan Hill in Shangcheng District, stretching about 1,800 meters from Zhonghe Road in the east to Wushan Square in the west. It is Hangzhou''s best-preserved and most representative Ming-Qing commercial street. When Hangzhou (then Lin''an) was the Southern Song capital, Qinghefang was the most prosperous commercial center beneath the imperial city walls. The famous "Five Hangs" — Hangzhou scissors (Zhang Xiaoquan), fans (Wang Xingji), face powder (Kong Fengchun), tobacco (Mi Dachang), and silk thread (Zhang Yunsheng) — all originated here, representing the pinnacle of Hangzhou''s traditional handicrafts. The block predominantly features late-Qing and early-Republican architecture: two-story wooden buildings with white walls, black tiles, upturned eaves, and traditional signboards swaying alongside red lanterns. Hu Qing Yu Tang Pharmacy — "Qing Yu Tang in the South, Tong Ren Tang in the North" — with its magnificent Huizhou-style architecture, is the block''s landmark. Dozens of authentic Hangzhou snacks coexist with tea houses, herbal shops, antique stores, silk shops, and craft workshops, brimming with marketplace vitality. The western end connects to Wushan Square and Chenghuang Pavilion, where panoramic views of West Lake and Hangzhou await. Daily costume parades and traditional craft performances breathe new cultural life into this millennium-old street.',
  'P1', 'Free. The street is open to all with no admission fee. Some venues inside (e.g., Hu Qing Yu Tang Chinese Medicine Museum) may charge separately.', NULL,
  'Street: open 24/7 year-round. Shop hours generally 9:00–22:00, varying by individual store.', NULL,
  FALSE, '- **Metro:** Line 1 to Ding''an Road Station Exit C (10-min walk); Line 7 to Wushan Square Station.
- **Bus:** Routes 8, 25, 35, 38 to Wushan Square or Qinghefang Station.
- **By Car:** Navigate to "Wushan Square Parking" or "Gaoyin Street Parking" (approx. 10 RMB/hour).',
  '[{"icon": "🎫", "label": "Ticket", "value": "Free. The street is open to all with no admission fee. Some venues inside (e.g., Hu Qing Yu Tang Chinese Medicine Museum) may charge separately."}, {"icon": "🕘", "label": "Opening Hours", "value": "Street: open 24/7 year-round. Shop hours generally 9:00–22:00, varying by individual store."}, {"icon": "🚇", "label": "Metro", "value": "- **Metro:** Line 1 to Ding''an Road Station Exit C (10-min walk); Line 7 to Wushan Square Station.\n- **Bus:** Routes 8, 25, 35, 38 to Wushan Square or Qinghefang Station.\n- **By Car:** Navigate to \"Wushan Square Parking\" or \"Gaoyin Street Parking\" (approx. 10 RMB/hour)."}]'::jsonb, '[]'::jsonb, '[]'::jsonb,
  'Hefang Street, Shangcheng District, Hangzhou, Zhejiang Province (from Zhonghe Road east to Wushan Square west)', '浙江省杭州市上城区河坊街（东起中河路，西至吴山广场）',
  0, 'com.chinago.travel.attraction.hangzhou_hefang_street', 11, TRUE
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
  'hangzhou_xiaohe_street', 'hangzhou', 'Xiaohe Straight Street (Xiaohezhijie Historical Block)', '小河直街',
  'market', 'attractions/hangzhou_xiaohe_street.png', 'Xiaohe Straight Street, at the confluence of the Grand Canal, Xiaohe River, and Yuhangtang River, is Hangzhou''s most authentic canal-side historical block, featuring white walls, black tiles, small bridges, and flowing waters brimming with marketplace vitality and artistic charm.', 'Xiaohe Straight Street, near No.48 Xiaohe Road, Gongshu District, sits at the confluence of three rivers: the Grand Canal, Xiaohe River, and Yuhangtang River. The Xiaohe River runs through the entire block, dividing it into east and west banks and creating the classic Jiangnan scene of facing each other across the water. The area flourished because of waterways — since the Southern Song Dynasty it has been a distribution hub, and during the Ming-Qing canal transport boom, its catering, tea, and retail industries thrived. The block preserves extensive late-Qing and early-Republican riverside residences: two-story buildings with white walls, black tiles, wooden doors and windows, stone quays lining the banks, and weathered bluestone paths telling a century of stories. Unlike overly commercialized ancient streets, Xiaohe still houses many ''old Hangzhou'' residents, keeping authentic marketplace life — described as ''Republican-era architecture, modern living.'' Today, old houses have been transformed into distinctive independent coffee shops, leather/pottery craft workshops, creative boutiques, bookstores, tea houses, and canal cuisine restaurants, each reflecting its owner''s personality. Recommended stops: Old Bridge Noodle House (authentic Hangzhou noodles, open until 13:30), Riverside Fish House (marinated seafood, perfect for gatherings), various cat cafes and dessert shops. When lanterns glow at night and warm lights reflect on the water, it becomes the best place to experience ''old Hangzhou slow living.'' Free admission, metro accessible. Allow 2-3 hours to savor.',
  'P1', 'FREE. The block is open to all with no admission fee.', NULL,
  'Block: 24/7 year-round. Shops generally 10:00-21:00; cafes and restaurants stay open later. Individual hours vary; afternoon to evening is the best time to visit.', NULL,
  FALSE, 'Metro Line 5 to Grand Canal Station Exit D (~10 min walk); Line 3 to Xiangji Temple Station (~15 min walk). Bus Routes 1, 76 to Changzheng Bridge or Xiaohe Straight Street. Water Bus Line 1 to Gongchen Bridge, then ~15 min walk along the canal. By car: navigate to ''Xiaohe Straight Street Parking'' (limited spaces; public transport recommended).',
  '[{"icon": "🎫", "label": "Ticket", "value": "FREE. The block is open to all with no admission fee."}, {"icon": "🕘", "label": "Opening Hours", "value": "Block: 24/7 year-round. Shops generally 10:00-21:00; cafes and restaurants stay open later. Individual hours vary; afternoon to evening is the best time to visit."}, {"icon": "🚇", "label": "Metro", "value": "Metro Line 5 to Grand Canal Station Exit D (~10 min walk); Line 3 to Xiangji Temple Station (~15 min walk). Bus Routes 1, 76 to Changzheng Bridge or Xiaohe Straight Street. Water Bus Line 1 to Gongchen Bridge, then ~15 min walk along the canal. By car: navigate to ''Xiaohe Straight Street Parking'' (limited spaces; public transport recommended)."}]'::jsonb, '[]'::jsonb, '[]'::jsonb,
  'Near No.48 Xiaohe Road, Gongshu District, Hangzhou, Zhejiang (Xiaohezhijie Historical and Cultural Block)', '浙江省杭州市拱墅区小河路48号附近（小河直街历史文化街区）',
  0, 'com.chinago.travel.attraction.hangzhou_xiaohe_street', 12, TRUE
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
  'hangzhou_silk_museum', 'hangzhou', 'China National Silk Museum', '中国丝绸博物馆',
  'museum', 'attractions/hangzhou_silk_museum.png', 'The China National Silk Museum, located by West Lake at the foot of Yuhuang Hill, is China''s largest textile and costume-themed national first-class museum and the world''s largest silk museum, offering free admission to the public.', 'The China National Silk Museum, at No.73-1 Yuhuangshan Road, Xihu District, by West Lake at the foot of Yuhuang Hill, covers 42,286 m² with 22,999 m² of building space. Opened in 1992, it is China''s largest textile and costume-themed national first-class museum and the world''s largest silk museum. The museum comprehensively presents the 5,000-year history of Chinese silk and its role in civilizational exchange. Permanent exhibitions include: ''The Story of Chinese Silk,'' systematically narrating from Neolithic sericulture origins through dynastic silk development to East-West Silk Road exchanges; ''From Field to Wardrobe,'' presenting the complete silk production process from silkworm rearing, reeling, weaving, dyeing to garment-making with physical exhibits and interactive installations; and ''A Century of Chinese Fashion,'' tracing the evolution of Chinese clothing since the 20th century. The sericulture hall allows close observation of silkworms feeding on mulberry leaves, spinning cocoons, and emerging as moths — an excellent educational experience for families. The building, designed by internationally renowned architects, blends modern minimalist style with traditional Jiangnan garden aesthetics. Free admission; individual visitors do not need reservations.',
  'P2', 'Free admission. Individual visitors do not need reservations. Group visits require advance reservation via the official website or WeChat account.', NULL,
  'Tuesday-Sunday 9:00-17:00 (last entry 16:30). Closed Mondays (except public holidays).', NULL,
  TRUE, 'Bus Routes 12, 31, 42, 87, 133 to Silk Museum Station. Metro Line 7 to Wushan Square Station, then transfer to bus (~15 min). By car: navigate to ''China National Silk Museum'' (parking available on-site).',
  '[{"icon": "🎫", "label": "Ticket", "value": "Free admission. Individual visitors do not need reservations. Group visits require advance reservation via the official website or WeChat account."}, {"icon": "🕘", "label": "Opening Hours", "value": "Tuesday-Sunday 9:00-17:00 (last entry 16:30). Closed Mondays (except public holidays)."}, {"icon": "🚇", "label": "Metro", "value": "Bus Routes 12, 31, 42, 87, 133 to Silk Museum Station. Metro Line 7 to Wushan Square Station, then transfer to bus (~15 min). By car: navigate to ''China National Silk Museum'' (parking available on-site)."}]'::jsonb, '[]'::jsonb, '[]'::jsonb,
  'No.73-1 Yuhuangshan Road, Xihu District, Hangzhou, Zhejiang Province', '浙江省杭州市西湖区玉皇山路73-1号',
  0, 'com.chinago.travel.attraction.hangzhou_silk_museum', 13, TRUE
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
  'hangzhou_west_lake_cultural_plaza', 'hangzhou', 'West Lake Cultural Square', '西湖文化广场',
  'museum', NULL, 'West Lake Cultural Square, located north of the Grand Canal at Wulin Square in downtown Hangzhou, is a comprehensive urban landmark integrating culture, entertainment, exhibitions, and performances. Its 170-meter Global Center tower is one of Hangzhou''s iconic buildings.', 'West Lake Cultural Square, at No.47 Huancheng North Road, Gongshu District, sits at the core of downtown Hangzhou north of the Grand Canal at Wulin Square, just 2 km from West Lake. Covering 13.3 hectares with 350,000 m² of building space and ~100,000 m² of outdoor plaza, it opened fully in 2012. The design draws on West Lake culture, canal culture, and pagoda culture, reflecting the essence of Wuyue civilization. The 170-meter, 41-story Zhejiang Global Center is the Wulin business district landmark. The square houses major cultural venues: Zhejiang Museum of Natural History (200,000+ specimens, Asia''s largest gray whale skeleton and dinosaur fossils), Zhejiang Science and Technology Museum (VR capsules, robot theater), Zhejiang Culture and Art Center, and the Zhejiang Provincial Museum (Wulin branch). Commercial facilities include a bookstore, cinema, fitness center, and restaurants. The musical fountain operates nightly (19:30-20:30), synchronized with the Global Center light show. The canal-side platform offers the best photo spot for architectural reflections. The fan-shaped layout facing the canal symbolizes Hangzhou''s open, inclusive spirit. Metro Lines 1/3/19 provide direct access to this ''city living room.''',
  'P2', 'The square is FREE. Museums (Zhejiang Museum of Natural History, Science Museum) require advance reservation via their WeChat accounts (free). Cultural performances require separate tickets.', NULL,
  'Square: 24/7. Museums: generally Tue-Sun 9:00-16:30 (closed Mon). Musical fountain: nightly 19:30-20:30.', NULL,
  TRUE, 'Metro Lines 1/3/19 to West Lake Cultural Square Station Exit C/D. Bus Routes 3, 6, 26, 33, 78 to West Lake Cultural Square. By car: navigate to underground parking. Water Bus Line 1 to West Lake Cultural Square Pier.',
  '[{"icon": "🎫", "label": "Ticket", "value": "The square is FREE. Museums (Zhejiang Museum of Natural History, Science Museum) require advance reservation via their WeChat accounts (free). Cultural performances require separate tickets."}, {"icon": "🕘", "label": "Opening Hours", "value": "Square: 24/7. Museums: generally Tue-Sun 9:00-16:30 (closed Mon). Musical fountain: nightly 19:30-20:30."}, {"icon": "🚇", "label": "Metro", "value": "Metro Lines 1/3/19 to West Lake Cultural Square Station Exit C/D. Bus Routes 3, 6, 26, 33, 78 to West Lake Cultural Square. By car: navigate to underground parking. Water Bus Line 1 to West Lake Cultural Square Pier."}]'::jsonb, '[]'::jsonb, '[]'::jsonb,
  'No.47 Huancheng North Road, Gongshu District, Hangzhou, Zhejiang Province', '浙江省杭州市拱墅区环城北路47号',
  0, 'com.chinago.travel.attraction.hangzhou_west_lake_cultural_plaza', 14, TRUE
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
