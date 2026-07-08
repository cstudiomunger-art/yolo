-- Generated content batch upsert

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_beihai_park_bj_sa_01', 'beijing_beihai_park', 'South Gate & Circular City', '南门与团城',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_beihai_park_bj_sa_01.jpg', '<p>The South Gate is the principal entrance to Beihai Park, framed by a spacious plaza and towering ancient trees that immediately convey a regal atmosphere. Just inside the gate lies the Circular City (Tuancheng), a round platform first built in the Jin dynasty and expanded under the Yuan. Though barely four thousand square metres, it packs extraordinary architectural and cultural value. The Chengguang Hall on the platform houses a white jade Buddha carved from a single block of jade in the Yuan dynasty, and the Jade Urn Pavilion before it displays the Dushan Great Jade Sea, a wine vessel from Kublai Khan''s reign—both national treasures. Ancient pines ring the platform, whose grey-brick walls are a rare military-architectural remnant within a garden; climbing up affords a panoramic view of the entire Beihai lake and park.</p>', 0, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_beihai_park_bj_sa_02', 'beijing_beihai_park', 'Yong''an Bridge', '永安桥',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_beihai_park_bj_sa_02.jpg', '<p>Yong''an Bridge, first built in the Yuan dynasty and rebuilt in the Qing, is the park''s most iconic bridge. Over forty metres long and nearly nine metres wide, it features three graceful arches constructed entirely of white marble; the balustrade posts are carved with lotus-petal motifs, and the deck arches gently like a rainbow. The south end connects the Circular City, while the north end leads directly into the mountain gate of Yong''an Temple on Jade Flower Island—both a practical crossing and a superb viewing platform. Standing on the bridge, one looks south to ancient pines on Tuancheng, north to the towering White Dagoba, and east and west across rippling lotus-dotted waters—the quintessential Beihai composition. After snowfall the white-marble bridge merges with the snow into a fairyland, earning the phrase "Yong''an Snow Clearing."</p>', 1, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_beihai_park_bj_sa_03', 'beijing_beihai_park', 'Jade Flower Island · Yong''an Temple & White Dagoba', '琼华岛·永安寺与白塔',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_beihai_park_bj_sa_03.png', '<p>Jade Flower Island is the lake-centred hill and the park''s highest point and visual anchor. Yong''an Temple on the island was founded in 1651 (Shunzhi 8) and expanded under Qianlong, ascending the slope in layered courtyards—from the Falun Hall at the mountain gate to the Zhengjue Hall above, the halls are solemn and incense has burned here for centuries. The White Dagoba at the summit stands 35.9 metres tall in Tibetan stupa form; its gleaming white body is crowned by a bronze canopy and gilded sun-and-moon finials that flash in sunlight. It was first erected to welcome the Fifth Dalai Lama to Beijing, bearing both political and religious significance. From the top, sweeping views capture the Forbidden City''s red walls and yellow roofs, the entire central axis, and the Western Hills—one of the most magnificent urban panoramas in Beijing.</p>', 2, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_beihai_park_bj_sa_04', 'beijing_beihai_park', 'Jade Flower Island · Qiong Island Spring Shade Stele & Yuegu Tower', '琼华岛·琼岛春阴碑与阅古楼',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_beihai_park_bj_sa_04.jpg', '<p>The Qiong Island Spring Shade Stele stands on the mid-slope of Jade Flower Island''s east side. Its tall shaft bears four characters "Qiong Island Spring Shade" in Emperor Qianlong''s own hand, with his poem on the reverse. This scene originates from the "Eight Views of Yanjing" of the Jin dynasty, depicting the island''s dappled tree shadows and veiling mists in spring—the oldest landscape-aesthetic tradition in Beijing. Ancient trees cast deep shade around the stele, and in spring blooming crabapples and flowering peaches echo the inscription''s mood. Yuegu Tower, on the island''s northwest side, is a semi-circular two-storey pavilion built under Qianlong to house the Three Rarities Hall Model Calligraphy (Sanxitang Fatie) in stone. The collection gathers works by over 340 master calligraphers from Wei-Jin to late Ming, carved on 495 stone tablets—the largest engraved calligraphy anthology in Chinese history, a true treasury of brush and ink.</p>', 3, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_beihai_park_bj_sa_05', 'beijing_beihai_park', 'Jade Flower Island · Yilan Hall, Daoning Studio & Bronze Immortal Holding Dew Plate', '琼华岛·漪澜堂、道宁斋与铜仙承露盘',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_beihai_park_bj_sa_05.jpg', '<p>Yilan Hall and Daoning Studio sit on Jade Flower Island''s north slope directly above the lake, forming the island''s most important palatial complex. Yilan Hall, five bays wide with a waterfront veranda, was where Emperor Qianlong often reviewed memorials and enjoyed the scenery over tea; Daoning Studio was his study, its name meaning "the Way lies in tranquillity"—quiet and refined. Both halls imitate Jiangnan garden style, blending imperial scale with literati sensibility. Behind them, on a higher terrace, stands the Bronze Immortal Holding a Dew Plate—a copper figure with both hands raised holding a plate, mounted on a stone column, replicating the Han-dynasty Jianzhang Palace dew-receiver. Legend says Emperor Wu of Han used such a figure to gather heavenly dew for elixirs; Qianlong recast it as a symbol of communion between heaven and man, receiving divine grace. The figure is fully gilded, blazing in sunlight, and is Beihai''s most mystically charged landmark.</p>', 4, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_beihai_park_bj_sa_06', 'beijing_beihai_park', 'East Shore · Haopu Retreat & Painted Boat Studio', '东岸·濠濮间与画舫斋',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_beihai_park_bj_sa_06.jpg', '<p>Haopu Retreat lies mid-way along Beihai''s east shore—an exquisitely crafted enclosed water courtyard. A winding path leads through artificial rockwork and a festooned gate before revealing a pool ringed by corridors, a tiny stone bridge at its centre, and the Haopu plaque in Qianlong''s calligraphy. "Haopu" references Zhuangzi''s debate on the Hao Bridge and his fishing by the Pu River, evoking detachment and fish-happy self-sufficiency. Remote from palatial noise, this is the garden''s most literati-hermitic corner. The Painted Boat Studio (Huafang Zhai) sits just north of Haopu, its main building shaped like a boat moored on water, yet its interior follows a scholar''s layout—the front room named "Spring Rain on the Pond," the rear "Observing Wonder." Qianlong often read and composed poetry here. Winding corridors outside, draped in old vines, bring cool lotus-scented breezes in summer—an ideal retreat from heat.</p>', 5, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_beihai_park_bj_sa_07', 'beijing_beihai_park', 'Jingxin Studio (Quiet Heart Studio)', '静心斋',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_beihai_park_bj_sa_07.jpg', '<p>Jingxin Studio occupies the northwest corner of Beihai''s north shore. Founded in 1757 (Qianlong 22) as "Jingqing Studio" and later renamed, it was the emperor''s personal reading-and-resting retreat, modelled on Jiangnan private gardens. Though only about eight thousand square metres, it contains rockwork hills, winding pools, cloistered corridors, pavilions, tiny bridges and flowing water—every garden element packed into a "small yet vast" masterclass. The Qinquan Corridor spans the water; Diedie Tower crowns the artificial hill; the Bake-Tea Hut and String-Music Studio scatter among rich spatial layers. Taihu limestone crags are jagged and varied, their caves deep, shifting vistas with every step. Empress Dowager Cixi summered and governed here; Yuan Shikai used it for diplomatic talks—proof that this garden''s magic has enchanted every era.</p>', 6, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_beihai_park_bj_sa_08', 'beijing_beihai_park', 'Western Heavenly Paradise & Nine-Dragon Wall', '西天梵境与九龙壁',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_beihai_park_bj_sa_08.jpg', '<p>Western Heavenly Paradise (also called Great Western Heaven) sits mid-section of Beihai''s north shore. Founded in the Ming and rebuilt in the Qing, it served as the imperial family''s private Buddhist temple. The Mahavira Hall inside enshrines the Three Buddhas; the stone pillars and incense burners before it are Qing masterworks. The hall''s yellow-glazed tiles with green trim denote a rank just below the palace itself. Behind the temple once stood a grand stupa courtyard, now partially lost yet still hinting at its former majesty. The Nine-Dragon Wall stands immediately east of the temple, built in 1756 (Qianlong 21). It measures 25.86 m long, 6.65 m high, and 1.42 m thick, with nine glazed dragons on each face—18 in total—in yellow, green, blue, purple and white. Each dragon poses differently, leaping through cloud-seas and wave-crests. This is the best-preserved and most skillfully crafted of China''s three surviving double-sided Nine-Dragon Walls; every scale is delineated, every whisker flies—a supreme achievement of Qing glazed-tile art.</p>', 7, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_beihai_park_bj_sa_09', 'beijing_beihai_park', 'Kuai Xue Tang (Quick Snow Hall) & Iron Shadow Wall', '快雪堂与铁影壁',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_beihai_park_bj_sa_09.jpg', '<p>Kuai Xue Tang sits on Beihai''s north shore between Western Heavenly Paradise and Chanfu Temple, founded in 1779 (Qianlong 44). Obsessed with Wang Xizhi''s brushwork, the emperor ordered this hall built in pine-wood Jiangnan style to house engraved reproductions of the "Quick Snow Clearing" letter and other master calligraphy rubbings in stone. Fine nanmu woodwork graces the interior; the courtyard is open and airy—an imperial building that radiates literati refinement, another bastion of calligraphy culture in the park. The Iron Shadow Wall, a Yuan-dynasty relic originally at Desheng Gate, was later moved here. Carved from volcanic rock (locally called "iron stone"), it is so hard it earned the name "Iron Shadow Wall." Relief carvings of lions and rhinoceroses on its faces are bold and archaic, preserving the rugged vigour of Yuan sculpture—one of Beijing''s few surviving Yuan stone-carving artefacts. Its stark power contrasts vividly with Kuai Xue Tang''s delicate grace—one martial, one literary, mirroring each other across time.</p>', 8, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_beihai_park_bj_sa_10', 'beijing_beihai_park', 'Chanfu Temple & Little Western Heaven', '阐福寺与小西天',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_beihai_park_bj_sa_10.jpg', '<p>Chanfu Temple stands on the west segment of Beihai''s north shore, founded in 1760 (Qianlong 25) as Emperor Qianlong''s votive offering for his mother''s longevity. The main hall spans seven bays under yellow glazed tiles—a lofty rank—and once housed a bronze Thousand-Armed Thousand-Eyed Avalokiteshvara, now lost. The bell tower, drum tower and mountain gate remain intact, still conveying the solemnity of an imperial Buddhist sanctuary. Little Western Heaven (Xiao Xitian) lies just north of Chanfu Temple, built in 1770 (Qianlong 35) for the empress dowager''s eightieth birthday, mimicking the South Sea Bodhisattva realm. Its central "Pure Land" square pavilion measures 52.23 m wide and 42.32 m deep—the largest square-pavilion structure in China. Inside, the four walls carry suspended sculptures of Avalokiteshvara rescuing sentient beings; five hundred arhats crossing the sea are vividly alive. Outside, multicoloured glazed tiles blaze against the lake light—a vision of staggering grandeur.</p>', 9, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_beihai_park_bj_sa_11', 'beijing_beihai_park', 'Five Dragon Pavilions', '五龙亭',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_beihai_park_bj_sa_11.jpg', '<p>The Five Dragon Pavilions jut into the lake from the mid-section of Beihai''s north shore, built under Ming Emperor Jiajing and rebuilt in the Qing. Five pavilions line up in a row extending into the water: the central one, Dragon-Blessing Pavilion (Longze), is largest; flanking it are Clear-Blessing (Chengxiang) and Nourishing-Fragrance (Zixiang), with two smaller outer pavilions beyond. Stone bridges link them, and the ensemble resembles five dragons floating on water—hence the name. The central pavilion is a double-eaved square structure under yellow glazed tiles (highest rank); the others step down in size under green tiles, creating a tiered, hierarchically clear waterside cluster. Dragons and phoenixes adorn the eaves; limitless blue waves spread below. Spring and autumn for lotus, winter for snow, mid-autumn for moonlight—every season offers a scene. Qing emperors and empresses often fished and moon-watched here; Empress Dowager Cixi especially loved mid-autumn banquets with lanterns—the most romantically evocative complex in Beihai.</p>', 10, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_ming_tombs_bj_sa_01', 'beijing_ming_tombs', 'Stone Archway and Great Red Gate', '石牌坊与大红门',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_ming_tombs_bj_sa_01.jpg', '<p>The Stone Archway, built in 1540 during the Jiajing reign, is a five-bay, six-pillar, eleven-roof stone structure made entirely of white marble. Measuring 28.86 meters wide and 14 meters high, it is the largest and best-preserved stone archway in China. Its beams are exquisitely carved with dragons, phoenixes, lions, and other auspicious motifs. The Great Red Gate, the main entrance to the mausoleum area, was built during the Yongle reign. It features a single-eave hipped roof with red walls and yellow tiles, connecting Mount Hu and Mount Long on either side to form a natural barrier. It is the first portal into the tomb complex and holds exceptional architectural and historical significance.</p>', 0, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_ming_tombs_bj_sa_02', 'beijing_ming_tombs', 'Stele Pavilion of Divine Merit and Sacred Way', '神功圣德碑亭与神路',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_ming_tombs_bj_sa_02.jpg', '<p>The Stele Pavilion of Divine Merit stands approximately one kilometer north of the Great Red Gate. Built in 1435 during the Xuande reign, it is a square structure with a double-eave gabled roof. Inside stands a giant stone stele 7.91 meters tall, with a dragon-carved top and an inscription composed by Emperor Renzong (Zhu Gaozhi) praising the military and civil achievements of Emperor Yongle (Zhu Di). Four marble ornamental columns, each about 10 meters tall and carved with coiled dragons and clouds, flank the pavilion''s corners. The Sacred Way extends southward for about seven kilometers, serving as the central processional road to all tombs. Lined with pines and cypresses and enclosed by stone walls, it forms the central axis of the Ming Tombs layout.</p>', 1, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_ming_tombs_bj_sa_03', 'beijing_ming_tombs', 'Stone Statues and Dragon and Phoenix Gate', '石像生群与棂星门',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_ming_tombs_bj_sa_03.jpg', '<p>The Stone Statues flank both sides of the Sacred Way, built between the Xuande and Zhengtong reigns. There are 36 figures in total: 24 stone animals (lions, xiezhi, camels, elephants, qilin, and horses, four of each, in alternating standing and kneeling postures) and 12 human figures (four nobles, four civil officials, and four military generals). Each statue is carved from a single massive stone block, with the tallest exceeding three meters. They represent the pinnacle of Ming imperial stone carving. The Dragon and Phoenix Gate (Lingxing Gate), also called the "Flame Archway," stands at the northern end of the statue group. It features three gates with six pillars topped by stone beasts and flame-shaped ornaments, symbolizing the passage of imperial souls to heaven.</p>', 2, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_ming_tombs_bj_sa_04', 'beijing_ming_tombs', 'Changling Tomb and Museum', '长陵与博物馆',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_ming_tombs_bj_sa_04.jpg', '<p>Changling is the largest, earliest, and best-preserved tomb among the Ming Tombs. Construction began in 1409 during the Yongle reign, housing Emperor Zhu Di (Yongle) and Empress Xu. The complex follows a rectangular-front-and-round-rear layout. The main hall, the Hall of Eminent Favor (Ling''en Dian), sits on a three-tiered white marble base with a double-eave hipped roof. It spans nine bays wide and five bays deep, covering 1,956 square meters. Thirty-two golden-thread nanmu pillars stand inside, with the four central columns measuring 1.17 meters in diameter and 14.3 meters in height—the largest existing nanmu pillars in China, still fragrant after over five centuries. The Changling Museum, housed within the hall, displays excavated artifacts, imperial garments, and architectural models.</p>', 3, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_ming_tombs_bj_sa_05', 'beijing_ming_tombs', 'Dingling Tomb and Underground Palace', '定陵与地宫',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_ming_tombs_bj_sa_05.png', '<p>Dingling is the joint burial tomb of Emperor Zhu Yijun (Wanli) and his two empresses, constructed between 1584 and 1590. It is the only archaeologically excavated tomb among the Ming Tombs. The underground palace was excavated between 1956 and 1958. Located 27 meters below ground, it consists of five stone chambers—front, middle, rear, left, and right—covering 1,195 square meters. The entire structure is built of stone arches without beams or columns, showcasing extraordinary craftsmanship. The rear chamber contains a white marble bed holding three vermillion-lacquered coffins and 26 wooden chests, yielding nearly 3,000 artifacts including the gold crown, phoenix crowns, dragon robes, and silk textiles of national-treasure status. The underground palace maintains a constant temperature of 18–20°C year-round.</p>', 4, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_ming_tombs_bj_sa_06', 'beijing_ming_tombs', 'Zhaoling Tomb', '昭陵',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_ming_tombs_bj_sa_06.jpg', '<p>Zhaoling is the joint burial tomb of Emperor Zhu Zaihou (Longqing) and his three empresses, construction beginning in 1572. It was the first tomb among the Ming Tombs to undergo large-scale restoration, allowing visitors to see the complete layout of a Ming imperial mausoleum. Its distinctive feature is the fully restored Hall of Eminent Favor and side halls. The complex follows Changling''s rectangular-and-round layout but features a unique drainage system—a retaining wall and water-discharge stone channel behind the main hall found nowhere else among the Ming Tombs. Emperor Longqing reigned only six years but initiated the "Longqing Accord," ushering in a brief Ming revival. The Zhaoling Museum displays reproduced imperial garments and sacrificial vessels.</p>', 5, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_ming_tombs_bj_sa_07', 'beijing_ming_tombs', 'Jingling, Kangling and Yongling Tombs', '景陵、康陵与永陵',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_ming_tombs_bj_sa_07.jpg', '<p>Jingling is the tomb of Emperor Zhu Zhanji (Xuande) and Empress Sun. Smaller in scale but compact in layout, its Hall of Eminent Favor employs a reduced-pillar technique to expand interior space—an innovation in Ming mausoleum architecture. Kangling, the tomb of Emperor Zhu Houzhao (Zhengde) and Empress Xia, is located at the westernmost end of the Ming Tombs, backed by Mount Jinling. Ancient pines create a serene environment, and Emperor Zhengde''s life was legendary. Yongling, the joint tomb of Emperor Zhu Houcong (Jiajing) and Empress Chen, took over a decade to build and is second only to Changling in scale. Its treasure-city wall reaches 240 meters in diameter, and its Soul Tower uses the finest materials, with bricks bearing inscriptions—the highest grade among the Ming Tombs. The three tombs are under conservation; some areas are open, allowing visitors to view the walls and towers from a distance.</p>', 6, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_ming_tombs_bj_sa_08', 'beijing_ming_tombs', 'Siling Tomb', '思陵',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_ming_tombs_bj_sa_08.jpg', '<p>Siling is the tomb of Emperor Zhu Youjian (Chongzhen), Empress Zhou, and Consort Tian. It is the smallest among the Ming Tombs. In 1644, when Li Zicheng''s forces captured Beijing, Emperor Chongzhen hanged himself at Coal Hill (Jingshan), marking the fall of the Ming Dynasty. After the Qing army entered Beijing, the Qing court reinterred Chongzhen here with imperial rites. Originally Consort Tian''s tomb, its scale is far smaller than the other twelve. Siling has no stele of divine merit, no stone statues, and no Soul Tower or treasure-city wall—only a simple round mound and a modest memorial hall, echoing the tragic fate of an emperor who was diligent yet lost his empire. Ancient cypresses create a solemn, melancholic atmosphere, making it a poignant place to reflect on the late Ming and a fitting conclusion to a Ming Tombs visit.</p>', 7, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_temple_of_heaven_bj_sa_01', 'beijing_temple_of_heaven', 'Circular Mound Altar', '圜丘坛',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_temple_of_heaven_bj_sa_01.png', '<p>The Circular Mound Altar is the core sacrificial structure in the southern part of the Temple of Heaven, first built in 1530 (Jiajing 9) and expanded in 1749 (Qianlong 14). It is a three-tiered open-air circular stone platform constructed entirely of white marble; the number of balustrade panels and steps on each tier is always nine or a multiple of nine—the supreme yang number symbolizing the highest authority of the Lord of Heaven. At the centre of the top tier lies a round "Heart of Heaven" stone; speaking from it, sound waves reflect from the surrounding balustrades and converge back, creating a startling amplification as if Heaven itself replies. Two concentric enclosure walls surround the altar—inner circular, outer square—echoing the ancient cosmology of "round heaven, square earth." At dawn on the winter solstice the emperor conducted the grand sacrifice, burning offerings and reading prayers with solemn reverence. Though roofless, the altar expresses awe and understanding of Heaven through pure geometry and number—the pinnacle of Chinese ritual architecture.</p>', 0, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_temple_of_heaven_bj_sa_02', 'beijing_temple_of_heaven', 'Imperial Vault of Heaven & Echo Wall', '皇穹宇与回音壁',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_temple_of_heaven_bj_sa_02.png', '<p>The Imperial Vault of Heaven stands north of the Circular Mound Altar, first built in 1530 (Jiajing 9) and rebuilt in 1752 (Qianlong 17). It is the hall where the tablet of the Lord of Heaven and ancestral spirit tablets were stored. A single-eaved circular structure with a conical roof under blue glazed tiles, it rises from a round stone platform—delicate and graceful, just 15.6 m in diameter yet displaying the sacred imagery of the celestial vault through perfect proportion and colour. The interior dome is beamless and columnless, supported entirely by intricate bracket sets—a masterwork of timber engineering. The circular enclosing wall outside is the celebrated Echo Wall—3.72 m high, 0.9 m thick, 195.2 m in circumference, with a triple-arched glazed doorway on each side. If two people stand at the rear of the east and west side halls and whisper against the wall, sound waves propagate along the smooth surface by successive reflection, and each hears the other clearly as though conversing across the wall—an acoustic analogue of optical reflection, a serendipitous masterpiece of ancient Chinese construction. The courtyard also contains "Three-Sound Stones"—clapping on them yields three echoes, adding further wonder.</p>', 1, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_temple_of_heaven_bj_sa_03', 'beijing_temple_of_heaven', 'Danbi Bridge (Sacred Way Bridge)', '丹陛桥',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_temple_of_heaven_bj_sa_03.png', '<p>Danbi Bridge is the most prominent passageway on the Temple of Heaven''s central axis, running from the Circular Mound Altar''s north gate to the Hall of Prayer''s south gate—about 360 m long and 28 m wide, paved in three parallel stone strips. The highest, central strip is the "Spirit Way," reserved for the tablet of the Lord of Heaven; the eastern strip is the "Imperial Way" for the emperor; the western is the "Princes'' Way" for nobles and ministers—strict hierarchy, no trespassing. The surface rises gradually from south to north, symbolizing step-by-step ascent from the human realm toward heaven; walking it truly induces a sense of looking up at the sky with reverent awe. Ancient cypress trees flank both sides, centuries old, canopying like umbrellas—solemnity enriched by verdant vitality. Though called a "bridge," it is actually an elevated road rising 4 m above ground; beneath it ran a passage for sacrificial animals—a clever design. The entire sacred way, like a dragon''s spine running north-south, binds the Circular Mound Altar and the Hall of Prayer into one ritual whole, the core axis of the Temple of Heaven''s ceremonial space.</p>', 2, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_temple_of_heaven_bj_sa_04', 'beijing_temple_of_heaven', 'Hall of Prayer for Good Harvests', '祈年殿',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_temple_of_heaven_bj_sa_04.png', '<p>The Hall of Prayer for Good Harvests is the main hall in the northern part of the Temple of Heaven and its visual soul. First built in 1420 (Yongle 18) as "Great Sacrifice Hall," renamed "Great Offering Hall" under Jiajing, and given its present name in 1751 (Qianlong 16). It is a triple-eaved circular structure with a conical roof under blue glazed tiles, standing on a three-tiered white-marble circular platform—about 38 m high and 32 m in diameter. The interior is a structural marvel: 28 nanmu columns carry the dome without beams or nails, relying on mortise-and-tenon joints and bracket sets rising tier by tier. The inner ring of four "Dragon Well" columns symbolizes the four seasons; the middle ring of twelve "Golden" columns symbolizes the twelve months; the outer ring of twelve "Eave" columns symbolizes the twelve double-hours; the total of 28 implicitly echoes the twenty-four solar terms—space is time, building is cosmos. At the centre stands the tablet of the Lord of Heaven; on the first sin day of the first lunar month the emperor held the Praying-for-Harvest ceremony here, beseeching abundant crops. With its perfect circle, blue dome and ingenious structure, the Hall has become the symbol of Chinese ancient architecture and one of the most recognizable Chinese images among World Heritage sites.</p>', 3, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_temple_of_heaven_bj_sa_05', 'beijing_temple_of_heaven', 'North Gate', '北门',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_temple_of_heaven_bj_sa_05.png', '<p>The North Gate sits on the park''s north side, one of the main access points for the Hall of Prayer precinct. Its classical style features red walls and grey tiles; outside, ancient cypresses tower, their shade dense, seamlessly extending the park''s landscape. Positioned close to the Hall of Prayer, exiting here after visiting the Hall is most convenient—no need to retrace southward. The path outside continues through a cypress grove, the air fragrant with pine and cedar; in spring blooming locust trees scent the whole approach. Walking east about 10 minutes from the gate reaches Subway Line 5''s Tiantan East Gate station; west about 15 minutes reaches Qianmen Street and Tiananmen Square—prime positioning for connecting to other central-axis landmarks. Though less bustling than the East or West Gates, its quiet antiquity underscores the Temple''s solemn character, a perfect finale to the visit.</p>', 4, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_prince_gong_mansion_bj_sa_01', 'beijing_prince_gong_mansion', 'Palace Gate', '宫门',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_prince_gong_mansion_bj_sa_01.jpg', '<p>The Palace Gate is the formal entrance to Prince Gong''s Mansion, built in the mid-to-late Qing Dynasty. It spans three bays with a gable-and-hip roof covered in green glazed tiles, and its door nails are arranged in nine vertical and seven horizontal rows, conforming to the specifications for a prince of the first rank. A pair of stone lions once stood guard before the gate, symbolizing the nobility of the residence. Flanking the gate are screen walls with exquisite brick carvings featuring auspicious patterns. Stepping through the Palace Gate, visitors enter the grand compound that witnessed the rise and fall of Heshen and Prince Gong Yixin across multiple reigns, feeling the weight of history that has accumulated over more than two centuries.</p>', 0, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_prince_gong_mansion_bj_sa_02', 'beijing_prince_gong_mansion', 'Yin''an Hall and Jiale Hall', '银安殿与嘉乐堂',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_prince_gong_mansion_bj_sa_02.jpg', '<p>Yin''an Hall is the architectural centerpiece of the mansion''s central axis, serving as the venue for the prince''s administrative affairs, receptions, and major ceremonies. It spans seven bays with a green-tiled gable-and-hip roof, and its spacious front platform ranks just below the Hall of Supreme Harmony in the imperial palace. The interior was once luxuriously furnished. Behind it stands Jiale Hall, an important living and banqueting space whose name evokes "virtuous words and harmonious joy." Jiale Hall once housed a vast collection of precious antiques, calligraphy, and paintings, making it the cultural heart of the mansion. The two halls form the most solemn architectural sequence on the central axis, reflecting the classic Qing Dynasty princely layout of "front hall, rear quarters."</p>', 1, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_prince_gong_mansion_bj_sa_03', 'beijing_prince_gong_mansion', 'Baoguang Chamber and Xijin Studio', '葆光室与锡晋斋',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_prince_gong_mansion_bj_sa_03.jpg', '<p>Baoguang Chamber, located in the western compound, takes its name from the Zhuangzi concept of "harbored light," symbolizing restraint and inner brilliance. It served as a space for quiet study and meditation, with elegant interior decorations and exquisitely carved wooden partitions. Xijin Studio is one of the most legendary buildings in the mansion, said to have been built by Heshen in imitation of the Palace of Tranquil Longevity in the Forbidden City. Its interior features a golden-thread nanmu wood mezzanine with fully carved surfaces of extraordinary luxury, which later became one of the charges against Heshen for overstepping his rank. Prince Gong Yixin subsequently stored Lu Ji''s famous "Pingfu Tie" calligraphy scroll here, giving the studio its name. Together, the two buildings—one serene, one opulent—reveal the dual character of scholarly refinement and powerful grandeur that defines the mansion.</p>', 2, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_prince_gong_mansion_bj_sa_04', 'beijing_prince_gong_mansion', 'Rear Cover Building', '后罩楼',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_prince_gong_mansion_bj_sa_04.jpg', '<p>The Rear Cover Building is one of the most striking structures in Prince Gong''s Mansion. Stretching approximately 180 meters from east to west with over forty rooms on two levels, it spans the entire northern boundary of the residence like a barrier separating the living quarters from the garden behind. Legend holds that this was Heshen''s treasure house, with hidden compartments and niches in each room storing gold, silver, jewels, and precious artifacts. When Heshen was arrested, the wealth confiscated from this building was staggering, giving rise to the popular saying "When Heshen falls, Jiaqing is full." The building features massive walls and windows of varied shapes—some square, some round—serving both decorative and practical purposes of ventilation and security. Walking beneath it and gazing up at the continuous facade, one can almost feel the overwhelming ambition of the once all-powerful Heshen.</p>', 3, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_prince_gong_mansion_bj_sa_05', 'beijing_prince_gong_mansion', 'Western-Style Gate and Dule Peak', '西洋门与独乐峰',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_prince_gong_mansion_bj_sa_05.png', '<p>The Western-Style Gate is the main entrance to Cuijin Garden, the garden of Prince Gong''s Mansion. Constructed from carved white marble, its arch combines Baroque-style elements with traditional Chinese decorative motifs—an extraordinary rarity among Qing Dynasty princely residences, said to reflect Heshen''s fondness for exotic Western aesthetics. The gate''s lintel bears four characters reading "Tranquility Harbors Antiquity," evoking a timeless serenity. Just beyond the gate stands Dule Peak, a natural Taihu stone rising about five meters high with a craggy, dramatic form. From the front, it resembles a Guanyin bestowing children; from the back, a leaping carp. The name "Dule" means "enjoying solitude," suggesting a retreat where scholars savor the pleasures of nature alone. A pool beneath the stone creates delightful reflections, forming the garden''s first scenic vista that calms the spirit before one even enters.</p>', 4, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_prince_gong_mansion_bj_sa_06', 'beijing_prince_gong_mansion', 'Bat Pool and Anshan Hall', '蝠池与安善堂',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_prince_gong_mansion_bj_sa_06.jpg', '<p>Bat Pool is the central water feature of the mansion''s garden, named for its shape resembling a bat with outstretched wings. In Chinese culture, the word for bat (蝠) is homophonous with the word for fortune (福), making the bat a powerful symbol of blessings. Elms were originally planted along the pool, as the word for elm (榆) sounds like "surplus" (余), conveying wishes for abundance year after year. The pool''s clear waters reflect the sky and clouds in all seasons, while koi swim among the lily pads. To the north stands Anshan Hall, whose name means "dwelling in virtue," an elegant space for receiving guests, sipping tea, and composing poetry. With water before it and hill behind, the hall seamlessly integrates architecture and nature, embodying the supreme ideal of Chinese classical gardens—"though made by human hands, it seems born of nature itself."</p>', 5, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_prince_gong_mansion_bj_sa_07', 'beijing_prince_gong_mansion', 'Winding Cup Pavilion, Bamboo Courtyard, and Peony Garden', '流杯亭、竹子院与牡丹园',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_prince_gong_mansion_bj_sa_07.png', '<p>The Winding Cup Pavilion is the most literary and refined structure in the garden. Its stone floor is carved with a water channel shaped like the character for "longevity" (寿). Water flows through the channel, and wine cups float downstream—wherever a cup stops, the person before it drinks and composes a poem. This is the ancient elegant pastime of "winding stream party," originating from Wang Xizhi''s famous gathering at the Orchid Pavilion. The Bamboo Courtyard nearby is filled with tall bamboo creating a tranquil, secluded atmosphere; when the wind passes through the treetops, the rustling leaves transport visitors to a Jiangnan landscape. The Peony Garden cultivates numerous rare varieties of peonies. Every April and May, the flowers bloom in a spectacular display—golden Yao Yellow, purple Wei Purple, pink Zhao Pink, and green Dou Green—each vying in beauty and grandeur. The three sites progress from literary elegance to serene seclusion to brilliant splendor, each with its own distinct charm.</p>', 6, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_prince_gong_mansion_bj_sa_08', 'beijing_prince_gong_mansion', 'Yishen Chamber and Bat Hall', '怡神所与蝠厅',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_prince_gong_mansion_bj_sa_08.png', '<p>Yishen Chamber is a tranquil retreat for cultivating the spirit, nestled among towering ancient trees with deep shade and a serene atmosphere. Its name means "nourishing the mind and spirit," and it was the ideal place for the mansion''s master to rest in solitude and restore body and soul. Its architectural layout is ingeniously integrated with the surrounding landscape of rocks, water, and plants. Bat Hall is a uniquely shaped building whose floor plan resembles a bat with outstretched wings, hence its name. It echoes the Bat Pool, reinforcing the theme of "fortune" (蝠/福). The interior is finely decorated, and the painted beams and brackets are well preserved, making it an important example for the study of Qing Dynasty architectural ornamentation. Tucked away in the deepest part of the garden, the hall offers visitors a sense of sudden revelation—a magnificent finale to the garden tour.</p>', 7, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_prince_gong_mansion_bj_sa_09', 'beijing_prince_gong_mansion', 'Path to the Clouds, Moon-Inviting Terrace, Emerald Rock, and the "Fu" Stele', '平步青云路、邀月台、滴翠岩与福字碑',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_prince_gong_mansion_bj_sa_09.png', '<p>The Path to the Clouds is a stone-paved walkway built through layered rocks, winding upward with the auspicious meaning of "rising smoothly to the clouds," symbolizing a successful career and rising status. At the top lies the Moon-Inviting Terrace, named after Li Bai''s poem "I raise my cup to invite the moon," offering the finest spot for moon-viewing and panoramic vistas of the entire garden. Below the terrace stands Emerald Rock, a massive Taihu stone rockery with craggy surfaces draped in green vines and interior passages for exploration. Deep within the rockery lies the famous "Fu" (Fortune) stele, believed to be the handwritten calligraphy of Emperor Kangxi, executed with vigorous strokes and imposing grandeur. The character can be decomposed into four meanings—"many sons, many talents, many fields, and long life"—earning it the title "The Greatest Fortune Under Heaven." It is the treasure of Prince Gong''s Mansion and a must-visit pilgrimage site for those seeking blessings.</p>', 8, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_prince_gong_mansion_bj_sa_10', 'beijing_prince_gong_mansion', 'Square Pond Pavilion, Miaoxiang Pavilion, Dragon King Temple, and Archery Range', '方塘水榭、妙香亭、龙王庙与箭道',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_prince_gong_mansion_bj_sa_10.jpg', '<p>The Square Pond Pavilion is an exquisite structure built over the Square Pond, surrounded by water on three sides. The pond is planted with lotus flowers; in summer, lush leaves and fragrant blossoms fill the air, and the pavilion appears to float on the water—an ideal summer retreat. Miaoxiang Pavilion sits beside the pond, its name meaning "wondrous fragrance spreads afar." Surrounded by flowering trees and shrubs that bloom across all four seasons, it is a perfect spot for enjoying flowers and tea. The Dragon King Temple is a small shrine dedicated to the Dragon King, reflecting ancient beliefs in praying for rain and blessings. Though modest in size, it is complete in layout and rich in antiquity. The Archery Range is the martial practice ground of the mansion, with ancient trees lining a long, straight, open path, embodying the Manchu aristocratic tradition of valuing both letters and martial arts and the ancestral heritage of horsemanship and archery. Together, the four neighboring sites present a portrait of the diverse lifestyle within the princely mansion.</p>', 9, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_prince_gong_mansion_bj_sa_11', 'beijing_prince_gong_mansion', 'Ledao Hall and Duofu Pavilion', '乐道堂与多福轩',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_prince_gong_mansion_bj_sa_11.png', '<p>Ledao Hall was the living quarters of Prince Gong Yixin. Its name, meaning "finding joy in the Way," was personally inscribed by Yixin, expressing his commitment to Confucian moral ideals despite being embroiled in political turmoil. The hall retains elegant Qing Dynasty furnishings and scholar''s implements, with finely crafted window lattices and partitions, offering a precious glimpse into the daily life of a late Qing prince. Duofu Pavilion stands nearby, its name meaning "many sons, many blessings." It was the venue for family celebrations and the reception of inner-court relatives. The interior is hung with numerous plaques and couplets celebrating fortune and longevity, lavishly yet tastefully decorated, embodying wishes for a flourishing and enduring family. The two buildings—one emphasizing self-cultivation, the other family harmony—reflect different facets of Prince Gong Yixin''s spiritual world and domestic life.</p>', 10, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_mutianyu_great_wall_bj_sa_01', 'beijing_mutianyu_great_wall', 'Great Corner Tower', '大角楼',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_mutianyu_great_wall_bj_sa_01.png', '<p>The Great Corner Tower is the first watchtower on the eastern section of the Mutianyu Great Wall, perched on a ridge at approximately 600 meters elevation. It earned its name because three sections of the wall converge here at a sharp angle, forming a dramatic corner. Originally constructed during the Hongwu reign of the Ming Dynasty under the supervision of General Xu Da, it was later reinforced by renowned commanders Tan Lun and Qi Jiguang. The tower features a unique three-arch connected design, serving multiple functions including lookout, defense, and troop billeting. From its summit, visitors can gaze eastward to see the Jiankou Great Wall snaking like a dragon across the peaks, southward to view the Mutianyu pass in its entirety, and northward over verdant valleys. As a critical node in the Great Wall defense system, it commanded a strategically vital position and remains a precious physical relic for the study of Ming Dynasty frontier military engineering.</p>', 0, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_mutianyu_great_wall_bj_sa_02', 'beijing_mutianyu_great_wall', 'Zhengguantai Pass', '正关台',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_mutianyu_great_wall_bj_sa_02.jpg', '<p>Zhengguantai Pass is the core fortress of the Mutianyu Great Wall, composed of three hollow watchtowers connected side by side from east to west. This three-tower arrangement is extremely rare along the entire Great Wall and represents the most iconic architectural feature of the Mutianyu section. Built during the Yongle reign of the Ming Dynasty, the towers are interconnected at the ground level while each has its own crenellated upper level, capable of simultaneously housing hundreds of soldiers. The three towers rise at staggered heights—the central one tallest, flanked by two slightly lower ones—appearing from afar as three ramparts standing together in imposing grandeur. The walls extend east and west along the ridgeline from the pass, built on granite block foundations with blue brick superstructures approximately 7-8 meters high and 4 meters wide at the top, wide enough for five horses or ten soldiers abreast. Commanding the valley passage, Zhengguantai was a vital military pass guarding the northern gateway to the imperial capital and has witnessed centuries of martial history.</p>', 1, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_mutianyu_great_wall_bj_sa_03', 'beijing_mutianyu_great_wall', 'Tower No. 6 and Cable Car Station', '六号敌楼与缆车站',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_mutianyu_great_wall_bj_sa_03.png', '<p>Tower No. 6 is one of the most popular boarding points along the Mutianyu Great Wall, situated adjacent to the upper cable car station and serving as the starting point for most visitors'' wall exploration. The Mutianyu cable car spans approximately 700 meters with an elevation gain of about 400 meters, completing a one-way trip in just 4-5 minutes. It transports passengers from the mountain base directly to the vicinity of Tower No. 6, eliminating the strenuous hike and greatly enhancing accessibility. Tower No. 6 is a square hollow watchtower with a spacious interior and a sturdy vaulted ceiling. From its summit, visitors can survey the magnificent panorama of the entire Mutianyu Great Wall winding through the mountains. This is also one of the finest vantage points for photographing the wall—spring brings blooming wildflowers, summer clothes the slopes in vivid green, autumn paints the forests in fiery colors, and winter drapes everything in pristine white, offering breathtaking scenery in every season.</p>', 2, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_mutianyu_great_wall_bj_sa_04', 'beijing_mutianyu_great_wall', '"If You Are the One" Filming Location', '非诚勿扰取景地',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_mutianyu_great_wall_bj_sa_04.jpg', '<p>Mutianyu Great Wall gained an added layer of romance after serving as a filming location for the movie "If You Are the One II" (2010, directed by Feng Xiaogang). The iconic scene in which the characters played by Ge You and Shu Qi have their proposal moment on the Great Wall was shot between Towers No. 14 and 16 of the Mutianyu section. This stretch of wall sits at a high elevation with an open panorama—the wall unfurls along the ridgeline like a ribbon, with layered peaks rising on both sides in magnificent splendor. After the film''s release, this spot quickly became a popular destination for visitors, especially favored by couples and newlyweds. The scenic area has placed identification markers near the filming location for easy photo positioning. Strolling along this section, visitors can simultaneously feel the weight of history and relive the romance of the film—a unique experience that beautifully merges cultural heritage with popular culture at Mutianyu.</p>', 3, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_mutianyu_great_wall_bj_sa_05', 'beijing_mutianyu_great_wall', 'Chairman Mao Stone Inscription and Boundary Marker', '毛主席石刻与界碑',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_mutianyu_great_wall_bj_sa_05.png', '<p>The Chairman Mao Stone Inscription is located within the Mutianyu Great Wall scenic area, bearing the famous line from Mao Zedong''s poem "Clean Plain Melody: Liupan Mountain"—"He who has not reached the Great Wall is not a true man"—carved in vigorous, imposing calligraphy. This quote originated from Mao''s reflections during the Red Army''s crossing of Liupan Mountain on the Long March in 1935 and has since become a classic inspiration for countless visitors to climb the Great Wall. The stone regularly draws large crowds of tourists posing for photographs and has become one of the signature photo spots at Mutianyu. Nearby stands an administrative boundary marker for Huairou District, indicating the geographical location of the site. The boundary marker and the stone inscription stand side by side—one marking geographic coordinates, the other carrying spiritual significance. Here, visitors can confirm they stand on the soil of Huairou while feeling the bold spirit of being a "true man"—a special waypoint that combines both cultural and geographical meaning along the Great Wall.</p>', 4, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_mutianyu_great_wall_bj_sa_06', 'beijing_mutianyu_great_wall', 'Hero Slope', '好汉坡',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_mutianyu_great_wall_bj_sa_06.jpg', '<p>Hero Slope is the highest point of the Mutianyu Great Wall, located near Tower No. 20 at an elevation of approximately 540 meters. The terrain here is steep, with the wall climbing along the ridgeline and some steps angled at nearly seventy degrees, making the ascent quite strenuous—hence the name "Hero Slope," inspired by the saying "He who has not reached the Great Wall is not a true man." To reach the summit, visitors set out from Zhengguantai Pass or Tower No. 6, climbing along the wall past multiple watchtowers, a journey of about one to two hours. Upon reaching the top, the vista opens dramatically—mountains stretch as far as the eye can see, and the Great Wall unfurls like a colossal dragon over the peaks into the distance in breathtaking grandeur. This is also an ideal spot for watching sunrise and sunset. When the first rays of dawn or the golden glow of dusk bathes the wall and mountains, the scenery is truly awe-inspiring. Conquering Hero Slope is not merely a physical challenge but a spiritual experience, allowing one to truly appreciate the boldness and heroism embodied in the word "hero."</p>', 5, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_forbidden_city_bj_sa_01', 'beijing_forbidden_city', 'Meridian Gate and Golden Water Bridge', '午门与金水桥',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_forbidden_city_bj_sa_01.jpg', '<p>The Meridian Gate is the highest-ranking of the Forbidden City''s four gates and the principal southern portal. Five pavilions crown the gate tower, their layered heights and upturned eaves resembling a phoenix in flight, hence the name "Five-Phoenix Tower." The gate contains five passageways: the central portal reserved for the emperor, the lateral ones for princes and officials, and the side doors for daily traffic. In front, the Golden Water River curves like a drawn bow, spanned by five white marble bridges symbolizing the five Confucian virtues — benevolence, righteousness, propriety, wisdom, and trustworthiness. During the Ming and Qing dynasties, ceremonies such as the annual issuance of the imperial calendar and the presentation of war captives were staged here. The recessed U-shaped plan formed by the flanking gates and walls imparts a profound sense of awe to every visitor entering this threshold.</p>', 0, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_forbidden_city_bj_sa_02', 'beijing_forbidden_city', 'Gate of Supreme Harmony and East-West Wings of Outer Court', '太和门与外朝东西路',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_forbidden_city_bj_sa_02.png', '<p>The Gate of Supreme Harmony is the main entrance to the Three Great Halls of the Outer Court. Measuring nine bays wide and four bays deep, with a double-eaved hip roof, it spans over 1,300 square meters — the highest-ranking and largest palace gate in the Forbidden City, truly the "king of gates." Here Ming emperors held "gate-side audiences" at dawn, receiving officials and deliberating state affairs. In the square before the gate stand a pair of Ming-dynasty bronze lions: the male to the east with a paw resting on an embroidered ball, the female to the west caressing a cub — symbols of imperial majesty and dynastic continuity. Flanking the gate, the West Wing houses the Hall of Martial Valor (Wuying Dian), formerly an imperial study and book-compilation hall, while the East Wing contains the Hall of Literary Glory (Wenhua Dian), venue for imperial classical lectures. The colonnaded corridors and side halls lining the central axis once served as offices for the various ministries, forming the grand prelude to China''s largest wooden palatial complex.</p>', 1, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_forbidden_city_bj_sa_03', 'beijing_forbidden_city', 'Hall of Supreme Harmony', '太和殿',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_forbidden_city_bj_sa_03.png', '<p>The Hall of Supreme Harmony rises from a three-tiered white marble terrace, reaching a total height of 35.05 meters. Measuring eleven bays wide and five bays deep, its double-eaved hip roof with yellow glazed tiles and golden dragon painted decoration marks the highest architectural rank in the entire complex. Seventy-two massive nanmu columns support the sweeping roof; at the center, a seven-tier gilded throne platform bears a carved dragon throne, beneath a plaque reading "Jian Ji Sui You" (Establish the Ultimate and Follow the Way) in the Qianlong Emperor''s own calligraphy. Before the throne stand auspicious ornaments — treasure elephants, luduan mythical beasts, cranes, and incense pavilions — symbolizing eternal sovereignty and universal peace. The terrace features a sundial and a grain measure, signifying imperial mastery over time and standards. The vast square before the hall could accommodate 100,000 courtiers for grand audiences. On New Year''s Day, the winter solstice, the emperor''s birthday, and at enthronement and wedding ceremonies, bells and drums resounded amid resplendent honor guards, fully manifesting the majesty of the Son of Heaven.</p>', 2, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_forbidden_city_bj_sa_04', 'beijing_forbidden_city', 'Hall of Central Harmony and Hall of Preserving Harmony', '中和殿与保和殿',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_forbidden_city_bj_sa_04.jpg', '', 3, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_forbidden_city_bj_sa_05', 'beijing_forbidden_city', 'Three Rear Palaces: Palace of Heavenly Purity, Hall of Union, and Palace of Earthly Tranquility', '后三宫·乾清宫、交泰殿与坤宁宫',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_forbidden_city_bj_sa_05.jpg', '<p>The Palace of Heavenly Purity, the foremost of the Three Rear Palaces, measures nine bays wide and five bays deep with a double-eaved hip roof — a rank second only to the Hall of Supreme Harmony. From the Yongle reign of the Ming to the Kangxi reign of the Qing, it served as the emperor''s private quarters. Above the central throne hangs the Shunzhi Emperor''s calligraphy "Zheng Da Guang Ming" (Open and Aboveboard), behind which secret succession edicts were once stored, determining the imperial line. Bronze tortoises, cranes, a sundial, and a grain measure stand on the front terrace, echoing those at the Hall of Supreme Harmony. Passing northward through the palace, one arrives at the Hall of Union — a square, single-eaved building housing the plaque "Wu Wei" (Effortless Governance) and twenty-five imperial seals displayed in a row, embodying supreme sovereignty. At the northernmost end, the Palace of Earthly Tranquility, nine bays wide, was the Ming empress''s bedchamber. In the Qing dynasty, its eastern half was converted into the imperial wedding chamber, while the western half became a shamanic ritual hall — a unique fusion of Manchu religious tradition with Han palatial architecture, unmatched anywhere in the Forbidden City.</p>', 4, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_forbidden_city_bj_sa_06', 'beijing_forbidden_city', 'Hall of Mental Cultivation and Grand Council', '养心殿与军机处',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_forbidden_city_bj_sa_06.png', '<p>The Hall of Mental Cultivation, situated west of the Palace of Heavenly Purity, became the de facto center of daily governance and imperial residence from 1729. Its I-shaped layout comprises a front hall for audiences and document review, a rear bedchamber, and a connecting corridor. The front hall, with a throne at its center, features east and west warming chambers for confidential deliberations and rest. Most famously, the East Warm Chamber was the site of "governance behind the curtain" — from behind a gauze screen, Empress Dowagers Cixi and Ci''an controlled the late Qing empire for nearly half a century during the Tongzhi and Guangxu reigns. The hall bears the Yongzheng Emperor''s inscription "Zhong Zheng Ren He" (Justice, Uprightness, Benevolence, and Harmony). To the south of the hall lies the Grand Council, originally established by Yongzheng for swift handling of northwestern military affairs and later evolved into the Qing empire''s supreme decision-making body. A single edict from this modest office could marshal entire armies, profoundly shaping the course of modern Chinese history.</p>', 5, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_forbidden_city_bj_sa_07', 'beijing_forbidden_city', 'Six Eastern and Western Palaces', '东西六宫',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_forbidden_city_bj_sa_07.png', '<p>The Six Eastern and Six Western Palaces, arrayed on either side of the Three Rear Palaces, represent the twelve terrestrial branches and twelve double-hours of the cosmic order in Chinese cosmology. The eastern group encompasses Jingren, Chengqian, Zhongcui, Yanxi, Yonghe, and Jingyang Palaces; the western group includes Yongshou, Yikun, Chuxiu, Xianfu, Changchun, and Qixiang (Taiji) Palaces. Each is a two- or three-courtyard siheyuan compound, its main hall, side halls, annexes, covered corridors, and gate forming a self-contained yet interconnected living space. Among them, Chuxiu Palace is famed as the early residence of Empress Dowager Cixi; Chengqian Palace housed Consort Donggo, beloved of the Shunzhi Emperor; Yanxi Palace saw an unfinished attempt at Western-style reconstruction in the late Qing. Today, some compounds function as themed galleries displaying bronzes, ceramics, and jades that quietly speak of millennia of craftsmanship; others preserve original furnishings depicting daily life in the imperial household, offering visitors a rare glimpse into the authentic world behind the vermilion walls.</p>', 6, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_forbidden_city_bj_sa_08', 'beijing_forbidden_city', 'Palace of Compassion and Tranquility - Sculpture Gallery', '慈宁宫·雕塑馆',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_forbidden_city_bj_sa_08.png', '<p>The Palace of Compassion and Tranquility, built in 1536 west of Longzong Gate on the western route, was purpose-built as a retirement residence for empress dowagers and former consorts, the highest-ranking "women''s palace" in the Forbidden City. Empress Dowager Xiaozhuang, mother of the Shunzhi Emperor, spent her later years here, and Emperor Kangxi would hold grand birthday banquets for his grandmother in this very palace — a display of filial devotion celebrated throughout the realm. The palace features east and west gates, a seven-bay main hall with a double-eaved hip roof, and an ancient cypress-filled courtyard of solemn tranquility. Since 2015, the Great Buddha Hall and surrounding buildings to the east have been transformed into the Palace Museum Sculpture Gallery, showcasing over 400 precious sculptural artifacts ranging from Qin-dynasty terracotta warriors to Ming and Qing Buddhist statues. Monumental stone carvings stand in the courtyards, while pottery figurines, stone reliefs, and bronze Buddhist images line the exhibition halls chronologically, forming a three-dimensional history of Chinese sculpture. The adjacent Cining Garden preserves its original Qing landscaping, where ancient pavilions and flowering trees create the most serene retreat within the Forbidden City.</p>', 7, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_forbidden_city_bj_sa_09', 'beijing_forbidden_city', 'Hall of Ancestral Worship - Clock Gallery & Palace of Tranquil Longevity - Treasure Gallery', '奉先殿·钟表馆与宁寿宫·珍宝馆',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_forbidden_city_bj_sa_09.jpg', '', 8, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_forbidden_city_bj_sa_10', 'beijing_forbidden_city', 'Qianlong Garden and Imperial Garden', '乾隆花园与御花园',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_forbidden_city_bj_sa_10.jpg', '', 9, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_forbidden_city_bj_sa_11', 'beijing_forbidden_city', 'Gate of Divine Might, Corner Towers, and East-West Prosperity Gates', '神武门、角楼与东西华门',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_forbidden_city_bj_sa_11.jpg', '', 10, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_lama_temple_bj_sa_01', 'beijing_lama_temple', 'Archway Courtyard and Zhaotai Gate', '牌楼院与昭泰门',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_lama_temple_bj_sa_01.jpg', '', 0, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_lama_temple_bj_sa_02', 'beijing_lama_temple', 'Bell and Drum Towers and the Hall of the Heavenly Kings', '钟鼓楼与天王殿',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_lama_temple_bj_sa_02.png', '', 1, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_lama_temple_bj_sa_03', 'beijing_lama_temple', 'Stele Pavilion of "On Lamaism" and the Bronze Mount Sumeru', '喇嘛说碑亭与铜铸须弥山',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_lama_temple_bj_sa_03.png', '', 2, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_lama_temple_bj_sa_04', 'beijing_lama_temple', 'Yonghe Palace (Mahavira Hall)', '雍和宫殿·大雄宝殿',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_lama_temple_bj_sa_04.png', '', 3, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_lama_temple_bj_sa_05', 'beijing_lama_temple', 'Yongyou Hall', '永佑殿',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_lama_temple_bj_sa_05.png', '', 4, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_lama_temple_bj_sa_06', 'beijing_lama_temple', 'Four Monastic Colleges (Dratsang)', '四大扎仓',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_lama_temple_bj_sa_06.png', '', 5, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_lama_temple_bj_sa_07', 'beijing_lama_temple', 'Falun Hall (Wheel of the Law Hall)', '法轮殿',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_lama_temple_bj_sa_07.png', '', 6, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_lama_temple_bj_sa_08', 'beijing_lama_temple', 'Pavilion of Ten Thousand Blessings (Wanfu Pavilion)', '万福阁',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_lama_temple_bj_sa_08.png', '', 7, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_lama_temple_bj_sa_09', 'beijing_lama_temple', 'Guanyin Grotto and Suicheng Hall (Epilogue)', '观音洞与绥成殿（结束语）',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_lama_temple_bj_sa_09.png', '', 8, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_summer_palace_bj_sa_01', 'beijing_summer_palace', 'East Palace Gate and Hall of Benevolence and Longevity', '东宫门与仁寿殿',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_summer_palace_bj_sa_01.png', '<p>The East Palace Gate is the main entrance to the Summer Palace, built in 1750 during the Qianlong reign. Bronze lions, stone steps, and cloud-dragon carvings flank the entrance, and the gate bears a plaque reading "Yiheyuan" (Summer Palace), said to be calligraphed by Emperor Guangxu. Inside stands the Hall of Benevolence and Longevity (Renshou Dian), originally called the "Hall of Diligent Administration." Destroyed by Anglo-French forces in 1860 and rebuilt, Empress Dowager Cixi renamed it, drawing from the Confucian Analects: "the benevolent enjoy longevity." The hall contains a nine-dragon throne, screens, and enamel cranes and deer. It was the central venue where Cixi and Emperor Guangxu held audiences and conducted state affairs. Bronze dragons, phoenixes, tripods, and Taihu stones decorate the courtyard, flanked by symmetrically arranged side halls, projecting imperial authority within the garden.</p>', 0, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_summer_palace_bj_sa_02', 'beijing_summer_palace', 'Garden of Virtue and Harmony', '德和园',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_summer_palace_bj_sa_02.png', '<p>Built in 1891 and located northwest of the Hall of Benevolence and Longevity, the Garden of Virtue and Harmony (Dehe Yuan) was a garden-within-a-garden dedicated to opera performances for Empress Dowager Cixi, constructed at a cost of 710,000 taels of silver. Its centerpiece is the Grand Theater Building, 21 meters tall with three upturned eaves. The ground-floor stage spans 17 meters, and the three-tiered stage features mechanical devices for spectacular effects—deities ascending to heaven and demons descending underground. It is the largest and most ingeniously structured surviving imperial theater in China. Cixi was an avid Peking Opera enthusiast, staging performances for days during birthdays and festivals. The complex also includes a backstage dressing area and the Yile Hall (viewing hall), preserving Cixi''s opera-viewing throne and precious Peking Opera artifacts.</p>', 1, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_summer_palace_bj_sa_03', 'beijing_summer_palace', 'Hall of Jade Ripples and Hall of Joyful Longevity', '玉澜堂与乐寿堂',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_summer_palace_bj_sa_03.png', '<p>The Hall of Jade Ripples (Yulan Tang), on the northeastern shore of Kunming Lake, was originally built during the Qianlong reign as a resting place for the imperial family. After the failure of the 1898 Hundred Days'' Reform, Empress Dowager Cixi placed Emperor Guangxu under house arrest here. The east and west side rooms were sealed with brick walls to isolate him—traces of which remain visible today, making the hall a historical witness to a political tragedy in modern China. The Hall of Joyful Longevity (Leshou Tang), immediately west, was Cixi''s residential quarters in the Summer Palace. Its name means "the wise find joy, the benevolent enjoy longevity." The central room contains Cixi''s throne and an agarwood screen, where she received congratulations, dined, and took tea. Bronze deer, cranes, and vases in the courtyard symbolize universal peace, while magnolia, crabapple, and peony represent "wealth and honor in the jade hall."</p>', 2, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_summer_palace_bj_sa_04', 'beijing_summer_palace', 'Long Corridor', '长廊',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_summer_palace_bj_sa_04.png', '<p>Stretching from the Moon-Inviting Gate in the east to the Stone Old Man Pavilion in the west, the Long Corridor (Changlang) is 728 meters long with 273 bays. It is the longest and most richly painted garden corridor in China, earning a Guinness World Record in 1992. Originally built in 1750 during the Qianlong reign, it was destroyed by Anglo-French forces in 1860 and rebuilt during the Guangxu reign. Over 14,000 Suzhou-style paintings decorate the beams, depicting landscapes, flora and fauna, historical figures, classical literature scenes from "Journey to the West," "Romance of the Three Kingdoms," and "Dream of the Red Chamber," and folk legends—an open-air museum of Chinese traditional painting. The corridor runs between mountain and water with seasonal views. Four octagonal double-eave pavilions—Liujia, Jilan, Qiushui, and Qingyao—mark the four seasons along its length.</p>', 3, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_summer_palace_bj_sa_05', 'beijing_summer_palace', 'Hall of Dispelling Clouds, Tower of Buddhist Incense and Sea of Wisdom', '排云殿、佛香阁与智慧海',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_summer_palace_bj_sa_05.png', '<p>These three structures form the central complex ascending from south to north along Longevity Hill''s central axis. The Hall of Dispelling Clouds (Paiyun Dian) occupies the lower section. Originally the "Great Temple of Repaying Kindness and Extending Longevity," it was converted into a ceremonial hall by Cixi, named after a line by poet Guo Pu: "immortals emerge from the clouds, revealing halls of gold and silver." Its throne was used for Cixi''s birthday celebrations. The Tower of Buddhist Incense (Foxiang Ge) stands on a 21-meter stone platform mid-hill—a three-tiered, four-eave octagonal tower 36.44 meters tall, the iconic landmark of the Summer Palace. Inside is a Ming Dynasty bronze Thousand-Handed Guanyin, five meters tall. The Sea of Wisdom (Zhihui Hai) crowns the hilltop, a beamless hall built entirely of multicolored glazed tiles with embedded Buddha images, meaning "the Buddha''s wisdom is as vast as the sea." As the highest point, it offers panoramic views of Kunming Lake.</p>', 4, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_summer_palace_bj_sa_06', 'beijing_summer_palace', 'Marble Boat', '石舫',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_summer_palace_bj_sa_06.png', '<p>The Marble Boat (Qingyan Fang, "Boat of Purity and Peace") stands at the western end of the Long Corridor on the shore of Kunming Lake. Built in 1755 during the Qianlong reign, it is the largest surviving ancient stone boat-shaped garden structure in China. Carved entirely from massive stone blocks, it measures 36 meters long. The hull is made of grey stone, while the cabin was originally wood, combining Western stained-glass windows with a traditional Chinese gabled roof, reflecting the Qianlong era''s fusion of Chinese and Western aesthetics. According to legend, Emperor Qianlong drew on the classical admonition by Tang minister Wei Zheng—"water can carry a boat, but can also overturn it"—using the stone boat to symbolize the eternal, unshakeable stability of the Qing Empire. The cabin was burned by Anglo-French forces in 1860 and rebuilt in 1893 with its current marble patterns and decorative tiles. The Marble Boat is a visual focal point of the western lake area and a classic photo landmark.</p>', 5, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_summer_palace_bj_sa_07', 'beijing_summer_palace', 'Kunming Lake', '昆明湖',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_summer_palace_bj_sa_07.png', '<p>Kunming Lake is the core water body of the Summer Palace, covering 220 hectares—three-quarters of the total park area—and is the largest artificial lake in Beijing. Fed by springs from Yuquan Mountain and Wengshan Lake, it was dredged and expanded in 1750. Emperor Qianlong named it after the Kunming Pool that Emperor Wu of Han dug in Chang''an to train his navy. With Longevity Hill as its backdrop, the lake is divided into three zones: East Lake, West Lake, and North Lake. The West Causeway with its six bridges imitates the Su Causeway of West Lake in Hangzhou, lined with peach and willow trees, evoking the misty charm of Jiangnan. The lake shimmers in every season—lotus blooms in summer, reeds sway in winter. Visitors can take painted boats to cruise the lake and experience the grandeur of the imperial garden from the water.</p>', 6, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_summer_palace_bj_sa_08', 'beijing_summer_palace', 'Seventeen-Arch Bridge and South Lake Island', '十七孔桥与南湖岛',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_summer_palace_bj_sa_08.png', '<p>The Seventeen-Arch Bridge spans from the East Causeway to South Lake Island on Kunming Lake, built during the Qianlong reign (1736–1795). It is 150 meters long and 8 meters wide, with 17 arches. The arch count derives from the number nine—the supreme yang number—with nine arches on each side of the central arch, symbolizing imperial supremacy. The bridge is built of white marble, and its railings are carved with 544 stone lions in diverse postures—more than the Marco Polo Bridge—each vividly rendered. Stele pavilions and a bronze ox stand at the east and west ends. South Lake Island, at the center of Kunming Lake, symbolizes Penglai, the immortal isle of Eastern Sea legend. Buildings on the island include the Hanxu Hall and Dragon King Temple, where the imperial family viewed the lake and worshipped the Dragon King. Around the winter solstice, the setting sun shines through the bridge arches, creating the spectacular "Golden Light through the Arches" phenomenon that draws countless visitors and photographers.</p>', 7, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_summer_palace_bj_sa_09', 'beijing_summer_palace', 'Bronze Ox', '铜牛',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_summer_palace_bj_sa_09.png', '<p>The Bronze Ox stands on the eastern shore of Kunming Lake, north of the Seventeen-Arch Bridge. Cast in 1755 during the Qianlong reign, it is a reclining bronze ox measuring 1.75 meters long, 0.8 meters wide, and 1.15 meters high. It lies on a stone base with head raised, lifelike and masterfully crafted. An 80-character inscription in seal script, the "Golden Ox Inscription" composed by Emperor Qianlong, is carved on its back, recording the reason for casting and the emperor''s prayers. It follows the ancient tradition of using iron oxen to suppress floods. Qianlong compared Kunming Lake to the Milky Way and the bronze ox to the Altair star, expressing his wish for favorable weather and a peaceful realm. The ox complements Longevity Hill and Kunming Lake, serving as both a guardian spirit of the imperial garden and an important witness to Chinese hydraulic culture.</p>', 8, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_summer_palace_bj_sa_10', 'beijing_summer_palace', 'Newly Built Palace Gate (Concluding Remarks)', '新建宫门',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/beijing_summer_palace_bj_sa_10.png', '<p>The Newly Built Palace Gate (Xinjiangongmen) is the South Gate of the Summer Palace, constructed during the Guangxu reign. It was named for being built later than the East Palace Gate and other entrances. The gate has three bays with a gabled roof and front and rear corridors. Though less grand than the East Palace Gate, its open foreground offers one of the best vantage points for viewing Kunming Lake and the Seventeen-Arch Bridge. It is a key portal for the circular lake tour: heading north along the East Causeway leads to the Bronze Ox, Seventeen-Arch Bridge, and South Lake Island, while heading west along the West Causeway''s six bridges evokes the scenery of Hangzhou''s West Lake. Arriving here, looking back at the tiered pavilions of the Tower of Buddhist Incense on Longevity Hill and the vast expanse of Kunming Lake, the magnificent synthesis of garden art is fully revealed. As the final stop, this gate is not merely an entrance or exit, but a fond farewell to centuries of history and culture.</p>', 9, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=EXCLUDED.cover_image_path,
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'shanghai_museum_sa_01', 'shanghai_museum', '', '中国历代书法馆',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/shanghai_museum_sa_01.png', '', 0, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'shanghai_museum_sa_02', 'shanghai_museum', '', '中国历代玺印馆',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/shanghai_museum_sa_02.png', '', 1, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'shanghai_museum_sa_03', 'shanghai_museum', '', '中国历代绘画馆',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/shanghai_museum_sa_03.png', '', 2, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'shanghai_museum_sa_04', 'shanghai_museum', '', '中国历代钱币馆',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/shanghai_museum_sa_04.png', '', 3, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'shanghai_museum_sa_05', 'shanghai_museum', '', '中国古代玉器馆',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/shanghai_museum_sa_05.png', '', 4, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'shanghai_museum_sa_06', 'shanghai_museum', '', '中国古代陶瓷馆',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/shanghai_museum_sa_06.png', '', 5, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'shanghai_museum_sa_07', 'shanghai_museum', '', '中国古代雕塑馆',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/shanghai_museum_sa_07.png', '', 6, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'shanghai_museum_sa_08', 'shanghai_museum', '', '中国古代青铜馆',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/shanghai_museum_sa_08.png', '', 7, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'shanghai_museum_sa_09', 'shanghai_museum', '', '中国明清家具馆',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/shanghai_museum_sa_09.png', '', 8, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'shanghai_museum_sa_10', 'shanghai_museum', '', '解说词-中国少数民族工艺馆',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/shanghai_museum_sa_10.png', '', 9, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'the_bund_shanghai_sa_01', 'the_bund_shanghai', '上海市人民英雄纪念塔 / Shanghai People''s Heroes Memorial Tower', '上海市人民英雄纪念塔 / Shanghai People''s Heroes Memorial Tower',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/the_bund_shanghai_sa_01.png', '', 0, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'the_bund_shanghai_sa_02', 'the_bund_shanghai', '上海总会（华尔道夫酒店） / Shanghai Club (Waldorf Astoria Shanghai on the Bund)', '上海总会（华尔道夫酒店） / Shanghai Club (Waldorf Astoria Shanghai on the Bund)',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/the_bund_shanghai_sa_02.png', '', 1, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'the_bund_shanghai_sa_03', 'the_bund_shanghai', '亚细亚大楼（外滩一号） / Asia Building (Bund No. 1)', '亚细亚大楼（外滩一号） / Asia Building (Bund No. 1)',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/the_bund_shanghai_sa_03.png', '', 2, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'the_bund_shanghai_sa_04', 'the_bund_shanghai', '十六铺码头 / Shiliupu Wharf', '十六铺码头 / Shiliupu Wharf',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/the_bund_shanghai_sa_04.png', '', 3, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'the_bund_shanghai_sa_05', 'the_bund_shanghai', '原汇丰银行大楼 / Former HSBC Building', '原汇丰银行大楼 / Former HSBC Building',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/the_bund_shanghai_sa_05.png', '', 4, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'the_bund_shanghai_sa_06', 'the_bund_shanghai', '和平饭店 / Peace Hotel (Fairmont Peace Hotel)', '和平饭店 / Peace Hotel (Fairmont Peace Hotel)',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/the_bund_shanghai_sa_06.png', '<p>和平饭店位于中山东一路20号，由英籍犹太商人维克多·沙逊（Sir Victor Sassoon）投资，公和洋行设计，建成于1929年，原名沙逊大厦，曾为"远东第一高楼"。建筑为装饰艺术风格，高十层，外立面以花岗岩贴面，顶部冠以标志性的绿色铜金字塔尖顶，在阳光下格外醒目。大楼内设华懋饭店（Cathay Hotel），曾是20世纪上半叶远东最顶级的酒店，卓别林、萧伯纳等名流曾下榻于此。1952年更名为和平饭店，2007年至2010年完成大规模修缮，现由费尔蒙酒店集团管理运营，拥有标志性的茉莉酒廊与九国特色套房。</p>', 5, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'the_bund_shanghai_sa_07', 'the_bund_shanghai', '外滩十八号 / Bund 18', '外滩十八号 / Bund 18',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/the_bund_shanghai_sa_07.png', '', 6, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'the_bund_shanghai_sa_08', 'the_bund_shanghai', '外滩源 / The Origin of the Bund (Waitanyuan)', '外滩源 / The Origin of the Bund (Waitanyuan)',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/the_bund_shanghai_sa_08.png', '', 7, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'the_bund_shanghai_sa_09', 'the_bund_shanghai', '外滩牛 / Bund Bull (Shanghai Financial Bull)', '外滩牛 / Bund Bull (Shanghai Financial Bull)',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/the_bund_shanghai_sa_09.png', '<p>外滩牛位于中山东一路福州路口的外滩金融广场，由意大利裔美籍艺术家阿图罗·迪·莫迪卡（Arturo Di Modica）创作，于2010年上海世博会期间正式揭幕。迪莫迪卡正是纽约华尔街铜牛的原作者，因此外滩牛与华尔街铜牛为"姊妹之作"。铜像采用铸铜工艺，通体呈暗红色，重约2.5吨，体量略大于华尔街铜牛。公牛呈低头蓄力、昂首挺角之姿，肌肉线条饱满，充满向前冲击的力量感，寓意"牛市"繁荣与上海金融市场的稳健发展。雕塑落成后迅速成为外滩热门打卡地标，游客常以触摸牛角祈求财运。</p>', 8, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'the_bund_shanghai_sa_10', 'the_bund_shanghai', '外白渡桥 / Waibaidu Bridge (Garden Bridge of Shanghai)', '外白渡桥 / Waibaidu Bridge (Garden Bridge of Shanghai)',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/the_bund_shanghai_sa_10.png', '', 9, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'the_bund_shanghai_sa_11', 'the_bund_shanghai', '海关大楼 / Customs House (Shanghai)', '海关大楼 / Customs House (Shanghai)',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/the_bund_shanghai_sa_11.png', '<p>上海海关大楼位于中山东一路13号，由公和洋行设计，于1927年重建完工，是外滩万国建筑群中辨识度最高的建筑之一。大楼高八层，正立面采用希腊新古典主义风格，底部以多立克柱廊支撑，整体庄重大气。最瞩目的是顶部的钟楼——高耸的方形塔楼上嵌有四面大钟，大钟仿照英国伦敦国会大厦大本钟的式样制造，由英国Joyce &amp; Co.钟厂铸造，每十五分钟报时一次，浑厚的钟声曾响彻黄浦江两岸，被称为"亚洲第一钟"。大楼至今仍为上海海关办公使用，是外滩"万国建筑博览会"的灵魂坐标。</p>', 10, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'the_bund_shanghai_sa_12', 'the_bund_shanghai', '陈毅广场与陈毅铜像 / Chen Yi Square and Bronze Statue of Chen Yi', '陈毅广场与陈毅铜像 / Chen Yi Square and Bronze Statue of Chen Yi',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/the_bund_shanghai_sa_12.png', '', 11, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'shanghai_disney_resort_sa_01', 'shanghai_disney_resort', '', '奇想花园',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/shanghai_disney_resort_sa_01.png', '', 0, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'shanghai_disney_resort_sa_02', 'shanghai_disney_resort', '', '宝藏湾',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/shanghai_disney_resort_sa_02.png', '', 1, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'shanghai_disney_resort_sa_03', 'shanghai_disney_resort', '', '探险岛',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/shanghai_disney_resort_sa_03.png', '<p>探险岛位于乐园东南部，以远古丛林部落探险为主题。园区核心地标是"雷鸣山"——一座人造假山，内部贯穿漂流河道与飞行体验剧场。标志性项目"翱翔·飞越地平线"是全园排队最长的项目之一，游客乘坐悬挂式飞行器，在巨幕球幕中飞越全球标志性景观（身高要求≥102cm）。另有"雷鸣山漂流"（室外激流漂流，身高≥107cm）、"古迹探寻营"（绳索挑战道等户外探索路线）等冒险项目。园区设计灵感来自太平洋岛屿与南美丛林的混合文明，弥漫着烟雾与水雾效果，是乐园最具沉浸感的主题区之一。</p>', 2, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'shanghai_disney_resort_sa_04', 'shanghai_disney_resort', '', '明日世界',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/shanghai_disney_resort_sa_04.png', '<p>明日世界位于乐园西北部，以未来科技与科幻探索为主题。园区建筑风格充满流线型金属感与霓虹光效，营造出"赛博朋克"未来都市氛围。标志性项目"创极速光轮—雪佛兰呈献"是室内高速摩托式过山车（身高≥122cm），游客跨骑发光摩托车在光影隧道中疾驰，是全球迪士尼乐园中最刺激的过山车之一。其他项目包括"巴斯光年星际营救"（室内互动射击）、"喷气背包飞行器"（室外旋转飞行，身高≥122cm）、"创界：雪佛兰数字挑战"（互动体验未来驾驶）等。园区还定期举办"复仇者联盟培训行动"演出与"E 空间聚乐部"电子音乐派对。</p>', 3, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'shanghai_disney_resort_sa_05', 'shanghai_disney_resort', '', '星愿公园',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/shanghai_disney_resort_sa_05.png', '<p>星愿公园位于上海迪士尼度假区西侧，环绕面积达 40 万平方米的"星愿湖"而建，是度假区内独立于乐园围墙外的免费开放式公园。公园内设约 2.5 公里环湖步道，沿途分布亲水平台、花园、儿童乐园、野餐草坪与多个拍照打卡点。公园以迪士尼动画《花木兰》中"当你许下星愿"（When You Wish Upon a Star）为命名灵感，湖心有一座名为"星愿"的巨型灯光装置，夜晚点亮后倒映湖面，是度假区标志性夜景之一。公园还设有自行车租赁点（双人/四人自行车）、皮划艇体验区与季节性花展，是亲子家庭与跑步爱好者在乐园外消磨时光的理想选择。</p>', 4, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'shanghai_disney_resort_sa_06', 'shanghai_disney_resort', '', '梦幻世界',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/shanghai_disney_resort_sa_06.png', '<p>梦幻世界位于乐园北部，是园区内游乐项目最多（9 个）的主题区，以迪士尼经典动画童话为核心叙事。园区核心地标"奇幻童话城堡"是全球最高最大的迪士尼城堡，塔尖缀有中国祥云、牡丹、白玉兰等元素，是全园最热门的拍照打卡点。代表项目包括"七个小矮人矿山车"（家庭过山车，身高≥97cm）、"小飞侠天空奇遇"（室内悬挂飞行）、"小熊维尼历险记"（室内乘船）、"晶彩奇航"（室外水上项目）、"爱丽丝梦游仙境迷宫"（室外互动迷宫）等。城堡内还设有"漫游童话时光"白雪公主互动体验与"冰雪奇缘：欢唱盛会"演出（约 20 分钟）。</p>', 5, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'shanghai_disney_resort_sa_07', 'shanghai_disney_resort', '', '玩具总动员乐园',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/shanghai_disney_resort_sa_07.png', '<p>玩具总动员乐园位于乐园西北部，紧邻明日世界，于 2018 年 4 月 26 日开放，是上海迪士尼乐园第一个扩建主题园区。园区设计基于《玩具总动员》电影世界观——游客入园后"缩小"至玩具尺寸，进入主角安迪的后院：巨大的积木、弹簧狗、纸风筝、多米诺骨牌等日常物品变成了超比例的巨型装置。代表项目包括"抱抱龙冲天赛车"（U 型轨道赛车，身高≥120cm）、"弹簧狗团团转"（室外旋转追逐）、"胡迪牛仔嘉年华"（西部马车 ride，身高≥81cm）。园区整体色彩鲜艳、节奏轻松，是亲子家庭与低龄儿童最友好的主题区。</p>', 6, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'shanghai_disney_resort_sa_08', 'shanghai_disney_resort', '', '疯狂动物城',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/shanghai_disney_resort_sa_08.png', '<p>疯狂动物城位于乐园东部，毗邻宝藏湾，于 2023 年 12 月 20 日正式开幕，是全球首个"疯狂动物城"主题园区，也是上海迪士尼乐园第八大主题园区。园区忠实还原了电影中动物都市（Zootopia）的城市场景——不同体型的动物区域、列车系统、霓虹招牌、市政厅。标志性游乐项目"疯狂动物城：热力追踪"是全园最新的高科技沉浸式乘骑体验。园区内随处可见尼克、朱迪、闪电等电影角色的互动装置与拍照点。2023 年 3 月 10 日，小熊猫"美美"在此全球首发亮相。2024 年 11 月，该园区荣获全球主题娱乐协会（TEA）2025 年度"主题乐园园区杰出成就奖"。</p>', 7, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'shanghai_disney_resort_sa_09', 'shanghai_disney_resort', '', '米奇大街',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/shanghai_disney_resort_sa_09.png', '', 8, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'shanghai_disney_resort_sa_10', 'shanghai_disney_resort', '', '迪士尼小镇',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/shanghai_disney_resort_sa_10.png', '<p>迪士尼小镇位于上海迪士尼乐园主入口外南侧，是度假区内独立的商业娱乐区，无需购买乐园门票即可进入。小镇占地约 4.6 万平方米，分为"小镇市集""百老汇广场""百老汇大道"三个区域，汇集全球知名餐饮品牌（如芝乐坊、The BOATHOUSE、元素 Table）、迪士尼官方商店（世界最大迪士尼旗舰店之一）、大隐书局、乐高品牌旗舰店等零售店铺。小镇内的"华特迪士尼大剧院"上演百老汇音乐剧《狮子王》中文版（需单独购票）。小镇还定期举办季节性集市、户外演出与灯光装置展，是游客在乐园外消磨半天的热门去处。</p>', 9, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'oriental_pearl_radio_television_tower_sa_01', 'oriental_pearl_radio_television_tower', '**English**: Shanghai History Development Exhibition Hall', '**中文**：上海城市历史发展陈列馆',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/oriental_pearl_radio_television_tower_sa_01.png', '<p>- VR 体验：5 分钟"穿越 1930"VR 漫游（免费） Long Description: The Shanghai History Development Exhibition Hall occupies approximately 6,000 square meters on Level 0 of the Oriental Pearl TV Tower''s podium, one of China''s earliest "tower + museum" themed venues. The hall is divided into five sections — Prelude, Shanghai before the Treaty Port, Rise of the Modern City, New China''s Shanghai, and Pudong Development &amp; New Shanghai — displaying more than 1,000 items including vintage photographs, archives, wax figure scenes, physical models, and interactive installations. Highlights include: - "Ten-Mile Foreign Settlement" Street Scene: 1930s Bund Nanjing Road recreation with bronze carriages, vintage trams, and calendar posters - Lilong Lane Scene: Restored Shikumen life in old Shanghai - Pudong Development Sandbox: 1:500 dynamic scale model of Lujiazui core area - Interactive Photo Spots: Pose with 1930s calendar girls and qipao-clad beauties - VR Experience: Free 5-minute "Time Travel to 1930" VR walkthrough - Recommended visit duration: 60–90 minutes, can be flexibly split before and after the tower climb</p>', 0, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'oriental_pearl_radio_television_tower_sa_02', 'oriental_pearl_radio_television_tower', '**English**: Main Observation Deck', '**中文**：主观光层',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/oriental_pearl_radio_television_tower_sa_02.png', '<p>Long Description: The Main Observation Deck sits inside the tower''s third sphere at 263 meters — the original core observation level open to the public. With a 20-meter inner diameter, the circular walkway is fully glazed, offering sweeping views of the Bund''s historic buildings, Pudong''s skyscrapers, and the winding Huangpu River. Sunset (around 17:30–18:30, seasonally shifting) brings Shanghai''s most celebrated "golden hour" as city lights come on. The deck features transparent floor windows, photo spots, vending machines, and a light-snack corner. A wide-angle lens and a phone''s night mode are recommended; be aware of glass glare, so press close to the glass or pick a column-free spot. The level connects by elevator to the 259m Skywalk, 350m Space Capsule, 78m "More Shanghai" immersive show, and the 0m Shanghai History Exhibition.</p>', 1, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'oriental_pearl_radio_television_tower_sa_03', 'oriental_pearl_radio_television_tower', '**English**: Transparent Glass Skywalk (Sky Observatory)', '**中文**：全透明悬空观光廊',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/oriental_pearl_radio_television_tower_sa_03.png', '<p>全透明悬空观光廊位于东方明珠第二个球体的下沿，垂直高度 259 米，环形步道宽约 1.8 米，全长约 150 米。三面伸出球体之外，凌空悬挂于黄浦江上空，廊道地板与护栏均为三层夹胶钢化玻璃（厚度 24 毫米），透光率 99.7%，是"踩在云上"的真实体验。步道下可直接俯瞰陆家嘴核心区车流、东方明珠塔身"串珠"造型、滨江步道与外滩万国建筑群。走廊设 6 个"勇敢者拍照点"，玻璃地面下方嵌入 LED 屏，夜晚会播放"星河"动画。玻璃栈道最大载重 800 公斤/平方米，单段限 8 人。强风、雨雪天气会临时关闭。 Long Description: The Transparent Glass Skywalk runs along the underside of the tower''s second sphere at 259 meters. The circular walkway is 1.8 meters wide and approximately 150 meters long, projecting from three sides of the sphere and suspended over the Huangpu River. Both the floor and railings are 24mm triple-laminated tempered glass with 99.7% light transmission — a true "walking on clouds" experience. Below the walkway, visitors can see Lujiazui''s core traffic, the tower''s signature "pearl-string" silhouette, the riverside promenade, and the Bund''s historic skyline. The corridor features 6 "brave photo spots," with LED screens embedded beneath the glass that play a "star river" animation at night. The glass can support up to 800 kg per square meter, with a limit of 8 people per section. The skywalk is temporarily closed during strong winds, rain, or snow.</p>', 2, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'oriental_pearl_radio_television_tower_sa_04', 'oriental_pearl_radio_television_tower', '**English**: 351-Meter Space Capsule', '**中文**：351 米太空舱',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/oriental_pearl_radio_television_tower_sa_04.png', '<p>351 米太空舱位于塔体最高球体（也称"太空舱"或"明珠舱"），原 2008 年建成，2023 年升级为"航天 + 元宇宙"线下沉浸体验空间。整个球体内径约 14 米，舱壁以星空顶与镜面金属为主材，配合全息投影与环绕音响系统，营造"漫步太空"的视觉感受。舱内核心体验包括：360°俯瞰上海四大城市天际线（陆家嘴、外滩、北外滩、徐汇滨江）、AI 互动拍照（生成"太空人"纪念照）、VR 沉浸式"中国空间站"模拟、地面遥控"玉兔月球车"等。舱外甲板为封闭观景走廊，配双层安全玻璃，可拍摄无遮挡的城市全貌。舱内容纳人数上限 30 人，限流 10 分钟轮换。 Long Description: The 351-Meter Space Capsule sits inside the tower''s highest sphere, originally completed in 2008 and upgraded in 2023 into a "space + metaverse" immersive experience venue. With a 14-meter inner diameter, its walls combine starry ceilings and mirrored metals, paired with holographic projections and surround sound, creating a "spacewalk" atmosphere. Highlights include 360° views of Shanghai''s four skylines (Lujiazui, the Bund, North Bund, Xuhui Riverside), AI interactive photo booths (generating "astronaut" souvenir images), VR immersive "China Space Station" simulations, and remote-controlled "Yutu Lunar Rover" demos on the floor. The outer deck is a closed observation corridor with double-glazed safety glass, offering unobstructed full-city photography. Capacity is capped at 30 people with 10-minute rotations.</p>', 3, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'oriental_pearl_radio_television_tower_sa_05', 'oriental_pearl_radio_television_tower', '**English**: Outdoor Observation Terrace', '**中文**：户外观光层',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/oriental_pearl_radio_television_tower_sa_05.png', '<p>户外观光层位于东方明珠塔身 350 米处，环绕主柱呈 360 度环形观景台，全长约 200 米，宽 2.5 米，是整座塔最高、视野最开阔的露天场所。平台设有 1.3 米高钢化玻璃护栏，地面为防滑铝板，全程 24 小时监控 + 急救站 + 救生绳。站在此处可直面 351 米太空舱的"玉柱"、俯瞰黄浦江"S"形弯道与外滩天际线。风速 3–5 级时体感清凉舒爽，6 级以上平台关闭。建议在塔内电梯至 350 米层时通过指定闸机进入。露台不设座位，停留时间建议 15–30 分钟。 Long Description: The Outdoor Observation Terrace is a 360-degree circular platform at 350 meters on the tower''s main shaft, approximately 200 meters long and 2.5 meters wide — the highest open-air viewing area on the tower. It features 1.3m tempered-glass railings, anti-slip aluminum flooring, 24/7 surveillance, an emergency station, and safety ropes. From here, visitors look up at the 351m Space Capsule "jade pillar" and down on the S-shaped bend of the Huangpu River and the Bund skyline. A breeze of Beaufort 3–5 makes for a refreshing experience; the terrace closes in winds above Beaufort 6. Access is via a dedicated gate on the 350m elevator level. No seating is provided; a 15–30 minute stay is recommended.</p>', 4, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'oriental_pearl_radio_television_tower_sa_06', 'oriental_pearl_radio_television_tower', '**English**: "More Shanghai" 360° Immersive Multimedia Show', '**中文**：更上海环动多媒体秀',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/oriental_pearl_radio_television_tower_sa_06.png', '<p>Long Description: The "More Shanghai" Immersive Multimedia Show is located at 78 meters on the tower''s main shaft. The theater has a 30-meter inner diameter with a 360° wraparound screen and a synchronized "motion floor" projection; seats rotate 360 degrees. The 10-minute show uses five chapters — River, Sea, Tide, Wind, Charm — to trace Shanghai''s century-long evolution: from the 1843 treaty-port opening, 1920s Bund construction, 1949 liberation, 1990 Pudong development, 2010 World Expo, 2020 urban renewal, to 2035 planning vision. Original music and 6.1-channel surround sound complete the immersive experience. Capacity is 80 people, with a show every 15 minutes. It is best watched as a mid-tour interlude, serving as a "city-background lesson" before ascending the main observation levels.</p>', 5, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'oriental_pearl_radio_television_tower_sa_07', 'oriental_pearl_radio_television_tower', '**English**: Ticket Gate', '**中文**：检票口',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/oriental_pearl_radio_television_tower_sa_07.png', '<p>东方明珠广播电视塔的检票口位于塔体南侧裙楼入口处，毗邻浦东陆家嘴滨江步道，正对世纪大道。检票口以"明珠"为造型意象，外立面为银白色金属与玻璃组合，配以 LED 字幕屏滚动播报实时排队与登塔信息。游客须出示电子票二维码或身份证（刷证入场），并通过安检与金属探测门。检票口内部为序厅，设有无障碍通道、行李寄存柜、母婴室与团体接待窗口。塔内按 9 米/秒高速电梯直达各观光层，开放时间内无固定批次限制。建议节假日提前 1 小时到达以避开人峰，平日可在 9:30 前完成检票，享受人少景好的"包塔感"。 Long Description: The Ticket Gate of the Oriental Pearl TV Tower is located at the south podium entrance, adjacent to the Lujiazui Riverside Walk and facing Century Avenue. Designed with a "bright pearl" motif, its facade combines silver-white metal and glass, paired with LED ticker displays showing real-time queue and boarding information. Visitors must present their e-ticket QR code or ID card (swipe-to-enter), and pass through security and metal detectors. Inside the gate is the prelude hall, offering accessible lanes, luggage lockers, a baby-care room, and group reception counters. High-speed elevators at 9 m/s take guests directly to each observation level, with no fixed batch restrictions during opening hours. On holidays, arrive an hour early to avoid peak queues; on regular days, completing the ticket check before 9:30 offers a near-private tower experience.</p>', 6, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market_sa_01', 'south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market', 'kate kevin', '一楼-Kate&Kevin定制工坊',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market_sa_01.png', '', 0, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market_sa_02', 'south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market', '', '一楼-成衣与皮具区',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market_sa_02.png', '', 1, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market_sa_03', 'south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market', '', '三楼-传统面料零售区',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market_sa_03.png', '', 2, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market_sa_04', 'south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market', '', '三楼-旗袍与中式服装区',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market_sa_04.png', '', 3, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market_sa_05', 'south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market', '', '二楼-西装定制核心区',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market_sa_05.png', '', 4, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market_sa_06', 'south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market', '', '二楼-进口面料坊',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market_sa_06.png', '', 5, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market_sa_07', 'south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market', '', '四楼-羊绒与杂项区',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market_sa_07.png', '', 6, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market_sa_08', 'south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market', '', '市场入口大厅',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market_sa_08.png', '', 7, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market_sa_09', 'south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market', '', '黄浦邮政国际寄送服务台',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market_sa_09.png', '', 8, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'xujiahui_source_scenic_area_sa_01', 'xujiahui_source_scenic_area', '', '上海气象博物馆（徐家汇观象台旧址）',
  NULL, '', 0, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'xujiahui_source_scenic_area_sa_02', 'xujiahui_source_scenic_area', '', '上海电影博物馆',
  NULL, '', 1, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'xujiahui_source_scenic_area_sa_03', 'xujiahui_source_scenic_area', '', '光启公园与徐光启纪念馆',
  NULL, '', 2, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'xujiahui_source_scenic_area_sa_04', 'xujiahui_source_scenic_area', '', '土山湾博物馆',
  NULL, '', 3, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'xujiahui_source_scenic_area_sa_05', 'xujiahui_source_scenic_area', '', '圣母院旧址（上海老站）',
  NULL, '', 4, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'xujiahui_source_scenic_area_sa_06', 'xujiahui_source_scenic_area', '', '徐家汇书院',
  NULL, '', 5, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'xujiahui_source_scenic_area_sa_07', 'xujiahui_source_scenic_area', '', '徐家汇天主堂',
  NULL, '', 6, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'xujiahui_source_scenic_area_sa_08', 'xujiahui_source_scenic_area', '', '徐汇公学旧址（崇思楼）',
  NULL, '', 7, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'xujiahui_source_scenic_area_sa_09', 'xujiahui_source_scenic_area', '', '百代小楼（《义勇军进行曲》灌制地纪念馆）',
  NULL, '', 8, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'zhujiajiao_ancient_town_sa_01', 'zhujiajiao_ancient_town', '1', '1.放生桥',
  NULL, '', 0, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'zhujiajiao_ancient_town_sa_02', 'zhujiajiao_ancient_town', '2', '2.北大街',
  NULL, '', 1, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'zhujiajiao_ancient_town_sa_03', 'zhujiajiao_ancient_town', '3', '3.涵大隆酱园',
  NULL, '', 2, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'zhujiajiao_ancient_town_sa_04', 'zhujiajiao_ancient_town', '4', '4.泰安桥',
  NULL, '', 3, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'zhujiajiao_ancient_town_sa_05', 'zhujiajiao_ancient_town', '5', '5.圆津禅院',
  NULL, '', 4, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'zhujiajiao_ancient_town_sa_06', 'zhujiajiao_ancient_town', '6', '6.廊桥',
  NULL, '', 5, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'zhujiajiao_ancient_town_sa_07', 'zhujiajiao_ancient_town', '7', '7.城隍庙',
  NULL, '', 6, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'zhujiajiao_ancient_town_sa_08', 'zhujiajiao_ancient_town', '8', '8.课植园',
  NULL, '', 7, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'zhujiajiao_ancient_town_sa_09', 'zhujiajiao_ancient_town', '9', '9.大清邮局',
  NULL, '', 8, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'wukang_road_sa_01', 'wukang_road', '391 1', '**周璇旧居（武康路 391 弄 1 号）**',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/wukang_road_sa_01.jpg', '', 0, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'wukang_road_sa_02', 'wukang_road', '393', '**宋庆龄故居（武康路 393 号）**',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/wukang_road_sa_02.jpg', '', 1, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'wukang_road_sa_03', 'wukang_road', '**密丹公寓（武康路 115 号 / Medan Apartments）**', '**密丹公寓（武康路 115 号 / Medan Apartments）**',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/wukang_road_sa_03.jpg', '<p>密丹公寓位于武康路 115 号，由法商万国储蓄会（International Savings Society）投资、赉安洋行（A. Léonard &amp; P. Veysseyre）于 1924 年设计建造。公寓地上 6 层（原为 4 层加建），砖混结构，黄色水泥拉毛外墙配合简洁几何线条的窗套与阳台，底层有连续拱券门廊，整体呈现典型的 1920 年代末"装饰艺术（Art Deco）"萌芽期的现代派风格。公寓因位于原法租界核心区、紧邻巴金故居与武康庭，长期为外籍医生、工程师与文艺界名流租住。1949 年后成为上海普通市民住宅，目前 1—2 楼部分为商业、3 楼及以上为住宅。建筑可外观，内部不开放，是武康路"建筑可阅读"漫步路线的必看节点之一。</p>', 2, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'wukang_road_sa_04', 'wukang_road', '113', '**巴金故居（武康路 113 号）**',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/wukang_road_sa_04.jpg', '', 3, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'wukang_road_sa_05', 'wukang_road', '390', '**意大利总领事馆旧址（武康路 390 号）**',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/wukang_road_sa_05.jpg', '<p>意大利总领事馆旧址位于武康路 390 号，由义品地产公司（Credit Foncier d''Extreme-Orient）设计并承建，1932 年建成，曾为意大利驻沪总领事官邸。建筑占地约 2630 平方米，建筑面积 612 平方米，假二层砖石混合结构，主立面朝南，面对花园，底层东、南、西三面均设计为敞廊，红色筒瓦坡屋顶搭配半圆形与方形门窗洞，是上海现存少见的地中海风格花园住宅。1949 年后曾长期为上海机电系统办公场所，1995 年起划归上海汽车工业总公司，2010 年后逐步修缮开放。2024 年起以"地中海生活美学馆"形态向公众预约开放，可参观建筑本体、花园与小型艺术展陈。</p>', 4, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'wukang_road_sa_06', 'wukang_road', '1', '**武康大楼（原诺曼底公寓 / 武康路 1 号）**',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/wukang_road_sa_06.jpg', '<p>武康大楼位于淮海中路—武康路五条岔路口，由匈牙利籍建筑师邬达克 1924 年设计，原名"诺曼底公寓"（Normandie Apartments），1953 年更名武康大楼，是上海最早一批现代化高层公寓之一。整栋建筑呈巨型"船型"楔入路口，地下 1 层、地上 8 层，连续外廊与转角弧线由淮海中路一直延伸到武康路深处，是上海仅存的 1920 年代巨型船型公寓。底层为骑楼与商铺，2019—2020 年完成"一楼一策"微更新后辟出咖啡、轻餐、文创小店与文献展陈空间。大楼经多次修缮，外立面水刷石与红砖对比鲜明，是俯瞰淮海中路梧桐街景、拍摄"上海第一转角"的最佳视点。</p>', 5, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'wukang_road_sa_07', 'wukang_road', '**武康庭（Wukang Mansion Courtyard / 武康路 376—378 号）**', '**武康庭（Wukang Mansion Courtyard / 武康路 376—378 号）**',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/wukang_road_sa_07.jpg', '<p>武康庭位于武康路 376—378 号，前身为 1920 年代英商正广和洋行（旗下"正广和"汽水厂）上海办公地与周边新式里弄。2007 年整体改造为开放式商业庭院，保留了红砖立面、老虎窗与水磨石台阶等历史构件，并以中央水景、长条木椅与藤蔓花架营造"欧式里弄中庭"氛围。庭院集中了精品咖啡馆（如 %Arabica、Peet''s Coffee、Manner 等快闪店）、独立设计师买手店、当代艺术画廊、婚纱定制与轻餐，是武康路上停留时间最长的"小而美"综合体。庭院与街道直接贯通，免费向公众开放，是拍摄"武康路午后"最经典的取景地之一。</p>', 6, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'wukang_road_sa_08', 'wukang_road', '210', '**罗密欧阳台（武康路 210 号 / 原德利那齐宅）**',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/wukang_road_sa_08.jpg', '<p>罗密欧阳台位于武康路 210 号，建于 1930 年代，原为意大利商人德利那齐（Del Nerce）私宅。建筑为三层砖混结构西式洋房，鹅黄色外墙、白色窗套，二楼南侧外挑一个小巧的弧形铁艺阳台，面朝武康路梧桐深处。远远望去，阳台与上方墙面、藤蔓与院墙共同构成一幅极具戏剧感的画面，2000 年代被网友昵称为"罗密欧阳台"——意指"朱丽叶阳台"——成为武康路最浪漫的微地标之一。建筑为私产，目前不开放入内参观，但游客可沿武康路人行道远观并拍照，是武康路 City Walk 不可错过的"路上风景"。</p>', 7, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'wukang_road_sa_09', 'wukang_road', '393', '**黄兴故居 / 武康路 393 弄黄兴故居老房子艺术中心**',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/wukang_road_sa_09.jpg', '', 8, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'tianzifang_sa_01', 'tianzifang', '248', '**248 弄弄堂**',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/tianzifang_sa_01.png', '', 0, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'tianzifang_sa_02', 'tianzifang', '274', '**274 弄艺术长廊**',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/tianzifang_sa_02.png', '', 1, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'tianzifang_sa_03', 'tianzifang', '', '**守白艺术中心**',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/tianzifang_sa_03.png', '', 2, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'tianzifang_sa_04', 'tianzifang', '', '**气味图书馆**',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/tianzifang_sa_04.png', '<p>气味图书馆（Demeter Fragrance Library 的中国合作方）位于田子坊 248 弄内，是国内最早把"城市气味""童年记忆""情绪气味"做成香水产品的本土品牌之一。门店小巧，墙上整齐排列几十种按主题命名的香水——"雨后花园""旧书页""外婆的厨房""老上海弄堂"等，每一种都对应一种具象场景或情感记忆。客人可以自由试闻，找到与自己嗅觉经验最契合的那款香水，也可以现场调香或买走 30ml 旅行装礼盒。对"用味道留住一座城"的游客来说，这是田子坊最值得带走的"嗅觉伴手礼"。</p>', 3, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'tianzifang_sa_05', 'tianzifang', '', '**泰康路主入口**',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/tianzifang_sa_05.png', '', 4, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'tianzifang_sa_06', 'tianzifang', '', '**画家楼天台**',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/tianzifang_sa_06.png', '', 5, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'tianzifang_sa_07', 'tianzifang', '', '**石库门里弄建筑群**',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/tianzifang_sa_07.png', '', 6, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'tianzifang_sa_08', 'tianzifang', '', '**金粉世家**',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/tianzifang_sa_08.png', '', 7, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'tianzifang_sa_09', 'tianzifang', '', '**陈逸飞工作室旧址**',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/tianzifang_sa_09.png', '', 8, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'yu_garden_sa_01', 'yu_garden', '1', '1.三穗堂',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/yu_garden_sa_01.jpg', '', 0, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'yu_garden_sa_02', 'yu_garden', '10', '10.得月楼',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/yu_garden_sa_02.jpg', '', 1, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'yu_garden_sa_03', 'yu_garden', '11', '11.内园',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/yu_garden_sa_03.jpg', '', 2, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'yu_garden_sa_04', 'yu_garden', '2', '2.仰山堂卷雨楼',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/yu_garden_sa_04.jpg', '', 3, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'yu_garden_sa_05', 'yu_garden', '3', '3.大假山',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/yu_garden_sa_05.jpg', '', 4, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'yu_garden_sa_06', 'yu_garden', '4', '4.萃秀堂',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/yu_garden_sa_06.jpg', '', 5, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'yu_garden_sa_07', 'yu_garden', '5', '5.万花楼',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/yu_garden_sa_07.jpg', '', 6, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'yu_garden_sa_08', 'yu_garden', '6', '6.点春堂',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/yu_garden_sa_08.jpg', '', 7, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'yu_garden_sa_09', 'yu_garden', '7', '7.玉玲珑',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/yu_garden_sa_09.jpg', '', 8, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'yu_garden_sa_10', 'yu_garden', '8', '8.玉华堂',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/yu_garden_sa_10.jpg', '', 9, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'yu_garden_sa_11', 'yu_garden', '9', '9.会景楼',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/yu_garden_sa_11.jpg', '', 10, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'lujiazui_financial_district_sa_01', 'lujiazui_financial_district', '**英文名**：Shanghai Tower (Top of Shanghai Observation Hall)', '**中文名**：上海中心大厦（上海之巅观光厅）',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/lujiazui_financial_district_sa_01.png', '<p>上海中心大厦位于浦东新区银城中路501号，楼高632米，地上127层、地下5层，2015年全面建成开放，是中国第一、世界第二高楼，仅次于迪拜哈利法塔。大厦由美国Gensler事务所设计，造型灵感来自DNA双螺旋结构，外形如同一根缓缓旋转上升的"龙形"曲面，外墙由近20000块曲面玻璃幕墙构成，可随光照变化呈现不同色泽。大厦集办公、酒店、商业、观光于一体，内部设有J酒店（位于84-110层，世界最高酒店之一）、118层"上海之巅"观光厅、126层"阻尼器演绎"装置、上海观光线·魔都之光艺术展等项目。"上海之巅"观光厅位于第118层，垂直高度546米，拥有世界最高的室内观光平台，360度全视角俯瞰上海；126层的"上海慧眼"——重达1000吨的"风阻尼器"是世界最重的阻尼器之一，是科技与艺术的完美结合。 Shanghai Tower, located at 501 Yincheng Middle Road, Pudong New Area, stands 632 meters tall with 127 above-ground floors and 5 basement levels. Fully completed and opened in 2015, it is the tallest building in China and the second tallest in the world, after the Burj Khalifa in Dubai. Designed by the American firm Gensler, the tower draws inspiration from DNA''s double-helix structure, with its form resembling a slowly twisting "dragon-like" curved surface. Its facade consists of nearly 20,000 curved glass panels that change color with the light. The complex integrates offices, hotels, commerce, and sightseeing, housing the J Hotel (floors 84-110, one of the world''s highest hotels), the 118F "Top of Shanghai" Observation Hall, the 126F "Damper Performance" installation, and the "Magic City Light" art exhibition. The "Top of Shanghai" observation hall on the 118th floor stands at 546 meters, making it the world''s highest indoor observation platform, offering 360-degree views. The 126F "Shanghai Eye"—a 1,000-ton tuned mass damper—is one of the world''s heaviest, blending technology and art seamlessly.</p>', 0, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'lujiazui_financial_district_sa_02', 'lujiazui_financial_district', '**英文名**：Shanghai Ocean Aquarium', '**中文名**：上海海洋水族馆',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/lujiazui_financial_district_sa_02.png', '<p>The Shanghai Ocean Aquarium, located at 1388 Lujiazui Ring Road, Pudong New Area, is adjacent to the Oriental Pearl TV Tower. With a building area of approximately 20,500 square meters, it opened in 2002 and is one of the largest and most diverse ocean aquariums in Asia. The facility features 9 themed exhibition zones including Asia, South America, Australia, Africa, Cold Water, Coastline, Deep Sea, and China zones, housing over 15,000 rare marine creatures from more than 450 species. Its most famous feature is the 155-meter-long underwater viewing tunnel—certified by Guinness World Records as one of the world''s longest ocean tunnels—where visitors can watch sharks, rays, and sea turtles swim overhead through transparent acrylic panels. The aquarium also features the Jellyfish Kingdom, Coral Sea, and Antarctic Penguin exhibits, making it an ideal destination for families, couples, and marine life enthusiasts.</p>', 1, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'lujiazui_financial_district_sa_03', 'lujiazui_financial_district', '**英文名**：Shanghai World Financial Center (SWFC)', '**中文名**：上海环球金融中心',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/lujiazui_financial_district_sa_03.png', '<p>上海环球金融中心位于浦东新区世纪大道100号，楼高492米，地上101层、地下3层，2008年8月全面建成开放。建筑由日本KPF事务所设计，因其顶部梯形方孔造型酷似"开瓶器"而得名，是上海陆家嘴金融区的"三件套"摩天楼之一。大楼集办公、酒店、观光、商业于一体，内部设有柏悦酒店（79-93层）、94/97/100层观光厅、492米高的"巅峰之旅"观光体验等项目。100层观光天阁曾被吉尼斯世界纪录认证为"世界最高观光厅"，474米高空可360度俯瞰上海全城，悬空观光长廊配备全透明玻璃地板，惊险刺激。SWFC与金茂大厦、上海中心大厦形成"三足鼎立"的陆家嘴天际线，是中国改革开放30年的城市地标象征。 Shanghai World Financial Center, located at 100 Century Avenue, Pudong New Area, stands 492 meters tall with 101 above-ground floors and 3 basement levels, fully opened in August 2008. Designed by Japan''s Kohn Pedersen Fox (KPF), the building is nicknamed the "Bottle Opener" due to its distinctive trapezoidal aperture at the top. As one of the Lujiazui "Trio" skyscrapers, it integrates offices, hotels, sightseeing, and commerce, housing the Park Hyatt Shanghai (floors 79-93), observation decks on floors 94/97/100, and the "Sky Walk 100" experience at 492 meters. The 100th-floor observation sky lobby was certified by Guinness World Records as the world''s highest observation deck, offering a 360-degree panoramic view at 474 meters. Its transparent glass-floor sky walk provides an exhilarating experience. Together with Jin Mao Tower and Shanghai Tower, SWFC forms the iconic "three-legged" Lujiazui skyline—a symbol of China''s 30 years of reform and opening up.</p>', 2, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'lujiazui_financial_district_sa_04', 'lujiazui_financial_district', '**英文名**：Century Avenue', '**中文名**：世纪大道',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/lujiazui_financial_district_sa_04.png', '<p>Century Avenue, located in Pudong New Area, is 5.5 kilometers long and 100 meters wide. Stretching east from Century Park to the Oriental Pearl TV Tower in Lujiazui and connecting directly with the Yan''an East Road Tunnel, it opened on April 18, 2000, and is one of the most important east-west arterial roads in Shanghai''s Pudong New Area. Its most distinctive feature is being "China''s first urban landscape avenue where greenery and sidewalks are wider than the vehicle lanes"—the north sidewalk alone is 44.5 meters wide, the south sidewalk 24.5 meters, with a total green landscape sidewalk area of 69 meters, more than three times that of an ordinary urban road. The avenue is lined with four rows of street trees, including evergreen camphor trees on the outer side and deciduous ginkgo and plane trees on the inner side, creating changing colors throughout the year and earning it the nickname "The Champs-Élysées of the East." Flanked by skyscrapers (Jin Mao Tower, SWFC, Shanghai Tower, Oriental Pearl) and low-rise financial street shops, the avenue is Shanghai''s most international city image display. Along the way, Century Park is a weekend leisure destination, while Century Square features a large musical fountain.</p>', 3, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'lujiazui_financial_district_sa_05', 'lujiazui_financial_district', '**英文名**：Oriental Pearl TV Tower (Oriental Pearl Radio & Television Tower)', '**中文名**：东方明珠广播电视塔',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/lujiazui_financial_district_sa_05.png', '<p>The Oriental Pearl TV Tower, located at 1 Century Avenue, Pudong New Area, stands 467.9 meters tall and was opened in 1994, ranking as the 6th tallest tower in Asia and 9th in the world. Its structure consists of three 9-meter-diameter pillars and three spheres of varying sizes connected by space capsules, creating the iconic "large and small pearls falling on a jade plate" silhouette that has become a symbol of Shanghai''s skyline. The tower features the Main Observation Deck (263m), the transparent Sky Walk (259m), the Space Capsule (351m), the outdoor Observation Deck (350m), a Revolving Restaurant (267m), and the Shanghai Museum of Urban Development History, making it one of the best vantage points for viewing Shanghai''s day and night scenery on both sides of the Huangpu River. The plaza at its base hosts various city festivals, and the "Dynamic Shanghai" multimedia show inside provides an immersive experience of Shanghai''s century-long urban transformation.</p>', 4, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'lujiazui_financial_district_sa_06', 'lujiazui_financial_district', '**英文名**：Wu Changshuo Memorial Hall', '**中文名**：吴昌硕纪念馆',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/lujiazui_financial_district_sa_06.png', '<p>The Wu Changshuo Memorial Hall, located at 15 Lujiazui East Road, Pudong New Area, is a dedicated memorial to Wu Changshuo (1844-1927), the master of Shanghai-style painting and calligraphy in late Qing and early Republican China, who excelled in poetry, painting, calligraphy, and seal carving. The memorial is housed in the "Yingchuan Xiaozhu" (Yingchuan Small Mansion)—a late Qing and early Republic era red-and-blue brick carved residence built in 1920, originally the home of Shanghai merchant Chen Guichun. Officially relocated to this site in May 2010, the building covers approximately 1,500 square meters and is recognized as a Shanghai Municipal Cultural Relic Protection Unit, renowned for its exquisite brick and wood carvings and nicknamed "Pudong Carved Building." The memorial features three main exhibition halls: "Wu Changshuo''s Life and Career," "Artistic Achievements," and "Poetry, Painting, Calligraphy, and Seal Works," displaying over 200 precious artifacts including works by Wu Changshuo and his disciples Qi Baishi, Pan Tianshou, Sha Menghai, Wang Geyi, and others. The site also includes the "Fou Pavilion" café and a cultural creative shop, making it a rare refined cultural oasis in the Lujiazui financial district.</p>', 5, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'lujiazui_financial_district_sa_07', 'lujiazui_financial_district', '**英文名**：Pudong Riverside Promenade (Dongchang Wharf to Taitongzhan Wharf Section)', '**中文名**：浦东滨江大道（东昌路码头至泰同栈码头段）',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/lujiazui_financial_district_sa_07.png', '<p>浦东滨江大道位于浦东新区黄浦江东岸，西起东昌路码头，东至泰同栈码头，全长约2.5公里，1997年建成开放。大道由亲水平台、坡地绿化、半地下厢体及景观道路组成，被誉为"上海小外滩"。与浦西外滩隔江相望的格局让游客可凭栏远眺浦西万国建筑博览群（外滩建筑群）和陆家嘴摩天楼群（东方明珠、金茂、SWFC、上海中心），形成"动与静结合、古老与现代对话"的壮丽画卷。大道沿线绿树成荫、花草争艳，设有20余处主题雕塑、亲水观景台、文化地标（如陈毅广场、船厂1862时尚艺术中心、上海艺仓美术馆）。夜间沿江灯光璀璨，是上海最经典的夜游、跑步、骑行、摄影地标之一。"船厂1862"原为百年船厂改造的时尚艺术中心，定期举办时尚、艺术、商业活动，已成为陆家嘴金融区最具艺术气质的"工业风新地标"。 The Pudong Riverside Promenade, located on the east bank of the Huangpu River in Pudong New Area, stretches approximately 2.5 kilometers from Dongchang Wharf in the west to Taitongzhan Wharf in the east, completed and opened in 1997. Comprising a water-friendly platform, sloped green landscape, semi-underground spaces, and landscape roads, it is hailed as the "Little Bund of Shanghai." Facing the historic Bund across the river, visitors can enjoy a panoramic view of the Puxi Bund''s "Expo of World Architecture" and Lujiazui''s modern skyscrapers (Oriental Pearl, Jin Mao, SWFC, Shanghai Tower), creating a magnificent dialogue between history and modernity. Lined with lush trees and blooming flowers, the promenade features over 20 themed sculptures, water-friendly viewing platforms, and cultural landmarks such as Chen Yi Square, the 1862 Shipyard Fashion Art Center, and the Shanghai Powerlong Art Museum. At night, the illuminated riverside becomes one of Shanghai''s most iconic destinations for evening strolls, jogging, cycling, and photography. The "1862 Shipyard," a former century-old shipyard converted into a fashion art center, regularly hosts fashion, art, and commercial events, becoming Lujiazui''s most artistic industrial-style new landmark.</p>', 6, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'lujiazui_financial_district_sa_08', 'lujiazui_financial_district', '**英文名**：Jin Mao Tower', '**中文名**：金茂大厦',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/lujiazui_financial_district_sa_08.png', '<p>金茂大厦位于浦东新区世纪大道88号，楼高420.5米，地上88层、地下3层，1999年全面建成开放，曾是中国大陆第一座突破400米的超高层建筑。大厦由美国SOM建筑设计事务所设计，建筑造型借鉴中国古典塔的层叠收分手法，外形如同一座"钢笔尖"般的现代宝塔，立面由铝合金与花岗岩幕墙构成，极具辨识度。大厦集办公、酒店、观光、商业于一体，内部设有金茂君悦大酒店（位于53-87层）、88层观光厅、152米高的"时光隧道"环形灯廊等观光设施。从88层观光厅可360度俯瞰上海全景，浦江两岸的万国建筑群与陆家嘴摩天楼尽收眼底。夜晚大厦顶端灯光映亮夜空，是上海最经典的城市天际线元素之一。 Jin Mao Tower, located at 88 Century Avenue, Pudong New Area, stands 420.5 meters tall with 88 above-ground floors and 3 basement levels. Completed and opened in 1999, it was the first building in mainland China to exceed 400 meters. Designed by the American architectural firm SOM, the building draws inspiration from classical Chinese pagodas with its tiered, tapering form, creating a "fountain pen tip" silhouette. Its facade combines aluminum alloy and granite curtain walls, making it highly recognizable. The complex integrates offices, hotels, sightseeing, and commerce, featuring the Grand Hyatt Shanghai (floors 53-87), the 88th-floor Observation Deck, and the spectacular 152-meter-tall "Time Tunnel" light corridor. From the 88th-floor observation deck, visitors can enjoy a 360-degree panoramic view of Shanghai, with the historic Bund and Lujiazui skyscrapers all visible. At night, the building''s illuminated peak becomes one of Shanghai''s most iconic skyline features.</p>', 7, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'lujiazui_financial_district_sa_09', 'lujiazui_financial_district', '**英文名**：Lujiazui Central Greenland', '**中文名**：陆家嘴中心绿地',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/lujiazui_financial_district_sa_09.png', '<p>Lujiazui Central Greenland, located at 717 Lujiazui Ring Road, Pudong New Area, is a rare open urban green space situated at the heart of Shanghai''s skyscraper cluster. Covering approximately 100,000 square meters and planted with cool-season turf imported from Europe, it features a striking steel "Pearl" sculpture and a circular sunken plaza at its center. Surrounded by the Jin Mao Tower, Shanghai World Financial Center, and Shanghai Tower—the three tallest buildings in China—it creates a remarkable "city within a garden, garden within a city" experience. Connected to the Huangpu River, the Oriental Pearl TV Tower, and the Riverside Promenade, it serves as a "green living room" for office workers and tourists alike, and is especially beautiful in spring when magnolias bloom and in autumn when ginkgo leaves turn golden.</p>', 8, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chengdu_museum_sa_01', 'chengdu_museum', '', '三楼·丹楼生晚辉——明清时期的成都',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chengdu_museum_sa_01.png', '<p>"Red towers glow in the evening" is taken from the poem of Yang Shen, a Ming Dynasty scholar from Sichuan. The gallery is located on the 3rd floor of Chengdu Museum.</p>', 0, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chengdu_museum_sa_02', 'chengdu_museum', '', '三楼·喧然名都会——隋唐五代宋元时期的成都',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chengdu_museum_sa_02.png', '<p>"A bustling famous metropolis" is taken from the Tang Dynasty poet Du Fu''s poem "Chengdu Fu," with the line "A bustling famous metropolis, with flutes and sheng pipes alternating."</p>', 1, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chengdu_museum_sa_03', 'chengdu_museum', '', '二楼·九天开出一成都——先秦时期的成都',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chengdu_museum_sa_03.png', '<p>"From nine heavens emerged a Chengdu" is taken from the Tang Dynasty poet Li Bai''s poem "Song of the Emperor''s Western Journey to the Southern Capital," with the full line reading "From nine heavens emerged a Chengdu, with ten thousand households and a thousand gates forming a picture scroll."</p>', 2, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chengdu_museum_sa_04', 'chengdu_museum', '', '二楼·西蜀称天府——两汉魏晋南北朝时期的成都',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chengdu_museum_sa_04.png', '<p>The "Western Shu Known as Land of Abundance" gallery is located on the 2nd floor of Chengdu Museum, as the second part of the "Flowers Weigh Down Brocade City — Chengdu Historical and Cultural Exhibition (Ancient Period)."</p>', 3, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chengdu_museum_sa_05', 'chengdu_museum', '', '五楼·偶戏大千——中国木偶展',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chengdu_museum_sa_05.png', '<p>"Puppet Theater of the Great Thousand — Chinese Puppet Exhibition" is located on the 5th floor of Chengdu Museum, adjacent to the "Shadow Dance of All Phenomena — Chinese Shadow Puppetry Exhibition."</p>', 4, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chengdu_museum_sa_06', 'chengdu_museum', '', '五楼·影舞万象——中国皮影展',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chengdu_museum_sa_06.png', '<p>"Shadow Dance of All Phenomena — Chinese Shadow Puppetry Exhibition" is located on the 5th floor of Chengdu Museum. It is one of the museum''s most distinctive permanent exhibitions and the largest and finest shadow puppetry thematic exhibition in China.</p>', 5, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chengdu_museum_sa_07', 'chengdu_museum', '', '四楼·花重锦官城——成都历史文化陈列（民俗篇）',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chengdu_museum_sa_07.png', '<p>"Flowers Weigh Down Brocade City — Chengdu Historical and Cultural Exhibition (Folk Customs Section)" is located on the 4th floor of Chengdu Museum.</p>', 6, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chengdu_museum_sa_08', 'chengdu_museum', '', '四楼·花重锦官城——成都历史文化陈列（近世篇）',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chengdu_museum_sa_08.png', '<p>"Flowers Weigh Down Brocade City — Chengdu Historical and Cultural Exhibition (Modern Period)" is located on the 4th floor of Chengdu Museum, focusing on Chengdu''s modern history from the mid-19th century to the mid-20th century.</p>', 7, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chengdu_museum_sa_09', 'chengdu_museum', '', '正门大厅',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chengdu_museum_sa_09.png', '<p>The Main Entrance Hall is the entrance space and core atrium of the new Chengdu Museum building, with a soaring ceiling of tens of meters, creating a magnificent and imposing atmosphere. The hall''s design integrates modern architectural language with ancient Shu cultural elements.</p>', 8, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chengdu_museum_sa_10', 'chengdu_museum', '', '负一楼·人与自然——贝林捐赠展',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chengdu_museum_sa_10.png', '<p>"Man and Nature — Behring Donation Exhibition" is located on the basement level 1 of Chengdu Museum, and is the first nature-themed exhibition since the museum''s establishment.</p>', 9, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'du_fu_thatched_cottage_sa_01', 'du_fu_thatched_cottage', '千诗碑廊 / Thousand Poetry Stele Corridor', '千诗碑廊 / Thousand Poetry Stele Corridor',
  NULL, '<p>The Thousand Poetry Stele Corridor is located on the east side of the central axis of Du Fu Thatched Cottage, close to the south side of the Hall of Great Elegance, and is a corridor-style building about 100 meters long. The stele corridor is composed of green bricks, green tiles and carved wooden windows, and on both sides of the corridor are inlaid with bluestone steles, on which more than 1,450 of Du Fu''s surviving poems are engraved in the form of calligraphy, which is a cultural landmark of the perfect combination of Chinese classical literature and calligraphy art. The stele calligraphy collects calligraphy works of Du Fu''s poems by calligraphy masters of all dynasties such as Su Shi, Huang Tingjian and Mi Fu of the Song Dynasty, Zhao Mengfu of the Yuan Dynasty, Dong Qichang and Wen Zhengming of the Ming Dynasty, He Shaoji and Zhao Zhiqian of the Qing Dynasty, and Yu Youren, Guo Moruo, Qi Gong, Sha Menghai of modern times, with all five scripts of seal, clerical, regular, running and cursive, making it a "small museum of Chinese calligraphy art". Walking slowly along the corridor, visitors feel as if they are strolling in the long river of history: on the left are the immortal poems of the poet saint, on the right are the brush and ink style of calligraphers, and in the middle is the sculpture group of poets in the Hall of Great Elegance. Visitors are advised to stop and appreciate in the stele corridor, each stele is a piece of history, and each calligraphy work is a kind of style.</p>', 0, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'du_fu_thatched_cottage_sa_02', 'du_fu_thatched_cottage', '南门 / South Gate', '南门 / South Gate',
  NULL, '<p>The South Gate is located on the south side of the Chengdu Du Fu Thatched Cottage Museum and is one of the secondary entrances of the cottage, mainly serving visitors entering the park from the direction of Huanhua Stream Park. The South Gate tower is in an antique architectural style, with green bricks, gray tiles and upturned eaves, echoing the main gate but more elegant and restrained. In front of the gate is close to the Huanhua Stream, with the stream water gurgling; inside the gate, bamboo shadows are dancing and the green is lush. Entering through the South Gate, visitors can directly reach the garden landscape belt connecting the south area of the cottage with Huanhua Stream Park. Compared with the main gate, the South Gate has fewer visitors and a quieter environment, making it the best entrance for visitors who want to avoid the crowds and deeply experience the quiet beauty of the cottage. Entering the park from the South Gate in the morning or evening, visitors can listen to the sound of the Huanhua Stream, watch the green bamboos swaying, and feel the poetic imagery of "The water of Huanhua Stream is at the west end, the host divined that the forest pond is quiet" (Du Fu''s "Divining Residence"). After entering from the South Gate, visitors can follow the signs northward to visit the Thatched Cottage Former Residence, Shaoling Thatched Cottage Stele Pavilion, Firewood Gate, Hall of Poetic History, and finally reach Da Xie and the main gate, taking about 2 hours in total.</p>', 1, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'du_fu_thatched_cottage_sa_03', 'du_fu_thatched_cottage', '唐代遗址 / Tang Dynasty Site', '唐代遗址 / Tang Dynasty Site',
  NULL, '<p>The Tang Dynasty Site is located at the westernmost end of the central axis of Du Fu Thatched Cottage, a Tang dynasty living site area excavated archaeologically and protected in situ. Since the 1980s, archaeologists have conducted multiple excavations within the cottage area, successively unearthing Tang dynasty house foundations, wells, porcelain, bronze ware, pottery and a large number of daily necessities, among which the location of some Tang dynasty house sites is highly consistent with the location of Du Fu''s former residence recorded in literature, providing indisputable physical evidence for the "Thatched Cottage". The site area adopts a protective display method: Tang dynasty stratigraphic sections are completely preserved and protected with glass covers, so that visitors can clearly see the original appearance of Tang dynasty architectural foundations, drainage ditches, stoves, wells and other relics. Next to the site is a small exhibition hall, which systematically displays the real life scene of Du Fu in the Chengdu Thatched Cottage through excavated artifacts, archaeological photos and literature. Here, visitors can touch the historical pulse of 1,200 years ago, making it an important place for parent-child study and in-depth understanding of Tang dynasty culture.</p>', 2, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'du_fu_thatched_cottage_sa_04', 'du_fu_thatched_cottage', '大廨 / Hall of Great Affairs (Da Xie)', '大廨 / Hall of Great Affairs (Da Xie)',
  NULL, '<p>Da Xie is located behind the Main Gate and in front of the Hall of Poetic History, serving as the first main hall on the central axis. "Xie" refers to an official residence. Du Fu once served as Left Reminder and Vice Minister of Works, hence the name "Da Xie" to highlight his official status. Da Xie was originally the Mahavira Hall of Caotang Temple and was rebuilt as a reception hall and Du Fu life exhibition hall after 1949. In the center of the hall stands a standing bronze statue of Du Fu, depicted in official robes with profound gaze; the side walls display biographical panels of Du Fu, detailing his life from "Study and Travel" to "Struggles in Chang''an" and finally to "Wandering in Southwest China". The door pillars of Da Xie feature a couplet written by Qing dynasty scholar Wanyan Chongshi: "Jin River Spring Wind you claim, Thatched Cottage Renri I return", cleverly incorporating the Chengdu custom of "Visiting Thatched Cottage on Renri" (the seventh day of the first lunar month).</p>', 3, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'du_fu_thatched_cottage_sa_05', 'du_fu_thatched_cottage', '大雅堂 / Hall of Great Elegance (Da Ya Tang)', '大雅堂 / Hall of Great Elegance (Da Ya Tang)',
  NULL, '<p>The Hall of Great Elegance is located on the east side of the central axis of Du Fu Thatched Cottage, the largest and most artistically valuable exhibition hall in the cottage. The word "Da Ya" comes from "Da Ya" of the "Book of Songs", representing the "righteous and elegant music" of the Western Zhou royal domain, symbolizing the orthodox poetics and cultural peak. The plaque "Da Ya Tang" in front of the hall is composed of characters from the famous Tang dynasty calligrapher Yan Zhenqing, full of momentum. The Hall of Great Elegance was originally the Mahavira Hall of Caotang Temple, and was officially converted into an art exhibition hall and opened to the public in 2002. The most famous art treasure in the hall is the large-scale colored glaze inlaid lacquer mural "Poets Walking and Chanting", the largest of its kind in China to date, with Du Fu''s life journey as the clue, bringing Li Bai, Wang Wei, Meng Haoran, Gao Shi, Cen Shen and other Tang dynasty poets together in one painting, with a grand picture and brilliant colors. The hall also displays 12 sculptures of famous poets of all dynasties, including Qu Yuan, Tao Yuanming, Xie Lingyun, Li Bai, Du Fu, Bai Juyi, Su Shi, Lu You, Li Qingzhao, Xin Qiji and other peak poets in the history of Chinese literature, allowing visitors to feel the long history of Chinese poetics in every step.</p>', 4, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'du_fu_thatched_cottage_sa_06', 'du_fu_thatched_cottage', '少陵草堂碑亭 / Shaoling Thatched Cottage Stele Pavilion', '少陵草堂碑亭 / Shaoling Thatched Cottage Stele Pavilion',
  NULL, '<p>The Shaoling Thatched Cottage Stele Pavilion is located east of the Gongbu Shrine and serves as the core landmark of the Du Fu Thatched Cottage park. "Shaoling" is the abbreviation of Du Fu''s self-styled name "Shaoling Yelao" (Old Man of Shaoling). There was a Shaoling Plateau in Chang''an in the Han Dynasty, and Du Fu''s ancestor Du Yu of the Xiangyang Du family was a Jinzhao Du, so he called himself "Old Man of Shaoling". The stele pavilion is a wooden hexagonal pavilion with a thatched roof, supported by 6 wooden pillars, with a gourd-shaped finial, surrounded by beauty-rest chairs, and the base is built of bluestone in a hexagonal shape. In the center of the pavilion stands a huge stone tablet, on which are engraved the four majestic characters "Shaoling Cao Tang", signed by Qing Yongzheng Emperor''s brother Prince Guo Aisin Gioro Yunli. According to legend, Yunli passed through Chengdu on his way to Tibet on imperial order, made a special pilgrimage to the cottage and wrote the inscription. The inscription is in regular script with strict structure and strong bones, making it a masterpiece among inscriptions of all dynasties. Surrounded by towering ancient trees and verdant bamboo, the pavilion is the core landscape that visitors must take photos with.</p>', 5, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'du_fu_thatched_cottage_sa_07', 'du_fu_thatched_cottage', '工部祠 / Gongbu Shrine (Ministry of Works Shrine)', '工部祠 / Gongbu Shrine (Ministry of Works Shrine)',
  NULL, '<p>The Gongbu Shrine is located behind the Firewood Gate and east of the Shaoling Thatched Cottage Stele Pavilion, the most solemn sacrificial building at the deepest part of the central axis. Du Fu once served as Vice Minister of Works (Jianxiao Gongbu Yuanwailang), commonly known as "Du Gongbu", hence the name "Gongbu Shrine". The shrine is a traditional ceremonial hall with green tiles and white walls, housing statues of Du Fu, Huang Tingjian and Lu You, commonly known as the "Hall of Three Sages". Huang Tingjian was the founder of the "Jiangxi Poetry School" of the Northern Song Dynasty, and Lu You was a patriotic poet of the Southern Song Dynasty, both of whom admired Du Fu''s poetic art. The Gongbu Shrine enshrines them on both sides of Du Fu, showing the poetic lineage of the three. The shrine is full of plaques and couplets, among which the couplet by Qing dynasty scholar Qian Baotang "Building a hut by the desolate river, you live forever; Different eras ascending the hall, these two sages" is a famous masterpiece. In front of the shrine there are incense burners and incense tables, with constant incense throughout the year, making it the core place for visitors to mourn the poet saint and express their respect.</p>', 6, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'du_fu_thatched_cottage_sa_08', 'du_fu_thatched_cottage', '柴门 / Firewood Gate', '柴门 / Firewood Gate',
  NULL, '<p>The Firewood Gate is located on the central axis after the Hall of Poetic History and before the Gongbu Shrine, serving as a landmark landscape. In ancient times, "Chai Men" referred to a simple door made of branches and thorns, often used to describe the residence of hermits or impoverished families. Du Fu wrote in his poem "Thatched Cottage" that "The four pines stand at the gate, ten thousand bamboos sparse by the steps", and in "Field House" he also wrote "The firewood gate opens toward the river unevenly", making the Firewood Gate a true reflection of the poet''s former residence. The current Firewood Gate is a low wooden gate rebuilt according to Du Fu''s poetic imagery and the style of western Sichuan folk houses, with bamboo fences and thatched cottages on both sides, and a plaque with the characters "Chai Men" on the lintel. The "low" design of the gate is intentional — visitors must lower their heads and bend over to enter, symbolizing the poet''s noble character of not pursuing power or wealth and maintaining humility. Inside the gate, bamboo shadows dance and pines and cypresses are verdant, creating a reclusive atmosphere of "building a hut in the human world without the noise of carriages and horses".</p>', 7, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'du_fu_thatched_cottage_sa_09', 'du_fu_thatched_cottage', '正门 / Main Gate', '正门 / Main Gate',
  NULL, '<p>The Main Gate is the main entrance of the Chengdu Du Fu Thatched Cottage Museum, located at the southern end of Qinghua Road and serves as the first stop for visitors. The gate tower is built in a five-pillar, three-bay Tang-style architecture with upturned eaves and grand momentum. The four golden characters "Du Fu Cao Tang" inscribed on the lintel were written by the famous writer and poet Guo Moruo in 1958, with powerful and vigorous brushstrokes, making it the most recognizable landmark of the cottage. A couplet on both sides reads: "Wanli Bridge West Residence, Baihua Pool North Villa", indicating the geographical location of the cottage. Entering the main gate, visitors can tour the Hall of Great Affairs, Hall of Poetic History, Firewood Gate, Gongbu Shrine, Shaoling Thatched Cottage Stele Pavilion, Thatched Cottage Former Residence and other attractions in turn.</p>', 8, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'du_fu_thatched_cottage_sa_10', 'du_fu_thatched_cottage', '花径 / Flower Path', '花径 / Flower Path',
  NULL, '<p>The Flower Path is located on the east side of the central axis of Du Fu Thatched Cottage, a small red wall path connecting the Hall of Poetic History and the Firewood Gate. The name "Flower Path" comes from Du Fu''s poem "The flower path has never been swept for guests, the pine door is now opened for you" ("Guest Arrival"), originally referring to the small path in front of Du Fu''s residence leading to the Firewood Gate. The current Flower Path has been renovated many times and has become the most popular internet-famous check-in point in the cottage: red walls lining the path, green bamboos shading, cherry blossoms and crabapples blooming alternately in four seasons; at the end, a screen wall is inlaid with the two characters "Cao Tang" with Qing dynasty blue and white porcelain fragments, with exquisite craftsmanship and strong classical charm. Walking slowly along the Flower Path, visitors can feel the poetic imagery of "The flower path has never been swept for guests" — from Tang to Qing, this small path has welcomed countless literati and dignitaries. In spring and summer, cherry blossoms are like snow and crabapples are like rosy clouds, making it one of the most popular Chinese-style photo spots in Chengdu; in autumn and winter, red leaves dot and wintersweet is fragrant, showing another kind of quiet beauty. It is recommended to visit in the morning or evening when the light is soft, to take the most artistic red wall flower shadow photos.</p>', 9, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'du_fu_thatched_cottage_sa_11', 'du_fu_thatched_cottage', '茅屋故居 / Thatched Cottage Former Residence', '茅屋故居 / Thatched Cottage Former Residence',
  NULL, '<p>The Thatched Cottage Former Residence is located west of the Shaoling Thatched Cottage Stele Pavilion, a landmark attraction rebuilt in 1997 based on Du Fu''s poetic imagery and the style of western Sichuan folk houses, covering an area of about 5 mu. The overall building uses traditional western Sichuan farmhouse craftsmanship of bamboo-woven mud walls and wooden windows with paper seams, the roof is covered with thatch, and the front of the door has vegetable fields enclosed by fences, connected to a pond and Huanhua Stream. The interior of the cottage is simply furnished: a thatched bed, a writing desk, brushes and inkstones, poetry manuscripts, and medicine jars are restored according to Tang dynasty life style, recreating Du Fu''s impoverished life of "No dry place at the head of the bed or under the eaves, the rain drops like hemp without ceasing". A stone statue of Du Fu stands in front of the cottage, leaning on a staff with a solemn expression, as if still worrying about the country and the people here. The cottage is surrounded by green bamboos, plum trees and peach trees, with different scenery in four seasons — peach blossoms in spring, green shade in summer, yellow chrysanthemums in autumn, plum blossoms in snow in winter. Visitors can feel the great mind of "How can I get a vast mansion of a million rooms to shelter all the poor scholars of the world with joy" here, which is the core place to experience the life scene of the poet saint.</p>', 10, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'du_fu_thatched_cottage_sa_12', 'du_fu_thatched_cottage', '草堂影壁 / Cao Tang Screen Wall (Thatched Cottage Screen Wall)', '草堂影壁 / Cao Tang Screen Wall (Thatched Cottage Screen Wall)',
  NULL, '<p>The Cao Tang Screen Wall is located at the end of the Flower Path and is one of the most popular iconic landscapes in Du Fu Thatched Cottage. The screen wall, also called the Zhaobi, is an independent wall used to block sight and decorate the facade in traditional Chinese architecture. This screen wall is built of green bricks, with the two characters "Cao Tang" inlaid in the center, each character about 1.5 meters square. The most unique feature is that the two characters "Cao Tang" use the late Qing dynasty blue and white porcelain fragment inlay technique — craftsmen carefully cut and polished hundreds of late Qing dynasty blue and white porcelain fragments, then inlaid them according to the shape of calligraphy strokes, the blue and white porcelain fragments shine in the sun, which is both simple and elegant, and is an outstanding representative of late Qing folk craft. The screen wall has a red wall behind it, facing the Flower Path in front, with green bamboos and cherry blossoms in the background, forming the most poetic picture of the cottage. Every day, a large number of visitors queue up to take photos here, capturing the Chinese-style moment when the four elements of "red wall, green tiles, porcelain shadow and flower path" are integrated, which has become one of the most representative internet-famous check-in landmarks in Chengdu.</p>', 11, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'du_fu_thatched_cottage_sa_13', 'du_fu_thatched_cottage', '诗史堂 / Hall of Poetic History', '诗史堂 / Hall of Poetic History',
  NULL, '<p>The Hall of Poetic History is located behind Da Xie and serves as the core main hall on the central axis. Du Fu''s poems truly record the historical transformation of the Tang Dynasty from prosperity to decline around the An Lushan Rebellion, and are honored as "Poetic History" by later generations, hence the name "Hall of Poetic History". The plaque "Shi Shi Tang" in front of the hall was inscribed by the famous philosopher and former Peking University President Feng Youlan in 1980. In the center of the hall is a bronze bust of Du Fu created by the famous sculptor Liu Kaiqu, with a lean face and solemn expression, embodying the spirit of caring for the country and the people. The walls on both sides of the hall are inlaid with calligraphy works of Du Fu''s representative works such as "Five Hundred Words on the Way from Chang''an to Fengxian County", "The Thatched Cottage Broken by Autumn Wind", "Climbing High", "Spring View", "Three Officials" and "Three Farewells", which is a must-see for visitors to understand the essence of Du Fu''s poetry. At the back wall of the hall is a 1:1 scale restoration of a Tang dynasty poet Du Fu walking and chanting statue.</p>', 12, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chengdu_wuhou_shrine_sa_01', 'chengdu_wuhou_shrine', 'Sanyi Temple (Chengdu Wuhou Shrine)', '三义庙（成都武侯祠）',
  NULL, '<p>Sanyi Temple, originally built in 1672 and relocated in 1998, now forms an independent courtyard at the southern end of the heritage zone. It enshrines the three sworn brothers: Liu Bei in the center, Guan Yu left, Zhang Fei right. The east/west wings display woodblock prints of Romance of the Three Kingdoms, replica weapons, and Guan Yu cultural exhibits. The temple complements the central axis''s "sovereign-minister" theme with a "brotherly loyalty" focus. Guan Yu''s birthday (24th day of 6th lunar month) features ceremonies and Sichuan-opera performances.</p>', 0, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chengdu_wuhou_shrine_sa_02', 'chengdu_wuhou_shrine', 'Second Gate & Tang Stele — Three Absolutes Stele (Chengdu Wuhou Shrine)', '二门与唐碑——三绝碑（成都武侯祠）',
  NULL, '<p>Crossing the main gate, the second gate bears Guo Moruo''s 1944 "Wuhou Shrine" plaque, echoing the main gate''s "Han Zhao Lie Miao" in the unique sovereign-minister protocol. Inside stands the "Three Absolutes Stele"—3.4m tall, 1.3m wide—composed by Prime Minister Pei Du, calligraphed by Liu Gongchuo, and carved by Lu Jian, 809 AD. The pavilion houses 20+ steles from Han to Qing dynasties, making it a one-stop showcase of 1,200 years of stone inscription. Visitors gain the key view of the central axis: Liu Bei''s hall in front, Zhuge''s hall behind.</p>', 1, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chengdu_wuhou_shrine_sa_03', 'chengdu_wuhou_shrine', 'Liu Bei''s Hall — Main Hall of Han Zhao Lie Miao (Chengdu Wuhou Shrine)', '刘备殿——汉昭烈庙正殿（成都武侯祠）',
  NULL, '<p>Liu Bei''s Hall is the 3rd bay of the central axis, ~12m high, hung with the plaque "Ye Shao Gao Guang." Centered is the gilded seated statue of Emperor Zhaolie Liu Bei—robed, holding the jade tablet, dignified—the shrine''s principal deity. Flanking the emperor are Guan Yu''s three generations (Guan Ping, Guan Xing, Zhang Zun) and Zhang Fei''s three generations (Zhang Bao, Zhang Zun); the side walls display 14 Shu Han elite statues (Zhuge Liang, Pang Tong, Zhao Yun, Ma Chao, Huang Zhong). The stone balustrade is finely carved, and the hall houses historic plaques including Zhuge Liang''s "Collection" plaque and Lu You''s poetry stele. Liu Bei''s birthday celebration is held on the 26th day of the 6th lunar month.</p>', 2, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chengdu_wuhou_shrine_sa_04', 'chengdu_wuhou_shrine', 'South Gate & Screen Wall (Chengdu Wuhou Shrine)', '南门与照壁（成都武侯祠）',
  NULL, '<p>The vermilion screen wall outside the south gate bears the black-and-gold "Han Zhao Lie Miao" plaque—signaling that this is no ordinary Zhuge shrine, but a nationally unique co-enshrinement of sovereign and minister. The wall is ~18m long and ~6m tall, built of grey brick. The south plaza, shaded by green trees, often features Sichuan-opera face-changing performers and bronze statues. The "red wall with bamboo shadow" is one of Chengdu''s most photogenic classical backdrops. During Spring Festival, the plaza hosts lantern shows and intangible-heritage markets.</p>', 3, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chengdu_wuhou_shrine_sa_05', 'chengdu_wuhou_shrine', 'Main Gate — Han Zhao Lie Miao (Chengdu Wuhou Shrine)', '大门——汉昭烈庙（成都武侯祠）',
  NULL, '<p>The main gate bears the gold character "Han Zhao Lie Miao," calligraphied by Guo Moruo in 1955. The gate is a single-eave overhanging-gable building, vermilion doors with bronze beast-head knockers, flanked by two stone lions carved in the Kangxi era. The plaque is the key to understanding the shrine''s unique layout: as minister, Zhuge Liang''s shrine should be in front, but during the early Ming the order was reversed—Emperor Liu Bei''s "Han Zhao Lie Miao" stands ahead, Zhuge''s behind. The tour officially begins here.</p>', 4, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chengdu_wuhou_shrine_sa_06', 'chengdu_wuhou_shrine', 'Hui Ling — Joint Burial Tomb of Emperor Zhaolie Liu Bei and Empresses Gan & Wu', '惠陵——蜀汉昭烈帝刘备与甘、吴二皇后合葬陵',
  NULL, '<p>Hui Ling is located at the northwest of the heritage zone, distributed in a "reverse pinwheel" layout with Han Zhao Lie Miao and Wuhou Shrine. The burial mound is ~12m high, 180m in circumference, ~3,000 sqm. Liu Bei was entombed here after his death at Baidi City in 223 AD—the tomb has never been looted in 1,780 years, protected by both the people''s loyalty and the Ming-Qing tomb guardians. The 1953 excavation of the tomb passage revealed gold, jade, swords, and horse-and-chariot artifacts. The mound, tomb passage, que-fang, and corner towers form a complete imperial-tomb architectural group.</p>', 5, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chengdu_wuhou_shrine_sa_07', 'chengdu_wuhou_shrine', 'Guihe Tower, Qin Pavilion & Garden Area (Chengdu Wuhou Shrine)', '桂荷楼、琴亭与园林区（成都武侯祠）',
  NULL, '<p>The garden area west of the main axis centers on the Guihe Pond, with the Qing-era civilian-style Guihe Tower, the hexagonal Qin Pavilion (named for Zhuge Liang''s "Empty City Strategy"), and several smaller structures—Tingli Pavilion, Bicao Xuan, a boat pavilion, and a bonsai garden. The garden employs the "borrowed scenery" technique, pulling distant views of Zhuge Liang''s Hall, Hui Ling Tomb, and the city wall into the pond''s reflections. Autumn brings osmanthus and lotus together, while winter features red plum blossoms and stone lanterns. The garden is also home to calligraphy steles of "Chu Shi Biao" and "Jie Zi Shu."</p>', 6, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chengdu_wuhou_shrine_sa_08', 'chengdu_wuhou_shrine', 'Zhuge Liang''s Hall — Jingyuan Tang (Chengdu Wuhou Shrine)', '诸葛亮殿——静远堂（成都武侯祠）',
  NULL, '<p>Zhuge Liang''s Hall, the 13m-high endpoint of the central axis, bears the Qing prince''s "Eternal Fame" plaque. Inside, three generations of the Zhuge family are enshrined as gilded statues. Above Zhuge Liang''s image is the "Yi-Zhou Sage" plaque—equating him to the legendary minister Yi Yin. The veranda displays the famous "Gongxin Couplet" by Zhao Fan (late Qing), essential for understanding Sichuan governance philosophy. The hall also houses the "Three Absolutes" original text, a Ming bronze drum, and Qing-era epigraphy exhibits.</p>', 7, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chengdu_wuhou_shrine_sa_09', 'chengdu_wuhou_shrine', 'Connecting Hall — Chu Shi Biao Stone Carving (Chengdu Wuhou Shrine)', '过厅——出师表石刻（成都武侯祠）',
  NULL, '<p>The connecting hall is the 4th bay on the central axis, functioning as a transition between Liu Bei''s and Zhuge Liang''s halls. Its south and north walls bear the "Chu Shi Biao" carvings—Yue Fei''s calligraphy of the "Former" and "Latter Memorials." Yue Fei''s running script is vigorous and powerful, bridging the two loyal figures 700 years apart. The carved plaques were re-engraved in the Guangxu era. The hall bears the "Jingyuan Tang" (Tranquility Hall) plaque, quoting Zhuge Liang''s famous injunction: "Without tranquility, one cannot achieve far-reaching goals."</p>', 8, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chengdu_wuhou_shrine_sa_10', 'chengdu_wuhou_shrine', 'Jinli Folk Street & Waterside Pavilion (Chengdu Wuhou Shrine · Folk Area)', '锦里与水榭（成都武侯祠·民俗区）',
  NULL, '<p>Jinli Folk Area, opened in 2004, is Chengdu''s first "Three Kingdoms + western Sichuan folk" themed block, ~550m long, in western Sichuan folk-house style: grey-tile white-wall houses, bluestone paths, wooden archways, and overhanging eaves along the Jinli watercourse. Three highlights: ①Snacks—over 100 Sichuan-style eateries (San Da Pao, Bo Bo Ji, etc.); ②Intangible heritage—12 western Sichuan crafts (Shu embroidery, lacquerware, silver filigree, etc.); ③Performances—three daily Sichuan-opera shows. The waterside pavilion, a riverside teahouse, offers a perfect view of Jinli and the shrine''s red wall at night. Year-round red lanterns and Three Kingdoms flags decorate the street, with over 100,000 daily visitors during Spring Festival.</p>', 9, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'qingyangg_sa_01', 'qingyangg', '三清殿 / Sanqing Hall (Three Pure Ones Hall)', '三清殿 / Sanqing Hall (Three Pure Ones Hall)',
  NULL, '<p>The Sanqing Hall is located after the Bagua Pavilion and before the Doumu Hall, and is the largest and most prestigious hall in Qingyang Palace, as well as the core main hall of the entire Qingyang Palace building complex. The Sanqing Hall is a large double-eave Xieshan-style brick and wood structure, with gray tiles, red walls, carved beams and painted rafters, magnificent and solemn. The main deities in the hall are the highest Taoist gods "Sanqing": Yuqing Yuanshi Tianzun (Heavenly Worthy of the Primordial Beginning), Shangqing Lingbao Tianzun (Heavenly Worthy of Spiritual Treasure), and Taiqing Dao De Tianzun (Heavenly Worthy of the Way and its Virtue, i.e. Laozi). The three pure ones sit side by side on a lotus platform, each Tianzun statue is several meters tall, with a peaceful expression and deep eyes. The plaque "Sanqing Hall" in the hall is written by a famous calligrapher in the Qing Dynasty, vigorous and powerful. The stone steps, moon platforms and railings in front of the Sanqing Hall are all carved from white marble, echoing the Taoist statues and painted murals in the hall, forming the most solemn and sacred sacrificial space in Qingyang Palace. Every year during major Taoist festivals such as the Spring Festival and the birthday of the Sanqing, a grand Zhaijiao ceremony will be held in front of the Sanqing Hall, which is the most concentrated place for Taoist cultural activities in Qingyang Palace. The Ming and Qing wood carvings, stone carvings and paintings inside and outside the hall are of high artistic value, and are precious objects for studying the history of Chinese Taoist architecture and art. The Sanqing Hall is the core place for visitors to understand Qingyang Palace and the highest deity system of Taoism. Visitors are advised to keep quiet and respect religious etiquette when visiting.</p>', 0, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'qingyangg_sa_02', 'qingyangg', '八卦亭 / Bagua Pavilion (Eight Trigrams Pavilion)', '八卦亭 / Bagua Pavilion (Eight Trigrams Pavilion)',
  NULL, '<p>The Bagua Pavilion is located after the Hunyuan Hall and before the Sanqing Hall, and is one of the most iconic buildings in Qingyang Palace, as well as a perfect combination of the architectural art and Taoist philosophy of Qingyang Palace. The Bagua Pavilion is a double-eave octagonal pyramidal building, and the body of the pavilion is mainly decorated with green glazed tiles - the eight sides of the pavilion roof and the eight sides of the pavilion body correspond to the eight trigrams of Qian, Kun, Zhen, Xun, Kan, Li, Gen and Dui. The center of the pavilion roof is a black and white Taiji diagram, with the Yin and Yang fish of the Taiji embracing and rotating, symbolizing the cosmic evolution of "The Tao gives birth to one, one gives birth to two, two gives birth to three, three gives birth to all things". The whole Bagua Pavilion has a unique shape and elegant color, the green glazed tiles shine in the sun, forming a sharp contrast with the surrounding red walls and gray tiles, and is a masterpiece of traditional Chinese Taoist temple architectural art. The pavilion originally enshrined a bronze statue of Laozi riding a green ox through Hangu Pass (which was moved to another place during some periods), which is the core cultural symbol of Qingyang Palace. The Bagua Pavilion is not only the visual "commanding height" of Qingyang Palace, but also carries the Taoist cosmology of "the unity of heaven and man" - visitors standing under the pavilion and looking up at the Taiji diagram can intuitively feel the core idea of "Tao follows nature" in Taoism. The square in front of the pavilion often hosts Taoist cultural exhibitions and Tai Chi performances, making it a must-visit place to experience the Taoist culture of Qingyang Palace.</p>', 1, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'qingyangg_sa_03', 'qingyangg', '山门 / Mountain Gate (Temple Gate)', '山门 / Mountain Gate (Temple Gate)',
  NULL, '<p>The Mountain Gate is the first hall-style gate after the main gate in Qingyang Palace, located between the main gate and the Lingzu Hall, and is the first gate for visitors to enter the core sacrificial area of Qingyang Palace. The Mountain Gate is a single-eave Xieshan-style building, with gray tube tile roof and vermilion red door panels, and the ridge is decorated with Taoist-style chiwen ridge beasts. The four gilded characters "Purple Air Comes from the East" are hung high on the lintel - the allusion comes from the "Liexian Zhuan" (Biographies of Immortals) in which Laozi rode the green ox westward through Hangu Pass, and Guan Ling Yinxi saw the purple air coming from the east, which is in line with the core legend of Qingyang Palace''s "Laozi''s Transformation into a Barbarian". On both sides of the gate stands a majestic stone lion, male on the left and female on the right, symbolizing the guardianship and majesty of the Taoist temple. In front of the gate, you can often see traces of men and women burning incense and paper on the floor tiles, and the air is filled with the sandalwood and the unique ancient atmosphere of the temple. The mountain gate has the ceremonial significance of "separating the secular from the sacred" in the architectural pattern of the Taoist temple. Crossing the mountain gate, you will officially enter the altar area of Qingyang Palace, and visitors should keep quiet and respect religious etiquette here. The mountain gate itself does not have a separate hall, but on both sides there are often drum towers and bell towers standing symmetrically, making it an important ceremonial space node in Qingyang Palace.</p>', 2, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'qingyangg_sa_04', 'qingyangg', '斗姥殿 / Doumu Hall (Mother of the Big Dipper Hall)', '斗姥殿 / Doumu Hall (Mother of the Big Dipper Hall)',
  NULL, '<p>The Doumu Hall is located after the Sanqing Hall and before the Jade Emperor Hall, and is one of the core halls on the central axis of Qingyang Palace. The Doumu Hall is a single-eave Xieshan-style brick and wood structure, with gray tiles, red walls, and a solemn atmosphere. The main deity in the hall is Doumu Yuanjun, also known as "Doumou Yuanjun", the highest goddess in the Taoist star worship system, who is in charge of the constellations in the sky, fertility and longevity in the mortal world. The image of Doumu Yuanjun is unique, with three faces and four heads, or three faces and eight heads, holding the sun and moon in her hands or holding the sun and moon beads, symbolizing her supreme divine power over the stars of the heavens. On both sides of the Doumu Hall are often accompanied by the "Big Dipper Seven Star Lords" - the statues of the seven star lords Tianshu, Tianxuan, Tianji, Tianquan, Yuheng, Kaiyang and Yaoguang. The Doumu Hall has a very high status in folk beliefs, and it is said that Doumu Yuanjun is one of the incarnations of the "Goddess of Child Giving", and pilgrims often pray here for offspring, health and longevity. Every year on the ninth day of the ninth lunar month, the birthday of Doumu, a grand blessing ceremony will be held in front of the hall. The Taoist statues and painted murals in the Doumu Hall are exquisite, and the stone and wood carvings outside the hall are exquisite. The Doumu Hall is a representative place to experience the Taoist star worship and female deity belief in Qingyang Palace, and is also a popular hall for visitors to pray and make wishes.</p>', 3, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'qingyangg_sa_05', 'qingyangg', '正门 / Main Gate (Front Gate)', '正门 / Main Gate (Front Gate)',
  NULL, '<p>The Main Gate is the formal entrance of the Chengdu Qingyang Palace, located on the south side of the west section of the First Ring Road, facing the city''s main road, and is magnificent. The main gate is a three-bay imitation of the official Ming and Qing style archway building, the main body is built of green bricks, covered with gray tiles and flying eaves, and the lintel has the three gilded characters "Qingyang Palace" hanging high, vigorous and simple. On both sides of the gate stands a stone carved green sheep - this is the origin of the name of Qingyang Palace: according to legend, when Laozi rode the green ox through Hangu Pass, he said "Find me in Chengdu Qingyang Market a thousand days later", and the Tang Dynasty built the temple here based on this legend. In front of the gate, the square is filled with curling incense and a crowd of visitors, and pilgrims often stop here to burn incense and pay their respects. Stepping into the main gate, you enter the outer altar area of Qingyang Palace, and you can successively pass through the Mountain Gate, Lingzu Hall, Hunyuan Hall, Bagua Pavilion, Sanqing Hall, Doumu Hall, Jade Emperor Hall and other main halls, with the central axis being symmetrical and progressive layer by layer, creating a solemn and sacred ceremonial sense of the traditional Chinese Taoist temple. The main gate is open all day, and buying a ticket to enter the park is the standard starting point for visiting Qingyang Palace.</p>', 4, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'qingyangg_sa_06', 'qingyangg', '混元殿 / Hunyuan Hall (Primordial Chaos Hall)', '混元殿 / Hunyuan Hall (Primordial Chaos Hall)',
  NULL, '<p>The Hunyuan Hall is located after the Lingzu Hall and before the Bagua Pavilion, and is the second main hall on the central axis of Qingyang Palace. The Hunyuan Hall was first built in the Ming Dynasty and rebuilt during the Kangxi period of the Qing Dynasty. It is one of the oldest and most historically valuable halls in Qingyang Palace. The word "Hunyuan" comes from the Taoist classic "Dao De Jing" (Tao Te Ching) "The Tao gives birth to one, one gives birth to two, two gives birth to three, three gives birth to all things" cosmology, symbolizing the original state of heaven and earth not yet divided and chaos at the beginning. The main deity in the hall is the "Dao De Tianzun" (Heavenly Worthy of the Way and its Virtue), one of the "Sanqing" in Taoism, i.e. Laozi Li Er, the philosopher of the Spring and Autumn Period. In the center of the hall, a bronze statue of Laozi is enshrined, holding a ruyi in his left hand and pressing his knee with his right hand, looking peaceful. The statue of Laozi is one of the treasures of Qingyang Palace, and it is said that on the 15th day of the second lunar month, the birthday of Laozi, a grand birthday ceremony will be held in the palace. The Hunyuan Hall is a single-eave Xieshan-style building, with exquisite Taoist ridge beasts on the roof, and the wood carvings, brick carvings and stone carvings inside and outside the hall are exquisite, integrating the architectural aesthetics of the Ming and Qing dynasties. In front of the Hunyuan Hall, Taoists often chant sutras and confess here, which is an important place to experience the core connotation of the Taoist culture of Qingyang Palace.</p>', 5, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'qingyangg_sa_07', 'qingyangg', '灵祖殿 / Lingzu Hall (Patriarch Hall)', '灵祖殿 / Lingzu Hall (Patriarch Hall)',
  NULL, '<p>The Lingzu Hall is located after the Mountain Gate and before the Hunyuan Hall, and is the first main hall on the central axis of Qingyang Palace, as well as the first large hall that visitors see after entering the core sacrificial area of Qingyang Palace. The Lingzu Hall is a single-eave Xieshan-style brick and wood structure, with gray tiles, red walls, flying eaves, five bays wide, and a solemn atmosphere. The main worship in the hall is the Taoist "Sanqing" one of the "Lingbao Tianzun" (Heavenly Worthy of Spiritual Treasure), also known as "Shangqing Lingbao Tianzun", one of the highest deities in Taoism. The two sides of the Lingzu Hall are often accompanied by Taoist Dharma protector generals, with various shapes and exquisite painted statues. In front of the hall, there is a large incense burner, where pilgrims and visitors burn incense to worship and pray for blessings. The Lingzu Hall plays a transitional role in the overall architectural pattern of Qingyang Palace - it not only continues the "separation of secular and sacred" of the mountain gate, but also paves the way for the rituals of the Hunyuan Hall, Sanqing Hall and other main halls behind. The plaques and couplets inside and outside the hall are mostly written by famous Qing dynasty calligraphers, containing rich Taoist cultural connotations. The Lingzu Hall has been bustling with incense all year round, and is an important place to experience the Taoist atmosphere of Qingyang Palace and understand Taoist etiquette.</p>', 6, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'qingyangg_sa_08', 'qingyangg', '玉皇殿（福禄寿照壁）/ Jade Emperor Hall (Fulu Shou Screen Wall)', '玉皇殿（福禄寿照壁）/ Jade Emperor Hall (Fulu Shou Screen Wall)',
  NULL, '<p>The Jade Emperor Hall is located after the Doumu Hall and before the Descent Birth Platform and Preaching Platform, and is the last main hall on the central axis of Qingyang Palace. The Jade Emperor Hall is a double-eave Xieshan-style brick and wood structure, with gray tiles, red walls and a grand scale. The main deity in the hall is the Jade Emperor - one of the highest deities in the Taoist pantheon, second only to "Sanqing", who is in charge of the three realms and ten directions, the master of all gods, so it is also called "Tiangong" (Lord of Heaven). In front of the Jade Emperor Hall is an exquisite screen wall called the "Fulu Shou Screen Wall", which is the most popular blessing check-in landscape in Qingyang Palace. The screen wall is built of green bricks, with the three characters "Fulu Shou" inlaid in the center. "Fu" represents good fortune and well-being, "Lu" represents fame and salary, and "Shou" represents longevity and well-being - the three characters together represent the three most simple and beautiful wishes of the Chinese people. The three characters "Fulu Shou" use the same late Qing dynasty blue and white porcelain fragment inlay technique as the "Caotang" Screen Wall of Du Fu Thatched Cottage. Craftsmen cut and polished hundreds of blue and white porcelain fragments and then inlaid them together. The blue and white porcelain fragments shine in the sun, which is an outstanding representative of late Qing folk craft. Many visitors queue up here to take photos and touch the word "Fu" to pray for good luck. The Jade Emperor Hall is the "finale" of the Qingyang Palace building complex, and a grand birthday ceremony will be held every year on the ninth day of the first lunar month, the birthday of the Jade Emperor.</p>', 7, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'qingyangg_sa_09', 'qingyangg', '紫金台（唐王殿）/ Purple Gold Platform (Tang King Hall)', '紫金台（唐王殿）/ Purple Gold Platform (Tang King Hall)',
  NULL, '<p>The Purple Gold Platform, also known as the Tang King Hall, is located after the Descent Birth Platform and Preaching Platform, and is one of the most historically legendary commemorative buildings at the westernmost end of Qingyang Palace. The origin of the Purple Gold Platform is closely related to Emperor Xuanzong of Tang Li Longji: it is said that during the Anshi Rebellion (after 755 AD), Tang Xuanzong took refuge in Shu, once stayed in Qingyang Palace, and dreamed of Laozi appearing at night in the palace, telling him an omen of peace in the world. Tang Xuanzong, in gratitude for Laozi''s kindness, ordered the rebuilding of Qingyang Palace and built the Purple Gold Platform here in commemoration. The Purple Gold Platform is a high-platform building built of green bricks, on which there were originally portraits or statues of Tang Xuanzong, some of which were lost due to age, but the platform base, steps and pattern are still clearly visible. In front of the platform, there are often stone inscription steles recording the legend of Tang Xuanzong''s visit to Shu and the historical evolution of Qingyang Palace. The Purple Gold Platform has a "finale" status in the architectural pattern of Qingyang Palace - it is not only the end of the Taoist cultural narrative of Qingyang Palace (the spread of Laozi''s thought), but also the node of the historical narrative of Qingyang Palace (Tang Xuanzong''s visit to Shu), connecting the Taoist legend and historical truth. The Purple Gold Platform is often visited by tourists, and is a representative place in Qingyang Palace to understand the history of the Tang Dynasty and the interaction between emperors and Taoism. The whole Purple Gold Platform is not large in scale but has profound cultural connotations, and is the "finale" scenic spot on the tour route of Qingyang Palace.</p>', 8, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'qingyangg_sa_10', 'qingyangg', '茶园与老庄书院 / Tea Garden and Laozhuang Academy (Lao-Zhuang Academy)', '茶园与老庄书院 / Tea Garden and Laozhuang Academy (Lao-Zhuang Academy)',
  NULL, '<p>The Tea Garden and Laozhuang Academy are located in the middle and rear of the Qingyang Palace building complex, near the back gate of Qingyang Palace, and are the most leisurely characteristic cultural space in Qingyang Palace. The Tea Garden is a typical Sichuan-Western folk-style teahouse building, with green bricks, gray tiles, rattan chairs, bamboo tables, and green plants. The tea garden provides authentic Chengdu gaiwan tea (Bitan Piaoxue, Zhuyeqing, etc.), Sichuan-Western snacks (San Da Pao, Zhong Dumplings, Lai Tangyuan, Fuqi Feipian, etc.), Sichuan-style cold dishes and health tea. Visitors can rest in the tea garden after visiting the halls, brew a pot of tea, taste some snacks, listen to a section of Sichuan opera Qingyin, watch a tea art performance, and experience the most authentic "teahouse culture" in Chengdu. The Laozhuang Academy is adjacent to the tea garden and is a special academic space for displaying, researching and disseminating Taoist culture in Qingyang Palace. The academy is named after the two representative figures of Taoism - Laozi (Li Er) and Zhuangzi (Zhuang Zhou). The academy has a collection of Taoist classic versions such as the "Tao Te Ching" and "Zhuangzi", Taoist calligraphy stone inscriptions and rubbings from past dynasties, and books on Taoist culture research. The cloister outside the academy often has calligraphy exhibitions, displaying calligraphy works of famous Taoist articles. The Tea Garden and the Laozhuang Academy together form a "dynamic-static" combination of leisure and cultural system in Qingyang Palace - the halls are "dynamic" religious and cultural spaces, and the tea garden and academy are "static" cultural leisure spaces, allowing visitors to find a quiet place in the hustle and bustle of the city after pilgrimage and worship, and experience the "Taoist slow life".</p>', 9, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'qingyangg_sa_11', 'qingyangg', '降生台与说法台 / Descent Birth Platform and Preaching Platform', '降生台与说法台 / Descent Birth Platform and Preaching Platform',
  NULL, '<p>The Descent Birth Platform and Preaching Platform are located after the Jade Emperor Hall and before the Purple Gold Platform, and are two commemorative buildings with profound cultural connotations in Qingyang Palace. The Descent Birth Platform is a commemorative building in Qingyang Palace for the birth of Laozi. According to legend, Laozi Li Er was born in Ku County, Chu State (now Luyi, Henan). In order to commemorate this "Taoist Master" and promote Taoist culture, the Taoists of later generations specially built this platform in Qingyang Palace. The Descent Birth Platform is a high platform built of green bricks, on which there were originally sculptures or murals on the theme of the birth legend of Laozi, some of which were lost due to age, but the platform base and pattern are still clearly visible, and it is an important part of the "Laozi''s Transformation into a Barbarian" cultural narrative of Qingyang Palace. The Preaching Platform is adjacent to the Descent Birth Platform, built to commemorate Laozi''s westward journey through Hangu Pass and his writing of the 5,000-character Tao Te Ching at the request of Guan Ling Yinxi. The platform originally had a statue of Laozi riding a green ox out of the pass with "purple air coming from the east" or related stone carvings, symbolizing the spread and dissemination of Taoist thought. The two platforms stand side by side in the east and west, complementing each other, and together tell the complete narrative of Laozi from birth, cultivation to the creation of Taoist philosophy, which is the core memorial space of the Taoist history and culture of Qingyang Palace. Visitors can stop here and deeply feel the philosophical mood of "Tao follows nature" and "do nothing and everything is done", which is a must-visit place to experience the deep connotation of the Taoist culture of Qingyang Palace.</p>', 10, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'wenshuyuan_sa_01', 'wenshuyuan', '', '三大士殿（观音殿）',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/wenshuyuan_sa_01.jpg', '', 0, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'wenshuyuan_sa_02', 'wenshuyuan', '', '千佛和平塔与碑廊',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/wenshuyuan_sa_02.jpg', '', 1, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'wenshuyuan_sa_03', 'wenshuyuan', '', '园林与放生池',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/wenshuyuan_sa_03.jpg', '', 2, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'wenshuyuan_sa_04', 'wenshuyuan', '', '大雄宝殿',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/wenshuyuan_sa_04.png', '', 3, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'wenshuyuan_sa_05', 'wenshuyuan', '', '山门（天王殿）',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/wenshuyuan_sa_05.jpg', '', 4, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'wenshuyuan_sa_06', 'wenshuyuan', '', '文殊阁',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/wenshuyuan_sa_06.png', '', 5, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'wenshuyuan_sa_07', 'wenshuyuan', '', '正门（照壁）',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/wenshuyuan_sa_07.jpg', '', 6, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'wenshuyuan_sa_08', 'wenshuyuan', '', '茶园与香斋堂',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/wenshuyuan_sa_08.jpg', '', 7, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'wenshuyuan_sa_09', 'wenshuyuan', '', '藏经楼（宸经楼）',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/wenshuyuan_sa_09.jpg', '', 8, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'wenshuyuan_sa_10', 'wenshuyuan', '', '说法堂（药师殿）',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/wenshuyuan_sa_10.jpg', '', 9, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_jiujie_sa_01', 'chongqing_jiujie', '1', '1.九街标志牌坊',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_jiujie_sa_01.jpg', '', 0, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_jiujie_sa_02', 'chongqing_jiujie', '2', '2.九街高屋',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_jiujie_sa_02.jpg', '', 1, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_jiujie_sa_03', 'chongqing_jiujie', '3 42', '3.鲤鱼池42号文创园',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_jiujie_sa_03.jpg', '', 2, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_jiujie_sa_04', 'chongqing_jiujie', '4', '4.九街后街',
  NULL, '', 3, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_shibati_sa_01', 'chongqing_shibati', '1', '1.十八梯大牌坊',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_shibati_sa_01.png', '', 0, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_shibati_sa_02', 'chongqing_shibati', '2', '2.善果巷与山城记忆馆',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_shibati_sa_02.png', '', 1, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_shibati_sa_03', 'chongqing_shibati', '3', '3.月台坝（山地院落）',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_shibati_sa_03.png', '', 2, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_shibati_sa_04', 'chongqing_shibati', '4', '4.大隧道遗址',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_shibati_sa_04.png', '', 3, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_dazu_rock_carvings_sa_01', 'chongqing_dazu_rock_carvings', '1', '1.宝顶山',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_dazu_rock_carvings_sa_01.jpg', '', 0, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_dazu_rock_carvings_sa_02', 'chongqing_dazu_rock_carvings', '2', '2.北山景区',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_dazu_rock_carvings_sa_02.jpg', '', 1, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_dazu_rock_carvings_sa_03', 'chongqing_dazu_rock_carvings', '3', '3.大足石刻博物馆',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_dazu_rock_carvings_sa_03.jpg', '', 2, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_dazu_rock_carvings_sa_04', 'chongqing_dazu_rock_carvings', '4', '4.南山景区',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_dazu_rock_carvings_sa_04.jpg', '', 3, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_dazu_rock_carvings_sa_05', 'chongqing_dazu_rock_carvings', '5', '5.石门山景区',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_dazu_rock_carvings_sa_05.png', '', 4, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_dazu_rock_carvings_sa_06', 'chongqing_dazu_rock_carvings', '6', '6.石篆山',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_dazu_rock_carvings_sa_06.jpg', '', 5, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_mountain_trails_sa_01', 'chongqing_mountain_trails', '1', '1.步道入口牌坊',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_mountain_trails_sa_01.png', '', 0, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_mountain_trails_sa_02', 'chongqing_mountain_trails', '2', '2.厚庐',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_mountain_trails_sa_02.png', '', 1, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_mountain_trails_sa_03', 'chongqing_mountain_trails', '3', '3.悬空栈道',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_mountain_trails_sa_03.png', '', 2, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_mountain_trails_sa_04', 'chongqing_mountain_trails', '4', '4.仁爱荒野剧场',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_mountain_trails_sa_04.png', '', 3, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_liziba_monorail_sa_01', 'chongqing_liziba_monorail', '1 1', '1.轨道李子坝站1号出口',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_liziba_monorail_sa_01.png', '', 0, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_liziba_monorail_sa_02', 'chongqing_liziba_monorail', '2', '2.李子坝观景平台',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_liziba_monorail_sa_02.png', '', 1, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_liziba_monorail_sa_03', 'chongqing_liziba_monorail', '3', '3.岩之魂浮雕文化墙',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_liziba_monorail_sa_03.png', '', 2, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_liziba_monorail_sa_04', 'chongqing_liziba_monorail', '4', '4.文旅服务中心',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_liziba_monorail_sa_04.png', '', 3, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_liziba_monorail_sa_05', 'chongqing_liziba_monorail', '5', '5.巴渝旧闻馆',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_liziba_monorail_sa_05.png', '', 4, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_liziba_monorail_sa_06', 'chongqing_liziba_monorail', '6', '6.轨道穿楼主体建筑',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_liziba_monorail_sa_06.png', '', 5, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_raffles_city_sa_01', 'chongqing_raffles_city', '1', '1.朝天门广场与两江交汇',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_raffles_city_sa_01.png', '', 0, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_raffles_city_sa_02', 'chongqing_raffles_city', '2', '2.购物中心中庭与山城花园',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_raffles_city_sa_02.png', '', 1, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_raffles_city_sa_03', 'chongqing_raffles_city', '3', '3.水晶连廊（探索舱·观景台）',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_raffles_city_sa_03.png', '', 2, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_raffles_city_sa_04', 'chongqing_raffles_city', '4', '4.探索舱·云端乐园',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_raffles_city_sa_04.png', '', 3, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_wulong_karst_sa_01', 'chongqing_wulong_karst', '1', '1.天龙桥',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_wulong_karst_sa_01.png', '', 0, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_wulong_karst_sa_02', 'chongqing_wulong_karst', '10', '10.仙女山国家公园-木梯子站',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_wulong_karst_sa_02.png', '', 1, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_wulong_karst_sa_03', 'chongqing_wulong_karst', '11', '11.仙女山国家公园-大草原站',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_wulong_karst_sa_03.png', '', 2, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_wulong_karst_sa_04', 'chongqing_wulong_karst', '2', '2.天官赐福',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_wulong_karst_sa_04.png', '', 3, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_wulong_karst_sa_05', 'chongqing_wulong_karst', '3', '3.青龙桥',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_wulong_karst_sa_05.png', '', 4, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_wulong_karst_sa_06', 'chongqing_wulong_karst', '4', '4.神鹰天坑',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_wulong_karst_sa_06.png', '', 5, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_wulong_karst_sa_07', 'chongqing_wulong_karst', '5', '5.黑龙桥',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_wulong_karst_sa_07.png', '', 6, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_wulong_karst_sa_08', 'chongqing_wulong_karst', '6', '6.龙泉洞',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_wulong_karst_sa_08.png', '', 7, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_wulong_karst_sa_09', 'chongqing_wulong_karst', '7', '7.龙水峡地缝',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_wulong_karst_sa_09.png', '', 8, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_wulong_karst_sa_10', 'chongqing_wulong_karst', '8', '8.银河飞瀑',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_wulong_karst_sa_10.png', '', 9, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_wulong_karst_sa_11', 'chongqing_wulong_karst', '9', '9.蛟龙寒窟',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_wulong_karst_sa_11.png', '', 10, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_hongya_cave_sa_01', 'chongqing_hongya_cave', '1', '1.重庆洪崖洞民俗风貌区',
  NULL, '', 0, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_hongya_cave_sa_02', 'chongqing_hongya_cave', '10', '10.六楼：光影互动艺术空间',
  NULL, '', 1, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_hongya_cave_sa_03', 'chongqing_hongya_cave', '11 1980', '11.五楼：重逢1980·八十年代生活情境街区',
  NULL, '', 2, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_hongya_cave_sa_04', 'chongqing_hongya_cave', '12', '12.四楼：盛宴美食街',
  NULL, '', 3, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_hongya_cave_sa_05', 'chongqing_hongya_cave', '13', '13.三楼：天成巷巴渝风情街',
  NULL, '', 4, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_hongya_cave_sa_06', 'chongqing_hongya_cave', '14', '14.二楼：纸盐河动感酒吧街',
  NULL, '', 5, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_hongya_cave_sa_07', 'chongqing_hongya_cave', '15', '15.一楼：滴翠广场',
  NULL, '', 6, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_hongya_cave_sa_08', 'chongqing_hongya_cave', '2', '2.城市阳台',
  NULL, '', 7, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_hongya_cave_sa_09', 'chongqing_hongya_cave', '3', '3.辛亥丰碑',
  NULL, '', 8, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_hongya_cave_sa_10', 'chongqing_hongya_cave', '4', '4.记忆山城雕塑',
  NULL, '', 9, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_hongya_cave_sa_11', 'chongqing_hongya_cave', '5', '5.江隘炮台铜雕',
  NULL, '', 10, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_hongya_cave_sa_12', 'chongqing_hongya_cave', '6', '6.十楼：巴文化柱',
  NULL, '', 11, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_hongya_cave_sa_13', 'chongqing_hongya_cave', '7', '7.九楼：异域风情街',
  NULL, '', 12, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_hongya_cave_sa_14', 'chongqing_hongya_cave', '8 78', '8.八楼：78区潮玩世界',
  NULL, '', 13, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_hongya_cave_sa_15', 'chongqing_hongya_cave', '9 78', '9.七楼：78区潮玩世界',
  NULL, '', 14, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_baixiangju_sa_01', 'chongqing_baixiangju', '1 1', '1.1层临江入口（起点）',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_baixiangju_sa_01.png', '', 0, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_baixiangju_sa_02', 'chongqing_baixiangju', '2 10', '2.10层空中公共连廊',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_baixiangju_sa_02.png', '', 1, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_baixiangju_sa_03', 'chongqing_baixiangju', '3', '3.长江索道同框观景窗',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_baixiangju_sa_03.png', '', 2, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_baixiangju_sa_04', 'chongqing_baixiangju', '4 15', '4.15层解放东路出口（终点）',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_baixiangju_sa_04.png', '', 3, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_ciqikou_old_town_sa_01', 'chongqing_ciqikou_old_town', '1', '1.黄桷坪牌坊',
  NULL, '', 0, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_ciqikou_old_town_sa_02', 'chongqing_ciqikou_old_town', '10', '10.磁器长歌体验馆',
  NULL, '', 1, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_ciqikou_old_town_sa_03', 'chongqing_ciqikou_old_town', '2', '2.钟家院',
  NULL, '', 2, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_ciqikou_old_town_sa_04', 'chongqing_ciqikou_old_town', '3', '3.宝善宫',
  NULL, '', 3, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_ciqikou_old_town_sa_05', 'chongqing_ciqikou_old_town', '4', '4.鑫记杂货铺',
  NULL, '', 4, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_ciqikou_old_town_sa_06', 'chongqing_ciqikou_old_town', '5', '5.聚森茂酱园旧址',
  NULL, '', 5, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_ciqikou_old_town_sa_07', 'chongqing_ciqikou_old_town', '6', '6.磁横街',
  NULL, '', 6, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_ciqikou_old_town_sa_08', 'chongqing_ciqikou_old_town', '7', '7.宝轮寺',
  NULL, '', 7, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_ciqikou_old_town_sa_09', 'chongqing_ciqikou_old_town', '8', '8.迎龙门码头',
  NULL, '', 8, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_ciqikou_old_town_sa_10', 'chongqing_ciqikou_old_town', '9', '9.九石缸河滩',
  NULL, '', 9, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_guanyinqiao_sa_01', 'chongqing_guanyinqiao', '1', '1.观音桥步行街广场',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_guanyinqiao_sa_01.jpg', '', 0, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_guanyinqiao_sa_02', 'chongqing_guanyinqiao', '2 3d', '2.茂业天地“裸眼3D”大屏',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_guanyinqiao_sa_02.jpg', '', 1, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_guanyinqiao_sa_03', 'chongqing_guanyinqiao', '3', '3.观音桥雕塑（城市标志）',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_guanyinqiao_sa_03.jpg', '', 2, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_guanyinqiao_sa_04', 'chongqing_guanyinqiao', '4', '4.北城天街',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_guanyinqiao_sa_04.jpg', '', 3, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_guanyinqiao_sa_05', 'chongqing_guanyinqiao', '5', '5.观音桥九街（不夜九街 - 终点）',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_guanyinqiao_sa_05.jpg', '', 4, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_jiefangbei_sa_01', 'chongqing_jiefangbei', '1', '1.解放碑广场',
  NULL, '', 0, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_jiefangbei_sa_02', 'chongqing_jiefangbei', '2', '2.解放碑纪念碑',
  NULL, '', 1, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_jiefangbei_sa_03', 'chongqing_jiefangbei', '3', '3.解放碑步行街雕塑群',
  NULL, '', 2, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_jiefangbei_sa_04', 'chongqing_jiefangbei', '4', '4.邹容路步行街',
  NULL, '', 3, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_jiefangbei_sa_05', 'chongqing_jiefangbei', '5', '5.八一路好吃街',
  NULL, '', 4, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_jiefangbei_sa_06', 'chongqing_jiefangbei', '6', '6.环球金融中心会仙楼观景台',
  NULL, '', 5, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_zoo_sa_01', 'chongqing_zoo', '1', '1.大门广场（起点）',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_zoo_sa_01.jpg', '', 0, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_zoo_sa_02', 'chongqing_zoo', '2', '2.熊猫馆',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_zoo_sa_02.jpg', '', 1, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_zoo_sa_03', 'chongqing_zoo', '3', '3.金鱼馆',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_zoo_sa_03.jpg', '', 2, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_zoo_sa_04', 'chongqing_zoo', '4', '4.两栖爬行动物馆',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_zoo_sa_04.jpg', '', 3, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_zoo_sa_05', 'chongqing_zoo', '5', '5.鸟类区',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_zoo_sa_05.jpg', '', 4, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_jinfo_mountain_sa_01', 'chongqing_jinfo_mountain', '1', '1.大门',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_jinfo_mountain_sa_01.jpg', '', 0, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_jinfo_mountain_sa_02', 'chongqing_jinfo_mountain', '10', '10.药池坝',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_jinfo_mountain_sa_02.jpg', '', 1, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_jinfo_mountain_sa_03', 'chongqing_jinfo_mountain', '11', '11.古佛洞',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_jinfo_mountain_sa_03.jpg', '', 2, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_jinfo_mountain_sa_04', 'chongqing_jinfo_mountain', '12', '12.金佛顶',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_jinfo_mountain_sa_04.jpg', '', 3, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_jinfo_mountain_sa_05', 'chongqing_jinfo_mountain', '13', '13.生态石林',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_jinfo_mountain_sa_05.jpg', '', 4, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_jinfo_mountain_sa_06', 'chongqing_jinfo_mountain', '14', '14.西门索道下站',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_jinfo_mountain_sa_06.jpg', '', 5, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_jinfo_mountain_sa_07', 'chongqing_jinfo_mountain', '15', '15.西门游客中心',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_jinfo_mountain_sa_07.jpg', '', 6, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_jinfo_mountain_sa_08', 'chongqing_jinfo_mountain', '2', '2.碧潭幽谷',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_jinfo_mountain_sa_08.jpg', '', 7, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_jinfo_mountain_sa_09', 'chongqing_jinfo_mountain', '3', '3.索道下站',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_jinfo_mountain_sa_09.jpg', '', 8, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_jinfo_mountain_sa_10', 'chongqing_jinfo_mountain', '4', '4.牵牛坪天街',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_jinfo_mountain_sa_10.png', '', 9, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_jinfo_mountain_sa_11', 'chongqing_jinfo_mountain', '5', '5.箭竹林海',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_jinfo_mountain_sa_11.png', '', 10, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_jinfo_mountain_sa_12', 'chongqing_jinfo_mountain', '6', '6.金龟朝阳',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_jinfo_mountain_sa_12.jpg', '', 11, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_jinfo_mountain_sa_13', 'chongqing_jinfo_mountain', '7', '7.云端步道',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_jinfo_mountain_sa_13.jpg', '', 12, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_jinfo_mountain_sa_14', 'chongqing_jinfo_mountain', '8', '8.燕子洞和灵观洞',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_jinfo_mountain_sa_14.jpg', '', 13, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_jinfo_mountain_sa_15', 'chongqing_jinfo_mountain', '9', '9.杜鹃王子',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_jinfo_mountain_sa_15.jpg', '', 14, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_yangtze_cableway_sa_01', 'chongqing_yangtze_cableway', '1', '1.北站（渝中区新华路站）',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_yangtze_cableway_sa_01.png', '', 0, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_yangtze_cableway_sa_02', 'chongqing_yangtze_cableway', '2', '2.索道轿厢',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_yangtze_cableway_sa_02.png', '', 1, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_yangtze_cableway_sa_03', 'chongqing_yangtze_cableway', '3', '3.南站（南岸区龙门浩站）',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_yangtze_cableway_sa_03.png', '', 2, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_eling_2nd_factory_sa_01', 'chongqing_eling_2nd_factory', '1', '1.大门',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_eling_2nd_factory_sa_01.jpg', '', 0, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_eling_2nd_factory_sa_02', 'chongqing_eling_2nd_factory', '10', '10.螺旋楼梯和涂鸦巷',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_eling_2nd_factory_sa_02.png', '', 1, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_eling_2nd_factory_sa_03', 'chongqing_eling_2nd_factory', '11', '11.巨型拉链雕塑',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_eling_2nd_factory_sa_03.jpg', '', 2, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_eling_2nd_factory_sa_04', 'chongqing_eling_2nd_factory', '12', '12.下沉广场',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_eling_2nd_factory_sa_04.png', '', 3, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_eling_2nd_factory_sa_05', 'chongqing_eling_2nd_factory', '13', '13.重庆书局',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_eling_2nd_factory_sa_05.jpg', '', 4, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_eling_2nd_factory_sa_06', 'chongqing_eling_2nd_factory', '14', '14.你好童年怀旧馆',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_eling_2nd_factory_sa_06.png', '', 5, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_eling_2nd_factory_sa_07', 'chongqing_eling_2nd_factory', '2', '2.二厂记忆博物馆',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_eling_2nd_factory_sa_07.jpg', '', 6, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_eling_2nd_factory_sa_08', 'chongqing_eling_2nd_factory', '3 9', '3.民国中央银行印钞厂旧址（9号楼）',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_eling_2nd_factory_sa_08.jpg', '', 7, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_eling_2nd_factory_sa_09', 'chongqing_eling_2nd_factory', '4 test design', '4.Test Design街巷',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_eling_2nd_factory_sa_09.jpg', '', 8, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_eling_2nd_factory_sa_10', 'chongqing_eling_2nd_factory', '5 test joy', '5.Test Joy街巷',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_eling_2nd_factory_sa_10.png', '', 9, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_eling_2nd_factory_sa_11', 'chongqing_eling_2nd_factory', '6 test spirit', '6.Test Spirit街巷',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_eling_2nd_factory_sa_11.jpg', '', 10, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_eling_2nd_factory_sa_12', 'chongqing_eling_2nd_factory', '7 t', '7.T²国际当代艺术中心',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_eling_2nd_factory_sa_12.jpg', '', 11, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_eling_2nd_factory_sa_13', 'chongqing_eling_2nd_factory', '8 city radio', '8.爱情天台（CITY-RADIO电台墙）',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_eling_2nd_factory_sa_13.jpg', '', 12, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, sort_order, is_active, requires_purchase
) VALUES (
  'chongqing_eling_2nd_factory_sa_14', 'chongqing_eling_2nd_factory', '9', '9.云上天台',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/all/chongqing_eling_2nd_factory_sa_14.png', '', 13, TRUE, FALSE
) ON CONFLICT (id) DO UPDATE SET
  name_en=EXCLUDED.name_en,
  name_zh=EXCLUDED.name_zh,
  cover_image_path=COALESCE(EXCLUDED.cover_image_path, sub_areas.cover_image_path),
  body=EXCLUDED.body,
  sort_order=EXCLUDED.sort_order,
  is_active=EXCLUDED.is_active,
  requires_purchase=EXCLUDED.requires_purchase,
  updated_at=NOW();

