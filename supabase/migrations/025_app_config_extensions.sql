-- Extended app_settings: Home cards, flights, AI limits, Paywall copy

ALTER TABLE app_settings ADD COLUMN IF NOT EXISTS home_dashboard_cards JSONB NOT NULL DEFAULT '[
  {"id":"traveler","enabled":true},
  {"id":"countdown","enabled":true},
  {"id":"prep","enabled":true},
  {"id":"get_started","enabled":true}
]'::jsonb;

ALTER TABLE app_settings ADD COLUMN IF NOT EXISTS flight_platforms JSONB NOT NULL DEFAULT '[
  {"id":"skyscanner","label":"Skyscanner","url_template":"https://www.skyscanner.com/"},
  {"id":"google_flights","label":"Google Flights","url_template":"https://www.google.com/travel/flights"},
  {"id":"trip","label":"Trip.com","url_template":"https://www.trip.com/flights/"},
  {"id":"kayak","label":"Kayak","url_template":"https://www.kayak.com/flights/"}
]'::jsonb;

ALTER TABLE app_settings ADD COLUMN IF NOT EXISTS ai_max_trip_days INT NOT NULL DEFAULT 30;
ALTER TABLE app_settings ADD COLUMN IF NOT EXISTS ai_generation_timeout_sec INT NOT NULL DEFAULT 30;
ALTER TABLE app_settings ADD COLUMN IF NOT EXISTS ai_max_cities INT NOT NULL DEFAULT 6;

ALTER TABLE app_settings ADD COLUMN IF NOT EXISTS paywall_title_template TEXT NOT NULL DEFAULT 'Unlock {attraction_name} Audio Guide';
ALTER TABLE app_settings ADD COLUMN IF NOT EXISTS paywall_preview_line_template TEXT NOT NULL DEFAULT '{duration} min · Literary narrative';
ALTER TABLE app_settings ADD COLUMN IF NOT EXISTS paywall_pro_title TEXT NOT NULL DEFAULT 'ChinaGo Pro';
ALTER TABLE app_settings ADD COLUMN IF NOT EXISTS paywall_pro_subtitle TEXT NOT NULL DEFAULT 'Unlock ALL audio guides';
ALTER TABLE app_settings ADD COLUMN IF NOT EXISTS paywall_pro_price_hint TEXT NOT NULL DEFAULT 'Billed annually · Cancel anytime';
ALTER TABLE app_settings ADD COLUMN IF NOT EXISTS paywall_pro_cta TEXT NOT NULL DEFAULT 'Start Pro';
ALTER TABLE app_settings ADD COLUMN IF NOT EXISTS paywall_single_title TEXT NOT NULL DEFAULT 'This Attraction Only';
ALTER TABLE app_settings ADD COLUMN IF NOT EXISTS paywall_single_subtitle TEXT NOT NULL DEFAULT 'One-time purchase · Yours forever';
ALTER TABLE app_settings ADD COLUMN IF NOT EXISTS paywall_single_cta TEXT NOT NULL DEFAULT 'Buy This Guide';
ALTER TABLE app_settings ADD COLUMN IF NOT EXISTS paywall_maybe_later TEXT NOT NULL DEFAULT 'Maybe Later';
ALTER TABLE app_settings ADD COLUMN IF NOT EXISTS paywall_restore TEXT NOT NULL DEFAULT 'Restore Purchase';
ALTER TABLE app_settings ADD COLUMN IF NOT EXISTS paywall_footnote TEXT NOT NULL DEFAULT 'Prices shown in your local currency. Subscriptions renew automatically unless cancelled.';

ALTER TABLE emergency_config ADD COLUMN IF NOT EXISTS help_phrases JSONB NOT NULL DEFAULT '[
  {"chinese":"我需要帮助","pinyin":"Wǒ xūyào bāngzhù","english":"I need help"},
  {"chinese":"请叫警察","pinyin":"Qǐng jiào jǐngchá","english":"Please call the police"},
  {"chinese":"我需要救护车","pinyin":"Wǒ xūyào jiùhùchē","english":"I need an ambulance"}
]'::jsonb;
