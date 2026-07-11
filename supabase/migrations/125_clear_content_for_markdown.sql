-- Clear legacy Quill/HTML CMS content before Markdown re-entry.
-- Payment *_md_* columns are preserved (already Markdown).
-- Run AFTER deploying admin-vue + iOS + site Markdown renderers.
--
-- NOTE: Columns with NOT NULL use '' (empty Markdown), not NULL.
-- Nullable columns are set to NULL.
-- NOT NULL columns cleared to '': app_settings legal/about bodies, home_tips.body,
-- reading_list.synopsis_en, culture_tips.preview/body, emergency_config.embassy_note,
-- payment_advice_rules.body_zh/body_en, transport_tips, internet_access_guides,
-- emergency_help_items, emergency_medical_items.

BEGIN;

-- app_settings: all legal/about bodies are NOT NULL DEFAULT ''
UPDATE app_settings SET
  about_body = '',
  privacy_policy_body = '',
  terms_of_service_body = '',
  gdpr_compliance_body = '',
  ai_content_disclosure_body = '',
  updated_at = NOW()
WHERE id = 'global';

UPDATE cities SET description = NULL, updated_at = NOW() WHERE description IS NOT NULL;

UPDATE city_guides SET
  body = NULL,
  audio_quote = NULL,
  audio_transcript = NULL,
  updated_at = NOW()
WHERE body IS NOT NULL OR audio_quote IS NOT NULL OR audio_transcript IS NOT NULL;

UPDATE attractions SET
  summary = NULL,
  short_description = NULL,
  introduction = NULL,
  updated_at = NOW()
WHERE summary IS NOT NULL OR short_description IS NOT NULL OR introduction IS NOT NULL;

UPDATE sub_areas SET
  body = NULL,
  content_blocks = '[]'::jsonb,
  updated_at = NOW()
WHERE body IS NOT NULL OR content_blocks IS DISTINCT FROM '[]'::jsonb;

UPDATE checklist_items SET
  why_important = NULL,
  how_to_complete = NULL,
  cultural_tip = NULL,
  updated_at = NOW()
WHERE why_important IS NOT NULL OR how_to_complete IS NOT NULL OR cultural_tip IS NOT NULL;

-- home_tips.body NOT NULL
UPDATE home_tips SET body = '', updated_at = NOW() WHERE body IS NOT NULL AND body <> '';

UPDATE audio_guides SET
  description = NULL,
  quote = NULL,
  updated_at = NOW()
WHERE description IS NOT NULL OR quote IS NOT NULL;

UPDATE shopping_items SET note_en = NULL, updated_at = NOW() WHERE note_en IS NOT NULL;

-- reading_list.synopsis_en NOT NULL
UPDATE reading_list SET synopsis_en = '', updated_at = NOW() WHERE synopsis_en IS NOT NULL AND synopsis_en <> '';

UPDATE hotels SET
  english_staff_note = NULL,
  language_tip = NULL,
  location_note = NULL,
  updated_at = NOW()
WHERE english_staff_note IS NOT NULL OR language_tip IS NOT NULL OR location_note IS NOT NULL;

-- culture_tips.preview + body NOT NULL; do_text/dont_text nullable
UPDATE culture_tips SET
  preview = '',
  body = '',
  do_text = NULL,
  dont_text = NULL,
  updated_at = NOW()
WHERE preview IS NOT NULL AND preview <> ''
   OR body IS NOT NULL AND body <> ''
   OR do_text IS NOT NULL
   OR dont_text IS NOT NULL;

-- emergency_config.embassy_note NOT NULL
UPDATE emergency_config SET embassy_note = '', updated_at = NOW()
WHERE embassy_note IS NOT NULL AND embassy_note <> '';

-- payment_advice_rules.body_* NOT NULL DEFAULT ''
UPDATE payment_advice_rules SET
  body_zh = '',
  body_en = '',
  updated_at = NOW();

-- transport_tips.body_* NOT NULL DEFAULT ''
UPDATE transport_tips SET
  body_zh = '',
  body_en = '',
  updated_at = NOW()
WHERE body_zh IS NOT NULL AND body_zh <> ''
   OR body_en IS NOT NULL AND body_en <> '';

-- internet_access_guides.body_* NOT NULL DEFAULT ''
UPDATE internet_access_guides SET
  body_zh = '',
  body_en = '',
  updated_at = NOW()
WHERE body_zh IS NOT NULL AND body_zh <> ''
   OR body_en IS NOT NULL AND body_en <> '';

-- emergency_help_items / emergency_medical_items body_* NOT NULL DEFAULT ''
UPDATE emergency_help_items SET
  body_en = '',
  body_zh = '',
  updated_at = NOW()
WHERE body_en IS NOT NULL AND body_en <> ''
   OR body_zh IS NOT NULL AND body_zh <> '';

UPDATE emergency_medical_items SET
  body_en = '',
  body_zh = '',
  updated_at = NOW()
WHERE body_en IS NOT NULL AND body_en <> ''
   OR body_zh IS NOT NULL AND body_zh <> '';

COMMIT;
