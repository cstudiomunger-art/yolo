import SwiftUI

/// Visa verdict card driven by the verified engine's `VisaRecommendation`: tri-colour
/// verdict + four-dimension health sheet, also-eligible policies, amber plan A/B, and a
/// freshness badge. The detector only answers "is this line enough" — prep happens later.
struct VisaVerdictView: View {
    @Environment(\.dismiss) private var dismiss
    let recommendation: VisaRecommendation
    let cityCodes: [String]            // GB/T 2260 codes evaluated
    let data: VisaDataSet
    var routes: [VisaRoute] = []

    @State private var showRules = false
    @State private var showHumanNote = false
    @State private var showRoutes = false

    private var rec: VisaRecommendation { recommendation }
    private var isGate0: Bool { rec.chosenPolicyId == "GATE0" }
    private var chosenPolicy: VisaPolicyV2? { data.policy(rec.chosenPolicyId) }

    private var color: Color {
        switch rec.level {
        case .green: return Theme.ColorToken.success
        case .amber, .red: return Theme.ColorToken.warning
        }
    }

    private var titleText: String {
        if isGate0 { return "Renew passport first · policies below don't apply" }
        switch rec.level {
        case .green: return "Good to go · fully visa-free on this route"
        case .amber: return "Conditionally OK · visa-free if conditions met"
        case .red: return "Not enough · visa likely required"
        }
    }

