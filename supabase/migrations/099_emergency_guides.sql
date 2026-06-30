-- Emergency tutorial guides: consular protection + per-number how-to pages.
-- body_* fields store Quill HTML; app renders via HTMLContentView.

CREATE TABLE IF NOT EXISTS emergency_guides (
  id          TEXT PRIMARY KEY,
  kind        TEXT NOT NULL DEFAULT 'emergency_number',  -- 'consular' | 'emergency_number'
  number      TEXT NOT NULL DEFAULT '',
  title_zh    TEXT NOT NULL DEFAULT '',
  title_en    TEXT NOT NULL DEFAULT '',
  body_zh     TEXT NOT NULL DEFAULT '',
  body_en     TEXT NOT NULL DEFAULT '',
  sort_order  INT NOT NULL DEFAULT 0,
  is_active   BOOLEAN NOT NULL DEFAULT TRUE,
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS emergency_guides_kind_idx ON emergency_guides (kind);
CREATE INDEX IF NOT EXISTS emergency_guides_number_idx ON emergency_guides (number) WHERE number <> '';

ALTER TABLE emergency_guides ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Public read emergency_guides" ON emergency_guides;
CREATE POLICY "Public read emergency_guides" ON emergency_guides
  FOR SELECT USING (is_active = TRUE OR public.is_admin());
DROP POLICY IF EXISTS "Admin insert emergency_guides" ON emergency_guides;
CREATE POLICY "Admin insert emergency_guides" ON emergency_guides
  FOR INSERT TO authenticated WITH CHECK (public.is_admin());
DROP POLICY IF EXISTS "Admin update emergency_guides" ON emergency_guides;
CREATE POLICY "Admin update emergency_guides" ON emergency_guides
  FOR UPDATE TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());
DROP POLICY IF EXISTS "Admin delete emergency_guides" ON emergency_guides;
CREATE POLICY "Admin delete emergency_guides" ON emergency_guides
  FOR DELETE TO authenticated USING (public.is_admin());

-- ════════════════════ STARTER SEED (EN HTML from Consular Protection Guide) ════════════════════

