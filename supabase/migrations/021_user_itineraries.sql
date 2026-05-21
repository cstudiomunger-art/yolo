-- User-saved trips (unlimited; synced per account)

CREATE TABLE IF NOT EXISTS user_itineraries (
  id            TEXT PRIMARY KEY,
  user_id       UUID NOT NULL REFERENCES auth.users (id) ON DELETE CASCADE,
  title         TEXT NOT NULL,
  start_date    DATE,
  end_date      DATE,
  cities        TEXT[] NOT NULL DEFAULT '{}',
  payload       JSONB NOT NULL DEFAULT '{}'::jsonb,
  is_deleted    BOOLEAN NOT NULL DEFAULT FALSE,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS user_itineraries_user_idx ON user_itineraries (user_id) WHERE NOT is_deleted;

CREATE OR REPLACE FUNCTION set_user_itineraries_updated_at()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS user_itineraries_updated_at ON user_itineraries;
CREATE TRIGGER user_itineraries_updated_at
  BEFORE UPDATE ON user_itineraries
  FOR EACH ROW EXECUTE FUNCTION set_user_itineraries_updated_at();

ALTER TABLE user_itineraries ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users read own itineraries" ON user_itineraries;
CREATE POLICY "Users read own itineraries" ON user_itineraries FOR SELECT TO authenticated
  USING (auth.uid() = user_id);
DROP POLICY IF EXISTS "Users insert own itineraries" ON user_itineraries;
CREATE POLICY "Users insert own itineraries" ON user_itineraries FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = user_id);
DROP POLICY IF EXISTS "Users update own itineraries" ON user_itineraries;
CREATE POLICY "Users update own itineraries" ON user_itineraries FOR UPDATE TO authenticated
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
DROP POLICY IF EXISTS "Users delete own itineraries" ON user_itineraries;
CREATE POLICY "Users delete own itineraries" ON user_itineraries FOR DELETE TO authenticated
  USING (auth.uid() = user_id);
