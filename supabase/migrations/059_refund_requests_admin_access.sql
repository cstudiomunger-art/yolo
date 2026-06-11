-- 修复后台退款审批失效 + 收紧用户对自己退款状态的写入。
--
-- 现状（049）：user_refund_requests 仅一条策略
--   "Users manage own refund requests" FOR ALL USING (auth.uid() = user_id)
-- 由此产生两个问题：
--   1) 管理员（is_admin）在后台点「通过/拒绝」时，UPDATE 被 RLS 按 user_id 过滤，
--      命中 0 行 —— 不报错但状态没变，审批功能形同虚设。
--   2) 普通用户可 UPDATE 自己申请的 status（虽不触发真实退款，仍是状态污染）。
--
-- 本迁移可独立、立即上线，不影响 App（App 端只 INSERT 申请、SELECT 自己的记录）。

-- 用户：只能新建与查看自己的申请，不能再改 status。
DROP POLICY IF EXISTS "Users manage own refund requests" ON user_refund_requests;

DROP POLICY IF EXISTS "Users insert own refund requests" ON user_refund_requests;
CREATE POLICY "Users insert own refund requests"
  ON user_refund_requests FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users read own refund requests" ON user_refund_requests;
CREATE POLICY "Users read own refund requests"
  ON user_refund_requests FOR SELECT TO authenticated
  USING (auth.uid() = user_id);

-- 管理员：读取并审批所有退款申请。
DROP POLICY IF EXISTS "Admins read all refund requests" ON user_refund_requests;
CREATE POLICY "Admins read all refund requests"
  ON user_refund_requests FOR SELECT TO authenticated
  USING (public.is_admin());

DROP POLICY IF EXISTS "Admins update refund requests" ON user_refund_requests;
CREATE POLICY "Admins update refund requests"
  ON user_refund_requests FOR UPDATE TO authenticated
  USING (public.is_admin())
  WITH CHECK (public.is_admin());
