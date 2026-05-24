-- CMS admins: read/update all app user profiles (purchases, Pro flag, prefs).

DROP POLICY IF EXISTS "Admins read all profiles" ON profiles;
CREATE POLICY "Admins read all profiles"
  ON profiles FOR SELECT TO authenticated
  USING (public.is_admin());

DROP POLICY IF EXISTS "Admins update all profiles" ON profiles;
CREATE POLICY "Admins update all profiles"
  ON profiles FOR UPDATE TO authenticated
  USING (public.is_admin())
  WITH CHECK (public.is_admin());

-- CMS admins: list all CMS operator accounts.
DROP POLICY IF EXISTS "Admins read all admin_users" ON admin_users;
CREATE POLICY "Admins read all admin_users"
  ON admin_users FOR SELECT TO authenticated
  USING (public.is_admin());
