import Foundation

/// Builds the nationality-level visa summary that drives the Home hero + Profile cards,
/// derived from the verified VisaPolicyEngine data — replaces the retired single-country
/// `visa_rules` table. Reuses `VisaRule` purely as a view-model so the existing cards are
/// unchanged. Nationwide visa-free (互免 / 单方面) → a clean "visa-free" badge + stay days;
/// a 240h / 海南 / 团免 grant → "conditional visa-free"; otherwise visa required. The
/// detector / Plan banner remain the place for a real per-trip judgement; this is a hint.
enum VisaNationalitySummary {
    /// Nationwide blanket visa-free → clean visa-free badge.
    private static let nationwide = ["mutual_exempt", "unilateral_30d"]
    /// Grant-based conditional visa-free (needs a trip check). Excludes the universal
    /// 24h-transit / cruise policies, which apply to everyone and aren't a useful signal.
    private static let conditional = ["twov_240h", "hainan_30d", "group_asean_xsbn"]

    private static let dayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = TimeZone(identifier: "UTC")
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()

    static func rule(countryCode: String, countryName: String, flag: String,
                     data: VisaDataSet, today: Date = Date()) -> VisaRule {
        let cc = countryCode.uppercased()
        let onDate = dayFormatter.string(from: today)
        let sorted = data.policies.sorted { $0.priority < $1.priority }

        // Best nationwide visa-free policy active for this nationality today.
        for p in sorted where nationwide.contains(p.id) {
            if let grant = VisaPolicyEngine.activeGrant(policyId: p.id, country: cc, onDate: onDate, data: data) {
                return VisaRule(
                    countryCode: cc, countryName: countryName, flag: flag,
                    visaFree: true, stayDays: grant.maxStayOverride ?? p.maxStayDefault,
                    headline: p.officialNameEn.isEmpty ? p.officialNameZh : p.officialNameEn, details: [])
            }
        }

        // Conditional visa-free (transit / regional / group) — not a blanket pass.
        let hasConditional = sorted.contains { p in
            conditional.contains(p.id)
                && VisaPolicyEngine.activeGrant(policyId: p.id, country: cc, onDate: onDate, data: data) != nil
        }
        return VisaRule(
            countryCode: cc, countryName: countryName, flag: flag,
            visaFree: false, stayDays: nil,
            headline: hasConditional ? String(localized: "Conditional visa-free") : "",
            details: [])
    }
}
