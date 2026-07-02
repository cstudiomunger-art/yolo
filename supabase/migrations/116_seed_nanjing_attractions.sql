-- Seed: nanjing attractions from Desktop Markdown
-- Text fields = verbatim English sections from source docs.
-- practical_info = Ticket / Duration / Opening Hours / Closed / Metro from MD sections.
-- Idempotent: ON CONFLICT (id) DO UPDATE

INSERT INTO attractions (
  id, city_id, name, chinese_name, category, cover_image_path, summary, introduction,
  priority, ticket_price, recommended_duration, opening_hours, closed_days,
  requires_advance_booking, metro_access, practical_info, western_visitor_tips, nearby_places,
  address_en, address_zh, audio_guide_count, iap_product_id, display_order, is_published
) VALUES (
  'nanjing_sun_yat_sen_mausoleum', 'nanjing', 'Sun Yat-sen Mausoleum Scenic Area, Nanjing', '南京中山陵景区',
  'sight', 'attractions/nanjing_sun_yat_sen_mausoleum.png', 'The Sun Yat-sen Mausoleum in Nanjing is the tomb of Dr. Sun Yat-sen, the great pioneer of China''s modern democratic revolution. Located at the southern foot of the central peak of Purple Mountain and built against the mountain, it is magnificent and is one of the most representative commemorative architectural complexes in modern Chinese architectural history.', 'The Sun Yat-sen Mausoleum is located in the Purple Mountain Scenic Area in Xuanwu District, Nanjing. It is the tomb of Dr. Sun Yat-sen, the great pioneer of China''s modern democratic revolution. Construction of the Sun Yat-sen Mausoleum began in March 1926, and the Entombment Ceremony was held on June 1, 1929, when Dr. Sun Yat-sen''s coffin was officially buried here.

The Sun Yat-sen Mausoleum was designed by Lu Yanzhi, a famous modern Chinese architect. The entire architectural complex is built on the southern foot of the central peak of Purple Mountain, arranged in sequence from south to north and from low to high on a central axis. The plane presents a "warning bell" shape, implying "the alarm bell ringing long to awaken the people." The main buildings of the mausoleum include the Paifang (Memorial Archway), the Mausoleum Gate, the Stele Pavilion, the Sacrificial Hall, the Burial Chamber, etc. Among them, the "Arched Gate of Philanthropy" located at the southernmost end is a three-bay, four-pillar, three-story skyward stone Paifang, with the two characters "Bo Ai" (Universal Love) written by Dr. Sun Yat-sen engraved on the architrave; the Sacrificial Hall is the core building of the Sun Yat-sen Mausoleum, with a blue glazed tile roof with double eaves and nine ridges. Inside the hall stands a marble seated statue of Dr. Sun Yat-sen, and the four walls are engraved with the full text of the "Fundamentals of National Reconstruction" handwritten by Dr. Sun Yat-sen.

All buildings of the Sun Yat-sen Mausoleum are built with blue glazed tiles and granite, with a solemn, simple, and magnificent style, blending traditional Chinese architectural style with Western architectural spirit. It is a masterpiece of modern Chinese architecture and one of the most iconic cultural landmarks in Nanjing.

The area above the "World is for All" Mausoleum Gate is open daily from 8:30 to 17:00, and the Burial Chamber is not open. It is closed on Mondays for maintenance (except for statutory holidays). Admission to the Sun Yat-sen Mausoleum is free, but advance reservation through official channels is required.',
  'P0', '- **Ticket price:** Free admission
- **Reservation requirement:** Advance reservation through the official WeChat public account or official website of "Zhongshan Scenic Area" is required. Enter with the reservation voucher and valid ID document
- **Open area:** The area above the "World is for All" Mausoleum Gate is open; the Burial Chamber is not open
- **Special note:** Closed on Mondays for maintenance (except for statutory holidays); reservation slots may be tight during holidays, advance reservation is recommended', NULL,
  '- **Opening hours:** Daily 8:30–17:00 (last entry at 16:00)
- **Closing time:** Closed on Mondays for maintenance (except for statutory holidays)
- **Burial Chamber opening status:** The Burial Chamber is not open
- **Recommended visiting time:** 1.5–2 hours', NULL,
  TRUE, '- **Metro:**
  - Take Metro Line 2 to Muxuyuan Station, then walk or transfer to the scenic area sightseeing bus to the Sun Yat-sen Mausoleum Scenic Area
  - Take Metro Line 2 to Xiamafang Station, then transfer to the scenic area shuttle bus after exiting the station
- **Bus:**
  - Take Bus No. 20, 315, etc. to the Sun Yat-sen Mausoleum Parking Lot Station
  - Take the tourist shuttle to the Sun Yat-sen Mausoleum Station
- **Scenic area sightseeing bus:** Sightseeing bus routes are set up within the Purple Mountain Scenic Area. You can take the sightseeing bus to travel between various attractions; sightseeing buses connect the Sun Yat-sen Mausoleum with Ming Xiaoling Mausoleum, Linggu Temple and other attractions
- **Self-driving:** Navigate to "Sun Yat-sen Mausoleum Parking Lot." The scenic area has parking lots (parking spaces may be tight during holidays)
- **Tip:** The Sun Yat-sen Mausoleum is located within the Purple Mountain Scenic Area. It is recommended to arrange visits to Ming Xiaoling Mausoleum, Linggu Temple and other attractions on the same day, and give priority to public transportation or scenic area sightseeing buses',
  '[{"icon": "🎫", "label": "Ticket", "value": "- **Ticket price:** Free admission\n- **Reservation requirement:** Advance reservation through the official WeChat public account or official website of \"Zhongshan Scenic Area\" is required. Enter with the reservation voucher and valid ID document\n- **Open area:** The area above the \"World is for All\" Mausoleum Gate is open; the Burial Chamber is not open\n- **Special note:** Closed on Mondays for maintenance (except for statutory holidays); reservation slots may be tight during holidays, advance reservation is recommended"}, {"icon": "🕘", "label": "Opening Hours", "value": "- **Opening hours:** Daily 8:30–17:00 (last entry at 16:00)\n- **Closing time:** Closed on Mondays for maintenance (except for statutory holidays)\n- **Burial Chamber opening status:** The Burial Chamber is not open\n- **Recommended visiting time:** 1.5–2 hours"}, {"icon": "🚇", "label": "Metro", "value": "- **Metro:**\n  - Take Metro Line 2 to Muxuyuan Station, then walk or transfer to the scenic area sightseeing bus to the Sun Yat-sen Mausoleum Scenic Area\n  - Take Metro Line 2 to Xiamafang Station, then transfer to the scenic area shuttle bus after exiting the station\n- **Bus:**\n  - Take Bus No. 20, 315, etc. to the Sun Yat-sen Mausoleum Parking Lot Station\n  - Take the tourist shuttle to the Sun Yat-sen Mausoleum Station\n- **Scenic area sightseeing bus:** Sightseeing bus routes are set up within the Purple Mountain Scenic Area. You can take the sightseeing bus to travel between various attractions; sightseeing buses connect the Sun Yat-sen Mausoleum with Ming Xiaoling Mausoleum, Linggu Temple and other attractions\n- **Self-driving:** Navigate to \"Sun Yat-sen Mausoleum Parking Lot.\" The scenic area has parking lots (parking spaces may be tight during holidays)\n- **Tip:** The Sun Yat-sen Mausoleum is located within the Purple Mountain Scenic Area. It is recommended to arrange visits to Ming Xiaoling Mausoleum, Linggu Temple and other attractions on the same day, and give priority to public transportation or scenic area sightseeing buses"}]'::jsonb, '[]'::jsonb, '[]'::jsonb,
  'Inside Purple Mountain Scenic Area, Shixiang Road, Xuanwu District, Nanjing, Jiangsu Province', '江苏省南京市玄武区石象路钟山风景名胜区内',
  0, 'com.chinago.travel.attraction.nanjing_sun_yat_sen_mausoleum', 0, TRUE
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
  'nanjing_museum', 'nanjing', 'Nanjing Museum', '南京博物院',
  'museum', 'attractions/nanjing_museum.png', 'Nanjing Museum is one of China''s three major museums and one of the first national first-class museums. Its predecessor was the National Central Museum advocated by Mr. Cai Yuanpei in 1933. It houses over 430,000 precious cultural relics, with bronzes, porcelain, and calligraphy and paintings as its three major features. It is an important window for displaying Chinese civilization.', 'Nanjing Museum is located at No. 321 Zhongshan East Road, Xuanwu District, Nanjing, at the southern foot of Purple Mountain and beside the Zhongshan Scenic Area. It is one of China''s three major museums, one of the first national first-class museums, a national key museum jointly built by the central and local governments, and a national AAAA-level tourist attraction.

The predecessor of Nanjing Museum was the National Central Museum, advocated by Mr. Cai Yuanpei in 1933 and first built in 1936. It is one of the earliest museums established in China. After 1949, the National Central Museum was renamed Nanjing Museum. In 2009, the second-phase renovation and expansion project of Nanjing Museum was launched. The first-phase project was completed in 2013 and officially opened to the public. It now has a layout of "one museum, six halls," namely the History Hall, the Art Hall, the Special Exhibition Hall, the Digital Hall, the Republic of China Hall, and the Intangible Cultural Heritage Hall, with an exhibition area of 42,000 square meters.

Nanjing Museum houses over 430,000 cultural relics, ranging from the Paleolithic Age to contemporary times, covering historical relics, artistic treasures, and modern historical materials. Among them, there are over a thousand national treasure-level cultural relics and national first-class cultural relics. Nanjing Museum features bronzes, porcelain, and calligraphy and paintings as its three major collection characteristics: among the bronze wares are heavy vessels such as the Shang Dynasty beast-faced pattern bronze ding and the Western Zhou bronze bird-pattern square ding; among the porcelains, various glaze-color large vases, blue and white porcelain, and underglaze red porcelain are the most famous; in terms of calligraphy and paintings, it houses a large number of works by famous artists from the Ming, Qing, and modern times. In addition, lacquerware, woven and embroidered articles, jade and stone wares, gold and silver wares, and bamboo, wood, ivory, and horn wares also have great value.

Nanjing Museum is not only a museum, but also a comprehensive cultural palace integrating history, art, archaeology, intangible cultural heritage protection and research. The building itself also has great ornamental value—the History Hall (Old Main Hall) is an architecture imitating Liao Dynasty palace style, with yellow walls and dark blue tiles, magnificent and grand; the Republic of China Hall restores the streets and shops of the Republic of China period in real scenes, making visitors feel as if they have traveled through time and space.

Nanjing Museum is open to the public free of charge (closed on Mondays, except for statutory holidays). Advance reservation through the official WeChat public account or official website is required. Opening hours are daily 9:00—17:00 (last ticket check at 16:00). It is recommended to reserve half a day to a full day for the visit, so as to fully appreciate the charm of this cultural palace.',
  'P0', '- **Ticket price:** Free admission
- **Reservation requirement:** Advance reservation through the official WeChat public account or official website of "Nanjing Museum" is required. Enter the museum with the reservation voucher and valid ID document
- **Opening hours:** Daily 9:00—17:00 (last ticket check at 16:00)
- **Closing time:** Closed on Mondays (except for statutory holidays); closed on New Year''s Eve and the first day of the Lunar New Year
- **Special note:** Some special exhibitions may charge separately or require reservation, subject to official announcements
- **Tip:** Reservation slots may be tight during holidays. It is recommended to make a reservation 3—7 days in advance', NULL,
  '- **Opening hours:** Daily 9:00—17:00 (last ticket check at 16:00)
- **Closing time:** Closed on Mondays (except for statutory holidays); closed on New Year''s Eve and the first day of the Lunar New Year
- **Night opening hours of the Intangible Cultural Heritage Hall:** Please pay attention to the announcements on Nanjing Museum''s official website or official WeChat public account
- **Recommended visiting time:** Half a day to a full day', NULL,
  TRUE, '- **Metro:**
  - Take Metro Line 2 to Minggugong Station, exit at Exit 1, then walk east along Zhongshan East Road for about 10 minutes to reach Nanjing Museum
- **Bus:**
  - Take Bus No. 5, 34, 36, 55, 59, 80 and get off at "Zhongshan Gate" stop, then walk about 5 minutes to reach the museum
- **Self-driving:** Navigate to "Nanjing Museum." The museum has a parking lot (parking spaces are limited and may be tight during holidays)
- **Tip:** Nanjing Museum is one of Nanjing''s most popular cultural venues. The visitor flow is extremely large during holidays. It is recommended to give priority to public transportation and complete the reservation in advance',
  '[{"icon": "🎫", "label": "Ticket", "value": "- **Ticket price:** Free admission\n- **Reservation requirement:** Advance reservation through the official WeChat public account or official website of \"Nanjing Museum\" is required. Enter the museum with the reservation voucher and valid ID document\n- **Opening hours:** Daily 9:00—17:00 (last ticket check at 16:00)\n- **Closing time:** Closed on Mondays (except for statutory holidays); closed on New Year''s Eve and the first day of the Lunar New Year\n- **Special note:** Some special exhibitions may charge separately or require reservation, subject to official announcements\n- **Tip:** Reservation slots may be tight during holidays. It is recommended to make a reservation 3—7 days in advance"}, {"icon": "🕘", "label": "Opening Hours", "value": "- **Opening hours:** Daily 9:00—17:00 (last ticket check at 16:00)\n- **Closing time:** Closed on Mondays (except for statutory holidays); closed on New Year''s Eve and the first day of the Lunar New Year\n- **Night opening hours of the Intangible Cultural Heritage Hall:** Please pay attention to the announcements on Nanjing Museum''s official website or official WeChat public account\n- **Recommended visiting time:** Half a day to a full day"}, {"icon": "🚇", "label": "Metro", "value": "- **Metro:**\n  - Take Metro Line 2 to Minggugong Station, exit at Exit 1, then walk east along Zhongshan East Road for about 10 minutes to reach Nanjing Museum\n- **Bus:**\n  - Take Bus No. 5, 34, 36, 55, 59, 80 and get off at \"Zhongshan Gate\" stop, then walk about 5 minutes to reach the museum\n- **Self-driving:** Navigate to \"Nanjing Museum.\" The museum has a parking lot (parking spaces are limited and may be tight during holidays)\n- **Tip:** Nanjing Museum is one of Nanjing''s most popular cultural venues. The visitor flow is extremely large during holidays. It is recommended to give priority to public transportation and complete the reservation in advance"}]'::jsonb, '[]'::jsonb, '[]'::jsonb,
  'No. 321 Zhongshan East Road, Xuanwu District, Nanjing, Jiangsu Province', '江苏省南京市玄武区中山东路321号',
  0, 'com.chinago.travel.attraction.nanjing_museum', 1, TRUE
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
  'nanjing_confucius_temple_qinhuai', 'nanjing', 'Nanjing Confucius Temple - Qinhuai River Scenic Area', '南京夫子庙-秦淮河风光带',
  'sight', 'attractions/nanjing_confucius_temple_qinhuai.png', 'The Nanjing Confucius Temple - Qinhuai River Scenic Area is Nanjing''s most representative historical and cultural district. Centered on the Confucius Temple and with the ten-li Qinhuai River as its axis, it integrates natural scenery, gardens and temples, street life and folk customs. It is a must-visit place to experience the charm of the ancient capital Jinling.', 'The Nanjing Confucius Temple - Qinhuai River Scenic Area is located in the area of Gongyuan Street, Qinhuai District, Nanjing. It is a national AAAAA-level tourist attraction and the core symbol of Nanjing, a famous historical and cultural city. The scenic area is centered on the ancient architectural complex of the Confucius Temple, with the ten-li inner Qinhuai River as its axis, stretching from Dongshuiguan Park in the east to Xishuiguan Park (now Shuimen Gate) in the west, with a total length of about 5 kilometers.

The Confucius Temple was first built during the period of Emperor Cheng of the Eastern Jin Dynasty, Sima Yan (337–365 AD). It is one of China''s four major Confucian temples and also the first national highest institution of learning in China. Historically, the Confucius Temple experienced "seven destructions and eight constructions." The current architectural complex was mainly built through the restoration project launched in 1984. The Confucius Temple scenic area includes buildings such as the Dacheng Hall, the Lingxing Gate, the Zunjing Pavilion, and the Chongsheng Shrine, and is an important window for understanding Nanjing''s cultural and educational history.

The Qinhuai River is Nanjing''s "Mother River," known as the "Ten-li Qinhuai." Along both banks of the Qinhuai River, numerous historical and cultural relics are distributed: noble residences of the Eastern Jin Dynasty, the Ming Dynasty Bailuzhou Park, the Jiangnan Gongyuan (the largest imperial examination hall in ancient China), the Former Residence of Li Xiangjun, the Former Residence of the Wang and Xie Families, Wuyi Lane, etc. The poem "Wuyi Lane" by Tang Dynasty poet Liu Yuxi, with the lines "Swallows that once visited the halls of Wang and Xie now fly into the homes of ordinary people," has made this small lane famous all over the world.

A night cruise on the Qinhuai River is one of Nanjing''s most representative tourist experiences. Riding a painted boat through the river reflected with lights, the Ming and Qing dynasty buildings, stone bridges, and light shadows on both banks reflect each other, as if traveling back to the prosperous ancient capital of six dynasties.

The scenic area also features characteristic Jinling snacks, such as duck blood vermicelli soup, beef pot stickers, red bean wine-brewed yuanxiao, etc., making it a paradise for food lovers.',
  'P0', '- **Public areas of the scenic area:** Free admission
- **Tickets for internal attractions (reference prices, subject to on-site announcements):**
  - Confucius Temple Dacheng Hall: 30 RMB
  - Nanjing China Imperial Examination Museum (Jiangnan Gongyuan): 50 RMB
  - Former Residence of Li Xiangjun Exhibition Hall: 10 RMB
  - Former Residence of the Wang and Xie Families: 8 RMB
  - Former Residence of Qin Dashi: 5 RMB
  - Zhonghuamen Wengcheng (Gate Tower): 15–20 RMB (April to October 8:30–22:00; November to March 8:30–21:00)
- **Combo ticket information:** Tickets for each attraction can be purchased separately, or combo tickets can be purchased, subject to on-site announcements at the scenic area
- **Qinhuai River painted boat cruise:** Approximately 80–150 RMB/person (prices vary according to different routes)
- **Tip:** Tickets for attractions may be tight during holidays. Advance online ticket purchase or reservation is recommended', NULL,
  '- **Public areas of the scenic area:** Open 24 hours a day
- **Opening hours of internal attractions (reference, subject to on-site announcements):**
  - Confucius Temple Dacheng Hall: 9:00—21:00
  - Nanjing China Imperial Examination Museum: 9:00—21:00
  - Former Residence of Li Xiangjun Exhibition Hall: 9:00—22:00
  - Former Residence of the Wang and Xie Families: 9:00—22:00
  - Former Residence of Qin Dashi: 9:30—17:30
  - Zhonghuamen Wengcheng (Gate Tower): April to October 8:30—22:00; November to March 8:30—21:00
  - Zhanyuan Garden: 8:00—17:00
- **Qinhuai River painted boat cruise:** Day and night shifts are available. Night cruise is about 18:00—22:00
- **Recommended visiting time:** Half a day to a full day; it is recommended to visit from evening to night, so you can enjoy both daytime scenery and night lighting', NULL,
  TRUE, '- **Metro:**
  - Take Metro Line 1 to Sanshan Street Station, then walk about 10 minutes to reach the Confucius Temple Scenic Area
  - Take Metro Line 3 to Confucius Temple Station, then walk about 5 minutes to reach the Confucius Temple Scenic Area
- **Bus:**
  - Take Bus No. 1, 4, 7, 30, 31, 40, 44, 49, 62, 202, 304, etc. and get off at "Confucius Temple" stop or "West Gate of Confucius Temple" stop
- **Self-driving/taxi:** Navigate to "Nanjing Confucius Temple" or "Confucius Temple Scenic Area." There are multiple parking lots in the surrounding area, but parking spaces are tight during holidays. Public transportation is recommended
- **Qinhuai River painted boat cruise docks:** There are multiple docks, mainly distributed near the Confucius Temple Square, Pingjiangfu Road, etc.
- **Tip:** The Confucius Temple - Qinhuai River Scenic Area is one of Nanjing''s most popular tourist areas. The visitor flow is extremely large during holidays. It is recommended to avoid peak hours or choose public transportation',
  '[{"icon": "🎫", "label": "Ticket", "value": "- **Public areas of the scenic area:** Free admission\n- **Tickets for internal attractions (reference prices, subject to on-site announcements):**\n  - Confucius Temple Dacheng Hall: 30 RMB\n  - Nanjing China Imperial Examination Museum (Jiangnan Gongyuan): 50 RMB\n  - Former Residence of Li Xiangjun Exhibition Hall: 10 RMB\n  - Former Residence of the Wang and Xie Families: 8 RMB\n  - Former Residence of Qin Dashi: 5 RMB\n  - Zhonghuamen Wengcheng (Gate Tower): 15–20 RMB (April to October 8:30–22:00; November to March 8:30–21:00)\n- **Combo ticket information:** Tickets for each attraction can be purchased separately, or combo tickets can be purchased, subject to on-site announcements at the scenic area\n- **Qinhuai River painted boat cruise:** Approximately 80–150 RMB/person (prices vary according to different routes)\n- **Tip:** Tickets for attractions may be tight during holidays. Advance online ticket purchase or reservation is recommended"}, {"icon": "🕘", "label": "Opening Hours", "value": "- **Public areas of the scenic area:** Open 24 hours a day\n- **Opening hours of internal attractions (reference, subject to on-site announcements):**\n  - Confucius Temple Dacheng Hall: 9:00—21:00\n  - Nanjing China Imperial Examination Museum: 9:00—21:00\n  - Former Residence of Li Xiangjun Exhibition Hall: 9:00—22:00\n  - Former Residence of the Wang and Xie Families: 9:00—22:00\n  - Former Residence of Qin Dashi: 9:30—17:30\n  - Zhonghuamen Wengcheng (Gate Tower): April to October 8:30—22:00; November to March 8:30—21:00\n  - Zhanyuan Garden: 8:00—17:00\n- **Qinhuai River painted boat cruise:** Day and night shifts are available. Night cruise is about 18:00—22:00\n- **Recommended visiting time:** Half a day to a full day; it is recommended to visit from evening to night, so you can enjoy both daytime scenery and night lighting"}, {"icon": "🚇", "label": "Metro", "value": "- **Metro:**\n  - Take Metro Line 1 to Sanshan Street Station, then walk about 10 minutes to reach the Confucius Temple Scenic Area\n  - Take Metro Line 3 to Confucius Temple Station, then walk about 5 minutes to reach the Confucius Temple Scenic Area\n- **Bus:**\n  - Take Bus No. 1, 4, 7, 30, 31, 40, 44, 49, 62, 202, 304, etc. and get off at \"Confucius Temple\" stop or \"West Gate of Confucius Temple\" stop\n- **Self-driving/taxi:** Navigate to \"Nanjing Confucius Temple\" or \"Confucius Temple Scenic Area.\" There are multiple parking lots in the surrounding area, but parking spaces are tight during holidays. Public transportation is recommended\n- **Qinhuai River painted boat cruise docks:** There are multiple docks, mainly distributed near the Confucius Temple Square, Pingjiangfu Road, etc.\n- **Tip:** The Confucius Temple - Qinhuai River Scenic Area is one of Nanjing''s most popular tourist areas. The visitor flow is extremely large during holidays. It is recommended to avoid peak hours or choose public transportation"}]'::jsonb, '[]'::jsonb, '[]'::jsonb,
  'Gongyuan Street, Qinhuai District, Nanjing, Jiangsu Province (Confucius Temple Central Scenic Area)', '江苏省南京市秦淮区贡院街（夫子庙中心景区）',
  0, 'com.chinago.travel.attraction.nanjing_confucius_temple_qinhuai', 2, TRUE
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
  'nanjing_ming_xiaoling', 'nanjing', 'Ming Xiaoling Mausoleum, Nanjing', '南京明孝陵',
  'sight', 'attractions/nanjing_ming_xiaoling.png', 'Ming Xiaoling Mausoleum in Nanjing is the tomb of Emperor Zhu Yuanzhang (the founding emperor of the Ming Dynasty) and Empress Ma. It is one of the largest imperial mausoleums in China and pioneered the basic layout of imperial mausoleums of the Ming and Qing dynasties, known as "The First Imperial Mausoleum of the Ming and Qing Dynasties."', 'Ming Xiaoling Mausoleum is located in the Purple Mountain Scenic Area in Xuanwu District, Nanjing. It is the tomb of Emperor Zhu Yuanzhang (the founding emperor of the Ming Dynasty) and Empress Ma. Construction began in the 14th year of the Hongwu reign of the Ming Dynasty (1381) and was basically completed in the 3rd year of the Yongle reign (1405), taking 25 years and mobilizing more than 100,000 military workers.

Ming Xiaoling Mausoleum deeply absorbed the culture of Southern Dynasty mausoleums and the essence of Tang and Song imperial mausoleums, with far-reaching regulations and a grand layout. The entire mausoleum area is divided into two major parts: the front section is the Spirit Way part, about 1,800 meters long, with stone animals, stone figures and other stone statues lined up on both sides, with different expressions and vivid images; the rear section is the main body of the mausoleum, including buildings such as the Civil and Military Square Gate, Xiaoling Hall, Square City, Ming Tower, and Treasure Mound. Among them, Xiaoling Hall (Enjoyment Hall) originally had a brilliant building complex. There are now 56 giant stone column bases, which give an idea of the grand scale of that year.

The "square in front, round at the back" mausoleum regulation pioneered by Ming Xiaoling Mausoleum profoundly influenced the shape and system of imperial mausoleums for more than 500 years during the Ming and Qing dynasties, and has a milestone position in the development history of Chinese imperial mausoleums. The Eastern Qing Tombs and Western Qing Tombs of the Qing Dynasty, as well as the Thirteen Tombs of the Ming Dynasty, all inherited the basic layout of Ming Xiaoling Mausoleum.

In July 2003, after deliberation and approval at the 27th session of the UNESCO World Heritage Committee, Ming Xiaoling Mausoleum was officially inscribed on the UNESCO World Heritage List as an extension project of "Imperial Tombs of the Ming and Qing Dynasties." Today, Ming Xiaoling Mausoleum is not only an important historical and cultural landmark in Nanjing, but also a must-visit place for Chinese and foreign tourists to feel the atmosphere of the Ming Dynasty and appreciate the charm of the ancient capital of six dynasties. In spring and autumn, the stone elephant spirit way in the mausoleum area has fiery maple leaves and golden ginkgo, and the scenery is especially magnificent.',
  'P0', '- **Ticket price:** 70 RMB/person (60 RMB/person during Plum Blossom Festival)
- **Preferential policies:** Seniors over 60 years old, students, military personnel, etc. enjoy discounts with valid documents; children under 6 years old (inclusive) or under 1.4 meters (inclusive) in height are free
- **Combo ticket information:** Ming Xiaoling Mausoleum Scenic Area + Linggu Scenic Area + Music Stage + Meiling Palace combo ticket 100 RMB/person
- **Reservation method:** Tickets can be purchased through the official WeChat public account of "Zhongshan Scenic Area," or purchased on-site
- **Tip:** Tickets are valid on the day of visit. Re-entry after leaving the park requires repurchasing tickets', '**Special note:** Opening hours of small attractions within the scenic area may vary, subject to on-site announcements at the scenic area',
  '- **March to October:** 6:30–18:30 (last entry at 18:00)
- **November to February of the following year:** 6:30–18:00 (last entry at 17:30)
- **Special note:** Opening hours of small attractions within the scenic area may vary, subject to on-site announcements at the scenic area
- **Recommended visiting time:** 2–3 hours', NULL,
  TRUE, '- **Metro:**
  - Take Metro Line 2 to Muxuyuan Station, then walk or transfer to the scenic area sightseeing bus to Ming Xiaoling Mausoleum Scenic Area
  - Take Metro Line 2 to Xiamafang Station, then walk about 15 minutes to reach Ming Xiaoling Mausoleum Scenic Area
- **Bus:**
  - Take Bus No. 20 to Ming Xiaoling Station, enter through Gate 1
  - Take Bus No. 315 to Meihua Valley South Gate Station
  - Take Bus No. 20 to Ming Xiaoling Parking Lot Station
- **Scenic area sightseeing bus:** Sightseeing bus routes are set up within the Purple Mountain Scenic Area. You can take the sightseeing bus to travel between various attractions
- **Self-driving:** Navigate to "Ming Xiaoling Mausoleum Scenic Area" or "Ming Xiaoling Parking Lot." The scenic area has parking lots
- **Tip:** The Purple Mountain Scenic Area covers a large area. It is recommended to reserve sufficient time and give priority to public transportation or scenic area sightseeing buses',
  '[{"icon": "🎫", "label": "Ticket", "value": "- **Ticket price:** 70 RMB/person (60 RMB/person during Plum Blossom Festival)\n- **Preferential policies:** Seniors over 60 years old, students, military personnel, etc. enjoy discounts with valid documents; children under 6 years old (inclusive) or under 1.4 meters (inclusive) in height are free\n- **Combo ticket information:** Ming Xiaoling Mausoleum Scenic Area + Linggu Scenic Area + Music Stage + Meiling Palace combo ticket 100 RMB/person\n- **Reservation method:** Tickets can be purchased through the official WeChat public account of \"Zhongshan Scenic Area,\" or purchased on-site\n- **Tip:** Tickets are valid on the day of visit. Re-entry after leaving the park requires repurchasing tickets"}, {"icon": "🕐", "label": "Duration", "value": "**Special note:** Opening hours of small attractions within the scenic area may vary, subject to on-site announcements at the scenic area"}, {"icon": "🕘", "label": "Opening Hours", "value": "- **March to October:** 6:30–18:30 (last entry at 18:00)\n- **November to February of the following year:** 6:30–18:00 (last entry at 17:30)\n- **Special note:** Opening hours of small attractions within the scenic area may vary, subject to on-site announcements at the scenic area\n- **Recommended visiting time:** 2–3 hours"}, {"icon": "🚇", "label": "Metro", "value": "- **Metro:**\n  - Take Metro Line 2 to Muxuyuan Station, then walk or transfer to the scenic area sightseeing bus to Ming Xiaoling Mausoleum Scenic Area\n  - Take Metro Line 2 to Xiamafang Station, then walk about 15 minutes to reach Ming Xiaoling Mausoleum Scenic Area\n- **Bus:**\n  - Take Bus No. 20 to Ming Xiaoling Station, enter through Gate 1\n  - Take Bus No. 315 to Meihua Valley South Gate Station\n  - Take Bus No. 20 to Ming Xiaoling Parking Lot Station\n- **Scenic area sightseeing bus:** Sightseeing bus routes are set up within the Purple Mountain Scenic Area. You can take the sightseeing bus to travel between various attractions\n- **Self-driving:** Navigate to \"Ming Xiaoling Mausoleum Scenic Area\" or \"Ming Xiaoling Parking Lot.\" The scenic area has parking lots\n- **Tip:** The Purple Mountain Scenic Area covers a large area. It is recommended to reserve sufficient time and give priority to public transportation or scenic area sightseeing buses"}]'::jsonb, '[]'::jsonb, '[]'::jsonb,
  'Ming Xiaoling Mausoleum Scenic Area, Purple Mountain Scenic Area, Xuanwu District, Nanjing, Jiangsu Province (at the foot of Wanju Peak, Dulongfu, on the southern slope of Purple Mountain)', '江苏省南京市玄武区钟山风景名胜区-明孝陵景区（钟山南麓独龙阜玩珠峰下）',
  0, 'com.chinago.travel.attraction.nanjing_ming_xiaoling', 3, TRUE
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
  'nanjing_presidential_palace', 'nanjing', 'Nanking Presidential Palace (Nanjing Museum of Modern Chinese History)', '总统府（南京中国近代史遗址博物馆）',
  'museum', 'attractions/nanjing_presidential_palace.png', 'The Presidential Palace is the largest-scale and best-preserved architectural complex of modern Chinese history. It has witnessed multiple important historical periods such as the Taiping Heavenly Kingdom and the Republic of China, and is a "panoramic museum of modern history."', 'The Presidential Palace is located at No. 292 Changjiang Road, Xuanwu District, Nanjing. It is the largest-scale and best-preserved architectural complex of modern Chinese history, and is now the Museum of Modern Chinese History, as well as a national AAAA-level tourist attraction.

The architectural complex of the Presidential Palace covers an area of about 150,000 square meters and has a history of more than 600 years to date. In the Ming Dynasty, this place was the Han Prince''s Mansion; in the Qing Dynasty, it was the Liangjiang Viceroy''s Yamen and the Jiangning Weaving Bureau; during the Taiping Heavenly Kingdom period, Hong Xiuquan built the grand-scale "Heavenly King''s Palace" here; on January 1, 1912, Dr. Sun Yat-sen was sworn in here as the Provisional Grand President of the Republic of China and established the Provisional Government of the Republic of China; from 1927 to 1949, this place became the seat of the Nanjing National Government, where Chiang Kai-shek, Lin Sen, Li Zongren, etc. successively worked.

The architectural complex has 118 buildings of various types, totaling 1,098 rooms, with a construction area of about 71,000 square meters. The architectural styles blend various styles such as traditional Chinese palace style, Chinese official government office style, Western classical style, Western modern style, etc., and can be called a "Museum of Modern Chinese Architecture." Main attractions include: the Gate Tower, the Chaofang (FrontOffice Houses), the Main Hall, the Second Hall, the Eight-Character Hall, the Reception Hall, the Qilin Gate, the Political Affairs Bureau Building, the Zichao Building, the Air-Raid Shelter, the Wangfei Pavilion, the Yilan Pavilion, the Waterside Pavilion, the Stone Boat, etc.

Historical sites such as the "Heavenly King''s Palace" of the Taiping Heavenly Kingdom, Dr. Sun Yat-sen''s office as Provisional Grand President, Chiang Kai-shek''s "Zichao Building," and the official residence of the Chairman of the National Government are all preserved here. Among them, the "Zichao Building" is Chiang Kai-shek''s office building. It got its name because Chiang Kai-shek''s courtesy name was "Zhongzheng" and his elegant name was "Zichao."

The Presidential Palace is not only an important historical site, but also the best window to understand modern Chinese history and feel the changes of a century of ups and downs. Through a large number of historical photos, cultural relics, archives, and scene restorations, the museum vividly reappears the century-long history from the Opium War to the liberation of Nanjing in 1949.',
  'P0', '- **Ticket price:** 35 RMB/person
- **Preferential policies:**
  - Seniors aged 60 (inclusive) to 69 (inclusive) enjoy half-price discount with valid ID document
  - Children under 6 years old (inclusive) or under 1.4 meters (inclusive) in height are free
  - Seniors aged 70 and above, active military personnel, people with disabilities, retired officials, etc. are free with valid documents
- **Reservation method:** Tickets can be purchased through the official WeChat public account of "Nanjing Presidential Palace," or purchased on-site
- **Tip:** There are many visitors during holidays. Advance online ticket purchase or reservation is recommended to reduce queuing time', NULL,
  '- **Opening hours:**
  - March 1–October 14: 8:30–18:00 (last entry at 17:10)
  - October 15–November 30: 8:30–17:30 (last entry at 16:40)
  - December 1–February 28 (29) of the following year: 8:30–17:00 (last entry at 16:10)
- **Closing time:** Except for the Spring Festival holiday, there are no fixed closing days throughout the year
- **Recommended visiting time:** 2–3 hours', NULL,
  TRUE, '- **Metro:**
  - Take Metro Line 2 or Line 3 to Daxinggong Station, exit at Exit 5, and walk about 5 minutes to reach the Presidential Palace
- **Bus:**
  - Take Bus No. 29, 44, 65, 95, 304 and get off at "Presidential Palace" stop, then walk about 1 minute to reach the site
  - Take Bus No. 1, 2, 3, 5, 9, 25, 31, 34, 80, 202, 304, etc. and get off at "Daxinggong" stop, then walk about 5–10 minutes to reach the site
- **Self-driving/taxi:** Navigate to "Nanjing Presidential Palace." There are multiple parking lots in the surrounding area (such as the Jiangning Weaving Museum parking lot, Nanjing Library parking lot, etc.), but parking spaces are tight during holidays. Public transportation is recommended
- **Tip:** The Presidential Palace is located in the center of Nanjing. The surrounding traffic is relatively congested. Priority should be given to public transportation',
  '[{"icon": "🎫", "label": "Ticket", "value": "- **Ticket price:** 35 RMB/person\n- **Preferential policies:**\n  - Seniors aged 60 (inclusive) to 69 (inclusive) enjoy half-price discount with valid ID document\n  - Children under 6 years old (inclusive) or under 1.4 meters (inclusive) in height are free\n  - Seniors aged 70 and above, active military personnel, people with disabilities, retired officials, etc. are free with valid documents\n- **Reservation method:** Tickets can be purchased through the official WeChat public account of \"Nanjing Presidential Palace,\" or purchased on-site\n- **Tip:** There are many visitors during holidays. Advance online ticket purchase or reservation is recommended to reduce queuing time"}, {"icon": "🕘", "label": "Opening Hours", "value": "- **Opening hours:**\n  - March 1–October 14: 8:30–18:00 (last entry at 17:10)\n  - October 15–November 30: 8:30–17:30 (last entry at 16:40)\n  - December 1–February 28 (29) of the following year: 8:30–17:00 (last entry at 16:10)\n- **Closing time:** Except for the Spring Festival holiday, there are no fixed closing days throughout the year\n- **Recommended visiting time:** 2–3 hours"}, {"icon": "🚇", "label": "Metro", "value": "- **Metro:**\n  - Take Metro Line 2 or Line 3 to Daxinggong Station, exit at Exit 5, and walk about 5 minutes to reach the Presidential Palace\n- **Bus:**\n  - Take Bus No. 29, 44, 65, 95, 304 and get off at \"Presidential Palace\" stop, then walk about 1 minute to reach the site\n  - Take Bus No. 1, 2, 3, 5, 9, 25, 31, 34, 80, 202, 304, etc. and get off at \"Daxinggong\" stop, then walk about 5–10 minutes to reach the site\n- **Self-driving/taxi:** Navigate to \"Nanjing Presidential Palace.\" There are multiple parking lots in the surrounding area (such as the Jiangning Weaving Museum parking lot, Nanjing Library parking lot, etc.), but parking spaces are tight during holidays. Public transportation is recommended\n- **Tip:** The Presidential Palace is located in the center of Nanjing. The surrounding traffic is relatively congested. Priority should be given to public transportation"}]'::jsonb, '[]'::jsonb, '[]'::jsonb,
  'No. 292 Changjiang Road, Xuanwu District, Nanjing, Jiangsu Province', '江苏省南京市玄武区长江路292号',
  0, 'com.chinago.travel.attraction.nanjing_presidential_palace', 4, TRUE
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
  'nanjing_massacre_memorial', 'nanjing', 'Memorial Hall of the Victims in Nanjing Massacre by Japanese Invaders', '侵华日军南京大屠杀遇难同胞纪念馆',
  'museum', 'attractions/nanjing_massacre_memorial.png', 'The Memorial Hall of the Victims in Nanjing Massacre by Japanese Invaders is the only memorial hall in China with the Nanjing Massacre as its historical background. Bearing the national memory and vision of peace, it is an important historical witness to the victory of the World Anti-Fascist War.', 'The Memorial Hall of the Victims in Nanjing Massacre by Japanese Invaders is located at No. 418 Shuiximen Street, Jianye District, Nanjing. Covering an area of about 74,000 square meters, it is one of China''s first national first-class museums, a national demonstration base for patriotic education, and a major historical and cultural site protected at the national level.

The memorial hall was completed and opened on August 15, 1985, and has been expanded twice since then. It is now a comprehensive memorial hall covering multiple exhibition areas including the "Nanjing Massacre History Exhibition Area," the "Three Victories" exhibition area, and the former site of the Lijixiang Comfort Women Station. The exhibition hall building was designed by Academician Qi Kang. The overall shape resembles a broken military knife, symbolizing the failure of the invaders and the preciousness of peace. Large-scale sculptures such as "Family Ruined" and "Refugee" stand in the square, giving people a strong visual impact and spiritual shock.

The exhibition in the hall centers on the historical event of the "Nanking Massacre," and through a large number of historical photos, cultural relics, archive materials, video products, and scene restorations, truly, comprehensively, and profoundly displays the historical truth of the Nanjing Massacre from December 13, 1937 to January 1938. Among them, the Wall of Names of Victims (Crying Wall) is engraved with the names of more than ten thousand victims, and is one of the most solemn and awe-inspiring places in the memorial hall.

The memorial hall is open to the public free of charge all year round (closed on Mondays). It is an important place for patriotic education, historical research, and peace exchanges. The National Memorial Ceremony for the Victims of the Nanjing Massacre is held here on December 13 every year, reminding the world to remember history, cherish peace, and create the future.',
  'P0', '- **Ticket price:** Free admission (advance reservation required)
- **Reservation method:** Make an advance reservation through the memorial hall''s official WeChat public account or official website. Enter the hall with the reservation voucher and valid ID document
- **Special note:** Closed on Mondays (open on national statutory holidays); special opening arrangements may be implemented on December 13 (National Memorial Day for Nanjing Massacre Victims), please pay attention to official announcements', NULL,
  '- **Opening hours:** Tuesday to Sunday 8:30–17:30 (last entry at 16:30)
- **Closing time:** Closed on Mondays (open on national statutory holidays)
- **Special periods:** Opening hours may be adjusted during statutory holidays and periods of large visitor flow, please pay attention to official announcements
- **Recommended visiting time:** 2–3 hours', NULL,
  TRUE, '- **Metro:** Take Metro Line 2 to Yunjin Road Station, exit at Exit 2 and enter the hall through Gate 1; during statutory holidays and periods of large visitor flow, exit at Exit 3 and enter the hall through Gate 1
- **Bus:** Take Bus No. 7, 37, 61, 63, 166, 170, 186, etc. and get off at "Shuiximen·Jiangdongmen" stop or "Jiangdongmen Memorial Hall" stop
- **Self-driving:** Navigate to "Memorial Hall of the Victims in Nanjing Massacre by Japanese Invaders." Vehicles can be parked in the "Three Victories" underground parking lot (near the intersection of Shuiximen Street and Jiangdong Middle Road)
- **Tip:** Visitor flow is large during holidays and memorial days. Public transportation is recommended, and please complete the reservation in advance',
  '[{"icon": "🎫", "label": "Ticket", "value": "- **Ticket price:** Free admission (advance reservation required)\n- **Reservation method:** Make an advance reservation through the memorial hall''s official WeChat public account or official website. Enter the hall with the reservation voucher and valid ID document\n- **Special note:** Closed on Mondays (open on national statutory holidays); special opening arrangements may be implemented on December 13 (National Memorial Day for Nanjing Massacre Victims), please pay attention to official announcements"}, {"icon": "🕘", "label": "Opening Hours", "value": "- **Opening hours:** Tuesday to Sunday 8:30–17:30 (last entry at 16:30)\n- **Closing time:** Closed on Mondays (open on national statutory holidays)\n- **Special periods:** Opening hours may be adjusted during statutory holidays and periods of large visitor flow, please pay attention to official announcements\n- **Recommended visiting time:** 2–3 hours"}, {"icon": "🚇", "label": "Metro", "value": "- **Metro:** Take Metro Line 2 to Yunjin Road Station, exit at Exit 2 and enter the hall through Gate 1; during statutory holidays and periods of large visitor flow, exit at Exit 3 and enter the hall through Gate 1\n- **Bus:** Take Bus No. 7, 37, 61, 63, 166, 170, 186, etc. and get off at \"Shuiximen·Jiangdongmen\" stop or \"Jiangdongmen Memorial Hall\" stop\n- **Self-driving:** Navigate to \"Memorial Hall of the Victims in Nanjing Massacre by Japanese Invaders.\" Vehicles can be parked in the \"Three Victories\" underground parking lot (near the intersection of Shuiximen Street and Jiangdong Middle Road)\n- **Tip:** Visitor flow is large during holidays and memorial days. Public transportation is recommended, and please complete the reservation in advance"}]'::jsonb, '[]'::jsonb, '[]'::jsonb,
  '- **Main Exhibition Area (Nanjing Massacre History Exhibition Area, Three Victories Exhibition Area):** No. 418 Shuiximen Street, Jianye District, Nanjing, Jiangsu Province
- **Former Site of Lijixiang Comfort Women Station Exhibition Area:** No. 2 Liji Lane, Qinhuai District, Nanjing, Jiangsu Province', '- **主展区（南京大屠杀史展区、三个必胜展区）：** 江苏省南京市建邺区水西门大街418号
- **利济巷慰安所旧址展区：** 江苏省南京市秦淮区利济巷2号',
  0, 'com.chinago.travel.attraction.nanjing_massacre_memorial', 5, TRUE
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
  'nanjing_city_wall', 'nanjing', 'Nanjing Ming City Wall', '南京明城墙',
  'wall', 'attractions/nanjing_city_wall.png', 'The Nanjing Ming City Wall was first built in 1366 and is the longest extant ancient city wall in the world. It is also the only capital-level city wall historically built in the Jiangnan region of China. About 25.1 kilometers of basically intact city wall still exist today. It is one of Nanjing''s most iconic historical and cultural heritages.', 'The Nanjing Ming City Wall was first built in the 9th year of the Hongwu reign of the Ming Dynasty (1366) and was completed in the 26th year of the Hongwu reign (1393). It took 28 years to complete and mobilized the money and grain of 1 chief secretariat, 3 guards, 5 provinces, 28 prefectures, and 152 counties, as well as tens of thousands of military and civilian craftsmen. It is the longest extant ancient city wall in the world and the only capital-level city wall historically built in the Jiangnan region of China.

The Nanjing Ming City Wall was built according to the mountains and waters, following the shape and terrain. It broke through the old regulation of taking a square or rectangular shape for previous capital cities, and combined the complex topographic features of Nanjing to form an asymmetric and irregular plane layout. The city wall originally had two layers: the outer Guo and the inner city. The outer Guo had a perimeter of about 60 kilometers, and the inner city (i.e., the extant Ming city wall) had a perimeter of about 35.267 kilometers. About 25.1 kilometers of basically intact city wall still exist today. The highest point reaches 25 meters, the top width is 7—12 meters, the bottom width is 10—18 meters, there are 13,616 crenelations, 200 guard houses, and 13 city gates.

The Nanjing Ming City Wall is not only the peak work of Chinese military defense engineering, but also one of Nanjing''s most iconic historical and cultural heritages. The wall structure is extremely solid. The base is built with granite or limestone slab stones, the wall body is built with huge city bricks, and "mixed slurry" made from a mixture of glutinous rice juice, lime, tung oil, etc. is used as an adhesive, so that the city wall still stands towering after more than 600 years of wind and rain.

Today, some sections of the Nanjing Ming City Wall have been opened to the public as scenic areas, including the Zhonghuamen Section, the Taicheng Section, the Shencemen Section, the Zhongshanmen Section, the Xuanwumen Section, the Jiefangmen Section, etc. Among them, Zhonghuamen (original name Jubao Gate) is the largest extant city gate of the Nanjing Ming City Wall and also the largest extant city gate in China. It has three Wengcheng (enclosure fortifications) and four city gates, with a strict layout and unique structure. It is the best place to understand the defense system of the Nanjing Ming City Wall. The Taicheng Section allows a panoramic view of Xuanwu Lake and is one of the most ornamental valuable sections of the Nanjing Ming City Wall.

In 2012, the "City Walls of the Ming and Qing Dynasties in China" combined project, including the Nanjing Ming City Wall, was designated by the National Cultural Heritage Administration as a project for the "China World Cultural Heritage Tentative List."',
  'P1', '- **Zhonghuamen Wengcheng (Gate Tower):** 50 RMB/person
- **Taicheng Section (Jiefangmen Section):** 30 RMB/person
- **Shencemen Section:** Subject to on-site announcements
- **Some sections (such as Xuanwumen Section, Zhongshanmen Section, etc.):** Free admission
- **Preferential policies:** Seniors over 60 years old, students, military personnel, etc. enjoy discounts with valid documents; children under 6 years old (inclusive) or under 1.4 meters (inclusive) in height are free
- **Tip:** Ticket prices vary for different wall entry points, and some sections are open free of charge. It is recommended to check the ticket information of specific wall entry points in advance', NULL,
  '- **Daytime opening hours:** Generally 8:00—17:00 (subject to announcements at each wall entry point)
- **Night opening hours:** To facilitate citizens and tourists to enjoy the night view of the city wall, Zhonghuamen and Jiefangmen (Taicheng Section) implement evening opening. In peak season (April of the current year to October of the current year), the opening hours are 17:00—22:00 (ticket sales stop at 21:30); off-season opening hours may be adjusted, subject to on-site announcements
- **Special note:** Some sections may be temporarily closed due to repairs, weather, etc. Please pay attention to official announcements
- **Recommended visiting time:** 1—2 hours/section', NULL,
  FALSE, '- **Zhonghuamen Section:**
  - Metro: Take Metro Line 1 to Zhonghuamen Station, then walk about 5 minutes after exiting the station to reach the site
  - Bus: Take Bus No. 2, 16, 26, 33, 49, 63, 202, 302, Y2, Y20 to "Zhonghuamen Nei" stop or "Zhonghuamen Castle" stop and get off
- **Taicheng Section (Jiefangmen Section):**
  - Metro: Take Metro Line 3 to Jiming Temple Station, then walk about 10 minutes after exiting the station to reach Jiefangmen
  - Bus: Take Bus No. 2, 3, 20, 31, 44, 48, 52, 67, 70, 201, 304 to "Jiming Temple" stop or "Jiefangmen" stop and get off
- **Shencemen Section:**
  - Metro: Take Metro Line 1 to Nanjing Station, then walk about 10 minutes after exiting the station to reach Shencemen Park
  - Bus: Take Bus No. 1, 8, 22, 25, 28, 32, 33, 35, 36, 45, 56, 59, 64, 66, 69, 73, 76, 77, 136, 157, 159, 173, 176, Y1, Y9, Y19, and many other routes to "Nanjing Station" or "Shencemen" stop and get off
- **Tip:** The various sections of the Nanjing Ming City Wall are scattered. It is recommended to plan the visiting route in advance and choose 1—2 sections for focused visiting',
  '[{"icon": "🎫", "label": "Ticket", "value": "- **Zhonghuamen Wengcheng (Gate Tower):** 50 RMB/person\n- **Taicheng Section (Jiefangmen Section):** 30 RMB/person\n- **Shencemen Section:** Subject to on-site announcements\n- **Some sections (such as Xuanwumen Section, Zhongshanmen Section, etc.):** Free admission\n- **Preferential policies:** Seniors over 60 years old, students, military personnel, etc. enjoy discounts with valid documents; children under 6 years old (inclusive) or under 1.4 meters (inclusive) in height are free\n- **Tip:** Ticket prices vary for different wall entry points, and some sections are open free of charge. It is recommended to check the ticket information of specific wall entry points in advance"}, {"icon": "🕘", "label": "Opening Hours", "value": "- **Daytime opening hours:** Generally 8:00—17:00 (subject to announcements at each wall entry point)\n- **Night opening hours:** To facilitate citizens and tourists to enjoy the night view of the city wall, Zhonghuamen and Jiefangmen (Taicheng Section) implement evening opening. In peak season (April of the current year to October of the current year), the opening hours are 17:00—22:00 (ticket sales stop at 21:30); off-season opening hours may be adjusted, subject to on-site announcements\n- **Special note:** Some sections may be temporarily closed due to repairs, weather, etc. Please pay attention to official announcements\n- **Recommended visiting time:** 1—2 hours/section"}, {"icon": "🚇", "label": "Metro", "value": "- **Zhonghuamen Section:**\n  - Metro: Take Metro Line 1 to Zhonghuamen Station, then walk about 5 minutes after exiting the station to reach the site\n  - Bus: Take Bus No. 2, 16, 26, 33, 49, 63, 202, 302, Y2, Y20 to \"Zhonghuamen Nei\" stop or \"Zhonghuamen Castle\" stop and get off\n- **Taicheng Section (Jiefangmen Section):**\n  - Metro: Take Metro Line 3 to Jiming Temple Station, then walk about 10 minutes after exiting the station to reach Jiefangmen\n  - Bus: Take Bus No. 2, 3, 20, 31, 44, 48, 52, 67, 70, 201, 304 to \"Jiming Temple\" stop or \"Jiefangmen\" stop and get off\n- **Shencemen Section:**\n  - Metro: Take Metro Line 1 to Nanjing Station, then walk about 10 minutes after exiting the station to reach Shencemen Park\n  - Bus: Take Bus No. 1, 8, 22, 25, 28, 32, 33, 35, 36, 45, 56, 59, 64, 66, 69, 73, 76, 77, 136, 157, 159, 173, 176, Y1, Y9, Y19, and many other routes to \"Nanjing Station\" or \"Shencemen\" stop and get off\n- **Tip:** The various sections of the Nanjing Ming City Wall are scattered. It is recommended to plan the visiting route in advance and choose 1—2 sections for focused visiting"}]'::jsonb, '[]'::jsonb, '[]'::jsonb,
  'The Nanjing Ming City Wall is distributed across multiple districts of Nanjing. The addresses of the main wall entry points are as follows:
- **Zhonghuamen Section:** Zhonghuamen Castle, Qinhuai District, Nanjing, Jiangsu Province
- **Taicheng Section (Jiefangmen Section):** Jiefangmen (near Jiming Temple), Xuanwu District, Nanjing, Jiangsu Province
- **Shencemen Section:** Shencemen Park, Xuanwu District, Nanjing, Jiangsu Province
- **Zhongshanmen Section:** Zhongshanmen, Xuanwu District, Nanjing, Jiangsu Province
- **Xuanwumen Section:** Xuanwumen, Xuanwu Lake Park, Xuanwu District, Nanjing, Jiangsu Province', '南京明城墙全线分布于南京市多个区，主要登城口地址如下：
- **中华门段：** 江苏省南京市秦淮区中华门城堡
- **台城段（解放门段）：** 江苏省南京市玄武区解放门（近鸡鸣寺）
- **神策门段：** 江苏省南京市玄武区神策门公园
- **中山门段：** 江苏省南京市玄武区中山门
- **玄武门段：** 江苏省南京市玄武区玄武湖公园玄武门',
  0, 'com.chinago.travel.attraction.nanjing_city_wall', 6, TRUE
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
  'nanjing_niushoushan', 'nanjing', 'Niushou Mountain Cultural Tourism Zone, Nanjing', '南京牛首山文化旅游区',
  'temple', 'attractions/nanjing_niushoushan.png', 'Niushou Mountain Cultural Tourism Zone in Nanjing is a comprehensive cultural tourism zone that carries half of Jinling''s cultural history. It is famous for being the enshrinement place of the Buddhist parietal bone relic and the magnificent Buddha''s Summit Palace. It is a Buddhist cultural holy land integrating culture, tourism, and leisure.', 'Niushou Mountain Cultural Tourism Zone is located in Jiangning District, Nanjing. In ancient times, it was called "Tianque Mountain" and is one of the four famous scenic spots in Jinling. It has been a famous Buddhist mountain since ancient times and enjoys the beautiful reputation of "Spring Niushou". Niushou Mountain got its name because the twin peaks on the mountaintop stand opposite each other like the two horns of an ox head. In the Tang Dynasty, Chan Master Farong founded the "Niutou School" here, making Niushou Mountain one of the important birthplaces of Chinese Zen Buddhism.

In 2010, the Buddhist parietal bone relic shone again in Nanjing during prosperous times. To permanently enshrine this world''s only parietal bone relic of Sakyamuni Buddha, it was decided in 2012 to build an underground palace on Niushou Mountain for long-term enshrinement. The park was fully completed and opened in October 2015.

The core building of the scenic area, the Buddha''s Summit Palace, is built above a huge mining pit with a diameter of more than 200 meters. It has six underground floors and three above-ground floors, with a total construction area of about 136,000 square meters. The interior decoration of the Buddha''s Summit Palace is extremely luxurious. The dome, murals, Buddha statues, etc. all reflect the essence of Buddhist culture everywhere, making people marvel. The Buddhist parietal bone relic is enshrined in the core position of the underground palace of the Buddha''s Summit Palace and is the supreme sacred object in the Buddhist community.

In addition to the Buddha''s Summit Palace, there are many other attractions in the scenic area, such as the Buddha''s Summit Pagoda, Niutou Zen Cultural Park, the remains of Yue Fei''s resistance against the Jin Dynasty, cliff stone carvings, Hongjue Temple Pagoda, etc. The Buddha''s Summit Pagoda is a nine-level, four-sided, seven-story pavilion-style pagoda. Climbing the pagoda offers a panoramic view of Niushou Mountain.

Niushou Mountain is not only a famous Buddhist mountain, but also a comprehensive cultural tourism zone integrating natural scenery, historical culture, and leisure vacation. In spring, peach blossoms are in full bloom on Niushou Mountain and new green is all over the fields, making it the first choice for Nanjing people to go for spring outings.',
  'P1', '- **Ticket price:** 98 RMB/person (specific prices are subject to official announcements of the scenic area and may be adjusted seasonally)
- **Preferential policies:** Seniors aged 60 and above, students, military personnel, etc. enjoy discounts with valid documents; children under 6 years old (inclusive) or under 1.4 meters (inclusive) in height are free
- **Sightseeing bus:** Sightseeing buses are available in the scenic area for a fee. Specific prices are subject to announcements in the scenic area
- **Tip:** It is recommended to check the latest ticket prices and preferential policies in advance through official channels', '**Special note:** Opening hours may be adjusted during holidays, please pay attention to official announcements of the scenic area',
  '- **Opening hours:** All year round 08:30—17:30 (last entry at 17:00)
- **Special note:** Opening hours may be adjusted during holidays, please pay attention to official announcements of the scenic area
- **Recommended visiting time:** 3—4 hours', NULL,
  FALSE, '- **Metro:**
  - Take Metro Line S1 (Airport Line) to Hehai University · Focheng West Road Station, then transfer to a bus or take a taxi to Niushou Mountain Cultural Tourism Zone after exiting the station
- **Bus:**
  - Take Bus No. 754, G70, etc. and get off at "Niushou Mountain Scenic Area" stop, then walk about 10 minutes to reach the entrance of the scenic area
- **Self-driving:** Navigate to "Niushou Mountain Cultural Tourism Zone, Nanjing." The scenic area has a large parking lot
- **Taxi/ride-hailing car:** It takes about 40—60 minutes to take a taxi from downtown Nanjing to Niushou Mountain, with a cost of about 80—120 RMB
- **Tip:** Niushou Mountain is located in Jiangning District, far from downtown Nanjing. It is recommended to reserve sufficient time and give priority to self-driving or taking a taxi',
  '[{"icon": "🎫", "label": "Ticket", "value": "- **Ticket price:** 98 RMB/person (specific prices are subject to official announcements of the scenic area and may be adjusted seasonally)\n- **Preferential policies:** Seniors aged 60 and above, students, military personnel, etc. enjoy discounts with valid documents; children under 6 years old (inclusive) or under 1.4 meters (inclusive) in height are free\n- **Sightseeing bus:** Sightseeing buses are available in the scenic area for a fee. Specific prices are subject to announcements in the scenic area\n- **Tip:** It is recommended to check the latest ticket prices and preferential policies in advance through official channels"}, {"icon": "🕐", "label": "Duration", "value": "**Special note:** Opening hours may be adjusted during holidays, please pay attention to official announcements of the scenic area"}, {"icon": "🕘", "label": "Opening Hours", "value": "- **Opening hours:** All year round 08:30—17:30 (last entry at 17:00)\n- **Special note:** Opening hours may be adjusted during holidays, please pay attention to official announcements of the scenic area\n- **Recommended visiting time:** 3—4 hours"}, {"icon": "🚇", "label": "Metro", "value": "- **Metro:**\n  - Take Metro Line S1 (Airport Line) to Hehai University · Focheng West Road Station, then transfer to a bus or take a taxi to Niushou Mountain Cultural Tourism Zone after exiting the station\n- **Bus:**\n  - Take Bus No. 754, G70, etc. and get off at \"Niushou Mountain Scenic Area\" stop, then walk about 10 minutes to reach the entrance of the scenic area\n- **Self-driving:** Navigate to \"Niushou Mountain Cultural Tourism Zone, Nanjing.\" The scenic area has a large parking lot\n- **Taxi/ride-hailing car:** It takes about 40—60 minutes to take a taxi from downtown Nanjing to Niushou Mountain, with a cost of about 80—120 RMB\n- **Tip:** Niushou Mountain is located in Jiangning District, far from downtown Nanjing. It is recommended to reserve sufficient time and give priority to self-driving or taking a taxi"}]'::jsonb, '[]'::jsonb, '[]'::jsonb,
  'No. 18 Ningdan Avenue, Jiangning District, Nanjing, Jiangsu Province', '江苏省南京市江宁区宁丹大道18号',
  0, 'com.chinago.travel.attraction.nanjing_niushoushan', 7, TRUE
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
  'nanjing_laomendong', 'nanjing', 'Laomendong Historical and Cultural District', '老门东历史文化街区',
  'market', 'attractions/nanjing_laomendong.png', 'Laomendong Historical and Cultural District is the core historical and cultural district in the southern part of old Nanjing. Traditional-style Ming and Qing dynasty buildings were reconstructed here. It gathers intangible cultural heritage and characteristic foods, and is an ideal place to experience the local customs and sentiments of old Nanjing.', 'Laomendong Historical and Cultural District is located east of Zhonghua Gate in Qinhuai District, Nanjing, between the Confucius Temple and the Former Site Park of the Da Bao''en Temple. It gets the name "Mendong" (East of the Gate) because it is located east of the southern gate of Nanjing''s capital city (i.e., Zhonghua Gate), and it is opposite to Laomenxi (West of the Gate).

Laomendong is an ancient place name in the southern part of old Nanjing, and also a gathering place for traditional Nanjing residences. Since ancient times, it has been a place where Jiangnan merchants gathered, culture and talents converged, and great families resided. Historically, Laomendong was an area where commerce and residence were relatively developed in Nanjing. Today, traditional Chinese wooden buildings and horse-head walls are reconstructed according to traditional styles, recreating the original appearance of old Chengnan.

The history of Laomendong can be traced back to the Ming Dynasty. At that time, because it was close to the Da Bao''en Temple and the Jiangnan Manufacturing Bureau, it gradually developed into a key town for handicrafts and commerce. During the Ming and Qing dynasties, Laomendong reached its peak, gathering more than a hundred time-honored brands such as Yunjin workshops, book carving workshops, silver buildings, etc. Today''s Laomendong not only preserves the road distribution of the Ming and Qing dynasties, but also gathers numerous intangible cultural heritages, such as horse-head wall construction craftsmanship, traditional snack production techniques, etc.

The street sculptures in the district are extremely characteristic. There are 4 groups of street sculptures around the Paifang, namely the Rickshaw Puller, Sugar Taro Sprout, Old Mailbox, and Schoolchildren Entering the School (attending private school). The sculpture figures are all "wearing" Ming and Qing dynasty costumes, vividly recreating the residential life of Laomendong during the Ming and Qing dynasties.

Laomendong is also a gathering place for Nanjing cuisine, bringing together numerous Nanjing traditional snacks such as Jiangyouji Pot Stickers, Jiming Soup Dumplings, Shen Wanshan Pig''s Trotters, Huang Qinji Liangfen, and Lan Laoda Sugar Porridge with Lotus Root, etc., allowing tourists to feast their eyes on historical culture while also feasting their mouths.

Laomendong is located in the middle of the Confucius Temple, Zhonghua Gate, and the Da Bao''en Temple. They can be visited as a whole to feel the historical changes of Nanjing from the Ming Dynasty to the Qing Dynasty to the Republic of China and then to the present in one go. The district is open free of charge all day long, and is an ideal place to feel the blending temperament of tradition and modernity in Nanjing.',
  'P1', '- **Public areas of the district:** Free admission
- **Some exhibition halls/experience projects:** May charge separately, subject to on-site announcements
- **Tip:** Restaurants, cafés, handicraft shops, etc. within the district have separate consumption, subject to actual prices', NULL,
  '- **Public areas of the district:** Open 24 hours a day
- **Shops/restaurants/cafés in the district:** Generally 10:00–22:00, specifically subject to the actual business hours of each merchant
- **Recommended visiting time:** 1.5–3 hours', NULL,
  FALSE, '- **Metro:**
  - Take Metro Line 3 to Wudingmen Station, exit at Exit 2, and walk about 5 minutes to reach Laomendong
  - Take Metro Line 1 to Sanshan Street Station, then walk about 15 minutes after exiting the station to reach Laomendong
- **Bus:**
  - Take Bus No. 14, 46, 305, 701, 706, etc. and get off at "Gutong Lane" stop, then walk about 2 minutes to reach the site
  - Take Bus No. 23, 43, 63, 81, 87, 88, 301, 305, etc. and get off at "Pipa Lane" stop, then walk about 5 minutes to reach the site
- **Self-driving/taxi:** Navigate to "Laomendong Historical and Cultural District." There are multiple parking lots in the surrounding area, but parking spaces are tight during holidays. Public transportation is recommended
- **Tip:** Laomendong is located near the Confucius Temple scenic area. It is recommended to arrange visits to the Confucius Temple, Qinhuai River Scenic Area, Zhonghuamen Castle, and other attractions on the same day',
  '[{"icon": "🎫", "label": "Ticket", "value": "- **Public areas of the district:** Free admission\n- **Some exhibition halls/experience projects:** May charge separately, subject to on-site announcements\n- **Tip:** Restaurants, cafés, handicraft shops, etc. within the district have separate consumption, subject to actual prices"}, {"icon": "🕘", "label": "Opening Hours", "value": "- **Public areas of the district:** Open 24 hours a day\n- **Shops/restaurants/cafés in the district:** Generally 10:00–22:00, specifically subject to the actual business hours of each merchant\n- **Recommended visiting time:** 1.5–3 hours"}, {"icon": "🚇", "label": "Metro", "value": "- **Metro:**\n  - Take Metro Line 3 to Wudingmen Station, exit at Exit 2, and walk about 5 minutes to reach Laomendong\n  - Take Metro Line 1 to Sanshan Street Station, then walk about 15 minutes after exiting the station to reach Laomendong\n- **Bus:**\n  - Take Bus No. 14, 46, 305, 701, 706, etc. and get off at \"Gutong Lane\" stop, then walk about 2 minutes to reach the site\n  - Take Bus No. 23, 43, 63, 81, 87, 88, 301, 305, etc. and get off at \"Pipa Lane\" stop, then walk about 5 minutes to reach the site\n- **Self-driving/taxi:** Navigate to \"Laomendong Historical and Cultural District.\" There are multiple parking lots in the surrounding area, but parking spaces are tight during holidays. Public transportation is recommended\n- **Tip:** Laomendong is located near the Confucius Temple scenic area. It is recommended to arrange visits to the Confucius Temple, Qinhuai River Scenic Area, Zhonghuamen Castle, and other attractions on the same day"}]'::jsonb, '[]'::jsonb, '[]'::jsonb,
  'No. 54 Jianzi Lane, Qinhuai District, Nanjing, Jiangsu Province (Kong Miao Subdistrict)', '江苏省南京市秦淮区剪子巷54号（夫子庙街道）',
  0, 'com.chinago.travel.attraction.nanjing_laomendong', 8, TRUE
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
  'nanjing_ganxi_mansion', 'nanjing', 'Gan Xi Residence (Nanjing Folk Custom Museum)', '甘熙宅第（南京民俗博物馆）',
  'museum', 'attractions/nanjing_ganxi_mansion.png', 'Gan Xi Residence (Nanjing Folk Custom Museum) is the largest extant and best-preserved Qing Dynasty residential building complex in Nanjing. It has long been known as the "Ninety-Nine and a Half Rooms" and is the best window to understand Nanjing''s traditional folk custom culture.', 'Gan Xi Residence (Nanjing Folk Custom Museum) is located at No. 400 Zhongshan South Road, Xiananli Street, Nanbuting, Qinhuai District, Nanjing. It is the largest extant and best-preserved Qing Dynasty residential building complex in Nanjing and has long been known as the "Ninety-Nine and a Half Rooms."

Gan Xi Residence was first built during the Jiaqing reign of the Qing Dynasty and was the former residence of Gan Xi, a famous scholar of the Qing Dynasty. Gan Xi was a famous literati and book collector in Nanjing during the Qing Dynasty and wrote many works in his life. The construction area of Gan Xi Residence reaches more than 9,500 square meters. It consists of four groups of multi-entry passage-through buildings, with a total of nineteen courtyards. The courtyards are connected to each other, winding and deep.

Gan Xi Residence itself is the largest exhibit. Its architectural style blends the north and the south. It not only inherits the style of Huizhou ancient buildings, with exquisite wood and stone carvings, but also has the architectural features of the Taihu Lake basin, focusing on the detailed carvings of the beams and frames of the halls. The residence sits facing south and north. Multiple contrasting architectural systems coexist harmoniously in the same residence, reflecting the Chinese traditional philosophical thought of "harmony between heaven and man."

Now the residence serves as the Nanjing Folk Custom Museum. Through scene restoration and physical display, it shows the folk customs of old Nanjing such as weddings, funerals, and festivals and seasonal events. It also has display and inheritance activities of representative projects of intangible cultural heritage. The museum also regularly holds intangible cultural heritage exhibitions and performances such as Nanjing Baiju and Nanjing Pinghua, allowing tourists to appreciate the profound folk cultural heritage of Nanjing while admiring the ancient buildings.

Nanjing Folk Custom Museum is open all day long. The ticket price is about 20 RMB/person. It is an ideal place to understand Nanjing''s traditional folk custom culture and appreciate the architectural art of Qing Dynasty residential buildings.',
  'P1', '- **Ticket price:** 20 RMB/person (prices may change due to policy adjustments, subject to on-site announcements)
- **Preferential policies:** Students, seniors, military personnel, etc. enjoy discounts with valid documents; children under 6 years old (inclusive) or under 1.4 meters (inclusive) in height are free
- **Special note:** Some intangible cultural heritage exhibition and performance activities may charge separately, subject to on-site announcements
- **Tip:** It is recommended to check the latest ticket prices and preferential policies in advance through official channels', '**Special note:** Opening hours may be adjusted during holidays, please pay attention to official announcements',
  '- **Opening hours:** 9:00—17:00 (last entry at 16:30)
- **Closing time:** Closed on Mondays (except for statutory holidays)
- **Special note:** Opening hours may be adjusted during holidays, please pay attention to official announcements
- **Recommended visiting time:** 1.5—2 hours', NULL,
  FALSE, '- **Metro:**
  - Take Metro Line 1 to Sanshan Street Station, exit at Exit 3, and walk about 5 minutes to reach the site
  - Take Metro Line 3 to Confucius Temple Station, then walk about 10 minutes after exiting the station to reach the site
- **Bus:**
  - Take Bus No. 35, 100, 128, 301, 313, Y2, Y12, etc. and get off at "Shengzhou Road" stop or "Zhongshan South Road · Shengzhou Road" stop, then walk about 3—5 minutes to reach the site
- **Self-driving/taxi:** Navigate to "Gan Xi Residence" or "Nanjing Folk Custom Museum." There are a small number of parking spaces in the surrounding area. Public transportation is recommended
- **Tip:** Gan Xi Residence is located in the core area of old Nanjing''s Chengnan. The surrounding roads are relatively narrow. Priority should be given to public transportation',
  '[{"icon": "🎫", "label": "Ticket", "value": "- **Ticket price:** 20 RMB/person (prices may change due to policy adjustments, subject to on-site announcements)\n- **Preferential policies:** Students, seniors, military personnel, etc. enjoy discounts with valid documents; children under 6 years old (inclusive) or under 1.4 meters (inclusive) in height are free\n- **Special note:** Some intangible cultural heritage exhibition and performance activities may charge separately, subject to on-site announcements\n- **Tip:** It is recommended to check the latest ticket prices and preferential policies in advance through official channels"}, {"icon": "🕐", "label": "Duration", "value": "**Special note:** Opening hours may be adjusted during holidays, please pay attention to official announcements"}, {"icon": "🕘", "label": "Opening Hours", "value": "- **Opening hours:** 9:00—17:00 (last entry at 16:30)\n- **Closing time:** Closed on Mondays (except for statutory holidays)\n- **Special note:** Opening hours may be adjusted during holidays, please pay attention to official announcements\n- **Recommended visiting time:** 1.5—2 hours"}, {"icon": "🚇", "label": "Metro", "value": "- **Metro:**\n  - Take Metro Line 1 to Sanshan Street Station, exit at Exit 3, and walk about 5 minutes to reach the site\n  - Take Metro Line 3 to Confucius Temple Station, then walk about 10 minutes after exiting the station to reach the site\n- **Bus:**\n  - Take Bus No. 35, 100, 128, 301, 313, Y2, Y12, etc. and get off at \"Shengzhou Road\" stop or \"Zhongshan South Road · Shengzhou Road\" stop, then walk about 3—5 minutes to reach the site\n- **Self-driving/taxi:** Navigate to \"Gan Xi Residence\" or \"Nanjing Folk Custom Museum.\" There are a small number of parking spaces in the surrounding area. Public transportation is recommended\n- **Tip:** Gan Xi Residence is located in the core area of old Nanjing''s Chengnan. The surrounding roads are relatively narrow. Priority should be given to public transportation"}]'::jsonb, '[]'::jsonb, '[]'::jsonb,
  'Nanbuting, Xiananli Street, No. 400 Zhongshan South Road, Qinhuai District, Nanjing, Jiangsu Province (at the intersection of Shengzhou Road)', '江苏省南京市秦淮区中山南路400号熙南里街区南捕厅（升州路口）',
  0, 'com.chinago.travel.attraction.nanjing_ganxi_mansion', 9, TRUE
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
  'nanjing_1865_creative_park', 'nanjing', 'Chenguang 1865 Science and Technology Creative Industry Park', '晨光1865科技创意产业园',
  'sight', 'attractions/nanjing_1865_creative_park.png', 'Chenguang 1865 Science and Technology Creative Industry Park is a creative industry park transformed from the former site of a century-old arsenal. Integrating science and technology, culture, tourism, and commerce, it is a model work of Nanjing''s modern industrial heritage protection and reuse.', 'Chenguang 1865 Science and Technology Creative Industry Park is located at No. 388 Yingtian Street, Qinhuai District, Nanjing. It is a creative industry park transformed from the former site of the late Qing Dynasty "Jinling Machine Bureau." In 1865, Li Hongzhang founded the "Jinling Machine Bureau" outside Zhonghua Gate in Nanjing. This was one of the earliest modern arsenals in China, two years earlier than the Beiyang Machine Bureau founded by Li Hongzhang in Tianjin, and can be called the "cradle of China''s national industry."

The park covers an area of about 210,000 square meters and has more than 60 historical buildings of various types extant, including buildings from different historical periods such as the Qing Dynasty, the Republic of China, and the early days of the founding of the People''s Republic, with a time span of more than a hundred years. It is one of the largest modern industrial heritage groups extant in China. These buildings have different styles, including Qing Dynasty factory buildings, Republic of China office buildings, production workshops after the founding of the People''s Republic, etc., truthfully recording the development process of China''s modern industry.

In 2007, Nanjing Chenguang Group launched the "Chenguang 1865 Science and Technology Creative Industry Park" project, carrying out protective repair and transformation of the historical buildings in the park. On the basis of preserving the original industrial style and features, modern creative industry elements were injected. The park is divided into five functional areas: fashion life and leisure area, science and technology creative R&D area, arts and crafts creation area, hotel and business area, and science and technology creative expo area.

Today, the park gathers numerous cultural and creative enterprises, designer studios, art exhibition halls, characteristic restaurants, cafés, boutique hotels, etc., and has become one of Nanjing''s most literary and artistic creative industry parks. Tourists can feel the historical profoundness of the century-old industrial heritage here, and can also experience the vitality and passion of the modern creative industry. There is also the Nanjing City Wall Museum in the park, which is the largest city wall thematic museum in China and is worth visiting together.

Chenguang 1865 Science and Technology Creative Industry Park is open free of charge all day long, and is an ideal place to understand Nanjing''s modern industrial history and feel the creative cultural atmosphere.',
  'P2', '- **Public areas of the park:** Free admission
- **Some exhibition halls/experience projects:** May charge separately, subject to on-site announcements
- **Nanjing City Wall Museum:** Free admission (reservation required)
- **Tip:** Some enterprises, studios, restaurants, cafés, etc. within the park have separate consumption, subject to actual prices', NULL,
  '- **Public areas of the park:** Open 24 hours a day
- **Shops/restaurants/cafés within the park:** Generally 10:00–22:00, specifically subject to the actual business hours of each merchant
- **Nanjing City Wall Museum:** 9:00–17:00 (closed on Mondays, except for statutory holidays)
- **Recommended visiting time:** 2–3 hours', NULL,
  TRUE, '- **Metro:**
  - Take Metro Line 1 to Zhonghuamen Station, exit at Exit 2, and walk about 10 minutes to reach Chenguang 1865 Industry Park
- **Bus:**
  - Take Bus No. 2, 16, 38, 63, 110, 126, 202, 302, Y2, Y20, etc. and get off at "Zhonghuamen Nei" stop or "Zhonghuamen Castle" stop, then walk about 5–10 minutes to reach the site
- **Self-driving/taxi:** Navigate to "Chenguang 1865 Science and Technology Creative Industry Park." The park has a parking lot
- **Tip:** The park is located near Zhonghua Gate. It is recommended to arrange visits to Zhonghuamen Castle, the Former Site Park of the Da Bao''en Temple, Laomendong, and other attractions on the same day',
  '[{"icon": "🎫", "label": "Ticket", "value": "- **Public areas of the park:** Free admission\n- **Some exhibition halls/experience projects:** May charge separately, subject to on-site announcements\n- **Nanjing City Wall Museum:** Free admission (reservation required)\n- **Tip:** Some enterprises, studios, restaurants, cafés, etc. within the park have separate consumption, subject to actual prices"}, {"icon": "🕘", "label": "Opening Hours", "value": "- **Public areas of the park:** Open 24 hours a day\n- **Shops/restaurants/cafés within the park:** Generally 10:00–22:00, specifically subject to the actual business hours of each merchant\n- **Nanjing City Wall Museum:** 9:00–17:00 (closed on Mondays, except for statutory holidays)\n- **Recommended visiting time:** 2–3 hours"}, {"icon": "🚇", "label": "Metro", "value": "- **Metro:**\n  - Take Metro Line 1 to Zhonghuamen Station, exit at Exit 2, and walk about 10 minutes to reach Chenguang 1865 Industry Park\n- **Bus:**\n  - Take Bus No. 2, 16, 38, 63, 110, 126, 202, 302, Y2, Y20, etc. and get off at \"Zhonghuamen Nei\" stop or \"Zhonghuamen Castle\" stop, then walk about 5–10 minutes to reach the site\n- **Self-driving/taxi:** Navigate to \"Chenguang 1865 Science and Technology Creative Industry Park.\" The park has a parking lot\n- **Tip:** The park is located near Zhonghua Gate. It is recommended to arrange visits to Zhonghuamen Castle, the Former Site Park of the Da Bao''en Temple, Laomendong, and other attractions on the same day"}]'::jsonb, '[]'::jsonb, '[]'::jsonb,
  'No. 388 Yingtian Street, Qinhuai District, Nanjing, Jiangsu Province', '江苏省南京市秦淮区应天大街388号',
  0, 'com.chinago.travel.attraction.nanjing_1865_creative_park', 10, TRUE
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
  'nanjing_shijiu_lake', 'nanjing', 'Shijiu Lake', '石臼湖',
  'park', 'attractions/nanjing_shijiu_lake.png', 'Shijiu Lake is Nanjing''s "Sky Mirror." It is located at the junction of Lishui District and Gaochun District in Nanjing and Dangtu County, Ma''anshan City, Anhui Province. The lake surface is vast, and the water and sky merge into one color. It is an ideal place for photography enthusiasts and natural scenery lovers.', 'Shijiu Lake is located at the junction of Lishui District and Gaochun District in Nanjing and Dangtu County, Ma''anshan City, Anhui Province. It is one of the largest freshwater lakes around Nanjing and also the mother lake of Lishui and Gaochun. Shijiu Lake has a vast surface area, covering more than 200 square kilometers. The water surface is as calm as a mirror, reflecting the blue sky and white clouds, and is known as Nanjing''s "Sky Mirror."

Since ancient times, Shijiu Lake has been an important source of income and livelihood support for villagers along the lake. The lake abounds in "three delicacies" such as silver fish, crabs, and wild ducks, with unique flavors, famous far and near. Every year during the crab harvest season, crabs from Shijiu Lake become a delicacy sought after by diners around Nanjing.

In recent years, with the opening of Nanjing Metro Line S9, Shijiu Lake has leaped to become one of Nanjing''s most popular "internet celebrity" check-in places. The Line S9 train shuttles on the Shijiu Lake Grand Bridge. Looking out from the metro carriage window, the lake and mountain scenery can be seen in full view. Especially on sunny days, the lake surface reflects the blue sky and white clouds like a mirror, breathtakingly beautiful, and is known as the "metro to the sky mirror."

The best viewing point of Shijiu Lake is the Shijiu Lake Grand Bridge. Tourists can take Metro Line S9 to Tuanjiewei Station or Mingjue Station, and then walk or take a taxi to the lake shore after exiting the station. On sunny days, the lake surface is like a mirror, and the water and sky merge into one color; at sunset, the afterglow of the setting sun sprinkles on the lake surface, glittering with golden light, like a fairyland.

Shijiu Lake is open free of charge all day long. It is an excellent place for leisure tourism, photography check-ins, and parent-child play around Nanjing. Since it is windy by the lake and the sun exposure is strong, it is recommended to take windproof, warmth-keeping, and sun protection measures.',
  'P2', '- **Ticket price:** Free admission
- **Special note:** Shijiu Lake is a natural lake area and does not require ticket purchase; some surrounding farmhouses, fisherman''s homes, etc. may charge separately, subject to actual consumption
- **Tip:** Shijiu Lake is suitable for self-driving or taking Metro Line S9. It is recommended to plan the transportation route in advance', NULL,
  '- **Opening hours:** Open 24 hours a day
- **Best viewing time:**
  - **Sunny daytime:** The lake surface is like a mirror, and the water and sky merge into one color, suitable for photography
  - **At sunset (about 17:00—19:00, specifically varying by season):** The afterglow of the setting sun sprinkles on the lake surface, glittering with golden light, extremely spectacular
  - **Clear nights:** There is relatively litle light pollution by the lake, suitable for stargazing
- **Recommended visiting time:** 2—3 hours', NULL,
  FALSE, '- **Metro:**
  - Take Metro Line S9 (operating hours about 6:00—22:00) to Tuanjiewei Station (Exit 1), then walk about 20—30 minutes or take a taxi to the lake shore after exiting the station
  - Take Metro Line S9 to Mingjue Station (Exit 1), then walk about 1.5 kilometers or take a taxi to Shijiu Lake Grand Bridge after exiting the station
  - **Tip:** If going in the morning, it is recommended to get off at Lishui. Take Line S9 to "Mingjue Station." It is still nearly two kilometers from the station to the lake shore. There are many cars soliciting customers next to the metro station, and you can rent a car to get there; the Lishui side is front-lit in the morning, and the photography effect is relatively good
- **Self-driving:**
  - Directly search for "Shijiu Lake Grand Bridge" or "Xiangyang Village, Shiqi Subdistrict, Lishui District" in navigation
  - There is some parking area by the lake, but parking spaces are limited. It is recommended to arrive early
- **Bus:** Lishui Bus No. 22, Shuangpaishi-Zhujia, etc. can reach the lake shore area, but the specific schedules are few. Priority should be given to metro or self-driving
- **Tip:** Shijiu Lake is far from downtown Nanjing (about 60—80 kilometers). It is recommended to reserve sufficient time; it is windy by the lake and the sun exposure is strong. Please take windproof, warmth-keeping, and sun protection measures',
  '[{"icon": "🎫", "label": "Ticket", "value": "- **Ticket price:** Free admission\n- **Special note:** Shijiu Lake is a natural lake area and does not require ticket purchase; some surrounding farmhouses, fisherman''s homes, etc. may charge separately, subject to actual consumption\n- **Tip:** Shijiu Lake is suitable for self-driving or taking Metro Line S9. It is recommended to plan the transportation route in advance"}, {"icon": "🕘", "label": "Opening Hours", "value": "- **Opening hours:** Open 24 hours a day\n- **Best viewing time:**\n  - **Sunny daytime:** The lake surface is like a mirror, and the water and sky merge into one color, suitable for photography\n  - **At sunset (about 17:00—19:00, specifically varying by season):** The afterglow of the setting sun sprinkles on the lake surface, glittering with golden light, extremely spectacular\n  - **Clear nights:** There is relatively litle light pollution by the lake, suitable for stargazing\n- **Recommended visiting time:** 2—3 hours"}, {"icon": "🚇", "label": "Metro", "value": "- **Metro:**\n  - Take Metro Line S9 (operating hours about 6:00—22:00) to Tuanjiewei Station (Exit 1), then walk about 20—30 minutes or take a taxi to the lake shore after exiting the station\n  - Take Metro Line S9 to Mingjue Station (Exit 1), then walk about 1.5 kilometers or take a taxi to Shijiu Lake Grand Bridge after exiting the station\n  - **Tip:** If going in the morning, it is recommended to get off at Lishui. Take Line S9 to \"Mingjue Station.\" It is still nearly two kilometers from the station to the lake shore. There are many cars soliciting customers next to the metro station, and you can rent a car to get there; the Lishui side is front-lit in the morning, and the photography effect is relatively good\n- **Self-driving:**\n  - Directly search for \"Shijiu Lake Grand Bridge\" or \"Xiangyang Village, Shiqi Subdistrict, Lishui District\" in navigation\n  - There is some parking area by the lake, but parking spaces are limited. It is recommended to arrive early\n- **Bus:** Lishui Bus No. 22, Shuangpaishi-Zhujia, etc. can reach the lake shore area, but the specific schedules are few. Priority should be given to metro or self-driving\n- **Tip:** Shijiu Lake is far from downtown Nanjing (about 60—80 kilometers). It is recommended to reserve sufficient time; it is windy by the lake and the sun exposure is strong. Please take windproof, warmth-keeping, and sun protection measures"}]'::jsonb, '[]'::jsonb, '[]'::jsonb,
  'Shijiu Lake, Lishui District, Nanjing, Jiangsu Province (for specific viewing points, you can navigate to "Shijiu Lake Grand Bridge" or "Xiangyang Village, Shiqi Subdistrict, Lishui District")', '江苏省南京市溧水区石臼湖（具体观赏点可导航至"石臼湖特大桥"或"溧水区石湫街道向阳村"）',
  0, 'com.chinago.travel.attraction.nanjing_shijiu_lake', 11, TRUE
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
