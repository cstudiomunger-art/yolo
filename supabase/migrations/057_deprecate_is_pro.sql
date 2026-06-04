-- is_pro is deprecated: membership is now driven by subscription_plan_id +
-- subscription_expires_at (and per-plan access_flags). The App and admin no longer
-- read or write is_pro. The column is kept for backward compatibility with older app
-- builds still in the field; it can be dropped in a future migration once every client
-- has upgraded.
COMMENT ON COLUMN profiles.is_pro IS
  'DEPRECATED — replaced by subscription_plan_id / subscription_expires_at. No longer read or written by the app or admin.';
