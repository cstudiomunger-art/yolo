-- P0 scheduling columns for attractions + city centers + optional second-LLM disable flag.

ALTER TABLE attractions ADD COLUMN IF NOT EXISTS latitude double precision;
ALTER TABLE attractions ADD COLUMN IF NOT EXISTS longitude double precision;
ALTER TABLE attractions ADD COLUMN IF NOT EXISTS is_day_trip boolean NOT NULL DEFAULT false;
ALTER TABLE attractions ADD COLUMN IF NOT EXISTS distance_from_center_km double precision;
ALTER TABLE attractions ADD COLUMN IF NOT EXISTS duration_slots_min numeric(2,1);
ALTER TABLE attractions ADD COLUMN IF NOT EXISTS duration_slots_max numeric(2,1);

ALTER TABLE cities ADD COLUMN IF NOT EXISTS center_lat double precision;
ALTER TABLE cities ADD COLUMN IF NOT EXISTS center_lng double precision;

ALTER TABLE app_settings ADD COLUMN IF NOT EXISTS ai_disable_second_llm_pass boolean NOT NULL DEFAULT false;

COMMENT ON COLUMN attractions.is_day_trip IS 'Full-day / far-suburb sight; must not share calendar day with urban stops';
COMMENT ON COLUMN attractions.duration_slots_min IS 'Scheduler slot budget (min); overrides recommended_duration text when set';
COMMENT ON COLUMN app_settings.ai_disable_second_llm_pass IS 'When true, skip day_plans regeneration retry after heavy schedule repairs';

-- Known day-trip flags (DB ids only; no jinshanling until seeded)
UPDATE attractions SET is_day_trip = true
WHERE id IN (
  'chongqing_wulong_karst',
  'beijing_mutianyu_great_wall',
  'chongqing_dazu_rock_carvings'
);
