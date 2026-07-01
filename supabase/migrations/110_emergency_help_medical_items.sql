-- Emergency page CMS: dynamic help + medical/medicine list items (Quill HTML bodies).

CREATE TABLE IF NOT EXISTS emergency_help_items (
  id           TEXT PRIMARY KEY,
  title_zh     TEXT NOT NULL DEFAULT '',
  title_en     TEXT NOT NULL DEFAULT '',
  subtitle_zh  TEXT NOT NULL DEFAULT '',
  subtitle_en  TEXT NOT NULL DEFAULT '',
  body_zh      TEXT NOT NULL DEFAULT '',
  body_en      TEXT NOT NULL DEFAULT '',
  icon         TEXT NOT NULL DEFAULT '',
  sort_order   INT NOT NULL DEFAULT 0,
  is_active    BOOLEAN NOT NULL DEFAULT TRUE,
  updated_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS emergency_medical_items (
  id           TEXT PRIMARY KEY,
  title_zh     TEXT NOT NULL DEFAULT '',
  title_en     TEXT NOT NULL DEFAULT '',
  subtitle_zh  TEXT NOT NULL DEFAULT '',
  subtitle_en  TEXT NOT NULL DEFAULT '',
  body_zh      TEXT NOT NULL DEFAULT '',
  body_en      TEXT NOT NULL DEFAULT '',
  icon         TEXT NOT NULL DEFAULT '',
  sort_order   INT NOT NULL DEFAULT 0,
  is_active    BOOLEAN NOT NULL DEFAULT TRUE,
  updated_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS emergency_help_items_sort_idx ON emergency_help_items (sort_order);
CREATE INDEX IF NOT EXISTS emergency_medical_items_sort_idx ON emergency_medical_items (sort_order);

DO $policy$
DECLARE
  t TEXT;
BEGIN
  FOREACH t IN ARRAY ARRAY['emergency_help_items', 'emergency_medical_items']
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


-- SEED: emergency help + medical items (English only)

INSERT INTO emergency_help_items (id, icon, title_zh, title_en, subtitle_zh, subtitle_en, body_zh, body_en, sort_order) VALUES
('consular_emergency_help', '🆘', '', 'Consular Protection & Emergency Help Guide', '', 'What to do · language tips · find your embassy', '', $$<h1>Consular Protection &amp; Emergency Help Guide (for foreign travelers in China)</h1>
<blockquote>
<p>⚠️ <strong>If your life is in danger, call first — Police 110, Ambulance 120, Fire 119. Make sure you are safe; documents and paperwork can wait.</strong></p>
</blockquote>
<blockquote>
<p>If you lose your passport, are robbed, fall ill, or are questioned, detained, or arrested by the police in China, this guide tells you <strong>which number to call, what to do in what order, and who can help</strong> — including <strong>what to do when there is a language barrier</strong>.
The emergency numbers (110 / 120 / 119) are the same nationwide and do not change; the procedures below apply across China. For your own embassy or consulate details, rely on your home country&#39;s official channels (Section 5 shows you how to find them on the spot).</p>
</blockquote>
<blockquote>
<p>Note: Chinese terms are kept in brackets so you can show them to people or staff in China when needed.</p>
</blockquote>
<hr>
<h2>1. Numbers to remember first (nationwide, free, 24 hours)</h2>
<table>
<thead>
<tr>
<th>Situation</th>
<th>Number</th>
<th>Notes</th>
</tr>
</thead>
<tbody><tr>
<td>Police / theft / robbery / personal safety / missing person</td>
<td><strong>110</strong></td>
<td>National police number. Call or visit the police when you need a police report (《报案证明》).</td>
</tr>
<tr>
<td>Medical emergency (ambulance)</td>
<td><strong>120</strong></td>
<td>Sudden illness, injury, or when you need to get to a hospital.</td>
</tr>
<tr>
<td>Fire</td>
<td><strong>119</strong></td>
<td>Fires, and also rescue from being trapped, hazardous-material leaks, etc.</td>
</tr>
<tr>
<td>Traffic accident</td>
<td><strong>122</strong></td>
<td>Road accidents and vehicle disputes; you can also just call 110.</td>
</tr>
<tr>
<td><strong>Your country&#39;s consular protection</strong></td>
<td>Your embassy/consulate&#39;s emergency line</td>
<td>The most important contact for a lost passport, arrest, or serious incident. <strong>Don&#39;t have the number?</strong> Search &quot;<strong><your country> embassy China</strong>&quot; on your phone for the official line, or call your foreign ministry&#39;s <strong>global consular emergency hotline</strong> (see Section 5).</td>
</tr>
</tbody></table>
<blockquote>
<p>In one line: <strong>Personal safety &amp; police → 110; identity documents &amp; arrest → your embassy/consulate; visa &amp; legal stay → China&#39;s Exit-Entry Administration (出入境管理部门).</strong></p>
</blockquote>
<hr>
<h2>2. What to do when there is a language barrier</h2>
<p>China&#39;s 110 / 120 / 119 operators <strong>mostly speak only Chinese</strong> — do not assume English is available. In an emergency, use these ways around the language barrier:</p>
<ol>
<li><strong>Fastest option: ask a Chinese-speaker nearby to call and interpret for you.</strong> Hotel front-desk staff, a restaurant or shop assistant, or a passer-by all work — just hand them your phone to speak for you. <strong>Hotel front desks are especially reliable</strong> — if something happens, go back to your hotel or phone the front desk for help.</li>
<li><strong>If you call yourself, prepare three sentences with a translation app first</strong> — &quot;<strong>Where I am</strong> (most important) / <strong>What happened</strong> / <strong>What help I need</strong>&quot; — then read the Chinese aloud or play it on speaker to the operator.</li>
<li><strong>Stating your location is the top priority.</strong> Police and ambulances most need to know where you are. Check your <strong>Chinese address or nearest landmark</strong> on a map in advance; if you can&#39;t say it, show a map screenshot to whoever is helping you.</li>
<li><strong>For medical situations</strong>, call your <strong>travel/medical insurance 24-hour assistance line</strong> — they can usually support your language and help arrange a hospital, an interpreter, and payment if needed. Major-city Grade A tertiary hospitals (三甲医院) usually have an <strong>international department / foreigners&#39; clinic (国际部 / 外宾门诊)</strong> with English service.</li>
<li><strong>Official lines with English / interpretation</strong>: the immigration service hotline for foreigners <strong>12367</strong> (exit-entry, stay, and visa questions); some cities&#39; government hotline <strong>12345</strong> also offers multiple languages or interpreter transfer.</li>
<li>Before your trip, save a few <strong>emergency phrases in Chinese</strong> on your phone (&quot;请帮我报警&quot; = please call the police for me / &quot;我需要救护车&quot; = I need an ambulance / &quot;我护照丢了&quot; = I lost my passport) and show them when needed.</li>
</ol>
<hr>
<h2>3. Handling common emergencies (applies across China)</h2>
<h3>① Passport lost or stolen</h3>
<p>Your passport is your main <strong>identity document</strong> in China; your <strong>legal stay</strong> is shown by your Chinese <strong>visa, stay permit, or residence permit</strong>. If your passport is lost or stolen, handle it in this order:</p>
<ol>
<li><strong>Report it to the police immediately.</strong> Call <strong>110</strong> if it was stolen or you need urgent help; go to the nearest police station (派出所), explain what happened, and ask for a <strong>written, officially stamped police report (《报案证明》 / 受案回执)</strong>.</li>
<li><strong>Report the loss to the local Exit-Entry Administration (出入境管理部门).</strong> Report the lost passport and ask which document they need you to obtain or which they will issue — usually a <strong>Passport Loss Report / Confirmation of Reporting Loss of Passport (《护照报失证明》)</strong>. Your embassy and your later exit/visa procedures often need this document.</li>
<li><strong>Contact your embassy or consulate in China to get an emergency travel document</strong> (Emergency Travel Document / temporary passport) so you can return home or continue your trip. Typically bring: the police report, a passport copy or photo page (if available), passport photos, proof of identity, and a means of payment — <strong>requirements vary by country</strong>.</li>
<li><strong>After you receive the new document, return to the Exit-Entry Administration (出入境管理部门) for exit/visa formalities.</strong> Your old visa or entry stamp was in the lost passport, so the new document does not show your legal entry and stay; <strong>before leaving China</strong> you may need a replacement visa, an updated stay/residence permit, or an exit document. Allow at least several working days — in some cases around 10 — and <strong>do not wait until your flight date</strong>.</li>
<li><strong>If you find the old passport later, do not use it.</strong> Once reported lost or replaced, it may have been cancelled and may no longer be valid for travel.</li>
</ol>
<blockquote>
<p>Order to remember: <strong>Police report (《报案证明》) → loss report at Exit-Entry (《护照报失证明》) → emergency travel document from your embassy → back to Exit-Entry for visa/exit formalities.</strong></p>
</blockquote>
<h3>② Theft / robbery</h3>
<ol>
<li><strong>Call 110</strong>, truthfully state the time, place, items, and amount, and ask for a <strong>police report (报案证明)</strong> (needed for both insurance claims and document replacement).</li>
<li><strong>Bank/credit cards</strong>: call to <strong>report them lost</strong> immediately (use the number on the back of the card or your bank&#39;s overseas line) and freeze the accounts.</li>
<li><strong>Phone</strong>: lock or wipe it remotely (Find My iPhone, etc.) and contact your carrier to suspend the line.</li>
<li><strong>Out of cash</strong>: embassies/consulates <strong>do not lend money or pay on your behalf</strong>, but can help you contact family back home to send money or point you to emergency transfer channels (e.g. Western Union).</li>
<li>Keep all police reports and receipts for an insurance claim after you return home.</li>
</ol>
<h3>③ Sudden illness / injury</h3>
<ol>
<li><strong>In an emergency, call 120 for an ambulance</strong>, or go to the nearest hospital <strong>emergency department (急诊)</strong>. Major-city Grade A tertiary hospitals (三甲医院) often have an international department / foreigners&#39; clinic (国际部 / 外宾门诊), some with English service.</li>
<li><strong>Keep all medical records, diagnoses, and payment receipts</strong> — essential for an overseas medical insurance claim.</li>
<li><strong>Call your travel/medical insurance 24-hour assistance line</strong> (note your policy number and the number before you travel). They can help arrange a hospital, payment, and medical evacuation if needed, and can usually support your language.</li>
<li><strong>For serious illness or injury</strong> — when family needs to come or you need treatment back home — contact your embassy/consulate to help notify family and provide a list of local hospitals/doctors.</li>
</ol>
<h3>④ Detained or arrested by the police — your right to consular access</h3>
<ol>
<li><strong>Stay calm, do not resist, and do not sign documents you cannot read.</strong> You have the right to <strong>communicate through an interpreter</strong>.</li>
<li><strong>State clearly: &quot;I want to contact my embassy / consulate (我要联系我国大使馆 / 领事馆).&quot;</strong> Under the Vienna Convention on Consular Relations, you have the right to have your consulate notified and to receive <strong>consular visits</strong>.</li>
<li>Consular officers <strong>can</strong>: visit you, check on your situation, confirm you are being treated fairly, provide a list of local lawyers and interpreters, notify your family, and monitor whether due process is followed.</li>
<li>Consular officers <strong>cannot</strong>: bail you out, represent you in court, interfere with China&#39;s judicial process or judge your case, or get you out of investigation/trial.</li>
<li>In serious cases, the authorities may handle consular notification under the applicable rules, but do not rely only on automatic notification — <strong>clearly ask to contact your embassy or consulate</strong>. If your personal safety is at risk, calling <strong>110</strong> first is also the right move.</li>
</ol>
<hr>
<h2>4. What an embassy/consulate can and cannot do (clearing up misunderstandings)</h2>
<p><strong>They can:</strong></p>
<ul>
<li>Reissue a passport or issue an emergency travel document;</li>
<li>Visit you if detained/arrested, provide a list of lawyers and interpreters, and notify your family;</li>
<li>Provide a list of hospitals and help notify relatives in case of serious illness or injury;</li>
<li>Help you contact family to arrange an emergency money transfer;</li>
<li>Provide consular assistance for births, deaths, and major incidents.</li>
</ul>
<p><strong>They cannot:</strong></p>
<ul>
<li><strong>Lend money or pay</strong> medical bills / hotel bills / fines / airfare on your behalf;</li>
<li><strong>Extend your Chinese visa or issue a stay permit</strong> (that is the authority of China&#39;s Exit-Entry Administration);</li>
<li>Exempt you from Chinese law, or appear in court, post bail, or interfere with the justice system for you;</li>
<li>Book flights or hotels, act as an interpreter or tour escort, or store your luggage.</li>
</ul>
<hr>
<h2>5. How to find your country&#39;s embassy/consulate in China, on the spot</h2>
<p><strong>The most authoritative and up-to-date source is always your own government</strong> — it knows exactly how many missions it has in China, which area each one covers (its consular district), their addresses, phone numbers, and 24-hour emergency lines, all kept current and in your own language.</p>
<p><strong>Find it right now</strong>: search &quot;<strong><your country> embassy China</strong>&quot; on your phone, or open your foreign ministry&#39;s website and look for &quot;Embassy &amp; Consulates in China (驻华使领馆)&quot; — you&#39;ll see the official page, addresses, phone numbers, and emergency consular hotline.</p>
<p><strong>Which mission to contact</strong> (consular districts):</p>
<ul>
<li>Most countries have an <strong>embassy in Beijing</strong> and <strong>consulates-general</strong> in cities such as <strong>Shanghai, Guangzhou, Chengdu, Shenyang, Wuhan, and Chongqing</strong>, each covering nearby provinces by &quot;consular district&quot;.</li>
<li><strong>Find which district your city falls under, and contact that mission</strong>; if your country has no mission in your area, contact the consulate in the nearest mission city, or the embassy in Beijing.</li>
<li>If you&#39;re unsure which district applies, just call your embassy&#39;s consular line and ask.</li>
</ul>
<blockquote>
<p>This guide does not copy individual mission directories — precisely so you are never given an outdated address or number. <strong>Rely on your home country&#39;s official channels for the latest information.</strong></p>
</blockquote>
<hr>
<h2>6. Before you travel: save your consular info in a few minutes ✅</h2>
<p>This is easiest to do <strong>before your trip, while you have good internet and a clear head</strong>. Save a copy in your phone&#39;s notes or the cloud:</p>
<ol>
<li><strong>Your embassy/consulate in China</strong>: on your foreign ministry&#39;s website, find the <strong>mission nearest your destination</strong> and note its <strong>address, phone number, and 24-hour emergency consular line</strong>;</li>
<li><strong>Your foreign ministry&#39;s global consular emergency hotline</strong> (many countries have a single 24h number);</li>
<li><strong>A scan of your passport photo page</strong> (on your phone / cloud — very useful if you need a replacement);</li>
<li><strong>Your travel/medical insurance policy number and 24-hour assistance line</strong>;</li>
<li><strong>A few emergency phrases in Chinese</strong> (call the police / call an ambulance / lost passport);</li>
<li>Memorize <strong>110 / 120 / 119</strong> — in China, this is your first line of help in any emergency.</li>
</ol>
<blockquote>
<p>With these ready, if something happens you can reach the right people right away, instead of scrambling to find them in a panic.</p>
</blockquote>
<hr>
<h3>Notes</h3>
<ul>
<li>This guide provides only <strong>nationwide procedures and methods</strong>; for specific embassy/consulate contact details, rely on the <strong>latest information from your home country&#39;s official channels</strong>.</li>
<li>China&#39;s unified emergency numbers (110 / 120 / 119 / 122) are official nationwide numbers and remain valid long-term.</li>
</ul>$$, 0)
ON CONFLICT (id) DO UPDATE SET
  icon = EXCLUDED.icon,
  title_zh = EXCLUDED.title_zh,
  title_en = EXCLUDED.title_en,
  subtitle_zh = EXCLUDED.subtitle_zh,
  subtitle_en = EXCLUDED.subtitle_en,
  body_zh = EXCLUDED.body_zh,
  body_en = EXCLUDED.body_en,
  sort_order = EXCLUDED.sort_order,
  updated_at = NOW();


INSERT INTO emergency_medical_items (id, icon, title_zh, title_en, subtitle_zh, subtitle_en, body_zh, body_en, sort_order) VALUES
('health_prep', '📋', '', 'Health Prep Before You Travel', '', 'Your Health Card & Prescription Medicines', '', $$<h1>Health Prep Before You Travel — Your Health Card &amp; Prescription Medicines</h1>
<blockquote>
<p>For foreign visitors | English version | Information verified: 2026-06-29</p>
<p>China&#39;s medical system and entry rules are different from those in Europe and North America. Before departure, spend about ten minutes preparing <strong>two things</strong>. They can save you major trouble if you get sick or go through customs:
<strong>one. a health card to carry with you</strong> two. <strong>a doctor&#39;s letter for prescription medicines</strong>.
This section explains <strong>how to prepare them</strong>. These are your private details, so <strong>please prepare them yourself and keep them yourself</strong>; we only provide the method, do not fill it in for you, and the platform does not collect or store any personal health data.
⚠️ This article is for travel reference only and does not constitute medical or legal advice; follow your doctor&#39;s advice and the current regulations of China Customs.</p>
</blockquote>
<hr>
<h1>One. Personal Health Card to Show Medical Staff</h1>
<h3>Your Personal Health Card</h3>
<h2>Why Prepare One</h2>
<p>Most ordinary hospitals in China <strong>do not have English services</strong>. In an emergency, you may not be able to explain clearly, or may not be able to speak at all. A <strong>Chinese-English bilingual</strong> health card lets medical staff understand <strong>within seconds</strong> who you are, what you are allergic to, and what medical conditions you have. This is often critical information for treatment.</p>
<h2>What to Prepare</h2>
<p>Make it <strong>bilingual in Chinese and English</strong>, and include:</p>
<ul>
<li><strong>Identity</strong>: name, sex, date of birth, nationality, passport number, <strong>blood type (including Rh +/-)</strong>, and preferred language.</li>
<li><strong>Allergy history (most important)</strong>: medicine allergies (such as penicillin), food allergies (such as peanuts / seafood), and others (latex / contrast agent, etc.); whether you have ever had a severe allergy / anaphylactic shock, and whether you carry an epinephrine auto-injector (EpiPen).</li>
<li><strong>Chronic conditions / medical history</strong>: such as high blood pressure, diabetes (whether insulin is used), heart disease, asthma, epilepsy, etc.; major surgeries or implants (stent, pacemaker, etc.).</li>
<li><strong>Long-term medicines</strong>: write the <strong>generic name (active ingredient name), not only a foreign brand name</strong>, and include dose and frequency.</li>
<li><strong>Emergency contacts</strong>: name, relationship, and <strong>phone number with country code</strong> (two contacts are recommended).</li>
<li><strong>Travel medical insurance</strong>: insurer, policy number, and <strong>24h assistance phone number</strong>.</li>
<li><strong>Other</strong>: whether pregnant (gestational week), organ donation wishes, etc.</li>
<li><strong>One sentence for medical staff</strong> (can be shown directly):<blockquote>
<p>中文：<strong>你好，我是外国游客，中文不流利。这是我的健康信息卡，请帮助我；如需要，请联系我的紧急联系人或保险公司。</strong>
English: <em>Hello, I am a foreign visitor and don&#39;t speak Chinese well. This is my health card. Please help me, and if needed, contact my emergency contact or my insurer.</em></p>
</blockquote>
</li>
</ul>
<h2>How to Use It Safely</h2>
<ul>
<li><strong>Print one copy and carry it with you</strong> + <strong>save a screenshot on your phone</strong>, in a place that is easy to reach or open.</li>
<li>Write key items (allergies, blood type) <strong>large and clearly visible</strong>.</li>
<li>Update it whenever your information changes (new medicine, new allergy).</li>
</ul>
<blockquote>
<p>💡 This card is &quot;you, as shown to medical staff&quot;; phrases such as &quot;please help me call 120&quot; are <strong>for asking passersby for help</strong> and belong in 👉 <strong>&quot;Help Card — Point to These, Ask a Stranger for Help&quot;</strong>. The two cards serve different purposes.</p>
</blockquote>
<hr>
<h1>Two. Bringing Prescription Medicines and a Doctor&#39;s Letter</h1>
<h3>Bringing Prescription Medicines Into China</h3>
<h2>Four Core Principles</h2>
<ol>
<li><strong>Carry medicines with you</strong>: keep regular medicines in your carry-on luggage, and <strong>keep the original packaging and labels</strong>.</li>
<li><strong>Bring documentation</strong>: carry an <strong>English prescription</strong> or <strong>doctor&#39;s letter</strong> stating the medicine name (generic name), dose, course of treatment, and diagnosis.</li>
<li><strong>Bring a reasonable amount</strong>: only bring an amount for <strong>personal use within a reasonable treatment period</strong> (common travel advice is no more than about one month&#39;s supply, but this is a reference and not an official unified limit; larger amounts may lead to questions about use).</li>
<li><strong>Be careful with controlled ingredients</strong>: some prescription medicine ingredients that are common in Europe and North America are <strong>controlled / prohibited</strong> in China. See the table below.</li>
</ol>
<h2>What the Doctor&#39;s Letter Should Include</h2>
<ul>
<li>Patient name and passport number</li>
<li>Diagnosis</li>
<li>Medicine <strong>generic name / ingredient</strong>, strength, daily dose, and total amount carried</li>
<li>Explanation of medical necessity</li>
<li>Doctor&#39;s name, signature, medical institution, contact information, and date</li>
</ul>
<blockquote>
<p>English writing is recommended; adding a brief Chinese translation will make things smoother (not mandatory).</p>
</blockquote>
<h2>⚠️ China Controlled / Prohibited Ingredient Reminder (High Risk)</h2>
<blockquote>
<p>The following ingredients are common prescription / OTC medicines in many countries, but are <strong>strictly controlled or prohibited</strong> in China. Before carrying them, verify carefully and prepare all documentation; if necessary, do not carry them. <strong>The current regulations of China Customs are the final authority.</strong></p>
</blockquote>
<table>
<thead>
<tr>
<th>Category</th>
<th>Ingredients involved (examples)</th>
<th>Risk notes</th>
</tr>
</thead>
<tbody><tr>
<td>Opioid pain relief</td>
<td>可待因 Codeine, 曲马多 Tramadol, 羟考酮 Oxycodone, 吗啡 Morphine</td>
<td>Controlled narcotic / psychotropic medicines; procedures and risk are high, so confirm with the embassy / consulate or customs before carrying</td>
</tr>
<tr>
<td>Psychiatric / sleep medicines</td>
<td>阿普唑仑 Alprazolam (Xanax), 地西泮 Diazepam (Valium), 唑吡坦 Zolpidem (Ambien)</td>
<td>Category II psychotropic medicine control; prescription + documentation required, and excess quantity is high risk</td>
</tr>
<tr>
<td>Stimulants / ADHD</td>
<td>哌甲酯 Methylphenidate (Ritalin), 安非他明类 Amphetamine (Adderall)</td>
<td>Amphetamine-type substances are high-risk controlled substances in China; confirm before carrying; if you rely on them, discuss alternatives with your doctor before travel</td>
</tr>
<tr>
<td>Ephedrine-containing combinations</td>
<td>伪麻黄碱 Pseudoephedrine (some cold medicines)</td>
<td>Controlled; carrying large quantities is sensitive</td>
</tr>
<tr>
<td>Cannabis-related</td>
<td>大麻 Cannabis, CBD (cannabidiol), THC</td>
<td>Products containing cannabis / THC / CBD or synthetic cannabinoids are all high risk and are not recommended to carry; oils / gummies / skincare products / vape liquids are also included</td>
</tr>
</tbody></table>
<blockquote>
<p>🚩 <strong>Any product</strong> containing CBD / cannabis ingredients (supplements, skincare products, vape liquids) is high risk and not recommended to carry; ADHD amphetamine-type medicines (such as Adderall) are high-risk controlled substances. Before travel, discuss alternatives with your doctor and confirm with the embassy / consulate or customs.</p>
</blockquote>
<h2>Special Medicines</h2>
<ul>
<li><strong>Insulin / cold-chain medicines</strong>: carry them with you, prepare a portable cooling bag, bring the prescription and airline medical item documentation, and bring needles together while keeping the prescription.</li>
<li><strong>Injectables / injections</strong>: carrying needles requires a doctor&#39;s letter.</li>
<li><strong>Inhalers (asthma)</strong>: carry them with you and keep the original packaging.</li>
<li><strong>Contraceptive pills / hormones</strong>: generally, a personal-use quantity can be carried; keep the packaging.</li>
</ul>
<h2>What to Do If You Are Asked About Medicines at Entry</h2>
<ol>
<li>Proactively show your <strong>prescription / doctor&#39;s letter</strong> and the original medicine packaging.</li>
<li>Explain the purpose using the <strong>ingredient name (generic name)</strong>, not only the brand name.</li>
<li>Cooperate with inspection; if you have questions, you may request contact with your country&#39;s embassy or consulate.</li>
<li>If a medicine is judged not allowed to carry, cooperate with the handling process and <strong>do not argue or hide it</strong>.</li>
</ol>
<h2>Refilling / Replacing Medicines in China</h2>
<ul>
<li>Foreign prescriptions <strong>cannot be filled directly</strong> in China; a Chinese doctor must issue a new prescription.</li>
<li>You can visit a public hospital / <strong>医院国际部 (hospital International Department) / 涉外门诊 (foreign-related outpatient clinic) / foreign-invested clinic</strong> and have a doctor issue a Chinese prescription.</li>
<li>For chronic-condition medicines, it is recommended to <strong>bring enough with you</strong> and not rely on getting the exact same brand after arrival.</li>
</ul>
<hr>
<h2>See Also</h2>
<ul>
<li>&quot;Help Card — Point to These, Ask a Stranger for Help&quot; — phrases for asking others to help you in an emergency</li>
<li>&quot;How to Get Medical Care in China: A Guide for Foreign Visitors&quot; — the complete medical visit process</li>
<li>&quot;How to Buy Medicine in China: A Guide for Foreign Visitors&quot; — finding pharmacies, communicating with pharmacists, and cautions</li>
<li>&quot;City-by-City International Medical Services and Hospitals&quot; — find a nearby hospital that is more foreigner-friendly</li>
</ul>
<hr>
<p><strong>Information verified: 2026-06-29</strong> | Controlled medicine lists and customs rules are subject to current official Chinese announcements. Before travel, please confirm again with the Chinese embassy / consulate in your location or the 12360 China Customs hotline.</p>$$, 0),
('hospital_visit', '🏥', '', 'How to Get Medical Care in China', '', 'A Guide for Foreign Visitors', '', $$<h1>How to Get Medical Care in China — A Guide for Foreign Visitors</h1>
<blockquote>
<p>For foreign visitors | English version | Information verified: 2026-06-29
How to use this: read it once before travel to understand the basic expectations for &quot;how to see a doctor in China&quot;; if something happens, match your situation to the relevant scenario.
⚠️ This article is for travel reference, helping you understand the medical visit process and practical information. It <strong>does not constitute medical advice</strong>; if you feel unwell, seek medical care promptly and let a doctor assess you.</p>
</blockquote>
<hr>
<h2>One. Read This First</h2>
<p>China <strong>does not have a GP and referral system</strong>. Medical care usually follows a <strong>&quot;go directly to a hospital and register&quot;</strong> model. This is very different from Europe and North America, and it is the part most likely to confuse foreign visitors.</p>
<ul>
<li>You do not need to make an appointment with a GP first and then get referred; <strong>go directly to a hospital, register on site, choose a department, and see a doctor.</strong></li>
<li>Medical care is generally <strong>pay first, then receive service</strong>: you pay first for registration, tests, and medicines.</li>
<li>Foreign visitors <strong>do not have Chinese public medical insurance and pay out of pocket throughout</strong>. This is why <strong>travel medical insurance</strong> and <strong>keeping all invoices and receipts</strong> are very important (you will need them for reimbursement after returning home).</li>
</ul>
<hr>
<h2>Two. Three Scenarios by Urgency</h2>
<h3>Scenario One | Emergency / Life-Threatening</h3>
<ul>
<li><strong>Call 120 for an ambulance.</strong> Note: a 120 ambulance usually <strong>requires payment</strong>, and the dispatcher may not speak English. <strong>The safest approach is to ask your hotel front desk to call for you</strong> and clearly state the address.</li>
<li>Or go directly to the <strong>急诊科 (Emergency / ER)</strong> of a major hospital, which is open 24 hours.</li>
<li>In China, it is common to <strong>pay 押金 (deposit)</strong> before treatment, so prepare a usable bank card / mobile payment method.</li>
<li>In a real emergency, you may not have time to type into a translation app. You can directly show / point to 👉 <strong>&quot;Help Card — Point to These, Ask a Stranger for Help&quot;</strong> (asking a passerby to call 120 for you).</li>
</ul>
<h3>Scenario Two | Non-urgent Illness (Cold, Stomach Upset, Minor Injury, etc.)</h3>
<p>For short-term visitors, it is recommended to choose <strong>foreigner-friendly medical options</strong> first. There are two main routes:</p>
<ul>
<li><strong>The &quot;国际部&quot; (International Department) of a large public hospital</strong>. It has English-speaking doctors and a smoother process. Prices are slightly higher, but it is the most foreigner-friendly option in public hospitals.</li>
<li><strong>Foreign-invested / private international clinics</strong>. These offer the best English-language environment, and many can provide direct billing with international insurance. Prices are higher, and the experience is similar to private clinics in Europe and North America.</li>
<li>Ordinary outpatient clinics in public hospitals can also treat you and are <strong>cheaper</strong>, but the whole process is <strong>in Chinese, requires registration on self-service machines, involves queues, and may have no English-speaking staff</strong>. For short-term visitors, the barrier is higher.</li>
</ul>
<p>For specific options by city, see 👉 <strong>&quot;City-by-City International Medical Services and Hospitals&quot;</strong>.</p>
<h3>Scenario Three | Pharmacy &amp; Minor Issues</h3>
<ul>
<li>Pharmacies, called <strong>&quot;药房&quot; (pharmacy) or &quot;药店&quot; (drugstore)</strong> in Chinese, are common and easy to find. Convenience stores usually do not sell medicine.</li>
<li>However, China has <strong>stricter prescription medicine controls than Europe and North America</strong>, and many medicines that are OTC abroad may require a prescription here.</li>
<li>For how to find a pharmacy, communicate with a pharmacist, and buy medicine safely, see 👉 <strong>&quot;How to Buy Medicine in China: A Guide for Foreign Visitors&quot;</strong>.</li>
</ul>
<hr>
<h2>Three. Step by Step at a Hospital</h2>
<p>This is the typical process for ordinary outpatient care at a public hospital. Once you understand this &quot;loop&quot;, it is less stressful:</p>
<ol>
<li><strong>Register</strong>: register at a self-service machine or counter, <strong>choose a department first</strong> (such as Internal Medicine, Surgery, Pediatrics), and pay the registration fee. If you are not sure which department to choose, ask at the <strong>导诊台 / 分诊台 (guidance desk / triage desk)</strong>.</li>
<li><strong>Wait</strong>: go to the waiting area for that department and wait for your number to be called.</li>
<li><strong>See the Doctor</strong>: meet the doctor and explain your symptoms (you can show a translation or health card).</li>
<li><strong>Pay -&gt; Tests</strong>: if the doctor orders lab tests / imaging, you must <strong>pay first at the payment counter / self-service machine, then do the tests</strong>. After receiving the results, <strong>return to the doctor for follow-up</strong>.</li>
<li><strong>Prescription -&gt; Pay -&gt; Pharmacy</strong>: after the doctor prescribes medicine, <strong>pay first</strong>, then collect the medicine at the <strong>药房窗口 (pharmacy window / medicine pickup counter)</strong>.</li>
<li>Keep all <strong>registration slips, invoices, and test reports</strong> throughout the process. For self-paid care, these are reimbursement documents.</li>
</ol>
<blockquote>
<p>💡 Key difference: many steps are &quot;<strong>pay first, then proceed</strong>&quot;, and after tests you usually need to <strong>bring the results back to the doctor</strong>. The visit is not necessarily finished after one consultation. The process at an International Department / private clinic is more streamlined and guided.</p>
</blockquote>
<hr>
<h2>Four. Good to Know for Foreign Visitors</h2>
<ul>
<li><strong>Registration system</strong>: you must first &quot;挂号&quot; (registration) and choose a department before seeing a doctor; walk-in registration is possible, but you need to use a self-service machine or counter.</li>
<li><strong>Pay before treatment</strong>: in most cases you pay first / pay a deposit first. <strong>Bank cards, WeChat Pay, and Alipay are the main methods; cash is less common</strong>.</li>
<li><strong>Medical insurance is not shared</strong>: foreign visitors do not have Chinese public medical insurance and <strong>pay fully out of pocket</strong>; be sure to buy <strong>travel medical insurance</strong> and <strong>keep all invoices and receipts</strong>.</li>
<li><strong>Language barrier</strong>: outside International Departments / private clinics, English services are <strong>generally not available</strong>.</li>
<li><strong>Mobile payment</strong>: if you do not have a mainland Chinese phone number / bank card linked, WeChat Pay or Alipay may <strong>not work</strong>. It is recommended to set up foreign card binding in advance or prepare a usable payment method.</li>
<li><strong>Foreign prescriptions cannot be filled directly</strong>: a Chinese doctor must issue a new prescription. For chronic-condition medicines, it is recommended to <strong>bring enough with you</strong>.</li>
</ul>
<hr>
<h2>Five. Before You Travel</h2>
<ul>
<li><input disabled="" type="checkbox"> Buy <strong>travel medical insurance</strong>, and write down your <strong>policy number</strong> and <strong>24h assistance phone number</strong>.</li>
<li><input disabled="" type="checkbox"> Prepare your own <strong>Chinese-English health card</strong>. If you have chronic conditions / long-term medicines, also prepare an <strong>English prescription or doctor&#39;s letter</strong> and check whether ingredients are restricted 👉 see <strong>&quot;Health Preparation Before Travel: Emergency Card and Prescription Medicines&quot;</strong>.</li>
<li><input disabled="" type="checkbox"> Save 👉 <strong>&quot;Help Card — Point to These&quot;</strong> and the destination city&#39;s 👉 <strong>&quot;International Medical Services and Hospitals List&quot;</strong> on your phone.</li>
<li><input disabled="" type="checkbox"> Confirm one <strong>payment method that works in China</strong>.</li>
</ul>
<hr>
<h2>Six. Key Numbers</h2>
<table>
<thead>
<tr>
<th>Purpose</th>
<th>Number</th>
</tr>
</thead>
<tbody><tr>
<td>急救 / 救护车 Ambulance</td>
<td><strong>120</strong></td>
</tr>
<tr>
<td>报警 Police</td>
<td><strong>110</strong></td>
</tr>
<tr>
<td>火警 Fire</td>
<td><strong>119</strong></td>
</tr>
<tr>
<td>Your insurance 24h assistance phone number</td>
<td>See your policy / health card</td>
</tr>
</tbody></table>$$, 1),
('buy_medicine', '💊', '', 'How to Buy Medicine in China', '', 'A Guide for Foreign Visitors', '', $$<h1>How to Buy Medicine in China — A Guide for Foreign Visitors</h1>
<blockquote>
<p>For foreign visitors | English version | Information verified: 2026-06-29</p>
<p>This guide explains <strong>how to find a pharmacy in China, how to communicate with a pharmacist, and what to watch out for when buying medicine</strong>.
⚠️ We <strong>do not choose medicines for you or provide dosage instructions</strong>. What to buy and how much to take should follow the <strong>medicine package insert</strong> and the advice of a <strong>licensed pharmacist / doctor</strong>. This article is for process reference only and does not constitute medical advice.</p>
</blockquote>
<hr>
<h2>One. Where to Buy</h2>
<ul>
<li>Look for shops with signs such as <strong>&quot;药房&quot; (pharmacy), &quot;药店&quot; (drugstore), or &quot;大药房&quot; (large pharmacy)</strong>. They are common in cities.</li>
<li><strong>Convenience stores and supermarkets do not sell medicine</strong> (at most, they may sell a small number of health supplements).</li>
<li>Pharmacies usually have long opening hours. Big cities have <strong>24-hour pharmacies</strong>; in a map app, search for &quot;药店 24 小时&quot;.</li>
<li>Prescription medicine requires a doctor&#39;s prescription and is often bought at a <strong>hospital pharmacy</strong> or at a pharmacy with a valid prescription.</li>
</ul>
<h2>Two. Labels to Know in a Pharmacy</h2>
<ul>
<li><strong>Blue &quot;OTC&quot;</strong> on the package = OTC (over-the-counter) medicine, available without a prescription.</li>
<li><strong>Red &quot;OTC&quot;</strong> = OTC medicine, but it requires more caution; it is better to ask the pharmacist.</li>
<li><strong>&quot;处方药 / Rx&quot; (prescription medicine / Rx)</strong> = a doctor&#39;s prescription is required; you cannot buy it on your own.</li>
<li>Most pharmacies have a <strong>执业药师 (licensed pharmacist)</strong> on site. <strong>If you have any questions, ask the pharmacist directly. This is the most reliable and safest approach.</strong></li>
</ul>
<h2>Three. How to Communicate with the Pharmacist</h2>
<p>If you do not speak Chinese, that is okay. <strong>The easiest method is to use a translation app</strong>: translate your symptoms or the medicine name you want into Chinese and show it to the pharmacist. Typed text or voice both work, and this is accurate and flexible. Also:</p>
<ul>
<li><strong>If you cannot explain clearly, ask the pharmacist to recommend something</strong>: describe where you feel unwell, or point to the area for the pharmacist, and let <strong>the pharmacist help choose the medicine</strong>. Leaving the choice to a professional is the safest option.</li>
<li><strong>If you already know what you want to buy, give the generic name</strong>: for example, ibuprofen or loratadine. Show the pharmacist the <strong>English generic name (active ingredient name)</strong>.</li>
<li><strong>Use the ingredient name, not the brand name</strong>: give the <strong>ingredient name / generic name</strong>, not only a foreign brand name. Chinese pharmacists can usually match the ingredient, but they may not know overseas brands.</li>
</ul>
<h2>Four. Important Cautions</h2>
<ul>
<li><strong>Read the package insert and ask the pharmacist about dosage</strong>. Do not estimate the dose based on past experience, because formulations and concentrations differ by country.</li>
<li><strong>Tell the pharmacist about allergies and medicines you are currently taking</strong>. This is especially important if you are allergic to certain medicines or are taking long-term medication, to avoid interactions.</li>
<li><strong>Watch out for duplicate ingredients</strong>. Many Chinese combination cold / cough medicines already contain <strong>对乙酰氨基酚 (acetaminophen)</strong>. Do not add a single-ingredient fever reducer on top of them, or you may overdose and harm your liver.</li>
<li><strong>Check ingredients before taking medicines home</strong>. Some Chinese cough medicines contain <strong>可待因 codeine</strong>, and some cold medicines contain <strong>伪麻黄碱 pseudoephedrine</strong>. These are restricted for entry in many countries, so <strong>do not casually bring them back with you</strong>. For details, see 👉 <strong>&quot;Health Preparation Before Travel: Emergency Card and Prescription Medicines&quot;</strong>.</li>
<li><strong>Payment</strong>: most pharmacies accept WeChat Pay / Alipay, and some larger stores accept bank cards.</li>
<li><strong>Keep the original packaging and receipt</strong>, especially if you plan to take the medicine back to your home country.</li>
</ul>
<h2>Five. Do Not Self-Medicate in These Situations. See a Doctor Instead.</h2>
<ul>
<li>Symptoms are severe, do not improve, or are getting worse.</li>
<li><strong>Severe allergy</strong> (difficulty breathing, facial swelling, shock). This is an emergency. <strong>Call 120 immediately</strong>; do not rely on buying medicine.</li>
<li>Persistent high fever, bloody stool, severe abdominal pain, chest pain, serious injury, and similar symptoms.</li>
<li>For pregnant people, breastfeeding people, children, and people with chronic conditions, <strong>consult a doctor or pharmacist first</strong>.</li>
</ul>
<blockquote>
<p>For the medical visit process, see 👉 <strong>&quot;How to Get Medical Care in China: A Guide for Foreign Visitors&quot;</strong>.</p>
</blockquote>$$, 2)
ON CONFLICT (id) DO UPDATE SET
  icon = EXCLUDED.icon,
  title_zh = EXCLUDED.title_zh,
  title_en = EXCLUDED.title_en,
  subtitle_zh = EXCLUDED.subtitle_zh,
  subtitle_en = EXCLUDED.subtitle_en,
  body_zh = EXCLUDED.body_zh,
  body_en = EXCLUDED.body_en,
  sort_order = EXCLUDED.sort_order,
  updated_at = NOW();
