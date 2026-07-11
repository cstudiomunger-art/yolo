-- 子景点解说音频 audio_url 全量绑定 SQL
-- 生成时间: 2026-07-09T10:56:52.206Z
-- 绑定条目: 717
-- 说明: 按 Benedict 文件名 ↔ 子景点名匹配；上海 12 景点为硬编码映射
-- 在 Supabase SQL Editor 中整段执行即可

BEGIN;

-- 北海公园 (beijing_beihai_park)
-- A_EN_Benedict_1.South Gate and Round City.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_beihai_park_001.mp3', updated_at = NOW() WHERE id = 'beijing_beihai_park_bj_sa_01';

-- A_EN_Benedict_2.Yong'an Bridge.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_beihai_park_002.mp3', updated_at = NOW() WHERE id = 'beijing_beihai_park_bj_sa_02';

-- A_EN_Benedict_3.Qionghua Island · Yong'an Temple and the White Pagoda.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_beihai_park_003.mp3', updated_at = NOW() WHERE id = 'beijing_beihai_park_bj_sa_03';

-- A_EN_Benedict_4.Qionghua Island · Qiongdao Chunyin Stele and Yuegu Tower.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_beihai_park_004.mp3', updated_at = NOW() WHERE id = 'beijing_beihai_park_bj_sa_04';

-- A_EN_Benedict_5.Qionghua Island · Yilan Hall, Daoning Studio, and the Bronze Immortal's Vessel.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_beihai_park_005.mp3', updated_at = NOW() WHERE id = 'beijing_beihai_park_bj_sa_05';

-- A_EN_Benedict_6.East Shore · Haopujian and Huafang Studio.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_beihai_park_006.mp3', updated_at = NOW() WHERE id = 'beijing_beihai_park_bj_sa_06';

-- A_EN_Benedict_7.Jingxin Studio.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_beihai_park_007.mp3', updated_at = NOW() WHERE id = 'beijing_beihai_park_bj_sa_07';

-- A_EN_Benedict_8.Xitian Fanjing and the Nine-Dragon Wall.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_beihai_park_008.mp3', updated_at = NOW() WHERE id = 'beijing_beihai_park_bj_sa_08';

-- A_EN_Benedict_9.Kuaixue Tang and the Iron Shadow Wall.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_beihai_park_009.mp3', updated_at = NOW() WHERE id = 'beijing_beihai_park_bj_sa_09';

-- A_EN_Benedict_10.Chanfu Temple and Xiaoxitian.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_beihai_park_010.mp3', updated_at = NOW() WHERE id = 'beijing_beihai_park_bj_sa_10';

-- 故宫 (beijing_forbidden_city)
-- A_EN_Benedict_1.Meridian Gate and the Golden Water Bridges.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_forbidden_city_001.mp3', updated_at = NOW() WHERE id = 'beijing_forbidden_city_bj_sa_01';

-- A_EN_Benedict_2.Gate of Supreme Harmony and the Eastern and Western Flanks of the Outer Court.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_forbidden_city_002.mp3', updated_at = NOW() WHERE id = 'beijing_forbidden_city_bj_sa_11';

-- A_EN_Benedict_3.Hall of Supreme Harmony.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_forbidden_city_003.mp3', updated_at = NOW() WHERE id = 'beijing_forbidden_city_bj_sa_03';

-- A_EN_Benedict_4.Hall of Central Harmony and Hall of Preserving Harmony.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_forbidden_city_004.mp3', updated_at = NOW() WHERE id = 'beijing_forbidden_city_bj_sa_05';

-- A_EN_Benedict_5.The Rear Three Palaces - Palace of Heavenly Purity, Hall of Union and Palace of Earthly Tranquility.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_forbidden_city_005.mp3', updated_at = NOW() WHERE id = 'beijing_forbidden_city_bj_sa_07';

-- A_EN_Benedict_6.Hall of Mental Cultivation and the Grand Council Office.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_forbidden_city_006.mp3', updated_at = NOW() WHERE id = 'beijing_forbidden_city_bj_sa_04';

-- A_EN_Benedict_7.The Six Eastern and Six Western Palaces.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_forbidden_city_007.mp3', updated_at = NOW() WHERE id = 'beijing_forbidden_city_bj_sa_02';

-- A_EN_Benedict_8.Palace of Compassion and Tranquility - Sculpture Gallery.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_forbidden_city_008.mp3', updated_at = NOW() WHERE id = 'beijing_forbidden_city_bj_sa_08';

-- A_EN_Benedict_9.Hall of Ancestral Worship - Clock and Watch Gallery and Palace of Tranquil Longevity - Treasures Gallery.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_forbidden_city_009.mp3', updated_at = NOW() WHERE id = 'beijing_forbidden_city_bj_sa_06';

-- A_EN_Benedict_10.Qianlong Garden and the Imperial Garden.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_forbidden_city_010.mp3', updated_at = NOW() WHERE id = 'beijing_forbidden_city_bj_sa_10';

-- 雍和宫 (beijing_lama_temple)
-- A_EN_Benedict_1.Archway Courtyard and Zhaotai Gate.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_lama_temple_001.mp3', updated_at = NOW() WHERE id = 'beijing_lama_temple_bj_sa_01';

-- A_EN_Benedict_2.Bell and Drum Towers and Hall of the Heavenly Kings.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_lama_temple_002.mp3', updated_at = NOW() WHERE id = 'beijing_lama_temple_bj_sa_02';

-- A_EN_Benedict_3.Stele of On Lamas and Bronze Mount Sumeru.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_lama_temple_003.mp3', updated_at = NOW() WHERE id = 'beijing_lama_temple_bj_sa_03';

-- A_EN_Benedict_4.Main Hall.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_lama_temple_004.mp3', updated_at = NOW() WHERE id = 'beijing_lama_temple_bj_sa_04';

-- A_EN_Benedict_5.Hall of Eternal Blessing.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_lama_temple_005.mp3', updated_at = NOW() WHERE id = 'beijing_lama_temple_bj_sa_05';

-- A_EN_Benedict_6.The Four Dratsangs.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_lama_temple_006.mp3', updated_at = NOW() WHERE id = 'beijing_lama_temple_bj_sa_06';

-- A_EN_Benedict_7.Hall of the Wheel of the Law.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_lama_temple_007.mp3', updated_at = NOW() WHERE id = 'beijing_lama_temple_bj_sa_07';

-- A_EN_Benedict_8.Pavilion of Ten Thousand Happinesses.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_lama_temple_008.mp3', updated_at = NOW() WHERE id = 'beijing_lama_temple_bj_sa_08';

-- 十三陵 (beijing_ming_tombs)
-- A_EN_Benedict_1.Stone Memorial Archway and Great Red Gate.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_ming_tombs_001.mp3', updated_at = NOW() WHERE id = 'beijing_ming_tombs_bj_sa_01';

-- A_EN_Benedict_2.Stele Pavilion and Sacred Way.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_ming_tombs_002.mp3', updated_at = NOW() WHERE id = 'beijing_ming_tombs_bj_sa_02';

-- A_EN_Benedict_3.Stone Statues and Lingxing Gate.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_ming_tombs_003.mp3', updated_at = NOW() WHERE id = 'beijing_ming_tombs_bj_sa_03';

-- A_EN_Benedict_4.Changling and the Museum.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_ming_tombs_004.mp3', updated_at = NOW() WHERE id = 'beijing_ming_tombs_bj_sa_04';

-- A_EN_Benedict_5.Dingling and the Underground Palace.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_ming_tombs_005.mp3', updated_at = NOW() WHERE id = 'beijing_ming_tombs_bj_sa_05';

-- A_EN_Benedict_6.Zhaoling.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_ming_tombs_006.mp3', updated_at = NOW() WHERE id = 'beijing_ming_tombs_bj_sa_06';

-- A_EN_Benedict_7.Jingling, Kangling, and Yongling.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_ming_tombs_007.mp3', updated_at = NOW() WHERE id = 'beijing_ming_tombs_bj_sa_07';

-- 慕田峪长城 (beijing_mutianyu_great_wall)
-- A_EN_Benedict_1.Great Corner Tower.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_mutianyu_great_wall_001.mp3', updated_at = NOW() WHERE id = 'beijing_mutianyu_great_wall_bj_sa_01';

-- A_EN_Benedict_2.Zhengguan Terrace.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_mutianyu_great_wall_002.mp3', updated_at = NOW() WHERE id = 'beijing_mutianyu_great_wall_bj_sa_06';

-- A_EN_Benedict_3.Tower No.6 and the Cable Car Station.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_mutianyu_great_wall_003.mp3', updated_at = NOW() WHERE id = 'beijing_mutianyu_great_wall_bj_sa_03';

-- A_EN_Benedict_4.Filming Location of If You Are the One 2.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_mutianyu_great_wall_004.mp3', updated_at = NOW() WHERE id = 'beijing_mutianyu_great_wall_bj_sa_04';

-- A_EN_Benedict_5.Stone Inscription and Boundary Tablet.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_mutianyu_great_wall_005.mp3', updated_at = NOW() WHERE id = 'beijing_mutianyu_great_wall_bj_sa_05';

-- 国博 (beijing_national_museum)
-- A_EN_Benedict_1.Ancient China.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_national_museum_001.mp3', updated_at = NOW() WHERE id = 'beijing_national_museum_bj_sa_01';

-- A_EN_Benedict_2.The Road to Rejuvenation.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_national_museum_002.mp3', updated_at = NOW() WHERE id = 'beijing_national_museum_bj_sa_02';

-- A_EN_Benedict_3.Second Floor Galleries - Science, Standing in the East, Red Flags, and Blanc de Chine.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_national_museum_003.mp3', updated_at = NOW() WHERE id = 'beijing_national_museum_bj_sa_08';

-- A_EN_Benedict_4.Ancient Chinese Porcelain.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_national_museum_004.mp3', updated_at = NOW() WHERE id = 'beijing_national_museum_bj_sa_04';

-- A_EN_Benedict_5.Ancient Chinese Jade.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_national_museum_005.mp3', updated_at = NOW() WHERE id = 'beijing_national_museum_bj_sa_05';

-- A_EN_Benedict_6.Ancient Chinese Coins and Bronze Mirrors.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_national_museum_006.mp3', updated_at = NOW() WHERE id = 'beijing_national_museum_bj_sa_06';

-- A_EN_Benedict_7.Ancient Chinese Buddhist Sculpture.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_national_museum_007.mp3', updated_at = NOW() WHERE id = 'beijing_national_museum_bj_sa_07';

-- A_EN_Benedict_8.Ancient Chinese Costume and Food Culture.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_national_museum_008.mp3', updated_at = NOW() WHERE id = 'beijing_national_museum_bj_sa_03';

-- A_EN_Benedict_9.Rhinoceros Zun Digital Gallery and Qing Dynasty Calligraphy.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_national_museum_009.mp3', updated_at = NOW() WHERE id = 'beijing_national_museum_bj_sa_09';

-- 恭王府 (beijing_prince_gong_mansion)
-- A_EN_Benedict_1.The Palace Gate.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_prince_gong_mansion_001.mp3', updated_at = NOW() WHERE id = 'beijing_prince_gong_mansion_bj_sa_01';

-- A_EN_Benedict_2.The Hall of Silver Peace and the Hall of Joyful Music.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_prince_gong_mansion_002.mp3', updated_at = NOW() WHERE id = 'beijing_prince_gong_mansion_bj_sa_02';

-- A_EN_Benedict_3.The Hall of Hidden Light and the Hall of Xi Jin.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_prince_gong_mansion_003.mp3', updated_at = NOW() WHERE id = 'beijing_prince_gong_mansion_bj_sa_09';

-- A_EN_Benedict_4.The Rear Mansion Building.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_prince_gong_mansion_004.mp3', updated_at = NOW() WHERE id = 'beijing_prince_gong_mansion_bj_sa_04';

-- A_EN_Benedict_5.The Western-Style Gate and the Rock of Solitary Joy.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_prince_gong_mansion_005.mp3', updated_at = NOW() WHERE id = 'beijing_prince_gong_mansion_bj_sa_05';

-- A_EN_Benedict_6.Bat Pond and the Hall of Good Peace.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_prince_gong_mansion_006.mp3', updated_at = NOW() WHERE id = 'beijing_prince_gong_mansion_bj_sa_06';

-- A_EN_Benedict_7.The Floating Cup Pavilion, the Bamboo Courtyard and the Peony Garden.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_prince_gong_mansion_007.mp3', updated_at = NOW() WHERE id = 'beijing_prince_gong_mansion_bj_sa_07';

-- A_EN_Benedict_8.The Hall of Spirit's Delight and Bat Hall.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_prince_gong_mansion_008.mp3', updated_at = NOW() WHERE id = 'beijing_prince_gong_mansion_bj_sa_08';

-- A_EN_Benedict_9.Rise-to-Prominence Path, the Moon-Inviting Terrace, Dripping Emerald Rock and the Fortune Stele.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_prince_gong_mansion_009.mp3', updated_at = NOW() WHERE id = 'beijing_prince_gong_mansion_bj_sa_03';

-- A_EN_Benedict_10.The Square Pond Waterside Pavilion, Miao Xiang Pavilion, Dragon King Temple and the Archery Lane.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_prince_gong_mansion_010.mp3', updated_at = NOW() WHERE id = 'beijing_prince_gong_mansion_bj_sa_10';

-- 颐和园 (beijing_summer_palace)
-- A_EN_Benedict_1.East Palace Gate and Hall of Benevolence and Longevity.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_summer_palace_001.mp3', updated_at = NOW() WHERE id = 'beijing_summer_palace_bj_sa_01';

-- A_EN_Benedict_2.Garden of Virtue and Harmony.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_summer_palace_002.mp3', updated_at = NOW() WHERE id = 'beijing_summer_palace_bj_sa_02';

-- A_EN_Benedict_3.Hall of Jade Ripples and Hall of Joyful Longevity.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_summer_palace_003.mp3', updated_at = NOW() WHERE id = 'beijing_summer_palace_bj_sa_03';

-- A_EN_Benedict_4.Long Corridor.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_summer_palace_004.mp3', updated_at = NOW() WHERE id = 'beijing_summer_palace_bj_sa_04';

-- A_EN_Benedict_5.Hall of Dispelling Clouds, Tower of Buddhist Incense and Sea of Wisdom.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_summer_palace_005.mp3', updated_at = NOW() WHERE id = 'beijing_summer_palace_bj_sa_05';

-- A_EN_Benedict_6.Marble Boat.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_summer_palace_006.mp3', updated_at = NOW() WHERE id = 'beijing_summer_palace_bj_sa_06';

-- A_EN_Benedict_7.Kunming Lake.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_summer_palace_007.mp3', updated_at = NOW() WHERE id = 'beijing_summer_palace_bj_sa_07';

-- A_EN_Benedict_8.Seventeen-Arch Bridge and South Lake Island.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_summer_palace_008.mp3', updated_at = NOW() WHERE id = 'beijing_summer_palace_bj_sa_08';

-- A_EN_Benedict_9.Bronze Ox.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_summer_palace_009.mp3', updated_at = NOW() WHERE id = 'beijing_summer_palace_bj_sa_09';

-- 天坛 (beijing_temple_of_heaven)
-- A_EN_Benedict_1.Circular Mound Altar.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_temple_of_heaven_001.mp3', updated_at = NOW() WHERE id = 'beijing_temple_of_heaven_bj_sa_01';

-- A_EN_Benedict_2.Imperial Vault of Heaven and Echo Wall.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_temple_of_heaven_002.mp3', updated_at = NOW() WHERE id = 'beijing_temple_of_heaven_bj_sa_02';

-- A_EN_Benedict_4.Hall of Praying for Good Harvests.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/beijing_temple_of_heaven_004.mp3', updated_at = NOW() WHERE id = 'beijing_temple_of_heaven_bj_sa_04';

-- 成都博物馆 (chengdu_museum)
-- A_EN_Benedict_1.正门大厅.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chengdu_museum_001.mp3', updated_at = NOW() WHERE id = 'chengdu_museum_sa_10';

-- A_EN_Benedict_2.二楼·九天开出一成都——先秦时期的成都.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chengdu_museum_002.mp3', updated_at = NOW() WHERE id = 'chengdu_museum_sa_01';

-- A_EN_Benedict_3.二楼·西蜀称天府——两汉魏晋南北朝时期的成都.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chengdu_museum_003.mp3', updated_at = NOW() WHERE id = 'chengdu_museum_sa_02';

-- A_EN_Benedict_4.三楼·喧然名都会——隋唐五代宋元时期的成都.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chengdu_museum_004.mp3', updated_at = NOW() WHERE id = 'chengdu_museum_sa_05';

-- A_EN_Benedict_5.三楼·丹楼生晚辉——明清时期的成都.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chengdu_museum_005.mp3', updated_at = NOW() WHERE id = 'chengdu_museum_sa_04';

-- A_EN_Benedict_6.四楼·花重锦官城——成都历史文化陈列（近世篇）.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chengdu_museum_006.mp3', updated_at = NOW() WHERE id = 'chengdu_museum_sa_06';

-- A_EN_Benedict_7.四楼·花重锦官城——成都历史文化陈列（民俗篇）.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chengdu_museum_007.mp3', updated_at = NOW() WHERE id = 'chengdu_museum_sa_07';

-- A_EN_Benedict_8.五楼·影舞万象——中国皮影展.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chengdu_museum_008.mp3', updated_at = NOW() WHERE id = 'chengdu_museum_sa_09';

-- A_EN_Benedict_9.五楼·偶戏大千——中国木偶展.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chengdu_museum_009.mp3', updated_at = NOW() WHERE id = 'chengdu_museum_sa_08';

-- A_EN_Benedict_10.负一楼·人与自然——贝林捐赠展.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chengdu_museum_010.mp3', updated_at = NOW() WHERE id = 'chengdu_museum_sa_03';

-- 武侯祠 (chengdu_wuhou_shrine)
-- A_EN_Benedict_1.南门与照壁.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chengdu_wuhou_shrine_001.mp3', updated_at = NOW() WHERE id = 'chengdu_wuhou_shrine_sa_01';

