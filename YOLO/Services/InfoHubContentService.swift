import Foundation
import Observation
import Supabase

/// Loads Info Hub content (transport tips, common phrases, dialect phrases, internet access guide) from
/// Supabase with cached + in-code bundled fallback (mirrors VisaDataService).
@Observable
@MainActor
final class InfoHubContentService {

    private(set) var content: InfoHubContent = .empty
    private static let cacheKey = "yolohappy.cachedInfoHubContent.v2"

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

    // MARK: - Bundled fallback (mirrors migrations 065 + 097 seed)

    private static let bundledInternetAccessBodyEN = """
    <h2>1. Before You Arrive</h2>
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
    <p><strong>Check phone has a physical SIM slot → Get a Chinese SIM at the airport → Register Chinese-number-required apps right away → Use international roaming for overseas sites → Close accounts before you leave</strong></p>
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
