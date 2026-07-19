-- Disable end-user invite-code redemption (App Store guideline 3.1.1).
-- Keeps historical tables and existing membership_override grants intact.
-- Promotions should use App Store Offer Codes; CMS "开通会员" remains for manual grants.

BEGIN;

-- Stop any still-active self-serve codes.
UPDATE public.invite_codes
SET is_active = false
WHERE is_active = true;

-- Revoke client execute rights on the redeem RPC (if present).
DO $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_proc p
    JOIN pg_namespace n ON n.oid = p.pronamespace
    WHERE n.nspname = 'public'
      AND p.proname = 'redeem_invite_code'
      AND pg_get_function_identity_arguments(p.oid) = 'p_code text'
  ) THEN
    REVOKE EXECUTE ON FUNCTION public.redeem_invite_code(text) FROM PUBLIC;
    REVOKE EXECUTE ON FUNCTION public.redeem_invite_code(text) FROM anon;
    REVOKE EXECUTE ON FUNCTION public.redeem_invite_code(text) FROM authenticated;
  END IF;
END $$;

-- Hard-disable the function body so even service_role callers get a clear error
-- if someone re-grants execute by mistake.
CREATE OR REPLACE FUNCTION public.redeem_invite_code(p_code text)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  RETURN jsonb_build_object(
    'ok', false,
    'error', 'DISABLED',
    'message', 'Invite codes are disabled. Use App Store Offer Codes or CMS membership grant.'
  );
END;
$$;

COMMENT ON FUNCTION public.redeem_invite_code(text) IS
  'Disabled for App Store 3.1.1 compliance. Prefer App Store Offer Codes; CMS grant for manual access.';

COMMIT;
