-- CMS-editable VolcEngine / AI invocation settings (secrets stay in Edge Function env)

ALTER TABLE app_settings ADD COLUMN IF NOT EXISTS ai_model_id TEXT;
ALTER TABLE app_settings ADD COLUMN IF NOT EXISTS ai_chat_api_url TEXT NOT NULL DEFAULT 'https://ark.cn-beijing.volces.com/api/v3/chat/completions';
ALTER TABLE app_settings ADD COLUMN IF NOT EXISTS ai_chat_max_tokens INT NOT NULL DEFAULT 450;
ALTER TABLE app_settings ADD COLUMN IF NOT EXISTS ai_itinerary_max_tokens INT NOT NULL DEFAULT 1200;
ALTER TABLE app_settings ADD COLUMN IF NOT EXISTS ai_temperature REAL NOT NULL DEFAULT 0.7;
ALTER TABLE app_settings ADD COLUMN IF NOT EXISTS ai_timeout_ms INT NOT NULL DEFAULT 20000;
ALTER TABLE app_settings ADD COLUMN IF NOT EXISTS ai_system_prompt_assistant TEXT;
ALTER TABLE app_settings ADD COLUMN IF NOT EXISTS ai_system_prompt_itinerary TEXT;

COMMENT ON COLUMN app_settings.ai_model_id IS 'VolcEngine Ark endpoint/model id; overrides VOLCENGINE_SUGGESTION_MODEL when set';
COMMENT ON COLUMN app_settings.ai_system_prompt_assistant IS 'Optional system prompt override for assistant_chat';
COMMENT ON COLUMN app_settings.ai_system_prompt_itinerary IS 'Optional system prompt override for itinerary JSON generation';
