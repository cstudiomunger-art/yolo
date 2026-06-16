-- Commercial support chat: unread tracking, typing indicators, device push tokens.

-- Per-side read + typing markers on the conversation (participants can update via
-- existing "Participants update conversation" policy).
ALTER TABLE support_conversations ADD COLUMN IF NOT EXISTS user_last_read_at  TIMESTAMPTZ;
ALTER TABLE support_conversations ADD COLUMN IF NOT EXISTS agent_last_read_at TIMESTAMPTZ;
ALTER TABLE support_conversations ADD COLUMN IF NOT EXISTS user_typing_at     TIMESTAMPTZ;
ALTER TABLE support_conversations ADD COLUMN IF NOT EXISTS agent_typing_at    TIMESTAMPTZ;

-- APNs device tokens for offline push (agent reply → push to the user's devices).
CREATE TABLE IF NOT EXISTS device_tokens (
  user_id    UUID NOT NULL REFERENCES auth.users (id) ON DELETE CASCADE,
  token      TEXT NOT NULL,
  platform   TEXT NOT NULL DEFAULT 'ios',
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  PRIMARY KEY (user_id, token)
);

ALTER TABLE device_tokens ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users manage own device tokens" ON device_tokens;
CREATE POLICY "Users manage own device tokens" ON device_tokens
  FOR ALL TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- The push Edge Function (service role) reads tokens to send APNs; agents may also
-- read tokens of users they're conversing with (for completeness) — service role
-- bypasses RLS, so no extra agent policy is required here.
