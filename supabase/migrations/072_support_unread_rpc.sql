-- Server-side unread counts for the support inbox. Replaces the client pulling
-- up to 300 recent messages and counting in-memory (which grows with traffic and
-- runs on every inbox refresh). This computes per-conversation unread in a single
-- indexed query for the calling user.
--
-- Unread = agent messages newer than the user's last-read marker, in the user's
-- own non-deleted conversations.
CREATE OR REPLACE FUNCTION public.support_unread_counts()
RETURNS TABLE(conversation_id UUID, unread BIGINT)
LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT m.conversation_id, COUNT(*)::BIGINT
  FROM support_messages m
  JOIN support_conversations c ON c.id = m.conversation_id
  WHERE c.user_id = auth.uid()
    AND c.user_deleted_at IS NULL
    AND m.sender_type = 'agent'
    AND m.created_at > COALESCE(c.user_last_read_at, '-infinity'::TIMESTAMPTZ)
  GROUP BY m.conversation_id;
$$;

GRANT EXECUTE ON FUNCTION public.support_unread_counts() TO authenticated;
