-- Payment helper: data-driven card-receivability matrix + readiness checklist.
-- The folder spec (支付问题解决_逻辑_2026-06-22) requires these to be editable
-- by ops ("运营改表即生效，不写死"). The app reads them to compute
-- `weChatBindingViable` and the readiness percent instead of hardcoding card orgs.
--
-- NOTE: named `payment_*` to avoid colliding with the existing app-wide
-- `checklist_items` table (the prep checklist).

CREATE TABLE IF NOT EXISTS payment_card_networks (
  id           TEXT PRIMARY KEY,                        -- 'visa'|'mc'|'jcb'|'amex'|'unionpay'|'diners'|'discover'
  name_zh      TEXT NOT NULL,
  name_en      TEXT NOT NULL DEFAULT '',
  alipay_ok    BOOLEAN NOT NULL DEFAULT TRUE,
  wechat_ok    BOOLEAN NOT NULL DEFAULT FALSE,
  note         TEXT NOT NULL DEFAULT '',
  sort_order   INT NOT NULL DEFAULT 0,
  is_active    BOOLEAN NOT NULL DEFAULT TRUE,
  updated_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS payment_checklist_items (
  id           TEXT PRIMARY KEY,
  item_order   INT NOT NULL DEFAULT 0,
  label_zh     TEXT NOT NULL,
  label_en     TEXT NOT NULL DEFAULT '',
  weight       INT NOT NULL DEFAULT 25,
  condition    TEXT,                                    -- NULL = always done; 'has_wechat' = done only if a WeChat-capable card is selected
  is_active    BOOLEAN NOT NULL DEFAULT TRUE,
  updated_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ── RLS: public-read CMS content tables (mirrors migration 063) ──
DO $policy$
DECLARE
  t TEXT;
BEGIN
  FOREACH t IN ARRAY ARRAY[
    'payment_card_networks',
    'payment_checklist_items'
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
-- Receivability matrix (per folder spec 交互demo/content.js card_networks):
--   Visa/MC/JCB accepted by both; Amex/UnionPay/Diners/Discover Alipay-only.

INSERT INTO payment_card_networks (id, name_zh, name_en, alipay_ok, wechat_ok, sort_order) VALUES
  ('visa',     'Visa',       'Visa',             TRUE,  TRUE,  0),
  ('mc',       'Mastercard', 'Mastercard',       TRUE,  TRUE,  1),
  ('jcb',      'JCB',        'JCB',              TRUE,  TRUE,  2),
  ('amex',     '美国运通',    'American Express', TRUE,  FALSE, 3),
  ('unionpay', '银联',        'UnionPay',         TRUE,  FALSE, 4),
  ('diners',   '大来卡',      'Diners Club',      TRUE,  FALSE, 5),
  ('discover', '发现卡',      'Discover',         TRUE,  FALSE, 6)
ON CONFLICT (id) DO NOTHING;

INSERT INTO payment_checklist_items (id, item_order, label_zh, label_en, weight, condition) VALUES
  ('alipay_bound', 1, '支付宝已绑卡',     'Alipay card added',      25, NULL),
  ('wechat_bound', 2, '微信支付已绑卡',   'WeChat card added',      25, 'has_wechat'),
  ('backup_cash',  3, '备用卡 + 现金计划', 'Backup card + cash plan', 25, NULL),
  ('verified',     4, '通道已 1 元验证',   'Channel 1-yuan verified', 25, NULL)
ON CONFLICT (id) DO NOTHING;