INSERT INTO common_phrases (id, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES ('phrase_common_001', '你好', '你好', 'Hello', 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_common_001.mp3', 0, TRUE)
ON CONFLICT (id) DO UPDATE SET
  cn=EXCLUDED.cn,pinyin=EXCLUDED.pinyin,en=EXCLUDED.en,audio_url=EXCLUDED.audio_url,sort_order=EXCLUDED.sort_order,is_active=EXCLUDED.is_active,updated_at=NOW();

INSERT INTO common_phrases (id, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES ('phrase_common_002', '谢谢', '谢谢', 'Thank you', 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_common_002.mp3', 1, TRUE)
ON CONFLICT (id) DO UPDATE SET
  cn=EXCLUDED.cn,pinyin=EXCLUDED.pinyin,en=EXCLUDED.en,audio_url=EXCLUDED.audio_url,sort_order=EXCLUDED.sort_order,is_active=EXCLUDED.is_active,updated_at=NOW();

INSERT INTO common_phrases (id, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES ('phrase_common_003', '不好意思', '不好意思', 'Excuse me / Sorry', 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_common_003.mp3', 2, TRUE)
ON CONFLICT (id) DO UPDATE SET
  cn=EXCLUDED.cn,pinyin=EXCLUDED.pinyin,en=EXCLUDED.en,audio_url=EXCLUDED.audio_url,sort_order=EXCLUDED.sort_order,is_active=EXCLUDED.is_active,updated_at=NOW();

INSERT INTO common_phrases (id, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES ('phrase_common_004', '我听不懂', '我听不懂', 'I don''t understand', 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_common_004.mp3', 3, TRUE)
ON CONFLICT (id) DO UPDATE SET
  cn=EXCLUDED.cn,pinyin=EXCLUDED.pinyin,en=EXCLUDED.en,audio_url=EXCLUDED.audio_url,sort_order=EXCLUDED.sort_order,is_active=EXCLUDED.is_active,updated_at=NOW();

INSERT INTO common_phrases (id, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES ('phrase_common_005', '我不会说中文', '我不会说中文', 'I don''t speak Chinese', 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_common_005.mp3', 4, TRUE)
ON CONFLICT (id) DO UPDATE SET
  cn=EXCLUDED.cn,pinyin=EXCLUDED.pinyin,en=EXCLUDED.en,audio_url=EXCLUDED.audio_url,sort_order=EXCLUDED.sort_order,is_active=EXCLUDED.is_active,updated_at=NOW();

INSERT INTO common_phrases (id, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES ('phrase_common_006', '请说慢一点', '请说慢一点', 'Please speak slowly', 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_common_006.mp3', 5, TRUE)
ON CONFLICT (id) DO UPDATE SET
  cn=EXCLUDED.cn,pinyin=EXCLUDED.pinyin,en=EXCLUDED.en,audio_url=EXCLUDED.audio_url,sort_order=EXCLUDED.sort_order,is_active=EXCLUDED.is_active,updated_at=NOW();

INSERT INTO common_phrases (id, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES ('phrase_common_007', '请帮我写下来，谢谢', '请帮我写下来，谢谢', 'Please write it down for me', 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_common_007.mp3', 6, TRUE)
ON CONFLICT (id) DO UPDATE SET
  cn=EXCLUDED.cn,pinyin=EXCLUDED.pinyin,en=EXCLUDED.en,audio_url=EXCLUDED.audio_url,sort_order=EXCLUDED.sort_order,is_active=EXCLUDED.is_active,updated_at=NOW();

INSERT INTO common_phrases (id, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES ('phrase_common_008', '你会说英语吗？', '你会说英语吗？', 'Do you speak English?', 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_common_008.mp3', 7, TRUE)
ON CONFLICT (id) DO UPDATE SET
  cn=EXCLUDED.cn,pinyin=EXCLUDED.pinyin,en=EXCLUDED.en,audio_url=EXCLUDED.audio_url,sort_order=EXCLUDED.sort_order,is_active=EXCLUDED.is_active,updated_at=NOW();

INSERT INTO common_phrases (id, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES ('phrase_common_009', '我要去这个地址', '我要去这个地址', 'I want to go to this address', 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_common_009.mp3', 8, TRUE)
ON CONFLICT (id) DO UPDATE SET
  cn=EXCLUDED.cn,pinyin=EXCLUDED.pinyin,en=EXCLUDED.en,audio_url=EXCLUDED.audio_url,sort_order=EXCLUDED.sort_order,is_active=EXCLUDED.is_active,updated_at=NOW();

INSERT INTO common_phrases (id, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES ('phrase_common_010', '请去这里', '请去这里', 'Please go here', 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_common_010.mp3', 9, TRUE)
ON CONFLICT (id) DO UPDATE SET
  cn=EXCLUDED.cn,pinyin=EXCLUDED.pinyin,en=EXCLUDED.en,audio_url=EXCLUDED.audio_url,sort_order=EXCLUDED.sort_order,is_active=EXCLUDED.is_active,updated_at=NOW();

INSERT INTO common_phrases (id, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES ('phrase_common_011', '到了请告诉我', '到了请告诉我', 'Please tell me when we arrive', 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_common_011.mp3', 10, TRUE)
ON CONFLICT (id) DO UPDATE SET
  cn=EXCLUDED.cn,pinyin=EXCLUDED.pinyin,en=EXCLUDED.en,audio_url=EXCLUDED.audio_url,sort_order=EXCLUDED.sort_order,is_active=EXCLUDED.is_active,updated_at=NOW();

INSERT INTO common_phrases (id, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES ('phrase_common_012', '停这里', '停这里', 'Stop here', 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_common_012.mp3', 11, TRUE)
ON CONFLICT (id) DO UPDATE SET
  cn=EXCLUDED.cn,pinyin=EXCLUDED.pinyin,en=EXCLUDED.en,audio_url=EXCLUDED.audio_url,sort_order=EXCLUDED.sort_order,is_active=EXCLUDED.is_active,updated_at=NOW();

INSERT INTO common_phrases (id, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES ('phrase_common_013', '往哪边走？', '往哪边走？', 'Which way should I go?', 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_common_013.mp3', 12, TRUE)
ON CONFLICT (id) DO UPDATE SET
  cn=EXCLUDED.cn,pinyin=EXCLUDED.pinyin,en=EXCLUDED.en,audio_url=EXCLUDED.audio_url,sort_order=EXCLUDED.sort_order,is_active=EXCLUDED.is_active,updated_at=NOW();

INSERT INTO common_phrases (id, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES ('phrase_common_014', '最近的洗手间在哪？', '最近的洗手间在哪？', 'Where is the nearest restroom?', 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_common_014.mp3', 13, TRUE)
ON CONFLICT (id) DO UPDATE SET
  cn=EXCLUDED.cn,pinyin=EXCLUDED.pinyin,en=EXCLUDED.en,audio_url=EXCLUDED.audio_url,sort_order=EXCLUDED.sort_order,is_active=EXCLUDED.is_active,updated_at=NOW();

INSERT INTO common_phrases (id, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES ('phrase_common_015', '哪个出口离这里近？', '哪个出口离这里近？', 'Which exit is closest to this place?', 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_common_015.mp3', 14, TRUE)
ON CONFLICT (id) DO UPDATE SET
  cn=EXCLUDED.cn,pinyin=EXCLUDED.pinyin,en=EXCLUDED.en,audio_url=EXCLUDED.audio_url,sort_order=EXCLUDED.sort_order,is_active=EXCLUDED.is_active,updated_at=NOW();

INSERT INTO common_phrases (id, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES ('phrase_common_016', '菜单有英文吗？', '菜单有英文吗？', 'Do you have an English menu?', 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_common_016.mp3', 15, TRUE)
ON CONFLICT (id) DO UPDATE SET
  cn=EXCLUDED.cn,pinyin=EXCLUDED.pinyin,en=EXCLUDED.en,audio_url=EXCLUDED.audio_url,sort_order=EXCLUDED.sort_order,is_active=EXCLUDED.is_active,updated_at=NOW();

INSERT INTO common_phrases (id, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES ('phrase_common_017', '有图片菜单吗？', '有图片菜单吗？', 'Do you have a picture menu?', 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_common_017.mp3', 16, TRUE)
ON CONFLICT (id) DO UPDATE SET
  cn=EXCLUDED.cn,pinyin=EXCLUDED.pinyin,en=EXCLUDED.en,audio_url=EXCLUDED.audio_url,sort_order=EXCLUDED.sort_order,is_active=EXCLUDED.is_active,updated_at=NOW();

INSERT INTO common_phrases (id, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES ('phrase_common_018', '来一份这个', '来一份这个', 'One of these, please', 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_common_018.mp3', 17, TRUE)
ON CONFLICT (id) DO UPDATE SET
  cn=EXCLUDED.cn,pinyin=EXCLUDED.pinyin,en=EXCLUDED.en,audio_url=EXCLUDED.audio_url,sort_order=EXCLUDED.sort_order,is_active=EXCLUDED.is_active,updated_at=NOW();

INSERT INTO common_phrases (id, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES ('phrase_common_019', '不要辣', '不要辣', 'Not spicy, please', 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_common_019.mp3', 18, TRUE)
ON CONFLICT (id) DO UPDATE SET
  cn=EXCLUDED.cn,pinyin=EXCLUDED.pinyin,en=EXCLUDED.en,audio_url=EXCLUDED.audio_url,sort_order=EXCLUDED.sort_order,is_active=EXCLUDED.is_active,updated_at=NOW();

INSERT INTO common_phrases (id, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES ('phrase_common_020', '我对花生过敏', '我对花生过敏', 'I am allergic to peanuts', 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_common_020.mp3', 19, TRUE)
ON CONFLICT (id) DO UPDATE SET
  cn=EXCLUDED.cn,pinyin=EXCLUDED.pinyin,en=EXCLUDED.en,audio_url=EXCLUDED.audio_url,sort_order=EXCLUDED.sort_order,is_active=EXCLUDED.is_active,updated_at=NOW();

INSERT INTO common_phrases (id, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES ('phrase_common_021', '我吃素', '我吃素', 'I am vegetarian', 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_common_021.mp3', 20, TRUE)
ON CONFLICT (id) DO UPDATE SET
  cn=EXCLUDED.cn,pinyin=EXCLUDED.pinyin,en=EXCLUDED.en,audio_url=EXCLUDED.audio_url,sort_order=EXCLUDED.sort_order,is_active=EXCLUDED.is_active,updated_at=NOW();

INSERT INTO common_phrases (id, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES ('phrase_common_022', '买单', '买单', 'The bill, please', 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_common_022.mp3', 21, TRUE)
ON CONFLICT (id) DO UPDATE SET
  cn=EXCLUDED.cn,pinyin=EXCLUDED.pinyin,en=EXCLUDED.en,audio_url=EXCLUDED.audio_url,sort_order=EXCLUDED.sort_order,is_active=EXCLUDED.is_active,updated_at=NOW();

INSERT INTO common_phrases (id, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES ('phrase_common_023', '你这瓜保熟吗？', '你这瓜保熟吗？', 'Is this melon ripe (sweet)?', 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_common_023.mp3', 22, TRUE)
ON CONFLICT (id) DO UPDATE SET
  cn=EXCLUDED.cn,pinyin=EXCLUDED.pinyin,en=EXCLUDED.en,audio_url=EXCLUDED.audio_url,sort_order=EXCLUDED.sort_order,is_active=EXCLUDED.is_active,updated_at=NOW();

INSERT INTO dialect_phrases (id, dialect, emoji, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES ('phrase_dialect__001', '四川话', '', '巴适', '', 'Awesome / so comfy', 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_dialect__001.mp3', 0, TRUE)
ON CONFLICT (id) DO UPDATE SET
  dialect=EXCLUDED.dialect,cn=EXCLUDED.cn,en=EXCLUDED.en,audio_url=EXCLUDED.audio_url,sort_order=EXCLUDED.sort_order,is_active=EXCLUDED.is_active,updated_at=NOW();

INSERT INTO dialect_phrases (id, dialect, emoji, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES ('phrase_dialect__002', '四川话', '', '安逸惨了', '', 'Super chill / perfect', 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_dialect__002.mp3', 1, TRUE)
ON CONFLICT (id) DO UPDATE SET
  dialect=EXCLUDED.dialect,cn=EXCLUDED.cn,en=EXCLUDED.en,audio_url=EXCLUDED.audio_url,sort_order=EXCLUDED.sort_order,is_active=EXCLUDED.is_active,updated_at=NOW();

INSERT INTO dialect_phrases (id, dialect, emoji, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES ('phrase_dialect__003', '四川话', '', '要得', '', 'OK / sure', 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_dialect__003.mp3', 2, TRUE)
ON CONFLICT (id) DO UPDATE SET
  dialect=EXCLUDED.dialect,cn=EXCLUDED.cn,en=EXCLUDED.en,audio_url=EXCLUDED.audio_url,sort_order=EXCLUDED.sort_order,is_active=EXCLUDED.is_active,updated_at=NOW();

INSERT INTO dialect_phrases (id, dialect, emoji, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES ('phrase_dialect__004', '四川话', '', '微微辣', '', 'Just a tiny bit spicy (mild)', 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_dialect__004.mp3', 3, TRUE)
ON CONFLICT (id) DO UPDATE SET
  dialect=EXCLUDED.dialect,cn=EXCLUDED.cn,en=EXCLUDED.en,audio_url=EXCLUDED.audio_url,sort_order=EXCLUDED.sort_order,is_active=EXCLUDED.is_active,updated_at=NOW();

INSERT INTO dialect_phrases (id, dialect, emoji, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES ('phrase_dialect__005', '四川话', '', '这个才叫资格', '', 'Now THIS is the real deal', 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_dialect__005.mp3', 4, TRUE)
ON CONFLICT (id) DO UPDATE SET
  dialect=EXCLUDED.dialect,cn=EXCLUDED.cn,en=EXCLUDED.en,audio_url=EXCLUDED.audio_url,sort_order=EXCLUDED.sort_order,is_active=EXCLUDED.is_active,updated_at=NOW();

INSERT INTO dialect_phrases (id, dialect, emoji, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES ('phrase_dialect__006', '四川话', '', '安逸，巴适得很', '', 'So cozy — life''s good!', 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_dialect__006.mp3', 5, TRUE)
ON CONFLICT (id) DO UPDATE SET
  dialect=EXCLUDED.dialect,cn=EXCLUDED.cn,en=EXCLUDED.en,audio_url=EXCLUDED.audio_url,sort_order=EXCLUDED.sort_order,is_active=EXCLUDED.is_active,updated_at=NOW();

INSERT INTO dialect_phrases (id, dialect, emoji, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES ('phrase_dialect__007', '四川话', '', '老板，来个鸳鸯锅', '', 'A half-spicy hotpot, boss (split mild & spicy)', 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_dialect__007.mp3', 6, TRUE)
ON CONFLICT (id) DO UPDATE SET
  dialect=EXCLUDED.dialect,cn=EXCLUDED.cn,en=EXCLUDED.en,audio_url=EXCLUDED.audio_url,sort_order=EXCLUDED.sort_order,is_active=EXCLUDED.is_active,updated_at=NOW();

INSERT INTO dialect_phrases (id, dialect, emoji, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES ('phrase_dialect__008', '四川话', '', '老板，这个微微辣就够了哈', '', 'Just a tiny bit spicy, boss', 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_dialect__008.mp3', 7, TRUE)
ON CONFLICT (id) DO UPDATE SET
  dialect=EXCLUDED.dialect,cn=EXCLUDED.cn,en=EXCLUDED.en,audio_url=EXCLUDED.audio_url,sort_order=EXCLUDED.sort_order,is_active=EXCLUDED.is_active,updated_at=NOW();

INSERT INTO dialect_phrases (id, dialect, emoji, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES ('phrase_dialect__009', '四川话', '', '这个好吃得很，巴适！', '', 'So delicious — bashi (awesome)!', 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_dialect__009.mp3', 8, TRUE)
ON CONFLICT (id) DO UPDATE SET
  dialect=EXCLUDED.dialect,cn=EXCLUDED.cn,en=EXCLUDED.en,audio_url=EXCLUDED.audio_url,sort_order=EXCLUDED.sort_order,is_active=EXCLUDED.is_active,updated_at=NOW();

INSERT INTO dialect_phrases (id, dialect, emoji, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES ('phrase_dialect__010', '四川话', '', '老板，来二两小面，少放点辣子', '', 'A small noodle bowl, easy on the chili', 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_dialect__010.mp3', 9, TRUE)
ON CONFLICT (id) DO UPDATE SET
  dialect=EXCLUDED.dialect,cn=EXCLUDED.cn,en=EXCLUDED.en,audio_url=EXCLUDED.audio_url,sort_order=EXCLUDED.sort_order,is_active=EXCLUDED.is_active,updated_at=NOW();

INSERT INTO dialect_phrases (id, dialect, emoji, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES ('phrase_dialect__011', '四川话', '', '老板，来碗三花', '', 'A bowl of sanhua jasmine tea, boss', 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_dialect__011.mp3', 10, TRUE)
ON CONFLICT (id) DO UPDATE SET
  dialect=EXCLUDED.dialect,cn=EXCLUDED.cn,en=EXCLUDED.en,audio_url=EXCLUDED.audio_url,sort_order=EXCLUDED.sort_order,is_active=EXCLUDED.is_active,updated_at=NOW();

INSERT INTO dialect_phrases (id, dialect, emoji, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES ('phrase_dialect__001', '北京话', '', '劳驾，让一让', '', 'Excuse me, coming through', 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_dialect__001.mp3', 0, TRUE)
ON CONFLICT (id) DO UPDATE SET
  dialect=EXCLUDED.dialect,cn=EXCLUDED.cn,en=EXCLUDED.en,audio_url=EXCLUDED.audio_url,sort_order=EXCLUDED.sort_order,is_active=EXCLUDED.is_active,updated_at=NOW();

INSERT INTO dialect_phrases (id, dialect, emoji, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES ('phrase_dialect__002', '北京话', '', '这味儿倍儿棒', '', 'This tastes amazing!', 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_dialect__002.mp3', 1, TRUE)
ON CONFLICT (id) DO UPDATE SET
  dialect=EXCLUDED.dialect,cn=EXCLUDED.cn,en=EXCLUDED.en,audio_url=EXCLUDED.audio_url,sort_order=EXCLUDED.sort_order,is_active=EXCLUDED.is_active,updated_at=NOW();

INSERT INTO dialect_phrases (id, dialect, emoji, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES ('phrase_dialect__003', '北京话', '', '这才叫地道', '', 'Now that''s authentic', 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_dialect__003.mp3', 2, TRUE)
ON CONFLICT (id) DO UPDATE SET
  dialect=EXCLUDED.dialect,cn=EXCLUDED.cn,en=EXCLUDED.en,audio_url=EXCLUDED.audio_url,sort_order=EXCLUDED.sort_order,is_active=EXCLUDED.is_active,updated_at=NOW();

INSERT INTO dialect_phrases (id, dialect, emoji, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES ('phrase_dialect__004', '北京话', '', '师傅，劳驾，去天安门', '', 'Excuse me driver, to Tiananmen', 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_dialect__004.mp3', 3, TRUE)
ON CONFLICT (id) DO UPDATE SET
  dialect=EXCLUDED.dialect,cn=EXCLUDED.cn,en=EXCLUDED.en,audio_url=EXCLUDED.audio_url,sort_order=EXCLUDED.sort_order,is_active=EXCLUDED.is_active,updated_at=NOW();

INSERT INTO dialect_phrases (id, dialect, emoji, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES ('phrase_dialect__005', '北京话', '', '您这手艺，倍儿地道！', '', 'Your cooking''s super authentic!', 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_dialect__005.mp3', 4, TRUE)
ON CONFLICT (id) DO UPDATE SET
  dialect=EXCLUDED.dialect,cn=EXCLUDED.cn,en=EXCLUDED.en,audio_url=EXCLUDED.audio_url,sort_order=EXCLUDED.sort_order,is_active=EXCLUDED.is_active,updated_at=NOW();

INSERT INTO dialect_phrases (id, dialect, emoji, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES ('phrase_dialect__006', '北京话', '', '得嘞，谢谢您嘞！', '', 'Got it — thank you!', 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_dialect__006.mp3', 5, TRUE)
ON CONFLICT (id) DO UPDATE SET
  dialect=EXCLUDED.dialect,cn=EXCLUDED.cn,en=EXCLUDED.en,audio_url=EXCLUDED.audio_url,sort_order=EXCLUDED.sort_order,is_active=EXCLUDED.is_active,updated_at=NOW();

INSERT INTO dialect_phrases (id, dialect, emoji, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES ('phrase_dialect__007', '北京话', '', '溜着边儿的喝，才地道', '', 'Sip it along the rim — the proper way', 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_dialect__007.mp3', 6, TRUE)
ON CONFLICT (id) DO UPDATE SET
  dialect=EXCLUDED.dialect,cn=EXCLUDED.cn,en=EXCLUDED.en,audio_url=EXCLUDED.audio_url,sort_order=EXCLUDED.sort_order,is_active=EXCLUDED.is_active,updated_at=NOW();

INSERT INTO dialect_phrases (id, dialect, emoji, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES ('phrase_dialect__008', '北京话', '', '沏壶高的', '', 'Brew us a pot of the good stuff', 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_dialect__008.mp3', 7, TRUE)
ON CONFLICT (id) DO UPDATE SET
  dialect=EXCLUDED.dialect,cn=EXCLUDED.cn,en=EXCLUDED.en,audio_url=EXCLUDED.audio_url,sort_order=EXCLUDED.sort_order,is_active=EXCLUDED.is_active,updated_at=NOW();

INSERT INTO dialect_phrases (id, dialect, emoji, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES ('phrase_dialect__009', '北京话', '', '谢谢您嘞', '', 'Thank you kindly!', 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_dialect__009.mp3', 8, TRUE)
ON CONFLICT (id) DO UPDATE SET
  dialect=EXCLUDED.dialect,cn=EXCLUDED.cn,en=EXCLUDED.en,audio_url=EXCLUDED.audio_url,sort_order=EXCLUDED.sort_order,is_active=EXCLUDED.is_active,updated_at=NOW();

INSERT INTO dialect_phrases (id, dialect, emoji, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES ('phrase_dialect__001', '南京话', '', '这个真来斯', '', 'This is really great!', 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_dialect__001.mp3', 0, TRUE)
ON CONFLICT (id) DO UPDATE SET
  dialect=EXCLUDED.dialect,cn=EXCLUDED.cn,en=EXCLUDED.en,audio_url=EXCLUDED.audio_url,sort_order=EXCLUDED.sort_order,is_active=EXCLUDED.is_active,updated_at=NOW();

INSERT INTO dialect_phrases (id, dialect, emoji, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES ('phrase_dialect__002', '南京话', '', '这个味道真恩正，来斯！', '', 'So authentic — nice!', 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_dialect__002.mp3', 1, TRUE)
ON CONFLICT (id) DO UPDATE SET
  dialect=EXCLUDED.dialect,cn=EXCLUDED.cn,en=EXCLUDED.en,audio_url=EXCLUDED.audio_url,sort_order=EXCLUDED.sort_order,is_active=EXCLUDED.is_active,updated_at=NOW();

INSERT INTO dialect_phrases (id, dialect, emoji, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES ('phrase_dialect__001', '上海话', '', '这个老灵额！', '', 'This is really great!', 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_dialect__001.mp3', 0, TRUE)
ON CONFLICT (id) DO UPDATE SET
  dialect=EXCLUDED.dialect,cn=EXCLUDED.cn,en=EXCLUDED.en,audio_url=EXCLUDED.audio_url,sort_order=EXCLUDED.sort_order,is_active=EXCLUDED.is_active,updated_at=NOW();

INSERT INTO dialect_phrases (id, dialect, emoji, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES ('phrase_dialect__002', '上海话', '', '侬好，阿拉是来白相额', '', 'Hi, we''re here to have some fun', 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_dialect__002.mp3', 1, TRUE)
ON CONFLICT (id) DO UPDATE SET
  dialect=EXCLUDED.dialect,cn=EXCLUDED.cn,en=EXCLUDED.en,audio_url=EXCLUDED.audio_url,sort_order=EXCLUDED.sort_order,is_active=EXCLUDED.is_active,updated_at=NOW();

INSERT INTO dialect_phrases (id, dialect, emoji, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES ('phrase_dialect__003', '上海话', '', '侬老有腔调额！', '', 'You''ve got real style!', 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_dialect__003.mp3', 2, TRUE)
ON CONFLICT (id) DO UPDATE SET
  dialect=EXCLUDED.dialect,cn=EXCLUDED.cn,en=EXCLUDED.en,audio_url=EXCLUDED.audio_url,sort_order=EXCLUDED.sort_order,is_active=EXCLUDED.is_active,updated_at=NOW();

INSERT INTO dialect_phrases (id, dialect, emoji, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES ('phrase_dialect__004', '上海话', '', '侬好', '', 'Hello! (Shanghainese)', 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_dialect__004.mp3', 3, TRUE)
ON CONFLICT (id) DO UPDATE SET
  dialect=EXCLUDED.dialect,cn=EXCLUDED.cn,en=EXCLUDED.en,audio_url=EXCLUDED.audio_url,sort_order=EXCLUDED.sort_order,is_active=EXCLUDED.is_active,updated_at=NOW();

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/shanghai_museum_001.mp3', updated_at=NOW()
WHERE attraction_id='shanghai_museum' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/shanghai_museum_010.mp3', updated_at=NOW()
WHERE attraction_id='shanghai_museum' AND sort_order=9;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/shanghai_museum_002.mp3', updated_at=NOW()
WHERE attraction_id='shanghai_museum' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/shanghai_museum_003.mp3', updated_at=NOW()
WHERE attraction_id='shanghai_museum' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/shanghai_museum_004.mp3', updated_at=NOW()
WHERE attraction_id='shanghai_museum' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/shanghai_museum_005.mp3', updated_at=NOW()
WHERE attraction_id='shanghai_museum' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/shanghai_museum_006.mp3', updated_at=NOW()
WHERE attraction_id='shanghai_museum' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/shanghai_museum_007.mp3', updated_at=NOW()
WHERE attraction_id='shanghai_museum' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/shanghai_museum_008.mp3', updated_at=NOW()
WHERE attraction_id='shanghai_museum' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/shanghai_museum_009.mp3', updated_at=NOW()
WHERE attraction_id='shanghai_museum' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/the_bund_shanghai_001.mp3', updated_at=NOW()
WHERE attraction_id='the_bund_shanghai' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/the_bund_shanghai_010.mp3', updated_at=NOW()
WHERE attraction_id='the_bund_shanghai' AND sort_order=9;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/the_bund_shanghai_011.mp3', updated_at=NOW()
WHERE attraction_id='the_bund_shanghai' AND sort_order=10;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/the_bund_shanghai_012.mp3', updated_at=NOW()
WHERE attraction_id='the_bund_shanghai' AND sort_order=11;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/the_bund_shanghai_002.mp3', updated_at=NOW()
WHERE attraction_id='the_bund_shanghai' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/the_bund_shanghai_003.mp3', updated_at=NOW()
WHERE attraction_id='the_bund_shanghai' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/the_bund_shanghai_004.mp3', updated_at=NOW()
WHERE attraction_id='the_bund_shanghai' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/the_bund_shanghai_005.mp3', updated_at=NOW()
WHERE attraction_id='the_bund_shanghai' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/the_bund_shanghai_006.mp3', updated_at=NOW()
WHERE attraction_id='the_bund_shanghai' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/the_bund_shanghai_007.mp3', updated_at=NOW()
WHERE attraction_id='the_bund_shanghai' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/the_bund_shanghai_008.mp3', updated_at=NOW()
WHERE attraction_id='the_bund_shanghai' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/the_bund_shanghai_009.mp3', updated_at=NOW()
WHERE attraction_id='the_bund_shanghai' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/shanghai_disney_resort_001.mp3', updated_at=NOW()
WHERE attraction_id='shanghai_disney_resort' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/shanghai_disney_resort_010.mp3', updated_at=NOW()
WHERE attraction_id='shanghai_disney_resort' AND sort_order=9;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/shanghai_disney_resort_002.mp3', updated_at=NOW()
WHERE attraction_id='shanghai_disney_resort' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/shanghai_disney_resort_003.mp3', updated_at=NOW()
WHERE attraction_id='shanghai_disney_resort' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/shanghai_disney_resort_004.mp3', updated_at=NOW()
WHERE attraction_id='shanghai_disney_resort' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/shanghai_disney_resort_005.mp3', updated_at=NOW()
WHERE attraction_id='shanghai_disney_resort' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/shanghai_disney_resort_006.mp3', updated_at=NOW()
WHERE attraction_id='shanghai_disney_resort' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/shanghai_disney_resort_007.mp3', updated_at=NOW()
WHERE attraction_id='shanghai_disney_resort' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/shanghai_disney_resort_008.mp3', updated_at=NOW()
WHERE attraction_id='shanghai_disney_resort' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/shanghai_disney_resort_009.mp3', updated_at=NOW()
WHERE attraction_id='shanghai_disney_resort' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/oriental_pearl_radio_television_tower_001.mp3', updated_at=NOW()
WHERE attraction_id='oriental_pearl_radio_television_tower' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/oriental_pearl_radio_television_tower_002.mp3', updated_at=NOW()
WHERE attraction_id='oriental_pearl_radio_television_tower' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/oriental_pearl_radio_television_tower_003.mp3', updated_at=NOW()
WHERE attraction_id='oriental_pearl_radio_television_tower' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/oriental_pearl_radio_television_tower_004.mp3', updated_at=NOW()
WHERE attraction_id='oriental_pearl_radio_television_tower' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/oriental_pearl_radio_television_tower_005.mp3', updated_at=NOW()
WHERE attraction_id='oriental_pearl_radio_television_tower' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/oriental_pearl_radio_television_tower_006.mp3', updated_at=NOW()
WHERE attraction_id='oriental_pearl_radio_television_tower' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/oriental_pearl_radio_television_tower_007.mp3', updated_at=NOW()
WHERE attraction_id='oriental_pearl_radio_television_tower' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market_001.mp3', updated_at=NOW()
WHERE attraction_id='south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market_002.mp3', updated_at=NOW()
WHERE attraction_id='south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market_003.mp3', updated_at=NOW()
WHERE attraction_id='south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market_004.mp3', updated_at=NOW()
WHERE attraction_id='south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market_005.mp3', updated_at=NOW()
WHERE attraction_id='south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market_006.mp3', updated_at=NOW()
WHERE attraction_id='south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market_007.mp3', updated_at=NOW()
WHERE attraction_id='south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market_008.mp3', updated_at=NOW()
WHERE attraction_id='south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market_009.mp3', updated_at=NOW()
WHERE attraction_id='south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/xujiahui_source_scenic_area_001.mp3', updated_at=NOW()
WHERE attraction_id='xujiahui_source_scenic_area' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/xujiahui_source_scenic_area_002.mp3', updated_at=NOW()
WHERE attraction_id='xujiahui_source_scenic_area' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/xujiahui_source_scenic_area_003.mp3', updated_at=NOW()
WHERE attraction_id='xujiahui_source_scenic_area' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/xujiahui_source_scenic_area_004.mp3', updated_at=NOW()
WHERE attraction_id='xujiahui_source_scenic_area' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/xujiahui_source_scenic_area_005.mp3', updated_at=NOW()
WHERE attraction_id='xujiahui_source_scenic_area' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/xujiahui_source_scenic_area_006.mp3', updated_at=NOW()
WHERE attraction_id='xujiahui_source_scenic_area' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/xujiahui_source_scenic_area_007.mp3', updated_at=NOW()
WHERE attraction_id='xujiahui_source_scenic_area' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/xujiahui_source_scenic_area_008.mp3', updated_at=NOW()
WHERE attraction_id='xujiahui_source_scenic_area' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/xujiahui_source_scenic_area_009.mp3', updated_at=NOW()
WHERE attraction_id='xujiahui_source_scenic_area' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/zhujiajiao_ancient_town_001.mp3', updated_at=NOW()
WHERE attraction_id='zhujiajiao_ancient_town' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/zhujiajiao_ancient_town_002.mp3', updated_at=NOW()
WHERE attraction_id='zhujiajiao_ancient_town' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/zhujiajiao_ancient_town_003.mp3', updated_at=NOW()
WHERE attraction_id='zhujiajiao_ancient_town' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/zhujiajiao_ancient_town_004.mp3', updated_at=NOW()
WHERE attraction_id='zhujiajiao_ancient_town' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/zhujiajiao_ancient_town_005.mp3', updated_at=NOW()
WHERE attraction_id='zhujiajiao_ancient_town' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/zhujiajiao_ancient_town_006.mp3', updated_at=NOW()
WHERE attraction_id='zhujiajiao_ancient_town' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/zhujiajiao_ancient_town_007.mp3', updated_at=NOW()
WHERE attraction_id='zhujiajiao_ancient_town' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/zhujiajiao_ancient_town_008.mp3', updated_at=NOW()
WHERE attraction_id='zhujiajiao_ancient_town' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/zhujiajiao_ancient_town_009.mp3', updated_at=NOW()
WHERE attraction_id='zhujiajiao_ancient_town' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/wukang_road_001.mp3', updated_at=NOW()
WHERE attraction_id='wukang_road' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/wukang_road_002.mp3', updated_at=NOW()
WHERE attraction_id='wukang_road' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/wukang_road_003.mp3', updated_at=NOW()
WHERE attraction_id='wukang_road' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/wukang_road_004.mp3', updated_at=NOW()
WHERE attraction_id='wukang_road' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/wukang_road_005.mp3', updated_at=NOW()
WHERE attraction_id='wukang_road' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/wukang_road_006.mp3', updated_at=NOW()
WHERE attraction_id='wukang_road' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/wukang_road_007.mp3', updated_at=NOW()
WHERE attraction_id='wukang_road' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/wukang_road_008.mp3', updated_at=NOW()
WHERE attraction_id='wukang_road' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/wukang_road_009.mp3', updated_at=NOW()
WHERE attraction_id='wukang_road' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/tianzifang_001.mp3', updated_at=NOW()
WHERE attraction_id='tianzifang' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/tianzifang_002.mp3', updated_at=NOW()
WHERE attraction_id='tianzifang' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/tianzifang_003.mp3', updated_at=NOW()
WHERE attraction_id='tianzifang' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/tianzifang_004.mp3', updated_at=NOW()
WHERE attraction_id='tianzifang' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/tianzifang_005.mp3', updated_at=NOW()
WHERE attraction_id='tianzifang' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/tianzifang_006.mp3', updated_at=NOW()
WHERE attraction_id='tianzifang' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/tianzifang_007.mp3', updated_at=NOW()
WHERE attraction_id='tianzifang' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/tianzifang_008.mp3', updated_at=NOW()
WHERE attraction_id='tianzifang' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/tianzifang_009.mp3', updated_at=NOW()
WHERE attraction_id='tianzifang' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_creek_twelve_nations_colors_001.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_creek_twelve_nations_colors' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_creek_twelve_nations_colors_010.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_creek_twelve_nations_colors' AND sort_order=9;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_creek_twelve_nations_colors_011.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_creek_twelve_nations_colors' AND sort_order=10;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_creek_twelve_nations_colors_012.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_creek_twelve_nations_colors' AND sort_order=11;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_creek_twelve_nations_colors_002.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_creek_twelve_nations_colors' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_creek_twelve_nations_colors_003.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_creek_twelve_nations_colors' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_creek_twelve_nations_colors_004.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_creek_twelve_nations_colors' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_creek_twelve_nations_colors_005.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_creek_twelve_nations_colors' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_creek_twelve_nations_colors_006.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_creek_twelve_nations_colors' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_creek_twelve_nations_colors_007.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_creek_twelve_nations_colors' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_creek_twelve_nations_colors_008.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_creek_twelve_nations_colors' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_creek_twelve_nations_colors_009.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_creek_twelve_nations_colors' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/yu_garden_001.mp3', updated_at=NOW()
WHERE attraction_id='yu_garden' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/yu_garden_010.mp3', updated_at=NOW()
WHERE attraction_id='yu_garden' AND sort_order=9;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/yu_garden_011.mp3', updated_at=NOW()
WHERE attraction_id='yu_garden' AND sort_order=10;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/yu_garden_002.mp3', updated_at=NOW()
WHERE attraction_id='yu_garden' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/yu_garden_003.mp3', updated_at=NOW()
WHERE attraction_id='yu_garden' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/yu_garden_004.mp3', updated_at=NOW()
WHERE attraction_id='yu_garden' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/yu_garden_005.mp3', updated_at=NOW()
WHERE attraction_id='yu_garden' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/yu_garden_006.mp3', updated_at=NOW()
WHERE attraction_id='yu_garden' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/yu_garden_007.mp3', updated_at=NOW()
WHERE attraction_id='yu_garden' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/yu_garden_008.mp3', updated_at=NOW()
WHERE attraction_id='yu_garden' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/yu_garden_009.mp3', updated_at=NOW()
WHERE attraction_id='yu_garden' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/lujiazui_financial_district_001.mp3', updated_at=NOW()
WHERE attraction_id='lujiazui_financial_district' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/lujiazui_financial_district_002.mp3', updated_at=NOW()
WHERE attraction_id='lujiazui_financial_district' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/lujiazui_financial_district_003.mp3', updated_at=NOW()
WHERE attraction_id='lujiazui_financial_district' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/lujiazui_financial_district_004.mp3', updated_at=NOW()
WHERE attraction_id='lujiazui_financial_district' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/lujiazui_financial_district_005.mp3', updated_at=NOW()
WHERE attraction_id='lujiazui_financial_district' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/lujiazui_financial_district_006.mp3', updated_at=NOW()
WHERE attraction_id='lujiazui_financial_district' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/lujiazui_financial_district_007.mp3', updated_at=NOW()
WHERE attraction_id='lujiazui_financial_district' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/lujiazui_financial_district_008.mp3', updated_at=NOW()
WHERE attraction_id='lujiazui_financial_district' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/lujiazui_financial_district_009.mp3', updated_at=NOW()
WHERE attraction_id='lujiazui_financial_district' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_beihai_park_001.mp3', updated_at=NOW()
WHERE attraction_id='beijing_beihai_park' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_beihai_park_010.mp3', updated_at=NOW()
WHERE attraction_id='beijing_beihai_park' AND sort_order=9;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_beihai_park_011.mp3', updated_at=NOW()
WHERE attraction_id='beijing_beihai_park' AND sort_order=10;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_beihai_park_002.mp3', updated_at=NOW()
WHERE attraction_id='beijing_beihai_park' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_beihai_park_003.mp3', updated_at=NOW()
WHERE attraction_id='beijing_beihai_park' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_beihai_park_004.mp3', updated_at=NOW()
WHERE attraction_id='beijing_beihai_park' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_beihai_park_005.mp3', updated_at=NOW()
WHERE attraction_id='beijing_beihai_park' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_beihai_park_006.mp3', updated_at=NOW()
WHERE attraction_id='beijing_beihai_park' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_beihai_park_007.mp3', updated_at=NOW()
WHERE attraction_id='beijing_beihai_park' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_beihai_park_008.mp3', updated_at=NOW()
WHERE attraction_id='beijing_beihai_park' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_beihai_park_009.mp3', updated_at=NOW()
WHERE attraction_id='beijing_beihai_park' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_ming_tombs_001.mp3', updated_at=NOW()
WHERE attraction_id='beijing_ming_tombs' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_ming_tombs_002.mp3', updated_at=NOW()
WHERE attraction_id='beijing_ming_tombs' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_ming_tombs_003.mp3', updated_at=NOW()
WHERE attraction_id='beijing_ming_tombs' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_ming_tombs_004.mp3', updated_at=NOW()
WHERE attraction_id='beijing_ming_tombs' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_ming_tombs_005.mp3', updated_at=NOW()
WHERE attraction_id='beijing_ming_tombs' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_ming_tombs_006.mp3', updated_at=NOW()
WHERE attraction_id='beijing_ming_tombs' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_ming_tombs_007.mp3', updated_at=NOW()
WHERE attraction_id='beijing_ming_tombs' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_ming_tombs_008.mp3', updated_at=NOW()
WHERE attraction_id='beijing_ming_tombs' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_national_museum_001.mp3', updated_at=NOW()
WHERE attraction_id='beijing_national_museum' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_national_museum_010.mp3', updated_at=NOW()
WHERE attraction_id='beijing_national_museum' AND sort_order=9;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_national_museum_002.mp3', updated_at=NOW()
WHERE attraction_id='beijing_national_museum' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_national_museum_003.mp3', updated_at=NOW()
WHERE attraction_id='beijing_national_museum' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_national_museum_004.mp3', updated_at=NOW()
WHERE attraction_id='beijing_national_museum' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_national_museum_005.mp3', updated_at=NOW()
WHERE attraction_id='beijing_national_museum' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_national_museum_006.mp3', updated_at=NOW()
WHERE attraction_id='beijing_national_museum' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_national_museum_007.mp3', updated_at=NOW()
WHERE attraction_id='beijing_national_museum' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_national_museum_008.mp3', updated_at=NOW()
WHERE attraction_id='beijing_national_museum' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_national_museum_009.mp3', updated_at=NOW()
WHERE attraction_id='beijing_national_museum' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_temple_of_heaven_001.mp3', updated_at=NOW()
WHERE attraction_id='beijing_temple_of_heaven' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_temple_of_heaven_002.mp3', updated_at=NOW()
WHERE attraction_id='beijing_temple_of_heaven' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_temple_of_heaven_003.mp3', updated_at=NOW()
WHERE attraction_id='beijing_temple_of_heaven' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_temple_of_heaven_004.mp3', updated_at=NOW()
WHERE attraction_id='beijing_temple_of_heaven' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_temple_of_heaven_005.mp3', updated_at=NOW()
WHERE attraction_id='beijing_temple_of_heaven' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_prince_gong_mansion_001.mp3', updated_at=NOW()
WHERE attraction_id='beijing_prince_gong_mansion' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_prince_gong_mansion_010.mp3', updated_at=NOW()
WHERE attraction_id='beijing_prince_gong_mansion' AND sort_order=9;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_prince_gong_mansion_011.mp3', updated_at=NOW()
WHERE attraction_id='beijing_prince_gong_mansion' AND sort_order=10;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_prince_gong_mansion_002.mp3', updated_at=NOW()
WHERE attraction_id='beijing_prince_gong_mansion' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_prince_gong_mansion_003.mp3', updated_at=NOW()
WHERE attraction_id='beijing_prince_gong_mansion' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_prince_gong_mansion_004.mp3', updated_at=NOW()
WHERE attraction_id='beijing_prince_gong_mansion' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_prince_gong_mansion_005.mp3', updated_at=NOW()
WHERE attraction_id='beijing_prince_gong_mansion' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_prince_gong_mansion_006.mp3', updated_at=NOW()
WHERE attraction_id='beijing_prince_gong_mansion' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_prince_gong_mansion_007.mp3', updated_at=NOW()
WHERE attraction_id='beijing_prince_gong_mansion' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_prince_gong_mansion_008.mp3', updated_at=NOW()
WHERE attraction_id='beijing_prince_gong_mansion' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_prince_gong_mansion_009.mp3', updated_at=NOW()
WHERE attraction_id='beijing_prince_gong_mansion' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_mutianyu_great_wall_001.mp3', updated_at=NOW()
WHERE attraction_id='beijing_mutianyu_great_wall' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_mutianyu_great_wall_002.mp3', updated_at=NOW()
WHERE attraction_id='beijing_mutianyu_great_wall' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_mutianyu_great_wall_003.mp3', updated_at=NOW()
WHERE attraction_id='beijing_mutianyu_great_wall' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_mutianyu_great_wall_004.mp3', updated_at=NOW()
WHERE attraction_id='beijing_mutianyu_great_wall' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_mutianyu_great_wall_005.mp3', updated_at=NOW()
WHERE attraction_id='beijing_mutianyu_great_wall' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_mutianyu_great_wall_006.mp3', updated_at=NOW()
WHERE attraction_id='beijing_mutianyu_great_wall' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_forbidden_city_001.mp3', updated_at=NOW()
WHERE attraction_id='beijing_forbidden_city' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_forbidden_city_010.mp3', updated_at=NOW()
WHERE attraction_id='beijing_forbidden_city' AND sort_order=9;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_forbidden_city_011.mp3', updated_at=NOW()
WHERE attraction_id='beijing_forbidden_city' AND sort_order=10;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_forbidden_city_002.mp3', updated_at=NOW()
WHERE attraction_id='beijing_forbidden_city' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_forbidden_city_003.mp3', updated_at=NOW()
WHERE attraction_id='beijing_forbidden_city' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_forbidden_city_004.mp3', updated_at=NOW()
WHERE attraction_id='beijing_forbidden_city' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_forbidden_city_005.mp3', updated_at=NOW()
WHERE attraction_id='beijing_forbidden_city' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_forbidden_city_006.mp3', updated_at=NOW()
WHERE attraction_id='beijing_forbidden_city' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_forbidden_city_007.mp3', updated_at=NOW()
WHERE attraction_id='beijing_forbidden_city' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_forbidden_city_008.mp3', updated_at=NOW()
WHERE attraction_id='beijing_forbidden_city' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_forbidden_city_009.mp3', updated_at=NOW()
WHERE attraction_id='beijing_forbidden_city' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_lama_temple_001.mp3', updated_at=NOW()
WHERE attraction_id='beijing_lama_temple' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_lama_temple_002.mp3', updated_at=NOW()
WHERE attraction_id='beijing_lama_temple' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_lama_temple_003.mp3', updated_at=NOW()
WHERE attraction_id='beijing_lama_temple' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_lama_temple_004.mp3', updated_at=NOW()
WHERE attraction_id='beijing_lama_temple' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_lama_temple_005.mp3', updated_at=NOW()
WHERE attraction_id='beijing_lama_temple' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_lama_temple_006.mp3', updated_at=NOW()
WHERE attraction_id='beijing_lama_temple' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_lama_temple_007.mp3', updated_at=NOW()
WHERE attraction_id='beijing_lama_temple' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_lama_temple_008.mp3', updated_at=NOW()
WHERE attraction_id='beijing_lama_temple' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_lama_temple_009.mp3', updated_at=NOW()
WHERE attraction_id='beijing_lama_temple' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_summer_palace_001.mp3', updated_at=NOW()
WHERE attraction_id='beijing_summer_palace' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_summer_palace_010.mp3', updated_at=NOW()
WHERE attraction_id='beijing_summer_palace' AND sort_order=9;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_summer_palace_002.mp3', updated_at=NOW()
WHERE attraction_id='beijing_summer_palace' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_summer_palace_003.mp3', updated_at=NOW()
WHERE attraction_id='beijing_summer_palace' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_summer_palace_004.mp3', updated_at=NOW()
WHERE attraction_id='beijing_summer_palace' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_summer_palace_005.mp3', updated_at=NOW()
WHERE attraction_id='beijing_summer_palace' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_summer_palace_006.mp3', updated_at=NOW()
WHERE attraction_id='beijing_summer_palace' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_summer_palace_007.mp3', updated_at=NOW()
WHERE attraction_id='beijing_summer_palace' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_summer_palace_008.mp3', updated_at=NOW()
WHERE attraction_id='beijing_summer_palace' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_summer_palace_009.mp3', updated_at=NOW()
WHERE attraction_id='beijing_summer_palace' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_sun_yat_sen_mausoleum_001.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_sun_yat_sen_mausoleum' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_sun_yat_sen_mausoleum_010.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_sun_yat_sen_mausoleum' AND sort_order=9;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_sun_yat_sen_mausoleum_002.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_sun_yat_sen_mausoleum' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_sun_yat_sen_mausoleum_003.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_sun_yat_sen_mausoleum' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_sun_yat_sen_mausoleum_004.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_sun_yat_sen_mausoleum' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_sun_yat_sen_mausoleum_005.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_sun_yat_sen_mausoleum' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_sun_yat_sen_mausoleum_006.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_sun_yat_sen_mausoleum' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_sun_yat_sen_mausoleum_007.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_sun_yat_sen_mausoleum' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_sun_yat_sen_mausoleum_008.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_sun_yat_sen_mausoleum' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_sun_yat_sen_mausoleum_009.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_sun_yat_sen_mausoleum' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_museum_001.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_museum' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_museum_010.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_museum' AND sort_order=9;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_museum_011.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_museum' AND sort_order=10;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_museum_012.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_museum' AND sort_order=11;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_museum_002.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_museum' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_museum_003.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_museum' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_museum_004.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_museum' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_museum_005.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_museum' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_museum_006.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_museum' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_museum_007.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_museum' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_museum_008.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_museum' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_museum_009.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_museum' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_confucius_temple_qinhuai_001.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_confucius_temple_qinhuai' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_confucius_temple_qinhuai_010.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_confucius_temple_qinhuai' AND sort_order=9;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_confucius_temple_qinhuai_011.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_confucius_temple_qinhuai' AND sort_order=10;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_confucius_temple_qinhuai_012.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_confucius_temple_qinhuai' AND sort_order=11;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_confucius_temple_qinhuai_013.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_confucius_temple_qinhuai' AND sort_order=12;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_confucius_temple_qinhuai_002.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_confucius_temple_qinhuai' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_confucius_temple_qinhuai_003.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_confucius_temple_qinhuai' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_confucius_temple_qinhuai_004.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_confucius_temple_qinhuai' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_confucius_temple_qinhuai_005.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_confucius_temple_qinhuai' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_confucius_temple_qinhuai_006.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_confucius_temple_qinhuai' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_confucius_temple_qinhuai_007.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_confucius_temple_qinhuai' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_confucius_temple_qinhuai_008.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_confucius_temple_qinhuai' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_confucius_temple_qinhuai_009.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_confucius_temple_qinhuai' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_presidential_palace_001.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_presidential_palace' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_presidential_palace_010.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_presidential_palace' AND sort_order=9;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_presidential_palace_011.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_presidential_palace' AND sort_order=10;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_presidential_palace_012.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_presidential_palace' AND sort_order=11;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_presidential_palace_013.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_presidential_palace' AND sort_order=12;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_presidential_palace_014.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_presidential_palace' AND sort_order=13;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_presidential_palace_002.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_presidential_palace' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_presidential_palace_003.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_presidential_palace' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_presidential_palace_004.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_presidential_palace' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_presidential_palace_005.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_presidential_palace' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_presidential_palace_006.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_presidential_palace' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_presidential_palace_007.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_presidential_palace' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_presidential_palace_008.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_presidential_palace' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_presidential_palace_009.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_presidential_palace' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_city_wall_001.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_city_wall' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_city_wall_002.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_city_wall' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_city_wall_003.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_city_wall' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_city_wall_004.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_city_wall' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_city_wall_005.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_city_wall' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_city_wall_006.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_city_wall' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_city_wall_007.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_city_wall' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_city_wall_008.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_city_wall' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_city_wall_009.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_city_wall' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_ming_xiaoling_001.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_ming_xiaoling' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_ming_xiaoling_010.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_ming_xiaoling' AND sort_order=9;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_ming_xiaoling_011.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_ming_xiaoling' AND sort_order=10;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_ming_xiaoling_012.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_ming_xiaoling' AND sort_order=11;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_ming_xiaoling_002.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_ming_xiaoling' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_ming_xiaoling_003.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_ming_xiaoling' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_ming_xiaoling_004.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_ming_xiaoling' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_ming_xiaoling_005.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_ming_xiaoling' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_ming_xiaoling_006.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_ming_xiaoling' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_ming_xiaoling_007.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_ming_xiaoling' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_ming_xiaoling_008.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_ming_xiaoling' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_ming_xiaoling_009.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_ming_xiaoling' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_1865_creative_park_001.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_1865_creative_park' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_1865_creative_park_010.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_1865_creative_park' AND sort_order=9;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_1865_creative_park_002.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_1865_creative_park' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_1865_creative_park_003.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_1865_creative_park' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_1865_creative_park_004.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_1865_creative_park' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_1865_creative_park_005.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_1865_creative_park' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_1865_creative_park_006.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_1865_creative_park' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_1865_creative_park_007.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_1865_creative_park' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_1865_creative_park_008.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_1865_creative_park' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_1865_creative_park_009.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_1865_creative_park' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_niushoushan_001.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_niushoushan' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_niushoushan_010.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_niushoushan' AND sort_order=9;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_niushoushan_011.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_niushoushan' AND sort_order=10;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_niushoushan_002.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_niushoushan' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_niushoushan_003.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_niushoushan' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_niushoushan_004.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_niushoushan' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_niushoushan_005.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_niushoushan' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_niushoushan_006.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_niushoushan' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_niushoushan_007.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_niushoushan' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_niushoushan_008.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_niushoushan' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_niushoushan_009.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_niushoushan' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_ganxi_mansion_001.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_ganxi_mansion' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_ganxi_mansion_010.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_ganxi_mansion' AND sort_order=9;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_ganxi_mansion_011.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_ganxi_mansion' AND sort_order=10;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_ganxi_mansion_002.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_ganxi_mansion' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_ganxi_mansion_003.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_ganxi_mansion' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_ganxi_mansion_004.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_ganxi_mansion' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_ganxi_mansion_005.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_ganxi_mansion' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_ganxi_mansion_006.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_ganxi_mansion' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_ganxi_mansion_007.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_ganxi_mansion' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_ganxi_mansion_008.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_ganxi_mansion' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_ganxi_mansion_009.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_ganxi_mansion' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_shijiu_lake_001.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_shijiu_lake' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_shijiu_lake_002.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_shijiu_lake' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_shijiu_lake_003.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_shijiu_lake' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_shijiu_lake_004.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_shijiu_lake' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_shijiu_lake_005.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_shijiu_lake' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_shijiu_lake_006.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_shijiu_lake' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_shijiu_lake_007.mp3', updated_at=NOW()
WHERE attraction_id='nanjing_shijiu_lake' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/sichuan_museum_001.mp3', updated_at=NOW()
WHERE attraction_id='sichuan_museum' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/sichuan_museum_010.mp3', updated_at=NOW()
WHERE attraction_id='sichuan_museum' AND sort_order=9;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/sichuan_museum_011.mp3', updated_at=NOW()
WHERE attraction_id='sichuan_museum' AND sort_order=10;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/sichuan_museum_012.mp3', updated_at=NOW()
WHERE attraction_id='sichuan_museum' AND sort_order=11;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/sichuan_museum_013.mp3', updated_at=NOW()
WHERE attraction_id='sichuan_museum' AND sort_order=12;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/sichuan_museum_002.mp3', updated_at=NOW()
WHERE attraction_id='sichuan_museum' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/sichuan_museum_003.mp3', updated_at=NOW()
WHERE attraction_id='sichuan_museum' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/sichuan_museum_004.mp3', updated_at=NOW()
WHERE attraction_id='sichuan_museum' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/sichuan_museum_005.mp3', updated_at=NOW()
WHERE attraction_id='sichuan_museum' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/sichuan_museum_006.mp3', updated_at=NOW()
WHERE attraction_id='sichuan_museum' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/sichuan_museum_007.mp3', updated_at=NOW()
WHERE attraction_id='sichuan_museum' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/sichuan_museum_008.mp3', updated_at=NOW()
WHERE attraction_id='sichuan_museum' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/sichuan_museum_009.mp3', updated_at=NOW()
WHERE attraction_id='sichuan_museum' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chengdu_museum_001.mp3', updated_at=NOW()
WHERE attraction_id='chengdu_museum' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chengdu_museum_010.mp3', updated_at=NOW()
WHERE attraction_id='chengdu_museum' AND sort_order=9;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chengdu_museum_002.mp3', updated_at=NOW()
WHERE attraction_id='chengdu_museum' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chengdu_museum_003.mp3', updated_at=NOW()
WHERE attraction_id='chengdu_museum' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chengdu_museum_004.mp3', updated_at=NOW()
WHERE attraction_id='chengdu_museum' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chengdu_museum_005.mp3', updated_at=NOW()
WHERE attraction_id='chengdu_museum' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chengdu_museum_006.mp3', updated_at=NOW()
WHERE attraction_id='chengdu_museum' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chengdu_museum_007.mp3', updated_at=NOW()
WHERE attraction_id='chengdu_museum' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chengdu_museum_008.mp3', updated_at=NOW()
WHERE attraction_id='chengdu_museum' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chengdu_museum_009.mp3', updated_at=NOW()
WHERE attraction_id='chengdu_museum' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/wenshuyuan_001.mp3', updated_at=NOW()
WHERE attraction_id='wenshuyuan' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/wenshuyuan_010.mp3', updated_at=NOW()
WHERE attraction_id='wenshuyuan' AND sort_order=9;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/wenshuyuan_011.mp3', updated_at=NOW()
WHERE attraction_id='wenshuyuan' AND sort_order=10;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/wenshuyuan_002.mp3', updated_at=NOW()
WHERE attraction_id='wenshuyuan' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/wenshuyuan_003.mp3', updated_at=NOW()
WHERE attraction_id='wenshuyuan' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/wenshuyuan_004.mp3', updated_at=NOW()
WHERE attraction_id='wenshuyuan' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/wenshuyuan_005.mp3', updated_at=NOW()
WHERE attraction_id='wenshuyuan' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/wenshuyuan_006.mp3', updated_at=NOW()
WHERE attraction_id='wenshuyuan' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/wenshuyuan_007.mp3', updated_at=NOW()
WHERE attraction_id='wenshuyuan' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/wenshuyuan_008.mp3', updated_at=NOW()
WHERE attraction_id='wenshuyuan' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/wenshuyuan_009.mp3', updated_at=NOW()
WHERE attraction_id='wenshuyuan' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/du_fu_thatched_cottage_001.mp3', updated_at=NOW()
WHERE attraction_id='du_fu_thatched_cottage' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/du_fu_thatched_cottage_010.mp3', updated_at=NOW()
WHERE attraction_id='du_fu_thatched_cottage' AND sort_order=9;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/du_fu_thatched_cottage_011.mp3', updated_at=NOW()
WHERE attraction_id='du_fu_thatched_cottage' AND sort_order=10;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/du_fu_thatched_cottage_012.mp3', updated_at=NOW()
WHERE attraction_id='du_fu_thatched_cottage' AND sort_order=11;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/du_fu_thatched_cottage_013.mp3', updated_at=NOW()
WHERE attraction_id='du_fu_thatched_cottage' AND sort_order=12;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/du_fu_thatched_cottage_002.mp3', updated_at=NOW()
WHERE attraction_id='du_fu_thatched_cottage' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/du_fu_thatched_cottage_003.mp3', updated_at=NOW()
WHERE attraction_id='du_fu_thatched_cottage' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/du_fu_thatched_cottage_004.mp3', updated_at=NOW()
WHERE attraction_id='du_fu_thatched_cottage' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/du_fu_thatched_cottage_005.mp3', updated_at=NOW()
WHERE attraction_id='du_fu_thatched_cottage' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/du_fu_thatched_cottage_006.mp3', updated_at=NOW()
WHERE attraction_id='du_fu_thatched_cottage' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/du_fu_thatched_cottage_007.mp3', updated_at=NOW()
WHERE attraction_id='du_fu_thatched_cottage' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/du_fu_thatched_cottage_008.mp3', updated_at=NOW()
WHERE attraction_id='du_fu_thatched_cottage' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/du_fu_thatched_cottage_009.mp3', updated_at=NOW()
WHERE attraction_id='du_fu_thatched_cottage' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chengdu_wuhou_shrine_001.mp3', updated_at=NOW()
WHERE attraction_id='chengdu_wuhou_shrine' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chengdu_wuhou_shrine_010.mp3', updated_at=NOW()
WHERE attraction_id='chengdu_wuhou_shrine' AND sort_order=9;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chengdu_wuhou_shrine_002.mp3', updated_at=NOW()
WHERE attraction_id='chengdu_wuhou_shrine' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chengdu_wuhou_shrine_003.mp3', updated_at=NOW()
WHERE attraction_id='chengdu_wuhou_shrine' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chengdu_wuhou_shrine_004.mp3', updated_at=NOW()
WHERE attraction_id='chengdu_wuhou_shrine' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chengdu_wuhou_shrine_005.mp3', updated_at=NOW()
WHERE attraction_id='chengdu_wuhou_shrine' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chengdu_wuhou_shrine_006.mp3', updated_at=NOW()
WHERE attraction_id='chengdu_wuhou_shrine' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chengdu_wuhou_shrine_007.mp3', updated_at=NOW()
WHERE attraction_id='chengdu_wuhou_shrine' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chengdu_wuhou_shrine_008.mp3', updated_at=NOW()
WHERE attraction_id='chengdu_wuhou_shrine' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chengdu_wuhou_shrine_009.mp3', updated_at=NOW()
WHERE attraction_id='chengdu_wuhou_shrine' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/https_yoloadmin_vue_cstudiomunger_workers_dev_001.mp3', updated_at=NOW()
WHERE attraction_id='https_yoloadmin_vue_cstudiomunger_workers_dev' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/https_yoloadmin_vue_cstudiomunger_workers_dev_010.mp3', updated_at=NOW()
WHERE attraction_id='https_yoloadmin_vue_cstudiomunger_workers_dev' AND sort_order=9;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/https_yoloadmin_vue_cstudiomunger_workers_dev_011.mp3', updated_at=NOW()
WHERE attraction_id='https_yoloadmin_vue_cstudiomunger_workers_dev' AND sort_order=10;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/https_yoloadmin_vue_cstudiomunger_workers_dev_012.mp3', updated_at=NOW()
WHERE attraction_id='https_yoloadmin_vue_cstudiomunger_workers_dev' AND sort_order=11;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/https_yoloadmin_vue_cstudiomunger_workers_dev_013.mp3', updated_at=NOW()
WHERE attraction_id='https_yoloadmin_vue_cstudiomunger_workers_dev' AND sort_order=12;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/https_yoloadmin_vue_cstudiomunger_workers_dev_002.mp3', updated_at=NOW()
WHERE attraction_id='https_yoloadmin_vue_cstudiomunger_workers_dev' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/https_yoloadmin_vue_cstudiomunger_workers_dev_003.mp3', updated_at=NOW()
WHERE attraction_id='https_yoloadmin_vue_cstudiomunger_workers_dev' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/https_yoloadmin_vue_cstudiomunger_workers_dev_004.mp3', updated_at=NOW()
WHERE attraction_id='https_yoloadmin_vue_cstudiomunger_workers_dev' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/https_yoloadmin_vue_cstudiomunger_workers_dev_005.mp3', updated_at=NOW()
WHERE attraction_id='https_yoloadmin_vue_cstudiomunger_workers_dev' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/https_yoloadmin_vue_cstudiomunger_workers_dev_006.mp3', updated_at=NOW()
WHERE attraction_id='https_yoloadmin_vue_cstudiomunger_workers_dev' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/https_yoloadmin_vue_cstudiomunger_workers_dev_007.mp3', updated_at=NOW()
WHERE attraction_id='https_yoloadmin_vue_cstudiomunger_workers_dev' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/https_yoloadmin_vue_cstudiomunger_workers_dev_008.mp3', updated_at=NOW()
WHERE attraction_id='https_yoloadmin_vue_cstudiomunger_workers_dev' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/https_yoloadmin_vue_cstudiomunger_workers_dev_009.mp3', updated_at=NOW()
WHERE attraction_id='https_yoloadmin_vue_cstudiomunger_workers_dev' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/qingyangg_001.mp3', updated_at=NOW()
WHERE attraction_id='qingyangg' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/qingyangg_010.mp3', updated_at=NOW()
WHERE attraction_id='qingyangg' AND sort_order=9;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/qingyangg_011.mp3', updated_at=NOW()
WHERE attraction_id='qingyangg' AND sort_order=10;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/qingyangg_002.mp3', updated_at=NOW()
WHERE attraction_id='qingyangg' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/qingyangg_003.mp3', updated_at=NOW()
WHERE attraction_id='qingyangg' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/qingyangg_004.mp3', updated_at=NOW()
WHERE attraction_id='qingyangg' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/qingyangg_005.mp3', updated_at=NOW()
WHERE attraction_id='qingyangg' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/qingyangg_006.mp3', updated_at=NOW()
WHERE attraction_id='qingyangg' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/qingyangg_007.mp3', updated_at=NOW()
WHERE attraction_id='qingyangg' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/qingyangg_008.mp3', updated_at=NOW()
WHERE attraction_id='qingyangg' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/qingyangg_009.mp3', updated_at=NOW()
WHERE attraction_id='qingyangg' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_grand_canal_001.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_grand_canal' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_grand_canal_010.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_grand_canal' AND sort_order=9;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_grand_canal_002.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_grand_canal' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_grand_canal_003.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_grand_canal' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_grand_canal_004.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_grand_canal' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_grand_canal_005.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_grand_canal' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_grand_canal_006.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_grand_canal' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_grand_canal_007.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_grand_canal' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_grand_canal_008.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_grand_canal' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_grand_canal_009.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_grand_canal' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_gongchen_bridge_001.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_gongchen_bridge' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_gongchen_bridge_010.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_gongchen_bridge' AND sort_order=9;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_gongchen_bridge_002.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_gongchen_bridge' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_gongchen_bridge_003.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_gongchen_bridge' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_gongchen_bridge_004.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_gongchen_bridge' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_gongchen_bridge_005.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_gongchen_bridge' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_gongchen_bridge_006.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_gongchen_bridge' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_gongchen_bridge_007.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_gongchen_bridge' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_gongchen_bridge_008.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_gongchen_bridge' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_gongchen_bridge_009.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_gongchen_bridge' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_xiaohe_street_001.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_xiaohe_street' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_xiaohe_street_010.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_xiaohe_street' AND sort_order=9;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_xiaohe_street_002.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_xiaohe_street' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_xiaohe_street_003.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_xiaohe_street' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_xiaohe_street_004.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_xiaohe_street' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_xiaohe_street_005.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_xiaohe_street' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_xiaohe_street_006.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_xiaohe_street' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_xiaohe_street_007.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_xiaohe_street' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_xiaohe_street_008.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_xiaohe_street' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_xiaohe_street_009.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_xiaohe_street' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_hefang_street_001.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_hefang_street' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_hefang_street_010.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_hefang_street' AND sort_order=9;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_hefang_street_002.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_hefang_street' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_hefang_street_003.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_hefang_street' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_hefang_street_004.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_hefang_street' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_hefang_street_005.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_hefang_street' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_hefang_street_006.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_hefang_street' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_hefang_street_007.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_hefang_street' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_hefang_street_008.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_hefang_street' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_hefang_street_009.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_hefang_street' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_faxi_temple_001.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_faxi_temple' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_faxi_temple_010.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_faxi_temple' AND sort_order=9;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_faxi_temple_002.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_faxi_temple' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_faxi_temple_003.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_faxi_temple' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_faxi_temple_004.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_faxi_temple' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_faxi_temple_005.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_faxi_temple' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_faxi_temple_006.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_faxi_temple' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_faxi_temple_007.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_faxi_temple' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_faxi_temple_008.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_faxi_temple' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_faxi_temple_009.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_faxi_temple' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_zhejiang_museum_001.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_zhejiang_museum' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_zhejiang_museum_010.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_zhejiang_museum' AND sort_order=9;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_zhejiang_museum_002.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_zhejiang_museum' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_zhejiang_museum_003.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_zhejiang_museum' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_zhejiang_museum_004.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_zhejiang_museum' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_zhejiang_museum_005.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_zhejiang_museum' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_zhejiang_museum_006.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_zhejiang_museum' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_zhejiang_museum_007.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_zhejiang_museum' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_zhejiang_museum_008.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_zhejiang_museum' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_zhejiang_museum_009.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_zhejiang_museum' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_lingyin_temple_001.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_lingyin_temple' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_lingyin_temple_010.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_lingyin_temple' AND sort_order=9;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_lingyin_temple_002.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_lingyin_temple' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_lingyin_temple_003.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_lingyin_temple' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_lingyin_temple_004.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_lingyin_temple' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_lingyin_temple_005.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_lingyin_temple' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_lingyin_temple_006.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_lingyin_temple' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_lingyin_temple_007.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_lingyin_temple' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_lingyin_temple_008.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_lingyin_temple' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_lingyin_temple_009.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_lingyin_temple' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_liangzhu_ancient_city_001.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_liangzhu_ancient_city' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_liangzhu_ancient_city_010.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_liangzhu_ancient_city' AND sort_order=9;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_liangzhu_ancient_city_002.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_liangzhu_ancient_city' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_liangzhu_ancient_city_003.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_liangzhu_ancient_city' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_liangzhu_ancient_city_004.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_liangzhu_ancient_city' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_liangzhu_ancient_city_005.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_liangzhu_ancient_city' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_liangzhu_ancient_city_006.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_liangzhu_ancient_city' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_liangzhu_ancient_city_007.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_liangzhu_ancient_city' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_liangzhu_ancient_city_008.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_liangzhu_ancient_city' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_liangzhu_ancient_city_009.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_liangzhu_ancient_city' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_west_lake_cultural_plaza_001.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_west_lake_cultural_plaza' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_west_lake_cultural_plaza_010.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_west_lake_cultural_plaza' AND sort_order=9;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_west_lake_cultural_plaza_002.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_west_lake_cultural_plaza' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_west_lake_cultural_plaza_003.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_west_lake_cultural_plaza' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_west_lake_cultural_plaza_004.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_west_lake_cultural_plaza' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_west_lake_cultural_plaza_005.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_west_lake_cultural_plaza' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_west_lake_cultural_plaza_006.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_west_lake_cultural_plaza' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_west_lake_cultural_plaza_007.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_west_lake_cultural_plaza' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_west_lake_cultural_plaza_008.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_west_lake_cultural_plaza' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_west_lake_cultural_plaza_009.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_west_lake_cultural_plaza' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_xixi_wetland_001.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_xixi_wetland' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_xixi_wetland_010.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_xixi_wetland' AND sort_order=9;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_xixi_wetland_002.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_xixi_wetland' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_xixi_wetland_003.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_xixi_wetland' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_xixi_wetland_004.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_xixi_wetland' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_xixi_wetland_005.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_xixi_wetland' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_xixi_wetland_006.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_xixi_wetland' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_xixi_wetland_007.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_xixi_wetland' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_xixi_wetland_008.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_xixi_wetland' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_xixi_wetland_009.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_xixi_wetland' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_leifeng_pagoda_001.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_leifeng_pagoda' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_leifeng_pagoda_002.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_leifeng_pagoda' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_leifeng_pagoda_003.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_leifeng_pagoda' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_leifeng_pagoda_004.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_leifeng_pagoda' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_leifeng_pagoda_005.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_leifeng_pagoda' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_leifeng_pagoda_006.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_leifeng_pagoda' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_leifeng_pagoda_007.mp3', updated_at=NOW()
WHERE attraction_id='hangzhou_leifeng_pagoda' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_tongli_ancient_town_001.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_tongli_ancient_town' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_tongli_ancient_town_010.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_tongli_ancient_town' AND sort_order=9;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_tongli_ancient_town_002.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_tongli_ancient_town' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_tongli_ancient_town_003.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_tongli_ancient_town' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_tongli_ancient_town_004.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_tongli_ancient_town' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_tongli_ancient_town_005.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_tongli_ancient_town' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_tongli_ancient_town_006.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_tongli_ancient_town' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_tongli_ancient_town_007.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_tongli_ancient_town' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_tongli_ancient_town_008.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_tongli_ancient_town' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_tongli_ancient_town_009.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_tongli_ancient_town' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_zhouzhuang_ancient_town_001.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_zhouzhuang_ancient_town' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_zhouzhuang_ancient_town_010.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_zhouzhuang_ancient_town' AND sort_order=9;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_zhouzhuang_ancient_town_002.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_zhouzhuang_ancient_town' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_zhouzhuang_ancient_town_003.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_zhouzhuang_ancient_town' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_zhouzhuang_ancient_town_004.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_zhouzhuang_ancient_town' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_zhouzhuang_ancient_town_005.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_zhouzhuang_ancient_town' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_zhouzhuang_ancient_town_006.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_zhouzhuang_ancient_town' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_zhouzhuang_ancient_town_007.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_zhouzhuang_ancient_town' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_zhouzhuang_ancient_town_008.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_zhouzhuang_ancient_town' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_zhouzhuang_ancient_town_009.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_zhouzhuang_ancient_town' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_pingjiang_road_001.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_pingjiang_road' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_pingjiang_road_010.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_pingjiang_road' AND sort_order=9;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_pingjiang_road_002.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_pingjiang_road' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_pingjiang_road_003.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_pingjiang_road' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_pingjiang_road_004.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_pingjiang_road' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_pingjiang_road_005.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_pingjiang_road' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_pingjiang_road_006.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_pingjiang_road' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_pingjiang_road_007.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_pingjiang_road' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_pingjiang_road_008.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_pingjiang_road' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_pingjiang_road_009.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_pingjiang_road' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_humble_administrators_garden_001.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_humble_administrators_garden' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_humble_administrators_garden_002.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_humble_administrators_garden' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_humble_administrators_garden_003.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_humble_administrators_garden' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_humble_administrators_garden_004.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_humble_administrators_garden' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_humble_administrators_garden_005.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_humble_administrators_garden' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_humble_administrators_garden_006.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_humble_administrators_garden' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_humble_administrators_garden_007.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_humble_administrators_garden' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_humble_administrators_garden_008.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_humble_administrators_garden' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_humble_administrators_garden_009.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_humble_administrators_garden' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_canglang_pavilion_001.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_canglang_pavilion' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_canglang_pavilion_002.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_canglang_pavilion' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_canglang_pavilion_003.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_canglang_pavilion' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_canglang_pavilion_004.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_canglang_pavilion' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_canglang_pavilion_005.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_canglang_pavilion' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_canglang_pavilion_006.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_canglang_pavilion' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_canglang_pavilion_007.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_canglang_pavilion' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_canglang_pavilion_008.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_canglang_pavilion' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_canglang_pavilion_009.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_canglang_pavilion' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_lion_grove_garden_001.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_lion_grove_garden' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_lion_grove_garden_010.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_lion_grove_garden' AND sort_order=9;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_lion_grove_garden_002.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_lion_grove_garden' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_lion_grove_garden_003.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_lion_grove_garden' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_lion_grove_garden_004.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_lion_grove_garden' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_lion_grove_garden_005.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_lion_grove_garden' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_lion_grove_garden_006.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_lion_grove_garden' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_lion_grove_garden_007.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_lion_grove_garden' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_lion_grove_garden_008.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_lion_grove_garden' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_lion_grove_garden_009.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_lion_grove_garden' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_huanxiu_mountain_villa_001.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_huanxiu_mountain_villa' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_huanxiu_mountain_villa_002.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_huanxiu_mountain_villa' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_huanxiu_mountain_villa_003.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_huanxiu_mountain_villa' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_huanxiu_mountain_villa_004.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_huanxiu_mountain_villa' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_huanxiu_mountain_villa_005.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_huanxiu_mountain_villa' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_huanxiu_mountain_villa_006.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_huanxiu_mountain_villa' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_huanxiu_mountain_villa_007.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_huanxiu_mountain_villa' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_huanxiu_mountain_villa_008.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_huanxiu_mountain_villa' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_huanxiu_mountain_villa_009.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_huanxiu_mountain_villa' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_lingering_garden_001.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_lingering_garden' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_lingering_garden_002.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_lingering_garden' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_lingering_garden_003.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_lingering_garden' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_lingering_garden_004.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_lingering_garden' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_lingering_garden_005.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_lingering_garden' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_lingering_garden_006.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_lingering_garden' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_lingering_garden_007.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_lingering_garden' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_lingering_garden_008.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_lingering_garden' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_lingering_garden_009.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_lingering_garden' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_master_of_nets_garden_001.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_master_of_nets_garden' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_master_of_nets_garden_010.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_master_of_nets_garden' AND sort_order=9;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_master_of_nets_garden_002.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_master_of_nets_garden' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_master_of_nets_garden_003.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_master_of_nets_garden' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_master_of_nets_garden_004.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_master_of_nets_garden' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_master_of_nets_garden_005.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_master_of_nets_garden' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_master_of_nets_garden_006.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_master_of_nets_garden' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_master_of_nets_garden_007.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_master_of_nets_garden' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_master_of_nets_garden_008.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_master_of_nets_garden' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_master_of_nets_garden_009.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_master_of_nets_garden' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_ou_garden_001.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_ou_garden' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_ou_garden_010.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_ou_garden' AND sort_order=9;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_ou_garden_002.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_ou_garden' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_ou_garden_003.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_ou_garden' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_ou_garden_004.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_ou_garden' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_ou_garden_005.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_ou_garden' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_ou_garden_006.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_ou_garden' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_ou_garden_007.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_ou_garden' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_ou_garden_008.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_ou_garden' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_ou_garden_009.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_ou_garden' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_yi_garden_001.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_yi_garden' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_yi_garden_010.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_yi_garden' AND sort_order=9;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_yi_garden_002.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_yi_garden' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_yi_garden_003.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_yi_garden' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_yi_garden_004.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_yi_garden' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_yi_garden_005.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_yi_garden' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_yi_garden_006.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_yi_garden' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_yi_garden_007.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_yi_garden' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_yi_garden_008.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_yi_garden' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_yi_garden_009.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_yi_garden' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_museum_001.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_museum' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_museum_010.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_museum' AND sort_order=9;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_museum_002.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_museum' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_museum_003.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_museum' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_museum_004.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_museum' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_museum_005.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_museum' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_museum_006.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_museum' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_museum_007.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_museum' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_museum_008.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_museum' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_museum_009.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_museum' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_tuisi_garden_001.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_tuisi_garden' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_tuisi_garden_010.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_tuisi_garden' AND sort_order=9;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_tuisi_garden_002.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_tuisi_garden' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_tuisi_garden_003.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_tuisi_garden' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_tuisi_garden_004.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_tuisi_garden' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_tuisi_garden_005.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_tuisi_garden' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_tuisi_garden_006.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_tuisi_garden' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_tuisi_garden_007.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_tuisi_garden' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_tuisi_garden_008.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_tuisi_garden' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_tuisi_garden_009.mp3', updated_at=NOW()
WHERE attraction_id='suzhou_tuisi_garden' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_jiujie_001.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_jiujie' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_jiujie_002.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_jiujie' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_jiujie_003.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_jiujie' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_jiujie_004.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_jiujie' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_shibati_001.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_shibati' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_shibati_002.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_shibati' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_shibati_003.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_shibati' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_shibati_004.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_shibati' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_mountain_trails_001.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_mountain_trails' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_mountain_trails_002.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_mountain_trails' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_mountain_trails_003.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_mountain_trails' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_mountain_trails_004.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_mountain_trails' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_liziba_monorail_001.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_liziba_monorail' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_liziba_monorail_002.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_liziba_monorail' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_liziba_monorail_003.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_liziba_monorail' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_liziba_monorail_004.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_liziba_monorail' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_liziba_monorail_005.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_liziba_monorail' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_liziba_monorail_006.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_liziba_monorail' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_raffles_city_001.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_raffles_city' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_raffles_city_002.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_raffles_city' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_raffles_city_003.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_raffles_city' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_raffles_city_004.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_raffles_city' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_hongya_cave_001.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_hongya_cave' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_hongya_cave_010.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_hongya_cave' AND sort_order=9;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_hongya_cave_011.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_hongya_cave' AND sort_order=10;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_hongya_cave_012.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_hongya_cave' AND sort_order=11;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_hongya_cave_013.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_hongya_cave' AND sort_order=12;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_hongya_cave_014.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_hongya_cave' AND sort_order=13;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_hongya_cave_015.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_hongya_cave' AND sort_order=14;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_hongya_cave_002.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_hongya_cave' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_hongya_cave_003.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_hongya_cave' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_hongya_cave_004.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_hongya_cave' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_hongya_cave_005.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_hongya_cave' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_hongya_cave_006.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_hongya_cave' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_hongya_cave_007.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_hongya_cave' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_hongya_cave_008.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_hongya_cave' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_hongya_cave_009.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_hongya_cave' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_baixiangju_001.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_baixiangju' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_baixiangju_002.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_baixiangju' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_baixiangju_003.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_baixiangju' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_baixiangju_004.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_baixiangju' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_ciqikou_old_town_001.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_ciqikou_old_town' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_ciqikou_old_town_010.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_ciqikou_old_town' AND sort_order=9;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_ciqikou_old_town_002.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_ciqikou_old_town' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_ciqikou_old_town_003.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_ciqikou_old_town' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_ciqikou_old_town_004.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_ciqikou_old_town' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_ciqikou_old_town_005.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_ciqikou_old_town' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_ciqikou_old_town_006.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_ciqikou_old_town' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_ciqikou_old_town_007.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_ciqikou_old_town' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_ciqikou_old_town_008.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_ciqikou_old_town' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_ciqikou_old_town_009.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_ciqikou_old_town' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_guanyinqiao_001.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_guanyinqiao' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_guanyinqiao_002.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_guanyinqiao' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_guanyinqiao_003.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_guanyinqiao' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_guanyinqiao_004.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_guanyinqiao' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_guanyinqiao_005.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_guanyinqiao' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_jiefangbei_001.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_jiefangbei' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_jiefangbei_002.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_jiefangbei' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_jiefangbei_003.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_jiefangbei' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_jiefangbei_004.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_jiefangbei' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_jiefangbei_005.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_jiefangbei' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_jiefangbei_006.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_jiefangbei' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_zoo_001.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_zoo' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_zoo_002.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_zoo' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_zoo_003.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_zoo' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_zoo_004.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_zoo' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_zoo_005.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_zoo' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_jinfo_mountain_001.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_jinfo_mountain' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_jinfo_mountain_010.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_jinfo_mountain' AND sort_order=9;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_jinfo_mountain_011.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_jinfo_mountain' AND sort_order=10;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_jinfo_mountain_012.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_jinfo_mountain' AND sort_order=11;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_jinfo_mountain_013.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_jinfo_mountain' AND sort_order=12;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_jinfo_mountain_014.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_jinfo_mountain' AND sort_order=13;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_jinfo_mountain_015.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_jinfo_mountain' AND sort_order=14;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_jinfo_mountain_002.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_jinfo_mountain' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_jinfo_mountain_003.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_jinfo_mountain' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_jinfo_mountain_004.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_jinfo_mountain' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_jinfo_mountain_005.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_jinfo_mountain' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_jinfo_mountain_006.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_jinfo_mountain' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_jinfo_mountain_007.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_jinfo_mountain' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_jinfo_mountain_008.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_jinfo_mountain' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_jinfo_mountain_009.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_jinfo_mountain' AND sort_order=8;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_yangtze_cableway_001.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_yangtze_cableway' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_yangtze_cableway_002.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_yangtze_cableway' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_yangtze_cableway_003.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_yangtze_cableway' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_eling_2nd_factory_001.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_eling_2nd_factory' AND sort_order=0;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_eling_2nd_factory_010.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_eling_2nd_factory' AND sort_order=9;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_eling_2nd_factory_011.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_eling_2nd_factory' AND sort_order=10;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_eling_2nd_factory_012.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_eling_2nd_factory' AND sort_order=11;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_eling_2nd_factory_013.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_eling_2nd_factory' AND sort_order=12;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_eling_2nd_factory_014.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_eling_2nd_factory' AND sort_order=13;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_eling_2nd_factory_002.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_eling_2nd_factory' AND sort_order=1;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_eling_2nd_factory_003.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_eling_2nd_factory' AND sort_order=2;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_eling_2nd_factory_004.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_eling_2nd_factory' AND sort_order=3;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_eling_2nd_factory_005.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_eling_2nd_factory' AND sort_order=4;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_eling_2nd_factory_006.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_eling_2nd_factory' AND sort_order=5;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_eling_2nd_factory_007.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_eling_2nd_factory' AND sort_order=6;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_eling_2nd_factory_008.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_eling_2nd_factory' AND sort_order=7;

UPDATE sub_areas
SET audio_url='https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_eling_2nd_factory_009.mp3', updated_at=NOW()
WHERE attraction_id='chongqing_eling_2nd_factory' AND sort_order=8;
