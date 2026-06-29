import Foundation
import Observation
import Supabase

/// Loads payment-helper CMS content from Supabase with cached + bundled fallback.
/// Branching IA lives in views; copy/steps/advice are data-driven.
@Observable
@MainActor
final class PaymentHelperService {

    private(set) var content: PaymentHelperContent = .empty
    private(set) var isLoading = false

    var cardTypes: Set<String> {
        didSet { UserDefaults.standard.set(Array(cardTypes), forKey: Self.cardsKey) }
    }
    var tripKind: TripKind? {
        didSet { UserDefaults.standard.set(tripKind?.rawValue, forKey: Self.tripKey) }
    }
    /// q1 override; nil → fall back to onboarding country.
    var selectedCountryCode: String? {
        didSet {
            if let v = selectedCountryCode {
                UserDefaults.standard.set(v, forKey: Self.countryKey)
            } else {
                UserDefaults.standard.removeObject(forKey: Self.countryKey)
            }
        }
    }

    private static let cacheKey = "yolohappy.cachedPaymentContent.v3"
    private static let cardsKey = "yolohappy.paymentCardTypes.v1"
    private static let tripKey = "yolohappy.paymentTripKind.v1"
    private static let countryKey = "yolohappy.paymentCountryCode.v1"
    private static let checklistKey = "yolohappy.paymentChecklistSelfReport.v1"

    /// User self-reported readiness on the 随身支付卡 screen (spec: 自报 toggles).
    private(set) var checklistSelfReportDone: Set<String> = []

    init() {
        cardTypes = Set(UserDefaults.standard.stringArray(forKey: Self.cardsKey) ?? [])
        tripKind = UserDefaults.standard.string(forKey: Self.tripKey).flatMap(TripKind.init(rawValue:))
        selectedCountryCode = UserDefaults.standard.string(forKey: Self.countryKey)
        checklistSelfReportDone = Set(UserDefaults.standard.stringArray(forKey: Self.checklistKey) ?? [])
    }

    func prefillCountryIfNeeded(fallback: String) {
        guard selectedCountryCode == nil, !fallback.isEmpty else { return }
        let code = fallback.lowercased()
        if countries.contains(where: { $0.countryCode.lowercased() == code }) {
            selectedCountryCode = code
        }
    }

    func toggleChecklistSelfReport(_ id: String) {
        if checklistSelfReportDone.contains(id) { checklistSelfReportDone.remove(id) }
        else { checklistSelfReportDone.insert(id) }
        UserDefaults.standard.set(Array(checklistSelfReportDone), forKey: Self.checklistKey)
    }

    func isChecklistSelfReported(_ id: String) -> Bool {
        checklistSelfReportDone.contains(id)
    }

    // MARK: - Load

    func load() async {
        guard AppConfig.isSupabaseConfigured, !AppConfig.useMock else {
            content = cached() ?? Self.bundledFallback
            return
        }
        isLoading = true
        defer { isLoading = false }
        do {
            let client = SupabaseManager.shared
            async let countries: [PaymentCountry] = client.from("payment_countries").select().eq("is_active", value: true).eq("enabled", value: true).order("opt_order").execute().value
            async let cashRules: [PaymentCashRule] = client.from("payment_cash_rules").select().eq("is_active", value: true).order("opt_order").execute().value
            async let flowSteps: [PaymentFlowStep] = client.from("payment_flow_steps").select().eq("is_active", value: true).order("step_order").execute().value
            async let rescueRungs: [PaymentRescueRung] = client.from("payment_rescue_rungs").select().eq("is_active", value: true).order("rung_order").execute().value
            async let nodeTexts: [PaymentNodeText] = client.from("payment_node_texts").select().eq("is_active", value: true).order("ord").execute().value
            async let phrases: [MerchantPhrase] = client.from("payment_merchant_phrases").select().eq("is_active", value: true).order("sort_order").execute().value
            async let links: [PaymentHelperLink] = client.from("payment_helper_links").select().eq("is_active", value: true).order("sort_order").execute().value
            async let cards: [CardNetwork] = client.from("payment_card_networks").select().eq("is_active", value: true).order("sort_order").execute().value
            async let checklist: [PaymentChecklistItem] = client.from("payment_checklist_items").select().eq("is_active", value: true).order("item_order").execute().value
            async let articles: [PaymentArticle] = client.from("payment_articles").select().eq("is_active", value: true).eq("is_published", value: true).order("display_order").execute().value
            let loaded = try await PaymentHelperContent(
                countries: countries, cashRules: cashRules, flowSteps: flowSteps,
                rescueRungs: rescueRungs, nodeTexts: nodeTexts,
                adviceRules: [], merchantPhrases: phrases, links: links,
                cardNetworks: cards, checklistItems: checklist, articles: articles
            )
            if loaded.countries.isEmpty && loaded.flowSteps.isEmpty && loaded.merchantPhrases.isEmpty {
                content = cached() ?? Self.bundledFallback
            } else {
                content = loaded
                cache(loaded)
            }
        } catch {
            content = cached() ?? Self.bundledFallback
        }
    }

