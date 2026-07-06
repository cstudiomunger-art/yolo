import Foundation

/// Phase 2 route recommendation (delivery doc 02): the engine is the judge, the route
/// layer is the question-setter. We don't re-derive visa logic — we GENERATE candidate
/// routes (add a transit hub / drop blockers) and re-run `VisaPolicyEngine.recommend`
/// on each, keeping only engine-verified green ones. Ranking: add city > drop city > apply visa.
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
    let cities: [String]       // app content-city ids in visit order (entry → … → exit)
    let addedCity: String?     // advisory transit-exit city (display name) for the friendly route
    /// Content-city slug for `addedCity` (e.g. "hongkong"). When this city exists in the content
    /// catalog, adopting the route folds it into the itinerary as a real stop; until then the
    /// add stays advisory (display-only). Forward-compatible: no-op while the slug is absent.
    var addedCitySlug: String? = nil
    /// For a transit card that offers several equivalent exits (HK / Macao), the per-hub choices.
    /// When present the UI shows one button per option (pick the hub) instead of one CTA.
    var transitOptions: [TransitOption]? = nil
    let note: String

    enum Tone { case warn, neutral, ok }
    struct TransitOption: Identifiable, Hashable { let id = UUID(); let short: String; let slug: String }
}

enum VisaTripChecker {

    /// HK/MO are valid third-place transit exits that can activate 240h transit visa-free.
    /// `short` = display short name; `landPort` = the bordering mainland city to cross by land.
    private static let transitHubs: [(code: String, name: String, short: String, landPort: String, slug: String)] = [
        ("HK", "Hong Kong", "Hong Kong", "Shenzhen", "hongkong"),
        ("MO", "Macao", "Macao", "Zhuhai", "macao"),
    ]

    /// `query` carries the exact engine inputs used for the base verdict; we clone it with
    /// candidate tweaks and re-run the engine to verify each route actually goes green.
    /// City swap is NOT here — it's interactive (`swapPlan`), so the user picks the replacement
    /// from a city list rather than us auto-choosing the most popular one.
    /// `appCities` must be in visit order (first = landing, last = return) so Original picks
    /// matches Flight endpoints and coarse entry/exit ports stay aligned.
    static func routes(query: VisaQuery, appCities: [String], data: VisaDataSet,
                       recommendation rec: VisaRecommendation) -> [VisaRoute] {
        guard !rec.isEnough else { return [] }

        var result: [VisaRoute] = []

        // R1 original interest — original cities, pay with an L visa (cost from the base verdict).
        result.append(VisaRoute(
            kind: .interest,
            title: "✦ Original picks",
            badge: "L visa needed", badgeTone: .warn,
            cities: appCities, addedCity: nil,
            note: "Keep your original itinerary; an L tourist visa is typically required."))

        // R3 visa-friendly — engine-verified least change. Show a card per working transit hub
        // (HK + Macao, both verified green); fall back to drop-city only when no transit works.
        let transit = activateTransit(query: query, appCities: appCities, data: data)
        if !transit.isEmpty {
            result.append(contentsOf: transit)
        } else if let drop = dropBlockers(query: query, appCities: appCities, data: data, rec: rec) {
            result.append(drop)
        }

        // R2 fallback — cities unchanged, apply an L visa (engine plan B).
        result.append(VisaRoute(
            kind: .applyVisa,
            title: "◇ Fallback · keep cities",
            badge: "Apply for L visa", badgeTone: .neutral,
            cities: appCities, addedCity: nil,
            note: "Keep every city; apply for an L tourist visa (~4–7 business days + visa fee)."))

        return result
    }

    // MARK: - City swap (interactive): list qualifying replacement cities, the user chooses

    /// An engine-verified replacement pool for a not-enough trip's blocker cities. Each
    /// candidate is green as a solo stand-in (under the same coarse query); the user's final
    /// combined pick is re-verified with `verifySwap` at confirm time (engine is the judge).
    struct SwapPlan {
        let blockerSlugs: [String]   // app slugs being removed
        let blockerNames: String     // display, e.g. "Yuncheng · Datong"
        let keptSlugs: [String]      // retained non-blocker cities (app slugs)
        let need: Int                // how many replacements the user must choose
        let candidates: [Candidate]  // qualifying replacements, ranked by popularity
        struct Candidate: Identifiable, Hashable { let id: String; let slug: String; let name: String; let popularity: Int }
    }

