-- Assistant scenarios master table (CMS-managed labels for scenario_id)

CREATE TABLE IF NOT EXISTS assistant_scenarios (
  id            TEXT PRIMARY KEY,
  label         TEXT NOT NULL,
  description   TEXT,
  sort_order    INT NOT NULL DEFAULT 0,
  is_active     BOOLEAN NOT NULL DEFAULT TRUE,
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS assistant_scenarios_sort_idx ON assistant_scenarios (sort_order);

-- Seed from existing chips (friendly labels) and replies
INSERT INTO assistant_scenarios (id, label, sort_order, is_active)
SELECT DISTINCT ON (s.id)
  s.id,
  COALESCE(c.label, s.id),
  COALESCE(c.sort_order, 0),
  TRUE
FROM (
  SELECT scenario_id AS id FROM assistant_replies
  UNION
  SELECT scenario_id AS id FROM assistant_chips
) AS s
LEFT JOIN assistant_chips c ON c.scenario_id = s.id
ORDER BY s.id, c.sort_order NULLS LAST
ON CONFLICT (id) DO UPDATE SET
  label = EXCLUDED.label,
  sort_order = LEAST(assistant_scenarios.sort_order, EXCLUDED.sort_order),
  updated_at = NOW();

-- RLS (same pattern as assistant_chips)
ALTER TABLE assistant_scenarios ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Public read assistant_scenarios" ON assistant_scenarios;
CREATE POLICY "Public read assistant_scenarios"
  ON assistant_scenarios FOR SELECT
  USING (is_active = TRUE OR public.is_admin());

DROP POLICY IF EXISTS "Admin insert assistant_scenarios" ON assistant_scenarios;
CREATE POLICY "Admin insert assistant_scenarios"
  ON assistant_scenarios FOR INSERT TO authenticated
  WITH CHECK (public.is_admin());

DROP POLICY IF EXISTS "Admin update assistant_scenarios" ON assistant_scenarios;
CREATE POLICY "Admin update assistant_scenarios"
  ON assistant_scenarios FOR UPDATE TO authenticated
  USING (public.is_admin()) WITH CHECK (public.is_admin());

DROP POLICY IF EXISTS "Admin delete assistant_scenarios" ON assistant_scenarios;
CREATE POLICY "Admin delete assistant_scenarios"
  ON assistant_scenarios FOR DELETE TO authenticated
  USING (public.is_admin());
