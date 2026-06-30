-- Backfill: users whose subscription row shows expired but have no override yet.
-- Sets ban so App locks content even when RevenueCat sandbox subscription is still active.
-- Safe to re-run (only touches rows with NULL override and past expiry).

UPDATE profiles
SET
  membership_override            = 'ban',
  membership_override_expires_at = NULL,
  updated_at                     = now()
WHERE membership_override IS NULL
  AND subscription_plan_id IS NOT NULL
  AND subscription_expires_at IS NOT NULL
  AND subscription_expires_at <= now();
