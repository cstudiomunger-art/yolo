-- Generated legal documents for app_settings (id=global) — Markdown
-- Sources: Privacy Policy, Terms of Service, GDPR Framework, AI Content Disclosure
-- Generated: 2026-07-12T03:51:35.575Z

-- 1/4 privacy_policy_body (22965 chars)
UPDATE app_settings
SET privacy_policy_body = $yolo_legal_privacy_policy_body$# Privacy Policy

**Last Updated:** June 29, 2026  
**Effective Date:** June 29, 2026

---

## 1. Introduction

Chengdu Yuliu Technology Co., Ltd. ("**Yuliu Tech**", "**we**", "**us**", or "**our**"), a company registered in Chengdu, Sichuan Province, People's Republic of China, operates the **YOLO HAPPY** iOS mobile application (the "**App**"). We are committed to protecting your privacy and processing your personal data in a transparent, lawful, fair, and necessary manner.

This Privacy Policy explains how we collect, use, store, share, and protect your personal data when you use the App, and describes your rights under applicable data protection laws.

### 1.1 Applicable Laws

This Privacy Policy is prepared in accordance with, among others:

- The **General Data Protection Regulation (GDPR)** — applicable to users located in the EU/EEA
- The **California Consumer Privacy Act / California Privacy Rights Act (CCPA/CPRA)** — applicable to California residents
- The **Personal Information Protection Law of the People's Republic of China (PIPL)** — applicable as the data controller is a China-registered company
- The **Data Security Law of the PRC** and the **Cybersecurity Law of the PRC**

### 1.2 Data Controller

| Item | Detail |
|------|--------|
| Data Controller | Chengdu Yuliu Technology Co., Ltd. (成都预流科技有限公司) |
| Registered Address | No. 14, 1/F, Building 1, No. 299 Ronghua North Road, Chengdu Hi-tech Zone, Sichuan Province, 610094, P.R. China |
| Privacy Contact | chengduyuliutech@163.com |
| User Support | support@yolohappy.app |

If you do not agree with this Privacy Policy, please do not use the App.

---

## 2. Data We Collect

### 2.1 Information You Provide

| Category | Examples | Purpose | Legal Basis (GDPR) | Legal Basis (PIPL) |
|----------|---------|---------|:---:|:---:|
| **Account Information** | Display name, email address, authentication tokens (Apple Sign In / Google Sign In / email registration) | Account creation, authentication, account security | Art. 6(1)(b) — Contract performance | Art. 13(1)(ii) — Necessary for contract |
| **Profile Data** | Avatar, nationality | Personalized travel recommendations, visa eligibility detection, pre-trip checklist customization | Art. 6(1)(b) — Contract performance | Art. 13(1)(ii) — Necessary for contract |
| **Itinerary Data** | Destination city, travel dates (arrival/departure), travel preferences, itinerary details (activities, notes) | AI-assisted itinerary planning, trip reminders, pre-trip checklist generation | Art. 6(1)(b) — Contract performance | Art. 13(1)(ii) — Necessary for contract |
| **Customer Support Communications** | Chat messages, uploaded images | Genius Bar support services, service quality improvement | Art. 6(1)(f) — Legitimate interests | Art. 13(1)(ii) — Necessary for contract |
| **Purchase Information** | Subscription status, purchase history (processed via RevenueCat and Apple App Store; we do **not** directly collect credit card numbers or payment credentials) | In-app purchase fulfillment, subscription management, refund processing | Art. 6(1)(b) — Contract performance | Art. 13(1)(ii) — Necessary for contract |

### 2.2 Automatically Collected Information

| Category | Examples | Purpose | Legal Basis |
|----------|---------|---------|-------------|
| **Device Information** | Device model, OS version, language preferences | App compatibility, bug fixes, UX optimization | Contract performance (Art. 6(1)(b) GDPR / Art. 13(1)(ii) PIPL) |
| **Crash & Performance Data** | Anonymized crash logs and performance diagnostics via Apple MetricKit system framework | App stability and bug fixes | Legitimate interests (Art. 6(1)(f) GDPR) |
| **Content Preferences** | Favorited attractions, downloaded audio guides, content mode selection | Personalized experience, offline access support | Contract performance (Art. 6(1)(b) GDPR / Art. 13(1)(ii) PIPL) |

> **Important:** This App does **NOT** integrate any third-party remote analytics or tracking SDKs (e.g., Firebase Analytics, Google Analytics, Facebook SDK, Adjust, Amplitude, Mixpanel, Shence, Youmeng). Client-side `os.log` is Apple's native local logging only. We do **not** profile you or conduct automated behavioral predictions.

### 2.3 Permission-Based Data

| Permission | Purpose | Required? |
|------------|---------|:---------:|
| **Push Notifications** | Trip reminders, pre-trip checklist alerts, customer support message notifications | Optional (revocable in system settings) |
| **Photo Library (Write)** | Saving shared itinerary card images | Optional |
| **Photo Library (Read)** | Uploading profile avatar; sending images in support chat | Optional |
| **Background Audio** | Continuing audio guide playback when the App is in the background or device is locked | Optional |

> This App does **NOT** request access to: camera, microphone, location, contacts, or Bluetooth.

---

## 3. How We Use Your Data

We use your personal data only for the purposes stated in this Privacy Policy and only where a valid legal basis exists:

| Processing Activity | Data Involved | Legal Basis |
|---------------------|---------------|-------------|
| Creating and managing your account | Account Information | Contract performance (Art. 6(1)(b) GDPR / Art. 13(1)(ii) PIPL) |
| AI-assisted itinerary generation | Itinerary Data, Profile Data | Contract performance |
| Providing audio guides and city guide content | Device info, Content Preferences | Contract performance |
| Visa eligibility detection and pre-trip checklists | Nationality, destination, stay duration | Contract performance |
| Processing in-app purchases and subscriptions | Anonymized purchase tokens | Contract performance |
| Providing Genius Bar customer support | Support communications | Contract performance |
| Sending push notifications | Device Push Token | **Your separate consent** (Art. 6(1)(a) GDPR / Art. 13(1)(i) PIPL) |
| App stability monitoring (crash diagnostics) | Anonymized MetricKit data | Contract performance |

If we need to use your personal data for purposes not covered in this Policy or for new business scenarios, we will obtain your consent separately.

---

## 4. AI Content Generation

The App uses artificial intelligence (AI) to generate travel itineraries, audio guide content, and other materials. This section provides transparency disclosures required under PIPL Art. 24 (automated decision-making), GDPR Art. 22, and relevant AI regulations.

### 4.1 How We Use AI

| Dimension | Detail |
|-----------|--------|
| **Data sent to AI** | **Text only** (destination cities, travel dates, preference keywords, assistant dialogue messages). The App does **NOT** upload your photos or images for AI analysis |
| **AI Service Provider** | Volcengine Ark LLM API (Beijing, China node, `ark.cn-beijing.volces.com`) |
| **Data flow** | User iOS device → Supabase Edge Function (US West) → Volcengine Ark (Beijing, China) → AI-generated results returned |
| **AI output type** | Itinerary suggestions, guide information, travel phrase translations — informational travel references only |
| **AI training** | We do **NOT** use your personal data to train AI models. Volcengine is contractually prohibited from using your inputs to train its general-purpose models |

### 4.2 AI Accuracy Disclaimer

**AI-generated content may contain inaccuracies, omissions, or outdated information.** AI itineraries and guide content are for travel reference only and do NOT constitute legal advice, visa decision-making basis, or official information. You should independently verify critical information through official channels, including but not limited to:

- Visa policies and entry requirements (consult official embassy/consulate websites)
- Attraction opening hours, ticket prices, and booking requirements
- Transportation schedules and routes
- Safety and health advisories

### 4.3 Non-AI Alternatives

You may use the App **without any AI processing.** The following non-AI paths are available:

- **Guest mode (not logged in):** Itinerary planning uses a local deterministic algorithm — no remote AI calls
- **AI fallback:** If remote AI fails, the system automatically falls back to local itinerary assembly
- **Assistant offline mode:** Can be configured to `offline` mode, returning offline help guidance
- **Core features are AI-independent:** Audio guides, visa lookup, pre-trip checklists, emergency info, payment guides — all fully functional without AI

---

## 5. How We Share Your Data

We do **NOT sell** your personal data. We share data only under the following circumstances:

### 5.1 Data Processors (Service Providers)

We engage the following service providers to process data on our behalf. Under PIPL Art. 21 and GDPR Art. 28, processing agreements specify the purpose, duration, method, data categories, protective measures, and respective rights and obligations:

| Provider | Service | Data Processed | Processing Location | DPA Status |
|----------|---------|----------------|---------------------|:----------:|
| **Supabase** | Backend database (PostgreSQL), authentication, file storage, Edge Functions | Account info, profiles, itineraries, support chat records, avatar files | US West (us-west-1) | ✅ Covered by Supabase DPA (accepted via Terms of Service) |
| **Volcengine Ark** (ByteDance) | AI text inference (itinerary, assistant dialogue, chat translation) | User text input (destination, dates, preference keywords, dialogue) — does **NOT** include name, email, or nationality | Beijing, China | ⚠️ DPA pending signature; recommend completion before launch |
| **RevenueCat** | In-app purchase receipt validation, subscription management | Anonymous user ID, purchase tokens (transaction ID, product ID, subscription expiry) — no PII | United States | ⚠️ Integration in progress; DPA coverage to be confirmed |
| **Apple (APNs)** | Push notification delivery | Device push token | Apple global infrastructure | ✅ Covered by Apple Developer Agreement |
| **Cloudflare** | Workers edge hosting (shared itinerary pages, marketing site, CMS) | Standard server access logs (CDN/security purposes only) | Global edge network | ✅ Covered by Cloudflare Terms of Service |

