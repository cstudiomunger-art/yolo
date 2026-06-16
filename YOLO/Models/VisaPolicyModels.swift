import Foundation

// Data source for the on-device VisaPolicyEngine. All rows are CMS-managed and
// decoded from Supabase with the client's convertFromSnakeCase strategy, so Swift
// properties stay camelCase. Date columns are kept as "yyyy-MM-dd" strings and
// parsed in the engine (avoids date-decoding pitfalls across PostgREST).

/// Policy framework row (P1 互免 / P2 单方面 / P3 240h过境 / P4 海南 / P5 团体 / L 兜底).
struct VisaPolicy: Codable, Identifiable, Hashable {
    var id: String { policyKey }
    let policyKey: String
    let priority: Int
    let verdict: String          // "green" | "amber" | "red"
    let maxStayDays: Int?
    let areaScope: String        // "nationwide" | "transit_ports" | "hainan" | "group" | "none"
    let clockRule: String?       // "entry_plus_30d" | "entry_plus_10d" | ...
    let headlineEn: String?
    let headlineZh: String?
}

/// Nationality × policy × validity window. Hit when entry date ∈ [effective, expiry].
struct VisaPolicyGrant: Codable, Identifiable, Hashable {
    let id: String
    let policyKey: String
    let countryCode: String
    let effectiveDate: String?   // "yyyy-MM-dd", nil = open start
    let expiryDate: String?      // "yyyy-MM-dd", nil = no end
    let maxStayOverride: Int?
}

/// City region tag for per-city re-check (mainland / hk / macao / special).
struct CityVisaTag: Codable, Identifiable, Hashable {
    var id: String { cityId }
    let cityId: String
    let regionType: String
    let isPortOfEntry: Bool
}

/// Entry port with 240h-transit / Hainan flags.
struct EntryPort: Codable, Identifiable, Hashable {
    var id: String { portId }
    let portId: String
    let nameEn: String
    let nameZh: String
    let cityId: String?
    let transit240h: Bool
    let isHainan: Bool
}

/// Per-(nationality, region) override for the city re-check.
struct VisaRuleOverride: Codable, Identifiable, Hashable {
    let id: String
    let countryCode: String
    let regionType: String
    let visaFree: Bool
    let stayDays: Int?
}

/// Bundle of all visa data the engine evaluates against (fetched + cached, or bundled).
struct VisaDataSet: Codable, Equatable {
    var policies: [VisaPolicy]
    var grants: [VisaPolicyGrant]
    var cityTags: [CityVisaTag]
    var ports: [EntryPort]
    var overrides: [VisaRuleOverride]

    static let empty = VisaDataSet(policies: [], grants: [], cityTags: [], ports: [], overrides: [])
}

// MARK: - Query & Verdict

/// "Third place" status of the onward leg (decides P3 240h transit eligibility).
enum OnwardStatus: Equatable {
    case undecided          // 还没定 → don't judge transit, only look at visa-free
    case sameAsDeparture    // 往返同国 → not a third place
    case thirdPlace         // 第三国/港澳 → eligible third place
}

/// Five hard inputs + trip cities. The trip is the object being judged, not an input.
struct VisaQuery: Equatable {
    let countryCode: String      // passport nationality (ISO-2)
    let departureCode: String?   // country/region code, nil = unknown
    let onwardCode: String?      // country/region code, "HK"/"MO", or nil = 还没定
    let onwardTicketed: Bool
    let entryPortId: String?
    let stayDays: Int
    let entryDate: Date
    let passportValidMonths: Int? // nil = 跳过 GATE0
    let cities: [String]
}

enum VisaVerdictColor: String, Equatable {
    case green, amber, red
}

/// Engine output: enough / not-enough + which policy, secondary matches, blocker cities.
struct VisaVerdict: Equatable {
    let color: VisaVerdictColor
    let policyKey: String         // hit policy, "GATE0" if passport too short, "L" if fallback
    let maxStayDays: Int?
    let areaScope: String
    let headlineZh: String
    /// Other policies the nationality also satisfies (e.g. "你也符合 P3，但 P2 限制更少").
    let secondaryMatches: [String]
    /// Cities not covered by the chosen policy → "不够用 · 拖累城市".
    let blockers: [String]
    let latestExitDate: Date?
    /// True for cases the engine won't hard-judge (double passport / unknown) → 问真人.
    let needsHumanReview: Bool

    var isEnough: Bool { color != .red && blockers.isEmpty }
}
