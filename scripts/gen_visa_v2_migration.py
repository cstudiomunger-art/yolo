#!/usr/bin/env python3
"""从交付包 visa.db 生成 Supabase 迁移 075_visa_engine_v2.sql。

把已人工核验的 8 政策 + 201 grant + 115 城市 + 920 矩阵 + permit_zone 转成
Postgres DDL + 种子 INSERT（INT 0/1→BOOLEAN、TEXT-JSON→jsonb、去 review_status）。
派生矩阵直接灌表（client 不重算）。城市加 app_city_slug 映射 app 内容城市。
铁律：数据真伪由交付包人工核对，本脚本只做机械转换。
"""
import sqlite3
import os

SRC = os.path.expanduser("~/Desktop/YOLOHAPYY签证检查器/数据/visa.db")
OUT = os.path.expanduser("~/Desktop/YOLO/supabase/migrations/075_visa_engine_v2.sql")

# app 内容城市 slug → GB/T 2260 地级码（C 模块映射，单一真源）
APP_CITY_SLUG = {
    "110000": "beijing", "310000": "shanghai", "610100": "xian",
    "510100": "chengdu", "320500": "suzhou", "330100": "hangzhou",
}


def sql_str(v):
    if v is None:
        return "NULL"
    return "'" + str(v).replace("'", "''") + "'"


def sql_bool(v):
    return "TRUE" if v else "FALSE"


def sql_num(v):
    return "NULL" if v is None else str(v)


def sql_jsonb(v):
    """db 里已是 JSON 文本（如 '"national"' / '["110000"]' / NULL）→ jsonb 字面量。"""
    if v is None or v == "":
        return "NULL"
    return sql_str(v) + "::jsonb"


