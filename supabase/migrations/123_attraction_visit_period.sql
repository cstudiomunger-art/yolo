-- P2: structured visit period for itinerary scheduling (Evening slot).
ALTER TABLE attractions
  ADD COLUMN IF NOT EXISTS recommended_visit_period text
    CHECK (recommended_visit_period IN ('morning', 'afternoon', 'evening', 'flexible')),
  ADD COLUMN IF NOT EXISTS attraction_kind text;

COMMENT ON COLUMN attractions.recommended_visit_period IS
  'Planner hint: evening-only sights (night markets, pedestrian streets) must not fill Morning/Afternoon slots.';
COMMENT ON COLUMN attractions.attraction_kind IS
  'Optional taxonomy e.g. commercial_street, night_market — used when backfilling visit_period.';

-- Core-city evening backfill (explicit CMS labels only; no close_time inference).
UPDATE attractions SET
  recommended_visit_period = 'evening',
  attraction_kind = 'commercial_street',
  updated_at = NOW()
WHERE id = 'chongqing_guanyinqiao';

UPDATE attractions SET
  recommended_visit_period = 'evening',
  attraction_kind = 'night_market',
  updated_at = NOW()
WHERE id = 'chongqing_jiujie';

UPDATE attractions SET
  recommended_visit_period = 'evening',
  attraction_kind = 'commercial_street',
  updated_at = NOW()
WHERE id = 'hangzhou_hefang_street';

-- Default flexible for existing rows without a value.
UPDATE attractions SET recommended_visit_period = 'flexible'
WHERE recommended_visit_period IS NULL;
