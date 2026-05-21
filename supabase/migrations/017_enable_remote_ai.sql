-- Turn on remote AI when remote content is already enabled (one-time fix for existing deployments)
UPDATE app_settings
SET use_remote_ai = TRUE
WHERE id = 'global'
  AND use_remote_content = TRUE
  AND use_remote_ai = FALSE;
