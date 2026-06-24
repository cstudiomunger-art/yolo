import Foundation

/// Phase 2 route recommendation (delivery doc 02): the engine is the judge, the route
/// layer is the question-setter. We don't re-derive visa logic — we GENERATE candidate
/// routes (add a transit hub / drop blockers) and re-run `VisaPolicyEngine.recommend`
/// on each, keeping only engine-verified green ones. Ranking: 加城 > 删城 > 办签.
///
/// City lists are app content-city ids (slugs) because they write back to
/// `selectedCityIds`; engine works in GB/T 2260 codes, mapped via the data set.
struct VisaRoute: Identifiable {
    enum Kind { case interest, applyVisa, friendly }
    let id = UUID()
    let kind: Kind
    let title: String
    let badge: String
    let badgeTone: Tone
    let cities: [String]       // app content-city ids (display/write-back order)
    let addedCity: String?     // advisory transit-exit city (display name) for the friendly route
    /// Content-city slug for `addedCity` (e.g. "hongkong"). When this city exists in the content
    /// catalog, adopting the route folds it into the itinerary as a real stop; until then the
    /// add stays advisory (display-only). Forward-compatible: no-op while the slug is absent.
    var addedCitySlug: String? = nil
    let note: String

    enum Tone { case warn, neutral, ok }
}

enum VisaTripChecker {

    /// HK/MO are valid third-place transit exits that can activate 240h transit visa-free.
    /// `short` = display short name; `landPort` = the bordering mainland city to cross by land.
    private static let transitHubs: [(code: String, name: String, short: String, landPort: String, slug: String)] = [
        ("HK", "香港 Hong Kong", "香港", "深圳", "hongkong"),
        ("MO", "澳门 Macao", "澳门", "珠海", "macao"),
    ]

    /// `query` carries the exact engine inputs used for the base verdict; we clone it with
    /// candidate tweaks and re-run the engine to verify each route actually goes green.
    /// 换城 is NOT here — it's interactive (`swapPlan`), so the user picks the replacement
    /// from a city list rather than us auto-choosing the most popular one.
    static func routes(query: VisaQuery, appCities: [String], data: VisaDataSet,
                       recommendation rec: VisaRecommendation) -> [VisaRoute] {
        guard !rec.isEnough else { return [] }

        var result: [VisaRoute] = []

        // R1 纯兴趣 — original cities, pay with an L visa (cost from the base verdict).
        result.append(VisaRoute(
            kind: .interest,
            title: "✦ 纯兴趣 · 你最初选的",
            badge: "需办 L 签", badgeTone: .warn,
            cities: appCities, addedCity: nil,
            note: "保持原行程，默认需办 L 旅游签证。"))

        // R3 签证友好 — engine-verified least change. Show a card per working transit hub
        // (港 + 澳, both verified green); fall back to 删城 only when no transit works.
        let transit = activateTransit(query: query, appCities: appCities, data: data)
        if !transit.isEmpty {
            result.append(contentsOf: transit)
        } else if let drop = dropBlockers(query: query, appCities: appCities, data: data, rec: rec) {
            result.append(drop)
        }

        // R2 备选 — cities unchanged, apply an L visa (engine plan B).
        result.append(VisaRoute(
            kind: .applyVisa,
            title: "◇ 备选 · 一城不动",
            badge: "办 L 签", badgeTone: .neutral,
            cities: appCities, addedCity: nil,
            note: "行程一城不动，办一张 L 旅游签证（约 4–7 个工作日 + 签证费）。"))

        return result
    }

    // MARK: - 换城 (interactive)：list qualifying replacement cities, the user chooses

    /// An engine-verified replacement pool for a not-enough trip's blocker cities. Each
    /// candidate is green as a solo stand-in (under the same coarse query); the user's final
    /// combined pick is re-verified with `verifySwap` at confirm time (engine is the judge).
    struct SwapPlan {
        let blockerSlugs: [String]   // app slugs being removed
        let blockerNames: String     // display, e.g. "运城市 · 大同市"
        let keptSlugs: [String]      // retained non-blocker cities (app slugs)
        let need: Int                // how many replacements the user must choose
        let candidates: [Candidate]  // qualifying replacements, ranked by popularity
        struct Candidate: Identifiable, Hashable { let id: String; let slug: String; let name: String; let popularity: Int }
    }

    /// Builds the replacement pool, or nil if there's nothing to offer (no blockers, no
    /// catalog, or fewer green candidates than blockers). `catalog` = full content-city pool.
    static func swapPlan(query: VisaQuery, appCities: [String],
                         catalog: [(slug: String, popularity: Int)],
                         data: VisaDataSet, rec: VisaRecommendation) -> SwapPlan? {
        guard !rec.blockers.isEmpty, !catalog.isEmpty else { return nil }
        let blockerSlugSet = Set(rec.blockers.compactMap { data.city(forAdminCode: $0)?.appCitySlug?.lowercased() })
        let keptSlugs = appCities.filter { !blockerSlugSet.contains($0.lowercased()) }
        let blockerSlugs = appCities.filter { blockerSlugSet.contains($0.lowercased()) }
        let need = appCities.count - keptSlugs.count
        guard need > 0 else { return nil }

        let inTrip = Set(appCities.map { $0.lowercased() })
        let candidates: [SwapPlan.Candidate] = catalog
            .filter { !inTrip.contains($0.slug.lowercased()) }
            .sorted { $0.popularity > $1.popularity }
            .compactMap { item in
                guard let code = data.adminCode(forAppSlug: item.slug) else { return nil }
                let r = VisaPolicyEngine.recommend(query.with(cities: [code]), data: data)
                guard r.level == .green else { return nil }
                return SwapPlan.Candidate(id: item.slug, slug: item.slug,
                                          name: data.cityName(forAdminCode: code), popularity: item.popularity)
            }
        guard candidates.count >= need else { return nil }

        let blockerNames = rec.blockers.map { data.cityName(forAdminCode: $0) }.joined(separator: " · ")
        return SwapPlan(blockerSlugs: blockerSlugs, blockerNames: blockerNames,
                        keptSlugs: keptSlugs, need: need, candidates: candidates)
    }

