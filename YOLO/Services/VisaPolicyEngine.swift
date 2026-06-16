import Foundation

/// On-device, offline-capable visa judgement. Pure function over CMS data: collects
/// the policies a nationality satisfies, picks the least-restrictive (priority order),
/// then re-checks each trip city. The trip is judged, not input (DOC-02 philosophy).
///
/// Priority order (least restrictive first): P1 互免 ≥ P2 单方面 > P3 240h过境 > P4 海南 > P5 团体 > L 兜底.
enum VisaPolicyEngine {

    // MARK: - Public entry

    static func evaluate(_ query: VisaQuery, data: VisaDataSet) -> VisaVerdict {
        // GATE 0 — only when the user supplied a validity (it's optional).
        if let months = query.passportValidMonths, months < 6 {
            return VisaVerdict(
                color: .red, policyKey: "GATE0", maxStayDays: nil, areaScope: "none",
                headlineZh: "护照剩余有效期不足 6 个月，请先换护照",
                secondaryMatches: [], blockers: query.cities, latestExitDate: nil,
                needsHumanReview: false
            )
        }

        let activeGrants = data.grants.filter {
            $0.countryCode.caseInsensitiveEquals(query.countryCode)
                && grantWindowContains(query.entryDate, grant: $0)
        }
        let grantedPolicyKeys = Set(activeGrants.map(\.policyKey))
        let port = query.entryPortId.flatMap { id in data.ports.first { $0.portId == id } }
        let onward = onwardStatus(departure: query.departureCode, onward: query.onwardCode)

        // Walk policies least-restrictive first; first match wins, rest are "secondary".
        let ordered = data.policies.filter { $0.policyKey != "L" }.sorted { $0.priority < $1.priority }
        var chosen: VisaPolicy?
        var secondary: [String] = []
        for policy in ordered where policyMatches(policy, query: query, grantedPolicyKeys: grantedPolicyKeys, port: port, onward: onward) {
            if chosen == nil { chosen = policy } else { secondary.append(policy.policyKey) }
        }

        let fallbackL = data.policies.first { $0.policyKey == "L" }
        let result = chosen ?? fallbackL
        let color = VisaVerdictColor(rawValue: result?.verdict ?? "red") ?? .red

        let blockers = blockerCities(
            query.cities, country: query.countryCode, color: color,
            cityTags: data.cityTags, overrides: data.overrides
        )

        let maxStay = activeGrants.first { $0.policyKey == result?.policyKey }?.maxStayOverride ?? result?.maxStayDays
        let latestExit = latestExitDate(entryDate: query.entryDate, clockRule: result?.clockRule, maxStayDays: maxStay)

        return VisaVerdict(
            color: color,
            policyKey: result?.policyKey ?? "L",
            maxStayDays: maxStay,
            areaScope: result?.areaScope ?? "none",
            headlineZh: result?.headlineZh ?? "默认需办 L 旅游签证",
            secondaryMatches: secondary,
            blockers: blockers,
            latestExitDate: latestExit,
            needsHumanReview: false
        )
    }

    // MARK: - Onward / transit third-place

    static func onwardStatus(departure: String?, onward: String?) -> OnwardStatus {
        guard let onward, !onward.isEmpty else { return .undecided }
        if onward.caseInsensitiveEquals("HK") || onward.caseInsensitiveEquals("MO") { return .thirdPlace }
        if let departure, departure.caseInsensitiveEquals(onward) { return .sameAsDeparture }
        return .thirdPlace
    }

    // MARK: - Policy matching

    private static func policyMatches(
        _ policy: VisaPolicy,
        query: VisaQuery,
        grantedPolicyKeys: Set<String>,
        port: EntryPort?,
        onward: OnwardStatus
    ) -> Bool {
        let granted = grantedPolicyKeys.contains(policy.policyKey)
        switch policy.policyKey {
        case "P1", "P2":
            // Mutual / unilateral visa-free: nationality granted within the active window.
            return granted
        case "P3":
            // 240h transit: granted + onward is a third place + open transit port + within hour cap.
            guard granted, onward == .thirdPlace, port?.transit240h == true else { return false }
            return query.stayDays <= (policy.maxStayDays ?? 10)
        case "P4":
            // Hainan regional visa-free: entered via a Hainan port + granted.
            return granted && port?.isHainan == true
        case "P5":
            // Group-tour visa-free: no group input is collected → never auto-matches.
            return false
        default:
            return false
        }
    }

    // MARK: - Per-city re-check

    private static func blockerCities(
        _ cities: [String],
        country: String,
        color: VisaVerdictColor,
        cityTags: [CityVisaTag],
        overrides: [VisaRuleOverride]
    ) -> [String] {
        cities.filter { city in
            let region = cityTags.first { $0.cityId.caseInsensitiveEquals(city) }?.regionType ?? "mainland"
            if let override = overrides.first(where: {
                $0.countryCode.caseInsensitiveEquals(country) && $0.regionType == region
            }) {
                return !override.visaFree
            }
            // No override: HK/Macao are visa-free for most nationalities; mainland/special
            // are covered iff the chosen policy isn't a red (visa-required) verdict.
            switch region {
            case "hk", "macao": return false
            default: return color == .red
            }
        }
    }

    // MARK: - Dates

    private static let dayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = TimeZone(identifier: "UTC")
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()

    private static func parseDay(_ s: String?) -> Date? {
        guard let s, !s.isEmpty else { return nil }
        return dayFormatter.date(from: s)
    }

    static func grantWindowContains(_ entryDate: Date, grant: VisaPolicyGrant) -> Bool {
        if let start = parseDay(grant.effectiveDate), entryDate < start { return false }
        if let end = parseDay(grant.expiryDate), entryDate > end { return false }
        return true
    }

    /// Latest legal exit date from the policy clock rule ("entry_plus_Nd") or max stay days.
    static func latestExitDate(entryDate: Date, clockRule: String?, maxStayDays: Int?) -> Date? {
        let days: Int?
        if let rule = clockRule, rule.hasPrefix("entry_plus_"), rule.hasSuffix("d"),
           let n = Int(rule.dropFirst("entry_plus_".count).dropLast()) {
            days = n
        } else {
            days = maxStayDays
        }
        guard let d = days else { return nil }
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: d, to: entryDate)
    }
}

private extension String {
    func caseInsensitiveEquals(_ other: String) -> Bool {
        caseInsensitiveCompare(other) == .orderedSame
    }
}
