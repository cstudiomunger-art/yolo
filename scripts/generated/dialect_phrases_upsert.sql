-- Generated dialect_phrases from 趣味方言合集 manifest + audio
-- Source: /Users/vesperal/Downloads/04_常用语/各城市-趣味方言与常用语/趣味方言合集
-- Total phrases: 26

-- Remove dialect phrases not in the new 26-item manifest set
DELETE FROM dialect_phrases
WHERE id NOT IN ('phrase_dialect_sichuan_001', 'phrase_dialect_sichuan_002', 'phrase_dialect_sichuan_003', 'phrase_dialect_sichuan_004', 'phrase_dialect_sichuan_005', 'phrase_dialect_sichuan_006', 'phrase_dialect_sichuan_007', 'phrase_dialect_sichuan_008', 'phrase_dialect_sichuan_009', 'phrase_dialect_sichuan_010', 'phrase_dialect_sichuan_011', 'phrase_dialect_beijing_001', 'phrase_dialect_beijing_002', 'phrase_dialect_beijing_003', 'phrase_dialect_beijing_004', 'phrase_dialect_beijing_005', 'phrase_dialect_beijing_006', 'phrase_dialect_beijing_007', 'phrase_dialect_beijing_008', 'phrase_dialect_beijing_009', 'phrase_dialect_nanjing_001', 'phrase_dialect_nanjing_002', 'phrase_dialect_shanghai_001', 'phrase_dialect_shanghai_002', 'phrase_dialect_shanghai_003', 'phrase_dialect_shanghai_004');

