-- Review before apply. Complements migration 127 seed for known day trips.
UPDATE attractions SET is_day_trip = true
WHERE id IN (
  'chongqing_wulong_karst',
  'beijing_mutianyu_great_wall',
  'chongqing_dazu_rock_carvings'
);
