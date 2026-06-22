import Foundation

/// Phase 2: when a trip isn't visa-enough, produce three routes — keep & apply, apply an
/// L visa, or the least-change "visa-friendly" route (add a transit exit / drop blockers).
/// Reuses the verified engine; the only new step is the friendly-route suggestion.
///
/// City lists are app content-city ids (slugs) because they write back to
/// `selectedCityIds`; engine blockers are GB/T 2260 codes, mapped back via the data set.
struct VisaRoute: Identifiable {
    enum Kind { case interest, applyVisa, friendly }
    let id = UUID()
    let kind: Kind
    let title: String
    let badge: String
    let badgeTone: Tone
    let cities: [String]       // app content-city ids (display/write-back order)
    let addedCity: String?     // extra transit-exit city (display name) for the friendly route
    let note: String

    enum Tone { case warn, neutral, ok }
}

enum VisaTripChecker {

    /// HK/MO are valid third-place transit exits that can activate 240h transit visa-free.
    private static let transitExitName = "香港 Hong Kong"

    static func routes(appCities: [String], country: String, data: VisaDataSet,
                       recommendation rec: VisaRecommendation) -> [VisaRoute] {
        guard !rec.isEnough else { return [] }

        var result: [VisaRoute] = []

        // R1 纯兴趣 — original cities, pay with an L visa.
        result.append(VisaRoute(
            kind: .interest,
            title: "✦ 纯兴趣 · 你最初选的",
            badge: "需办 L 签", badgeTone: .warn,
            cities: appCities, addedCity: nil,
            note: "保持原行程，需办 L 旅游签证。"))

        // R2 备选 — cities unchanged, apply an L visa (cost/time).
        result.append(VisaRoute(
            kind: .applyVisa,
            title: "◇ 备选 · 一城不动",
            badge: "办 L 签", badgeTone: .neutral,
            cities: appCities, addedCity: nil,
            note: "行程一城不动，办一张 L 旅游签证（约 4–7 个工作日 + 签证费）。"))

        // R3 签证友好 — least change that removes the blocker.
        let eligibleForTransit = data.grants.contains {
            $0.policyId == "twov_240h" && $0.countryCode.caseInsensitiveCompare(country) == .orderedSame
        }
        if eligibleForTransit {
            result.append(VisaRoute(
                kind: .friendly,
                title: "✓ 签证友好 · 推荐",
                badge: "全程免签 · 多一城", badgeTone: .ok,
                cities: appCities, addedCity: transitExitName,
                note: "把香港加成最后一站：从内地出境到香港构成第三地过境 → 满足 240h 过境免签，内地段全程免签；香港对你的护照也免签。等于不用办签证，还白赚一座城。"))
        } else if !rec.blockers.isEmpty {
            // Map engine blocker codes back to app slugs, then drop them.
            let blockerSlugs = Set(rec.blockers.compactMap { data.city(forAdminCode: $0)?.appCitySlug?.lowercased() })
            let kept = appCities.filter { !blockerSlugs.contains($0.lowercased()) }
            let blockerNames = rec.blockers.map { data.cityName(forAdminCode: $0) }.joined(separator: " · ")
            result.append(VisaRoute(
                kind: .friendly,
                title: "✓ 签证友好 · 推荐",
                badge: "去掉拖累城", badgeTone: .ok,
                cities: kept, addedCity: nil,
                note: "去掉需签证的城市（\(blockerNames)），其余城市免签可达。"))
        }

        return result
    }
}
