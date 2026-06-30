-- Single annual membership at $9.99/year (RevenueCat: com.yolohappy.sub.annual)

UPDATE membership_plans
SET is_active = false
WHERE id IN (
  'quarterly', 'monthly', 'attraction_single',
  'single_t1', 'single_t2', 'single_t3'
);

UPDATE membership_plans
SET
  rc_package_id = '$rc_annual',
  price_label = '$9.99/year',
  free_trial_days = 0,
  access_flags = '{"audio_guides": true, "text_content": true, "visitor_tips": true}'::jsonb,
  is_best_value = true,
  is_active = true
WHERE id = 'annual';

UPDATE app_settings
SET iap_pro_price = '$9.99/year'
WHERE iap_pro_price = '$19.99/year' OR iap_pro_price IS NULL;
