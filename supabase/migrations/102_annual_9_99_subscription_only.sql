-- Idempotent: ensure annual plan exists + disable all other plans + subscription-only paywall.
-- Safe to run multiple times in Supabase SQL Editor.

BEGIN;

-- 1) Upsert the only active plan (INSERT if missing, UPDATE if exists)
INSERT INTO membership_plans (
  id, rc_package_id, apple_product_id,
  name_en, name_zh, price_label,
  duration_days, free_trial_days, plan_type,
  access_flags, feature_lines,
  is_best_value, display_order, is_active
) VALUES (
  'annual',
  '$rc_annual',
  'com.yolohappy.sub.annual',
  'Annual Membership',
  '年度会员',
  '$9.99/year',
  365,
  0,
  'subscription',
  '{"audio_guides": true, "text_content": true, "visitor_tips": true}'::jsonb,
  ARRAY[
    'Unlimited audio guides for all attractions',
    'Full text content for every attraction',
    'All visitor tips unlocked',
    'AI-powered itinerary planning'
  ],
  TRUE,
  0,
  TRUE
)
ON CONFLICT (id) DO UPDATE SET
  rc_package_id    = EXCLUDED.rc_package_id,
  apple_product_id = EXCLUDED.apple_product_id,
  name_en          = EXCLUDED.name_en,
  name_zh          = EXCLUDED.name_zh,
  price_label      = EXCLUDED.price_label,
  duration_days    = EXCLUDED.duration_days,
  free_trial_days  = EXCLUDED.free_trial_days,
  plan_type        = EXCLUDED.plan_type,
  access_flags     = EXCLUDED.access_flags,
  feature_lines    = EXCLUDED.feature_lines,
  is_best_value    = EXCLUDED.is_best_value,
  display_order    = EXCLUDED.display_order,
  is_active        = TRUE;

-- 2) Disable every other plan
UPDATE membership_plans
SET is_active = FALSE
WHERE id <> 'annual';

-- 3) Attractions: paywalled, subscription-only (no per-item tier)
UPDATE attractions
SET
  requires_purchase = TRUE,
  price_tier_id     = NULL,
  iap_product_id    = NULL;

UPDATE sub_areas
SET
  requires_purchase = TRUE,
  price_tier_id     = NULL;

-- 4) Paywall copy
UPDATE app_settings
SET
  iap_pro_price          = '$9.99/year',
  iap_pro_trial_text     = '',
  paywall_pro_price_hint = 'Billed annually · Cancel anytime',
  iap_single_price_label = 'Annual Membership · $9.99/year'
WHERE id = 'global';

COMMIT;

-- Verify (should return exactly 1 row with is_active = true):
-- SELECT id, name_zh, price_label, is_active, plan_type FROM membership_plans ORDER BY display_order;
