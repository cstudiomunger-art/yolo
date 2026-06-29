-- Internet access guide: CMS-managed rich-text page for Info Hub "科学上网" entry.
-- body_* fields store Quill HTML; app renders via HTMLContentView.

CREATE TABLE IF NOT EXISTS internet_access_guides (
  id          TEXT PRIMARY KEY,
  title_zh    TEXT NOT NULL DEFAULT '',
  title_en    TEXT NOT NULL DEFAULT '',
  body_zh     TEXT NOT NULL DEFAULT '',
  body_en     TEXT NOT NULL DEFAULT '',
  is_active   BOOLEAN NOT NULL DEFAULT TRUE,
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ── RLS: public-read active rows; admin full ──
ALTER TABLE internet_access_guides ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Public read internet_access_guides" ON internet_access_guides;
CREATE POLICY "Public read internet_access_guides" ON internet_access_guides
  FOR SELECT USING (is_active = TRUE OR public.is_admin());
DROP POLICY IF EXISTS "Admin insert internet_access_guides" ON internet_access_guides;
CREATE POLICY "Admin insert internet_access_guides" ON internet_access_guides
  FOR INSERT TO authenticated WITH CHECK (public.is_admin());
DROP POLICY IF EXISTS "Admin update internet_access_guides" ON internet_access_guides;
CREATE POLICY "Admin update internet_access_guides" ON internet_access_guides
  FOR UPDATE TO authenticated USING (public.is_admin()) WITH CHECK (public.is_admin());
DROP POLICY IF EXISTS "Admin delete internet_access_guides" ON internet_access_guides;
CREATE POLICY "Admin delete internet_access_guides" ON internet_access_guides
  FOR DELETE TO authenticated USING (public.is_admin());

-- ════════════════════ STARTER SEED (EN, converted from Markdown) ════════════════════
INSERT INTO internet_access_guides (id, title_zh, title_en, body_zh, body_en) VALUES
  ('legal_guide', '科学上网指南', 'Legal Internet Access in China', '',
$$<h2>1. Before You Arrive</h2>
<h3>Check Your Phone</h3>
<table>
<thead><tr><th>Requirement</th><th>Details</th></tr></thead>
<tbody>
<tr><td>Physical SIM slot (Nano-SIM)</td><td>Chinese carriers only issue physical SIM cards. <strong>US/Japanese iPhones have no SIM slot — you cannot use a Chinese SIM card directly</strong></td></tr>
<tr><td>5G or VoLTE support</td><td>Without it, your phone may show no signal even with a SIM inserted</td></tr>
<tr><td>Unlocked phone</td><td>Carrier-locked phones from your home country may reject other SIM cards</td></tr>
</tbody>
</table>
<p><strong>No SIM slot on your iPhone? Here's what to do:</strong></p>
<ul>
<li>Bring a dual-SIM phone (e.g. Samsung S24 Ultra) — slot 1 for the Chinese SIM, slot 2 keeps your home SIM</li>
<li>Or buy a Chinese-market iPhone in advance (iPhone 15 Pro and earlier still have physical slots)</li>
</ul>
<h3>Documents &amp; Cash</h3>
<table>
<thead><tr><th>Item</th><th>Details</th></tr></thead>
<tbody>
<tr><td>Passport (original)</td><td>Must be valid for at least 6 more months</td></tr>
<tr><td>International credit card</td><td>Visa / Mastercard</td></tr>
<tr><td>~¥2,000 RMB in cash</td><td>For SIM card deposit + small purchases</td></tr>
</tbody>
</table>
<blockquote>Banks in China offer "coin pouches" (零钱包) — pre-packed small bills you can exchange at any branch, handy for taxis and snacks.</blockquote>
<hr>
<h2>2. Get a Chinese SIM Card</h2>
<h3>Where to Go</h3>
<ul>
<li><strong>Best option: airport service desk</strong> — Major airports (Beijing, Shanghai, Guangzhou) have dedicated foreigner counters with multilingual staff</li>
<li><strong>Next option: carrier-owned store</strong> — Choose China Mobile / Unicom / Telecom official stores, avoid third-party agents</li>
</ul>
<h3>Steps</h3>
<ol>
<li>Get a queue number → 2. Show your passport → 3. Pick a plan → 4. Pay + verify identity (photo + sign anti-fraud declaration) → 5. Receive &amp; activate SIM</li>
</ol>
<h3>Plan Reference (Actual prices may vary at the store)</h3>
<table>
<thead><tr><th>Duration</th><th>Approx. Price</th><th>Data + Minutes</th></tr></thead>
<tbody>
<tr><td>7 days</td><td>¥85–120</td><td>20–35 GB + 100–150 min</td></tr>
<tr><td>15 days</td><td>¥125–180</td><td>30–50 GB + 150–200 min</td></tr>
<tr><td>30 days</td><td>¥195–250</td><td>50–80 GB + 300 min</td></tr>
</tbody>
</table>
<table>
<thead><tr><th>Carrier</th><th>What They're Good At</th></tr></thead>
<tbody>
<tr><td>China Unicom</td><td>Best compatibility with foreign phone models; solid in cities</td></tr>
<tr><td>China Mobile</td><td>Largest coverage; best choice for rural/remote areas</td></tr>
<tr><td>China Telecom</td><td>Good value; strong in southern China</td></tr>
</tbody>
</table>
<hr>
<h2>3. Register Essential Apps</h2>
<blockquote>For WeChat &amp; Alipay setup, see the separate <strong>Payment Registration Guide</strong>.</blockquote>
<p><strong>Which apps require a Chinese phone number?</strong></p>
<table>
<thead><tr><th>App</th><th>Chinese Number Required?</th><th>Notes</th></tr></thead>
<tbody>
<tr><td>WeChat / Alipay</td><td>❌ No</td><td>Accepts international phone numbers</td></tr>
<tr><td>DiDi (ride-hailing)</td><td>❌ No</td><td>Supports international numbers + foreign cards</td></tr>
<tr><td>12306 (train tickets)</td><td>❌ No</td><td>Email registration + international card payment</td></tr>
<tr><td>Bike-sharing (Meituan / Hellobike / Qingju)</td><td>✅ Yes</td><td>Register immediately after getting your SIM</td></tr>
<tr><td>Food delivery / reviews (Meituan / Dianping)</td><td>⚠️ Maybe</td><td>International numbers sometimes work unreliably; mini-programs may be easier</td></tr>
</tbody>
</table>
<hr>
<h2>4. Accessing International Websites Legally</h2>
<table>
<thead><tr><th>Method</th><th>Who It's For</th><th>Details</th></tr></thead>
<tbody>
<tr><td>International roaming</td><td>Short-term visitors</td><td>Activate with your home carrier before departure; can access overseas sites; costs more</td></tr>
<tr><td>Authorized international network channel</td><td>Business / academic / long-term stays</td><td>Apply through your employer or school; requires a letter + passport copy</td></tr>
<tr><td>Some hotel / campus networks</td><td>Hotel guests / students</td><td>Institution-provided lawful service; not available to individuals</td></tr>
</tbody>
</table>
<p><strong>⚠️ Legal notice: In China, using unauthorized VPNs to access overseas networks is illegal.</strong> "I didn't know the local law" is not a valid defense.</p>
<p>Do this: ✅ Use international roaming for overseas sites &nbsp; ✅ Apply for an authorized channel &nbsp; ❌ Do not use unauthorized VPNs</p>
<hr>
<h2>5. Before You Leave</h2>
<ul>
<li>Short-term SIM cards auto-cancel when the plan expires — the number becomes invalid</li>
<li>Before expiry: back up important data → close accounts registered with that number → add your international number as a backup in all apps</li>
</ul>
<hr>
<h2>Bottom Line</h2>
<p><strong>Check phone has a physical SIM slot → Get a Chinese SIM at the airport → Register Chinese-number-required apps right away → Use international roaming for overseas sites → Close accounts before you leave</strong></p>$$)
ON CONFLICT (id) DO NOTHING;
