-- Free trial support for subscription plans (shown as a badge + drives the dynamic CTA copy)
ALTER TABLE membership_plans
  ADD COLUMN IF NOT EXISTS free_trial_days INT NOT NULL DEFAULT 0;

COMMENT ON COLUMN membership_plans.free_trial_days IS
  'Free trial length in days (0 = no trial). When > 0 the paywall shows a trial badge and the CTA reads "Start Free Trial".';

-- Seed: give the annual plan a 7-day trial by default
UPDATE membership_plans SET free_trial_days = 7 WHERE id = 'annual';