INSERT INTO dialect_phrases (id, dialect, emoji, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES (
  'phrase_dialect_sichuan_001',
  '四川话',
  '🌶️',
  '巴适',
  '',
  'Awesome / so comfy',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_dialect_sichuan_001.mp3',
  0,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  dialect = EXCLUDED.dialect,
  emoji = EXCLUDED.emoji,
  cn = EXCLUDED.cn,
  pinyin = EXCLUDED.pinyin,
  en = EXCLUDED.en,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO dialect_phrases (id, dialect, emoji, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES (
  'phrase_dialect_sichuan_002',
  '四川话',
  '🌶️',
  '安逸惨了',
  '',
  'Super chill / perfect',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_dialect_sichuan_002.mp3',
  1,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  dialect = EXCLUDED.dialect,
  emoji = EXCLUDED.emoji,
  cn = EXCLUDED.cn,
  pinyin = EXCLUDED.pinyin,
  en = EXCLUDED.en,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO dialect_phrases (id, dialect, emoji, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES (
  'phrase_dialect_sichuan_003',
  '四川话',
  '🌶️',
  '要得',
  '',
  'OK / sure',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_dialect_sichuan_003.mp3',
  2,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  dialect = EXCLUDED.dialect,
  emoji = EXCLUDED.emoji,
  cn = EXCLUDED.cn,
  pinyin = EXCLUDED.pinyin,
  en = EXCLUDED.en,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO dialect_phrases (id, dialect, emoji, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES (
  'phrase_dialect_sichuan_004',
  '四川话',
  '🌶️',
  '微微辣',
  '',
  'Just a tiny bit spicy (mild)',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_dialect_sichuan_004.mp3',
  3,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  dialect = EXCLUDED.dialect,
  emoji = EXCLUDED.emoji,
  cn = EXCLUDED.cn,
  pinyin = EXCLUDED.pinyin,
  en = EXCLUDED.en,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO dialect_phrases (id, dialect, emoji, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES (
  'phrase_dialect_sichuan_005',
  '四川话',
  '🌶️',
  '这个才叫资格',
  '',
  'Now THIS is the real deal',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_dialect_sichuan_005.mp3',
  4,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  dialect = EXCLUDED.dialect,
  emoji = EXCLUDED.emoji,
  cn = EXCLUDED.cn,
  pinyin = EXCLUDED.pinyin,
  en = EXCLUDED.en,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO dialect_phrases (id, dialect, emoji, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES (
  'phrase_dialect_sichuan_006',
  '四川话',
  '🌶️',
  '安逸，巴适得很',
  '',
  'So cozy — life''s good!',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_dialect_sichuan_006.mp3',
  5,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  dialect = EXCLUDED.dialect,
  emoji = EXCLUDED.emoji,
  cn = EXCLUDED.cn,
  pinyin = EXCLUDED.pinyin,
  en = EXCLUDED.en,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO dialect_phrases (id, dialect, emoji, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES (
  'phrase_dialect_sichuan_007',
  '四川话',
  '🌶️',
  '老板，来个鸳鸯锅',
  '',
  'A half-spicy hotpot, boss (split mild & spicy)',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_dialect_sichuan_007.mp3',
  6,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  dialect = EXCLUDED.dialect,
  emoji = EXCLUDED.emoji,
  cn = EXCLUDED.cn,
  pinyin = EXCLUDED.pinyin,
  en = EXCLUDED.en,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO dialect_phrases (id, dialect, emoji, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES (
  'phrase_dialect_sichuan_008',
  '四川话',
  '🌶️',
  '老板，这个微微辣就够了哈',
  '',
  'Just a tiny bit spicy, boss',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_dialect_sichuan_008.mp3',
  7,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  dialect = EXCLUDED.dialect,
  emoji = EXCLUDED.emoji,
  cn = EXCLUDED.cn,
  pinyin = EXCLUDED.pinyin,
  en = EXCLUDED.en,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO dialect_phrases (id, dialect, emoji, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES (
  'phrase_dialect_sichuan_009',
  '四川话',
  '🌶️',
  '这个好吃得很，巴适！',
  '',
  'So delicious — bashi (awesome)!',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_dialect_sichuan_009.mp3',
  8,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  dialect = EXCLUDED.dialect,
  emoji = EXCLUDED.emoji,
  cn = EXCLUDED.cn,
  pinyin = EXCLUDED.pinyin,
  en = EXCLUDED.en,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO dialect_phrases (id, dialect, emoji, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES (
  'phrase_dialect_sichuan_010',
  '四川话',
  '🌶️',
  '老板，来二两小面，少放点辣子',
  '',
  'A small noodle bowl, easy on the chili',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_dialect_sichuan_010.mp3',
  9,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  dialect = EXCLUDED.dialect,
  emoji = EXCLUDED.emoji,
  cn = EXCLUDED.cn,
  pinyin = EXCLUDED.pinyin,
  en = EXCLUDED.en,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO dialect_phrases (id, dialect, emoji, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES (
  'phrase_dialect_sichuan_011',
  '四川话',
  '🌶️',
  '老板，来碗三花',
  '',
  'A bowl of sanhua jasmine tea, boss',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_dialect_sichuan_011.mp3',
  10,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  dialect = EXCLUDED.dialect,
  emoji = EXCLUDED.emoji,
  cn = EXCLUDED.cn,
  pinyin = EXCLUDED.pinyin,
  en = EXCLUDED.en,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO dialect_phrases (id, dialect, emoji, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES (
  'phrase_dialect_beijing_001',
  '北京话',
  '🫖',
  '劳驾，让一让',
  '',
  'Excuse me, coming through',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_dialect_beijing_001.mp3',
  11,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  dialect = EXCLUDED.dialect,
  emoji = EXCLUDED.emoji,
  cn = EXCLUDED.cn,
  pinyin = EXCLUDED.pinyin,
  en = EXCLUDED.en,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO dialect_phrases (id, dialect, emoji, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES (
  'phrase_dialect_beijing_002',
  '北京话',
  '🫖',
  '这味儿倍儿棒',
  '',
  'This tastes amazing!',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_dialect_beijing_002.mp3',
  12,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  dialect = EXCLUDED.dialect,
  emoji = EXCLUDED.emoji,
  cn = EXCLUDED.cn,
  pinyin = EXCLUDED.pinyin,
  en = EXCLUDED.en,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO dialect_phrases (id, dialect, emoji, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES (
  'phrase_dialect_beijing_003',
  '北京话',
  '🫖',
  '这才叫地道',
  '',
  'Now that''s authentic',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_dialect_beijing_003.mp3',
  13,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  dialect = EXCLUDED.dialect,
  emoji = EXCLUDED.emoji,
  cn = EXCLUDED.cn,
  pinyin = EXCLUDED.pinyin,
  en = EXCLUDED.en,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO dialect_phrases (id, dialect, emoji, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES (
  'phrase_dialect_beijing_004',
  '北京话',
  '🫖',
  '师傅，劳驾，去天安门',
  '',
  'Excuse me driver, to Tiananmen',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_dialect_beijing_004.mp3',
  14,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  dialect = EXCLUDED.dialect,
  emoji = EXCLUDED.emoji,
  cn = EXCLUDED.cn,
  pinyin = EXCLUDED.pinyin,
  en = EXCLUDED.en,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO dialect_phrases (id, dialect, emoji, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES (
  'phrase_dialect_beijing_005',
  '北京话',
  '🫖',
  '您这手艺，倍儿地道！',
  '',
  'Your cooking''s super authentic!',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_dialect_beijing_005.mp3',
  15,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  dialect = EXCLUDED.dialect,
  emoji = EXCLUDED.emoji,
  cn = EXCLUDED.cn,
  pinyin = EXCLUDED.pinyin,
  en = EXCLUDED.en,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO dialect_phrases (id, dialect, emoji, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES (
  'phrase_dialect_beijing_006',
  '北京话',
  '🫖',
  '得嘞，谢谢您嘞！',
  '',
  'Got it — thank you!',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_dialect_beijing_006.mp3',
  16,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  dialect = EXCLUDED.dialect,
  emoji = EXCLUDED.emoji,
  cn = EXCLUDED.cn,
  pinyin = EXCLUDED.pinyin,
  en = EXCLUDED.en,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO dialect_phrases (id, dialect, emoji, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES (
  'phrase_dialect_beijing_007',
  '北京话',
  '🫖',
  '溜着边儿的喝，才地道',
  '',
  'Sip it along the rim — the proper way',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_dialect_beijing_007.mp3',
  17,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  dialect = EXCLUDED.dialect,
  emoji = EXCLUDED.emoji,
  cn = EXCLUDED.cn,
  pinyin = EXCLUDED.pinyin,
  en = EXCLUDED.en,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO dialect_phrases (id, dialect, emoji, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES (
  'phrase_dialect_beijing_008',
  '北京话',
  '🫖',
  '沏壶高的',
  '',
  'Brew us a pot of the good stuff',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_dialect_beijing_008.mp3',
  18,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  dialect = EXCLUDED.dialect,
  emoji = EXCLUDED.emoji,
  cn = EXCLUDED.cn,
  pinyin = EXCLUDED.pinyin,
  en = EXCLUDED.en,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO dialect_phrases (id, dialect, emoji, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES (
  'phrase_dialect_beijing_009',
  '北京话',
  '🫖',
  '谢谢您嘞',
  '',
  'Thank you kindly!',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_dialect_beijing_009.mp3',
  19,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  dialect = EXCLUDED.dialect,
  emoji = EXCLUDED.emoji,
  cn = EXCLUDED.cn,
  pinyin = EXCLUDED.pinyin,
  en = EXCLUDED.en,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO dialect_phrases (id, dialect, emoji, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES (
  'phrase_dialect_nanjing_001',
  '南京话',
  '🏯',
  '这个真来斯',
  '',
  'This is really great!',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_dialect_nanjing_001.mp3',
  20,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  dialect = EXCLUDED.dialect,
  emoji = EXCLUDED.emoji,
  cn = EXCLUDED.cn,
  pinyin = EXCLUDED.pinyin,
  en = EXCLUDED.en,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO dialect_phrases (id, dialect, emoji, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES (
  'phrase_dialect_nanjing_002',
  '南京话',
  '🏯',
  '这个味道真恩正，来斯！',
  '',
  'So authentic — nice!',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_dialect_nanjing_002.mp3',
  21,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  dialect = EXCLUDED.dialect,
  emoji = EXCLUDED.emoji,
  cn = EXCLUDED.cn,
  pinyin = EXCLUDED.pinyin,
  en = EXCLUDED.en,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO dialect_phrases (id, dialect, emoji, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES (
  'phrase_dialect_shanghai_001',
  '上海话',
  '🏙️',
  '这个老灵额！',
  '',
  'This is really great!',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_dialect_shanghai_001.mp3',
  22,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  dialect = EXCLUDED.dialect,
  emoji = EXCLUDED.emoji,
  cn = EXCLUDED.cn,
  pinyin = EXCLUDED.pinyin,
  en = EXCLUDED.en,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO dialect_phrases (id, dialect, emoji, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES (
  'phrase_dialect_shanghai_002',
  '上海话',
  '🏙️',
  '侬好，阿拉是来白相额',
  '',
  'Hi, we''re here to have some fun',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_dialect_shanghai_002.mp3',
  23,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  dialect = EXCLUDED.dialect,
  emoji = EXCLUDED.emoji,
  cn = EXCLUDED.cn,
  pinyin = EXCLUDED.pinyin,
  en = EXCLUDED.en,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO dialect_phrases (id, dialect, emoji, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES (
  'phrase_dialect_shanghai_003',
  '上海话',
  '🏙️',
  '侬老有腔调额！',
  '',
  'You''ve got real style!',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_dialect_shanghai_003.mp3',
  24,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  dialect = EXCLUDED.dialect,
  emoji = EXCLUDED.emoji,
  cn = EXCLUDED.cn,
  pinyin = EXCLUDED.pinyin,
  en = EXCLUDED.en,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO dialect_phrases (id, dialect, emoji, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES (
  'phrase_dialect_shanghai_004',
  '上海话',
  '🏙️',
  '侬好',
  '',
  'Hello! (Shanghainese)',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_dialect_shanghai_004.mp3',
  25,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  dialect = EXCLUDED.dialect,
  emoji = EXCLUDED.emoji,
  cn = EXCLUDED.cn,
  pinyin = EXCLUDED.pinyin,
  en = EXCLUDED.en,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();
