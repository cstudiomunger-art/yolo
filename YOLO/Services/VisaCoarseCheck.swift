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

    /// Builds the coarse engine query for a trip, or nil if there's nothing to judge (no
    /// mappable cities / data not loaded). Conservative defaults: round-trip (no third-country
    /// transit), ticketed, self-guided (not a group), GATE0 skipped. Single source of truth so
    /// callers that also need route candidates (`VisaTripChecker.routes`) judge the same query.
    /// `departure`/`onward` override the round-trip default (both = passport country) when the
    /// caller has collected them — e.g. the Plan dates page asks for nationality / 出发国 /
    /// 下一程国 so transit (240h) can be judged accurately. `onward == nil` = undecided.
    static func query(citySlugs: [String], start: Date?, end: Date?,
                      countryCode: String, data: VisaDataSet,
                      departure: String? = nil, onward: String? = nil,
                      passportValidMonths: Int? = nil) -> VisaQuery? {
        let codes = citySlugs.compactMap { data.adminCode(forAppSlug: $0) }
        guard !codes.isEmpty, !data.policies.isEmpty else { return nil }

        let cc = countryCode.isEmpty ? "GB" : countryCode.uppercased()
        let dep = (departure?.isEmpty == false) ? departure!.uppercased() : cc
        // onward: nil (not provided) → round-trip default = cc; "" (explicitly undecided) → nil.
        let onw: String?
        if let onward { onw = onward.isEmpty ? nil : onward.uppercased() } else { onw = cc }
        let entryAt = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: start ?? Date())
            ?? (start ?? Date())
        let exitAt = end ?? Calendar.current.date(byAdding: .day, value: max(1, citySlugs.count * 2), to: entryAt) ?? entryAt

        return VisaQuery(
            countryCode: cc, departure: dep, onward: onw,
            entryPort: airport(forSlug: citySlugs.first), exitPort: airport(forSlug: citySlugs.last),
            entryAt: entryAt, plannedExitAt: exitAt, cities: codes,
            ticketed: true, group: false, passportValidMonths: passportValidMonths, today: Date())
    }

    /// Returns a coarse recommendation, or nil if there's nothing to judge.
    static func recommendation(citySlugs: [String], start: Date?, end: Date?,
                               countryCode: String, data: VisaDataSet) -> VisaRecommendation? {
        guard let q = query(citySlugs: citySlugs, start: start, end: end,
                            countryCode: countryCode, data: data) else { return nil }
        return VisaPolicyEngine.recommend(q, data: data)
    }
}
