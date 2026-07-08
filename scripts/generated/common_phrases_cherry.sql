-- Generated common_phrases from Cherry Mandarin audio
-- Source: /Users/vesperal/Downloads/通用普通话音频_Cherry
-- Total phrases: 23

-- Remove common phrases not in the Cherry 23-audio set
DELETE FROM common_phrases
WHERE id NOT IN ('phrase_common_001', 'phrase_common_002', 'phrase_common_003', 'phrase_common_004', 'phrase_common_005', 'phrase_common_006', 'phrase_common_007', 'phrase_common_008', 'phrase_common_009', 'phrase_common_010', 'phrase_common_011', 'phrase_common_012', 'phrase_common_013', 'phrase_common_014', 'phrase_common_015', 'phrase_common_016', 'phrase_common_017', 'phrase_common_018', 'phrase_common_019', 'phrase_common_020', 'phrase_common_021', 'phrase_common_022', 'phrase_common_023');

INSERT INTO common_phrases (id, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES (
  'phrase_common_001',
  '你好',
  '',
  'Hello',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_common_001.mp3',
  0,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  cn = EXCLUDED.cn,
  pinyin = EXCLUDED.pinyin,
  en = EXCLUDED.en,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO common_phrases (id, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES (
  'phrase_common_002',
  '谢谢',
  '',
  'Thank you',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_common_002.mp3',
  1,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  cn = EXCLUDED.cn,
  pinyin = EXCLUDED.pinyin,
  en = EXCLUDED.en,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO common_phrases (id, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES (
  'phrase_common_003',
  '不好意思',
  '',
  'Excuse me / Sorry',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_common_003.mp3',
  2,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  cn = EXCLUDED.cn,
  pinyin = EXCLUDED.pinyin,
  en = EXCLUDED.en,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO common_phrases (id, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES (
  'phrase_common_004',
  '我听不懂',
  '',
  'I don''t understand',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_common_004.mp3',
  3,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  cn = EXCLUDED.cn,
  pinyin = EXCLUDED.pinyin,
  en = EXCLUDED.en,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO common_phrases (id, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES (
  'phrase_common_005',
  '我不会说中文',
  '',
  'I don''t speak Chinese',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_common_005.mp3',
  4,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  cn = EXCLUDED.cn,
  pinyin = EXCLUDED.pinyin,
  en = EXCLUDED.en,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO common_phrases (id, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES (
  'phrase_common_006',
  '请帮我写下来',
  '',
  'Please write it down for me',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_common_006.mp3',
  5,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  cn = EXCLUDED.cn,
  pinyin = EXCLUDED.pinyin,
  en = EXCLUDED.en,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO common_phrases (id, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES (
  'phrase_common_007',
  '你会说英语吗',
  '',
  'Do you speak English?',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_common_007.mp3',
  6,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  cn = EXCLUDED.cn,
  pinyin = EXCLUDED.pinyin,
  en = EXCLUDED.en,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO common_phrases (id, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES (
  'phrase_common_008',
  '我要去这个地址',
  '',
  'I want to go to this address',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_common_008.mp3',
  7,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  cn = EXCLUDED.cn,
  pinyin = EXCLUDED.pinyin,
  en = EXCLUDED.en,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO common_phrases (id, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES (
  'phrase_common_009',
  '到了请告诉我',
  '',
  'Please tell me when we arrive',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_common_009.mp3',
  8,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  cn = EXCLUDED.cn,
  pinyin = EXCLUDED.pinyin,
  en = EXCLUDED.en,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO common_phrases (id, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES (
  'phrase_common_010',
  '往哪边走',
  '',
  'Which way should I go?',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_common_010.mp3',
  9,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  cn = EXCLUDED.cn,
  pinyin = EXCLUDED.pinyin,
  en = EXCLUDED.en,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO common_phrases (id, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES (
  'phrase_common_011',
  '最近的洗手间在哪',
  '',
  'Where is the nearest restroom?',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_common_011.mp3',
  10,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  cn = EXCLUDED.cn,
  pinyin = EXCLUDED.pinyin,
  en = EXCLUDED.en,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO common_phrases (id, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES (
  'phrase_common_012',
  '哪个出口离这里近',
  '',
  'Which exit is closest to this place?',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_common_012.mp3',
  11,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  cn = EXCLUDED.cn,
  pinyin = EXCLUDED.pinyin,
  en = EXCLUDED.en,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO common_phrases (id, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES (
  'phrase_common_013',
  '菜单有英文吗',
  '',
  'Do you have an English menu?',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_common_013.mp3',
  12,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  cn = EXCLUDED.cn,
  pinyin = EXCLUDED.pinyin,
  en = EXCLUDED.en,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO common_phrases (id, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES (
  'phrase_common_014',
  '有图片菜单吗',
  '',
  'Do you have a picture menu?',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_common_014.mp3',
  13,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  cn = EXCLUDED.cn,
  pinyin = EXCLUDED.pinyin,
  en = EXCLUDED.en,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO common_phrases (id, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES (
  'phrase_common_015',
  '来一份这个',
  '',
  'One of these, please',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_common_015.mp3',
  14,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  cn = EXCLUDED.cn,
  pinyin = EXCLUDED.pinyin,
  en = EXCLUDED.en,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO common_phrases (id, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES (
  'phrase_common_016',
  '不要辣',
  '',
  'Not spicy, please',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_common_016.mp3',
  15,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  cn = EXCLUDED.cn,
  pinyin = EXCLUDED.pinyin,
  en = EXCLUDED.en,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO common_phrases (id, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES (
  'phrase_common_017',
  '买单',
  '',
  'The bill, please',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_common_017.mp3',
  16,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  cn = EXCLUDED.cn,
  pinyin = EXCLUDED.pinyin,
  en = EXCLUDED.en,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO common_phrases (id, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES (
  'phrase_common_018',
  '你这瓜保熟吗',
  '',
  'Is this melon ripe (sweet)?',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_common_018.mp3',
  17,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  cn = EXCLUDED.cn,
  pinyin = EXCLUDED.pinyin,
  en = EXCLUDED.en,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO common_phrases (id, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES (
  'phrase_common_019',
  '能用支付宝或者微信吗',
  '',
  'Can I pay with Alipay or WeChat?',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_common_019.mp3',
  18,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  cn = EXCLUDED.cn,
  pinyin = EXCLUDED.pinyin,
  en = EXCLUDED.en,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO common_phrases (id, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES (
  'phrase_common_020',
  '请帮帮我',
  '',
  'Please help me',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_common_020.mp3',
  19,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  cn = EXCLUDED.cn,
  pinyin = EXCLUDED.pinyin,
  en = EXCLUDED.en,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO common_phrases (id, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES (
  'phrase_common_021',
  '请打 110',
  '',
  'Please call 110',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_common_021.mp3',
  20,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  cn = EXCLUDED.cn,
  pinyin = EXCLUDED.pinyin,
  en = EXCLUDED.en,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO common_phrases (id, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES (
  'phrase_common_022',
  '请帮我打 120',
  '',
  'Please call 120 for me',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_common_022.mp3',
  21,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  cn = EXCLUDED.cn,
  pinyin = EXCLUDED.pinyin,
  en = EXCLUDED.en,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();

INSERT INTO common_phrases (id, cn, pinyin, en, audio_url, sort_order, is_active)
VALUES (
  'phrase_common_023',
  '我的护照丢了',
  '',
  'I lost my passport',
  'https://edwvrriuwzaaqznklrgi.supabase.co/storage/v1/object/public/audio-guides/phrases/phrase_common_023.mp3',
  22,
  TRUE
) ON CONFLICT (id) DO UPDATE SET
  cn = EXCLUDED.cn,
  pinyin = EXCLUDED.pinyin,
  en = EXCLUDED.en,
  audio_url = EXCLUDED.audio_url,
  sort_order = EXCLUDED.sort_order,
  is_active = EXCLUDED.is_active,
  updated_at = NOW();
