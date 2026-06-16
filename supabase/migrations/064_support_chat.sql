-- Genius Bar live support: agents, conversations, messages (text + image + translation).
-- Realtime drives both the App and the web/support agent console. Team-internal
-- agents only (rows in support_agents); travellers are regular auth users.

-- Translation settings for the chat-translate Edge Function (CMS-configurable,
-- like the ai_* columns). Empty/NULL → falls back to the VolcEngine LLM defaults.
ALTER TABLE app_settings ADD COLUMN IF NOT EXISTS translate_model          TEXT;
ALTER TABLE app_settings ADD COLUMN IF NOT EXISTS translate_api_url        TEXT;
ALTER TABLE app_settings ADD COLUMN IF NOT EXISTS translate_api_key        TEXT;
ALTER TABLE app_settings ADD COLUMN IF NOT EXISTS translate_max_tokens     INT;
ALTER TABLE app_settings ADD COLUMN IF NOT EXISTS translate_timeout_ms     INT;
ALTER TABLE app_settings ADD COLUMN IF NOT EXISTS translate_target_default TEXT;

CREATE TABLE IF NOT EXISTS support_agents (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID UNIQUE REFERENCES auth.users (id) ON DELETE CASCADE,
  name        TEXT NOT NULL DEFAULT '',
  role        TEXT NOT NULL DEFAULT '',                 -- e.g. '北京 · 签证'
  avatar_seed TEXT NOT NULL DEFAULT '',
  languages   TEXT[] NOT NULL DEFAULT '{}',
  status      TEXT NOT NULL DEFAULT 'offline',          -- 'online'|'busy'|'offline'
  social_url  TEXT NOT NULL DEFAULT '',
  display_order INT NOT NULL DEFAULT 0,
  is_active   BOOLEAN NOT NULL DEFAULT TRUE,
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS support_conversations (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id      UUID NOT NULL REFERENCES auth.users (id) ON DELETE CASCADE,
  agent_id     UUID REFERENCES support_agents (id) ON DELETE SET NULL,
  context_json JSONB,                                   -- 签证/支付跳入上下文
  priority     TEXT NOT NULL DEFAULT 'normal',          -- 'normal'|'emergency'(SOS)
  status       TEXT NOT NULL DEFAULT 'open',            -- 'open'|'closed'
  created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS support_conversations_user_idx  ON support_conversations (user_id, updated_at DESC);
CREATE INDEX IF NOT EXISTS support_conversations_agent_idx ON support_conversations (agent_id, updated_at DESC);

CREATE TABLE IF NOT EXISTS support_messages (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_id UUID NOT NULL REFERENCES support_conversations (id) ON DELETE CASCADE,
  sender_type     TEXT NOT NULL,                        -- 'user'|'agent'
  sender_id       UUID,
  body_original   TEXT,
  body_translated TEXT,
  image_url       TEXT,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS support_messages_conv_idx ON support_messages (conversation_id, created_at);

-- ── Helpers ──
CREATE OR REPLACE FUNCTION public.is_support_agent()
RETURNS BOOLEAN LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT EXISTS (SELECT 1 FROM support_agents WHERE user_id = auth.uid());
$$;
GRANT EXECUTE ON FUNCTION public.is_support_agent() TO authenticated, anon;

CREATE OR REPLACE FUNCTION public.can_access_conversation(conv UUID)
RETURNS BOOLEAN LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT EXISTS (
    SELECT 1 FROM support_conversations c
    WHERE c.id = conv AND (
      c.user_id = auth.uid()
      OR EXISTS (SELECT 1 FROM support_agents a WHERE a.id = c.agent_id AND a.user_id = auth.uid())
      OR (c.priority = 'emergency' AND c.status = 'open' AND public.is_support_agent())
    )
  );
$$;
GRANT EXECUTE ON FUNCTION public.can_access_conversation(UUID) TO authenticated;

-- ── RLS ──
ALTER TABLE support_agents ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Public read support_agents" ON support_agents;
CREATE POLICY "Public read support_agents" ON support_agents
  FOR SELECT USING (is_active = TRUE OR public.is_admin());
DROP POLICY IF EXISTS "Agent updates own row" ON support_agents;
CREATE POLICY "Agent updates own row" ON support_agents
  FOR UPDATE TO authenticated
  USING (user_id = auth.uid() OR public.is_admin())
  WITH CHECK (user_id = auth.uid() OR public.is_admin());
DROP POLICY IF EXISTS "Admin writes support_agents" ON support_agents;
CREATE POLICY "Admin writes support_agents" ON support_agents
  FOR INSERT TO authenticated WITH CHECK (public.is_admin());
DROP POLICY IF EXISTS "Admin deletes support_agents" ON support_agents;
CREATE POLICY "Admin deletes support_agents" ON support_agents
  FOR DELETE TO authenticated USING (public.is_admin());

ALTER TABLE support_conversations ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Read own/assigned conversations" ON support_conversations;
CREATE POLICY "Read own/assigned conversations" ON support_conversations
  FOR SELECT TO authenticated
  USING (
    user_id = auth.uid()
    OR EXISTS (SELECT 1 FROM support_agents a WHERE a.id = support_conversations.agent_id AND a.user_id = auth.uid())
    OR (priority = 'emergency' AND status = 'open' AND public.is_support_agent())
    OR public.is_admin()
  );
DROP POLICY IF EXISTS "User creates own conversation" ON support_conversations;
CREATE POLICY "User creates own conversation" ON support_conversations
  FOR INSERT TO authenticated WITH CHECK (user_id = auth.uid());
DROP POLICY IF EXISTS "Participants update conversation" ON support_conversations;
CREATE POLICY "Participants update conversation" ON support_conversations
  FOR UPDATE TO authenticated
  USING (user_id = auth.uid() OR public.is_support_agent() OR public.is_admin())
  WITH CHECK (user_id = auth.uid() OR public.is_support_agent() OR public.is_admin());

ALTER TABLE support_messages ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Participants read messages" ON support_messages;
CREATE POLICY "Participants read messages" ON support_messages
  FOR SELECT TO authenticated
  USING (public.can_access_conversation(conversation_id) OR public.is_admin());
DROP POLICY IF EXISTS "Participants send messages" ON support_messages;
CREATE POLICY "Participants send messages" ON support_messages
  FOR INSERT TO authenticated
  WITH CHECK (public.can_access_conversation(conversation_id));

-- ── Storage bucket for chat images (private, authenticated participants) ──
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'chat-images', 'chat-images', FALSE, 10485760,
  ARRAY['image/jpeg', 'image/png', 'image/webp', 'image/heic']::text[]
)
ON CONFLICT (id) DO UPDATE SET
  file_size_limit = EXCLUDED.file_size_limit,
  allowed_mime_types = EXCLUDED.allowed_mime_types;

DROP POLICY IF EXISTS "Auth read chat images" ON storage.objects;
CREATE POLICY "Auth read chat images" ON storage.objects
  FOR SELECT TO authenticated USING (bucket_id = 'chat-images');
DROP POLICY IF EXISTS "Auth upload chat images" ON storage.objects;
CREATE POLICY "Auth upload chat images" ON storage.objects
  FOR INSERT TO authenticated WITH CHECK (bucket_id = 'chat-images');

-- Realtime: expose message/agent/conversation changes to subscribers (RLS still applies).
DO $realtime$
DECLARE
  t TEXT;
BEGIN
  FOREACH t IN ARRAY ARRAY['support_messages', 'support_conversations', 'support_agents']
  LOOP
    BEGIN
      EXECUTE format('ALTER PUBLICATION supabase_realtime ADD TABLE %I', t);
    EXCEPTION WHEN duplicate_object THEN
      NULL;  -- already in publication
    END;
  END LOOP;
END
$realtime$;
