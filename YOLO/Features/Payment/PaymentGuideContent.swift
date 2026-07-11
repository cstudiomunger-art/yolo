import Foundation

// MARK: - Navigation

enum PaymentGuideDestination: Hashable {
    case mobile, cash, prepay, failed, before, phrases, setup, limits
    case article(id: String)
}

// MARK: - Content models

struct PaymentGuideHubAction: Identifiable {
    let id: PaymentGuideDestination
    let number: String
    let title: String
    let keyTag: String?
    let keyTagDim: Bool
    let description: String
}

struct PaymentGuideMiniTile: Identifiable {
    let id: PaymentGuideDestination
    let eyebrow: String
    let title: String
    let subtitle: String
}

struct PaymentGuideStep: Identifiable {
    let id: String
    let number: String
    let title: String
    let note: String?
    let sayChinese: String?
    let sayTranslation: String?
    let failNotes: [PaymentGuideFailNote]?
}

struct PaymentGuideFailNote: Identifiable {
    let id: String
    let trigger: String
    let body: String
}

struct PaymentGuideRow: Identifiable {
    let id: String
    let label: String
    let subtitle: String?
    let badge: PaymentGuideBadgeLevel?
    let amount: String?
}

enum PaymentGuideBadgeLevel: String {
    case high, medium, low, best, ahead, hasFees, avoid, highest

    var label: String {
        switch self {
        case .high: return "High"
        case .medium: return "Medium"
        case .low: return "Low"
        case .best: return "Best"
        case .ahead: return "Ahead"
        case .hasFees: return "Has fees"
        case .avoid: return "Avoid"
        case .highest: return "Highest"
        }
    }

    var isWarning: Bool {
        self == .low || self == .avoid
    }
}

struct PaymentGuidePhrase: Identifiable {
    let id: String
    let labelEn: String
    let chinese: String
    let translation: String
}

struct PaymentGuideChecklistEntry: Identifiable {
    let id: String
    let label: String
}

struct PaymentGuideSegmentOption: Identifiable {
    let id: Int
    let title: String
    let prefLabel: String?
    let steps: [String]
}

enum PaymentGuideCMSArticles {
    static let cashGuides = ["physical_cards", "cash_guide"]
    static let mobileGuides = ["scene_guide"]
    static let prepayGuide = "prepay_online"
    static let limitsGuide = "limits_fees"
    static let hubFAQ = "faq"
}

// MARK: - Static content (English, from prototype HTML)

enum PaymentGuideContent {

    static let hubEyebrow = "Payment Guide"
    static let hubTitle = "Paying in China"
    static let hubIntroBold = "About 90% of payments can be done from your phone."
    static let hubIntroRest = " Set it up before you fly, and once you land you rarely need to switch to anything else."

    static let coreRuleKick = "Core Rule"
    static let coreRuleHeadline = "Never rely on just one way to pay."
    static let coreRuleBody = "Keep a backup ready, and a payment hiccup never turns into a crisis."

    static let threeWaysHeader = "Three Main Ways to Pay"

    static let hubActions: [PaymentGuideHubAction] = [
        PaymentGuideHubAction(
            id: .mobile,
            number: "01",
            title: "Mobile Pay",
            keyTag: "First choice · ~90%",
            keyTagDim: false,
            description: "Alipay + WeChat Pay. Scan to pay almost anywhere — the first thing to set up before you fly."
        ),
        PaymentGuideHubAction(
            id: .cash,
            number: "02",
            title: "Cash + Cards",
            keyTag: "Backup",
            keyTagDim: true,
            description: "Best for street stalls, taxis, and whenever mobile pay fails. Always keep some on you."
        ),
        PaymentGuideHubAction(
            id: .prepay,
            number: "03",
            title: "Prepay Online",
            keyTag: "Best for bookings",
            keyTagDim: true,
            description: "Trains, tickets, hotels, airport pickup — pay ahead on Trip.com / Klook before you arrive."
        ),
    ]

    static let sosTitle = "Payment failed?"
    static let sosBody = "Most cases are solved by working through these 6 steps."
    static let sosLink = "Open troubleshooting →"

    static let miniTiles: [PaymentGuideMiniTile] = [
        PaymentGuideMiniTile(id: .before, eyebrow: "Before You Fly", title: "Pre-Trip", subtitle: "10-minute checklist"),
        PaymentGuideMiniTile(id: .phrases, eyebrow: "Show Merchant", title: "Show the Cashier", subtitle: "Phrases in Chinese"),
    ]