INSERT INTO emergency_guides (id, kind, number, title_en, body_en, sort_order) VALUES
(
  'consular_protection',
  'consular',
  '',
  'Consular Protection & Emergency Help',
$$<blockquote><p>⚠️ <strong>If your life is in danger, call first — Police 110, Ambulance 120, Fire 119.</strong> Make sure you are safe; documents and paperwork can wait.</p></blockquote>
<p>If you lose your passport, are robbed, fall ill, or are questioned, detained, or arrested in China, this guide tells you <strong>which number to call, what to do in what order, and who can help</strong> — including <strong>what to do when there is a language barrier</strong>.</p>
<p>Emergency numbers (110 / 120 / 119 / 122) are the same nationwide. For embassy or consulate details, use your home country's official channels (Section 5).</p>
<hr>
<h2>1. Numbers to remember (nationwide, free, 24h)</h2>
<table><thead><tr><th>Situation</th><th>Number</th><th>Notes</th></tr></thead><tbody>
<tr><td>Police / theft / safety</td><td><strong>110</strong></td><td>National police; get a police report (《报案证明》)</td></tr>
<tr><td>Medical emergency</td><td><strong>120</strong></td><td>Ambulance; sudden illness or injury</td></tr>
<tr><td>Fire / rescue</td><td><strong>119</strong></td><td>Fires, trapped persons, hazmat</td></tr>
<tr><td>Traffic accident</td><td><strong>122</strong></td><td>Road accidents; you may also call 110</td></tr>
</tbody></table>
<p><strong>In one line:</strong> Personal safety &amp; police → 110; identity documents &amp; arrest → your embassy/consulate; visa &amp; legal stay → Exit-Entry Administration (出入境管理部门).</p>
<hr>
<h2>2. Language barrier</h2>
<p>110 / 120 / 119 operators <strong>mostly speak only Chinese</strong>. In an emergency:</p>
<ol>
<li><strong>Ask a Chinese-speaker nearby to call for you</strong> — hotel front desk is especially reliable.</li>
<li>Prepare three sentences: <strong>Where I am / What happened / What help I need</strong> — read Chinese aloud or play on speaker.</li>
<li><strong>Location is the top priority.</strong> Show a map screenshot if needed.</li>
<li>For medical issues, call your <strong>insurance 24h line</strong>; major hospitals often have 国际部 / 外宾门诊.</li>
<li>Hotlines: foreigners immigration <strong>12367</strong>; some cities <strong>12345</strong> with interpretation.</li>
</ol>
<hr>
<h2>3. Common emergencies</h2>
<h3>Passport lost or stolen</h3>
<ol>
<li>Report to police (<strong>110</strong> if urgent); get 《报案证明》.</li>
<li>Report to Exit-Entry Administration; get 《护照报失证明》.</li>
<li>Contact your embassy for an emergency travel document.</li>
<li>Return to Exit-Entry for visa/exit formalities before departure.</li>
</ol>
<h3>Theft / robbery</h3>
<p>Call <strong>110</strong>, freeze cards, lock phone, keep reports for insurance.</p>
<h3>Sudden illness</h3>
<p>Call <strong>120</strong> or go to 急诊; keep receipts; call insurance and embassy if serious.</p>
<h3>Detained or arrested</h3>
<p>Stay calm. Say: <strong>我要联系我国大使馆 / 领事馆</strong>. You have the right to consular notification and visits.</p>
<hr>
<h2>4. What embassies can and cannot do</h2>
<p><strong>Can:</strong> emergency travel documents; consular visits; lawyer lists; notify family; help arrange money from home.</p>
<p><strong>Cannot:</strong> lend money or pay bills; extend Chinese visas; bail you out or appear in court for you.</p>
<hr>
<h2>5. Find your embassy on the spot</h2>
<p>Search <strong>&lt;your country&gt; embassy China</strong> on your phone, or your foreign ministry website → "Embassy &amp; Consulates in China (驻华使领馆)".</p>
<p>Most countries have an embassy in Beijing and consulates in Shanghai, Guangzhou, Chengdu, etc. Contact the mission for your <strong>consular district</strong>.</p>
<blockquote><p>This app does <strong>not</strong> list individual mission phone numbers or addresses — use official government sources for the latest information.</p></blockquote>
<hr>
<h2>6. Before you travel</h2>
<ol>
<li>Save your nearest mission's official contact from your government website;</li>
<li>Your foreign ministry's global consular hotline;</li>
<li>Passport scan; insurance policy &amp; 24h line;</li>
<li>Chinese emergency phrases; memorize 110 / 120 / 119.</li>
</ol>$$,
  0
),
(
  'number_110',
  'emergency_number',
  '110',
  'Police 110 — When & How to Call',
$$<p><strong>110</strong> is China's national police emergency number — free, 24 hours, nationwide.</p>
<h2>When to call 110</h2>
<ul>
<li>Theft, robbery, assault, or threats to personal safety</li>
<li>Missing person or urgent police help</li>
<li>You need a <strong>police report (《报案证明》)</strong> for insurance or passport replacement</li>
<li>Serious traffic incidents (you may also use 122)</li>
</ul>
<h2>How to call effectively</h2>
<ol>
<li><strong>Location first</strong> — address or landmark in Chinese if possible.</li>
<li>State what happened and what you need (police on scene / report / interpreter).</li>
<li>Operators <strong>usually speak Chinese only</strong> — ask hotel staff or a passer-by to call for you if needed.</li>
<li>Prepare three phrases: where you are / what happened / what help you need.</li>
</ol>
<h2>After the incident</h2>
<ul>
<li>Get a written, stamped police report at the station (派出所) if required.</li>
<li>For lost passport: police report → Exit-Entry loss report → embassy emergency document.</li>
<li>If detained: clearly say <strong>我要联系我国大使馆 / 领事馆</strong>.</li>
</ul>
<blockquote><p>If your life is in immediate danger, call 110 first. Paperwork can wait.</p></blockquote>$$,
  1
),
(
  'number_120',
  'emergency_number',
  '120',
  'Ambulance 120 — Medical Emergency',
$$<p><strong>120</strong> is China's national ambulance and medical emergency number — free, 24 hours, nationwide.</p>
<h2>When to call 120</h2>
<ul>
<li>Sudden serious illness or injury</li>
<li>You cannot safely get to a hospital yourself</li>
<li>Someone is unconscious, bleeding heavily, or in acute distress</li>
</ul>
<h2>How to call effectively</h2>
<ol>
<li><strong>Give your exact location</strong> — show a map to a helper if you cannot speak Chinese.</li>
<li>Briefly describe symptoms and number of patients.</li>
<li>Stay on the line; follow operator instructions.</li>
<li>Call your <strong>travel/medical insurance 24h line</strong> — they can help with language, hospital choice, and payment.</li>
</ol>
<h2>At the hospital</h2>
<ul>
<li>Go to <strong>急诊 (emergency department)</strong> if you arrive on your own.</li>
<li>Major 三甲医院 often have <strong>国际部 / 外宾门诊</strong> with English service.</li>
<li>Keep all records and receipts for insurance claims.</li>
<li>For serious cases, contact your embassy to notify family.</li>
</ul>$$,
  2
),
(
  'number_119',
  'emergency_number',
  '119',
  'Fire 119 — Fire & Rescue',
$$<p><strong>119</strong> is China's national fire and rescue number — free, 24 hours, nationwide.</p>
<h2>When to call 119</h2>
<ul>
<li>Fire, smoke, or explosion</li>
<li>Trapped in a building or elevator</li>
<li>Hazardous material leaks</li>
<li>Other rescue situations requiring fire service</li>
</ul>
<h2>How to call effectively</h2>
<ol>
<li><strong>Evacuate to safety first</strong> if you can — then call.</li>
<li>State your <strong>precise address</strong> and what is burning or trapped.</li>
<li>Do not assume English — get a Chinese-speaker to call if needed.</li>
<li>Do not re-enter the building; meet responders outside.</li>
</ol>
<blockquote><p>For injuries during a fire, also call <strong>120</strong> for medical help.</p></blockquote>$$,
  3
),
(
  'number_122',
  'emergency_number',
  '122',
  'Traffic 122 — Road Accidents',
$$<p><strong>122</strong> is China's traffic accident hotline — free, 24 hours, nationwide. You may also call <strong>110</strong> for police at an accident scene.</p>
<h2>When to call 122</h2>
<ul>
<li>Vehicle collision or road accident</li>
<li>Hit-and-run or dispute at the scene</li>
<li>You need traffic police to document the incident</li>
</ul>
<h2>What to do at the scene</h2>
<ol>
<li>Move to safety; turn on hazard lights; set warning triangle if available.</li>
<li>Call <strong>122</strong> or <strong>110</strong>; state location, injuries, and vehicles involved.</li>
<li>Do not leave before police document the scene if required.</li>
<li>Photograph damage and positions; exchange details with the other party.</li>
<li>Call <strong>120</strong> if anyone is injured.</li>
</ol>
<p>Keep the police report for insurance. Operators usually speak Chinese — ask someone nearby to help call if needed.</p>$$,
  4
)
ON CONFLICT (id) DO NOTHING;
