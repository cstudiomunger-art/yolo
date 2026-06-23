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

    private var titleZh: String {
        if isGate0 { return "需先换护照 · 后续政策不适用" }
        switch rec.level {
        case .green: return "够用 · 这条线全程免签"
        case .amber: return "有条件够用 · 满足条件即免签"
        case .red: return "不够用 · 默认需办签证"
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
                    if !isGate0, let sheet = rec.chosenSheet { healthSheet(sheet) }
                    if rec.level == .amber { plansCard }
                    if let fresh = rec.freshness { freshnessBadge(fresh) }
                    if !rec.isEnough && !routes.isEmpty {
                        Button { showRoutes = true } label: {
                            Text("看签证友好路线 →")
                                .font(Theme.FontToken.inter(13, weight: .semibold))
                                .frame(maxWidth: .infinity).padding(.vertical, 12)
                                .background(Theme.ColorToken.textPrimary).foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(.plain)
                    }
                    if showRules { rulesDetail }
                    Text("检测器只回答够不够用，不在此盖章收尾。绑卡 / 行前事项在「行前清单」里完成。以边检最终判定为准。")
                        .font(Theme.FontToken.inter(10))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                }
                .padding(Theme.screenPadding)
            }
            .navigationTitle("签证结论")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .confirmationAction) { Button("完成") { dismiss() } } }
            .alert("问真人确认", isPresented: $showHumanNote) {
                Button("好") {}
            } message: {
                Text("可在「实用信息 · Genius Bar」找真人，带着判定结果咨询。")
            }
            .sheet(isPresented: $showRoutes) {
                PlanRouteVisaCompareView(routes: routes)
            }
        }
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
            Text(titleZh).font(Theme.FontToken.playfair(18, weight: .semibold))
            if isGate0 {
                Text("护照剩余有效期不足 6 个月，需先换发护照，后续政策均不再适用。")
                    .font(Theme.FontToken.inter(12)).foregroundStyle(Theme.ColorToken.textSecondary)
            } else {
                Text(chosenPolicy?.officialNameZh ?? rec.chosenPolicyId)
                    .font(Theme.FontToken.inter(12)).foregroundStyle(Theme.ColorToken.textSecondary)
                if let exit = rec.latestExitDate {
                    Text("最晚须于 \(Self.dateLabel(exit)) 前出境。")
                        .font(Theme.FontToken.inter(12)).foregroundStyle(Theme.ColorToken.textSecondary)
                }
                if !rec.alsoEligible.isEmpty {
                    Text("你也符合：" + rec.alsoEligible.map { alsoLabel($0) }.joined(separator: " / ") + "，当前已选限制更少的一条。")
                        .font(Theme.FontToken.inter(11)).foregroundStyle(Theme.ColorToken.textMuted)
                }
                if portZoneOnly {
                    Text("⚠️ 24 小时过境：仅限口岸限定区域活动，出区需办临时入境许可，不可自由前往其他城市。")
                        .font(Theme.FontToken.inter(11)).foregroundStyle(Theme.ColorToken.warning)
                }
                if !rec.blockers.isEmpty {
                    Text("拖累城市：\(rec.blockers.map { data.cityName(forAdminCode: $0) }.joined(separator: " · "))。可在下方方案 A 或「签证友好路线」调整。")
                        .font(Theme.FontToken.inter(11)).foregroundStyle(Theme.ColorToken.warning)
                }
            }
            HStack(spacing: 10) {
                if !isGate0 { actionButton("看规则详情") { showRules.toggle() } }
                actionButton("问真人确认") { showHumanNote = true }
            }
            .padding(.top, 4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(color.opacity(0.08))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(color.opacity(0.4), lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var portZoneOnly: Bool {
        guard let p = chosenPolicy else { return false }
        if case .codes(let a) = p.allowedArea { return a.isEmpty }
        return false
    }

    // MARK: - Policy entry card（依据政策 · 条目）

    /// The concrete policy this verdict rests on — official name (zh/en), the key params
    /// in plain language, the verified date, and the 一级信源 link (source_url, previously
    /// unused on the client) so the result is traceable to the official notice.
    private func policyEntryCard(_ p: VisaPolicyV2) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("依据政策 · 条目").font(Theme.FontToken.inter(12, weight: .semibold))

            VStack(alignment: .leading, spacing: 2) {
                Text(p.officialNameZh).font(Theme.FontToken.inter(14, weight: .semibold))
                if !p.officialNameEn.isEmpty {
                    Text(p.officialNameEn).font(Theme.FontToken.inter(11)).foregroundStyle(Theme.ColorToken.textMuted)
                }
            }

            entryParam("停留", stayText(p))
            entryParam("活动范围", areaText)
            entryParam("计时", clockText(p))
            if let lv = p.lastVerified, !lv.isEmpty {
                entryParam("核验", "核验于 \(lv)")
            }

            if let s = p.sourceUrl, let url = URL(string: s) {
                Link(destination: url) {
                    Text("查看官方公告 →")
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
                .frame(width: 56, alignment: .leading)
            Text(value).font(Theme.FontToken.inter(11, weight: .medium)).foregroundStyle(Theme.ColorToken.textPrimary)
            Spacer(minLength: 0)
        }
    }

    private func stayText(_ p: VisaPolicyV2) -> String {
        if p.maxStayUnit == "hours" { return p.maxStayDefault.map { "\($0) 小时" } ?? "—" }
        return rec.maxStayDays.map { "\($0) 天" } ?? p.maxStayDefault.map { "\($0) 天" } ?? "—"
    }

    private func clockText(_ p: VisaPolicyV2) -> String {
        switch p.clockRule {
        case "by_hour": return "入境精确时刻起算"
        case "entry_day": return "入境当日起算"
        default: return "入境次日 0 时起算"
        }
    }

    private var areaText: String {
        guard let p = chosenPolicy else { return "—" }
        if case .national = p.allowedArea { return "全国（除特别说明区域）" }
        if case .codes(let a) = p.allowedArea { return a.isEmpty ? "仅口岸限定区" : "限 \(a.count) 个指定地区" }
        return "—"
    }

    private func alsoLabel(_ id: String) -> String {
        let p = data.policy(id)
        let stay = p?.maxStayUnit == "days" ? (p?.maxStayDefault).map { "（最长 \($0) 天）" } ?? "" : ""
        return (p?.officialNameZh ?? id) + stay
    }

    // MARK: - Four-dimension health sheet

    private func healthSheet(_ sheet: VisaSheet) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("体检单 · 四维检查").font(Theme.FontToken.inter(12, weight: .semibold))
            checkRow("空间 · 城市可达", ok: sheet.spaceOk,
                     detail: sheet.blockers.isEmpty ? "所选城市均在范围内"
                        : "超界：" + sheet.blockers.map { data.cityName(forAdminCode: $0) }.joined(separator: "、"))
            checkRow("时间 · 停留时长", ok: sheet.timeOk,
                     detail: sheet.timeOk
                        ? (sheet.latestExitDate.map { "最晚 \(Self.dateLabel($0)) 前出境" } ?? "在停留期内")
                        : String(format: "超期约 %.0f 小时，请收紧离境", sheet.overstayHours))
            checkRow("口岸 · 进出口岸", ok: sheet.portOk,
                     detail: sheet.portOk ? "进出口岸均开放" : "入境或出境口岸不在该政策开放清单内")
            checkRow("条件 · 续程/团/第三国", ok: sheet.conditionOk,
                     detail: sheet.conditionOk ? "附加条件已满足"
                        : sheet.conditionReasons.joined(separator: "；"))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Theme.ColorToken.backgroundSubtle)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func checkRow(_ title: String, ok: Bool, detail: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text(ok ? "✅" : "⚠️").font(.system(size: 13))
            VStack(alignment: .leading, spacing: 1) {
                Text(title).font(Theme.FontToken.inter(12, weight: .medium))
                Text(detail).font(Theme.FontToken.inter(10)).foregroundStyle(Theme.ColorToken.textMuted)
            }
            Spacer()
        }
    }

    // MARK: - Amber plans A/B

    private var plansCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("两个方案").font(Theme.FontToken.inter(12, weight: .semibold))
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
                Text("方案 A · 改行程保免签").font(Theme.FontToken.inter(12, weight: .semibold))
                ForEach(swaps.sorted(by: { $0.key < $1.key }), id: \.key) { from, to in
                    Text("· 把「\(data.cityName(forAdminCode: from))」换成「" +
                         (to.map { data.cityName(forAdminCode: $0) } ?? "同省暂无可替代城市") + "」")
                        .font(Theme.FontToken.inter(11)).foregroundStyle(Theme.ColorToken.textSecondary)
                }
                if let newExit {
                    Text("· 把离境收紧到 \(Self.dateLabel(newExit)) 前")
                        .font(Theme.FontToken.inter(11)).foregroundStyle(Theme.ColorToken.textSecondary)
                }
            }
        case .applyVisa:
            VStack(alignment: .leading, spacing: 4) {
                Text("方案 B · 一城不动办 L 签").font(Theme.FontToken.inter(12, weight: .semibold))
                Text("行程不改，办一张 L 旅游签证（约 4–7 个工作日 + 签证费）。")
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
            Text("规则详情").font(Theme.FontToken.inter(12, weight: .semibold))
            Text(rulesText).font(Theme.FontToken.inter(11)).foregroundStyle(Theme.ColorToken.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Theme.ColorToken.backgroundSubtle)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var rulesText: String {
        switch rec.chosenPolicyId {
        case "mutual_exempt": return "互免签证：你的国籍与中国签有互免协议，落地免签，自入境次日起算可连续停留至上限。"
        case "unilateral_30d": return "单方面免签：你的国籍在中国单方面免签清单内，且入境日在适用窗口内，落地免签 30 天（自入境次日 0 时起算）。"
        case "twov_240h": return "240 小时过境免签：下一程为第三国/港澳、从开放口岸进出、停留 ≤ 240 小时即成立；活动范围限指定省市。"
        case "twov_24h": return "24 小时过境免签：世界各国通用，需有续程票去第三国；仅限口岸限定区域活动，出区需办临时入境许可。"
        case "hainan_30d": return "海南区域免签：从海南口岸入境时适用，活动范围限海南省。"
        case "cruise_15d": return "邮轮团免签：随邮轮团从指定港口入境，团进团出，停留 ≤ 15 天，限沿海指定省市。"
        case "group_asean_xsbn": return "东盟旅游团西双版纳免签：东盟国家旅游团从指定口岸入境西双版纳，随团 6 天。"
        case "GATE0": return "护照剩余有效期不足 6 个月，需先换发护照，后续政策均不再适用。"
        default: return "默认需办 L 旅游签证（约 4–7 个工作日 + 签证费）。可在「签证友好路线」看是否能改成免签。L 签停留期/有效期以使馆签注实际为准。"
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
        f.locale = Locale(identifier: "zh_CN")
        f.dateFormat = "M 月 d 日"
        return f.string(from: date)
    }
}
