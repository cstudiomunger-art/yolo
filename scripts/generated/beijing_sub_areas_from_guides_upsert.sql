-- Generated Beijing sub_areas from Desktop 景点导览 markdown
-- Updates text fields only; preserves existing cover_image_path and audio_url
-- Generated: 2026-07-08T06:53:03.351Z
-- Total sub_areas: 81

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_lama_temple_bj_sa_01',
  'beijing_lama_temple',
  'Archway Courtyard and Zhaotai Gate',
  '牌楼院与昭泰门',
  '<p>The archway courtyard at the southernmost end of the Lama Temple serves as the processional forecourt of the entire complex. It comprises three grand glazed-tile archways: the central one inscribed "Revered by All within the Four Seas" and the flanking ones inscribed "Compassionate Majesty" and "Blessings Flowing to the Sands," all in the calligraphy of the Qianlong Emperor. Crowned with yellow and green glazed tiles, the archways feature intricate bracket sets, flying eaves and painted beams that proclaim the dignity of a royal monastery. Passing northward through the courtyard, visitors reach Zhaotai Gate, hung with a plaque reading "Yonghe Gate," the first threshold into the heart of the temple. The ground rises gently from south to north, creating a sequence that leads from the secular to the sacred, so that the moment one steps through Zhaotai Gate a solemn and serene religious atmosphere is felt.</p>',
  0,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_lama_temple_bj_sa_02',
  'beijing_lama_temple',
  'Bell and Drum Towers and the Hall of the Heavenly Kings',
  '钟鼓楼与天王殿',
  '<p>After entering Zhaotai Gate, the Bell Tower stands to the east and the Drum Tower to the west, marking the traditional "morning bell and evening drum" timekeeping of Buddhist monasteries. A bronze bell hangs in the Bell Tower and a large drum stands in the Drum Tower, continuing the layout inherited from Han-Chinese Buddhist temples. Directly to the north between the two towers stands the Hall of the Heavenly Kings. At its centre is enshrined the Cloth-Sack Maitreya, the pot-bellied Buddha with a beaming smile, symbolising the boundless capacity to embrace what is difficult to embrace. Behind Maitreya stands Skanda, the Dharma-protecting general holding a demon-subduing staff. Along the east and west walls are the Four Heavenly Kings—Virudhaka of the East, Virulaka of the South, Virupaksa of the West and Vaisravana of the North—each grasping a ritual implement, awe-inspiring and majestic, guardians of the four directions of Mount Sumeru and the core of the temple''s protective sequence.</p>',
  1,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_lama_temple_bj_sa_03',
  'beijing_lama_temple',
  'Stele Pavilion of "On Lamaism" and the Bronze Mount Sumeru',
  '喇嘛说碑亭与铜铸须弥山',
  '<p>Beyond the Hall of the Heavenly Kings stands the Imperial Stele Pavilion, housing a stone stele inscribed in 1792 (the fifty-seventh year of Qianlong) with the emperor''s essay "On Lamaism." Carved in Manchu, Chinese, Mongolian and Tibetan on its four faces, the text articulates Qing policy toward Tibetan Buddhism and the governing strategy that "promoting the Yellow Teaching pacifies the Mongols," making it a crucial document for the study of Qing ethnic and religious policy. North of the pavilion stands a bronze Mount Sumeru, believed to date from the Ming dynasty. Modelled on the Buddhist cosmos, it represents Mount Sumeru at the centre, encircled by the sun and moon, with the four great continents and eight minor continents arranged around it. Exquisitely crafted and rich in symbolism, it is a three-dimensional distillation of the Tibetan Buddhist worldview.</p>',
  2,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_lama_temple_bj_sa_04',
  'beijing_lama_temple',
  'Yonghe Palace (Mahavira Hall)',
  '雍和宫殿·大雄宝殿',
  '<p>Yonghe Palace is the main hall of the temple, originally the Silver An Hall of Prince Yong''s mansion before its conversion into a Buddhist sanctuary. It thus combines the grand scale of princely architecture with the solemnity of a Buddhist hall. At its centre are enshrined the Three Buddhas of the Three Times: Dipankara (the past), Shakyamuni (the present) and Maitreya (the future), their golden images serene and majestic. Along the sides stand the Eighteen Arhats, each in a distinct and lifelike posture. The spacious moon terrace in front is flanked by side halls dedicated to Guan Yu and Guanyin, reflecting the fusion of Han and Tibetan culture. The roof is covered with yellow glazed tiles trimmed in green—the imperial rank of roofing—and the painted beams are ornamented throughout with dragon and phoenix motifs, proclaiming the royal splendour of this "blessed land of the dragon."</p>',
  3,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_lama_temple_bj_sa_05',
  'beijing_lama_temple',
  'Yongyou Hall',
  '永佑殿',
  '<p>Yongyou Hall was originally the bedchamber of Prince Yong''s mansion. After the Yongzheng Emperor''s death his coffin rested here, and the name "Yongyou," meaning "eternal blessing," expresses the imperial family''s remembrance and prayers for the late emperor. At the centre of the hall is Amitayus (Amitabha), flanked by the Medicine Buddha and the Lion''s Roar Buddha. The images are solemn and exquisitely crafted, all fine works of Qing court sculpture. Also displayed are a "Fu" (blessing) character brushed by the Qianlong Emperor for his father and sandalwood arhat figures. As one of the temple''s central halls, Yongyou preserves the layout of a princely bedchamber and bears witness to the transformation of the mansion into a monastery, while remaining a place where the faithful gather to chant and pray.</p>',
  4,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_lama_temple_bj_sa_06',
  'beijing_lama_temple',
  'Four Monastic Colleges (Dratsang)',
  '四大扎仓',
  '<p>As the central Gelugpa monastery in the capital, the Lama Temple houses four dratsang (monastic colleges): the Exoteric College for the study of sutra, the Esoteric College for tantra and ritual, the Medical College for Tibetan medicine and pharmacology, and the Kalacakra College for astronomy and calendrical calculation. Set within the side halls on the east and west of the temple, each college enshrines its respective tutelary deity and displays scriptures, ritual implements and teaching materials. Historically, monks studied here for many years, and after rigorous debate examinations were awarded the Geshe degree, making the temple a key institution for training senior Tibetan Buddhist clergy. This tradition continues today, so that the temple is not merely a royal monastery but an important centre of Tibetan Buddhist scholarship and religious education.</p>',
  5,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_lama_temple_bj_sa_07',
  'beijing_lama_temple',
  'Falun Hall (Wheel of the Law Hall)',
  '法轮殿',
  '<p>Falun Hall is the ritual centre of the Lama Temple, where major religious ceremonies are held. Its architecture fuses Han and Tibetan styles, and the roof is crowned with five skylight pavilions symbolising the five major schools of Tibetan Buddhism. At the centre is a six-metre bronze statue of Tsongkhapa, founder of the Gelug school, flanked by his two chief disciples, Khedrup Je and Gyaltsab Je. To the west stands Shakyamuni, and to the east, Avalokitesvara. The hall''s most celebrated treasure is the "Mountain of Five Hundred Arhats," carved from red sandalwood into a landscape of layered peaks populated by five hundred arhats—sitting or standing, meditating or debating—each with a distinct expression, a triumph of craftsmanship counted among the "Three Wonders" of the temple. In front of the hall is displayed the Golden Bumpa Vase, presented by the Qianlong Emperor and used in the golden urn lot-draw to identify reincarnated lamas, a key artefact of Qing Tibet policy.</p>',
  6,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_lama_temple_bj_sa_08',
  'beijing_lama_temple',
  'Pavilion of Ten Thousand Blessings (Wanfu Pavilion)',
  '万福阁',
  '<p>Wanfu Pavilion, the principal building at the northern end of the Lama Temple, was built in 1750 (the fifteenth year of Qianlong). Rising about twenty-five metres with triple flying eaves, it is the tallest structure in the complex. At its centre stands a statue of Maitreya carved from a single piece of white sandalwood gifted by Nepal. The figure is twenty-six metres tall in total—eighteen metres above ground and eight metres below—with a girth of eight metres, making it one of the largest single-log Buddhist carvings in the world and an entry in the Guinness World Records, the foremost of the temple''s "Three Wonders." Flanking the pavilion, flying galleries connect it to the Yongkang and Yanning pavilions, creating a spectacular tripartite complex. Gazing up at the colossal Maitreya from the foot of the hall, its overwhelming and awe-inspiring presence marks the climax of any visit to the Lama Temple.</p>',
  7,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_lama_temple_bj_sa_09',
  'beijing_lama_temple',
  'Guanyin Grotto and Suicheng Hall (Epilogue)',
  '观音洞与绥成殿（结束语）',
  '<p>Beneath Wanfu Pavilion lies the Guanyin Grotto, also called the underground palace of the pavilion. Inside is enshrined a white sandalwood statue of Avalokitesvara, surrounded by Buddhist murals and reliefs in a hushed and solemn atmosphere that makes it a sacred place for the faithful to pray and make vows. The grotto gives Wanfu Pavilion a three-dimensional devotional structure—"Maitreya above, Guanyin below." At the northernmost end of the temple stands Suicheng Hall, originally named the Yamantaka Tower, the final hall of the complex, enshrining esoteric deities such as Vajrabhairava. The name "Suicheng" means "pacification and accomplishment." As the "epilogue" of the visit, the journey from the archway courtyard in the south to this hall in the north—entering through "Zhaotai" and concluding at "Suicheng"—completes not only a south-to-north passage through space but also a spiritual ascent from prayer to fulfilment, bringing the pilgrimage through this royal Tibetan Buddhist monastery to a perfect close.</p>',
  8,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_summer_palace_bj_sa_01',
  'beijing_summer_palace',
  'East Palace Gate and Hall of Benevolence and Longevity',
  '东宫门与仁寿殿',
  '<p>The East Palace Gate is the main entrance to the Summer Palace, built in 1750 during the Qianlong reign. Bronze lions, stone steps, and cloud-dragon carvings flank the entrance, and the gate bears a plaque reading "Yiheyuan" (Summer Palace), said to be calligraphed by Emperor Guangxu. Inside stands the Hall of Benevolence and Longevity (Renshou Dian), originally called the "Hall of Diligent Administration." Destroyed by Anglo-French forces in 1860 and rebuilt, Empress Dowager Cixi renamed it, drawing from the Confucian Analects: "the benevolent enjoy longevity." The hall contains a nine-dragon throne, screens, and enamel cranes and deer. It was the central venue where Cixi and Emperor Guangxu held audiences and conducted state affairs. Bronze dragons, phoenixes, tripods, and Taihu stones decorate the courtyard, flanked by symmetrically arranged side halls, projecting imperial authority within the garden.</p>',
  0,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_summer_palace_bj_sa_02',
  'beijing_summer_palace',
  'Garden of Virtue and Harmony',
  '德和园',
  '<p>Built in 1891 and located northwest of the Hall of Benevolence and Longevity, the Garden of Virtue and Harmony (Dehe Yuan) was a garden-within-a-garden dedicated to opera performances for Empress Dowager Cixi, constructed at a cost of 710,000 taels of silver. Its centerpiece is the Grand Theater Building, 21 meters tall with three upturned eaves. The ground-floor stage spans 17 meters, and the three-tiered stage features mechanical devices for spectacular effects—deities ascending to heaven and demons descending underground. It is the largest and most ingeniously structured surviving imperial theater in China. Cixi was an avid Peking Opera enthusiast, staging performances for days during birthdays and festivals. The complex also includes a backstage dressing area and the Yile Hall (viewing hall), preserving Cixi''s opera-viewing throne and precious Peking Opera artifacts.</p>',
  1,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_summer_palace_bj_sa_03',
  'beijing_summer_palace',
  'Hall of Jade Ripples and Hall of Joyful Longevity',
  '玉澜堂与乐寿堂',
  '<p>The Hall of Jade Ripples (Yulan Tang), on the northeastern shore of Kunming Lake, was originally built during the Qianlong reign as a resting place for the imperial family. After the failure of the 1898 Hundred Days'' Reform, Empress Dowager Cixi placed Emperor Guangxu under house arrest here. The east and west side rooms were sealed with brick walls to isolate him—traces of which remain visible today, making the hall a historical witness to a political tragedy in modern China. The Hall of Joyful Longevity (Leshou Tang), immediately west, was Cixi''s residential quarters in the Summer Palace. Its name means "the wise find joy, the benevolent enjoy longevity." The central room contains Cixi''s throne and an agarwood screen, where she received congratulations, dined, and took tea. Bronze deer, cranes, and vases in the courtyard symbolize universal peace, while magnolia, crabapple, and peony represent "wealth and honor in the jade hall."</p>',
  2,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_summer_palace_bj_sa_04',
  'beijing_summer_palace',
  'Long Corridor',
  '长廊',
  '<p>Stretching from the Moon-Inviting Gate in the east to the Stone Old Man Pavilion in the west, the Long Corridor (Changlang) is 728 meters long with 273 bays. It is the longest and most richly painted garden corridor in China, earning a Guinness World Record in 1992. Originally built in 1750 during the Qianlong reign, it was destroyed by Anglo-French forces in 1860 and rebuilt during the Guangxu reign. Over 14,000 Suzhou-style paintings decorate the beams, depicting landscapes, flora and fauna, historical figures, classical literature scenes from "Journey to the West," "Romance of the Three Kingdoms," and "Dream of the Red Chamber," and folk legends—an open-air museum of Chinese traditional painting. The corridor runs between mountain and water with seasonal views. Four octagonal double-eave pavilions—Liujia, Jilan, Qiushui, and Qingyao—mark the four seasons along its length.</p>',
  3,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_summer_palace_bj_sa_05',
  'beijing_summer_palace',
  'Hall of Dispelling Clouds, Tower of Buddhist Incense and Sea of Wisdom',
  '排云殿、佛香阁与智慧海',
  '<p>These three structures form the central complex ascending from south to north along Longevity Hill''s central axis. The Hall of Dispelling Clouds (Paiyun Dian) occupies the lower section. Originally the "Great Temple of Repaying Kindness and Extending Longevity," it was converted into a ceremonial hall by Cixi, named after a line by poet Guo Pu: "immortals emerge from the clouds, revealing halls of gold and silver." Its throne was used for Cixi''s birthday celebrations. The Tower of Buddhist Incense (Foxiang Ge) stands on a 21-meter stone platform mid-hill—a three-tiered, four-eave octagonal tower 36.44 meters tall, the iconic landmark of the Summer Palace. Inside is a Ming Dynasty bronze Thousand-Handed Guanyin, five meters tall. The Sea of Wisdom (Zhihui Hai) crowns the hilltop, a beamless hall built entirely of multicolored glazed tiles with embedded Buddha images, meaning "the Buddha''s wisdom is as vast as the sea." As the highest point, it offers panoramic views of Kunming Lake.</p>',
  4,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_summer_palace_bj_sa_06',
  'beijing_summer_palace',
  'Marble Boat',
  '石舫',
  '<p>The Marble Boat (Qingyan Fang, "Boat of Purity and Peace") stands at the western end of the Long Corridor on the shore of Kunming Lake. Built in 1755 during the Qianlong reign, it is the largest surviving ancient stone boat-shaped garden structure in China. Carved entirely from massive stone blocks, it measures 36 meters long. The hull is made of grey stone, while the cabin was originally wood, combining Western stained-glass windows with a traditional Chinese gabled roof, reflecting the Qianlong era''s fusion of Chinese and Western aesthetics. According to legend, Emperor Qianlong drew on the classical admonition by Tang minister Wei Zheng—"water can carry a boat, but can also overturn it"—using the stone boat to symbolize the eternal, unshakeable stability of the Qing Empire. The cabin was burned by Anglo-French forces in 1860 and rebuilt in 1893 with its current marble patterns and decorative tiles. The Marble Boat is a visual focal point of the western lake area and a classic photo landmark.</p>',
  5,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_summer_palace_bj_sa_07',
  'beijing_summer_palace',
  'Kunming Lake',
  '昆明湖',
  '<p>Kunming Lake is the core water body of the Summer Palace, covering 220 hectares—three-quarters of the total park area—and is the largest artificial lake in Beijing. Fed by springs from Yuquan Mountain and Wengshan Lake, it was dredged and expanded in 1750. Emperor Qianlong named it after the Kunming Pool that Emperor Wu of Han dug in Chang''an to train his navy. With Longevity Hill as its backdrop, the lake is divided into three zones: East Lake, West Lake, and North Lake. The West Causeway with its six bridges imitates the Su Causeway of West Lake in Hangzhou, lined with peach and willow trees, evoking the misty charm of Jiangnan. The lake shimmers in every season—lotus blooms in summer, reeds sway in winter. Visitors can take painted boats to cruise the lake and experience the grandeur of the imperial garden from the water.</p>',
  6,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_summer_palace_bj_sa_08',
  'beijing_summer_palace',
  'Seventeen-Arch Bridge and South Lake Island',
  '十七孔桥与南湖岛',
  '<p>The Seventeen-Arch Bridge spans from the East Causeway to South Lake Island on Kunming Lake, built during the Qianlong reign (1736–1795). It is 150 meters long and 8 meters wide, with 17 arches. The arch count derives from the number nine—the supreme yang number—with nine arches on each side of the central arch, symbolizing imperial supremacy. The bridge is built of white marble, and its railings are carved with 544 stone lions in diverse postures—more than the Marco Polo Bridge—each vividly rendered. Stele pavilions and a bronze ox stand at the east and west ends. South Lake Island, at the center of Kunming Lake, symbolizes Penglai, the immortal isle of Eastern Sea legend. Buildings on the island include the Hanxu Hall and Dragon King Temple, where the imperial family viewed the lake and worshipped the Dragon King. Around the winter solstice, the setting sun shines through the bridge arches, creating the spectacular "Golden Light through the Arches" phenomenon that draws countless visitors and photographers.</p>',
  7,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_summer_palace_bj_sa_09',
  'beijing_summer_palace',
  'Bronze Ox',
  '铜牛',
  '<p>The Bronze Ox stands on the eastern shore of Kunming Lake, north of the Seventeen-Arch Bridge. Cast in 1755 during the Qianlong reign, it is a reclining bronze ox measuring 1.75 meters long, 0.8 meters wide, and 1.15 meters high. It lies on a stone base with head raised, lifelike and masterfully crafted. An 80-character inscription in seal script, the "Golden Ox Inscription" composed by Emperor Qianlong, is carved on its back, recording the reason for casting and the emperor''s prayers. It follows the ancient tradition of using iron oxen to suppress floods. Qianlong compared Kunming Lake to the Milky Way and the bronze ox to the Altair star, expressing his wish for favorable weather and a peaceful realm. The ox complements Longevity Hill and Kunming Lake, serving as both a guardian spirit of the imperial garden and an important witness to Chinese hydraulic culture.</p>',
  8,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_summer_palace_bj_sa_10',
  'beijing_summer_palace',
  'Newly Built Palace Gate',
  '新建宫门',
  '<p>The Newly Built Palace Gate (Xinjiangongmen) is the South Gate of the Summer Palace, constructed during the Guangxu reign. It was named for being built later than the East Palace Gate and other entrances. The gate has three bays with a gabled roof and front and rear corridors. Though less grand than the East Palace Gate, its open foreground offers one of the best vantage points for viewing Kunming Lake and the Seventeen-Arch Bridge. It is a key portal for the circular lake tour: heading north along the East Causeway leads to the Bronze Ox, Seventeen-Arch Bridge, and South Lake Island, while heading west along the West Causeway''s six bridges evokes the scenery of Hangzhou''s West Lake. Arriving here, looking back at the tiered pavilions of the Tower of Buddhist Incense on Longevity Hill and the vast expanse of Kunming Lake, the magnificent synthesis of garden art is fully revealed. As the final stop, this gate is not merely an entrance or exit, but a fond farewell to centuries of history and culture.</p>',
  9,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_temple_of_heaven_bj_sa_01',
  'beijing_temple_of_heaven',
  'Circular Mound Altar',
  '圜丘坛',
  '<p>The Circular Mound Altar is the core sacrificial structure in the southern part of the Temple of Heaven, first built in 1530 (Jiajing 9) and expanded in 1749 (Qianlong 14). It is a three-tiered open-air circular stone platform constructed entirely of white marble; the number of balustrade panels and steps on each tier is always nine or a multiple of nine—the supreme yang number symbolizing the highest authority of the Lord of Heaven. At the centre of the top tier lies a round "Heart of Heaven" stone; speaking from it, sound waves reflect from the surrounding balustrades and converge back, creating a startling amplification as if Heaven itself replies. Two concentric enclosure walls surround the altar—inner circular, outer square—echoing the ancient cosmology of "round heaven, square earth." At dawn on the winter solstice the emperor conducted the grand sacrifice, burning offerings and reading prayers with solemn reverence. Though roofless, the altar expresses awe and understanding of Heaven through pure geometry and number—the pinnacle of Chinese ritual architecture.</p>',
  0,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_temple_of_heaven_bj_sa_02',
  'beijing_temple_of_heaven',
  'Imperial Vault of Heaven & Echo Wall',
  '皇穹宇与回音壁',
  '<p>The Imperial Vault of Heaven stands north of the Circular Mound Altar, first built in 1530 (Jiajing 9) and rebuilt in 1752 (Qianlong 17). It is the hall where the tablet of the Lord of Heaven and ancestral spirit tablets were stored. A single-eaved circular structure with a conical roof under blue glazed tiles, it rises from a round stone platform—delicate and graceful, just 15.6 m in diameter yet displaying the sacred imagery of the celestial vault through perfect proportion and colour. The interior dome is beamless and columnless, supported entirely by intricate bracket sets—a masterwork of timber engineering. The circular enclosing wall outside is the celebrated Echo Wall—3.72 m high, 0.9 m thick, 195.2 m in circumference, with a triple-arched glazed doorway on each side. If two people stand at the rear of the east and west side halls and whisper against the wall, sound waves propagate along the smooth surface by successive reflection, and each hears the other clearly as though conversing across the wall—an acoustic analogue of optical reflection, a serendipitous masterpiece of ancient Chinese construction. The courtyard also contains "Three-Sound Stones"—clapping on them yields three echoes, adding further wonder.</p>',
  1,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_temple_of_heaven_bj_sa_03',
  'beijing_temple_of_heaven',
  'Danbi Bridge (Sacred Way Bridge)',
  '丹陛桥',
  '<p>Danbi Bridge is the most prominent passageway on the Temple of Heaven''s central axis, running from the Circular Mound Altar''s north gate to the Hall of Prayer''s south gate—about 360 m long and 28 m wide, paved in three parallel stone strips. The highest, central strip is the "Spirit Way," reserved for the tablet of the Lord of Heaven; the eastern strip is the "Imperial Way" for the emperor; the western is the "Princes'' Way" for nobles and ministers—strict hierarchy, no trespassing. The surface rises gradually from south to north, symbolizing step-by-step ascent from the human realm toward heaven; walking it truly induces a sense of looking up at the sky with reverent awe. Ancient cypress trees flank both sides, centuries old, canopying like umbrellas—solemnity enriched by verdant vitality. Though called a "bridge," it is actually an elevated road rising 4 m above ground; beneath it ran a passage for sacrificial animals—a clever design. The entire sacred way, like a dragon''s spine running north-south, binds the Circular Mound Altar and the Hall of Prayer into one ritual whole, the core axis of the Temple of Heaven''s ceremonial space.</p>',
  2,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_temple_of_heaven_bj_sa_04',
  'beijing_temple_of_heaven',
  'Hall of Prayer for Good Harvests',
  '祈年殿',
  '<p>The Hall of Prayer for Good Harvests is the main hall in the northern part of the Temple of Heaven and its visual soul. First built in 1420 (Yongle 18) as "Great Sacrifice Hall," renamed "Great Offering Hall" under Jiajing, and given its present name in 1751 (Qianlong 16). It is a triple-eaved circular structure with a conical roof under blue glazed tiles, standing on a three-tiered white-marble circular platform—about 38 m high and 32 m in diameter. The interior is a structural marvel: 28 nanmu columns carry the dome without beams or nails, relying on mortise-and-tenon joints and bracket sets rising tier by tier. The inner ring of four "Dragon Well" columns symbolizes the four seasons; the middle ring of twelve "Golden" columns symbolizes the twelve months; the outer ring of twelve "Eave" columns symbolizes the twelve double-hours; the total of 28 implicitly echoes the twenty-four solar terms—space is time, building is cosmos. At the centre stands the tablet of the Lord of Heaven; on the first sin day of the first lunar month the emperor held the Praying-for-Harvest ceremony here, beseeching abundant crops. With its perfect circle, blue dome and ingenious structure, the Hall has become the symbol of Chinese ancient architecture and one of the most recognizable Chinese images among World Heritage sites.</p>',
  3,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_temple_of_heaven_bj_sa_05',
  'beijing_temple_of_heaven',
  'North Gate',
  '北门',
  '<p>The North Gate sits on the park''s north side, one of the main access points for the Hall of Prayer precinct. Its classical style features red walls and grey tiles; outside, ancient cypresses tower, their shade dense, seamlessly extending the park''s landscape. Positioned close to the Hall of Prayer, exiting here after visiting the Hall is most convenient—no need to retrace southward. The path outside continues through a cypress grove, the air fragrant with pine and cedar; in spring blooming locust trees scent the whole approach. Walking east about 10 minutes from the gate reaches Subway Line 5''s Tiantan East Gate station; west about 15 minutes reaches Qianmen Street and Tiananmen Square—prime positioning for connecting to other central-axis landmarks. Though less bustling than the East or West Gates, its quiet antiquity underscores the Temple''s solemn character, a perfect finale to the visit.</p>',
  4,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_ming_tombs_bj_sa_01',
  'beijing_ming_tombs',
  'Stone Archway and Great Red Gate',
  '石牌坊与大红门',
  '<p>The Stone Archway, built in 1540 during the Jiajing reign, is a five-bay, six-pillar, eleven-roof stone structure made entirely of white marble. Measuring 28.86 meters wide and 14 meters high, it is the largest and best-preserved stone archway in China. Its beams are exquisitely carved with dragons, phoenixes, lions, and other auspicious motifs. The Great Red Gate, the main entrance to the mausoleum area, was built during the Yongle reign. It features a single-eave hipped roof with red walls and yellow tiles, connecting Mount Hu and Mount Long on either side to form a natural barrier. It is the first portal into the tomb complex and holds exceptional architectural and historical significance.</p>',
  0,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_ming_tombs_bj_sa_02',
  'beijing_ming_tombs',
  'Stele Pavilion of Divine Merit and Sacred Way',
  '神功圣德碑亭与神路',
  '<p>The Stele Pavilion of Divine Merit stands approximately one kilometer north of the Great Red Gate. Built in 1435 during the Xuande reign, it is a square structure with a double-eave gabled roof. Inside stands a giant stone stele 7.91 meters tall, with a dragon-carved top and an inscription composed by Emperor Renzong (Zhu Gaozhi) praising the military and civil achievements of Emperor Yongle (Zhu Di). Four marble ornamental columns, each about 10 meters tall and carved with coiled dragons and clouds, flank the pavilion''s corners. The Sacred Way extends southward for about seven kilometers, serving as the central processional road to all tombs. Lined with pines and cypresses and enclosed by stone walls, it forms the central axis of the Ming Tombs layout.</p>',
  1,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_ming_tombs_bj_sa_03',
  'beijing_ming_tombs',
  'Stone Statues and Dragon and Phoenix Gate',
  '石像生群与棂星门',
  '<p>The Stone Statues flank both sides of the Sacred Way, built between the Xuande and Zhengtong reigns. There are 36 figures in total: 24 stone animals (lions, xiezhi, camels, elephants, qilin, and horses, four of each, in alternating standing and kneeling postures) and 12 human figures (four nobles, four civil officials, and four military generals). Each statue is carved from a single massive stone block, with the tallest exceeding three meters. They represent the pinnacle of Ming imperial stone carving. The Dragon and Phoenix Gate (Lingxing Gate), also called the "Flame Archway," stands at the northern end of the statue group. It features three gates with six pillars topped by stone beasts and flame-shaped ornaments, symbolizing the passage of imperial souls to heaven.</p>',
  2,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_ming_tombs_bj_sa_04',
  'beijing_ming_tombs',
  'Changling Tomb and Museum',
  '长陵与博物馆',
  '<p>Changling is the largest, earliest, and best-preserved tomb among the Ming Tombs. Construction began in 1409 during the Yongle reign, housing Emperor Zhu Di (Yongle) and Empress Xu. The complex follows a rectangular-front-and-round-rear layout. The main hall, the Hall of Eminent Favor (Ling''en Dian), sits on a three-tiered white marble base with a double-eave hipped roof. It spans nine bays wide and five bays deep, covering 1,956 square meters. Thirty-two golden-thread nanmu pillars stand inside, with the four central columns measuring 1.17 meters in diameter and 14.3 meters in height—the largest existing nanmu pillars in China, still fragrant after over five centuries. The Changling Museum, housed within the hall, displays excavated artifacts, imperial garments, and architectural models.</p>',
  3,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_ming_tombs_bj_sa_05',
  'beijing_ming_tombs',
  'Dingling Tomb and Underground Palace',
  '定陵与地宫',
  '<p>Dingling is the joint burial tomb of Emperor Zhu Yijun (Wanli) and his two empresses, constructed between 1584 and 1590. It is the only archaeologically excavated tomb among the Ming Tombs. The underground palace was excavated between 1956 and 1958. Located 27 meters below ground, it consists of five stone chambers—front, middle, rear, left, and right—covering 1,195 square meters. The entire structure is built of stone arches without beams or columns, showcasing extraordinary craftsmanship. The rear chamber contains a white marble bed holding three vermillion-lacquered coffins and 26 wooden chests, yielding nearly 3,000 artifacts including the gold crown, phoenix crowns, dragon robes, and silk textiles of national-treasure status. The underground palace maintains a constant temperature of 18–20°C year-round.</p>',
  4,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_ming_tombs_bj_sa_06',
  'beijing_ming_tombs',
  'Zhaoling Tomb',
  '昭陵',
  '<p>Zhaoling is the joint burial tomb of Emperor Zhu Zaihou (Longqing) and his three empresses, construction beginning in 1572. It was the first tomb among the Ming Tombs to undergo large-scale restoration, allowing visitors to see the complete layout of a Ming imperial mausoleum. Its distinctive feature is the fully restored Hall of Eminent Favor and side halls. The complex follows Changling''s rectangular-and-round layout but features a unique drainage system—a retaining wall and water-discharge stone channel behind the main hall found nowhere else among the Ming Tombs. Emperor Longqing reigned only six years but initiated the "Longqing Accord," ushering in a brief Ming revival. The Zhaoling Museum displays reproduced imperial garments and sacrificial vessels.</p>',
  5,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_ming_tombs_bj_sa_07',
  'beijing_ming_tombs',
  'Jingling, Kangling and Yongling Tombs',
  '景陵、康陵与永陵',
  '<p>Jingling is the tomb of Emperor Zhu Zhanji (Xuande) and Empress Sun. Smaller in scale but compact in layout, its Hall of Eminent Favor employs a reduced-pillar technique to expand interior space—an innovation in Ming mausoleum architecture. Kangling, the tomb of Emperor Zhu Houzhao (Zhengde) and Empress Xia, is located at the westernmost end of the Ming Tombs, backed by Mount Jinling. Ancient pines create a serene environment, and Emperor Zhengde''s life was legendary. Yongling, the joint tomb of Emperor Zhu Houcong (Jiajing) and Empress Chen, took over a decade to build and is second only to Changling in scale. Its treasure-city wall reaches 240 meters in diameter, and its Soul Tower uses the finest materials, with bricks bearing inscriptions—the highest grade among the Ming Tombs. The three tombs are under conservation; some areas are open, allowing visitors to view the walls and towers from a distance.</p>',
  6,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_ming_tombs_bj_sa_08',
  'beijing_ming_tombs',
  'Siling Tomb',
  '思陵',
  '<p>Siling is the tomb of Emperor Zhu Youjian (Chongzhen), Empress Zhou, and Consort Tian. It is the smallest among the Ming Tombs. In 1644, when Li Zicheng''s forces captured Beijing, Emperor Chongzhen hanged himself at Coal Hill (Jingshan), marking the fall of the Ming Dynasty. After the Qing army entered Beijing, the Qing court reinterred Chongzhen here with imperial rites. Originally Consort Tian''s tomb, its scale is far smaller than the other twelve. Siling has no stele of divine merit, no stone statues, and no Soul Tower or treasure-city wall—only a simple round mound and a modest memorial hall, echoing the tragic fate of an emperor who was diligent yet lost his empire. Ancient cypresses create a solemn, melancholic atmosphere, making it a poignant place to reflect on the late Ming and a fitting conclusion to a Ming Tombs visit.</p>',
  7,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_mutianyu_great_wall_bj_sa_01',
  'beijing_mutianyu_great_wall',
  'Great Corner Tower',
  '大角楼',
  '<p>The Great Corner Tower is the first watchtower on the eastern section of the Mutianyu Great Wall, perched on a ridge at approximately 600 meters elevation. It earned its name because three sections of the wall converge here at a sharp angle, forming a dramatic corner. Originally constructed during the Hongwu reign of the Ming Dynasty under the supervision of General Xu Da, it was later reinforced by renowned commanders Tan Lun and Qi Jiguang. The tower features a unique three-arch connected design, serving multiple functions including lookout, defense, and troop billeting. From its summit, visitors can gaze eastward to see the Jiankou Great Wall snaking like a dragon across the peaks, southward to view the Mutianyu pass in its entirety, and northward over verdant valleys. As a critical node in the Great Wall defense system, it commanded a strategically vital position and remains a precious physical relic for the study of Ming Dynasty frontier military engineering.</p>',
  0,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_mutianyu_great_wall_bj_sa_02',
  'beijing_mutianyu_great_wall',
  'Zhengguantai Pass',
  '正关台',
  '<p>Zhengguantai Pass is the core fortress of the Mutianyu Great Wall, composed of three hollow watchtowers connected side by side from east to west. This three-tower arrangement is extremely rare along the entire Great Wall and represents the most iconic architectural feature of the Mutianyu section. Built during the Yongle reign of the Ming Dynasty, the towers are interconnected at the ground level while each has its own crenellated upper level, capable of simultaneously housing hundreds of soldiers. The three towers rise at staggered heights—the central one tallest, flanked by two slightly lower ones—appearing from afar as three ramparts standing together in imposing grandeur. The walls extend east and west along the ridgeline from the pass, built on granite block foundations with blue brick superstructures approximately 7-8 meters high and 4 meters wide at the top, wide enough for five horses or ten soldiers abreast. Commanding the valley passage, Zhengguantai was a vital military pass guarding the northern gateway to the imperial capital and has witnessed centuries of martial history.</p>',
  1,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_mutianyu_great_wall_bj_sa_03',
  'beijing_mutianyu_great_wall',
  'Tower No. 6 and Cable Car Station',
  '六号敌楼与缆车站',
  '<p>Tower No. 6 is one of the most popular boarding points along the Mutianyu Great Wall, situated adjacent to the upper cable car station and serving as the starting point for most visitors'' wall exploration. The Mutianyu cable car spans approximately 700 meters with an elevation gain of about 400 meters, completing a one-way trip in just 4-5 minutes. It transports passengers from the mountain base directly to the vicinity of Tower No. 6, eliminating the strenuous hike and greatly enhancing accessibility. Tower No. 6 is a square hollow watchtower with a spacious interior and a sturdy vaulted ceiling. From its summit, visitors can survey the magnificent panorama of the entire Mutianyu Great Wall winding through the mountains. This is also one of the finest vantage points for photographing the wall—spring brings blooming wildflowers, summer clothes the slopes in vivid green, autumn paints the forests in fiery colors, and winter drapes everything in pristine white, offering breathtaking scenery in every season.</p>',
  2,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_mutianyu_great_wall_bj_sa_04',
  'beijing_mutianyu_great_wall',
  '"If You Are the One" Filming Location',
  '非诚勿扰取景地',
  '<p>Mutianyu Great Wall gained an added layer of romance after serving as a filming location for the movie "If You Are the One II" (2010, directed by Feng Xiaogang). The iconic scene in which the characters played by Ge You and Shu Qi have their proposal moment on the Great Wall was shot between Towers No. 14 and 16 of the Mutianyu section. This stretch of wall sits at a high elevation with an open panorama—the wall unfurls along the ridgeline like a ribbon, with layered peaks rising on both sides in magnificent splendor. After the film''s release, this spot quickly became a popular destination for visitors, especially favored by couples and newlyweds. The scenic area has placed identification markers near the filming location for easy photo positioning. Strolling along this section, visitors can simultaneously feel the weight of history and relive the romance of the film—a unique experience that beautifully merges cultural heritage with popular culture at Mutianyu.</p>',
  3,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_mutianyu_great_wall_bj_sa_05',
  'beijing_mutianyu_great_wall',
  'Chairman Mao Stone Inscription and Boundary Marker',
  '毛主席石刻与界碑',
  '<p>The Chairman Mao Stone Inscription is located within the Mutianyu Great Wall scenic area, bearing the famous line from Mao Zedong''s poem "Clean Plain Melody: Liupan Mountain"—"He who has not reached the Great Wall is not a true man"—carved in vigorous, imposing calligraphy. This quote originated from Mao''s reflections during the Red Army''s crossing of Liupan Mountain on the Long March in 1935 and has since become a classic inspiration for countless visitors to climb the Great Wall. The stone regularly draws large crowds of tourists posing for photographs and has become one of the signature photo spots at Mutianyu. Nearby stands an administrative boundary marker for Huairou District, indicating the geographical location of the site. The boundary marker and the stone inscription stand side by side—one marking geographic coordinates, the other carrying spiritual significance. Here, visitors can confirm they stand on the soil of Huairou while feeling the bold spirit of being a "true man"—a special waypoint that combines both cultural and geographical meaning along the Great Wall.</p>',
  4,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_mutianyu_great_wall_bj_sa_06',
  'beijing_mutianyu_great_wall',
  'Hero Slope',
  '好汉坡',
  '<p>Hero Slope is the highest point of the Mutianyu Great Wall, located near Tower No. 20 at an elevation of approximately 540 meters. The terrain here is steep, with the wall climbing along the ridgeline and some steps angled at nearly seventy degrees, making the ascent quite strenuous—hence the name "Hero Slope," inspired by the saying "He who has not reached the Great Wall is not a true man." To reach the summit, visitors set out from Zhengguantai Pass or Tower No. 6, climbing along the wall past multiple watchtowers, a journey of about one to two hours. Upon reaching the top, the vista opens dramatically—mountains stretch as far as the eye can see, and the Great Wall unfurls like a colossal dragon over the peaks into the distance in breathtaking grandeur. This is also an ideal spot for watching sunrise and sunset. When the first rays of dawn or the golden glow of dusk bathes the wall and mountains, the scenery is truly awe-inspiring. Conquering Hero Slope is not merely a physical challenge but a spiritual experience, allowing one to truly appreciate the boldness and heroism embodied in the word "hero."</p>',
  5,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_national_museum_bj_sa_01',
  'beijing_national_museum',
  'Ancient China Exhibition',
  '古代中国陈列',
  '<p>The "Ancient China Exhibition" is one of the National Museum''s core galleries, located on the B1 level of the North Wing and covering approximately 17,000 square metres. Organised around the succession of dynasties, it comprises eight sections: remote antiquity, Xia–Shang–Western Zhou, Spring and Autumn and Warring States, Qin and Han, Three Kingdoms through Northern and Southern Dynasties, Sui–Tang–Five Dynasties, Liao–Song–Xia–Jin–Yuan, and Ming–Qing. Over two thousand carefully selected artefacts are displayed, including bronzes, jades, ceramics, stone carvings and calligraphy. Among the signature treasures are the Houmuwu Ding, the Four-Ram Square Zun and the storytelling pottery figurine, together offering a systematic overview of the splendour and evolution of Chinese civilisation.</p>',
  0,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_national_museum_bj_sa_02',
  'beijing_national_museum',
  'The Road of Rejuvenation',
  '复兴之路',
  '<p>"The Road of Rejuvenation" is a permanent exhibition in the South Wing of the National Museum, structured in five parts: "China reduced to a semi-colonial and semi-feudal society," "Exploring paths to national salvation," "The Communist Party of China takes up the historic mission of national independence and people''s liberation," "Building the new socialist China," and "Taking the path of socialism with Chinese characteristics." Through precious artefacts, historical photographs, archival documents and multimedia installations, it vividly recreates the journey of the Chinese nation from humiliation to renewal since the Opium War, serving as an essential gallery for patriotic education and a vital window into the trajectory of modern and contemporary China.</p>',
  1,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_national_museum_bj_sa_03',
  'beijing_national_museum',
  'Second-Floor Special Exhibitions: The Power of Science and Technology, Red Flags Unfurled, and Dehua White Porcelain',
  '二层专题·科技的力量、风展红旗与德化白瓷',
  '<p>The second floor of the National Museum hosts several thematic galleries. "The Power of Science and Technology" surveys Chinese scientific and technological achievements from antiquity to the modern era, spanning astronomy, hydraulic engineering, textiles and metallurgy, and highlighting the creative ingenuity of the Chinese people. "Red Flags Unfurled" uses flags as a narrative thread, bringing together revolutionary artefacts and historical images to revisit the glorious journey of the Chinese people under the leadership of the Communist Party of China. The Dehua White Porcelain exhibition showcases masterpieces from the kilns of Dehua, Fujian, celebrated for their distinctive "China White" glaze and exquisite sculptural craftsmanship. Together, these three exhibitions create a rich and varied cultural panorama on the second floor.</p>',
  2,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_national_museum_bj_sa_04',
  'beijing_national_museum',
  'Ancient Chinese Porcelain',
  '古代瓷器',
  '<p>The "Ancient Chinese Porcelain" gallery presents a selection of fine porcelains arranged chronologically, tracing the complete development from proto-celadon to the masterpieces of Ming and Qing imperial kilns. The exhibition covers mature celadon of the Eastern Han, the Tang-dynasty pattern of "celadon in the south, white ware in the north," the five great Song kilns (Ru, Guan, Ge, Jun and Ding), Yuan-dynasty blue-and-white, Yongle and Xuande blue-and-white and Chenghua doucai of the Ming, and the falangcai and fencai of the Kangxi–Qianlong golden age. Each piece is accompanied by detailed interpretation—covering body and glaze techniques as well as the symbolism of decorative motifs—offering a comprehensive appreciation of Chinese porcelain as a national treasure and an ideal introduction to the history of Chinese ceramics.</p>',
  3,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_national_museum_bj_sa_05',
  'beijing_national_museum',
  'Ancient Chinese Jade',
  '古代玉器',
  '<p>The "Ancient Chinese Jade" gallery is arranged chronologically, presenting the evolution of Chinese jade from the Neolithic period to the Qing dynasty. It opens with prehistoric jades of the Xinglongwa, Hongshan and Liangzhu cultures, illustrating jade''s central role in the origins of Chinese civilisation. It continues with ritual and funerary jades of the Shang and Zhou, exquisite jade pendants of the Spring and Autumn and Warring States periods, the jade burial suit of the Han dynasty, Tang ornaments, Song archaistic jades, the Yuan "Dushan Great Jade Sea," Ming Zi-gang plaques, and the Qing "Yu the Great Taming the Waters" jade boulder from the Qianlong reign. The exhibition explores not only the craftsmanship of jade but also its profound symbolism in Chinese culture, where jade embodies the virtues of the noble personage.</p>',
  4,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_national_museum_bj_sa_06',
  'beijing_national_museum',
  'Ancient Chinese Coins and Bronze Mirrors',
  '古代钱币与铜镜',
  '<p>The "Ancient Chinese Coins" gallery follows a chronological thread, displaying pre-Qing currencies such as cowrie, spade, knife and round coins through to the Qin Banliang, Han Wuzhu, Tang Kaiyuan Tongbao, Song-dynasty Jiaozi paper money, and Ming–Qing silver ingots and machine-struck coins, comprehensively reflecting the evolution of China''s monetary and economic systems. The "Ancient Chinese Bronze Mirrors" gallery runs from Qiijia-culture mirrors to those of the Qing dynasty, illustrating developments in bronze alloys, back decoration and inscriptions across the ages. Combining utility with artistry, these mirrors distil ancient aesthetics and technology into a few centimetres of bronze. Together, the two galleries paint a vivid picture of ancient economy and everyday life.</p>',
  5,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_national_museum_bj_sa_07',
  'beijing_national_museum',
  'Ancient Chinese Buddhist Sculpture',
  '古代佛造像',
  '<p>The "Ancient Chinese Buddhist Sculpture" gallery brings together masterpieces from the National Museum''s collection, tracing the development of Buddhist art in China from its introduction in the Eastern Han through the Wei, Jin, Northern and Southern Dynasties, Sui, Tang, Song, Yuan, Ming and Qing. The exhibition is organised by medium—stone, gilt bronze and ceramic—highlighting the solemnity of Northern Dynasties sculpture, the slender elegance of Southern Dynasties figures, the magnificence of Tang imagery and the worldly style of the Song. Works include standing stone Buddhas in the manner of the Yungang, Longmen and Maijishan grottoes, gilt-bronze Buddhas and bodhisattva figures. Together they demonstrate consummate carving skills and vividly illustrate the creative exchange between Buddhist culture and Chinese tradition.</p>',
  6,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_national_museum_bj_sa_08',
  'beijing_national_museum',
  'Ancient Chinese Costume and Food Culture',
  '古代服饰与饮食文化',
  '<p>The "Ancient Chinese Costume" gallery is arranged chronologically, presenting the complete clothing system from animal hides in primitive society to the formal attire of Ming and Qing officials, including Han and Tang silk embroidery, Song and Yuan robes, and Ming and Qing rank badges and headwear, vividly recreating the evolution of styles and the hierarchies of ritual they embodied. The "Ancient Chinese Food Culture" gallery begins with Neolithic pottery cooking vessels and displays food, wine and tea wares across the dynasties, tracing the journey from raw food to refined cuisine, and from bronze ritual vessels of the pre-Qin era to the tableware of the Qing imperial kitchen. Read together, the two exhibitions offer an all-round portrait of the aesthetics and ritual culture of everyday life in ancient China.</p>',
  7,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_national_museum_bj_sa_09',
  'beijing_national_museum',
  'The Digitised Rhinoceros Zun and Qing-Dynasty Calligraphy and Painting',
  '数说犀尊与清代书画',
  '<p>"The Digitised Rhinoceros Zun" exhibition centres on the Western Han gilt-silver cloud-pattern bronze rhinoceros zun, employing 3-D scanning, digital-twin and augmented-reality technologies to decode the casting technique, sculptural artistry and cultural significance of this national-treasure artefact. Through interactive installations, visitors can examine the zun from every angle and learn about the ecology of ancient rhinoceroses and Han bronze-casting skills, establishing a new paradigm for digital cultural-heritage display. The "Qing-Dynasty Calligraphy and Painting" gallery features works by the early-Qing "Four Wangs" and "Four Monk" painters, the mid-Qing "Eight Eccentrics of Yangzhou" and late-Qing Shanghai-school masters, illustrating the diversity and lineage of Qing-dynasty painting and calligraphy and offering a feast for the eyes and the mind.</p>',
  8,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_national_museum_bj_sa_10',
  'beijing_national_museum',
  'Wax Figures of Heroes and Models (Epilogue)',
  '英模蜡像（结束语）',
  '<p>The "Wax Figures of Heroes and Models" gallery stands at the close of the visitor route, using realistic wax portraiture to bring exemplary figures from different eras to life. The lifelike figures encompass revolutionary martyrs, scientists, model workers and exemplary contemporaries, set amid scene reconstructions and multimedia interactions that allow visitors to feel the power of their spirit in an immersive atmosphere. As the "epilogue" to the museum visit, this gallery gathers the grand sweep of history into the warmth of individual lives, inviting visitors to converse face to face with historical figures before they leave, completing a journey through time in a spirit of emotion and respect and leaving a deep and warm memory of the whole museum experience.</p>',
  9,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_forbidden_city_bj_sa_01',
  'beijing_forbidden_city',
  'Meridian Gate and Golden Water Bridge',
  '午门与金水桥',
  '<p>The Meridian Gate is the highest-ranking of the Forbidden City''s four gates and the principal southern portal. Five pavilions crown the gate tower, their layered heights and upturned eaves resembling a phoenix in flight, hence the name "Five-Phoenix Tower." The gate contains five passageways: the central portal reserved for the emperor, the lateral ones for princes and officials, and the side doors for daily traffic. In front, the Golden Water River curves like a drawn bow, spanned by five white marble bridges symbolizing the five Confucian virtues — benevolence, righteousness, propriety, wisdom, and trustworthiness. During the Ming and Qing dynasties, ceremonies such as the annual issuance of the imperial calendar and the presentation of war captives were staged here. The recessed U-shaped plan formed by the flanking gates and walls imparts a profound sense of awe to every visitor entering this threshold.</p>',
  0,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_forbidden_city_bj_sa_02',
  'beijing_forbidden_city',
  'Gate of Supreme Harmony and East-West Wings of Outer Court',
  '太和门与外朝东西路',
  '<p>The Gate of Supreme Harmony is the main entrance to the Three Great Halls of the Outer Court. Measuring nine bays wide and four bays deep, with a double-eaved hip roof, it spans over 1,300 square meters — the highest-ranking and largest palace gate in the Forbidden City, truly the "king of gates." Here Ming emperors held "gate-side audiences" at dawn, receiving officials and deliberating state affairs. In the square before the gate stand a pair of Ming-dynasty bronze lions: the male to the east with a paw resting on an embroidered ball, the female to the west caressing a cub — symbols of imperial majesty and dynastic continuity. Flanking the gate, the West Wing houses the Hall of Martial Valor (Wuying Dian), formerly an imperial study and book-compilation hall, while the East Wing contains the Hall of Literary Glory (Wenhua Dian), venue for imperial classical lectures. The colonnaded corridors and side halls lining the central axis once served as offices for the various ministries, forming the grand prelude to China''s largest wooden palatial complex.</p>',
  1,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_forbidden_city_bj_sa_03',
  'beijing_forbidden_city',
  'Hall of Supreme Harmony',
  '太和殿',
  '<p>The Hall of Supreme Harmony rises from a three-tiered white marble terrace, reaching a total height of 35.05 meters. Measuring eleven bays wide and five bays deep, its double-eaved hip roof with yellow glazed tiles and golden dragon painted decoration marks the highest architectural rank in the entire complex. Seventy-two massive nanmu columns support the sweeping roof; at the center, a seven-tier gilded throne platform bears a carved dragon throne, beneath a plaque reading "Jian Ji Sui You" (Establish the Ultimate and Follow the Way) in the Qianlong Emperor''s own calligraphy. Before the throne stand auspicious ornaments — treasure elephants, luduan mythical beasts, cranes, and incense pavilions — symbolizing eternal sovereignty and universal peace. The terrace features a sundial and a grain measure, signifying imperial mastery over time and standards. The vast square before the hall could accommodate 100,000 courtiers for grand audiences. On New Year''s Day, the winter solstice, the emperor''s birthday, and at enthronement and wedding ceremonies, bells and drums resounded amid resplendent honor guards, fully manifesting the majesty of the Son of Heaven.</p>',
  2,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_forbidden_city_bj_sa_04',
  'beijing_forbidden_city',
  'Hall of Central Harmony and Hall of Preserving Harmony',
  '中和殿与保和殿',
  '<p>&gt; 保和殿位于中和殿之北，面阔九间、进深五间，重檐歇山顶，规模仅次于太和殿。明代皇帝在册立皇后、皇太子时亦在此更衣受贺。清代自乾隆五十四年（1789年）起，将科举最高等级的殿试改设于此，万千士子的命运曾在这座大殿中定格。殿前巨大的云龙石雕长16.57米、宽3.07米、重约250吨，为故宫最大的一块石雕，九条蟠龙于云水之间翻腾飞舞，气势磅礴。 The Hall of Central Harmony, positioned between the other two halls, is square in plan — three bays wide and deep — with a single-eaved pyramidal roof topped by a gilded finial. It is the smallest yet most refined of the three halls. Before grand ceremonies at the Hall of Supreme Harmony, the emperor would rest here, reviewing prayers and protocols, and receiving the respects of ritual officials. Its interior, simple yet elegant, bears the Qianlong Emperor''s inscription "Yun Zhi Jue Zhong" (Hold Fast to the Mean) — a statement of governance through the Doctrine of the Mean. &gt; The Hall of Preserving Harmony lies to the north, nine bays wide and five bays deep, with a double-eaved hip roof — second only to the Hall of Supreme Harmony in scale. Ming emperors changed robes here before ceremonies honoring empresses and crown princes. Starting in 1789, the Qing dynasty moved the Palace Examination, the highest level of the imperial civil service exam, to this hall, where the fates of countless scholars were decided. Before the hall lies the Forbidden City''s largest stone carving — a 16.57-meter-long, 3.07-meter-wide cloud-dragon marble slab weighing approximately 250 tons, depicting nine coiling dragons soaring through clouds and waves.</p>',
  3,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_forbidden_city_bj_sa_05',
  'beijing_forbidden_city',
  'Three Rear Palaces: Palace of Heavenly Purity, Hall of Union, and Palace of Earthly Tranquility',
  '后三宫·乾清宫、交泰殿与坤宁宫',
  '<p>The Palace of Heavenly Purity, the foremost of the Three Rear Palaces, measures nine bays wide and five bays deep with a double-eaved hip roof — a rank second only to the Hall of Supreme Harmony. From the Yongle reign of the Ming to the Kangxi reign of the Qing, it served as the emperor''s private quarters. Above the central throne hangs the Shunzhi Emperor''s calligraphy "Zheng Da Guang Ming" (Open and Aboveboard), behind which secret succession edicts were once stored, determining the imperial line. Bronze tortoises, cranes, a sundial, and a grain measure stand on the front terrace, echoing those at the Hall of Supreme Harmony. Passing northward through the palace, one arrives at the Hall of Union — a square, single-eaved building housing the plaque "Wu Wei" (Effortless Governance) and twenty-five imperial seals displayed in a row, embodying supreme sovereignty. At the northernmost end, the Palace of Earthly Tranquility, nine bays wide, was the Ming empress''s bedchamber. In the Qing dynasty, its eastern half was converted into the imperial wedding chamber, while the western half became a shamanic ritual hall — a unique fusion of Manchu religious tradition with Han palatial architecture, unmatched anywhere in the Forbidden City.</p>',
  4,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_forbidden_city_bj_sa_06',
  'beijing_forbidden_city',
  'Hall of Mental Cultivation and Grand Council',
  '养心殿与军机处',
  '<p>The Hall of Mental Cultivation, situated west of the Palace of Heavenly Purity, became the de facto center of daily governance and imperial residence from 1729. Its I-shaped layout comprises a front hall for audiences and document review, a rear bedchamber, and a connecting corridor. The front hall, with a throne at its center, features east and west warming chambers for confidential deliberations and rest. Most famously, the East Warm Chamber was the site of "governance behind the curtain" — from behind a gauze screen, Empress Dowagers Cixi and Ci''an controlled the late Qing empire for nearly half a century during the Tongzhi and Guangxu reigns. The hall bears the Yongzheng Emperor''s inscription "Zhong Zheng Ren He" (Justice, Uprightness, Benevolence, and Harmony). To the south of the hall lies the Grand Council, originally established by Yongzheng for swift handling of northwestern military affairs and later evolved into the Qing empire''s supreme decision-making body. A single edict from this modest office could marshal entire armies, profoundly shaping the course of modern Chinese history.</p>',
  5,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_forbidden_city_bj_sa_07',
  'beijing_forbidden_city',
  'Six Eastern and Western Palaces',
  '东西六宫',
  '<p>The Six Eastern and Six Western Palaces, arrayed on either side of the Three Rear Palaces, represent the twelve terrestrial branches and twelve double-hours of the cosmic order in Chinese cosmology. The eastern group encompasses Jingren, Chengqian, Zhongcui, Yanxi, Yonghe, and Jingyang Palaces; the western group includes Yongshou, Yikun, Chuxiu, Xianfu, Changchun, and Qixiang (Taiji) Palaces. Each is a two- or three-courtyard siheyuan compound, its main hall, side halls, annexes, covered corridors, and gate forming a self-contained yet interconnected living space. Among them, Chuxiu Palace is famed as the early residence of Empress Dowager Cixi; Chengqian Palace housed Consort Donggo, beloved of the Shunzhi Emperor; Yanxi Palace saw an unfinished attempt at Western-style reconstruction in the late Qing. Today, some compounds function as themed galleries displaying bronzes, ceramics, and jades that quietly speak of millennia of craftsmanship; others preserve original furnishings depicting daily life in the imperial household, offering visitors a rare glimpse into the authentic world behind the vermilion walls.</p>',
  6,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_forbidden_city_bj_sa_08',
  'beijing_forbidden_city',
  'Palace of Compassion and Tranquility - Sculpture Gallery',
  '慈宁宫·雕塑馆',
  '<p>The Palace of Compassion and Tranquility, built in 1536 west of Longzong Gate on the western route, was purpose-built as a retirement residence for empress dowagers and former consorts, the highest-ranking "women''s palace" in the Forbidden City. Empress Dowager Xiaozhuang, mother of the Shunzhi Emperor, spent her later years here, and Emperor Kangxi would hold grand birthday banquets for his grandmother in this very palace — a display of filial devotion celebrated throughout the realm. The palace features east and west gates, a seven-bay main hall with a double-eaved hip roof, and an ancient cypress-filled courtyard of solemn tranquility. Since 2015, the Great Buddha Hall and surrounding buildings to the east have been transformed into the Palace Museum Sculpture Gallery, showcasing over 400 precious sculptural artifacts ranging from Qin-dynasty terracotta warriors to Ming and Qing Buddhist statues. Monumental stone carvings stand in the courtyards, while pottery figurines, stone reliefs, and bronze Buddhist images line the exhibition halls chronologically, forming a three-dimensional history of Chinese sculpture. The adjacent Cining Garden preserves its original Qing landscaping, where ancient pavilions and flowering trees create the most serene retreat within the Forbidden City.</p>',
  7,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_forbidden_city_bj_sa_09',
  'beijing_forbidden_city',
  'Hall of Ancestral Worship - Clock Gallery & Palace of Tranquil Longevity - Treasure Gallery',
  '奉先殿·钟表馆与宁寿宫·珍宝馆',
  '<p>&gt; 宁寿宫位于故宫东路外朝与内廷之间，是乾隆帝为自己退位后营建的太上皇宫殿群。其建筑布局仿照故宫中路，涵盖皇极殿、宁寿宫、养性殿、乐寿堂等殿宇，以及著名的乾隆花园。皇极殿为宁寿宫区正殿，乾隆帝在此举行"千叟宴"。珍宝馆即设于宁寿宫区各殿堂之内，展出清宫所藏金器、玉器、珠宝、礼器与帝后冠服，其中金瓯永固杯、大禹治水玉山、龙袍朝珠等皆为国宝级文物。奉先殿与宁寿宫一西一东，构成故宫专题文物展陈的两大瑰丽篇章。 The Hall of Ancestral Worship, south of the Six Eastern Palaces and dating from the Yongle reign, served as the imperial family''s private ancestral temple. Its nine-bay hall with a double-eaved hip roof, gold-brick flooring, and nanmu columns exudes solemn magnificence. The Qing court''s clock collection, numbering over a thousand pieces, includes diplomatic gifts from Britain, France, and Switzerland alongside timepieces crafted by the palace workshops. Today the hall is the Clock Gallery, where selected timepieces are demonstrated — at the stroke of the hour, bells chime, birds sing, and water-driven automata spring to life, reawakening two-century-old mechanical marvels. &gt; The Palace of Tranquil Longevity, spanning the eastern Outer and Inner Courts, was built by the Qianlong Emperor as his retirement palace. Its layout mirrors the central axis, encompassing the Hall of Imperial Supremacy, the Palace of Tranquil Longevity, the Hall of Character Cultivation, the Hall of Joyful Longevity, and the famous Qianlong Garden. The Hall of Imperial Supremacy, the main building, hosted the emperor''s "Banquet of a Thousand Elders." The Treasure Gallery is distributed across these halls, exhibiting Qing court goldwork, jades, jewelry, ritual bronzes, and imperial attire. Highlights include the Gold Chalice of Eternal Stability, the Jade Mountain of Yu the Great Taming the Waters, and dragon robes with court beads — all national treasures. Together, the Clock Gallery and Treasure Gallery form two glittering chapters of the Palace Museum''s thematic collections.</p>',
  8,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_forbidden_city_bj_sa_10',
  'beijing_forbidden_city',
  'Qianlong Garden and Imperial Garden',
  '乾隆花园与御花园',
  '<p>&gt; 御花园位于坤宁宫之北、中轴线终点，建于明永乐年间，面积约12000平方米，是故宫中最大的花园。园中古柏参天，多植于明永乐年间，六百年风雨不改其苍翠。园内布局以钦安殿（道教神殿）为中心，左右对称分布着万春亭、千秋亭、浮碧亭、澄瑞亭等二十余座亭台楼阁，堆秀山与海参石相映成趣，天一门前的青铜鎏金獬豸更添庄严气象。园中花木扶疏、甬道蜿蜒，是参观完庄严宫阙后尽情放松身心、感受皇家园林之美的绝佳去处。 The Qianlong Garden, west of the Palace of Tranquil Longevity complex, was a decade-long labor of love by the Qianlong Emperor before his abdication. Despite its modest size, it masterfully employs the Jiangnan garden technique of "creating grandeur within a small space." Its four sequential courtyards house the Pavilion of Ancient Splendor, the Hall of Fulfilling Original Wishes, the Pavilion of Assembled Beauty, and the Pavilion of Expectations Fulfilled, culminating in the celebrated Lodge of Retired Diligence (Juanqin Zhai). Within Juanqin Zhai lies the emperor''s beloved private theater and panoramic mural screens — an unassuming exterior concealing a hidden realm, the most intimate artistic sanctum in the Forbidden City. &gt; The Imperial Garden, at the northern terminus of the central axis beyond the Palace of Earthly Tranquility, was laid out during the Ming Yongle reign and spans approximately 12,000 square meters — the largest garden in the Forbidden City. Ancient cypresses planted over six centuries ago still stand verdant. The garden centers on the Hall of Imperial Peace (a Daoist shrine), with over twenty pavilions and gazebos — including the Pavilion of Myriad Springs and the Pavilion of a Thousand Autumns — arranged symmetrically to the left and right. The Hill of Accumulated Elegance and the Sea-Cucumber Rock create a delightful contrast, while the gilded bronze xiezhi (mythical unicorn) before Tianyi Gate adds solemn dignity. With meandering paths, flowering shrubs, and shaded arbors, it is the perfect place to unwind after the solemn grandeur of the palaces and to savor the beauty of an imperial garden.</p>',
  9,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_forbidden_city_bj_sa_11',
  'beijing_forbidden_city',
  'Gate of Divine Might, Corner Towers, and East-West Prosperity Gates',
  '神武门、角楼与东西华门',
  '<p>&gt; 故宫四角的角楼堪称中国古代木结构建筑的奇迹，每座三开间、三重檐、十字脊顶，共有九梁十八柱七十二条脊，不用一钉一铆，全凭榫卯结构筑就美轮美奂的楼阁。夕阳西下时，金色的琉璃瓦与清澈的护城河水相映成趣，成为北京最具标志性的城市剪影之一。东西华门分列故宫东西城墙中部，东华门门钉为八路（其余三门均为九路），被认为与明代皇帝驾崩后梓宫由此出宫有关；西华门则在清代为帝后前往西苑（今中南海）和颐和园的必经之门。 The Gate of Divine Might, the northern gate, was completed in 1420 and originally named Xuanwu Gate — renamed to avoid the Kangxi Emperor''s personal name Xuanye. Its five-bay tower with a double-eaved hip roof once housed bells and drums that marked dawn and dusk; each evening, 108 strokes of the bell would echo across the Forbidden City, ending the day for the thousand-year-old palace. Today it is the exit for most visitors — beyond it rises the Wanchun Pavilion atop Jingshan Hill, the classic vantage point for panoramic views of the palace complex. &gt; The four corner towers of the Forbidden City are masterpieces of ancient Chinese timber construction. Each tower, spanning three bays with triple eaves and a cross-shaped ridge, comprises nine beams, eighteen columns, and seventy-two ridges — assembled entirely through mortise-and-tenon joinery without a single nail. At sunset, their golden-glazed tiles reflected in the clear moat waters form one of Beijing''s most iconic silhouettes. The East and West Prosperity Gates stand midway along the eastern and western walls respectively. The East Prosperity Gate has eight rows of door nails rather than the standard nine, believed to be related to the passage of imperial coffins during Ming funerals; the West Prosperity Gate served as the Qing emperors'' and empresses'' gateway to the Western Gardens (today''s Zhongnanhai) and the Summer Palace.</p>',
  10,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_prince_gong_mansion_bj_sa_01',
  'beijing_prince_gong_mansion',
  'Palace Gate',
  '宫门',
  '<p>The Palace Gate is the formal entrance to Prince Gong''s Mansion, built in the mid-to-late Qing Dynasty. It spans three bays with a gable-and-hip roof covered in green glazed tiles, and its door nails are arranged in nine vertical and seven horizontal rows, conforming to the specifications for a prince of the first rank. A pair of stone lions once stood guard before the gate, symbolizing the nobility of the residence. Flanking the gate are screen walls with exquisite brick carvings featuring auspicious patterns. Stepping through the Palace Gate, visitors enter the grand compound that witnessed the rise and fall of Heshen and Prince Gong Yixin across multiple reigns, feeling the weight of history that has accumulated over more than two centuries.</p>',
  0,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_prince_gong_mansion_bj_sa_02',
  'beijing_prince_gong_mansion',
  'Yin''an Hall and Jiale Hall',
  '银安殿与嘉乐堂',
  '<p>Yin''an Hall is the architectural centerpiece of the mansion''s central axis, serving as the venue for the prince''s administrative affairs, receptions, and major ceremonies. It spans seven bays with a green-tiled gable-and-hip roof, and its spacious front platform ranks just below the Hall of Supreme Harmony in the imperial palace. The interior was once luxuriously furnished. Behind it stands Jiale Hall, an important living and banqueting space whose name evokes "virtuous words and harmonious joy." Jiale Hall once housed a vast collection of precious antiques, calligraphy, and paintings, making it the cultural heart of the mansion. The two halls form the most solemn architectural sequence on the central axis, reflecting the classic Qing Dynasty princely layout of "front hall, rear quarters."</p>',
  1,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_prince_gong_mansion_bj_sa_03',
  'beijing_prince_gong_mansion',
  'Baoguang Chamber and Xijin Studio',
  '葆光室与锡晋斋',
  '<p>Baoguang Chamber, located in the western compound, takes its name from the Zhuangzi concept of "harbored light," symbolizing restraint and inner brilliance. It served as a space for quiet study and meditation, with elegant interior decorations and exquisitely carved wooden partitions. Xijin Studio is one of the most legendary buildings in the mansion, said to have been built by Heshen in imitation of the Palace of Tranquil Longevity in the Forbidden City. Its interior features a golden-thread nanmu wood mezzanine with fully carved surfaces of extraordinary luxury, which later became one of the charges against Heshen for overstepping his rank. Prince Gong Yixin subsequently stored Lu Ji''s famous "Pingfu Tie" calligraphy scroll here, giving the studio its name. Together, the two buildings—one serene, one opulent—reveal the dual character of scholarly refinement and powerful grandeur that defines the mansion.</p>',
  2,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_prince_gong_mansion_bj_sa_04',
  'beijing_prince_gong_mansion',
  'Rear Cover Building',
  '后罩楼',
  '<p>The Rear Cover Building is one of the most striking structures in Prince Gong''s Mansion. Stretching approximately 180 meters from east to west with over forty rooms on two levels, it spans the entire northern boundary of the residence like a barrier separating the living quarters from the garden behind. Legend holds that this was Heshen''s treasure house, with hidden compartments and niches in each room storing gold, silver, jewels, and precious artifacts. When Heshen was arrested, the wealth confiscated from this building was staggering, giving rise to the popular saying "When Heshen falls, Jiaqing is full." The building features massive walls and windows of varied shapes—some square, some round—serving both decorative and practical purposes of ventilation and security. Walking beneath it and gazing up at the continuous facade, one can almost feel the overwhelming ambition of the once all-powerful Heshen.</p>',
  3,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_prince_gong_mansion_bj_sa_05',
  'beijing_prince_gong_mansion',
  'Western-Style Gate and Dule Peak',
  '西洋门与独乐峰',
  '<p>The Western-Style Gate is the main entrance to Cuijin Garden, the garden of Prince Gong''s Mansion. Constructed from carved white marble, its arch combines Baroque-style elements with traditional Chinese decorative motifs—an extraordinary rarity among Qing Dynasty princely residences, said to reflect Heshen''s fondness for exotic Western aesthetics. The gate''s lintel bears four characters reading "Tranquility Harbors Antiquity," evoking a timeless serenity. Just beyond the gate stands Dule Peak, a natural Taihu stone rising about five meters high with a craggy, dramatic form. From the front, it resembles a Guanyin bestowing children; from the back, a leaping carp. The name "Dule" means "enjoying solitude," suggesting a retreat where scholars savor the pleasures of nature alone. A pool beneath the stone creates delightful reflections, forming the garden''s first scenic vista that calms the spirit before one even enters.</p>',
  4,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_prince_gong_mansion_bj_sa_06',
  'beijing_prince_gong_mansion',
  'Bat Pool and Anshan Hall',
  '蝠池与安善堂',
  '<p>Bat Pool is the central water feature of the mansion''s garden, named for its shape resembling a bat with outstretched wings. In Chinese culture, the word for bat (蝠) is homophonous with the word for fortune (福), making the bat a powerful symbol of blessings. Elms were originally planted along the pool, as the word for elm (榆) sounds like "surplus" (余), conveying wishes for abundance year after year. The pool''s clear waters reflect the sky and clouds in all seasons, while koi swim among the lily pads. To the north stands Anshan Hall, whose name means "dwelling in virtue," an elegant space for receiving guests, sipping tea, and composing poetry. With water before it and hill behind, the hall seamlessly integrates architecture and nature, embodying the supreme ideal of Chinese classical gardens—"though made by human hands, it seems born of nature itself."</p>',
  5,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_prince_gong_mansion_bj_sa_07',
  'beijing_prince_gong_mansion',
  'Winding Cup Pavilion, Bamboo Courtyard, and Peony Garden',
  '流杯亭、竹子院与牡丹园',
  '<p>The Winding Cup Pavilion is the most literary and refined structure in the garden. Its stone floor is carved with a water channel shaped like the character for "longevity" (寿). Water flows through the channel, and wine cups float downstream—wherever a cup stops, the person before it drinks and composes a poem. This is the ancient elegant pastime of "winding stream party," originating from Wang Xizhi''s famous gathering at the Orchid Pavilion. The Bamboo Courtyard nearby is filled with tall bamboo creating a tranquil, secluded atmosphere; when the wind passes through the treetops, the rustling leaves transport visitors to a Jiangnan landscape. The Peony Garden cultivates numerous rare varieties of peonies. Every April and May, the flowers bloom in a spectacular display—golden Yao Yellow, purple Wei Purple, pink Zhao Pink, and green Dou Green—each vying in beauty and grandeur. The three sites progress from literary elegance to serene seclusion to brilliant splendor, each with its own distinct charm.</p>',
  6,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_prince_gong_mansion_bj_sa_08',
  'beijing_prince_gong_mansion',
  'Yishen Chamber and Bat Hall',
  '怡神所与蝠厅',
  '<p>Yishen Chamber is a tranquil retreat for cultivating the spirit, nestled among towering ancient trees with deep shade and a serene atmosphere. Its name means "nourishing the mind and spirit," and it was the ideal place for the mansion''s master to rest in solitude and restore body and soul. Its architectural layout is ingeniously integrated with the surrounding landscape of rocks, water, and plants. Bat Hall is a uniquely shaped building whose floor plan resembles a bat with outstretched wings, hence its name. It echoes the Bat Pool, reinforcing the theme of "fortune" (蝠/福). The interior is finely decorated, and the painted beams and brackets are well preserved, making it an important example for the study of Qing Dynasty architectural ornamentation. Tucked away in the deepest part of the garden, the hall offers visitors a sense of sudden revelation—a magnificent finale to the garden tour.</p>',
  7,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_prince_gong_mansion_bj_sa_09',
  'beijing_prince_gong_mansion',
  'Path to the Clouds, Moon-Inviting Terrace, Emerald Rock, and the "Fu" Stele',
  '平步青云路、邀月台、滴翠岩与福字碑',
  '<p>The Path to the Clouds is a stone-paved walkway built through layered rocks, winding upward with the auspicious meaning of "rising smoothly to the clouds," symbolizing a successful career and rising status. At the top lies the Moon-Inviting Terrace, named after Li Bai''s poem "I raise my cup to invite the moon," offering the finest spot for moon-viewing and panoramic vistas of the entire garden. Below the terrace stands Emerald Rock, a massive Taihu stone rockery with craggy surfaces draped in green vines and interior passages for exploration. Deep within the rockery lies the famous "Fu" (Fortune) stele, believed to be the handwritten calligraphy of Emperor Kangxi, executed with vigorous strokes and imposing grandeur. The character can be decomposed into four meanings—"many sons, many talents, many fields, and long life"—earning it the title "The Greatest Fortune Under Heaven." It is the treasure of Prince Gong''s Mansion and a must-visit pilgrimage site for those seeking blessings.</p>',
  8,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_prince_gong_mansion_bj_sa_10',
  'beijing_prince_gong_mansion',
  'Square Pond Pavilion, Miaoxiang Pavilion, Dragon King Temple, and Archery Range',
  '方塘水榭、妙香亭、龙王庙与箭道',
  '<p>The Square Pond Pavilion is an exquisite structure built over the Square Pond, surrounded by water on three sides. The pond is planted with lotus flowers; in summer, lush leaves and fragrant blossoms fill the air, and the pavilion appears to float on the water—an ideal summer retreat. Miaoxiang Pavilion sits beside the pond, its name meaning "wondrous fragrance spreads afar." Surrounded by flowering trees and shrubs that bloom across all four seasons, it is a perfect spot for enjoying flowers and tea. The Dragon King Temple is a small shrine dedicated to the Dragon King, reflecting ancient beliefs in praying for rain and blessings. Though modest in size, it is complete in layout and rich in antiquity. The Archery Range is the martial practice ground of the mansion, with ancient trees lining a long, straight, open path, embodying the Manchu aristocratic tradition of valuing both letters and martial arts and the ancestral heritage of horsemanship and archery. Together, the four neighboring sites present a portrait of the diverse lifestyle within the princely mansion.</p>',
  9,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_prince_gong_mansion_bj_sa_11',
  'beijing_prince_gong_mansion',
  'Ledao Hall and Duofu Pavilion',
  '乐道堂与多福轩',
  '<p>Ledao Hall was the living quarters of Prince Gong Yixin. Its name, meaning "finding joy in the Way," was personally inscribed by Yixin, expressing his commitment to Confucian moral ideals despite being embroiled in political turmoil. The hall retains elegant Qing Dynasty furnishings and scholar''s implements, with finely crafted window lattices and partitions, offering a precious glimpse into the daily life of a late Qing prince. Duofu Pavilion stands nearby, its name meaning "many sons, many blessings." It was the venue for family celebrations and the reception of inner-court relatives. The interior is hung with numerous plaques and couplets celebrating fortune and longevity, lavishly yet tastefully decorated, embodying wishes for a flourishing and enduring family. The two buildings—one emphasizing self-cultivation, the other family harmony—reflect different facets of Prince Gong Yixin''s spiritual world and domestic life.</p>',
  10,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_beihai_park_bj_sa_01',
  'beijing_beihai_park',
  'South Gate & Circular City',
  '南门与团城',
  '<p>The South Gate is the principal entrance to Beihai Park, framed by a spacious plaza and towering ancient trees that immediately convey a regal atmosphere. Just inside the gate lies the Circular City (Tuancheng), a round platform first built in the Jin dynasty and expanded under the Yuan. Though barely four thousand square metres, it packs extraordinary architectural and cultural value. The Chengguang Hall on the platform houses a white jade Buddha carved from a single block of jade in the Yuan dynasty, and the Jade Urn Pavilion before it displays the Dushan Great Jade Sea, a wine vessel from Kublai Khan''s reign—both national treasures. Ancient pines ring the platform, whose grey-brick walls are a rare military-architectural remnant within a garden; climbing up affords a panoramic view of the entire Beihai lake and park.</p>',
  0,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_beihai_park_bj_sa_02',
  'beijing_beihai_park',
  'Yong''an Bridge',
  '永安桥',
  '<p>Yong''an Bridge, first built in the Yuan dynasty and rebuilt in the Qing, is the park''s most iconic bridge. Over forty metres long and nearly nine metres wide, it features three graceful arches constructed entirely of white marble; the balustrade posts are carved with lotus-petal motifs, and the deck arches gently like a rainbow. The south end connects the Circular City, while the north end leads directly into the mountain gate of Yong''an Temple on Jade Flower Island—both a practical crossing and a superb viewing platform. Standing on the bridge, one looks south to ancient pines on Tuancheng, north to the towering White Dagoba, and east and west across rippling lotus-dotted waters—the quintessential Beihai composition. After snowfall the white-marble bridge merges with the snow into a fairyland, earning the phrase "Yong''an Snow Clearing."</p>',
  1,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_beihai_park_bj_sa_03',
  'beijing_beihai_park',
  'Jade Flower Island · Yong''an Temple & White Dagoba',
  '琼华岛·永安寺与白塔',
  '<p>Jade Flower Island is the lake-centred hill and the park''s highest point and visual anchor. Yong''an Temple on the island was founded in 1651 (Shunzhi 8) and expanded under Qianlong, ascending the slope in layered courtyards—from the Falun Hall at the mountain gate to the Zhengjue Hall above, the halls are solemn and incense has burned here for centuries. The White Dagoba at the summit stands 35.9 metres tall in Tibetan stupa form; its gleaming white body is crowned by a bronze canopy and gilded sun-and-moon finials that flash in sunlight. It was first erected to welcome the Fifth Dalai Lama to Beijing, bearing both political and religious significance. From the top, sweeping views capture the Forbidden City''s red walls and yellow roofs, the entire central axis, and the Western Hills—one of the most magnificent urban panoramas in Beijing.</p>',
  2,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_beihai_park_bj_sa_04',
  'beijing_beihai_park',
  'Jade Flower Island · Qiong Island Spring Shade Stele & Yuegu Tower',
  '琼华岛·琼岛春阴碑与阅古楼',
  '<p>The Qiong Island Spring Shade Stele stands on the mid-slope of Jade Flower Island''s east side. Its tall shaft bears four characters "Qiong Island Spring Shade" in Emperor Qianlong''s own hand, with his poem on the reverse. This scene originates from the "Eight Views of Yanjing" of the Jin dynasty, depicting the island''s dappled tree shadows and veiling mists in spring—the oldest landscape-aesthetic tradition in Beijing. Ancient trees cast deep shade around the stele, and in spring blooming crabapples and flowering peaches echo the inscription''s mood. Yuegu Tower, on the island''s northwest side, is a semi-circular two-storey pavilion built under Qianlong to house the Three Rarities Hall Model Calligraphy (Sanxitang Fatie) in stone. The collection gathers works by over 340 master calligraphers from Wei-Jin to late Ming, carved on 495 stone tablets—the largest engraved calligraphy anthology in Chinese history, a true treasury of brush and ink.</p>',
  3,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_beihai_park_bj_sa_05',
  'beijing_beihai_park',
  'Jade Flower Island · Yilan Hall, Daoning Studio & Bronze Immortal Holding Dew Plate',
  '琼华岛·漪澜堂、道宁斋与铜仙承露盘',
  '<p>Yilan Hall and Daoning Studio sit on Jade Flower Island''s north slope directly above the lake, forming the island''s most important palatial complex. Yilan Hall, five bays wide with a waterfront veranda, was where Emperor Qianlong often reviewed memorials and enjoyed the scenery over tea; Daoning Studio was his study, its name meaning "the Way lies in tranquillity"—quiet and refined. Both halls imitate Jiangnan garden style, blending imperial scale with literati sensibility. Behind them, on a higher terrace, stands the Bronze Immortal Holding a Dew Plate—a copper figure with both hands raised holding a plate, mounted on a stone column, replicating the Han-dynasty Jianzhang Palace dew-receiver. Legend says Emperor Wu of Han used such a figure to gather heavenly dew for elixirs; Qianlong recast it as a symbol of communion between heaven and man, receiving divine grace. The figure is fully gilded, blazing in sunlight, and is Beihai''s most mystically charged landmark.</p>',
  4,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_beihai_park_bj_sa_06',
  'beijing_beihai_park',
  'East Shore · Haopu Retreat & Painted Boat Studio',
  '东岸·濠濮间与画舫斋',
  '<p>Haopu Retreat lies mid-way along Beihai''s east shore—an exquisitely crafted enclosed water courtyard. A winding path leads through artificial rockwork and a festooned gate before revealing a pool ringed by corridors, a tiny stone bridge at its centre, and the Haopu plaque in Qianlong''s calligraphy. "Haopu" references Zhuangzi''s debate on the Hao Bridge and his fishing by the Pu River, evoking detachment and fish-happy self-sufficiency. Remote from palatial noise, this is the garden''s most literati-hermitic corner. The Painted Boat Studio (Huafang Zhai) sits just north of Haopu, its main building shaped like a boat moored on water, yet its interior follows a scholar''s layout—the front room named "Spring Rain on the Pond," the rear "Observing Wonder." Qianlong often read and composed poetry here. Winding corridors outside, draped in old vines, bring cool lotus-scented breezes in summer—an ideal retreat from heat.</p>',
  5,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_beihai_park_bj_sa_07',
  'beijing_beihai_park',
  'Jingxin Studio (Quiet Heart Studio)',
  '静心斋',
  '<p>Jingxin Studio occupies the northwest corner of Beihai''s north shore. Founded in 1757 (Qianlong 22) as "Jingqing Studio" and later renamed, it was the emperor''s personal reading-and-resting retreat, modelled on Jiangnan private gardens. Though only about eight thousand square metres, it contains rockwork hills, winding pools, cloistered corridors, pavilions, tiny bridges and flowing water—every garden element packed into a "small yet vast" masterclass. The Qinquan Corridor spans the water; Diedie Tower crowns the artificial hill; the Bake-Tea Hut and String-Music Studio scatter among rich spatial layers. Taihu limestone crags are jagged and varied, their caves deep, shifting vistas with every step. Empress Dowager Cixi summered and governed here; Yuan Shikai used it for diplomatic talks—proof that this garden''s magic has enchanted every era.</p>',
  6,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_beihai_park_bj_sa_08',
  'beijing_beihai_park',
  'Western Heavenly Paradise & Nine-Dragon Wall',
  '西天梵境与九龙壁',
  '<p>Western Heavenly Paradise (also called Great Western Heaven) sits mid-section of Beihai''s north shore. Founded in the Ming and rebuilt in the Qing, it served as the imperial family''s private Buddhist temple. The Mahavira Hall inside enshrines the Three Buddhas; the stone pillars and incense burners before it are Qing masterworks. The hall''s yellow-glazed tiles with green trim denote a rank just below the palace itself. Behind the temple once stood a grand stupa courtyard, now partially lost yet still hinting at its former majesty. The Nine-Dragon Wall stands immediately east of the temple, built in 1756 (Qianlong 21). It measures 25.86 m long, 6.65 m high, and 1.42 m thick, with nine glazed dragons on each face—18 in total—in yellow, green, blue, purple and white. Each dragon poses differently, leaping through cloud-seas and wave-crests. This is the best-preserved and most skillfully crafted of China''s three surviving double-sided Nine-Dragon Walls; every scale is delineated, every whisker flies—a supreme achievement of Qing glazed-tile art.</p>',
  7,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_beihai_park_bj_sa_09',
  'beijing_beihai_park',
  'Kuai Xue Tang (Quick Snow Hall) & Iron Shadow Wall',
  '快雪堂与铁影壁',
  '<p>Kuai Xue Tang sits on Beihai''s north shore between Western Heavenly Paradise and Chanfu Temple, founded in 1779 (Qianlong 44). Obsessed with Wang Xizhi''s brushwork, the emperor ordered this hall built in pine-wood Jiangnan style to house engraved reproductions of the "Quick Snow Clearing" letter and other master calligraphy rubbings in stone. Fine nanmu woodwork graces the interior; the courtyard is open and airy—an imperial building that radiates literati refinement, another bastion of calligraphy culture in the park. The Iron Shadow Wall, a Yuan-dynasty relic originally at Desheng Gate, was later moved here. Carved from volcanic rock (locally called "iron stone"), it is so hard it earned the name "Iron Shadow Wall." Relief carvings of lions and rhinoceroses on its faces are bold and archaic, preserving the rugged vigour of Yuan sculpture—one of Beijing''s few surviving Yuan stone-carving artefacts. Its stark power contrasts vividly with Kuai Xue Tang''s delicate grace—one martial, one literary, mirroring each other across time.</p>',
  8,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_beihai_park_bj_sa_10',
  'beijing_beihai_park',
  'Chanfu Temple & Little Western Heaven',
  '阐福寺与小西天',
  '<p>Chanfu Temple stands on the west segment of Beihai''s north shore, founded in 1760 (Qianlong 25) as Emperor Qianlong''s votive offering for his mother''s longevity. The main hall spans seven bays under yellow glazed tiles—a lofty rank—and once housed a bronze Thousand-Armed Thousand-Eyed Avalokiteshvara, now lost. The bell tower, drum tower and mountain gate remain intact, still conveying the solemnity of an imperial Buddhist sanctuary. Little Western Heaven (Xiao Xitian) lies just north of Chanfu Temple, built in 1770 (Qianlong 35) for the empress dowager''s eightieth birthday, mimicking the South Sea Bodhisattva realm. Its central "Pure Land" square pavilion measures 52.23 m wide and 42.32 m deep—the largest square-pavilion structure in China. Inside, the four walls carry suspended sculptures of Avalokiteshvara rescuing sentient beings; five hundred arhats crossing the sea are vividly alive. Outside, multicoloured glazed tiles blaze against the lake light—a vision of staggering grandeur.</p>',
  9,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO sub_areas (
  id, attraction_id, name_en, name_zh, body, sort_order, is_active
) VALUES (
  'beijing_beihai_park_bj_sa_11',
  'beijing_beihai_park',
  'Five Dragon Pavilions',
  '五龙亭',
  '<p>The Five Dragon Pavilions jut into the lake from the mid-section of Beihai''s north shore, built under Ming Emperor Jiajing and rebuilt in the Qing. Five pavilions line up in a row extending into the water: the central one, Dragon-Blessing Pavilion (Longze), is largest; flanking it are Clear-Blessing (Chengxiang) and Nourishing-Fragrance (Zixiang), with two smaller outer pavilions beyond. Stone bridges link them, and the ensemble resembles five dragons floating on water—hence the name. The central pavilion is a double-eaved square structure under yellow glazed tiles (highest rank); the others step down in size under green tiles, creating a tiered, hierarchically clear waterside cluster. Dragons and phoenixes adorn the eaves; limitless blue waves spread below. Spring and autumn for lotus, winter for snow, mid-autumn for moonlight—every season offers a scene. Qing emperors and empresses often fished and moon-watched here; Empress Dowager Cixi especially loved mid-autumn banquets with lanterns—the most romantically evocative complex in Beihai.</p>',
  10,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  attraction_id = EXCLUDED.attraction_id,
  name_en = EXCLUDED.name_en,
  name_zh = EXCLUDED.name_zh,
  body = EXCLUDED.body,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();
