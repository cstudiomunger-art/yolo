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
    let note: String

    enum Tone { case warn, neutral, ok }
}

enum VisaTripChecker {

    /// HK/MO are valid third-place transit exits that can activate 240h transit visa-free.
    private static let transitHubs: [(code: String, name: String)] = [("HK", "香港 Hong Kong"), ("MO", "澳门 Macao")]

    /// `query` carries the exact engine inputs used for the base verdict; we clone it with
    /// candidate tweaks and re-run the engine to verify each route actually goes green.
    ///
    /// `catalog` is the full content-city pool (slug + popularity) used to source 换城
    /// replacements; defaults to empty so the detector verdict path keeps its old behaviour
    /// (加过境 / 删城 only). Friendly routes are ranked by loss: 加过境(不丢城) > 换城(等量替换) > 删城(丢城).
    static func routes(query: VisaQuery, appCities: [String], data: VisaDataSet,
                       recommendation rec: VisaRecommendation,
                       catalog: [(slug: String, popularity: Int)] = []) -> [VisaRoute] {
        guard !rec.isEnough else { return [] }

        var result: [VisaRoute] = []

        // R1 纯兴趣 — original cities, pay with an L visa (cost from the base verdict).
        result.append(VisaRoute(
            kind: .interest,
            title: "✦ 纯兴趣 · 你最初选的",
            badge: "需办 L 签", badgeTone: .warn,
            cities: appCities, addedCity: nil,
            note: "保持原行程，默认需办 L 旅游签证。"))

        // R3 签证友好 — engine-verified, ranked by loss. 加过境(no loss) + 换城(equal swap);
        // 删城 only as a fallback when neither produced, so we never show > 2 friendly cards.
        var friendly: [VisaRoute] = []
        if let r = activateTransit(query: query, appCities: appCities, data: data) { friendly.append(r) }
        if let r = swapBlockers(query: query, appCities: appCities, catalog: catalog, data: data, rec: rec) { friendly.append(r) }
        if friendly.isEmpty, let r = dropBlockers(query: query, appCities: appCities, data: data, rec: rec) { friendly.append(r) }
        result.append(contentsOf: friendly)

        // R2 备选 — cities unchanged, apply an L visa (engine plan B).
        result.append(VisaRoute(
            kind: .applyVisa,
            title: "◇ 备选 · 一城不动",
            badge: "办 L 签", badgeTone: .neutral,
            cities: appCities, addedCity: nil,
            note: "行程一城不动，办一张 L 旅游签证（约 4–7 个工作日 + 签证费）。"))

        return result
    }

    // MARK: - ① 加城：add a HK/MO transit exit to activate 240h (engine-verified)

    /// Route-layer's headline move (doc §4②): the engine never adds cities itself, so we
    /// propose adding HK/MO as the onward leg and let the engine VERIFY it goes green via
    /// twov_240h. Only works when the mainland cities are in the 240h area and the stay ≤ 240h.
    private static func activateTransit(query: VisaQuery, appCities: [String], data: VisaDataSet) -> VisaRoute? {
        for hub in transitHubs {
            let q2 = query.with(onward: hub.code, ticketed: true)
            let r = VisaPolicyEngine.recommend(q2, data: data)
            if r.level == .green && r.chosenPolicyId == "twov_240h" {
                return VisaRoute(
                    kind: .friendly,
                    title: "✓ 签证友好 · 加一城过境",
                    badge: "全程免签 · 多一城", badgeTone: .ok,
                    cities: appCities, addedCity: hub.name,
                    note: "把\(hub.name)加成最后一站：从内地出境到\(hub.name)构成第三地过境 → 满足 240 小时过境免签，内地段全程免签，\(hub.name)对你的护照通常也免签。等于不办签证还白赚一座城（停留需 ≤ 10 天、从开放口岸进出）。")
            }
        }
        return nil
    }

    // MARK: - ② 换城：swap blocker cities for popular visa-free ones (engine-verified)

    /// Equal-count replacement (doc: 替换一个城市): keep the non-blocker cities, then fill
    /// the freed slots with the most popular catalog cities that are (a) not already in the
    /// trip, (b) mappable to an admin code, (c) green on their own — finally re-running the
    /// engine on the whole swapped list to VERIFY it goes green. Keeps the city count intact.
    private static func swapBlockers(query: VisaQuery, appCities: [String],
                                     catalog: [(slug: String, popularity: Int)],
                                     data: VisaDataSet, rec: VisaRecommendation) -> VisaRoute? {
        guard !rec.blockers.isEmpty, !catalog.isEmpty else { return nil }
        let blockerSlugs = Set(rec.blockers.compactMap { data.city(forAdminCode: $0)?.appCitySlug?.lowercased() })
        let keptSlugs = appCities.filter { !blockerSlugs.contains($0.lowercased()) }
        let need = appCities.count - keptSlugs.count
        guard need > 0 else { return nil }

        let inTrip = Set(appCities.map { $0.lowercased() })
        let candidates: [(slug: String, code: String)] = catalog
            .filter { !inTrip.contains($0.slug.lowercased()) }
            .sorted { $0.popularity > $1.popularity }
            .compactMap { item in
                guard let code = data.adminCode(forAppSlug: item.slug) else { return nil }
                let r = VisaPolicyEngine.recommend(query.with(cities: [code]), data: data)
                return r.level == .green ? (item.slug, code) : nil
            }
        guard candidates.count >= need else { return nil }

        let picks = Array(candidates.prefix(need))
        let swappedSlugs = keptSlugs + picks.map { $0.slug }
        let swappedCodes = swappedSlugs.compactMap { data.adminCode(forAppSlug: $0) }
        let r = VisaPolicyEngine.recommend(query.with(cities: swappedCodes), data: data)
        guard r.level == .green else { return nil }

        let fromNames = rec.blockers.map { data.cityName(forAdminCode: $0) }.joined(separator: " · ")
        let toNames = picks.map { data.cityName(forAdminCode: $0.code) }.joined(separator: " · ")
        return VisaRoute(
            kind: .friendly,
            title: "✓ 签证友好 · 换城",
            badge: "换城免签 · 城数不变", badgeTone: .ok,
            cities: swappedSlugs, addedCity: nil,
            note: "把需签证的城市（\(fromNames)）换成免签可达的（\(toNames)），城市数量不变，经引擎复核为全程免签。")
    }

    // MARK: - ③ 删城：drop blocker cities (engine-verified)

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
