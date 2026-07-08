-- Beijing sub_areas seed (generated)
-- cover_image_path is full public URL from Supabase Storage

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_beihai_park_bj_sa_01',
  'beijing_beihai_park',
  'south gate circular city',
  '南门与团城 / South Gate & Circular City',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_beihai_park_bj_sa_01.jpg',
  '<p>- **名字 / Name：** 南门与团城 / South Gate &amp; Circular City<br>- **摘要 / Summary：** 北海公园的正门入口与承载千年历史的微型城堡，团城珍藏元代白玉佛与乾隆珍宝。 The main entrance to Beihai Park and a miniature castle steeped in a millennium of history, home to a Yuan-dynasty white jade Buddha and Emperor Qianlong''s treasures.<br>- **长文描述 / Description：** 南门是北海公园最主要的入口，门前广场开阔，古木参天，步入即感皇家气派。门内紧邻团城——一座建于金代、元代扩修的圆形城台，面积仅四千余平方米，却浓缩了极高的建筑与文物价值。团城上的承光殿供奉着元代整玉雕成的白玉佛，殿前玉瓮亭内陈放元世祖忽必烈时期的渎山大玉海，堪称国宝级文物。城台四周古松苍翠，城墙以青砖砌筑，是园林中罕见的军事建筑遗存，登城可俯瞰北海全景。 The South Gate is the principal entrance to Beihai Park, framed by a spacious plaza and towering ancient trees that immediately convey a regal atmosphere. Just inside the gate lies the Circular City (Tuancheng), a round platform first built in the Jin dynasty and expanded under the Yuan. Though barely four thousand square metres, it packs extraordinary architectural and cultural value. The Chengguang Hall on the platform houses a white jade Buddha carved from a single block of jade in the Yuan dynasty, and the Jade Urn Pavilion before it displays the Dushan Great Jade Sea, a wine vessel from Kublai Khan''s reign—both national treasures. Ancient pines ring the platform, whose grey-brick walls are a rare military-architectural remnant within a garden; climbing up affords a panoramic view of the entire Beihai lake and park.<br>- **详细地址 / Address：** 北京市西城区文津街1号（南门位于公园南侧文津街） / No. 1 Wenjin Street, Xicheng District, Beijing (South Gate on the south side along Wenjin Street)<br>- **门票信息 / Ticket Information：** 旺季（4月-10月）10元/淡季（11月-3月）5元；联票（含琼华岛等）旺季20元/淡季15元 / Peak season (Apr–Oct) ¥10 / Off-peak (Nov–Mar) ¥5; combined ticket (incl. Jade Flower Island) peak ¥20 / off-peak ¥15<br>- **开放时间 / Opening Hours：** 旺季6:00-21:00（20:30停止入园），淡季6:30-20:00（19:30停止入园） / Peak season 6:00–21:00 (last entry 20:30); off-peak 6:30–20:00 (last entry 19:30)<br>- **交通信息 / Transportation：** 乘5路、101路、109路等公交至北海站下车，步行至南门；地铁6号线北海北站步行约10分钟 / Bus routes 5, 101, 109 etc. to Beihai stop, then walk to South Gate; Subway Line 6 Beihai North station, walk approx. 10 min</p><p>---</p>',
  '',
  0,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_beihai_park_bj_sa_02',
  'beijing_beihai_park',
  'yong an bridge',
  '永安桥 / Yong''an Bridge',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_beihai_park_bj_sa_02.jpg',
  '<p>- **名字 / Name：** 永安桥 / Yong''an Bridge<br>- **摘要 / Summary：** 连接南岸与琼华岛的三孔汉白玉石拱桥，桥身洁白如玉，是入园后通往白塔的第一道风景。 A three-arch white-marble bridge linking the south shore to Jade Flower Island, its jade-white span is the first landmark on the way to the White Dagoba.<br>- **长文描述 / Description：** 永安桥始建于元代，清代重修，是北海公园最具代表性的桥梁建筑。桥长四十余米，宽近九米，三孔拱券造型优美，全部以汉白玉石砌筑，栏杆望柱上雕有莲瓣纹饰，桥面微拱如虹。桥南端连接团城，北端直通琼华岛永安寺山门，既是实用通道，也是绝佳的观景平台。站在桥上，南望团城古松，北仰白塔巍峨，东西碧波荡漾，荷花映日，是北海最经典的构图之一。每逢雪后，白石桥身与白雪融为一体，宛若仙境，故有"永安雪霁"之誉。 Yong''an Bridge, first built in the Yuan dynasty and rebuilt in the Qing, is the park''s most iconic bridge. Over forty metres long and nearly nine metres wide, it features three graceful arches constructed entirely of white marble; the balustrade posts are carved with lotus-petal motifs, and the deck arches gently like a rainbow. The south end connects the Circular City, while the north end leads directly into the mountain gate of Yong''an Temple on Jade Flower Island—both a practical crossing and a superb viewing platform. Standing on the bridge, one looks south to ancient pines on Tuancheng, north to the towering White Dagoba, and east and west across rippling lotus-dotted waters—the quintessential Beihai composition. After snowfall the white-marble bridge merges with the snow into a fairyland, earning the phrase "Yong''an Snow Clearing."<br>- **详细地址 / Address：** 北京市西城区文津街1号（永安桥位于南门与琼华岛之间） / No. 1 Wenjin Street, Xicheng District, Beijing (bridge between South Gate and Jade Flower Island)<br>- **门票信息 / Ticket Information：** 包含在北海公园门票内，无需额外购票 / Included in general park admission; no extra ticket required<br>- **开放时间 / Opening Hours：** 旺季6:00-21:00（20:30停止入园），淡季6:30-20:00（19:30停止入园） / Peak season 6:00–21:00 (last entry 20:30); off-peak 6:30–20:00 (last entry 19:30)<br>- **交通信息 / Transportation：** 乘5路、101路、109路等公交至北海站；地铁6号线北海北站步行约5分钟至北门，再沿东岸步行至南门方向 / Bus routes 5, 101, 109 to Beihai stop; Subway Line 6 Beihai North station, walk ~5 min to North Gate then along east shore toward South Gate</p><p>---</p>',
  '',
  1,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_beihai_park_bj_sa_03',
  'beijing_beihai_park',
  'jade flower island yong an temple white dagoba',
  '琼华岛·永安寺与白塔 / Jade Flower Island · Yong''an Temple & White Dagoba',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_beihai_park_bj_sa_03.png',
  '<p>- **名字 / Name：** 琼华岛·永安寺与白塔 / Jade Flower Island · Yong''an Temple &amp; White Dagoba<br>- **摘要 / Summary：** 北海公园的核心地标，藏式白塔耸立山顶，永安寺依山而建，为五朝御苑的精神象征。 The heart of Beihai Park: a Tibetan-style White Dagoba crowns the hilltop and Yong''an Temple climbs the slope—the spiritual emblem of five dynasties'' imperial gardens.<br>- **长文描述 / Description：** 琼华岛是北海湖心岛，也是全园制高点与视觉中心。岛上永安寺始建于清顺治八年（1651年），为乾隆时期重修扩建，依山势层层递进，从山门的法轮殿到高处的正觉殿，殿宇庄严，香火绵延。山顶白塔高35.9米，为藏式覆钵式塔，塔身洁白，塔顶铜质华盖与日、月鎏金装饰在阳光下熠熠生辉。白塔初建是为迎接西藏五世达赖喇嘛来京，兼具政治与宗教意义。登塔环眺，故宫红墙黄瓦、中轴线全景、西山峰峦尽收眼底，是北京城区最壮观的观景点之一。 Jade Flower Island is the lake-centred hill and the park''s highest point and visual anchor. Yong''an Temple on the island was founded in 1651 (Shunzhi 8) and expanded under Qianlong, ascending the slope in layered courtyards—from the Falun Hall at the mountain gate to the Zhengjue Hall above, the halls are solemn and incense has burned here for centuries. The White Dagoba at the summit stands 35.9 metres tall in Tibetan stupa form; its gleaming white body is crowned by a bronze canopy and gilded sun-and-moon finials that flash in sunlight. It was first erected to welcome the Fifth Dalai Lama to Beijing, bearing both political and religious significance. From the top, sweeping views capture the Forbidden City''s red walls and yellow roofs, the entire central axis, and the Western Hills—one of the most magnificent urban panoramas in Beijing.<br>- **详细地址 / Address：** 北京市西城区文津街1号（琼华岛位于北海湖心） / No. 1 Wenjin Street, Xicheng District, Beijing (Jade Flower Island in the centre of Beihai Lake)<br>- **门票信息 / Ticket Information：** 联票旺季20元/淡季15元（含白塔登塔）；普通门票旺季10元/淡季5元（不含白塔） / Combined ticket peak ¥20 / off-peak ¥15 (incl. Dagoba ascent); general admission peak ¥10 / off-peak ¥5 (excl. Dagoba)<br>- **开放时间 / Opening Hours：** 旺季6:00-21:00（白塔8:00-18:00），淡季6:30-20:00（白塔8:00-17:00） / Peak season park 6:00–21:00, Dagoba 8:00–18:00; off-peak park 6:30–20:00, Dagoba 8:00–17:00<br>- **交通信息 / Transportation：** 从南门经永安桥步行上岛约5分钟；地铁6号线北海北站至北门后沿东岸南行可达永安桥 / Walk across Yong''an Bridge from South Gate—approx. 5 min; Subway Line 6 Beihai North station → North Gate → walk south along east shore to Yong''an Bridge</p><p>---</p>',
  '',
  2,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_beihai_park_bj_sa_04',
  'beijing_beihai_park',
  'jade flower island qiong island spring shade stele yuegu tower',
  '琼华岛·琼岛春阴碑与阅古楼 / Jade Flower Island · Qiong Island Spring Shade Stele & Yuegu Tower',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_beihai_park_bj_sa_04.jpg',
  '<p>- **名字 / Name：** 琼华岛·琼岛春阴碑与阅古楼 / Jade Flower Island · Qiong Island Spring Shade Stele &amp; Yuegu Tower<br>- **摘要 / Summary：** "琼岛春阴"为金代燕京八景之一，碑刻乾隆御笔；阅古楼珍藏三希堂法帖石刻，为书法圣地。 "Qiong Island Spring Shade" is one of the eight classic scenes of Yanjing from the Jin dynasty, inscribed with Qianlong''s calligraphy; Yuegu Tower houses the Three Rarities Hall calligraphy rubbings in stone—a calligraphy shrine.<br>- **长文描述 / Description：** 琼岛春阴碑立于琼华岛东侧半山腰，碑身高大，正面刻"琼岛春阴"四字，为乾隆皇帝手书，背面刻乾隆御制诗。此景源自金代"燕京八景"，描绘北海春日岛上树影婆娑、烟岚轻笼之态，是北京最古老的风景审美传统。碑旁古木浓荫，春日海棠、碧桃盛开，与碑文意境相映成趣。阅古楼位于岛西北侧，为乾隆年间修建的半月形两层楼阁，专门收藏《三希堂法帖》石刻。法帖收录自魏晋至明末340余位书法名家的作品，刻石495方，是中国书法史上规模最大的石刻法帖集，堪称翰墨宝库。 The Qiong Island Spring Shade Stele stands on the mid-slope of Jade Flower Island''s east side. Its tall shaft bears four characters "Qiong Island Spring Shade" in Emperor Qianlong''s own hand, with his poem on the reverse. This scene originates from the "Eight Views of Yanjing" of the Jin dynasty, depicting the island''s dappled tree shadows and veiling mists in spring—the oldest landscape-aesthetic tradition in Beijing. Ancient trees cast deep shade around the stele, and in spring blooming crabapples and flowering peaches echo the inscription''s mood. Yuegu Tower, on the island''s northwest side, is a semi-circular two-storey pavilion built under Qianlong to house the Three Rarities Hall Model Calligraphy (Sanxitang Fatie) in stone. The collection gathers works by over 340 master calligraphers from Wei-Jin to late Ming, carved on 495 stone tablets—the largest engraved calligraphy anthology in Chinese history, a true treasury of brush and ink.<br>- **详细地址 / Address：** 北京市西城区文津街1号（琼华岛东侧及西北侧） / No. 1 Wenjin Street, Xicheng District, Beijing (east and northwest sides of Jade Flower Island)<br>- **门票信息 / Ticket Information：** 包含在联票内（旺季20元/淡季15元） / Included in combined ticket (peak ¥20 / off-peak ¥15)<br>- **开放时间 / Opening Hours：** 随琼华岛开放，旺季8:00-18:00/淡季8:00-17:00 / Follows Jade Flower Island hours: peak 8:00–18:00 / off-peak 8:00–17:00<br>- **交通信息 / Transportation：** 从南门经永安桥上岛后沿山路步行约10分钟可达碑刻处 / From South Gate via Yong''an Bridge, follow hill paths approx. 10 min to the stele</p><p>---</p>',
  '',
  3,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_beihai_park_bj_sa_05',
  'beijing_beihai_park',
  'jade flower island yilan hall daoning studio bronze immortal holding dew plate',
  '琼华岛·漪澜堂、道宁斋与铜仙承露盘 / Jade Flower Island · Yilan Hall, Daoning Studio & Bronze Immortal Holding Dew Plate',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_beihai_park_bj_sa_05.jpg',
  '<p>- **名字 / Name：** 琼华岛·漪澜堂、道宁斋与铜仙承露盘 / Jade Flower Island · Yilan Hall, Daoning Studio &amp; Bronze Immortal Holding Dew Plate<br>- **摘要 / Summary：** 琼华岛北坡的临水殿宇与汉代风格的铜仙承露盘，既是乾隆理政之所，也是中国最早的"天人沟通"符号。 Waterfront halls on Jade Flower Island''s north slope where Qianlong handled affairs, and a Han-style bronze immortal gathering dew—the earliest Chinese symbol of "communication between heaven and man."<br>- **长文描述 / Description：** 漪澜堂与道宁斋位于琼华岛北坡临湖处，是岛上最重要的宫殿建筑群。漪澜堂面阔五间，前廊临水，乾隆帝常在此批阅奏章、赏景品茶；道宁斋为其书斋，取名意为"道在于宁"，幽静雅致。两殿均仿江南园林风格，虽为皇家建筑却有文人意趣。殿后高处矗立铜仙承露盘——一尊铜铸仙人双手高举承露盘，立于石柱之上，造型仿汉代建章宫承露盘遗制。相传汉武帝以铜仙承接天露，炼制仙丹；清代乾隆复铸此像，寓意天人相通、承接天恩。铜仙通体鎏金，阳光下金光闪耀，是北海最具神秘色彩的标志性造像。 Yilan Hall and Daoning Studio sit on Jade Flower Island''s north slope directly above the lake, forming the island''s most important palatial complex. Yilan Hall, five bays wide with a waterfront veranda, was where Emperor Qianlong often reviewed memorials and enjoyed the scenery over tea; Daoning Studio was his study, its name meaning "the Way lies in tranquillity"—quiet and refined. Both halls imitate Jiangnan garden style, blending imperial scale with literati sensibility. Behind them, on a higher terrace, stands the Bronze Immortal Holding a Dew Plate—a copper figure with both hands raised holding a plate, mounted on a stone column, replicating the Han-dynasty Jianzhang Palace dew-receiver. Legend says Emperor Wu of Han used such a figure to gather heavenly dew for elixirs; Qianlong recast it as a symbol of communion between heaven and man, receiving divine grace. The figure is fully gilded, blazing in sunlight, and is Beihai''s most mystically charged landmark.<br>- **详细地址 / Address：** 北京市西城区文津街1号（琼华岛北坡临湖处） / No. 1 Wenjin Street, Xicheng District, Beijing (north slope of Jade Flower Island above the lake)<br>- **门票信息 / Ticket Information：** 包含在联票内（旺季20元/淡季15元） / Included in combined ticket (peak ¥20 / off-peak ¥15)<br>- **开放时间 / Opening Hours：** 随琼华岛开放，旺季8:00-18:00/淡季8:00-17:00 / Follows Jade Flower Island hours: peak 8:00–18:00 / off-peak 8:00–17:00<br>- **交通信息 / Transportation：** 从北门沿东岸步行至永安桥上岛，顺山路北行约15分钟 / From North Gate along east shore to Yong''an Bridge, then follow north hill path approx. 15 min</p><p>---</p>',
  '',
  4,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_beihai_park_bj_sa_06',
  'beijing_beihai_park',
  'east shore haopu retreat painted boat studio',
  '东岸·濠濮间与画舫斋 / East Shore · Haopu Retreat & Painted Boat Studio',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_beihai_park_bj_sa_06.jpg',
  '<p>- **名字 / Name：** 东岸·濠濮间与画舫斋 / East Shore · Haopu Retreat &amp; Painted Boat Studio<br>- **摘要 / Summary：** 濠濮间是隐于东岸山石间的水院幽境，画舫斋为仿舟形水上书斋，尽显皇家"小隐"哲学。 Haopu Retreat is a hidden water courtyard tucked among east-shore rocks; the Painted Boat Studio mimics a moored vessel—a supreme expression of the imperial "small retreat" philosophy.<br>- **长文描述 / Description：** 濠濮间位于北海东岸中部，是一处极为精巧的园中水院。入口曲径通幽，穿过叠石假山与垂花门，方见一方水池环以廊庑，池中架小石桥，桥头濠濮间匾额为乾隆御笔。"濠濮"取自庄子濠梁之辩与濮水垂钓的典故，寓意超然物外、鱼乐自得。此处远离殿宇喧嚣，是园中最具文人隐逸气质的角落。画舫斋紧邻濠濮间以北，主体建筑仿船形建于水上，三面临水，内部却完全按书斋格局布置，前厅名"春雨淋塘"，后室曰"观妙"，乾隆常在此读书赋诗。斋外回廊曲折，古藤缠绕，夏日荷风送爽，是消暑佳处。 Haopu Retreat lies mid-way along Beihai''s east shore—an exquisitely crafted enclosed water courtyard. A winding path leads through artificial rockwork and a festooned gate before revealing a pool ringed by corridors, a tiny stone bridge at its centre, and the Haopu plaque in Qianlong''s calligraphy. "Haopu" references Zhuangzi''s debate on the Hao Bridge and his fishing by the Pu River, evoking detachment and fish-happy self-sufficiency. Remote from palatial noise, this is the garden''s most literati-hermitic corner. The Painted Boat Studio (Huafang Zhai) sits just north of Haopu, its main building shaped like a boat moored on water, yet its interior follows a scholar''s layout—the front room named "Spring Rain on the Pond," the rear "Observing Wonder." Qianlong often read and composed poetry here. Winding corridors outside, draped in old vines, bring cool lotus-scented breezes in summer—an ideal retreat from heat.<br>- **详细地址 / Address：** 北京市西城区文津街1号（北海东岸中部） / No. 1 Wenjin Street, Xicheng District, Beijing (mid-section of east shore)<br>- **门票信息 / Ticket Information：** 包含在公园普通门票内（旺季10元/淡季5元） / Included in general admission (peak ¥10 / off-peak ¥5)<br>- **开放时间 / Opening Hours：** 随公园开放，旺季6:00-21:00/淡季6:30-20:00 / Follows park hours: peak 6:00–21:00 / off-peak 6:30–20:00<br>- **交通信息 / Transportation：** 地铁6号线北海北站B口出，步行约5分钟至北门，沿东岸南行约10分钟 / Subway Line 6 Beihai North station Exit B, walk ~5 min to North Gate, then south along east shore approx. 10 min</p><p>---</p>',
  '',
  5,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_beihai_park_bj_sa_07',
  'beijing_beihai_park',
  'jingxin studio quiet heart studio',
  '静心斋 / Jingxin Studio (Quiet Heart Studio)',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_beihai_park_bj_sa_07.jpg',
  '<p>- **名字 / Name：** 静心斋 / Jingxin Studio (Quiet Heart Studio)<br>- **摘要 / Summary：** 北海园中园之冠，乾隆仿江南园林打造的私用别院，叠石理水堪称皇家造园艺术巅峰。 The crown jewel of Beihai''s "garden within a garden"—Qianlong''s private retreat modelled on Jiangnan gardens, its rockwork and water design representing the pinnacle of imperial landscape art.<br>- **长文描述 / Description：** 静心斋位于北海北岸西北角，始建于乾隆二十二年（1757年），初名"静清斋"，后改今名。这是乾隆皇帝专门为自己修建的读书休憩之所，仿照江南私家园林格局，占地约八千平方米，却包罗叠石假山、曲池回廊、亭台楼阁、小桥流水等一切园林要素，堪称"小中见大"的极致范例。园内沁泉廊横跨水面，叠翠楼高踞假山之巅，焙茶坞、韵琴斋等小巧殿宇散布其间，空间层次极为丰富。太湖石假山嶙峋多姿，山洞幽深，步移景异。慈禧太后曾在此避暑理政，袁世凯亦将其作为外交议事场所，可见此园之妙，古今共赏。 Jingxin Studio occupies the northwest corner of Beihai''s north shore. Founded in 1757 (Qianlong 22) as "Jingqing Studio" and later renamed, it was the emperor''s personal reading-and-resting retreat, modelled on Jiangnan private gardens. Though only about eight thousand square metres, it contains rockwork hills, winding pools, cloistered corridors, pavilions, tiny bridges and flowing water—every garden element packed into a "small yet vast" masterclass. The Qinquan Corridor spans the water; Diedie Tower crowns the artificial hill; the Bake-Tea Hut and String-Music Studio scatter among rich spatial layers. Taihu limestone crags are jagged and varied, their caves deep, shifting vistas with every step. Empress Dowager Cixi summered and governed here; Yuan Shikai used it for diplomatic talks—proof that this garden''s magic has enchanted every era.<br>- **详细地址 / Address：** 北京市西城区文津街1号（北海北岸西北角） / No. 1 Wenjin Street, Xicheng District, Beijing (northwest corner of north shore)<br>- **门票信息 / Ticket Information：** 需另购静心斋门票10元（不含在联票内） / Separate ticket ¥10 (not included in combined ticket)<br>- **开放时间 / Opening Hours：** 旺季9:00-18:00/淡季9:00-17:00 / Peak 9:00–18:00 / off-peak 9:00–17:00<br>- **交通信息 / Transportation：** 地铁6号线北海北站B口出步行至北门，进园后西行约5分钟 / Subway Line 6 Beihai North station Exit B → North Gate, then walk west approx. 5 min inside park</p><p>---</p>',
  '',
  6,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_beihai_park_bj_sa_08',
  'beijing_beihai_park',
  'western heavenly paradise nine dragon wall',
  '西天梵境与九龙壁 / Western Heavenly Paradise & Nine-Dragon Wall',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_beihai_park_bj_sa_08.jpg',
  '<p>- **名字 / Name：** 西天梵境与九龙壁 / Western Heavenly Paradise &amp; Nine-Dragon Wall<br>- **摘要 / Summary：** 北海北岸的皇家佛寺与全国仅存三座双面九龙壁之一，琉璃烧制工艺登峰造极。 A imperial Buddhist temple on the north shore and one of only three surviving double-sided Nine-Dragon Walls in China—glazed-tile craftsmanship at its zenith.<br>- **长文描述 / Description：** 西天梵境（又称大西天）位于北海北岸中段，始建于明代，清代重修，是皇家御用佛寺。寺内大雄宝殿供奉三世佛，殿前经幢、香炉均为清代精品，殿宇黄琉璃瓦绿剪边，等级仅次于皇宫。寺后原有宏大塔院，今虽部分损毁，仍可窥见昔日的恢弘格局。九龙壁紧邻西天梵境东侧，建于乾隆二十一年（1756年），长25.86米，高6.65米，厚1.42米，两面各饰九条琉璃龙，共18条，色彩以黄、绿、蓝、紫、白五色为主，龙姿各异，腾跃于云海波涛之间。这是中国现存三座双面九龙壁中保存最完好、工艺最精湛的一座，每一条龙鳞甲毕现，须发飞扬，堪称清代琉璃艺术的绝品。 Western Heavenly Paradise (also called Great Western Heaven) sits mid-section of Beihai''s north shore. Founded in the Ming and rebuilt in the Qing, it served as the imperial family''s private Buddhist temple. The Mahavira Hall inside enshrines the Three Buddhas; the stone pillars and incense burners before it are Qing masterworks. The hall''s yellow-glazed tiles with green trim denote a rank just below the palace itself. Behind the temple once stood a grand stupa courtyard, now partially lost yet still hinting at its former majesty. The Nine-Dragon Wall stands immediately east of the temple, built in 1756 (Qianlong 21). It measures 25.86 m long, 6.65 m high, and 1.42 m thick, with nine glazed dragons on each face—18 in total—in yellow, green, blue, purple and white. Each dragon poses differently, leaping through cloud-seas and wave-crests. This is the best-preserved and most skillfully crafted of China''s three surviving double-sided Nine-Dragon Walls; every scale is delineated, every whisker flies—a supreme achievement of Qing glazed-tile art.<br>- **详细地址 / Address：** 北京市西城区文津街1号（北海北岸中段） / No. 1 Wenjin Street, Xicheng District, Beijing (mid-section of north shore)<br>- **门票信息 / Ticket Information：** 包含在联票内（旺季20元/淡季15元） / Included in combined ticket (peak ¥20 / off-peak ¥15)<br>- **开放时间 / Opening Hours：** 随公园开放，旺季6:00-21:00/淡季6:30-20:00 / Follows park hours: peak 6:00–21:00 / off-peak 6:30–20:00<br>- **交通信息 / Transportation：** 地铁6号线北海北站步行至北门，沿北岸东行约10分钟；或乘5路公交至北海站步行 / Subway Line 6 Beihai North station → North Gate, walk east along north shore approx. 10 min; or Bus 5 to Beihai stop then walk</p><p>---</p>',
  '',
  7,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_beihai_park_bj_sa_09',
  'beijing_beihai_park',
  'kuai xue tang quick snow hall iron shadow wall',
  '快雪堂与铁影壁 / Kuai Xue Tang (Quick Snow Hall) & Iron Shadow Wall',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_beihai_park_bj_sa_09.jpg',
  '<p>- **名字 / Name：** 快雪堂与铁影壁 / Kuai Xue Tang (Quick Snow Hall) &amp; Iron Shadow Wall<br>- **摘要 / Summary：** 乾隆以松木仿建的王羲之书法陈列馆与元代 volcanic-rock 影壁，一文一武，古今对话。 Qianlong''s timber-built gallery honouring Wang Xizhi''s calligraphy and a Yuan-dynasty volcanic-rock shadow wall—one cultured, one rugged, a dialogue across ages.<br>- **长文描述 / Description：** 快雪堂位于北海北岸，介于西天梵境与阐福寺之间，始建于乾隆四十四年（1779年）。乾隆帝痴迷王羲之书法，特命以松木仿江南式样建造此堂，专门陈列《快雪时晴帖》摹刻及历代名家法帖石刻。堂内楠木装修精美，庭院疏朗，虽为皇家建筑却尽显文人雅趣，是园中书法文化的又一重镇。铁影壁原位于德胜门内，元代遗物，后移至北海。影壁以火山岩（俗称"铁石"）雕成，质地坚硬如铁，故名"铁影壁"。壁面浮雕狮、犀牛等瑞兽，刀法浑厚古拙，保留了元代雕塑粗犷有力的风格，是北京现存极少数元代石雕实物之一，与快雪堂的精致文雅形成鲜明对照，一文一武，古今映照。 Kuai Xue Tang sits on Beihai''s north shore between Western Heavenly Paradise and Chanfu Temple, founded in 1779 (Qianlong 44). Obsessed with Wang Xizhi''s brushwork, the emperor ordered this hall built in pine-wood Jiangnan style to house engraved reproductions of the "Quick Snow Clearing" letter and other master calligraphy rubbings in stone. Fine nanmu woodwork graces the interior; the courtyard is open and airy—an imperial building that radiates literati refinement, another bastion of calligraphy culture in the park. The Iron Shadow Wall, a Yuan-dynasty relic originally at Desheng Gate, was later moved here. Carved from volcanic rock (locally called "iron stone"), it is so hard it earned the name "Iron Shadow Wall." Relief carvings of lions and rhinoceroses on its faces are bold and archaic, preserving the rugged vigour of Yuan sculpture—one of Beijing''s few surviving Yuan stone-carving artefacts. Its stark power contrasts vividly with Kuai Xue Tang''s delicate grace—one martial, one literary, mirroring each other across time.<br>- **详细地址 / Address：** 北京市西城区文津街1号（北海北岸，西天梵境与阐福寺之间） / No. 1 Wenjin Street, Xicheng District, Beijing (north shore, between Western Heavenly Paradise and Chanfu Temple)<br>- **门票信息 / Ticket Information：** 包含在公园普通门票内（旺季10元/淡季5元） / Included in general admission (peak ¥10 / off-peak ¥5)<br>- **开放时间 / Opening Hours：** 随公园开放，旺季6:00-21:00/淡季6:30-20:00 / Follows park hours: peak 6:00–21:00 / off-peak 6:30–20:00<br>- **交通信息 / Transportation：** 地铁6号线北海北站步行至北门，沿北岸西行约8分钟 / Subway Line 6 Beihai North station → North Gate, walk west along north shore approx. 8 min</p><p>---</p>',
  '',
  8,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_beihai_park_bj_sa_10',
  'beijing_beihai_park',
  'chanfu temple little western heaven',
  '阐福寺与小西天 / Chanfu Temple & Little Western Heaven',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_beihai_park_bj_sa_10.jpg',
  '<p>- **名字 / Name：** 阐福寺与小西天 / Chanfu Temple &amp; Little Western Heaven<br>- **摘要 / Summary：** 乾隆为母祈福而建的皇家佛寺与仿观音道场的宏大方亭，琉璃辉映，气象万千。 A imperial temple Qianlong built to bless his mother and a grand square pavilion mimicking a Bodhisattva paradise—glazed tiles ablaze, vistas boundless.<br>- **长文描述 / Description：** 阐福寺位于北海北岸西段，始建于乾隆二十五年（1760年），是乾隆帝为崇庆皇太后祈福所建。寺内大殿面阔七间，黄琉璃瓦覆顶，等级崇高，殿内曾供奉千手千眼观音大士铜像，惜已不存。寺前钟鼓楼、山门格局完整，至今仍可见皇家佛寺的庄严肃穆。小西天紧邻阐福寺北侧，建于乾隆三十五年（1770年），是为崇庆皇太后八十大寿而建的仿南海观音道场。主建筑极乐世界方亭面阔52.23米，进深42.32米，是国内最大的方亭式建筑，内部四壁悬塑南海观音普渡众生场景，五百罗汉渡海形象栩栩如生，外部琉璃瓦五彩斑斓，辉映湖光，气象极为壮丽。 Chanfu Temple stands on the west segment of Beihai''s north shore, founded in 1760 (Qianlong 25) as Emperor Qianlong''s votive offering for his mother''s longevity. The main hall spans seven bays under yellow glazed tiles—a lofty rank—and once housed a bronze Thousand-Armed Thousand-Eyed Avalokiteshvara, now lost. The bell tower, drum tower and mountain gate remain intact, still conveying the solemnity of an imperial Buddhist sanctuary. Little Western Heaven (Xiao Xitian) lies just north of Chanfu Temple, built in 1770 (Qianlong 35) for the empress dowager''s eightieth birthday, mimicking the South Sea Bodhisattva realm. Its central "Pure Land" square pavilion measures 52.23 m wide and 42.32 m deep—the largest square-pavilion structure in China. Inside, the four walls carry suspended sculptures of Avalokiteshvara rescuing sentient beings; five hundred arhats crossing the sea are vividly alive. Outside, multicoloured glazed tiles blaze against the lake light—a vision of staggering grandeur.<br>- **详细地址 / Address：** 北京市西城区文津街1号（北海北岸西段） / No. 1 Wenjin Street, Xicheng District, Beijing (west segment of north shore)<br>- **门票信息 / Ticket Information：** 包含在联票内（旺季20元/淡季15元） / Included in combined ticket (peak ¥20 / off-peak ¥15)<br>- **开放时间 / Opening Hours：** 随公园开放，旺季6:00-21:00/淡季6:30-20:00 / Follows park hours: peak 6:00–21:00 / off-peak 6:30–20:00<br>- **交通信息 / Transportation：** 地铁6号线北海北站步行至北门，沿北岸西行约15分钟；或乘13路、42路公交至北海北门站 / Subway Line 6 Beihai North station → North Gate, walk west along north shore approx. 15 min; or Bus 13/42 to Beihai North Gate stop</p><p>---</p>',
  '',
  9,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_beihai_park_bj_sa_11',
  'beijing_beihai_park',
  'five dragon pavilions',
  '五龙亭 / Five Dragon Pavilions',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_beihai_park_bj_sa_11.jpg',
  '<p>- **名字 / Name：** 五龙亭 / Five Dragon Pavilions<br>- **摘要 / Summary：** 北海北岸伸入湖中的五座方形亭子，如龙浮水面，是观湖赏月与皇家垂钓的最佳去处。 Five square pavilions reaching into the lake from the north shore, like dragons floating on water—the finest spot for lake viewing, moon admiring and imperial angling.<br>- **长文描述 / Description：** 五龙亭位于北海北岸中段水域，建于明嘉靖年间，清代重修。五亭一字排开伸入湖中，中亭最大，名"龙泽亭"，两侧依次为"澄祥亭""滋香亭"及最外的两座小亭，亭间以石桥相连，整体造型如五龙浮水，故称"五龙亭"。中亭为重檐方亭，黄琉璃瓦覆顶，等级最高，其余四亭渐次缩小，绿琉璃瓦覆顶，形成高低错落、主次分明的水上建筑群。亭上雕龙画凤，亭下碧波万顷，春秋观荷，冬月赏雪，中秋望月，四季皆景。清代帝后常于此垂钓赏月，太后慈禧尤喜中秋在此宴饮观灯，是北海最具浪漫意境的建筑群。 The Five Dragon Pavilions jut into the lake from the mid-section of Beihai''s north shore, built under Ming Emperor Jiajing and rebuilt in the Qing. Five pavilions line up in a row extending into the water: the central one, Dragon-Blessing Pavilion (Longze), is largest; flanking it are Clear-Blessing (Chengxiang) and Nourishing-Fragrance (Zixiang), with two smaller outer pavilions beyond. Stone bridges link them, and the ensemble resembles five dragons floating on water—hence the name. The central pavilion is a double-eaved square structure under yellow glazed tiles (highest rank); the others step down in size under green tiles, creating a tiered, hierarchically clear waterside cluster. Dragons and phoenixes adorn the eaves; limitless blue waves spread below. Spring and autumn for lotus, winter for snow, mid-autumn for moonlight—every season offers a scene. Qing emperors and empresses often fished and moon-watched here; Empress Dowager Cixi especially loved mid-autumn banquets with lanterns—the most romantically evocative complex in Beihai.<br>- **详细地址 / Address：** 北京市西城区文津街1号（北海北岸中段伸入湖面处） / No. 1 Wenjin Street, Xicheng District, Beijing (mid-section of north shore, extending into the lake)<br>- **门票信息 / Ticket Information：** 包含在公园普通门票内（旺季10元/淡季5元） / Included in general admission (peak ¥10 / off-peak ¥5)<br>- **开放时间 / Opening Hours：** 随公园开放，旺季6:00-21:00/淡季6:30-20:00 / Follows park hours: peak 6:00–21:00 / off-peak 6:30–20:00<br>- **交通信息 / Transportation：** 地铁6号线北海北站步行至北门，沿北岸东行约8分钟；或乘5路公交至北海站 / Subway Line 6 Beihai North station → North Gate, walk east along north shore approx. 8 min; or Bus 5 to Beihai stop</p><p>---</p>',
  '',
  10,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_ming_tombs_bj_sa_01',
  'beijing_ming_tombs',
  'stone archway and great red gate',
  '石牌坊与大红门 / Stone Archway and Great Red Gate',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_ming_tombs_bj_sa_01.jpg',
  '<p>- **名字 / Name：** 石牌坊与大红门 / Stone Archway and Great Red Gate<br>- **摘要 / Summary：** 十三陵的宏伟前导入口，中国现存最大的石牌坊与陵区正门。 The grand entrance to the Ming Tombs, featuring China''s largest existing stone archway and the main gate of the mausoleum area.<br>- **长文描述 / Description：** 石牌坊建于明嘉靖十九年（1540年），为五间六柱十一楼式石构建筑，通体由汉白玉雕砌而成，面阔28.86米，高14米，是中国现存规模最大、保存最完好的石牌坊。牌坊额坊上雕有旋子彩画及龙凤、狮兽等瑞兽图案，工艺精湛，气势恢宏。大红门为十三陵陵区的正门，建于明永乐年间，单檐庑殿顶，红墙黄瓦，两侧与虎山、龙山相连，形成天然屏障，是进入陵区的第一道门户，具有极高的建筑与历史价值。The Stone Archway, built in 1540 during the Jiajing reign, is a five-bay, six-pillar, eleven-roof stone structure made entirely of white marble. Measuring 28.86 meters wide and 14 meters high, it is the largest and best-preserved stone archway in China. Its beams are exquisitely carved with dragons, phoenixes, lions, and other auspicious motifs. The Great Red Gate, the main entrance to the mausoleum area, was built during the Yongle reign. It features a single-eave hipped roof with red walls and yellow tiles, connecting Mount Hu and Mount Long on either side to form a natural barrier. It is the first portal into the tomb complex and holds exceptional architectural and historical significance.<br>- **详细地址 / Address：** 北京市昌平区十三陵镇石牌坊景区入口处 / Stone Archway entrance, Ming Tombs Scenic Area, Shisanling Town, Changping District, Beijing<br>- **门票信息 / Ticket Information：** 石牌坊与大红门区域为开放景观，免费参观；进入神路景区需购神路门票30元 / The Stone Archway and Great Red Gate area is open and free to visit; entering the Sacred Way scenic area requires a Sacred Way ticket at 30 RMB<br>- **开放时间 / Opening Hours：** 全年开放，户外区域全天可观赏；神路景区8:00–17:30 / Open year-round; outdoor areas viewable all day; Sacred Way scenic area 8:00–17:30<br>- **交通信息 / Transportation：** 地铁昌平线至昌平站下车，换乘公交314路至石牌坊站；或乘公交872路至大宫门站下车步行前往 / Take Changping Subway Line to Changping Station, transfer to bus 314 to Shipaifang Station; or take bus 872 to Dagongmen Station and walk</p><p>---</p>',
  '',
  0,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_ming_tombs_bj_sa_02',
  'beijing_ming_tombs',
  'stele pavilion of divine merit and sacred way',
  '神功圣德碑亭与神路 / Stele Pavilion of Divine Merit and Sacred Way',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_ming_tombs_bj_sa_02.jpg',
  '<p>- **名字 / Name：** 神功圣德碑亭与神路 / Stele Pavilion of Divine Merit and Sacred Way<br>- **摘要 / Summary：** 记录帝王功德的巨型碑亭与通往各陵的神圣御道。 A monumental stele pavilion recording imperial virtues and the sacred processional way leading to the tombs.<br>- **长文描述 / Description：** 神功圣德碑亭位于大红门北约1公里处，建于明宣德十年（1435年），为重檐歇山顶方形建筑。亭内立有巨型石碑，高7.91米，碑首雕双龙，碑身刻有明仁宗朱高炽撰写的《大明长陵神功圣德碑》碑文，记述明成祖朱棣的文治武功。碑亭四角各立一座华表，高约10米，雕蟠龙流云，气势雄伟。神路由此向南延伸约7公里，是通往各陵的统一御道，两侧以石墙围护，松柏夹道，庄严肃穆，是十三陵整体布局的中轴线核心。The Stele Pavilion of Divine Merit stands approximately one kilometer north of the Great Red Gate. Built in 1435 during the Xuande reign, it is a square structure with a double-eave gabled roof. Inside stands a giant stone stele 7.91 meters tall, with a dragon-carved top and an inscription composed by Emperor Renzong (Zhu Gaozhi) praising the military and civil achievements of Emperor Yongle (Zhu Di). Four marble ornamental columns, each about 10 meters tall and carved with coiled dragons and clouds, flank the pavilion''s corners. The Sacred Way extends southward for about seven kilometers, serving as the central processional road to all tombs. Lined with pines and cypresses and enclosed by stone walls, it forms the central axis of the Ming Tombs layout.<br>- **详细地址 / Address：** 北京市昌平区十三陵镇神路景区内 / Sacred Way Scenic Area, Shisanling Town, Changping District, Beijing<br>- **门票信息 / Ticket Information：** 神路景区门票30元；联票（神路+长陵+定陵+昭陵）130元 / Sacred Way ticket 30 RMB; combined ticket (Sacred Way + Changling + Dingling + Zhaoling) 130 RMB<br>- **开放时间 / Opening Hours：** 4月–10月 8:00–17:30；11月–3月 8:30–17:00 / April–October 8:00–17:30; November–March 8:30–17:00<br>- **交通信息 / Transportation：** 地铁昌平线至昌平站换乘314路至神路景区站；或公交872路至大宫门站下车北行即达 / Take Changping Subway Line to Changping Station, transfer to bus 314 to Shenlu Scenic Area Station; or take bus 872 to Dagongmen Station and walk north</p><p>---</p>',
  '',
  1,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_ming_tombs_bj_sa_03',
  'beijing_ming_tombs',
  'stone statues and dragon and phoenix gate',
  '石像生群与棂星门 / Stone Statues and Dragon and Phoenix Gate',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_ming_tombs_bj_sa_03.jpg',
  '<p>- **名字 / Name：** 石像生群与棂星门 / Stone Statues and Dragon and Phoenix Gate<br>- **摘要 / Summary：** 神路两侧三十六尊石雕仪卫与象征天门的棂星门。 Thirty-six stone guardian figures lining the Sacred Way and the Dragon and Phoenix Gate symbolizing the heavenly portal.<br>- **长文描述 / Description：** 石像生群位于神路两侧，建于明宣德至正统年间，共36尊，包括石兽24尊（狮子、獬豸、骆驼、象、麒麟、马各4尊，或卧或立）和石人12尊（勋臣、文臣、武将各4尊）。每尊石像均以整块巨石雕琢，体量宏大，造型生动，最高者达3米余，是明代皇家石雕艺术的巅峰之作。棂星门位于石像生群北端，又称"龙凤门"或"火焰牌坊"，三门六柱，柱顶雕石兽，门额饰火焰宝珠，寓意帝后灵魂由此升入天界，是神路的重要节点与礼仪象征。The Stone Statues flank both sides of the Sacred Way, built between the Xuande and Zhengtong reigns. There are 36 figures in total: 24 stone animals (lions, xiezhi, camels, elephants, qilin, and horses, four of each, in alternating standing and kneeling postures) and 12 human figures (four nobles, four civil officials, and four military generals). Each statue is carved from a single massive stone block, with the tallest exceeding three meters. They represent the pinnacle of Ming imperial stone carving. The Dragon and Phoenix Gate (Lingxing Gate), also called the "Flame Archway," stands at the northern end of the statue group. It features three gates with six pillars topped by stone beasts and flame-shaped ornaments, symbolizing the passage of imperial souls to heaven.<br>- **详细地址 / Address：** 北京市昌平区十三陵镇神路景区北段 / Northern section of Sacred Way Scenic Area, Shisanling Town, Changping District, Beijing<br>- **门票信息 / Ticket Information：** 含于神路景区门票内（30元）；联票含此景点 / Included in Sacred Way ticket (30 RMB); also included in combined ticket<br>- **开放时间 / Opening Hours：** 4月–10月 8:00–17:30；11月–3月 8:30–17:00 / April–October 8:00–17:30; November–March 8:30–17:00<br>- **交通信息 / Transportation：** 与神路景区同一入口，公交314路至神路景区站或872路至大宫门站后北行游览 / Same entrance as the Sacred Way scenic area; take bus 314 to Shenlu Scenic Area Station or bus 872 to Dagongmen Station, then walk north along the Sacred Way</p><p>---</p>',
  '',
  2,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_ming_tombs_bj_sa_04',
  'beijing_ming_tombs',
  'changling tomb and museum',
  '长陵与博物馆 / Changling Tomb and Museum',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_ming_tombs_bj_sa_04.jpg',
  '<p>- **名字 / Name：** 长陵与博物馆 / Changling Tomb and Museum<br>- **摘要 / Summary：** 十三陵首陵，明成祖朱棣之陵，拥有中国最大的楠木殿宇。 The first and largest of the Ming Tombs, burial site of Emperor Yongle, featuring China''s largest nanmu hall.<br>- **长文描述 / Description：** 长陵是十三陵中规模最大、营建最早、保存最好的陵墓，始建于明永乐七年（1409年），安葬明成祖朱棣与皇后徐氏。陵宫建筑平面呈前方后圆格局，主体建筑祾恩殿建于三层汉白玉台基之上，重檐庑殿顶，面阔九间，进深五间，总面积1956平方米。殿内32根金丝楠木巨柱巍然矗立，其中4根中央明柱直径达1.17米，高14.3米，为国内现存最大楠木柱，五百余年仍散发幽香。长陵博物馆设于祾恩殿内，展出出土文物、帝后服饰及陵寝建筑模型，系统呈现明代皇家丧葬礼制与建筑成就。Changling is the largest, earliest, and best-preserved tomb among the Ming Tombs. Construction began in 1409 during the Yongle reign, housing Emperor Zhu Di (Yongle) and Empress Xu. The complex follows a rectangular-front-and-round-rear layout. The main hall, the Hall of Eminent Favor (Ling''en Dian), sits on a three-tiered white marble base with a double-eave hipped roof. It spans nine bays wide and five bays deep, covering 1,956 square meters. Thirty-two golden-thread nanmu pillars stand inside, with the four central columns measuring 1.17 meters in diameter and 14.3 meters in height—the largest existing nanmu pillars in China, still fragrant after over five centuries. The Changling Museum, housed within the hall, displays excavated artifacts, imperial garments, and architectural models.<br>- **详细地址 / Address：** 北京市昌平区十三陵镇长陵景区 / Changling Tomb Scenic Area, Shisanling Town, Changping District, Beijing<br>- **门票信息 / Ticket Information：** 长陵门票45元（含博物馆）；联票（长陵+定陵+昭陵+神路）130元 / Changling ticket 45 RMB (museum included); combined ticket 130 RMB<br>- **开放时间 / Opening Hours：** 4月–10月 8:00–17:30；11月–3月 8:30–17:00 / April–October 8:00–17:30; November–March 8:30–17:00<br>- **交通信息 / Transportation：** 地铁昌平线至昌平站换乘314路至长陵站；或公交872路直达长陵站下车 / Take Changping Subway Line to Changping Station, transfer to bus 314 to Changling Station; or take bus 872 directly to Changling Station</p><p>---</p>',
  '',
  3,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_ming_tombs_bj_sa_05',
  'beijing_ming_tombs',
  'dingling tomb and underground palace',
  '定陵与地宫 / Dingling Tomb and Underground Palace',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_ming_tombs_bj_sa_05.png',
  '<p>- **名字 / Name：** 定陵与地宫 / Dingling Tomb and Underground Palace<br>- **摘要 / Summary：** 明神宗万历皇帝之陵，十三陵中唯一发掘的地下宫殿。 Tomb of Emperor Wanli and the only excavated underground palace among the Ming Tombs.<br>- **长文描述 / Description：** 定陵是明神宗朱翊钧（万历皇帝）及其两位皇后的合葬陵墓，建于1584–1590年，是十三陵中唯一经过考古发掘的陵墓。地宫于1956–1958年发掘，深27米，由前、中、后、左、右五座石室组成，总面积1195平方米，全部为石拱结构，无梁无柱，建筑工艺令人惊叹。后室设有汉白玉宝床，放置三口朱漆棺椁及26只随葬红木箱，出土文物近3000件，包括金冠、凤冠、衮服、丝织品等国宝级文物。地宫常年恒温18–20度，是了解明代帝陵玄宫结构的唯一实物见证。Dingling is the joint burial tomb of Emperor Zhu Yijun (Wanli) and his two empresses, constructed between 1584 and 1590. It is the only archaeologically excavated tomb among the Ming Tombs. The underground palace was excavated between 1956 and 1958. Located 27 meters below ground, it consists of five stone chambers—front, middle, rear, left, and right—covering 1,195 square meters. The entire structure is built of stone arches without beams or columns, showcasing extraordinary craftsmanship. The rear chamber contains a white marble bed holding three vermillion-lacquered coffins and 26 wooden chests, yielding nearly 3,000 artifacts including the gold crown, phoenix crowns, dragon robes, and silk textiles of national-treasure status. The underground palace maintains a constant temperature of 18–20°C year-round.<br>- **详细地址 / Address：** 北京市昌平区十三陵镇定陵景区 / Dingling Tomb Scenic Area, Shisanling Town, Changping District, Beijing<br>- **门票信息 / Ticket Information：** 定陵门票60元（含地宫）；联票（定陵+长陵+昭陵+神路）130元 / Dingling ticket 60 RMB (underground palace included); combined ticket 130 RMB<br>- **开放时间 / Opening Hours：** 4月–10月 8:00–17:30；11月–3月 8:30–17:00 / April–October 8:00–17:30; November–March 8:30–17:00<br>- **交通信息 / Transportation：** 地铁昌平线至昌平站换乘314路至定陵站；或公交872路至定陵道口站下车西行 / Take Changping Subway Line to Changping Station, transfer to bus 314 to Dingling Station; or take bus 872 to Dingling Daokou Station and walk west</p><p>---</p>',
  '',
  4,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_ming_tombs_bj_sa_06',
  'beijing_ming_tombs',
  'zhaoling tomb',
  '昭陵 / Zhaoling Tomb',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_ming_tombs_bj_sa_06.jpg',
  '<p>- **名字 / Name：** 昭陵 / Zhaoling Tomb<br>- **摘要 / Summary：** 明穆宗隆庆皇帝之陵，经修缮再现明代陵寝完整格局。 Tomb of Emperor Longqing, restored to showcase the complete layout of a Ming imperial mausoleum.<br>- **长文描述 / Description：** 昭陵是明穆宗朱载坖及其三位皇后的合葬陵墓，始建于明隆庆六年（1572年），是十三陵中第一座大规模修缮复原的陵墓。昭陵的最大特色在于其完整的祾恩殿与配殿复原，使游客得以一览明代陵寝建筑的完整格局。陵宫继承了长陵"前方后圆"的基本形制，但在排水系统上有独特设计——祾恩殿后增设挡土墙与泄水石槽，为十三陵中独有。墓主人明穆宗在位仅六年，却推行"隆庆议和"等政策，开启明朝短暂中兴。昭陵博物馆展出复刻帝后服饰与祭祀器物，生动呈现明代皇家陵寝礼制。Zhaoling is the joint burial tomb of Emperor Zhu Zaihou (Longqing) and his three empresses, construction beginning in 1572. It was the first tomb among the Ming Tombs to undergo large-scale restoration, allowing visitors to see the complete layout of a Ming imperial mausoleum. Its distinctive feature is the fully restored Hall of Eminent Favor and side halls. The complex follows Changling''s rectangular-and-round layout but features a unique drainage system—a retaining wall and water-discharge stone channel behind the main hall found nowhere else among the Ming Tombs. Emperor Longqing reigned only six years but initiated the "Longqing Accord," ushering in a brief Ming revival. The Zhaoling Museum displays reproduced imperial garments and sacrificial vessels.<br>- **详细地址 / Address：** 北京市昌平区十三陵镇昭陵景区 / Zhaoling Tomb Scenic Area, Shisanling Town, Changping District, Beijing<br>- **门票信息 / Ticket Information：** 昭陵门票30元；联票（昭陵+长陵+定陵+神路）130元 / Zhaoling ticket 30 RMB; combined ticket 130 RMB<br>- **开放时间 / Opening Hours：** 4月–10月 8:00–17:30；11月–3月 8:30–17:00 / April–October 8:00–17:30; November–March 8:30–17:00<br>- **交通信息 / Transportation：** 公交872路至定陵道口站下车，南行约1公里至昭陵；或由长陵步行约15分钟可达；自驾可沿昌赤路至昭陵停车场 / Take bus 872 to Dingling Daokou Station and walk south about 1 km; or walk about 15 minutes from Changling; by car, drive along Changchi Road to Zhaoling parking lot</p><p>---</p>',
  '',
  5,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_ming_tombs_bj_sa_07',
  'beijing_ming_tombs',
  'jingling kangling and yongling tombs',
  '景陵、康陵与永陵 / Jingling, Kangling and Yongling Tombs',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_ming_tombs_bj_sa_07.jpg',
  '<p>- **名字 / Name：** 景陵、康陵与永陵 / Jingling, Kangling and Yongling Tombs<br>- **摘要 / Summary：** 三座风格各异的明陵，分别安葬宣德、正德与嘉靖三朝皇帝。 Three distinct Ming tombs housing emperors of the Xuande, Zhengde, and Jiajing reigns.<br>- **长文描述 / Description：** 景陵是明宣宗朱瞻基与皇后孙氏的陵墓，规模较小但布局紧凑，其祾恩殿采用减柱法扩大空间，为明代陵寝建筑的创新之作。康陵是明武宗朱厚照与皇后夏氏的陵墓，位于十二陵最西端，背靠金岭山，陵区古松参天，环境幽静，武宗一生颇具传奇色彩。永陵是明世宗朱厚熜与皇后陈氏等的合葬陵墓，营建历时十余年，规模仅次于长陵。其宝城直径达240米，明楼用料考究，城砖刻有字号，为十三陵中等级最高者。三陵目前均为修缮保护状态，部分对外开放，可远观陵墙与明楼，感受不同时期的营建风格与历史变迁。Jingling is the tomb of Emperor Zhu Zhanji (Xuande) and Empress Sun. Smaller in scale but compact in layout, its Hall of Eminent Favor employs a reduced-pillar technique to expand interior space—an innovation in Ming mausoleum architecture. Kangling, the tomb of Emperor Zhu Houzhao (Zhengde) and Empress Xia, is located at the westernmost end of the Ming Tombs, backed by Mount Jinling. Ancient pines create a serene environment, and Emperor Zhengde''s life was legendary. Yongling, the joint tomb of Emperor Zhu Houcong (Jiajing) and Empress Chen, took over a decade to build and is second only to Changling in scale. Its treasure-city wall reaches 240 meters in diameter, and its Soul Tower uses the finest materials, with bricks bearing inscriptions—the highest grade among the Ming Tombs. The three tombs are under conservation; some areas are open, allowing visitors to view the walls and towers from a distance.<br>- **详细地址 / Address：** 北京市昌平区十三陵镇景陵、康陵、永陵各自独立陵区 / Separate mausoleum areas within Shisanling Town, Changping District, Beijing<br>- **门票信息 / Ticket Information：** 景陵、康陵、永陵目前部分保护性开放，暂无单独售票；可于陵区外围参观；建议购买联票参观长陵、定陵等主陵后顺访 / Jingling, Kangling, and Yongling are under conservation with no individual tickets; exterior viewing is free; recommended to visit after purchasing combined tickets for major tombs<br>- **开放时间 / Opening Hours：** 陵区外围全天可参观；室内区域暂不开放 / Exterior areas accessible all day; interiors currently closed<br>- **交通信息 / Transportation：** 景陵、永陵位于长陵附近，可由长陵步行或租车前往；康陵位于陵区西部，建议自驾或从昭陵乘当地出租车沿陵区公路前往 / Jingling and Yongling are near Changling, reachable on foot or by rental car; Kangling is in the western part of the complex—driving or taking a local taxi from Zhaoling along the tomb area road is recommended</p><p>---</p>',
  '',
  6,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_ming_tombs_bj_sa_08',
  'beijing_ming_tombs',
  'siling tomb',
  '思陵 / Siling Tomb',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_ming_tombs_bj_sa_08.jpg',
  '<p>- **名字 / Name：** 思陵 / Siling Tomb<br>- **摘要 / Summary：** 明末崇祯皇帝之陵，十三陵中规模最小、命运最特殊的一座。 Tomb of Emperor Chongzhen, the smallest and most tragically fated of the Ming Tombs.<br>- **长文描述 / Description：** 思陵是明思宗朱由检（崇祯皇帝）及皇后周氏、田贵妃的陵墓，也是十三陵中规模最小的一座。崇祯十七年（1644年），李自成攻入北京，崇祯帝于煤山自缢殉国，明朝覆亡。清军入关后，出于政治考量，清廷以帝礼将崇祯帝改葬于此，原为田贵妃墓，规模远不及其他诸陵。思陵无神功圣德碑、无石像生、无明楼宝城，仅有一座圆形宝顶与简朴的享殿，与崇祯帝勤政却亡国的悲剧命运相映。陵区古柏苍翠，氛围肃穆沉郁，是追思明末历史沧桑的特殊场所，也是十三陵游览的深沉尾声。Siling is the tomb of Emperor Zhu Youjian (Chongzhen), Empress Zhou, and Consort Tian. It is the smallest among the Ming Tombs. In 1644, when Li Zicheng''s forces captured Beijing, Emperor Chongzhen hanged himself at Coal Hill (Jingshan), marking the fall of the Ming Dynasty. After the Qing army entered Beijing, the Qing court reinterred Chongzhen here with imperial rites. Originally Consort Tian''s tomb, its scale is far smaller than the other twelve. Siling has no stele of divine merit, no stone statues, and no Soul Tower or treasure-city wall—only a simple round mound and a modest memorial hall, echoing the tragic fate of an emperor who was diligent yet lost his empire. Ancient cypresses create a solemn, melancholic atmosphere, making it a poignant place to reflect on the late Ming and a fitting conclusion to a Ming Tombs visit.<br>- **详细地址 / Address：** 北京市昌平区十三陵镇思陵（陵区西南侧）/ Siling Tomb, southwestern side of Ming Tombs area, Shisanling Town, Changping District, Beijing<br>- **门票信息 / Ticket Information：** 思陵目前为保护性管理状态，暂不对公众开放室内参观，陵区外围可免费瞻观 / Siling is under conservation management; interior visits are not currently open to the public; exterior viewing is free<br>- **开放时间 / Opening Hours：** 陵区外围全天可参观；室内暂不开放 / Exterior areas accessible all day; interiors currently closed<br>- **交通信息 / Transportation：** 思陵位置偏僻，位于陵区西南侧，公共交通不便；建议自驾从昌平城区沿十三陵环湖路前往，或从定陵乘当地出租车约10分钟可达 / Siling is remotely located on the southwest side of the tomb area with limited public transit; driving from Changping town along Shisanling Ring Lake Road is recommended, or taking a local taxi from Dingling (about 10 minutes)</p><p>---</p><p>&gt; **游览建议 / Visiting Tips：**<br>&gt; - 推荐游览路线：石牌坊→大红门→神功圣德碑亭→神路→石像生→棂星门→长陵→定陵→昭陵，全程约需1天。<br>&gt; - Recommended route: Stone Archway → Great Red Gate → Stele Pavilion → Sacred Way → Stone Statues → Dragon and Phoenix Gate → Changling → Dingling → Zhaoling. Allow a full day.<br>&gt; - 联票性价比高，建议于景区售票处或官方平台提前购买。<br>&gt; - Combined tickets offer good value; purchase at the scenic area ticket office or official online platform in advance.<br>&gt; - 陵区面积广阔，各陵间距离较远，建议合理规划交通，自驾或乘坐景区摆渡车为佳。<br>&gt; - The tomb area is vast with considerable distances between sites; plan transportation carefully—driving or taking the scenic area shuttle is recommended.</p>',
  '',
  7,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_national_museum_bj_sa_01',
  'beijing_national_museum',
  'ancient china exhibition',
  '古代中国陈列 / Ancient China Exhibition',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_national_museum_bj_sa_01.jpg',
  '<p>- **名字 / Name：** 古代中国陈列 / Ancient China Exhibition<br>- **摘要 / Summary：** 以王朝更替为脉络全景呈现中华文明五千年恢弘历程。 This exhibition presents a panoramic view of five thousand years of Chinese civilisation through the succession of dynasties.<br>- **长文描述 / Description：** "古代中国陈列"是国家博物馆的基本陈列之一，位于北馆地下一层，展陈面积约一万七千平方米。展览以王朝更替为主线，分为远古时期、夏商西周、春秋战国、秦汉、三国两晋南北朝、隋唐五代、辽宋夏金元、明清八个部分。精选两千余件文物精品，涵盖青铜器、玉器、陶瓷、石刻、书画等门类，其中后母戊鼎、四羊方尊、击鼓说唱俑等为镇馆之宝，系统展现了中华民族悠久灿烂的文明成就与历史演进脉络。</p><p>  The "Ancient China Exhibition" is one of the National Museum''s core galleries, located on the B1 level of the North Wing and covering approximately 17,000 square metres. Organised around the succession of dynasties, it comprises eight sections: remote antiquity, Xia–Shang–Western Zhou, Spring and Autumn and Warring States, Qin and Han, Three Kingdoms through Northern and Southern Dynasties, Sui–Tang–Five Dynasties, Liao–Song–Xia–Jin–Yuan, and Ming–Qing. Over two thousand carefully selected artefacts are displayed, including bronzes, jades, ceramics, stone carvings and calligraphy. Among the signature treasures are the Houmuwu Ding, the Four-Ram Square Zun and the storytelling pottery figurine, together offering a systematic overview of the splendour and evolution of Chinese civilisation.<br>- **详细地址 / Address：** 北京市东城区东长安街16号天安门广场东侧（国家博物馆北馆地下一层） / East side of Tiananmen Square, 16 East Chang''an Avenue, Dongcheng District, Beijing (B1, North Wing, National Museum of China)<br>- **门票信息 / Ticket Information：** 免费参观，需提前通过国家博物馆官方微信或官网实名预约 / Free admission; advance real-name reservation required via the museum''s official WeChat account or website<br>- **开放时间 / Opening Hours：** 每日9:00–17:00（16:00停止入馆），周一闭馆（法定节假日除外）/ 9:00–17:00 daily (last entry 16:00), closed on Mondays (except statutory holidays)<br>- **交通信息 / Transportation：** 地铁1号线天安门东站A口出，向西步行约200米；或乘坐公交1、2、52、82路至天安门东站 / Take Subway Line 1 to Tiananmen East, Exit A, then walk about 200 m west; or take bus routes 1, 2, 52 or 82 to Tiananmen East</p><p>---</p>',
  '',
  0,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_national_museum_bj_sa_02',
  'beijing_national_museum',
  'the road of rejuvenation',
  '复兴之路 / The Road of Rejuvenation',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_national_museum_bj_sa_02.jpg',
  '<p>- **名字 / Name：** 复兴之路 / The Road of Rejuvenation<br>- **摘要 / Summary：** 自1840年鸦片战争起全景展现中华民族走向复兴的壮阔征程。 This exhibition traces the monumental journey of the Chinese nation toward rejuvenation from the First Opium War of 1840 onwards.<br>- **长文描述 / Description：** "复兴之路"基本陈列位于国家博物馆南馆，分为"中国沦为半殖民地半封建社会""探求救亡图存的道路""中国共产党肩负起民族独立人民解放历史重任""建设社会主义新中国""走中国特色社会主义道路"五个部分。通过珍贵文物、历史照片、文献档案及多媒体场景，生动再现了自鸦片战争以来中华民族从屈辱走向复兴的历史进程，是进行爱国主义教育的重要展览，也是了解近现代中国发展脉络的关键窗口。</p><p>  "The Road of Rejuvenation" is a permanent exhibition in the South Wing of the National Museum, structured in five parts: "China reduced to a semi-colonial and semi-feudal society," "Exploring paths to national salvation," "The Communist Party of China takes up the historic mission of national independence and people''s liberation," "Building the new socialist China," and "Taking the path of socialism with Chinese characteristics." Through precious artefacts, historical photographs, archival documents and multimedia installations, it vividly recreates the journey of the Chinese nation from humiliation to renewal since the Opium War, serving as an essential gallery for patriotic education and a vital window into the trajectory of modern and contemporary China.<br>- **详细地址 / Address：** 北京市东城区东长安街16号天安门广场东侧（国家博物馆南馆） / East side of Tiananmen Square, 16 East Chang''an Avenue, Dongcheng District, Beijing (South Wing, National Museum of China)<br>- **门票信息 / Ticket Information：** 免费参观，需提前在线实名预约 / Free admission; advance online real-name reservation required<br>- **开放时间 / Opening Hours：** 每日9:00–17:00（16:00停止入馆），周一闭馆 / 9:00–17:00 daily (last entry 16:00), closed on Mondays<br>- **交通信息 / Transportation：** 地铁1号线天安门东站，步行约5分钟即达 / Subway Line 1, Tiananmen East station, about a 5-minute walk</p><p>---</p>',
  '',
  1,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_national_museum_bj_sa_03',
  'beijing_national_museum',
  'second floor special exhibitions the power of science and technology red flags unfurled and dehua white porcelain',
  '二层专题·科技的力量、风展红旗与德化白瓷 / Second-Floor Special Exhibitions: The Power of Science and Technology, Red Flags Unfurled, and Dehua White Porcelain',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_national_museum_bj_sa_03.jpg',
  '<p>- **名字 / Name：** 二层专题·科技的力量、风展红旗与德化白瓷 / Second-Floor Special Exhibitions: The Power of Science and Technology, Red Flags Unfurled, and Dehua White Porcelain<br>- **摘要 / Summary：** 汇聚科技、革命与工艺三大主题的二层精品专题联展。 Three thematic exhibitions on the second floor explore science and technology, revolutionary heritage, and the artistry of Dehua white porcelain.<br>- **长文描述 / Description：** 国家博物馆二层设有多个专题展厅，其中"科技的力量"专题陈列展现中国古代至近现代科技成就，涵盖天文、水利、纺织、冶金等领域，彰显中华民族的创造智慧；"风展红旗——馆藏红色经典文物展"以旗帜为线索，汇集革命文物与历史影像，再现中国共产党领导人民奋斗的光辉历程；"德化白瓷"专题展示福建德化窑瓷器精品，体现"中国白"独特釉色与精湛雕塑工艺，三个专题各具特色，共同构成了二层丰富多元的展览图景。</p><p>  The second floor of the National Museum hosts several thematic galleries. "The Power of Science and Technology" surveys Chinese scientific and technological achievements from antiquity to the modern era, spanning astronomy, hydraulic engineering, textiles and metallurgy, and highlighting the creative ingenuity of the Chinese people. "Red Flags Unfurled" uses flags as a narrative thread, bringing together revolutionary artefacts and historical images to revisit the glorious journey of the Chinese people under the leadership of the Communist Party of China. The Dehua White Porcelain exhibition showcases masterpieces from the kilns of Dehua, Fujian, celebrated for their distinctive "China White" glaze and exquisite sculptural craftsmanship. Together, these three exhibitions create a rich and varied cultural panorama on the second floor.<br>- **详细地址 / Address：** 北京市东城区东长安街16号天安门广场东侧（国家博物馆二层专题展厅） / East side of Tiananmen Square, 16 East Chang''an Avenue, Dongcheng District, Beijing (2nd-floor thematic galleries, National Museum of China)<br>- **门票信息 / Ticket Information：** 免费参观，需提前在线实名预约 / Free admission; advance online real-name reservation required<br>- **开放时间 / Opening Hours：** 每日9:00–17:00（16:00停止入馆），周一闭馆 / 9:00–17:00 daily (last entry 16:00), closed on Mondays<br>- **交通信息 / Transportation：** 地铁1号线天安门东站A口出，步行约200米 / Subway Line 1, Tiananmen East, Exit A, about a 200-metre walk</p><p>---</p>',
  '',
  2,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_national_museum_bj_sa_04',
  'beijing_national_museum',
  'ancient chinese porcelain',
  '古代瓷器 / Ancient Chinese Porcelain',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_national_museum_bj_sa_04.jpg',
  '<p>- **名字 / Name：** 古代瓷器 / Ancient Chinese Porcelain<br>- **摘要 / Summary：** 系统展示中国瓷器从萌芽到巅峰的发展历程与艺术成就。 This exhibition systematically presents the evolution and artistic achievements of Chinese porcelain from its origins to its zenith.<br>- **长文描述 / Description：** "古代瓷器"专题陈列位于国家博物馆，精选历代瓷器珍品，按时代顺序展示从原始青瓷到明清官窑精品的完整发展序列。展览涵盖东汉成熟青瓷、唐代"南青北白"格局、宋代五大名窑（汝、官、哥、钧、定）、元代青花瓷、明代永宣青花与成化斗彩、清代康乾盛世的珐琅彩与粉彩等重要品类。每件展品均配有详尽说明，从胎釉工艺到纹饰寓意，全面展现中国瓷器作为"国之瑰宝"的艺术魅力与历史价值，是了解中国陶瓷文明的绝佳课堂。</p><p>  The "Ancient Chinese Porcelain" gallery presents a selection of fine porcelains arranged chronologically, tracing the complete development from proto-celadon to the masterpieces of Ming and Qing imperial kilns. The exhibition covers mature celadon of the Eastern Han, the Tang-dynasty pattern of "celadon in the south, white ware in the north," the five great Song kilns (Ru, Guan, Ge, Jun and Ding), Yuan-dynasty blue-and-white, Yongle and Xuande blue-and-white and Chenghua doucai of the Ming, and the falangcai and fencai of the Kangxi–Qianlong golden age. Each piece is accompanied by detailed interpretation—covering body and glaze techniques as well as the symbolism of decorative motifs—offering a comprehensive appreciation of Chinese porcelain as a national treasure and an ideal introduction to the history of Chinese ceramics.<br>- **详细地址 / Address：** 北京市东城区东长安街16号天安门广场东侧（国家博物馆专题展厅） / East side of Tiananmen Square, 16 East Chang''an Avenue, Dongcheng District, Beijing (thematic gallery, National Museum of China)<br>- **门票信息 / Ticket Information：** 免费参观，需提前在线实名预约 / Free admission; advance online real-name reservation required<br>- **开放时间 / Opening Hours：** 每日9:00–17:00（16:00停止入馆），周一闭馆 / 9:00–17:00 daily (last entry 16:00), closed on Mondays<br>- **交通信息 / Transportation：** 地铁1号线天安门东站，步行约5分钟 / Subway Line 1, Tiananmen East station, about a 5-minute walk</p><p>---</p>',
  '',
  3,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_national_museum_bj_sa_05',
  'beijing_national_museum',
  'ancient chinese jade',
  '古代玉器 / Ancient Chinese Jade',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_national_museum_bj_sa_05.jpg',
  '<p>- **名字 / Name：** 古代玉器 / Ancient Chinese Jade<br>- **摘要 / Summary：** 以玉为媒贯穿八千年中华玉文化的发展与精神内涵。 Spanning eight millennia, this exhibition traces the development and spiritual significance of Chinese jade culture.<br>- **长文描述 / Description：** "古代玉器"专题陈列以时代为序，系统呈现中国玉器从新石器时代至清代的演变历程。展览从兴隆洼文化、红山文化、良渚文化的史前玉器开始，展现玉器在中华文明起源中的核心地位；继而展示商周礼玉与葬玉、春秋战国精美组玉佩、汉代金缕玉衣、唐代玉饰、宋代仿古玉、元代渎山大玉海、明代子冈牌及清代乾隆时期《大禹治水图》玉山等代表作。展览不仅展示玉器工艺之美，更深入诠释玉在中国文化中"君子比德于玉"的精神象征与文化内涵。</p><p>  The "Ancient Chinese Jade" gallery is arranged chronologically, presenting the evolution of Chinese jade from the Neolithic period to the Qing dynasty. It opens with prehistoric jades of the Xinglongwa, Hongshan and Liangzhu cultures, illustrating jade''s central role in the origins of Chinese civilisation. It continues with ritual and funerary jades of the Shang and Zhou, exquisite jade pendants of the Spring and Autumn and Warring States periods, the jade burial suit of the Han dynasty, Tang ornaments, Song archaistic jades, the Yuan "Dushan Great Jade Sea," Ming Zi-gang plaques, and the Qing "Yu the Great Taming the Waters" jade boulder from the Qianlong reign. The exhibition explores not only the craftsmanship of jade but also its profound symbolism in Chinese culture, where jade embodies the virtues of the noble personage.<br>- **详细地址 / Address：** 北京市东城区东长安街16号天安门广场东侧（国家博物馆专题展厅） / East side of Tiananmen Square, 16 East Chang''an Avenue, Dongcheng District, Beijing (thematic gallery, National Museum of China)<br>- **门票信息 / Ticket Information：** 免费参观，需提前在线实名预约 / Free admission; advance online real-name reservation required<br>- **开放时间 / Opening Hours：** 每日9:00–17:00（16:00停止入馆），周一闭馆 / 9:00–17:00 daily (last entry 16:00), closed on Mondays<br>- **交通信息 / Transportation：** 地铁1号线天安门东站A口出，步行约200米 / Subway Line 1, Tiananmen East, Exit A, about a 200-metre walk</p><p>---</p>',
  '',
  4,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_national_museum_bj_sa_06',
  'beijing_national_museum',
  'ancient chinese coins and bronze mirrors',
  '古代钱币与铜镜 / Ancient Chinese Coins and Bronze Mirrors',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_national_museum_bj_sa_06.jpg',
  '<p>- **名字 / Name：** 古代钱币与铜镜 / Ancient Chinese Coins and Bronze Mirrors<br>- **摘要 / Summary：** 以钱币与铜镜两大专藏串联起经济与生活的千年图景。 Two collections of ancient coins and bronze mirrors weave together a thousand-year panorama of economy and daily life.<br>- **长文描述 / Description：** "古代钱币"专题陈列以时间为主线，展示从贝币、布币、刀币、圜钱等先秦货币，到秦半两、汉五铢、唐开元通宝、宋代纸币交子、明清银锭与机制币等货币体系演变，全面反映中国古代经济贸易发展脉络。"古代铜镜"专题陈列则从齐家文化铜镜开始，至清代铜镜为止，展示各时代铜镜在合金工艺、镜背纹饰与铭文方面的演变，兼具实用与艺术价值，方寸之间凝聚古代审美与科技，两大专题共同构筑一幅古代经济与生活画卷。</p><p>  The "Ancient Chinese Coins" gallery follows a chronological thread, displaying pre-Qing currencies such as cowrie, spade, knife and round coins through to the Qin Banliang, Han Wuzhu, Tang Kaiyuan Tongbao, Song-dynasty Jiaozi paper money, and Ming–Qing silver ingots and machine-struck coins, comprehensively reflecting the evolution of China''s monetary and economic systems. The "Ancient Chinese Bronze Mirrors" gallery runs from Qiijia-culture mirrors to those of the Qing dynasty, illustrating developments in bronze alloys, back decoration and inscriptions across the ages. Combining utility with artistry, these mirrors distil ancient aesthetics and technology into a few centimetres of bronze. Together, the two galleries paint a vivid picture of ancient economy and everyday life.<br>- **详细地址 / Address：** 北京市东城区东长安街16号天安门广场东侧（国家博物馆专题展厅） / East side of Tiananmen Square, 16 East Chang''an Avenue, Dongcheng District, Beijing (thematic gallery, National Museum of China)<br>- **门票信息 / Ticket Information：** 免费参观，需提前在线实名预约 / Free admission; advance online real-name reservation required<br>- **开放时间 / Opening Hours：** 每日9:00–17:00（16:00停止入馆），周一闭馆 / 9:00–17:00 daily (last entry 16:00), closed on Mondays<br>- **交通信息 / Transportation：** 地铁1号线天安门东站，步行约5分钟 / Subway Line 1, Tiananmen East station, about a 5-minute walk</p><p>---</p>',
  '',
  5,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_national_museum_bj_sa_07',
  'beijing_national_museum',
  'ancient chinese buddhist sculpture',
  '古代佛造像 / Ancient Chinese Buddhist Sculpture',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_national_museum_bj_sa_07.jpg',
  '<p>- **名字 / Name：** 古代佛造像 / Ancient Chinese Buddhist Sculpture<br>- **摘要 / Summary：** 融汇南北造像精品展现佛教中国化的艺术巅峰。 Featuring masterpieces from north and south, this gallery showcases the artistic pinnacle of the Sinicisation of Buddhism.<br>- **长文描述 / Description：** "古代佛造像"专题陈列汇集国家博物馆馆藏佛造像精品，系统展示佛教艺术自东汉传入中国后，历经魏晋南北朝、隋唐、宋元至明清的发展历程。展览分为石造像、金铜造像与陶瓷造像等类别，重点呈现北朝造像的庄严古朴、南朝造像的秀骨清像、唐代造像的雍容华贵及宋代世俗化风格。展品包括云冈、龙门、麦积山石窟风格的石雕佛立像、鎏金铜佛、观音菩萨像等，不仅展现高超雕刻技艺，更生动体现了佛教文化与中国传统文化交融互鉴的历史进程。</p><p>  The "Ancient Chinese Buddhist Sculpture" gallery brings together masterpieces from the National Museum''s collection, tracing the development of Buddhist art in China from its introduction in the Eastern Han through the Wei, Jin, Northern and Southern Dynasties, Sui, Tang, Song, Yuan, Ming and Qing. The exhibition is organised by medium—stone, gilt bronze and ceramic—highlighting the solemnity of Northern Dynasties sculpture, the slender elegance of Southern Dynasties figures, the magnificence of Tang imagery and the worldly style of the Song. Works include standing stone Buddhas in the manner of the Yungang, Longmen and Maijishan grottoes, gilt-bronze Buddhas and bodhisattva figures. Together they demonstrate consummate carving skills and vividly illustrate the creative exchange between Buddhist culture and Chinese tradition.<br>- **详细地址 / Address：** 北京市东城区东长安街16号天安门广场东侧（国家博物馆专题展厅） / East side of Tiananmen Square, 16 East Chang''an Avenue, Dongcheng District, Beijing (thematic gallery, National Museum of China)<br>- **门票信息 / Ticket Information：** 免费参观，需提前在线实名预约 / Free admission; advance online real-name reservation required<br>- **开放时间 / Opening Hours：** 每日9:00–17:00（16:00停止入馆），周一闭馆 / 9:00–17:00 daily (last entry 16:00), closed on Mondays<br>- **交通信息 / Transportation：** 地铁1号线天安门东站A口出，步行约200米 / Subway Line 1, Tiananmen East, Exit A, about a 200-metre walk</p><p>---</p>',
  '',
  6,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_national_museum_bj_sa_08',
  'beijing_national_museum',
  'ancient chinese costume and food culture',
  '古代服饰与饮食文化 / Ancient Chinese Costume and Food Culture',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_national_museum_bj_sa_08.jpg',
  '<p>- **名字 / Name：** 古代服饰与饮食文化 / Ancient Chinese Costume and Food Culture<br>- **摘要 / Summary：** 从衣冠之美到饮食之盛全景再现古人生活图卷。 From the elegance of attire to the abundance of the table, these galleries recreate the daily life of ancient China.<br>- **长文描述 / Description：** "古代服饰"专题陈列以时代为序，展示从原始社会兽皮蔽体到明清官服礼仪的完整服饰体系，涵盖汉唐丝绸织绣、宋元袍衫、明清补服冠带等，生动再现各时代服饰的款式演变与等级礼制内涵。"古代饮食文化"专题陈列则从新石器时代陶制炊具开始，展示历代食器、酒器与茶具，呈现中华饮食从"茹毛饮血"到精烹细饪的发展历程，系统展示了从先秦青铜礼器到清代宫廷御膳的食具器物。两展并举，全方位展示古人衣食起居的生活美学与礼乐文化。</p><p>  The "Ancient Chinese Costume" gallery is arranged chronologically, presenting the complete clothing system from animal hides in primitive society to the formal attire of Ming and Qing officials, including Han and Tang silk embroidery, Song and Yuan robes, and Ming and Qing rank badges and headwear, vividly recreating the evolution of styles and the hierarchies of ritual they embodied. The "Ancient Chinese Food Culture" gallery begins with Neolithic pottery cooking vessels and displays food, wine and tea wares across the dynasties, tracing the journey from raw food to refined cuisine, and from bronze ritual vessels of the pre-Qin era to the tableware of the Qing imperial kitchen. Read together, the two exhibitions offer an all-round portrait of the aesthetics and ritual culture of everyday life in ancient China.<br>- **详细地址 / Address：** 北京市东城区东长安街16号天安门广场东侧（国家博物馆专题展厅） / East side of Tiananmen Square, 16 East Chang''an Avenue, Dongcheng District, Beijing (thematic gallery, National Museum of China)<br>- **门票信息 / Ticket Information：** 免费参观，需提前在线实名预约 / Free admission; advance online real-name reservation required<br>- **开放时间 / Opening Hours：** 每日9:00–17:00（16:00停止入馆），周一闭馆 / 9:00–17:00 daily (last entry 16:00), closed on Mondays<br>- **交通信息 / Transportation：** 地铁1号线天安门东站，步行约5分钟 / Subway Line 1, Tiananmen East station, about a 5-minute walk</p><p>---</p>',
  '',
  7,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_national_museum_bj_sa_09',
  'beijing_national_museum',
  'the digitised rhinoceros zun and qing dynasty calligraphy and painting',
  '数说犀尊与清代书画 / The Digitised Rhinoceros Zun and Qing-Dynasty Calligraphy and Painting',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_national_museum_bj_sa_09.png',
  '<p>- **名字 / Name：** 数说犀尊与清代书画 / The Digitised Rhinoceros Zun and Qing-Dynasty Calligraphy and Painting<br>- **摘要 / Summary：** 以数字科技解读西汉错金银铜犀尊，并荟萃清代书画精品。 Digital technology decodes the Western Han gilt-silver rhinoceros zun, complemented by a selection of Qing-dynasty calligraphy and painting masterpieces.<br>- **长文描述 / Description：** "数说犀尊"展览以西汉错金银云纹铜犀尊为核心，借助三维扫描、数字孪生、增强现实等科技手段，深入解读这件国宝级文物的铸造工艺、造型艺术与文化内涵。观众可通过交互装置多角度观察犀尊细节，了解古代犀牛生态与汉代青铜铸造技艺，开创了文物数字化展示的新范式。"清代书画"专题陈列精选清初"四王""四僧"、清中"扬州八怪"及晚清海派画家作品，展现清代书画艺术的多元面貌与流派传承，为观众提供一场视觉与人文的盛宴。</p><p>  "The Digitised Rhinoceros Zun" exhibition centres on the Western Han gilt-silver cloud-pattern bronze rhinoceros zun, employing 3-D scanning, digital-twin and augmented-reality technologies to decode the casting technique, sculptural artistry and cultural significance of this national-treasure artefact. Through interactive installations, visitors can examine the zun from every angle and learn about the ecology of ancient rhinoceroses and Han bronze-casting skills, establishing a new paradigm for digital cultural-heritage display. The "Qing-Dynasty Calligraphy and Painting" gallery features works by the early-Qing "Four Wangs" and "Four Monk" painters, the mid-Qing "Eight Eccentrics of Yangzhou" and late-Qing Shanghai-school masters, illustrating the diversity and lineage of Qing-dynasty painting and calligraphy and offering a feast for the eyes and the mind.<br>- **详细地址 / Address：** 北京市东城区东长安街16号天安门广场东侧（国家博物馆专题展厅） / East side of Tiananmen Square, 16 East Chang''an Avenue, Dongcheng District, Beijing (thematic gallery, National Museum of China)<br>- **门票信息 / Ticket Information：** 免费参观，需提前在线实名预约 / Free admission; advance online real-name reservation required<br>- **开放时间 / Opening Hours：** 每日9:00–17:00（16:00停止入馆），周一闭馆 / 9:00–17:00 daily (last entry 16:00), closed on Mondays<br>- **交通信息 / Transportation：** 地铁1号线天安门东站A口出，步行约200米 / Subway Line 1, Tiananmen East, Exit A, about a 200-metre walk</p><p>---</p>',
  '',
  8,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_national_museum_bj_sa_10',
  'beijing_national_museum',
  'wax figures of heroes and models epilogue',
  '英模蜡像（结束语） / Wax Figures of Heroes and Models (Epilogue)',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_national_museum_bj_sa_10.png',
  '<p>- **名字 / Name：** 英模蜡像（结束语） / Wax Figures of Heroes and Models (Epilogue)<br>- **摘要 / Summary：** 以蜡像致敬时代楷模，为博物馆之旅画上动人句点。 Lifelike wax figures pay tribute to exemplary figures of the era, bringing the museum journey to a moving close.<br>- **长文描述 / Description：** "英模蜡像"展区位于参观动线的尾声，以写实蜡像艺术再现各时代英雄模范人物的鲜活形象。蜡像栩栩如生，涵盖革命先烈、科学家、劳动模范、时代楷模等人物群像，配合场景复原与多媒体互动，使观众在沉浸式氛围中感受英模精神力量。作为博物馆参观的"结束语"，这一展区将宏大历史叙事收束于个体生命的温度之中，让观众在离馆前与历史人物"面对面"对话，在感动与敬意中完成一次穿越古今的精神洗礼，为整场博物馆之旅留下深刻而温暖的记忆。</p><p>  The "Wax Figures of Heroes and Models" gallery stands at the close of the visitor route, using realistic wax portraiture to bring exemplary figures from different eras to life. The lifelike figures encompass revolutionary martyrs, scientists, model workers and exemplary contemporaries, set amid scene reconstructions and multimedia interactions that allow visitors to feel the power of their spirit in an immersive atmosphere. As the "epilogue" to the museum visit, this gallery gathers the grand sweep of history into the warmth of individual lives, inviting visitors to converse face to face with historical figures before they leave, completing a journey through time in a spirit of emotion and respect and leaving a deep and warm memory of the whole museum experience.<br>- **详细地址 / Address：** 北京市东城区东长安街16号天安门广场东侧（国家博物馆） / East side of Tiananmen Square, 16 East Chang''an Avenue, Dongcheng District, Beijing (National Museum of China)<br>- **门票信息 / Ticket Information：** 免费参观，需提前在线实名预约 / Free admission; advance online real-name reservation required<br>- **开放时间 / Opening Hours：** 每日9:00–17:00（16:00停止入馆），周一闭馆 / 9:00–17:00 daily (last entry 16:00), closed on Mondays<br>- **交通信息 / Transportation：** 地铁1号线天安门东站，步行约5分钟；亦可在参观结束后由西门出馆，前往天安门广场游览 / Subway Line 1, Tiananmen East station, about a 5-minute walk; after the visit, exit via the West Gate to continue to Tiananmen Square</p>',
  '',
  9,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_temple_of_heaven_bj_sa_01',
  'beijing_temple_of_heaven',
  'circular mound altar',
  '圜丘坛 / Circular Mound Altar',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_temple_of_heaven_bj_sa_01.png',
  '<p>- **名字 / Name：** 圜丘坛 / Circular Mound Altar<br>- **摘要 / Summary：** 明清皇帝冬至祭天的露天圆形祭坛，三层汉白玉坛面象征"天圆"，奇妙的数字设计蕴含宇宙秩序。 The open-air circular altar where Ming and Qing emperors offered sacrifices to Heaven on the winter solstice—three tiers of white marble symbolizing "round heaven," its numerical design encoding cosmic order.<br>- **长文描述 / Description：** 圜丘坛是天坛南部的核心祭坛，始建于明嘉靖九年（1530年），清乾隆十四年（1749年）扩建。坛为三层圆形露天石台，全部以汉白玉砌筑，每层坛面栏板、台阶数目均为九或九的倍数——九为极阳之数，象征天帝至高无上。上层坛面中心有一块圆形"天心石"，站在其上说话，声波经四周栏板反射回聚，产生奇妙的扩音效果，仿佛天帝回应。坛周环绕两层壝墙，内圆外方，呼应"天圆地方"的古宇宙观。冬至日黎明，皇帝于此举行祭天大典，焚烧祭品、恭读祝文，庄严肃穆。圜丘坛虽无殿宇遮盖，却以纯粹的几何与数字语言表达了古人对天的敬畏与理解，是中国礼制建筑的巅峰之作。 The Circular Mound Altar is the core sacrificial structure in the southern part of the Temple of Heaven, first built in 1530 (Jiajing 9) and expanded in 1749 (Qianlong 14). It is a three-tiered open-air circular stone platform constructed entirely of white marble; the number of balustrade panels and steps on each tier is always nine or a multiple of nine—the supreme yang number symbolizing the highest authority of the Lord of Heaven. At the centre of the top tier lies a round "Heart of Heaven" stone; speaking from it, sound waves reflect from the surrounding balustrades and converge back, creating a startling amplification as if Heaven itself replies. Two concentric enclosure walls surround the altar—inner circular, outer square—echoing the ancient cosmology of "round heaven, square earth." At dawn on the winter solstice the emperor conducted the grand sacrifice, burning offerings and reading prayers with solemn reverence. Though roofless, the altar expresses awe and understanding of Heaven through pure geometry and number—the pinnacle of Chinese ritual architecture.<br>- **详细地址 / Address：** 北京市东城区天坛内东里7号（天坛南部） / No. 7 Tiantan Neidongli, Dongcheng District, Beijing (southern section of Temple of Heaven)<br>- **门票信息 / Ticket Information：** 联票旺季34元/淡季28元（含圜丘坛、祈年殿、回音壁）；普通门票旺季15元/淡季10元（不含核心景点） / Combined ticket peak ¥34 / off-peak ¥28 (incl. Circular Mound, Hall of Prayer, Echo Wall); general admission peak ¥15 / off-peak ¥10 (excl. core sites)<br>- **开放时间 / Opening Hours：** 公园大门6:00-22:00（21:00停止入园）；景点旺季8:00-17:30/淡季8:00-16:30 / Park gates 6:00–22:00 (last entry 21:00); core sites peak 8:00–17:30 / off-peak 8:00–16:30<br>- **交通信息 / Transportation：** 地铁5号线天坛东门站A口出，进东门后沿中轴线南行约20分钟；或7号线天桥站C口至西门，南行至圜丘坛 / Subway Line 5 Tiantan East Gate station Exit A, enter East Gate then walk south along central axis approx. 20 min; or Line 7 Tianqiao station Exit C to West Gate, then walk south to altar</p><p>---</p>',
  '',
  0,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_temple_of_heaven_bj_sa_02',
  'beijing_temple_of_heaven',
  'imperial vault of heaven echo wall',
  '皇穹宇与回音壁 / Imperial Vault of Heaven & Echo Wall',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_temple_of_heaven_bj_sa_02.png',
  '<p>- **名字 / Name：** 皇穹宇与回音壁 / Imperial Vault of Heaven &amp; Echo Wall<br>- **摘要 / Summary：** 存放皇天上帝神位的圆形殿宇与其环绕的回音壁，声学奇观令人叹为观止。 The circular hall housing the tablet of the Lord of Heaven and its surrounding Echo Wall—an acoustic marvel that leaves visitors awestruck.<br>- **长文描述 / Description：** 皇穹宇位于圜丘坛北侧，始建于明嘉靖九年（1530年），清乾隆十七年（1752年）重建，是存放皇天上帝及历代祖先神位的殿宇。殿为单檐圆形攒尖顶，蓝琉璃瓦覆盖，立于圆形石台之上，造型精巧优美，直径仅15.6米，却以完美的比例与色彩展现出天穹的神圣意象。殿内穹顶无梁无柱，全凭斗拱支撑，木构技术高超。殿外环绕的圆形围墙即为著名的"回音壁"——墙高3.72米，厚0.9米，周长195.2米，两面各有一座三门琉璃门。若两人分站东西配殿后方贴墙轻语，声波沿光滑墙面连续反射传播，对方清晰可闻，如同隔墙对话，声学原理与光学反射类似，堪称中国古代建筑的意外杰作。院中还有"三音石"，站在石上拍手可听到三次回声，进一步增添了奇趣。 The Imperial Vault of Heaven stands north of the Circular Mound Altar, first built in 1530 (Jiajing 9) and rebuilt in 1752 (Qianlong 17). It is the hall where the tablet of the Lord of Heaven and ancestral spirit tablets were stored. A single-eaved circular structure with a conical roof under blue glazed tiles, it rises from a round stone platform—delicate and graceful, just 15.6 m in diameter yet displaying the sacred imagery of the celestial vault through perfect proportion and colour. The interior dome is beamless and columnless, supported entirely by intricate bracket sets—a masterwork of timber engineering. The circular enclosing wall outside is the celebrated Echo Wall—3.72 m high, 0.9 m thick, 195.2 m in circumference, with a triple-arched glazed doorway on each side. If two people stand at the rear of the east and west side halls and whisper against the wall, sound waves propagate along the smooth surface by successive reflection, and each hears the other clearly as though conversing across the wall—an acoustic analogue of optical reflection, a serendipitous masterpiece of ancient Chinese construction. The courtyard also contains "Three-Sound Stones"—clapping on them yields three echoes, adding further wonder.<br>- **详细地址 / Address：** 北京市东城区天坛内东里7号（圜丘坛北侧） / No. 7 Tiantan Neidongli, Dongcheng District, Beijing (north of Circular Mound Altar)<br>- **门票信息 / Ticket Information：** 需联票进入（旺季34元/淡季28元） / Requires combined ticket (peak ¥34 / off-peak ¥28)<br>- **开放时间 / Opening Hours：** 景点旺季8:00-17:30/淡季8:00-16:30 / Peak 8:00–17:30 / off-peak 8:00–16:30<br>- **交通信息 / Transportation：** 地铁5号线天坛东门站A口出，沿中轴线南行至圜丘坛后北望即达；7号线天桥站至西门南行亦可 / Subway Line 5 Tiantan East Gate station Exit A → walk south along axis to Circular Mound, then look north; Line 7 Tianqiao station → West Gate, walk south also possible</p><p>---</p>',
  '',
  1,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_temple_of_heaven_bj_sa_03',
  'beijing_temple_of_heaven',
  'danbi bridge sacred way bridge',
  '丹陛桥 / Danbi Bridge (Sacred Way Bridge)',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_temple_of_heaven_bj_sa_03.png',
  '<p>- **名字 / Name：** 丹陛桥 / Danbi Bridge (Sacred Way Bridge)<br>- **摘要 / Summary：** 连接圜丘坛与祈年殿的360米长石砌神道，如巨龙脊背贯通南北，是祭天仪式的庄严通道。 A 360-metre-long stone-paved sacred way linking the Circular Mound Altar to the Hall of Prayer for Good Harvests—like a dragon''s spine running north-south, the solemn processional route of the heaven-sacrifice ceremony.<br>- **长文描述 / Description：** 丹陛桥是天坛中轴线上最醒目的通道，南起圜丘坛北门，北至祈年殿南门，全长约360米，宽约28米，由三道石板铺成。中间最高的一道为"神道"，专供皇天上帝神位通行；东侧为"御道"，皇帝行走；西侧为"王道"，王公大臣随行——等级分明，不可僭越。桥面自南向北缓缓升高，寓意步步登天、由人间走向天界，行走其间确有仰视天穹、心怀敬畏之感。桥两侧古柏森森，树龄数百年，树冠如盖，浓荫蔽日，庄严肃穆之中又添一份苍翠生机。丹陛桥虽名为"桥"，实为高出地面4米的大道，下方曾为祭牲通道，设计巧妙。整条神道如同一条巨龙脊背贯通南北，将圜丘坛与祈年殿连为一体，是天坛礼制空间的核心轴线。 Danbi Bridge is the most prominent passageway on the Temple of Heaven''s central axis, running from the Circular Mound Altar''s north gate to the Hall of Prayer''s south gate—about 360 m long and 28 m wide, paved in three parallel stone strips. The highest, central strip is the "Spirit Way," reserved for the tablet of the Lord of Heaven; the eastern strip is the "Imperial Way" for the emperor; the western is the "Princes'' Way" for nobles and ministers—strict hierarchy, no trespassing. The surface rises gradually from south to north, symbolizing step-by-step ascent from the human realm toward heaven; walking it truly induces a sense of looking up at the sky with reverent awe. Ancient cypress trees flank both sides, centuries old, canopying like umbrellas—solemnity enriched by verdant vitality. Though called a "bridge," it is actually an elevated road rising 4 m above ground; beneath it ran a passage for sacrificial animals—a clever design. The entire sacred way, like a dragon''s spine running north-south, binds the Circular Mound Altar and the Hall of Prayer into one ritual whole, the core axis of the Temple of Heaven''s ceremonial space.<br>- **详细地址 / Address：** 北京市东城区天坛内东里7号（天坛中轴线，圜丘坛与祈年殿之间） / No. 7 Tiantan Neidongli, Dongcheng District, Beijing (central axis, between Circular Mound Altar and Hall of Prayer)<br>- **门票信息 / Ticket Information：** 包含在普通门票内（旺季15元/淡季10元） / Included in general admission (peak ¥15 / off-peak ¥10)<br>- **开放时间 / Opening Hours：** 随公园开放，6:00-22:00（21:00停止入园） / Follows park hours: 6:00–22:00 (last entry 21:00)<br>- **交通信息 / Transportation：** 任何门进入后沿中轴线均可到达，东门最便捷（地铁5号线天坛东门站） / Accessible from any gate via the central axis; East Gate most convenient (Subway Line 5 Tiantan East Gate station)</p><p>---</p>',
  '',
  2,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_temple_of_heaven_bj_sa_04',
  'beijing_temple_of_heaven',
  'hall of prayer for good harvests',
  '祈年殿 / Hall of Prayer for Good Harvests',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_temple_of_heaven_bj_sa_04.png',
  '<p>- **名字 / Name：** 祈年殿 / Hall of Prayer for Good Harvests<br>- **摘要 / Summary：** 天坛最标志性建筑，三重蓝檐圆形大殿如天穹降落人间，是中国古建筑的无价瑰宝。 The Temple of Heaven''s most iconic structure—a triple-eaved circular hall under blue tiles descending like the celestial vault to earth, an invaluable treasure of Chinese architecture.<br>- **长文描述 / Description：** 祈年殿是天坛北部的主殿，也是整个天坛的视觉灵魂。殿始建于明永乐十八年（1420年），初名"大祀殿"，明嘉靖改为"大享殿"，清乾隆十六年（1751年）定名"祈年殿"。殿为三重檐圆形攒尖顶，蓝琉璃瓦覆盖，立于三层汉白玉圆形石台之上，总高约38米，直径约32米。殿内结构绝妙：28根楠木大柱承托穹顶，无梁无钉，全凭榫卯与斗拱层层递升。内圈4根龙井柱象征四季，中圈12根金柱象征十二月，外圈12根檐柱象征十二时辰，柱数合计暗合二十四节气，空间即时间，建筑即宇宙。殿内中央设皇天上帝神位，每年正月上辛日皇帝于此举行祈谷大典，祈求五谷丰登。祈年殿以其完美的圆形、蓝色穹顶与精妙的结构，成为中国古建筑的象征，也是世界文化遗产中最具辨识度的中国形象之一。 The Hall of Prayer for Good Harvests is the main hall in the northern part of the Temple of Heaven and its visual soul. First built in 1420 (Yongle 18) as "Great Sacrifice Hall," renamed "Great Offering Hall" under Jiajing, and given its present name in 1751 (Qianlong 16). It is a triple-eaved circular structure with a conical roof under blue glazed tiles, standing on a three-tiered white-marble circular platform—about 38 m high and 32 m in diameter. The interior is a structural marvel: 28 nanmu columns carry the dome without beams or nails, relying on mortise-and-tenon joints and bracket sets rising tier by tier. The inner ring of four "Dragon Well" columns symbolizes the four seasons; the middle ring of twelve "Golden" columns symbolizes the twelve months; the outer ring of twelve "Eave" columns symbolizes the twelve double-hours; the total of 28 implicitly echoes the twenty-four solar terms—space is time, building is cosmos. At the centre stands the tablet of the Lord of Heaven; on the first sin day of the first lunar month the emperor held the Praying-for-Harvest ceremony here, beseeching abundant crops. With its perfect circle, blue dome and ingenious structure, the Hall has become the symbol of Chinese ancient architecture and one of the most recognizable Chinese images among World Heritage sites.<br>- **详细地址 / Address：** 北京市东城区天坛内东里7号（天坛北部中心） / No. 7 Tiantan Neidongli, Dongcheng District, Beijing (centre of northern section)<br>- **门票信息 / Ticket Information：** 需联票进入（旺季34元/淡季28元） / Requires combined ticket (peak ¥34 / off-peak ¥28)<br>- **开放时间 / Opening Hours：** 景点旺季8:00-17:30/淡季8:00-16:30 / Peak 8:00–17:30 / off-peak 8:00–16:30<br>- **交通信息 / Transportation：** 地铁5号线天坛东门站A口出，沿中轴线北行约15分钟；或7号线天桥站至西门，沿中轴线北行约25分钟 / Subway Line 5 Tiantan East Gate Exit A → walk north along axis approx. 15 min; or Line 7 Tianqiao → West Gate, walk north along axis approx. 25 min</p><p>---</p>',
  '',
  3,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_temple_of_heaven_bj_sa_05',
  'beijing_temple_of_heaven',
  'north gate',
  '北门 / North Gate',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_temple_of_heaven_bj_sa_05.png',
  '<p>- **名字 / Name：** 北门 / North Gate<br>- **摘要 / Summary：** 天坛北侧出口，毗邻祈年殿，门外古柏成林，是游览结束时的静谧归途。 The north-side exit of the Temple of Heaven, adjacent to the Hall of Prayer; ancient cypresses cluster outside—a tranquil, contemplative path as the visit draws to an end.<br>- **长文描述 / Description：** 天坛北门位于公园北侧，是祈年殿区域的主要出入口之一。门体为红墙灰瓦的古典样式，门外即为天坛北路，周边古柏参天，绿荫浓密，与园内景观无缝衔接。北门位置靠近祈年殿，参观完祈年殿后由此出园最为便捷，不必折返南行。门外步道沿古柏林延伸，空气中弥漫松柏清香，春季槐花盛开时更是满目芬芳。北门外向东步行约10分钟可达地铁5号线天坛东门站，向西约15分钟可达前门大街与天安门广场，地理位置优越，出园后即可衔接北京中轴线其他重要景点。北门虽不如东门、西门繁华，却因静谧古朴而更显天坛的庄重气质，是完美收官之处。 The North Gate sits on the park''s north side, one of the main access points for the Hall of Prayer precinct. Its classical style features red walls and grey tiles; outside, ancient cypresses tower, their shade dense, seamlessly extending the park''s landscape. Positioned close to the Hall of Prayer, exiting here after visiting the Hall is most convenient—no need to retrace southward. The path outside continues through a cypress grove, the air fragrant with pine and cedar; in spring blooming locust trees scent the whole approach. Walking east about 10 minutes from the gate reaches Subway Line 5''s Tiantan East Gate station; west about 15 minutes reaches Qianmen Street and Tiananmen Square—prime positioning for connecting to other central-axis landmarks. Though less bustling than the East or West Gates, its quiet antiquity underscores the Temple''s solemn character, a perfect finale to the visit.<br>- **详细地址 / Address：** 北京市东城区天坛内东里7号（天坛北侧） / No. 7 Tiantan Neidongli, Dongcheng District, Beijing (north side of Temple of Heaven)<br>- **门票信息 / Ticket Information：** 出园无需额外门票；入园需普通门票（旺季15元/淡季10元）或联票（旺季34元/淡季28元） / No extra ticket for exiting; entry requires general admission (peak ¥15 / off-peak ¥10) or combined ticket (peak ¥34 / off-peak ¥28)<br>- **开放时间 / Opening Hours：** 随公园大门开放，6:00-22:00（21:00停止入园） / Follows park gate hours: 6:00–22:00 (last entry 21:00)<br>- **交通信息 / Transportation：** 地铁5号线天坛东门站A口出，沿天坛东路北行约5分钟至北门；或乘6路、34路、35路公交至天坛北门站 / Subway Line 5 Tiantan East Gate Exit A → walk north along Tiantan East Road approx. 5 min to North Gate; or Bus 6/34/35 to Tiantan North Gate stop</p><p>---</p>',
  '',
  4,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_prince_gong_mansion_bj_sa_01',
  'beijing_prince_gong_mansion',
  'palace gate',
  '宫门 / Palace Gate',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_prince_gong_mansion_bj_sa_01.jpg',
  '<p>- **名字 / Name：** 宫门 / Palace Gate<br>- **摘要 / Summary：** 恭王府的正门，庄严肃穆，彰显王府气派。 The main entrance of Prince Gong''s Mansion, solemn and majestic, showcasing the grandeur of a royal residence.<br>- **长文描述 / Description：** 宫门是恭王府的正式出入口，建于清代中后期，面阔三间，歇山顶覆绿琉璃瓦，门钉纵九横七，符合亲王级别的礼制规格。门前原有石狮一对，威严矗立，象征王府的尊贵地位。宫门两侧连接八字影壁，砖雕精美，图案寓意吉祥。步入宫门，便正式进入这座历经乾隆、嘉庆、道光、咸丰数朝风云的深宅大院，感受到历史扑面而来的厚重气息。这座门见证了从和珅到恭亲王奕訢的百年沧桑。 The Palace Gate is the formal entrance to Prince Gong''s Mansion, built in the mid-to-late Qing Dynasty. It spans three bays with a gable-and-hip roof covered in green glazed tiles, and its door nails are arranged in nine vertical and seven horizontal rows, conforming to the specifications for a prince of the first rank. A pair of stone lions once stood guard before the gate, symbolizing the nobility of the residence. Flanking the gate are screen walls with exquisite brick carvings featuring auspicious patterns. Stepping through the Palace Gate, visitors enter the grand compound that witnessed the rise and fall of Heshen and Prince Gong Yixin across multiple reigns, feeling the weight of history that has accumulated over more than two centuries.<br>- **详细地址 / Address：** 北京市西城区前海西街17号恭王府宫门 / Palace Gate, Prince Gong''s Mansion, No. 17 Qianhai West Street, Xicheng District, Beijing<br>- **门票信息 / Ticket Information：** 成人40元/人，学生、老人等享受优惠票价，具体以官方公告为准 / Adult 40 RMB per person; discounted rates available for students and seniors; subject to official announcements<br>- **开放时间 / Opening Hours：** 8:30-17:00（16:10停止检票），全年开放，周一不闭馆 / 8:30-17:00 (last entry at 16:10), open year-round, not closed on Mondays<br>- **交通信息 / Transportation：** 乘坐地铁6号线至北海北站，从B口出站，步行约10分钟可达；或乘坐公交13路、42路、107路、111路、118路至厂桥路口西站下车步行前往 / Take Subway Line 6 to Beihai North Station, Exit B, walk about 10 minutes; or take bus routes 13, 42, 107, 111, or 118 to Changqiao Lukou Xi station and walk</p><p>---</p>',
  '',
  0,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_prince_gong_mansion_bj_sa_02',
  'beijing_prince_gong_mansion',
  'yin an hall and jiale hall',
  '银安殿与嘉乐堂 / Yin''an Hall and Jiale Hall',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_prince_gong_mansion_bj_sa_02.jpg',
  '<p>- **名字 / Name：** 银安殿与嘉乐堂 / Yin''an Hall and Jiale Hall<br>- **摘要 / Summary：** 王府中路主殿与寝居之所，礼仪与生活并重。 The central-axis main hall and living quarters of the mansion, where ceremony and daily life intertwined.<br>- **长文描述 / Description：** 银安殿是恭王府中路建筑的核心，为亲王理政、会客和举行重大典礼之所，面阔七间，绿琉璃瓦歇山顶，殿前月台宽敞，规格仅次于皇宫太和殿。殿内原陈设华丽，彰显亲王尊荣。银安殿后为嘉乐堂，是府内重要的寝居与宴饮空间，取"嘉言善行、其乐融融"之意。嘉乐堂曾收藏大量珍贵文物与书画，是府中文化气息最浓郁之处。两座建筑前后相承，构成中路中轴线上最庄严的建筑序列，体现了清代王府"前殿后寝"的经典格局。 Yin''an Hall is the architectural centerpiece of the mansion''s central axis, serving as the venue for the prince''s administrative affairs, receptions, and major ceremonies. It spans seven bays with a green-tiled gable-and-hip roof, and its spacious front platform ranks just below the Hall of Supreme Harmony in the imperial palace. The interior was once luxuriously furnished. Behind it stands Jiale Hall, an important living and banqueting space whose name evokes "virtuous words and harmonious joy." Jiale Hall once housed a vast collection of precious antiques, calligraphy, and paintings, making it the cultural heart of the mansion. The two halls form the most solemn architectural sequence on the central axis, reflecting the classic Qing Dynasty princely layout of "front hall, rear quarters."<br>- **详细地址 / Address：** 北京市西城区前海西街17号恭王府中路 / Central Axis, Prince Gong''s Mansion, No. 17 Qianhai West Street, Xicheng District, Beijing<br>- **门票信息 / Ticket Information：** 包含在恭王府大门票内，成人40元/人 / Included in the general admission ticket of Prince Gong''s Mansion, adult 40 RMB per person<br>- **开放时间 / Opening Hours：** 8:30-17:00（16:10停止检票） / 8:30-17:00 (last entry at 16:10)<br>- **交通信息 / Transportation：** 地铁6号线北海北站B口出，步行约10分钟；公交13路、42路、107路、111路、118路至厂桥路口西站 / Subway Line 6 to Beihai North Station, Exit B, walk about 10 minutes; or bus routes 13, 42, 107, 111, 118 to Changqiao Lukou Xi station</p><p>---</p>',
  '',
  1,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_prince_gong_mansion_bj_sa_03',
  'beijing_prince_gong_mansion',
  'baoguang chamber and xijin studio',
  '葆光室与锡晋斋 / Baoguang Chamber and Xijin Studio',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_prince_gong_mansion_bj_sa_03.jpg',
  '<p>- **名字 / Name：** 葆光室与锡晋斋 / Baoguang Chamber and Xijin Studio<br>- **摘要 / Summary：** 府西路院落中的精致厅堂，藏珍纳宝，尽显匠心。 Exquisite halls in the western compound, once housing treasures and showcasing masterful craftsmanship.<br>- **长文描述 / Description：** 葆光室位于恭王府西路，取《庄子》"葆光"之意，寓意内敛含蓄、光华蕴藉，是府中静修与读书之所，室内装饰典雅，木雕隔扇工艺精湛。锡晋斋则是恭王府中最具传奇色彩的建筑之一，相传为和珅仿紫禁城宁寿宫所建，殿内金丝楠木仙楼隔断通体雕花，极尽奢华，也是和珅僭越罪状之一。恭亲王奕訢后来将晋代陆机《平复帖》珍藏于此，故名"锡晋斋"。两处建筑一静一奢，分别体现了文人雅趣与权臣气派，是了解王府多元面貌的重要窗口。 Baoguang Chamber, located in the western compound, takes its name from the Zhuangzi concept of "harbored light," symbolizing restraint and inner brilliance. It served as a space for quiet study and meditation, with elegant interior decorations and exquisitely carved wooden partitions. Xijin Studio is one of the most legendary buildings in the mansion, said to have been built by Heshen in imitation of the Palace of Tranquil Longevity in the Forbidden City. Its interior features a golden-thread nanmu wood mezzanine with fully carved surfaces of extraordinary luxury, which later became one of the charges against Heshen for overstepping his rank. Prince Gong Yixin subsequently stored Lu Ji''s famous "Pingfu Tie" calligraphy scroll here, giving the studio its name. Together, the two buildings—one serene, one opulent—reveal the dual character of scholarly refinement and powerful grandeur that defines the mansion.<br>- **详细地址 / Address：** 北京市西城区前海西街17号恭王府西路 / Western Compound, Prince Gong''s Mansion, No. 17 Qianhai West Street, Xicheng District, Beijing<br>- **门票信息 / Ticket Information：** 包含在恭王府大门票内，成人40元/人 / Included in the general admission ticket, adult 40 RMB per person<br>- **开放时间 / Opening Hours：** 8:30-17:00（16:10停止检票） / 8:30-17:00 (last entry at 16:10)<br>- **交通信息 / Transportation：** 地铁6号线北海北站B口出，步行约10分钟；公交13路、42路、107路、111路、118路至厂桥路口西站 / Subway Line 6 to Beihai North Station, Exit B, walk about 10 minutes; or bus routes 13, 42, 107, 111, 118 to Changqiao Lukou Xi station</p><p>---</p>',
  '',
  2,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_prince_gong_mansion_bj_sa_04',
  'beijing_prince_gong_mansion',
  'rear cover building',
  '后罩楼 / Rear Cover Building',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_prince_gong_mansion_bj_sa_04.jpg',
  '<p>- **名字 / Name：** 后罩楼 / Rear Cover Building<br>- **摘要 / Summary：** 横贯府邸北墙的两层长楼，府中最神秘之所在。 A two-story elongated building running along the northern wall, the most mysterious structure in the mansion.<br>- **长文描述 / Description：** 后罩楼是恭王府最引人注目的建筑之一，东西长约180米，上下两层共四十余间，横亘于府邸北界，如一道屏障将宅院与后花园隔开。此楼相传为和珅的藏宝楼，每间房内暗设壁龛夹层，用以存放金银珠宝和珍贵文物。和珅被查抄时，由此楼搜出的财富价值连城，民间传说"和珅跌倒，嘉庆吃饱"即源于此。后罩楼墙体厚重，窗户形制各异，有方有圆，既有装饰之妙，也暗含通风防盗之用。漫步楼下，仰望连绵的长楼，仿佛仍能感受到当年权倾朝野的和珅那不可一世的气焰。 The Rear Cover Building is one of the most striking structures in Prince Gong''s Mansion. Stretching approximately 180 meters from east to west with over forty rooms on two levels, it spans the entire northern boundary of the residence like a barrier separating the living quarters from the garden behind. Legend holds that this was Heshen''s treasure house, with hidden compartments and niches in each room storing gold, silver, jewels, and precious artifacts. When Heshen was arrested, the wealth confiscated from this building was staggering, giving rise to the popular saying "When Heshen falls, Jiaqing is full." The building features massive walls and windows of varied shapes—some square, some round—serving both decorative and practical purposes of ventilation and security. Walking beneath it and gazing up at the continuous facade, one can almost feel the overwhelming ambition of the once all-powerful Heshen.<br>- **详细地址 / Address：** 北京市西城区前海西街17号恭王府北部 / Northern Section, Prince Gong''s Mansion, No. 17 Qianhai West Street, Xicheng District, Beijing<br>- **门票信息 / Ticket Information：** 包含在恭王府大门票内，成人40元/人 / Included in the general admission ticket, adult 40 RMB per person<br>- **开放时间 / Opening Hours：** 8:30-17:00（16:10停止检票） / 8:30-17:00 (last entry at 16:10)<br>- **交通信息 / Transportation：** 地铁6号线北海北站B口出，步行约10分钟；公交13路、42路、107路、111路、118路至厂桥路口西站 / Subway Line 6 to Beihai North Station, Exit B, walk about 10 minutes; or bus routes 13, 42, 107, 111, 118 to Changqiao Lukou Xi station</p><p>---</p>',
  '',
  3,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_prince_gong_mansion_bj_sa_05',
  'beijing_prince_gong_mansion',
  'western style gate and dule peak',
  '西洋门与独乐峰 / Western-Style Gate and Dule Peak',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_prince_gong_mansion_bj_sa_05.png',
  '<p>- **名字 / Name：** 西洋门与独乐峰 / Western-Style Gate and Dule Peak<br>- **摘要 / Summary：** 中西合璧的汉白玉石门与嶙峋奇石，花园入口的标志性景观。 A fusion-style white marble gate and a striking scholar''s rock marking the garden entrance.<br>- **长文描述 / Description：** 西洋门是恭王府花园——萃锦园的正门，由汉白玉雕砌而成，门拱造型融合了巴洛克风格与中国传统纹饰，在清代王府中极为罕见，据说为和珅偏好西洋奇趣而建。门额刻"静含太古"四字，意境悠远。入门后迎面便是独乐峰，一块天然太湖石拔地而起，高约五米，形态奇崛，正面酷似一尊送子观音，背面则如一条昂首鲤鱼。石名取"独乐乐"之意，暗示此处为文人独享山林之乐的隐逸之所。峰下有池，倒影成趣，构成花园第一景，令人未入园中便已心旷神怡。 The Western-Style Gate is the main entrance to Cuijin Garden, the garden of Prince Gong''s Mansion. Constructed from carved white marble, its arch combines Baroque-style elements with traditional Chinese decorative motifs—an extraordinary rarity among Qing Dynasty princely residences, said to reflect Heshen''s fondness for exotic Western aesthetics. The gate''s lintel bears four characters reading "Tranquility Harbors Antiquity," evoking a timeless serenity. Just beyond the gate stands Dule Peak, a natural Taihu stone rising about five meters high with a craggy, dramatic form. From the front, it resembles a Guanyin bestowing children; from the back, a leaping carp. The name "Dule" means "enjoying solitude," suggesting a retreat where scholars savor the pleasures of nature alone. A pool beneath the stone creates delightful reflections, forming the garden''s first scenic vista that calms the spirit before one even enters.<br>- **详细地址 / Address：** 北京市西城区前海西街17号恭王府萃锦园入口 / Entrance of Cuijin Garden, Prince Gong''s Mansion, No. 17 Qianhai West Street, Xicheng District, Beijing<br>- **门票信息 / Ticket Information：** 包含在恭王府大门票内，成人40元/人 / Included in the general admission ticket, adult 40 RMB per person<br>- **开放时间 / Opening Hours：** 8:30-17:00（16:10停止检票） / 8:30-17:00 (last entry at 16:10)<br>- **交通信息 / Transportation：** 地铁6号线北海北站B口出，步行约10分钟；公交13路、42路、107路、111路、118路至厂桥路口西站 / Subway Line 6 to Beihai North Station, Exit B, walk about 10 minutes; or bus routes 13, 42, 107, 111, 118 to Changqiao Lukou Xi station</p><p>---</p>',
  '',
  4,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_prince_gong_mansion_bj_sa_06',
  'beijing_prince_gong_mansion',
  'bat pool and anshan hall',
  '蝠池与安善堂 / Bat Pool and Anshan Hall',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_prince_gong_mansion_bj_sa_06.jpg',
  '<p>- **名字 / Name：** 蝠池与安善堂 / Bat Pool and Anshan Hall<br>- **摘要 / Summary：** 形如展翅蝙蝠的水池与环池雅堂，寓意福气盈门。 A bat-shaped pond and the elegant hall beside it, symbolizing boundless good fortune.<br>- **长文描述 / Description：** 蝠池是恭王府花园中的核心水景，因池形酷似一只展翅的蝙蝠而得名。在中华文化中，"蝠"与"福"同音，蝙蝠是福气的象征。池畔原植榆树数株，"榆"与"余"谐音，取"年年有余、福泽绵长"之意。池水清澈，四时倒映天光云影，池中锦鲤游弋，生机盎然。池北为安善堂，取"安于善行"之意，是园中会客品茗、吟诗作画的雅致之所。堂前临水，堂后依山，建筑与自然融为一体，体现了中国古典园林"虽由人作，宛自天开"的至高境界。 Bat Pool is the central water feature of the mansion''s garden, named for its shape resembling a bat with outstretched wings. In Chinese culture, the word for bat (蝠) is homophonous with the word for fortune (福), making the bat a powerful symbol of blessings. Elms were originally planted along the pool, as the word for elm (榆) sounds like "surplus" (余), conveying wishes for abundance year after year. The pool''s clear waters reflect the sky and clouds in all seasons, while koi swim among the lily pads. To the north stands Anshan Hall, whose name means "dwelling in virtue," an elegant space for receiving guests, sipping tea, and composing poetry. With water before it and hill behind, the hall seamlessly integrates architecture and nature, embodying the supreme ideal of Chinese classical gardens—"though made by human hands, it seems born of nature itself."<br>- **详细地址 / Address：** 北京市西城区前海西街17号恭王府萃锦园中部 / Central Cuijin Garden, Prince Gong''s Mansion, No. 17 Qianhai West Street, Xicheng District, Beijing<br>- **门票信息 / Ticket Information：** 包含在恭王府大门票内，成人40元/人 / Included in the general admission ticket, adult 40 RMB per person<br>- **开放时间 / Opening Hours：** 8:30-17:00（16:10停止检票） / 8:30-17:00 (last entry at 16:10)<br>- **交通信息 / Transportation：** 地铁6号线北海北站B口出，步行约10分钟；公交13路、42路、107路、111路、118路至厂桥路口西站 / Subway Line 6 to Beihai North Station, Exit B, walk about 10 minutes; or bus routes 13, 42, 107, 111, 118 to Changqiao Lukou Xi station</p><p>---</p>',
  '',
  5,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_prince_gong_mansion_bj_sa_07',
  'beijing_prince_gong_mansion',
  'winding cup pavilion bamboo courtyard and peony garden',
  '流杯亭、竹子院与牡丹园 / Winding Cup Pavilion, Bamboo Courtyard, and Peony Garden',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_prince_gong_mansion_bj_sa_07.png',
  '<p>- **名字 / Name：** 流杯亭、竹子院与牡丹园 / Winding Cup Pavilion, Bamboo Courtyard, and Peony Garden<br>- **摘要 / Summary：** 曲水流觞之亭、修竹幽深之院与国色天香之园，三景并秀。 A pavilion for the floating-cup game, a serene bamboo courtyard, and a radiant peony garden—three scenic gems in one.<br>- **长文描述 / Description：** 流杯亭是恭王府花园中最富文人雅趣的建筑，亭内石地面刻有水槽，形如"寿"字，引水入槽，酒杯浮于水上顺流而下，停于谁前谁便饮酒赋诗，此即古代"曲水流觞"之雅事，源于王羲之兰亭集会的故事。竹子院位于流杯亭附近，院中修竹成林，清幽静谧，风过竹梢，沙沙有声，恍若置身江南。牡丹园则栽植各色名贵牡丹，每年四五月份花开时节，姚黄魏紫、赵粉豆绿，争奇斗艳，雍容华贵，令人流连忘返。三处景点由文雅到清幽再到绚烂，层次分明，各擅胜场。 The Winding Cup Pavilion is the most literary and refined structure in the garden. Its stone floor is carved with a water channel shaped like the character for "longevity" (寿). Water flows through the channel, and wine cups float downstream—wherever a cup stops, the person before it drinks and composes a poem. This is the ancient elegant pastime of "winding stream party," originating from Wang Xizhi''s famous gathering at the Orchid Pavilion. The Bamboo Courtyard nearby is filled with tall bamboo creating a tranquil, secluded atmosphere; when the wind passes through the treetops, the rustling leaves transport visitors to a Jiangnan landscape. The Peony Garden cultivates numerous rare varieties of peonies. Every April and May, the flowers bloom in a spectacular display—golden Yao Yellow, purple Wei Purple, pink Zhao Pink, and green Dou Green—each vying in beauty and grandeur. The three sites progress from literary elegance to serene seclusion to brilliant splendor, each with its own distinct charm.<br>- **详细地址 / Address：** 北京市西城区前海西街17号恭王府萃锦园东南部 / Southeastern Cuijin Garden, Prince Gong''s Mansion, No. 17 Qianhai West Street, Xicheng District, Beijing<br>- **门票信息 / Ticket Information：** 包含在恭王府大门票内，成人40元/人 / Included in the general admission ticket, adult 40 RMB per person<br>- **开放时间 / Opening Hours：** 8:30-17:00（16:10停止检票） / 8:30-17:00 (last entry at 16:10)<br>- **交通信息 / Transportation：** 地铁6号线北海北站B口出，步行约10分钟；公交13路、42路、107路、111路、118路至厂桥路口西站 / Subway Line 6 to Beihai North Station, Exit B, walk about 10 minutes; or bus routes 13, 42, 107, 111, 118 to Changqiao Lukou Xi station</p><p>---</p>',
  '',
  6,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_prince_gong_mansion_bj_sa_08',
  'beijing_prince_gong_mansion',
  'yishen chamber and bat hall',
  '怡神所与蝠厅 / Yishen Chamber and Bat Hall',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_prince_gong_mansion_bj_sa_08.png',
  '<p>- **名字 / Name：** 怡神所与蝠厅 / Yishen Chamber and Bat Hall<br>- **摘要 / Summary：** 花园深处的养心之所与形如蝙蝠的奇巧建筑，妙趣横生。 A restorative retreat deep in the garden and an ingenious bat-shaped hall, full of charm.<br>- **长文描述 / Description：** 怡神所是恭王府花园中一处静谧的养心之所，周围古木参天，浓荫蔽日，环境清幽，取"怡养神思"之意，是府中主人闲居独处、调养身心的理想之地。建筑布局精巧，与周边山水植物浑然一体。蝠厅则是一座形态独特的建筑，整体平面呈蝙蝠展翅之形，故名"蝠厅"，与蝠池遥相呼应，再次点明"福"的主题。厅内装修考究，梁枋彩绘保存完好，是研究清代建筑装饰艺术的重要实例。蝠厅隐于花园最深处，游人至此，往往有豁然开朗之感，是游园路线的精彩收尾。 Yishen Chamber is a tranquil retreat for cultivating the spirit, nestled among towering ancient trees with deep shade and a serene atmosphere. Its name means "nourishing the mind and spirit," and it was the ideal place for the mansion''s master to rest in solitude and restore body and soul. Its architectural layout is ingeniously integrated with the surrounding landscape of rocks, water, and plants. Bat Hall is a uniquely shaped building whose floor plan resembles a bat with outstretched wings, hence its name. It echoes the Bat Pool, reinforcing the theme of "fortune" (蝠/福). The interior is finely decorated, and the painted beams and brackets are well preserved, making it an important example for the study of Qing Dynasty architectural ornamentation. Tucked away in the deepest part of the garden, the hall offers visitors a sense of sudden revelation—a magnificent finale to the garden tour.<br>- **详细地址 / Address：** 北京市西城区前海西街17号恭王府萃锦园深处 / Deep in Cuijin Garden, Prince Gong''s Mansion, No. 17 Qianhai West Street, Xicheng District, Beijing<br>- **门票信息 / Ticket Information：** 包含在恭王府大门票内，成人40元/人 / Included in the general admission ticket, adult 40 RMB per person<br>- **开放时间 / Opening Hours：** 8:30-17:00（16:10停止检票） / 8:30-17:00 (last entry at 16:10)<br>- **交通信息 / Transportation：** 地铁6号线北海北站B口出，步行约10分钟；公交13路、42路、107路、111路、118路至厂桥路口西站 / Subway Line 6 to Beihai North Station, Exit B, walk about 10 minutes; or bus routes 13, 42, 107, 111, 118 to Changqiao Lukou Xi station</p><p>---</p>',
  '',
  7,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_prince_gong_mansion_bj_sa_09',
  'beijing_prince_gong_mansion',
  'path to the clouds moon inviting terrace emerald rock and the fu stele',
  '平步青云路、邀月台、滴翠岩与福字碑 / Path to the Clouds, Moon-Inviting Terrace, Emerald Rock, and the "Fu" Stele',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_prince_gong_mansion_bj_sa_09.png',
  '<p>- **名字 / Name：** 平步青云路、邀月台、滴翠岩与福字碑 / Path to the Clouds, Moon-Inviting Terrace, Emerald Rock, and the "Fu" Stele<br>- **摘要 / Summary：** 青云石阶、赏月高台、叠翠假山与康熙御笔福字碑，花园最高潮所在。 Stone steps to the clouds, a moon-viewing terrace, cascading green rockery, and Emperor Kangxi''s calligraphic "Fu" stele—the climax of the garden.<br>- **长文描述 / Description：** 平步青云路是一条由叠石构成的上山甬道，石阶起伏蜿蜒，取"平步青云"之吉意，寓意仕途通达、步步高升。拾级而上可达邀月台，取李白"举杯邀明月"之诗意，是园中赏月观景的最佳位置，登台俯瞰，全园美景尽收眼底。邀月台下即为滴翠岩，一座由太湖石叠砌而成的巨大假山，山石嶙峋，翠藤攀附，中有洞穴可穿行。假山最深处藏有著名的"福"字碑，传为康熙帝御笔亲书，笔力遒劲，气势磅礴。此"福"字可分解为"多子、多才、多田、多寿"四意，被誉为"天下第一福"，是恭王府的镇府之宝，也是游客必至的祈福圣地。 The Path to the Clouds is a stone-paved walkway built through layered rocks, winding upward with the auspicious meaning of "rising smoothly to the clouds," symbolizing a successful career and rising status. At the top lies the Moon-Inviting Terrace, named after Li Bai''s poem "I raise my cup to invite the moon," offering the finest spot for moon-viewing and panoramic vistas of the entire garden. Below the terrace stands Emerald Rock, a massive Taihu stone rockery with craggy surfaces draped in green vines and interior passages for exploration. Deep within the rockery lies the famous "Fu" (Fortune) stele, believed to be the handwritten calligraphy of Emperor Kangxi, executed with vigorous strokes and imposing grandeur. The character can be decomposed into four meanings—"many sons, many talents, many fields, and long life"—earning it the title "The Greatest Fortune Under Heaven." It is the treasure of Prince Gong''s Mansion and a must-visit pilgrimage site for those seeking blessings.<br>- **详细地址 / Address：** 北京市西城区前海西街17号恭王府萃锦园中北部 / North-Central Cuijin Garden, Prince Gong''s Mansion, No. 17 Qianhai West Street, Xicheng District, Beijing<br>- **门票信息 / Ticket Information：** 包含在恭王府大门票内，成人40元/人 / Included in the general admission ticket, adult 40 RMB per person<br>- **开放时间 / Opening Hours：** 8:30-17:00（16:10停止检票） / 8:30-17:00 (last entry at 16:10)<br>- **交通信息 / Transportation：** 地铁6号线北海北站B口出，步行约10分钟；公交13路、42路、107路、111路、118路至厂桥路口西站 / Subway Line 6 to Beihai North Station, Exit B, walk about 10 minutes; or bus routes 13, 42, 107, 111, 118 to Changqiao Lukou Xi station</p><p>---</p>',
  '',
  8,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_prince_gong_mansion_bj_sa_10',
  'beijing_prince_gong_mansion',
  'square pond pavilion miaoxiang pavilion dragon king temple and archery range',
  '方塘水榭、妙香亭、龙王庙与箭道 / Square Pond Pavilion, Miaoxiang Pavilion, Dragon King Temple, and Archery Range',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_prince_gong_mansion_bj_sa_10.jpg',
  '<p>- **名字 / Name：** 方塘水榭、妙香亭、龙王庙与箭道 / Square Pond Pavilion, Miaoxiang Pavilion, Dragon King Temple, and Archery Range<br>- **摘要 / Summary：** 方塘临水之榭、荷香小亭、龙王古庙与演武箭道，集文武雅趣于一区。 A waterside pavilion on a square pond, a lotus-scented gazebo, an ancient Dragon King temple, and an archery range—gathering literary and martial pursuits in one area.<br>- **长文描述 / Description：** 方塘水榭建于方塘之上，是一座三面临水的精巧建筑，塘中植荷花，夏日荷叶田田，荷香四溢，水榭如浮于水面，是消夏纳凉的绝佳去处。妙香亭位于方塘之畔，取"妙香远布"之意，亭周遍植花木，四季芬芳，是赏花品茗的雅地。龙王庙是园中一座小型庙宇，供奉龙王，反映了古人祈雨祈福的信仰传统，庙虽小而布局完整，古意盎然。箭道则是府中习武射箭的场地，道旁古树成行，地面开阔笔直，体现了满族贵族文武并重、骑射传家的尚武精神。四景相邻，文武兼备，展现了王府生活的丰富面貌。 The Square Pond Pavilion is an exquisite structure built over the Square Pond, surrounded by water on three sides. The pond is planted with lotus flowers; in summer, lush leaves and fragrant blossoms fill the air, and the pavilion appears to float on the water—an ideal summer retreat. Miaoxiang Pavilion sits beside the pond, its name meaning "wondrous fragrance spreads afar." Surrounded by flowering trees and shrubs that bloom across all four seasons, it is a perfect spot for enjoying flowers and tea. The Dragon King Temple is a small shrine dedicated to the Dragon King, reflecting ancient beliefs in praying for rain and blessings. Though modest in size, it is complete in layout and rich in antiquity. The Archery Range is the martial practice ground of the mansion, with ancient trees lining a long, straight, open path, embodying the Manchu aristocratic tradition of valuing both letters and martial arts and the ancestral heritage of horsemanship and archery. Together, the four neighboring sites present a portrait of the diverse lifestyle within the princely mansion.<br>- **详细地址 / Address：** 北京市西城区前海西街17号恭王府萃锦园西北部 / Northwestern Cuijin Garden, Prince Gong''s Mansion, No. 17 Qianhai West Street, Xicheng District, Beijing<br>- **门票信息 / Ticket Information：** 包含在恭王府大门票内，成人40元/人 / Included in the general admission ticket, adult 40 RMB per person<br>- **开放时间 / Opening Hours：** 8:30-17:00（16:10停止检票） / 8:30-17:00 (last entry at 16:10)<br>- **交通信息 / Transportation：** 地铁6号线北海北站B口出，步行约10分钟；公交13路、42路、107路、111路、118路至厂桥路口西站 / Subway Line 6 to Beihai North Station, Exit B, walk about 10 minutes; or bus routes 13, 42, 107, 111, 118 to Changqiao Lukou Xi station</p><p>---</p>',
  '',
  9,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_prince_gong_mansion_bj_sa_11',
  'beijing_prince_gong_mansion',
  'ledao hall and duofu pavilion',
  '乐道堂与多福轩 / Ledao Hall and Duofu Pavilion',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_prince_gong_mansion_bj_sa_11.png',
  '<p>- **名字 / Name：** 乐道堂与多福轩 / Ledao Hall and Duofu Pavilion<br>- **摘要 / Summary：** 恭亲王起居之所与多子多福之轩，府中东路精华所在。 The residence of Prince Gong and the pavilion of abundant blessings—the highlights of the eastern compound.<br>- **长文描述 / Description：** 乐道堂是恭亲王奕訢的起居之所，取"安贫乐道"之意，堂名由奕訢亲题，表达了他虽处政治漩涡之中仍坚守儒家道德理想的心境。堂内陈设典雅，保留有清代家具和文房用具，窗棂隔扇工艺精美，是了解晚清亲王日常生活的珍贵空间。多福轩位于乐道堂附近，取"多子多福"之吉意，是府中举行家庭庆典和接待内眷的场所。轩内悬挂有多幅福寿匾联，装饰华美而不失雅致，处处体现着对福寿绵长的美好期盼。两处建筑一重修身、一重齐家，从不同侧面反映了恭亲王奕訢的精神世界与家族生活。 Ledao Hall was the living quarters of Prince Gong Yixin. Its name, meaning "finding joy in the Way," was personally inscribed by Yixin, expressing his commitment to Confucian moral ideals despite being embroiled in political turmoil. The hall retains elegant Qing Dynasty furnishings and scholar''s implements, with finely crafted window lattices and partitions, offering a precious glimpse into the daily life of a late Qing prince. Duofu Pavilion stands nearby, its name meaning "many sons, many blessings." It was the venue for family celebrations and the reception of inner-court relatives. The interior is hung with numerous plaques and couplets celebrating fortune and longevity, lavishly yet tastefully decorated, embodying wishes for a flourishing and enduring family. The two buildings—one emphasizing self-cultivation, the other family harmony—reflect different facets of Prince Gong Yixin''s spiritual world and domestic life.<br>- **详细地址 / Address：** 北京市西城区前海西街17号恭王府东路 / Eastern Compound, Prince Gong''s Mansion, No. 17 Qianhai West Street, Xicheng District, Beijing<br>- **门票信息 / Ticket Information：** 包含在恭王府大门票内，成人40元/人 / Included in the general admission ticket, adult 40 RMB per person<br>- **开放时间 / Opening Hours：** 8:30-17:00（16:10停止检票） / 8:30-17:00 (last entry at 16:10)<br>- **交通信息 / Transportation：** 地铁6号线北海北站B口出，步行约10分钟；公交13路、42路、107路、111路、118路至厂桥路口西站 / Subway Line 6 to Beihai North Station, Exit B, walk about 10 minutes; or bus routes 13, 42, 107, 111, 118 to Changqiao Lukou Xi station</p><p>---</p>',
  '',
  10,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_mutianyu_great_wall_bj_sa_01',
  'beijing_mutianyu_great_wall',
  'great corner tower',
  '大角楼 / Great Corner Tower',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_mutianyu_great_wall_bj_sa_01.png',
  '<p>- **名字 / Name：** 大角楼 / Great Corner Tower<br>- **摘要 / Summary：** 慕田峪长城东端起点敌楼，三面城墙交汇，气势恢宏。 The watchtower at the eastern end of Mutianyu Great Wall where three wall sections converge in grandeur.<br>- **长文描述 / Description：** 大角楼是慕田峪长城东段第一座敌楼，位于海拔约600米的山脊之上，因处于长城走向的转折处，三面城墙在此交汇形成大角度转角而得名。该楼始建于明洪武年间，由徐达督建，后经谭纶、戚继光等名将主持修缮加固。大角楼为三孔连台式敌楼，形制独特，兼具瞭望、射击与屯兵多重功能。登楼远眺，东可见箭扣长城如巨龙蜿蜒于群峰之上，南可望慕田峪关城全貌，北可俯瞰山谷苍翠。作为长城防御体系中的重要节点，大角楼扼守交通要道，战略位置极为关键，是研究明代边防军事工程的珍贵实物遗存。 The Great Corner Tower is the first watchtower on the eastern section of the Mutianyu Great Wall, perched on a ridge at approximately 600 meters elevation. It earned its name because three sections of the wall converge here at a sharp angle, forming a dramatic corner. Originally constructed during the Hongwu reign of the Ming Dynasty under the supervision of General Xu Da, it was later reinforced by renowned commanders Tan Lun and Qi Jiguang. The tower features a unique three-arch connected design, serving multiple functions including lookout, defense, and troop billeting. From its summit, visitors can gaze eastward to see the Jiankou Great Wall snaking like a dragon across the peaks, southward to view the Mutianyu pass in its entirety, and northward over verdant valleys. As a critical node in the Great Wall defense system, it commanded a strategically vital position and remains a precious physical relic for the study of Ming Dynasty frontier military engineering.<br>- **详细地址 / Address：** 北京市怀柔区渤海镇慕田峪长城景区东段 / Eastern Section, Mutianyu Great Wall Scenic Area, Bohai Town, Huairou District, Beijing<br>- **门票信息 / Ticket Information：** 成人45元/人（长城门票），缆车、索道另购；学生、老人享受优惠票价 / Adult 45 RMB per person (wall entrance); cable car and chairlift sold separately; discounts available for students and seniors<br>- **开放时间 / Opening Hours：** 旺季（3月16日-11月15日）7:30-18:00；淡季（11月16日-次年3月15日）8:00-17:00 / Peak season (Mar 16-Nov 15) 7:30-18:00; off-season (Nov 16-Mar 15) 8:00-17:00<br>- **交通信息 / Transportation：** 自驾：京承高速第13号出口出，沿慕田峪方向行驶约20公里；公交：东直门乘916路快车至怀柔北大街站，换乘H23路或H24路至慕田峪长城站 / By car: Jingcheng Expressway Exit 13, drive about 20 km following signs to Mutianyu; By bus: take Express 916 from Dongzhimen to Huairou Beidajie station, then transfer to bus H23 or H24 to Mutianyu Great Wall station</p><p>---</p>',
  '',
  0,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_mutianyu_great_wall_bj_sa_02',
  'beijing_mutianyu_great_wall',
  'zhengguantai pass',
  '正关台 / Zhengguantai Pass',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_mutianyu_great_wall_bj_sa_02.jpg',
  '<p>- **名字 / Name：** 正关台 / Zhengguantai Pass<br>- **摘要 / Summary：** 慕田峪关的正关台三楼并立，为万里长城所罕见。 Three connected watchtowers standing together at the Mutianyu Pass, a rare sight along the entire Great Wall.<br>- **长文描述 / Description：** 正关台是慕田峪长城的核心关隘，由三座空心敌楼东西并排相连组成，这种三楼并列的形制在万里长城中极为罕见，是慕田峪长城最具标志性的建筑景观。正关台建于明永乐年间，底层相通，上层各有垛口，可同时容纳数百名士兵驻守。三座敌楼高低错落，中间最高，两侧稍低，远远望去如三座堡垒并峙，气势雄伟。关台两侧城墙沿山脊向东西延伸，墙体以花岗岩条石为基，青砖砌筑，高约7-8米，顶宽约4米，可五马并行、十人并进。正关台扼守山谷通道，是明代拱卫京师北大门的重要军事关隘，见证了数百年的烽火沧桑。 Zhengguantai Pass is the core fortress of the Mutianyu Great Wall, composed of three hollow watchtowers connected side by side from east to west. This three-tower arrangement is extremely rare along the entire Great Wall and represents the most iconic architectural feature of the Mutianyu section. Built during the Yongle reign of the Ming Dynasty, the towers are interconnected at the ground level while each has its own crenellated upper level, capable of simultaneously housing hundreds of soldiers. The three towers rise at staggered heights—the central one tallest, flanked by two slightly lower ones—appearing from afar as three ramparts standing together in imposing grandeur. The walls extend east and west along the ridgeline from the pass, built on granite block foundations with blue brick superstructures approximately 7-8 meters high and 4 meters wide at the top, wide enough for five horses or ten soldiers abreast. Commanding the valley passage, Zhengguantai was a vital military pass guarding the northern gateway to the imperial capital and has witnessed centuries of martial history.<br>- **详细地址 / Address：** 北京市怀柔区渤海镇慕田峪长城景区中段 / Central Section, Mutianyu Great Wall Scenic Area, Bohai Town, Huairou District, Beijing<br>- **门票信息 / Ticket Information：** 成人45元/人（长城门票），缆车、索道另购 / Adult 45 RMB per person (wall entrance); cable car and chairlift sold separately<br>- **开放时间 / Opening Hours：** 旺季（3月16日-11月15日）7:30-18:00；淡季（11月16日-次年3月15日）8:00-17:00 / Peak season (Mar 16-Nov 15) 7:30-18:00; off-season (Nov 16-Mar 15) 8:00-17:00<br>- **交通信息 / Transportation：** 自驾：京承高速第13号出口出，沿慕田峪方向行驶约20公里；公交：东直门乘916路快车至怀柔北大街站，换乘H23路或H24路至慕田峪长城站 / By car: Jingcheng Expressway Exit 13, follow signs to Mutianyu about 20 km; By bus: Express 916 from Dongzhimen to Huairou Beidajie, transfer to H23 or H24 to Mutianyu Great Wall</p><p>---</p>',
  '',
  1,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_mutianyu_great_wall_bj_sa_03',
  'beijing_mutianyu_great_wall',
  'tower no 6 and cable car station',
  '六号敌楼与缆车站 / Tower No. 6 and Cable Car Station',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_mutianyu_great_wall_bj_sa_03.png',
  '<p>- **名字 / Name：** 六号敌楼与缆车站 / Tower No. 6 and Cable Car Station<br>- **摘要 / Summary：** 缆车直达的核心敌楼区域，便捷游览与壮丽风光兼得。 A core watchtower area accessible directly by cable car, combining convenient access with spectacular views.<br>- **长文描述 / Description：** 六号敌楼是慕田峪长城中最受游客欢迎的登城点之一，因紧邻缆车上站而成为多数游客游览长城的起点。慕田峪缆车全长约700米，落差约400米，单程约4-5分钟，乘客可从山脚直达六号敌楼附近，免去了徒步登山之劳，极大提升了游览的便捷性。六号敌楼为方形空心敌楼，内部空间宽敞，拱顶结构坚固，登楼可俯瞰整段慕田峪长城蜿蜒于群山之间的壮美景象。此处也是拍摄长城全景的最佳机位之一，春日山花烂漫，夏季满目苍翠，秋来层林尽染，冬则银装素裹，四时景色各异，令人叹为观止。 Tower No. 6 is one of the most popular boarding points along the Mutianyu Great Wall, situated adjacent to the upper cable car station and serving as the starting point for most visitors'' wall exploration. The Mutianyu cable car spans approximately 700 meters with an elevation gain of about 400 meters, completing a one-way trip in just 4-5 minutes. It transports passengers from the mountain base directly to the vicinity of Tower No. 6, eliminating the strenuous hike and greatly enhancing accessibility. Tower No. 6 is a square hollow watchtower with a spacious interior and a sturdy vaulted ceiling. From its summit, visitors can survey the magnificent panorama of the entire Mutianyu Great Wall winding through the mountains. This is also one of the finest vantage points for photographing the wall—spring brings blooming wildflowers, summer clothes the slopes in vivid green, autumn paints the forests in fiery colors, and winter drapes everything in pristine white, offering breathtaking scenery in every season.<br>- **详细地址 / Address：** 北京市怀柔区渤海镇慕田峪长城景区缆车上站附近 / Near Upper Cable Car Station, Mutianyu Great Wall Scenic Area, Bohai Town, Huairou District, Beijing<br>- **门票信息 / Ticket Information：** 长城门票成人45元/人；缆车单程120元/人，往返200元/人（价格以景区公告为准） / Wall entrance adult 45 RMB; cable car one-way 120 RMB, round-trip 200 RMB (prices subject to scenic area announcements)<br>- **开放时间 / Opening Hours：** 旺季7:30-18:00；淡季8:00-17:00（缆车运营时间与景区同步，恶劣天气可能停运） / Peak season 7:30-18:00; off-season 8:00-17:00 (cable car operates during scenic area hours; may close in inclement weather)<br>- **交通信息 / Transportation：** 自驾：京承高速第13号出口出，沿慕田峪方向行驶约20公里；公交：东直门乘916路快车至怀柔北大街站，换乘H23路或H24路至慕田峪长城站 / By car: Jingcheng Expressway Exit 13, follow signs about 20 km; By bus: Express 916 from Dongzhimen to Huairou Beidajie, transfer to H23 or H24 to Mutianyu Great Wall</p><p>---</p>',
  '',
  2,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_mutianyu_great_wall_bj_sa_04',
  'beijing_mutianyu_great_wall',
  'if you are the one filming location',
  '非诚勿扰取景地 / "If You Are the One" Filming Location',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_mutianyu_great_wall_bj_sa_04.jpg',
  '<p>- **名字 / Name：** 非诚勿扰取景地 / "If You Are the One" Filming Location<br>- **摘要 / Summary：** 冯小刚电影《非诚勿扰2》取景地，长城浪漫打卡新地标。 The filming location of Feng Xiaogang''s film "If You Are the One II," a romantic new landmark on the Great Wall.<br>- **长文描述 / Description：** 慕田峪长城因电影《非诚勿扰2》（2010年，冯小刚执导）在此取景而增添了浓厚的浪漫色彩。影片中葛优与舒淇饰演的角色在长城上求婚的经典场景即拍摄于慕田峪长城第十四至十六号敌楼之间。这段城墙地势较高，视野开阔，长城沿山脊舒展如带，两侧峰峦叠嶂，景色壮美。电影上映后，此处迅速成为游客争相打卡的热门景点，尤其受到情侣和新人的青睐。景区在取景地附近设有标识牌，方便游客定位拍照。漫步在这段长城上，既能感受历史厚重，又能回味电影中的浪漫情节，是慕田峪长城将文化遗产与流行文化完美融合的独特体验。 Mutianyu Great Wall gained an added layer of romance after serving as a filming location for the movie "If You Are the One II" (2010, directed by Feng Xiaogang). The iconic scene in which the characters played by Ge You and Shu Qi have their proposal moment on the Great Wall was shot between Towers No. 14 and 16 of the Mutianyu section. This stretch of wall sits at a high elevation with an open panorama—the wall unfurls along the ridgeline like a ribbon, with layered peaks rising on both sides in magnificent splendor. After the film''s release, this spot quickly became a popular destination for visitors, especially favored by couples and newlyweds. The scenic area has placed identification markers near the filming location for easy photo positioning. Strolling along this section, visitors can simultaneously feel the weight of history and relive the romance of the film—a unique experience that beautifully merges cultural heritage with popular culture at Mutianyu.<br>- **详细地址 / Address：** 北京市怀柔区渤海镇慕田峪长城景区第14至16号敌楼之间 / Between Towers No. 14-16, Mutianyu Great Wall Scenic Area, Bohai Town, Huairou District, Beijing<br>- **门票信息 / Ticket Information：** 成人45元/人（长城门票），缆车另购 / Adult 45 RMB per person (wall entrance); cable car sold separately<br>- **开放时间 / Opening Hours：** 旺季7:30-18:00；淡季8:00-17:00 / Peak season 7:30-18:00; off-season 8:00-17:00<br>- **交通信息 / Transportation：** 自驾：京承高速第13号出口出，沿慕田峪方向行驶约20公里；公交：东直门乘916路快车至怀柔北大街站，换乘H23路或H24路至慕田峪长城站 / By car: Jingcheng Expressway Exit 13, follow signs about 20 km; By bus: Express 916 from Dongzhimen to Huairou Beidajie, transfer to H23 or H24 to Mutianyu Great Wall</p><p>---</p>',
  '',
  3,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_mutianyu_great_wall_bj_sa_05',
  'beijing_mutianyu_great_wall',
  'chairman mao stone inscription and boundary marker',
  '毛主席石刻与界碑 / Chairman Mao Stone Inscription and Boundary Marker',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_mutianyu_great_wall_bj_sa_05.png',
  '<p>- **名字 / Name：** 毛主席石刻与界碑 / Chairman Mao Stone Inscription and Boundary Marker<br>- **摘要 / Summary：** "不到长城非好汉"石刻与怀柔行政区划界碑，精神与地理双重标志。 A stone bearing Chairman Mao''s famous quote and an administrative boundary marker—a dual symbol of spirit and geography.<br>- **长文描述 / Description：** 毛主席石刻位于慕田峪长城景区内，石上镌刻着毛泽东著名词作《清平乐·六盘山》中的名句"不到长城非好汉"，笔力遒劲，气势磅礴。这句话源自1935年红军长征途中翻越六盘山时毛泽东的感怀，后成为激励无数人登临长城的经典名言。石刻前常聚集着大量游客合影留念，已成为慕田峪长城的标志性打卡点之一。附近还设有怀柔区行政区划界碑，标明此处地理位置，具有地理标识意义。界碑与石刻并立，一者标记地理坐标，一者承载精神象征，游客在此既可确认自己脚踏怀柔大地，又可感受"好汉"豪情，是长城游览中兼具人文与地理意义的特殊节点。 The Chairman Mao Stone Inscription is located within the Mutianyu Great Wall scenic area, bearing the famous line from Mao Zedong''s poem "Clean Plain Melody: Liupan Mountain"—"He who has not reached the Great Wall is not a true man"—carved in vigorous, imposing calligraphy. This quote originated from Mao''s reflections during the Red Army''s crossing of Liupan Mountain on the Long March in 1935 and has since become a classic inspiration for countless visitors to climb the Great Wall. The stone regularly draws large crowds of tourists posing for photographs and has become one of the signature photo spots at Mutianyu. Nearby stands an administrative boundary marker for Huairou District, indicating the geographical location of the site. The boundary marker and the stone inscription stand side by side—one marking geographic coordinates, the other carrying spiritual significance. Here, visitors can confirm they stand on the soil of Huairou while feeling the bold spirit of being a "true man"—a special waypoint that combines both cultural and geographical meaning along the Great Wall.<br>- **详细地址 / Address：** 北京市怀柔区渤海镇慕田峪长城景区内 / Within Mutianyu Great Wall Scenic Area, Bohai Town, Huairou District, Beijing<br>- **门票信息 / Ticket Information：** 成人45元/人（长城门票），缆车另购 / Adult 45 RMB per person (wall entrance); cable car sold separately<br>- **开放时间 / Opening Hours：** 旺季7:30-18:00；淡季8:00-17:00 / Peak season 7:30-18:00; off-season 8:00-17:00<br>- **交通信息 / Transportation：** 自驾：京承高速第13号出口出，沿慕田峪方向行驶约20公里；公交：东直门乘916路快车至怀柔北大街站，换乘H23路或H24路至慕田峪长城站 / By car: Jingcheng Expressway Exit 13, follow signs about 20 km; By bus: Express 916 from Dongzhimen to Huairou Beidajie, transfer to H23 or H24 to Mutianyu Great Wall</p><p>---</p>',
  '',
  4,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_mutianyu_great_wall_bj_sa_06',
  'beijing_mutianyu_great_wall',
  'hero slope',
  '好汉坡 / Hero Slope',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_mutianyu_great_wall_bj_sa_06.jpg',
  '<p>- **名字 / Name：** 好汉坡 / Hero Slope<br>- **摘要 / Summary：** 慕田峪长城最高点，登顶方为"好汉"，极目楚天舒。 The highest point of Mutianyu Great Wall—reach the summit and become a "true hero" with boundless vistas.<br>- **长文描述 / Description：** 好汉坡是慕田峪长城的最高点，位于第二十号敌楼附近，海拔约540米。此处山势陡峭，城墙沿山脊攀升，部分台阶坡度接近七十度，攀爬颇为费力，故以"不到长城非好汉"之意命名为"好汉坡"。登顶好汉坡需从正关台或六号敌楼出发，沿城墙拾级而上，途经多座敌楼，全程约需1-2小时。登顶后豁然开朗，群山尽收眼底，长城如巨龙翻山越岭向远方延伸，气势磅礴，蔚为壮观。此处也是观赏日出和日落的绝佳位置，晨曦初照或夕阳西下时，金色光辉洒满城墙与山峦，景色令人震撼。登临好汉坡，不仅是一次体力挑战，更是一次心灵洗礼，真正体悟"好汉"二字的豪迈与豪情。 Hero Slope is the highest point of the Mutianyu Great Wall, located near Tower No. 20 at an elevation of approximately 540 meters. The terrain here is steep, with the wall climbing along the ridgeline and some steps angled at nearly seventy degrees, making the ascent quite strenuous—hence the name "Hero Slope," inspired by the saying "He who has not reached the Great Wall is not a true man." To reach the summit, visitors set out from Zhengguantai Pass or Tower No. 6, climbing along the wall past multiple watchtowers, a journey of about one to two hours. Upon reaching the top, the vista opens dramatically—mountains stretch as far as the eye can see, and the Great Wall unfurls like a colossal dragon over the peaks into the distance in breathtaking grandeur. This is also an ideal spot for watching sunrise and sunset. When the first rays of dawn or the golden glow of dusk bathes the wall and mountains, the scenery is truly awe-inspiring. Conquering Hero Slope is not merely a physical challenge but a spiritual experience, allowing one to truly appreciate the boldness and heroism embodied in the word "hero."<br>- **详细地址 / Address：** 北京市怀柔区渤海镇慕田峪长城景区第20号敌楼附近 / Near Tower No. 20, Mutianyu Great Wall Scenic Area, Bohai Town, Huairou District, Beijing<br>- **门票信息 / Ticket Information：** 成人45元/人（长城门票），缆车另购；登顶好汉坡需步行，无额外费用 / Adult 45 RMB per person (wall entrance); cable car sold separately; reaching Hero Slope requires walking with no additional fee<br>- **开放时间 / Opening Hours：** 旺季7:30-18:00；淡季8:00-17:00（建议上午登顶，预留充足返程时间） / Peak season 7:30-18:00; off-season 8:00-17:00 (morning ascent recommended, allow sufficient time for return)<br>- **交通信息 / Transportation：** 自驾：京承高速第13号出口出，沿慕田峪方向行驶约20公里；公交：东直门乘916路快车至怀柔北大街站，换乘H23路或H24路至慕田峪长城站 / By car: Jingcheng Expressway Exit 13, follow signs about 20 km; By bus: Express 916 from Dongzhimen to Huairou Beidajie, transfer to H23 or H24 to Mutianyu Great Wall</p><p>---</p>',
  '',
  5,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_forbidden_city_bj_sa_01',
  'beijing_forbidden_city',
  'meridian gate and golden water bridge',
  '午门与金水桥 / Meridian Gate and Golden Water Bridge',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_forbidden_city_bj_sa_01.jpg',
  '<p>- **名字 / Name：** 午门与金水桥 / Meridian Gate and Golden Water Bridge<br>- **摘要 / Summary：** 故宫的正南门，明清两代皇帝举行重大典礼的出入口，以"明三暗五"的门洞形制和门前蜿蜒如弓的金水河而著称。 The main southern entrance of the Forbidden City, where grand imperial ceremonies were held, famed for its "three visible, five concealed" gateway design and the meandering Golden Water River shaped like a bow.<br>- **长文描述 / Description：** 午门是故宫四座城门中等级最高者，也是紫禁城的正南门户。城台之上建有五座崇楼，高低错落、翼角飞翘，形如凤鸟展翅，故又称"五凤楼"。午门共有五个门洞，中门为皇帝御道，两侧门供宗室王公与文武百官出入，东西掖门则用于日常通行。午门前方的金水河蜿蜒如弓，五座汉白玉金水桥横跨其上，象征"仁义礼智信"五德。明清两代，每岁颁发时宪书、大军凯旋献俘等重大典礼皆在此举行。午门北面两侧的阙门与城墙构成气势恢宏的"凹"字形平面，令每一位步入者顿生敬畏之心。 The Meridian Gate is the highest-ranking of the Forbidden City''s four gates and the principal southern portal. Five pavilions crown the gate tower, their layered heights and upturned eaves resembling a phoenix in flight, hence the name "Five-Phoenix Tower." The gate contains five passageways: the central portal reserved for the emperor, the lateral ones for princes and officials, and the side doors for daily traffic. In front, the Golden Water River curves like a drawn bow, spanned by five white marble bridges symbolizing the five Confucian virtues — benevolence, righteousness, propriety, wisdom, and trustworthiness. During the Ming and Qing dynasties, ceremonies such as the annual issuance of the imperial calendar and the presentation of war captives were staged here. The recessed U-shaped plan formed by the flanking gates and walls imparts a profound sense of awe to every visitor entering this threshold.<br>- **详细地址 / Address：** 北京市东城区景山前街4号故宫正南门 / No. 4 Jingshan Front Street, Dongcheng District, Beijing — the southern entrance of the Forbidden City<br>- **门票信息 / Ticket Information：** 旺季（4月1日—10月31日）60元/人，淡季（11月1日—次年3月31日）40元/人；珍宝馆、钟表馆各10元另购；需通过故宫博物院官网或微信公众号提前在线预约，凭身份证或护照入场。 / Peak season (Apr 1–Oct 31): CNY 60/person; off-season (Nov 1–Mar 31): CNY 40/person. The Treasure Gallery and Clock Gallery each require an additional CNY 10 ticket. All visitors must book online in advance via the Palace Museum''s official website or WeChat mini-program, and present a valid ID or passport for entry.<br>- **开放时间 / Opening Hours：** 旺季（4月1日—10月31日）8:30—17:00（16:10停止入馆）；淡季（11月1日—次年3月31日）8:30—16:30（15:40停止入馆）；周一闭馆（法定节假日除外）。 / Peak season (Apr 1–Oct 31): 8:30 AM–5:00 PM (last entry at 4:10 PM); off-season (Nov 1–Mar 31): 8:30 AM–4:30 PM (last entry at 3:40 PM). Closed on Mondays (except public holidays).<br>- **交通信息 / Transportation：** 乘坐北京地铁1号线至天安门东站或天安门西站，出站后经天安门城楼向北步行约500米即达午门入口；或乘坐地铁2号线至前门站，经天安门广场向北步行约10分钟。建议从天安门方向进入午门，感受皇家礼仪的完整序列。 / Take Beijing Subway Line 1 to Tian''anmen East or Tian''anmen West Station, then walk north through Tian''anmen Gate for approximately 500 meters to reach the Meridian Gate entrance. Alternatively, take Line 2 to Qianmen Station and walk north through Tian''anmen Square (about 10 minutes). Entering via Tian''anmen is recommended to experience the full ceremonial sequence of the imperial approach.</p><p>---</p>',
  '',
  0,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_forbidden_city_bj_sa_02',
  'beijing_forbidden_city',
  'gate of supreme harmony and east west wings of outer court',
  '太和门与外朝东西路 / Gate of Supreme Harmony and East-West Wings of Outer Court',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_forbidden_city_bj_sa_02.png',
  '<p>- **名字 / Name：** 太和门与外朝东西路 / Gate of Supreme Harmony and East-West Wings of Outer Court<br>- **摘要 / Summary：** 进入午门后的第一重宏伟殿门，明代皇帝曾在此"御门听政"，两侧东西朝房分别为武英殿与文华殿所在的外朝东西路。 The first grand gate hall after the Meridian Gate, where Ming emperors once held "gate-side court audiences," flanked by the east and west wings housing the Hall of Martial Valor and the Hall of Literary Glory.<br>- **长文描述 / Description：** 太和门是外朝三大殿的正门，面阔九间、进深四间，重檐歇山顶，建筑面积1300余平方米，是故宫等级最高、体量最大的宫门，堪称"宫门之王"。明代皇帝于此御门听政，清晨受百官朝拜，处理国家大政。门前开阔广场上陈设着一对明铸青铜巨狮，东为雄狮脚踏绣球，西为雌狮抚弄幼狮，象征皇权威仪与子嗣绵延。太和门东西两侧的外朝辅路分别为武英殿与文华殿所在——武英殿曾为皇帝便殿及修书之所，文华殿则是明清两代经筵讲学之处。广场中轴线两侧的庑廊与朝房，昔日为各部院衙门办公之处，共同构成了中国最大木结构宫殿院落的序章。 The Gate of Supreme Harmony is the main entrance to the Three Great Halls of the Outer Court. Measuring nine bays wide and four bays deep, with a double-eaved hip roof, it spans over 1,300 square meters — the highest-ranking and largest palace gate in the Forbidden City, truly the "king of gates." Here Ming emperors held "gate-side audiences" at dawn, receiving officials and deliberating state affairs. In the square before the gate stand a pair of Ming-dynasty bronze lions: the male to the east with a paw resting on an embroidered ball, the female to the west caressing a cub — symbols of imperial majesty and dynastic continuity. Flanking the gate, the West Wing houses the Hall of Martial Valor (Wuying Dian), formerly an imperial study and book-compilation hall, while the East Wing contains the Hall of Literary Glory (Wenhua Dian), venue for imperial classical lectures. The colonnaded corridors and side halls lining the central axis once served as offices for the various ministries, forming the grand prelude to China''s largest wooden palatial complex.<br>- **详细地址 / Address：** 北京市东城区景山前街4号故宫博物院内，进入午门后即达 / Within the Palace Museum at No. 4 Jingshan Front Street, Dongcheng District, Beijing — immediately past the Meridian Gate<br>- **门票信息 / Ticket Information：** 旺季（4月1日—10月31日）60元/人，淡季（11月1日—次年3月31日）40元/人；珍宝馆、钟表馆各10元另购；需通过故宫博物院官网或微信公众号提前在线预约，凭身份证或护照入场。 / Peak season (Apr 1–Oct 31): CNY 60/person; off-season (Nov 1–Mar 31): CNY 40/person. The Treasure Gallery and Clock Gallery each require an additional CNY 10 ticket. All visitors must book online in advance via the Palace Museum''s official website or WeChat mini-program, and present a valid ID or passport for entry.<br>- **开放时间 / Opening Hours：** 旺季（4月1日—10月31日）8:30—17:00（16:10停止入馆）；淡季（11月1日—次年3月31日）8:30—16:30（15:40停止入馆）；周一闭馆（法定节假日除外）。 / Peak season (Apr 1–Oct 31): 8:30 AM–5:00 PM (last entry at 4:10 PM); off-season (Nov 1–Mar 31): 8:30 AM–4:30 PM (last entry at 3:40 PM). Closed on Mondays (except public holidays).<br>- **交通信息 / Transportation：** 进入午门后直行即达太和门广场，位于故宫中轴线南段，距午门约200米。武英殿位于太和门西侧，文华殿位于东侧，可沿中路参观后分往东西路探访。 / From the Meridian Gate, walk directly north for about 200 meters along the central axis to reach the Gate of Supreme Harmony square. The Hall of Martial Valor lies to the west, the Hall of Literary Glory to the east — both accessible by branching off from the central route.</p><p>---</p>',
  '',
  1,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_forbidden_city_bj_sa_03',
  'beijing_forbidden_city',
  'hall of supreme harmony',
  '太和殿 / Hall of Supreme Harmony',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_forbidden_city_bj_sa_03.png',
  '<p>- **名字 / Name：** 太和殿 / Hall of Supreme Harmony<br>- **摘要 / Summary：** 故宫至高无上的核心建筑，俗称金銮殿，中国现存最大的木结构宫殿，明清两代皇帝举行登基、大婚、万寿等重大典礼的场所。 The paramount edifice of the Forbidden City, commonly known as the Throne Hall — the largest surviving wooden palace in China, where emperors of the Ming and Qing dynasties held enthronements, grand weddings, and birthday celebrations.<br>- **长文描述 / Description：** 太和殿位于三层汉白玉须弥座台基之上，通高35.05米，面阔十一间，进深五间，重檐庑殿顶，黄色琉璃瓦、金龙和玺彩画，为故宫建筑等级之最。殿内七十二根巨大楠木立柱支撑全檐，正中设七阶金漆雕龙宝座，上悬"建极绥猷"匾额为乾隆帝御笔。宝座前陈设宝象、甪端、仙鹤、香亭等祥瑞之物，象征江山永固、天下太平。殿前月台上置有日晷与嘉量，代表皇权掌握时间与度量。太和殿广场可容纳十万人朝贺，每逢元旦、冬至、万寿三大节及皇帝登基、大婚之日，钟鼓齐鸣、仪仗森列，尽展"天子之威"。殿内的金砖墁地与盘龙藻井，更令这座木构巨构彰显出无可比拟的皇家气度。 The Hall of Supreme Harmony rises from a three-tiered white marble terrace, reaching a total height of 35.05 meters. Measuring eleven bays wide and five bays deep, its double-eaved hip roof with yellow glazed tiles and golden dragon painted decoration marks the highest architectural rank in the entire complex. Seventy-two massive nanmu columns support the sweeping roof; at the center, a seven-tier gilded throne platform bears a carved dragon throne, beneath a plaque reading "Jian Ji Sui You" (Establish the Ultimate and Follow the Way) in the Qianlong Emperor''s own calligraphy. Before the throne stand auspicious ornaments — treasure elephants, luduan mythical beasts, cranes, and incense pavilions — symbolizing eternal sovereignty and universal peace. The terrace features a sundial and a grain measure, signifying imperial mastery over time and standards. The vast square before the hall could accommodate 100,000 courtiers for grand audiences. On New Year''s Day, the winter solstice, the emperor''s birthday, and at enthronement and wedding ceremonies, bells and drums resounded amid resplendent honor guards, fully manifesting the majesty of the Son of Heaven.<br>- **详细地址 / Address：** 北京市东城区景山前街4号故宫博物院内，位于前朝中路 / Within the Palace Museum at No. 4 Jingshan Front Street, Dongcheng District, Beijing — situated in the middle of the Outer Court<br>- **门票信息 / Ticket Information：** 旺季（4月1日—10月31日）60元/人，淡季（11月1日—次年3月31日）40元/人；珍宝馆、钟表馆各10元另购；需通过故宫博物院官网或微信公众号提前在线预约，凭身份证或护照入场。 / Peak season (Apr 1–Oct 31): CNY 60/person; off-season (Nov 1–Mar 31): CNY 40/person. The Treasure Gallery and Clock Gallery each require an additional CNY 10 ticket. All visitors must book online in advance via the Palace Museum''s official website or WeChat mini-program, and present a valid ID or passport for entry.<br>- **开放时间 / Opening Hours：** 旺季（4月1日—10月31日）8:30—17:00（16:10停止入馆）；淡季（11月1日—次年3月31日）8:30—16:30（15:40停止入馆）；周一闭馆（法定节假日除外）。 / Peak season (Apr 1–Oct 31): 8:30 AM–5:00 PM (last entry at 4:10 PM); off-season (Nov 1–Mar 31): 8:30 AM–4:30 PM (last entry at 3:40 PM). Closed on Mondays (except public holidays).<br>- **交通信息 / Transportation：** 从午门沿中轴线向北约400米，穿过太和门即至太和殿广场。太和殿为故宫中轴线参观的绝对核心，建议在此停留较长时间细细品味。 / Walk approximately 400 meters north from the Meridian Gate along the central axis, passing through the Gate of Supreme Harmony to reach the Hall of Supreme Harmony square. As the absolute centerpiece of any Forbidden City tour, plan to spend extra time here to absorb the full grandeur.</p><p>---</p>',
  '',
  2,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_forbidden_city_bj_sa_04',
  'beijing_forbidden_city',
  'hall of central harmony and hall of preserving harmony',
  '中和殿与保和殿 / Hall of Central Harmony and Hall of Preserving Harmony',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_forbidden_city_bj_sa_04.jpg',
  '<p>- **名字 / Name：** 中和殿与保和殿 / Hall of Central Harmony and Hall of Preserving Harmony<br>- **摘要 / Summary：** 位于太和殿之后的两座重要殿堂——中和殿为皇帝大典前休憩整装之所，保和殿则为皇帝赐宴外藩与殿试进士之处，共同构成外朝三大殿的完整序列。 Two important halls behind the Hall of Supreme Harmony — the Hall of Central Harmony where the emperor paused before grand rituals, and the Hall of Preserving Harmony for state banquets and the Palace Examination, together completing the triad of the Three Great Halls of the Outer Court.<br>- **长文描述 / Description：** 中和殿坐落于太和殿与保和殿之间，平面呈正方形，面阔进深各三间，单檐攒尖鎏金宝顶，是三大殿中体量最小而形制最为精巧的一座。皇帝在太和殿举行大典前，先至此殿暂歇，翻阅祝文、审阅仪程；亦在此接受执事官员的行礼。殿内陈设简朴雅致，悬有乾隆御笔"允执厥中"匾额，道出中庸之道的治国哲学。<br>&gt;<br>&gt; 保和殿位于中和殿之北，面阔九间、进深五间，重檐歇山顶，规模仅次于太和殿。明代皇帝在册立皇后、皇太子时亦在此更衣受贺。清代自乾隆五十四年（1789年）起，将科举最高等级的殿试改设于此，万千士子的命运曾在这座大殿中定格。殿前巨大的云龙石雕长16.57米、宽3.07米、重约250吨，为故宫最大的一块石雕，九条蟠龙于云水之间翻腾飞舞，气势磅礴。 The Hall of Central Harmony, positioned between the other two halls, is square in plan — three bays wide and deep — with a single-eaved pyramidal roof topped by a gilded finial. It is the smallest yet most refined of the three halls. Before grand ceremonies at the Hall of Supreme Harmony, the emperor would rest here, reviewing prayers and protocols, and receiving the respects of ritual officials. Its interior, simple yet elegant, bears the Qianlong Emperor''s inscription "Yun Zhi Jue Zhong" (Hold Fast to the Mean) — a statement of governance through the Doctrine of the Mean.<br>&gt;<br>&gt; The Hall of Preserving Harmony lies to the north, nine bays wide and five bays deep, with a double-eaved hip roof — second only to the Hall of Supreme Harmony in scale. Ming emperors changed robes here before ceremonies honoring empresses and crown princes. Starting in 1789, the Qing dynasty moved the Palace Examination, the highest level of the imperial civil service exam, to this hall, where the fates of countless scholars were decided. Before the hall lies the Forbidden City''s largest stone carving — a 16.57-meter-long, 3.07-meter-wide cloud-dragon marble slab weighing approximately 250 tons, depicting nine coiling dragons soaring through clouds and waves.<br>- **详细地址 / Address：** 北京市东城区景山前街4号故宫博物院内，太和殿正北 / Within the Palace Museum at No. 4 Jingshan Front Street, Dongcheng District, Beijing — directly north of the Hall of Supreme Harmony<br>- **门票信息 / Ticket Information：** 旺季（4月1日—10月31日）60元/人，淡季（11月1日—次年3月31日）40元/人；珍宝馆、钟表馆各10元另购；需通过故宫博物院官网或微信公众号提前在线预约，凭身份证或护照入场。 / Peak season (Apr 1–Oct 31): CNY 60/person; off-season (Nov 1–Mar 31): CNY 40/person. The Treasure Gallery and Clock Gallery each require an additional CNY 10 ticket. All visitors must book online in advance via the Palace Museum''s official website or WeChat mini-program, and present a valid ID or passport for entry.<br>- **开放时间 / Opening Hours：** 旺季（4月1日—10月31日）8:30—17:00（16:10停止入馆）；淡季（11月1日—次年3月31日）8:30—16:30（15:40停止入馆）；周一闭馆（法定节假日除外）。 / Peak season (Apr 1–Oct 31): 8:30 AM–5:00 PM (last entry at 4:10 PM); off-season (Nov 1–Mar 31): 8:30 AM–4:30 PM (last entry at 3:40 PM). Closed on Mondays (except public holidays).<br>- **交通信息 / Transportation：** 从太和殿继续向北步行，中和殿与保和殿依次排布于三层汉白玉台基之上，三殿相距极近，可在同一区域连续参观。 / From the Hall of Supreme Harmony, continue walking north — the Hall of Central Harmony and Hall of Preserving Harmony are arranged in sequence atop the same three-tiered marble terrace. All three halls are in close proximity and can be visited consecutively.</p><p>---</p>',
  '',
  3,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_forbidden_city_bj_sa_05',
  'beijing_forbidden_city',
  'three rear palaces palace of heavenly purity hall of union and palace of earthly tranquility',
  '后三宫·乾清宫、交泰殿与坤宁宫 / Three Rear Palaces: Palace of Heavenly Purity, Hall of Union, and Palace of Earthly Tranquility',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_forbidden_city_bj_sa_05.jpg',
  '<p>- **名字 / Name：** 后三宫·乾清宫、交泰殿与坤宁宫 / Three Rear Palaces: Palace of Heavenly Purity, Hall of Union, and Palace of Earthly Tranquility<br>- **摘要 / Summary：** 故宫内廷的核心建筑群，乾清宫为皇帝正寝，交泰殿为皇后礼制之所，坤宁宫为皇后正寝与萨满祭祀之地，共同构成"前朝后寝"的完整格局。 The core architectural group of the Inner Court — the Palace of Heavenly Purity served as the emperor''s principal bedchamber, the Hall of Union as the empress''s ceremonial hall, and the Palace of Earthly Tranquility as the empress''s bedchamber and shamanic ritual site, together forming the "front court, rear bedchamber" layout.<br>- **长文描述 / Description：** 乾清宫是后三宫之首，面阔九间、进深五间，重檐庑殿顶，形制仅次于太和殿。自明永乐至清康熙，乾清宫皆为皇帝寝宫。殿内正中悬有顺治帝御笔"正大光明"匾，其后的秘密立储匣曾决定了大清皇位的传递。殿前露台上陈设有铜龟铜鹤与日晷嘉量，与太和殿遥相呼应。穿乾清宫而北即为交泰殿，方形单檐，内悬"无为"匾额，殿中二十五方御玺一字排开，象征着皇权的至高无上。最北端的坤宁宫面阔九间，明代为皇后寝宫，清代将其东侧改为皇帝大婚的洞房，西侧则辟为萨满祭祀场所，将满族传统宗教信仰融入汉式宫廷建筑之中，其独特的复合功能在故宫中绝无仅有。 The Palace of Heavenly Purity, the foremost of the Three Rear Palaces, measures nine bays wide and five bays deep with a double-eaved hip roof — a rank second only to the Hall of Supreme Harmony. From the Yongle reign of the Ming to the Kangxi reign of the Qing, it served as the emperor''s private quarters. Above the central throne hangs the Shunzhi Emperor''s calligraphy "Zheng Da Guang Ming" (Open and Aboveboard), behind which secret succession edicts were once stored, determining the imperial line. Bronze tortoises, cranes, a sundial, and a grain measure stand on the front terrace, echoing those at the Hall of Supreme Harmony. Passing northward through the palace, one arrives at the Hall of Union — a square, single-eaved building housing the plaque "Wu Wei" (Effortless Governance) and twenty-five imperial seals displayed in a row, embodying supreme sovereignty. At the northernmost end, the Palace of Earthly Tranquility, nine bays wide, was the Ming empress''s bedchamber. In the Qing dynasty, its eastern half was converted into the imperial wedding chamber, while the western half became a shamanic ritual hall — a unique fusion of Manchu religious tradition with Han palatial architecture, unmatched anywhere in the Forbidden City.<br>- **详细地址 / Address：** 北京市东城区景山前街4号故宫博物院内廷中路 / Within the Palace Museum at No. 4 Jingshan Front Street, Dongcheng District, Beijing — along the central axis of the Inner Court<br>- **门票信息 / Ticket Information：** 旺季（4月1日—10月31日）60元/人，淡季（11月1日—次年3月31日）40元/人；珍宝馆、钟表馆各10元另购；需通过故宫博物院官网或微信公众号提前在线预约，凭身份证或护照入场。 / Peak season (Apr 1–Oct 31): CNY 60/person; off-season (Nov 1–Mar 31): CNY 40/person. The Treasure Gallery and Clock Gallery each require an additional CNY 10 ticket. All visitors must book online in advance via the Palace Museum''s official website or WeChat mini-program, and present a valid ID or passport for entry.<br>- **开放时间 / Opening Hours：** 旺季（4月1日—10月31日）8:30—17:00（16:10停止入馆）；淡季（11月1日—次年3月31日）8:30—16:30（15:40停止入馆）；周一闭馆（法定节假日除外）。 / Peak season (Apr 1–Oct 31): 8:30 AM–5:00 PM (last entry at 4:10 PM); off-season (Nov 1–Mar 31): 8:30 AM–4:30 PM (last entry at 3:40 PM). Closed on Mondays (except public holidays).<br>- **交通信息 / Transportation：** 从保和殿向北穿过乾清门即进入内廷区域，后三宫沿中轴线依次排列，步行约5分钟可遍览三殿。此处为故宫中轴线参观的精华段落，建议预留充足时间。 / From the Hall of Preserving Harmony, pass through the Gate of Heavenly Purity to enter the Inner Court. The Three Rear Palaces are aligned along the central axis and can be covered on foot in about five minutes. This section is the highlight of the central-axis route — allow ample time for exploration.</p><p>---</p>',
  '',
  4,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_forbidden_city_bj_sa_06',
  'beijing_forbidden_city',
  'hall of mental cultivation and grand council',
  '养心殿与军机处 / Hall of Mental Cultivation and Grand Council',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_forbidden_city_bj_sa_06.png',
  '<p>- **名字 / Name：** 养心殿与军机处 / Hall of Mental Cultivation and Grand Council<br>- **摘要 / Summary：** 清雍正帝以后历代皇帝的日常政务中心与寝宫，"垂帘听政"的历史即发生于此；其南侧的军机处为清代最高军国政务决策机构。 The daily governance hub and bedchamber of Qing emperors from Yongzheng onward, where the "governance behind the curtain" took place; the adjacent Grand Council served as the empire''s supreme military and political decision-making body.<br>- **长文描述 / Description：** 养心殿位于乾清宫西侧，自雍正七年（1729年）起取代乾清宫成为皇帝日常起居与处理政务的实际中心。殿宇呈"工"字形平面，前殿为召见大臣、批阅奏折的政务区，后殿为皇帝寝宫，前后由穿堂相连。前殿正中设宝座，东西暖阁分别用于机密议事与休憩，最著名的东暖阁即为同治、光绪年间慈禧太后与慈安太后"垂帘听政"之所——一道黄纱帘后，两位太后曾在此操纵晚清政权近半个世纪。殿内悬挂雍正御笔"中正仁和"匾额，陈设精致而不失庄重。养心殿南侧的军机处是雍正帝为快速处理西北军务而设立，后演变为整个清帝国的最高决策机构，一纸诏令便可调动千军万马，深刻影响了中国近代历史的走向。 The Hall of Mental Cultivation, situated west of the Palace of Heavenly Purity, became the de facto center of daily governance and imperial residence from 1729. Its I-shaped layout comprises a front hall for audiences and document review, a rear bedchamber, and a connecting corridor. The front hall, with a throne at its center, features east and west warming chambers for confidential deliberations and rest. Most famously, the East Warm Chamber was the site of "governance behind the curtain" — from behind a gauze screen, Empress Dowagers Cixi and Ci''an controlled the late Qing empire for nearly half a century during the Tongzhi and Guangxu reigns. The hall bears the Yongzheng Emperor''s inscription "Zhong Zheng Ren He" (Justice, Uprightness, Benevolence, and Harmony). To the south of the hall lies the Grand Council, originally established by Yongzheng for swift handling of northwestern military affairs and later evolved into the Qing empire''s supreme decision-making body. A single edict from this modest office could marshal entire armies, profoundly shaping the course of modern Chinese history.<br>- **详细地址 / Address：** 北京市东城区景山前街4号故宫博物院内，乾清宫西侧 / Within the Palace Museum at No. 4 Jingshan Front Street, Dongcheng District, Beijing — west of the Palace of Heavenly Purity<br>- **门票信息 / Ticket Information：** 旺季（4月1日—10月31日）60元/人，淡季（11月1日—次年3月31日）40元/人；珍宝馆、钟表馆各10元另购；需通过故宫博物院官网或微信公众号提前在线预约，凭身份证或护照入场。 / Peak season (Apr 1–Oct 31): CNY 60/person; off-season (Nov 1–Mar 31): CNY 40/person. The Treasure Gallery and Clock Gallery each require an additional CNY 10 ticket. All visitors must book online in advance via the Palace Museum''s official website or WeChat mini-program, and present a valid ID or passport for entry.<br>- **开放时间 / Opening Hours：** 旺季（4月1日—10月31日）8:30—17:00（16:10停止入馆）；淡季（11月1日—次年3月31日）8:30—16:30（15:40停止入馆）；周一闭馆（法定节假日除外）。 / Peak season (Apr 1–Oct 31): 8:30 AM–5:00 PM (last entry at 4:10 PM); off-season (Nov 1–Mar 31): 8:30 AM–4:30 PM (last entry at 3:40 PM). Closed on Mondays (except public holidays).<br>- **交通信息 / Transportation：** 从乾清宫向西步行约100米即达养心殿，位于内廷西路，军机处位于养心殿南侧。此区域为故宫西线参观的重要节点。 / Walk about 100 meters west from the Palace of Heavenly Purity to reach the Hall of Mental Cultivation, located in the western Inner Court. The Grand Council lies immediately to the south. This area is a key stop on the Forbidden City''s western route.</p><p>---</p>',
  '',
  5,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_forbidden_city_bj_sa_07',
  'beijing_forbidden_city',
  'six eastern and western palaces',
  '东西六宫 / Six Eastern and Western Palaces',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_forbidden_city_bj_sa_07.png',
  '<p>- **名字 / Name：** 东西六宫 / Six Eastern and Western Palaces<br>- **摘要 / Summary：** 后三宫两侧各六座宫院的统称，为明清两代后妃、皇子及太后起居之所，每座院落自成一格，见证着紫禁城中无数深宫故事。 The collective name for the twelve palace compounds flanking the Three Rear Palaces — living quarters for empresses, consorts, princes, and dowagers of the Ming and Qing, each courtyard a world unto itself, witness to countless stories within the deep palace walls.<br>- **长文描述 / Description：** 东西六宫分列后三宫东西两侧，各有六座独立院落，按"东六宫"与"西六宫"布局。东六宫包括景仁宫、承乾宫、钟粹宫、延禧宫、永和宫与景阳宫，西六宫包括永寿宫、翊坤宫、储秀宫、咸福宫、长春宫与启祥宫（太极殿），象征十二地支、十二时辰的宇宙秩序。每座宫院均为两进或三进式四合院格局，正殿、配殿、耳房、游廊与宫门构成各自独立又彼此呼应的生活空间。其中储秀宫以慈禧太后早年居住而闻名，承乾宫为顺治帝宠妃董鄂氏所居，延禧宫在清末改建为西洋式"水晶宫"而未竟。今日部分宫院辟为专题陈列馆，青铜器、陶瓷、玉器等文物在此静静诉说千年工艺之美；另一些院落则保持着皇家日常生活原状陈列，让参观者得以一窥后宫深处的真实面貌。 The Six Eastern and Six Western Palaces, arrayed on either side of the Three Rear Palaces, represent the twelve terrestrial branches and twelve double-hours of the cosmic order in Chinese cosmology. The eastern group encompasses Jingren, Chengqian, Zhongcui, Yanxi, Yonghe, and Jingyang Palaces; the western group includes Yongshou, Yikun, Chuxiu, Xianfu, Changchun, and Qixiang (Taiji) Palaces. Each is a two- or three-courtyard siheyuan compound, its main hall, side halls, annexes, covered corridors, and gate forming a self-contained yet interconnected living space. Among them, Chuxiu Palace is famed as the early residence of Empress Dowager Cixi; Chengqian Palace housed Consort Donggo, beloved of the Shunzhi Emperor; Yanxi Palace saw an unfinished attempt at Western-style reconstruction in the late Qing. Today, some compounds function as themed galleries displaying bronzes, ceramics, and jades that quietly speak of millennia of craftsmanship; others preserve original furnishings depicting daily life in the imperial household, offering visitors a rare glimpse into the authentic world behind the vermilion walls.<br>- **详细地址 / Address：** 北京市东城区景山前街4号故宫博物院内廷区域 / Within the Palace Museum at No. 4 Jingshan Front Street, Dongcheng District, Beijing — throughout the Inner Court area<br>- **门票信息 / Ticket Information：** 旺季（4月1日—10月31日）60元/人，淡季（11月1日—次年3月31日）40元/人；珍宝馆、钟表馆各10元另购；需通过故宫博物院官网或微信公众号提前在线预约，凭身份证或护照入场。 / Peak season (Apr 1–Oct 31): CNY 60/person; off-season (Nov 1–Mar 31): CNY 40/person. The Treasure Gallery and Clock Gallery each require an additional CNY 10 ticket. All visitors must book online in advance via the Palace Museum''s official website or WeChat mini-program, and present a valid ID or passport for entry.<br>- **开放时间 / Opening Hours：** 旺季（4月1日—10月31日）8:30—17:00（16:10停止入馆）；淡季（11月1日—次年3月31日）8:30—16:30（15:40停止入馆）；周一闭馆（法定节假日除外）。 / Peak season (Apr 1–Oct 31): 8:30 AM–5:00 PM (last entry at 4:10 PM); off-season (Nov 1–Mar 31): 8:30 AM–4:30 PM (last entry at 3:40 PM). Closed on Mondays (except public holidays).<br>- **交通信息 / Transportation：** 东西六宫分布于后三宫两侧，从乾清宫向东或向西步行即可进入。东六宫区域紧邻珍宝馆和钟表馆（奉先殿），可一并游览；西六宫靠近养心殿与慈宁宫，建议按区域集中参观以免遗漏。 / The Six Eastern and Western Palaces flank the Three Rear Palaces — accessible by walking east or west from the Palace of Heavenly Purity. The eastern group is adjacent to the Treasure Gallery and Clock Gallery (Hall of Ancestral Worship), ideal for a combined visit; the western group lies near the Hall of Mental Cultivation and the Palace of Compassion and Tranquility. Visit by zone to avoid missing any courtyard.</p><p>---</p>',
  '',
  6,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_forbidden_city_bj_sa_08',
  'beijing_forbidden_city',
  'palace of compassion and tranquility sculpture gallery',
  '慈宁宫·雕塑馆 / Palace of Compassion and Tranquility - Sculpture Gallery',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_forbidden_city_bj_sa_08.png',
  '<p>- **名字 / Name：** 慈宁宫·雕塑馆 / Palace of Compassion and Tranquility - Sculpture Gallery<br>- **摘要 / Summary：** 明清两代皇太后及前朝太妃颐养天年之正宫，现辟为故宫雕塑馆，陈列自秦汉至明清的石刻、陶俑与佛教造像精品。 The principal palace for retired empress dowagers and consorts of the Ming and Qing dynasties, now transformed into the Palace Museum''s Sculpture Gallery, displaying exquisite stone carvings, pottery figurines, and Buddhist statuary from the Qin-Han era through the Ming-Qing period.<br>- **长文描述 / Description：** 慈宁宫位于故宫西路隆宗门之西，始建于明嘉靖十五年（1536年），是专为皇太后和先朝嫔妃修建的养老居所，堪称故宫中地位最高的"女眷宫"。孝庄文皇后（清顺治帝生母）晚年即长居于此，康熙帝每年在此为祖母举行盛大寿宴，母子情深、天下称颂。慈宁宫前有东西两座宫门，正殿面阔七间、重檐歇山顶，院内古柏森森，气氛庄重沉静。2015年起，慈宁宫东侧的大佛堂及周边殿堂被改造为故宫雕塑馆，展出从秦兵马俑到明清佛造像的400余件珍贵雕塑文物。庭院中矗立的巨型石雕与展室内的陶俑、石刻、铜佛像依年代排列，形成一部立体的中国雕塑艺术通史。慈宁宫花园则保留着清代园林的原貌，古亭与花木相映，是故宫内最为静谧的休憩之所。 The Palace of Compassion and Tranquility, built in 1536 west of Longzong Gate on the western route, was purpose-built as a retirement residence for empress dowagers and former consorts, the highest-ranking "women''s palace" in the Forbidden City. Empress Dowager Xiaozhuang, mother of the Shunzhi Emperor, spent her later years here, and Emperor Kangxi would hold grand birthday banquets for his grandmother in this very palace — a display of filial devotion celebrated throughout the realm. The palace features east and west gates, a seven-bay main hall with a double-eaved hip roof, and an ancient cypress-filled courtyard of solemn tranquility. Since 2015, the Great Buddha Hall and surrounding buildings to the east have been transformed into the Palace Museum Sculpture Gallery, showcasing over 400 precious sculptural artifacts ranging from Qin-dynasty terracotta warriors to Ming and Qing Buddhist statues. Monumental stone carvings stand in the courtyards, while pottery figurines, stone reliefs, and bronze Buddhist images line the exhibition halls chronologically, forming a three-dimensional history of Chinese sculpture. The adjacent Cining Garden preserves its original Qing landscaping, where ancient pavilions and flowering trees create the most serene retreat within the Forbidden City.<br>- **详细地址 / Address：** 北京市东城区景山前街4号故宫博物院内西路隆宗门西侧 / Within the Palace Museum at No. 4 Jingshan Front Street, Dongcheng District, Beijing — west of Longzong Gate on the western route<br>- **门票信息 / Ticket Information：** 旺季（4月1日—10月31日）60元/人，淡季（11月1日—次年3月31日）40元/人；珍宝馆、钟表馆各10元另购；需通过故宫博物院官网或微信公众号提前在线预约，凭身份证或护照入场。 / Peak season (Apr 1–Oct 31): CNY 60/person; off-season (Nov 1–Mar 31): CNY 40/person. The Treasure Gallery and Clock Gallery each require an additional CNY 10 ticket. All visitors must book online in advance via the Palace Museum''s official website or WeChat mini-program, and present a valid ID or passport for entry.<br>- **开放时间 / Opening Hours：** 旺季（4月1日—10月31日）8:30—17:00（16:10停止入馆）；淡季（11月1日—次年3月31日）8:30—16:30（15:40停止入馆）；周一闭馆（法定节假日除外）。 / Peak season (Apr 1–Oct 31): 8:30 AM–5:00 PM (last entry at 4:10 PM); off-season (Nov 1–Mar 31): 8:30 AM–4:30 PM (last entry at 3:40 PM). Closed on Mondays (except public holidays).<br>- **交通信息 / Transportation：** 从乾清宫向西经隆宗门即达慈宁宫区域，距养心殿约300米。慈宁宫位于故宫西线纵深，适合在参观西六宫后继续西行探访，其花园安静少扰，是中途休憩的理想之处。 / Proceed west from the Palace of Heavenly Purity through Longzong Gate to reach the Cining Palace area, about 300 meters from the Hall of Mental Cultivation. Located deep in the western zone, it is best visited after exploring the Six Western Palaces. The garden offers a quiet, uncrowded spot ideal for a mid-tour rest.</p><p>---</p>',
  '',
  7,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_forbidden_city_bj_sa_09',
  'beijing_forbidden_city',
  'hall of ancestral worship clock gallery palace of tranquil longevity treasure gallery',
  '奉先殿·钟表馆与宁寿宫·珍宝馆 / Hall of Ancestral Worship - Clock Gallery & Palace of Tranquil Longevity - Treasure Gallery',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_forbidden_city_bj_sa_09.jpg',
  '<p>- **名字 / Name：** 奉先殿·钟表馆与宁寿宫·珍宝馆 / Hall of Ancestral Worship - Clock Gallery &amp; Palace of Tranquil Longevity - Treasure Gallery<br>- **摘要 / Summary：** 奉先殿为明清皇室祭祀祖先的家庙，今设钟表馆陈列中外精美钟表；宁寿宫为乾隆帝退位后颐养之所，珍宝馆内陈列清宫奇珍异宝，两者均为故宫需另购票的热门专题馆。 The Hall of Ancestral Worship, the Ming-Qing imperial ancestral shrine, now houses the Clock Gallery with exquisite Chinese and Western timepieces; the Palace of Tranquil Longevity, built as the Qianlong Emperor''s retirement residence, hosts the Treasure Gallery showcasing Qing court rarities — both popular special-exhibition halls requiring separate tickets.<br>- **长文描述 / Description：** 奉先殿位于东六宫之南，始建于明永乐年间，是明清皇帝祭祀本朝列祖列宗的家庙。大殿面阔九间、重檐庑殿顶，殿内以金砖墁地、楠木作柱，庄严华贵。清宫旧藏的钟表大多来自英国、法国及瑞士进献，亦有清宫造办处自行设计制造的御制钟表，计千余件。今日奉先殿辟为钟表馆，定时展示部分精密时计，整点报时之际，钟鼓齐鸣、鸟啼水转，两百年前的机械奇迹在此复活。<br>&gt;<br>&gt; 宁寿宫位于故宫东路外朝与内廷之间，是乾隆帝为自己退位后营建的太上皇宫殿群。其建筑布局仿照故宫中路，涵盖皇极殿、宁寿宫、养性殿、乐寿堂等殿宇，以及著名的乾隆花园。皇极殿为宁寿宫区正殿，乾隆帝在此举行"千叟宴"。珍宝馆即设于宁寿宫区各殿堂之内，展出清宫所藏金器、玉器、珠宝、礼器与帝后冠服，其中金瓯永固杯、大禹治水玉山、龙袍朝珠等皆为国宝级文物。奉先殿与宁寿宫一西一东，构成故宫专题文物展陈的两大瑰丽篇章。 The Hall of Ancestral Worship, south of the Six Eastern Palaces and dating from the Yongle reign, served as the imperial family''s private ancestral temple. Its nine-bay hall with a double-eaved hip roof, gold-brick flooring, and nanmu columns exudes solemn magnificence. The Qing court''s clock collection, numbering over a thousand pieces, includes diplomatic gifts from Britain, France, and Switzerland alongside timepieces crafted by the palace workshops. Today the hall is the Clock Gallery, where selected timepieces are demonstrated — at the stroke of the hour, bells chime, birds sing, and water-driven automata spring to life, reawakening two-century-old mechanical marvels.<br>&gt;<br>&gt; The Palace of Tranquil Longevity, spanning the eastern Outer and Inner Courts, was built by the Qianlong Emperor as his retirement palace. Its layout mirrors the central axis, encompassing the Hall of Imperial Supremacy, the Palace of Tranquil Longevity, the Hall of Character Cultivation, the Hall of Joyful Longevity, and the famous Qianlong Garden. The Hall of Imperial Supremacy, the main building, hosted the emperor''s "Banquet of a Thousand Elders." The Treasure Gallery is distributed across these halls, exhibiting Qing court goldwork, jades, jewelry, ritual bronzes, and imperial attire. Highlights include the Gold Chalice of Eternal Stability, the Jade Mountain of Yu the Great Taming the Waters, and dragon robes with court beads — all national treasures. Together, the Clock Gallery and Treasure Gallery form two glittering chapters of the Palace Museum''s thematic collections.<br>- **详细地址 / Address：** 北京市东城区景山前街4号故宫博物院内——奉先殿位于东六宫之南（钟表馆），宁寿宫位于东路北部（珍宝馆） / Within the Palace Museum at No. 4 Jingshan Front Street, Dongcheng District, Beijing — Hall of Ancestral Worship south of the Six Eastern Palaces (Clock Gallery); Palace of Tranquil Longevity in the northeastern section (Treasure Gallery)<br>- **门票信息 / Ticket Information：** 故宫大门票外，珍宝馆与钟表馆各需另购10元/人，可在预约故宫门票时一并勾选，亦可入宫后在两馆入口处扫码购买。 / In addition to the main Palace Museum ticket, the Treasure Gallery and Clock Gallery each require a separate CNY 10 ticket. These can be purchased together with your main ticket when booking online, or scanned and purchased at the entrance to each gallery after entering the Forbidden City.<br>- **开放时间 / Opening Hours：** 旺季（4月1日—10月31日）8:30—17:00（16:10停止入馆）；淡季（11月1日—次年3月31日）8:30—16:30（15:40停止入馆）；周一闭馆（法定节假日除外）。钟表馆每日定时有钟表演示，具体时间请关注当日公告。 / Peak season (Apr 1–Oct 31): 8:30 AM–5:00 PM (last entry at 4:10 PM); off-season (Nov 1–Mar 31): 8:30 AM–4:30 PM (last entry at 3:40 PM). Closed on Mondays (except public holidays). The Clock Gallery holds scheduled timepiece demonstrations daily — check on-site announcements for times.<br>- **交通信息 / Transportation：** 奉先殿（钟表馆）位于内廷东路南侧，从乾清宫向东步行约150米即达。宁寿宫（珍宝馆）位于东路北端，可从奉先殿继续向北穿过景运门进入，宁寿宫区域较大，建议预留1-1.5小时细细赏玩。 / The Hall of Ancestral Worship (Clock Gallery) is on the eastern side of the Inner Court, about 150 meters east of the Palace of Heavenly Purity. The Palace of Tranquil Longevity (Treasure Gallery) lies further north on the eastern route — enter via Jingyun Gate from the Hall of Ancestral Worship. The Palace of Tranquil Longevity area is extensive; plan for 1–1.5 hours to appreciate it fully.</p><p>---</p>',
  '',
  8,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_forbidden_city_bj_sa_10',
  'beijing_forbidden_city',
  'qianlong garden and imperial garden',
  '乾隆花园与御花园 / Qianlong Garden and Imperial Garden',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_forbidden_city_bj_sa_10.jpg',
  '<p>- **名字 / Name：** 乾隆花园与御花园 / Qianlong Garden and Imperial Garden<br>- **摘要 / Summary：** 故宫中最具代表性的两座皇家园林——乾隆花园为乾隆退位后精心营建的私密园林，御花园则是位于中轴线末端的皇家后苑，古柏奇石、亭台楼阁交相辉映。 The Forbidden City''s two most representative imperial gardens — the Qianlong Garden, a private retreat meticulously designed for the Qianlong Emperor''s retirement, and the Imperial Garden, the grand rear garden at the terminus of the central axis, where ancient cypresses, scholar rocks, and pavilions blend in harmony.<br>- **长文描述 / Description：** 乾隆花园位于宁寿宫区西侧，是乾隆帝退位前耗时十年精心营建的私人园林。园内面积虽小，却巧妙运用了"以小见大"的江南园林造园手法，假山、曲径、游廊、亭台错落有致，共分四进院落，依次为古华轩、遂初堂、萃赏楼、符望阁，以及园内最负盛名的倦勤斋。倦勤斋内设有乾隆帝最钟爱的"戏台"与通景画围屏，外看为普通厅堂，内则别有洞天，堪称紫禁城中最具私密感的艺术殿堂。<br>&gt;<br>&gt; 御花园位于坤宁宫之北、中轴线终点，建于明永乐年间，面积约12000平方米，是故宫中最大的花园。园中古柏参天，多植于明永乐年间，六百年风雨不改其苍翠。园内布局以钦安殿（道教神殿）为中心，左右对称分布着万春亭、千秋亭、浮碧亭、澄瑞亭等二十余座亭台楼阁，堆秀山与海参石相映成趣，天一门前的青铜鎏金獬豸更添庄严气象。园中花木扶疏、甬道蜿蜒，是参观完庄严宫阙后尽情放松身心、感受皇家园林之美的绝佳去处。 The Qianlong Garden, west of the Palace of Tranquil Longevity complex, was a decade-long labor of love by the Qianlong Emperor before his abdication. Despite its modest size, it masterfully employs the Jiangnan garden technique of "creating grandeur within a small space." Its four sequential courtyards house the Pavilion of Ancient Splendor, the Hall of Fulfilling Original Wishes, the Pavilion of Assembled Beauty, and the Pavilion of Expectations Fulfilled, culminating in the celebrated Lodge of Retired Diligence (Juanqin Zhai). Within Juanqin Zhai lies the emperor''s beloved private theater and panoramic mural screens — an unassuming exterior concealing a hidden realm, the most intimate artistic sanctum in the Forbidden City.<br>&gt;<br>&gt; The Imperial Garden, at the northern terminus of the central axis beyond the Palace of Earthly Tranquility, was laid out during the Ming Yongle reign and spans approximately 12,000 square meters — the largest garden in the Forbidden City. Ancient cypresses planted over six centuries ago still stand verdant. The garden centers on the Hall of Imperial Peace (a Daoist shrine), with over twenty pavilions and gazebos — including the Pavilion of Myriad Springs and the Pavilion of a Thousand Autumns — arranged symmetrically to the left and right. The Hill of Accumulated Elegance and the Sea-Cucumber Rock create a delightful contrast, while the gilded bronze xiezhi (mythical unicorn) before Tianyi Gate adds solemn dignity. With meandering paths, flowering shrubs, and shaded arbors, it is the perfect place to unwind after the solemn grandeur of the palaces and to savor the beauty of an imperial garden.<br>- **详细地址 / Address：** 北京市东城区景山前街4号故宫博物院内——乾隆花园位于宁寿宫区西侧（珍宝馆区域内），御花园位于中轴线北端、坤宁宫之北 / Within the Palace Museum at No. 4 Jingshan Front Street, Dongcheng District, Beijing — the Qianlong Garden is west of the Palace of Tranquil Longevity complex (within the Treasure Gallery zone); the Imperial Garden is at the northern end of the central axis, north of the Palace of Earthly Tranquility<br>- **门票信息 / Ticket Information：** 旺季（4月1日—10月31日）60元/人，淡季（11月1日—次年3月31日）40元/人；珍宝馆、钟表馆各10元另购；需通过故宫博物院官网或微信公众号提前在线预约，凭身份证或护照入场。乾隆花园位于珍宝馆区域内，需持有珍宝馆门票方可参观；御花园包含在大门票内，无需另购。 / Peak season (Apr 1–Oct 31): CNY 60/person; off-season (Nov 1–Mar 31): CNY 40/person. The Treasure Gallery and Clock Gallery each require an additional CNY 10 ticket. All visitors must book online in advance. The Qianlong Garden is within the Treasure Gallery zone — a Treasure Gallery ticket is required. The Imperial Garden is included in the main admission ticket with no extra charge.<br>- **开放时间 / Opening Hours：** 旺季（4月1日—10月31日）8:30—17:00（16:10停止入馆）；淡季（11月1日—次年3月31日）8:30—16:30（15:40停止入馆）；周一闭馆（法定节假日除外）。 / Peak season (Apr 1–Oct 31): 8:30 AM–5:00 PM (last entry at 4:10 PM); off-season (Nov 1–Mar 31): 8:30 AM–4:30 PM (last entry at 3:40 PM). Closed on Mondays (except public holidays).<br>- **交通信息 / Transportation：** 乾隆花园位于故宫东路珍宝馆区域内，从宁寿宫区进入；御花园位于中轴线终点，参观完坤宁宫后向北直行即达。御花园北端即为神武门出口，参观完毕可由此出宫。 / The Qianlong Garden is on the eastern route within the Treasure Gallery zone, accessed from the Palace of Tranquil Longevity complex. The Imperial Garden is at the terminal point of the central axis — continue north from the Palace of Earthly Tranquility to reach it. The Gate of Divine Might (exit) is at the garden''s northern end, providing a natural departure point.</p><p>---</p>',
  '',
  9,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_forbidden_city_bj_sa_11',
  'beijing_forbidden_city',
  'gate of divine might corner towers and east west prosperity gates',
  '神武门、角楼与东西华门 / Gate of Divine Might, Corner Towers, and East-West Prosperity Gates',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_forbidden_city_bj_sa_11.jpg',
  '<p>- **名字 / Name：** 神武门、角楼与东西华门 / Gate of Divine Might, Corner Towers, and East-West Prosperity Gates<br>- **摘要 / Summary：** 故宫北门、四角角楼与东西侧门共同构成了紫禁城的边界景观——神武门为参观出口，角楼以巧夺天工的木结构享誉世界，东西华门则各具独特历史功。 The northern gate, four corner towers, and the east and west side gates collectively define the Forbidden City''s perimeter — the Gate of Divine Might serves as the exit, the corner towers are world-renowned for their intricate wooden structure, and the East and West Prosperity Gates each bear unique historical significance.<br>- **长文描述 / Description：** 神武门为故宫的正北门，建于明永乐十八年（1420年），初名"玄武门"，清代为避康熙帝玄烨名讳而改称"神武门"。城楼面阔五间、进深一间，重檐庑殿顶。昔日有钟鼓设于城楼之上，司报晨昏；每日入夜后鸣钟108响，钟声回荡于紫禁城上空，为这座千年宫城划上一天的句号。如今神武门是大多数游客游览故宫后的出口，走出神武门即见景山万春亭，俯瞰宫城的经典视角即从此处启程。<br>&gt;<br>&gt; 故宫四角的角楼堪称中国古代木结构建筑的奇迹，每座三开间、三重檐、十字脊顶，共有九梁十八柱七十二条脊，不用一钉一铆，全凭榫卯结构筑就美轮美奂的楼阁。夕阳西下时，金色的琉璃瓦与清澈的护城河水相映成趣，成为北京最具标志性的城市剪影之一。东西华门分列故宫东西城墙中部，东华门门钉为八路（其余三门均为九路），被认为与明代皇帝驾崩后梓宫由此出宫有关；西华门则在清代为帝后前往西苑（今中南海）和颐和园的必经之门。 The Gate of Divine Might, the northern gate, was completed in 1420 and originally named Xuanwu Gate — renamed to avoid the Kangxi Emperor''s personal name Xuanye. Its five-bay tower with a double-eaved hip roof once housed bells and drums that marked dawn and dusk; each evening, 108 strokes of the bell would echo across the Forbidden City, ending the day for the thousand-year-old palace. Today it is the exit for most visitors — beyond it rises the Wanchun Pavilion atop Jingshan Hill, the classic vantage point for panoramic views of the palace complex.<br>&gt;<br>&gt; The four corner towers of the Forbidden City are masterpieces of ancient Chinese timber construction. Each tower, spanning three bays with triple eaves and a cross-shaped ridge, comprises nine beams, eighteen columns, and seventy-two ridges — assembled entirely through mortise-and-tenon joinery without a single nail. At sunset, their golden-glazed tiles reflected in the clear moat waters form one of Beijing''s most iconic silhouettes. The East and West Prosperity Gates stand midway along the eastern and western walls respectively. The East Prosperity Gate has eight rows of door nails rather than the standard nine, believed to be related to the passage of imperial coffins during Ming funerals; the West Prosperity Gate served as the Qing emperors'' and empresses'' gateway to the Western Gardens (today''s Zhongnanhai) and the Summer Palace.<br>- **详细地址 / Address：** 北京市东城区景山前街4号故宫博物院——神武门为北门出口；角楼位于故宫城墙四角；东华门位于东城墙中部，西华门位于西城墙中部 / No. 4 Jingshan Front Street, Dongcheng District, Beijing, Palace Museum — the Gate of Divine Might is the north gate exit; the corner towers stand at the four corners of the outer walls; the East Prosperity Gate is midway along the eastern wall, the West Prosperity Gate midway along the western wall<br>- **门票信息 / Ticket Information：** 旺季（4月1日—10月31日）60元/人，淡季（11月1日—次年3月31日）40元/人；珍宝馆、钟表馆各10元另购；需通过故宫博物院官网或微信公众号提前在线预约，凭身份证或护照入场。角楼与护城河可从宫外观赏，无需购票。 / Peak season (Apr 1–Oct 31): CNY 60/person; off-season (Nov 1–Mar 31): CNY 40/person. The Treasure Gallery and Clock Gallery each require an additional CNY 10 ticket. All visitors must book online in advance. The corner towers and moat can be viewed from outside the palace walls without a ticket.<br>- **开放时间 / Opening Hours：** 旺季（4月1日—10月31日）8:30—17:00（16:10停止入馆）；淡季（11月1日—次年3月31日）8:30—16:30（15:40停止入馆）；周一闭馆（法定节假日除外）。神武门出宫后不可再次进入。 / Peak season (Apr 1–Oct 31): 8:30 AM–5:00 PM (last entry at 4:10 PM); off-season (Nov 1–Mar 31): 8:30 AM–4:30 PM (last entry at 3:40 PM). Closed on Mondays (except public holidays). Re-entry is not permitted after exiting through the Gate of Divine Might.<br>- **交通信息 / Transportation：** 神武门为参观终点出口，出宫后可乘坐北京公交或地铁返回。角楼最佳拍摄点在故宫东北角与西北角护城河外侧，尤其以东北角楼落日时分最为壮观，可乘地铁至中国美术馆站或乘公交至此拍摄。东西华门一般不作为游客主要出入口，从故宫内部沿东西路分别可达。 / The Gate of Divine Might is the final exit. After exiting, buses and the subway are available for the return journey. The best photography spots for the corner towers are outside the moat at the northeast and northwest corners — the northeast corner tower at sunset is especially spectacular. Reach these spots via China Art Museum subway station or by bus. The East and West Prosperity Gates are not used as main visitor entrances or exits but are accessible from the eastern and western routes inside the Forbidden City.</p><p>---</p><p>&gt; **游览提示 / Visitor Tips:**<br>&gt; 故宫博物院实行"自南向北"单向参观路线，所有游客须从午门（南门）进入，由神武门（北门）或东华门（东侧门）离开。建议提前至少一天在"故宫博物院"官方网站或微信小程序上预约门票，旺季及节假日门票紧俏。参观时请勿触摸文物与古建筑，建议穿着舒适的步行鞋，全程游览约需4—6小时。珍宝馆与钟表馆强烈推荐单独购票参观，其收藏之精美令人叹为观止。<br>&gt;<br>&gt; The Palace Museum operates a one-way south-to-north visiting route: all visitors must enter through the Meridian Gate (south) and exit via the Gate of Divine Might (north) or the East Prosperity Gate. Tickets should be booked at least one day in advance via the Palace Museum''s official website or WeChat mini-program, as they sell out quickly during peak seasons and holidays. Please do not touch artifacts or ancient structures. Comfortable walking shoes are strongly recommended; a complete visit typically takes 4–6 hours. The Treasure Gallery and Clock Gallery are highly recommended as add-ons — their collections are nothing short of breathtaking.</p>',
  '',
  10,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_lama_temple_bj_sa_01',
  'beijing_lama_temple',
  'archway courtyard and zhaotai gate',
  '牌楼院与昭泰门 / Archway Courtyard and Zhaotai Gate',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_lama_temple_bj_sa_01.jpg',
  '<p>- **名字 / Name：** 牌楼院与昭泰门 / Archway Courtyard and Zhaotai Gate<br>- **摘要 / Summary：** 三座飞檐牌楼与昭泰门构成雍和宫庄严华美的南端入口。 Three flying-eave archways and Zhaotai Gate form a magnificent southern entrance to the Lama Temple.<br>- **长文描述 / Description：** 雍和宫最南端的牌楼院是整座寺院的前导空间，由三座气势恢宏的琉璃牌楼构成，居中者题"寰海尊亲"，东西两座分别题"慈隆宝叶"与"福衍金沙"，为乾隆御笔。三座牌楼以黄绿琉璃瓦覆顶，斗拱飞檐，雕梁画栋，彰显皇家寺院的尊贵气度。穿过牌楼院北行，迎面即为昭泰门，门洞上方悬"雍和门"匾额，是进入寺院核心区域的第一道门户。整个前导空间由南至北逐步抬升，营造出由凡入圣、渐入庄严的空间序列，令人在踏入昭泰门的瞬间便感受到肃穆宁静的宗教氛围。</p><p>  The archway courtyard at the southernmost end of the Lama Temple serves as the processional forecourt of the entire complex. It comprises three grand glazed-tile archways: the central one inscribed "Revered by All within the Four Seas" and the flanking ones inscribed "Compassionate Majesty" and "Blessings Flowing to the Sands," all in the calligraphy of the Qianlong Emperor. Crowned with yellow and green glazed tiles, the archways feature intricate bracket sets, flying eaves and painted beams that proclaim the dignity of a royal monastery. Passing northward through the courtyard, visitors reach Zhaotai Gate, hung with a plaque reading "Yonghe Gate," the first threshold into the heart of the temple. The ground rises gently from south to north, creating a sequence that leads from the secular to the sacred, so that the moment one steps through Zhaotai Gate a solemn and serene religious atmosphere is felt.<br>- **详细地址 / Address：** 北京市东城区雍和宫大街12号（雍和宫最南端入口） / 12 Yonghe Temple Avenue, Dongcheng District, Beijing (southern entrance of the Lama Temple)<br>- **门票信息 / Ticket Information：** 门票25元，学生及老人凭有效证件半价；官方网站或现场购票 / Admission 25 yuan; half price for students and seniors with valid ID; tickets available online or on site<br>- **开放时间 / Opening Hours：** 11月至3月9:00–16:30；4月至10月9:00–17:00 / November–March 9:00–16:30; April–October 9:00–17:00<br>- **交通信息 / Transportation：** 地铁2号线或5号线雍和宫站C口出，向南步行约100米 / Subway Line 2 or 5, Yonghe Temple (Yonghegong) station, Exit C, about 100 m south on foot</p><p>---</p>',
  '',
  0,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_lama_temple_bj_sa_02',
  'beijing_lama_temple',
  'bell and drum towers and the hall of the heavenly kings',
  '钟鼓楼与天王殿 / Bell and Drum Towers and the Hall of the Heavenly Kings',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_lama_temple_bj_sa_02.png',
  '<p>- **名字 / Name：** 钟鼓楼与天王殿 / Bell and Drum Towers and the Hall of the Heavenly Kings<br>- **摘要 / Summary：** 晨钟暮鼓与弥勒韦驮四大天王共护佛法庄严。 Morning bell and evening drum join the Maitreya, Skanda and Four Heavenly Kings in guarding the dignity of the Dharma.<br>- **长文描述 / Description：** 进入昭泰门后，东西两侧分列钟楼与鼓楼，是寺院"晨钟暮鼓"报时之所。钟楼内悬挂铜钟，鼓楼内置大鼓，均沿袭汉传佛寺传统布局。钟鼓楼之间正北即为天王殿，殿内正中供奉布袋弥勒佛（大肚弥勒），袒胸露腹，笑容可掬，寓意"大肚能容，容天下难容之事"。弥勒背后供奉韦驮菩萨，手持降魔杵，为护法神将。殿内东西两侧塑有四大天王——东方持国天王、南方增长天王、西方广目天王、北方多闻天王，各执法器，威武庄严，守护须弥山四方，是整座寺院守护序列的核心。</p><p>  After entering Zhaotai Gate, the Bell Tower stands to the east and the Drum Tower to the west, marking the traditional "morning bell and evening drum" timekeeping of Buddhist monasteries. A bronze bell hangs in the Bell Tower and a large drum stands in the Drum Tower, continuing the layout inherited from Han-Chinese Buddhist temples. Directly to the north between the two towers stands the Hall of the Heavenly Kings. At its centre is enshrined the Cloth-Sack Maitreya, the pot-bellied Buddha with a beaming smile, symbolising the boundless capacity to embrace what is difficult to embrace. Behind Maitreya stands Skanda, the Dharma-protecting general holding a demon-subduing staff. Along the east and west walls are the Four Heavenly Kings—Virudhaka of the East, Virulaka of the South, Virupaksa of the West and Vaisravana of the North—each grasping a ritual implement, awe-inspiring and majestic, guardians of the four directions of Mount Sumeru and the core of the temple''s protective sequence.<br>- **详细地址 / Address：** 北京市东城区雍和宫大街12号（雍和宫第一进院落） / 12 Yonghe Temple Avenue, Dongcheng District, Beijing (first courtyard of the Lama Temple)<br>- **门票信息 / Ticket Information：** 门票25元，含全寺参观；学生及老人半价 / Admission 25 yuan, including the whole temple; half price for students and seniors<br>- **开放时间 / Opening Hours：** 11月至3月9:00–16:30；4月至10月9:00–17:00 / November–March 9:00–16:30; April–October 9:00–17:00<br>- **交通信息 / Transportation：** 地铁2/5号线雍和宫站，步行约150米 / Subway Line 2 or 5, Yonghegong station, about a 150-metre walk</p><p>---</p>',
  '',
  1,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_lama_temple_bj_sa_03',
  'beijing_lama_temple',
  'stele pavilion of on lamaism and the bronze mount sumeru',
  '喇嘛说碑亭与铜铸须弥山 / Stele Pavilion of "On Lamaism" and the Bronze Mount Sumeru',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_lama_temple_bj_sa_03.png',
  '<p>- **名字 / Name：** 喇嘛说碑亭与铜铸须弥山 / Stele Pavilion of "On Lamaism" and the Bronze Mount Sumeru<br>- **摘要 / Summary：** 乾隆御笔《喇嘛说》碑文与铜铸须弥山合彰政教与宇宙之理。 The Qianlong Emperor''s essay "On Lamaism" and a bronze Mount Sumeru illuminate the relationship between governance, religion and cosmology.<br>- **长文描述 / Description：** 天王殿之后为御碑亭，亭内立有乾隆五十七年（1792年）御笔《喇嘛说》石碑，四面分别以满、汉、蒙、藏四种文字镌刻，阐述了清王朝对藏传佛教的政策与"兴黄教即所以安众蒙古"的治国方略，是研究清代民族宗教政策的重要文献。碑亭北侧设铜铸须弥山，据传为明代遗物，以佛教宇宙观为蓝本，以山形结构展现须弥山为中心、日月环绕、四大部洲与八小部洲分列的宇宙图景，工艺精湛，寓意深远，是藏传佛教宇宙观的立体缩影。</p><p>  Beyond the Hall of the Heavenly Kings stands the Imperial Stele Pavilion, housing a stone stele inscribed in 1792 (the fifty-seventh year of Qianlong) with the emperor''s essay "On Lamaism." Carved in Manchu, Chinese, Mongolian and Tibetan on its four faces, the text articulates Qing policy toward Tibetan Buddhism and the governing strategy that "promoting the Yellow Teaching pacifies the Mongols," making it a crucial document for the study of Qing ethnic and religious policy. North of the pavilion stands a bronze Mount Sumeru, believed to date from the Ming dynasty. Modelled on the Buddhist cosmos, it represents Mount Sumeru at the centre, encircled by the sun and moon, with the four great continents and eight minor continents arranged around it. Exquisitely crafted and rich in symbolism, it is a three-dimensional distillation of the Tibetan Buddhist worldview.<br>- **详细地址 / Address：** 北京市东城区雍和宫大街12号（雍和宫第二进院落） / 12 Yonghe Temple Avenue, Dongcheng District, Beijing (second courtyard of the Lama Temple)<br>- **门票信息 / Ticket Information：** 门票25元，含全寺参观 / Admission 25 yuan, including the whole temple<br>- **开放时间 / Opening Hours：** 11月至3月9:00–16:30；4月至10月9:00–17:00 / November–March 9:00–16:30; April–October 9:00–17:00<br>- **交通信息 / Transportation：** 地铁2/5号线雍和宫站，步行约200米 / Subway Line 2 or 5, Yonghegong station, about a 200-metre walk</p><p>---</p>',
  '',
  2,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_lama_temple_bj_sa_04',
  'beijing_lama_temple',
  'yonghe palace mahavira hall',
  '雍和宫殿·大雄宝殿 / Yonghe Palace (Mahavira Hall)',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_lama_temple_bj_sa_04.png',
  '<p>- **名字 / Name：** 雍和宫殿·大雄宝殿 / Yonghe Palace (Mahavira Hall)<br>- **摘要 / Summary：** 雍和宫正殿由亲王府邸佛殿演变而来供奉三世佛。 The temple''s main hall evolved from a prince''s residence chapel and enshrines the Three Buddhas of the Three Times.<br>- **长文描述 / Description：** 雍和宫殿是整座寺院的主殿，原为雍亲王胤禛府邸的银安殿，后改建为佛殿，故兼有王府建筑的恢宏尺度与佛寺殿宇的庄严格局。殿内正中供奉三世佛——燃灯佛（过去）、释迦牟尼佛（现在）、弥勒佛（未来），法相庄严，金身肃穆。两侧塑有十八罗汉像，姿态各异，栩栩如生。殿前月台宽敞，东西两侧配殿分别供奉关帝与观音，体现汉藏文化交融特色。殿顶覆黄琉璃瓦绿剪边，为皇家建筑等级，雕梁画栋间处处可见龙凤纹饰，彰显"龙潜福地"的皇家气派。</p><p>  Yonghe Palace is the main hall of the temple, originally the Silver An Hall of Prince Yong''s mansion before its conversion into a Buddhist sanctuary. It thus combines the grand scale of princely architecture with the solemnity of a Buddhist hall. At its centre are enshrined the Three Buddhas of the Three Times: Dipankara (the past), Shakyamuni (the present) and Maitreya (the future), their golden images serene and majestic. Along the sides stand the Eighteen Arhats, each in a distinct and lifelike posture. The spacious moon terrace in front is flanked by side halls dedicated to Guan Yu and Guanyin, reflecting the fusion of Han and Tibetan culture. The roof is covered with yellow glazed tiles trimmed in green—the imperial rank of roofing—and the painted beams are ornamented throughout with dragon and phoenix motifs, proclaiming the royal splendour of this "blessed land of the dragon."<br>- **详细地址 / Address：** 北京市东城区雍和宫大街12号（雍和宫主殿） / 12 Yonghe Temple Avenue, Dongcheng District, Beijing (main hall of the Lama Temple)<br>- **门票信息 / Ticket Information：** 门票25元，含全寺参观 / Admission 25 yuan, including the whole temple<br>- **开放时间 / Opening Hours：** 11月至3月9:00–16:30；4月至10月9:00–17:00 / November–March 9:00–16:30; April–October 9:00–17:00<br>- **交通信息 / Transportation：** 地铁2/5号线雍和宫站，步行约200米 / Subway Line 2 or 5, Yonghegong station, about a 200-metre walk</p><p>---</p>',
  '',
  3,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_lama_temple_bj_sa_05',
  'beijing_lama_temple',
  'yongyou hall',
  '永佑殿 / Yongyou Hall',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_lama_temple_bj_sa_05.png',
  '<p>- **名字 / Name：** 永佑殿 / Yongyou Hall<br>- **摘要 / Summary：** 雍正帝停灵与清帝祈福之所供奉无量寿佛等三尊造像。 This hall, where the Yongzheng Emperor''s coffin once rested, enshrines Amitayus and two other sacred images.<br>- **长文描述 / Description：** 永佑殿原为雍亲王府的寝殿，雍正帝驾崩后曾在此停灵，故取"永佑"之意，寄托皇室对先帝的追思与祈福。殿内正中供奉无量寿佛（阿弥陀佛），两侧分别为药师佛和狮吼佛，造像法相庄严，工艺精湛，均为清代宫廷造像佳作。殿内还陈列有乾隆皇帝为其父雍正所书"福"字碑及檀木罗汉像等珍贵文物。永佑殿作为寺院的中心殿堂之一，在建筑上保持了亲王府寝殿的格局，是雍和宫由王府向寺院转变的重要历史见证，亦是信众诵经祈福的重要场所。</p><p>  Yongyou Hall was originally the bedchamber of Prince Yong''s mansion. After the Yongzheng Emperor''s death his coffin rested here, and the name "Yongyou," meaning "eternal blessing," expresses the imperial family''s remembrance and prayers for the late emperor. At the centre of the hall is Amitayus (Amitabha), flanked by the Medicine Buddha and the Lion''s Roar Buddha. The images are solemn and exquisitely crafted, all fine works of Qing court sculpture. Also displayed are a "Fu" (blessing) character brushed by the Qianlong Emperor for his father and sandalwood arhat figures. As one of the temple''s central halls, Yongyou preserves the layout of a princely bedchamber and bears witness to the transformation of the mansion into a monastery, while remaining a place where the faithful gather to chant and pray.<br>- **详细地址 / Address：** 北京市东城区雍和宫大街12号（雍和宫第三进殿宇） / 12 Yonghe Temple Avenue, Dongcheng District, Beijing (third hall of the Lama Temple)<br>- **门票信息 / Ticket Information：** 门票25元，含全寺参观 / Admission 25 yuan, including the whole temple<br>- **开放时间 / Opening Hours：** 11月至3月9:00–16:30；4月至10月9:00–17:00 / November–March 9:00–16:30; April–October 9:00–17:00<br>- **交通信息 / Transportation：** 地铁2/5号线雍和宫站，步行约250米 / Subway Line 2 or 5, Yonghegong station, about a 250-metre walk</p><p>---</p>',
  '',
  4,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_lama_temple_bj_sa_06',
  'beijing_lama_temple',
  'four monastic colleges dratsang',
  '四大扎仓 / Four Monastic Colleges (Dratsang)',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_lama_temple_bj_sa_06.png',
  '<p>- **名字 / Name：** 四大扎仓 / Four Monastic Colleges (Dratsang)<br>- **摘要 / Summary：** 显宗密宗等四大学僧扎仓构成藏传佛教完备教育体系。 Four colleges of Exoteric, Esoteric, Medicine and Kalacakra form a complete system of Tibetan Buddhist education.<br>- **长文描述 / Description：** 雍和宫作为藏传佛教格鲁派在京城的中心寺院，设有四大扎仓（学院），分别是显宗扎仓（研修显宗教理）、密宗扎仓（研修密宗仪轨）、医学扎仓（研修藏医藏药）与时轮扎仓（研修天文历算）。四大扎仓设于寺院东西两侧的配殿之中，各扎仓内供奉相应本尊造像，陈列经卷法器与教学用具，历史上学僧在此系统修学多年，经辩经考核后获授格西学位，是培养藏传佛教高僧的重要学府。这一制度延续至今，使雍和宫不仅为皇家寺院，更是藏传佛教学术研究与宗教教育的重要基地。</p><p>  As the central Gelugpa monastery in the capital, the Lama Temple houses four dratsang (monastic colleges): the Exoteric College for the study of sutra, the Esoteric College for tantra and ritual, the Medical College for Tibetan medicine and pharmacology, and the Kalacakra College for astronomy and calendrical calculation. Set within the side halls on the east and west of the temple, each college enshrines its respective tutelary deity and displays scriptures, ritual implements and teaching materials. Historically, monks studied here for many years, and after rigorous debate examinations were awarded the Geshe degree, making the temple a key institution for training senior Tibetan Buddhist clergy. This tradition continues today, so that the temple is not merely a royal monastery but an important centre of Tibetan Buddhist scholarship and religious education.<br>- **详细地址 / Address：** 北京市东城区雍和宫大街12号（雍和宫东西配殿区域） / 12 Yonghe Temple Avenue, Dongcheng District, Beijing (east and west side halls of the Lama Temple)<br>- **门票信息 / Ticket Information：** 门票25元，含全寺参观 / Admission 25 yuan, including the whole temple<br>- **开放时间 / Opening Hours：** 11月至3月9:00–16:30；4月至10月9:00–17:00 / November–March 9:00–16:30; April–October 9:00–17:00<br>- **交通信息 / Transportation：** 地铁2/5号线雍和宫站，步行约250米 / Subway Line 2 or 5, Yonghegong station, about a 250-metre walk</p><p>---</p>',
  '',
  5,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_lama_temple_bj_sa_07',
  'beijing_lama_temple',
  'falun hall wheel of the law hall',
  '法轮殿 / Falun Hall (Wheel of the Law Hall)',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_lama_temple_bj_sa_07.png',
  '<p>- **名字 / Name：** 法轮殿 / Falun Hall (Wheel of the Law Hall)<br>- **摘要 / Summary：** 寺院法事核心殿堂以宗喀巴大师像与五百罗汉山闻名。 The ritual heart of the temple, famous for the statue of Tsongkhapa and the mountain of five hundred arhats.<br>- **长文描述 / Description：** 法轮殿是雍和宫举行重大宗教法事活动的核心殿堂，建筑风格融汉藏于一体，殿顶设五座天窗式小阁，象征藏传佛教五大教派。殿内正中供奉格鲁派创始人宗喀巴大师铜像，高约六米，法相庄严，两侧为其两大弟子贾曹杰与克主杰造像。殿西供奉释迦牟尼佛，殿东为观世音菩萨。殿内最为著名的是"五百罗汉山"，以紫檀木雕琢成山峦叠嶂之形，五百罗汉错落分布其间，或坐或立，或参禅或论道，神态各异，巧夺天工，是雍和宫"三绝"之一。殿前还陈列有乾隆帝所赠金奔巴瓶，用于金瓶掣签确定活佛转世灵童，是清代治藏政策的重要物证。</p><p>  Falun Hall is the ritual centre of the Lama Temple, where major religious ceremonies are held. Its architecture fuses Han and Tibetan styles, and the roof is crowned with five skylight pavilions symbolising the five major schools of Tibetan Buddhism. At the centre is a six-metre bronze statue of Tsongkhapa, founder of the Gelug school, flanked by his two chief disciples, Khedrup Je and Gyaltsab Je. To the west stands Shakyamuni, and to the east, Avalokitesvara. The hall''s most celebrated treasure is the "Mountain of Five Hundred Arhats," carved from red sandalwood into a landscape of layered peaks populated by five hundred arhats—sitting or standing, meditating or debating—each with a distinct expression, a triumph of craftsmanship counted among the "Three Wonders" of the temple. In front of the hall is displayed the Golden Bumpa Vase, presented by the Qianlong Emperor and used in the golden urn lot-draw to identify reincarnated lamas, a key artefact of Qing Tibet policy.<br>- **详细地址 / Address：** 北京市东城区雍和宫大街12号（雍和宫第四进殿宇） / 12 Yonghe Temple Avenue, Dongcheng District, Beijing (fourth hall of the Lama Temple)<br>- **门票信息 / Ticket Information：** 门票25元，含全寺参观 / Admission 25 yuan, including the whole temple<br>- **开放时间 / Opening Hours：** 11月至3月9:00–16:30；4月至10月9:00–17:00 / November–March 9:00–16:30; April–October 9:00–17:00<br>- **交通信息 / Transportation：** 地铁2/5号线雍和宫站，步行约300米 / Subway Line 2 or 5, Yonghegong station, about a 300-metre walk</p><p>---</p>',
  '',
  6,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_lama_temple_bj_sa_08',
  'beijing_lama_temple',
  'pavilion of ten thousand blessings wanfu pavilion',
  '万福阁 / Pavilion of Ten Thousand Blessings (Wanfu Pavilion)',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_lama_temple_bj_sa_08.png',
  '<p>- **名字 / Name：** 万福阁 / Pavilion of Ten Thousand Blessings (Wanfu Pavilion)<br>- **摘要 / Summary：** 二十五米高阁内耸立弥勒菩萨巨像为雍和宫镇寺之宝。 This 25-metre-high pavilion houses the colossal Maitreya statue, the temple''s greatest treasure.<br>- **长文描述 / Description：** 万福阁是雍和宫最北端的主体建筑，始建于乾隆十五年（1750年），高约二十五米，飞檐三层，气势磅礴，为雍和宫最高建筑。阁内正中供奉一尊白檀木雕弥勒菩萨站像，由尼泊尔赠予一整根巨型白檀木雕琢而成，通高二十六米，其中地上十八米、地下八米，身围八米，为世界最大的独木雕佛之一，被列入吉尼斯世界纪录，是雍和宫"三绝"之首。万福阁两侧以飞廊与永康阁、延宁阁相连，形成"三阁并立"的壮观格局。站在万福阁前仰望弥勒巨像，宝相庄严，令人震撼敬畏，是雍和宫参观的高潮所在。</p><p>  Wanfu Pavilion, the principal building at the northern end of the Lama Temple, was built in 1750 (the fifteenth year of Qianlong). Rising about twenty-five metres with triple flying eaves, it is the tallest structure in the complex. At its centre stands a statue of Maitreya carved from a single piece of white sandalwood gifted by Nepal. The figure is twenty-six metres tall in total—eighteen metres above ground and eight metres below—with a girth of eight metres, making it one of the largest single-log Buddhist carvings in the world and an entry in the Guinness World Records, the foremost of the temple''s "Three Wonders." Flanking the pavilion, flying galleries connect it to the Yongkang and Yanning pavilions, creating a spectacular tripartite complex. Gazing up at the colossal Maitreya from the foot of the hall, its overwhelming and awe-inspiring presence marks the climax of any visit to the Lama Temple.<br>- **详细地址 / Address：** 北京市东城区雍和宫大街12号（雍和宫最北端主体建筑） / 12 Yonghe Temple Avenue, Dongcheng District, Beijing (main building at the northern end of the Lama Temple)<br>- **门票信息 / Ticket Information：** 门票25元，含全寺参观 / Admission 25 yuan, including the whole temple<br>- **开放时间 / Opening Hours：** 11月至3月9:00–16:30；4月至10月9:00–17:00 / November–March 9:00–16:30; April–October 9:00–17:00<br>- **交通信息 / Transportation：** 地铁2/5号线雍和宫站，步行约350米（寺院最深处）/ Subway Line 2 or 5, Yonghegong station, about a 350-metre walk (the deepest part of the temple)</p><p>---</p>',
  '',
  7,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_lama_temple_bj_sa_09',
  'beijing_lama_temple',
  'guanyin grotto and suicheng hall epilogue',
  '观音洞与绥成殿（结束语） / Guanyin Grotto and Suicheng Hall (Epilogue)',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_lama_temple_bj_sa_09.png',
  '<p>- **名字 / Name：** 观音洞与绥成殿（结束语） / Guanyin Grotto and Suicheng Hall (Epilogue)<br>- **摘要 / Summary：** 万福阁下观音洞与最北绥成殿为朝礼之旅画上圆满句号。 The Guanyin Grotto beneath Wanfu Pavilion and the northernmost Suicheng Hall bring the pilgrimage to a perfect close.<br>- **长文描述 / Description：** 万福阁下方设有观音洞（又称万福阁地宫），洞内供奉白檀木雕观音菩萨像，周围绘有佛教壁画与浮雕，气氛幽静肃穆，是信众祈福许愿的圣地。观音洞的设立赋予万福阁以"上奉弥勒、下供观音"的立体礼拜结构。雍和宫最北端的绥成殿，原名"雅曼达嘎楼"，是全寺最后的一座殿堂，供奉大威德金刚等密宗本尊造像，殿名"绥成"寓意"安定成就"。作为参观雍和宫的"结束语"，从南端牌楼院一路行至此处，自"昭泰"而入，以"绥成"而终，不仅完成了由南至北的空间穿越，更寓意由祈福到圆满的精神升华，为这趟皇家藏传佛寺之旅画上圆满的句号。</p><p>  Beneath Wanfu Pavilion lies the Guanyin Grotto, also called the underground palace of the pavilion. Inside is enshrined a white sandalwood statue of Avalokitesvara, surrounded by Buddhist murals and reliefs in a hushed and solemn atmosphere that makes it a sacred place for the faithful to pray and make vows. The grotto gives Wanfu Pavilion a three-dimensional devotional structure—"Maitreya above, Guanyin below." At the northernmost end of the temple stands Suicheng Hall, originally named the Yamantaka Tower, the final hall of the complex, enshrining esoteric deities such as Vajrabhairava. The name "Suicheng" means "pacification and accomplishment." As the "epilogue" of the visit, the journey from the archway courtyard in the south to this hall in the north—entering through "Zhaotai" and concluding at "Suicheng"—completes not only a south-to-north passage through space but also a spiritual ascent from prayer to fulfilment, bringing the pilgrimage through this royal Tibetan Buddhist monastery to a perfect close.<br>- **详细地址 / Address：** 北京市东城区雍和宫大街12号（雍和宫万福阁地下及最北端绥成殿） / 12 Yonghe Temple Avenue, Dongcheng District, Beijing (beneath Wanfu Pavilion and the northernmost Suicheng Hall of the Lama Temple)<br>- **门票信息 / Ticket Information：** 门票25元，含全寺参观；参观结束后可由北侧出口离寺 / Admission 25 yuan, including the whole temple; exit via the north gate after the visit<br>- **开放时间 / Opening Hours：** 11月至3月9:00–16:30；4月至10月9:00–17:00 / November–March 9:00–16:30; April–October 9:00–17:00<br>- **交通信息 / Transportation：** 参观结束后由北侧出口出寺，步行至地铁2/5号线雍和宫站约400米；或乘公交13、116、117路至雍和宫站 / After the visit, exit via the north gate and walk about 400 m to Subway Line 2 or 5, Yonghegong station; or take bus routes 13, 116 or 117 to Yonghegong</p>',
  '',
  8,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_summer_palace_bj_sa_01',
  'beijing_summer_palace',
  'east palace gate and hall of benevolence and longevity',
  '东宫门与仁寿殿 / East Palace Gate and Hall of Benevolence and Longevity',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_summer_palace_bj_sa_01.png',
  '<p>- **名字 / Name：** 东宫门与仁寿殿 / East Palace Gate and Hall of Benevolence and Longevity<br>- **摘要 / Summary：** 颐和园的正门与清代帝后处理政务的正殿。 The main entrance of the Summer Palace and the principal hall where Qing emperors and empresses handled state affairs.<br>- **长文描述 / Description：** 东宫门是颐和园的正门，建于清乾隆十五年（1750年），门前有铜狮、台阶及云龙石雕，门檐悬"颐和园"三字匾额，相传为光绪帝御笔。进入东宫门后即为仁寿殿，原名"勤政殿"，1860年被英法联军焚毁后重建，慈禧太后改名"仁寿殿"，取《论语》"仁者寿"之意。殿内设有九龙宝座、屏风及珐琅鹤鹿等陈设，是慈禧太后和光绪帝驻园期间召见臣工、处理政务的核心场所。殿前院落中陈列铜龙、铜凤、铜鼎及太湖石，两侧配殿对称排列，庄重威严，是皇家权力在园林中的象征。The East Palace Gate is the main entrance to the Summer Palace, built in 1750 during the Qianlong reign. Bronze lions, stone steps, and cloud-dragon carvings flank the entrance, and the gate bears a plaque reading "Yiheyuan" (Summer Palace), said to be calligraphed by Emperor Guangxu. Inside stands the Hall of Benevolence and Longevity (Renshou Dian), originally called the "Hall of Diligent Administration." Destroyed by Anglo-French forces in 1860 and rebuilt, Empress Dowager Cixi renamed it, drawing from the Confucian Analects: "the benevolent enjoy longevity." The hall contains a nine-dragon throne, screens, and enamel cranes and deer. It was the central venue where Cixi and Emperor Guangxu held audiences and conducted state affairs. Bronze dragons, phoenixes, tripods, and Taihu stones decorate the courtyard, flanked by symmetrically arranged side halls, projecting imperial authority within the garden.<br>- **详细地址 / Address：** 北京市海淀区新建宫门路19号颐和园东宫门 / East Palace Gate, Summer Palace, No. 19 Xinjiangongmen Road, Haidian District, Beijing<br>- **门票信息 / Ticket Information：** 旺季30元/淡季20元（大门门票）；联票旺季60元/淡季50元（含佛香阁、德和园等园中园）/ Peak season 30 RMB / off-season 20 RMB (entrance ticket); combined ticket peak season 60 RMB / off-season 50 RMB (includes Tower of Buddhist Incense, Garden of Virtue and Harmony, etc.)<br>- **开放时间 / Opening Hours：** 旺季（4月–10月）6:30–18:00；淡季（11月–3月）7:00–17:00 / Peak season (April–October) 6:30–18:00; off-season (November–March) 7:00–17:00<br>- **交通信息 / Transportation：** 地铁4号线北宫门站下车步行约5分钟至东宫门；或乘公交331路、332路、346路至颐和园站 / Take Subway Line 4 to Beigongmen Station, walk about 5 minutes to the East Palace Gate; or take bus 331, 332, or 346 to Yiheyuan (Summer Palace) Station</p><p>---</p>',
  '',
  0,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_summer_palace_bj_sa_02',
  'beijing_summer_palace',
  'garden of virtue and harmony',
  '德和园 / Garden of Virtue and Harmony',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_summer_palace_bj_sa_02.png',
  '<p>- **名字 / Name：** 德和园 / Garden of Virtue and Harmony<br>- **摘要 / Summary：** 慈禧太后观戏之所，中国现存最大的皇家戏楼所在地。 The opera venue of Empress Dowager Cixi, housing the largest surviving imperial theater building in China.<br>- **长文描述 / Description：** 德和园位于仁寿殿西北，建成于清光绪十七年（1891年），是专供慈禧太后观戏的园中园，耗资白银71万两修建。园内核心建筑为大戏楼，高21米，三层翘檐，底层舞台宽17米，设有三层戏台及天花板机关，可表演神仙升天、鬼怪入地等特效，是中国现存规模最大、结构最精巧的皇家戏楼。慈禧太后酷爱京剧，每逢生日等节庆便在此连续数日演戏。德和园内还设有扮戏房（后台）和颐乐殿（观戏厅），殿内保留慈禧观戏宝座及珍贵京剧文物，是了解晚清宫廷戏曲文化的重要场所。Built in 1891 and located northwest of the Hall of Benevolence and Longevity, the Garden of Virtue and Harmony (Dehe Yuan) was a garden-within-a-garden dedicated to opera performances for Empress Dowager Cixi, constructed at a cost of 710,000 taels of silver. Its centerpiece is the Grand Theater Building, 21 meters tall with three upturned eaves. The ground-floor stage spans 17 meters, and the three-tiered stage features mechanical devices for spectacular effects—deities ascending to heaven and demons descending underground. It is the largest and most ingeniously structured surviving imperial theater in China. Cixi was an avid Peking Opera enthusiast, staging performances for days during birthdays and festivals. The complex also includes a backstage dressing area and the Yile Hall (viewing hall), preserving Cixi''s opera-viewing throne and precious Peking Opera artifacts.<br>- **详细地址 / Address：** 北京市海淀区颐和园内仁寿殿西北 / Northwest of Hall of Benevolence and Longevity, Summer Palace, Haidian District, Beijing<br>- **门票信息 / Ticket Information：** 含于颐和园联票内（旺季60元/淡季50元）；单独参观需购园中园票10元 / Included in Summer Palace combined ticket (peak 60 RMB / off-season 50 RMB); separate garden-within-garden ticket 10 RMB<br>- **开放时间 / Opening Hours：** 旺季（4月–10月）8:30–17:30；淡季（11月–3月）9:00–16:30 / Peak season (April–October) 8:30–17:30; off-season (November–March) 9:00–16:30<br>- **交通信息 / Transportation：** 由东宫门进入后沿主路北行约300米即达；地铁4号线北宫门站步行至东宫门 / Enter through the East Palace Gate and walk north along the main path for about 300 meters; accessible via Subway Line 4 Beigongmen Station to East Palace Gate</p><p>---</p>',
  '',
  1,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_summer_palace_bj_sa_03',
  'beijing_summer_palace',
  'hall of jade ripples and hall of joyful longevity',
  '玉澜堂与乐寿堂 / Hall of Jade Ripples and Hall of Joyful Longevity',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_summer_palace_bj_sa_03.png',
  '<p>- **名字 / Name：** 玉澜堂与乐寿堂 / Hall of Jade Ripples and Hall of Joyful Longevity<br>- **摘要 / Summary：** 光绪帝被囚之所与慈禧太后颐养寝宫。 The prison quarters of Emperor Guangxu and the residential quarters of Empress Dowager Cixi.<br>- **长文描述 / Description：** 玉澜堂位于昆明湖东北岸，始建于乾隆年间，原为帝后游览休憩之所。1898年戊戌变法失败后，慈禧太后将光绪帝软禁于此，堂内东西配殿均砌死砖墙以隔绝内外，至今墙迹犹存，成为近代中国政治悲剧的历史见证。乐寿堂紧邻玉澜堂西，是慈禧太后在颐和园的寝宫，意为"智者乐，仁者寿"。堂内正间设慈禧宝座与沉香木插屏，慈禧在此接受朝贺、进膳品茗。庭院陈列铜鹿、铜鹤、铜瓶，取"六合太平"之意，另有玉兰、海棠、牡丹，寓意"玉堂富贵"。堂前可远眺昆明湖，视野开阔，为颐和园政治与生活场景的核心区域。The Hall of Jade Ripples (Yulan Tang), on the northeastern shore of Kunming Lake, was originally built during the Qianlong reign as a resting place for the imperial family. After the failure of the 1898 Hundred Days'' Reform, Empress Dowager Cixi placed Emperor Guangxu under house arrest here. The east and west side rooms were sealed with brick walls to isolate him—traces of which remain visible today, making the hall a historical witness to a political tragedy in modern China. The Hall of Joyful Longevity (Leshou Tang), immediately west, was Cixi''s residential quarters in the Summer Palace. Its name means "the wise find joy, the benevolent enjoy longevity." The central room contains Cixi''s throne and an agarwood screen, where she received congratulations, dined, and took tea. Bronze deer, cranes, and vases in the courtyard symbolize universal peace, while magnolia, crabapple, and peony represent "wealth and honor in the jade hall."<br>- **详细地址 / Address：** 北京市海淀区颐和园内昆明湖东北岸 / Northeastern shore of Kunming Lake, Summer Palace, Haidian District, Beijing<br>- **门票信息 / Ticket Information：** 含于颐和园大门门票内（旺季30元/淡季20元），无需另购园中园票 / Included in Summer Palace entrance ticket (peak 30 RMB / off-season 20 RMB); no separate garden-within-garden ticket required<br>- **开放时间 / Opening Hours：** 旺季（4月–10月）8:30–17:30；淡季（11月–3月）9:00–16:30 / Peak season (April–October) 8:30–17:30; off-season (November–March) 9:00–16:30<br>- **交通信息 / Transportation：** 由东宫门入沿主路西行至乐寿堂；玉澜堂在乐寿堂东侧；地铁4号线北宫门站至东宫门 / Enter through East Palace Gate and walk west along the main path to Leshou Tang; Yulan Tang is just east of Leshou Tang; accessible via Subway Line 4 Beigongmen Station</p><p>---</p>',
  '',
  2,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_summer_palace_bj_sa_04',
  'beijing_summer_palace',
  'long corridor',
  '长廊 / Long Corridor',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_summer_palace_bj_sa_04.png',
  '<p>- **名字 / Name：** 长廊 / Long Corridor<br>- **摘要 / Summary：** 世界最长的画廊，14000余幅彩绘横贯万寿山南麓。 The world''s longest painted gallery, with over 14,000 paintings stretching along the southern foot of Longevity Hill.<br>- **长文描述 / Description：** 长廊东起邀月门，西至石丈亭，全长728米，共273间，是中国现存最长、彩绘最丰富的园林画廊，1992年被收入《吉尼斯世界纪录》。长廊始建于乾隆十五年（1750年），1860年被英法联军焚毁后于光绪年间重建。廊内梁枋上绘有苏式彩画14000余幅，内容涵盖山水花鸟、人物典故、古典文学名篇及民间传说，如《西游记》《三国演义》《红楼梦》等经典场景，堪称一座露天的中国传统绘画博物馆。长廊依山傍水，四季景致各异，四座八角重檐亭——留佳、寄澜、秋水、清遥——分踞其间，象征春夏秋冬四季，是颐和园最为经典的游览线路。Stretching from the Moon-Inviting Gate in the east to the Stone Old Man Pavilion in the west, the Long Corridor (Changlang) is 728 meters long with 273 bays. It is the longest and most richly painted garden corridor in China, earning a Guinness World Record in 1992. Originally built in 1750 during the Qianlong reign, it was destroyed by Anglo-French forces in 1860 and rebuilt during the Guangxu reign. Over 14,000 Suzhou-style paintings decorate the beams, depicting landscapes, flora and fauna, historical figures, classical literature scenes from "Journey to the West," "Romance of the Three Kingdoms," and "Dream of the Red Chamber," and folk legends—an open-air museum of Chinese traditional painting. The corridor runs between mountain and water with seasonal views. Four octagonal double-eave pavilions—Liujia, Jilan, Qiushui, and Qingyao—mark the four seasons along its length.<br>- **详细地址 / Address：** 北京市海淀区颐和园内万寿山南麓 / Southern foot of Longevity Hill, Summer Palace, Haidian District, Beijing<br>- **门票信息 / Ticket Information：** 含于颐和园大门门票内（旺季30元/淡季20元），无需另购票 / Included in Summer Palace entrance ticket (peak 30 RMB / off-season 20 RMB); no additional ticket required<br>- **开放时间 / Opening Hours：** 随颐和园开放，旺季6:30–18:00；淡季7:00–17:00 / Open with the Summer Palace: peak season 6:30–18:00; off-season 7:00–17:00<br>- **交通信息 / Transportation：** 由东宫门入经仁寿殿、玉澜堂后西行即达长廊东端邀月门；或由北宫门入南下至排云殿后东行 / Enter via East Palace Gate, pass through Renshou Hall and Yulan Tang, walk west to the Moon-Inviting Gate at the corridor''s east end; or enter via North Palace Gate, descend south to Paiyun Hall and walk east</p><p>---</p>',
  '',
  3,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_summer_palace_bj_sa_05',
  'beijing_summer_palace',
  'hall of dispelling clouds tower of buddhist incense and sea of wisdom',
  '排云殿、佛香阁与智慧海 / Hall of Dispelling Clouds, Tower of Buddhist Incense and Sea of Wisdom',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_summer_palace_bj_sa_05.png',
  '<p>- **名字 / Name：** 排云殿、佛香阁与智慧海 / Hall of Dispelling Clouds, Tower of Buddhist Incense and Sea of Wisdom<br>- **摘要 / Summary：** 万寿山中轴线上的核心建筑群，颐和园最壮观的礼佛与朝政中心。 The central architectural complex on Longevity Hill, the most spectacular ceremonial and Buddhist center of the Summer Palace.<br>- **长文描述 / Description：** 排云殿、佛香阁与智慧海构成万寿山中轴线上自南向北递升的核心建筑群。排云殿坐落于中轴线下段，原名"大报恩延寿寺"，慈禧太后重建后改为朝政正殿，取郭璞诗"神仙排云出，但见金银台"之意，殿内设慈禧宝座，是其在园中举行万寿庆典的场所。佛香阁雄踞万寿山中段高21米的石台之上，为八面三层四重檐阁楼，高36.44米，是颐和园标志性建筑。阁内供奉明代铜铸千手观音，高5米，堪称佛教造像精品。智慧海位于万寿山顶，为无梁殿结构，通体用五彩琉璃砖砌成，外壁嵌满琉璃佛像，意为"佛智慧如海"，是全园最高点，可俯瞰昆明湖全景。These three structures form the central complex ascending from south to north along Longevity Hill''s central axis. The Hall of Dispelling Clouds (Paiyun Dian) occupies the lower section. Originally the "Great Temple of Repaying Kindness and Extending Longevity," it was converted into a ceremonial hall by Cixi, named after a line by poet Guo Pu: "immortals emerge from the clouds, revealing halls of gold and silver." Its throne was used for Cixi''s birthday celebrations. The Tower of Buddhist Incense (Foxiang Ge) stands on a 21-meter stone platform mid-hill—a three-tiered, four-eave octagonal tower 36.44 meters tall, the iconic landmark of the Summer Palace. Inside is a Ming Dynasty bronze Thousand-Handed Guanyin, five meters tall. The Sea of Wisdom (Zhihui Hai) crowns the hilltop, a beamless hall built entirely of multicolored glazed tiles with embedded Buddha images, meaning "the Buddha''s wisdom is as vast as the sea." As the highest point, it offers panoramic views of Kunming Lake.<br>- **详细地址 / Address：** 北京市海淀区颐和园内万寿山中轴线 / Central axis of Longevity Hill, Summer Palace, Haidian District, Beijing<br>- **门票信息 / Ticket Information：** 佛香阁需购园中园票10元（含于联票旺季60元/淡季50元内）；排云殿、智慧海含于大门门票 / Tower of Buddhist Incense requires garden-within-garden ticket 10 RMB (included in combined ticket); Hall of Dispelling Clouds and Sea of Wisdom included in entrance ticket<br>- **开放时间 / Opening Hours：** 佛香阁旺季9:00–16:30，淡季9:00–16:00；排云殿随园开放；智慧海随园开放 / Tower of Buddhist Incense: peak season 9:00–16:30, off-season 9:00–16:00; Hall of Dispelling Clouds and Sea of Wisdom open with the park<br>- **交通信息 / Transportation：** 由长廊中段北行经排云门进入排云殿院落，拾阶而上至佛香阁，再上行至智慧海；或由北宫门入南下至智慧海 / From the middle of the Long Corridor, walk north through the Paiyun Gate to the Hall of Dispelling Clouds, climb steps to the Tower of Buddhist Incense, then continue up to the Sea of Wisdom; or enter via North Palace Gate and walk south to the Sea of Wisdom</p><p>---</p>',
  '',
  4,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_summer_palace_bj_sa_06',
  'beijing_summer_palace',
  'marble boat',
  '石舫 / Marble Boat',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_summer_palace_bj_sa_06.png',
  '<p>- **名字 / Name：** 石舫 / Marble Boat<br>- **摘要 / Summary：** 昆明湖上的清代石造画舫，寓意"江山永固"的标志性景观。 A Qing Dynasty stone boat on Kunming Lake, symbolizing eternal stability of the empire.<br>- **长文描述 / Description：** 石舫位于长廊西端昆明湖畔，原名"清晏舫"，始建于乾隆二十年（1755年），是中国现存最大的古代石造园林船型建筑。石舫通体用巨石雕砌，长36米，船体用青石雕成，舱楼为木质结构，采用西方彩色玻璃窗与中国传统歇山顶相结合的装饰风格，反映了乾隆时期中西合璧的审美趣味。据传乾隆帝取唐魏征"水能载舟，亦能覆舟"之典，以石舫寓意清朝江山坚如磐石、永不动摇。1860年石舫舱楼被英法联军焚毁，光绪十九年（1893年）重建时改为现存样式，增饰大理石纹与花砖。石舫是颐和园西部水域的视觉焦点，也是游人合影留念的经典地标。The Marble Boat (Qingyan Fang, "Boat of Purity and Peace") stands at the western end of the Long Corridor on the shore of Kunming Lake. Built in 1755 during the Qianlong reign, it is the largest surviving ancient stone boat-shaped garden structure in China. Carved entirely from massive stone blocks, it measures 36 meters long. The hull is made of grey stone, while the cabin was originally wood, combining Western stained-glass windows with a traditional Chinese gabled roof, reflecting the Qianlong era''s fusion of Chinese and Western aesthetics. According to legend, Emperor Qianlong drew on the classical admonition by Tang minister Wei Zheng—"water can carry a boat, but can also overturn it"—using the stone boat to symbolize the eternal, unshakeable stability of the Qing Empire. The cabin was burned by Anglo-French forces in 1860 and rebuilt in 1893 with its current marble patterns and decorative tiles. The Marble Boat is a visual focal point of the western lake area and a classic photo landmark.<br>- **详细地址 / Address：** 北京市海淀区颐和园内长廊西端昆明湖畔 / Western end of Long Corridor, shore of Kunming Lake, Summer Palace, Haidian District, Beijing<br>- **门票信息 / Ticket Information：** 含于颐和园大门门票内（旺季30元/淡季20元），无需另购票 / Included in Summer Palace entrance ticket (peak 30 RMB / off-season 20 RMB); no additional ticket required<br>- **开放时间 / Opening Hours：** 随颐和园开放，旺季6:30–18:00；淡季7:00–17:00 / Open with the Summer Palace: peak season 6:30–18:00; off-season 7:00–17:00<br>- **交通信息 / Transportation：** 由长廊西行至尽头即达；或由北宫门入沿后山小路西行至昆明湖畔 / Walk west along the Long Corridor to its western terminus; or enter via North Palace Gate and take the hill path west to the Kunming Lake shore</p><p>---</p>',
  '',
  5,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_summer_palace_bj_sa_07',
  'beijing_summer_palace',
  'kunming lake',
  '昆明湖 / Kunming Lake',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_summer_palace_bj_sa_07.png',
  '<p>- **名字 / Name：** 昆明湖 / Kunming Lake<br>- **摘要 / Summary：** 颐和园的主体水面，占全园面积四分之三，仿西湖而建的皇家湖泊。 The principal water body of the Summer Palace, covering three-quarters of the park area, a royal lake modeled on West Lake.<br>- **长文描述 / Description：** 昆明湖是颐和园的核心水面，面积达220公顷，占全园总面积的四分之三，是北京城内最大的人工湖泊。湖水源于玉泉山和瓮山泊，乾隆十五年（1750年）疏浚扩建，取汉武帝在长安开凿昆明池操练水军之典，命名为"昆明湖"。湖面以万寿山为背景，分为东湖、西湖和北湖三个水域，湖中设有西堤六桥，仿杭州西湖苏堤而建，堤上桃柳相间，烟波浩渺，宛如江南。湖面波光粼粼，春夏荷花盛开，秋冬芦苇苍苍，四季风光各异。游人可乘画舫游船环湖观光，从水上视角感受皇家园林的恢弘气度，是颐和园游览中不可错过的亲水体验。Kunming Lake is the core water body of the Summer Palace, covering 220 hectares—three-quarters of the total park area—and is the largest artificial lake in Beijing. Fed by springs from Yuquan Mountain and Wengshan Lake, it was dredged and expanded in 1750. Emperor Qianlong named it after the Kunming Pool that Emperor Wu of Han dug in Chang''an to train his navy. With Longevity Hill as its backdrop, the lake is divided into three zones: East Lake, West Lake, and North Lake. The West Causeway with its six bridges imitates the Su Causeway of West Lake in Hangzhou, lined with peach and willow trees, evoking the misty charm of Jiangnan. The lake shimmers in every season—lotus blooms in summer, reeds sway in winter. Visitors can take painted boats to cruise the lake and experience the grandeur of the imperial garden from the water.<br>- **详细地址 / Address：** 北京市海淀区颐和园内万寿山南 / South of Longevity Hill, Summer Palace, Haidian District, Beijing<br>- **门票信息 / Ticket Information：** 含于颐和园大门门票内（旺季30元/淡季20元）；游船另收费，画舫单程10–20元 / Included in Summer Palace entrance ticket (peak 30 RMB / off-season 20 RMB); boat rides extra, painted ferry 10–20 RMB one-way<br>- **开放时间 / Opening Hours：** 随颐和园开放，旺季6:30–18:00；淡季7:00–17:00；游船9:00–16:30运营 / Open with the Summer Palace: peak season 6:30–18:00; off-season 7:00–17:00; boat service 9:00–16:30<br>- **交通信息 / Transportation：** 由东宫门入经乐寿堂南行至湖畔；游船码头分布于排云殿前、铜牛旁及南湖岛等处 / Enter via East Palace Gate, pass Leshou Tang and walk south to the lakeshore; boat piers are located near Paiyun Hall, the Bronze Ox, and South Lake Island</p><p>---</p>',
  '',
  6,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_summer_palace_bj_sa_08',
  'beijing_summer_palace',
  'seventeen arch bridge and south lake island',
  '十七孔桥与南湖岛 / Seventeen-Arch Bridge and South Lake Island',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_summer_palace_bj_sa_08.png',
  '<p>- **名字 / Name：** 十七孔桥与南湖岛 / Seventeen-Arch Bridge and South Lake Island<br>- **摘要 / Summary：** 昆明湖上的皇家石桥与湖中仙境岛屿，颐和园水景精华。 The royal stone bridge and island paradise on Kunming Lake, the highlight of the Summer Palace waterscape.<br>- **长文描述 / Description：** 十七孔桥横跨昆明湖东堤至南湖岛，建于清乾隆年间（1736–1795年），全长150米，宽8米，由17个桥洞组成，因桥洞数取"九"为阳数之极，两侧各九孔，中孔合"九"之意，寓意皇家至尊。桥身用汉白玉砌筑，桥栏雕有544只形态各异的石狮，数量超过卢沟桥，造型生动。桥东西两端各有碑亭与镇水铜牛。南湖岛位于昆明湖中心，象征东海三仙山中的蓬莱仙岛，岛上建有涵虚堂、龙王庙等建筑，是帝后观赏湖景、祭祀龙王之所。每年冬至前后，夕阳穿过十七孔桥洞，金光万道，形成著名的"金光穿洞"奇观，吸引无数游客与摄影爱好者。The Seventeen-Arch Bridge spans from the East Causeway to South Lake Island on Kunming Lake, built during the Qianlong reign (1736–1795). It is 150 meters long and 8 meters wide, with 17 arches. The arch count derives from the number nine—the supreme yang number—with nine arches on each side of the central arch, symbolizing imperial supremacy. The bridge is built of white marble, and its railings are carved with 544 stone lions in diverse postures—more than the Marco Polo Bridge—each vividly rendered. Stele pavilions and a bronze ox stand at the east and west ends. South Lake Island, at the center of Kunming Lake, symbolizes Penglai, the immortal isle of Eastern Sea legend. Buildings on the island include the Hanxu Hall and Dragon King Temple, where the imperial family viewed the lake and worshipped the Dragon King. Around the winter solstice, the setting sun shines through the bridge arches, creating the spectacular "Golden Light through the Arches" phenomenon that draws countless visitors and photographers.<br>- **详细地址 / Address：** 北京市海淀区颐和园内昆明湖东部 / Eastern part of Kunming Lake, Summer Palace, Haidian District, Beijing<br>- **门票信息 / Ticket Information：** 含于颐和园大门门票内（旺季30元/淡季20元），无需另购票 / Included in Summer Palace entrance ticket (peak 30 RMB / off-season 20 RMB); no additional ticket required<br>- **开放时间 / Opening Hours：** 随颐和园开放，旺季6:30–18:00；淡季7:00–17:00 / Open with the Summer Palace: peak season 6:30–18:00; off-season 7:00–17:00<br>- **交通信息 / Transportation：** 由新建宫门（南门）入北行至昆明湖东堤即达十七孔桥；或由东宫门入沿湖东岸南行 / Enter via Xinjiangongmen (South Gate) and walk north along the East Causeway to the bridge; or enter via East Palace Gate and walk south along the eastern lake shore</p><p>---</p>',
  '',
  7,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_summer_palace_bj_sa_09',
  'beijing_summer_palace',
  'bronze ox',
  '铜牛 / Bronze Ox',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_summer_palace_bj_sa_09.png',
  '<p>- **名字 / Name：** 铜牛 / Bronze Ox<br>- **摘要 / Summary：** 昆明湖东岸的镇水铜铸神牛，铭刻乾隆治水宏愿。 A bronze ox on the eastern shore of Kunming Lake, inscribed with Emperor Qianlong''s vow to control the waters.<br>- **长文描述 / Description：** 铜牛位于昆明湖东岸十七孔桥北侧，铸于清乾隆二十年（1755年），是用青铜铸造的卧牛像，长1.75米，宽0.8米，高1.15米，昂首蜷卧于石座之上，形态逼真，工艺精湛。牛背上篆刻乾隆御笔《金牛铭》，共80字，记述铸造铜牛的缘由与祈愿，取古代以铁牛镇水防洪的传统。乾隆帝将昆明湖比作银河，以铜牛隐喻天上牛郎星，寄托风调雨顺、江山安澜的理想。铜牛与万寿山、昆明湖交相辉映，既是皇家园林的镇水灵物，也是中国古代水利文化的重要见证，是颐和园标志性的文物景观之一。The Bronze Ox stands on the eastern shore of Kunming Lake, north of the Seventeen-Arch Bridge. Cast in 1755 during the Qianlong reign, it is a reclining bronze ox measuring 1.75 meters long, 0.8 meters wide, and 1.15 meters high. It lies on a stone base with head raised, lifelike and masterfully crafted. An 80-character inscription in seal script, the "Golden Ox Inscription" composed by Emperor Qianlong, is carved on its back, recording the reason for casting and the emperor''s prayers. It follows the ancient tradition of using iron oxen to suppress floods. Qianlong compared Kunming Lake to the Milky Way and the bronze ox to the Altair star, expressing his wish for favorable weather and a peaceful realm. The ox complements Longevity Hill and Kunming Lake, serving as both a guardian spirit of the imperial garden and an important witness to Chinese hydraulic culture.<br>- **详细地址 / Address：** 北京市海淀区颐和园内昆明湖东岸 / Eastern shore of Kunming Lake, Summer Palace, Haidian District, Beijing<br>- **门票信息 / Ticket Information：** 含于颐和园大门门票内（旺季30元/淡季20元），无需另购票 / Included in Summer Palace entrance ticket (peak 30 RMB / off-season 20 RMB); no additional ticket required<br>- **开放时间 / Opening Hours：** 随颐和园开放，旺季6:30–18:00；淡季7:00–17:00 / Open with the Summer Palace: peak season 6:30–18:00; off-season 7:00–17:00<br>- **交通信息 / Transportation：** 由新建宫门（南门）入沿东堤北行至十七孔桥前即见铜牛；或由东宫门入沿湖岸南行至东堤 / Enter via Xinjiangongmen (South Gate), walk north along the East Causeway to just before the Seventeen-Arch Bridge; or enter via East Palace Gate and walk south along the lakeshore to the East Causeway</p><p>---</p>',
  '',
  8,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, cover_image_path, body, audio_url, sort_order, is_active, requires_purchase
) VALUES (
  'beijing_summer_palace_bj_sa_10',
  'beijing_summer_palace',
  'newly built palace gate concluding remarks',
  '新建宫门 / Newly Built Palace Gate (Concluding Remarks)',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/sub-areas/beijing/beijing_summer_palace_bj_sa_10.png',
  '<p>- **名字 / Name：** 新建宫门 / Newly Built Palace Gate<br>- **摘要 / Summary：** 颐和园南门，游览行程的圆满终点与世界遗产的深情回望。 The South Gate of the Summer Palace, a fitting endpoint of the visit and a reflective farewell to a World Heritage site.<br>- **长文描述 / Description：** 新建宫门是颐和园的南门，建于清光绪年间，因晚于东宫门等其他宫门修建而得名。门面阔三间，歇山顶，前后出廊，虽规模不及东宫门宏伟，但门前景色开阔，是观赏昆明湖全景与十七孔桥的最佳起点之一。新建宫门是颐和园环湖游览路线的重要门户，由此进入可北行沿东堤直达铜牛、十七孔桥与南湖岛，也可西行经西堤六桥感受仿西湖的江南意境。游览至此，回望万寿山佛香阁层叠的楼阁与昆明湖浩渺的波光，皇家园林集造园艺术之大成的恢弘气象尽收眼底。新建宫门作为颐和园游览的最后一站，不仅是一扇出入之门，更是一段穿越数百年的历史与文化的深情告别。The Newly Built Palace Gate (Xinjiangongmen) is the South Gate of the Summer Palace, constructed during the Guangxu reign. It was named for being built later than the East Palace Gate and other entrances. The gate has three bays with a gabled roof and front and rear corridors. Though less grand than the East Palace Gate, its open foreground offers one of the best vantage points for viewing Kunming Lake and the Seventeen-Arch Bridge. It is a key portal for the circular lake tour: heading north along the East Causeway leads to the Bronze Ox, Seventeen-Arch Bridge, and South Lake Island, while heading west along the West Causeway''s six bridges evokes the scenery of Hangzhou''s West Lake. Arriving here, looking back at the tiered pavilions of the Tower of Buddhist Incense on Longevity Hill and the vast expanse of Kunming Lake, the magnificent synthesis of garden art is fully revealed. As the final stop, this gate is not merely an entrance or exit, but a fond farewell to centuries of history and culture.<br>- **详细地址 / Address：** 北京市海淀区新建宫门路19号颐和园南门 / South Gate, Summer Palace, No. 19 Xinjiangongmen Road, Haidian District, Beijing<br>- **门票信息 / Ticket Information：** 含于颐和园大门门票内（旺季30元/淡季20元）；由此门出入无需另购票 / Included in Summer Palace entrance ticket (peak 30 RMB / off-season 20 RMB); no additional ticket for entry or exit through this gate<br>- **开放时间 / Opening Hours：** 旺季（4月–10月）6:30–18:00；淡季（11月–3月）7:00–17:00 / Peak season (April–October) 6:30–18:00; off-season (November–March) 7:00–17:00<br>- **交通信息 / Transportation：** 地铁4号线北宫门站下车后步行约15分钟至新建宫门；或乘公交374路、437路至颐和园新建宫门站直达 / Take Subway Line 4 to Beigongmen Station and walk about 15 minutes to the South Gate; or take bus 374 or 437 to Yiheyuan Xinjiangongmen (Summer Palace South Gate) Station</p><p>---</p><p>&gt; **游览建议 / Visiting Tips：**<br>&gt; - 推荐游览路线：东宫门→仁寿殿→德和园→玉澜堂→乐寿堂→长廊→排云殿→佛香阁→智慧海→石舫→昆明湖（乘船）→铜牛→十七孔桥→南湖岛→新建宫门出，全程约4–5小时。<br>&gt; - Recommended route: East Palace Gate → Hall of Benevolence and Longevity → Garden of Virtue and Harmony → Hall of Jade Ripples → Hall of Joyful Longevity → Long Corridor → Hall of Dispelling Clouds → Tower of Buddhist Incense → Sea of Wisdom → Marble Boat → Kunming Lake (boat ride) → Bronze Ox → Seventeen-Arch Bridge → South Lake Island → exit via Newly Built Palace Gate. Allow 4–5 hours.<br>&gt; - 联票含佛香阁、德和园等园中园，性价比高，建议于官方平台或售票处购买。<br>&gt; - Combined tickets include garden-within-garden sites such as the Tower of Buddhist Incense and Garden of Virtue and Harmony; purchase at the official platform or ticket office.<br>&gt; - 万寿山至昆明湖高差较大，建议穿舒适鞋履；夏季注意防晒补水，冬季湖面寒风较大，注意保暖。<br>&gt; - Significant elevation changes between Longevity Hill and Kunming Lake—wear comfortable shoes; protect against sun in summer and dress warmly against lake winds in winter.</p>',
  '',
  9,
  TRUE,
  FALSE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  cover_image_path = EXCLUDED.cover_image_path,
  body = EXCLUDED.body,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  requires_purchase = EXCLUDED.requires_purchase,
  updated_at = NOW();
