-- 历史数据：后台只写了 subscription_* 未写 membership_override=grant 时，App 不会解锁。
-- 将仍有效的后台订阅镜像补写为 grant（已有 ban / grant 的不动）。

UPDATE profiles
SET
  membership_override            = 'grant',
  membership_override_expires_at = subscription_expires_at
WHERE membership_override IS NULL
  AND subscription_plan_id IS NOT NULL
  AND (subscription_expires_at IS NULL OR subscription_expires_at > now());
