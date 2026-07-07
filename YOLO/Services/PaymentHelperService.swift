import Foundation
import Observation
import Supabase

/// Loads optional merchant phrases from CMS; guide copy is static in PaymentGuideContent.
@Observable
@MainActor
final class PaymentHelperService {

    private(set) var content: PaymentHelperContent = .empty
    private(set) var isLoading = false

    private static let cacheKey = "yolohappy.cachedPaymentPhrases.v1"
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
        PaymentGuideContent.checklistItems.filter { isChecklistDone($0.id) }.count
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
            let phrases: [MerchantPhrase] = try await client
                .from("payment_merchant_phrases")
                .select()
                .eq("is_active", value: true)
                .order("sort_order")
                .execute()
                .value
            if phrases.isEmpty {
                content = cached() ?? Self.bundledFallback
            } else {
                content = PaymentHelperContent(merchantPhrases: phrases)
                cache(content)
            }
        } catch {
            content = cached() ?? Self.bundledFallback
        }
    }

    var merchantPhrases: [MerchantPhrase] {
        let phrases = content.merchantPhrases.isEmpty ? Self.bundledFallback.merchantPhrases : content.merchantPhrases
        return phrases.sorted { ($0.sortOrder ?? 0) < ($1.sortOrder ?? 0) }
    }

    /// CMS phrases when available; otherwise static guide phrases.
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
        return URL(string: urlStr)
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

    static let bundledFallback: PaymentHelperContent = {
        let phrases: [MerchantPhrase] = PaymentGuideContent.phrases.map { p in
            MerchantPhrase(id: p.id, cn: p.chinese, en: p.translation, sortOrder: nil, speakable: true, audioUrl: nil)
        }
        return PaymentHelperContent(merchantPhrases: phrases)
    }()
}
