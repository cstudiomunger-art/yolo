-- Per-scenario AI prompts (CMS-editable)

ALTER TABLE assistant_scenarios ADD COLUMN IF NOT EXISTS user_message_template TEXT;
ALTER TABLE assistant_scenarios ADD COLUMN IF NOT EXISTS ai_system_prompt TEXT;
ALTER TABLE assistant_scenarios ADD COLUMN IF NOT EXISTS response_mode TEXT NOT NULL DEFAULT 'ai'
  CHECK (response_mode IN ('ai', 'offline'));

UPDATE assistant_scenarios SET response_mode = 'offline' WHERE id = 'emergency';

UPDATE assistant_scenarios SET
  user_message_template = COALESCE(user_message_template, 'Help me order food at a restaurant'),
  ai_system_prompt = COALESCE(ai_system_prompt, 'Provide practical restaurant ordering help: common Chinese phrases with pinyin and English, how to point at menu items, dietary restrictions.')
WHERE id = 'ordering_food' OR id LIKE '%food%';

UPDATE assistant_scenarios SET
  user_message_template = COALESCE(user_message_template, 'How do I use the metro?'),
  ai_system_prompt = COALESCE(ai_system_prompt, 'Explain how to buy tickets and ride the metro in China step by step.')
WHERE id = 'metro' OR id LIKE '%metro%';

UPDATE assistant_scenarios SET
  user_message_template = COALESCE(user_message_template, 'How do I get a Didi?'),
  ai_system_prompt = COALESCE(ai_system_prompt, 'Explain Didi ride-hailing: download, register, set destination, verify driver.')
WHERE id = 'didi' OR id LIKE '%didi%';

UPDATE assistant_scenarios SET
  user_message_template = COALESCE(user_message_template, 'My payment isn''t working, what do I do?'),
  ai_system_prompt = COALESCE(ai_system_prompt, 'Troubleshoot Alipay/WeChat Pay for foreign visitors and suggest backup payment options.')
WHERE id = 'payment' OR id LIKE '%payment%';

UPDATE assistant_scenarios SET
  user_message_template = COALESCE(user_message_template, 'I have an emergency'),
  response_mode = 'offline'
WHERE id = 'emergency';

UPDATE assistant_scenarios SET
  user_message_template = COALESCE(user_message_template, 'What are key cultural rules to know?'),
  ai_system_prompt = COALESCE(ai_system_prompt, 'Summarize essential cultural etiquette for visitors to China.')
WHERE id = 'culture' OR id LIKE '%culture%' OR id LIKE '%etiquette%';

UPDATE assistant_scenarios SET
  user_message_template = COALESCE(user_message_template, 'How do I book tickets for attractions?'),
  ai_system_prompt = COALESCE(ai_system_prompt, 'Explain how to book major attraction tickets in advance (Forbidden City, Great Wall, etc.).')
WHERE id = 'tickets' OR id LIKE '%ticket%' OR id LIKE '%attraction%';

UPDATE assistant_scenarios SET
  user_message_template = COALESCE(user_message_template, 'I lost my passport, what should I do?'),
  ai_system_prompt = COALESCE(ai_system_prompt, 'Give step-by-step guidance for lost passport: police report, embassy, temporary travel document.')
WHERE id = 'passport' OR id LIKE '%passport%';
