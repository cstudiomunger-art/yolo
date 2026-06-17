-- Commercial hardening for the support chat (security + concurrency + inbox ordering).
-- Safe to re-run (idempotent). Apply via `supabase db push` or the SQL editor.

-- ── 1. Lock down the private chat-images bucket to conversation participants ──
-- Previously ANY authenticated user could read/write EVERY object in the bucket
-- (bucket_id check only), leaking other travellers' private images (passports,
-- payment screenshots). Both the app and the agent console upload to
-- `<conversation_id>/<uuid>.jpg`, so scope access by the first path segment.
DROP POLICY IF EXISTS "Auth read chat images" ON storage.objects;
DROP POLICY IF EXISTS "Auth upload chat images" ON storage.objects;
DROP POLICY IF EXISTS "Participants read chat images" ON storage.objects;
CREATE POLICY "Participants read chat images" ON storage.objects
  FOR SELECT TO authenticated
  USING (
    bucket_id = 'chat-images'
    AND (
      public.is_admin()
      OR public.can_access_conversation(((storage.foldername(name))[1])::uuid)
    )
  );
DROP POLICY IF EXISTS "Participants upload chat images" ON storage.objects;
CREATE POLICY "Participants upload chat images" ON storage.objects
  FOR INSERT TO authenticated
  WITH CHECK (
    bucket_id = 'chat-images'
    AND public.can_access_conversation(((storage.foldername(name))[1])::uuid)
  );

-- ── 2. Validate message sender (no impersonation) ──
-- The old INSERT policy only checked conversation access, so a traveller could
-- post a message with sender_type='agent' / an arbitrary sender_id and fake an
-- "official" reply. Pin sender_id to the caller and match sender_type to role.
-- (App user and agent console both insert sender_id = their own auth.uid().)
DROP POLICY IF EXISTS "Participants send messages" ON support_messages;
CREATE POLICY "Participants send messages" ON support_messages
  FOR INSERT TO authenticated
  WITH CHECK (
    public.can_access_conversation(conversation_id)
    AND sender_id = auth.uid()
    AND (
      (sender_type = 'user'
        AND EXISTS (SELECT 1 FROM support_conversations c
                    WHERE c.id = conversation_id AND c.user_id = auth.uid()))
      OR (sender_type = 'agent' AND public.is_support_agent())
    )
  );

-- ── 3. One open normal thread per user↔agent (kill the duplicate-create race) ──
-- Collapse any pre-existing duplicates (keep the newest) so the unique index builds.
WITH ranked AS (
  SELECT id, row_number() OVER (
           PARTITION BY user_id, agent_id ORDER BY created_at DESC
         ) AS rn
  FROM support_conversations
  WHERE status = 'open' AND priority = 'normal' AND agent_id IS NOT NULL
)
UPDATE support_conversations c
SET status = 'closed'
FROM ranked r
WHERE c.id = r.id AND r.rn > 1;

CREATE UNIQUE INDEX IF NOT EXISTS support_conversations_one_open_normal_idx
  ON support_conversations (user_id, agent_id)
  WHERE status = 'open' AND priority = 'normal' AND agent_id IS NOT NULL;

-- ── 4. Keep updated_at fresh so the inbox sorts by latest activity ──
-- updated_at was only set at creation, but every inbox/order query sorts by it.
CREATE OR REPLACE FUNCTION public.bump_conversation_updated_at()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
  UPDATE support_conversations SET updated_at = NOW() WHERE id = NEW.conversation_id;
  RETURN NEW;
END;
$$;
DROP TRIGGER IF EXISTS support_messages_bump_conv ON support_messages;
CREATE TRIGGER support_messages_bump_conv
  AFTER INSERT ON support_messages
  FOR EACH ROW EXECUTE FUNCTION public.bump_conversation_updated_at();
