-- Seed: chongqing attractions from Desktop Markdown
-- Text fields = verbatim English sections from source docs.
-- practical_info = concise summaries; scalar columns keep full EN text.
-- Idempotent: ON CONFLICT (id) DO UPDATE

INSERT INTO attractions (
  id, city_id, name, chinese_name, category, cover_image_path, summary, introduction,
  priority, ticket_price, recommended_duration, opening_hours, closed_days,
  requires_advance_booking, metro_access, practical_info, western_visitor_tips, nearby_places,
  address_en, address_zh, audio_guide_count, iap_product_id, display_order, is_published
) VALUES ('chongqing_hongya_cave',
  'chongqing',
  'Hongya Cave Folk Customs Area',
  '洪崖洞民俗风貌区',
  'sight',
  'attractions/chongqing_hongya_cave.png',
  'An 11-story stilt-house complex built along the mountain and river, golden and magnificent under the night, like the real-life version of "Spirited Away," it is Chongqing''s most iconic and magical internet-famous nightscape landmark.',
  'Hongya Cave Folk Customs Area is located by the Jialing River in Yuzhong District, Chongqing, next to Chongqing Jiefangbei Cangbai Road. It is the most renowned city name card and tourist landmark of Chongqing. The total building area of the project is about 46,000 square meters.',
  'P0',
  'Free admission (no ticket required for the folk customs area; some restaurants, bars, and hotels are charged separately)',
  NULL,
  '- Customs Area Public Areas: Open 24/7
- Shops/Restaurants: About 11:00-23:00 (may extend to 24:00 in summer)
- Lighting Time: Usually 19:30-23:00 (may start earlier at 19:00 in winter, may extend to 23:30 in summer)
- Note: The best viewing time is within 30 minutes after sunset, capturing the beautiful scene of architectural lights and twilight sky intersecting; the best photo spots are on Qiansimen Bridge or Jiangbeizui on the opposite side of the Jialing River',
  NULL,
  FALSE,
  '- Rail Transit: Take Chongqing Rail Transit Line 1 or 6, get off at Xiaoshizi Station, walk about 10 minutes; or take Line 2, get off at Linjiangmen Station, walk about 8 minutes
- Bus: Take buses 111, 112, 151, 181, 262, 322, 862, etc., get off at Hongya Cave Station
- Yangtze River Cableway: Take the cableway from Nanan District to Yuzhong District, walk about 5 minutes after exiting the station
- Taxi/Ride-hailing: Directly tell the driver "Hongya Cave"; you will arrive right at the destination
- Note: Hongya Cave has extremely high visitor traffic; roads around the area may be congested during holidays; it is recommended to prioritize rail transit',
  '[{"icon": "🎫", "label": "Ticket", "value": "Free"}, {"icon": "🕘", "label": "Opening Hours", "value": "11:00–23:00"}, {"icon": "🚇", "label": "Metro", "value": "Metro Line 1, Xiaoshizi Station"}]'::jsonb,
  '[]'::jsonb,
  '[]'::jsonb,
  'No. 88 Jialingjiang Riverside Road, Yuzhong District, Chongqing (next to Jiefangbei Cangbai Road, by the Jialing River)',
  '重庆市渝中区嘉陵江滨江路88号（解放碑沧白路旁，嘉陵江畔）',
  0,
  'com.chinago.travel.attraction.chongqing_hongya_cave',
  0,
  TRUE) ON CONFLICT (id) DO UPDATE SET
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
) VALUES ('chongqing_jiefangbei',
  'chongqing',
  'Jiefangbei (Liberation Monument)',
  '解放碑',
  'sight',
  'attractions/chongqing_jiefangbei.png',
  'Chongqing''s landmark and spiritual totem, a Monument to the War of Resistance Against Japan Victory standing in the center of a bustling business district, it is both the city''s geographical center and the eternal "soul of the city" in the hearts of Chongqing people.',
  'The full name of Jiefangbei is "Chongqing People''s Liberation Monument," located in the center of Jiefangbei Pedestrian Street in Yuzhong District, Chongqing. It is the most representative urban landmark and spiritual totem of Chongqing. The history of Jiefangbei can be traced back to 1940.',
  'P0',
  'Free admission (no ticket required for public areas around Jiefangbei Monument; shopping malls and restaurants in the vicinity are charged separately)',
  NULL,
  '- Public Areas Around the Monument: Open 24/7
- Best Visit Time: Nighttime, when the area around Jiefangbei is neon-lit and brilliant, you can enjoy both the monument light show and the business district nightscape
- Note: Jiefangbei Business District has extremely high visitor traffic, especially during holidays; please take care of personal belongings',
  NULL,
  FALSE,
  '- Rail Transit: Take Chongqing Rail Transit Line 1, 2, or 6, get off at Xiaoshizi Station, walk about 3 minutes from Exit D to arrive
- Bus: Take buses 105, 111, 112, 114, 135, 151, 181, 261, 462, 465, 601, 603, 868, etc., get off at Jiefangbei Station
- Taxi/Ride-hailing: Directly tell the driver "Jiefangbei" or "Jiefangbei Pedestrian Street"; you will arrive right at the destination
- Yangtze River Cableway: Take the cableway from Nanan District to Yuzhong District, walk about 10 minutes after exiting the station to arrive',
  '[{"icon": "🎫", "label": "Ticket", "value": "Free"}, {"icon": "🕘", "label": "Opening Hours", "value": "24/7"}, {"icon": "🚇", "label": "Metro", "value": "Metro Line 1, Xiaoshizi Station"}]'::jsonb,
  '[]'::jsonb,
  '[]'::jsonb,
  'Center of Jiefangbei Pedestrian Street, Yuzhong District, Chongqing (intersection of Minquan Road, Minzu Road, and Zourong Road)',
  '重庆市渝中区解放碑步行街中心（民权路、民族路、邹容路交汇处）',
  0,
  'com.chinago.travel.attraction.chongqing_jiefangbei',
  1,
  TRUE) ON CONFLICT (id) DO UPDATE SET
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
) VALUES ('chongqing_liziba_monorail',
  'chongqing',
  'Liziba Light Rail Passing Through Building',
  '李子坝轻轨穿楼',
  'sight',
  'attractions/chongqing_liziba_monorail.png',
  'The ultimate symbol of Chongqing''s "magic realim" — the wonder of Rail Transit Line 2 trains whistling through the middle of a residential building, letting the whole world witness the architectural miracle of perfect integration of mountain-city terrain and urban transportation.',
  'Liziba Light Rail Passing Through Building is located on Liziba Main Street in Yuzhong District, Chongqing. It is a unique station on Chongqing Rail Transit Line 2 — Liziba Station, and one of the most renowned and representative urban wonders of Chongqing.',
  'P0',
  'Free admission (no ticket required for the viewing platform; riding the light rail requires purchasing a ticket, starting price 2 RMB)',
  NULL,
  '- Viewing Platform: Open 24/7
- Light Rail Operating Hours: About 06:30-23:00 (trains run about every 6-8 minutes)
- Note: You can see the light rail passing through the building at any time during the day; if you want to photograph the classic scene of the train passing through the building, it is recommended to check the light rail schedule in advance and arrive at the viewing platform 5 minutes before the train arrives to secure a spot',
  NULL,
  FALSE,
  '- Rail Transit: Take Chongqing Rail Transit Line 2, get off at Liziba Station, walk about 2 minutes from Exit A to the viewing platform (experience the wonderful feeling of "passing through the light rail station")
- Bus: Take buses 210, 215, 219, 261, 318, 501, 503, 802, etc., get off at Liziba Station, walk about 5 minutes
- Taxi/Ride-hailing: Directly tell the driver "Liziba Light Rail Station" or "Liziba Viewing Platform"; you will arrive right at the destination
- Note: The viewing platform has limited space and extremely high visitor traffic during holidays; off-peak visits are recommended; the best photo spots are the front of the viewing platform and the Zengjiayan riverside on the opposite side of the Jialing River',
  '[{"icon": "🎫", "label": "Ticket", "value": "2 RMB"}, {"icon": "🕘", "label": "Opening Hours", "value": "06:30–23:00"}, {"icon": "🚇", "label": "Metro", "value": "Metro Line 2, Liziba Station"}]'::jsonb,
  '[]'::jsonb,
  '[]'::jsonb,
  'No. 62 Liziba Main Street, Yuzhong District, Chongqing (Liziba Light Rail Station)',
  '重庆市渝中区李子坝正街62号（轻轨李子坝站）',
  0,
  'com.chinago.travel.attraction.chongqing_liziba_monorail',
  2,
  TRUE) ON CONFLICT (id) DO UPDATE SET
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
) VALUES ('chongqing_yangtze_cableway',
  'chongqing',
  'Yangtze River Cableway',
  '长江索道',
  'sight',
  'attractions/chongqing_yangtze_cableway.png',
  '"The first aerial corridor over the long Yangtze River," an aerial bus crossing the river that has been operating for over 30 years, overlooking the two rivers, four banks, and the panoramic view of the mountain city from a unique perspective, it is a "time machine" traversing Chongqing''s past and present.',
  'The Yangtze River Cableway is located between Yuzhong District and Nanan District in Chongqing. Built in 1986, it was officially completed and opened to traffic in October 1987.',
  'P1',
  '- One-way: 30 RMB/person (recommended, allows experiencing the unique perspective from Yuzhong to Nanan or vice versa)
- Round-trip: 50 RMB/person
- Discounted Tickets: Students, seniors, military personnel, etc. can enjoy half-price discounts with valid ID
- Note: It is recommended to purchase a one-way ticket, take the cableway from Xinhua Road Station in Yuzhong District to Shangxin Street Station in Nanan District, then you can visit attractions such as Longmenhao Old Street and Tushan Temple in Nanan, avoiding backtracking; round-trip tickets are suitable for visitors with limited time who only want to experience the cableway itself',
  NULL,
  '- Operational Hours: 08:00-22:00 (the last trip is about 21:30 departing from Nanan District)
- Note: Evening to nighttime riding is the best choice, allowing overlooking the sunset and the brilliant night view of Yuzhong Peninsula; if encountering foggy weather or heavy rainstorm, the cableway may suspend operation; it is recommended to check the weather before traveling',
  NULL,
  FALSE,
  '- To Yuzhong District Xinhua Road Cableway Station (North Station):
  - Rail Transit: Take Chongqing Rail Transit Line 1 or 6, get off at Xiaoshizi Station, walk about 5 minutes from Exit 4
  - Bus: Take buses 112, 120, 141, 151, 181, 261, 322, 372, 382, 503, etc., get off at Daomenkou or Xinhua Road Station, walk about 5 minutes
  - Walking: About 10 minutes walk from Jiefangbei; about 8 minutes walk from Hongya Cave
- To Nanan District Shangxin Street Cableway Station (South Station):
  - Rail Transit: Take Chongqing Rail Transit Line 6, get off at Shangxin Street Station, walk about 5 minutes from Exit 2
  - Bus: Take buses 304, 318, 320, 321, 354, 376, etc., get off at Shangxin Street Station, walk about 5 minutes
- Note: Tickets can be purchased and boarding can be done at both cableway stations; it is recommended to choose the departure station according to the subsequent itinerary arrangements',
  '[{"icon": "🎫", "label": "Ticket", "value": "30 RMB"}, {"icon": "🕘", "label": "Opening Hours", "value": "08:00–22:00"}, {"icon": "🚇", "label": "Metro", "value": "Metro Line 1, Xiaoshizi Station"}]'::jsonb,
  '[]'::jsonb,
  '[]'::jsonb,
  '- Yuzhong District Xinhua Road Cableway Station (North Station): No. 151 Xinhua Road, Yuzhong District, Chongqing (near Jiefangbei, Hongya Cave)
- Nanan District Shangxin Street Cableway Station (South Station): No. 4 Shangxin Street, Nanan District, Chongqing (near Longmenhao Old Street, Tushan Temple)',
  '- 渝中区新华路索道站（北站）：重庆市渝中区新华路151号（近解放碑、洪崖洞）
- 南岸区上新街索道站（南站）：重庆市南岸区上新街4号（近龙门浩老街、涂山寺）',
  0,
  'com.chinago.travel.attraction.chongqing_yangtze_cableway',
  3,
  TRUE) ON CONFLICT (id) DO UPDATE SET
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
) VALUES ('chongqing_ciqikou_old_town',
  'chongqing',
  'Ciqikou Ancient Town',
  '磁器口古镇',
  'market',
  'attractions/chongqing_ciqikou_old_town.png',
  'An ancient town first built in the Song Dynasty, with winding stone-paved roads, fragrant teahouses, and crispy Chen Mahua, it is the most vivid cultural living fossil for experiencing old Chongqing''s folk customs.',
  'Ciqikou Ancient Town is located by the Jialing River in Shapingba District, Chongqing, backed by Gele Mountain and facing the Jialing River. It was first built during the Xianping period of Emperor Zhenzong of Song (998-1003), with a history of over 1,000 years. The town got its name "Ciqikou" (Porcelain Mouth) because it became a transfer and distribution center for blue-and-white porcelain during the Ming and Qing Dynasties. Historically, it was once a bustling water and land port and commercial town, known as the "Number One Ancient Town of Bayu" and "Little Chongqing." The core protected area of the ancient town covers only 1.5 square kilometers but completely preserves the architectural layout of the Ming and Qing Dynasties and the style of old mountain-city streets.',
  'P1',
  'Free admission (ancient town streets are free; some small attractions like Baolun Temple may charge separately, about 5-10 RMB)',
  NULL,
  '- Ancient Town Streets: Open 24/7
- Shops/Restaurants: About 09:00-22:00 (may extend to 23:00 in summer)
- Note: Afternoon to evening visits are recommended to experience both the daytime town scenery and nighttime light views',
  NULL,
  FALSE,
  '- Rail Transit: Take Chongqing Rail Transit Line 1, get off at Ciqikou Station, Exit 2, walk about 5 minutes
- Bus: Take buses 202, 220, 237, 467, 808, etc., get off at Ciqikou Station
- Driving: Navigate to "Ciqikou Ancient Town"; multiple parking lots available nearby, parking fee about 15-20 RMB/time
- Taxi/Ride-hailing: Directly tell the driver "Ciqikou Ancient Town"',
  '[{"icon": "🎫", "label": "Ticket", "value": "10 RMB"}, {"icon": "🕘", "label": "Opening Hours", "value": "09:00–22:00"}, {"icon": "🚇", "label": "Metro", "value": "Metro Line 1, Ciqikou Station"}]'::jsonb,
  '[]'::jsonb,
  '[]'::jsonb,
  'Ciqikou Ancient Town, Shapingba District, Chongqing (by the Jialing River)',
  '重庆市沙坪坝区磁器口古镇（嘉陵江畔）',
  0,
  'com.chinago.travel.attraction.chongqing_ciqikou_old_town',
  4,
  TRUE) ON CONFLICT (id) DO UPDATE SET
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
) VALUES ('chongqing_wulong_karst',
  'chongqing',
  'Wulong Karst Tourist Area',
  '武隆喀斯特旅游区',
  'park',
  'attractions/chongqing_wulong_karst.png',
  'A UNESCO World Natural Heritage Site and the pinnacle masterpiece of South China Karst, the magnificence of Tiankeng Three Bridges, the depth of Longshuixia Ground Fissure, and the splendor of Furong Cave together weave a magnificent picture scroll of the Earth''s evolution over hundreds of millions of years.',
  'Wulong Karst Tourist Area is located in Wulong District, Chongqing, about 200 kilometers from the main urban area of Chongqing, about 2.5 hours'' drive.',
  'P0',
  '- Tiankeng Three Bridges: Peak season (March-October) 125 RMB/person (including environmentally friendly shuttle bus); Off season (November-February next year) 95 RMB/person
- Longshuixia Ground Fissure: Peak season (March-October) 105 RMB/person (including environmentally friendly shuttle bus); Off season (November-February next year) 80 RMB/person
- Furong Cave: Peak season (March-October) 120 RMB/person (including cable car); Off season (November-February next year) 80 RMB/person
- Combo Ticket: Tiankeng Three Bridges + Longshuixia Ground Fissure combo ticket, peak season 200 RMB/person; off season 150 RMB/person
- Discounted Tickets: Students, seniors, military personnel, etc. can enjoy half-price or free admission with valid ID
- Note: It is recommended to purchase tickets in advance through the official WeChat account or travel platforms for discounts and to avoid on-site queuing; Tiankeng Three Bridges and Longshuixia Ground Fissure are about 10 kilometers apart; it is recommended to arrange visiting them on the same day',
  NULL,
  '- Tiankeng Three Bridges: 08:00-17:30 (last entry at 16:30)
- Longshuixia Ground Fissure: 08:00-17:00 (last entry at 15:30)
- Furong Cave: 08:30-17:00 (last entry at 16:00)
- Note: Wulong Karst Tourist Area covers a vast area; it is recommended to allow 2 days for visiting; if time is limited, Tiankeng Three Bridges is the top recommendation',
  NULL,
  FALSE,
  '- From Chongqing urban area:
  - Driving: Drive along the Chongqing-Xiangtan Expressway (G65) to the Wulong exit, follow signs to each scenic spot, about 2.5 hours'' drive
  - Bus: Take a shuttle from Chongqing Sigongli Transport Hub to Wulong District, about 2.5 hours, fare about 60 RMB; after arriving in Wulong, transfer to the scenic area direct bus to each attraction (about 30-50 minutes)
  - High-speed Rail: Take the Chongqing-Xiamen High-speed Railway to Wulong Station, about 1 hour; after arrival, transfer to the scenic area direct bus to each attraction (about 30-50 minutes)
  - Travel Agency One-day Tour: There are tourist direct buses/one-day tour groups from Chongqing Jiefangbei, Hongya Cave, etc. to Wulong Karst, round-trip about 200-300 RMB/person (including transportation, tickets, tour guide)
- Within the scenic area: There is a scenic area direct bus shuttle between Tiankeng Three Bridges and Longshuixia Ground Fissure (about 20 RMB/person); Furong Cave is about 40 kilometers from Tiankeng Three Bridges, requiring separate transportation arrangements',
  '[{"icon": "🎫", "label": "Ticket", "value": "125 / 95 RMB"}, {"icon": "🕘", "label": "Opening Hours", "value": "08:00–17:30"}]'::jsonb,
  '[]'::jsonb,
  '[]'::jsonb,
  'Xiannushan Street, Wulong District, Chongqing (Tiankeng Three Bridges/Longshuixia Ground Fissure); Jiangkou Town, Wulong District, Chongqing (Furong Cave)',
  '重庆市武隆区仙女山街道（天生三桥/龙水峡地缝）；重庆市武隆区江口镇（芙蓉洞）',
  0,
  'com.chinago.travel.attraction.chongqing_wulong_karst',
  5,
  TRUE) ON CONFLICT (id) DO UPDATE SET
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
) VALUES ('chongqing_dazu_rock_carvings',
  'chongqing',
  'Dazu Rock Carvings',
  '大足石刻',
  'temple',
  'attractions/chongqing_dazu_rock_carvings.png',
  'A UNESCO World Heritage Site and the pinnacle of Tang and Song Dynasty grotto art, represented by Baodingshan and Beishan, with over 50,000 exquisite statues, hailed as the "Last Monument of Eastern Grotto Art."',
  'Dazu Rock Carvings are located in Dazu District, Chongqing, about 160 kilometers from the main urban area of Chongqing. They are the pinnacle of Chinese grotto art from the late Tang and early Song periods (650-1250 AD) and one of the world''s eight great grottoes. The carvings are distributed across 41 sites in Dazu District, with a total of over 50,000 statues, among which Baodingshan and Beishan rock carvings are the most famous and exquisite. Dazu Rock Carvings integrate Buddhist, Taoist, and Confucian statues, achieving the unique cultural fusion of "three religions in one" in Chinese grotto art.',
  'P0',
  '- Baodingshan Rock Carvings: Peak season (March-November) 115 RMB/person; Off season (December-February next year) 100 RMB/person
- Beishan Rock Carvings: Peak season (March-November) 70 RMB/person; Off season (December-February next year) 50 RMB/person
- Combo Ticket (Baodingshan + Beishan + Baodingshan Museum): Peak season 140 RMB/person; Off season 120 RMB/person
- Discounted Tickets: Students, seniors, military personnel, etc. can enjoy half-price or free admission with valid ID
- Note: It is recommended to purchase a combo ticket to visit both Baodingshan and Beishan core scenic areas at once',
  'Note: Allow 3-4 hours for Baodingshan Rock Carvings; 1.5-2 hours for Beishan Rock Carvings',
  '- Baodingshan Rock Carvings: 08:30-18:00 (last entry at 17:00)
- Beishan Rock Carvings: 08:30-17:30 (last entry at 16:30)
- Note: Allow 3-4 hours for Baodingshan Rock Carvings; 1.5-2 hours for Beishan Rock Carvings',
  NULL,
  FALSE,
  '- From Chongqing urban area:
  - Bus: Take a bus from Chongqing Caiyuanba Bus Station or Chenjiaping Bus Station to Dazu District, about 2.5 hours, fare about 45 RMB; after arriving in Dazu, transfer to bus or taxi to the scenic area
  - High-speed Rail: Take the Chengdu-Chongqing High-speed Railway to Dazu South Station, about 1 hour; after arrival, transfer to bus or taxi to the scenic area (about 30 minutes)
  - Driving: Drive along the Chongqing-Chengdu Expressway (G5013) to the Dazu exit, follow signs to the scenic area, about 2 hours
- Within the scenic area: The distance between Baodingshan and Beishan is about 15 kilometers; you can take the scenic area shuttle bus (about 20 RMB/person)',
  '[{"icon": "🎫", "label": "Ticket", "value": "115 / 100 RMB"}, {"icon": "🕐", "label": "Duration", "value": "3–4 hours"}, {"icon": "🕘", "label": "Opening Hours", "value": "08:30–18:00"}]'::jsonb,
  '[]'::jsonb,
  '[]'::jsonb,
  'Baoding Town, Dazu District, Chongqing (Baodingshan Rock Carvings); Longgang Street, Dazu District, Chongqing (Beishan Rock Carvings)',
  '重庆市大足区宝顶镇（宝顶山石刻）；重庆市大足区龙岗街道（北山石刻）',
  0,
  'com.chinago.travel.attraction.chongqing_dazu_rock_carvings',
  6,
  TRUE) ON CONFLICT (id) DO UPDATE SET
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
) VALUES ('chongqing_raffles_city',
  'chongqing',
  'Raffles City Chongqing',
  '来福士',
  'sight',
  'attractions/chongqing_raffles_city.png',
  'A surreal landmark composed of 8 skyscrapers and an aerial "crystal corridor," integrating shopping mall, luxury hotel, high-end residences, and a 360-degree observation deck, it is the most stunning "futuristic" urban facade of Chongqing''s Chaotianmen.',
  'Raffles City Chongqing is located at Chaotianmen Square in Yuzhong District, Chongqing, situated at the "Golden Triangle" area where the Yangtze River and Jialing River meet. Invested by Singapore''s CapitaLand Group and designed by renowned architect Moshe Safdie.',
  'P1',
  '- Shopping Mall: Free admission
- Crystal Corridor Observation Deck (Exploration Deck): About 180 RMB/person (including aerial glass corridor, interactive exhibitions, and 360-degree observation deck)
- Discounted Tickets: Students, seniors, military personnel, etc. can enjoy discounts with valid ID
- Note: It is recommended to purchase observation deck tickets in advance through the official WeChat account or travel platforms for discounts and to avoid on-site queuing',
  'Note: Visiting the observation deck 2 hours before sunset is best, to see both the daytime city panorama and the nightime lights of thousands of homes',
  '- Shopping Mall: About 10:00-22:00
- Crystal Corridor Observation Deck (Exploration Deck): 10:00-22:00 (last entry at 21:00)
- Note: Visiting the observation deck 2 hours before sunset is best, to see both the daytime city panorama and the nightime lights of thousands of homes',
  NULL,
  FALSE,
  '- Rail Transit: Take Chongqing Rail Transit Line 1 or 6, get off at Xiaoshizi Station, walk about 8 minutes from Exit 9
- Bus: Take buses 112, 120, 141, 151, 181, 261, 322, 372, 382, 503, etc., get off at Chaotianmen Station, walk about 5 minutes
- Yangtze River Cableway: Take the cableway from Nanan District to Yuzhong District, walk about 10 minutes after exiting the station to arrive
- Taxi/Ride-hailing: Directly tell the driver "Raffles" or "Chongqing Raffles City"; you will arrive right at the destination
- Note: Raffles is located at Chaotianmen Square; roads in the vicinity are prone to congestion; it is recommended to prioritize rail transit',
  '[{"icon": "🎫", "label": "Ticket", "value": "180 RMB"}, {"icon": "🕐", "label": "Duration", "value": "2 hours"}, {"icon": "🕘", "label": "Opening Hours", "value": "10:00–22:00"}, {"icon": "🚇", "label": "Metro", "value": "Metro Line 1, Xiaoshizi Station"}]'::jsonb,
  '[]'::jsonb,
  '[]'::jsonb,
  'No. 8 Jiesheng Street, Yuzhong District, Chongqing (Chaotianmen Square, confluence of Jialing River and Yangtze River)',
  '重庆市渝中区接圣街8号（朝天门广场，嘉陵江与长江交汇处）',
  0,
  'com.chinago.travel.attraction.chongqing_raffles_city',
  7,
  TRUE) ON CONFLICT (id) DO UPDATE SET
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
) VALUES ('chongqing_eling_2nd_factory',
  'chongqing',
  'Eling Second Factory Cultural and Creative Park',
  '鹅岭二厂文创公园',
  'sight',
  'attractions/chongqing_eling_2nd_factory.png',
  'A cultural and creative landmark transformed from an abandoned printing factory, where graffiti walls, retro cafes, art exhibitions, and river-view rooftops intertwine to create Chongqing''s most artistic "cyberpunk" time-space.',
  'Eling Second Factory Cultural and Creative Park is located on Eling Main Street in Yuzhong District, Chongqing. Its predecessor was Chongqing Printing Factory No. 2, built in 1937, which was an important printing industrial base during the Republic of China period and after the founding of New China, mainly responsible for printing textbooks, archives, and confidential documents. With the changes of the times, Printing Factory No. 2 completely stopped production and relocated in 2012, and the abandoned factory buildings were silent for a time.',
  'P1',
  'Free admission (no ticket required for the cultural and creative park; some exhibitions or workshops may charge separately)',
  NULL,
  '- Park public areas: Open 24/7
- Shops/Cafes/Restaurants: About 10:00-22:00 (some shops open until late at night)
- Rooftop viewing: Daytime to evening visits recommended; the rooftop may be closed at night
- Note: The best time for photography is afternoon to dusk, capturing both industrial-style architecture and the sunset view of the two rivers'' confluence',
  NULL,
  FALSE,
  '- Rail Transit: Take Chongqing Rail Transit Line 1 or 3, get off at Lianglukou Station, walk about 15 minutes from Exit A (uphill section, comfortable shoes recommended)
- Bus: Take buses 109, 118, 138, 403, 413, etc., get off at Eling Station, walk about 5 minutes
- Taxi/Ride-hailing: Navigate to "Eling Second Factory" or "Eling Printing Factory No. 2"; you will arrive right at the destination
- Note: The park is located halfway up the mountain; walking from the rail transit station requires climbing an uphill section; those with less physical strength are advised to take a taxi directly',
  '[{"icon": "🎫", "label": "Ticket", "value": "Free"}, {"icon": "🕘", "label": "Opening Hours", "value": "10:00–22:00"}, {"icon": "🚇", "label": "Metro", "value": "Metro Line 1, Lianglukou Station"}]'::jsonb,
  '[]'::jsonb,
  '[]'::jsonb,
  'No. 1 Eling Main Street, Yuzhong District, Chongqing (next to Eling Park)',
  '重庆市渝中区鹅岭正街1号（鹅岭公园旁）',
  0,
  'com.chinago.travel.attraction.chongqing_eling_2nd_factory',
  8,
  TRUE) ON CONFLICT (id) DO UPDATE SET
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
) VALUES ('chongqing_mountain_trails',
  'chongqing',
  'Mountain City Trail (Shancheng Buda)',
  '山城步道',
  'sight',
  'attractions/chongqing_mountain_trails.png',
  'An ancient mountain path built along the cliffs of Yuzhong Peninsula for a thousand years, with winding stone steps, quiet old houses, and expansive river views, it is the most beautiful mountain-city aerial corridor to escape urban hustle and bustle and touch the pulse of old Chongqing.',
  'Mountain City Trail is located in Yuzhong District, Chongqing. It is a century-old street built along the cliffs on the south side of Yuzhong Peninsula, with a total length of about 3 kilometers, connected by stone steps, alleys, and aerial corridors of all sizes.',
  'P1',
  'Free admission (no ticket required for the trail public areas; some cafes, cultural and creative shops, homestays along the way are charged separately)',
  NULL,
  '- Trail Public Areas: Open 24/7
- Note: Daytime visits are recommended, as you can see the old buildings and river views clearly and ensure walking safety; it is also highly recommended to watch the sunset and night views from the viewing platform on the trail at dusk',
  NULL,
  FALSE,
  '- Rail Transit: Take Chongqing Rail Transit Line 1 or 2, get off at Jiaochangkou Station, walk about 10 minutes from Exit 9; or take Line 1, get off at Xiaoshizi Station, walk about 15 minutes
- Bus: Take buses 108, 112, 143, 293, 320, 346, 372, 376, 429, 440, etc., get off at Zhongxing Road Station, walk about 3 minutes to the trail entrance
- Taxi/Ride-hailing: Directly tell the driver "Mountain City Trail" or "Zhongxing Road Mountain City Trail Entrance"; you will arrive right at the destination
- Note: The entire Mountain City Trail consists of stone steps and slopes; the walking intensity is moderate; comfortable shoes and drinking water are recommended',
  '[{"icon": "🎫", "label": "Ticket", "value": "Free"}, {"icon": "🕘", "label": "Opening Hours", "value": "24/7"}, {"icon": "🚇", "label": "Metro", "value": "Metro Line 1, Jiaochangkou Station"}]'::jsonb,
  '[]'::jsonb,
  '[]'::jsonb,
  'Zhongxing Road, Yuzhong District, Chongqing (entrance of Mountain City Trail, near Zhongxing Road Bus Stop)',
  '重庆市渝中区中兴路（山城步道入口处，近中兴路公交站）',
  0,
  'com.chinago.travel.attraction.chongqing_mountain_trails',
  9,
  TRUE) ON CONFLICT (id) DO UPDATE SET
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
) VALUES ('chongqing_shibati',
  'chongqing',
  'Shiba Ti (Eighteen Steps)',
  '十八梯',
  'sight',
  'attractions/chongqing_shibati.png',
  'A century-old stone-step street connecting the upper and lower halves of Chongqing, carrying the deepest memories and nostalgia of the mountain city. The renovated Shiba Ti retains the fabric of old Chongqing while injecting new commercial vitality, it is a "living Qingming Shanghe Tu of the mountain city" that transcends time and space.',
  'Shiba Ti is located in Yuzhong District, Chongqing, starting from Houci Street in the south and ending at Jiaochangkou in the north. It is an old street with a total length of about 500 meters.',
  'P1',
  'Free admission (no ticket required for the customs area public areas; some exhibitions, performances, or specialty shops may charge separately)',
  NULL,
  '- Customs Area Public Areas: Open 24/7
- Shops/Restaurants: About 10:00-23:00 (may extend to 24:00 in summer)
- Note: Evening to nighttime visits are recommended to experience both the daytime old-street style and the nighttime neon lights and immersive nightscape',
  NULL,
  FALSE,
  '- Rail Transit: Take Chongqing Rail Transit Line 1 or 2, get off at Jiaochangkou Station, walk about 3 minutes from Exit 11 to the north entrance of the customs area; or take Line 1, get off at Xiaoshizi Station, walk about 12 minutes
- Bus: Take buses 108, 112, 143, 293, 320, 346, 372, 376, 429, 440, etc., get off at Jiaochangkou or Zhongxing Road Station, walk about 5 minutes
- Taxi/Ride-hailing: Directly tell the driver "Shiba Ti" or "Shiba Ti Traditional Customs Area"; you will arrive right at the destination
- Walking: About 10 minutes walk from Jiefangbei',
  '[{"icon": "🎫", "label": "Ticket", "value": "Free"}, {"icon": "🕘", "label": "Opening Hours", "value": "10:00–23:00"}, {"icon": "🚇", "label": "Metro", "value": "Metro Line 1, Jiaochangkou Station"}]'::jsonb,
  '[]'::jsonb,
  '[]'::jsonb,
  'No. 1 Zhongxing Road, Yuzhong District, Chongqing (Shiba Ti Traditional Customs Area, near Jiaochangkou)',
  '重庆市渝中区中兴路1号（十八梯传统风貌区，近较场口）',
  0,
  'com.chinago.travel.attraction.chongqing_shibati',
  10,
  TRUE) ON CONFLICT (id) DO UPDATE SET
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
) VALUES ('chongqing_baixiangju',
  'chongqing',
  'Baixiangju Residential Complex',
  '白象居',
  'sight',
  'attractions/chongqing_baixiangju.png',
  'A hidden "three-dimensional magical residential building" on the cliffs of Yuzhong Peninsula, famous for its 24 floors without elevators and aerial corridors crossing through the building, representing the living fossil of Chongqing''s local lifestyle aesthetics.',
  'Baixiangju is located on Baixiang Street in Yuzhong District, Chongqing, right by the Yangtze River. It is a residential community that epitomizes the mountain-city character of Chongqing. Due to the unique mountainous terrain, this residential building was designed as a "three-dimensional maze" — entering from the front gate is the 1st floor, from the side road is the 10th floor, and from the back mountain path you directly reach the 24th floor. The entire complex has 24 floors but not a single elevator; residents have long been accustomed to the lifestyle of daily climbing exercise. Aerial corridors connect the buildings, forming an "aerial street" where children run and play in the corridors while the elderly sit by the railings chatting and resting, creating a vivid picture of mountain-city life. Baixiangju is not a commercial scenic spot but an authentic Chongqing local living scene, full of rich neighborhood atmosphere. In recent years, due to its unique architectural structure and strong local living vibe, it has attracted numerous photographers, film directors, and tourists. The movie "Crazy Stone" was filmed here. Here, you can truly feel the daily "climbing slopes and steps" of Chongqing people, the intimate relationships between neighbors, and the urban wisdom of perfectly integrating mountain-city architecture with terrain. Baixiangju is an excellent window for understanding Chongqing''s urban character and a rare destination for experiencing the most authentic Chongqing lifestyle.',
  'P1',
  'Free admission (residential area, no ticket required)',
  NULL,
  'Open 24/7 (residential area, accessible anytime; daytime visits recommended)',
  NULL,
  FALSE,
  '- Rail Transit: Take Chongqing Rail Transit Line 1 or 6, get off at Xiaoshizi Station, walk about 15 minutes
- Bus: Take buses 112, 120, 141, etc., get off at Chaotianmen Station, walk about 10 minutes
- Taxi/Ride-hailing: Navigate to "Baixiangju" or "Baixiang Street," walk uphill about 5 minutes after getting off
- Note: Baixiangju is located on a steep slope; comfortable shoes are recommended',
  '[{"icon": "🎫", "label": "Ticket", "value": "Free"}, {"icon": "🕘", "label": "Opening Hours", "value": "24/7"}, {"icon": "🚇", "label": "Metro", "value": "Metro Line 1, Xiaoshizi Station"}]'::jsonb,
  '[]'::jsonb,
  '[]'::jsonb,
  'No. 1 Baixiang Street, Yuzhong District, Chongqing (by the Yangtze River, near Chaotianmen)',
  '重庆市渝中区白象街1号（长江河畔，靠近朝天门）',
  0,
  'com.chinago.travel.attraction.chongqing_baixiangju',
  11,
  TRUE) ON CONFLICT (id) DO UPDATE SET
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
) VALUES ('chongqing_guanyinqiao',
  'chongqing',
  'Guanyinqiao',
  '观音桥',
  'market',
  'attractions/chongqing_guanyinqiao.png',
  'One of Chongqing''s most bustling commercial districts, famous for its giant "I LOVE Chongqing" internet-famous check-in wall, high-end shopping malls, food streets, and dazzling night views, it is an excellent window for experiencing modern Chongqing''s urban vitality.',
  'Guanyinqiao is located in Jiangbei District, Chongqing, and is one of the most popular and vibrant commercial centers in Chongqing, alongside Jiefangbei Business District as the two core business districts of Chongqing. After nearly 20 years of development, Guanyinqiao has transformed from an old urban area into a modern urban commercial district integrating shopping, dining, entertainment, business, and living.',
  'P1',
  'Free admission (no ticket required for the business district public areas; shopping malls and restaurants are charged separately)',
  NULL,
  '- Business District Public Areas: Open 24/7
- Shopping Malls: About 10:00-22:00 (hours may vary slightly by mall)
- Restaurants/Bars: About 11:00-02:00 next day (some bars open until early morning)
- Note: Guanyinqiao is most prosperous and beautiful at night; evening to nighttime visits are recommended to experience shopping, food, and night views simultaneously',
  NULL,
  FALSE,
  '- Rail Transit: Take Chongqing Rail Transit Line 3 or 9, get off at Guanyinqiao Station, multiple exits lead directly to the business district
- Bus: Take buses 107, 113, 115, 118, 120, 125, 181, 603, 605, 606, 609, 610, 618, 818, etc., get off at Guanyinqiao Station
- Taxi/Ride-hailing: Directly tell the driver "Guanyinqiao" or "Guanyinqiao Pedestrian Street"; you will arrive right at the destination',
  '[{"icon": "🎫", "label": "Ticket", "value": "Free"}, {"icon": "🕘", "label": "Opening Hours", "value": "10:00–22:00"}, {"icon": "🚇", "label": "Metro", "value": "Metro Line 3, Guanyinqiao Station"}]'::jsonb,
  '[]'::jsonb,
  '[]'::jsonb,
  'Guanyinqiao Pedestrian Street, Jiangbei District, Chongqing (near Guanyinqiao Metro Station)',
  '重庆市江北区观音桥步行街（近观音桥地铁站）',
  0,
  'com.chinago.travel.attraction.chongqing_guanyinqiao',
  12,
  TRUE) ON CONFLICT (id) DO UPDATE SET
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
) VALUES ('chongqing_jiujie',
  'chongqing',
  'Jiujie (Nine Street)',
  '九街',
  'market',
  'attractions/chongqing_jiujie.png',
  'Chongqing''s most "hyped" and trendy nightlife landmark, where craft beer bars, Live Houses, electronic music parties, and late-night food intersect, it is a "cyberpunk" playground for the mountain city''s night owls and sleepless youth.',
  'Jiujie is located on the edge of the Guanyinqiao business district in Jiangbei District, Chongqing. Its full name is "Jiujie Gaowu," and it is the most renowned and lively nightlife entertainment street in Chongqing, and one of the most influential night economy landmarks in Southwest China.',
  'P1',
  '- Street Public Areas: Free admission
- Bars/Nightclubs: Some bars have minimum consumption or cover charges (about 50-200 RMB/person, including the first round of drinks); large nightclubs may have separate admission fees (about 100-300 RMB/person)
- Note: Consumption levels in Jiujie vary greatly, from dozens of RMB for barbecue to thousands of RMB for nightclub table seats; it is recommended to understand the consumption standards of each shop in advance',
  NULL,
  '- Street Public Areas: Open 24/7
- Bars/Nightclubs/Restaurants: About 18:00-06:00 next day (some shops open all night)
- Note: The best experience time in Jiujie is 21:00 to early morning next day; it is recommended to go in groups and pay attention to safety',
  NULL,
  FALSE,
  '- Rail Transit: Take Chongqing Rail Transit Line 3 or 9, get off at Guanyinqiao Station, walk about 10 minutes from Exit 3
- Bus: Take buses 107, 113, 118, 120, 125, 181, 606, 618, etc., get off at Guanyinqiao or Jiujie Station, walk about 5 minutes
- Taxi/Ride-hailing: Directly tell the driver "Jiujie" or "Jiujie Gaowu"; you will arrive right at the destination
- Note: Roads around Jiujie are extremely prone to congestion at night, and parking spaces are tight; it is strongly recommended to take rail transit or a taxi (the drop-off point is very close to the street)',
  '[{"icon": "🎫", "label": "Ticket", "value": "200 / 300 RMB"}, {"icon": "🕘", "label": "Opening Hours", "value": "18:00–06:00"}, {"icon": "🚇", "label": "Metro", "value": "Metro Line 3, Guanyinqiao Station"}]'::jsonb,
  '[]'::jsonb,
  '[]'::jsonb,
  'Yanghe First Lane, Jiangbei District, Chongqing (edge of Guanyinqiao business district, near Jiujie Gaowu)',
  '重庆市江北区杨河一巷（观音桥商圈边缘，近九街高屋）',
  0,
  'com.chinago.travel.attraction.chongqing_jiujie',
  13,
  TRUE) ON CONFLICT (id) DO UPDATE SET
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
) VALUES ('chongqing_bayi_food_street',
  'chongqing',
  'Bayi (August 1st) Food Street',
  '八一好吃街',
  'market',
  'attractions/chongqing_bayi_food_street.png',
  'A Chongqing food universe hidden underground in the Jiefangbei business district, with signature snacks like hot and sour noodles, mountain-city small tangyuan, and delicious squid tentacles lined up, it is the best place for first-time Chongqing visitors to "catch them all" Bayu flavors in one go.',
  'Bayi Food Street is located on Bayi Road in the Jiefangbei business district, Yuzhong District, Chongqing, adjacent to Jiefangbei Pedestrian Street. It is a well-known food brand street hidden in an underground commercial street and one of the most famous and lively food gathering places in Chongqing.',
  'P1',
  'Free entry (each snack stall charges separately; average per-person consumption about 30-60 RMB)',
  NULL,
  '- Food Street Public Areas: About 10:00-22:00
- Each snack stall: About 10:30-21:30 (some stalls open until after 22:00)
- Note: The highest visitor traffic is during meal times (12:00-13:30, 18:00-20:00); off-peak visits are recommended; you can also go to Hongya Cave to see the night view first, then return to Bayi Food Street for late-night snacks',
  NULL,
  FALSE,
  '- Rail Transit: Take Chongqing Rail Transit Line 1, 2, or 6, get off at Xiaoshizi Station, walk about 3 minutes from Exit D to the underground commercial street entrance
- Bus: Take buses 105, 111, 112, 114, 135, 151, 181, etc., get off at Jiefangbei Station, walk about 5 minutes
- Walking: About 3 minutes walk from Jiefangbei Monument
- Taxi/Ride-hailing: Directly tell the driver "Jiefangbei Bayi Road" or "Bayi Food Street"; walk about 2 minutes after getting off',
  '[{"icon": "🎫", "label": "Ticket", "value": "60 RMB"}, {"icon": "🕘", "label": "Opening Hours", "value": "10:00–22:00"}, {"icon": "🚇", "label": "Metro", "value": "Metro Line 1, Xiaoshizi Station"}]'::jsonb,
  '[]'::jsonb,
  '[]'::jsonb,
  'Bayi Road, Yuzhong District, Chongqing (underground commercial street of Jiefangbei Pedestrian Street, near Minquan Road)',
  '重庆市渝中区八一路（解放碑步行街地下商业街，近民权路）',
  0,
  'com.chinago.travel.attraction.chongqing_bayi_food_street',
  14,
  TRUE) ON CONFLICT (id) DO UPDATE SET
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
) VALUES ('chongqing_jinfo_mountain',
  'chongqing',
  'Jinfo Mountain (Jinfoshan)',
  '金佛山',
  'park',
  'attractions/chongqing_jinfo_mountain.png',
  'A UNESCO World Natural Heritage Site only 1.5 hours'' drive from downtown Chongqing, famous for its karst table mountain wonders, sea of clouds and sunrise, azalea flower seas, and ice and snow world, it is Chongqing''s "Natural Museum" and summer resort paradise.',
  'Jinfo Mountain is located in Nanchuan District, Chongqing, about 88 kilometers from the main urban area of Chongqing, about 1.5 hours'' drive. It is the main peak of the Dalou Mountain Range, with an altitude of 2,238 meters and a total area of about 1,300 square kilometers.',
  'P1',
  '- Admission: Peak season (March-October) 70 RMB/person; Off season (November-February next year) 50 RMB/person
- Cable Car: Round-trip 80 RMB/person (recommended to purchase, saves significant physical effort)
- Skiing/Snow Play: Charged separately in winter, about 120-180 RMB/person (including ski equipment rental)
- Discounted Tickets: Students, seniors, military personnel, etc. can enjoy half-price or free admission with valid ID
- Note: It is recommended to purchase combo tickets (admission + cable car) in advance through the official WeChat account or travel platforms for discounts and to avoid on-site queuing',
  NULL,
  '- Scenic Area: 08:00-17:30 (last entry at 16:30)
- Cable Car: 08:30-17:00
- Note: Jinfo Mountain covers a vast area; it is recommended to allow a full day for the visit; if you want to see the sunrise and sea of clouds, you can choose to stay overnight on the mountain',
  NULL,
  FALSE,
  '- From Chongqing urban area:
  - Driving: Drive along the Chongqing-Xiangtan Expressway (G65) to the Jinfo Mountain exit, follow signs to the scenic area, about 1.5 hours'' drive
  - Bus: Take a shuttle from Chongqing Sigongli Transport Hub to Nanchuan District, about 1.5 hours, fare about 35 RMB; after arriving in Nanchuan, transfer to bus or taxi to the scenic area (about 30 minutes)
  - High-speed Rail: Take the Chongqing-Xiamen High-speed Railway to Nanchuan North Station, about 30 minutes; after arrival, transfer to bus or taxi to the scenic area (about 40 minutes)
  - Scenic Area Direct Bus: There are tourist direct buses from Chongqing Jiefangbei, Hongya Cave, etc. directly to Jinfo Mountain, round-trip about 100-120 RMB/person
- Within the scenic area: There are environmentally friendly shuttle buses in the scenic area; it is recommended to purchase environmentally friendly shuttle bus + cable car combo tickets for convenient sightseeing',
  '[{"icon": "🎫", "label": "Ticket", "value": "70 / 50 RMB"}, {"icon": "🕘", "label": "Opening Hours", "value": "08:00–17:30"}]'::jsonb,
  '[]'::jsonb,
  '[]'::jsonb,
  'Jinfo Mountain Scenic Area, Nanchuan District, Chongqing (entrances available on south slope/west slope/north slope)',
  '重庆市南川区金佛山景区（南坡/西坡/北坡均有入口）',
  0,
  'com.chinago.travel.attraction.chongqing_jinfo_mountain',
  15,
  TRUE) ON CONFLICT (id) DO UPDATE SET
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
) VALUES ('chongqing_zoo',
  'chongqing',
  'Chongqing Zoo',
  '重庆动物园',
  'park',
  'attractions/chongqing_zoo.png',
  'One of the largest comprehensive zoos in Southwest China, renowned worldwide for its large giant panda population and the world''s first Bengal tiger-South China tiger hybrid "Chongqing Tiger."',
  'Established in 1955, Chongqing Zoo is located in Yangjiaping, Jiulongpo District, covering an area of about 2,000 mu. It is one of the largest comprehensive zoos in Southwest China and a national AAAA-level tourist attraction. After nearly 70 years of development, Chongqing Zoo has become a modern zoo integrating wildlife protection, science education, leisure tourism, and scientific research. The zoo houses and displays more than 200 species and over 4,000 animals, including rare and endangered animals from around the world such as giant pandas, red pandas, golden monkeys, South China tigers, Asian elephants, giraffes, zebras, kangaroos, and penguins. What Chongqing Zoo is most praised for is its giant panda house, which has the largest captive giant panda population in domestic zoos, with more than 20 giant pandas on display year-round, attracting countless visitors. In addition to giant pandas, Chongqing Zoo is also world-famous for the "Chongqing Tiger" — the world''s first successfully artificially bred hybrid offspring of Bengal tiger and South China tiger, a true world miracle. The zoo has an extremely high green coverage rate, with beautiful lakes, hills, birdsongs, and fragrant flowers.',
  'P2',
  '- Adult Ticket: Peak season (January-November) 25 RMB/person; Off season (December) 20 RMB/person
- Student/Child/Senior Ticket: 12.5 RMB/person (valid ID required)
- Giant Panda House: Free (included in general admission)
- Note: It is recommended to purchase e-tickets in advance through the official WeChat account or travel platforms for discounts and faster entry',
  NULL,
  '- March-October: 08:00-18:00 (last entry at 17:30)
- November-February: 08:30-17:30 (last entry at 17:00)
- Note: Giant pandas have feeding activity sessions in the morning and afternoon; it is recommended to visit before 10:00 or after 14:00 for a higher chance of seeing active giant pandas',
  NULL,
  FALSE,
  '- Rail Transit: Take Chongqing Rail Transit Line 2, get off at Zoo Station, Exit 1 leads directly to the zoo
- Bus: Take buses 204, 207, 226, 413, 420, etc., get off at Zoo Station
- Driving: Navigate to "Chongqing Zoo"; parking lot available in the zoo, parking fee about 10 RMB/time
- Taxi/Ride-hailing: Directly tell the driver "Chongqing Zoo"; you will arrive right at the destination',
  '[{"icon": "🎫", "label": "Ticket", "value": "25 / 20 RMB"}, {"icon": "🕘", "label": "Opening Hours", "value": "08:00–18:00"}, {"icon": "🚇", "label": "Metro", "value": "Metro Line 2, Zoo Station"}]'::jsonb,
  '[]'::jsonb,
  '[]'::jsonb,
  'No. 25 Xijiao Road, Yangjiaping, Jiulongpo District, Chongqing',
  '重庆市九龙坡区杨家坪西郊路25号',
  0,
  'com.chinago.travel.attraction.chongqing_zoo',
  16,
  TRUE) ON CONFLICT (id) DO UPDATE SET
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
