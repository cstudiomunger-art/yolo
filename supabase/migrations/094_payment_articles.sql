-- Payment helper: per-node detailed articles (详细图文 / articles_by_node).
-- Each article is anchored to a node_key (plan/bind/use/home...) and rendered as
-- Markdown in the app. "坐下来研究"型内容(限额/实体卡/现金/自检清单)挂这里,
-- 与"临场照做"的 steps 区分。Ops edit & publish in admin; app reads published rows.

CREATE TABLE IF NOT EXISTS payment_articles (
  id            TEXT PRIMARY KEY,
  node_key      TEXT NOT NULL,                       -- 'plan'|'bind'|'use'|'home'
  title_zh      TEXT NOT NULL,
  title_en      TEXT NOT NULL DEFAULT '',
  body_md_zh    TEXT NOT NULL DEFAULT '',            -- Markdown
  body_md_en    TEXT NOT NULL DEFAULT '',
  display_order INT NOT NULL DEFAULT 0,
  is_published  BOOLEAN NOT NULL DEFAULT TRUE,
  is_active     BOOLEAN NOT NULL DEFAULT TRUE,
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ── RLS: public read published+active rows; admin full ──
ALTER TABLE payment_articles ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Public read payment_articles" ON payment_articles;
CREATE POLICY "Public read payment_articles" ON payment_articles
  FOR SELECT USING ((is_active = TRUE AND is_published = TRUE) OR public.is_admin());
DROP POLICY IF EXISTS "Admin insert payment_articles" ON payment_articles;
CREATE POLICY "Admin insert payment_articles" ON payment_articles
  FOR INSERT TO authenticated WITH CHECK (public.is_admin());
DROP POLICY IF EXISTS "Admin update payment_articles" ON payment_articles;
CREATE POLICY "Admin update payment_articles" ON payment_articles
  FOR UPDATE TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());
DROP POLICY IF EXISTS "Admin delete payment_articles" ON payment_articles;
CREATE POLICY "Admin delete payment_articles" ON payment_articles
  FOR DELETE TO authenticated USING (public.is_admin());

-- ════════════════════ STARTER SEED ════════════════════
INSERT INTO payment_articles (id, node_key, title_zh, title_en, body_md_zh, display_order) VALUES
  ('plan_selfcheck', 'plan', '出发前 10 分钟自检', 'Pre-trip 10-minute check',
$$出发前，请逐条确认：

- 支付宝已安装并能打开。
- 微信已安装并能正常登录。
- 两个 App 至少各绑定一张银行卡，或至少有一个 App 已成功绑定。
- 你的银行卡已开通海外交易。
- 你知道银行 App 或客服电话在哪里。
- 你准备了至少 500 元人民币现金，或知道落地后在哪里取。
- 你的手机能在中国上网，或已购买 eSIM / 漫游 / 本地 SIM。
- 酒店、高铁、热门景点、接送机等关键项目已尽量预付。
- 护照信息和所有预订信息一致。$$, 0),
  ('plan_cards', 'plan', '该带哪些实体卡 / Wise、Revolut 有用吗', 'Which physical cards to bring',
$$**主力**：带至少 2 张不同银行的卡（一张信用卡 + 一张借记卡），优先 Visa / Mastercard / JCB——支付宝、微信都能尝试绑定。

**银联 / Amex / Diners / Discover**：支付宝多可绑、微信一般不收，作备用。

**Wise、Revolut 等**：本质通常是 Visa / Mastercard 借记卡，能否绑定取决于卡组织、发卡地区、银行风控和平台验证。可以尝试，但**一定要准备备用卡**。

> Apple Pay / Google Pay / PayPal 在中国大陆线下覆盖有限，不要作为主要支付方式。$$, 1)
ON CONFLICT (id) DO NOTHING;
