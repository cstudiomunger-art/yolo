-- 046: Drop FK constraint on culture_tips.city_id and re-seed city tips
-- The FK caused insert failures when cities table is partially seeded.
-- city_id remains a plain TEXT column; referential integrity is managed by the admin.

ALTER TABLE culture_tips
  DROP CONSTRAINT IF EXISTS culture_tips_city_id_fkey;

-- Universal tips
INSERT INTO culture_tips (id, emoji, title, preview, body, category, do_text, dont_text, sort_order, is_active, city_id)
VALUES (
  'culture_qr_payment', '📱', 'QR Code Payments',
  'Cash is rarely used in China. Set up Alipay or WeChat Pay before you arrive.',
  'Almost every vendor — from street food stalls to malls — accepts QR payments. Have your app open and ready. Many places no longer accept cash at all. Link an international card via Alipay International.',
  'payments',
  'Set up Alipay International before departure. Have a backup card linked.',
  'Rely on cash alone — many vendors will turn you away.',
  10, TRUE, NULL
)
ON CONFLICT (id) DO UPDATE SET
  preview = EXCLUDED.preview, body = EXCLUDED.body,
  do_text = EXCLUDED.do_text, dont_text = EXCLUDED.dont_text,
  city_id = EXCLUDED.city_id, updated_at = NOW();

INSERT INTO culture_tips (id, emoji, title, preview, body, category, do_text, dont_text, sort_order, is_active, city_id)
VALUES (
  'culture_face_saving', '🤝', 'Face (面子) & Social Harmony',
  'Avoid causing embarrassment in public. Disagreements are handled privately, not in front of others.',
  'The concept of "face" (mianzi) is central to Chinese social life. Criticising someone publicly — even gently — can cause lasting embarrassment. If something goes wrong, address it calmly and privately. Complimenting your host goes a long way.',
  'social',
  'Express gratitude openly. Compliment the food, the city, the experience.',
  'Argue loudly in public or correct someone in front of others.',
  11, TRUE, NULL
)
ON CONFLICT (id) DO UPDATE SET
  preview = EXCLUDED.preview, body = EXCLUDED.body,
  do_text = EXCLUDED.do_text, dont_text = EXCLUDED.dont_text,
  city_id = EXCLUDED.city_id, updated_at = NOW();

-- Beijing
INSERT INTO culture_tips (id, emoji, title, preview, body, category, do_text, dont_text, sort_order, is_active, city_id)
VALUES (
  'culture_beijing_hutong', '🏘', 'Hutong Etiquette',
  'Hutongs are lived-in neighbourhoods, not theme parks. Residents appreciate quiet visitors.',
  'Beijing''s hutongs are residential alleyways where people actually live. Keep noise down, don''t peek into open courtyards uninvited, and ask permission before photographing residents or their homes. Early morning is the best time to visit — fewer crowds, more authentic atmosphere.',
  'social',
  'Walk slowly, observe, and ask locals for directions — they''re often happy to help.',
  'Treat hutongs like a tourist attraction — loud groups and selfie sticks are unwelcome.',
  20, TRUE, 'beijing'
)
ON CONFLICT (id) DO UPDATE SET
  preview = EXCLUDED.preview, body = EXCLUDED.body,
  do_text = EXCLUDED.do_text, dont_text = EXCLUDED.dont_text,
  city_id = EXCLUDED.city_id, updated_at = NOW();

INSERT INTO culture_tips (id, emoji, title, preview, body, category, do_text, dont_text, sort_order, is_active, city_id)
VALUES (
  'culture_beijing_temple', '🏯', 'Temple of Heaven & Tiananmen Etiquette',
  'Dress modestly and keep voices low inside temple grounds. Photography rules vary by section.',
  'At the Temple of Heaven, locals use the park daily for tai chi, opera singing, and group dancing — you''re welcome to watch respectfully. At Tiananmen Square and the Forbidden City, bags go through security checks. Photography is restricted inside certain palace halls — follow posted signs.',
  'temple',
  'Arrive early (before 8am) to see locals practising tai chi in the park.',
  'Enter restricted palace halls with a camera raised — follow the posted signs.',
  21, TRUE, 'beijing'
)
ON CONFLICT (id) DO UPDATE SET
  preview = EXCLUDED.preview, body = EXCLUDED.body,
  do_text = EXCLUDED.do_text, dont_text = EXCLUDED.dont_text,
  city_id = EXCLUDED.city_id, updated_at = NOW();

