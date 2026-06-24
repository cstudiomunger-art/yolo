import Foundation

// Data source + I/O contract for the on-device VisaPolicyEngine (Swift port of the
// verified delivery-package engine.py). Rows are CMS-managed in the visa_*_v2 Supabase
// tables and decoded with the client's convertFromSnakeCase strategy, so Swift
// properties stay camelCase. Date columns are kept as "yyyy-MM-dd" strings and parsed
// in the engine (avoids PostgREST date-decoding pitfalls).

// MARK: - allowed_area (heterogeneous JSON: "national" or ["110000", ...])

/// `policies.allowed_area` is either the literal string "national" or an array of
/// GB/T 2260 admin codes (24h transit uses an empty array = port-zone only).
enum AllowedArea: Codable, Hashable {
    case national
    case codes([String])

    init(from decoder: Decoder) throws {
        let c = try decoder.singleValueContainer()
        if let s = try? c.decode(String.self) {
            self = (s == "national") ? .national : .codes([s])
        } else {
            self = .codes((try? c.decode([String].self)) ?? [])
        }
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.singleValueContainer()
        switch self {
        case .national: try c.encode("national")
        case .codes(let a): try c.encode(a)
        }
    }

    var isNational: Bool { if case .national = self { return true } else { return false } }
}

// MARK: - CMS rows (visa_*_v2 tables)

/// Policy framework row (8 verified policies). Nationality-agnostic rule shape.
struct VisaPolicyV2: Codable, Identifiable, Hashable {
    let id: String                      // mutual_exempt / unilateral_30d / twov_240h / visa_L ...
    let policyType: String
    let nodeKind: String                // "computed" | "info" (visa_L fallback)
    let universal: Bool                 // 1 → skip grant requirement (24h / cruise)
    let officialNameZh: String
    let officialNameEn: String
    let onwardTicket: Bool
    let onwardThirdCountry: Bool
    let groupRequired: Bool
    let entryPortLimited: Bool
    let entryPorts: [String]?           // IATA / UN-LOCODE, nil = unrestricted
    let exitPorts: [String]?            // 240h exit is restricted too
    let entryMode: [String]?
    let maxStayDefault: Int?
    let maxStayUnit: String?            // "days" | "hours"
    let clockRule: String?              // next_day_0000 | by_hour | entry_day
    let entryCount: String?             // single | double | multiple | per_entry (display/data only)
    let allowedArea: AllowedArea
    let passportOrdinaryOnly: Bool?     // 仅普通护照 (display/data only)
    let purpose: [String]?              // tourism | business | transit | family (display/data only)
    let passportValidityMonths: Int?
    let priority: Int                   // tie/fallback order only — NOT the winner picker
    let sourceUrl: String?
    let lastVerified: String?

    /// conditions_count contract = sum of the four restriction booleans.
    var conditionsCount: Int {
        (onwardTicket ? 1 : 0) + (onwardThirdCountry ? 1 : 0)
            + (groupRequired ? 1 : 0) + (entryPortLimited ? 1 : 0)
    }
}

/// Nationality × policy × validity window. Hit when entry date ∈ [effective, expiry].
struct VisaGrantV2: Codable, Identifiable, Hashable {
    let id: String
    let policyId: String
    let countryCode: String
    let effectiveDate: String?          // "yyyy-MM-dd", nil/1900-01-01 = no lower bound
    let expiryDate: String?             // "yyyy-MM-dd", nil = no official end
    let maxStayOverride: Int?
    let entryCountOverride: String?     // per-country entry-count override (display/data only)
    let announcedDate: String?          // 公告日 "yyyy-MM-dd" (display/data only)
    let evidenceQuote: String?          // 原文引文 (display/data only)
}

/// City dimension (GB/T 2260). `appCitySlug` maps the app's content-city ids in.
struct VisaCityRow: Codable, Identifiable, Hashable {
    var id: String { cityId }
    let cityId: String
    let nameZh: String
    let nameEn: String
    let regionType: String              // mainland | special
    let isEntryPort: Bool
    let isExitPort: Bool
    let transit240h: Bool
    let appCitySlug: String?

