-- Anti-abuse for the chat-translate Edge Function (LLM cost protection).
-- Previously any authenticated user could translate arbitrary text without limit.
-- This adds an atomic per-user, per-minute rate check that also enforces eligibility
-- (only support agents or users with an open conversation may translate at all).

CREATE TABLE IF NOT EXISTS translate_usage (
  user_id       UUID NOT NULL REFERENCES auth.users (id) ON DELETE CASCADE,
  window_minute TIMESTAMPTZ NOT NULL,   -- truncated to the minute
  count         INT NOT NULL DEFAULT 0,
  PRIMARY KEY (user_id, window_minute)
);
-- Accessed only through the SECURITY DEFINER RPC below; no client access needed.
ALTER TABLE translate_usage ENABLE ROW LEVEL SECURITY;

CREATE INDEX IF NOT EXISTS translate_usage_window_idx ON translate_usage (window_minute);

-- Atomically: verify the caller is eligible, increment their minute counter, and
-- return whether they're still under the limit. One round-trip, race-free.
CREATE OR REPLACE FUNCTION public.translate_rate_check(max_per_min INT DEFAULT 30)
RETURNS BOOLEAN
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
DECLARE
  uid UUID := auth.uid();
  w   TIMESTAMPTZ := date_trunc('minute', NOW());
  c   INT;
BEGIN
  IF uid IS NULL THEN
    RETURN FALSE;
  END IF;

  -- Eligibility: only agents, or users who actually have an open conversation,
  -- have any reason to call translate. Everyone else is denied outright.
  IF NOT (
    public.is_support_agent()
    OR EXISTS (SELECT 1 FROM support_conversations WHERE user_id = uid AND status = 'open')
  ) THEN
    RETURN FALSE;
  END IF;

  INSERT INTO translate_usage (user_id, window_minute, count)
    VALUES (uid, w, 1)
    ON CONFLICT (user_id, window_minute)
      DO UPDATE SET count = translate_usage.count + 1
    RETURNING count INTO c;

  RETURN c <= max_per_min;
END;
$$;

GRANT EXECUTE ON FUNCTION public.translate_rate_check(INT) TO authenticated;

-- Optional housekeeping: purge old counters. Safe to run from a scheduled job.
CREATE OR REPLACE FUNCTION public.purge_translate_usage()
RETURNS VOID
LANGUAGE sql SECURITY DEFINER SET search_path = public AS $$
  DELETE FROM translate_usage WHERE window_minute < NOW() - INTERVAL '1 day';
$$;
