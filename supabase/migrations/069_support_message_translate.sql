-- Translate-after-send: messages are inserted with only body_original; the receiving
-- side (auto-toggle or the per-message button) translates later and writes back
-- body_translated. That UPDATE needs an RLS policy — messages previously had only
-- SELECT/INSERT. Participants of the conversation may update (client only sets
-- body_translated).

DROP POLICY IF EXISTS "Participants update messages" ON support_messages;
CREATE POLICY "Participants update messages" ON support_messages
  FOR UPDATE TO authenticated
  USING (public.can_access_conversation(conversation_id) OR public.is_admin())
  WITH CHECK (public.can_access_conversation(conversation_id) OR public.is_admin());
