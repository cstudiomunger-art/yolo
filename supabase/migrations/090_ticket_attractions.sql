-- Ticket-pain-point attractions for the marketing site's /attraction-tickets pages.
-- CMS-managed (admin-vue) so booking rules, release schedule and the countdown are
-- editable without a code change. Public read of active rows; admin-only writes.

CREATE TABLE IF NOT EXISTS ticket_attractions (
  slug               TEXT PRIMARY KEY,           -- URL key, e.g. "forbidden-city"
  name               TEXT NOT NULL,
  name_zh            TEXT,
  city               TEXT,
  status             TEXT NOT NULL DEFAULT 'coming-soon',  -- 'live' | 'coming-soon'
  blurb              TEXT,
  advance_days       INT,                         -- tickets open ~N days ahead (null = unknown)
  release_time       TEXT,                        -- daily release "HH:MM" Beijing time; null = no countdown
  release_note       TEXT,                        -- caveat/source shown under the countdown
  closed             TEXT,
  official_url       TEXT,
  passport_required  BOOLEAN NOT NULL DEFAULT TRUE,
  rules              JSONB NOT NULL DEFAULT '[]'::jsonb,    -- array of strings
  passport_note      TEXT,
  display_order      INT NOT NULL DEFAULT 0,
  is_active          BOOLEAN NOT NULL DEFAULT TRUE,
  updated_at         TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE ticket_attractions ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Public read ticket_attractions" ON ticket_attractions;
CREATE POLICY "Public read ticket_attractions" ON ticket_attractions FOR SELECT
  USING (is_active = TRUE OR public.is_admin());

DROP POLICY IF EXISTS "Admin write ticket_attractions" ON ticket_attractions;
CREATE POLICY "Admin write ticket_attractions" ON ticket_attractions FOR ALL TO authenticated
  USING (public.is_admin()) WITH CHECK (public.is_admin());

-- Seed: the four launch entries (mirror of the site's committed fallback seed).
INSERT INTO ticket_attractions
  (slug, name, name_zh, city, status, blurb, advance_days, release_time, release_note, closed, official_url, passport_required, rules, passport_note, display_order)
VALUES
  (
    'forbidden-city', 'Forbidden City', '故宫 · Palace Museum', 'Beijing', 'live',
    'China''s most-visited museum sells out days ahead, and the official booking flow assumes you have a Chinese ID. Here''s how foreign passport holders actually get a ticket.',
    7, '20:00',
    'Tickets are commonly reported to open daily around 20:00 Beijing time, ~7 days ahead. Always confirm the exact time on the official Palace Museum site before relying on it.',
    'Most Mondays (except public holidays)', 'https://en.dpm.org.cn/', TRUE,
    '["Real-name and passport-based: each ticket is tied to one passport, and the name must match your passport exactly.","Tickets are released a set number of days in advance and sell out fast in peak season — book the moment they open.","Closed most Mondays — plan your day around it.","Bring the physical passport you booked with; it is checked against your ticket at the gate."]'::jsonb,
    'Enter your name exactly as printed in the machine-readable zone of your passport — Latin letters only, surname and given names.',
    0
  ),
  (
    'great-wall-mutianyu', 'Great Wall (Mutianyu)', '慕田峪长城', 'Beijing', 'coming-soon',
    'Timed-entry tickets, shuttle buses and cable cars — which to pre-book and how, for foreign visitors.',
    NULL, NULL, NULL, NULL, NULL, TRUE, '[]'::jsonb, NULL, 1
  ),
  (
    'terracotta-army', 'Terracotta Army', '兵马俑', 'Xi''an', 'coming-soon',
    'Real-name, passport-based booking for the Emperor Qinshihuang''s Mausoleum site — the foreigner path, step by step.',
    NULL, NULL, NULL, NULL, NULL, TRUE, '[]'::jsonb, NULL, 2
  ),
  (
    'chengdu-panda-base', 'Chengdu Panda Base', '成都大熊猫繁育研究基地', 'Chengdu', 'coming-soon',
    'Daily ticket caps sell out at sunrise. When they release, how to book on a foreign passport, and the best arrival time.',
    NULL, NULL, NULL, NULL, NULL, TRUE, '[]'::jsonb, NULL, 3
  )
ON CONFLICT (slug) DO NOTHING;