    init(cityId: String, nameZh: String, nameEn: String, regionType: String,
         isEntryPort: Bool, isExitPort: Bool, transit240h: Bool, appCitySlug: String?) {
        self.cityId = cityId; self.nameZh = nameZh; self.nameEn = nameEn
        self.regionType = regionType; self.isEntryPort = isEntryPort; self.isExitPort = isExitPort
        self.transit240h = transit240h; self.appCitySlug = appCitySlug
    }

    // Foundation's `.convertFromSnakeCase` (the Supabase client's decoder) mis-maps
    // `transit_240h` → `transit240H` — it uppercases the letter after the digits — so the
    // synthesized key `transit240h` never matches and the WHOLE row throws keyNotFound,
    // which cascades to discard the entire live `visa_cities` fetch (app silently falls
    // back to the bundled 6-city set). Decode it by both spellings (Supabase: transit240H;
    // local cache uses plain keys: transit240h); default false (advisory, unused by engine).
    enum CodingKeys: String, CodingKey {
        case cityId, nameZh, nameEn, regionType, isEntryPort, isExitPort, appCitySlug
        case transit240h
        case transit240HConverted = "transit240H"
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        cityId = try c.decode(String.self, forKey: .cityId)
        nameZh = try c.decode(String.self, forKey: .nameZh)
        nameEn = try c.decode(String.self, forKey: .nameEn)
        regionType = try c.decode(String.self, forKey: .regionType)
        isEntryPort = try c.decode(Bool.self, forKey: .isEntryPort)
        isExitPort = try c.decode(Bool.self, forKey: .isExitPort)
        appCitySlug = try c.decodeIfPresent(String.self, forKey: .appCitySlug)
        transit240h = (try? c.decode(Bool.self, forKey: .transit240h))
            ?? (try? c.decode(Bool.self, forKey: .transit240HConverted)) ?? false
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(cityId, forKey: .cityId)
        try c.encode(nameZh, forKey: .nameZh)
        try c.encode(nameEn, forKey: .nameEn)
        try c.encode(regionType, forKey: .regionType)
        try c.encode(isEntryPort, forKey: .isEntryPort)
        try c.encode(isExitPort, forKey: .isExitPort)
        try c.encode(transit240h, forKey: .transit240h)
        try c.encodeIfPresent(appCitySlug, forKey: .appCitySlug)
    }
}

/// Derived city × policy feasibility (read-only; DB computes it, client never recalcs).
struct CityPolicyFeas: Codable, Hashable {
    let cityId: String
    let policyId: String
    let feasibility: String             // ok | no | permit_required
}

/// Overlay permit zone (e.g. Tibet 540000) — reachable but needs a permit.
struct PermitZone: Codable, Hashable {
    let adminCode: String
    let name: String
    let note: String?
}

/// Selectable entry/exit port (CMS-managed in `visa_ports`). The engine matches a query's
/// port against a policy's `entry_ports/exit_ports` by `code`, so this list MUST share that
/// namespace (IATA). Editable in admin so ports aren't hardcoded in the app.
struct VisaPort: Codable, Identifiable, Hashable {
    var id: String { code }
    let code: String            // IATA, e.g. PVG
    let nameZh: String
    let displayOrder: Int
}

/// Tunable engine parameter (CMS `visa_config`, key/value). Optional on the data set so old
/// caches / the bundled fallback decode fine; missing keys fall back to code defaults.
struct VisaConfigRow: Codable, Hashable {
    let key: String
    let valueInt: Int?
    let valueText: String?
}

/// Everything the engine evaluates against (fetched + cached, or bundled fallback).
struct VisaDataSet: Codable, Equatable {
    var policies: [VisaPolicyV2]
    var grants: [VisaGrantV2]
    var cities: [VisaCityRow]
    var matrix: [CityPolicyFeas]
    var permitZones: [PermitZone]
    var ports: [VisaPort]
    var config: [VisaConfigRow]? = nil

