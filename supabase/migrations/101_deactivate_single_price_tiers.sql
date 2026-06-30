-- Deactivate per-attraction price tiers when only annual subscription is sold.

UPDATE membership_plans
SET is_active = false
WHERE id IN ('single_t1', 'single_t2', 'single_t3')
  AND is_active = true;