### 5.2 Independent Data Controllers

The following third parties process your data as **independent data controllers** — please refer to their respective privacy policies:

| Third Party | Function | Data Involved |
|-------------|----------|---------------|
| **Apple (Sign in with Apple)** | Third-party login | Apple user identifier, email (if you authorize sharing) |
| **Google (Google OAuth)** | Third-party login | Google account identifier, email |
| **Apple App Store / StoreKit** | In-app purchases | Transaction receipts, subscription status |

### 5.3 Legal Compliance

We may disclose your data where required by law, court order, or governmental regulation, or where we believe in good faith that disclosure is necessary to protect our rights, your safety, or the safety of others.

### 5.4 Business Transfers

If Yuliu Tech is involved in a merger, acquisition, or asset sale, your personal data may be transferred as part of that transaction. We will notify you of the identity and contact details of the recipient and require the recipient to continue honoring this Privacy Policy. Any change in processing purposes or methods will require renewed consent.

---

## 6. International Data Transfers

### 6.1 Storage Locations and Transfer Paths

Your data is stored at and transferred through the following locations:

| Data Type | Primary Storage/Processing Location | Provider |
|-----------|-------------------------------------|----------|
| Core business data (accounts, itineraries, preferences, support chats) | **US West** (AWS us-west-1, Supabase Cloud) | Supabase |
| Media files (avatars, audio guides) | Same as above (Supabase Storage) | Supabase |
| AI inference requests (text) | **Beijing, China** (Volcengine Ark API) | Volcengine |
| Shared itinerary pages, email confirmation, password reset | Cloudflare Workers global edge network | Cloudflare |

**Full transfer paths:**
1. General business data: User iOS device (global) → HTTPS → Supabase (US West, us-west-1)
2. AI features: User iOS device → Supabase Edge Function (US West) → Volcengine Ark (Beijing, China) → results returned
3. Apple/Google sign-in: Device ↔ Identity provider ↔ Supabase Auth
4. Push notifications: Supabase/backend → Apple APNs → User device
5. In-app purchases: Device ↔ Apple App Store; subscription validation via RevenueCat (US) → write-back to Supabase

### 6.2 GDPR Transfer Safeguards (Art. 44–49)

For transfers outside the EEA, we rely on:

- **Standard Contractual Clauses (SCCs):** We adopt the framework of EU Standard Contractual Clauses (2021/914) in our data processing agreements with processors in third countries
- **Transfer Impact Assessment (TIA):** Transfers to China (for AI processing) have been assessed for local law impacts on data protection
- **Supplementary measures:** TLS 1.3 encryption in transit, AES-256 encryption at rest, contractual obligations on processors

### 6.3 PIPL Cross-Border Transfer Rules (Art. 38–39)

Under PIPL Art. 38, we implement the following safeguards for cross-border data transfers:

- Supabase provides AES-256 encryption at rest, Row Level Security (RLS), and TLS 1.3 encryption in transit
- Data processing agreements are in place or pending with all processors
- All cross-border links use encrypted HTTPS/TLS connections

Under **PIPL Art. 39**, we inform you of:
- **Overseas recipients:** Supabase Inc. (US), Volcengine (China), RevenueCat Inc. (US)
- **Processing purposes, methods, and data categories:** As detailed in Section 2 and Section 5.1
- **How to exercise your rights against overseas recipients:** See Section 8

**Separate Consent:** Under PIPL Art. 39, cross-border transfer of personal information requires your **separate consent**. We will request this consent via a dedicated consent screen when you first use the App. You may withdraw this consent at any time, though this will not affect the lawfulness of processing based on consent before its withdrawal. Withdrawal may result in certain features (such as AI itinerary planning) becoming unavailable.

---

## 7. Data Retention

We retain your personal data only as long as necessary for the stated purposes:

| Data Category | Retention Period | Deletion Mechanism |
|---------------|-----------------|-------------------|
| Account data (`auth.users`) | **Immediately deleted** upon account deletion | `delete-account` Edge Function removes Supabase Auth user |
| Associated business data (profiles, itineraries, favorites, checklist progress, support sessions) | **Immediately deleted** upon account deletion | `ON DELETE CASCADE` database constraints |
| User avatar files (`avatars/{userId}/`) | **Immediately deleted** upon account deletion | Storage directory cleaned synchronously |
| Supabase platform backups | 7–30 days (depending on plan tier) | Infrastructure-level backups, not business-accessible |
| Apple IAP transaction records | Retained by Apple per Apple Privacy Policy | Apple manages as independent controller |
| RevenueCat transaction logs | Per RevenueCat data retention policy | To be confirmed upon integration completion |
| Statutory retention (e.g., accounting records) | No less than 10 years (PRC Accounting Law) | Separable from personal account data; can be anonymized |

> **Account deletion path:** App → Profile → Settings → Delete account → Confirmation → **Immediate effect.** Deleted accounts and all associated cloud data are permanently removed and cannot be recovered. Local App cache must be manually cleared via Settings → Clear Cache or by uninstalling the App.

---

## 8. Your Rights

### 8.1 GDPR Rights (EU/EEA Users)

| Right | GDPR Article | How to Exercise |
|-------|:-----------:|-----------------|
| **Right of access** | Art. 15 | Email request or view profile in App |
| **Right to rectification** | Art. 16 | Edit profile in App Settings |
| **Right to erasure** | Art. 17 | Delete account in App Settings or email request |
| **Right to restriction** | Art. 18 | Email request |
| **Right to data portability** | Art. 20 | Email request (JSON/CSV export) |
| **Right to object** | Art. 21 | Adjust preferences in App Settings or email |
| **Right to withdraw consent** | Art. 7(3) | Revoke in App notification/privacy settings |
| **Right not to be subject to automated decision-making** | Art. 22 | App has no solely automated decisions producing legal or similarly significant effects; non-AI mode available |

### 8.2 PIPL Rights (All Users)

| Right | PIPL Article | Description |
|-------|:-----------:|-------------|
| **Right to know and decide** | Art. 44 | Know the processing rules and decide whether to consent |
| **Right to restrict or refuse processing** | Art. 44 | Restrict or refuse processing of your personal data (unless otherwise provided by law) |
| **Right to access and copy** | Art. 45 | Access and obtain a copy of your personal data |
| **Right to data portability** | Art. 45 | Transfer your data to another designated processor |
| **Right to rectification** | Art. 46 | Correct or complete inaccurate or incomplete data |
| **Right to deletion** | Art. 47 | Request deletion under specified circumstances |
| **Right to explanation** | Art. 48 | Request explanation of processing rules |
| **Rights of next-of-kin** | Art. 49 | After death, next-of-kin may exercise certain rights for their own legitimate interests |

### 8.3 CCPA/CPRA Rights (California Residents)

- **Right to know:** What personal information we collect, use, and share
- **Right to delete:** Request deletion of your personal information
- **Right to correct:** Request correction of inaccurate personal information
- **Right to opt-out:** We do NOT sell your data, so no opt-out is needed
- **Right to non-discrimination:** We will not discriminate against you for exercising your rights

**Response Time:** We will respond to your requests within **30 calendar days**. If more time is needed due to complexity, we will notify you within the 30-day period with an explanation.

**Identity Verification:** Before acting on your request, we verify your identity by:
- Matching your request email with your account email
- Requiring in-app authentication for requests submitted through the App
- Requesting additional verification for sensitive requests when identity cannot be confirmed

**Contact for exercising rights:**
- Data protection: chengduyuliutech@163.com
- User support: support@yolohappy.app

### 8.4 Right to Complain

If you believe your data protection rights have been violated, you have the right to lodge a complaint with the competent data protection authority in China, your EU member state, or another jurisdiction with regulatory authority. We encourage you to first contact us through the channels above so we can address your concerns directly.

---

## 9. Data Security

We implement appropriate technical and organizational measures to protect your personal data:

| Security Layer | Measures |
|----------------|----------|
| **Transmission** | HTTPS/TLS 1.3 encryption for all network communications |
| **Storage** | AES-256 encryption at rest (Supabase); Row Level Security (RLS) per-user access control |
| **Authentication** | Apple Sign In, Google OAuth, email+password (Supabase Auth managed) |
| **Access Control** | Least privilege principle; role-based access for administrative functions |
| **Data Isolation** | Logical isolation of each user's data via unique user ID (UUID) |
| **Monitoring** | Supabase audit logs; MetricKit crash monitoring |

No method of electronic storage or transmission is 100% secure. We cannot guarantee absolute security.

---

## 10. Data Breach Notification

In the event of a personal data breach, we will:

1. **Immediately take remedial measures:** Identify and contain the breach, assess impact scope
2. **Notify supervisory authorities:** Within the statutory timeframes under PIPL Art. 57 and GDPR Art. 33 (within 72 hours of becoming aware under GDPR)
3. **Notify affected users:** Without undue delay if the breach is likely to result in high risk to your rights and freedoms
4. **Document and archive:** Maintain a complete record of the breach facts, impact assessment, and remedial measures

---

## 11. Children's Privacy

