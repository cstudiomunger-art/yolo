-- Turn on CMS remote content for all clients (idempotent).
UPDATE app_settings
SET use_remote_content = true,
    updated_at = NOW()
WHERE id = 'global';