    // MARK: Mobile Pay

    static let mobileLead = "Alipay + WeChat Pay"
    static let mobileSub = "Together they cover almost every situation. Install both — some places accept only one of them."
    static let mobileBrandChips = ["支付宝 Alipay", "微信支付 WeChat Pay"]

    static let mobileBeforeFlySteps: [PaymentGuideStep] = [
        PaymentGuideStep(
            id: "mb1", number: "01",
            title: "Install both apps while still at home.",
            note: "Once you arrive, the App Store / Google Play may not work smoothly.",
            sayChinese: nil, sayTranslation: nil, failNotes: nil
        ),
        PaymentGuideStep(
            id: "mb2", number: "02",
            title: "Add 2 cards from different banks (recommended).",
            note: "Supports Visa, Mastercard, JCB, Discover or Diners, and more. If one card fails, you won't be stuck.",
            sayChinese: nil, sayTranslation: nil, failNotes: nil
        ),
        PaymentGuideStep(
            id: "mb3", number: "03",
            title: "Turn on cross-border payments.",
            note: "Alipay: Me → Settings → International version. It may be off by default.",
            sayChinese: nil, sayTranslation: nil, failNotes: nil
        ),
        PaymentGuideStep(
            id: "mb4", number: "04",
            title: "Run a ¥1 test before you leave.",
            note: "Confirm your issuing bank actually allows the charge.",
            sayChinese: nil, sayTranslation: nil, failNotes: nil
        ),
    ]

    static let mobileHowSegments: [PaymentGuideSegmentOption] = [
        PaymentGuideSegmentOption(
            id: 1,
            title: "Show Your Code",
            prefLabel: "Try this first",
            steps: [
                "Open the app and tap **Pay** in Alipay, or **+ → Money** in WeChat.",
                "Show your payment code to the cashier.",
                "They scan it; enter your payment password if prompted. Done.",
            ]
        ),
        PaymentGuideSegmentOption(
            id: 2,
            title: "Scan Merchant Code",
            prefLabel: nil,
            steps: [
                "Tap **Scan** and scan the merchant's QR code.",
                "Enter the amount, confirm, then enter your payment password.",
                "If a personal QR code won't take your foreign card, ask the merchant to scan **your** code instead.",
            ]
        ),
    ]

    static let mobileCoverageRows: [PaymentGuideRow] = [
        PaymentGuideRow(id: "mc1", label: "Convenience stores & cafés", subtitle: nil, badge: .high, amount: nil),
        PaymentGuideRow(id: "mc2", label: "Restaurants", subtitle: nil, badge: .high, amount: nil),
        PaymentGuideRow(id: "mc3", label: "Taxis & DiDi", subtitle: "DiDi works inside both apps", badge: .high, amount: nil),
        PaymentGuideRow(id: "mc4", label: "Attractions & museums", subtitle: nil, badge: .medium, amount: nil),
        PaymentGuideRow(id: "mc5", label: "Metro & buses", subtitle: "Rules vary by city; some need a transit QR set up first", badge: .medium, amount: nil),
        PaymentGuideRow(id: "mc6", label: "Street stalls & markets", subtitle: "Personal QR codes may not take foreign cards — use cash instead", badge: .medium, amount: nil),
    ]

    static let mobileSetupLink = "Full setup: Alipay & WeChat Pay →"

    // MARK: Cash + Cards

    static let cashLead = "Your Backup Plan"
    static let cashSub = "You may not use them often, but when a stall has only a personal QR code, or the network is shaky, cash is the most reliable."

    static let cashAmountRows: [PaymentGuideRow] = [
        PaymentGuideRow(id: "ca1", label: "Big cities · 3–5 days", subtitle: nil, badge: nil, amount: "¥500–800"),
        PaymentGuideRow(id: "ca2", label: "Multiple cities · 7–14 days", subtitle: nil, badge: nil, amount: "¥1,000–1,500"),
        PaymentGuideRow(id: "ca3", label: "Family / with kids or elders", subtitle: "Split it up — don't keep it all in one place", badge: nil, amount: "¥1,500–3,000"),
        PaymentGuideRow(id: "ca4", label: "Small towns / remote areas", subtitle: nil, badge: nil, amount: "¥2,000+"),
    ]