The App is intended primarily for **adult** international travelers visiting China and does not contain functionality specifically directed at minors.

- We do **not knowingly collect** personal data from individuals under the age of 18
- If you are a minor, please use the App only with the consent and guidance of your parent or guardian
- If we become aware that we have inadvertently collected personal data from a minor, we will delete it immediately
- If you believe a minor has provided us with personal data, please contact us at chengduyuliutech@163.com

> We have set an appropriate age rating in App Store Connect.

---

## 12. Cookies and Tracking Technologies

- **This App (iOS client) does not use cookies.**
- We do **NOT** integrate any third-party remote analytics or tracking SDKs
- The App uses only Apple native `os.log` for local logging and Apple MetricKit for crash/performance diagnostics
- **Shared itinerary pages (Web):** Pure static HTML with direct Supabase REST API calls — no cookies, no tracking
- Cloudflare Workers may record standard server access logs for CDN/security purposes — **not** used for user profiling or ad targeting

---

## 13. Third-Party Links

The App may contain links to third-party websites or services (e.g., official visa application portals, transportation booking platforms). We are not responsible for the privacy practices of these third parties. We recommend reviewing their respective privacy policies before providing any personal data.

---

## 14. Changes to This Policy

We may update this Privacy Policy from time to time. For material changes, we will notify you by:

- Posting the updated policy within the App
- Sending a push notification or email (for significant changes affecting your rights)
- Updating the "Last Updated" date at the top of this page

Your continued use of the App after changes take effect constitutes acceptance. If you disagree, you must stop using the App and delete your account.

---

## 15. Contact Us

For questions, concerns, or requests regarding this Privacy Policy or our data practices:

| Channel | Detail |
|---------|--------|
| **Data Protection** | chengduyuliutech@163.com |
| **User Support** | support@yolohappy.app |
| **Mailing Address** | Chengdu Yuliu Technology Co., Ltd. |
|  | No. 14, 1/F, Building 1, No. 299 Ronghua North Road |
|  | Chengdu Hi-tech Zone, Sichuan Province, 610094, P.R. China |
|  | Attn: Data Protection Officer |

---

*© 2026 Chengdu Yuliu Technology Co., Ltd. All rights reserved.*$yolo_legal_privacy_policy_body$,
    updated_at = NOW()
WHERE id = 'global';

-- 2/4 terms_of_service_body (20840 chars)
UPDATE app_settings
SET terms_of_service_body = $yolo_legal_terms_of_service_body$# Terms of Service

**Last Updated:** June 29, 2026  
**Effective Date:** June 29, 2026

---

## 1. Introduction

Welcome to **YOLO HAPPY** (the "**App**"), a travel assistant iOS application operated by **Chengdu Yuliu Technology Co., Ltd.** ("**Yuliu Tech**", "**we**", "**us**", or "**our**"), a company registered at No. 14, 1/F, Building 1, No. 299 Ronghua North Road, Chengdu Hi-tech Zone, Sichuan Province, 610094, P.R. China.

By downloading, installing, accessing, or using the App, you ("**User**", "**you**", or "**your**") agree to be bound by these Terms of Service (the "**Terms**"). **If you do not agree to these Terms, do not use the App.**

These Terms, together with our [Privacy Policy](/privacy-policy), constitute the entire agreement between you and Yuliu Tech regarding your use of the App.

---

## 2. Service Description

YOLO HAPPY is a travel assistant for international visitors to China, providing:

- AI-assisted itinerary planning based on your preferences
- Audio guides for attractions and cities (with background playback and offline download)
- Visa policy detection and eligibility assessment
- Pre-trip checklists and travel reminders
- Practical travel information (emergency contacts, payment guides, transportation tips)
- Genius Bar live customer support
- Common Chinese phrases with pronunciation

The App is available exclusively through the **Apple App Store (non-China region)**.

---

## 3. Eligibility

By using the App, you represent and warrant that:

1. You are at least **18 years of age** (or the age of digital consent in your jurisdiction, whichever is higher); if you are under 18, you must use the App only with the consent and supervision of your parent or guardian
2. If you are using the App on behalf of a company or other entity, you have authority to bind that entity to these Terms
3. Your use of the App complies with all applicable laws and regulations
4. You are not located in a country or region where receipt of this service is prohibited by applicable law

---

## 4. Account Registration and Management

### 4.1 Account Creation

To access certain features, you must create an account. You may register via:

- Sign in with Apple
- Google OAuth
- Email and password

### 4.2 Account Responsibility

You are responsible for:

- Maintaining the confidentiality of your login credentials
- All activities that occur under your account
- Providing accurate, current, and complete information during registration
- Keeping your information updated

You must immediately notify us at **support@yolohappy.app** of any unauthorized use of your account.

### 4.3 Account Deletion

**Deletion path:** App → Profile → Settings → Delete account → Confirmation

**Effective:** **Immediately** upon confirmation — your account and all associated cloud data are permanently deleted and cannot be recovered. See Section 7 of our [Privacy Policy](/privacy-policy) for details.

> Deleting the App from your device does NOT automatically delete your account data — you must use the in-app "Delete account" function. Locally cached data may be cleared via Settings → Clear Cache or by uninstalling the App.

### 4.4 Account Termination

We reserve the right to suspend or terminate your account if:

- You materially breach these Terms
- Your conduct may harm other users, third parties, or our legitimate interests
- We are required to do so by law
- We discontinue the App or a related feature

We will provide reasonable notice before termination, except in emergencies or where otherwise required by law.

---

## 5. Subscriptions and Purchases

### 5.1 In-App Purchases

The App offers the following paid content and services through Apple App Store In-App Purchases (IAP):

| Type | Description |
|------|-------------|
| **Membership Subscriptions** | Annual/quarterly/monthly auto-renewing subscriptions, unlocking premium content and features |
| **Single Attraction Unlock** | Consumable in-app purchase, permanently unlocking paid content for a single attraction (e.g., exclusive audio guide) |

Subscription status is managed via RevenueCat (integration in progress); payment processing is handled by Apple App Store.

### 5.2 Payment and Billing

- All payments are processed through your Apple ID account
- All purchases are subject to Apple's Media Services Terms and Conditions
- **Auto-Renewal:** Subscriptions automatically renew and charge unless canceled at least **24 hours** before the end of the current period
- **Manage/Cancel:** iOS Settings → [Your Name] → Subscriptions → YOLO HAPPY → Cancel Subscription
- We reserve the right to change pricing; you will be notified of price changes in advance. Continued use after a price change takes effect constitutes acceptance

### 5.3 Refunds

Refund requests are handled by Apple under its refund policy. To request a refund:

1. Visit reportaproblem.apple.com
2. Sign in with your Apple ID
3. Select the purchase you wish to refund
4. Follow the on-screen instructions

We also provide an in-app refund request option (Membership Center → Purchase History → Refund Request) as an informational aid. **Apple has the final decision on all refunds.**

### 5.4 Virtual Goods

All content and services purchased through the App are **virtual goods**, which are non-transferable, non-resalable, and have no cash value. Except as provided under Apple's refund policy, all purchases are final and non-refundable.

---

## 6. User Conduct

### 6.1 Prohibited Activities

You agree **NOT** to:

- Use the App for any unlawful purpose or in violation of any applicable laws
- Infringe our or any third party's intellectual property rights
- Upload or transmit viruses, malware, or malicious code
- Attempt unauthorized access to our systems, other users' accounts, or data
- Interfere with or disrupt the App, servers, or networks
- Scrape, crawl, or data-mine the App's content without permission
- Harass, abuse, or harm other users or our support staff
- Impersonate any person or entity
- Use the App to send spam or unsolicited promotional messages
- Resell, sublicense, or commercially exploit the App or its content
- Upload or transmit illegal, pornographic, violent, hateful, or otherwise objectionable content

### 6.2 User Content

When you submit content through the App (e.g., support chat messages, uploaded images), you:

- Retain ownership of your content
- Grant us a worldwide, non-exclusive, royalty-free license to use, reproduce, and process such content solely for the purpose of providing and improving the App
- Represent and warrant that you have the right to submit such content and that it does not infringe any third-party rights

### 6.3 Content Moderation

We employ the following content moderation measures:

| Content Type | Moderation Method |
|-------------|-------------------|
| User avatars | Manual review (CMS backend marks status: pending / approved / rejected) |
| Images uploaded in support chat | Manual review (reviewed via support agent dashboard) |
| Static content (attractions, guides, etc.) | Manual editorial review (CMS-published, not auto-generated UGC) |

We reserve the right (but have no obligation) to:
- Remove or refuse to post any user content that violates these Terms
- Suspend or terminate accounts for violations
- Cooperate with law enforcement investigations as required by law

---

## 7. Intellectual Property

### 7.1 Our Content

All content, features, and functionality of the App, including but not limited to:

- The "YOLO HAPPY" name, logo, and brand identity
- App design, interface, graphics, and layout
- Audio guides, city guides, and cultural content
- Software code, algorithms, and architecture
- Pre-trip checklists and travel tips
- Text, images, and multimedia content published through the CMS

are owned by Yuliu Tech or its licensors and are protected by copyright, trademark, and other intellectual property laws. These Terms grant you no right, title, or interest in our intellectual property.

### 7.2 Trademarks

"YOLO HAPPY" and related marks are trademarks of Chengdu Yuliu Technology Co., Ltd. You may not use our trademarks without our prior written permission.

### 7.3 Limited License

