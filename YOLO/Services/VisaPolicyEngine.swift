import Foundation

/// On-device, offline visa judgement — a faithful Swift port of the delivery-package
/// `engine.py` (8 verified policies). Pure function over `VisaDataSet`: collect ALL
/// eligible candidates, run a four-dimension health sheet on each, then pick the
/// least-restrictive PASS via `scorePolicy` (NOT a priority short-circuit — see doc §3).
///
/// Decision flow (engine.py:210):
///   pass exists  → 🟢 green, scorePolicy picks the winner, rest are also-eligible
///   no pass, fail → 🟡 amber, smallest-gap candidate + plan A (modify) / plan B (visa)
///   only L left  → 🔴 red, visa_L fallback
enum VisaPolicyEngine {

    private static let cn = "CN"

    // Deterministic UTC Gregorian calendar (mirrors engine.py's naive datetimes).
    private static let cal: Calendar = {
        var c = Calendar(identifier: .gregorian)
        c.timeZone = TimeZone(identifier: "UTC")!
        return c
    }()

    private static let dayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = TimeZone(identifier: "UTC")
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()

    // MARK: - Public entry

    static func recommend(_ query: VisaQuery, data: VisaDataSet) -> VisaRecommendation {
        // GATE 0 — passport validity ≥ 6 months (engine-external pre-check, delivery doc §2).
        if let months = query.passportValidMonths, months < 6 {
            return VisaRecommendation(
                level: .red, chosenPolicyId: "GATE0", alsoEligible: [], sheets: [], plans: [],
                blockers: query.cities, latestExitDate: nil, maxStayDays: nil,
                freshness: nil, needsHumanReview: false)
        }

        let candidates = checkEligibility(query, data: data)
        let policyMap = Dictionary(uniqueKeysWithValues: data.policies.map { ($0.id, $0) })
        let onDate = dayString(query.entryAt)

        var sheets: [VisaSheet] = []
        for c in candidates where c.status == .candidate {
            guard let p = policyMap[c.policyId] else { continue }
            let grant = activeGrant(policyId: p.id, country: query.countryCode, onDate: onDate, data: data)
            sheets.append(runSheet(query, policy: p, grant: grant, data: data))
        }

        let passed = sheets.filter { $0.pass }

        // 🟢 Green — pick the least-restrictive passing policy (scorePolicy, not priority).
        if !passed.isEmpty {
            let chosen = passed.min { a, b in
                score(policyMap[a.policyId]!, latestExitAt: a.latestExitAt, plannedExitAt: query.plannedExitAt)
                    < score(policyMap[b.policyId]!, latestExitAt: b.latestExitAt, plannedExitAt: query.plannedExitAt)
            }!
            let also = passed.filter { $0.policyId != chosen.policyId }.map(\.policyId)
            let policy = policyMap[chosen.policyId]!
            return VisaRecommendation(
                level: .green, chosenPolicyId: chosen.policyId, alsoEligible: also,
                sheets: sheets, plans: [],
                blockers: chosen.blockers, latestExitDate: chosen.latestExitDate,
                maxStayDays: displayStayDays(policy, grant: activeGrant(policyId: policy.id, country: query.countryCode, onDate: onDate, data: data)),
                freshness: VisaFreshness.forPolicy(chosen.policyId, country: query.countryCode, data: data, today: query.today),
                needsHumanReview: false)
        }

        // 🔴 Red — no failing candidate either: only L visa remains.
        let failing = sheets.filter { !$0.pass }
        if failing.isEmpty {
            return VisaRecommendation(
                level: .red, chosenPolicyId: "visa_L", alsoEligible: [], sheets: sheets,
                plans: [.applyVisa], blockers: query.cities, latestExitDate: nil, maxStayDays: nil,
                freshness: VisaFreshness.forPolicy("visa_L", country: query.countryCode, data: data, today: query.today),
                needsHumanReview: false)
        }

        // 🟡 Amber — smallest-gap candidate (fail dims → overstay → blocker count).
        let chosen = failing.min { gap($0) < gap($1) }!
        let swaps = replaceBlockers(policyId: chosen.policyId, blockers: chosen.blockers, data: data)
        let planA = VisaPlan.modify(
            policyId: chosen.policyId,
            swaps: swaps,
            newPlannedExitMax: chosen.timeOk ? nil : chosen.latestExitAt)
        return VisaRecommendation(
            level: .amber, chosenPolicyId: chosen.policyId, alsoEligible: [], sheets: sheets,
            plans: [planA, .applyVisa],
            blockers: chosen.blockers, latestExitDate: chosen.latestExitDate,
            maxStayDays: displayStayDays(policyMap[chosen.policyId]!, grant: activeGrant(policyId: chosen.policyId, country: query.countryCode, onDate: onDate, data: data)),
            freshness: VisaFreshness.forPolicy(chosen.policyId, country: query.countryCode, data: data, today: query.today),
            needsHumanReview: false)
    }