def main():
    con = sqlite3.connect(SRC)
    con.row_factory = sqlite3.Row
    out = []
    w = out.append

    w("-- Visa engine v2 — 已人工核验数据（8 政策 + 201 grant + 115 城市 + 派生矩阵）。")
    w("-- 由 scripts/gen_visa_v2_migration.py 从交付包 visa.db 生成，勿手改种子。")
    w("-- 客户端 VisaPolicyEngine(Swift) 离线判定的 CMS 数据源；旧 062 表保留作回退。")
    w("")

    # ── DDL ────────────────────────────────────────────────────────────────
    w("""CREATE TABLE IF NOT EXISTS visa_policies_v2 (
  id                       TEXT PRIMARY KEY,
  policy_type              TEXT NOT NULL,
  node_kind                TEXT NOT NULL DEFAULT 'computed',  -- computed | info(visa_L 兜底)
  universal                BOOLEAN NOT NULL DEFAULT FALSE,
  official_name_zh         TEXT NOT NULL DEFAULT '',
  official_name_en         TEXT NOT NULL DEFAULT '',
  onward_ticket            BOOLEAN NOT NULL DEFAULT FALSE,
  onward_third_country     BOOLEAN NOT NULL DEFAULT FALSE,
  group_required           BOOLEAN NOT NULL DEFAULT FALSE,
  entry_port_limited       BOOLEAN NOT NULL DEFAULT FALSE,
  entry_ports              JSONB,
  exit_ports               JSONB,
  entry_mode               JSONB,
  max_stay_default         INT,
  max_stay_unit            TEXT,                              -- hours | days
  clock_rule               TEXT,                              -- next_day_0000 | by_hour | entry_day
  allowed_area             JSONB,                             -- "national" 或 ["110000",...]
  passport_validity_months INT DEFAULT 6,
  priority                 INT NOT NULL,
  source_url               TEXT,
  last_verified            TEXT,
  is_active                BOOLEAN NOT NULL DEFAULT TRUE,
  updated_at               TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS visa_policy_grants_v2 (
  id                TEXT PRIMARY KEY,                         -- slug: {policy}_{cc}
  policy_id         TEXT NOT NULL REFERENCES visa_policies_v2 (id) ON DELETE CASCADE,
  country_code      TEXT NOT NULL,
  effective_date    DATE NOT NULL DEFAULT '1900-01-01',       -- NULL 起始 → 无下限
  expiry_date       DATE,                                     -- NULL = 官方未设截止
  max_stay_override INT,
  source_url        TEXT,
  last_verified     TEXT,
  is_active         BOOLEAN NOT NULL DEFAULT TRUE,
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS visa_policy_grants_v2_country_idx
  ON visa_policy_grants_v2 (country_code, policy_id);

CREATE TABLE IF NOT EXISTS visa_cities (
  city_id       TEXT PRIMARY KEY,                            -- GB/T 2260
  name_zh       TEXT NOT NULL DEFAULT '',
  name_en       TEXT NOT NULL DEFAULT '',
  region_type   TEXT NOT NULL DEFAULT 'mainland',            -- mainland | special
  is_entry_port BOOLEAN NOT NULL DEFAULT FALSE,
  is_exit_port  BOOLEAN NOT NULL DEFAULT FALSE,
  transit_240h  BOOLEAN NOT NULL DEFAULT FALSE,
  app_city_slug TEXT,                                        -- 映射 app 内容城市 id（可空）
  is_active     BOOLEAN NOT NULL DEFAULT TRUE,
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS visa_city_policy_matrix (
  city_id     TEXT NOT NULL REFERENCES visa_cities (city_id) ON DELETE CASCADE,
  policy_id   TEXT NOT NULL REFERENCES visa_policies_v2 (id) ON DELETE CASCADE,
  feasibility TEXT NOT NULL,                                 -- ok | no | permit_required（派生只读）
  note        TEXT,
  is_active   BOOLEAN NOT NULL DEFAULT TRUE,
  PRIMARY KEY (city_id, policy_id)
);

CREATE TABLE IF NOT EXISTS visa_permit_zones (
  admin_code TEXT PRIMARY KEY,                               -- GB/T 2260（省级或市级）
  name       TEXT NOT NULL DEFAULT '',
  note       TEXT,
  is_active  BOOLEAN NOT NULL DEFAULT TRUE
);
""")

    # ── RLS（与 062 同款：public-read where is_active，admin 写）─────────────
    w("""DO $policy$
DECLARE
  t TEXT;
BEGIN
  FOREACH t IN ARRAY ARRAY[
    'visa_policies_v2', 'visa_policy_grants_v2', 'visa_cities',
    'visa_city_policy_matrix', 'visa_permit_zones'
  ]
  LOOP
    EXECUTE format('ALTER TABLE %I ENABLE ROW LEVEL SECURITY', t);
    EXECUTE format('DROP POLICY IF EXISTS %I ON %I', 'Public read ' || t, t);
    EXECUTE format(
      'CREATE POLICY %I ON %I FOR SELECT USING (is_active = TRUE OR public.is_admin())',
      'Public read ' || t, t);
    EXECUTE format('DROP POLICY IF EXISTS %I ON %I', 'Admin insert ' || t, t);
    EXECUTE format(
      'CREATE POLICY %I ON %I FOR INSERT TO authenticated WITH CHECK (public.is_admin())',
      'Admin insert ' || t, t);
    EXECUTE format('DROP POLICY IF EXISTS %I ON %I', 'Admin update ' || t, t);
    EXECUTE format(
      'CREATE POLICY %I ON %I FOR UPDATE TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin())',
      'Admin update ' || t, t);
    EXECUTE format('DROP POLICY IF EXISTS %I ON %I', 'Admin delete ' || t, t);
    EXECUTE format(
      'CREATE POLICY %I ON %I FOR DELETE TO authenticated USING (public.is_admin())',
      'Admin delete ' || t, t);
  END LOOP;
END
$policy$;
""")

    # ── 政策 ────────────────────────────────────────────────────────────────
    w("-- ════════════════ 政策框架（8 条，人工核验）════════════════")
    rows = con.execute("SELECT * FROM policies ORDER BY priority").fetchall()
    for p in rows:
        node_kind = "info" if p["id"] == "visa_L" else "computed"
        vals = [
            sql_str(p["id"]), sql_str(p["policy_type"]), sql_str(node_kind),
            sql_bool(p["universal"]), sql_str(p["official_name_zh"]), sql_str(p["official_name_en"]),
            sql_bool(p["onward_ticket"]), sql_bool(p["onward_third_country"]),
            sql_bool(p["group_required"]), sql_bool(p["entry_port_limited"]),
            sql_jsonb(p["entry_ports"]), sql_jsonb(p["exit_ports"]), sql_jsonb(p["entry_mode"]),
            sql_num(p["max_stay_default"]), sql_str(p["max_stay_unit"]), sql_str(p["clock_rule"]),
            sql_jsonb(p["allowed_area"]), sql_num(p["passport_validity_months"]),
            sql_num(p["priority"]), sql_str(p["source_url"]), sql_str(p["last_verified"]),
        ]
        w("INSERT INTO visa_policies_v2 (id, policy_type, node_kind, universal, official_name_zh, "
          "official_name_en, onward_ticket, onward_third_country, group_required, entry_port_limited, "
          "entry_ports, exit_ports, entry_mode, max_stay_default, max_stay_unit, clock_rule, "
          "allowed_area, passport_validity_months, priority, source_url, last_verified) VALUES")
        w("  (" + ", ".join(vals) + ")")
        w("ON CONFLICT (id) DO NOTHING;")
    w("")

    # ── 城市 ────────────────────────────────────────────────────────────────
    w("-- ════════════════ 城市维表（115，GB/T 2260）════════════════")
    crows = con.execute("SELECT * FROM cities ORDER BY city_id").fetchall()
    w("INSERT INTO visa_cities (city_id, name_zh, name_en, region_type, is_entry_port, "
      "is_exit_port, transit_240h, app_city_slug) VALUES")
    parts = []
    for c in crows:
        slug = APP_CITY_SLUG.get(c["city_id"])
        parts.append("  (" + ", ".join([
            sql_str(c["city_id"]), sql_str(c["name_zh"]), sql_str(c["name_en"]),
            sql_str(c["region_type"]), sql_bool(c["is_entry_port"]),
            sql_bool(c["is_exit_port"]), sql_bool(c["transit_240h"]),
            sql_str(slug) if slug else "NULL",
        ]) + ")")
    w(",\n".join(parts))
    w("ON CONFLICT (city_id) DO NOTHING;")
    w("")

    # ── grant ──────────────────────────────────────────────────────────────
    w("-- ════════════════ 政策适用 grant（201 国次，人工核验）════════════════")
    grows = con.execute("SELECT * FROM policy_grants ORDER BY policy_id, country_code").fetchall()
    w("INSERT INTO visa_policy_grants_v2 (id, policy_id, country_code, effective_date, "
      "expiry_date, max_stay_override, source_url, last_verified) VALUES")
    parts = []
    for g in grows:
        gid = f"{g['policy_id']}_{g['country_code']}".lower()
        eff = g["effective_date"] or "1900-01-01"
        parts.append("  (" + ", ".join([
            sql_str(gid), sql_str(g["policy_id"]), sql_str(g["country_code"]),
            sql_str(eff), sql_str(g["expiry_date"]), sql_num(g["max_stay_override"]),
            sql_str(g["source_url"]), sql_str(g["last_verified"]),
        ]) + ")")
    w(",\n".join(parts))
    w("ON CONFLICT (id) DO NOTHING;")
    w("")

    # ── 矩阵 ────────────────────────────────────────────────────────────────
    w("-- ════════════════ 城市×政策矩阵（920，派生只读）════════════════")
    mrows = con.execute("SELECT * FROM city_policy_matrix ORDER BY policy_id, city_id").fetchall()
    w("INSERT INTO visa_city_policy_matrix (city_id, policy_id, feasibility, note) VALUES")
    parts = []
    for m in mrows:
        parts.append("  (" + ", ".join([
            sql_str(m["city_id"]), sql_str(m["policy_id"]),
            sql_str(m["feasibility"]), sql_str(m["note"]),
        ]) + ")")
    w(",\n".join(parts))
    w("ON CONFLICT (city_id, policy_id) DO NOTHING;")
    w("")

    # ── permit zones ────────────────────────────────────────────────────────
    w("-- ════════════════ 叠加许可区（西藏等）════════════════")
    pzrows = con.execute("SELECT * FROM permit_zones ORDER BY admin_code").fetchall()
    w("INSERT INTO visa_permit_zones (admin_code, name, note) VALUES")
    parts = []
    for z in pzrows:
        parts.append("  (" + ", ".join([
            sql_str(z["admin_code"]), sql_str(z["name"]), sql_str(z["note"]),
        ]) + ")")
    w(",\n".join(parts))
    w("ON CONFLICT (admin_code) DO NOTHING;")
    w("")

    con.close()
    with open(OUT, "w", encoding="utf-8") as f:
        f.write("\n".join(out))
    print(f"✓ wrote {OUT}")
    print(f"  policies={len(rows)} cities={len(crows)} grants={len(grows)} "
          f"matrix={len(mrows)} permit_zones={len(pzrows)}")


if __name__ == "__main__":
    main()