We grant you a **non-exclusive, non-transferable, revocable, limited license** to download, install, and use the App on iOS devices you own or control, solely for personal, non-commercial use, subject to these Terms. This license is conditioned on your continued compliance.

### 7.4 Feedback

If you provide us with suggestions, feedback, or ideas about the App ("**Feedback**"), you agree that we may use such Feedback without compensation or obligation of confidentiality.

---

## 8. AI-Generated Content Disclaimer

### 8.1 AI Functionality

The App uses artificial intelligence (AI) to generate travel itineraries, audio guide scripts, and other content. AI services are provided by Volcengine Ark LLM API (Beijing, China node), processing only **text input** (destinations, dates, preference keywords) — **no photos or images are uploaded for AI analysis**.

### 8.2 Non-AI Alternatives

The App offers a complete non-AI usage path; you may use the App without any AI processing:

- **Guest mode (not logged in):** Itinerary planning uses a local deterministic algorithm — no remote AI
- **AI fallback:** On remote AI failure, the system automatically falls back to local itinerary assembly
- **Assistant offline mode:** Configurable to offline, returning offline help guidance
- **Core features are AI-independent:** Audio guides, visa lookup, checklists, emergency info, payment guides — all functional without AI

### 8.3 Accuracy Disclaimer

**IMPORTANT — PLEASE READ CAREFULLY:**

1. **AI-generated content may contain inaccuracies, be incomplete, or outdated.** We do not guarantee the accuracy, reliability, or completeness of AI-generated content.
2. **AI content is for travel reference only** and does not constitute professional travel advice, legal advice, visa decision-making basis, or official information.
3. **User verification required.** You should independently verify critical information, including but not limited to:
   - Visa policies and entry requirements (consult official government sources)
   - Attraction opening hours and ticket prices
   - Transportation schedules and routes
   - Safety and health advisories
4. **AI labeling:** All AI-generated content in the App is labeled with an "AI-generated" indicator for your awareness.

---

## 9. Visa Information Disclaimer

The App provides a **visa detection** feature that assesses visa eligibility based on your nationality and travel plans. You acknowledge and agree that:

1. **Visa policies may change at any time without notice.** The visa information displayed relies on our periodic data updates and may be delayed.
2. **The App's assessment does not constitute a guarantee.** Only official government authorities can make binding visa determinations.
3. **You are solely responsible** for verifying visa requirements through official channels (embassies, consulates, government websites) before travel.
4. **We are not liable** for any consequences arising from reliance on the App's visa information, including denied entry, flight changes, or other travel disruptions. This disclaimer does not exclude or limit liability where not permitted by applicable law.

---

## 10. Emergency and Safety Information

The App provides emergency contact information (e.g., police, ambulance, embassy contacts). You acknowledge that:

1. The App is **not a substitute** for dialing local emergency numbers directly
2. We do not guarantee emergency contact information is current or available in all regions
3. The App does not send emergency alerts to authorities on your behalf
4. In an emergency, **always immediately dial the local emergency number**

---

## 11. Third-Party Services

The App may contain links to or integrations with third-party websites, applications, and services (e.g., official visa application portals, transportation booking platforms). We do not control, endorse, or assume responsibility for third-party services. Your use of third-party services is at your own risk and subject to their respective terms and privacy policies.

---

## 12. Limitation of Liability

**To the maximum extent permitted by applicable law:**

1. **No Warranty.** The App is provided on an "AS IS" and "AS AVAILABLE" basis, without warranties of any kind, express or implied. To the extent permitted by law, we disclaim all warranties, including implied warranties of merchantability, fitness for a particular purpose, and non-infringement.

2. **No Consequential Damages.** In no event shall Yuliu Tech, its directors, employees, or agents be liable for any indirect, incidental, special, consequential, or punitive damages, including but not limited to:
   - Loss of profits, data, use, or goodwill
   - Travel disruptions, missed flights, or denied entry
   - Any damages arising from use or inability to use the App

   > **Exception for personal injury:** Nothing in these Terms excludes or limits our statutory liability for personal injury caused by our fault, to the extent such liability cannot be excluded or limited under applicable law.

3. **Liability Cap.** Our total liability for any claim arising out of or relating to these Terms or your use of the App shall not exceed the amount you have paid to us through the App in the twelve (12) months preceding the claim. If you have made no paid purchases, our liability cap shall be one thousand Renminbi (¥1,000).

4. **Mandatory Consumer Protections.** Some jurisdictions do not allow the exclusion or limitation of certain warranties or liabilities. In such jurisdictions, the above limitations may not apply to you, and our liability is limited to the maximum extent permitted by law. Nothing in these Terms affects your statutory rights as a consumer that cannot be excluded by agreement.

---

## 13. Indemnification

