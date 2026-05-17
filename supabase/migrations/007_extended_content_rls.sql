-- RLS for extended CMS tables (same pattern as 005)

DO $policy$
DECLARE
  t TEXT;
  read_expr TEXT;
BEGIN
  FOREACH t IN ARRAY ARRAY[
    'passport_countries',
    'visa_rules',
    'culture_tips',
    'assistant_replies',
    'content_itineraries'
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

-- emergency_config: always readable; admin write
ALTER TABLE emergency_config ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Public read emergency_config" ON emergency_config;
CREATE POLICY "Public read emergency_config"
  ON emergency_config FOR SELECT
  USING (true);

DROP POLICY IF EXISTS "Admin update emergency_config" ON emergency_config;
CREATE POLICY "Admin update emergency_config"
  ON emergency_config FOR UPDATE
  TO authenticated
  USING (public.is_admin())
  WITH CHECK (public.is_admin());

DROP POLICY IF EXISTS "Admin insert emergency_config" ON emergency_config;
CREATE POLICY "Admin insert emergency_config"
  ON emergency_config FOR INSERT
  TO authenticated
  WITH CHECK (public.is_admin());
