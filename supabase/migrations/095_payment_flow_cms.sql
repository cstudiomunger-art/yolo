-- Payment helper flow CMS (countries, cash_rules, flow_steps, rescue_rungs, node_texts)
-- + merchant/card extensions. Seed from prototype seed.py


CREATE TABLE IF NOT EXISTS payment_countries (
  country_code    TEXT PRIMARY KEY,
  flag_emoji      TEXT NOT NULL DEFAULT '',
  name_zh         TEXT NOT NULL,
  name_en         TEXT NOT NULL DEFAULT '',
  sms_tone        TEXT NOT NULL DEFAULT 'ok',
  reg_method      TEXT NOT NULL DEFAULT 'phone',
  sms_advice_zh   TEXT NOT NULL DEFAULT '',
  sms_advice_en   TEXT NOT NULL DEFAULT '',
  enabled         BOOLEAN NOT NULL DEFAULT TRUE,
  opt_order       INT NOT NULL DEFAULT 0,
  is_active       BOOLEAN NOT NULL DEFAULT TRUE,
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS payment_cash_rules (
  trip_type       TEXT PRIMARY KEY,
  label_zh        TEXT NOT NULL,
  label_en        TEXT NOT NULL DEFAULT '',
  amount_md_zh    TEXT NOT NULL DEFAULT '',
  amount_md_en    TEXT NOT NULL DEFAULT '',
  note_zh         TEXT NOT NULL DEFAULT '',
  note_en         TEXT NOT NULL DEFAULT '',
  opt_order       INT NOT NULL DEFAULT 0,
  is_active       BOOLEAN NOT NULL DEFAULT TRUE,
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS payment_flow_steps (
  id                  TEXT PRIMARY KEY,
  tool                TEXT NOT NULL DEFAULT '',
  node_key            TEXT NOT NULL,
  step_order          INT NOT NULL DEFAULT 0,
  title_zh            TEXT NOT NULL,
  title_en            TEXT NOT NULL DEFAULT '',
  instruction_md_zh   TEXT NOT NULL DEFAULT '',
  instruction_md_en   TEXT NOT NULL DEFAULT '',
  screenshot_url      TEXT NOT NULL DEFAULT '',
  fail_reasons        JSONB NOT NULL DEFAULT '[]'::jsonb,
  stability_tier      TEXT NOT NULL DEFAULT 'stable',
  is_active           BOOLEAN NOT NULL DEFAULT TRUE,
  updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS payment_rescue_rungs (
  id              TEXT PRIMARY KEY,
  rung_order      INT NOT NULL DEFAULT 0,
  title_zh        TEXT NOT NULL,
  title_en        TEXT NOT NULL DEFAULT '',
  subtitle_zh     TEXT NOT NULL DEFAULT '',
  subtitle_en     TEXT NOT NULL DEFAULT '',
  detail_md_zh    TEXT NOT NULL DEFAULT '',
  detail_md_en    TEXT NOT NULL DEFAULT '',
  applies         TEXT NOT NULL DEFAULT 'always',
  is_active       BOOLEAN NOT NULL DEFAULT TRUE,
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS payment_node_texts (
  id          TEXT PRIMARY KEY,
  node_key    TEXT NOT NULL,
  slot        TEXT NOT NULL,
  text_zh     TEXT NOT NULL,
  text_en     TEXT NOT NULL DEFAULT '',
  tone        TEXT,
  ord         INT NOT NULL DEFAULT 0,
  is_active   BOOLEAN NOT NULL DEFAULT TRUE,
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE payment_merchant_phrases ADD COLUMN IF NOT EXISTS speakable BOOLEAN NOT NULL DEFAULT TRUE;
ALTER TABLE payment_merchant_phrases ADD COLUMN IF NOT EXISTS audio_url TEXT NOT NULL DEFAULT '';

ALTER TABLE payment_card_networks ADD COLUMN IF NOT EXISTS note_zh TEXT NOT NULL DEFAULT '';
ALTER TABLE payment_card_networks ADD COLUMN IF NOT EXISTS note_en TEXT NOT NULL DEFAULT '';
UPDATE payment_card_networks SET note_zh = note WHERE note_zh = '' AND note IS NOT NULL AND note <> '';

DO $policy$
DECLARE t TEXT;
BEGIN
  EXECUTE format('ALTER TABLE %I ENABLE ROW LEVEL SECURITY', 'payment_countries');
  EXECUTE format('DROP POLICY IF EXISTS %I ON %I', 'Public read payment_countries', 'payment_countries');
  EXECUTE format('CREATE POLICY %I ON %I FOR SELECT USING (is_active = TRUE OR public.is_admin())', 'Public read payment_countries', 'payment_countries');
  EXECUTE format('DROP POLICY IF EXISTS %I ON %I', 'Admin insert payment_countries', 'payment_countries');
  EXECUTE format('CREATE POLICY %I ON %I FOR INSERT TO authenticated WITH CHECK (public.is_admin())', 'Admin insert payment_countries', 'payment_countries');
  EXECUTE format('DROP POLICY IF EXISTS %I ON %I', 'Admin update payment_countries', 'payment_countries');
  EXECUTE format('CREATE POLICY %I ON %I FOR UPDATE TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin())', 'Admin update payment_countries', 'payment_countries');
  EXECUTE format('DROP POLICY IF EXISTS %I ON %I', 'Admin delete payment_countries', 'payment_countries');
  EXECUTE format('CREATE POLICY %I ON %I FOR DELETE TO authenticated USING (public.is_admin())', 'Admin delete payment_countries', 'payment_countries');
  EXECUTE format('ALTER TABLE %I ENABLE ROW LEVEL SECURITY', 'payment_cash_rules');
  EXECUTE format('DROP POLICY IF EXISTS %I ON %I', 'Public read payment_cash_rules', 'payment_cash_rules');
  EXECUTE format('CREATE POLICY %I ON %I FOR SELECT USING (is_active = TRUE OR public.is_admin())', 'Public read payment_cash_rules', 'payment_cash_rules');
  EXECUTE format('DROP POLICY IF EXISTS %I ON %I', 'Admin insert payment_cash_rules', 'payment_cash_rules');
  EXECUTE format('CREATE POLICY %I ON %I FOR INSERT TO authenticated WITH CHECK (public.is_admin())', 'Admin insert payment_cash_rules', 'payment_cash_rules');
  EXECUTE format('DROP POLICY IF EXISTS %I ON %I', 'Admin update payment_cash_rules', 'payment_cash_rules');
  EXECUTE format('CREATE POLICY %I ON %I FOR UPDATE TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin())', 'Admin update payment_cash_rules', 'payment_cash_rules');
  EXECUTE format('DROP POLICY IF EXISTS %I ON %I', 'Admin delete payment_cash_rules', 'payment_cash_rules');
  EXECUTE format('CREATE POLICY %I ON %I FOR DELETE TO authenticated USING (public.is_admin())', 'Admin delete payment_cash_rules', 'payment_cash_rules');
  EXECUTE format('ALTER TABLE %I ENABLE ROW LEVEL SECURITY', 'payment_flow_steps');
  EXECUTE format('DROP POLICY IF EXISTS %I ON %I', 'Public read payment_flow_steps', 'payment_flow_steps');
  EXECUTE format('CREATE POLICY %I ON %I FOR SELECT USING (is_active = TRUE OR public.is_admin())', 'Public read payment_flow_steps', 'payment_flow_steps');
  EXECUTE format('DROP POLICY IF EXISTS %I ON %I', 'Admin insert payment_flow_steps', 'payment_flow_steps');
  EXECUTE format('CREATE POLICY %I ON %I FOR INSERT TO authenticated WITH CHECK (public.is_admin())', 'Admin insert payment_flow_steps', 'payment_flow_steps');
  EXECUTE format('DROP POLICY IF EXISTS %I ON %I', 'Admin update payment_flow_steps', 'payment_flow_steps');
  EXECUTE format('CREATE POLICY %I ON %I FOR UPDATE TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin())', 'Admin update payment_flow_steps', 'payment_flow_steps');
  EXECUTE format('DROP POLICY IF EXISTS %I ON %I', 'Admin delete payment_flow_steps', 'payment_flow_steps');
  EXECUTE format('CREATE POLICY %I ON %I FOR DELETE TO authenticated USING (public.is_admin())', 'Admin delete payment_flow_steps', 'payment_flow_steps');
  EXECUTE format('ALTER TABLE %I ENABLE ROW LEVEL SECURITY', 'payment_rescue_rungs');
  EXECUTE format('DROP POLICY IF EXISTS %I ON %I', 'Public read payment_rescue_rungs', 'payment_rescue_rungs');
  EXECUTE format('CREATE POLICY %I ON %I FOR SELECT USING (is_active = TRUE OR public.is_admin())', 'Public read payment_rescue_rungs', 'payment_rescue_rungs');
  EXECUTE format('DROP POLICY IF EXISTS %I ON %I', 'Admin insert payment_rescue_rungs', 'payment_rescue_rungs');
  EXECUTE format('CREATE POLICY %I ON %I FOR INSERT TO authenticated WITH CHECK (public.is_admin())', 'Admin insert payment_rescue_rungs', 'payment_rescue_rungs');
  EXECUTE format('DROP POLICY IF EXISTS %I ON %I', 'Admin update payment_rescue_rungs', 'payment_rescue_rungs');
  EXECUTE format('CREATE POLICY %I ON %I FOR UPDATE TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin())', 'Admin update payment_rescue_rungs', 'payment_rescue_rungs');
  EXECUTE format('DROP POLICY IF EXISTS %I ON %I', 'Admin delete payment_rescue_rungs', 'payment_rescue_rungs');
  EXECUTE format('CREATE POLICY %I ON %I FOR DELETE TO authenticated USING (public.is_admin())', 'Admin delete payment_rescue_rungs', 'payment_rescue_rungs');
  EXECUTE format('ALTER TABLE %I ENABLE ROW LEVEL SECURITY', 'payment_node_texts');
  EXECUTE format('DROP POLICY IF EXISTS %I ON %I', 'Public read payment_node_texts', 'payment_node_texts');
  EXECUTE format('CREATE POLICY %I ON %I FOR SELECT USING (is_active = TRUE OR public.is_admin())', 'Public read payment_node_texts', 'payment_node_texts');
  EXECUTE format('DROP POLICY IF EXISTS %I ON %I', 'Admin insert payment_node_texts', 'payment_node_texts');
  EXECUTE format('CREATE POLICY %I ON %I FOR INSERT TO authenticated WITH CHECK (public.is_admin())', 'Admin insert payment_node_texts', 'payment_node_texts');
  EXECUTE format('DROP POLICY IF EXISTS %I ON %I', 'Admin update payment_node_texts', 'payment_node_texts');
  EXECUTE format('CREATE POLICY %I ON %I FOR UPDATE TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin())', 'Admin update payment_node_texts', 'payment_node_texts');
  EXECUTE format('DROP POLICY IF EXISTS %I ON %I', 'Admin delete payment_node_texts', 'payment_node_texts');
  EXECUTE format('CREATE POLICY %I ON %I FOR DELETE TO authenticated USING (public.is_admin())', 'Admin delete payment_node_texts', 'payment_node_texts');
END
$policy$;

-- SEED: countries
INSERT INTO payment_countries (country_code,flag_emoji,name_zh,name_en,sms_tone,reg_method,sms_advice_zh,sms_advice_en,opt_order) VALUES ('jp','🇯🇵','日本','Japan','info','phone','短信会延迟 3–8 分钟，别狂点重发（会触发风控）。日韩运营商审核较严。','SMS arrives in 3–8 min — don''t spam resend (anti-fraud trigger).',1) ON CONFLICT (country_code) DO NOTHING;
INSERT INTO payment_countries (country_code,flag_emoji,name_zh,name_en,sms_tone,reg_method,sms_advice_zh,sms_advice_en,opt_order) VALUES ('kr','🇰🇷','韩国','South Korea','info','phone','运营商对国际短信审核较严，首次注册建议关闭垃圾短信过滤。','Carriers screen intl SMS strictly; turn off spam filter for first signup.',2) ON CONFLICT (country_code) DO NOTHING;
INSERT INTO payment_countries (country_code,flag_emoji,name_zh,name_en,sms_tone,reg_method,sms_advice_zh,sms_advice_en,opt_order) VALUES ('us','🇺🇸','美国','USA','ok','phone','主流运营商可正常收码；部分预付费卡（Mint 等）需联系客服开通国际短信。','Major carriers fine; some prepaid (Mint) need intl SMS enabled.',3) ON CONFLICT (country_code) DO NOTHING;
INSERT INTO payment_countries (country_code,flag_emoji,name_zh,name_en,sms_tone,reg_method,sms_advice_zh,sms_advice_en,opt_order) VALUES ('gb','🇬🇧','英国','UK','ok','phone','','',4) ON CONFLICT (country_code) DO NOTHING;
INSERT INTO payment_countries (country_code,flag_emoji,name_zh,name_en,sms_tone,reg_method,sms_advice_zh,sms_advice_en,opt_order) VALUES ('de','🇩🇪','德国','Germany','ok','phone','','',5) ON CONFLICT (country_code) DO NOTHING;
INSERT INTO payment_countries (country_code,flag_emoji,name_zh,name_en,sms_tone,reg_method,sms_advice_zh,sms_advice_en,opt_order) VALUES ('fr','🇫🇷','法国','France','ok','phone','','',6) ON CONFLICT (country_code) DO NOTHING;
INSERT INTO payment_countries (country_code,flag_emoji,name_zh,name_en,sms_tone,reg_method,sms_advice_zh,sms_advice_en,opt_order) VALUES ('sg','🇸🇬','新加坡','Singapore','ok','phone','','',7) ON CONFLICT (country_code) DO NOTHING;
INSERT INTO payment_countries (country_code,flag_emoji,name_zh,name_en,sms_tone,reg_method,sms_advice_zh,sms_advice_en,opt_order) VALUES ('my','🇲🇾','马来西亚','Malaysia','ok','phone','','',8) ON CONFLICT (country_code) DO NOTHING;
INSERT INTO payment_countries (country_code,flag_emoji,name_zh,name_en,sms_tone,reg_method,sms_advice_zh,sms_advice_en,opt_order) VALUES ('th','🇹🇭','泰国','Thailand','ok','phone','','',9) ON CONFLICT (country_code) DO NOTHING;
INSERT INTO payment_countries (country_code,flag_emoji,name_zh,name_en,sms_tone,reg_method,sms_advice_zh,sms_advice_en,opt_order) VALUES ('in','🇮🇳','印度','India','warn','email','运营商默认关闭国际短信，大概率收不到验证码 —— 直接用邮箱注册（Gmail/Outlook）。','Carriers block intl SMS by default — register with email (Gmail/Outlook).',10) ON CONFLICT (country_code) DO NOTHING;
INSERT INTO payment_countries (country_code,flag_emoji,name_zh,name_en,sms_tone,reg_method,sms_advice_zh,sms_advice_en,opt_order) VALUES ('br','🇧🇷','巴西','Brazil','warn','email','运营商默认关闭国际短信 —— 直接用邮箱注册。','Carriers block intl SMS by default — register with email.',11) ON CONFLICT (country_code) DO NOTHING;

-- UPDATE card network notes
UPDATE payment_card_networks SET note_zh='', note_en='' WHERE id='visa';
UPDATE payment_card_networks SET note_zh='', note_en='' WHERE id='mc';
UPDATE payment_card_networks SET note_zh='', note_en='' WHERE id='jcb';
UPDATE payment_card_networks SET note_zh='微信不收 Amex，这趟微信先别绑卡，主用支付宝。', note_en='WeChat doesn''t take Amex — use Alipay.' WHERE id='amex';
UPDATE payment_card_networks SET note_zh='微信不收银联外卡，主用支付宝。', note_en='WeChat doesn''t take foreign UnionPay — use Alipay.' WHERE id='unionpay';
UPDATE payment_card_networks SET note_zh='', note_en='' WHERE id='diners';
UPDATE payment_card_networks SET note_zh='', note_en='' WHERE id='discover';

-- SEED: cash_rules
INSERT INTO payment_cash_rules (trip_type,label_zh,label_en,amount_md_zh,amount_md_en,note_zh,note_en,opt_order) VALUES ('city','大城市为主','Cities mainly','带 **500–800 元** 现金兜底，拆成小面额（50/20/10/5）。','Carry **¥500–800** in small notes as backup.','','',1) ON CONFLICT (trip_type) DO NOTHING;
INSERT INTO payment_cash_rules (trip_type,label_zh,label_en,amount_md_zh,amount_md_en,note_zh,note_en,opt_order) VALUES ('both','城市 + 乡村都去','Cities + rural','城市段靠扫码，进偏远地区前务必备足 **1000–2000 元** 现金。按最“野”的那段准备。','Scan in cities, but stock **¥1000–2000** cash before rural legs.','','',2) ON CONFLICT (trip_type) DO NOTHING;
INSERT INTO payment_cash_rules (trip_type,label_zh,label_en,amount_md_zh,amount_md_en,note_zh,note_en,opt_order) VALUES ('remote','主要去乡村/偏远','Mostly remote','带 **2000 元以上** 现金，那里基本只收现金或个人收款码。','Carry **¥2000+**; remote areas often take cash or personal QR only.','','',3) ON CONFLICT (trip_type) DO NOTHING;
INSERT INTO payment_cash_rules (trip_type,label_zh,label_en,amount_md_zh,amount_md_en,note_zh,note_en,opt_order) VALUES ('family','家庭游/带老人小孩','Family trip','**1500–3000 元**，分散保管。','**¥1500–3000**, kept in separate places.','','',4) ON CONFLICT (trip_type) DO NOTHING;

-- SEED: flow_steps
INSERT INTO payment_flow_steps (id,tool,node_key,step_order,title_zh,instruction_md_zh,fail_reasons,stability_tier) VALUES ('install_alipay_1','alipay','install',1,'出发前下载支付宝','**务必在来中国前下载**（落地后可能上不了 Google Play、收不到验证码、网络不稳）。App Store / Google Play 搜 “Alipay”；或支付宝官方渠道 https://render.alipay.com/p/yuyan/180020040001212700/ ；也可扫官方二维码。安卓别装来路不明的 APK，可用华为 AppGallery 搜“支付宝”。','[]'::jsonb,'stable') ON CONFLICT (id) DO NOTHING;
INSERT INTO payment_flow_steps (id,tool,node_key,step_order,title_zh,instruction_md_zh,fail_reasons,stability_tier) VALUES ('install_wechat_1','wechat','install',1,'出发前下载微信','App Store / Google Play 搜 “WeChat”，或官方渠道 https://www.wechat.com/zh_CN 。注册前**关闭 VPN**，确保设备和网络安全可靠。','[]'::jsonb,'stable') ON CONFLICT (id) DO NOTHING;
INSERT INTO payment_flow_steps (id,tool,node_key,step_order,title_zh,instruction_md_zh,fail_reasons,stability_tier) VALUES ('register_alipay_1','alipay','register',1,'选择国家、填手机号','打开支付宝→注册，先选手机号所在国家（如美国 +1 输入 10 位纯数字、无需加 1），再填手机号。','[{"reason": "收不到验证码", "fix": "改用邮箱注册（选 Use Email，支持 Gmail/Outlook），或装支付宝国际版。"}, {"reason": "国家列表找不到我的国家", "fix": "选地理最近的替代国家（缅甸可选泰国 +66，需能收国际短信），或联系客服 +86-571-2688-6000（英语）。"}]'::jsonb,'stable') ON CONFLICT (id) DO NOTHING;
INSERT INTO payment_flow_steps (id,tool,node_key,step_order,title_zh,instruction_md_zh,fail_reasons,stability_tier) VALUES ('register_alipay_2','alipay','register',2,'切换到国际版','我的→设置→版本切换→切到**国际版**。','[]'::jsonb,'stable') ON CONFLICT (id) DO NOTHING;
INSERT INTO payment_flow_steps (id,tool,node_key,step_order,title_zh,instruction_md_zh,fail_reasons,stability_tier) VALUES ('register_alipay_3','alipay','register',3,'护照实名认证','按提示填姓名、护照号、有效期，上传护照照片或人脸验证。姓名严格按护照机读区拼音填（Zhang San 不要写 Zhangsan），不要用昵称。','[{"reason": "姓名顺序/空格/中间名不符", "fix": "按护照机读区填。"}, {"reason": "护照照片反光", "fix": "重新拍摄，避免反光遮挡。"}]'::jsonb,'stable') ON CONFLICT (id) DO NOTHING;
INSERT INTO payment_flow_steps (id,tool,node_key,step_order,title_zh,instruction_md_zh,fail_reasons,stability_tier) VALUES ('register_wechat_1','wechat','register',1,'注册微信','用可正常收码的境外手机号注册，或用 Facebook 账户注册。**一个手机号只能注册一个微信**。若提示需辅助注册：请一位老用户扫注册界面二维码协助，或走「验证银行卡」「验证并开通微信支付」方式完成。注册时勿用非官方版本、勿连 VPN。','[{"reason": "需要辅助注册", "fix": "请老用户扫码协助；或用验证银行卡/开通微信支付的方式注册。仍失败可走官方申诉通道。"}]'::jsonb,'stable') ON CONFLICT (id) DO NOTHING;
INSERT INTO payment_flow_steps (id,tool,node_key,step_order,title_zh,instruction_md_zh,fail_reasons,stability_tier) VALUES ('register_wechat_2','wechat','register',2,'护照实名 + 人脸识别','我→服务→钱包→实名认证→去认证。证件类型选 **护照**（不可选身份证）；姓名严格按护照拼音、证件号大写字母+数字、有效期需 ≥ 当前 + 6 个月。上传护照照片（四角入镜、**关美颜滤镜**、无反光）→ 人脸识别（朗读随机数字 + 眨眼）。','[{"reason": "证件信息不匹配", "fix": "核对姓名大小写/空格、证件号格式；有效期需≥6个月。"}, {"reason": "人脸识别未通过", "fix": "关美颜滤镜用原图；光线均匀、勿戴眼镜帽子；失败 3 次需等 24 小时。可走人工申诉（关键词“国际证件认证人工审核”）。"}]'::jsonb,'stable') ON CONFLICT (id) DO NOTHING;
INSERT INTO payment_flow_steps (id,tool,node_key,step_order,title_zh,instruction_md_zh,fail_reasons,stability_tier) VALUES ('bind_alipay_1','alipay','bind',1,'添加银行卡','我的→银行卡→添加，选 Visa / Mastercard / JCB / Discover / Diners Club，输入卡号、有效期、CVV、安全验证。支付宝现支持大多数主流国际卡。','[{"reason": "发卡行拒绝 / 3D Secure 失败", "fix": "联系银行开通中国大陆线上交易；换借记卡或换卡组织（Visa↔MC）。"}, {"reason": "账单地址不匹配", "fix": "核对账单地址，或换卡。"}]'::jsonb,'stable') ON CONFLICT (id) DO NOTHING;
INSERT INTO payment_flow_steps (id,tool,node_key,step_order,title_zh,instruction_md_zh,fail_reasons,stability_tier) VALUES ('bind_wechat_1','wechat','bind',1,'绑定银行卡','钱包→银行卡→添加，输完整卡号、持卡人姓名（**与护照完全一致**、大小写敏感）、**银行预留手机号（必须与微信绑定号码相同）**→接银行短信验证码→设 6 位支付密码（不可与银行卡取款密码相同）。**微信仅收 Visa / Mastercard / JCB**（银联、美国运通不可用）。','[{"reason": "绑卡失败", "fix": "换卡；确认是 Visa/MC/JCB；联系银行；确保银行预留手机号与微信号一致且可收短信。"}, {"reason": "支付密码错 3 次", "fix": "等 30 分钟再试。"}]'::jsonb,'stable') ON CONFLICT (id) DO NOTHING;
INSERT INTO payment_flow_steps (id,tool,node_key,step_order,title_zh,instruction_md_zh,fail_reasons,stability_tier) VALUES ('verify_alipay_1','alipay','verify',1,'验证通道（安全版）','我的→银行卡→管理→**验证卡片**（预授权 1 元、不扣款）；或把落地后第一笔真实小额消费当验证。无需做假订单。','[]'::jsonb,'stable') ON CONFLICT (id) DO NOTHING;
INSERT INTO payment_flow_steps (id,tool,node_key,step_order,title_zh,instruction_md_zh,fail_reasons,stability_tier) VALUES ('verify_alipay_2','alipay','verify',2,'（备选·易失效）滴滴 1 元测试','支付宝搜“滴滴出行”→登录→下测试单仅扣 1 元→立即取消全额退款，以此验证通道。','[{"reason": "退款未到账", "fix": "多为发卡行延迟（24h 内）；可找滴滴英文客服报交易号。"}]'::jsonb,'volatile') ON CONFLICT (id) DO NOTHING;
INSERT INTO payment_flow_steps (id,tool,node_key,step_order,title_zh,instruction_md_zh,fail_reasons,stability_tier) VALUES ('use_general_1','','use',1,'出示你的付款码给商家扫（优先）','打开支付宝/微信→点「Pay / 付款」（首次需验证支付密码或刷脸）→把你的**付款码**给商家扫→必要时输支付密码确认。这条通常最稳。','[]'::jsonb,'stable') ON CONFLICT (id) DO NOTHING;
INSERT INTO payment_flow_steps (id,tool,node_key,step_order,title_zh,instruction_md_zh,fail_reasons,stability_tier) VALUES ('use_general_2','','use',2,'扫商家的二维码','打开支付宝/微信→「扫一扫 / Scan」→扫商家收款码→输入金额→确认支付。','[{"reason": "扫码后无法付款", "fix": "商家可能是个人收款码、不支持外卡 —— 改让商家扫你的付款码，或换另一个 App，或用现金。"}, {"reason": "页面全是中文", "fix": "用手机系统翻译/截图翻译，或请酒店/商家协助。"}]'::jsonb,'stable') ON CONFLICT (id) DO NOTHING;
INSERT INTO payment_flow_steps (id,tool,node_key,step_order,title_zh,instruction_md_zh,fail_reasons,stability_tier) VALUES ('trouble_general_1','','trouble',1,'发卡行拒绝','打开你的银行 App 确认交易，或联系客服说“需开通中国大陆线上交易”。换另一张卡也行。','[]'::jsonb,'stable') ON CONFLICT (id) DO NOTHING;
INSERT INTO payment_flow_steps (id,tool,node_key,step_order,title_zh,instruction_md_zh,fail_reasons,stability_tier) VALUES ('trouble_general_2','','trouble',2,'姓名 / 空格不符','严格按护照拼音填，例：护照 **Zhang San** 就别写 **Zhangsan**。','[]'::jsonb,'stable') ON CONFLICT (id) DO NOTHING;
INSERT INTO payment_flow_steps (id,tool,node_key,step_order,title_zh,instruction_md_zh,fail_reasons,stability_tier) VALUES ('trouble_general_3','','trouble',3,'3D 验证失败','换一张借记卡，或换不同卡组织（Visa↔Mastercard）。','[]'::jsonb,'stable') ON CONFLICT (id) DO NOTHING;
INSERT INTO payment_flow_steps (id,tool,node_key,step_order,title_zh,instruction_md_zh,fail_reasons,stability_tier) VALUES ('china_general_1','','china',1,'先有现金兜底','落地先确保有现金：机场或市区大型银行 ATM（认 Visa/MC/UnionPay/JCB 标识，中行/工行/建行/农行/招行更可靠）取现。跳过所有“出发前 X 天”的建议。','[]'::jsonb,'stable') ON CONFLICT (id) DO NOTHING;
INSERT INTO payment_flow_steps (id,tool,node_key,step_order,title_zh,instruction_md_zh,fail_reasons,stability_tier) VALUES ('china_general_2','','china',2,'再慢慢绑卡','有现金兜底后，再按 注册→绑卡→验证 一步步把支付宝/微信弄好，不慌。','[]'::jsonb,'stable') ON CONFLICT (id) DO NOTHING;

-- SEED: rescue_rungs
INSERT INTO payment_rescue_rungs (id,rung_order,title_zh,title_en,subtitle_zh,subtitle_en,detail_md_zh,detail_md_en,applies) VALUES ('rescue_1',1,'换个动作','Switch action','让商家扫你，而不是你扫商家','Let them scan you','打开你自己的 **付款码** 给店员扫。很多失败只因商家是个人收款码、不支持外卡。','Show your own **payment code** for the clerk to scan. Many failures are just personal-QR merchants.','always') ON CONFLICT (id) DO NOTHING;
INSERT INTO payment_rescue_rungs (id,rung_order,title_zh,title_en,subtitle_zh,subtitle_en,detail_md_zh,detail_md_en,applies) VALUES ('rescue_2',2,'换个 App','Switch app','支付宝 ↔ 微信','Alipay ↔ WeChat','支付宝失败试微信；微信失败试支付宝。','If Alipay fails try WeChat, and vice versa.','wx_only') ON CONFLICT (id) DO NOTHING;
INSERT INTO payment_rescue_rungs (id,rung_order,title_zh,title_en,subtitle_zh,subtitle_en,detail_md_zh,detail_md_en,applies) VALUES ('rescue_3',3,'换张卡 / 拆小额','Switch card / split','另一张不同银行的卡','A different bank''s card','大额失败可拆两笔（1200 = 600+600），或在 App 里换绑另一张卡。','Split a large amount (1200 = 600+600), or switch to another linked card.','always') ON CONFLICT (id) DO NOTHING;
INSERT INTO payment_rescue_rungs (id,rung_order,title_zh,title_en,subtitle_zh,subtitle_en,detail_md_zh,detail_md_en,applies) VALUES ('rescue_4',4,'联系发卡银行','Call your bank','确认有没有被风控拦','Check for a fraud block','打开银行 App 看是否有风控拦截；必要时联系客服，说明你正在中国旅行、需开通中国大陆交易。','Open your bank app for a fraud block; call them to enable China transactions if needed.','always') ON CONFLICT (id) DO NOTHING;
INSERT INTO payment_rescue_rungs (id,rung_order,title_zh,title_en,subtitle_zh,subtitle_en,detail_md_zh,detail_md_en,applies) VALUES ('rescue_5',5,'用现金','Use cash','永远的兜底','The ultimate fallback','小商户/夜市/个人码搞不定时现金最现实，每天随身 100–300 元小面额。','Cash is the realest fallback at stalls/night markets — carry ¥100–300 small notes daily.','always') ON CONFLICT (id) DO NOTHING;

-- SEED: merchant_phrases
INSERT INTO payment_merchant_phrases (id,cn,en,sort_order,speakable) VALUES ('mphrase_1','可以用支付宝吗？','Can I pay with Alipay?',0,TRUE) ON CONFLICT (id) DO UPDATE SET cn=EXCLUDED.cn, en=EXCLUDED.en, sort_order=EXCLUDED.sort_order, speakable=EXCLUDED.speakable;
INSERT INTO payment_merchant_phrases (id,cn,en,sort_order,speakable) VALUES ('mphrase_2','可以用微信支付吗？','Can I pay with WeChat Pay?',1,TRUE) ON CONFLICT (id) DO UPDATE SET cn=EXCLUDED.cn, en=EXCLUDED.en, sort_order=EXCLUDED.sort_order, speakable=EXCLUDED.speakable;
INSERT INTO payment_merchant_phrases (id,cn,en,sort_order,speakable) VALUES ('mphrase_3','请扫我的付款码。','Please scan my payment code.',2,TRUE) ON CONFLICT (id) DO UPDATE SET cn=EXCLUDED.cn, en=EXCLUDED.en, sort_order=EXCLUDED.sort_order, speakable=EXCLUDED.speakable;
INSERT INTO payment_merchant_phrases (id,cn,en,sort_order,speakable) VALUES ('mphrase_4','我可以扫你的二维码付款吗？','Can I scan your QR code to pay?',3,TRUE) ON CONFLICT (id) DO UPDATE SET cn=EXCLUDED.cn, en=EXCLUDED.en, sort_order=EXCLUDED.sort_order, speakable=EXCLUDED.speakable;
INSERT INTO payment_merchant_phrases (id,cn,en,sort_order,speakable) VALUES ('mphrase_5','可以用现金吗？','Can I pay with cash?',4,TRUE) ON CONFLICT (id) DO UPDATE SET cn=EXCLUDED.cn, en=EXCLUDED.en, sort_order=EXCLUDED.sort_order, speakable=EXCLUDED.speakable;
INSERT INTO payment_merchant_phrases (id,cn,en,sort_order,speakable) VALUES ('mphrase_6','可以刷 Visa 或 Mastercard 吗？','Do you take Visa or Mastercard?',5,TRUE) ON CONFLICT (id) DO UPDATE SET cn=EXCLUDED.cn, en=EXCLUDED.en, sort_order=EXCLUDED.sort_order, speakable=EXCLUDED.speakable;
INSERT INTO payment_merchant_phrases (id,cn,en,sort_order,speakable) VALUES ('mphrase_7','支付失败了，我换一种方式。','Payment failed, let me try another way.',6,TRUE) ON CONFLICT (id) DO UPDATE SET cn=EXCLUDED.cn, en=EXCLUDED.en, sort_order=EXCLUDED.sort_order, speakable=EXCLUDED.speakable;
INSERT INTO payment_merchant_phrases (id,cn,en,sort_order,speakable) VALUES ('mphrase_8','可以分两笔支付吗？','Can I split it into two payments?',7,TRUE) ON CONFLICT (id) DO UPDATE SET cn=EXCLUDED.cn, en=EXCLUDED.en, sort_order=EXCLUDED.sort_order, speakable=EXCLUDED.speakable;
INSERT INTO payment_merchant_phrases (id,cn,en,sort_order,speakable) VALUES ('mphrase_9','请帮我写下金额。','Could you write down the amount?',8,TRUE) ON CONFLICT (id) DO UPDATE SET cn=EXCLUDED.cn, en=EXCLUDED.en, sort_order=EXCLUDED.sort_order, speakable=EXCLUDED.speakable;

-- SEED: node_texts
INSERT INTO payment_node_texts (id,node_key,slot,text_zh,text_en,tone,ord) VALUES ('home_h1_0','home','h1','你现在的处境？','Where are you right now?',NULL,0) ON CONFLICT (id) DO NOTHING;
INSERT INTO payment_node_texts (id,node_key,slot,text_zh,text_en,tone,ord) VALUES ('home_intro_0','home','intro','我们不先问“你想干嘛”，先问“你在哪个时刻”——最慌的人能一秒拿到帮助。','We ask when you are, not what you want — the most anxious get help in one tap.',NULL,0) ON CONFLICT (id) DO NOTHING;
INSERT INTO payment_node_texts (id,node_key,slot,text_zh,text_en,tone,ord) VALUES ('q1_h1_0','q1','h1','你从哪个国家来？','Which country are you from?',NULL,0) ON CONFLICT (id) DO NOTHING;
INSERT INTO payment_node_texts (id,node_key,slot,text_zh,text_en,tone,ord) VALUES ('q1_intro_0','q1','intro','这一个答案，就替你把那张“几十国短信表”剪成只属于你的一行。','This one answer trims a dozens-of-countries SMS table down to your single line.',NULL,0) ON CONFLICT (id) DO NOTHING;
INSERT INTO payment_node_texts (id,node_key,slot,text_zh,text_en,tone,ord) VALUES ('q2_h1_0','q2','h1','你有哪些卡？','Which cards do you have?',NULL,0) ON CONFLICT (id) DO NOTHING;
INSERT INTO payment_node_texts (id,node_key,slot,text_zh,text_en,tone,ord) VALUES ('q2_intro_0','q2','intro','决定哪条路走得通。比如只有 Amex/银联，我们会直接让你跳过微信绑卡。','Decides which path works. Amex/UnionPay only → we skip WeChat binding for you.',NULL,0) ON CONFLICT (id) DO NOTHING;
INSERT INTO payment_node_texts (id,node_key,slot,text_zh,text_en,tone,ord) VALUES ('q3_h1_0','q3','h1','这趟主要去哪？','Where are you mainly going?',NULL,0) ON CONFLICT (id) DO NOTHING;
INSERT INTO payment_node_texts (id,node_key,slot,text_zh,text_en,tone,ord) VALUES ('q3_intro_0','q3','intro','决定你要带多少现金、要不要强调“偏远地区只收现金”。','Decides how much cash and whether to stress ''remote areas take cash only''.',NULL,0) ON CONFLICT (id) DO NOTHING;
INSERT INTO payment_node_texts (id,node_key,slot,text_zh,text_en,tone,ord) VALUES ('plan_h1_0','plan','h1','为你一个人裁好的','Your personalized plan',NULL,0) ON CONFLICT (id) DO NOTHING;
INSERT INTO payment_node_texts (id,node_key,slot,text_zh,text_en,tone,ord) VALUES ('install_h1_0','install','h1','装两个主 App','Install Alipay + WeChat',NULL,0) ON CONFLICT (id) DO NOTHING;
INSERT INTO payment_node_texts (id,node_key,slot,text_zh,text_en,tone,ord) VALUES ('install_callout_0','install','callout','务必出发前装！到了中国可能上不了 Google Play、收不到验证码。','Install before you fly — Google Play / SMS may not work in China.','warm',0) ON CONFLICT (id) DO NOTHING;
INSERT INTO payment_node_texts (id,node_key,slot,text_zh,text_en,tone,ord) VALUES ('register_h1_0','register','h1','注册并实名','Register & verify identity',NULL,0) ON CONFLICT (id) DO NOTHING;
INSERT INTO payment_node_texts (id,node_key,slot,text_zh,text_en,tone,ord) VALUES ('bind_h1_0','bind','h1','绑定银行卡','Add your bank card',NULL,0) ON CONFLICT (id) DO NOTHING;
INSERT INTO payment_node_texts (id,node_key,slot,text_zh,text_en,tone,ord) VALUES ('bind_intro_0','bind','intro','主线只有一条直线：填卡号 → 短信验证 → 完成。顺利的话三步就好。','One straight line: card number → SMS code → done.',NULL,0) ON CONFLICT (id) DO NOTHING;
INSERT INTO payment_node_texts (id,node_key,slot,text_zh,text_en,tone,ord) VALUES ('verify_h1_0','verify','h1','验证一下通道','Verify the channel — the safe way',NULL,0) ON CONFLICT (id) DO NOTHING;
INSERT INTO payment_node_texts (id,node_key,slot,text_zh,text_en,tone,ord) VALUES ('verify_callout_0','verify','callout','安全版：不用做假订单。用支付宝官方“验证卡片”（预授权 1 元、不扣款），或把落地后第一笔真实小额消费当验证。','Safe way: no fake orders. Use Alipay''s official ''verify card'' (¥1 pre-auth, not charged), or your first real small purchase.','jade',0) ON CONFLICT (id) DO NOTHING;
INSERT INTO payment_node_texts (id,node_key,slot,text_zh,text_en,tone,ord) VALUES ('use_h1_0','use','h1','怎么付款','How to pay',NULL,0) ON CONFLICT (id) DO NOTHING;
INSERT INTO payment_node_texts (id,node_key,slot,text_zh,text_en,tone,ord) VALUES ('use_intro_0','use','intro','两招：优先出示你的付款码给商家扫；不行就扫商家的码。失败别慌，去“救援”一步步换。','Two moves: show your code first; otherwise scan theirs. If it fails, step down the rescue ladder.',NULL,0) ON CONFLICT (id) DO NOTHING;
INSERT INTO payment_node_texts (id,node_key,slot,text_zh,text_en,tone,ord) VALUES ('card_h1_0','card','h1','你的随身支付卡','Your pocket payment card',NULL,0) ON CONFLICT (id) DO NOTHING;
INSERT INTO payment_node_texts (id,node_key,slot,text_zh,text_en,tone,ord) VALUES ('china_h1_0','china','h1','你已经落地了','You''re already in China',NULL,0) ON CONFLICT (id) DO NOTHING;
INSERT INTO payment_node_texts (id,node_key,slot,text_zh,text_en,tone,ord) VALUES ('china_callout_0','china','callout','跳过所有“出发前 X 天”的建议。现在最稳的一步是先有现金兜底，再慢慢绑卡。','Skip all ''X days before'' advice. Get cash backup first, then bind cards.','default',0) ON CONFLICT (id) DO NOTHING;
INSERT INTO payment_node_texts (id,node_key,slot,text_zh,text_en,tone,ord) VALUES ('rescue_h1_0','rescue','h1','别慌，一步步换','Stay calm — step down the ladder',NULL,0) ON CONFLICT (id) DO NOTHING;
INSERT INTO payment_node_texts (id,node_key,slot,text_zh,text_en,tone,ord) VALUES ('merchant_h1_0','merchant','h1','给商家看','Show the merchant',NULL,0) ON CONFLICT (id) DO NOTHING;

-- SEED: additional articles
INSERT INTO payment_articles (id,node_key,title_zh,body_md_zh,display_order,is_published) VALUES ('alipay_bind_guide','bind','支付宝绑卡详细图文','# 支付宝：注册 + 实名 + 绑卡（图文）

出发前在家一次走通，落地直接扫码。

## 先准备好
- 能收短信的国际手机号（优先主流运营商）
- 两张不同银行的卡（一张信用卡 + 一张借记卡）：Visa / Mastercard / JCB / Discover / Diners Club
- 护照原件或清晰无反光照片（有效期 ≥ 6 个月）
- 备用：Gmail / Outlook 邮箱（收不到短信时改邮箱注册）

## 步骤
1. **注册**：选手机号所在国家 → 填号 → 收验证码（收不到就用邮箱注册）。
2. **切国际版**：我的 → 设置 → 版本切换 → 国际版。
3. **护照实名**：按机读区填姓名（`Zhang San` 不要写 `Zhangsan`）→ 上传护照 → 人脸识别。
4. **添加银行卡**：我的 → 银行卡 → 添加 → 输卡号/有效期/CVV → 安全验证。
5. **验证通道**：管理 → “验证卡片”（预授权 1 元、不扣款）。

> 在编辑器里点「🖼 插入图片」直传每一步截图。
',1,TRUE) ON CONFLICT (id) DO NOTHING;
INSERT INTO payment_articles (id,node_key,title_zh,body_md_zh,display_order,is_published) VALUES ('wechat_bind_guide','bind','微信绑卡详细图文','# 微信：注册 + 实名 + 绑卡（图文）

## 先准备好
- 关闭 VPN，网络安全可靠
- 能收短信的境外手机号
- 银行卡：**仅支持 Visa / Mastercard / JCB**（银联、美国运通不可用）；**银行预留手机号必须与微信绑定号码一致**
- 护照（有效期 ≥ 6 个月）

## 步骤
1. **注册**：用手机号或 Facebook 账户注册。一个手机号只能注册一个微信。提示辅助注册时，请老用户扫码协助，或走“验证银行卡 / 开通微信支付”。
2. **实名**：我 → 服务 → 钱包 → 实名认证 → 证件类型选**护照** → 按格式填姓名与证件号 → 上传护照（关美颜、四角入镜）→ 人脸识别。
3. **绑卡**：钱包 → 银行卡 → 添加 → 卡号 + 持卡人姓名（与护照一致）+ 银行预留手机号 → 短信验证码 → 设 6 位支付密码。

## 认证后能/不能做什么
- 能：扫码消费、线上消费、查零钱。
- 不能：个人转账/红包、提现到银行卡、绑中国内地卡。
',2,TRUE) ON CONFLICT (id) DO NOTHING;
INSERT INTO payment_articles (id,node_key,title_zh,body_md_zh,display_order,is_published) VALUES ('how_to_pay','use','如何用支付宝 / 微信付款（图文）','# 怎么付款

## 方法一：出示你的付款码给商家扫（优先）
1. 打开支付宝/微信 → 点「Pay / 付款」（微信在首页右上角“+”→ Money）。
2. 首次使用需验证支付密码或刷脸。
3. 把你的付款码给商家扫，必要时输支付密码确认。

## 方法二：扫商家的二维码
1. 打开 App →「扫一扫 / Scan」。
2. 扫商家收款码 → 输入金额 → 确认支付。

## 付不了时
- 扫码失败 → 让商家扫你的付款码。
- 还不行 → 换另一个 App（支付宝 ↔ 微信）。
- 都不行 → 用现金。
- 个人收款码常不支持海外卡，这很常见，不是你的问题。
',3,TRUE) ON CONFLICT (id) DO NOTHING;
INSERT INTO payment_articles (id,node_key,title_zh,body_md_zh,display_order,is_published) VALUES ('pre_trip_checklist','plan','出发前 10 分钟自检清单','# 出发前 10 分钟自检

出发前确认：
- [ ] 支付宝已安装并能打开
- [ ] 微信已安装并能正常登录
- [ ] 两个 App 至少各绑一张卡，或至少一个 App 已成功绑卡
- [ ] 银行卡已开通海外交易
- [ ] 知道银行 App 或客服电话在哪
- [ ] 准备了至少 500 元人民币现金，或知道落地后在哪取
- [ ] 手机能在中国上网（eSIM/漫游/本地 SIM）
- [ ] 酒店、高铁、热门景点、接送机等关键项目已尽量预付
- [ ] 护照信息和所有预订信息一致

> 最重要的原则：**不要让任何一种支付方式成为你的唯一选择。**
',4,TRUE) ON CONFLICT (id) DO NOTHING;
INSERT INTO payment_articles (id,node_key,title_zh,body_md_zh,display_order,is_published) VALUES ('limits_fees','plan','支付限额与手续费','# 支付限额与手续费

官方信息：面向海外游客的移动支付**单笔限额已从 1,000 美元提高到 5,000 美元**，**年度累计从 10,000 美元提高到 50,000 美元**。

仍需注意：
- **平台限额**：支付宝/微信按身份认证、银行卡、风险等级显示不同限制。
- **银行限额**：发卡行可能有单笔/单日/境外交易限制。
- **商户限制**：有些商户码不支持海外卡。
- **手续费**：部分海外卡交易可能有服务费，付款页会显示，不要假设全免费。
- **汇率**：由卡组织/发卡行/平台按当时规则结算，以账单和支付页为准。

> 大额订单（酒店长住、包车、医疗、购物、高端餐厅）建议提前通知发卡行，并备用卡或让旅行社/酒店协助预付。具体数字以官方与支付页为准。
',5,TRUE) ON CONFLICT (id) DO NOTHING;
INSERT INTO payment_articles (id,node_key,title_zh,body_md_zh,display_order,is_published) VALUES ('physical_cards','plan','该带哪些实体卡','# 除支付宝/微信外，建议带哪些实体卡

| 卡组织 | 在中国大陆可用性 | 建议 |
|---|---|---|
| 银联 UnionPay | 最高 | 本国银行能发就带，来华更方便 |
| Visa | 中 | 必带，但别当唯一方式 |
| Mastercard | 中 | 与 Visa 搭配 |
| JCB | 中低到中 | 对日本游客有用，覆盖有限 |
| American Express | 中低 | 高端酒店/国际品牌较可能支持 |
| Diners / Discover | 低到中 | 覆盖有限，作补充 |

**容易刷卡的地方**：国际品牌/五星酒店、机场免税店、航司柜台、高端商场、部分大景区窗口、大医院国际部、部分火车站人工窗口。

**不可靠的地方**：普通餐馆、小超市小卖部、路边摊夜市菜市场、小民宿客栈、偏远景区小交通。

**刷卡失败**：没有外卡 POS → 改扫码/现金；只支持银联 → 换银联卡；风控拒付 → 银行 App 确认或联系银行；需要 PIN → 出发前设好；押金预授权失败 → 换信用卡/现金押金/OTA 预付；DCC 汇率不好 → 选以人民币 CNY 结算。
',6,TRUE) ON CONFLICT (id) DO NOTHING;
INSERT INTO payment_articles (id,node_key,title_zh,body_md_zh,display_order,is_published) VALUES ('cash_guide','plan','现金怎么准备、在哪取','# 现金怎么准备

## 带多少（参考）
| 旅行类型 | 建议现金 |
|---|---|
| 一线城市 3–5 天 | 500–800 元 |
| 7–14 天多城市 | 1000–1500 元 |
| 家庭游/带老人小孩 | 1500–3000 元，分散保管 |
| 小城镇/乡村/偏远 | 2000 元以上 |

建议把整百拆成 50 + 20 + 10×2 + 5×2 等小面额。不要带过多现金；大额现金入境请提前查中国海关与本国海关申报规定。

## 在哪取
- **机场 ATM**（高）：落地最方便，找有 Visa/MC/UnionPay/JCB 标识的。
- **市区大型银行 ATM**（高）：中行/工行/建行/农行/招行更可靠。
- 本国提前兑换（中）、机场人工兑换（中低）、酒店换汇（低）、私人换汇（不推荐）。

## 什么时候最有用
手机没电没网、支付宝/微信触发风控、路边摊夜市个人码、偏远小交通停车费、小额临时费用。
',7,TRUE) ON CONFLICT (id) DO NOTHING;
INSERT INTO payment_articles (id,node_key,title_zh,body_md_zh,display_order,is_published) VALUES ('prepay_online','plan','线上预付清单（避免现场付款失败）','# 线上预付：避免到现场付款失败

建议尽量提前预订或预付：

| 项目 | 推荐平台 | 为什么提前 |
|---|---|---|
| 酒店 | Trip.com / Booking / Agoda / Expedia / 官网 | 避免到店外卡/押金失败 |
| 高铁票 | Trip.com / 12306 英文版 | 热门线路售罄快，护照购票需时间 |
| 景点门票 | Trip.com / Klook / 景区官方英文站 | 很多需实名预约，中国手机号是卡点 |
| 接送机/包车 | Trip.com / Klook / 正规旅行社 | 避免机场临时叫车失败 |
| eSIM/流量 | Trip.com / Airalo / Nomad / Holafly | 落地没网会影响所有支付 |
| 一日游/导览 | Klook / Trip.com / GetYourGuide / Viator | 可用外卡提前付 |

> 若某景点小程序必须中国手机号/身份证，优先看 Trip.com/Klook 有没有可购产品，或请酒店前台、旅行社、中国朋友协助。
',8,TRUE) ON CONFLICT (id) DO NOTHING;
INSERT INTO payment_articles (id,node_key,title_zh,body_md_zh,display_order,is_published) VALUES ('scene_guide','plan','常见消费场景怎么付','# 常见消费场景应该怎么付

| 场景 | 首选 | 备用 |
|---|---|---|
| 机场到酒店 | 支付宝内滴滴 / 机场出租 / Trip.com 接送机 | 现金、实体卡 |
| 国际酒店 | 预付订单 + 实体信用卡押金 | 支付宝/微信、现金押金 |
| 普通餐厅 | 支付宝/微信扫码 | 现金 |
| 连锁咖啡/便利店 | 支付宝/微信付款码 | 实体卡、现金 |
| 路边摊/夜市 | 支付宝/微信扫码 | 现金 |
| 高铁票 | Trip.com/12306 提前买 | 车站窗口、现金、银行卡 |
| 景点门票 | 官方渠道、Trip.com/Klook | 现场窗口、酒店/旅行社协助 |
| 地铁公交 | 支付宝/微信乘车码、城市交通卡 | 现金、交通卡 |
| 打车 | 支付宝/微信内滴滴 | 正规出租现金 |
| 医院/药店 | 支付宝/微信、银行卡 | 现金 |
| 民宿/客栈 | 平台预付 | 支付宝/微信、现金 |
| 购物商场 | 支付宝/微信 | 实体卡、现金 |
',9,TRUE) ON CONFLICT (id) DO NOTHING;
INSERT INTO payment_articles (id,node_key,title_zh,body_md_zh,display_order,is_published) VALUES ('faq','home','常见问题 FAQ','# 常见问题

**没有中国手机号能用支付宝/微信吗？** 通常可以，国际手机号能收短信即可；但景点预约、外卖、部分小程序可能仍要中国手机号。

**能只带 Visa/Mastercard 吗？** 不建议。普通餐馆、小店、夜市、景区小交通、民宿不一定接受，仍需支付宝、微信和现金。

**能只带现金吗？** 不建议。很多预约、打车、点餐依赖手机支付，现金只作兜底。

**支付宝和微信哪个更重要？** 都重要。支付宝在打车/翻译/交通更友好，微信在小程序/景点预约/点餐/沟通更重要。

**海外卡能转账给中国朋友吗？** 通常不建议依赖，主要用于商户消费，红包/转账/提现多受限。

**小摊只收微信怎么办？** 先试微信付款码，失败试支付宝，都不行用现金。每天带 100–300 元小额。

**商家能拒收现金吗？** 官方推进现金支付便利化，现金仍是重要方式；但小额最好备小面额。

**能用 Apple Pay/Google Pay/PayPal 吗？** 不要作主方案，覆盖远不如支付宝/微信/银联/现金。

**Wise、Revolut 有用吗？** 本质多是 Visa/MC 借记或信用卡，能否绑取决于卡组织/发卡地/风控/平台验证，可试但务必备用卡。
',10,TRUE) ON CONFLICT (id) DO NOTHING;