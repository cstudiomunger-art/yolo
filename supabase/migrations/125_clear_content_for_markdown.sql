-- Clear legacy Quill/HTML CMS content before Markdown re-entry.
-- Payment *_md_* columns are preserved (already Markdown).
-- Run AFTER deploying admin-vue + iOS + site Markdown renderers.

BEGIN;

UPDATE app_settings SET
  about_body = NULL,
  privacy_policy_body = NULL,
  terms_of_service_body = NULL,
  gdpr_compliance_body = NULL,
  ai_content_disclosure_body = NULL,
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

UPDATE home_tips SET body = NULL, updated_at = NOW() WHERE body IS NOT NULL;

UPDATE audio_guides SET
  description = NULL,
  quote = NULL,
  updated_at = NOW()
WHERE description IS NOT NULL OR quote IS NOT NULL;

UPDATE shopping_items SET note_en = NULL, updated_at = NOW() WHERE note_en IS NOT NULL;

UPDATE reading_list SET synopsis_en = NULL, updated_at = NOW() WHERE synopsis_en IS NOT NULL;

UPDATE hotels SET
  english_staff_note = NULL,
  language_tip = NULL,
  location_note = NULL,
  updated_at = NOW()
WHERE english_staff_note IS NOT NULL OR language_tip IS NOT NULL OR location_note IS NOT NULL;

UPDATE culture_tips SET
  preview = NULL,
  body = NULL,
  do_text = NULL,
  dont_text = NULL,
  updated_at = NOW()
WHERE preview IS NOT NULL OR body IS NOT NULL OR do_text IS NOT NULL OR dont_text IS NOT NULL;

UPDATE emergency_config SET embassy_note = NULL, updated_at = NOW() WHERE embassy_note IS NOT NULL;

UPDATE payment_advice_rules SET
  body_zh = NULL,
  body_en = NULL,
  updated_at = NOW()
WHERE body_zh IS NOT NULL OR body_en IS NOT NULL;

UPDATE transport_tips SET
  body_zh = NULL,
  body_en = NULL,
  updated_at = NOW()
WHERE body_zh IS NOT NULL OR body_en IS NOT NULL;

UPDATE internet_access_guides SET
  body_zh = NULL,
  body_en = NULL,
  updated_at = NOW()
WHERE body_zh IS NOT NULL OR body_en IS NOT NULL;

UPDATE emergency_help_items SET
  body_en = NULL,
  body_zh = NULL,
  updated_at = NOW()
WHERE body_en IS NOT NULL OR body_zh IS NOT NULL;

UPDATE emergency_medical_items SET
  body_en = NULL,
  body_zh = NULL,
  updated_at = NOW()
WHERE body_en IS NOT NULL OR body_zh IS NOT NULL;

COMMIT;