    // MARK: - S1 eligibility (engine.py:102) — list ALL candidates, don't short-circuit

    enum CandStatus { case candidate, excluded, fallback }
    struct Candidate { let policyId: String; let status: CandStatus; let reason: String }

    static func checkEligibility(_ query: VisaQuery, data: VisaDataSet) -> [Candidate] {
        let onDate = dayString(query.entryAt)
        let third = isThirdCountryTransit(departure: query.departure, onward: query.onward)
        var out: [Candidate] = []
        for p in data.policies.sorted(by: { $0.priority < $1.priority }) {
            if p.id == "visa_L" {
                out.append(Candidate(policyId: p.id, status: .fallback, reason: "永远可行，代价=时间+费用"))
                continue
            }
            let grant = activeGrant(policyId: p.id, country: query.countryCode, onDate: onDate, data: data)
            // universal=1 policies (24h / cruise) apply worldwide → skip grant; non-universal
            // without a grant = not applicable (incl. "grant not录完" drafts — exclude not admit).
            if grant == nil && !p.universal {
                out.append(Candidate(policyId: p.id, status: .excluded, reason: "\(query.countryCode) 无生效中的 \(p.id) grant"))
                continue
            }
            if p.onwardThirdCountry && third != true {
                out.append(Candidate(policyId: p.id, status: .excluded, reason: "非第三国过境"))
                continue
            }
            // Group-exemption (cruise / asean) is a hard 随团 gate: lone travelers excluded so a
            // universal cruise policy doesn't leak into every散客 candidate set (README fix #2).
            if p.groupRequired && !query.group {
                out.append(Candidate(policyId: p.id, status: .excluded, reason: "团体免签需随团入境（当前为散客）"))
                continue
            }
            out.append(Candidate(policyId: p.id, status: .candidate, reason: "资格过滤通过"))
        }
        return out
    }

    // MARK: - S3 health sheet (engine.py:136) — four dims × gap

    static func runSheet(_ query: VisaQuery, policy: VisaPolicyV2, grant: VisaGrantV2?, data: VisaDataSet) -> VisaSheet {
        // ① space
        var blockers: [String] = []
        for c in query.cities {
            let feas = feasibility(city: c, policyId: policy.id, data: data)
            if !(feas == "ok" || feas == "permit_required") { blockers.append(c) }
        }
        let spaceOk = blockers.isEmpty

        // ② time
        let (latestAt, latestDate) = computeLatestExit(policy: policy, entryAt: query.entryAt, grant: grant)
        let timeOk = query.plannedExitAt <= latestAt
        let overstay = max(0, query.plannedExitAt.timeIntervalSince(latestAt) / 3600)

        // ③ port (entry + exit both restricted)
        let portOk = (policy.entryPorts == nil || (query.entryPort.map { policy.entryPorts!.contains($0) } ?? false))
            && (policy.exitPorts == nil || (query.exitPort.map { policy.exitPorts!.contains($0) } ?? false))

        // ④ condition (onward ticket / third country / group)
        let third = isThirdCountryTransit(departure: query.departure, onward: query.onward)
        var condOk = true
        var reasons: [String] = []
        if policy.onwardTicket && !query.ticketed { condOk = false; reasons.append("需已出续程票") }
        if policy.onwardThirdCountry && third != true { condOk = false; reasons.append("需前往第三国/地区") }
        if policy.groupRequired && !query.group { condOk = false; reasons.append("需随旅游团入境") }

        let pass = spaceOk && timeOk && portOk && condOk
        return VisaSheet(
            policyId: policy.id, pass: pass,
            spaceOk: spaceOk, blockers: blockers,
            timeOk: timeOk, latestExitAt: latestAt, latestExitDate: latestDate, overstayHours: overstay,
            portOk: portOk, conditionOk: condOk, conditionReasons: reasons)
    }

    // MARK: - Predicates / math

