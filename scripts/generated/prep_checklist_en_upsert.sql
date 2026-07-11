-- Deactivate legacy entry/universal items (keep city-specific)
UPDATE checklist_items
SET is_active = FALSE, updated_at = NOW()
WHERE type IN ('entry', 'universal')
  AND id NOT IN ('cl_prep_en_01', 'cl_prep_en_02', 'cl_prep_en_03', 'cl_prep_en_04', 'cl_prep_en_05', 'cl_prep_en_06');

INSERT INTO checklist_items (
  id, type, phase, group_title, title_en, priority,
  why_important, how_to_complete, external_links,
  target_nationalities, target_cities, city_id, display_tags, sort_order, reminder_days_before, is_active
) VALUES
  ('cl_prep_en_01', 'entry', 'before_departure', 'Entry Requirements', 'Check your visa or visa-free eligibility', 'required', 'China''s visa-free policies vary widely by nationality, length of stay, and entry point — mutual exemptions, unilateral exemptions, the 240-hour transit exemption, the Hainan exemption, and more. Getting this wrong can get you denied boarding entirely.', '1. Open the App''s Visa Checker and enter your passport nationality, itinerary cities, and length of stay
2. If you qualify (visa-free or transit visa-free), you''re done — transit visa-free travelers must hold an onward ticket to a third country
3. If you need a visa, apply as early as possible for an L tourist visa at your nearest Chinese embassy or visa center (usually four to seven business days, longer during peak season)', '[{"label":"Open Visa Checker","url":"app://visa-checker"}]'::jsonb, ARRAY[]::text[], ARRAY[]::text[], NULL, ARRAY['key']::text[], 10, 30, TRUE),
  ('cl_prep_en_02', 'entry', 'before_departure', 'Entry Requirements', 'Get your passport and entry documents ready', 'required', 'An expiring passport or missing paperwork can get you denied boarding or denied entry. Passport renewals take weeks, so catch this early.', '1. **Passport**: Must be valid for at least six months beyond your departure date, with one to two blank pages remaining. Renew immediately if it falls short
2. **Backups**: A photocopy of your passport plus a photo on your phone (stored separately from the passport itself), and two to four passport photos
3. **Entry documents**: A return or onward flight ticket (always checked for transit visa-free entry) plus hotel bookings for your entire trip, including addresses in Chinese
4. Carrying the equivalent of five thousand US dollars or more, or twenty thousand yuan in cash, requires a customs declaration', '[]'::jsonb, ARRAY[]::text[], ARRAY[]::text[], NULL, ARRAY['key']::text[], 20, 45, TRUE),
  ('cl_prep_en_03', 'universal', 'before_departure', 'Essential Prep', 'Get your phone ready (payments, data, apps)', 'required', 'Daily life in China runs almost entirely on smartphones — scan-to-pay, ride-hailing, navigation, translation. Land without a ready phone and you''ll struggle from the moment you arrive.', '1. **Payments**: Install both Alipay and WeChat Pay, verify with your passport, and link a foreign card (Visa, Mastercard, JCB, or Amex). Before you leave, call your card issuer to whitelist transactions with Chinese merchants, and carry five hundred to a thousand yuan in cash as backup
2. **Data**: Buy an eSIM that works in China before you land — you can''t purchase or activate one after arrival. A foreign routing option lets you connect directly to Google and WhatsApp
3. **Apps**: Install Didi (ride-hailing), Trip.com (bookings — most reliable for English support and foreign cards), Amap in English mode, and a translation app. Log into each one and download offline maps and translation packs in advance', '[{"label":"Payment setup guide","url":"app://payment-helper"},{"label":"Connectivity options","url":"app://info-hub"}]'::jsonb, ARRAY[]::text[], ARRAY[]::text[], NULL, ARRAY['key']::text[], 10, 5, TRUE),
  ('cl_prep_en_04', 'universal', 'before_departure', 'Essential Prep', 'Book your hotels, high-speed rail, and popular attraction tickets', 'required', 'Some hotels don''t accept foreign passports, high-speed rail tickets sell out, and top attractions offer no on-site tickets — all of this needs to be locked in ahead of time.', '1. **Hotels**: Only book hotels licensed to host foreign guests, and save your confirmation with the address in Chinese so you can show it to a driver
2. **High-speed rail**: Intercity tickets go on sale about fifteen days ahead, and popular routes sell out — Trip.com in English with foreign card support is the easiest option
3. **Attraction tickets**: Top sites like the Forbidden City sell no tickets on site — book with your real name seven to ten days ahead. Check each city''s must-book list for its most in-demand attractions', '[{"label":"Book a hotel","url":"app://plan-hotels"}]'::jsonb, ARRAY[]::text[], ARRAY[]::text[], NULL, ARRAY['key']::text[], 20, 10, TRUE),
  ('cl_prep_en_05', 'universal', 'before_departure', 'Essential Prep', 'Pack smart (medications, power, clothing)', 'recommended', 'Prescription drugs face customs restrictions, outlet standards differ from home, and China''s climate varies enormously from north to south — all three need sorting out before you leave.', '1. **Medications**: Bring enough prescription medicine for your whole trip in its original packaging, along with an English prescription or doctor''s note listing generic names. Pack a small stash of over-the-counter basics (stomach relief, pain relievers, cold medicine), and get travel medical insurance that covers China with 24-hour emergency assistance
2. **Power**: China runs on 220V/50Hz with its own outlet standard, so bring a universal travel adapter (pack one or two spares). Power banks must stay in your carry-on — never checked baggage — and need a CCC mark; anything up to 100Wh travels freely, while 100 to 160Wh needs airline approval
3. **Clothing**: Check the seven-to-ten-day forecast for each destination (temperature, rain, air quality) before you go. Dress in removable layers and pack comfortable walking shoes; bring long pants or a shawl for temple visits. Check each city''s list for specifics', '[{"label":"Medication guide","url":"app://emergency-medical"}]'::jsonb, ARRAY[]::text[], ARRAY[]::text[], NULL, ARRAY[]::text[], 30, NULL, TRUE),
  ('cl_prep_en_06', 'universal', 'before_departure', 'Essential Prep', 'Cover your safety and emergency basics', 'recommended', 'A handful of scams specifically target foreign tourists, and you''ll want emergency numbers saved before anything goes wrong — do this homework before you land and travel with peace of mind.', '1. **Avoiding scams**: Tipping isn''t expected in mainland China. Only use licensed taxis or Didi, and check the license plate matches. Watch for pickpockets on the subway, at night markets, and around attractions. Be wary of street touts pushing "tea ceremonies," art sales, or bars — a classic overcharging scam. Drink bottled or boiled water. Ask permission before photographing people, religious sites, or military and government facilities
2. **Emergency numbers** (save on your phone and on paper): Police 110, Ambulance 120, Fire 119, Government services and complaints 12345, Immigration hotline for foreigners 12367 (English-speaking staff available)
3. **Embassies**: Check your home country''s foreign ministry website for the embassy or consulate nearest your destination, and note the address, phone number, and 24-hour emergency consular line. Save a scan of your passport photo page on your phone and in the cloud', '[{"label":"Embassy assistance","url":"app://emergency"}]'::jsonb, ARRAY[]::text[], ARRAY[]::text[], NULL, ARRAY[]::text[], 40, NULL, TRUE)
ON CONFLICT (id) DO UPDATE SET
  type = EXCLUDED.type,
  phase = EXCLUDED.phase,
  group_title = EXCLUDED.group_title,
  title_en = EXCLUDED.title_en,
  priority = EXCLUDED.priority,
  why_important = EXCLUDED.why_important,
  how_to_complete = EXCLUDED.how_to_complete,
  external_links = EXCLUDED.external_links,
  target_nationalities = EXCLUDED.target_nationalities,
  target_cities = EXCLUDED.target_cities,
  city_id = EXCLUDED.city_id,
  display_tags = EXCLUDED.display_tags,
  sort_order = EXCLUDED.sort_order,
  reminder_days_before = EXCLUDED.reminder_days_before,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();