    private var icon: String { rec.level == .green ? "✅" : "⚠️" }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if !isGate0 { citiesChips }
                    verdictCard
                    if !isGate0, let policy = chosenPolicy { policyEntryCard(policy) }
                    if rec.level == .amber { plansCard }
                    if let fresh = rec.freshness { freshnessBadge(fresh) }
                    if !rec.isEnough && !routes.isEmpty {
                        Button { showRoutes = true } label: {
                            Text("View visa-friendly routes →")
                                .font(Theme.FontToken.inter(13, weight: .semibold))
                                .frame(maxWidth: .infinity).padding(.vertical, 12)
                                .background(Theme.ColorToken.textPrimary).foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(.plain)
                    }
                    if showRules { rulesDetail }
                    Text("This check only answers whether your route qualifies; it does not finalize paperwork. Card binding and pre-trip tasks belong in your Pre-Trip Checklist. Subject to final decision at border control.")
                        .font(Theme.FontToken.inter(10))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                }
                .padding(Theme.screenPadding)
            }
            .navigationTitle("Visa Verdict")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .confirmationAction) { Button("Done") { dismiss() } } }
            .alert("Confirm with an expert", isPresented: $showHumanNote) {
                Button("OK") {}
            } message: {
                Text("Find a live expert under Practical Info · Genius Bar and bring this verdict with you.")
            }
            .sheet(isPresented: $showRoutes) {
                PlanRouteVisaCompareView(routes: routes)
            }
        }
        .sheetDragToDismiss()
    }

    // MARK: - Cities

    private var citiesChips: some View {
        let blockerSet = Set(rec.blockers)
        return LazyVGrid(columns: [GridItem(.adaptive(minimum: 84), spacing: 8, alignment: .leading)], alignment: .leading, spacing: 8) {
            ForEach(cityCodes, id: \.self) { code in
                let blocked = blockerSet.contains(code)
                Text((blocked ? "" : "✓ ") + data.cityName(forAdminCode: code))
                    .font(Theme.FontToken.inter(12))
                    .padding(.horizontal, 12).padding(.vertical, 6)
                    .foregroundStyle(blocked ? Theme.ColorToken.warning : Theme.ColorToken.success)
                    .overlay(Capsule().stroke(blocked ? Theme.ColorToken.warning : Theme.ColorToken.success, lineWidth: 1))
            }
        }
    }

    // MARK: - Verdict card

    private var verdictCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(icon).font(.system(size: 30))
            Text(titleText).font(Theme.FontToken.playfair(18, weight: .semibold))
            if isGate0 {
                Text("Passport valid for less than 6 months. Renew your passport first; policies below will not apply.")
                    .font(Theme.FontToken.inter(12)).foregroundStyle(Theme.ColorToken.textSecondary)
            } else {
                policyNameBlock(chosenPolicy, fallback: rec.chosenPolicyId)
                if let exit = rec.latestExitDate {
                    Text("Must exit by \(Self.dateLabel(exit)).")
                        .font(Theme.FontToken.inter(12)).foregroundStyle(Theme.ColorToken.textSecondary)
                }
                if !rec.alsoEligible.isEmpty {
                    Text("You also qualify for: " + rec.alsoEligible.map { alsoLabel($0) }.joined(separator: " / ") + ". The least restrictive option was selected.")
                        .font(Theme.FontToken.inter(11)).foregroundStyle(Theme.ColorToken.textMuted)
                }
                if portZoneOnly {
                    Text("⚠️ 24-hour transit: activity limited to the port zone. Leaving the zone requires a temporary entry permit; you cannot freely visit other cities.")
                        .font(Theme.FontToken.inter(11)).foregroundStyle(Theme.ColorToken.warning)
                }
                if !rec.blockers.isEmpty {
                    Text("Cities holding you back: \(rec.blockers.map { data.cityName(forAdminCode: $0) }.joined(separator: " · ")). Adjust in Plan A below or via visa-friendly routes.")
                        .font(Theme.FontToken.inter(11)).foregroundStyle(Theme.ColorToken.warning)
                }
            }
            HStack(spacing: 10) {
                if !isGate0 { actionButton("View rule details") { showRules.toggle() } }
                actionButton("Confirm with an expert") { showHumanNote = true }
            }
            .padding(.top, 4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(color.opacity(0.08))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(color.opacity(0.4), lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    @ViewBuilder
    private func policyNameBlock(_ policy: VisaPolicyV2?, fallback: String) -> some View {
        if let en = policy?.officialNameEn, !en.isEmpty {
            Text(en).font(Theme.FontToken.inter(12)).foregroundStyle(Theme.ColorToken.textSecondary)
            if let zh = policy?.officialNameZh, !zh.isEmpty {
                Text(zh).font(Theme.FontToken.inter(11)).foregroundStyle(Theme.ColorToken.textMuted)
            }
        } else {
            Text(policy?.officialNameZh ?? fallback)
                .font(Theme.FontToken.inter(12)).foregroundStyle(Theme.ColorToken.textSecondary)
        }
    }

    private var portZoneOnly: Bool {
        guard let p = chosenPolicy else { return false }
        if case .codes(let a) = p.allowedArea { return a.isEmpty }
        return false
    }

    // MARK: - Policy entry card

    /// The concrete policy this verdict rests on — official name (en/zh), the key params
    /// in plain language, the verified date, and the primary-source link (source_url) so
    /// the result is traceable to the official notice.
    private func policyEntryCard(_ p: VisaPolicyV2) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Policy basis").font(Theme.FontToken.inter(12, weight: .semibold))

            VStack(alignment: .leading, spacing: 2) {
                if !p.officialNameEn.isEmpty {
                    Text(p.officialNameEn).font(Theme.FontToken.inter(14, weight: .semibold))
                    if !p.officialNameZh.isEmpty {
                        Text(p.officialNameZh).font(Theme.FontToken.inter(11)).foregroundStyle(Theme.ColorToken.textMuted)
                    }
                } else {
                    Text(p.officialNameZh).font(Theme.FontToken.inter(14, weight: .semibold))
                }
            }

            entryParam("Stay", stayText(p))
            entryParam("Allowed area", areaText)
            entryParam("Clock", clockText(p))
            if let ec = entryCountText(p) { entryParam("Entries", ec) }
            if let pp = purposeText(p) { entryParam("Purpose", pp) }
            if p.passportOrdinaryOnly == true { entryParam("Passport", "Ordinary passport only") }
            if let lv = p.lastVerified, !lv.isEmpty {
                entryParam("Verified", "Verified \(lv)")
            }

            if let s = p.sourceUrl, let url = URL(string: s) {
                Link(destination: url) {
                    Text("View official notice →")
                        .font(Theme.FontToken.inter(11, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 9)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.ColorToken.textPrimary, lineWidth: 1))
                }
                .buttonStyle(.plain)
                .padding(.top, 2)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Theme.ColorToken.backgroundSubtle)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func entryParam(_ label: String, _ value: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text(label).font(Theme.FontToken.inter(11)).foregroundStyle(Theme.ColorToken.textMuted)
                .frame(width: 72, alignment: .leading)
            Text(value).font(Theme.FontToken.inter(11, weight: .medium)).foregroundStyle(Theme.ColorToken.textPrimary)
            Spacer(minLength: 0)
        }
    }

    private func stayText(_ p: VisaPolicyV2) -> String {
        if p.maxStayUnit == "hours" { return p.maxStayDefault.map { "\($0) hours" } ?? "—" }
        return rec.maxStayDays.map { "\($0) days" } ?? p.maxStayDefault.map { "\($0) days" } ?? "—"
    }

    private func clockText(_ p: VisaPolicyV2) -> String {
        switch p.clockRule {
        case "by_hour": return "Counted from exact entry time"
        case "entry_day": return "Counted from day of entry"
        default: return "Counted from midnight after entry day"
        }
    }

    private func entryCountText(_ p: VisaPolicyV2) -> String? {
        switch p.entryCount {
        case "single": return "Single entry"
        case "double": return "Two entries"
        case "multiple": return "Multiple entries"
        case "per_entry": return "Counted per entry"
        default: return nil
        }
    }

    private func purposeText(_ p: VisaPolicyV2) -> String? {
        guard let purpose = p.purpose, !purpose.isEmpty else { return nil }
        let map = ["tourism": "Tourism", "business": "Business", "transit": "Transit", "family": "Family visit"]
        return purpose.map { map[$0] ?? $0 }.joined(separator: " · ")
    }

    private var areaText: String {
        guard let p = chosenPolicy else { return "—" }
        if case .national = p.allowedArea { return "Nationwide (except specially noted areas)" }
        if case .codes(let a) = p.allowedArea { return a.isEmpty ? "Port zone only" : "Limited to \(a.count) designated areas" }
        return "—"
    }

    private func alsoLabel(_ id: String) -> String {
        let p = data.policy(id)
        let stay = p?.maxStayUnit == "days" ? (p?.maxStayDefault).map { " (up to \($0) days)" } ?? "" : ""
        let name = {
            guard let p else { return id }
            if !p.officialNameEn.isEmpty { return p.officialNameEn }
            return p.officialNameZh
        }()
        return name + stay
    }

    // MARK: - Amber plans A/B

    private var plansCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Two options").font(Theme.FontToken.inter(12, weight: .semibold))
            ForEach(rec.plans) { plan in planRow(plan) }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.ColorToken.border, lineWidth: 1))
    }

    @ViewBuilder
    private func planRow(_ plan: VisaPlan) -> some View {
        switch plan {
        case .modify(_, let swaps, let newExit):
            VStack(alignment: .leading, spacing: 4) {
                Text("Plan A · Adjust itinerary to stay visa-free").font(Theme.FontToken.inter(12, weight: .semibold))
                ForEach(swaps.sorted(by: { $0.key < $1.key }), id: \.key) { from, to in
                    Text("· Replace \(data.cityName(forAdminCode: from)) with " +
                         (to.map { data.cityName(forAdminCode: $0) } ?? "no in-province alternative"))
                        .font(Theme.FontToken.inter(11)).foregroundStyle(Theme.ColorToken.textSecondary)
                }
                if let newExit {
                    Text("· Move exit date up to before \(Self.dateLabel(newExit))")
                        .font(Theme.FontToken.inter(11)).foregroundStyle(Theme.ColorToken.textSecondary)
                }
            }
        case .applyVisa:
            VStack(alignment: .leading, spacing: 4) {
                Text("Plan B · Keep cities, apply for L visa").font(Theme.FontToken.inter(12, weight: .semibold))
                Text("Keep your itinerary; apply for an L tourist visa (about 4–7 business days plus visa fee).")
                    .font(Theme.FontToken.inter(11)).foregroundStyle(Theme.ColorToken.textSecondary)
            }
        }
    }

    // MARK: - Freshness

    private func freshnessBadge(_ fresh: VisaFreshness) -> some View {
        let warn = fresh.level == .expiring || fresh.level == .expired || fresh.level == .stale
        return HStack(alignment: .top, spacing: 6) {
            Text(warn ? "🟡" : "🟢").font(.system(size: 11))
            Text(fresh.message).font(Theme.FontToken.inter(10))
                .foregroundStyle(warn ? Theme.ColorToken.warning : Theme.ColorToken.textMuted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background((warn ? Theme.ColorToken.warning : Theme.ColorToken.textMuted).opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    // MARK: - Rules

    private var rulesDetail: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Rule details").font(Theme.FontToken.inter(12, weight: .semibold))
            Text(rulesText).font(Theme.FontToken.inter(11)).foregroundStyle(Theme.ColorToken.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Theme.ColorToken.backgroundSubtle)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var rulesText: String {
        switch rec.chosenPolicyId {
        case "mutual_exempt":
            return "Mutual visa exemption: your nationality has a mutual exemption agreement with China. Visa-free on arrival; continuous stay from the day after entry up to the limit."
        case "unilateral_30d":
            return "Unilateral visa waiver: your nationality is on China's unilateral waiver list and entry falls within the applicable window. Visa-free for 30 days (from midnight after the day of entry)."
        case "twov_240h":
            return "240-hour transit waiver: valid when your next destination is a third country or Hong Kong/Macau, you enter/exit via an eligible port, and stay ≤ 240 hours; activity limited to designated provinces/cities."
        case "twov_24h":
            return "24-hour transit waiver: available to all nationalities with onward tickets to a third country; activity limited to the port zone; leaving the zone requires a temporary entry permit."
        case "hainan_30d":
            return "Hainan regional waiver: applies when entering via a Hainan port; activity limited to Hainan Province."
        case "cruise_15d":
            return "Cruise group waiver: enter with a cruise group at designated ports, group travel in/out, stay ≤ 15 days, limited to designated coastal provinces/cities."
        case "group_asean_xsbn":
            return "ASEAN tour group Xishuangbanna waiver: ASEAN tour groups enter Xishuangbanna via designated ports, 6 days with the group."
        case "GATE0":
            return "Passport valid for less than 6 months. Renew your passport first; policies below will not apply."
        default:
            return "L tourist visa likely required (about 4–7 business days plus fee). See visa-friendly routes to see if you can switch to visa-free. L visa stay/validity per embassy stamp. Subject to final decision at border control."
        }
    }

    private func actionButton(_ title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(Theme.FontToken.inter(11, weight: .medium))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .overlay(RoundedRectangle(cornerRadius: 11).stroke(Theme.ColorToken.textPrimary, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }

    private static func dateLabel(_ date: Date) -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US")
        f.dateFormat = "MMM d"
        return f.string(from: date)
    }
}
