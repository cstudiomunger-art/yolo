import Foundation
import Observation
import Supabase

/// Loads payment-helper content (advice copy / merchant phrases / links) from Supabase
/// with a cached + in-code bundled fallback (mirrors VisaDataService / PurchaseService).
/// The branching flow + pruning logic lives here in the app; only the copy is CMS-driven.
@Observable
@MainActor
final class PaymentHelperService {

    private(set) var content: PaymentHelperContent = .empty
    private(set) var isLoading = false

    // User self-reported answers (persisted locally; country comes from onboarding).
    var cardTypes: Set<CardOrg> {
        didSet {
            UserDefaults.standard.set(cardTypes.map(\.rawValue), forKey: Self.cardsKey)
        }
    }
    var tripKind: TripKind? {
        didSet {
            UserDefaults.standard.set(tripKind?.rawValue, forKey: Self.tripKey)
        }
    }

    private static let cacheKey = "yolohappy.cachedPaymentContent.v1"
    private static let cardsKey = "yolohappy.paymentCardTypes.v1"
    private static let tripKey = "yolohappy.paymentTripKind.v1"

    init() {
        let raw = UserDefaults.standard.stringArray(forKey: Self.cardsKey) ?? []
        cardTypes = Set(raw.compactMap(CardOrg.init(rawValue:)))
        tripKind = UserDefaults.standard.string(forKey: Self.tripKey).flatMap(TripKind.init(rawValue:))
    }

    func load() async {
        guard AppConfig.isSupabaseConfigured, !AppConfig.useMock else {
            content = cached() ?? Self.bundledFallback
            return
        }
        isLoading = true
        defer { isLoading = false }
        do {
            let client = SupabaseManager.shared
            async let rules: [PaymentAdviceRule] = client.from("payment_advice_rules").select().eq("is_active", value: true).order("sort_order").execute().value
            async let phrases: [MerchantPhrase] = client.from("payment_merchant_phrases").select().eq("is_active", value: true).order("sort_order").execute().value
            async let links: [PaymentHelperLink] = client.from("payment_helper_links").select().eq("is_active", value: true).order("sort_order").execute().value
            let loaded = try await PaymentHelperContent(adviceRules: rules, merchantPhrases: phrases, links: links)
            if loaded.adviceRules.isEmpty && loaded.merchantPhrases.isEmpty {
                content = cached() ?? Self.bundledFallback
            } else {
                content = loaded
                cache(loaded)
            }
        } catch {
            content = cached() ?? Self.bundledFallback
        }
    }

    // MARK: - Tailored advice (pruning logic, data-driven copy)

    func advice(for dimension: String, country: String) -> PaymentAdviceRule? {
        let cards = Set(cardTypes.map(\.rawValue))
        let matching = content.adviceRules
            .filter { $0.dimension == dimension && matches($0.matchJson, country: country, cards: cards) }
        // Prefer the most specific match (has any condition) over a catch-all default.
        return matching.sorted {
            specificity($0.matchJson) > specificity($1.matchJson)
        }.first
    }

    private func matches(_ match: PaymentMatch?, country: String, cards: Set<String>) -> Bool {
        guard let match else { return true }
        if let c = match.country, !c.map({ $0.uppercased() }).contains(country.uppercased()) { return false }
        if let ex = match.cardsExclude, !cards.isDisjoint(with: Set(ex)) { return false }
        if let t = match.trip, t != tripKind?.rawValue { return false }
        return true
    }

    private func specificity(_ match: PaymentMatch?) -> Int {
        guard let match else { return 0 }
        var n = 0
        if match.country != nil { n += 1 }
        if match.cardsExclude != nil { n += 1 }
        if match.trip != nil { n += 1 }
        return n
    }

    /// Whether WeChat card-binding is viable (needs Visa/MC/JCB).
    var weChatBindingViable: Bool {
        !cardTypes.isDisjoint(with: [.visa, .mc, .jcb])
    }

    var merchantPhrases: [MerchantPhrase] {
        content.merchantPhrases.isEmpty ? Self.bundledFallback.merchantPhrases : content.merchantPhrases
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

    // MARK: - Bundled fallback (mirrors migration 063 seed)

    static let bundledFallback: PaymentHelperContent = {
        let rules: [PaymentAdviceRule] = [
            PaymentAdviceRule(id: "sms_default", dimension: "sms", matchJson: nil, severity: "ok",
                bodyEn: nil, bodyZh: "你所在国家主流运营商可正常接收验证码，按手机号注册即可。", sortOrder: 0),
            PaymentAdviceRule(id: "sms_in_br", dimension: "sms", matchJson: PaymentMatch(country: ["IN", "BR"], cardsExclude: nil, trip: nil), severity: "warn",
                bodyEn: nil, bodyZh: "你的运营商默认关闭国际短信，大概率收不到验证码——直接用邮箱注册（Gmail/Outlook）。", sortOrder: 1),
            PaymentAdviceRule(id: "card_no_wx", dimension: "card", matchJson: PaymentMatch(country: nil, cardsExclude: ["visa", "mc", "jcb"], trip: nil), severity: "warn",
                bodyEn: nil, bodyZh: "微信只收 Visa/MC/JCB，这趟微信先别绑卡，主用支付宝。", sortOrder: 2),
            PaymentAdviceRule(id: "card_ok", dimension: "card", matchJson: nil, severity: "ok",
                bodyEn: nil, bodyZh: "你的卡支付宝、微信都能绑，建议两个 App 各绑一张不同银行的卡。", sortOrder: 3),
            PaymentAdviceRule(id: "cash_remote", dimension: "cash", matchJson: PaymentMatch(country: nil, cardsExclude: nil, trip: "remote"), severity: "info",
                bodyEn: nil, bodyZh: "主要去乡村/偏远——带 2000 元以上现金，那里基本只收现金或个人收款码。", sortOrder: 4),
            PaymentAdviceRule(id: "cash_city", dimension: "cash", matchJson: PaymentMatch(country: nil, cardsExclude: nil, trip: "city"), severity: "info",
                bodyEn: nil, bodyZh: "主要在大城市——带 500-800 元现金兜底，拆成小面额。", sortOrder: 5),
            PaymentAdviceRule(id: "cash_default", dimension: "cash", matchJson: nil, severity: "info",
                bodyEn: nil, bodyZh: "建议带至少 2 张不同银行的卡（一张信用卡 + 一张借记卡）+ 少量现金兜底。", sortOrder: 6),
        ]
        let phrases: [MerchantPhrase] = [
            MerchantPhrase(id: "scan_me", cn: "请扫我的付款码", en: "Please scan my payment code", sortOrder: 0),
            MerchantPhrase(id: "failed_try", cn: "支付失败了，我换一种方式", en: "Payment failed, let me try another way", sortOrder: 1),
            MerchantPhrase(id: "cash_ok", cn: "可以用现金吗？", en: "Can I pay with cash?", sortOrder: 2),
            MerchantPhrase(id: "split_two", cn: "可以分两笔支付吗？", en: "Can I split it into two payments?", sortOrder: 3),
        ]
        return PaymentHelperContent(adviceRules: rules, merchantPhrases: phrases, links: [])
    }()
}
