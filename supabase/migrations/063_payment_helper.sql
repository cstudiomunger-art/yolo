-- Payment helper: CMS-driven content (advice copy, merchant phrases, links).
-- The branching flow + pruning logic lives in the app; these tables only supply
-- editable copy with a bundled JSON fallback shipped in the app.

CREATE TABLE IF NOT EXISTS payment_advice_rules (
  id          TEXT PRIMARY KEY,
  dimension   TEXT NOT NULL,                            -- 'sms'|'card'|'cash'
  match_json  JSONB NOT NULL DEFAULT '{}'::jsonb,       -- {country:['in','br']} / {cards_exclude:['visa','mc','jcb']} / {trip:'remote'}
  severity    TEXT NOT NULL DEFAULT 'info',             -- 'ok'|'warn'|'info'
  body_en     TEXT NOT NULL DEFAULT '',
  body_zh     TEXT NOT NULL DEFAULT '',
  sort_order  INT NOT NULL DEFAULT 0,
  is_active   BOOLEAN NOT NULL DEFAULT TRUE,
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS payment_merchant_phrases (
  id          TEXT PRIMARY KEY,
  cn          TEXT NOT NULL,
  en          TEXT NOT NULL DEFAULT '',
  sort_order  INT NOT NULL DEFAULT 0,
  is_active   BOOLEAN NOT NULL DEFAULT TRUE,
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS payment_helper_links (
  id          TEXT PRIMARY KEY,
  label_en    TEXT NOT NULL DEFAULT '',
  label_zh    TEXT NOT NULL DEFAULT '',
  url         TEXT NOT NULL,
  lane        TEXT NOT NULL DEFAULT 'prep',             -- 'prep'|'china'|'rescue'
  sort_order  INT NOT NULL DEFAULT 0,
  is_active   BOOLEAN NOT NULL DEFAULT TRUE,
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- User payment preferences (synced via ProfileSyncService; country comes from onboarding).
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS payment_card_types TEXT[];
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS payment_trip_type  TEXT;   -- 'city'|'both'|'remote'

-- ── RLS: public-read CMS content tables ──
DO $policy$
DECLARE
  t TEXT;
BEGIN
  FOREACH t IN ARRAY ARRAY[
    'payment_advice_rules',
    'payment_merchant_phrases',
    'payment_helper_links'
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

-- ════════════════════ STARTER SEED ════════════════════

INSERT INTO payment_merchant_phrases (id, cn, en, sort_order) VALUES
  ('scan_me',    '请扫我的付款码',       'Please scan my payment code',          0),
  ('failed_try', '支付失败了，我换一种方式','Payment failed, let me try another way',1),
  ('cash_ok',    '可以用现金吗？',        'Can I pay with cash?',                 2),
  ('split_two',  '可以分两笔支付吗？',     'Can I split it into two payments?',    3)
ON CONFLICT (id) DO NOTHING;

INSERT INTO payment_advice_rules (id, dimension, match_json, severity, body_en, body_zh, sort_order) VALUES
  ('sms_default', 'sms', '{}'::jsonb, 'ok',
    'Your carrier can receive the SMS code; register with your phone number.',
    '你所在国家主流运营商可正常接收验证码，按手机号注册即可。', 0),
  ('sms_in_br',   'sms', '{"country":["IN","BR"]}'::jsonb, 'warn',
    'Your carrier blocks international SMS by default — register with email (Gmail/Outlook) instead.',
    '你的运营商默认关闭国际短信，大概率收不到验证码——直接用邮箱注册（Gmail/Outlook）。', 1),
  ('card_no_wx',  'card', '{"cards_exclude":["visa","mc","jcb"]}'::jsonb, 'warn',
    'WeChat only accepts Visa/MC/JCB — skip binding a card to WeChat this trip, use Alipay.',
    '微信只收 Visa/MC/JCB，这趟微信先别绑卡，主用支付宝。', 2),
  ('cash_remote', 'cash', '{"trip":"remote"}'::jsonb, 'info',
    'Mostly rural/remote — carry 2000+ RMB cash; many spots are cash or personal QR only.',
    '主要去乡村/偏远——带 2000 元以上现金，那里基本只收现金或个人收款码。', 3),
  ('cash_city',   'cash', '{"trip":"city"}'::jsonb, 'info',
    'Mostly big cities — carry 500-800 RMB cash as backup, in small notes.',
    '主要在大城市——带 500-800 元现金兜底，拆成小面额。', 4)
ON CONFLICT (id) DO NOTHING;
