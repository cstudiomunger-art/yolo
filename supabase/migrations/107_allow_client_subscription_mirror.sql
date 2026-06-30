-- App 购买后需把 RevenueCat 订阅状态镜像到 profiles，供后台展示。
-- 105 误锁了 subscription_* / rc_customer_id，导致 App 无法回写，后台永远看不到会员。
--
-- 策略：
--   · subscription_plan_id / subscription_expires_at / rc_customer_id → 客户端可写（镜像，仅供后台看）
--   · membership_override_* / purchased_attraction_ids → 仍仅管理员 / service_role 可写
--   · App 内会员判定仍以 RevenueCat + override 为准，不信任远程 subscription_* 拉取

CREATE OR REPLACE FUNCTION public.protect_profile_client_entitlements()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
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

  -- UPDATE：仅锁定 override 与单购列表；subscription_* 允许 App 镜像 RC 状态。
  NEW.purchased_attraction_ids         := OLD.purchased_attraction_ids;
  NEW.membership_override              := OLD.membership_override;
  NEW.membership_override_expires_at   := OLD.membership_override_expires_at;
  NEW.membership_override_note         := OLD.membership_override_note;

  RETURN NEW;
END;
$$;