    static let cashBreakNote = "Break one ¥100 note into **50 + 20 + 10×2 + 5×2**. Small stalls often can't make change for large notes."

    static let cashSourceRows: [PaymentGuideRow] = [
        PaymentGuideRow(id: "cs1", label: "Airport ATM on arrival", subtitle: "Easiest first source of cash; look for the Visa / Mastercard / UnionPay / JCB logos", badge: .best, amount: nil),
        PaymentGuideRow(id: "cs2", label: "Major bank ATMs downtown", subtitle: "Bank of China, ICBC, CCB, ABC, China Merchants Bank", badge: .high, amount: nil),
        PaymentGuideRow(id: "cs3", label: "Airport exchange counter", subtitle: nil, badge: .hasFees, amount: nil),
        PaymentGuideRow(id: "cs4", label: "Private / street exchange", subtitle: nil, badge: .avoid, amount: nil),
    ]

    static let cashCardRows: [PaymentGuideRow] = [
        PaymentGuideRow(id: "cc1", label: "UnionPay 银联", subtitle: "If your home bank offers one, bring it — the widest coverage", badge: .highest, amount: nil),
        PaymentGuideRow(id: "cc2", label: "International hotels, airports, malls", subtitle: nil, badge: .high, amount: nil),
        PaymentGuideRow(id: "cc3", label: "Visa / Mastercard elsewhere", subtitle: "Fine to carry, but never your only method", badge: .medium, amount: nil),
        PaymentGuideRow(id: "cc4", label: "Small eateries, shops, markets", subtitle: nil, badge: .low, amount: nil),
    ]

    static let cashDCCWarning = "If a card terminal asks whether to settle in your home currency, **choose CNY (Chinese yuan)**. Let your own bank do the conversion — the merchant's dynamic currency conversion (DCC) rate is usually worse."

    static let cashLimitsLink = "Limits & fees →"

    // MARK: Prepay

    static let prepayLead = "Pay Before You Arrive"
    static let prepaySub = "These are the things most likely to go wrong at the counter, because they often need a Chinese phone number or ID. Book ahead with a foreign card."

    static let prepayRows: [PaymentGuideRow] = [
        PaymentGuideRow(id: "pp1", label: "Hotels", subtitle: "Trip.com · Booking · Agoda · hotel's own site", badge: .ahead, amount: nil),
        PaymentGuideRow(id: "pp2", label: "High-speed rail", subtitle: "Trip.com · 12306 English version", badge: .ahead, amount: nil),
        PaymentGuideRow(id: "pp3", label: "Attraction tickets", subtitle: "Trip.com · Klook · official English sites", badge: .ahead, amount: nil),
        PaymentGuideRow(id: "pp4", label: "Airport transfers", subtitle: "Trip.com · Klook · licensed travel agencies", badge: .ahead, amount: nil),
        PaymentGuideRow(id: "pp5", label: "eSIM / data", subtitle: "Airalo · Nomad · Trip.com — sort it before you land", badge: .ahead, amount: nil),
    ]

    static let prepayCallout = "If an attraction's own mini-program demands a Chinese phone number or ID, check Trip.com / Klook first — or ask your hotel to book it for you."

    // MARK: Payment Failed

    static let failedLead = "Work Through It in Order"
    static let failedSub = "In most cases the next step fixes it. Stay calm and change only one thing at a time."

    static let failedSteps: [PaymentGuideStep] = [
        PaymentGuideStep(
            id: "f1", number: "01",
            title: "Switch the payment action.",
            note: "Scanning their QR won't take your foreign card? Show your payment code and let them scan you.",
            sayChinese: "请扫我的付款码",
            sayTranslation: "\"Please scan my payment code.\"",
            failNotes: nil
        ),
        PaymentGuideStep(id: "f2", number: "02", title: "Switch apps.", note: "If Alipay fails, try WeChat Pay, and vice versa.", sayChinese: nil, sayTranslation: nil, failNotes: nil),
        PaymentGuideStep(id: "f3", number: "03", title: "Switch cards.", note: "Try a card from another bank or a different network.", sayChinese: nil, sayTranslation: nil, failNotes: nil),
        PaymentGuideStep(id: "f4", number: "04", title: "Lower the amount.", note: "Split a big payment — e.g. ¥1,200 as ¥600 + ¥600.", sayChinese: nil, sayTranslation: nil, failNotes: nil),
        PaymentGuideStep(id: "f5", number: "05", title: "Contact your bank.", note: "Open your bank app to check for a fraud block, and ask them to allow transactions in China.", sayChinese: nil, sayTranslation: nil, failNotes: nil),
        PaymentGuideStep(id: "f6", number: "06", title: "Use cash, or try another shop.", note: "A small stall genuinely may not take foreign cards — that's why you carry cash.", sayChinese: nil, sayTranslation: nil, failNotes: nil),
    ]