-- A_EN_Benedict_2.大门（汉昭烈庙）.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chengdu_wuhou_shrine_002.mp3', updated_at = NOW() WHERE id = 'chengdu_wuhou_shrine_sa_02';

-- A_EN_Benedict_3.二门与唐碑（三绝碑）.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chengdu_wuhou_shrine_003.mp3', updated_at = NOW() WHERE id = 'chengdu_wuhou_shrine_sa_03';

-- A_EN_Benedict_4.刘备殿（汉昭烈庙正殿）.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chengdu_wuhou_shrine_004.mp3', updated_at = NOW() WHERE id = 'chengdu_wuhou_shrine_sa_04';

-- A_EN_Benedict_5.过厅（出师表石刻）.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chengdu_wuhou_shrine_005.mp3', updated_at = NOW() WHERE id = 'chengdu_wuhou_shrine_sa_05';

-- A_EN_Benedict_6.诸葛亮殿（静远堂）.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chengdu_wuhou_shrine_006.mp3', updated_at = NOW() WHERE id = 'chengdu_wuhou_shrine_sa_06';

-- A_EN_Benedict_7.三义庙.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chengdu_wuhou_shrine_007.mp3', updated_at = NOW() WHERE id = 'chengdu_wuhou_shrine_sa_07';

-- A_EN_Benedict_8.桂荷楼、琴亭与园林区.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chengdu_wuhou_shrine_008.mp3', updated_at = NOW() WHERE id = 'chengdu_wuhou_shrine_sa_08';

-- A_EN_Benedict_9.惠陵（刘备墓）.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chengdu_wuhou_shrine_009.mp3', updated_at = NOW() WHERE id = 'chengdu_wuhou_shrine_sa_09';

-- 白象居 (chongqing_baixiangju)
-- A_EN_Benedict_1.Floor 1 — Riverside Entrance (Starting Point).mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_baixiangju_001.mp3', updated_at = NOW() WHERE id = 'chongqing_baixiangju_sa_03';

-- A_EN_Benedict_2.Floor 10 — Sky Public Corridor.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_baixiangju_002.mp3', updated_at = NOW() WHERE id = 'chongqing_baixiangju_sa_01';

-- A_EN_Benedict_3.Yangtze Cable Car Frame Window.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_baixiangju_003.mp3', updated_at = NOW() WHERE id = 'chongqing_baixiangju_sa_04';

-- A_EN_Benedict_4.Floor 15 — Jiefang East Road Exit (Final Stop).mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_baixiangju_004.mp3', updated_at = NOW() WHERE id = 'chongqing_baixiangju_sa_02';

-- 磁器口古镇 (chongqing_ciqikou_old_town)
-- A_EN_Benedict_1.Huangjueping Archway.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_ciqikou_old_town_001.mp3', updated_at = NOW() WHERE id = 'chongqing_ciqikou_old_town_sa_01';

-- A_EN_Benedict_2.Zhong Family Courtyard.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_ciqikou_old_town_002.mp3', updated_at = NOW() WHERE id = 'chongqing_ciqikou_old_town_sa_02';

-- A_EN_Benedict_3.Baoshan Palace.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_ciqikou_old_town_003.mp3', updated_at = NOW() WHERE id = 'chongqing_ciqikou_old_town_sa_03';

-- A_EN_Benedict_4.Xinji General Store.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_ciqikou_old_town_004.mp3', updated_at = NOW() WHERE id = 'chongqing_ciqikou_old_town_sa_08';

-- A_EN_Benedict_5.Jusenmao Sauce Garden Site.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_ciqikou_old_town_005.mp3', updated_at = NOW() WHERE id = 'chongqing_ciqikou_old_town_sa_05';

-- A_EN_Benedict_6.Ciheng Street.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_ciqikou_old_town_006.mp3', updated_at = NOW() WHERE id = 'chongqing_ciqikou_old_town_sa_06';

-- A_EN_Benedict_7.Baolun Temple.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_ciqikou_old_town_007.mp3', updated_at = NOW() WHERE id = 'chongqing_ciqikou_old_town_sa_07';

-- A_EN_Benedict_9.Jiushigang Riverbank.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_ciqikou_old_town_009.mp3', updated_at = NOW() WHERE id = 'chongqing_ciqikou_old_town_sa_09';

-- A_EN_Benedict_10.Ciqikou Changge Experience Hall.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_ciqikou_old_town_010.mp3', updated_at = NOW() WHERE id = 'chongqing_ciqikou_old_town_sa_10';

-- 大足石刻 (chongqing_dazu_rock_carvings)
-- 宝顶山/A_EN_Benedict_1.Visitor Center.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_dazu_rock_carvings_001.mp3', updated_at = NOW() WHERE id = 'chongqing_dazu_rock_carvings_sa_01';

-- 北山景区/A_EN_Benedict_10.Beishan Scenic Area Exit.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_dazu_rock_carvings_025.mp3', updated_at = NOW() WHERE id = 'chongqing_dazu_rock_carvings_sa_02';

-- 大足石刻博物馆/A_EN_Benedict_4.History and Art of the Dazu Rock Carvings.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_dazu_rock_carvings_029.mp3', updated_at = NOW() WHERE id = 'chongqing_dazu_rock_carvings_sa_03';

-- 南山景区/A_EN_Benedict_8.Nanshan Scenic Area Exit.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_dazu_rock_carvings_040.mp3', updated_at = NOW() WHERE id = 'chongqing_dazu_rock_carvings_sa_04';

-- 石门山景区/A_EN_Benedict_7.Shimenshan Scenic Area Exit.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_dazu_rock_carvings_047.mp3', updated_at = NOW() WHERE id = 'chongqing_dazu_rock_carvings_sa_05';

-- 石篆山景区/A_EN_Benedict_7.Shizhuanshan Scenic Area Exit.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_dazu_rock_carvings_054.mp3', updated_at = NOW() WHERE id = 'chongqing_dazu_rock_carvings_sa_06';

-- 鹅岭二厂文创公园 (chongqing_eling_2nd_factory)
-- A_EN_Benedict_1.Main Entrance.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_eling_2nd_factory_001.mp3', updated_at = NOW() WHERE id = 'chongqing_eling_2nd_factory_sa_01';

-- A_EN_Benedict_2.Ercchang Memory Museum.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_eling_2nd_factory_002.mp3', updated_at = NOW() WHERE id = 'chongqing_eling_2nd_factory_sa_02';

-- A_EN_Benedict_3.Former Republic of China Central Bank Banknote Printing Factory (Building 9).mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_eling_2nd_factory_003.mp3', updated_at = NOW() WHERE id = 'chongqing_eling_2nd_factory_sa_03';

-- A_EN_Benedict_4.Test Design Lane.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_eling_2nd_factory_004.mp3', updated_at = NOW() WHERE id = 'chongqing_eling_2nd_factory_sa_04';

-- A_EN_Benedict_5.Test Joy Lane.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_eling_2nd_factory_005.mp3', updated_at = NOW() WHERE id = 'chongqing_eling_2nd_factory_sa_05';

-- A_EN_Benedict_6.Test Spirit Lane.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_eling_2nd_factory_006.mp3', updated_at = NOW() WHERE id = 'chongqing_eling_2nd_factory_sa_06';

-- A_EN_Benedict_7.T² International Contemporary Art Center.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_eling_2nd_factory_007.mp3', updated_at = NOW() WHERE id = 'chongqing_eling_2nd_factory_sa_07';

-- A_EN_Benedict_8.Love Rooftop (CITY-RADIO Station Wall).mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_eling_2nd_factory_008.mp3', updated_at = NOW() WHERE id = 'chongqing_eling_2nd_factory_sa_08';

-- A_EN_Benedict_9.Sky Rooftop.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_eling_2nd_factory_009.mp3', updated_at = NOW() WHERE id = 'chongqing_eling_2nd_factory_sa_09';

-- A_EN_Benedict_10.Spiral Staircase and Graffiti Alley.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_eling_2nd_factory_010.mp3', updated_at = NOW() WHERE id = 'chongqing_eling_2nd_factory_sa_10';

-- A_EN_Benedict_11.Giant Zipper Sculpture.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_eling_2nd_factory_011.mp3', updated_at = NOW() WHERE id = 'chongqing_eling_2nd_factory_sa_11';

-- A_EN_Benedict_12.Sunken Plaza.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_eling_2nd_factory_012.mp3', updated_at = NOW() WHERE id = 'chongqing_eling_2nd_factory_sa_12';

-- A_EN_Benedict_13.Chongqing Bookstore.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_eling_2nd_factory_013.mp3', updated_at = NOW() WHERE id = 'chongqing_eling_2nd_factory_sa_13';

-- A_EN_Benedict_14.Hello Childhood Nostalgia Hall.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_eling_2nd_factory_014.mp3', updated_at = NOW() WHERE id = 'chongqing_eling_2nd_factory_sa_14';

-- 观音桥 (chongqing_guanyinqiao)
-- A_EN_Benedict_1.Guanyinqiao Pedestrian Plaza (Starting Point).mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_guanyinqiao_001.mp3', updated_at = NOW() WHERE id = 'chongqing_guanyinqiao_sa_01';

-- A_EN_Benedict_2.Maoye Tiandi Naked-Eye 3D Screen.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_guanyinqiao_002.mp3', updated_at = NOW() WHERE id = 'chongqing_guanyinqiao_sa_02';

-- A_EN_Benedict_3.Guanyinqiao Sculpture (City Landmark).mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_guanyinqiao_003.mp3', updated_at = NOW() WHERE id = 'chongqing_guanyinqiao_sa_03';

-- A_EN_Benedict_4.Beicheng Tianjie.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_guanyinqiao_004.mp3', updated_at = NOW() WHERE id = 'chongqing_guanyinqiao_sa_04';

-- A_EN_Benedict_5.Guanyinqiao Jiujie Night-Life Strip (Final Stop).mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_guanyinqiao_005.mp3', updated_at = NOW() WHERE id = 'chongqing_guanyinqiao_sa_05';

-- 洪崖洞民俗风貌区 (chongqing_hongya_cave)
-- A_EN_Benedict_2.Floor 11 — City Terrace.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_hongya_cave_002.mp3', updated_at = NOW() WHERE id = 'chongqing_hongya_cave_sa_01';

-- A_EN_Benedict_3.Floor 11 — Xinhai Monument.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_hongya_cave_003.mp3', updated_at = NOW() WHERE id = 'chongqing_hongya_cave_sa_03';

-- A_EN_Benedict_4.Floor 11 — Memory of Mountain City Sculpture.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_hongya_cave_004.mp3', updated_at = NOW() WHERE id = 'chongqing_hongya_cave_sa_04';

-- A_EN_Benedict_5.Floor 11 — River Gate Cannon Emplacement Bronze.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_hongya_cave_005.mp3', updated_at = NOW() WHERE id = 'chongqing_hongya_cave_sa_05';

-- A_EN_Benedict_6.Floor 10 — Ba Culture Pillar.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_hongya_cave_006.mp3', updated_at = NOW() WHERE id = 'chongqing_hongya_cave_sa_06';

-- A_EN_Benedict_7.Floor 9 — International Bazaar.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_hongya_cave_007.mp3', updated_at = NOW() WHERE id = 'chongqing_hongya_cave_sa_02';

-- A_EN_Benedict_8.Floor 8 — Zone 78 Trendy Play World (Upper Level).mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_hongya_cave_008.mp3', updated_at = NOW() WHERE id = 'chongqing_hongya_cave_sa_08';

-- A_EN_Benedict_9.Floor 7 — Zone 78 Trendy Play World (Lower Level).mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_hongya_cave_009.mp3', updated_at = NOW() WHERE id = 'chongqing_hongya_cave_sa_09';

-- A_EN_Benedict_10.Floor 6 — Light and Shadow Interactive Art Space.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_hongya_cave_010.mp3', updated_at = NOW() WHERE id = 'chongqing_hongya_cave_sa_10';

-- A_EN_Benedict_11.Floor 5 — Reunion 1980 Eighties Life Street.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_hongya_cave_011.mp3', updated_at = NOW() WHERE id = 'chongqing_hongya_cave_sa_11';

-- A_EN_Benedict_12.Floor 4 — Grand Feast Food Street.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_hongya_cave_012.mp3', updated_at = NOW() WHERE id = 'chongqing_hongya_cave_sa_12';

-- A_EN_Benedict_13.Floor 3 — Tiancheng Lane Ba-Yu Culture Street.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_hongya_cave_013.mp3', updated_at = NOW() WHERE id = 'chongqing_hongya_cave_sa_13';

-- A_EN_Benedict_14.Floor 2 — Zhiyan River Bar Street.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_hongya_cave_014.mp3', updated_at = NOW() WHERE id = 'chongqing_hongya_cave_sa_14';

-- A_EN_Benedict_15.Floor 1 — Dripping Green Plaza.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_hongya_cave_015.mp3', updated_at = NOW() WHERE id = 'chongqing_hongya_cave_sa_15';

-- 解放碑 (chongqing_jiefangbei)
-- A_EN_Benedict_1.Jiefangbei Square.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_jiefangbei_001.mp3', updated_at = NOW() WHERE id = 'chongqing_jiefangbei_sa_01';

-- A_EN_Benedict_2.Monument to the Liberation of the People.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_jiefangbei_002.mp3', updated_at = NOW() WHERE id = 'chongqing_jiefangbei_sa_02';

-- A_EN_Benedict_3.Jiefangbei Pedestrian Street Sculpture Group.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_jiefangbei_003.mp3', updated_at = NOW() WHERE id = 'chongqing_jiefangbei_sa_03';

-- A_EN_Benedict_4.Zouronglu Pedestrian Street.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_jiefangbei_004.mp3', updated_at = NOW() WHERE id = 'chongqing_jiefangbei_sa_04';

-- A_EN_Benedict_5.Bayi Road Snack Street.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_jiefangbei_005.mp3', updated_at = NOW() WHERE id = 'chongqing_jiefangbei_sa_05';

-- A_EN_Benedict_6.WFC Huixian Tower Observation Deck.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_jiefangbei_006.mp3', updated_at = NOW() WHERE id = 'chongqing_jiefangbei_sa_06';

-- 金佛山 (chongqing_jinfo_mountain)
-- A_EN_Benedict_1.Main Gate.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_jinfo_mountain_001.mp3', updated_at = NOW() WHERE id = 'chongqing_jinfo_mountain_sa_01';

-- A_EN_Benedict_2.Bitan Yougu (Emerald Pool Gorge).mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_jinfo_mountain_002.mp3', updated_at = NOW() WHERE id = 'chongqing_jinfo_mountain_sa_02';

-- A_EN_Benedict_3.Cable Car Lower Station.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_jinfo_mountain_003.mp3', updated_at = NOW() WHERE id = 'chongqing_jinfo_mountain_sa_03';

-- A_EN_Benedict_4.Qianniu Ping Sky Street.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_jinfo_mountain_004.mp3', updated_at = NOW() WHERE id = 'chongqing_jinfo_mountain_sa_05';

-- A_EN_Benedict_5.Arrow Bamboo Forest Sea.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_jinfo_mountain_005.mp3', updated_at = NOW() WHERE id = 'chongqing_jinfo_mountain_sa_06';

-- A_EN_Benedict_6.Golden Tortoise Facing the Sun.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_jinfo_mountain_006.mp3', updated_at = NOW() WHERE id = 'chongqing_jinfo_mountain_sa_07';

-- A_EN_Benedict_7.Skyline Trail.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_jinfo_mountain_007.mp3', updated_at = NOW() WHERE id = 'chongqing_jinfo_mountain_sa_08';

-- A_EN_Benedict_8.Yanzi Cave and Lingguan Cave.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_jinfo_mountain_008.mp3', updated_at = NOW() WHERE id = 'chongqing_jinfo_mountain_sa_09';

-- A_EN_Benedict_9.Rhododendron Prince.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_jinfo_mountain_009.mp3', updated_at = NOW() WHERE id = 'chongqing_jinfo_mountain_sa_11';

-- A_EN_Benedict_11.Gufo Cave.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_jinfo_mountain_011.mp3', updated_at = NOW() WHERE id = 'chongqing_jinfo_mountain_sa_12';

-- A_EN_Benedict_12.Jinfo Peak Summit.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_jinfo_mountain_012.mp3', updated_at = NOW() WHERE id = 'chongqing_jinfo_mountain_sa_13';

-- A_EN_Benedict_13.Ecological Stone Forest.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_jinfo_mountain_013.mp3', updated_at = NOW() WHERE id = 'chongqing_jinfo_mountain_sa_14';

-- A_EN_Benedict_14.West Gate Cable Car Lower Station (Descent).mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_jinfo_mountain_014.mp3', updated_at = NOW() WHERE id = 'chongqing_jinfo_mountain_sa_04';

-- A_EN_Benedict_15.West Gate Visitor Center.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_jinfo_mountain_015.mp3', updated_at = NOW() WHERE id = 'chongqing_jinfo_mountain_sa_15';

-- 李子坝轻轨穿楼 (chongqing_liziba_monorail)
-- A_EN_Benedict_1.Liziba Station Exit 1.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_liziba_monorail_001.mp3', updated_at = NOW() WHERE id = 'chongqing_liziba_monorail_sa_01';

-- A_EN_Benedict_2.Liziba Viewing Platform.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_liziba_monorail_002.mp3', updated_at = NOW() WHERE id = 'chongqing_liziba_monorail_sa_02';

-- A_EN_Benedict_3.Soul of Rock Relief Culture Wall.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_liziba_monorail_003.mp3', updated_at = NOW() WHERE id = 'chongqing_liziba_monorail_sa_03';

-- A_EN_Benedict_4.Culture and Tourism Service Center.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_liziba_monorail_004.mp3', updated_at = NOW() WHERE id = 'chongqing_liziba_monorail_sa_04';

-- A_EN_Benedict_5.Bayu Historical News Museum.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_liziba_monorail_005.mp3', updated_at = NOW() WHERE id = 'chongqing_liziba_monorail_sa_05';