    /// engine.py:26 — HK/MO are third places; round-trip / to-CN / undecided are not.
    static func isThirdCountryTransit(departure: String, onward: String?) -> Bool? {
        guard let onward, !onward.isEmpty, onward != "undecided" else { return nil }
        if onward.caseInsensitiveCompare(departure) == .orderedSame { return false }
        if onward.caseInsensitiveCompare(cn) == .orderedSame { return false }
        return true
    }

    static func effectiveStay(_ policy: VisaPolicyV2, grant: VisaGrantV2?) -> Int {
        grant?.maxStayOverride ?? policy.maxStayDefault ?? 0
    }

    /// engine.py:43 — latest legal exit (exclusive cutoff). Three clock-rule branches.
    static func computeLatestExit(policy: VisaPolicyV2, entryAt: Date, grant: VisaGrantV2?) -> (Date, Date) {
        let midnight = cal.startOfDay(for: entryAt)
        let nextMidnight = cal.date(byAdding: .day, value: 1, to: midnight)!
        let stay = effectiveStay(policy, grant: grant)
        let rule = policy.clockRule ?? "next_day_0000"

        let latest: Date
        if policy.maxStayUnit == "hours" {
            let start: Date
            switch rule {
            case "next_day_0000": start = nextMidnight
            case "by_hour": start = entryAt
            default: start = midnight
            }
            latest = start.addingTimeInterval(TimeInterval(stay) * 3600)
        } else { // days: entry day = day1, must leave before end of day `stay`
            let start = (rule == "next_day_0000") ? nextMidnight : midnight
            latest = cal.date(byAdding: .day, value: stay, to: start)!
        }
        let lastDay = cal.startOfDay(for: latest.addingTimeInterval(-1))
        return (latest, lastDay)
    }

    /// engine.py:72 — scoring key (smaller = preferred): conditions → spatial → -margin.
    /// Day-margin is ONLY a tiebreak (delivery doc §5 — golden-locked反例).
    static func score(_ policy: VisaPolicyV2, latestExitAt: Date?, plannedExitAt: Date) -> (Int, Int, Double) {
        let margin = (latestExitAt ?? plannedExitAt).timeIntervalSince(plannedExitAt)
        let spatialRank = policy.allowedArea.isNational ? 0 : 1
        return (policy.conditionsCount, spatialRank, -margin)
    }

    /// Amber gap key (engine.py:246): fail-dim count → overstay hours → blocker count.
    private static func gap(_ s: VisaSheet) -> (Int, Double, Int) {
        let nfail = (s.spaceOk ? 0 : 1) + (s.timeOk ? 0 : 1) + (s.portOk ? 0 : 1) + (s.conditionOk ? 0 : 1)
        return (nfail, s.overstayHours, s.blockers.count)
    }

    // MARK: - Plan A: least change that closes the gap (engine.py:195)

    /// Swap each blocker for a same-province reachable city under the policy (v1; content
    /// similarity deferred). Same-province lookup uses the first 2 admin-code digits.
    static func replaceBlockers(policyId: String, blockers: [String], data: VisaDataSet) -> [String: String?] {
        var swaps: [String: String?] = [:]
        let okCities = data.matrix
            .filter { $0.policyId == policyId && $0.feasibility == "ok" }
            .map(\.cityId)
            .sorted()
        for b in blockers {
            let prov = String(b.prefix(2))
            swaps[b] = okCities.first { $0.hasPrefix(prov) && $0 != b }
        }
        return swaps
    }

    // MARK: - DB reads

    static func activeGrant(policyId: String, country: String, onDate: String, data: VisaDataSet) -> VisaGrantV2? {
        data.grants
            .filter {
                $0.policyId == policyId
                    && $0.countryCode.caseInsensitiveCompare(country) == .orderedSame
                    && (($0.effectiveDate ?? "1900-01-01") <= onDate)
                    && ($0.expiryDate == nil || $0.expiryDate! >= onDate)
            }
            .max { ($0.effectiveDate ?? "") < ($1.effectiveDate ?? "") }
    }

    private static func feasibility(city: String, policyId: String, data: VisaDataSet) -> String {
        data.matrix.first { $0.cityId == city && $0.policyId == policyId }?.feasibility ?? "no"
    }

    private static func displayStayDays(_ policy: VisaPolicyV2, grant: VisaGrantV2?) -> Int? {
        policy.maxStayUnit == "days" ? effectiveStay(policy, grant: grant) : nil
    }

    private static func dayString(_ date: Date) -> String { dayFormatter.string(from: date) }
}
