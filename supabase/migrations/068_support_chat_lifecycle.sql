-- Support chat lifecycle: per-side soft delete. "删除" hides the conversation from
-- that side's list (user_deleted_at / agent_deleted_at) while the row + messages are
-- retained for the other side and for admin (audit). Closing a conversation uses the
-- existing status column + UPDATE policy. No new RLS needed — soft delete is an UPDATE,
-- and the existing "Participants update conversation" policy already permits it.

ALTER TABLE support_conversations ADD COLUMN IF NOT EXISTS user_deleted_at  TIMESTAMPTZ;
ALTER TABLE support_conversations ADD COLUMN IF NOT EXISTS agent_deleted_at TIMESTAMPTZ;

CREATE INDEX IF NOT EXISTS support_conversations_user_live_idx
  ON support_conversations (user_id, updated_at DESC)
  WHERE user_deleted_at IS NULL;
