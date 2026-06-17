-- Auto-cleanup of abandoned conversations: when a user taps an agent (which creates
-- a conversation row) but leaves without sending any message, the empty thread should
-- not linger in their inbox or the agent console. Users have no DELETE policy on
-- support_conversations (only UPDATE), so this SECURITY DEFINER RPC removes the row —
-- but only the caller's own conversation, and only when it truly has zero messages.
CREATE OR REPLACE FUNCTION public.delete_empty_conversation(conv UUID)
RETURNS BOOLEAN
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
DECLARE
  removed BOOLEAN := FALSE;
BEGIN
  DELETE FROM support_conversations c
  WHERE c.id = conv
    AND c.user_id = auth.uid()
    AND NOT EXISTS (SELECT 1 FROM support_messages m WHERE m.conversation_id = conv);
  IF FOUND THEN
    removed := TRUE;
  END IF;
  RETURN removed;
END;
$$;

GRANT EXECUTE ON FUNCTION public.delete_empty_conversation(UUID) TO authenticated;
