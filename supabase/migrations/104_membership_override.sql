-- 后台会员 override：管理员可手动「封禁 / 赠送」，优先级高于 RevenueCat。
--
-- 背景：会员真相源是 RevenueCat（Apple）。App 登录后用 RC 状态回写
--       profiles.subscription_plan_id / subscription_expires_at，因此后台直接改这两列
--       会被下次同步覆盖。本迁移新增一组「override 列」，由 App 在判定会员时优先读取，
--       且 App 端无权写入（受触发器保护），只有后台管理员 / service_role 能改。
--
--   membership_override:
--     NULL    → 无 override，按 RevenueCat 订阅判定（默认行为）
--     'grant' → 强制视为有效会员，直到 membership_override_expires_at（NULL = 永久）
--     'ban'   → 强制视为非会员（封禁），即使 RC 显示订阅有效也锁定全部付费内容
--   membership_override_expires_at: 仅 'grant' 用，到期后回落到 RC 判定
--   membership_override_note: 管理员备注（封禁/赠送原因），仅后台可见

ALTER TABLE profiles
  ADD COLUMN IF NOT EXISTS membership_override            TEXT,
  ADD COLUMN IF NOT EXISTS membership_override_expires_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS membership_override_note       TEXT;

ALTER TABLE profiles
  DROP CONSTRAINT IF EXISTS membership_override_valid;
ALTER TABLE profiles
  ADD CONSTRAINT membership_override_valid
  CHECK (membership_override IS NULL OR membership_override IN ('grant', 'ban'));

COMMENT ON COLUMN profiles.membership_override IS
  'Admin override of membership, beats RevenueCat. NULL=follow RC | grant=force member | ban=force non-member.';
COMMENT ON COLUMN profiles.membership_override_expires_at IS
  'Expiry for a grant override (NULL = lifetime). Ignored for ban / NULL override.';
COMMENT ON COLUMN profiles.membership_override_note IS
  'Admin-only note explaining the override (reason for grant/ban).';

-- 保护触发器：仅锁定 override 三列，普通用户（authenticated）改自己的 profile 时
-- 这三列一律还原为旧值；service_role 与后台管理员可正常写。
-- 注意：不锁 subscription_* 列 —— 那些仍由 App 用 RC 状态合法回写。
CREATE OR REPLACE FUNCTION public.protect_membership_override_columns()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF auth.role() = 'service_role' OR public.is_admin() THEN
    RETURN NEW;
  END IF;

  NEW.membership_override            := OLD.membership_override;
  NEW.membership_override_expires_at := OLD.membership_override_expires_at;
  NEW.membership_override_note       := OLD.membership_override_note;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS protect_membership_override ON profiles;
CREATE TRIGGER protect_membership_override
  BEFORE UPDATE ON profiles
  FOR EACH ROW
  EXECUTE FUNCTION public.protect_membership_override_columns();
