-- Default remote AI on for new rows and existing global settings
ALTER TABLE app_settings ALTER COLUMN use_remote_ai SET DEFAULT TRUE;

UPDATE app_settings
SET use_remote_ai = TRUE
WHERE id = 'global'
  AND use_remote_ai = FALSE;
