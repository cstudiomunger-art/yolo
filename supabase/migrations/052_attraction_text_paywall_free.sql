-- Per-attraction override: bypass text paywall for free/demo attractions
ALTER TABLE attractions
  ADD COLUMN IF NOT EXISTS text_paywall_free BOOLEAN NOT NULL DEFAULT FALSE;

COMMENT ON COLUMN attractions.text_paywall_free IS
  'When true, full text content and visitor tips are free for this attraction regardless of global paywall settings.';
