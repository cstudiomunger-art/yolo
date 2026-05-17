-- Admin CMS access: authenticated users listed in admin_users

CREATE TABLE IF NOT EXISTS admin_users (
  user_id    UUID PRIMARY KEY REFERENCES auth.users (id) ON DELETE CASCADE,
  email      TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE admin_users ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Admins read admin_users" ON admin_users;
CREATE POLICY "Admins read admin_users"
  ON admin_users FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1 FROM admin_users WHERE user_id = auth.uid()
  );
$$;

GRANT EXECUTE ON FUNCTION public.is_admin() TO authenticated, anon;

-- app_settings: public read, admin write
DROP POLICY IF EXISTS "App settings publicly readable" ON app_settings;
CREATE POLICY "App settings publicly readable"
  ON app_settings FOR SELECT
  USING (true);

DROP POLICY IF EXISTS "Admins update app_settings" ON app_settings;
CREATE POLICY "Admins update app_settings"
  ON app_settings FOR UPDATE
  TO authenticated
  USING (public.is_admin())
  WITH CHECK (public.is_admin());

-- Content RLS: app reads published/active; admins see and edit all
ALTER TABLE cities ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Public read cities" ON cities;
CREATE POLICY "Public read cities" ON cities FOR SELECT
  USING (is_published = TRUE OR public.is_admin());
DROP POLICY IF EXISTS "Admin insert cities" ON cities;
CREATE POLICY "Admin insert cities" ON cities FOR INSERT TO authenticated
  WITH CHECK (public.is_admin());
DROP POLICY IF EXISTS "Admin update cities" ON cities;
CREATE POLICY "Admin update cities" ON cities FOR UPDATE TO authenticated
  USING (public.is_admin()) WITH CHECK (public.is_admin());
DROP POLICY IF EXISTS "Admin delete cities" ON cities;
CREATE POLICY "Admin delete cities" ON cities FOR DELETE TO authenticated
  USING (public.is_admin());

ALTER TABLE city_routes ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Public read city_routes" ON city_routes;
CREATE POLICY "Public read city_routes" ON city_routes FOR SELECT USING (TRUE);
DROP POLICY IF EXISTS "Admin insert city_routes" ON city_routes;
CREATE POLICY "Admin insert city_routes" ON city_routes FOR INSERT TO authenticated WITH CHECK (public.is_admin());
DROP POLICY IF EXISTS "Admin update city_routes" ON city_routes;
CREATE POLICY "Admin update city_routes" ON city_routes FOR UPDATE TO authenticated
  USING (public.is_admin()) WITH CHECK (public.is_admin());
DROP POLICY IF EXISTS "Admin delete city_routes" ON city_routes;
CREATE POLICY "Admin delete city_routes" ON city_routes FOR DELETE TO authenticated USING (public.is_admin());

ALTER TABLE attractions ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Public read attractions" ON attractions;
CREATE POLICY "Public read attractions" ON attractions FOR SELECT
  USING (is_published = TRUE OR public.is_admin());
DROP POLICY IF EXISTS "Admin insert attractions" ON attractions;
CREATE POLICY "Admin insert attractions" ON attractions FOR INSERT TO authenticated WITH CHECK (public.is_admin());
DROP POLICY IF EXISTS "Admin update attractions" ON attractions;
CREATE POLICY "Admin update attractions" ON attractions FOR UPDATE TO authenticated
  USING (public.is_admin()) WITH CHECK (public.is_admin());
DROP POLICY IF EXISTS "Admin delete attractions" ON attractions;
CREATE POLICY "Admin delete attractions" ON attractions FOR DELETE TO authenticated USING (public.is_admin());

DO $policy$
DECLARE
  t TEXT;
  read_expr TEXT;
BEGIN
  FOREACH t IN ARRAY ARRAY[
    'audio_guides', 'checklist_items', 'shopping_items', 'reading_list', 'hotels', 'home_tips'
  ]
  LOOP
    read_expr := 'is_active = TRUE OR public.is_admin()';
    EXECUTE format('ALTER TABLE %I ENABLE ROW LEVEL SECURITY', t);
    EXECUTE format('DROP POLICY IF EXISTS %I ON %I', 'Public read ' || t, t);
    EXECUTE format(
      'CREATE POLICY %I ON %I FOR SELECT USING (%s)',
      'Public read ' || t, t, read_expr
    );
    EXECUTE format('DROP POLICY IF EXISTS %I ON %I', 'Admin insert ' || t, t);
    EXECUTE format(
      'CREATE POLICY %I ON %I FOR INSERT TO authenticated WITH CHECK (public.is_admin())',
      'Admin insert ' || t, t
    );
    EXECUTE format('DROP POLICY IF EXISTS %I ON %I', 'Admin update ' || t, t);
    EXECUTE format(
      'CREATE POLICY %I ON %I FOR UPDATE TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin())',
      'Admin update ' || t, t
    );
    EXECUTE format('DROP POLICY IF EXISTS %I ON %I', 'Admin delete ' || t, t);
    EXECUTE format(
      'CREATE POLICY %I ON %I FOR DELETE TO authenticated USING (public.is_admin())',
      'Admin delete ' || t, t
    );
  END LOOP;
END
$policy$;

-- Replace home_tips policy from 001 if it only allowed active rows
DROP POLICY IF EXISTS "Home tips publicly readable" ON home_tips;
