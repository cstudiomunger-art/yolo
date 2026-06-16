-- Visa policy engine: CMS-driven data for the client-side VisaPolicyEngine.
-- The judgement (decision tree) runs as a pure Swift function on-device; these
-- tables only supply the data it evaluates. Seed below is STARTER data for 6
-- countries — operations/legal must verify before relying on it in production.

-- ── Policy framework (P1 互免 / P2 单方面 / P3 240h过境 / P4 海南 / P5 团体 / L 兜底) ──
CREATE TABLE IF NOT EXISTS visa_policies (
  policy_key    TEXT PRIMARY KEY,                       -- 'P1'|'P2'|'P3'|'P4'|'P5'|'L'
  priority      INT NOT NULL,                           -- 择优排序：小=限制更少，命中即停
  verdict       TEXT NOT NULL,                          -- 'green'|'amber'|'red'
  max_stay_days INT,                                    -- 政策上限（P2=30, P3≈10, ...）
  area_scope    TEXT NOT NULL DEFAULT 'nationwide',     -- 'nationwide'|'transit_ports'|'hainan'|'group'|'none'
  clock_rule    TEXT,                                   -- 'entry_plus_30d'|'entry_plus_10d'|...
  headline_en   TEXT NOT NULL DEFAULT '',
  headline_zh   TEXT NOT NULL DEFAULT '',
  is_active     BOOLEAN NOT NULL DEFAULT TRUE,
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ── Nationality × policy × validity window (单方面免签各国 expiry 不同，按入境日命中) ──
CREATE TABLE IF NOT EXISTS visa_policy_grants (
  id                TEXT PRIMARY KEY,                   -- slug, e.g. 'p2_gb'
  policy_key        TEXT NOT NULL REFERENCES visa_policies (policy_key) ON DELETE CASCADE,
  country_code      TEXT NOT NULL,                      -- 护照国籍（ISO 2 字母）
  effective_date    DATE,                               -- NULL = 长期有效
  expiry_date       DATE,                               -- NULL = 无截止
  max_stay_override INT,
  is_active         BOOLEAN NOT NULL DEFAULT TRUE,
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS visa_policy_grants_country_idx
  ON visa_policy_grants (country_code, policy_key);

-- ── City tags (逐城复核港澳/特殊区) ──
CREATE TABLE IF NOT EXISTS city_visa_tags (
  city_id          TEXT PRIMARY KEY,
  region_type      TEXT NOT NULL DEFAULT 'mainland',    -- 'mainland'|'hk'|'macao'|'special'
  is_port_of_entry BOOLEAN NOT NULL DEFAULT FALSE,
  notes_en         TEXT NOT NULL DEFAULT '',
  notes_zh         TEXT NOT NULL DEFAULT '',
  is_active        BOOLEAN NOT NULL DEFAULT TRUE,
  updated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ── Entry ports (240h 过境 / 海南标记) ──
CREATE TABLE IF NOT EXISTS entry_ports (
  port_id       TEXT PRIMARY KEY,
  name_en       TEXT NOT NULL DEFAULT '',
  name_zh       TEXT NOT NULL DEFAULT '',
  city_id       TEXT,
  transit_240h  BOOLEAN NOT NULL DEFAULT FALSE,
  is_hainan     BOOLEAN NOT NULL DEFAULT FALSE,
  display_order INT NOT NULL DEFAULT 0,
  is_active     BOOLEAN NOT NULL DEFAULT TRUE,
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ── Nationality × region per-city override (逐城复核覆盖) ──
CREATE TABLE IF NOT EXISTS visa_rule_overrides (
  id           TEXT PRIMARY KEY,                        -- slug, e.g. 'us_hk'
  country_code TEXT NOT NULL,
  region_type  TEXT NOT NULL,
  visa_free    BOOLEAN NOT NULL DEFAULT FALSE,
  stay_days    INT,
  note_en      TEXT NOT NULL DEFAULT '',
  note_zh      TEXT NOT NULL DEFAULT '',
  is_active    BOOLEAN NOT NULL DEFAULT TRUE,
  updated_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ── RLS: public-read CMS content tables (same pattern as 005/007) ──
DO $policy$
DECLARE
  t TEXT;
BEGIN
  FOREACH t IN ARRAY ARRAY[
    'visa_policies',
    'visa_policy_grants',
    'city_visa_tags',
    'entry_ports',
    'visa_rule_overrides'
  ]
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

-- ════════════════════ STARTER SEED (verify before production) ════════════════════

INSERT INTO visa_policies (policy_key, priority, verdict, max_stay_days, area_scope, clock_rule, headline_en, headline_zh) VALUES
  ('P1', 1, 'green',   30, 'nationwide',     'entry_plus_30d', 'Mutual visa exemption',        '互免协定 · 全程免签'),
  ('P2', 2, 'green',   30, 'nationwide',     'entry_plus_30d', 'Unilateral 30-day visa-free',  '单方面免签 30 天'),
  ('P3', 3, 'amber',   10, 'transit_ports',  'entry_plus_10d', '240h transit visa-free',       '240 小时过境免签'),
  ('P4', 4, 'amber',   30, 'hainan',         'entry_plus_30d', 'Hainan visa-free',             '海南区域免签'),
  ('P5', 5, 'amber',   NULL,'group',         NULL,             'Group tour visa-free',         '团体免签'),
  ('L',  9, 'red',     NULL,'none',          NULL,             'Tourist (L) visa required',    '需办 L 旅游签证')
ON CONFLICT (policy_key) DO NOTHING;

-- Grants for the 6 seed countries (UK/US/FR/DE/SG/JP). Windows are illustrative.
INSERT INTO visa_policy_grants (id, policy_key, country_code, effective_date, expiry_date) VALUES
  -- P1 互免：新加坡（中新互免 30 天）
  ('p1_sg', 'P1', 'SG', NULL, NULL),
  -- P2 单方面免签 30 天（试行窗口，示意，需核对）
  ('p2_gb', 'P2', 'GB', '2024-11-30', '2025-12-31'),
  ('p2_fr', 'P2', 'FR', '2024-11-30', '2025-12-31'),
  ('p2_de', 'P2', 'DE', '2024-11-30', '2025-12-31'),
  ('p2_jp', 'P2', 'JP', '2024-11-30', '2025-12-31'),
  -- P3 240h 过境免签（6 国均在 54 国清单内，作 secondary / 美国的主路径）
  ('p3_us', 'P3', 'US', NULL, NULL),
  ('p3_gb', 'P3', 'GB', NULL, NULL),
  ('p3_fr', 'P3', 'FR', NULL, NULL),
  ('p3_de', 'P3', 'DE', NULL, NULL),
  ('p3_jp', 'P3', 'JP', NULL, NULL),
  ('p3_sg', 'P3', 'SG', NULL, NULL),
  -- P4 海南免签（59 国，仅在海南口岸入境时触发）
  ('p4_us', 'P4', 'US', NULL, NULL),
  ('p4_gb', 'P4', 'GB', NULL, NULL),
  ('p4_fr', 'P4', 'FR', NULL, NULL),
  ('p4_de', 'P4', 'DE', NULL, NULL),
  ('p4_jp', 'P4', 'JP', NULL, NULL),
  ('p4_sg', 'P4', 'SG', NULL, NULL)
ON CONFLICT (id) DO NOTHING;

-- City tags: existing content cities are all mainland.
INSERT INTO city_visa_tags (city_id, region_type, is_port_of_entry) VALUES
  ('beijing',  'mainland', TRUE),
  ('shanghai', 'mainland', TRUE),
  ('xian',     'mainland', TRUE),
  ('chengdu',  'mainland', TRUE),
  ('suzhou',   'mainland', FALSE),
  ('hangzhou', 'mainland', TRUE)
ON CONFLICT (city_id) DO NOTHING;

-- Entry ports: major airports (240h transit open ports + a Hainan port).
INSERT INTO entry_ports (port_id, name_en, name_zh, city_id, transit_240h, is_hainan, display_order) VALUES
  ('pek', 'Beijing Capital Intl',  '北京首都机场', 'beijing',  TRUE,  FALSE, 0),
  ('pvg', 'Shanghai Pudong Intl',  '上海浦东机场', 'shanghai', TRUE,  FALSE, 1),
  ('xiy', 'Xi''an Xianyang Intl',  '西安咸阳机场', 'xian',     TRUE,  FALSE, 2),
  ('ctu', 'Chengdu Tianfu Intl',   '成都天府机场', 'chengdu',  TRUE,  FALSE, 3),
  ('hgh', 'Hangzhou Xiaoshan Intl','杭州萧山机场', 'hangzhou', TRUE,  FALSE, 4),
  ('can', 'Guangzhou Baiyun Intl', '广州白云机场', NULL,       TRUE,  FALSE, 5),
  ('szx', 'Shenzhen Bao''an Intl', '深圳宝安机场', NULL,       TRUE,  FALSE, 6),
  ('hak', 'Haikou Meilan Intl',    '海口美兰机场', NULL,       FALSE, TRUE,  7)
ON CONFLICT (port_id) DO NOTHING;
