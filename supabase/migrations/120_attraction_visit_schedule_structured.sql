-- Structured visit schedule for itinerary parity across Edge/Swift.
ALTER TABLE attractions
  ADD COLUMN IF NOT EXISTS planning_zone text,
  ADD COLUMN IF NOT EXISTS closed_weekdays text[] DEFAULT '{}',
  ADD COLUMN IF NOT EXISTS open_time text,
  ADD COLUMN IF NOT EXISTS close_time text,
  ADD COLUMN IF NOT EXISTS last_entry_time text;

-- Backfill closed_weekdays from legacy closed_days text (best-effort).
UPDATE attractions
SET closed_weekdays = (
  SELECT ARRAY(
    SELECT DISTINCT day_key
    FROM (
      SELECT CASE WHEN closed_days ~* '(monday|mon)' THEN 'mon' END AS day_key
      UNION ALL SELECT CASE WHEN closed_days ~* '(tuesday|tue)' THEN 'tue' END
      UNION ALL SELECT CASE WHEN closed_days ~* '(wednesday|wed)' THEN 'wed' END
      UNION ALL SELECT CASE WHEN closed_days ~* '(thursday|thu)' THEN 'thu' END
      UNION ALL SELECT CASE WHEN closed_days ~* '(friday|fri)' THEN 'fri' END
      UNION ALL SELECT CASE WHEN closed_days ~* '(saturday|sat)' THEN 'sat' END
      UNION ALL SELECT CASE WHEN closed_days ~* '(sunday|sun)' THEN 'sun' END
    ) x
    WHERE day_key IS NOT NULL
  )
)
WHERE (closed_weekdays IS NULL OR cardinality(closed_weekdays) = 0)
  AND closed_days IS NOT NULL
  AND btrim(closed_days) <> '';

-- Backfill opening/closing time from legacy opening_hours text (HH:MM-HH:MM pattern).
UPDATE attractions
SET
  open_time = COALESCE(open_time, regexp_replace(opening_hours, '^.*?([0-2]?\d:[0-5]\d).*$','\1')),
  close_time = COALESCE(close_time, regexp_replace(opening_hours, '^.*?[0-2]?\d:[0-5]\d[^0-9]*([0-2]?\d:[0-5]\d).*$','\1'))
WHERE opening_hours ~ '([0-2]?\d:[0-5]\d).*([0-2]?\d:[0-5]\d)';