-- Shanghai
INSERT INTO culture_tips (id, emoji, title, preview, body, category, do_text, dont_text, sort_order, is_active, city_id)
VALUES (
  'culture_shanghai_pace', '🌆', 'Shanghai''s Fast Pace',
  'Shanghai moves fast. Stand on the right of escalators and step aside on busy pavements.',
  'Shanghai is one of China''s most cosmopolitan cities — English signage is common and locals are generally used to foreigners. The city moves quickly: stand to the right on escalators, keep walking on the left, and be decisive when ordering. The Bund area gets extremely crowded on weekends — visit on a weekday morning for the best experience.',
  'transport',
  'Use the metro app (Metro Daduhui) offline — it works without a VPN.',
  'Walk slowly in the middle of busy footpaths during rush hour.',
  30, TRUE, 'shanghai'
)
ON CONFLICT (id) DO UPDATE SET
  preview = EXCLUDED.preview, body = EXCLUDED.body,
  do_text = EXCLUDED.do_text, dont_text = EXCLUDED.dont_text,
  city_id = EXCLUDED.city_id, updated_at = NOW();

-- Chengdu
INSERT INTO culture_tips (id, emoji, title, preview, body, category, do_text, dont_text, sort_order, is_active, city_id)
VALUES (
  'culture_chengdu_hotpot', '🌶', 'Chengdu Hotpot Culture',
  'Hotpot is a social event. Meals last 2–3 hours. The spice level is serious — order mild (微辣) if unsure.',
  'Chengdu hotpot is a beloved ritual — friends gather around a bubbling pot for hours. If you''re not used to Sichuan spice, order the split pot (鸳鸯锅) with one spicy and one mild side. Sesame oil dipping sauce is provided — mix your own. It''s normal and expected to make noise, laugh, and linger.',
  'food',
  'Try the sesame oil dip — it cools the spice and adds flavour.',
  'Rush the meal or leave quickly — hotpot is about the experience, not efficiency.',
  40, TRUE, 'chengdu'
)
ON CONFLICT (id) DO UPDATE SET
  preview = EXCLUDED.preview, body = EXCLUDED.body,
  do_text = EXCLUDED.do_text, dont_text = EXCLUDED.dont_text,
  city_id = EXCLUDED.city_id, updated_at = NOW();

-- Xi'an
INSERT INTO culture_tips (id, emoji, title, preview, body, category, do_text, dont_text, sort_order, is_active, city_id)
VALUES (
  'culture_xian_muslim_quarter', '🕌', 'Muslim Quarter Respect',
  'Xi''an''s Muslim Quarter is home to the Hui community. Pork and alcohol are not served — this is a genuine religious practice, not a tourist rule.',
  'The Muslim Quarter (回民街) is a living neighbourhood for Xi''an''s Hui Muslim community. Pork and alcohol are completely absent from the area — don''t ask for them. Dress modestly when visiting the Great Mosque. Haggling for food is not appropriate; for souvenirs it''s expected. Friday prayers draw larger crowds — be respectful of worshippers.',
  'temple',
  'Try the local specialities: roujiamo (肉夹馍), yangrou paomo (羊肉泡馍), and cold noodles (凉皮).',
  'Bring or consume pork products or alcohol in the area.',
  50, TRUE, 'xian'
)
ON CONFLICT (id) DO UPDATE SET
  preview = EXCLUDED.preview, body = EXCLUDED.body,
  do_text = EXCLUDED.do_text, dont_text = EXCLUDED.dont_text,
  city_id = EXCLUDED.city_id, updated_at = NOW();
