-- Info Hub content: transport tips, common phrases, dialect phrases.
-- CMS-managed with bundled JSON fallback in the app. Audio is uploaded via admin
-- (audio_upload field → audio-guides bucket); audio_url is filled in later.

CREATE TABLE IF NOT EXISTS transport_tips (
  id          TEXT PRIMARY KEY,
  category    TEXT NOT NULL DEFAULT 'rail',             -- 'rail'|'taxi'|'metro'
  title_en    TEXT NOT NULL DEFAULT '',
  title_zh    TEXT NOT NULL DEFAULT '',
  body_en     TEXT NOT NULL DEFAULT '',
  body_zh     TEXT NOT NULL DEFAULT '',
  city_id     TEXT,
  sort_order  INT NOT NULL DEFAULT 0,
  is_active   BOOLEAN NOT NULL DEFAULT TRUE,
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS common_phrases (
  id          TEXT PRIMARY KEY,
  cn          TEXT NOT NULL,
  pinyin      TEXT NOT NULL DEFAULT '',
  en          TEXT NOT NULL DEFAULT '',
  audio_url   TEXT NOT NULL DEFAULT '',
  sort_order  INT NOT NULL DEFAULT 0,
  is_active   BOOLEAN NOT NULL DEFAULT TRUE,
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS dialect_phrases (
  id          TEXT PRIMARY KEY,
  dialect     TEXT NOT NULL,                            -- '四川话'|'北京话'|...
  emoji       TEXT NOT NULL DEFAULT '',
  cn          TEXT NOT NULL,
  pinyin      TEXT NOT NULL DEFAULT '',
  en          TEXT NOT NULL DEFAULT '',
  audio_url   TEXT NOT NULL DEFAULT '',
  sort_order  INT NOT NULL DEFAULT 0,
  is_active   BOOLEAN NOT NULL DEFAULT TRUE,
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ── RLS: public-read CMS content tables ──
DO $policy$
DECLARE
  t TEXT;
BEGIN
  FOREACH t IN ARRAY ARRAY['transport_tips', 'common_phrases', 'dialect_phrases']
  LOOP
    EXECUTE format('ALTER TABLE %I ENABLE ROW LEVEL SECURITY', t);
    EXECUTE format('DROP POLICY IF EXISTS %I ON %I', 'Public read ' || t, t);
    EXECUTE format(
      'CREATE POLICY %I ON %I FOR SELECT USING (is_active = TRUE OR public.is_admin())',
      'Public read ' || t, t
    );
    EXECUTE format('DROP POLICY IF EXISTS %I ON %I', 'Admin insert ' || t, t);
    EXECUTE format(
      'CREATE POLICY %I ON %I FOR INSERT TO authenticated WITH CHECK (public.is_admin())',
      'Admin insert ' || t, t
    );
    EXECUTE format('DROP POLICY IF EXISTS %I ON %I', 'Admin update ' || t, t);
    EXECUTE format(
      'CREATE POLICY %I ON %I FOR UPDATE TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin())',
      'Admin update ' || t, t
    );
    EXECUTE format('DROP POLICY IF EXISTS %I ON %I', 'Admin delete ' || t, t);
    EXECUTE format(
      'CREATE POLICY %I ON %I FOR DELETE TO authenticated USING (public.is_admin())',
      'Admin delete ' || t, t
    );
  END LOOP;
END
$policy$;

-- ════════════════════ STARTER SEED ════════════════════

INSERT INTO common_phrases (id, cn, pinyin, en, sort_order) VALUES
  ('hello',  '你好',       'nǐ hǎo',       'hello',          0),
  ('thanks', '谢谢',       'xièxie',       'thanks',         1),
  ('howmuch','多少钱',     'duō shǎo qián','how much',       2),
  ('nospicy','不要辣',     'bù yào là',    'no spicy',       3),
  ('toilet', '洗手间在哪', 'xǐ shǒu jiān zài nǎ', 'where is the toilet', 4)
ON CONFLICT (id) DO NOTHING;

INSERT INTO dialect_phrases (id, dialect, emoji, cn, pinyin, en, sort_order) VALUES
  ('sc_1', '四川话', '🌶️', '微微辣',       'wēi wēi là',      'a tiny bit spicy',   0),
  ('sc_2', '四川话', '⚖️', '多少钱一斤',   'duō shǎo qián yī jīn', 'how much per jin?', 1),
  ('sc_3', '四川话', '😋', '我能尝一下吗', 'wǒ néng cháng yī xià ma', 'can I taste it?', 2),
  ('bj_1', '北京话', '🫖', '您喝了吗',     'nín hē le ma',    'had your tea yet?',  3),
  ('bj_2', '北京话', '👍', '倍儿地道',     'bèir dì dao',     'super authentic',    4),
  ('sx_1', '陕西话', '🍜', '油泼面美得很', 'yóu pō miàn měi de hěn', 'this noodle is awesome', 5),
  ('sx_2', '陕西话', '🥘', '再来一碗',     'zài lái yī wǎn',  'another bowl please', 6)
ON CONFLICT (id) DO NOTHING;

INSERT INTO transport_tips (id, category, title_en, title_zh, body_en, body_zh, sort_order) VALUES
  ('rail_book', 'rail', 'Buying high-speed rail tickets', '高铁购票',
    'Use Trip.com or the official 12306 app; bring your passport — it is your ticket ID. Arrive 30+ min early for security.',
    '用 Trip.com 或官方 12306 购票；护照即车票证件，安检提前 30 分钟到。', 0),
  ('taxi_didi', 'taxi', 'Taxi & ride-hailing', '打车',
    'DiDi has an English mode; pay with Alipay/WeChat. Hotels can write your destination in Chinese.',
    '滴滴有英文模式，用支付宝/微信付；可让酒店帮你写中文目的地。', 1),
  ('metro', 'metro', 'Metro', '地铁',
    'Buy single-journey tickets at machines (English available) or scan Alipay/WeChat metro QR. Keep the token/card until you exit.',
    '自助机买单程票（有英文）或扫支付宝/微信地铁码；出站前别丢票/卡。', 2)
ON CONFLICT (id) DO NOTHING;
