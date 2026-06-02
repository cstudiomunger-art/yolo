-- 044: Add city_id to culture_tips to support city-specific tips
-- NULL city_id = universal tip (shown to all users with a saved itinerary)
-- Non-null city_id = city-specific tip (shown when itinerary contains that city)

ALTER TABLE culture_tips
  ADD COLUMN IF NOT EXISTS city_id TEXT REFERENCES cities (id) ON DELETE SET NULL;
