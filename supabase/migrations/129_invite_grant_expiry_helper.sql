-- Extracted grant expiry stacking logic for reuse / testing (RPC inlines equivalent logic).

CREATE OR REPLACE FUNCTION public.compute_invite_grant_expiry(
  p_user_id UUID,
  p_duration_days INT,
  p_is_lifetime BOOLEAN
) RETURNS TIMESTAMPTZ
LANGUAGE plpgsql STABLE SECURITY DEFINER SET search_path = public AS $$
DECLARE
  prof profiles%ROWTYPE;
  grant_exp TIMESTAMPTZ;
  sub_exp TIMESTAMPTZ;
  base_ts TIMESTAMPTZ;
BEGIN
  IF p_is_lifetime THEN
    RETURN NULL;
  END IF;

  SELECT * INTO prof FROM profiles WHERE id = p_user_id;
  IF NOT FOUND THEN
    RETURN NOW() + make_interval(days => p_duration_days);
  END IF;

  grant_exp := NULL;
  IF prof.membership_override = 'grant'
     AND (prof.membership_override_expires_at IS NULL OR prof.membership_override_expires_at > NOW()) THEN
    grant_exp := prof.membership_override_expires_at;
  END IF;

  sub_exp := NULL;
  IF prof.subscription_expires_at IS NOT NULL AND prof.subscription_expires_at > NOW() THEN
    sub_exp := prof.subscription_expires_at;
  END IF;

  base_ts := NOW();
  IF grant_exp IS NOT NULL AND grant_exp > base_ts THEN base_ts := grant_exp; END IF;
  IF sub_exp IS NOT NULL AND sub_exp > base_ts THEN base_ts := sub_exp; END IF;

  RETURN base_ts + make_interval(days => p_duration_days);
END;
$$;

COMMENT ON FUNCTION public.compute_invite_grant_expiry IS
  'Stack invite duration onto max(now, active grant expiry, active subscription mirror expiry).';