    // MARK: - Resolved content (fallback when empty)

    private var resolved: PaymentHelperContent {
        content.countries.isEmpty && content.flowSteps.isEmpty ? Self.bundledFallback : content
    }

    var countries: [PaymentCountry] {
        resolved.countries.isEmpty ? Self.bundledFallback.countries : resolved.countries
    }

    var cashRules: [PaymentCashRule] {
        resolved.cashRules.isEmpty ? Self.bundledFallback.cashRules : resolved.cashRules
    }

    var cardNetworks: [CardNetwork] {
        resolved.cardNetworks.isEmpty ? Self.bundledFallback.cardNetworks : resolved.cardNetworks
    }

    var checklistItems: [PaymentChecklistItem] {
        resolved.checklistItems.isEmpty ? Self.bundledFallback.checklistItems : resolved.checklistItems
    }

    var merchantPhrases: [MerchantPhrase] {
        resolved.merchantPhrases.isEmpty ? Self.bundledFallback.merchantPhrases : resolved.merchantPhrases
    }

    /// CMS links filtered by lane (`prep` / `china` / `rescue`); empty lane matches all.
    func links(for lane: String? = nil) -> [PaymentHelperLink] {
        let all = content.links.isEmpty ? Self.bundledFallback.links : content.links
        guard let lane else { return all.sorted { ($0.sortOrder ?? 0) < ($1.sortOrder ?? 0) } }
        return all
            .filter { ($0.lane ?? "prep") == lane }
            .sorted { ($0.sortOrder ?? 0) < ($1.sortOrder ?? 0) }
    }

    var rescueRungs: [PaymentRescueRung] {
        let rungs = resolved.rescueRungs.isEmpty ? Self.bundledFallback.rescueRungs : resolved.rescueRungs
        return rungs.sorted { ($0.rungOrder ?? 0) < ($1.rungOrder ?? 0) }
    }

    func rescueRungsForUser() -> [PaymentRescueRung] {
        rescueRungs.filter { rung in
            if rung.applies == "wx_only" { return weChatBindingViable }
            return true
        }
    }

    // MARK: - Node texts & steps

    func nodeTexts(for nodeKey: String) -> [PaymentNodeText] {
        let texts = resolved.nodeTexts.isEmpty ? Self.bundledFallback.nodeTexts : resolved.nodeTexts
        return texts.filter { $0.nodeKey == nodeKey }.sorted { ($0.ord ?? 0) < ($1.ord ?? 0) }
    }

    func text(for nodeKey: String, slot: String) -> PaymentNodeText? {
        nodeTexts(for: nodeKey).first { $0.slot == slot }
    }

