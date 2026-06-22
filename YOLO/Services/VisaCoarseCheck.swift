import Foundation

/// Phase 2 §1 (delivery doc 02): build a COARSE visa query from a Plan trip, filling the
/// engine inputs the itinerary doesn't carry (ports / departure / onward / ticket) with
/// sensible defaults — 方案一. Used to proactively flag "this line may need a visa" the
/// moment a route is ready; the user then refines every assumption in the detector and
/// re-judges. Single source of the default assumptions.
enum VisaCoarseCheck {

    /// Coarse default entry/exit airport per app content-city (engine matches by IATA code).
    private static let cityAirport: [String: String] = [
        "beijing": "PEK", "shanghai": "PVG", "xian": "XIY",
        "chengdu": "CTU", "hangzhou": "HGH", "suzhou": "PVG",
    ]

    /// Default airport for a slug list position (fallback to a major hub).
    static func airport(forSlug slug: String?) -> String {
        cityAirport[slug ?? ""] ?? "PVG"
    }

    /// Returns a coarse recommendation, or nil if there's nothing to judge (no mappable
    /// cities / data not loaded). Conservative defaults: round-trip (no third-country
    /// transit), ticketed, self-guided (not a group), GATE0 skipped.
    static func recommendation(citySlugs: [String], start: Date?, end: Date?,
                               countryCode: String, data: VisaDataSet) -> VisaRecommendation? {
        let codes = citySlugs.compactMap { data.adminCode(forAppSlug: $0) }
        guard !codes.isEmpty, !data.policies.isEmpty else { return nil }

        let cc = countryCode.isEmpty ? "GB" : countryCode.uppercased()
        let entryAt = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: start ?? Date())
            ?? (start ?? Date())
        let exitAt = end ?? Calendar.current.date(byAdding: .day, value: max(1, citySlugs.count * 2), to: entryAt) ?? entryAt

        let query = VisaQuery(
            countryCode: cc, departure: cc, onward: cc,
            entryPort: airport(forSlug: citySlugs.first), exitPort: airport(forSlug: citySlugs.last),
            entryAt: entryAt, plannedExitAt: exitAt, cities: codes,
            ticketed: true, group: false, passportValidMonths: nil, today: Date())
        return VisaPolicyEngine.recommend(query, data: data)
    }
}
