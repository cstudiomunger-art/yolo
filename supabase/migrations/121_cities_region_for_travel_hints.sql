ALTER TABLE cities
  ADD COLUMN IF NOT EXISTS region text;

UPDATE cities
SET region = CASE id
  WHEN 'beijing' THEN 'north_china'
  WHEN 'shanghai' THEN 'yangtze_delta'
  WHEN 'nanjing' THEN 'yangtze_delta'
  WHEN 'hangzhou' THEN 'yangtze_delta'
  WHEN 'suzhou' THEN 'yangtze_delta'
  WHEN 'chengdu' THEN 'southwest'
  WHEN 'chongqing' THEN 'southwest'
  ELSE region
END
WHERE region IS NULL;
