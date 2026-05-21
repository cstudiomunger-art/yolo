-- Checklist v2: entry / universal / city + completion tracking

ALTER TABLE checklist_items ADD COLUMN IF NOT EXISTS type TEXT NOT NULL DEFAULT 'city';
ALTER TABLE checklist_items ADD COLUMN IF NOT EXISTS why_important TEXT;
ALTER TABLE checklist_items ADD COLUMN IF NOT EXISTS how_to_complete TEXT;
ALTER TABLE checklist_items ADD COLUMN IF NOT EXISTS external_links JSONB NOT NULL DEFAULT '[]'::jsonb;
ALTER TABLE checklist_items ADD COLUMN IF NOT EXISTS target_nationalities TEXT[] NOT NULL DEFAULT '{}';
ALTER TABLE checklist_items ADD COLUMN IF NOT EXISTS target_cities TEXT[] NOT NULL DEFAULT '{}';
ALTER TABLE checklist_items ADD COLUMN IF NOT EXISTS priority TEXT NOT NULL DEFAULT 'recommended';

-- Backfill type from legacy city_id / phase
UPDATE checklist_items
SET type = CASE
  WHEN city_id IS NULL AND (group_title ILIKE '%entry%' OR group_title ILIKE '%visa%' OR phase = 'before_departure') THEN 'entry'
  WHEN city_id IS NULL THEN 'universal'
  ELSE 'city'
END
WHERE type = 'city' OR type IS NULL;

UPDATE checklist_items
SET target_cities = ARRAY[city_id]
WHERE type = 'city' AND city_id IS NOT NULL AND cardinality(target_cities) = 0;

CREATE TABLE IF NOT EXISTS checklist_settings (
  id              TEXT PRIMARY KEY DEFAULT 'global',
  reminder_days   INT NOT NULL DEFAULT 3,
  push_title      TEXT NOT NULL DEFAULT 'Your China trip is in {days} days!',
  push_body       TEXT NOT NULL DEFAULT 'You still have {count} prep items to complete. Don''t miss them!',
  home_banner_enabled BOOLEAN NOT NULL DEFAULT TRUE,
  home_banner_template TEXT NOT NULL DEFAULT '{count} items still need attention · Trip starts in {days} days',
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

INSERT INTO checklist_settings (id) VALUES ('global') ON CONFLICT (id) DO NOTHING;

CREATE TABLE IF NOT EXISTS checklist_completion (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id           UUID NOT NULL REFERENCES auth.users (id) ON DELETE CASCADE,
  checklist_item_id TEXT NOT NULL REFERENCES checklist_items (id) ON DELETE CASCADE,
  itinerary_id      TEXT,
  status            TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'done', 'skipped')),
  completed_at      TIMESTAMPTZ,
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (user_id, checklist_item_id, itinerary_id)
);

CREATE INDEX IF NOT EXISTS checklist_completion_user_idx ON checklist_completion (user_id);

ALTER TABLE checklist_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE checklist_completion ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Public read checklist_settings" ON checklist_settings;
CREATE POLICY "Public read checklist_settings" ON checklist_settings FOR SELECT USING (TRUE);
DROP POLICY IF EXISTS "Admin write checklist_settings" ON checklist_settings;
CREATE POLICY "Admin write checklist_settings" ON checklist_settings FOR ALL TO authenticated
  USING (public.is_admin()) WITH CHECK (public.is_admin());

DROP POLICY IF EXISTS "Users read own checklist_completion" ON checklist_completion;
CREATE POLICY "Users read own checklist_completion" ON checklist_completion FOR SELECT TO authenticated
  USING (auth.uid() = user_id);
DROP POLICY IF EXISTS "Users write own checklist_completion" ON checklist_completion;
CREATE POLICY "Users write own checklist_completion" ON checklist_completion FOR ALL TO authenticated
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
