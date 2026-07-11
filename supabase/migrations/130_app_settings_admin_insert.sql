-- app_settings had SELECT + UPDATE for admins only; CMS upsert can INSERT when the
-- global row is missing or id was not loaded — add matching INSERT policy.

DROP POLICY IF EXISTS "Admins insert app_settings" ON app_settings;
CREATE POLICY "Admins insert app_settings"
  ON app_settings FOR INSERT
  TO authenticated
  WITH CHECK (public.is_admin());

-- Ensure the singleton row exists (safe if already present).
INSERT INTO app_settings (id)
VALUES ('global')
ON CONFLICT (id) DO NOTHING;
