-- Migrate media (cover images + audio) from old attraction `chengdu_wuhouci`
-- to the new `chengdu_wuhou_shrine` sub_areas, then delete the old attraction.
--
-- New records reference the SAME storage URLs as the old records
-- (files are not moved or renamed). Fields the source lacked are left untouched:
--   - sa_04 刘备殿 / sa_06 诸葛亮殿: source had no audio  -> audio_url unchanged
--   - sa_09 惠陵:                    source had no image  -> cover_image_path unchanged
--
-- Mapping (new <- old, by content / Chinese name):
--   sa_01 南门与照壁          <- area_nanmenyuzhaobi
--   sa_02 大门（汉昭烈庙）     <- area_date
--   sa_03 二门与唐碑（三绝碑）  <- area_stele_of_three_perfections
--   sa_04 刘备殿              <- area_liu_bei_hall_main_hall_of_the_han_zhaolie_temple
--   sa_05 过厅（出师表石刻）    <- area_antechamber
--   sa_06 诸葛亮殿（静远堂）    <- area_zhuge_liang_hall_jingyuan_hall
--   sa_07 三义庙              <- area_sanyi_temple
--   sa_08 桂荷楼/园林区        <- area_guihe_lou_qin_pavilion_gardens_area
--   sa_09 惠陵（刘备墓）        <- area_huilin_mausoleum
--   sa_10 锦里与水榭          <- area_jinli_waterside_pavilion

BEGIN;

-- sa_01 南门与照壁 (image + audio)
UPDATE sub_areas SET
  cover_image_path = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/attractions/area_nanmenyuzhaobi.jpg',
  audio_url        = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/area_nanmenyuzhaobi.mp3',
  updated_at = NOW()
WHERE id = 'chengdu_wuhou_sa_01';

-- sa_02 大门（汉昭烈庙）(image + audio)
UPDATE sub_areas SET
  cover_image_path = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/attractions/area_date.jpg',
  audio_url        = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/area_date.mp3',
  updated_at = NOW()
WHERE id = 'chengdu_wuhou_sa_02';

-- sa_03 二门与唐碑（三绝碑）(image + audio)
UPDATE sub_areas SET
  cover_image_path = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/attractions/area_stele_of_three_perfections.jpg',
  audio_url        = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/area_stele_of_three_perfections.mp3',
  updated_at = NOW()
WHERE id = 'chengdu_wuhou_sa_03';

-- sa_04 刘备殿 (image only; source had no audio)
UPDATE sub_areas SET
  cover_image_path = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/attractions/area_liu_bei_hall_main_hall_of_the_han_zhaolie_temple.jpg',
  updated_at = NOW()
WHERE id = 'chengdu_wuhou_sa_04';

-- sa_05 过厅（出师表石刻）(image + audio)
UPDATE sub_areas SET
  cover_image_path = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/attractions/area_antechamber.jpg',
  audio_url        = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/area_antechamber.mp3',
  updated_at = NOW()
WHERE id = 'chengdu_wuhou_sa_05';

-- sa_06 诸葛亮殿（静远堂）(image only; source had no audio)
UPDATE sub_areas SET
  cover_image_path = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/attractions/area_zhuge_liang_hall_jingyuan_hall.jpg',
  updated_at = NOW()
WHERE id = 'chengdu_wuhou_sa_06';

-- sa_07 三义庙 (image + audio)
UPDATE sub_areas SET
  cover_image_path = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/attractions/area_sanyi_temple.jpg',
  audio_url        = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/area_sanyi_temple.mp3',
  updated_at = NOW()
WHERE id = 'chengdu_wuhou_sa_07';

-- sa_08 桂荷楼、琴亭与园林区 (image + audio)
UPDATE sub_areas SET
  cover_image_path = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/attractions/area_guihe_lou_qin_pavilion_gardens_area.jpg',
  audio_url        = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/area_guihe_lou_qin_pavilion_gardens_area.mp3',
  updated_at = NOW()
WHERE id = 'chengdu_wuhou_sa_08';

-- sa_09 惠陵（刘备墓）(audio only; source had no image)
UPDATE sub_areas SET
  audio_url = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/area_huilin_mausoleum.mp3',
  updated_at = NOW()
WHERE id = 'chengdu_wuhou_sa_09';

-- sa_10 锦里与水榭 (image + audio)
UPDATE sub_areas SET
  cover_image_path = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/cover-images/attractions/area_jinli_waterside_pavilion.jpg',
  audio_url        = 'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/sub-areas/area_jinli_waterside_pavilion.mp3',
  updated_at = NOW()
WHERE id = 'chengdu_wuhou_sa_10';

-- Delete the old attraction and its sub_areas.
-- (If sub_areas.attraction_id has ON DELETE CASCADE the first statement is redundant but harmless.)
DELETE FROM sub_areas   WHERE attraction_id = 'chengdu_wuhouci';
DELETE FROM attractions WHERE id            = 'chengdu_wuhouci';

COMMIT;