-- A_EN_Benedict_6.Rail-Through-Building Main Structure.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_liziba_monorail_006.mp3', updated_at = NOW() WHERE id = 'chongqing_liziba_monorail_sa_06';

-- 山城步道 (chongqing_mountain_trails)
-- A_EN_Benedict_1.Trail Entrance Archway (Start).mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_mountain_trails_001.mp3', updated_at = NOW() WHERE id = 'chongqing_mountain_trails_sa_01';

-- A_EN_Benedict_3.Suspended Boardwalk.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_mountain_trails_003.mp3', updated_at = NOW() WHERE id = 'chongqing_mountain_trails_sa_02';

-- A_EN_Benedict_4.Ren'ai Wilderness Theater (End).mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_mountain_trails_004.mp3', updated_at = NOW() WHERE id = 'chongqing_mountain_trails_sa_04';

-- 来福士 (chongqing_raffles_city)
-- A_EN_Benedict_1.Chaotianmen Square and the Meeting of Two Rivers (Starting Point).mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_raffles_city_001.mp3', updated_at = NOW() WHERE id = 'chongqing_raffles_city_sa_01';

-- A_EN_Benedict_2.Shopping Mall Atrium and Mountain City Garden.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_raffles_city_002.mp3', updated_at = NOW() WHERE id = 'chongqing_raffles_city_sa_02';

-- A_EN_Benedict_3.Crystal Link (Explorer Pod · Observation Deck).mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_raffles_city_003.mp3', updated_at = NOW() WHERE id = 'chongqing_raffles_city_sa_03';

-- A_EN_Benedict_4.Explorer Pod · Sky Park (Final Stop).mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_raffles_city_004.mp3', updated_at = NOW() WHERE id = 'chongqing_raffles_city_sa_04';

-- 十八梯 (chongqing_shibati)
-- A_EN_Benedict_1.The Grand Paifang of Shiba Ti (Starting Point).mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_shibati_001.mp3', updated_at = NOW() WHERE id = 'chongqing_shibati_sa_01';

-- A_EN_Benedict_2.Shanguojuan and the Mountain City Memory Museum.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_shibati_002.mp3', updated_at = NOW() WHERE id = 'chongqing_shibati_sa_02';

-- A_EN_Benedict_3.Yuetaiba (Hillside Courtyard).mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_shibati_003.mp3', updated_at = NOW() WHERE id = 'chongqing_shibati_sa_03';

-- A_EN_Benedict_4.The Da Suidao Tunnel Ruins (Final Stop).mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_shibati_004.mp3', updated_at = NOW() WHERE id = 'chongqing_shibati_sa_04';

-- 武隆喀斯特旅游区 (chongqing_wulong_karst)
-- 天生三桥/A_EN_Benedict_1.Tianlong Bridge.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_wulong_karst_001.mp3', updated_at = NOW() WHERE id = 'chongqing_wulong_karst_sa_01';

-- 天生三桥/A_EN_Benedict_2.Tianfu Post Station.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_wulong_karst_002.mp3', updated_at = NOW() WHERE id = 'chongqing_wulong_karst_sa_03';

-- 天生三桥/A_EN_Benedict_3.Qinglong Bridge.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_wulong_karst_003.mp3', updated_at = NOW() WHERE id = 'chongqing_wulong_karst_sa_04';

-- 天生三桥/A_EN_Benedict_4.Shenying Tiankeng.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_wulong_karst_004.mp3', updated_at = NOW() WHERE id = 'chongqing_wulong_karst_sa_05';

-- 天生三桥/A_EN_Benedict_5.Heilong Bridge.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_wulong_karst_005.mp3', updated_at = NOW() WHERE id = 'chongqing_wulong_karst_sa_06';

-- 天生三桥/A_EN_Benedict_6.Longquan Cave.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_wulong_karst_006.mp3', updated_at = NOW() WHERE id = 'chongqing_wulong_karst_sa_07';

-- 天生三桥/A_EN_Benedict_7.Longshuixia Slot Canyon.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_wulong_karst_007.mp3', updated_at = NOW() WHERE id = 'chongqing_wulong_karst_sa_08';

-- 天生三桥/A_EN_Benedict_8.Milky Way Falls.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_wulong_karst_008.mp3', updated_at = NOW() WHERE id = 'chongqing_wulong_karst_sa_09';

-- 天生三桥/A_EN_Benedict_9.Jiaolong Cold Cave.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_wulong_karst_009.mp3', updated_at = NOW() WHERE id = 'chongqing_wulong_karst_sa_10';

-- 仙女山国家森林公园/A_EN_Benedict_1.Muti Station.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_wulong_karst_010.mp3', updated_at = NOW() WHERE id = 'chongqing_wulong_karst_sa_11';

-- 仙女山国家森林公园/A_EN_Benedict_2.Grand Grassland Station.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_wulong_karst_011.mp3', updated_at = NOW() WHERE id = 'chongqing_wulong_karst_sa_02';

-- 长江索道 (chongqing_yangtze_cableway)
-- A_EN_Benedict_1.North Station (Xinhua Road, Yuzhong District).mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_yangtze_cableway_001.mp3', updated_at = NOW() WHERE id = 'chongqing_yangtze_cableway_sa_01';

-- A_EN_Benedict_2.The Cabin.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_yangtze_cableway_002.mp3', updated_at = NOW() WHERE id = 'chongqing_yangtze_cableway_sa_02';

