-- 078 · visa_ports：签证检测口岸选择器维表（IATA），改为后台可编辑
-- 端上口岸选择器原为硬编码；本表让运营在 admin 维护。引擎按 code 匹配政策
-- entry_ports/exit_ports，故 code 必须与 visa_policies_v2 端口同命名空间（IATA）。

CREATE TABLE IF NOT EXISTS visa_ports (
  code          TEXT PRIMARY KEY,                  -- IATA，如 PVG / PEK / TSN
  name_zh       TEXT NOT NULL DEFAULT '',
  name_en       TEXT,
  display_order INTEGER NOT NULL DEFAULT 0,        -- 选择器排序
  is_active     BOOLEAN NOT NULL DEFAULT TRUE
);

ALTER TABLE visa_ports ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Public read visa_ports" ON visa_ports;
CREATE POLICY "Public read visa_ports" ON visa_ports
  FOR SELECT USING (is_active = TRUE OR public.is_admin());
DROP POLICY IF EXISTS "Admin insert visa_ports" ON visa_ports;
CREATE POLICY "Admin insert visa_ports" ON visa_ports
  FOR INSERT TO authenticated WITH CHECK (public.is_admin());
DROP POLICY IF EXISTS "Admin update visa_ports" ON visa_ports;
CREATE POLICY "Admin update visa_ports" ON visa_ports
  FOR UPDATE TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());
DROP POLICY IF EXISTS "Admin delete visa_ports" ON visa_ports;
CREATE POLICY "Admin delete visa_ports" ON visa_ports
  FOR DELETE TO authenticated USING (public.is_admin());

-- 初始口岸（与端上兜底一致）。ON CONFLICT 幂等，便于重复执行。
INSERT INTO visa_ports (code, name_zh, name_en, display_order) VALUES
  ('PEK', '北京首都机场', 'Beijing Capital',        0),
  ('PKX', '北京大兴机场', 'Beijing Daxing',         1),
  ('PVG', '上海浦东机场', 'Shanghai Pudong',        2),
  ('SHA', '上海虹桥机场', 'Shanghai Hongqiao',      3),
  ('CAN', '广州白云机场', 'Guangzhou Baiyun',       4),
  ('SZX', '深圳宝安机场', 'Shenzhen Baoan',         5),
  ('TFU', '成都天府机场', 'Chengdu Tianfu',         6),
  ('CTU', '成都双流机场', 'Chengdu Shuangliu',      7),
  ('XIY', '西安咸阳机场', 'Xi''an Xianyang',        8),
  ('HGH', '杭州萧山机场', 'Hangzhou Xiaoshan',      9),
  ('CKG', '重庆江北机场', 'Chongqing Jiangbei',    10),
  ('TSN', '天津滨海机场', 'Tianjin Binhai',        11),
  ('HAK', '海口美兰机场', 'Haikou Meilan',         12),
  ('SYX', '三亚凤凰机场', 'Sanya Phoenix',         13),
  ('JHG', '西双版纳机场', 'Xishuangbanna Gasa',    14)
ON CONFLICT (code) DO UPDATE SET
  name_zh       = EXCLUDED.name_zh,
  name_en       = EXCLUDED.name_en,
  display_order = EXCLUDED.display_order;
