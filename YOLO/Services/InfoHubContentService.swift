import Foundation
import Observation
import Supabase

/// Loads Info Hub content (transport tips, common phrases, dialect phrases, internet access guide) from
/// Supabase with cached + in-code bundled fallback (mirrors VisaDataService).
@Observable
@MainActor
final class InfoHubContentService {

    private(set) var content: InfoHubContent = .empty
    private static let cacheKey = "yolohappy.cachedInfoHubContent.v3"

    func load() async {
        guard AppConfig.isSupabaseConfigured, !AppConfig.useMock else {
            content = cached() ?? Self.bundledFallback
            return
        }
        do {
            let client = SupabaseManager.shared
            async let transport: [TransportTip] = client.from("transport_tips").select().eq("is_active", value: true).order("sort_order").execute().value
            async let common: [CommonPhrase] = client.from("common_phrases").select().eq("is_active", value: true).order("sort_order").execute().value
            async let dialect: [DialectPhrase] = client.from("dialect_phrases").select().eq("is_active", value: true).order("sort_order").execute().value
            async let internetGuides: [InternetAccessGuide] = client.from("internet_access_guides").select().eq("is_active", value: true).execute().value
            let guides = try await internetGuides
            let internetAccess = guides.first { $0.id == "legal_guide" } ?? guides.first
            let loaded = try await InfoHubContent(
                transport: transport,
                common: common,
                dialect: dialect,
                internetAccess: internetAccess
            )
            if loaded.transport.isEmpty && loaded.common.isEmpty && loaded.dialect.isEmpty && loaded.internetAccess == nil {
                content = cached() ?? Self.bundledFallback
            } else {
                content = loaded
                cache(loaded)
            }
        } catch {
            content = cached() ?? Self.bundledFallback
        }
    }

    private func cache(_ c: InfoHubContent) {
        if let data = try? JSONEncoder().encode(c) { UserDefaults.standard.set(data, forKey: Self.cacheKey) }
    }
    private func cached() -> InfoHubContent? {
        guard let data = UserDefaults.standard.data(forKey: Self.cacheKey),
              let c = try? JSONDecoder().decode(InfoHubContent.self, from: data) else { return nil }
        return c
    }

    // MARK: - Bundled fallback (Markdown stubs; full content from CMS)

    private static let bundledInternetAccessBodyEN = """
    ## Internet Access in China

    **Offline summary** — full guide loads from CMS when online.

    ### Before you arrive

    - Check your phone has a **physical Nano-SIM slot** (many US iPhones do not)
    - Bring passport, international card, and some RMB cash for SIM deposit

    ### Emergency numbers

    - Police **110** · Ambulance **120** · Fire **119**

    ### Bottom line

    Get a Chinese SIM at the airport → register apps that need a local number → use **lawful** roaming or authorized channels for overseas sites. Unauthorized VPN use is illegal in China.
    """

    static let bundledFallback: InfoHubContent = {
        let transport: [TransportTip] = [
            TransportTip(id: "rail_book", category: "rail", titleEn: "High-speed rail tickets", titleZh: "高铁购票",
                bodyEn: nil, bodyZh: "用 Trip.com 或官方 12306 购票；护照即车票证件，安检提前 30 分钟到。", cityId: nil, sortOrder: 0),
            TransportTip(id: "taxi_didi", category: "taxi", titleEn: "Taxi & ride-hailing", titleZh: "打车",
                bodyEn: nil, bodyZh: "滴滴有英文模式，用支付宝/微信付；可让酒店帮你写中文目的地。", cityId: nil, sortOrder: 1),
            TransportTip(id: "metro", category: "metro", titleEn: "Metro", titleZh: "地铁",
                bodyEn: nil, bodyZh: "自助机买单程票（有英文）或扫支付宝/微信地铁码；出站前别丢票/卡。", cityId: nil, sortOrder: 2),
        ]
        let common: [CommonPhrase] = [
            CommonPhrase(id: "hello", cn: "你好", pinyin: "nǐ hǎo", en: "hello", audioUrl: nil, sortOrder: 0),
            CommonPhrase(id: "thanks", cn: "谢谢", pinyin: "xièxie", en: "thanks", audioUrl: nil, sortOrder: 1),
            CommonPhrase(id: "howmuch", cn: "多少钱", pinyin: "duō shǎo qián", en: "how much", audioUrl: nil, sortOrder: 2),
            CommonPhrase(id: "nospicy", cn: "不要辣", pinyin: "bù yào là", en: "no spicy", audioUrl: nil, sortOrder: 3),
            CommonPhrase(id: "toilet", cn: "洗手间在哪", pinyin: "xǐ shǒu jiān zài nǎ", en: "where is the toilet", audioUrl: nil, sortOrder: 4),
        ]
        let dialect: [DialectPhrase] = [
            DialectPhrase(id: "sc_1", dialect: "四川话", emoji: "🌶️", cn: "微微辣", pinyin: "wēi wēi là", en: "a tiny bit spicy", audioUrl: nil, sortOrder: 0),
            DialectPhrase(id: "sc_2", dialect: "四川话", emoji: "⚖️", cn: "多少钱一斤", pinyin: "duō shǎo qián yī jīn", en: "how much per jin?", audioUrl: nil, sortOrder: 1),
            DialectPhrase(id: "sc_3", dialect: "四川话", emoji: "😋", cn: "我能尝一下吗", pinyin: "wǒ néng cháng yī xià ma", en: "can I taste it?", audioUrl: nil, sortOrder: 2),
            DialectPhrase(id: "bj_1", dialect: "北京话", emoji: "🫖", cn: "您喝了吗", pinyin: "nín hē le ma", en: "had your tea yet?", audioUrl: nil, sortOrder: 3),
            DialectPhrase(id: "bj_2", dialect: "北京话", emoji: "👍", cn: "倍儿地道", pinyin: "bèir dì dao", en: "super authentic", audioUrl: nil, sortOrder: 4),
            DialectPhrase(id: "sx_1", dialect: "陕西话", emoji: "🍜", cn: "油泼面美得很", pinyin: "yóu pō miàn měi de hěn", en: "this noodle is awesome", audioUrl: nil, sortOrder: 5),
            DialectPhrase(id: "sx_2", dialect: "陕西话", emoji: "🥘", cn: "再来一碗", pinyin: "zài lái yī wǎn", en: "another bowl please", audioUrl: nil, sortOrder: 6),
        ]
        let internetAccess = InternetAccessGuide(
            id: "legal_guide",
            titleZh: "科学上网指南",
            titleEn: "Legal Internet Access in China",
            bodyZh: "",
            bodyEn: bundledInternetAccessBodyEN
        )
        return InfoHubContent(transport: transport, common: common, dialect: dialect, internetAccess: internetAccess)
    }()
}