-- A_EN_Benedict_3.South Station (Longmenghao, Nan'an District).mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_yangtze_cableway_003.mp3', updated_at = NOW() WHERE id = 'chongqing_yangtze_cableway_sa_03';

-- 重庆动物园 (chongqing_zoo)
-- A_EN_Benedict_1.Main Gate Plaza (Starting Point).mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_zoo_001.mp3', updated_at = NOW() WHERE id = 'chongqing_zoo_sa_01';

-- A_EN_Benedict_2.Giant Panda House.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_zoo_002.mp3', updated_at = NOW() WHERE id = 'chongqing_zoo_sa_03';

-- A_EN_Benedict_3.Goldfish Pavilion.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_zoo_003.mp3', updated_at = NOW() WHERE id = 'chongqing_zoo_sa_02';

-- A_EN_Benedict_4.Amphibian and Reptile Hall.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_zoo_004.mp3', updated_at = NOW() WHERE id = 'chongqing_zoo_sa_04';

-- A_EN_Benedict_5.Bird Zone (Final Stop).mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/chongqing_zoo_005.mp3', updated_at = NOW() WHERE id = 'chongqing_zoo_sa_05';

-- 杜甫草堂 (du_fu_thatched_cottage)
-- A_EN_Benedict_1.正门.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/du_fu_thatched_cottage_001.mp3', updated_at = NOW() WHERE id = 'du_fu_thatched_cottage_sa_13';

-- A_EN_Benedict_2.大廨.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/du_fu_thatched_cottage_002.mp3', updated_at = NOW() WHERE id = 'du_fu_thatched_cottage_sa_03';

-- A_EN_Benedict_3.诗史堂.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/du_fu_thatched_cottage_003.mp3', updated_at = NOW() WHERE id = 'du_fu_thatched_cottage_sa_11';

-- A_EN_Benedict_4.柴门.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/du_fu_thatched_cottage_004.mp3', updated_at = NOW() WHERE id = 'du_fu_thatched_cottage_sa_02';

-- A_EN_Benedict_5.工部祠.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/du_fu_thatched_cottage_005.mp3', updated_at = NOW() WHERE id = 'du_fu_thatched_cottage_sa_05';

-- A_EN_Benedict_6.少陵草堂碑亭.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/du_fu_thatched_cottage_006.mp3', updated_at = NOW() WHERE id = 'du_fu_thatched_cottage_sa_10';

-- A_EN_Benedict_7.茅屋故居.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/du_fu_thatched_cottage_007.mp3', updated_at = NOW() WHERE id = 'du_fu_thatched_cottage_sa_07';

-- A_EN_Benedict_8.唐代遗址.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/du_fu_thatched_cottage_008.mp3', updated_at = NOW() WHERE id = 'du_fu_thatched_cottage_sa_12';

-- A_EN_Benedict_9.千诗碑廊.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/du_fu_thatched_cottage_009.mp3', updated_at = NOW() WHERE id = 'du_fu_thatched_cottage_sa_09';

-- A_EN_Benedict_10.花径.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/du_fu_thatched_cottage_010.mp3', updated_at = NOW() WHERE id = 'du_fu_thatched_cottage_sa_06';

-- A_EN_Benedict_11.草堂影壁.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/du_fu_thatched_cottage_011.mp3', updated_at = NOW() WHERE id = 'du_fu_thatched_cottage_sa_01';

-- A_EN_Benedict_12.大雅堂.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/du_fu_thatched_cottage_012.mp3', updated_at = NOW() WHERE id = 'du_fu_thatched_cottage_sa_04';

-- A_EN_Benedict_13.南门（总结与告别）.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/du_fu_thatched_cottage_013.mp3', updated_at = NOW() WHERE id = 'du_fu_thatched_cottage_sa_08';

-- 法喜寺 (hangzhou_faxi_temple)
-- A_EN_Benedict_1.法喜寺山门.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_faxi_temple_001.mp3', updated_at = NOW() WHERE id = 'hangzhou_faxi_temple_sa_01';

-- A_EN_Benedict_2.天王殿.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_faxi_temple_002.mp3', updated_at = NOW() WHERE id = 'hangzhou_faxi_temple_sa_02';

-- A_EN_Benedict_3.圆通宝殿.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_faxi_temple_003.mp3', updated_at = NOW() WHERE id = 'hangzhou_faxi_temple_sa_03';

-- A_EN_Benedict_4.大雄宝殿.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_faxi_temple_004.mp3', updated_at = NOW() WHERE id = 'hangzhou_faxi_temple_sa_04';

-- A_EN_Benedict_5.藏经楼.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_faxi_temple_005.mp3', updated_at = NOW() WHERE id = 'hangzhou_faxi_temple_sa_05';

-- A_EN_Benedict_6.地藏殿.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_faxi_temple_006.mp3', updated_at = NOW() WHERE id = 'hangzhou_faxi_temple_sa_06';

-- A_EN_Benedict_7.五百罗汉堂.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_faxi_temple_007.mp3', updated_at = NOW() WHERE id = 'hangzhou_faxi_temple_sa_07';

-- A_EN_Benedict_8.白云峰观景台.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_faxi_temple_008.mp3', updated_at = NOW() WHERE id = 'hangzhou_faxi_temple_sa_08';

-- A_EN_Benedict_9.御碑亭.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_faxi_temple_009.mp3', updated_at = NOW() WHERE id = 'hangzhou_faxi_temple_sa_09';

-- A_EN_Benedict_10.法喜寺素斋堂.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_faxi_temple_010.mp3', updated_at = NOW() WHERE id = 'hangzhou_faxi_temple_sa_10';

-- 大运河拱宸桥 (hangzhou_gongchen_bridge)
-- A_EN_Benedict_1.运河广场.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_gongchen_bridge_001.mp3', updated_at = NOW() WHERE id = 'hangzhou_gongchen_bridge_sa_01';

-- A_EN_Benedict_2.拱宸桥.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_gongchen_bridge_002.mp3', updated_at = NOW() WHERE id = 'hangzhou_gongchen_bridge_sa_02';

-- A_EN_Benedict_3.桥西历史文化街区.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_gongchen_bridge_003.mp3', updated_at = NOW() WHERE id = 'hangzhou_gongchen_bridge_sa_03';

-- A_EN_Benedict_4.中国伞博物馆.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_gongchen_bridge_004.mp3', updated_at = NOW() WHERE id = 'hangzhou_gongchen_bridge_sa_04';

-- A_EN_Benedict_5.中国刀剪剑博物馆.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_gongchen_bridge_005.mp3', updated_at = NOW() WHERE id = 'hangzhou_gongchen_bridge_sa_05';

-- A_EN_Benedict_6.中国扇博物馆.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_gongchen_bridge_006.mp3', updated_at = NOW() WHERE id = 'hangzhou_gongchen_bridge_sa_06';

-- A_EN_Benedict_7.杭州工艺美术博物馆.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_gongchen_bridge_007.mp3', updated_at = NOW() WHERE id = 'hangzhou_gongchen_bridge_sa_07';

-- A_EN_Benedict_8.张大仙庙.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_gongchen_bridge_008.mp3', updated_at = NOW() WHERE id = 'hangzhou_gongchen_bridge_sa_08';

-- A_EN_Benedict_9.小河公园.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_gongchen_bridge_009.mp3', updated_at = NOW() WHERE id = 'hangzhou_gongchen_bridge_sa_09';

-- A_EN_Benedict_10.富义仓.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_gongchen_bridge_010.mp3', updated_at = NOW() WHERE id = 'hangzhou_gongchen_bridge_sa_10';

-- 京杭大运河（杭州段） (hangzhou_grand_canal)
-- A_EN_Benedict_1.武林门码头.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_grand_canal_001.mp3', updated_at = NOW() WHERE id = 'hangzhou_grand_canal_sa_01';

-- A_EN_Benedict_2.西湖文化广场.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_grand_canal_002.mp3', updated_at = NOW() WHERE id = 'hangzhou_grand_canal_sa_02';

-- A_EN_Benedict_3.信义坊.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_grand_canal_003.mp3', updated_at = NOW() WHERE id = 'hangzhou_grand_canal_sa_03';

-- A_EN_Benedict_4.富义仓.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_grand_canal_004.mp3', updated_at = NOW() WHERE id = 'hangzhou_grand_canal_sa_04';

-- A_EN_Benedict_5.小河直街.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_grand_canal_005.mp3', updated_at = NOW() WHERE id = 'hangzhou_grand_canal_sa_05';

-- A_EN_Benedict_6.小河公园.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_grand_canal_006.mp3', updated_at = NOW() WHERE id = 'hangzhou_grand_canal_sa_06';

-- A_EN_Benedict_7.桥西历史文化街区.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_grand_canal_007.mp3', updated_at = NOW() WHERE id = 'hangzhou_grand_canal_sa_07';

-- A_EN_Benedict_8.中国京杭大运河博物馆.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_grand_canal_008.mp3', updated_at = NOW() WHERE id = 'hangzhou_grand_canal_sa_08';

-- A_EN_Benedict_9.拱宸桥.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_grand_canal_009.mp3', updated_at = NOW() WHERE id = 'hangzhou_grand_canal_sa_09';

-- A_EN_Benedict_10.运河广场.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_grand_canal_010.mp3', updated_at = NOW() WHERE id = 'hangzhou_grand_canal_sa_10';

-- 河坊街（清河坊历史街区） (hangzhou_hefang_street)
-- A_EN_Benedict_1.河坊街东入口.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_hefang_street_001.mp3', updated_at = NOW() WHERE id = 'hangzhou_hefang_street_sa_01';

-- A_EN_Benedict_2.鼓楼.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_hefang_street_002.mp3', updated_at = NOW() WHERE id = 'hangzhou_hefang_street_sa_02';

-- A_EN_Benedict_3.望仙阁.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_hefang_street_003.mp3', updated_at = NOW() WHERE id = 'hangzhou_hefang_street_sa_03';

-- A_EN_Benedict_4.胡庆余堂中药博物馆.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_hefang_street_004.mp3', updated_at = NOW() WHERE id = 'hangzhou_hefang_street_sa_04';

-- A_EN_Benedict_5.方回春堂.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_hefang_street_005.mp3', updated_at = NOW() WHERE id = 'hangzhou_hefang_street_sa_05';

-- A_EN_Benedict_6.朱炳仁铜雕艺术博物馆.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_hefang_street_006.mp3', updated_at = NOW() WHERE id = 'hangzhou_hefang_street_sa_06';

-- A_EN_Benedict_7.江南铜屋.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_hefang_street_007.mp3', updated_at = NOW() WHERE id = 'hangzhou_hefang_street_sa_07';

-- A_EN_Benedict_8.南宋御街.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_hefang_street_008.mp3', updated_at = NOW() WHERE id = 'hangzhou_hefang_street_sa_08';

-- A_EN_Benedict_9.大井巷.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_hefang_street_009.mp3', updated_at = NOW() WHERE id = 'hangzhou_hefang_street_sa_09';

-- A_EN_Benedict_10.吴山广场与城隍阁.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_hefang_street_010.mp3', updated_at = NOW() WHERE id = 'hangzhou_hefang_street_sa_10';

-- 雷峰塔 (hangzhou_leifeng_pagoda)
-- A_EN_Benedict_1.雷峰塔景区入口.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_leifeng_pagoda_001.mp3', updated_at = NOW() WHERE id = 'hangzhou_leifeng_pagoda_sa_01';

-- A_EN_Benedict_2.雷峰塔遗址底层.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_leifeng_pagoda_002.mp3', updated_at = NOW() WHERE id = 'hangzhou_leifeng_pagoda_sa_02';

-- A_EN_Benedict_3.新雷峰塔一层.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_leifeng_pagoda_003.mp3', updated_at = NOW() WHERE id = 'hangzhou_leifeng_pagoda_sa_03';

-- A_EN_Benedict_4.新雷峰塔二至四层.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_leifeng_pagoda_004.mp3', updated_at = NOW() WHERE id = 'hangzhou_leifeng_pagoda_sa_04';

-- A_EN_Benedict_5.雷峰塔顶层观景台.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_leifeng_pagoda_005.mp3', updated_at = NOW() WHERE id = 'hangzhou_leifeng_pagoda_sa_05';

-- A_EN_Benedict_6.雷峰塔文化陈列馆.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_leifeng_pagoda_006.mp3', updated_at = NOW() WHERE id = 'hangzhou_leifeng_pagoda_sa_06';

-- A_EN_Benedict_7.夕照亭与放生池.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_leifeng_pagoda_007.mp3', updated_at = NOW() WHERE id = 'hangzhou_leifeng_pagoda_sa_07';

-- 良渚古城遗址公园 (hangzhou_liangzhu_ancient_city)
-- A_EN_Benedict_1.良渚古城遗址公园南入口.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_liangzhu_ancient_city_001.mp3', updated_at = NOW() WHERE id = 'hangzhou_liangzhu_ancient_city_sa_01';

-- A_EN_Benedict_2.陆城门遗址.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_liangzhu_ancient_city_002.mp3', updated_at = NOW() WHERE id = 'hangzhou_liangzhu_ancient_city_sa_02';

-- A_EN_Benedict_3.水城门遗址.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_liangzhu_ancient_city_003.mp3', updated_at = NOW() WHERE id = 'hangzhou_liangzhu_ancient_city_sa_03';

-- A_EN_Benedict_4.南城墙遗址.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_liangzhu_ancient_city_004.mp3', updated_at = NOW() WHERE id = 'hangzhou_liangzhu_ancient_city_sa_04';

-- A_EN_Benedict_5.钟家港古河道.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_liangzhu_ancient_city_005.mp3', updated_at = NOW() WHERE id = 'hangzhou_liangzhu_ancient_city_sa_05';

-- A_EN_Benedict_6.莫角山宫殿遗址.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_liangzhu_ancient_city_006.mp3', updated_at = NOW() WHERE id = 'hangzhou_liangzhu_ancient_city_sa_06';

-- A_EN_Benedict_7.反山王陵.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_liangzhu_ancient_city_007.mp3', updated_at = NOW() WHERE id = 'hangzhou_liangzhu_ancient_city_sa_07';

-- A_EN_Benedict_8.姜家山贵族墓地.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_liangzhu_ancient_city_008.mp3', updated_at = NOW() WHERE id = 'hangzhou_liangzhu_ancient_city_sa_08';

-- A_EN_Benedict_9.美人地遗址.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_liangzhu_ancient_city_009.mp3', updated_at = NOW() WHERE id = 'hangzhou_liangzhu_ancient_city_sa_09';

-- A_EN_Benedict_10.雉山观景台.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_liangzhu_ancient_city_010.mp3', updated_at = NOW() WHERE id = 'hangzhou_liangzhu_ancient_city_sa_10';

-- 灵隐寺 (hangzhou_lingyin_temple)
-- A_EN_Benedict_1.灵隐寺景区入口.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_lingyin_temple_001.mp3', updated_at = NOW() WHERE id = 'hangzhou_lingyin_temple_sa_01';

-- A_EN_Benedict_2.飞来峰造像.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_lingyin_temple_002.mp3', updated_at = NOW() WHERE id = 'hangzhou_lingyin_temple_sa_02';

-- A_EN_Benedict_3.理公塔与冷泉亭.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_lingyin_temple_003.mp3', updated_at = NOW() WHERE id = 'hangzhou_lingyin_temple_sa_03';

-- A_EN_Benedict_4.天王殿.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_lingyin_temple_004.mp3', updated_at = NOW() WHERE id = 'hangzhou_lingyin_temple_sa_04';

-- A_EN_Benedict_5.大雄宝殿.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_lingyin_temple_005.mp3', updated_at = NOW() WHERE id = 'hangzhou_lingyin_temple_sa_05';

-- A_EN_Benedict_6.药师殿.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_lingyin_temple_006.mp3', updated_at = NOW() WHERE id = 'hangzhou_lingyin_temple_sa_06';

-- A_EN_Benedict_7.藏经楼.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_lingyin_temple_007.mp3', updated_at = NOW() WHERE id = 'hangzhou_lingyin_temple_sa_07';

-- A_EN_Benedict_8.华严殿.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_lingyin_temple_008.mp3', updated_at = NOW() WHERE id = 'hangzhou_lingyin_temple_sa_08';

-- A_EN_Benedict_9.济公殿.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_lingyin_temple_009.mp3', updated_at = NOW() WHERE id = 'hangzhou_lingyin_temple_sa_09';

-- A_EN_Benedict_10.五百罗汉堂.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_lingyin_temple_010.mp3', updated_at = NOW() WHERE id = 'hangzhou_lingyin_temple_sa_10';

-- 西湖文化广场 (hangzhou_west_lake_cultural_plaza)
-- A_EN_Benedict_1.西湖文化广场北入口.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_west_lake_cultural_plaza_001.mp3', updated_at = NOW() WHERE id = 'hangzhou_west_lake_cultural_plaza_sa_01';

-- A_EN_Benedict_2.主广场与音乐喷泉.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_west_lake_cultural_plaza_002.mp3', updated_at = NOW() WHERE id = 'hangzhou_west_lake_cultural_plaza_sa_05';

-- A_EN_Benedict_3.浙江省博物馆.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_west_lake_cultural_plaza_003.mp3', updated_at = NOW() WHERE id = 'hangzhou_west_lake_cultural_plaza_sa_04';

-- A_EN_Benedict_4.浙江自然博物院.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_west_lake_cultural_plaza_004.mp3', updated_at = NOW() WHERE id = 'hangzhou_west_lake_cultural_plaza_sa_03';

-- A_EN_Benedict_5.浙江省科技馆.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_west_lake_cultural_plaza_005.mp3', updated_at = NOW() WHERE id = 'hangzhou_west_lake_cultural_plaza_sa_02';

-- A_EN_Benedict_6.环球中心.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_west_lake_cultural_plaza_006.mp3', updated_at = NOW() WHERE id = 'hangzhou_west_lake_cultural_plaza_sa_10';

-- A_EN_Benedict_7.运河景观带.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_west_lake_cultural_plaza_007.mp3', updated_at = NOW() WHERE id = 'hangzhou_west_lake_cultural_plaza_sa_09';

-- A_EN_Benedict_8.文化广场雕塑群.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_west_lake_cultural_plaza_008.mp3', updated_at = NOW() WHERE id = 'hangzhou_west_lake_cultural_plaza_sa_06';

-- A_EN_Benedict_9.下沉式广场.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_west_lake_cultural_plaza_009.mp3', updated_at = NOW() WHERE id = 'hangzhou_west_lake_cultural_plaza_sa_07';

-- A_EN_Benedict_10.夜景灯光秀.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_west_lake_cultural_plaza_010.mp3', updated_at = NOW() WHERE id = 'hangzhou_west_lake_cultural_plaza_sa_08';

-- 小河直街 (hangzhou_xiaohe_street)
-- A_EN_Benedict_1.小河直街主入口.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_xiaohe_street_001.mp3', updated_at = NOW() WHERE id = 'hangzhou_xiaohe_street_sa_01';

-- A_EN_Benedict_2.小河直街主街.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_xiaohe_street_002.mp3', updated_at = NOW() WHERE id = 'hangzhou_xiaohe_street_sa_02';

-- A_EN_Benedict_3.小河民居建筑群.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_xiaohe_street_003.mp3', updated_at = NOW() WHERE id = 'hangzhou_xiaohe_street_sa_03';

-- A_EN_Benedict_4.小河酱园.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_xiaohe_street_004.mp3', updated_at = NOW() WHERE id = 'hangzhou_xiaohe_street_sa_04';

-- A_EN_Benedict_5.老桥头.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_xiaohe_street_005.mp3', updated_at = NOW() WHERE id = 'hangzhou_xiaohe_street_sa_05';

-- A_EN_Benedict_6.临水长廊.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_xiaohe_street_006.mp3', updated_at = NOW() WHERE id = 'hangzhou_xiaohe_street_sa_06';

-- A_EN_Benedict_7.小河公园.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_xiaohe_street_007.mp3', updated_at = NOW() WHERE id = 'hangzhou_xiaohe_street_sa_07';

-- A_EN_Benedict_8.运河航运陈列馆.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_xiaohe_street_008.mp3', updated_at = NOW() WHERE id = 'hangzhou_xiaohe_street_sa_08';

-- A_EN_Benedict_9.手工艺作坊街.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_xiaohe_street_009.mp3', updated_at = NOW() WHERE id = 'hangzhou_xiaohe_street_sa_09';

-- A_EN_Benedict_10.运河观景平台.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_xiaohe_street_010.mp3', updated_at = NOW() WHERE id = 'hangzhou_xiaohe_street_sa_10';

-- 西溪国家湿地公园 (hangzhou_xixi_wetland)
-- A_EN_Benedict_1.周家村入口.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_xixi_wetland_001.mp3', updated_at = NOW() WHERE id = 'hangzhou_xixi_wetland_sa_01';

-- A_EN_Benedict_2.烟水渔庄.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_xixi_wetland_002.mp3', updated_at = NOW() WHERE id = 'hangzhou_xixi_wetland_sa_02';

-- A_EN_Benedict_3.深潭口.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_xixi_wetland_003.mp3', updated_at = NOW() WHERE id = 'hangzhou_xixi_wetland_sa_03';

-- A_EN_Benedict_4.河渚街.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_xixi_wetland_004.mp3', updated_at = NOW() WHERE id = 'hangzhou_xixi_wetland_sa_04';

-- A_EN_Benedict_5.福堤.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_xixi_wetland_005.mp3', updated_at = NOW() WHERE id = 'hangzhou_xixi_wetland_sa_05';

-- A_EN_Benedict_6.高庄.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_xixi_wetland_006.mp3', updated_at = NOW() WHERE id = 'hangzhou_xixi_wetland_sa_06';

-- A_EN_Benedict_7.梅竹山庄.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_xixi_wetland_007.mp3', updated_at = NOW() WHERE id = 'hangzhou_xixi_wetland_sa_07';

-- A_EN_Benedict_8.洪园.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_xixi_wetland_008.mp3', updated_at = NOW() WHERE id = 'hangzhou_xixi_wetland_sa_08';

-- A_EN_Benedict_9.西溪水街.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_xixi_wetland_009.mp3', updated_at = NOW() WHERE id = 'hangzhou_xixi_wetland_sa_09';

-- A_EN_Benedict_10.邬家湾.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_xixi_wetland_010.mp3', updated_at = NOW() WHERE id = 'hangzhou_xixi_wetland_sa_10';

-- 浙江省博物馆 (hangzhou_zhejiang_museum)
-- A_EN_Benedict_1.之江馆区主入口.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_zhejiang_museum_001.mp3', updated_at = NOW() WHERE id = 'hangzhou_zhejiang_museum_sa_01';

-- A_EN_Benedict_5.宋韵文化展.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_zhejiang_museum_005.mp3', updated_at = NOW() WHERE id = 'hangzhou_zhejiang_museum_sa_05';

-- A_EN_Benedict_6.浙江一万年·五代至明清.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_zhejiang_museum_006.mp3', updated_at = NOW() WHERE id = 'hangzhou_zhejiang_museum_sa_06';

-- A_EN_Benedict_7.伊人红妆——宁绍平原传统婚俗与嫁妆.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_zhejiang_museum_007.mp3', updated_at = NOW() WHERE id = 'hangzhou_zhejiang_museum_sa_07';

-- A_EN_Benedict_8.保境安民话钱镠——浙江名人文化系列展.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_zhejiang_museum_008.mp3', updated_at = NOW() WHERE id = 'hangzhou_zhejiang_museum_sa_08';

-- A_EN_Benedict_9.太古之音——古琴艺术馆.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_zhejiang_museum_009.mp3', updated_at = NOW() WHERE id = 'hangzhou_zhejiang_museum_sa_09';

-- A_EN_Benedict_10.富春山居馆.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/hangzhou_zhejiang_museum_010.mp3', updated_at = NOW() WHERE id = 'hangzhou_zhejiang_museum_sa_10';

-- 大熊猫基地 (https_yoloadmin_vue_cstudiomunger_workers_dev)
-- A_EN_Benedict_1.南大门.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/https_yoloadmin_vue_cstudiomunger_workers_dev_001.mp3', updated_at = NOW() WHERE id = 'https_yoloadmin_vue_cstudiomunger_workers_dev_sa_06';

-- A_EN_Benedict_2.大熊猫博物馆.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/https_yoloadmin_vue_cstudiomunger_workers_dev_002.mp3', updated_at = NOW() WHERE id = 'https_yoloadmin_vue_cstudiomunger_workers_dev_sa_02';

-- A_EN_Benedict_3.成年亚成年幼年大熊猫别墅14号、7号—1号别墅.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/https_yoloadmin_vue_cstudiomunger_workers_dev_003.mp3', updated_at = NOW() WHERE id = 'https_yoloadmin_vue_cstudiomunger_workers_dev_sa_01';

-- A_EN_Benedict_4.大熊猫太阳产房.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/https_yoloadmin_vue_cstudiomunger_workers_dev_004.mp3', updated_at = NOW() WHERE id = 'https_yoloadmin_vue_cstudiomunger_workers_dev_sa_03';

-- A_EN_Benedict_5.大熊猫月亮产房.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/https_yoloadmin_vue_cstudiomunger_workers_dev_005.mp3', updated_at = NOW() WHERE id = 'https_yoloadmin_vue_cstudiomunger_workers_dev_sa_05';

-- A_EN_Benedict_6.小熊猫1号2号活动场.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/https_yoloadmin_vue_cstudiomunger_workers_dev_006.mp3', updated_at = NOW() WHERE id = 'https_yoloadmin_vue_cstudiomunger_workers_dev_sa_09';

-- A_EN_Benedict_7.新区展馆（胜日馆、云日馆、旭日馆、映日馆）.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/https_yoloadmin_vue_cstudiomunger_workers_dev_007.mp3', updated_at = NOW() WHERE id = 'https_yoloadmin_vue_cstudiomunger_workers_dev_sa_11';

-- A_EN_Benedict_8.熊猫塔.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/https_yoloadmin_vue_cstudiomunger_workers_dev_008.mp3', updated_at = NOW() WHERE id = 'https_yoloadmin_vue_cstudiomunger_workers_dev_sa_13';

-- A_EN_Benedict_9.熊猫步行街、熊猫邮局.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/https_yoloadmin_vue_cstudiomunger_workers_dev_009.mp3', updated_at = NOW() WHERE id = 'https_yoloadmin_vue_cstudiomunger_workers_dev_sa_14';

-- A_EN_Benedict_10.大熊猫星星产房、星汉馆.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/https_yoloadmin_vue_cstudiomunger_workers_dev_010.mp3', updated_at = NOW() WHERE id = 'https_yoloadmin_vue_cstudiomunger_workers_dev_sa_04';

-- A_EN_Benedict_11.熊猫美术馆.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/https_yoloadmin_vue_cstudiomunger_workers_dev_011.mp3', updated_at = NOW() WHERE id = 'https_yoloadmin_vue_cstudiomunger_workers_dev_sa_12';

-- A_EN_Benedict_12.西区"月"字展馆群.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/https_yoloadmin_vue_cstudiomunger_workers_dev_012.mp3', updated_at = NOW() WHERE id = 'https_yoloadmin_vue_cstudiomunger_workers_dev_sa_08';

-- A_EN_Benedict_13.西门（总结与告别）.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/https_yoloadmin_vue_cstudiomunger_workers_dev_013.mp3', updated_at = NOW() WHERE id = 'https_yoloadmin_vue_cstudiomunger_workers_dev_sa_07';

-- 陆家嘴金融区 (lujiazui_financial_district)
-- A_EN_Benedict_1.Lujiazui Central Green.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/lujiazui_financial_district_001.mp3', updated_at = NOW() WHERE id = 'lujiazui_financial_district_sa_01';

-- A_EN_Benedict_2.Oriental Pearl Radio and TV Tower.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/lujiazui_financial_district_002.mp3', updated_at = NOW() WHERE id = 'lujiazui_financial_district_sa_02';

-- A_EN_Benedict_3.Shanghai Ocean Aquarium.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/lujiazui_financial_district_003.mp3', updated_at = NOW() WHERE id = 'lujiazui_financial_district_sa_03';

-- A_EN_Benedict_4.Jinmao Tower.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/lujiazui_financial_district_004.mp3', updated_at = NOW() WHERE id = 'lujiazui_financial_district_sa_04';

-- A_EN_Benedict_5.Shanghai World Financial Center.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/lujiazui_financial_district_005.mp3', updated_at = NOW() WHERE id = 'lujiazui_financial_district_sa_05';

-- A_EN_Benedict_6.Shanghai Tower.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/lujiazui_financial_district_006.mp3', updated_at = NOW() WHERE id = 'lujiazui_financial_district_sa_09';

-- A_EN_Benedict_7.Wu Changshuo Memorial Hall.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/lujiazui_financial_district_007.mp3', updated_at = NOW() WHERE id = 'lujiazui_financial_district_sa_06';

-- A_EN_Benedict_8.Century Avenue.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/lujiazui_financial_district_008.mp3', updated_at = NOW() WHERE id = 'lujiazui_financial_district_sa_07';

-- A_EN_Benedict_9.Pudong Riverside Promenade.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/lujiazui_financial_district_009.mp3', updated_at = NOW() WHERE id = 'lujiazui_financial_district_sa_08';

-- 晨光1865科技创意产业园 (nanjing_1865_creative_park)
-- A_EN_Benedict_1.老大门（主入口）.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_1865_creative_park_001.mp3', updated_at = NOW() WHERE id = 'nanjing_1865_creative_park_sa_01';

-- A_EN_Benedict_2.金陵兵工展览馆（机器正厂）.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_1865_creative_park_002.mp3', updated_at = NOW() WHERE id = 'nanjing_1865_creative_park_sa_02';

-- A_EN_Benedict_3.机器右厂与机器左厂.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_1865_creative_park_003.mp3', updated_at = NOW() WHERE id = 'nanjing_1865_creative_park_sa_03';

-- A_EN_Benedict_4.炎铜厂与捲铜厂.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_1865_creative_park_004.mp3', updated_at = NOW() WHERE id = 'nanjing_1865_creative_park_sa_04';

-- A_EN_Benedict_5.木厂大楼与机器大厂.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_1865_creative_park_005.mp3', updated_at = NOW() WHERE id = 'nanjing_1865_creative_park_sa_05';

-- A_EN_Benedict_6.民国办公楼与锯齿形厂房.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_1865_creative_park_006.mp3', updated_at = NOW() WHERE id = 'nanjing_1865_creative_park_sa_06';

-- A_EN_Benedict_7.反战雕塑.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_1865_creative_park_007.mp3', updated_at = NOW() WHERE id = 'nanjing_1865_creative_park_sa_07';

-- A_EN_Benedict_8.佛手青铜像.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_1865_creative_park_008.mp3', updated_at = NOW() WHERE id = 'nanjing_1865_creative_park_sa_08';

-- A_EN_Benedict_9.中央广场与1865数字雕塑.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_1865_creative_park_009.mp3', updated_at = NOW() WHERE id = 'nanjing_1865_creative_park_sa_09';

-- 南京明城墙 (nanjing_city_wall)
-- A_EN_Benedict_1.Zhonghua Gate Plaza (Entrance).mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_city_wall_001.mp3', updated_at = NOW() WHERE id = 'nanjing_city_wall_sa_01';

-- A_EN_Benedict_2.The First Gateway (Main Gate).mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_city_wall_002.mp3', updated_at = NOW() WHERE id = 'nanjing_city_wall_sa_02';

-- A_EN_Benedict_3.The First Barbican.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_city_wall_003.mp3', updated_at = NOW() WHERE id = 'nanjing_city_wall_sa_03';

-- A_EN_Benedict_4.The Hidden Soldier Caves.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_city_wall_004.mp3', updated_at = NOW() WHERE id = 'nanjing_city_wall_sa_05';

-- A_EN_Benedict_6.Top of the Wall.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_city_wall_006.mp3', updated_at = NOW() WHERE id = 'nanjing_city_wall_sa_06';

-- A_EN_Benedict_7.Nanjing City Wall Museum.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_city_wall_007.mp3', updated_at = NOW() WHERE id = 'nanjing_city_wall_sa_07';

-- A_EN_Benedict_8.Taicheng Section (The Highlight Stretch).mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_city_wall_008.mp3', updated_at = NOW() WHERE id = 'nanjing_city_wall_sa_08';

-- 南京夫子庙-秦淮河风光带 (nanjing_confucius_temple_qinhuai)
-- A_EN_Benedict_1.古秦淮牌坊（入口广场）.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_confucius_temple_qinhuai_001.mp3', updated_at = NOW() WHERE id = 'nanjing_confucius_temple_qinhuai_sa_01';

-- A_EN_Benedict_2.照壁与泮池.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_confucius_temple_qinhuai_002.mp3', updated_at = NOW() WHERE id = 'nanjing_confucius_temple_qinhuai_sa_02';

-- A_EN_Benedict_3.天下文枢坊与聚星亭.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_confucius_temple_qinhuai_003.mp3', updated_at = NOW() WHERE id = 'nanjing_confucius_temple_qinhuai_sa_03';

-- A_EN_Benedict_4.棂星门.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_confucius_temple_qinhuai_004.mp3', updated_at = NOW() WHERE id = 'nanjing_confucius_temple_qinhuai_sa_04';

-- A_EN_Benedict_5.大成门.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_confucius_temple_qinhuai_005.mp3', updated_at = NOW() WHERE id = 'nanjing_confucius_temple_qinhuai_sa_05';

-- A_EN_Benedict_6.大成殿.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_confucius_temple_qinhuai_006.mp3', updated_at = NOW() WHERE id = 'nanjing_confucius_temple_qinhuai_sa_06';

-- A_EN_Benedict_7.明德堂、尊经阁与东南第一学.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_confucius_temple_qinhuai_007.mp3', updated_at = NOW() WHERE id = 'nanjing_confucius_temple_qinhuai_sa_07';

-- A_EN_Benedict_8.江南贡院（中国科举博物馆南馆）.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_confucius_temple_qinhuai_008.mp3', updated_at = NOW() WHERE id = 'nanjing_confucius_temple_qinhuai_sa_08';

-- A_EN_Benedict_9.中国科举博物馆（北馆）与明远楼.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_confucius_temple_qinhuai_009.mp3', updated_at = NOW() WHERE id = 'nanjing_confucius_temple_qinhuai_sa_09';

-- A_EN_Benedict_10.文德桥.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_confucius_temple_qinhuai_010.mp3', updated_at = NOW() WHERE id = 'nanjing_confucius_temple_qinhuai_sa_10';

-- A_EN_Benedict_11.乌衣巷与王谢古居.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_confucius_temple_qinhuai_011.mp3', updated_at = NOW() WHERE id = 'nanjing_confucius_temple_qinhuai_sa_11';

-- A_EN_Benedict_12.秦淮画舫码头（游船体验）.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_confucius_temple_qinhuai_012.mp3', updated_at = NOW() WHERE id = 'nanjing_confucius_temple_qinhuai_sa_12';

-- 甘熙宅第（南京民俗博物馆） (nanjing_ganxi_mansion)
-- A_EN_Benedict_1.南门（正门）.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_ganxi_mansion_001.mp3', updated_at = NOW() WHERE id = 'nanjing_ganxi_mansion_sa_01';

-- A_EN_Benedict_2.门厅与轿厅.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_ganxi_mansion_002.mp3', updated_at = NOW() WHERE id = 'nanjing_ganxi_mansion_sa_02';

-- A_EN_Benedict_3.友恭堂（正厅）.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_ganxi_mansion_003.mp3', updated_at = NOW() WHERE id = 'nanjing_ganxi_mansion_sa_03';

-- A_EN_Benedict_4.内厅与响厅.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_ganxi_mansion_004.mp3', updated_at = NOW() WHERE id = 'nanjing_ganxi_mansion_sa_04';

-- A_EN_Benedict_5.跑马楼.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_ganxi_mansion_005.mp3', updated_at = NOW() WHERE id = 'nanjing_ganxi_mansion_sa_05';

-- A_EN_Benedict_6.书房与备弄.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_ganxi_mansion_006.mp3', updated_at = NOW() WHERE id = 'nanjing_ganxi_mansion_sa_06';

-- A_EN_Benedict_7.后花园（小园）与听秋阁.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_ganxi_mansion_007.mp3', updated_at = NOW() WHERE id = 'nanjing_ganxi_mansion_sa_07';

-- A_EN_Benedict_8.津逮楼.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_ganxi_mansion_008.mp3', updated_at = NOW() WHERE id = 'nanjing_ganxi_mansion_sa_08';

-- A_EN_Benedict_9.望月楼与严凤英旧居.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_ganxi_mansion_009.mp3', updated_at = NOW() WHERE id = 'nanjing_ganxi_mansion_sa_09';

-- A_EN_Benedict_10.金陵十八坊与非遗展区.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_ganxi_mansion_010.mp3', updated_at = NOW() WHERE id = 'nanjing_ganxi_mansion_sa_10';

-- A_EN_Benedict_11.老南京民俗展区与尾声.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_ganxi_mansion_011.mp3', updated_at = NOW() WHERE id = 'nanjing_ganxi_mansion_sa_11';

-- 老门东历史文化街区 (nanjing_laomendong)
-- A_EN_Benedict_1.Mendong Memorial Gateway.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_laomendong_001.mp3', updated_at = NOW() WHERE id = 'nanjing_laomendong_sa_02';

-- A_EN_Benedict_3.Street Sculpture Group.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_laomendong_003.mp3', updated_at = NOW() WHERE id = 'nanjing_laomendong_sa_03';

-- A_EN_Benedict_4.Santiaoning and Jiang Shoushan Residence.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_laomendong_004.mp3', updated_at = NOW() WHERE id = 'nanjing_laomendong_sa_04';

-- A_EN_Benedict_5.Jianzi Lane and Jinling Art Museum.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_laomendong_005.mp3', updated_at = NOW() WHERE id = 'nanjing_laomendong_sa_05';

-- A_EN_Benedict_6.Shangjian Examination Compound.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_laomendong_006.mp3', updated_at = NOW() WHERE id = 'nanjing_laomendong_sa_06';

-- A_EN_Benedict_7.Fu Shanxiang Former Residence.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_laomendong_007.mp3', updated_at = NOW() WHERE id = 'nanjing_laomendong_sa_07';

-- A_EN_Benedict_8.Jieziyuan.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_laomendong_008.mp3', updated_at = NOW() WHERE id = 'nanjing_laomendong_sa_08';

-- A_EN_Benedict_9.Yao Nai Residence (Xibao Xuan).mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_laomendong_009.mp3', updated_at = NOW() WHERE id = 'nanjing_laomendong_sa_09';

-- A_EN_Benedict_10.Ming City Wall (Laomendong Section).mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_laomendong_010.mp3', updated_at = NOW() WHERE id = 'nanjing_laomendong_sa_10';

-- 侵华日军南京大屠杀遇难同胞纪念馆 (nanjing_massacre_memorial)
-- A_EN_Benedict_1.雕塑广场.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_massacre_memorial_001.mp3', updated_at = NOW() WHERE id = 'nanjing_massacre_memorial_sa_01';

-- A_EN_Benedict_2.公祭广场.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_massacre_memorial_002.mp3', updated_at = NOW() WHERE id = 'nanjing_massacre_memorial_sa_02';

-- A_EN_Benedict_3.史料陈列厅.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_massacre_memorial_003.mp3', updated_at = NOW() WHERE id = 'nanjing_massacre_memorial_sa_03';

-- A_EN_Benedict_4."万人坑"遗址.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_massacre_memorial_004.mp3', updated_at = NOW() WHERE id = 'nanjing_massacre_memorial_sa_04';

-- A_EN_Benedict_5.墓地广场.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_massacre_memorial_005.mp3', updated_at = NOW() WHERE id = 'nanjing_massacre_memorial_sa_05';

-- A_EN_Benedict_6.祭场与冥思厅.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_massacre_memorial_006.mp3', updated_at = NOW() WHERE id = 'nanjing_massacre_memorial_sa_06';

-- A_EN_Benedict_7.和平公园.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_massacre_memorial_007.mp3', updated_at = NOW() WHERE id = 'nanjing_massacre_memorial_sa_07';

-- A_EN_Benedict_8.胜利之墙与胜利广场.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_massacre_memorial_008.mp3', updated_at = NOW() WHERE id = 'nanjing_massacre_memorial_sa_08';

-- A_EN_Benedict_9."三个必胜"主题展厅.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_massacre_memorial_009.mp3', updated_at = NOW() WHERE id = 'nanjing_massacre_memorial_sa_09';

-- 南京明孝陵 (nanjing_ming_xiaoling)
-- A_EN_Benedict_1.Xiamafang Heritage Park.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_ming_xiaoling_001.mp3', updated_at = NOW() WHERE id = 'nanjing_ming_xiaoling_sa_01';

-- A_EN_Benedict_2.Dajin Gate.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_ming_xiaoling_002.mp3', updated_at = NOW() WHERE id = 'nanjing_ming_xiaoling_sa_02';

-- A_EN_Benedict_3.Sifang Cheng (Spirit Virtue Stele Pavilion).mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_ming_xiaoling_003.mp3', updated_at = NOW() WHERE id = 'nanjing_ming_xiaoling_sa_03';

-- A_EN_Benedict_4.Stone Elephant Road (Spirit Road).mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_ming_xiaoling_004.mp3', updated_at = NOW() WHERE id = 'nanjing_ming_xiaoling_sa_04';

-- A_EN_Benedict_5.Wengzhong Road (Spirit Road).mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_ming_xiaoling_005.mp3', updated_at = NOW() WHERE id = 'nanjing_ming_xiaoling_sa_05';

-- A_EN_Benedict_6.Lingxing Gate and Golden Water Bridge.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_ming_xiaoling_006.mp3', updated_at = NOW() WHERE id = 'nanjing_ming_xiaoling_sa_06';

-- A_EN_Benedict_7.Wenwu Fangmen.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_ming_xiaoling_007.mp3', updated_at = NOW() WHERE id = 'nanjing_ming_xiaoling_sa_07';

-- A_EN_Benedict_8.Stele Hall (Zhilong Tang Song Stele).mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_ming_xiaoling_008.mp3', updated_at = NOW() WHERE id = 'nanjing_ming_xiaoling_sa_08';

-- A_EN_Benedict_9.Xiang Dian Ruins (Sacrificial Hall).mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_ming_xiaoling_009.mp3', updated_at = NOW() WHERE id = 'nanjing_ming_xiaoling_sa_09';

-- A_EN_Benedict_10.Fangcheng Minglou.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_ming_xiaoling_010.mp3', updated_at = NOW() WHERE id = 'nanjing_ming_xiaoling_sa_10';

-- A_EN_Benedict_11.Baoding (Burial Mound).mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_ming_xiaoling_011.mp3', updated_at = NOW() WHERE id = 'nanjing_ming_xiaoling_sa_11';

-- 南京博物院 (nanjing_museum)
-- A_EN_Benedict_1.正门与历史馆大殿.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_museum_001.mp3', updated_at = NOW() WHERE id = 'nanjing_museum_sa_01';

-- A_EN_Benedict_2.历史馆·2楼1号厅——远古印象.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_museum_002.mp3', updated_at = NOW() WHERE id = 'nanjing_museum_sa_02';

-- A_EN_Benedict_3.历史馆·2楼2号厅——史前神韵与吴越春秋.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_museum_003.mp3', updated_at = NOW() WHERE id = 'nanjing_museum_sa_03';

-- A_EN_Benedict_4.历史馆·2楼3号厅——汉家故里.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_museum_004.mp3', updated_at = NOW() WHERE id = 'nanjing_museum_sa_04';

-- A_EN_Benedict_5.历史馆·1楼4号厅——六朝风华.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_museum_005.mp3', updated_at = NOW() WHERE id = 'nanjing_museum_sa_05';

-- A_EN_Benedict_6.历史馆·1楼5-6号厅——江南盛世.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_museum_006.mp3', updated_at = NOW() WHERE id = 'nanjing_museum_sa_06';

-- A_EN_Benedict_7.特展馆.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_museum_007.mp3', updated_at = NOW() WHERE id = 'nanjing_museum_sa_07';

-- A_EN_Benedict_8.数字馆.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_museum_008.mp3', updated_at = NOW() WHERE id = 'nanjing_museum_sa_08';

-- A_EN_Benedict_9.民国馆.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_museum_009.mp3', updated_at = NOW() WHERE id = 'nanjing_museum_sa_09';

-- A_EN_Benedict_10.艺术馆.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_museum_010.mp3', updated_at = NOW() WHERE id = 'nanjing_museum_sa_10';

-- A_EN_Benedict_11.非遗馆（江苏省非物质文化遗产馆）.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_museum_011.mp3', updated_at = NOW() WHERE id = 'nanjing_museum_sa_11';

-- 南京牛首山文化旅游区 (nanjing_niushoushan)
-- A_EN_Benedict_1.佛顶前苑.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_niushoushan_001.mp3', updated_at = NOW() WHERE id = 'nanjing_niushoushan_sa_01';

-- A_EN_Benedict_2.佛顶寺.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_niushoushan_002.mp3', updated_at = NOW() WHERE id = 'nanjing_niushoushan_sa_02';

-- A_EN_Benedict_3.佛顶宫（外观与小穹顶）.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_niushoushan_003.mp3', updated_at = NOW() WHERE id = 'nanjing_niushoushan_sa_03';

-- A_EN_Benedict_4.佛顶宫·禅境大观.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_niushoushan_004.mp3', updated_at = NOW() WHERE id = 'nanjing_niushoushan_sa_04';

-- A_EN_Benedict_5.佛顶宫·舍利大殿（千佛殿）.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_niushoushan_005.mp3', updated_at = NOW() WHERE id = 'nanjing_niushoushan_sa_05';

-- A_EN_Benedict_6.佛顶宫·万佛廊与舍利藏宫.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_niushoushan_006.mp3', updated_at = NOW() WHERE id = 'nanjing_niushoushan_sa_06';

-- A_EN_Benedict_7.佛顶塔.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_niushoushan_007.mp3', updated_at = NOW() WHERE id = 'nanjing_niushoushan_sa_07';

-- A_EN_Benedict_8.牛头禅文化园（弘觉寺塔）.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_niushoushan_008.mp3', updated_at = NOW() WHERE id = 'nanjing_niushoushan_sa_08';

-- A_EN_Benedict_9.郑和文化园.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_niushoushan_009.mp3', updated_at = NOW() WHERE id = 'nanjing_niushoushan_sa_09';

-- A_EN_Benedict_10.岳飞抗金故垒.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_niushoushan_010.mp3', updated_at = NOW() WHERE id = 'nanjing_niushoushan_sa_10';

-- 总统府（南京中国近代史遗址博物馆） (nanjing_presidential_palace)
-- A_EN_Benedict_1.门楼.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_presidential_palace_001.mp3', updated_at = NOW() WHERE id = 'nanjing_presidential_palace_sa_01';

-- A_EN_Benedict_2.朝房与大堂.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_presidential_palace_002.mp3', updated_at = NOW() WHERE id = 'nanjing_presidential_palace_sa_02';

-- A_EN_Benedict_3.二堂与八字厅.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_presidential_palace_003.mp3', updated_at = NOW() WHERE id = 'nanjing_presidential_palace_sa_03';

-- A_EN_Benedict_4.麒麟门与政务局大楼.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_presidential_palace_004.mp3', updated_at = NOW() WHERE id = 'nanjing_presidential_palace_sa_04';

-- A_EN_Benedict_5.子超楼及总统办公室.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_presidential_palace_005.mp3', updated_at = NOW() WHERE id = 'nanjing_presidential_palace_sa_05';

-- A_EN_Benedict_6.复园.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_presidential_palace_006.mp3', updated_at = NOW() WHERE id = 'nanjing_presidential_palace_sa_06';

-- A_EN_Benedict_7.清两江总督署史料展.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_presidential_palace_007.mp3', updated_at = NOW() WHERE id = 'nanjing_presidential_palace_sa_07';

-- A_EN_Benedict_8.太平天国天朝宫殿陈列.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_presidential_palace_008.mp3', updated_at = NOW() WHERE id = 'nanjing_presidential_palace_sa_08';

-- A_EN_Benedict_9.行政院.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_presidential_palace_009.mp3', updated_at = NOW() WHERE id = 'nanjing_presidential_palace_sa_09';

-- A_EN_Benedict_10.煦园.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_presidential_palace_010.mp3', updated_at = NOW() WHERE id = 'nanjing_presidential_palace_sa_10';

-- A_EN_Benedict_11.太平湖与不系舟.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_presidential_palace_011.mp3', updated_at = NOW() WHERE id = 'nanjing_presidential_palace_sa_11';

-- A_EN_Benedict_12.孙中山临时大总统办公室.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_presidential_palace_012.mp3', updated_at = NOW() WHERE id = 'nanjing_presidential_palace_sa_12';

-- A_EN_Benedict_13.孙中山起居室.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_presidential_palace_013.mp3', updated_at = NOW() WHERE id = 'nanjing_presidential_palace_sa_13';

-- 石臼湖 (nanjing_shijiu_lake)
-- A_EN_Benedict_1.石湫街道向阳村·大堤观景台.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_shijiu_lake_001.mp3', updated_at = NOW() WHERE id = 'nanjing_shijiu_lake_sa_01';

-- A_EN_Benedict_2.石臼湖特大桥·水上列车.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_shijiu_lake_002.mp3', updated_at = NOW() WHERE id = 'nanjing_shijiu_lake_sa_02';

-- A_EN_Benedict_3.洪蓝街道西赵村·候鸟观测点.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_shijiu_lake_003.mp3', updated_at = NOW() WHERE id = 'nanjing_shijiu_lake_sa_03';

-- A_EN_Benedict_4.一工区·灯塔与孤独的树.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_shijiu_lake_004.mp3', updated_at = NOW() WHERE id = 'nanjing_shijiu_lake_sa_04';

-- A_EN_Benedict_5.和凤镇张许村·日落栈桥.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_shijiu_lake_005.mp3', updated_at = NOW() WHERE id = 'nanjing_shijiu_lake_sa_05';

-- A_EN_Benedict_6.和凤镇诸家村·古村落.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_shijiu_lake_006.mp3', updated_at = NOW() WHERE id = 'nanjing_shijiu_lake_sa_06';

-- 南京中山陵景区 (nanjing_sun_yat_sen_mausoleum)
-- A_EN_Benedict_1.孝经鼎广场.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_sun_yat_sen_mausoleum_001.mp3', updated_at = NOW() WHERE id = 'nanjing_sun_yat_sen_mausoleum_sa_01';

-- A_EN_Benedict_2.博爱坊.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_sun_yat_sen_mausoleum_002.mp3', updated_at = NOW() WHERE id = 'nanjing_sun_yat_sen_mausoleum_sa_02';

-- A_EN_Benedict_3.墓道.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_sun_yat_sen_mausoleum_003.mp3', updated_at = NOW() WHERE id = 'nanjing_sun_yat_sen_mausoleum_sa_03';

-- A_EN_Benedict_4.陵门.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_sun_yat_sen_mausoleum_004.mp3', updated_at = NOW() WHERE id = 'nanjing_sun_yat_sen_mausoleum_sa_04';

-- A_EN_Benedict_5.碑亭.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_sun_yat_sen_mausoleum_005.mp3', updated_at = NOW() WHERE id = 'nanjing_sun_yat_sen_mausoleum_sa_05';

-- A_EN_Benedict_6.石阶.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_sun_yat_sen_mausoleum_006.mp3', updated_at = NOW() WHERE id = 'nanjing_sun_yat_sen_mausoleum_sa_06';

-- A_EN_Benedict_7.祭堂.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_sun_yat_sen_mausoleum_007.mp3', updated_at = NOW() WHERE id = 'nanjing_sun_yat_sen_mausoleum_sa_07';

-- A_EN_Benedict_9.音乐台与附属建筑.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/nanjing_sun_yat_sen_mausoleum_009.mp3', updated_at = NOW() WHERE id = 'nanjing_sun_yat_sen_mausoleum_sa_09';

-- 东方明珠广播电视塔 (oriental_pearl_radio_television_tower)
-- A_EN_Benedict_1.Ticket Entrance.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/oriental_pearl_radio_television_tower_001.mp3', updated_at = NOW() WHERE id = 'oriental_pearl_radio_television_tower_sa_01';

-- A_EN_Benedict_2.Main Observation Level.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/oriental_pearl_radio_television_tower_002.mp3', updated_at = NOW() WHERE id = 'oriental_pearl_radio_television_tower_sa_02';

-- A_EN_Benedict_3.Space Capsule.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/oriental_pearl_radio_television_tower_003.mp3', updated_at = NOW() WHERE id = 'oriental_pearl_radio_television_tower_sa_03';

-- A_EN_Benedict_4.Fully Transparent Suspended Skywalk.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/oriental_pearl_radio_television_tower_004.mp3', updated_at = NOW() WHERE id = 'oriental_pearl_radio_television_tower_sa_04';

-- A_EN_Benedict_5.Outdoor Observation Level.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/oriental_pearl_radio_television_tower_005.mp3', updated_at = NOW() WHERE id = 'oriental_pearl_radio_television_tower_sa_05';

-- A_EN_Benedict_6.Higher Shanghai Immersive Multimedia Show.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/oriental_pearl_radio_television_tower_006.mp3', updated_at = NOW() WHERE id = 'oriental_pearl_radio_television_tower_sa_06';

-- A_EN_Benedict_7.Shanghai Municipal History Museum.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/oriental_pearl_radio_television_tower_007.mp3', updated_at = NOW() WHERE id = 'oriental_pearl_radio_television_tower_sa_07';

-- 青羊宫 (qingyangg)
-- A_EN_Benedict_1.正门（A口）.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/qingyangg_001.mp3', updated_at = NOW() WHERE id = 'qingyangg_sa_01';

-- A_EN_Benedict_2.山门.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/qingyangg_002.mp3', updated_at = NOW() WHERE id = 'qingyangg_sa_02';

-- A_EN_Benedict_3.灵祖殿.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/qingyangg_003.mp3', updated_at = NOW() WHERE id = 'qingyangg_sa_03';

-- A_EN_Benedict_4.混元殿.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/qingyangg_004.mp3', updated_at = NOW() WHERE id = 'qingyangg_sa_04';

-- A_EN_Benedict_5.八卦亭.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/qingyangg_005.mp3', updated_at = NOW() WHERE id = 'qingyangg_sa_05';

-- A_EN_Benedict_6.三清殿.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/qingyangg_006.mp3', updated_at = NOW() WHERE id = 'qingyangg_sa_06';

-- A_EN_Benedict_7.斗姥殿.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/qingyangg_007.mp3', updated_at = NOW() WHERE id = 'qingyangg_sa_07';

-- A_EN_Benedict_8.玉皇殿（福禄寿照壁）.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/qingyangg_008.mp3', updated_at = NOW() WHERE id = 'qingyangg_sa_08';

-- A_EN_Benedict_9.降生台与说法台.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/qingyangg_009.mp3', updated_at = NOW() WHERE id = 'qingyangg_sa_09';

-- A_EN_Benedict_10.紫金台（唐王殿）.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/qingyangg_010.mp3', updated_at = NOW() WHERE id = 'qingyangg_sa_10';

-- A_EN_Benedict_11.茶园与老庄书院（总结）.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/qingyangg_011.mp3', updated_at = NOW() WHERE id = 'qingyangg_sa_11';

-- 上海迪士尼度假区 (shanghai_disney_resort)
-- A_EN_Benedict_1.Mickey Avenue.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/shanghai_disney_resort_001.mp3', updated_at = NOW() WHERE id = 'shanghai_disney_resort_sa_01';

-- A_EN_Benedict_2.Gardens of Imagination.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/shanghai_disney_resort_002.mp3', updated_at = NOW() WHERE id = 'shanghai_disney_resort_sa_02';

-- A_EN_Benedict_3.Adventure Isle.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/shanghai_disney_resort_003.mp3', updated_at = NOW() WHERE id = 'shanghai_disney_resort_sa_03';

-- A_EN_Benedict_4.Treasure Cove.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/shanghai_disney_resort_004.mp3', updated_at = NOW() WHERE id = 'shanghai_disney_resort_sa_04';

-- A_EN_Benedict_5.Fantasyland.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/shanghai_disney_resort_005.mp3', updated_at = NOW() WHERE id = 'shanghai_disney_resort_sa_05';

-- A_EN_Benedict_6.Tomorrowland.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/shanghai_disney_resort_006.mp3', updated_at = NOW() WHERE id = 'shanghai_disney_resort_sa_06';

-- A_EN_Benedict_7.Toy Story Land.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/shanghai_disney_resort_007.mp3', updated_at = NOW() WHERE id = 'shanghai_disney_resort_sa_07';

-- A_EN_Benedict_8.Zootopia.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/shanghai_disney_resort_008.mp3', updated_at = NOW() WHERE id = 'shanghai_disney_resort_sa_08';

-- A_EN_Benedict_9.Disneytown.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/shanghai_disney_resort_009.mp3', updated_at = NOW() WHERE id = 'shanghai_disney_resort_sa_09';

-- A_EN_Benedict_10.Wishing Star Park.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/shanghai_disney_resort_010.mp3', updated_at = NOW() WHERE id = 'shanghai_disney_resort_sa_10';

-- 上海博物馆 (shanghai_museum)
-- A_EN_Benedict_1.Ancient Chinese Bronze Gallery.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/shanghai_museum_001.mp3', updated_at = NOW() WHERE id = 'shanghai_museum_sa_01';

-- A_EN_Benedict_2.Ancient Chinese Sculpture Gallery.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/shanghai_museum_002.mp3', updated_at = NOW() WHERE id = 'shanghai_museum_sa_02';

-- A_EN_Benedict_3.Ancient Chinese Ceramics Gallery.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/shanghai_museum_003.mp3', updated_at = NOW() WHERE id = 'shanghai_museum_sa_03';

-- A_EN_Benedict_4.Chinese Calligraphy Gallery.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/shanghai_museum_004.mp3', updated_at = NOW() WHERE id = 'shanghai_museum_sa_04';

-- A_EN_Benedict_5.Chinese Painting Gallery.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/shanghai_museum_005.mp3', updated_at = NOW() WHERE id = 'shanghai_museum_sa_05';

-- A_EN_Benedict_6.Chinese Seal Gallery.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/shanghai_museum_006.mp3', updated_at = NOW() WHERE id = 'shanghai_museum_sa_06';

-- A_EN_Benedict_7.Ancient Chinese Jade Gallery.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/shanghai_museum_007.mp3', updated_at = NOW() WHERE id = 'shanghai_museum_sa_07';

-- A_EN_Benedict_8.Chinese Currency Gallery.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/shanghai_museum_008.mp3', updated_at = NOW() WHERE id = 'shanghai_museum_sa_08';

-- A_EN_Benedict_9.Ming and Qing Furniture Gallery.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/shanghai_museum_009.mp3', updated_at = NOW() WHERE id = 'shanghai_museum_sa_09';

-- A_EN_Benedict_10.Chinese Ethnic Minorities Craft Gallery.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/shanghai_museum_010.mp3', updated_at = NOW() WHERE id = 'shanghai_museum_sa_10';

-- 四川博物院 (sichuan_museum)
-- A_EN_Benedict_1.正门与大厅.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/sichuan_museum_001.mp3', updated_at = NOW() WHERE id = 'sichuan_museum_sa_01';

-- A_EN_Benedict_2.一楼·四川汉代陶石艺术馆.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/sichuan_museum_002.mp3', updated_at = NOW() WHERE id = 'sichuan_museum_sa_02';

-- A_EN_Benedict_5.二楼·巴蜀青铜器馆.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/sichuan_museum_005.mp3', updated_at = NOW() WHERE id = 'sichuan_museum_sa_05';

-- A_EN_Benedict_6.二楼·陶瓷馆.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/sichuan_museum_006.mp3', updated_at = NOW() WHERE id = 'sichuan_museum_sa_06';

-- A_EN_Benedict_7.二楼·张大千书画馆（大风堂）.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/sichuan_museum_007.mp3', updated_at = NOW() WHERE id = 'sichuan_museum_sa_07';

-- A_EN_Benedict_9.三楼·藏传佛教文物馆.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/sichuan_museum_009.mp3', updated_at = NOW() WHERE id = 'sichuan_museum_sa_09';

-- A_EN_Benedict_10.三楼·万佛寺石刻馆.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/sichuan_museum_010.mp3', updated_at = NOW() WHERE id = 'sichuan_museum_sa_10';

-- A_EN_Benedict_11.三楼·四川民族文物馆.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/sichuan_museum_011.mp3', updated_at = NOW() WHERE id = 'sichuan_museum_sa_11';

-- A_EN_Benedict_12.三楼·工艺美术馆.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/sichuan_museum_012.mp3', updated_at = NOW() WHERE id = 'sichuan_museum_sa_12';

-- A_EN_Benedict_13.出口与周边（总结）.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/sichuan_museum_013.mp3', updated_at = NOW() WHERE id = 'sichuan_museum_sa_13';

-- 南外滩轻纺面料市场 (south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market)
-- A_EN_Benedict_1.Market Entrance Hall.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market_001.mp3', updated_at = NOW() WHERE id = 'south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market_sa_01';

-- A_EN_Benedict_2.1F Ready-to-Wear and Leather Goods Zone.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market_002.mp3', updated_at = NOW() WHERE id = 'south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market_sa_02';

-- A_EN_Benedict_3.1F Kate and Kevin Custom Tailoring Workshop.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market_003.mp3', updated_at = NOW() WHERE id = 'south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market_sa_03';

-- A_EN_Benedict_4.2F Bespoke Suit Core Zone.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market_004.mp3', updated_at = NOW() WHERE id = 'south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market_sa_04';

-- A_EN_Benedict_5.2F Imported Fabric Boutique.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market_005.mp3', updated_at = NOW() WHERE id = 'south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market_sa_05';

-- A_EN_Benedict_6.3F Qipao and Chinese-Style Garment Zone.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market_006.mp3', updated_at = NOW() WHERE id = 'south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market_sa_06';

-- A_EN_Benedict_7.3F Traditional Fabric Retail Zone.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market_007.mp3', updated_at = NOW() WHERE id = 'south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market_sa_07';

-- A_EN_Benedict_8.4F Cashmere and Miscellaneous Zone.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market_008.mp3', updated_at = NOW() WHERE id = 'south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market_sa_08';

-- A_EN_Benedict_9.Huangpu Post International Shipping Service Counter.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market_009.mp3', updated_at = NOW() WHERE id = 'south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market_sa_09';

-- 沧浪亭景区 (suzhou_canglang_pavilion)
-- A_EN_Benedict_1.面水轩.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_canglang_pavilion_001.mp3', updated_at = NOW() WHERE id = 'suzhou_canglang_pavilion_sa_01';

-- A_EN_Benedict_2.观鱼处.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_canglang_pavilion_002.mp3', updated_at = NOW() WHERE id = 'suzhou_canglang_pavilion_sa_02';

-- A_EN_Benedict_3.沧浪亭.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_canglang_pavilion_003.mp3', updated_at = NOW() WHERE id = 'suzhou_canglang_pavilion_sa_03';

-- A_EN_Benedict_4.明道堂.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_canglang_pavilion_004.mp3', updated_at = NOW() WHERE id = 'suzhou_canglang_pavilion_sa_04';

-- A_EN_Benedict_5.看山楼.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_canglang_pavilion_005.mp3', updated_at = NOW() WHERE id = 'suzhou_canglang_pavilion_sa_05';

-- A_EN_Benedict_6.翠玲珑.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_canglang_pavilion_006.mp3', updated_at = NOW() WHERE id = 'suzhou_canglang_pavilion_sa_06';

-- A_EN_Benedict_7.五百名贤祠.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_canglang_pavilion_007.mp3', updated_at = NOW() WHERE id = 'suzhou_canglang_pavilion_sa_07';

-- A_EN_Benedict_8.御碑亭.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_canglang_pavilion_008.mp3', updated_at = NOW() WHERE id = 'suzhou_canglang_pavilion_sa_08';

-- A_EN_Benedict_9.藕花水榭.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_canglang_pavilion_009.mp3', updated_at = NOW() WHERE id = 'suzhou_canglang_pavilion_sa_09';

-- 苏州河十二国色 (suzhou_creek_twelve_nations_colors)
-- A_EN_Benedict_1.Gaoling Market (Egg Yellow).mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_creek_twelve_nations_colors_001.mp3', updated_at = NOW() WHERE id = 'suzhou_creek_twelve_nations_colors_sa_01';

-- A_EN_Benedict_2.Caoyang New Village (Moon White).mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_creek_twelve_nations_colors_002.mp3', updated_at = NOW() WHERE id = 'suzhou_creek_twelve_nations_colors_sa_02';

-- A_EN_Benedict_3.Jade Buddha Temple (Vermilion).mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_creek_twelve_nations_colors_003.mp3', updated_at = NOW() WHERE id = 'suzhou_creek_twelve_nations_colors_sa_03';

-- A_EN_Benedict_4.M50 Creative Park (Jade Green).mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_creek_twelve_nations_colors_004.mp3', updated_at = NOW() WHERE id = 'suzhou_creek_twelve_nations_colors_sa_04';

-- A_EN_Benedict_5.Chuangxiang Tower (Hibiscus).mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_creek_twelve_nations_colors_005.mp3', updated_at = NOW() WHERE id = 'suzhou_creek_twelve_nations_colors_sa_12';

-- A_EN_Benedict_6.Wuyuan Tea House (Sky Blue).mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_creek_twelve_nations_colors_006.mp3', updated_at = NOW() WHERE id = 'suzhou_creek_twelve_nations_colors_sa_05';

-- A_EN_Benedict_7.Bamboo Weaving Heritage Experience Hall (Bamboo Green).mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_creek_twelve_nations_colors_007.mp3', updated_at = NOW() WHERE id = 'suzhou_creek_twelve_nations_colors_sa_06';

-- A_EN_Benedict_8.Gu Zhenghong Memorial Hall (Deep Black).mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_creek_twelve_nations_colors_008.mp3', updated_at = NOW() WHERE id = 'suzhou_creek_twelve_nations_colors_sa_07';

-- A_EN_Benedict_9.Suzhou Creek Industrial Heritage Museum (Lilac).mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_creek_twelve_nations_colors_009.mp3', updated_at = NOW() WHERE id = 'suzhou_creek_twelve_nations_colors_sa_08';

-- A_EN_Benedict_10.Banma Suhe Park (Cobalt Blue).mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_creek_twelve_nations_colors_010.mp3', updated_at = NOW() WHERE id = 'suzhou_creek_twelve_nations_colors_sa_09';

-- A_EN_Benedict_11.Baixi Park (Begonia Purple).mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_creek_twelve_nations_colors_011.mp3', updated_at = NOW() WHERE id = 'suzhou_creek_twelve_nations_colors_sa_10';

-- A_EN_Benedict_12.Hongshou Fang (Amber).mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_creek_twelve_nations_colors_012.mp3', updated_at = NOW() WHERE id = 'suzhou_creek_twelve_nations_colors_sa_11';

-- 环秀山庄 (suzhou_huanxiu_mountain_villa)
-- A_EN_Benedict_1.有穀堂.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_huanxiu_mountain_villa_001.mp3', updated_at = NOW() WHERE id = 'suzhou_huanxiu_mountain_villa_sa_01';

-- A_EN_Benedict_2.环秀山庄（四面厅）.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_huanxiu_mountain_villa_002.mp3', updated_at = NOW() WHERE id = 'suzhou_huanxiu_mountain_villa_sa_02';

-- A_EN_Benedict_3.戈裕良假山.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_huanxiu_mountain_villa_003.mp3', updated_at = NOW() WHERE id = 'suzhou_huanxiu_mountain_villa_sa_03';

-- A_EN_Benedict_4.涵云阁.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_huanxiu_mountain_villa_004.mp3', updated_at = NOW() WHERE id = 'suzhou_huanxiu_mountain_villa_sa_04';

-- A_EN_Benedict_5.边楼与边廊.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_huanxiu_mountain_villa_005.mp3', updated_at = NOW() WHERE id = 'suzhou_huanxiu_mountain_villa_sa_05';

-- A_EN_Benedict_6.问泉亭.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_huanxiu_mountain_villa_006.mp3', updated_at = NOW() WHERE id = 'suzhou_huanxiu_mountain_villa_sa_06';

-- A_EN_Benedict_7.补秋舫.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_huanxiu_mountain_villa_007.mp3', updated_at = NOW() WHERE id = 'suzhou_huanxiu_mountain_villa_sa_07';

-- A_EN_Benedict_8.半潭秋水一房山亭.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_huanxiu_mountain_villa_008.mp3', updated_at = NOW() WHERE id = 'suzhou_huanxiu_mountain_villa_sa_08';

-- A_EN_Benedict_9.飞雪泉遗址.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_huanxiu_mountain_villa_009.mp3', updated_at = NOW() WHERE id = 'suzhou_huanxiu_mountain_villa_sa_09';

-- 拙政园 (suzhou_humble_administrators_garden)
-- A_EN_Benedict_1.兰雪堂.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_humble_administrators_garden_001.mp3', updated_at = NOW() WHERE id = 'suzhou_humble_administrators_garden_sa_01';

-- A_EN_Benedict_2.远香堂.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_humble_administrators_garden_002.mp3', updated_at = NOW() WHERE id = 'suzhou_humble_administrators_garden_sa_02';

-- A_EN_Benedict_3.香洲.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_humble_administrators_garden_003.mp3', updated_at = NOW() WHERE id = 'suzhou_humble_administrators_garden_sa_03';

-- A_EN_Benedict_4.荷风四面亭.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_humble_administrators_garden_004.mp3', updated_at = NOW() WHERE id = 'suzhou_humble_administrators_garden_sa_04';

-- A_EN_Benedict_5.小飞虹.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_humble_administrators_garden_005.mp3', updated_at = NOW() WHERE id = 'suzhou_humble_administrators_garden_sa_05';

-- A_EN_Benedict_6.见山楼.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_humble_administrators_garden_006.mp3', updated_at = NOW() WHERE id = 'suzhou_humble_administrators_garden_sa_06';

-- A_EN_Benedict_7.卅六鸳鸯馆.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_humble_administrators_garden_007.mp3', updated_at = NOW() WHERE id = 'suzhou_humble_administrators_garden_sa_07';

-- A_EN_Benedict_8.与谁同坐轩.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_humble_administrators_garden_008.mp3', updated_at = NOW() WHERE id = 'suzhou_humble_administrators_garden_sa_08';

-- A_EN_Benedict_9.留听阁.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_humble_administrators_garden_009.mp3', updated_at = NOW() WHERE id = 'suzhou_humble_administrators_garden_sa_09';

-- 留园景区 (suzhou_lingering_garden)
-- A_EN_Benedict_1.古木交柯.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_lingering_garden_001.mp3', updated_at = NOW() WHERE id = 'suzhou_lingering_garden_sa_01';

-- A_EN_Benedict_2.绿荫轩.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_lingering_garden_002.mp3', updated_at = NOW() WHERE id = 'suzhou_lingering_garden_sa_02';

-- A_EN_Benedict_3.涵碧山房.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_lingering_garden_003.mp3', updated_at = NOW() WHERE id = 'suzhou_lingering_garden_sa_03';

-- A_EN_Benedict_4.闻木犀香轩.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_lingering_garden_004.mp3', updated_at = NOW() WHERE id = 'suzhou_lingering_garden_sa_04';

-- A_EN_Benedict_5.曲溪楼.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_lingering_garden_005.mp3', updated_at = NOW() WHERE id = 'suzhou_lingering_garden_sa_05';

-- A_EN_Benedict_6.五峰仙馆.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_lingering_garden_006.mp3', updated_at = NOW() WHERE id = 'suzhou_lingering_garden_sa_06';

-- A_EN_Benedict_7.林泉耆硕之馆.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_lingering_garden_007.mp3', updated_at = NOW() WHERE id = 'suzhou_lingering_garden_sa_07';

-- A_EN_Benedict_8.冠云峰.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_lingering_garden_008.mp3', updated_at = NOW() WHERE id = 'suzhou_lingering_garden_sa_08';

-- A_EN_Benedict_9.冠云楼.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_lingering_garden_009.mp3', updated_at = NOW() WHERE id = 'suzhou_lingering_garden_sa_09';

-- 狮子林 (suzhou_lion_grove_garden)
-- A_EN_Benedict_1.燕誉堂.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_lion_grove_garden_001.mp3', updated_at = NOW() WHERE id = 'suzhou_lion_grove_garden_sa_01';

-- A_EN_Benedict_2.小方厅.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_lion_grove_garden_002.mp3', updated_at = NOW() WHERE id = 'suzhou_lion_grove_garden_sa_02';

-- A_EN_Benedict_3.九狮峰.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_lion_grove_garden_003.mp3', updated_at = NOW() WHERE id = 'suzhou_lion_grove_garden_sa_03';

-- A_EN_Benedict_4.指柏轩.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_lion_grove_garden_004.mp3', updated_at = NOW() WHERE id = 'suzhou_lion_grove_garden_sa_04';

-- A_EN_Benedict_5.花篮厅.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_lion_grove_garden_005.mp3', updated_at = NOW() WHERE id = 'suzhou_lion_grove_garden_sa_05';

-- A_EN_Benedict_6.真趣亭.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_lion_grove_garden_006.mp3', updated_at = NOW() WHERE id = 'suzhou_lion_grove_garden_sa_06';

-- A_EN_Benedict_7.石舫.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_lion_grove_garden_007.mp3', updated_at = NOW() WHERE id = 'suzhou_lion_grove_garden_sa_07';

-- A_EN_Benedict_8.暗香疏影楼盘.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_lion_grove_garden_008.mp3', updated_at = NOW() WHERE id = 'suzhou_lion_grove_garden_sa_08';

-- A_EN_Benedict_9.湖心亭.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_lion_grove_garden_009.mp3', updated_at = NOW() WHERE id = 'suzhou_lion_grove_garden_sa_09';

-- A_EN_Benedict_10.卧云室.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_lion_grove_garden_010.mp3', updated_at = NOW() WHERE id = 'suzhou_lion_grove_garden_sa_10';

-- 网师园 (suzhou_master_of_nets_garden)
-- A_EN_Benedict_1.入口大门.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_master_of_nets_garden_001.mp3', updated_at = NOW() WHERE id = 'suzhou_master_of_nets_garden_sa_01';

-- A_EN_Benedict_2.轿厅.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_master_of_nets_garden_002.mp3', updated_at = NOW() WHERE id = 'suzhou_master_of_nets_garden_sa_02';

-- A_EN_Benedict_3.万卷堂.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_master_of_nets_garden_003.mp3', updated_at = NOW() WHERE id = 'suzhou_master_of_nets_garden_sa_03';

-- A_EN_Benedict_4.撷秀楼.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_master_of_nets_garden_004.mp3', updated_at = NOW() WHERE id = 'suzhou_master_of_nets_garden_sa_04';

-- A_EN_Benedict_5.梯云室.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_master_of_nets_garden_005.mp3', updated_at = NOW() WHERE id = 'suzhou_master_of_nets_garden_sa_05';

-- A_EN_Benedict_6.看松读画轩.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_master_of_nets_garden_006.mp3', updated_at = NOW() WHERE id = 'suzhou_master_of_nets_garden_sa_06';

-- A_EN_Benedict_7.殿春簃.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_master_of_nets_garden_007.mp3', updated_at = NOW() WHERE id = 'suzhou_master_of_nets_garden_sa_07';

-- A_EN_Benedict_8.月到风来亭.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_master_of_nets_garden_008.mp3', updated_at = NOW() WHERE id = 'suzhou_master_of_nets_garden_sa_08';

-- A_EN_Benedict_9.濯缨水阁.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_master_of_nets_garden_009.mp3', updated_at = NOW() WHERE id = 'suzhou_master_of_nets_garden_sa_09';

-- A_EN_Benedict_10.竹外一枝轩.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_master_of_nets_garden_010.mp3', updated_at = NOW() WHERE id = 'suzhou_master_of_nets_garden_sa_10';

-- 苏州博物馆 (suzhou_museum)
-- A_EN_Benedict_1.入口大厅.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_museum_001.mp3', updated_at = NOW() WHERE id = 'suzhou_museum_sa_01';

-- A_EN_Benedict_2.吴地遗珍展厅.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_museum_002.mp3', updated_at = NOW() WHERE id = 'suzhou_museum_sa_02';

-- A_EN_Benedict_3.吴塔国宝展厅.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_museum_003.mp3', updated_at = NOW() WHERE id = 'suzhou_museum_sa_03';

-- A_EN_Benedict_4.吴中风雅展厅.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_museum_004.mp3', updated_at = NOW() WHERE id = 'suzhou_museum_sa_04';

-- A_EN_Benedict_5.吴门书画展厅.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_museum_005.mp3', updated_at = NOW() WHERE id = 'suzhou_museum_sa_05';

-- A_EN_Benedict_6.新石器时代玉器展厅.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_museum_006.mp3', updated_at = NOW() WHERE id = 'suzhou_museum_sa_06';

-- A_EN_Benedict_7.主庭院（片石假山）.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_museum_007.mp3', updated_at = NOW() WHERE id = 'suzhou_museum_sa_07';

-- A_EN_Benedict_8.紫藤园.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_museum_008.mp3', updated_at = NOW() WHERE id = 'suzhou_museum_sa_08';

-- A_EN_Benedict_9.茶室.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_museum_009.mp3', updated_at = NOW() WHERE id = 'suzhou_museum_sa_09';

-- A_EN_Benedict_10.太平天国忠王府.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_museum_010.mp3', updated_at = NOW() WHERE id = 'suzhou_museum_sa_10';

-- 耦园（又称藕园） (suzhou_ou_garden)
-- A_EN_Benedict_1.门厅.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_ou_garden_001.mp3', updated_at = NOW() WHERE id = 'suzhou_ou_garden_sa_01';

-- A_EN_Benedict_2.轿厅.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_ou_garden_002.mp3', updated_at = NOW() WHERE id = 'suzhou_ou_garden_sa_02';

-- A_EN_Benedict_3.大厅（涉趣堂）.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_ou_garden_003.mp3', updated_at = NOW() WHERE id = 'suzhou_ou_garden_sa_03';

-- A_EN_Benedict_4.楼厅（寝居楼）.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_ou_garden_004.mp3', updated_at = NOW() WHERE id = 'suzhou_ou_garden_sa_04';

-- A_EN_Benedict_5.书房（含蕊书斋）.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_ou_garden_005.mp3', updated_at = NOW() WHERE id = 'suzhou_ou_garden_sa_05';

-- A_EN_Benedict_6.戏厅（听橹厅）.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_ou_garden_006.mp3', updated_at = NOW() WHERE id = 'suzhou_ou_garden_sa_06';

-- A_EN_Benedict_7.荷花池.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_ou_garden_007.mp3', updated_at = NOW() WHERE id = 'suzhou_ou_garden_sa_07';

-- A_EN_Benedict_8.假山.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_ou_garden_008.mp3', updated_at = NOW() WHERE id = 'suzhou_ou_garden_sa_08';

-- A_EN_Benedict_9.六角亭（藕香亭）.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_ou_garden_009.mp3', updated_at = NOW() WHERE id = 'suzhou_ou_garden_sa_09';

-- A_EN_Benedict_10.回廊.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_ou_garden_010.mp3', updated_at = NOW() WHERE id = 'suzhou_ou_garden_sa_10';

-- 平江路历史街区 (suzhou_pingjiang_road)
-- A_EN_Benedict_1.相门入口.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_pingjiang_road_001.mp3', updated_at = NOW() WHERE id = 'suzhou_pingjiang_road_sa_01';

-- A_EN_Benedict_2.苑桥.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_pingjiang_road_002.mp3', updated_at = NOW() WHERE id = 'suzhou_pingjiang_road_sa_02';

-- A_EN_Benedict_3.思婆桥.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_pingjiang_road_003.mp3', updated_at = NOW() WHERE id = 'suzhou_pingjiang_road_sa_03';

-- A_EN_Benedict_4.丁香巷.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_pingjiang_road_004.mp3', updated_at = NOW() WHERE id = 'suzhou_pingjiang_road_sa_04';

-- A_EN_Benedict_5.中张家巷（评弹博物馆）.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_pingjiang_road_005.mp3', updated_at = NOW() WHERE id = 'suzhou_pingjiang_road_sa_05';

-- A_EN_Benedict_6.钮家巷（状元博物馆）.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_pingjiang_road_006.mp3', updated_at = NOW() WHERE id = 'suzhou_pingjiang_road_sa_06';

-- A_EN_Benedict_7.大儒巷.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_pingjiang_road_007.mp3', updated_at = NOW() WHERE id = 'suzhou_pingjiang_road_sa_07';

-- A_EN_Benedict_8.悬桥巷（洪钧故居、船屋）.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_pingjiang_road_008.mp3', updated_at = NOW() WHERE id = 'suzhou_pingjiang_road_sa_08';

-- A_EN_Benedict_9.青石桥.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_pingjiang_road_009.mp3', updated_at = NOW() WHERE id = 'suzhou_pingjiang_road_sa_09';

-- A_EN_Benedict_10.全晋会馆-苏州戏曲博物馆.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_pingjiang_road_010.mp3', updated_at = NOW() WHERE id = 'suzhou_pingjiang_road_sa_10';

-- 同里古镇 (suzhou_tongli_ancient_town)
-- A_EN_Benedict_1.退思园.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_tongli_ancient_town_001.mp3', updated_at = NOW() WHERE id = 'suzhou_tongli_ancient_town_sa_01';

-- A_EN_Benedict_2.珍珠塔.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_tongli_ancient_town_002.mp3', updated_at = NOW() WHERE id = 'suzhou_tongli_ancient_town_sa_02';

-- A_EN_Benedict_3.三桥.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_tongli_ancient_town_003.mp3', updated_at = NOW() WHERE id = 'suzhou_tongli_ancient_town_sa_03';

-- A_EN_Benedict_4.崇本堂.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_tongli_ancient_town_004.mp3', updated_at = NOW() WHERE id = 'suzhou_tongli_ancient_town_sa_04';

-- A_EN_Benedict_5.嘉荫堂.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_tongli_ancient_town_005.mp3', updated_at = NOW() WHERE id = 'suzhou_tongli_ancient_town_sa_05';

-- A_EN_Benedict_6.耕乐堂.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_tongli_ancient_town_006.mp3', updated_at = NOW() WHERE id = 'suzhou_tongli_ancient_town_sa_06';

-- A_EN_Benedict_7.明清街.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_tongli_ancient_town_007.mp3', updated_at = NOW() WHERE id = 'suzhou_tongli_ancient_town_sa_07';

-- A_EN_Benedict_8.南园茶社.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_tongli_ancient_town_008.mp3', updated_at = NOW() WHERE id = 'suzhou_tongli_ancient_town_sa_08';

-- A_EN_Benedict_9.陈去病故居.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_tongli_ancient_town_009.mp3', updated_at = NOW() WHERE id = 'suzhou_tongli_ancient_town_sa_09';

-- A_EN_Benedict_10.罗星洲.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_tongli_ancient_town_010.mp3', updated_at = NOW() WHERE id = 'suzhou_tongli_ancient_town_sa_10';

-- 退思园 (suzhou_tuisi_garden)
-- A_EN_Benedict_1.入口宅门.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_tuisi_garden_001.mp3', updated_at = NOW() WHERE id = 'suzhou_tuisi_garden_sa_01';

-- A_EN_Benedict_2.轿厅.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_tuisi_garden_002.mp3', updated_at = NOW() WHERE id = 'suzhou_tuisi_garden_sa_02';

-- A_EN_Benedict_3.正厅（荫余堂）.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_tuisi_garden_003.mp3', updated_at = NOW() WHERE id = 'suzhou_tuisi_garden_sa_03';

-- A_EN_Benedict_4.内宅（畹芗楼）.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_tuisi_garden_004.mp3', updated_at = NOW() WHERE id = 'suzhou_tuisi_garden_sa_04';

-- A_EN_Benedict_5.退思草堂.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_tuisi_garden_005.mp3', updated_at = NOW() WHERE id = 'suzhou_tuisi_garden_sa_05';

-- A_EN_Benedict_6.水香榭.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_tuisi_garden_006.mp3', updated_at = NOW() WHERE id = 'suzhou_tuisi_garden_sa_06';

-- A_EN_Benedict_7.琴房与眠云亭.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_tuisi_garden_007.mp3', updated_at = NOW() WHERE id = 'suzhou_tuisi_garden_sa_07';

-- A_EN_Benedict_8.菰雨生凉.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_tuisi_garden_008.mp3', updated_at = NOW() WHERE id = 'suzhou_tuisi_garden_sa_08';

-- A_EN_Benedict_9.天桥与辛台.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_tuisi_garden_009.mp3', updated_at = NOW() WHERE id = 'suzhou_tuisi_garden_sa_09';

-- A_EN_Benedict_10.闹红一舸与九曲回廊.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_tuisi_garden_010.mp3', updated_at = NOW() WHERE id = 'suzhou_tuisi_garden_sa_10';

-- 艺圃 (suzhou_yi_garden)
-- A_EN_Benedict_1.入口宅门.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_yi_garden_001.mp3', updated_at = NOW() WHERE id = 'suzhou_yi_garden_sa_01';

-- A_EN_Benedict_2.世纶堂.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_yi_garden_002.mp3', updated_at = NOW() WHERE id = 'suzhou_yi_garden_sa_02';

-- A_EN_Benedict_3.东莱草堂.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_yi_garden_003.mp3', updated_at = NOW() WHERE id = 'suzhou_yi_garden_sa_03';

-- A_EN_Benedict_4.思嗜轩.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_yi_garden_004.mp3', updated_at = NOW() WHERE id = 'suzhou_yi_garden_sa_04';

-- A_EN_Benedict_5.乳鱼池.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_yi_garden_005.mp3', updated_at = NOW() WHERE id = 'suzhou_yi_garden_sa_05';

-- A_EN_Benedict_6.延光阁.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_yi_garden_006.mp3', updated_at = NOW() WHERE id = 'suzhou_yi_garden_sa_06';

-- A_EN_Benedict_7.朝爽亭.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_yi_garden_007.mp3', updated_at = NOW() WHERE id = 'suzhou_yi_garden_sa_07';

-- A_EN_Benedict_8.碧浪亭.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_yi_garden_008.mp3', updated_at = NOW() WHERE id = 'suzhou_yi_garden_sa_08';

-- A_EN_Benedict_9.芹庐.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_yi_garden_009.mp3', updated_at = NOW() WHERE id = 'suzhou_yi_garden_sa_09';

-- A_EN_Benedict_10.博雅堂.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_yi_garden_010.mp3', updated_at = NOW() WHERE id = 'suzhou_yi_garden_sa_10';

-- 周庄古镇 (suzhou_zhouzhuang_ancient_town)
-- A_EN_Benedict_1.古戏台.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_zhouzhuang_ancient_town_001.mp3', updated_at = NOW() WHERE id = 'suzhou_zhouzhuang_ancient_town_sa_01';

-- A_EN_Benedict_2.双桥.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_zhouzhuang_ancient_town_002.mp3', updated_at = NOW() WHERE id = 'suzhou_zhouzhuang_ancient_town_sa_02';

-- A_EN_Benedict_3.沈厅.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_zhouzhuang_ancient_town_003.mp3', updated_at = NOW() WHERE id = 'suzhou_zhouzhuang_ancient_town_sa_03';

-- A_EN_Benedict_4.张厅.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_zhouzhuang_ancient_town_004.mp3', updated_at = NOW() WHERE id = 'suzhou_zhouzhuang_ancient_town_sa_04';

-- A_EN_Benedict_5.富安桥.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_zhouzhuang_ancient_town_005.mp3', updated_at = NOW() WHERE id = 'suzhou_zhouzhuang_ancient_town_sa_05';

-- A_EN_Benedict_6.迷楼.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_zhouzhuang_ancient_town_006.mp3', updated_at = NOW() WHERE id = 'suzhou_zhouzhuang_ancient_town_sa_06';

-- A_EN_Benedict_7.周庄博物馆.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_zhouzhuang_ancient_town_007.mp3', updated_at = NOW() WHERE id = 'suzhou_zhouzhuang_ancient_town_sa_07';

-- A_EN_Benedict_8.怪楼.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_zhouzhuang_ancient_town_008.mp3', updated_at = NOW() WHERE id = 'suzhou_zhouzhuang_ancient_town_sa_08';

-- A_EN_Benedict_9.贞丰桥.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_zhouzhuang_ancient_town_009.mp3', updated_at = NOW() WHERE id = 'suzhou_zhouzhuang_ancient_town_sa_09';

-- A_EN_Benedict_10.全福讲寺.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/suzhou_zhouzhuang_ancient_town_010.mp3', updated_at = NOW() WHERE id = 'suzhou_zhouzhuang_ancient_town_sa_10';

-- 上海外滩 (the_bund_shanghai)
-- A_EN_Benedict_1.Shiliupu Wharf.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/the_bund_shanghai_001.mp3', updated_at = NOW() WHERE id = 'the_bund_shanghai_sa_01';

-- A_EN_Benedict_2.Bund 18.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/the_bund_shanghai_002.mp3', updated_at = NOW() WHERE id = 'the_bund_shanghai_sa_02';

-- A_EN_Benedict_3.The Asia Building (Bund Number 1).mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/the_bund_shanghai_003.mp3', updated_at = NOW() WHERE id = 'the_bund_shanghai_sa_03';

-- A_EN_Benedict_4.The Shanghai Club (Waldorf Astoria).mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/the_bund_shanghai_004.mp3', updated_at = NOW() WHERE id = 'the_bund_shanghai_sa_04';

-- A_EN_Benedict_5.The Former HSBC Building.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/the_bund_shanghai_005.mp3', updated_at = NOW() WHERE id = 'the_bund_shanghai_sa_05';

-- A_EN_Benedict_6.The Customs House.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/the_bund_shanghai_006.mp3', updated_at = NOW() WHERE id = 'the_bund_shanghai_sa_06';

-- A_EN_Benedict_7.The Peace Hotel.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/the_bund_shanghai_007.mp3', updated_at = NOW() WHERE id = 'the_bund_shanghai_sa_07';

-- A_EN_Benedict_8.Chen Yi Square and the Statue of Chen Yi.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/the_bund_shanghai_008.mp3', updated_at = NOW() WHERE id = 'the_bund_shanghai_sa_08';

-- A_EN_Benedict_9.The Bund Bull.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/the_bund_shanghai_009.mp3', updated_at = NOW() WHERE id = 'the_bund_shanghai_sa_09';

-- A_EN_Benedict_10.Monument to the People's Heroes of Shanghai.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/the_bund_shanghai_010.mp3', updated_at = NOW() WHERE id = 'the_bund_shanghai_sa_10';

-- A_EN_Benedict_11.Waibaidu Bridge.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/the_bund_shanghai_011.mp3', updated_at = NOW() WHERE id = 'the_bund_shanghai_sa_11';

-- A_EN_Benedict_12.The Bund Source.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/the_bund_shanghai_012.mp3', updated_at = NOW() WHERE id = 'the_bund_shanghai_sa_12';

--  田子坊 (tianzifang)
-- A_EN_Benedict_1.Taikang Road Main Entrance.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/tianzifang_001.mp3', updated_at = NOW() WHERE id = 'tianzifang_sa_01';

-- A_EN_Benedict_2.Shikumen Lane Architecture.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/tianzifang_002.mp3', updated_at = NOW() WHERE id = 'tianzifang_sa_02';

-- A_EN_Benedict_3.Former Studio of Chen Yifei.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/tianzifang_003.mp3', updated_at = NOW() WHERE id = 'tianzifang_sa_03';

-- A_EN_Benedict_4.Shoubai Art Centre.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/tianzifang_004.mp3', updated_at = NOW() WHERE id = 'tianzifang_sa_04';

-- A_EN_Benedict_5.Painters' Building Rooftop.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/tianzifang_005.mp3', updated_at = NOW() WHERE id = 'tianzifang_sa_05';

-- A_EN_Benedict_6.Scent Library.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/tianzifang_006.mp3', updated_at = NOW() WHERE id = 'tianzifang_sa_06';

-- A_EN_Benedict_7.Jin Fen Shi Jia.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/tianzifang_007.mp3', updated_at = NOW() WHERE id = 'tianzifang_sa_07';

-- A_EN_Benedict_8.Lane 248.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/tianzifang_008.mp3', updated_at = NOW() WHERE id = 'tianzifang_sa_08';

-- A_EN_Benedict_9.Lane 274 Art Corridor.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/tianzifang_009.mp3', updated_at = NOW() WHERE id = 'tianzifang_sa_09';

-- 文殊院 (wenshuyuan)
-- A_EN_Benedict_1.正门（照壁）.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/wenshuyuan_001.mp3', updated_at = NOW() WHERE id = 'wenshuyuan_sa_10';

-- A_EN_Benedict_2.山门（天王殿）.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/wenshuyuan_002.mp3', updated_at = NOW() WHERE id = 'wenshuyuan_sa_06';

-- A_EN_Benedict_3.三大士殿（观音殿）.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/wenshuyuan_003.mp3', updated_at = NOW() WHERE id = 'wenshuyuan_sa_05';

-- A_EN_Benedict_4.大雄宝殿.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/wenshuyuan_004.mp3', updated_at = NOW() WHERE id = 'wenshuyuan_sa_03';

-- A_EN_Benedict_5.说法堂（药师殿）.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/wenshuyuan_005.mp3', updated_at = NOW() WHERE id = 'wenshuyuan_sa_07';

-- A_EN_Benedict_6.藏经楼（宸经楼）.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/wenshuyuan_006.mp3', updated_at = NOW() WHERE id = 'wenshuyuan_sa_01';

-- A_EN_Benedict_7.文殊阁.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/wenshuyuan_007.mp3', updated_at = NOW() WHERE id = 'wenshuyuan_sa_08';

-- A_EN_Benedict_8.千佛和平塔与碑廊.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/wenshuyuan_008.mp3', updated_at = NOW() WHERE id = 'wenshuyuan_sa_04';

-- A_EN_Benedict_9.园林与放生池.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/wenshuyuan_009.mp3', updated_at = NOW() WHERE id = 'wenshuyuan_sa_09';

-- A_EN_Benedict_10.茶园与香斋堂.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/wenshuyuan_010.mp3', updated_at = NOW() WHERE id = 'wenshuyuan_sa_02';

-- 武康路 (wukang_road)
-- A_EN_Benedict_1.武康大楼（诺曼底公寓）.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/wukang_road_001.mp3', updated_at = NOW() WHERE id = 'wukang_road_sa_01';

-- A_EN_Benedict_2.宋庆龄故居.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/wukang_road_002.mp3', updated_at = NOW() WHERE id = 'wukang_road_sa_02';

-- A_EN_Benedict_3.黄兴故居老房子艺术中心.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/wukang_road_003.mp3', updated_at = NOW() WHERE id = 'wukang_road_sa_03';

-- A_EN_Benedict_4.周璇旧居.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/wukang_road_004.mp3', updated_at = NOW() WHERE id = 'wukang_road_sa_04';

-- A_EN_Benedict_5.意大利总领事馆旧址.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/wukang_road_005.mp3', updated_at = NOW() WHERE id = 'wukang_road_sa_05';

-- A_EN_Benedict_6.武康庭.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/wukang_road_006.mp3', updated_at = NOW() WHERE id = 'wukang_road_sa_06';

-- A_EN_Benedict_7.罗密欧阳台（德利那齐宅）.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/wukang_road_007.mp3', updated_at = NOW() WHERE id = 'wukang_road_sa_07';

-- A_EN_Benedict_8.巴金故居.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/wukang_road_008.mp3', updated_at = NOW() WHERE id = 'wukang_road_sa_08';

-- A_EN_Benedict_9.密丹里.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/wukang_road_009.mp3', updated_at = NOW() WHERE id = 'wukang_road_sa_09';

-- 徐家汇源景区 (xujiahui_source_scenic_area)
-- A_EN_Benedict_1.Xujiahui Academy.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/xujiahui_source_scenic_area_001.mp3', updated_at = NOW() WHERE id = 'xujiahui_source_scenic_area_sa_01';

-- A_EN_Benedict_2.St. Ignatius Cathedral.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/xujiahui_source_scenic_area_002.mp3', updated_at = NOW() WHERE id = 'xujiahui_source_scenic_area_sa_02';

-- A_EN_Benedict_3.Shanghai Meteorological Museum (Former Xujiahui Observatory).mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/xujiahui_source_scenic_area_003.mp3', updated_at = NOW() WHERE id = 'xujiahui_source_scenic_area_sa_03';

-- A_EN_Benedict_4.Former Xuhui Public School (Chongsi Building).mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/xujiahui_source_scenic_area_004.mp3', updated_at = NOW() WHERE id = 'xujiahui_source_scenic_area_sa_04';

-- A_EN_Benedict_5.EMI Building (Recording Site of March of the Volunteers).mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/xujiahui_source_scenic_area_005.mp3', updated_at = NOW() WHERE id = 'xujiahui_source_scenic_area_sa_05';

-- A_EN_Benedict_6.Shanghai Film Museum.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/xujiahui_source_scenic_area_006.mp3', updated_at = NOW() WHERE id = 'xujiahui_source_scenic_area_sa_06';

-- A_EN_Benedict_7.Guangqi Park and Xu Guangqi Memorial Hall.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/xujiahui_source_scenic_area_007.mp3', updated_at = NOW() WHERE id = 'xujiahui_source_scenic_area_sa_07';

-- A_EN_Benedict_8.Tushanwan Museum.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/xujiahui_source_scenic_area_008.mp3', updated_at = NOW() WHERE id = 'xujiahui_source_scenic_area_sa_08';

-- A_EN_Benedict_9.Former Notre Dame Site (Shanghai Old Station).mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/xujiahui_source_scenic_area_009.mp3', updated_at = NOW() WHERE id = 'xujiahui_source_scenic_area_sa_09';

-- 豫园 (yu_garden)
-- A_EN_Benedict_1.San Sui Tang — Hall of Three Abundant Harvests.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/yu_garden_001.mp3', updated_at = NOW() WHERE id = 'yu_garden_sa_01';

-- A_EN_Benedict_2.Yang Shan Tang and Juan Yu Lou — Hall of Viewing the Mountain and Tower of Rolling Clouds.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/yu_garden_002.mp3', updated_at = NOW() WHERE id = 'yu_garden_sa_02';

-- A_EN_Benedict_3.Da Jia Shan — Grand Rockery.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/yu_garden_003.mp3', updated_at = NOW() WHERE id = 'yu_garden_sa_03';

-- A_EN_Benedict_4.Cui Xiu Tang — Hall of Gathering Elegance.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/yu_garden_004.mp3', updated_at = NOW() WHERE id = 'yu_garden_sa_04';

-- A_EN_Benedict_5.Wan Hua Lou — Tower of Ten Thousand Flowers.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/yu_garden_005.mp3', updated_at = NOW() WHERE id = 'yu_garden_sa_05';

-- A_EN_Benedict_6.Dian Chun Tang — Hall of Herald Spring.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/yu_garden_006.mp3', updated_at = NOW() WHERE id = 'yu_garden_sa_06';

-- A_EN_Benedict_7.Yu Ling Long — Exquisite Jade Stone.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/yu_garden_007.mp3', updated_at = NOW() WHERE id = 'yu_garden_sa_07';

-- A_EN_Benedict_8.Yu Hua Tang — Hall of Jade Splendor.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/yu_garden_008.mp3', updated_at = NOW() WHERE id = 'yu_garden_sa_08';

-- A_EN_Benedict_9.Hui Jing Lou — Tower of Assembling Views.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/yu_garden_009.mp3', updated_at = NOW() WHERE id = 'yu_garden_sa_09';

-- A_EN_Benedict_10.De Yue Lou — Tower of Reaching the Moon.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/yu_garden_010.mp3', updated_at = NOW() WHERE id = 'yu_garden_sa_10';

-- A_EN_Benedict_11.Nei Yuan — Inner Garden.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/yu_garden_011.mp3', updated_at = NOW() WHERE id = 'yu_garden_sa_11';

-- 朱家角古镇 (zhujiajiao_ancient_town)
-- A_EN_Benedict_1.解说词-放生桥.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/zhujiajiao_ancient_town_001.mp3', updated_at = NOW() WHERE id = 'zhujiajiao_ancient_town_sa_01';

-- A_EN_Benedict_2.解说词-北大街.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/zhujiajiao_ancient_town_002.mp3', updated_at = NOW() WHERE id = 'zhujiajiao_ancient_town_sa_02';

-- A_EN_Benedict_3.解说词-涵大隆酱园.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/zhujiajiao_ancient_town_003.mp3', updated_at = NOW() WHERE id = 'zhujiajiao_ancient_town_sa_03';

-- A_EN_Benedict_4.解说词-泰安桥.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/zhujiajiao_ancient_town_004.mp3', updated_at = NOW() WHERE id = 'zhujiajiao_ancient_town_sa_04';

-- A_EN_Benedict_5.解说词-圆津禅院.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/zhujiajiao_ancient_town_005.mp3', updated_at = NOW() WHERE id = 'zhujiajiao_ancient_town_sa_05';

-- A_EN_Benedict_6.解说词-廊桥.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/zhujiajiao_ancient_town_006.mp3', updated_at = NOW() WHERE id = 'zhujiajiao_ancient_town_sa_06';

-- A_EN_Benedict_7.解说词-城隍庙.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/zhujiajiao_ancient_town_007.mp3', updated_at = NOW() WHERE id = 'zhujiajiao_ancient_town_sa_07';

-- A_EN_Benedict_8.解说词-课植园.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/zhujiajiao_ancient_town_008.mp3', updated_at = NOW() WHERE id = 'zhujiajiao_ancient_town_sa_08';

-- A_EN_Benedict_9.解说词-大清邮局.mp3
UPDATE sub_areas SET audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/zhujiajiao_ancient_town_009.mp3', updated_at = NOW() WHERE id = 'zhujiajiao_ancient_town_sa_09';

COMMIT;
