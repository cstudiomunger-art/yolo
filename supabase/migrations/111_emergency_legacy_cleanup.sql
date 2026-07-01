-- Align emergency CMS with redesigned Emergency page.

UPDATE emergency_config
SET contacts = '[
  {"label": "Police", "number": "110", "note": "24/7 emergency"},
  {"label": "Ambulance", "number": "120", "note": "Medical emergency"}
]'::jsonb,
    updated_at = NOW()
WHERE id = 'global';

DROP POLICY IF EXISTS "Public read emergency_guides" ON emergency_guides;
DROP POLICY IF EXISTS "Admin insert emergency_guides" ON emergency_guides;
DROP POLICY IF EXISTS "Admin update emergency_guides" ON emergency_guides;
DROP POLICY IF EXISTS "Admin delete emergency_guides" ON emergency_guides;
DROP TABLE IF EXISTS emergency_guides;
