-- Per-city emergency resources: recommended hospitals and embassy/consulate phone numbers.
-- CMS-managed via admin-vue; App reads by city_id (iOS integration separate).

CREATE TABLE IF NOT EXISTS city_hospitals (
  id                      TEXT PRIMARY KEY,
  city_id                 TEXT NOT NULL REFERENCES cities (id) ON DELETE CASCADE,
  name_en                 TEXT NOT NULL DEFAULT '',
  name_zh                 TEXT NOT NULL DEFAULT '',
  phone                   TEXT NOT NULL DEFAULT '',
  address_en              TEXT NOT NULL DEFAULT '',
  address_zh              TEXT NOT NULL DEFAULT '',
  has_international_dept  BOOLEAN NOT NULL DEFAULT FALSE,
  note                    TEXT NOT NULL DEFAULT '',
  sort_order              INT NOT NULL DEFAULT 0,
  is_active               BOOLEAN NOT NULL DEFAULT TRUE,
  updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS city_hospitals_city_id_idx ON city_hospitals (city_id);

CREATE TABLE IF NOT EXISTS city_embassies (
  id                TEXT PRIMARY KEY,
  city_id           TEXT NOT NULL REFERENCES cities (id) ON DELETE CASCADE,
  country_code      TEXT NOT NULL REFERENCES passport_countries (code) ON DELETE RESTRICT,
  location_label    TEXT NOT NULL DEFAULT '',
  embassy_phone     TEXT NOT NULL DEFAULT '',
  consular_hotline  TEXT NOT NULL DEFAULT '',
  sort_order        INT NOT NULL DEFAULT 0,
  is_active         BOOLEAN NOT NULL DEFAULT TRUE,
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (city_id, country_code)
);

CREATE INDEX IF NOT EXISTS city_embassies_city_id_idx ON city_embassies (city_id);

-- ── RLS: public-read active rows; admin full ──
DO $policy$
DECLARE
  t TEXT;
BEGIN
  FOREACH t IN ARRAY ARRAY['city_hospitals', 'city_embassies']
  LOOP
    EXECUTE format('ALTER TABLE %I ENABLE ROW LEVEL SECURITY', t);
    EXECUTE format('DROP POLICY IF EXISTS %I ON %I', 'Public read ' || t, t);
    EXECUTE format(
      'CREATE POLICY %I ON %I FOR SELECT USING (is_active = TRUE OR public.is_admin())',
      'Public read ' || t, t
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

-- ════════════════════ STARTER SEED: Beijing embassies (from iOS EmbassyDirectory) ════════════════════
INSERT INTO city_embassies (id, city_id, country_code, location_label, embassy_phone, consular_hotline, sort_order) VALUES
  ('beijing-gb', 'beijing', 'GB', '驻华大使馆 · 北京', '+86 10 5192 4000', '+86 10 5192 4000', 0),
  ('beijing-us', 'beijing', 'US', '驻华大使馆 · 北京', '+86 10 8531 3000', '+86 10 8531 3000', 1),
  ('beijing-au', 'beijing', 'AU', '驻华大使馆 · 北京', '+86 10 5140 4111', '+61 2 6261 3305', 2),
  ('beijing-ca', 'beijing', 'CA', '驻华大使馆 · 北京', '+86 10 5139 4000', '+1 613 996 8885', 3)
ON CONFLICT (id) DO NOTHING;

-- Sample Beijing hospitals for CMS reference format
INSERT INTO city_hospitals (id, city_id, name_en, name_zh, phone, address_en, address_zh, has_international_dept, note, sort_order) VALUES
  (
    'beijing-union-medical',
    'beijing',
    'Peking Union Medical College Hospital',
    '北京协和医院',
    '+86 10 6915 6114',
    '1 Shuaifuyuan Wangfujing, Dongcheng District',
    '东城区帅府园1号',
    TRUE,
    'International Medical Services (IMS); English-speaking staff at main campus.',
    0
  ),
  (
    'beijing-united-family',
    'beijing',
    'Beijing United Family Hospital',
    '北京和睦家医院',
    '+86 10 5927 7000',
    '2 Jiangtai Road, Chaoyang District',
    '朝阳区将台路2号',
    TRUE,
    'Private hospital; full English service; good for expats.',
    1
  )
ON CONFLICT (id) DO NOTHING;