    static let empty = VisaDataSet(policies: [], grants: [], cities: [], matrix: [], permitZones: [], ports: [])

    /// Minimum passport validity (months) for GATE0. CMS-editable via `visa_config`; default 3.
    var minPassportValidityMonths: Int {
        config?.first { $0.key == "passport_validity_months" }?.valueInt ?? 3
    }

    // MARK: City-code translation (single source of truth)

    /// Translate an app content-city id ("shanghai") to its GB/T 2260 code ("310000").
    func adminCode(forAppSlug slug: String) -> String? {
        cities.first { $0.appCitySlug?.caseInsensitiveCompare(slug) == .orderedSame }?.cityId
    }

    func city(forAdminCode code: String) -> VisaCityRow? {
        cities.first { $0.cityId == code }
    }

    /// Display label for an admin code (falls back to the raw code).
    func cityName(forAdminCode code: String) -> String {
        city(forAdminCode: code)?.nameZh ?? code
    }

    func policy(_ id: String) -> VisaPolicyV2? { policies.first { $0.id == id } }
}

// MARK: - Engine input contract (delivery doc §2)

/// Six hard inputs + trip cities. The trip is the object being judged, not an input.
struct VisaQuery: Equatable {
    let countryCode: String             // passport nationality (ISO-2)
    let departure: String               // departure country
    let onward: String?                 // next leg; nil/"undecided" = 未定
    let entryPort: String?              // entry port code
    let exitPort: String?               // exit port code (240h restricts exit too)
    let entryAt: Date                   // precise entry datetime (clock start)
    let plannedExitAt: Date             // planned departure
    let cities: [String]                // GB/T 2260 admin codes
    let ticketed: Bool                  // has an onward ticket
    let group: Bool                     // entering with a tour group
    let passportValidMonths: Int?       // GATE0 pre-check; nil = skip
    let today: Date                     // freshness baseline
}

// MARK: - Engine output (four-dim health sheet + plan A/B)

enum VisaLevel: String, Equatable { case green, amber, red }

/// One policy's four-dimension health sheet (the V2 UI render structure).
struct VisaSheet: Equatable, Identifiable {
    var id: String { policyId }
    let policyId: String
    let pass: Bool

    // space
    let spaceOk: Bool
    let blockers: [String]              // admin codes out of range
    // time
    let timeOk: Bool
    let latestExitAt: Date?
    let latestExitDate: Date?
    let overstayHours: Double
    // port
    let portOk: Bool
    // condition
    let conditionOk: Bool
    let conditionReasons: [String]
}

/// A yellow-verdict option: shrink the trip to stay visa-free (A) or apply for an L visa (B).
enum VisaPlan: Equatable, Identifiable {
    /// Plan A — least change that closes the gap: swap blocker cities to same-province
    /// reachable ones + tighten the planned exit to `newPlannedExitMax`.
    case modify(policyId: String, swaps: [String: String?], newPlannedExitMax: Date?)
    /// Plan B — keep the itinerary, apply for an L visa.
    case applyVisa

    var id: String {
        switch self {
        case .modify: return "A"
        case .applyVisa: return "B"
        }
    }
}

/// Engine judgement: green/amber/red + chosen policy, also-eligible, plans, freshness.
struct VisaRecommendation: Equatable {
    let level: VisaLevel
    let chosenPolicyId: String          // "GATE0" if passport too short
    let alsoEligible: [String]          // other passing policy ids
    let sheets: [VisaSheet]
    let plans: [VisaPlan]
    let blockers: [String]              // chosen sheet blockers (admin codes)
    let latestExitDate: Date?
    let maxStayDays: Int?
    let freshness: VisaFreshness?
    let needsHumanReview: Bool

    var isEnough: Bool { level != .red && blockers.isEmpty }

    var chosenSheet: VisaSheet? { sheets.first { $0.policyId == chosenPolicyId } }
}
