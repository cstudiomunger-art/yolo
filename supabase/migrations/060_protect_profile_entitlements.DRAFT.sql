-- ⚠️ 草案 / 暂勿在生产执行 —— 见文件底部「上线前提」。
--
-- 目的：堵住付费墙的服务端漏洞。
-- 现状：profiles 的 "Users can update own profile" 策略不限制列，会员/购买状态
--       又完全由客户端写入（UserPreferencesStore.makeProfileRow → ProfileSyncService）。
--       anon key 是公开的，任何登录用户可直接 PATCH 自己的 subscription_* /
--       purchased_attraction_ids，自助开通终身会员、解锁全部付费内容。
--
-- 方案：BEFORE UPDATE 触发器。普通用户改自己的 profile 时，强制「实体列」保持原值；
--       只有 service_role（RevenueCat webhook / Edge Function）与 CMS 管理员可改。
--       不用列级 GRANT，是因为那会同时挡住走 authenticated 角色的 CMS 管理员。

CREATE OR REPLACE FUNCTION public.protect_profile_entitlement_columns()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  -- 后端（service_role）与后台管理员可任意更新实体列。
  IF auth.role() = 'service_role' OR public.is_admin() THEN
    RETURN NEW;
  END IF;

  -- 普通用户改自己 profile：实体列一律还原为旧值，忽略客户端传入。
  NEW.subscription_plan_id     := OLD.subscription_plan_id;
  NEW.subscription_expires_at  := OLD.subscription_expires_at;
  NEW.purchased_attraction_ids := OLD.purchased_attraction_ids;
  NEW.is_pro                   := OLD.is_pro;
  NEW.rc_customer_id           := OLD.rc_customer_id;

  -- 头像审核状态：当前无服务端审核函数（moderate-avatar 已在 685366e 移除），
  -- avatar_status 仍由客户端写。若日后恢复服务端审核，取消下一行注释即可一并锁定。
  -- NEW.avatar_status         := OLD.avatar_status;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS protect_profile_entitlements ON profiles;
CREATE TRIGGER protect_profile_entitlements
  BEFORE UPDATE ON profiles
  FOR EACH ROW
  EXECUTE FUNCTION public.protect_profile_entitlement_columns();

-- ───────────────────────────────────────────────────────────────────────────
-- 上线前提（务必先满足，否则会打断当前流程）：
--
-- 1. PurchaseService 仍是「模拟购买」：purchase() / purchaseSingleAttraction()
--    直接在客户端写 subscriptionPlanId / purchasedAttractionIds 再 push。
--    本触发器一旦生效，这些写入会被静默还原 —— 模拟购买将彻底失效。
--    因此本迁移必须与「服务端写入会员状态」一起上线：
--      · 接入 RevenueCat，由其 webhook（service_role）回写 subscription_*；
--      · 单买景点改为经 Edge Function（service_role）校验后写 purchased_attraction_ids。
--
-- 2. 上线后请人工验证：
--    a) 普通用户 PATCH 自己的 subscription_plan_id → 列值不变（攻击被挡）。
--    b) CMS 管理员在后台改某用户会员 → 成功（is_admin 放行）。
--    c) RevenueCat webhook 回写 → 成功（service_role 放行）。
--
-- 准备好后，将文件改名为 060_protect_profile_entitlements.sql 再纳入迁移序列。
