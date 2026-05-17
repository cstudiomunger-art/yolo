-- ChinaGo MVP: content mode switches (CMS-controlled)
CREATE TABLE IF NOT EXISTS app_settings (
  id                  TEXT PRIMARY KEY DEFAULT 'global',
  use_remote_content  BOOLEAN NOT NULL DEFAULT FALSE,
  use_remote_ai       BOOLEAN NOT NULL DEFAULT FALSE,
  use_remote_iap      BOOLEAN NOT NULL DEFAULT FALSE,
  updated_at          TIMESTAMPTZ DEFAULT NOW()
);

INSERT INTO app_settings (id)
VALUES ('global')
ON CONFLICT (id) DO NOTHING;

ALTER TABLE app_settings ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "App settings publicly readable" ON app_settings;
CREATE POLICY "App settings publicly readable"
  ON app_settings FOR SELECT
  USING (true);

-- Prepare checklist display tags (Key / Urgent)
ALTER TABLE checklist_items
  ADD COLUMN IF NOT EXISTS display_tags TEXT[] DEFAULT '{}';

-- Home Heads Up tips
CREATE TABLE IF NOT EXISTS home_tips (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  city_id       TEXT REFERENCES cities(id),
  kicker        TEXT,
  headline      TEXT NOT NULL,
  body          TEXT NOT NULL,
  link_label    TEXT,
  link_url      TEXT,
  sort_order    INT DEFAULT 0,
  is_active     BOOLEAN DEFAULT TRUE,
  valid_from    DATE,
  valid_until   DATE,
  updated_at    TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE home_tips ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Home tips publicly readable" ON home_tips;
CREATE POLICY "Home tips publicly readable"
  ON home_tips FOR SELECT
  USING (is_active = true);