    static let failedWarning = "A \"risk / 风险\" warning usually means a new account or a first large payment triggered fraud control. Make a small purchase first, keep the same phone and network, wait a bit, then try again."

    // MARK: Before You Fly

    static let beforeLead = "10-Minute Check"
    static let beforeSub = "Tick these off before you leave home. Handling it now is far easier than scrambling after you land."

    static let checklistItems: [PaymentGuideChecklistEntry] = [
        PaymentGuideChecklistEntry(id: "apps_installed", label: "Alipay and WeChat installed and opening, with a card added to at least one app"),
        PaymentGuideChecklistEntry(id: "overseas_enabled", label: "Card enabled for overseas transactions"),
        PaymentGuideChecklistEntry(id: "bank_saved", label: "Bank app / support hotline saved"),
        PaymentGuideChecklistEntry(id: "cash_ready", label: "¥500 cash ready, or you know where to withdraw"),
        PaymentGuideChecklistEntry(id: "data_setup", label: "Phone set up with China data / eSIM"),
        PaymentGuideChecklistEntry(id: "prepaid", label: "Hotel, trains, key attractions prepaid"),
        PaymentGuideChecklistEntry(id: "passport_match", label: "All bookings match your passport name"),
    ]

    // MARK: Phrases

    static let phrasesLead = "Point to the line you need"
    static let phrasesSub = "Screenshot this page and show the cashier the Chinese line when words fail."

    static let phrases: [PaymentGuidePhrase] = [
        PaymentGuidePhrase(id: "p1", labelEn: "Pay with Alipay", chinese: "可以用支付宝吗？", translation: "Can I pay with Alipay?"),
        PaymentGuidePhrase(id: "p2", labelEn: "Pay with WeChat Pay", chinese: "可以用微信支付吗？", translation: "Can I pay with WeChat Pay?"),
        PaymentGuidePhrase(id: "p3", labelEn: "Ask them to scan you", chinese: "请扫我的付款码。", translation: "Please scan my payment code."),
        PaymentGuidePhrase(id: "p4", labelEn: "Scan them yourself", chinese: "我可以扫你的二维码付款吗？", translation: "Can I scan your QR code to pay?"),
        PaymentGuidePhrase(id: "p5", labelEn: "Pay with cash", chinese: "可以用现金吗？", translation: "Can I pay with cash?"),
        PaymentGuidePhrase(id: "p6", labelEn: "Switch payment method", chinese: "支付失败了，我换一种方式。", translation: "The payment failed. Let me try another way."),
        PaymentGuidePhrase(id: "p7", labelEn: "Split the payment", chinese: "可以分两笔支付吗？", translation: "Can I split it into two payments?"),
    ]

    // MARK: Full Setup

    static let setupLead = "Set Up Alipay & WeChat Pay"
    static let setupSub = "Best done before you fly. You'll need an international phone number that can receive SMS, two bank cards, and your passport."

