-- Extended CMS-managed content (replaces bundled-only data)

-- Passport countries for onboarding / profile
CREATE TABLE IF NOT EXISTS passport_countries (
  code          TEXT PRIMARY KEY,
  name          TEXT NOT NULL,
  flag          TEXT NOT NULL DEFAULT '',
  display_order INT NOT NULL DEFAULT 0,
  is_active     BOOLEAN NOT NULL DEFAULT TRUE,
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Visa rules per passport country
CREATE TABLE IF NOT EXISTS visa_rules (
  country_code  TEXT PRIMARY KEY,
  country_name  TEXT NOT NULL,
  flag          TEXT NOT NULL DEFAULT '',
  visa_free     BOOLEAN NOT NULL DEFAULT FALSE,
  stay_days     INT,
  headline      TEXT NOT NULL,
  details       JSONB NOT NULL DEFAULT '[]'::jsonb,
  is_active     BOOLEAN NOT NULL DEFAULT TRUE,
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Guide culture tips
CREATE TABLE IF NOT EXISTS culture_tips (
  id          TEXT PRIMARY KEY,
  emoji       TEXT NOT NULL DEFAULT '',
  title       TEXT NOT NULL,
  preview     TEXT NOT NULL,
  body        TEXT NOT NULL,
  sort_order  INT NOT NULL DEFAULT 0,
  is_active   BOOLEAN NOT NULL DEFAULT TRUE,
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Assistant canned replies by scenario
CREATE TABLE IF NOT EXISTS assistant_replies (
  scenario_id       TEXT PRIMARY KEY,
  user_message        TEXT,
  assistant_message   TEXT NOT NULL,
  is_active           BOOLEAN NOT NULL DEFAULT TRUE,
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Emergency numbers (single global config row)
CREATE TABLE IF NOT EXISTS emergency_config (
  id            TEXT PRIMARY KEY DEFAULT 'global',
  embassy_note  TEXT NOT NULL,
  contacts      JSONB NOT NULL DEFAULT '[]'::jsonb,
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

INSERT INTO emergency_config (id, embassy_note, contacts)
VALUES (
  'global',
  'Contact your embassy for lost passport assistance.',
  '[]'::jsonb
)
ON CONFLICT (id) DO NOTHING;

-- Sample / planning itineraries for Plan & Assistant
CREATE TABLE IF NOT EXISTS content_itineraries (
  id                TEXT PRIMARY KEY,
  kind              TEXT NOT NULL CHECK (kind IN ('sample', 'planning')),
  title             TEXT NOT NULL,
  meta              TEXT NOT NULL,
  route_summary     TEXT NOT NULL,
  estimated_budget  TEXT NOT NULL,
  days              JSONB NOT NULL DEFAULT '[]'::jsonb,
  sort_order        INT NOT NULL DEFAULT 0,
  is_active         BOOLEAN NOT NULL DEFAULT TRUE,
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS content_itineraries_kind_idx ON content_itineraries (kind);

-- home_tips: deep link column for Guide
ALTER TABLE home_tips ADD COLUMN IF NOT EXISTS link_attraction_id TEXT;