    func steps(for nodeKey: String, tool: String? = nil, includeVolatile: Bool = true) -> [PaymentFlowStep] {
        let all = resolved.flowSteps.isEmpty ? Self.bundledFallback.flowSteps : resolved.flowSteps
        return all
            .filter { step in
                guard step.nodeKey == nodeKey else { return false }
                if !includeVolatile && step.isVolatile { return false }
                if let tool, !tool.isEmpty {
                    return (step.tool ?? "") == tool
                }
                return true
            }
            .sorted { ($0.stepOrder ?? 0) < ($1.stepOrder ?? 0) }
    }

    func tools(for nodeKey: String) -> [String] {
        let tools = Set(steps(for: nodeKey).compactMap { step -> String? in
            let t = step.tool ?? ""
            return t.isEmpty ? nil : t
        })
        return ["alipay", "wechat"].filter { tools.contains($0) }
    }

    func articles(for nodeKey: String) -> [PaymentArticle] {
        let pool = content.articles.isEmpty ? Self.bundledFallback.articles : content.articles
        return pool
            .filter { $0.nodeKey == nodeKey }
            .sorted { ($0.displayOrder ?? 0) < ($1.displayOrder ?? 0) }
    }

    // MARK: - Three tailored advices (data-driven)

    func effectiveCountryCode(fallback: String) -> String {
        (selectedCountryCode ?? fallback).uppercased()
    }

    func smsAdvice(countryCode: String) -> PaymentAdviceResult {
        let code = countryCode.lowercased()
        if let c = countries.first(where: { $0.countryCode.lowercased() == code }) {
            let tone = c.smsTone
            let body = c.smsAdviceZh?.isEmpty == false
                ? c.smsAdviceZh!
                : (c.regMethod == "email"
                    ? "你的运营商可能收不到验证码——直接用邮箱注册（Gmail/Outlook）。"
                    : "你所在国家主流运营商可正常接收验证码，按手机号注册即可。")
            return PaymentAdviceResult(tone: tone, bodyZh: body, bodyEn: c.smsAdviceEn)
        }
        return PaymentAdviceResult(tone: "ok", bodyZh: "你所在国家主流运营商可正常接收验证码，按手机号注册即可。", bodyEn: nil)
    }

    func cardAdvice() -> PaymentAdviceResult {
        if !weChatBindingViable {
            let notes = cardNetworks
                .filter { cardTypes.contains($0.id) && !$0.wechatOk }
                .compactMap(\.displayNoteZh)
            let body = notes.first
                ?? "微信只收 Visa/MC/JCB，这趟微信先别绑卡，主用支付宝。"
            return PaymentAdviceResult(tone: "warn", bodyZh: body, bodyEn: nil)
        }
        return PaymentAdviceResult(
            tone: "ok",
            bodyZh: "你的卡支付宝、微信都能绑，建议两个 App 各绑一张不同银行的卡。",
            bodyEn: nil
        )
    }

    func cashAdvice() -> PaymentAdviceResult {
        if let trip = tripKind?.rawValue,
           let rule = cashRules.first(where: { $0.tripType == trip }) {
            let body = rule.amountMdZh?.isEmpty == false
                ? rule.amountMdZh!
                : (rule.noteZh ?? "建议带适量现金兜底。")
            return PaymentAdviceResult(tone: "info", bodyZh: body, bodyEn: rule.amountMdEn)
        }
        return PaymentAdviceResult(
            tone: "info",
            bodyZh: "建议带至少 2 张不同银行的卡（一张信用卡 + 一张借记卡）+ 少量现金兜底。",
            bodyEn: nil
        )
    }

    // MARK: - Readiness

    var weChatBindingViable: Bool {
        cardNetworks.contains { cardTypes.contains($0.id) && $0.wechatOk }
    }

    private func isChecklistSkipped(_ item: PaymentChecklistItem) -> Bool {
        item.condition == "has_wechat" && !weChatBindingViable
    }

    private var applicableChecklistItems: [PaymentChecklistItem] {
        checklistItems.filter { !isChecklistSkipped($0) }
    }

    func checklistItemDone(_ item: PaymentChecklistItem) -> Bool {
        if isChecklistSkipped(item) { return true }
        return isChecklistSelfReported(item.id)
    }