You agree to indemnify, defend, and hold harmless Yuliu Tech and its directors, employees, agents, and affiliates from and against any third-party claims, liabilities, damages, losses, costs, and expenses (including reasonable attorneys' fees) arising out of:

- Your breach of these Terms
- Your use or misuse of the App
- Your infringement of any third-party rights (including intellectual property and personality rights)
- Your violation of applicable laws or regulations

---

## 14. Governing Law and Dispute Resolution

### 14.1 Governing Law

These Terms are governed by and construed in accordance with the laws of the **People's Republic of China**, without regard to conflict of law principles. Where mandatory consumer protection laws of your jurisdiction provide greater protection, those protections shall apply.

### 14.2 Dispute Resolution

Any dispute arising out of or relating to these Terms shall be resolved as follows:

1. **Negotiation:** You agree to first contact us at **legal@yolohappy.app** and attempt to resolve the dispute informally for at least **30 days**.

2. **Litigation:** If informal resolution fails, either party may submit the dispute to the competent court in **Chengdu Hi-tech Zone, Sichuan Province, P.R. China**, unless mandatory consumer protection laws of your jurisdiction provide otherwise.

### 14.3 Class Action Waiver

**To the maximum extent permitted by law,** you agree that any dispute resolution will be conducted on an individual basis only, and you will not act as a plaintiff or class member in any class, consolidated, or representative proceeding. This provision does not apply in jurisdictions where class action waivers are not permitted by mandatory law.

---

## 15. Termination

### 15.1 By You

You may stop using the App and delete your account at any time. Path: App → Profile → Settings → Delete account → Confirm. Deletion takes effect immediately; account and associated cloud data are permanently deleted and cannot be recovered.

### 15.2 By Us

We may suspend or terminate your account or access to the App if:

- You materially breach these Terms and fail to remedy within a reasonable period
- Your conduct seriously violates applicable law
- We discontinue the App or a related feature
- Necessary to protect our legitimate interests or the safety of others

### 15.3 Effect of Termination

Upon termination:

- Your right to use the App immediately ceases
- We will immediately delete your account and associated cloud data as described in Section 7 of the Privacy Policy
- Provisions of these Terms that by their nature should survive termination (including intellectual property, disclaimers, limitations of liability, indemnification, and dispute resolution) shall continue in effect
- Termination does not relieve you of any payment obligations accrued before termination

---

## 16. Apple App Store Terms

The App is distributed through the Apple App Store. You acknowledge and agree that:

1. These Terms are solely between you and Yuliu Tech, not with Apple
2. Apple has no obligation to provide any maintenance or support services for the App
3. If the App fails to conform to any applicable warranty, you may notify Apple for a refund of the purchase price (if any); to the maximum extent permitted by law, Apple has no other warranty obligation
4. Apple is not responsible for addressing any claims by you or any third party relating to the App or your possession and/or use of the App, including product liability claims, claims the App fails to conform to legal or regulatory requirements, and claims under consumer protection or similar legislation
5. In the event of any third-party claim that the App or your use infringes that third party's intellectual property rights, Apple is not responsible for investigation, defense, settlement, or discharge
6. Apple and Apple's subsidiaries are third-party beneficiaries of these Terms, and upon your acceptance, Apple will have the right (and will be deemed to have accepted the right) to enforce these Terms against you

---

## 17. Export Compliance

The App may be subject to applicable export control laws and regulations. You represent that you are not located in a country or region where receipt of this service is prohibited by applicable law, and are not listed on any prohibited or restricted party list. You agree not to use, export, or re-export the App in violation of any applicable export laws.

---

## 18. Changes to These Terms

We reserve the right to modify these Terms at any time. For material changes, we will notify you by:

- Posting the updated Terms within the App
- Displaying an in-app notice
- Sending a push notification or email (for significant changes affecting your rights)

Your continued use of the App after changes take effect constitutes acceptance. If you disagree, you must stop using the App and delete your account.

---

## 19. General Provisions

### 19.1 Entire Agreement

These Terms, together with our Privacy Policy, constitute the entire agreement between you and Yuliu Tech regarding the App, superseding all prior oral or written communications, proposals, and representations on the subject.

### 19.2 Severability

If any provision of these Terms is found to be invalid or unenforceable by a court of competent jurisdiction, that provision shall be limited or eliminated to the minimum extent necessary and replaced with a valid, enforceable provision that most closely matches the original intent. The remaining provisions shall remain in full force and effect.

### 19.3 No Waiver

Our failure to exercise or enforce any right or provision of these Terms shall not constitute a waiver of such right. Any waiver must be in writing.

### 19.4 Assignment

You may not assign or transfer your rights or obligations under these Terms without our prior written consent. We may assign these Terms in their entirety to an affiliate or in connection with a merger or acquisition of the App-related business, with reasonable notice to you.

### 19.5 Force Majeure

We shall not be liable for any failure or delay in performance due to events beyond our reasonable control, including but not limited to natural disasters, war, terrorism, government acts, changes in laws, internet backbone outages, or third-party infrastructure failures.

---

## 20. Contact Us

| Channel | Detail |
|---------|--------|
| **General / Support** | support@yolohappy.app |
| **Legal Notices** | legal@yolohappy.app |
| **Data Protection** | chengduyuliutech@163.com |
| **Mailing Address** | Chengdu Yuliu Technology Co., Ltd. |
|  | No. 14, 1/F, Building 1, No. 299 Ronghua North Road |
|  | Chengdu Hi-tech Zone, Sichuan Province, 610094, P.R. China |

---

*© 2026 Chengdu Yuliu Technology Co., Ltd. All rights reserved.*  
*YOLO HAPPY is a trademark of Chengdu Yuliu Technology Co., Ltd.*$yolo_legal_terms_of_service_body$,
    updated_at = NOW()
WHERE id = 'global';

-- 3/4 gdpr_compliance_body (19320 chars)
UPDATE app_settings
SET gdpr_compliance_body = $yolo_legal_gdpr_compliance_body$# GDPR Data Privacy Compliance Framework

> **Company:** Chengdu Yuliu Technology Co., Ltd.  
> **Product:** YOLO HAPPY · iOS App (non-China App Store)  
> **Data Controller:** Chengdu Yuliu Technology Co., Ltd.  
> **Document Version:** v2.0  
> **Effective Date:** June 29, 2026  
> **Review Cycle:** Quarterly (or upon material change in processing activities)

---

## 1. Executive Summary

This document establishes the GDPR compliance framework for YOLO HAPPY, an iOS travel assistant app for international visitors to China. Although the data controller (Yuliu Tech) is a China-registered company with no physical presence in the EU, the **GDPR may apply** under Article 3(2) (targeting criterion) when the processing relates to offering goods or services to data subjects in the EU or monitoring their behavior within the EU.

### 1.1 Current Compliance Snapshot

| Dimension | Status | Notes |
|-----------|:------:|-------|
| Legal basis for processing (Art. 6) | ✅ Established | See Section 2 |
| Data subject rights (Arts. 12–23) | ✅ Implemented | In-app + email channels |
| Data breach response (Arts. 33–34) | ✅ Documented | See Section 6 |
| Data Protection Impact Assessment (Art. 35) | ⚠️ In progress | Nationality data, AI content generation, cross-border transfers require assessment |
| Records of Processing Activities (Art. 30) | ✅ Documented | See Section 7; updated with business changes |
| Processor DPAs (Art. 28) | ⚠️ Partially complete | Supabase ✅; Volcengine ⚠️ pending; RevenueCat ⚠️ in integration |
| EU Representative (Art. 27) | ⚠️ Under assessment | Currently eligible for Art. 27(2) exemption; appointment required when thresholds met |
| Data Protection Officer | N/A | Does not meet Art. 37 mandatory appointment threshold |
| Data Protection by Design & Default (Art. 25) | ✅ Implemented | See Section 4 |

---

## 2. Legal Basis for Processing (Art. 6)

| Processing Activity | Personal Data | Legal Basis | Article |
|---------------------|---------------|-------------|:-------:|
| Account creation (Apple/Google/Email sign-in) | Display name, email, auth tokens | **Contract** — necessary for service provision | Art. 6(1)(b) |
| AI-assisted itinerary generation | Destination city, dates, preferences (text) | **Contract** — core service functionality | Art. 6(1)(b) |
| Visa eligibility detection | Nationality, destination, stay duration | **Contract** — core service functionality | Art. 6(1)(b) |
| Audio guide delivery | Content preferences, download status | **Contract** — content delivery | Art. 6(1)(b) |
| In-app purchase processing | Purchase tokens (anonymized via RevenueCat + Apple) | **Contract** — payment processing | Art. 6(1)(b) |
| Genius Bar customer support | Chat messages, uploaded images | **Legitimate interests** — support service, quality improvement | Art. 6(1)(f) |
| Push notifications | Device push token, notification preferences | **Consent** — user actively opts in | Art. 6(1)(a) |
| App stability monitoring | Anonymized crash logs (Apple MetricKit) | **Legitimate interests** — service quality maintenance | Art. 6(1)(f) |

### 2.1 Legitimate Interests Assessment (LIA)

**Activity:** Customer support chat retention  
**Purpose:** User support, service quality improvement, dispute handling  
**Necessity:** Essential for resolving user issues; chat records are fundamental for service improvement and dispute resolution  
**Balancing test:**
- Users proactively initiate support contact with reasonable expectation that messages are recorded to provide service
- Chat records do not contain payment credentials, ID numbers, or other highly sensitive information
- Retention: Immediately deleted upon account deletion (CASCADE)
- Access limited to authorized support personnel only
**Conclusion:** Legitimate interests override user privacy interests; adequate safeguards in place

---

## 3. Data Subject Rights (Arts. 12–23)

| Right | Implementation | Response Time | Channel |
|-------|---------------|:------------:|---------|
| **Right of access** (Art. 15) | View profile in App Settings; request full export | 30 days | In-app or email: chengduyuliutech@163.com |
| **Right to rectification** (Art. 16) | Edit profile in App Settings | Immediate | In-app |
| **Right to erasure** (Art. 17) | Delete account in App Settings — **immediate**; CASCADE deletion | Immediate | In-app or email |
| **Right to restriction** (Art. 18) | Manual processing upon request | 30 days | Email request |
| **Right to data portability** (Art. 20) | JSON/CSV export upon request | 30 days | Email request |
| **Right to object** (Art. 21) | Opt-out of notifications immediately | Immediate | App Settings toggle |
| **Right to withdraw consent** (Art. 7(3)) | Disable in notification settings; does not affect prior lawful processing | Immediate | App/system settings |
| **Automated decision-making** (Art. 22) | No solely automated decisions producing legal or significant effects; AI itinerary is non-binding; non-AI mode available | N/A | N/A |

### 3.1 Identity Verification

Before acting on data subject requests:
1. Match request email with account email
2. Require in-app authentication for requests submitted through the App
3. Request additional verification for sensitive requests when identity cannot be confirmed
4. For third-party agent requests, require written authorization from the data subject

---

## 4. Data Protection by Design and by Default (Art. 25)

### 4.1 Data Minimization

| Principle | Implementation |
|-----------|---------------|
| **Collect only what is necessary** | No biometric data, health data, precise location, or payment credentials collected |
| **No mandatory personalization** | Itinerary generation works without nationality; nationality only required for visa detection |
| **Guest mode** | Browse basic content without login — no personal data collected |
| **AI data isolation** | Only text input sent to AI (destination, dates, preferences) — no name, email, nationality |

### 4.2 Purpose Limitation

- Each data field maps to a specific, explicit, and legitimate purpose (see Section 2)
- No repurposing without user consent or legal basis
- User data **not used** to train AI models; Volcengine contractually prohibited from using customer data for model training

### 4.3 Storage Limitation

| Data Category | Retention | Deletion Trigger |
|--------------|-----------|-----------------|
| Account data | **Immediately** upon deletion | `delete-account` function execution |
| Itinerary data | **Immediately** upon deletion | `ON DELETE CASCADE` |
| Profile data | **Immediately** upon deletion | `ON DELETE CASCADE` |
| Support chat records | **Immediately** upon deletion | `ON DELETE CASCADE` |
| Supabase platform backups | 7–30 days (plan-dependent) | Infrastructure-level auto-expiry |
| Apple IAP records | Per Apple's policy (independent controller) | Managed by Apple |
| Accounting/tax records | Min. 10 years (PRC law) | Separated from personal account data; anonymized |

### 4.4 Security Measures

| Layer | Measures |
|-------|----------|
| **Transmission** | HTTPS/TLS 1.3 for all network communications |
| **Storage** | Supabase AES-256 encryption at rest; Row Level Security (RLS) per-user access |
| **Authentication** | Apple Sign In, Google OAuth, email+password (Supabase Auth managed, rate-limited) |
| **Access Control** | Least privilege principle; role-based access control (RBAC) for admin functions |
| **Monitoring** | Supabase audit logs; Apple MetricKit crash diagnostics (anonymized data) |

---

## 5. Third-Party Processor Management (Art. 28)

### 5.1 Processor Inventory

| Processor | Service | Data Processed | Location | DPA Status |
|-----------|---------|----------------|----------|:----------:|
| **Supabase** | Backend database, auth, file storage, Edge Functions | All user data | US West (us-west-1) | ✅ Covered via Supabase Terms of Service DPA acceptance |
| **Volcengine Ark** (ByteDance) | AI text inference (itinerary, assistant, translation) | User text input (destination, dates, preferences) — no PII | Beijing, China | ⚠️ **Pending** signature; recommend completion before AI launch |
| **RevenueCat** | IAP receipt validation, subscription management | Anonymous user ID, purchase tokens (transaction ID, product ID, expiry) — no PII | United States | ⚠️ **In integration**; DPA coverage to be confirmed |
| **Apple (APNs)** | Push notification delivery | Device push token | Apple global infrastructure | ✅ Covered by Apple Developer Agreement |
| **Cloudflare** | Workers static site hosting (share pages, marketing site, CMS) | Standard access logs (CDN/security purposes only) | Global edge network | ✅ Covered by Cloudflare Terms of Service |

### 5.2 Priority Action Items

| Priority | Item | Recommended Timeline |
|:--------:|------|:--------------------:|
| 🔴 **Critical** | Sign DPA with Volcengine (ByteDance) for AI processing. Must include: prohibition on using customer data for model training, data minimization, output ownership, sub-processor disclosure, breach notification obligations, audit rights | Before AI feature launch |
| 🟡 **High** | Confirm RevenueCat DPA coverage (verify its role and obligations as a data processor) | Before IAP feature launch |
| 🟢 **Medium** | Document specific Cloudflare data processing clause references | Within 30 days of launch |

### 5.3 Standard Contractual Clauses (SCCs)

For transfers to third countries (China, United States):
1. **EU Standard Contractual Clauses (2021/914)** framework incorporated into processor agreements
2. **Transfer Impact Assessment (TIA)** — conducted for transfers to China for AI processing, assessing local law impact
3. **Supplementary technical measures:** TLS 1.3 in transit, AES-256 at rest, contractual processor obligations

---

## 6. Data Breach Response (Arts. 33–34)

### 6.1 Definition

A breach of security leading to accidental or unlawful destruction, loss, alteration, unauthorized disclosure of, or access to personal data.

### 6.2 Response Timeline

```
Discovery (T+0)
  │
  ├── 0–24h: Contain breach, assess scope and affected data
  │
  ├── 24–48h: Determine whether notification obligation is triggered
  │
  ├── Within 72h: Notify supervisory authority (Art. 33)
  │   (if risk to rights and freedoms of data subjects)
  │
  └── Without undue delay: Notify affected data subjects (Art. 34)
      (if high risk to rights and freedoms)
```

### 6.3 Response Team

| Role | Responsibility |
|------|---------------|
| **Data Protection Contact** | Lead breach response, coordinate regulatory and user notifications |
| **Technical Lead** | Identify cause, implement technical containment, deploy remediation |
| **Legal Counsel** | Advise on notification obligations, draft notices, document process |

Breach reporting contact: **chengduyuliutech@163.com**

### 6.4 Documentation Requirements

All personal data breaches (whether notifiable or not) shall be documented, including:
- Date and time of discovery
- Nature, scope, and approximate cause of the breach
- Categories and approximate number of affected data subjects
- Approximate number of affected personal data records
- Likely consequences
- Measures taken or proposed to address the breach
- Reasons for not notifying the supervisory authority (if applicable)

---

## 7. Records of Processing Activities — ROPA (Art. 30)

| # | Activity | Purpose | Legal Basis | Data Categories | Data Subjects | Recipients | Retention | Transfer |
|---|----------|---------|-------------|-----------------|---------------|------------|-----------|----------|
| 1 | Account registration & management | User authentication | Contract (6(1)(b)) | Display name, email, auth tokens | Registered users | Supabase | Immediate on deletion | US (us-west-1) |
| 2 | AI itinerary generation | Travel planning | Contract (6(1)(b)) | Destination, dates, preferences (text) | Itinerary-creating users | Supabase, Volcengine Ark | Immediate on deletion | US, China |
| 3 | Visa eligibility detection | Visa assessment | Contract (6(1)(b)) | Nationality, destination, stay duration | Visa-querying users | Supabase | Immediate on deletion | US |
| 4 | Audio guide delivery | Guide services | Contract (6(1)(b)) | Content preferences, download status | All users | Supabase | Immediate on deletion | US |
| 5 | In-app purchase processing | Payment/subscription | Contract (6(1)(b)) | Purchase tokens (anonymized) | Purchasing users | RevenueCat (in integration), Apple | 7 years (accounting) | US |
| 6 | Genius Bar support | User support | Legitimate interest (6(1)(f)) | Chat messages, images | Support-contacting users | Supabase | Immediate on deletion | US |
| 7 | Push notifications | Trip/checklist reminders | Consent (6(1)(a)) | Device push token | Opted-in users | Apple APNs | Immediate on deletion | Apple global |
| 8 | App stability monitoring | Bug fixes | Legitimate interest (6(1)(f)) | Anonymized crash data | All users | Apple MetricKit (system framework) | Anonymous, no personal link | N/A |

---

## 8. Data Protection Impact Assessment — DPIA (Art. 35)

### 8.1 Activities Requiring DPIA

Per GDPR Art. 35 and WP29 guidelines, the following high-risk processing activities require DPIA:

| # | Activity | High-Risk Factors | Status | Assessment Focus |
|---|----------|------------------|:------:|------------------|
| 1 | Collection of **nationality data** for visa detection | Nationality may reveal ethnic origin (borderline special category); combined with travel plans could infer sensitive info | ⚠️ Pending | Necessity assessment; adequacy of safeguards; risk severity to users |
| 2 | **AI text generation** via third-party processor (cross-border to China) | New technology; AI inaccuracies may impact travel decisions; cross-border to China requires local law assessment | ⚠️ Pending | Transfer Impact Assessment (TIA); AI output quality/bias risks; user redress mechanisms |
| 3 | Processing **international traveler** data (potentially vulnerable group) | Travelers may be vulnerable due to language barriers, unfamiliar environment | ⚠️ Pending | Additional safeguards for vulnerable groups; data use restrictions in emergencies |

### 8.2 Excluded from DPIA

- ~~Automated decision-making via AI~~: AI itineraries are **non-binding recommendations**, produce no legal effects or significant impact, and complete non-AI alternatives exist — not subject to Art. 35(3)(a) mandatory DPIA
- ~~Large-scale special category data processing~~: Nationality used only for visa detection; whether it constitutes special category data is subject to interpretation
- ~~Systematic monitoring of users~~: App does not track location or use behavioral profiling

### 8.3 DPIA Execution Plan

| Priority | DPIA Item | Recommended Owner | Timeline |
|:--------:|-----------|------------------|:--------:|
| 🔴 | Joint DPIA: Cross-border AI processing + nationality data | Legal lead + Technical lead | Before AI feature launch |
| 🟡 | International traveler vulnerability assessment | Legal lead | Within 30 days of launch |

---

## 9. EU Representative (Art. 27)

### 9.1 Legal Requirement

Under GDPR Art. 27, controllers or processors not established in the EU must designate a representative in writing, unless an Art. 27(2) exemption applies.

### 9.2 Exemption Assessment

| Exemption Condition | Current Assessment |
|--------------------|-------------------|
| (a) Processing is **occasional** | ✅ Early stage: product is early-stage with minimal EU user base (non-EU App Store, primarily non-EU travelers to China) |
| (b) Does not include **large-scale** processing of Art. 9(1) special categories | ✅ Nationality data processing is small in scale and frequency; borderline whether it constitutes special category data |
| (c) Does not include Art. 10 criminal conviction data | ✅ Not applicable |
| (d) Unlikely to result in risk to rights and freedoms | ⚠️ Requires scrutiny: AI output inaccuracies may lead to travel decision errors — to be assessed via DPIA |

### 9.3 Phased Recommendation

| Phase | Strategy |
|-------|----------|
| **Current (launch phase, <1,000 EU users)** | Assert Art. 27(2) exemption. Document and archive the exemption assessment |
| **Trigger event (any of the following)** | ① EU users exceed 1,000 (reasonable threshold) ② First EU data protection complaint received ③ DPIA results indicate high risk |
| **Follow-up action** | Appoint EU representative through professional GDPR rep service (e.g., ePrivacy, DataRep, GDPR-Rep.eu). Cost estimate: ~€500–€1,500/year |

---

## 10. Compliance Checklist

### 10.1 Pre-Launch (Critical Path)

| # | Item | Owner | Notes |
|---|------|-------|-------|
| 1 | ✅ English Privacy Policy published (accessible URL) | Legal/Tech | Complete |
| 2 | ✅ In-app data deletion (immediate) | Tech | `delete-account` Edge Function + CASCADE deployed |
| 3 | ✅ HTTPS/TLS 1.3 on all endpoints | Tech | Verified |
| 4 | ✅ Supabase RLS policies configured | Tech | Row-level security deployed |
| 5 | 🔴 Sign DPA with Volcengine for AI processing | Legal | **Must complete before AI launch**; include: training data prohibition, data minimization, sub-processor disclosure, audit rights |
| 6 | 🔴 Confirm RevenueCat DPA coverage | Legal | Before IAP feature launch |
| 7 | ✅ ROPA documented (Section 7 as foundation) | Legal | Complete; update dynamically with business changes |

### 10.2 Post-Launch Priority (30 days)

| # | Item | Owner |
|---|------|-------|
| 8 | Complete joint DPIA: cross-border AI + nationality data | Legal |
| 9 | Train support team on data subject rights handling | Legal/Ops |
| 10 | Establish breach notification contact list with internal drill | Legal/Tech |
| 11 | Complete international traveler vulnerability assessment | Legal |

### 10.3 Ongoing

| # | Item | Frequency |
|---|------|:---------:|
| 12 | Review and update ROPA | Quarterly / on material change |
| 13 | Monitor regulatory developments (GDPR enforcement priorities, ePrivacy Regulation, EDPB guidance) | Quarterly |
| 14 | Audit processor DPA compliance | Annually |
| 15 | Reassess EU representative need (Art. 27 exemption review) | Quarterly |
| 16 | Team data protection awareness training | Annually |

---

## 11. Key Contacts

| Role | Contact |
|------|---------|
| Data Protection Inquiries | chengduyuliutech@163.com |
| User Support | support@yolohappy.app |
| Legal Notices | legal@yolohappy.app |
| Lead Supervisory Authority (potential) | To be determined based on EU user distribution (initially likely Irish DPC or user's local DPA) |
| EU Representative | Not yet appointed (see Section 9 — currently claiming Art. 27(2) exemption) |

---

## 12. Document Control

| Field | Value |
|-------|-------|
| Document ID | GDPR-CF-2026-001 |
| Version | v2.0 |
| Prepared by | Legal & Compliance |
| Approved by | [TBD] |
| Next Review | September 29, 2026 |
| Change Log | v1.0 (2026-06-29) → v2.0 (2026-06-29): Corrected server location (US West), updated processor inventory and DPA statuses, refined DPIA assessment, updated ROPA, corrected data retention periods |

---

*This document is an internal compliance framework and does not constitute legal advice. For specific GDPR compliance obligations and legal determinations, consult a qualified data protection lawyer.*$yolo_legal_gdpr_compliance_body$,
    updated_at = NOW()
WHERE id = 'global';

-- 4/4 ai_content_disclosure_body (18483 chars)
UPDATE app_settings
SET ai_content_disclosure_body = $yolo_legal_ai_content_disclosure_body$# AI Content Generation — Compliance Disclosure

> **Company:** Chengdu Yuliu Technology Co., Ltd.  
> **Product:** YOLO HAPPY · iOS App  
> **Document Type:** AI Transparency & Compliance Disclosure  
> **Version:** v2.0  
> **Date:** June 29, 2026

---

## 1. Purpose

This document serves as the **AI Content Transparency & Compliance Disclosure** for YOLO HAPPY, addressing transparency obligations under the following regulations and platform requirements:

| Regulation/Standard | Applicable Provisions | Scope |
|---------------------|----------------------|-------|
| **Apple App Store Review Guidelines** | 5.1.1 (Privacy), 5.2.1 (Content Licensing) | Explicit disclosure of AI-generated content and content responsibility |
| **GDPR** | Arts. 13–14 (Transparency), Art. 22 (Automated Decision-Making), Art. 35 (DPIA) | AI processing transparency, user right to be informed |
| **PIPL (China)** | Art. 24 (Automated Decision-Making), Art. 7 (Transparency) | Automated decision transparency, user choice |
| **Interim Measures for Generative AI Services** (China, 2023) | Arts. 4, 5, 9, 12, 15 | AI service compliance |
| **Provisions on Deep Synthesis** (China, 2023) | Arts. 16–17 | Deep synthesis content labeling |
| **EU AI Act** (Regulation 2024/1689) | Art. 50 (Transparency Obligations) | AI system transparency |

---

## 2. AI Usage Overview

### 2.1 AI's Role in YOLO HAPPY

The App uses AI as an **assistive tool** to generate travel reference content. AI is not used to make legally binding or high-impact decisions about users.

| Feature | AI Capability | Model/Provider | User Input | AI Output |
|---------|--------------|----------------|------------|-----------|
| **Itinerary Planning** | Natural language generation; multi-day itinerary organization | Volcengine Ark (LLM) | Destination city, dates, preference keywords (text) | Day-by-day itinerary suggestions with activities, timing, tips |
| **Travel Assistant Dialogue** | Text-based conversation | Volcengine Ark (LLM) | User text messages | Travel-related helpful responses |
| **Support Chat Translation** | Text translation | Volcengine Ark (LLM) | Support chat message text | Translated text in target language |

> **Important:** The App does **NOT** upload any user photos or images to the AI service for analysis. AI processing is limited to **text input only**.

### 2.2 What AI Does NOT Do

- ❌ Does not make automated decisions producing legal effects or similarly significant impacts
- ❌ Does not profile users, predict behavior, or assess creditworthiness
- ❌ Does not process biometric data (facial, voiceprint, etc.)
- ❌ Does not generate content impersonating real persons (deepfakes)
- ❌ Does not permit the AI provider to use user data for model training (contractually prohibited)

### 2.3 Non-AI Alternatives

The App is designed as **AI-optional** — the following core features are fully functional without AI:

| Feature | Non-AI Implementation |
|---------|----------------------|
| Itinerary planning (guest mode) | Local deterministic algorithm (`PlanItineraryAssembler`) — no remote AI |
| AI fallback | Auto-fallback to local itinerary assembly on remote AI failure |
| Travel assistant (offline mode) | Configurable to `offline`, returning preset offline help guidance |
| Audio guides | Pre-set + manually edited content, published via CMS |
| Visa detection | Rule engine (`VisaPolicyEngine`), not AI-generated |
| Pre-trip checklist | Deterministic algorithm based on nationality + destination |
| Emergency info | Manually reviewed static data |
| Payment guide | Manually edited static content |

---

## 3. User-Facing Disclosures

### 3.1 App Store Connect — App Description

**Recommended disclosure for app description:**

> This app uses artificial intelligence (AI) to assist in generating travel itineraries and guide content. AI-generated content is for travel reference only and may not always be accurate, complete, or current. Users should independently verify critical information such as visa policies, opening hours, and transportation schedules through official channels. The app provides a complete non-AI usage path — you may choose not to use AI features.

### 3.2 App Store Connect — Privacy Nutrition Labels

| Data Type | Collected? | Linked to Identity? | Used for Tracking? |
|-----------|:----------:|:-------------------:|:------------------:|
| Contact Info (email) | Yes | Yes | No |
| User Content (itinerary input — text) | Yes | Yes | No |
| Identifiers (Device ID) | No | — | No |
| Usage Data | No (no third-party analytics SDKs) | — | No |
| Location | No (no location permission) | — | No |

### 3.3 In-App Disclosures

**Placement 1 — AI itinerary generation trigger:**

When the user initiates AI itinerary generation, display a confirmation dialog:

```
⚠️ AI-Generated Content Notice

This itinerary is generated with AI assistance (Volcengine Ark)
and may contain inaccurate or outdated information. We recommend
independently verifying:

· Visa policies and entry requirements (consult official sources)
· Attraction opening hours and ticket prices
· Transportation schedules and routes

Your itinerary preference text will be sent to our AI service
provider (Beijing, China node) for processing. Your name, email,
and nationality will NOT be sent.

        [I Understand, Generate]    [Cancel]
```

**Placement 2 — Settings → About → AI Transparency:**

```
About AI in YOLO HAPPY

YOLO HAPPY uses artificial intelligence (AI) to assist with:

• Generating personalized travel itineraries
• Providing travel assistant conversational help
• Translating support chat messages

━━━━━━━━━━━━━━━━━━━

📊 AI Provider
Volcengine Ark LLM (ByteDance)
API node: Beijing, China (ark.cn-beijing.volces.com)

🔒 Data Handling
• Only your text input (destinations, dates, preferences)
  is sent to AI
• Personal info (name, email, nationality) is NOT shared
  with the AI provider
• AI provider is contractually prohibited from using your
  data to train its models
• All data is transmitted with TLS 1.3 encryption

📝 Accuracy
AI-generated content is for travel reference only.
Please verify critical information through official channels.
Itinerary suggestions do not constitute visa advice or legal
opinions.

🔄 Non-AI Alternatives
You may use the app without AI at any time:
• Guest mode: local algorithm for itinerary planning
• AI fallback: auto-switch to local mode on remote failure
• All core features (guides, visa lookup, etc.) are
  AI-independent

━━━━━━━━━━━━━━━━━━━

See our Privacy Policy and Terms of Service for details.
```

---

## 4. Regulatory Compliance Matrix

### 4.1 GDPR Compliance

| GDPR Requirement | Implementation | Status |
|------------------|---------------|:------:|
| **Transparency** (Arts. 13–14) | Privacy Policy Section 4; In-app disclosures | ✅ |
| **Automated decisions** (Art. 22) | No solely AI decisions producing legal or significant effects | ✅ N/A |
| **Right to object** (Art. 21) | Users may choose not to use AI; non-AI alternatives available | ✅ |
| **Data minimization** (Art. 5(1)(c)) | Only text input sent to AI; no name, email, nationality | ✅ |
| **Processor agreement** (Art. 28) | Volcengine DPA pending — must be completed before AI launch | ⚠️ Pending |

### 4.2 PIPL Compliance (Art. 24 — Automated Decision-Making)

| PIPL Requirement | Implementation | Status |
|------------------|---------------|:------:|
| **Transparency** (Art. 24(1)) | Privacy Policy Section 4; in-app dialogs; this disclosure | ✅ |
| **Fair and equitable** (Art. 24(2)) | AI itineraries are non-binding; no differential treatment based on profiling | ✅ |
| **Opt-out mechanism** (Art. 24(3)) | Complete non-AI mode (guest, offline, AI fallback) | ✅ |
| **Explanation of significant decisions** (Art. 24(3)) | App's AI decisions produce no legal effects or significant impact | ✅ N/A |

### 4.3 China Generative AI Regulations Compliance

Per the *Interim Measures for the Administration of Generative Artificial Intelligence Services* (effective August 15, 2023):

| Requirement | Article | Implementation | Status |
|-------------|:------:|----------------|:------:|
| **Content labeling** | Art. 12 | All AI-generated content labeled with "AI-generated" indicator | ⚠️ To be implemented (frontend dev) |
| **Training data compliance** | Art. 7 | Model training is Volcengine's responsibility; DPA to require confirmation of lawful training data provenance | ⚠️ To be verified post-DPA |
| **User protection & complaint mechanism** | Arts. 9, 15 | Privacy Policy user rights section; support@yolohappy.app | ✅ |
| **Service agreement with users** | Art. 9 | Terms of Service Section 8 (AI content disclaimers) | ✅ |
| **Provider obligations** | Arts. 4, 5 | Allocation of compliance responsibilities to be clarified in Volcengine DPA | ⚠️ Pending DPA |
| **Content moderation** | Art. 14 | Currently relies on LLM's built-in safety policies + prompt constraints; no independent AI output content filtering deployed | ⚠️ To be assessed |

> **Note on applicability:** Art. 2 of the Interim Measures applies to services that "use generative AI technology to provide services generating text, images, audio, video, or other content to the public within the territory of the PRC." YOLO HAPPY serves international users via the non-China App Store. However, given the company's registration in China and the Volcengine API node in Beijing, there is potential applicability risk. **Independent legal counsel is recommended for a formal applicability analysis.**

### 4.4 Apple App Store Review Guidelines

| Guideline | Requirement | Implementation |
|-----------|-------------|----------------|
| 5.1.1 (iv) | Data minimization, clear disclosure | Dedicated AI section in Privacy Policy; only necessary text sent |
| 5.2.1 | Content licensing and responsibility | AI disclaimers in Terms of Service; user-generated content is not AI-generated |
| 5.2.3 | AI content labeling and transparency | In-app "AI-generated" labels; AI transparency page |
| Privacy Labels | Accurate disclosure | Truthfully completed (see 3.2) |

### 4.5 EU AI Act (Regulation 2024/1689)

| AI Act Requirement | Applicable? | Implementation |
|--------------------|:----------:|----------------|
| **Transparency** (Art. 50) | ✅ Applicable | Disclosures in-app, in Privacy Policy, and in Terms of Service |
| **High-risk classification** | ❌ N/A | Not a critical infrastructure, safety, or biometric AI system |
| **General-purpose AI rules** | ℹ️ Indirect | Volcengine Ark as GPAI provider bears primary compliance responsibility |

---

## 5. AI Output Labeling Standard

### 5.1 Visual Indicators

All AI-generated content in the App shall be labeled:

| Content Type | Label Format | Display Location |
|-------------|-------------|------------------|
| AI-generated itinerary | "🤖 AI-generated" badge on itinerary card | Top of itinerary view |
| AI assistant dialogue | "AI" indicator below message bubble | Below each assistant reply |
| AI-translated content | "AI-translated" label | Support chat translation area |

### 5.2 Technical Implementation

AI-generated content objects shall include metadata:

```swift
struct AIGeneratedContent {
    let content: String            // Generated content
    let contentType: AIContentType // Content type (itinerary/assistant/translation)
    let modelProvider: String      // Model provider ("Volcengine Ark")
    let generatedAt: Date          // Generation timestamp
    let isLabeled: Bool            // Must be true before display
    let userPrompt: String         // Original user prompt summary (text)
}
```

---

## 6. AI Provider Due Diligence — Volcengine Ark

### 6.1 Due Diligence Checklist

| Check Item | Status | Notes |
|------------|:------:|-------|
| DPA signed | ⚠️ **Pending** | Must complete before launch — highest priority compliance item |
| Prohibition on using customer data for model training | ⚠️ To verify | Must be explicitly stated in DPA |
| Data storage/processing location | ✅ Confirmed | Beijing, China (ark.cn-beijing.volces.com) |
| Data transmission encryption | ✅ Implemented | API endpoint HTTPS-only (TLS) |
| Sub-processor disclosure | ⚠️ To verify | Disclosure obligation to be included in DPA |
| Security certifications | ⚠️ To verify | SOC 2, ISO 27001 or equivalent |
| Breach notification commitment | ⚠️ To verify | ≤72-hour notification to be included in DPA |
| Content safety/moderation capabilities | ⚠️ To verify | Ark platform content safety policy details |

### 6.2 Recommended DPA Key Clauses

The DPA with Volcengine should include at minimum:

1. **AI Training Prohibition:** "Processor shall not use Customer input data or outputs derived therefrom to train, improve, or develop its artificial intelligence models, nor authorize any third party to do so. This clause shall survive termination of the Agreement."

2. **Data Minimization:** "Processor shall process only the minimum amount of data necessary to complete the specified AI inference services. Processor shall not retain, cache, or copy Customer data for its own purposes."

3. **Output Ownership:** "All AI-generated outputs obtained by Customer through this service (including itinerary arrangements, text responses, translation results) shall be the sole and exclusive property of Customer. Processor claims no rights to such outputs."

4. **Content Safety:** "Processor shall implement reasonable content moderation and safety mechanisms to prevent the generation or output of content that violates applicable law."

5. **Audit Rights:** "Customer shall have the right (itself or through an independent third-party auditor) to audit Processor's compliance with this Agreement, no more than once per year, upon 30 days' prior written notice."

6. **Liability Allocation:** "Processor shall bear liability for inaccuracies or harmful content in outputs resulting from defects, biases, or security vulnerabilities inherent in the AI model. Customer is responsible for the legal compliance of input data content."

---

## 7. Content Moderation

### 7.1 Current Moderation Status

| Content Type | Moderation Method | Automation Level |
|-------------|------------------|:----------------:|
| User avatars | **Manual review** (CMS backend marks `avatar_status`: pending / approved / rejected) | No automated filtering |
| AI-generated text | **LLM built-in safety policies + prompt constraints** (no independent AI output filtering system) | Relies on model-side safety |
| Static content (attractions, guides) | **Manual editorial** (CMS-reviewed before publish; not auto-generated UGC) | Fully manual |
| Support chat images | **Manual review** (via support agent dashboard; no automated image moderation SDK) | Fully manual |

### 7.2 Recommended Improvements

| Priority | Improvement | Timeline |
|:--------:|------------|:--------:|
| 🟡 | Integrate Volcengine Ark content safety API (if available) for automated filtering of AI outputs | Within 30 days of AI launch |
| 🟢 | Implement in-app "Report Inappropriate Content" button for users to flag problematic AI outputs | Include in product roadmap |
| 🟢 | Regular AI output quality spot-checks (monthly sampling of AI-generated itineraries for accuracy and compliance) | Begin post-launch |

---

## 8. Risk Mitigation

### 8.1 AI Hallucination / Inaccuracy Risks

| Risk Scenario | Mitigation | Status |
|---------------|-----------|:------:|
| AI generates incorrect visa policy info | Visa detection uses independent rule engine (`VisaPolicyEngine`), not AI | ✅ |
| AI generates unrealistic itineraries | Post-generation travel math constraints (travel time, opening hours, geographic distance) | ✅ |
| AI generates culturally insensitive content | Prompt engineering constraints + LLM built-in safety filtering | ⚠️ Independent review needed |
| AI gives dangerous advice in conversation | Assistant prompt includes behavioral boundaries; feedback/reporting mechanism | ⚠️ Reporting mechanism pending |

### 8.2 User Protection Measures

| Measure | Implementation |
|---------|---------------|
| Explicit notice before AI feature use | Confirmation dialog (Section 3.3) |
| Complete non-AI alternatives | Guest mode, offline mode, AI fallback (Section 2.3) |
| AI accuracy disclaimers | Privacy Policy Section 4 + Terms of Service Section 8 |
| AI content labeling | "AI-generated" indicators (Section 5.1) |
| User feedback mechanism | support@yolohappy.app for AI-related complaints |

---

## 9. Internal Governance

### 9.1 Roles & Responsibilities

| Role | Responsibility |
|------|---------------|
| **Product Lead** | Overall AI compliance oversight, AI feature direction and strategy |
| **Technical Lead** | AI interface implementation, content labeling implementation, security deployment |
| **Legal & Compliance Lead** | Regulatory tracking, DPA negotiation and signing, compliance documentation |

### 9.2 Review Cadence

| Activity | Frequency | Owner |
|----------|:---------:|-------|
| AI output quality spot-check (manual) | Monthly | Product/Ops |
| AI provider due diligence review | Annually | Legal |
| Regulatory change monitoring & compliance update | Quarterly | Legal |
| AI-related user complaint review | Per incident | Product/Ops + Legal |

---

## 10. Contact & Escalation

| Issue Type | Contact |
|------------|---------|
| AI content inaccuracy reports | support@yolohappy.app |
| Privacy concerns about AI data use | chengduyuliutech@163.com |
| Legal/compliance inquiries | legal@yolohappy.app |

---

## 11. Document Control

| Field | Value |
|-------|-------|
| Document ID | AI-DISCLOSURE-2026-001 |
| Version | v2.0 |
| Prepared by | Legal & Compliance |
| Approved by | [TBD] |
| Next Review | September 29, 2026 |
| Change Log | v1.0 → v2.0 (2026-06-29): Clarified AI processes text only (no photo uploads), detailed non-AI alternatives, updated content moderation status (truthful description), supplemented China Generative AI Interim Measures compliance matrix, corrected Volcengine due diligence checklist |

---

*This document is an internal compliance disclosure and does not constitute legal advice. AI regulations are evolving rapidly — maintain awareness of GDPR enforcement developments, EU AI Act implementation progress, China generative AI regulatory updates, and Apple Review Guidelines changes. For key legal determinations including the applicability of China's Generative AI Interim Measures, consult a qualified lawyer.*$yolo_legal_ai_content_disclosure_body$,
    updated_at = NOW()
WHERE id = 'global';