    /// Re-verify the user's chosen replacements actually go green together with the kept
    /// cities. The combination — not just each city solo — must pass (engine is the judge).
    static func verifySwap(query: VisaQuery, keptSlugs: [String], picks: [String], data: VisaDataSet) -> Bool {
        let codes = (keptSlugs + picks).compactMap { data.adminCode(forAppSlug: $0) }
        guard codes.count == keptSlugs.count + picks.count else { return false }
        return VisaPolicyEngine.recommend(query.with(cities: codes), data: data).level == .green
    }

    // MARK: - ① 加城：add a HK/MO transit exit to activate 240h (engine-verified)

    /// Route-layer's headline move (doc §4②): the engine never adds cities itself, so we
    /// propose adding HK/MO as the onward leg and let the engine VERIFY each goes green via
    /// twov_240h. Returns a card PER working hub (港 + 澳), copy/stay-limit derived from the
    /// matched policy so it stays in sync with the CMS.
    private static func activateTransit(query: VisaQuery, appCities: [String], data: VisaDataSet) -> [VisaRoute] {
        var out: [VisaRoute] = []
        for hub in transitHubs {
            let q2 = query.with(onward: hub.code, ticketed: true)
            let r = VisaPolicyEngine.recommend(q2, data: data)
            guard r.level == .green, r.chosenPolicyId == "twov_240h" else { continue }

            let policy = data.policies.first { $0.id == r.chosenPolicyId }
            let policyName = policy?.officialNameZh ?? "过境免签"
            let stayLimit = stayLimitText(policy)   // e.g. "≤ 10 天"

            out.append(VisaRoute(
                kind: .friendly,
                title: "✓ 签证友好 · 加\(hub.short)过境",
                badge: "全程免签 · 多一城", badgeTone: .ok,
                cities: appCities, addedCity: hub.name, addedCitySlug: hub.slug,
                note: """
                根据你的情况：把\(hub.short)加成途经/最后一站，内地段即符合\(policyName)（全程免签、白赚一座城）。
                • 想去\(hub.short)：可经\(hub.landPort)口岸陆路出境，或订一张飞\(hub.short)的机票。
                • 想去任意第三国（只要不是你的出发国）：同样免签——请重建行程，把第三国设为「下一程 / 返回国」。
                ⚠️ 需停留\(stayLimit)、从开放口岸进出、出示离境机票。
                """))
        }
        return out
    }

    /// Stay-limit phrase from the matched policy (hours → "≤ N 天", days → "≤ N 天"). Keeps the
    /// transit card's "≤ 10 天" honest if the CMS ever changes the window.
    private static func stayLimitText(_ policy: VisaPolicyV2?) -> String {
        guard let p = policy, let n = p.maxStayDefault else { return "在免签时限内" }
        if p.maxStayUnit == "hours" { return "≤ \(n / 24) 天" }
        return "≤ \(n) 天"
    }

    // MARK: - 删城：drop blocker cities (engine-verified)

    private static func dropBlockers(query: VisaQuery, appCities: [String], data: VisaDataSet,
                                     rec: VisaRecommendation) -> VisaRoute? {
        guard !rec.blockers.isEmpty else { return nil }
        let blockerSlugs = Set(rec.blockers.compactMap { data.city(forAdminCode: $0)?.appCitySlug?.lowercased() })
        let keptSlugs = appCities.filter { !blockerSlugs.contains($0.lowercased()) }
        guard !keptSlugs.isEmpty else { return nil }

        let keptCodes = keptSlugs.compactMap { data.adminCode(forAppSlug: $0) }
        let r = VisaPolicyEngine.recommend(query.with(cities: keptCodes), data: data)
        guard r.level == .green else { return nil }

        let blockerNames = rec.blockers.map { data.cityName(forAdminCode: $0) }.joined(separator: " · ")
        return VisaRoute(
            kind: .friendly,
            title: "✓ 签证友好 · 去掉拖累城",
            badge: "去掉拖累城", badgeTone: .ok,
            cities: keptSlugs, addedCity: nil,
            note: "去掉需签证的城市（\(blockerNames)），其余城市免签可达，经引擎复核为全程免签。")
    }
}

private extension VisaQuery {
    /// Clone with candidate overrides for re-running the engine on a generated route.
    func with(onward: String? = nil, ticketed: Bool? = nil, cities: [String]? = nil) -> VisaQuery {
        VisaQuery(
            countryCode: countryCode, departure: departure, onward: onward ?? self.onward,
            entryPort: entryPort, exitPort: exitPort, entryAt: entryAt, plannedExitAt: plannedExitAt,
            cities: cities ?? self.cities, ticketed: ticketed ?? self.ticketed, group: group,
            passportValidMonths: passportValidMonths, today: today)
    }
}
