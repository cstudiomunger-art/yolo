-- 用户经 App Store / RevenueCat 重新订阅时，自动清除过期的 admin ban。
-- 场景：后台曾封禁/过期用户，之后用户真实付款；App 镜像有效 subscription_* 时应恢复为「跟 RC」。

CREATE OR REPLACE FUNCTION public.protect_profile_client_entitlements()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  active_sub BOOLEAN;
BEGIN
  IF auth.role() = 'service_role' OR public.is_admin() THEN
    RETURN NEW;
  END IF;

  IF TG_OP = 'INSERT' THEN
    NEW.purchased_attraction_ids       := '{}';
    NEW.membership_override            := NULL;
    NEW.membership_override_expires_at := NULL;
    NEW.membership_override_note       := NULL;
    RETURN NEW;
  END IF;

  active_sub := NEW.subscription_plan_id IS NOT NULL
    AND (NEW.subscription_expires_at IS NULL OR NEW.subscription_expires_at > now());

  NEW.purchased_attraction_ids := OLD.purchased_attraction_ids;
  NEW.membership_override_note := OLD.membership_override_note;

  -- 有效订阅镜像 + 旧 ban → 清除 ban；否则保留 admin override
  IF active_sub AND OLD.membership_override = 'ban' THEN
    NEW.membership_override            := NULL;
    NEW.membership_override_expires_at := NULL;
  ELSE
    NEW.membership_override            := OLD.membership_override;
    NEW.membership_override_expires_at := OLD.membership_override_expires_at;
  END IF;

  RETURN NEW;
END;
$$;
