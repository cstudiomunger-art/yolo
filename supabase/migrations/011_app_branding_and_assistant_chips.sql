-- App branding / copy (CMS-managed) + Assistant quick-reply chips

ALTER TABLE app_settings ADD COLUMN IF NOT EXISTS support_email TEXT NOT NULL DEFAULT 'support@chinago.app';
ALTER TABLE app_settings ADD COLUMN IF NOT EXISTS about_title TEXT NOT NULL DEFAULT 'ChinaGo';
ALTER TABLE app_settings ADD COLUMN IF NOT EXISTS about_version TEXT NOT NULL DEFAULT '1.0.0';
ALTER TABLE app_settings ADD COLUMN IF NOT EXISTS about_body TEXT NOT NULL DEFAULT '';
ALTER TABLE app_settings ADD COLUMN IF NOT EXISTS iap_pro_title TEXT NOT NULL DEFAULT 'ChinaGo Pro';
ALTER TABLE app_settings ADD COLUMN IF NOT EXISTS iap_pro_price TEXT NOT NULL DEFAULT '$19.99/year';
ALTER TABLE app_settings ADD COLUMN IF NOT EXISTS iap_pro_trial_text TEXT NOT NULL DEFAULT '3-day free trial';
ALTER TABLE app_settings ADD COLUMN IF NOT EXISTS iap_pro_features TEXT NOT NULL DEFAULT 'All attraction guides
Unlimited AI planning
Offline download';
ALTER TABLE app_settings ADD COLUMN IF NOT EXISTS iap_single_price_label TEXT NOT NULL DEFAULT 'Buy This Guide · $1.99';
ALTER TABLE app_settings ADD COLUMN IF NOT EXISTS assistant_greeting_general TEXT NOT NULL DEFAULT 'Good morning. How can I assist with your China trip today?';
ALTER TABLE app_settings ADD COLUMN IF NOT EXISTS assistant_greeting_planning TEXT NOT NULL DEFAULT 'Hi! I''m building your itinerary. Tell me: how many days, interests, and budget?';
ALTER TABLE app_settings ADD COLUMN IF NOT EXISTS plan_alert_message TEXT NOT NULL DEFAULT '';
ALTER TABLE app_settings ADD COLUMN IF NOT EXISTS plan_alert_link_attraction_id TEXT;
ALTER TABLE app_settings ADD COLUMN IF NOT EXISTS plan_alert_link_city_id TEXT;
ALTER TABLE app_settings ADD COLUMN IF NOT EXISTS plan_alert_link_label TEXT NOT NULL DEFAULT 'How to Book →';
ALTER TABLE app_settings ADD COLUMN IF NOT EXISTS free_audio_preview_seconds INT NOT NULL DEFAULT 180;

UPDATE app_settings SET
  about_body = COALESCE(NULLIF(about_body, ''), 'Your companion for planning and experiencing travel in China — preparation checklists, AI-assisted itineraries, audio guides, and on-trip assistance.'),
  plan_alert_message = COALESCE(NULLIF(plan_alert_message, ''), 'Forbidden City tickets sell out 3 weeks in advance during your dates.'),
  plan_alert_link_attraction_id = COALESCE(plan_alert_link_attraction_id, 'beijing_forbidden_city'),
  plan_alert_link_city_id = COALESCE(plan_alert_link_city_id, 'beijing')
WHERE id = 'global';

CREATE TABLE IF NOT EXISTS assistant_chips (
  id            TEXT PRIMARY KEY,
  scenario_id   TEXT NOT NULL,
  label         TEXT NOT NULL,
  sort_order    INT NOT NULL DEFAULT 0,
  is_active     BOOLEAN NOT NULL DEFAULT TRUE,
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS assistant_chips_sort_idx ON assistant_chips (sort_order);

INSERT INTO assistant_chips (id, scenario_id, label, sort_order) VALUES
  ('chip_emergency', 'emergency', '🆘 Emergency', 0),
  ('chip_food', 'food', '🍜 Ordering food', 1),
  ('chip_subway', 'subway', '🚇 Subway', 2),
  ('chip_didi', 'didi', '🚕 Didi', 3),
  ('chip_payment', 'payment', '💳 Payment', 4),
  ('chip_etiquette', 'etiquette', '🙏 Etiquette', 5),
  ('chip_great_wall', 'great_wall', '🏔 Great Wall', 6),
  ('chip_passport', 'passport', '📛 Lost passport', 7)
ON CONFLICT (id) DO NOTHING;

-- RLS for assistant_chips
ALTER TABLE assistant_chips ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Public read assistant_chips" ON assistant_chips;
CREATE POLICY "Public read assistant_chips"
  ON assistant_chips FOR SELECT
  USING (is_active = TRUE OR public.is_admin());

DROP POLICY IF EXISTS "Admin insert assistant_chips" ON assistant_chips;
CREATE POLICY "Admin insert assistant_chips"
  ON assistant_chips FOR INSERT TO authenticated
  WITH CHECK (public.is_admin());

DROP POLICY IF EXISTS "Admin update assistant_chips" ON assistant_chips;
CREATE POLICY "Admin update assistant_chips"
  ON assistant_chips FOR UPDATE TO authenticated
  USING (public.is_admin()) WITH CHECK (public.is_admin());

DROP POLICY IF EXISTS "Admin delete assistant_chips" ON assistant_chips;
CREATE POLICY "Admin delete assistant_chips"
  ON assistant_chips FOR DELETE TO authenticated
  USING (public.is_admin());
