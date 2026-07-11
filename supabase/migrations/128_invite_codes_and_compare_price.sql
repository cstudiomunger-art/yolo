-- Invite codes (complimentary membership grants) + paywall compare price fields.

-- ── Compare price (membership_plans + app_settings) ──
ALTER TABLE membership_plans
  ADD COLUMN IF NOT EXISTS compare_price_label TEXT,
  ADD COLUMN IF NOT EXISTS show_compare_price BOOLEAN NOT NULL DEFAULT FALSE;

COMMENT ON COLUMN membership_plans.compare_price_label IS 'Optional strikethrough reference price label for paywall marketing.';
COMMENT ON COLUMN membership_plans.show_compare_price IS 'When true and global switch on, show compare_price_label beside price_label.';

ALTER TABLE app_settings
  ADD COLUMN IF NOT EXISTS paywall_compare_price_enabled BOOLEAN NOT NULL DEFAULT FALSE;

COMMENT ON COLUMN app_settings.paywall_compare_price_enabled IS 'Global switch: when false, no plan shows strikethrough compare price in the app.';

-- ── Batch metadata ──
CREATE TABLE IF NOT EXISTS invite_code_batches (
  id               TEXT PRIMARY KEY,
  label            TEXT NOT NULL DEFAULT '',
  redemption_mode  TEXT NOT NULL DEFAULT 'single_use'
    CHECK (redemption_mode IN ('single_use', 'multi_use', 'unlimited')),
  duration_preset  TEXT NOT NULL DEFAULT '1_month'
    CHECK (duration_preset IN ('1_month', '2_months', '6_months', 'lifetime', 'custom')),
  duration_days    INT,
  plan_id          TEXT NOT NULL DEFAULT 'annual' REFERENCES membership_plans(id),
  one_per_account  BOOLEAN NOT NULL DEFAULT FALSE,
  codes_generated  INT NOT NULL DEFAULT 0,
  codes_redeemed   INT NOT NULL DEFAULT 0,
  created_by       UUID,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ── Invite codes ──
CREATE TABLE IF NOT EXISTS invite_codes (
  id                         TEXT PRIMARY KEY,
  code                       TEXT NOT NULL UNIQUE,
  label                      TEXT NOT NULL DEFAULT '',
  batch_id                   TEXT REFERENCES invite_code_batches(id) ON DELETE SET NULL,
  plan_id                    TEXT NOT NULL DEFAULT 'annual' REFERENCES membership_plans(id),
  duration_preset            TEXT NOT NULL DEFAULT '1_month'
    CHECK (duration_preset IN ('1_month', '2_months', '6_months', 'lifetime', 'custom')),
  duration_days              INT,
  redemption_mode            TEXT NOT NULL DEFAULT 'single_use'
    CHECK (redemption_mode IN ('single_use', 'multi_use', 'unlimited')),
  max_redemptions            INT,
  redeemed_count             INT NOT NULL DEFAULT 0,
  auto_deactivate_on_exhaust BOOLEAN NOT NULL DEFAULT TRUE,
  one_per_account            BOOLEAN NOT NULL DEFAULT FALSE,
  valid_from                 TIMESTAMPTZ,
  valid_until                TIMESTAMPTZ,
  is_active                  BOOLEAN NOT NULL DEFAULT TRUE,
  new_users_only             BOOLEAN NOT NULL DEFAULT FALSE,
  first_redeemed_at          TIMESTAMPTZ,
  note_internal              TEXT,
  created_by                 UUID,
  created_at                 TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at                 TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT invite_codes_mode_max_chk CHECK (
    (redemption_mode = 'single_use' AND max_redemptions = 1)
    OR (redemption_mode = 'multi_use' AND max_redemptions IS NOT NULL AND max_redemptions >= 1)
    OR (redemption_mode = 'unlimited' AND max_redemptions IS NULL)
  ),
  CONSTRAINT invite_codes_custom_days_chk CHECK (
    duration_preset <> 'custom' OR (duration_days IS NOT NULL AND duration_days > 0)
  ),
  CONSTRAINT invite_codes_single_use_deactivate_chk CHECK (
    redemption_mode <> 'single_use' OR auto_deactivate_on_exhaust = TRUE
  )
);

CREATE INDEX IF NOT EXISTS invite_codes_batch_active_idx ON invite_codes (batch_id, is_active);
CREATE INDEX IF NOT EXISTS invite_codes_active_until_idx ON invite_codes (is_active, valid_until);

-- ── Redemptions audit ──
CREATE TABLE IF NOT EXISTS invite_code_redemptions (
  id                       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  invite_code_id           TEXT NOT NULL REFERENCES invite_codes(id) ON DELETE RESTRICT,
  user_id                  UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  batch_id                 TEXT REFERENCES invite_code_batches(id) ON DELETE SET NULL,
  code_snapshot            TEXT NOT NULL,
  redeemed_at              TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  granted_expires_at       TIMESTAMPTZ,
  duration_days_applied    INT,
  previous_expires_at      TIMESTAMPTZ,
  granted_plan_id          TEXT,
  redemption_mode_snapshot TEXT NOT NULL DEFAULT 'single_use',
  UNIQUE (invite_code_id, user_id)
);

CREATE UNIQUE INDEX IF NOT EXISTS invite_redemptions_one_per_batch
  ON invite_code_redemptions (user_id, batch_id)
  WHERE batch_id IS NOT NULL;

CREATE INDEX IF NOT EXISTS invite_redemptions_user_idx ON invite_code_redemptions (user_id, redeemed_at DESC);
CREATE INDEX IF NOT EXISTS invite_redemptions_code_idx ON invite_code_redemptions (invite_code_id);

-- ── Failed attempts (rate limit) ──
CREATE TABLE IF NOT EXISTS invite_redeem_failures (
  id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id               UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  attempted_code_prefix TEXT,
  error_code            TEXT NOT NULL,
  created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS invite_redeem_failures_user_time_idx
  ON invite_redeem_failures (user_id, created_at DESC);

-- ── RLS ──
ALTER TABLE invite_code_batches ENABLE ROW LEVEL SECURITY;
ALTER TABLE invite_codes ENABLE ROW LEVEL SECURITY;
ALTER TABLE invite_code_redemptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE invite_redeem_failures ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Admins manage invite batches" ON invite_code_batches;
CREATE POLICY "Admins manage invite batches"
  ON invite_code_batches FOR ALL TO authenticated
  USING (public.is_admin()) WITH CHECK (public.is_admin());

DROP POLICY IF EXISTS "Admins manage invite codes" ON invite_codes;
CREATE POLICY "Admins manage invite codes"
  ON invite_codes FOR ALL TO authenticated
  USING (public.is_admin()) WITH CHECK (public.is_admin());

DROP POLICY IF EXISTS "Users read own invite redemptions" ON invite_code_redemptions;
CREATE POLICY "Users read own invite redemptions"
  ON invite_code_redemptions FOR SELECT TO authenticated
  USING (user_id = auth.uid() OR public.is_admin());

DROP POLICY IF EXISTS "Admins manage invite redemptions" ON invite_code_redemptions;
CREATE POLICY "Admins manage invite redemptions"
  ON invite_code_redemptions FOR ALL TO authenticated
  USING (public.is_admin()) WITH CHECK (public.is_admin());

DROP POLICY IF EXISTS "Service role invite failures" ON invite_redeem_failures;
CREATE POLICY "Service role invite failures"
  ON invite_redeem_failures FOR ALL
  USING (auth.role() = 'service_role')
  WITH CHECK (auth.role() = 'service_role');

-- ── Helpers ──
CREATE OR REPLACE FUNCTION public.resolve_invite_duration_days(
  p_preset TEXT,
  p_custom INT
) RETURNS INT
LANGUAGE sql IMMUTABLE AS $$
  SELECT CASE p_preset
    WHEN '1_month'  THEN 30
    WHEN '2_months' THEN 60
    WHEN '6_months' THEN 180
    WHEN 'lifetime' THEN NULL
    WHEN 'custom'   THEN p_custom
    ELSE NULL
  END;
$$;

CREATE OR REPLACE FUNCTION public.is_invite_new_user(p_user_id UUID)
RETURNS BOOLEAN
LANGUAGE plpgsql STABLE SECURITY DEFINER SET search_path = public AS $$
DECLARE
  prof profiles%ROWTYPE;
BEGIN
  IF EXISTS (SELECT 1 FROM invite_code_redemptions WHERE user_id = p_user_id) THEN
    RETURN FALSE;
  END IF;

  SELECT * INTO prof FROM profiles WHERE id = p_user_id;
  IF NOT FOUND THEN
    RETURN TRUE;
  END IF;

  IF prof.membership_override = 'grant' THEN
    IF prof.membership_override_expires_at IS NULL OR prof.membership_override_expires_at > NOW() THEN
      RETURN FALSE;
    END IF;
  END IF;

  IF prof.subscription_expires_at IS NOT NULL AND prof.subscription_expires_at > NOW() THEN
    RETURN FALSE;
  END IF;

  RETURN TRUE;
END;
$$;

CREATE OR REPLACE FUNCTION public.log_invite_redeem_failure(
  p_user_id UUID,
  p_code TEXT,
  p_error TEXT
) RETURNS VOID
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
  INSERT INTO invite_redeem_failures (user_id, attempted_code_prefix, error_code)
  VALUES (p_user_id, left(coalesce(p_code, ''), 4), p_error);
END;
$$;

-- ── Redeem RPC ──
CREATE OR REPLACE FUNCTION public.redeem_invite_code(p_code TEXT)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  uid UUID := auth.uid();
  norm TEXT;
  ic invite_codes%ROWTYPE;
  prof profiles%ROWTYPE;
  fail_count INT;
  days INT;
  is_lifetime BOOLEAN;
  prev_exp TIMESTAMPTZ;
  base_ts TIMESTAMPTZ;
  grant_exp TIMESTAMPTZ;
  sub_exp TIMESTAMPTZ;
  new_exp TIMESTAMPTZ;
  new_note TEXT;
  benefit_label TEXT;
  exhausted BOOLEAN;
BEGIN
  IF uid IS NULL THEN
    RETURN jsonb_build_object('ok', false, 'error', 'NOT_AUTHENTICATED');
  END IF;

  norm := upper(regexp_replace(trim(coalesce(p_code, '')), '[^A-Z0-9]', '', 'g'));
  IF length(norm) < 6 THEN
    PERFORM public.log_invite_redeem_failure(uid, norm, 'INVALID_CODE');
    RETURN jsonb_build_object('ok', false, 'error', 'INVALID_CODE');
  END IF;

  SELECT count(*)::INT INTO fail_count
  FROM invite_redeem_failures
  WHERE user_id = uid AND created_at > NOW() - INTERVAL '1 hour';
  IF fail_count >= 15 THEN
    RETURN jsonb_build_object('ok', false, 'error', 'RATE_LIMITED');
  END IF;

  SELECT * INTO ic FROM invite_codes WHERE code = norm FOR UPDATE;
  IF NOT FOUND THEN
    PERFORM public.log_invite_redeem_failure(uid, norm, 'INVALID_CODE');
    RETURN jsonb_build_object('ok', false, 'error', 'INVALID_CODE');
  END IF;

  IF NOT ic.is_active THEN
    IF ic.redemption_mode = 'single_use' AND ic.redeemed_count >= 1 THEN
      PERFORM public.log_invite_redeem_failure(uid, norm, 'CODE_ALREADY_USED');
      RETURN jsonb_build_object('ok', false, 'error', 'CODE_ALREADY_USED');
    END IF;
    PERFORM public.log_invite_redeem_failure(uid, norm, 'INVALID_CODE');
    RETURN jsonb_build_object('ok', false, 'error', 'INVALID_CODE');
  END IF;

  IF ic.valid_from IS NOT NULL AND NOW() < ic.valid_from THEN
    PERFORM public.log_invite_redeem_failure(uid, norm, 'NOT_YET_VALID');
    RETURN jsonb_build_object('ok', false, 'error', 'NOT_YET_VALID');
  END IF;

  IF ic.valid_until IS NOT NULL AND NOW() > ic.valid_until THEN
    PERFORM public.log_invite_redeem_failure(uid, norm, 'EXPIRED');
    RETURN jsonb_build_object('ok', false, 'error', 'EXPIRED');
  END IF;

  IF ic.max_redemptions IS NOT NULL AND ic.redeemed_count >= ic.max_redemptions THEN
    PERFORM public.log_invite_redeem_failure(uid, norm, 'EXHAUSTED');
    RETURN jsonb_build_object('ok', false, 'error', 'EXHAUSTED');
  END IF;

  SELECT * INTO prof FROM profiles WHERE id = uid FOR UPDATE;
  IF NOT FOUND THEN
    PERFORM public.log_invite_redeem_failure(uid, norm, 'INVALID_CODE');
    RETURN jsonb_build_object('ok', false, 'error', 'INVALID_CODE');
  END IF;

  IF prof.membership_override = 'ban' THEN
    PERFORM public.log_invite_redeem_failure(uid, norm, 'ACCOUNT_BLOCKED');
    RETURN jsonb_build_object('ok', false, 'error', 'ACCOUNT_BLOCKED');
  END IF;

  IF EXISTS (
    SELECT 1 FROM invite_code_redemptions
    WHERE invite_code_id = ic.id AND user_id = uid
  ) THEN
    PERFORM public.log_invite_redeem_failure(uid, norm, 'ALREADY_REDEEMED');
    RETURN jsonb_build_object('ok', false, 'error', 'ALREADY_REDEEMED');
  END IF;

  IF ic.one_per_account AND EXISTS (
    SELECT 1 FROM invite_code_redemptions WHERE user_id = uid
  ) THEN
    PERFORM public.log_invite_redeem_failure(uid, norm, 'ACCOUNT_ALREADY_REDEEMED');
    RETURN jsonb_build_object('ok', false, 'error', 'ACCOUNT_ALREADY_REDEEMED');
  END IF;

  IF ic.batch_id IS NOT NULL AND EXISTS (
    SELECT 1 FROM invite_code_redemptions
    WHERE user_id = uid AND batch_id = ic.batch_id
  ) THEN
    PERFORM public.log_invite_redeem_failure(uid, norm, 'CAMPAIGN_ALREADY_REDEEMED');
    RETURN jsonb_build_object('ok', false, 'error', 'CAMPAIGN_ALREADY_REDEEMED');
  END IF;

  IF ic.new_users_only AND NOT public.is_invite_new_user(uid) THEN
    PERFORM public.log_invite_redeem_failure(uid, norm, 'NOT_ELIGIBLE');
    RETURN jsonb_build_object('ok', false, 'error', 'NOT_ELIGIBLE');
  END IF;

  is_lifetime := ic.duration_preset = 'lifetime';
  days := public.resolve_invite_duration_days(ic.duration_preset, ic.duration_days);

  IF prof.membership_override = 'grant' AND prof.membership_override_expires_at IS NULL THEN
    RETURN jsonb_build_object(
      'ok', true,
      'expires_at', NULL,
      'is_lifetime', true,
      'already_lifetime', true,
      'plan_id', ic.plan_id,
      'benefit_label', 'lifetime'
    );
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

  prev_exp := grant_exp;
  IF sub_exp IS NOT NULL AND (prev_exp IS NULL OR sub_exp > prev_exp) THEN
    prev_exp := sub_exp;
  END IF;

  base_ts := NOW();
  IF grant_exp IS NOT NULL AND grant_exp > base_ts THEN base_ts := grant_exp; END IF;
  IF sub_exp IS NOT NULL AND sub_exp > base_ts THEN base_ts := sub_exp; END IF;

  IF is_lifetime THEN
    new_exp := NULL;
    benefit_label := 'lifetime';
  ELSE
    new_exp := base_ts + make_interval(days => days);
    benefit_label := days::TEXT || ' days';
  END IF;

  new_note := coalesce(prof.membership_override_note, '');
  IF position('invite:' IN new_note) = 0 THEN
    new_note := trim(both FROM new_note || ' invite:' || ic.id);
  END IF;
  IF length(new_note) > 500 THEN
    new_note := right(new_note, 500);
  END IF;

  UPDATE profiles SET
    membership_override = 'grant',
    membership_override_expires_at = new_exp,
    subscription_plan_id = ic.plan_id,
    subscription_expires_at = new_exp,
    membership_override_note = new_note,
    updated_at = NOW()
  WHERE id = uid;

  INSERT INTO invite_code_redemptions (
    invite_code_id, user_id, batch_id, code_snapshot,
    granted_expires_at, duration_days_applied, previous_expires_at,
    granted_plan_id, redemption_mode_snapshot
  ) VALUES (
    ic.id, uid, ic.batch_id, ic.code,
    new_exp, days, prev_exp,
    ic.plan_id, ic.redemption_mode
  );

  exhausted := ic.redemption_mode = 'single_use'
    OR (ic.max_redemptions IS NOT NULL AND ic.redeemed_count + 1 >= ic.max_redemptions);

  UPDATE invite_codes SET
    redeemed_count = redeemed_count + 1,
    first_redeemed_at = COALESCE(first_redeemed_at, NOW()),
    is_active = CASE
      WHEN auto_deactivate_on_exhaust AND exhausted THEN FALSE
      ELSE is_active
    END,
    updated_at = NOW()
  WHERE id = ic.id;

  IF ic.batch_id IS NOT NULL THEN
    UPDATE invite_code_batches SET
      codes_redeemed = codes_redeemed + 1,
      updated_at = NOW()
    WHERE id = ic.batch_id;
  END IF;

  RETURN jsonb_build_object(
    'ok', true,
    'expires_at', new_exp,
    'is_lifetime', is_lifetime,
    'already_lifetime', false,
    'plan_id', ic.plan_id,
    'benefit_label', benefit_label
  );
EXCEPTION
  WHEN unique_violation THEN
    PERFORM public.log_invite_redeem_failure(uid, norm, 'ALREADY_REDEEMED');
    RETURN jsonb_build_object('ok', false, 'error', 'ALREADY_REDEEMED');
END;
$$;

REVOKE ALL ON FUNCTION public.redeem_invite_code(TEXT) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.redeem_invite_code(TEXT) TO authenticated;

COMMENT ON FUNCTION public.redeem_invite_code IS
  'Atomically redeem an invite code and grant membership via profiles.membership_override.';
