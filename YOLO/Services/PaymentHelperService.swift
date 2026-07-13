import Foundation
import Observation
import Supabase

/// Loads payment guide content from Supabase CMS; falls back to bundled static copy.
@Observable
@MainActor
final class PaymentHelperService {

    private(set) var content: PaymentHelperContent = .empty
    private(set) var isLoading = false

    private static let cacheKey = "yolohappy.cachedPaymentContent.v3"
    private static let checklistKey = "yolohappy.paymentGuideChecklist.v1"

    private(set) var checklistDone: Set<String> = []

    init() {
        checklistDone = Set(UserDefaults.standard.stringArray(forKey: Self.checklistKey) ?? [])
    }

    func toggleChecklist(_ id: String) {
        if checklistDone.contains(id) { checklistDone.remove(id) }
        else { checklistDone.insert(id) }
        UserDefaults.standard.set(Array(checklistDone), forKey: Self.checklistKey)
    }

    func isChecklistDone(_ id: String) -> Bool {
        checklistDone.contains(id)
    }

    var checklistDoneCount: Int {
        checklistEntries.filter { isChecklistDone($0.id) }.count
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
            async let phrases: [MerchantPhrase] = client
                .from("payment_merchant_phrases")
                .select()
                .eq("is_active", value: true)
                .order("sort_order")
                .execute()
                .value
            async let flowSteps: [PaymentFlowStep] = client
                .from("payment_flow_steps")
                .select()
                .eq("is_active", value: true)
                .order("step_order")
                .execute()
                .value
            async let cashRules: [PaymentCashRule] = client
                .from("payment_cash_rules")
                .select()
                .eq("is_active", value: true)
                .order("opt_order")
                .execute()
                .value
            async let rescueRungs: [PaymentRescueRung] = client
                .from("payment_rescue_rungs")
                .select()
                .eq("is_active", value: true)
                .order("rung_order")
                .execute()
                .value
            async let articles: [PaymentArticle] = client
                .from("payment_articles")
                .select()
                .eq("is_active", value: true)
                .eq("is_published", value: true)
                .order("display_order")
                .execute()
                .value
            async let nodeTexts: [PaymentNodeText] = client
                .from("payment_node_texts")
                .select()
                .eq("is_active", value: true)
                .order("ord")
                .execute()
                .value
            async let checklistItems: [PaymentChecklistItem] = client
                .from("payment_checklist_items")
                .select()
                .eq("is_active", value: true)
                .order("item_order")
                .execute()
                .value
            async let countries: [PaymentCountry] = client
                .from("payment_countries")
                .select()
                .eq("is_active", value: true)
                .order("opt_order")
                .execute()
                .value
            async let cardNetworks: [PaymentCardNetwork] = client
                .from("payment_card_networks")
                .select()
                .eq("is_active", value: true)
                .order("sort_order")
                .execute()
                .value
            async let helperLinks: [PaymentHelperLink] = client
                .from("payment_helper_links")
                .select()
                .eq("is_active", value: true)
                .order("sort_order")
                .execute()
                .value

            let loaded = PaymentHelperContent(
                merchantPhrases: try await phrases,
                flowSteps: try await flowSteps,
                cashRules: try await cashRules,
                rescueRungs: try await rescueRungs,
                articles: try await articles,
                nodeTexts: try await nodeTexts,
                checklistItems: try await checklistItems,
                countries: try await countries,
                cardNetworks: try await cardNetworks,
                helperLinks: try await helperLinks
            )
            if loaded == .empty {
                content = cached() ?? Self.bundledFallback
            } else {
                content = loaded
                cache(loaded)
            }
        } catch {
            content = cached() ?? Self.bundledFallback
        }
    }

    // MARK: - CMS accessors (with static fallback)

    func nodeText(nodeKey: String, slot: String, fallback: String) -> String {
        PaymentGuideCMSMapper.nodeText(content.nodeTexts, nodeKey: nodeKey, slot: slot) ?? fallback
    }

    func nodeCallouts(nodeKey: String) -> [String] {
        PaymentGuideCMSMapper.nodeCallouts(content.nodeTexts, nodeKey: nodeKey)
    }

    var mobileBeforeFlySteps: [PaymentGuideStep] {
        let cms = PaymentGuideCMSMapper.installBeforeFlySteps(content.flowSteps)
        return cms.isEmpty ? PaymentGuideContent.mobileBeforeFlySteps : cms
    }

    var mobileHowSegments: [PaymentGuideSegmentOption] {
        let cms = PaymentGuideCMSMapper.mobileHowSegments(content.flowSteps)
        return cms.isEmpty ? PaymentGuideContent.mobileHowSegments : cms
    }

    var alipaySetupSteps: [PaymentGuideStep] {
        let cms = PaymentGuideCMSMapper.setupSteps(content.flowSteps, tool: "alipay")
        return cms.isEmpty ? PaymentGuideContent.alipaySetupSteps : cms
    }

    var wechatSetupSteps: [PaymentGuideStep] {
        let cms = PaymentGuideCMSMapper.setupSteps(content.flowSteps, tool: "wechat")
        return cms.isEmpty ? PaymentGuideContent.wechatSetupSteps : cms
    }

    var failedSteps: [PaymentGuideStep] {
        let cms = PaymentGuideCMSMapper.rescueSteps(content.rescueRungs)
        return cms.isEmpty ? PaymentGuideContent.failedSteps : cms
    }

    var cashAmountRows: [PaymentGuideRow] {
        let cms = PaymentGuideCMSMapper.cashAmountRows(content.cashRules)
        return cms.isEmpty ? PaymentGuideContent.cashAmountRows : cms
    }

    var cashCardRows: [PaymentGuideRow] {
        let cms = PaymentGuideCMSMapper.cardNetworkRows(content.cardNetworks)
        return cms.isEmpty ? PaymentGuideContent.cashCardRows : cms
    }

    var chinaSteps: [PaymentGuideStep] {
        let cms = PaymentGuideCMSMapper.toGuideSteps(
            PaymentGuideCMSMapper.flowSteps(content.flowSteps, nodeKey: "china")
        )
        return cms
    }

    var checklistEntries: [PaymentGuideChecklistEntry] {
        let cms = PaymentGuideCMSMapper.checklistEntries(content.checklistItems)
        return cms.isEmpty ? PaymentGuideContent.checklistItems : cms
    }

    func articles(nodeKey: String) -> [PaymentArticle] {
        PaymentGuideCMSMapper.articles(content.articles, nodeKey: nodeKey)
    }

    func articles(ids: [String]) -> [PaymentArticle] {
        let order = Dictionary(uniqueKeysWithValues: ids.enumerated().map { ($1, $0) })
        return content.articles
            .filter { ids.contains($0.id) && ($0.isPublished ?? true) }
            .sorted { (order[$0.id] ?? 0) < (order[$1.id] ?? 0) }
    }

    func articleBody(id: String) -> String? {
        guard let article = content.articles.first(where: { $0.id == id }) else { return nil }
        let body = PaymentGuideCMSMapper.articleBody(article)
        return body.isEmpty ? nil : body
    }

    func helperLinks(lane: String) -> [PaymentHelperLink] {
        PaymentGuideCMSMapper.helperLinks(content.helperLinks, lane: lane)
    }

    func article(id: String) -> PaymentArticle? {
        content.articles.first { $0.id == id }
    }

    var merchantPhrases: [MerchantPhrase] {
        let phrases = content.merchantPhrases.isEmpty ? Self.bundledFallback.merchantPhrases : content.merchantPhrases
        return phrases.sorted { ($0.sortOrder ?? 0) < ($1.sortOrder ?? 0) }
    }

    var displayPhrases: [PaymentGuidePhrase] {
        let cms = merchantPhrases
        guard !cms.isEmpty else { return PaymentGuideContent.phrases }
        return cms.map { phrase in
            PaymentGuidePhrase(
                id: phrase.id,
                labelEn: phrase.en ?? "",
                chinese: phrase.cn,
                translation: phrase.en ?? ""
            )
        }
    }

    func audioURL(for phraseID: String) -> URL? {
        guard let phrase = merchantPhrases.first(where: { $0.id == phraseID }),
              let urlStr = phrase.audioUrl,
              !urlStr.isEmpty else { return nil }
        return MediaURLResolver.audioURL(from: urlStr) ?? URL(string: urlStr)
    }

    // MARK: - Cache

    private func cache(_ c: PaymentHelperContent) {
        if let data = try? JSONCoding.makeEncoder().encode(c) {
            UserDefaults.standard.set(data, forKey: Self.cacheKey)
        }
    }

    private func cached() -> PaymentHelperContent? {
        guard let data = UserDefaults.standard.data(forKey: Self.cacheKey),
              let c = try? JSONCoding.makeDecoder().decode(PaymentHelperContent.self, from: data) else { return nil }
        return c
    }

    static let bundledFallback: PaymentHelperContent = {
        let phrases: [MerchantPhrase] = PaymentGuideContent.phrases.map { p in
            MerchantPhrase(id: p.id, cn: p.chinese, en: p.translation, sortOrder: nil, speakable: true, audioUrl: nil)
        }
        return PaymentHelperContent(
            merchantPhrases: phrases,
            flowSteps: [],
            cashRules: [],
            rescueRungs: [],
            articles: [],
            nodeTexts: [],
            checklistItems: [],
            countries: [],
            cardNetworks: [],
            helperLinks: []
        )
    }()
}
