-- Admin Management: Allow admins to add/remove other admins
-- This migration enables UI-based admin management instead of requiring manual SQL

-- Allow admins to insert new admin users
DROP POLICY IF EXISTS "Admins insert admin_users" ON admin_users;
CREATE POLICY "Admins insert admin_users"
  ON admin_users FOR INSERT TO authenticated
  WITH CHECK (public.is_admin());

-- Allow admins to delete admin users
DROP POLICY IF EXISTS "Admins delete admin_users" ON admin_users;
CREATE POLICY "Admins delete admin_users"
  ON admin_users FOR DELETE TO authenticated
  USING (public.is_admin());