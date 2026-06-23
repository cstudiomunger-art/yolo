-- 079 · visa_ports 补邮轮母港（UN/LOCODE），对齐 cruise_15d 端口命名空间
-- cruise_15d.entry_ports/exit_ports 全为海港 UN/LOCODE（邮轮母港，无机场 IATA），
-- 而 078 只灌了机场 IATA，导致邮轮免签的口岸维度在选择器里永远无法满足。
-- 选择器命名空间须为政策端口的超集 → 把这些邮轮母港补进 visa_ports。
-- code 直接用政策里引用的 UN/LOCODE，引擎按 code 精确匹配。

INSERT INTO visa_ports (code, name_zh, name_en, display_order) VALUES
  ('CNTSN', '天津国际邮轮母港',     'Tianjin Cruise Home Port',      20),
  ('CNDLC', '大连国际邮轮中心',     'Dalian Cruise Center',          21),
  ('CNSHA', '上海吴淞口国际邮轮港', 'Shanghai Wusongkou Cruise Port',22),
  ('CNLYG', '连云港邮轮港',         'Lianyungang Cruise Port',       23),
  ('CNWNZ', '温州邮轮港',           'Wenzhou Cruise Port',           24),
  ('CNZOS', '舟山邮轮港',           'Zhoushan Cruise Port',          25),
  ('CNXMN', '厦门国际邮轮中心',     'Xiamen Cruise Center',          26),
  ('CNTAO', '青岛国际邮轮母港',     'Qingdao Cruise Home Port',      27),
  ('CNNSA', '广州南沙国际邮轮母港', 'Guangzhou Nansha Cruise Port',  28),
  ('CNSHK', '深圳蛇口太子湾邮轮母港','Shenzhen Shekou Cruise Port',  29),
  ('CNBHY', '北海国际邮轮母港',     'Beihai Cruise Home Port',       30),
  ('CNHKO', '海口邮轮港',           'Haikou Cruise Port',            31),
  ('CNSYA', '三亚凤凰岛国际邮轮港', 'Sanya Phoenix Island Cruise Port',32)
ON CONFLICT (code) DO UPDATE SET
  name_zh       = EXCLUDED.name_zh,
  name_en       = EXCLUDED.name_en,
  display_order = EXCLUDED.display_order;
