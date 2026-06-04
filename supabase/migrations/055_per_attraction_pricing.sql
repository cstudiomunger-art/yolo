-- Per-attraction / per-sub-area paywall + price tiers
--
-- Pricing model: price tiers are one_time_attraction rows in membership_plans.
-- Each attraction / sub_area can require purchase and reference a price tier.
-- Default is FREE (requires_purchase = FALSE); admins mark paid items explicitly.

-- 1) Seed example price tiers (admins edit price_label / apple_product_id in the CMS).
INSERT INTO membership_plans
  (id, apple_product_id, name_en, name_zh, price_label, duration_days, free_trial_days,
   plan_type, access_flags, feature_lines, is_best_value, display_order, is_active)
VALUES
  ('single_t1', 'com.yolohappy.attraction.t1', 'Single · Tier 1', '单购 · 一档', '¥6',  NULL, 0,
   'one_time_attraction',
   '{"audio_guides": true, "text_content": true, "offline_download": false, "visitor_tips": true, "ai_advanced": false}'::jsonb,
   ARRAY['Audio guide for this attraction','Full text content','Visitor tips unlocked'],
   FALSE, 10, TRUE),
  ('single_t2', 'com.yolohappy.attraction.t2', 'Single · Tier 2', '单购 · 二档', '¥12', NULL, 0,
   'one_time_attraction',
   '{"audio_guides": true, "text_content": true, "offline_download": false, "visitor_tips": true, "ai_advanced": false}'::jsonb,
   ARRAY['Audio guide for this attraction','Full text content','Visitor tips unlocked'],
   FALSE, 11, TRUE),
  ('single_t3', 'com.yolohappy.attraction.t3', 'Single · Tier 3', '单购 · 三档', '¥18', NULL, 0,
   'one_time_attraction',
   '{"audio_guides": true, "text_content": true, "offline_download": false, "visitor_tips": true, "ai_advanced": false}'::jsonb,
   ARRAY['Audio guide for this attraction','Full text content','Visitor tips unlocked'],
   FALSE, 12, TRUE)
ON CONFLICT (id) DO NOTHING;

-- 2) Attraction-level paywall config
ALTER TABLE attractions
  ADD COLUMN IF NOT EXISTS requires_purchase BOOLEAN NOT NULL DEFAULT FALSE,
  ADD COLUMN IF NOT EXISTS price_tier_id     TEXT REFERENCES membership_plans (id);

COMMENT ON COLUMN attractions.requires_purchase IS
  'When true, this attraction''s Guide (audio + text) is behind the paywall. Default FALSE = free.';
COMMENT ON COLUMN attractions.price_tier_id IS
  'Single-purchase price tier (membership_plans.id of a one_time_attraction). NULL = default tier.';

-- 3) Sub-area-level paywall config
ALTER TABLE sub_areas
  ADD COLUMN IF NOT EXISTS requires_purchase BOOLEAN NOT NULL DEFAULT FALSE,
  ADD COLUMN IF NOT EXISTS price_tier_id     TEXT REFERENCES membership_plans (id);

COMMENT ON COLUMN sub_areas.requires_purchase IS
  'When true, this sub-area is behind the paywall. Buying the parent attraction also unlocks it.';
COMMENT ON COLUMN sub_areas.price_tier_id IS
  'Single-purchase price tier for this sub-area. NULL = default tier.';

-- 4) Migrate the legacy text_paywall_free flag (true meant "free"):
--    leave requires_purchase = FALSE everywhere (default-free policy). No data flip needed
--    because the old default already left most attractions effectively gated only via the
--    global use_remote_iap switch. Admins now opt specific items INTO the paywall.
