-- YOLO HAPPY: Membership plans (CMS-configurable via admin panel)
CREATE TABLE IF NOT EXISTS membership_plans (
  id               TEXT PRIMARY KEY,
  rc_package_id    TEXT,
  apple_product_id TEXT NOT NULL UNIQUE,
  name_en          TEXT NOT NULL,
  name_zh          TEXT,
  price_label      TEXT NOT NULL DEFAULT '',
  duration_days    INT,
  plan_type        TEXT NOT NULL DEFAULT 'subscription'
    CHECK (plan_type IN ('subscription', 'one_time_attraction')),
  access_flags     JSONB NOT NULL DEFAULT '{
    "audio_guides": false,
    "text_content": false,
    "offline_download": false,
    "visitor_tips": false,
    "ai_advanced": false
  }'::jsonb,
  feature_lines    TEXT[] NOT NULL DEFAULT '{}',
  is_best_value    BOOLEAN NOT NULL DEFAULT FALSE,
  display_order    INT NOT NULL DEFAULT 0,
  is_active        BOOLEAN NOT NULL DEFAULT TRUE,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

COMMENT ON TABLE membership_plans IS 'IAP subscription and one-time purchase plan definitions. Managed via admin CMS.';
COMMENT ON COLUMN membership_plans.access_flags IS 'Per-plan content unlock flags: audio_guides, text_content, offline_download, visitor_tips, ai_advanced.';

-- Any authenticated user can read plans (needed for paywall display)
ALTER TABLE membership_plans ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Anyone can read active plans" ON membership_plans;
CREATE POLICY "Anyone can read active plans"
  ON membership_plans FOR SELECT
  USING (TRUE);

DROP POLICY IF EXISTS "Admins manage plans" ON membership_plans;
CREATE POLICY "Admins manage plans"
  ON membership_plans FOR ALL
  TO authenticated
  USING (public.is_admin())
  WITH CHECK (public.is_admin());

-- Seed default plans
INSERT INTO membership_plans (id, apple_product_id, name_en, name_zh, price_label, duration_days, plan_type, access_flags, feature_lines, is_best_value, display_order, is_active)
VALUES
  (
    'annual',
    'com.yolohappy.sub.annual',
    'Annual Membership',
    '年度会员',
    '$19.99/year',
    365,
    'subscription',
    '{"audio_guides": true, "text_content": true, "offline_download": true, "visitor_tips": true, "ai_advanced": true}'::jsonb,
    ARRAY['Unlimited audio guides for all attractions', 'Full text content for every attraction', 'Offline audio downloads', 'All visitor tips unlocked', 'Advanced AI travel assistant'],
    TRUE,
    0,
    TRUE
  ),
  (
    'quarterly',
    'com.yolohappy.sub.quarterly',
    'Quarterly Membership',
    '季度会员',
    '$7.99/quarter',
    90,
    'subscription',
    '{"audio_guides": true, "text_content": true, "offline_download": false, "visitor_tips": true, "ai_advanced": false}'::jsonb,
    ARRAY['Unlimited audio guides for all attractions', 'Full text content for every attraction', 'All visitor tips unlocked'],
    FALSE,
    1,
    TRUE
  ),
  (
    'monthly',
    'com.yolohappy.sub.monthly',
    'Monthly Membership',
    '月度会员',
    '$3.99/month',
    30,
    'subscription',
    '{"audio_guides": true, "text_content": false, "offline_download": false, "visitor_tips": false, "ai_advanced": false}'::jsonb,
    ARRAY['Unlimited audio guides for all attractions'],
    FALSE,
    2,
    TRUE
  ),
  (
    'attraction_single',
    'com.yolohappy.attraction.single',
    'Single Attraction',
    '单景点购买',
    '$1.99',
    NULL,
    'one_time_attraction',
    '{"audio_guides": true, "text_content": true, "offline_download": false, "visitor_tips": true, "ai_advanced": false}'::jsonb,
    ARRAY['Audio guide for this attraction', 'Full text content for this attraction', 'Visitor tips unlocked'],
    FALSE,
    3,
    TRUE
  )
ON CONFLICT (id) DO NOTHING;
