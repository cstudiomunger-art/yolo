-- Enable remote IAP (paywall) by default for production.
-- When use_remote_iap = false, ALL users see full content (demo/dev mode).
-- When use_remote_iap = true, free users see trial audio (3 min) and text preview.
UPDATE app_settings
SET use_remote_iap = TRUE
WHERE id = 'global';
