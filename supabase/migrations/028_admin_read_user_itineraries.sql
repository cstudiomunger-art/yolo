-- Allow CMS admins to view user-saved trips (read-only in admin UI; writes use user RLS).

DROP POLICY IF EXISTS "Admin read user_itineraries" ON user_itineraries;
CREATE POLICY "Admin read user_itineraries" ON user_itineraries FOR SELECT TO authenticated
  USING (public.is_admin());
