-- Use Cloudflare Worker default domain for share links
UPDATE app_settings
SET share_web_base_url = 'https://yolo.cstudiomunger.workers.dev'
WHERE id = 'global';
