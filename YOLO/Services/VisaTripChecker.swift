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

        // R3 签证友好 — engine-verified least change. 加城 first, then 删城.
        if let friendly = activateTransit(query: query, appCities: appCities, data: data)
            ?? dropBlockers(query: query, appCities: appCities, data: data, rec: rec) {
            result.append(friendly)
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
                    title: "✓ 签证友好 · 推荐",
                    badge: "全程免签 · 多一城", badgeTone: .ok,
                    cities: appCities, addedCity: hub.name,
                    note: "把\(hub.name)加成最后一站：从内地出境到\(hub.name)构成第三地过境 → 满足 240 小时过境免签，内地段全程免签，\(hub.name)对你的护照通常也免签。等于不办签证还白赚一座城（停留需 ≤ 10 天、从开放口岸进出）。")
            }
        }
        return nil
    }

    // MARK: - ② 删城：drop blocker cities (engine-verified)

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
            title: "✓ 签证友好 · 推荐",
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
