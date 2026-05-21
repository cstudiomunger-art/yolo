-- Hotel cover image and navigable address (CMS + app Book Your Trip)

ALTER TABLE hotels ADD COLUMN IF NOT EXISTS cover_image_path TEXT;
ALTER TABLE hotels ADD COLUMN IF NOT EXISTS address_zh TEXT;
ALTER TABLE hotels ADD COLUMN IF NOT EXISTS address_en TEXT;
ALTER TABLE hotels ADD COLUMN IF NOT EXISTS latitude DOUBLE PRECISION;
ALTER TABLE hotels ADD COLUMN IF NOT EXISTS longitude DOUBLE PRECISION;