    /// Builds the replacement pool, or nil if there's nothing to offer (no blockers, no
    /// catalog, or fewer green candidates than blockers). `catalog` = full content-city pool.
    static func swapPlan(query: VisaQuery, appCities: [String],
                         catalog: [(slug: String, popularity: Int)],
                         data: VisaDataSet, rec: VisaRecommendation) -> SwapPlan? {
        guard !rec.blockers.isEmpty, !catalog.isEmpty else { return nil }
        let blockerSlugSet = Set(rec.blockers.compactMap { data.city(forAdminCode: $0)?.appCitySlug?.lowercased() })
        let keptSlugs = appCities.filter { !blockerSlugSet.contains($0.lowercased()) }
        let blockerSlugs = appCities.filter { blockerSlugSet.contains($0.lowercased()) }
        let need = appCities.count - keptSlugs.count
        guard need > 0 else { return nil }

        let inTrip = Set(appCities.map { $0.lowercased() })
        let candidates: [SwapPlan.Candidate] = catalog
            .filter { !inTrip.contains($0.slug.lowercased()) }
            .sorted { $0.popularity > $1.popularity }
            .compactMap { item in
                guard let code = data.adminCode(forAppSlug: item.slug) else { return nil }
                let r = VisaPolicyEngine.recommend(query.with(cities: [code]), data: data)
                guard r.level == .green else { return nil }
                return SwapPlan.Candidate(id: item.slug, slug: item.slug,
                                          name: data.cityName(forAdminCode: code), popularity: item.popularity)
            }
        guard candidates.count >= need else { return nil }

        let blockerNames = rec.blockers.map { data.cityName(forAdminCode: $0) }.joined(separator: " · ")
        return SwapPlan(blockerSlugs: blockerSlugs, blockerNames: blockerNames,
                        keptSlugs: keptSlugs, need: need, candidates: candidates)
    }

    /// Re-verify the user's chosen replacements actually go green together with the kept
    /// cities. The combination — not just each city solo — must pass (engine is the judge).
    static func verifySwap(query: VisaQuery, keptSlugs: [String], picks: [String], data: VisaDataSet) -> Bool {
        let codes = (keptSlugs + picks).compactMap { data.adminCode(forAppSlug: $0) }
        guard codes.count == keptSlugs.count + picks.count else { return false }
        return VisaPolicyEngine.recommend(query.with(cities: codes), data: data).level == .green
    }

    // MARK: - Add city: add a HK/MO transit exit to activate 240h (engine-verified)

    /// Route-layer's headline move (doc §4②): the engine never adds cities itself, so we
    /// propose adding HK/MO as the onward leg and let the engine VERIFY each goes green via
    /// twov_240h. Returns a card PER working hub (HK + Macao), copy/stay-limit derived from the
    /// matched policy so it stays in sync with the CMS.
    private static func activateTransit(query: VisaQuery, appCities: [String], data: VisaDataSet) -> [VisaRoute] {
        var working: [(code: String, name: String, short: String, landPort: String, slug: String)] = []
        var policy: VisaPolicyV2?
        for hub in transitHubs {
            let q2 = query.with(onward: hub.code, ticketed: true)
            let r = VisaPolicyEngine.recommend(q2, data: data)
            guard r.level == .green, r.chosenPolicyId == "twov_240h" else { continue }
            if policy == nil { policy = data.policies.first { $0.id == r.chosenPolicyId } }
            working.append(hub)
        }
        guard !working.isEmpty else { return [] }

        // Equivalent exits (Hong Kong / Macao) collapse into ONE card with a button per hub.
        let policyName = policy.map { p in
            p.officialNameEn.isEmpty ? p.officialNameZh : p.officialNameEn
        } ?? "Transit visa-free"
        let stayLimit = stayLimitText(policy)
        let hubNames = working.map(\.short).joined(separator: " or ")
        let landBullets = working.map { "To reach \($0.short), exit via \($0.landPort) land port" }.joined(separator: "; ")
        let options = working.map { VisaRoute.TransitOption(short: $0.short, slug: $0.slug) }

        return [VisaRoute(
            kind: .friendly,
            title: "✓ Visa-friendly · add transit stop",
            badge: "All visa-free · +1 city", badgeTone: .ok,
            cities: appCities,
            addedCity: working.map(\.short).joined(separator: " / "),
            addedCitySlug: working.first?.slug,
            transitOptions: options,
            note: """
            For your case: add \(hubNames) as a transit/final stop and the mainland leg qualifies under \(policyName) (all visa-free, one extra city).
            • \(landBullets); or book a flight directly there.
            • Heading to any third country (not your departure country): also visa-free — rebuild the trip with that country as your onward/return leg.
            ⚠️ Stay within \(stayLimit), enter/exit via open ports, and show onward tickets.
            """)]
    }

    /// Stay-limit phrase from the matched policy (hours → "≤ N days", days → "≤ N days"). Keeps the
    /// transit card honest if the CMS ever changes the window.
    private static func stayLimitText(_ policy: VisaPolicyV2?) -> String {
        guard let p = policy, let n = p.maxStayDefault else { return "within the visa-free window" }
        if p.maxStayUnit == "hours" { return "≤ \(n / 24) days" }
        return "≤ \(n) days"
    }

    // MARK: - Drop city: drop blocker cities (engine-verified)

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
            title: "✓ Visa-friendly · drop blocker cities",
            badge: "Drop blockers", badgeTone: .ok,
            cities: keptSlugs, addedCity: nil,
            note: "Remove visa-required cities (\(blockerNames)); remaining cities stay visa-free per engine check.")
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
