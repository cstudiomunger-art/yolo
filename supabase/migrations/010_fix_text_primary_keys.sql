-- Fix content tables whose `id` was created as UUID (Supabase Table Editor default).
-- iOS + seed SQL use TEXT ids like 'route_beijing_classic', 'beijing_forbidden_city'.
-- Run BEFORE 008_seed_content.sql (after 004/009). Safe when tables are empty or seed-only.

-- Drop dependents first (keeps `cities` if already TEXT + seeded)
DROP TABLE IF EXISTS audio_guides CASCADE;
DROP TABLE IF EXISTS attractions CASCADE;
DROP TABLE IF EXISTS city_routes CASCADE;
DROP TABLE IF EXISTS checklist_items CASCADE;
DROP TABLE IF EXISTS shopping_items CASCADE;
DROP TABLE IF EXISTS reading_list CASCADE;
DROP TABLE IF EXISTS hotels CASCADE;
DROP TABLE IF EXISTS home_tips CASCADE;

-- Recreate with TEXT primary keys (migration 004 definitions)

CREATE TABLE city_routes (
  id          TEXT PRIMARY KEY,
  city_id     TEXT NOT NULL REFERENCES cities (id) ON DELETE CASCADE,
  title       TEXT NOT NULL,
  days        INT NOT NULL,
  summary     TEXT NOT NULL,
  sort_order  INT NOT NULL DEFAULT 0,
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX city_routes_city_id_idx ON city_routes (city_id);

CREATE TABLE attractions (
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

CREATE INDEX attractions_city_id_idx ON attractions (city_id);

CREATE TABLE audio_guides (
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

CREATE INDEX audio_guides_attraction_id_idx ON audio_guides (attraction_id);

CREATE TABLE checklist_items (
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

CREATE TABLE shopping_items (
  id          TEXT PRIMARY KEY,
  city_id     TEXT REFERENCES cities (id) ON DELETE SET NULL,
  title_en    TEXT NOT NULL,
  note_en     TEXT,
  sort_order  INT NOT NULL DEFAULT 0,
  is_active   BOOLEAN NOT NULL DEFAULT TRUE,
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE reading_list (
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

CREATE TABLE hotels (
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

CREATE INDEX hotels_city_id_idx ON hotels (city_id);

CREATE TABLE home_tips (
  id                   TEXT PRIMARY KEY,
  city_id              TEXT REFERENCES cities (id) ON DELETE SET NULL,
  kicker               TEXT,
  headline             TEXT NOT NULL,
  body                 TEXT NOT NULL,
  link_label           TEXT,
  link_url             TEXT,
  link_attraction_id   TEXT,
  sort_order           INT NOT NULL DEFAULT 0,
  is_active            BOOLEAN NOT NULL DEFAULT TRUE,
  updated_at           TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- RLS (same as 005)
ALTER TABLE city_routes ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Public read city_routes" ON city_routes;
CREATE POLICY "Public read city_routes" ON city_routes FOR SELECT USING (TRUE);
DROP POLICY IF EXISTS "Admin insert city_routes" ON city_routes;
CREATE POLICY "Admin insert city_routes" ON city_routes FOR INSERT TO authenticated WITH CHECK (public.is_admin());
DROP POLICY IF EXISTS "Admin update city_routes" ON city_routes;
CREATE POLICY "Admin update city_routes" ON city_routes FOR UPDATE TO authenticated
  USING (public.is_admin()) WITH CHECK (public.is_admin());
DROP POLICY IF EXISTS "Admin delete city_routes" ON city_routes;
CREATE POLICY "Admin delete city_routes" ON city_routes FOR DELETE TO authenticated USING (public.is_admin());

ALTER TABLE attractions ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Public read attractions" ON attractions;
CREATE POLICY "Public read attractions" ON attractions FOR SELECT
  USING (is_published = TRUE OR public.is_admin());
DROP POLICY IF EXISTS "Admin insert attractions" ON attractions;
CREATE POLICY "Admin insert attractions" ON attractions FOR INSERT TO authenticated WITH CHECK (public.is_admin());
DROP POLICY IF EXISTS "Admin update attractions" ON attractions;
CREATE POLICY "Admin update attractions" ON attractions FOR UPDATE TO authenticated
  USING (public.is_admin()) WITH CHECK (public.is_admin());
DROP POLICY IF EXISTS "Admin delete attractions" ON attractions;
CREATE POLICY "Admin delete attractions" ON attractions FOR DELETE TO authenticated USING (public.is_admin());

DO $policy$
DECLARE
  t TEXT;
  read_expr TEXT;
BEGIN
  FOREACH t IN ARRAY ARRAY[
    'audio_guides', 'checklist_items', 'shopping_items', 'reading_list', 'hotels', 'home_tips'
  ]
  LOOP
    read_expr := 'is_active = TRUE OR public.is_admin()';
    EXECUTE format('ALTER TABLE %I ENABLE ROW LEVEL SECURITY', t);
    EXECUTE format('DROP POLICY IF EXISTS %I ON %I', 'Public read ' || t, t);
    EXECUTE format(
      'CREATE POLICY %I ON %I FOR SELECT USING (%s)',
      'Public read ' || t, t, read_expr
    );
    EXECUTE format('DROP POLICY IF EXISTS %I ON %I', 'Admin insert ' || t, t);
    EXECUTE format(
      'CREATE POLICY %I ON %I FOR INSERT TO authenticated WITH CHECK (public.is_admin())',
      'Admin insert ' || t, t
    );
    EXECUTE format('DROP POLICY IF EXISTS %I ON %I', 'Admin update ' || t, t);
    EXECUTE format(
      'CREATE POLICY %I ON %I FOR UPDATE TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin())',
      'Admin update ' || t, t
    );
    EXECUTE format('DROP POLICY IF EXISTS %I ON %I', 'Admin delete ' || t, t);
    EXECUTE format(
      'CREATE POLICY %I ON %I FOR DELETE TO authenticated USING (public.is_admin())',
      'Admin delete ' || t, t
    );
  END LOOP;
END
$policy$;

DROP POLICY IF EXISTS "Home tips publicly readable" ON home_tips;
