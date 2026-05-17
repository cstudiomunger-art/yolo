-- ChinaGo: content tables (aligned with iOS RemoteContentRepository + bundled JSON)

CREATE TABLE IF NOT EXISTS cities (
  id                    TEXT PRIMARY KEY,
  name                  TEXT NOT NULL,
  chinese_name          TEXT NOT NULL,
  emoji                 TEXT,
  cover_image_path      TEXT,
  description           TEXT,
  best_for              TEXT[] NOT NULL DEFAULT '{}',
  season_note           TEXT,
  best_time_to_visit    TEXT,
  avg_days_recommended  INT,
  attraction_count      INT NOT NULL DEFAULT 0,
  display_order         INT NOT NULL DEFAULT 0,
  is_published          BOOLEAN NOT NULL DEFAULT TRUE,
  updated_at            TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS city_routes (
  id          TEXT PRIMARY KEY,
  city_id     TEXT NOT NULL REFERENCES cities (id) ON DELETE CASCADE,
  title       TEXT NOT NULL,
  days        INT NOT NULL,
  summary     TEXT NOT NULL,
  sort_order  INT NOT NULL DEFAULT 0,
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS city_routes_city_id_idx ON city_routes (city_id);

CREATE TABLE IF NOT EXISTS attractions (
  id                        TEXT PRIMARY KEY,
  city_id                   TEXT NOT NULL REFERENCES cities (id) ON DELETE CASCADE,
  name                      TEXT NOT NULL,
  chinese_name              TEXT NOT NULL,
  category                  TEXT NOT NULL DEFAULT 'sight',
  cover_image_path          TEXT,
  summary                   TEXT,
  introduction              TEXT,
  priority                  TEXT NOT NULL DEFAULT 'P1',
  ticket_price              TEXT,
  recommended_duration      TEXT,
  opening_hours             TEXT,
  closed_days               TEXT,
  requires_advance_booking  BOOLEAN NOT NULL DEFAULT FALSE,
  metro_access              TEXT,
  western_visitor_tips      JSONB NOT NULL DEFAULT '[]'::jsonb,
  nearby_places             JSONB NOT NULL DEFAULT '[]'::jsonb,
  audio_guide_count         INT NOT NULL DEFAULT 0,
  iap_product_id            TEXT,
  display_order             INT NOT NULL DEFAULT 0,
  is_published              BOOLEAN NOT NULL DEFAULT TRUE,
  updated_at                TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS attractions_city_id_idx ON attractions (city_id);

CREATE TABLE IF NOT EXISTS audio_guides (
  id                TEXT PRIMARY KEY,
  attraction_id     TEXT NOT NULL REFERENCES attractions (id) ON DELETE CASCADE,
  title_en          TEXT NOT NULL,
  description       TEXT,
  duration_seconds  INT NOT NULL DEFAULT 0,
  audio_url         TEXT NOT NULL DEFAULT '',
  quote             TEXT,
  segments          JSONB NOT NULL DEFAULT '[]'::jsonb,
  is_main_guide     BOOLEAN NOT NULL DEFAULT FALSE,
  sort_order        INT NOT NULL DEFAULT 0,
  is_active         BOOLEAN NOT NULL DEFAULT TRUE,
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS audio_guides_attraction_id_idx ON audio_guides (attraction_id);

CREATE TABLE IF NOT EXISTS checklist_items (
  id                  TEXT PRIMARY KEY,
  city_id             TEXT REFERENCES cities (id) ON DELETE SET NULL,
  phase               TEXT NOT NULL,
  group_title         TEXT NOT NULL,
  title_en            TEXT NOT NULL,
  estimated_minutes   INT,
  display_tags        TEXT[] NOT NULL DEFAULT '{}',
  cultural_tip        TEXT,
  sort_order          INT NOT NULL DEFAULT 0,
  is_active           BOOLEAN NOT NULL DEFAULT TRUE,
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS shopping_items (
  id          TEXT PRIMARY KEY,
  city_id     TEXT REFERENCES cities (id) ON DELETE SET NULL,
  title_en    TEXT NOT NULL,
  note_en     TEXT,
  sort_order  INT NOT NULL DEFAULT 0,
  is_active   BOOLEAN NOT NULL DEFAULT TRUE,
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS reading_list (
  id          TEXT PRIMARY KEY,
  city_ids    TEXT[] NOT NULL DEFAULT '{}',
  title       TEXT NOT NULL,
  author      TEXT NOT NULL,
  genre       TEXT NOT NULL,
  synopsis_en TEXT NOT NULL,
  sort_order  INT NOT NULL DEFAULT 0,
  is_active   BOOLEAN NOT NULL DEFAULT TRUE,
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS hotels (
  id                  TEXT PRIMARY KEY,
  city_id             TEXT NOT NULL REFERENCES cities (id) ON DELETE CASCADE,
  name                TEXT NOT NULL,
  chinese_name        TEXT NOT NULL,
  stars               INT NOT NULL DEFAULT 4,
  price_min_usd       INT NOT NULL DEFAULT 0,
  has_english_staff   BOOLEAN NOT NULL DEFAULT FALSE,
  english_staff_note  TEXT,
  language_tip        TEXT,
  location_note       TEXT,
  booking_platforms   TEXT[] NOT NULL DEFAULT '{}',
  sort_order          INT NOT NULL DEFAULT 0,
  is_active           BOOLEAN NOT NULL DEFAULT TRUE,
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS hotels_city_id_idx ON hotels (city_id);

-- home_tips may already exist from 001 (uuid id); skip if present
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.tables
    WHERE table_schema = 'public' AND table_name = 'home_tips'
  ) THEN
    CREATE TABLE home_tips (
      id          TEXT PRIMARY KEY,
      city_id     TEXT REFERENCES cities (id) ON DELETE SET NULL,
      kicker      TEXT,
      headline    TEXT NOT NULL,
      body        TEXT NOT NULL,
      link_label  TEXT,
      link_url    TEXT,
      sort_order  INT NOT NULL DEFAULT 0,
      is_active   BOOLEAN NOT NULL DEFAULT TRUE,
      updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  END IF;
END $$;
