-- Remove unimplemented access flags: offline_download (download just follows audio
-- access) and ai_advanced (no AI gating exists). access_flags now has 3 keys.

ALTER TABLE membership_plans
  ALTER COLUMN access_flags SET DEFAULT '{
    "audio_guides": false,
    "text_content": false,
    "visitor_tips": false
  }'::jsonb;

-- Strip the removed keys from existing rows (JSONB minus operator).
UPDATE membership_plans
SET access_flags = (access_flags - 'offline_download') - 'ai_advanced';