    static let alipaySetupSteps: [PaymentGuideStep] = [
        PaymentGuideStep(
            id: "a1", number: "01", title: "Register.",
            note: "Pick your country code, enter your phone number, and get the SMS code.",
            sayChinese: nil, sayTranslation: nil,
            failNotes: [
                PaymentGuideFailNote(
                    id: "a1f",
                    trigger: "No code arriving?",
                    body: "Register with **email** instead (\"use email\"), or install Alipay International. Some carriers block international SMS — contact yours to enable it. Wait 10 minutes before resending."
                )
            ]
        ),
        PaymentGuideStep(id: "a2", number: "02", title: "Switch to the international version.", note: "Me → Settings → Switch version.", sayChinese: nil, sayTranslation: nil, failNotes: nil),
        PaymentGuideStep(
            id: "a3", number: "03", title: "Complete identity verification.",
            note: "Enter your name, passport number and expiry, then upload a photo or do a face scan.",
            sayChinese: nil, sayTranslation: nil,
            failNotes: [
                PaymentGuideFailNote(
                    id: "a3f",
                    trigger: "Rejected?",
                    body: "Enter your name **exactly as in the passport machine-readable zone**, watching spaces and middle names. Re-shoot the passport without glare, and don't use a nickname."
                )
            ]
        ),
        PaymentGuideStep(
            id: "a4", number: "04", title: "Add a bank card.",
            note: "Supports Visa, Mastercard, JCB, Discover or Diners, and more — enter the card number, expiry and CVV.",
            sayChinese: nil, sayTranslation: nil,
            failNotes: [
                PaymentGuideFailNote(
                    id: "a4f",
                    trigger: "Declined?",
                    body: "Try another card, or ask your bank to enable overseas online transactions. A debit card sometimes goes through more easily than a credit card."
                )
            ]
        ),
        PaymentGuideStep(
            id: "a5", number: "05", title: "Run a ¥1 test.",
            note: "Open DiDi inside Alipay, create a test ride to a well-known address, pay ¥1 with your card, then cancel and refund.",
            sayChinese: nil, sayTranslation: nil, failNotes: nil
        ),
    ]

    static let wechatSetupSteps: [PaymentGuideStep] = [
        PaymentGuideStep(id: "w1", number: "01", title: "Cards: Visa / Mastercard / JCB only. The phone number registered with your bank must match your WeChat phone number.", note: nil, sayChinese: nil, sayTranslation: nil, failNotes: nil),
        PaymentGuideStep(id: "w2", number: "02", title: "Register with your phone number (or Facebook). A new account may need a friend to scan you, or activation via bank-card verification.", note: nil, sayChinese: nil, sayTranslation: nil, failNotes: nil),
        PaymentGuideStep(id: "w3", number: "03", title: "Verify and add a card: Me → Services → Wallet. Enter passport details, do a face scan, then add a bank card and set a 6-digit payment password.", note: nil, sayChinese: nil, sayTranslation: nil, failNotes: nil),
        PaymentGuideStep(id: "w4", number: "04", title: "Note: foreign cards can only be used to spend — no transfers, no red packets, and the balance can't be withdrawn.", note: nil, sayChinese: nil, sayTranslation: nil, failNotes: nil),
    ]

    // MARK: Limits & Fees

    static let limitsLead = "Numbers Worth Knowing"
    static let limitsSub = "The official allowances for overseas visitors are fairly generous — most limits you actually hit come from your own issuing bank."

    static let limitRows: [PaymentGuideRow] = [
        PaymentGuideRow(id: "l1", label: "Per transaction", subtitle: nil, badge: nil, amount: "up to US$5,000"),
        PaymentGuideRow(id: "l2", label: "Annual total", subtitle: nil, badge: nil, amount: "up to US$50,000"),
    ]

    static let watchForRows: [PaymentGuideRow] = [
        PaymentGuideRow(id: "w1", label: "Issuing bank limits", subtitle: "Per-transaction, daily and overseas-transaction caps", badge: nil, amount: nil),
        PaymentGuideRow(id: "w2", label: "Merchant restrictions", subtitle: "Some QR codes don't take foreign cards at all", badge: nil, amount: nil),
        PaymentGuideRow(id: "w3", label: "Foreign-card service fee", subtitle: "Shown on the checkout page — don't assume it's all free", badge: nil, amount: nil),
        PaymentGuideRow(id: "w4", label: "Exchange rate", subtitle: "Set by the card network / bank at settlement", badge: nil, amount: nil),
    ]

    static let limitsWarning = "For a large bill — a long hotel stay, a chartered car, medical costs — tell your issuing bank in advance and keep a backup card ready."

    // MARK: Screen titles

    static func screenTitle(for destination: PaymentGuideDestination) -> String {
        switch destination {
        case .mobile: return "Mobile Pay"
        case .cash: return "Cash + Cards"
        case .prepay: return "Prepay Online"
        case .failed: return "Payment Failed?"
        case .before: return "Before You Fly"
        case .phrases: return "Show the Cashier"
        case .setup: return "Full Setup"
        case .limits: return "Limits & Fees"
        case .article: return "Guide"
        }
    }
}
