-- Cultural tips: category grouping + optional do/don't examples

ALTER TABLE culture_tips ADD COLUMN IF NOT EXISTS category TEXT NOT NULL DEFAULT 'social';
ALTER TABLE culture_tips ADD COLUMN IF NOT EXISTS do_text TEXT;
ALTER TABLE culture_tips ADD COLUMN IF NOT EXISTS dont_text TEXT;

UPDATE culture_tips SET category = 'food' WHERE id = 'culture_restaurant';
UPDATE culture_tips SET category = 'transport' WHERE id = 'culture_transport';
UPDATE culture_tips SET category = 'social' WHERE id = 'culture_photo';
UPDATE culture_tips SET category = 'payments' WHERE id = 'culture_shopping';
UPDATE culture_tips SET category = 'social', do_text = 'Present gifts with both hands.', dont_text = 'Avoid clocks, green hats, and white wrapping paper.' WHERE id = 'culture_gifts';

INSERT INTO culture_tips (id, emoji, title, preview, body, category, do_text, dont_text, sort_order, is_active)
VALUES (
  'culture_temple',
  '🏯',
  'Temple & Sacred Sites',
  'Dress modestly and speak quietly. Photography may be restricted in prayer halls.',
  'Remove hats in main halls when requested. Walk clockwise around stupas when locals do. Do not touch statues or monks without permission.',
  'temple',
  'Bow slightly when entering main halls.',
  'Do not point feet toward Buddha images.',
  5,
  TRUE
)
ON CONFLICT (id) DO UPDATE SET
  category = EXCLUDED.category,
  do_text = EXCLUDED.do_text,
  dont_text = EXCLUDED.dont_text,
  updated_at = NOW();

INSERT INTO culture_tips (id, emoji, title, preview, body, category, do_text, dont_text, sort_order, is_active)
VALUES (
  'culture_festivals',
  '🎆',
  'Festivals & Holidays',
  'National holidays mean crowded transport and higher hotel prices — book early.',
  'Golden Week (early May) and Lunar New Year see mass travel. Many small shops close during Spring Festival. Temple fairs are lively but crowded.',
  'festivals',
  'Book trains and hotels weeks ahead for Golden Week.',
  'Do not assume restaurants stay open during Lunar New Year.',
  6,
  TRUE
)
ON CONFLICT (id) DO UPDATE SET
  category = EXCLUDED.category,
  do_text = EXCLUDED.do_text,
  dont_text = EXCLUDED.dont_text,
  updated_at = NOW();
