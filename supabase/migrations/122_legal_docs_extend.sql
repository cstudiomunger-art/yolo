-- Legal compliance documents (GDPR framework + AI disclosure) on app_settings CMS row

ALTER TABLE app_settings
  ADD COLUMN IF NOT EXISTS gdpr_compliance_body TEXT NOT NULL DEFAULT '',
  ADD COLUMN IF NOT EXISTS ai_content_disclosure_body TEXT NOT NULL DEFAULT '';

UPDATE app_settings SET
  gdpr_compliance_body = COALESCE(gdpr_compliance_body, ''),
  ai_content_disclosure_body = COALESCE(ai_content_disclosure_body, '')
WHERE id = 'global';
