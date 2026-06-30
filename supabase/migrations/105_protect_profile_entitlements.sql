-- 堵住客户端伪造会员状态：普通用户（authenticated）不得通过 App 写入
-- subscription_* / purchased_attraction_ids / rc_customer_id / membership_override_*。
-- 只有 service_role（未来 webhook）与 CMS 管理员（is_admin）可改。
--
-- 会员在 App 内的真相源是 RevenueCat；profiles 上的订阅列仅供后台查看，
-- 由管理员手动维护或日后 webhook 回写。override 列由后台「封禁/赠送」操作写入。
--
-- 取代 104 的 protect_membership_override 触发器 + 060 草案，合并为单一触发器。

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
    NEW.subscription_plan_id             := NULL;
    NEW.subscription_expires_at          := NULL;
    NEW.purchased_attraction_ids         := '{}';
    NEW.rc_customer_id                   := NULL;
    NEW.membership_override              := NULL;
    NEW.membership_override_expires_at   := NULL;
    NEW.membership_override_note         := NULL;
    RETURN NEW;
  END IF;

  -- UPDATE：实体列一律还原，忽略客户端传入。
  NEW.subscription_plan_id             := OLD.subscription_plan_id;
  NEW.subscription_expires_at          := OLD.subscription_expires_at;
  NEW.purchased_attraction_ids         := OLD.purchased_attraction_ids;
  NEW.rc_customer_id                   := OLD.rc_customer_id;
  NEW.membership_override              := OLD.membership_override;
  NEW.membership_override_expires_at   := OLD.membership_override_expires_at;
  NEW.membership_override_note         := OLD.membership_override_note;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS protect_membership_override ON profiles;
DROP TRIGGER IF EXISTS protect_profile_entitlements ON profiles;

CREATE TRIGGER protect_profile_client_entitlements
  BEFORE INSERT OR UPDATE ON profiles
  FOR EACH ROW
  EXECUTE FUNCTION public.protect_profile_client_entitlements();
