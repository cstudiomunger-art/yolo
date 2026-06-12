-- Per-user saved attractions (Guide favorites)

CREATE TABLE IF NOT EXISTS favorite_attractions (
  user_id       UUID NOT NULL REFERENCES auth.users (id) ON DELETE CASCADE,
  attraction_id TEXT NOT NULL,
  city_id       TEXT NOT NULL,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  PRIMARY KEY (user_id, attraction_id)
);

CREATE INDEX IF NOT EXISTS favorite_attractions_user_created_idx
  ON favorite_attractions (user_id, created_at DESC);

ALTER TABLE favorite_attractions ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users read own favorite_attractions" ON favorite_attractions;
CREATE POLICY "Users read own favorite_attractions" ON favorite_attractions
  FOR SELECT TO authenticated
  USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users write own favorite_attractions" ON favorite_attractions;
CREATE POLICY "Users write own favorite_attractions" ON favorite_attractions
  FOR ALL TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);
