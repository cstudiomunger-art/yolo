-- 083 · visa_config：签证引擎可调参数（key/value），后台可编辑
-- 首个参数 passport_validity_months = 护照最低有效期（月）。引擎 GATE0 用它判定：
-- 用户护照有效期 < 该值 → 既不能免签、也办不了签证（需先换发护照）。默认 3。
-- 端上以独立 try? 拉取本表，缺表/失败不影响主签证数据加载（避免级联回退）。

CREATE TABLE IF NOT EXISTS visa_config (
  key        TEXT PRIMARY KEY,             -- 参数键，如 passport_validity_months
  value_int  INTEGER,                      -- 整数值（月数等）
  value_text TEXT,                         -- 文本值（备用）
  label_zh   TEXT NOT NULL DEFAULT '',     -- 后台显示名
  is_active  BOOLEAN NOT NULL DEFAULT TRUE
);

ALTER TABLE visa_config ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Public read visa_config" ON visa_config;
CREATE POLICY "Public read visa_config" ON visa_config
  FOR SELECT USING (is_active = TRUE OR public.is_admin());
DROP POLICY IF EXISTS "Admin insert visa_config" ON visa_config;
CREATE POLICY "Admin insert visa_config" ON visa_config
  FOR INSERT TO authenticated WITH CHECK (public.is_admin());
DROP POLICY IF EXISTS "Admin update visa_config" ON visa_config;
CREATE POLICY "Admin update visa_config" ON visa_config
  FOR UPDATE TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());
DROP POLICY IF EXISTS "Admin delete visa_config" ON visa_config;
CREATE POLICY "Admin delete visa_config" ON visa_config
  FOR DELETE TO authenticated USING (public.is_admin());

-- 初始参数。ON CONFLICT 幂等。
INSERT INTO visa_config (key, value_int, label_zh) VALUES
  ('passport_validity_months', 3, '护照最低有效期（月）')
ON CONFLICT (key) DO UPDATE SET
  label_zh = EXCLUDED.label_zh;
