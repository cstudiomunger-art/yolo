-- Visa city×policy matrix — DB-enforced derivation (铁律：派生不手填).
-- Ports the delivery-package build_matrix.py logic into Postgres so editing a policy's
-- allowed_area (or cities / permit zones) in the admin automatically refreshes
-- visa_city_policy_matrix. No more manual recompute / drift between rule and matrix.

-- ── Code matcher: province code (XX0000) prefix-expands; prefecture code exact ──
CREATE OR REPLACE FUNCTION visa_code_matches(code TEXT, city_id TEXT)
RETURNS BOOLEAN
LANGUAGE sql IMMUTABLE
AS $$
  SELECT code = city_id
      OR (right(code, 4) = '0000' AND left(code, 2) = left(city_id, 2));
$$;

-- ── Feasibility for one (policy, city): no / permit_required / ok ──
CREATE OR REPLACE FUNCTION visa_feasibility(allowed JSONB, city_id TEXT)
RETURNS TABLE (feasibility TEXT, note TEXT)
LANGUAGE sql STABLE
AS $$
  WITH reach AS (
    SELECT CASE
      WHEN jsonb_typeof(allowed) = 'string' AND allowed #>> '{}' = 'national' THEN TRUE
      WHEN jsonb_typeof(allowed) = 'array' THEN EXISTS (
        SELECT 1 FROM jsonb_array_elements_text(allowed) e(code)
        WHERE visa_code_matches(e.code, city_id))
      ELSE FALSE
    END AS reachable
  ),
  permit AS (
    SELECT EXISTS (
      SELECT 1 FROM visa_permit_zones z WHERE visa_code_matches(z.admin_code, city_id)
    ) AS in_permit
  )
  SELECT
    CASE WHEN NOT r.reachable THEN 'no'
         WHEN p.in_permit THEN 'permit_required'
         ELSE 'ok' END,
    CASE WHEN r.reachable AND p.in_permit THEN '需额外许可（如入藏许可）' ELSE NULL END
  FROM reach r, permit p;
$$;

-- ── Recompute matrix rows for one policy (all cities) ──
CREATE OR REPLACE FUNCTION visa_recompute_matrix_for_policy(p_id TEXT)
RETURNS VOID
LANGUAGE plpgsql
AS $$
BEGIN
  DELETE FROM visa_city_policy_matrix WHERE policy_id = p_id;
  INSERT INTO visa_city_policy_matrix (city_id, policy_id, feasibility, note)
  SELECT c.city_id, pol.id, f.feasibility, f.note
  FROM visa_policies_v2 pol
  CROSS JOIN visa_cities c
  CROSS JOIN LATERAL visa_feasibility(pol.allowed_area, c.city_id) f
  WHERE pol.id = p_id;
END;
$$;

-- ── Recompute matrix rows for one city (all policies) ──
CREATE OR REPLACE FUNCTION visa_recompute_matrix_for_city(c_id TEXT)
RETURNS VOID
LANGUAGE plpgsql
AS $$
BEGIN
  DELETE FROM visa_city_policy_matrix WHERE city_id = c_id;
  INSERT INTO visa_city_policy_matrix (city_id, policy_id, feasibility, note)
  SELECT c.city_id, pol.id, f.feasibility, f.note
  FROM visa_cities c
  CROSS JOIN visa_policies_v2 pol
  CROSS JOIN LATERAL visa_feasibility(pol.allowed_area, c.city_id) f
  WHERE c.city_id = c_id;
END;
$$;

-- ── Recompute everything (permit-zone change / manual re-anchor) ──
CREATE OR REPLACE FUNCTION visa_recompute_matrix_all()
RETURNS VOID
LANGUAGE plpgsql
AS $$
DECLARE p RECORD;
BEGIN
  FOR p IN SELECT id FROM visa_policies_v2 LOOP
    PERFORM visa_recompute_matrix_for_policy(p.id);
  END LOOP;
END;
$$;

-- ── Triggers ──
CREATE OR REPLACE FUNCTION visa_trg_policy_matrix() RETURNS TRIGGER
LANGUAGE plpgsql AS $$
BEGIN
  PERFORM visa_recompute_matrix_for_policy(NEW.id);
  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION visa_trg_city_matrix() RETURNS TRIGGER
LANGUAGE plpgsql AS $$
BEGIN
  PERFORM visa_recompute_matrix_for_city(NEW.city_id);
  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION visa_trg_permit_matrix() RETURNS TRIGGER
LANGUAGE plpgsql AS $$
BEGIN
  PERFORM visa_recompute_matrix_all();
  RETURN NULL;
END;
$$;

-- Policy: recompute that policy when allowed_area changes (or a new policy is added).
DROP TRIGGER IF EXISTS visa_policy_matrix_sync ON visa_policies_v2;
CREATE TRIGGER visa_policy_matrix_sync
  AFTER INSERT OR UPDATE OF allowed_area ON visa_policies_v2
  FOR EACH ROW EXECUTE FUNCTION visa_trg_policy_matrix();

-- City: recompute that city across all policies when added / its code changes.
DROP TRIGGER IF EXISTS visa_city_matrix_sync ON visa_cities;
CREATE TRIGGER visa_city_matrix_sync
  AFTER INSERT OR UPDATE OF city_id ON visa_cities
  FOR EACH ROW EXECUTE FUNCTION visa_trg_city_matrix();

-- Permit zone: any change flips ok ↔ permit_required for matched cities → recompute all.
DROP TRIGGER IF EXISTS visa_permit_matrix_sync ON visa_permit_zones;
CREATE TRIGGER visa_permit_matrix_sync
  AFTER INSERT OR UPDATE OR DELETE ON visa_permit_zones
  FOR EACH STATEMENT EXECUTE FUNCTION visa_trg_permit_matrix();

-- One-time consistency anchor: regenerate the whole matrix from current rules.
SELECT visa_recompute_matrix_all();