    var readinessPercent: Int {
        let items = applicableChecklistItems
        let total = items.reduce(0) { $0 + $1.weight }
        guard total > 0 else { return 0 }
        let done = items.filter { isChecklistSelfReported($0.id) }.reduce(0) { $0 + $1.weight }
        return Int((Double(done) / Double(total) * 100).rounded())
    }

    // MARK: - Lane paths

    static func prepPath() -> [PaymentNodeKey] {
        [.q1, .q2, .q3, .plan, .install, .register, .bind, .verify, .use, .card]
    }

    static func chinaPath() -> [PaymentNodeKey] {
        [.china, .bind, .verify, .use, .card]
    }

    // MARK: - Cache

    private func cache(_ c: PaymentHelperContent) {
        if let data = try? JSONEncoder().encode(c) {
            UserDefaults.standard.set(data, forKey: Self.cacheKey)
        }
    }

    private func cached() -> PaymentHelperContent? {
        guard let data = UserDefaults.standard.data(forKey: Self.cacheKey),
              let c = try? JSONDecoder().decode(PaymentHelperContent.self, from: data) else { return nil }
        return c
    }

    // MARK: - Bundled fallback (offline / mock)

    static let bundledFallback: PaymentHelperContent = {
        let countries: [PaymentCountry] = [
            PaymentCountry(countryCode: "jp", flagEmoji: "🇯🇵", nameZh: "日本", nameEn: "Japan", smsTone: "info", regMethod: "phone", smsAdviceZh: "短信会延迟 3–8 分钟，别狂点重发（会触发风控）。日韩运营商审核较严。", smsAdviceEn: nil, enabled: true, optOrder: 1),
            PaymentCountry(countryCode: "kr", flagEmoji: "🇰🇷", nameZh: "韩国", nameEn: "South Korea", smsTone: "info", regMethod: "phone", smsAdviceZh: "运营商对国际短信审核较严，首次注册建议关闭垃圾短信过滤。", smsAdviceEn: nil, enabled: true, optOrder: 2),
            PaymentCountry(countryCode: "us", flagEmoji: "🇺🇸", nameZh: "美国", nameEn: "USA", smsTone: "ok", regMethod: "phone", smsAdviceZh: "主流运营商可正常收码；部分预付费卡（Mint 等）需联系客服开通国际短信。", smsAdviceEn: nil, enabled: true, optOrder: 3),
            PaymentCountry(countryCode: "in", flagEmoji: "🇮🇳", nameZh: "印度", nameEn: "India", smsTone: "warn", regMethod: "email", smsAdviceZh: "运营商默认关闭国际短信，大概率收不到验证码——直接用邮箱注册（Gmail/Outlook）。", smsAdviceEn: nil, enabled: true, optOrder: 10),
            PaymentCountry(countryCode: "br", flagEmoji: "🇧🇷", nameZh: "巴西", nameEn: "Brazil", smsTone: "warn", regMethod: "email", smsAdviceZh: "运营商默认关闭国际短信——直接用邮箱注册。", smsAdviceEn: nil, enabled: true, optOrder: 11),
        ]
        let cashRules: [PaymentCashRule] = [
            PaymentCashRule(tripType: "city", labelZh: "大城市为主", labelEn: "Cities mainly", amountMdZh: "带 **500–800 元** 现金兜底，拆成小面额（50/20/10/5）。", amountMdEn: nil, noteZh: nil, noteEn: nil, optOrder: 1),
            PaymentCashRule(tripType: "both", labelZh: "城市 + 乡村都去", labelEn: "Cities + rural", amountMdZh: "城市段靠扫码，进偏远地区前务必备足 **1000–2000 元** 现金。", amountMdEn: nil, noteZh: nil, noteEn: nil, optOrder: 2),
            PaymentCashRule(tripType: "remote", labelZh: "主要去乡村/偏远", labelEn: "Mostly remote", amountMdZh: "带 **2000 元以上** 现金，那里基本只收现金或个人收款码。", amountMdEn: nil, noteZh: nil, noteEn: nil, optOrder: 3),
            PaymentCashRule(tripType: "family", labelZh: "家庭游/带老人小孩", labelEn: "Family trip", amountMdZh: "**1500–3000 元**，分散保管。", amountMdEn: nil, noteZh: nil, noteEn: nil, optOrder: 4),
        ]
        let flowSteps: [PaymentFlowStep] = [
            PaymentFlowStep(id: "install_alipay_1", tool: "alipay", nodeKey: "install", stepOrder: 1, titleZh: "出发前下载支付宝", titleEn: nil, instructionMdZh: "**务必在来中国前下载**（落地后可能上不了 Google Play、收不到验证码）。App Store / Google Play 搜 “Alipay”。", instructionMdEn: nil, screenshotUrl: nil, failReasons: [], stabilityTier: "stable"),
            PaymentFlowStep(id: "install_wechat_1", tool: "wechat", nodeKey: "install", stepOrder: 1, titleZh: "出发前下载微信", titleEn: nil, instructionMdZh: "App Store / Google Play 搜 “WeChat”。注册前**关闭 VPN**。", instructionMdEn: nil, screenshotUrl: nil, failReasons: [], stabilityTier: "stable"),
            PaymentFlowStep(id: "register_alipay_1", tool: "alipay", nodeKey: "register", stepOrder: 1, titleZh: "选择国家、填手机号", titleEn: nil, instructionMdZh: "打开支付宝→注册，先选手机号所在国家，再填手机号。", instructionMdEn: nil, screenshotUrl: nil, failReasons: [PaymentFailReason(reason: "收不到验证码", fix: "改用邮箱注册（Gmail/Outlook）。")], stabilityTier: "stable"),
            PaymentFlowStep(id: "register_wechat_1", tool: "wechat", nodeKey: "register", stepOrder: 1, titleZh: "注册微信", titleEn: nil, instructionMdZh: "用境外手机号注册。**一个手机号只能注册一个微信**。", instructionMdEn: nil, screenshotUrl: nil, failReasons: [], stabilityTier: "stable"),
            PaymentFlowStep(id: "bind_alipay_1", tool: "alipay", nodeKey: "bind", stepOrder: 1, titleZh: "添加银行卡", titleEn: nil, instructionMdZh: "我的→银行卡→添加，选 Visa/Mastercard/JCB 等，输入卡号、有效期、CVV。", instructionMdEn: nil, screenshotUrl: nil, failReasons: [PaymentFailReason(reason: "发卡行拒绝", fix: "联系银行开通中国大陆线上交易；换另一张卡。")], stabilityTier: "stable"),
            PaymentFlowStep(id: "bind_wechat_1", tool: "wechat", nodeKey: "bind", stepOrder: 1, titleZh: "绑定银行卡", titleEn: nil, instructionMdZh: "钱包→银行卡→添加。**仅收 Visa/Mastercard/JCB**；银行预留手机号须与微信号一致。", instructionMdEn: nil, screenshotUrl: nil, failReasons: [], stabilityTier: "stable"),
            PaymentFlowStep(id: "verify_alipay_1", tool: "alipay", nodeKey: "verify", stepOrder: 1, titleZh: "验证通道（安全版）", titleEn: nil, instructionMdZh: "我的→银行卡→管理→**验证卡片**（预授权 1 元、不扣款）。无需做假订单。", instructionMdEn: nil, screenshotUrl: nil, failReasons: [], stabilityTier: "stable"),
            PaymentFlowStep(id: "use_general_1", tool: "", nodeKey: "use", stepOrder: 1, titleZh: "出示付款码给商家扫（优先）", titleEn: nil, instructionMdZh: "打开支付宝/微信→点「Pay / 付款」→把付款码给商家扫→必要时输支付密码确认。", instructionMdEn: nil, screenshotUrl: nil, failReasons: [], stabilityTier: "stable"),
            PaymentFlowStep(id: "use_general_2", tool: "", nodeKey: "use", stepOrder: 2, titleZh: "扫商家的二维码", titleEn: nil, instructionMdZh: "打开 App→「扫一扫」→扫商家收款码→输入金额→确认支付。", instructionMdEn: nil, screenshotUrl: nil, failReasons: [PaymentFailReason(reason: "扫码后无法付款", fix: "改让商家扫你的付款码，或换 App，或用现金。")], stabilityTier: "stable"),
            PaymentFlowStep(id: "trouble_general_1", tool: "", nodeKey: "trouble", stepOrder: 1, titleZh: "发卡行拒绝", titleEn: nil, instructionMdZh: "打开银行 App 确认交易，或联系客服说「需开通中国大陆线上交易」。换另一张卡也行。", instructionMdEn: nil, screenshotUrl: nil, failReasons: [], stabilityTier: "stable"),
            PaymentFlowStep(id: "trouble_general_2", tool: "", nodeKey: "trouble", stepOrder: 2, titleZh: "姓名 / 空格不符", titleEn: nil, instructionMdZh: "严格按护照拼音填，例：护照 **Zhang San** 就别写 **Zhangsan**。", instructionMdEn: nil, screenshotUrl: nil, failReasons: [], stabilityTier: "stable"),
            PaymentFlowStep(id: "trouble_general_3", tool: "", nodeKey: "trouble", stepOrder: 3, titleZh: "3D 验证失败", titleEn: nil, instructionMdZh: "换一张借记卡，或换不同卡组织（Visa↔Mastercard）。", instructionMdEn: nil, screenshotUrl: nil, failReasons: [], stabilityTier: "stable"),
            PaymentFlowStep(id: "china_general_1", tool: "", nodeKey: "china", stepOrder: 1, titleZh: "先有现金兜底", titleEn: nil, instructionMdZh: "落地先确保有现金：机场或市区大型银行 ATM 取 500 元。", instructionMdEn: nil, screenshotUrl: nil, failReasons: [], stabilityTier: "stable"),
            PaymentFlowStep(id: "china_general_2", tool: "", nodeKey: "china", stepOrder: 2, titleZh: "再慢慢绑卡", titleEn: nil, instructionMdZh: "有现金兜底后，再按 注册→绑卡→验证 一步步把支付宝/微信弄好。", instructionMdEn: nil, screenshotUrl: nil, failReasons: [], stabilityTier: "stable"),
        ]
        let rescueRungs: [PaymentRescueRung] = [
            PaymentRescueRung(id: "rescue_1", rungOrder: 1, titleZh: "换个动作", titleEn: "Switch action", subtitleZh: "让商家扫你，而不是你扫商家", subtitleEn: nil, detailMdZh: "打开你自己的 **付款码** 给店员扫。很多失败只因商家是个人收款码、不支持外卡。", detailMdEn: nil, applies: "always"),
            PaymentRescueRung(id: "rescue_2", rungOrder: 2, titleZh: "换个 App", titleEn: "Switch app", subtitleZh: "支付宝 ↔ 微信", subtitleEn: nil, detailMdZh: "支付宝失败试微信；微信失败试支付宝。", detailMdEn: nil, applies: "wx_only"),
            PaymentRescueRung(id: "rescue_3", rungOrder: 3, titleZh: "换张卡 / 拆小额", titleEn: "Switch card", subtitleZh: "另一张不同银行的卡", subtitleEn: nil, detailMdZh: "大额失败可拆两笔（1200 = 600+600），或在 App 里换绑另一张卡。", detailMdEn: nil, applies: "always"),
            PaymentRescueRung(id: "rescue_4", rungOrder: 4, titleZh: "联系发卡银行", titleEn: "Call bank", subtitleZh: "确认有没有被风控拦", subtitleEn: nil, detailMdZh: "打开银行 App 看是否有风控拦截；联系客服说明你正在中国旅行。", detailMdEn: nil, applies: "always"),
            PaymentRescueRung(id: "rescue_5", rungOrder: 5, titleZh: "用现金", titleEn: "Use cash", subtitleZh: "永远的兜底", subtitleEn: nil, detailMdZh: "小商户/夜市/个人码搞不定时现金最现实，每天随身 100–300 元小面额。", detailMdEn: nil, applies: "always"),
        ]
        let nodeTexts: [PaymentNodeText] = [
            PaymentNodeText(id: "home_h1_0", nodeKey: "home", slot: "h1", textZh: "你现在的处境？", textEn: nil, tone: nil, ord: 0),
            PaymentNodeText(id: "home_intro_0", nodeKey: "home", slot: "intro", textZh: "先问你在哪个时刻——最慌的人能一秒拿到帮助。", textEn: nil, tone: nil, ord: 0),
            PaymentNodeText(id: "q1_h1_0", nodeKey: "q1", slot: "h1", textZh: "你从哪个国家来？", textEn: nil, tone: nil, ord: 0),
            PaymentNodeText(id: "q2_h1_0", nodeKey: "q2", slot: "h1", textZh: "你有哪些卡？", textEn: nil, tone: nil, ord: 0),
            PaymentNodeText(id: "q3_h1_0", nodeKey: "q3", slot: "h1", textZh: "这趟主要去哪？", textEn: nil, tone: nil, ord: 0),
            PaymentNodeText(id: "plan_h1_0", nodeKey: "plan", slot: "h1", textZh: "为你一个人裁好的", textEn: nil, tone: nil, ord: 0),
            PaymentNodeText(id: "install_h1_0", nodeKey: "install", slot: "h1", textZh: "装两个主 App", textEn: nil, tone: nil, ord: 0),
            PaymentNodeText(id: "install_callout_0", nodeKey: "install", slot: "callout", textZh: "务必出发前装！到了中国可能上不了 Google Play、收不到验证码。", textEn: nil, tone: "warm", ord: 0),
            PaymentNodeText(id: "register_h1_0", nodeKey: "register", slot: "h1", textZh: "注册并实名", textEn: nil, tone: nil, ord: 0),
            PaymentNodeText(id: "bind_h1_0", nodeKey: "bind", slot: "h1", textZh: "绑定银行卡", textEn: nil, tone: nil, ord: 0),
            PaymentNodeText(id: "verify_h1_0", nodeKey: "verify", slot: "h1", textZh: "验证一下通道", textEn: nil, tone: nil, ord: 0),
            PaymentNodeText(id: "use_h1_0", nodeKey: "use", slot: "h1", textZh: "怎么付款", textEn: nil, tone: nil, ord: 0),
            PaymentNodeText(id: "card_h1_0", nodeKey: "card", slot: "h1", textZh: "你的随身支付卡", textEn: nil, tone: nil, ord: 0),
            PaymentNodeText(id: "china_h1_0", nodeKey: "china", slot: "h1", textZh: "你已经落地了", textEn: nil, tone: nil, ord: 0),
            PaymentNodeText(id: "rescue_h1_0", nodeKey: "rescue", slot: "h1", textZh: "别慌，一步步换", textEn: nil, tone: nil, ord: 0),
            PaymentNodeText(id: "merchant_h1_0", nodeKey: "merchant", slot: "h1", textZh: "给商家看", textEn: nil, tone: nil, ord: 0),
        ]
        let phrases: [MerchantPhrase] = [
            MerchantPhrase(id: "mphrase_1", cn: "可以用支付宝吗？", en: "Can I pay with Alipay?", sortOrder: 0, speakable: true, audioUrl: nil),
            MerchantPhrase(id: "mphrase_2", cn: "可以用微信支付吗？", en: "Can I pay with WeChat Pay?", sortOrder: 1, speakable: true, audioUrl: nil),
            MerchantPhrase(id: "mphrase_3", cn: "请扫我的付款码。", en: "Please scan my payment code.", sortOrder: 2, speakable: true, audioUrl: nil),
            MerchantPhrase(id: "mphrase_4", cn: "支付失败了，我换一种方式。", en: "Payment failed, let me try another way.", sortOrder: 3, speakable: true, audioUrl: nil),
            MerchantPhrase(id: "mphrase_5", cn: "可以用现金吗？", en: "Can I pay with cash?", sortOrder: 4, speakable: true, audioUrl: nil),
        ]
        let cardNetworks: [CardNetwork] = [
            CardNetwork(id: "visa", nameZh: "Visa", nameEn: "Visa", alipayOk: true, wechatOk: true, note: nil, noteZh: nil, noteEn: nil, sortOrder: 0),
            CardNetwork(id: "mc", nameZh: "Mastercard", nameEn: "Mastercard", alipayOk: true, wechatOk: true, note: nil, noteZh: nil, noteEn: nil, sortOrder: 1),
            CardNetwork(id: "jcb", nameZh: "JCB", nameEn: "JCB", alipayOk: true, wechatOk: true, note: nil, noteZh: nil, noteEn: nil, sortOrder: 2),
            CardNetwork(id: "amex", nameZh: "美国运通", nameEn: "American Express", alipayOk: true, wechatOk: false, note: nil, noteZh: "微信不收 Amex，这趟微信先别绑卡，主用支付宝。", noteEn: nil, sortOrder: 3),
            CardNetwork(id: "unionpay", nameZh: "银联", nameEn: "UnionPay", alipayOk: true, wechatOk: false, note: nil, noteZh: "微信不收银联外卡，主用支付宝。", noteEn: nil, sortOrder: 4),
            CardNetwork(id: "diners", nameZh: "大来卡", nameEn: "Diners Club", alipayOk: true, wechatOk: false, note: nil, noteZh: nil, noteEn: nil, sortOrder: 5),
            CardNetwork(id: "discover", nameZh: "发现卡", nameEn: "Discover", alipayOk: true, wechatOk: false, note: nil, noteZh: nil, noteEn: nil, sortOrder: 6),
        ]
        let checklist: [PaymentChecklistItem] = [
            PaymentChecklistItem(id: "alipay_bound", itemOrder: 1, labelZh: "支付宝已绑卡", labelEn: "Alipay card added", weight: 25, condition: nil),
            PaymentChecklistItem(id: "wechat_bound", itemOrder: 2, labelZh: "微信支付已绑卡", labelEn: "WeChat card added", weight: 25, condition: "has_wechat"),
            PaymentChecklistItem(id: "backup_cash", itemOrder: 3, labelZh: "备用卡 + 现金计划", labelEn: "Backup card + cash plan", weight: 25, condition: nil),
            PaymentChecklistItem(id: "verified", itemOrder: 4, labelZh: "通道已 1 元验证", labelEn: "Channel 1-yuan verified", weight: 25, condition: nil),
        ]
        let articles: [PaymentArticle] = [
            PaymentArticle(id: "plan_selfcheck", nodeKey: "plan", titleZh: "出发前 10 分钟自检", titleEn: "Pre-trip check", bodyMdZh: "出发前，请逐条确认：\n\n- 支付宝已安装并能打开。\n- 微信已安装并能正常登录。\n- 两个 App 至少各绑定一张银行卡。\n- 银行卡已开通海外交易。\n- 准备了至少 500 元人民币现金。", bodyMdEn: nil, displayOrder: 0),
            PaymentArticle(id: "plan_cards", nodeKey: "plan", titleZh: "该带哪些实体卡", titleEn: "Physical cards", bodyMdZh: "**主力**：带至少 2 张不同银行的卡，优先 Visa / Mastercard / JCB。", bodyMdEn: nil, displayOrder: 1),
        ]
        return PaymentHelperContent(
            countries: countries, cashRules: cashRules, flowSteps: flowSteps,
            rescueRungs: rescueRungs, nodeTexts: nodeTexts,
            adviceRules: [], merchantPhrases: phrases, links: [],
            cardNetworks: cardNetworks, checklistItems: checklist, articles: articles
        )
    }()
}
