-- YOLO HAPPY: Add subscription state and user profile fields to profiles table

ALTER TABLE profiles
  ADD COLUMN IF NOT EXISTS display_name            TEXT,
  ADD COLUMN IF NOT EXISTS avatar_url              TEXT,
  ADD COLUMN IF NOT EXISTS avatar_status           TEXT NOT NULL DEFAULT 'none',
    -- 'none' | 'pending' | 'approved' | 'rejected'
  ADD COLUMN IF NOT EXISTS subscription_plan_id    TEXT REFERENCES membership_plans(id),
  ADD COLUMN IF NOT EXISTS subscription_expires_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS rc_customer_id          TEXT;

COMMENT ON COLUMN profiles.display_name IS 'User-chosen display name (client-side filtered).';
COMMENT ON COLUMN profiles.avatar_url IS 'Supabase Storage path: avatars/{user_id}/avatar.jpg';
COMMENT ON COLUMN profiles.avatar_status IS 'Content moderation status: none | pending | approved | rejected.';
COMMENT ON COLUMN profiles.subscription_plan_id IS 'Active membership_plans.id — synced by revenuecat-webhook.';
COMMENT ON COLUMN profiles.subscription_expires_at IS 'Subscription expiry timestamp — synced by revenuecat-webhook.';
COMMENT ON COLUMN profiles.rc_customer_id IS 'RevenueCat app_user_id (= Supabase auth.uid() string).';
