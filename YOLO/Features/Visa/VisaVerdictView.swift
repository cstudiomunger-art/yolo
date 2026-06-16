import SwiftUI

/// Visa verdict card: enough / not-enough + the chosen policy, day calculator, blockers.
/// The detector only answers "is this line enough" — it does not finalize prep here.
struct VisaVerdictView: View {
    @Environment(\.dismiss) private var dismiss
    let verdict: VisaVerdict
    let cities: [String]

    @State private var showRules = false
    @State private var showHumanNote = false

    private var color: Color {
        switch verdict.color {
        case .green: return Theme.ColorToken.success
        case .amber: return Theme.ColorToken.warning
        case .red: return Theme.ColorToken.warning
        }
    }

    private var titleZh: String {
        if verdict.color == .green && verdict.blockers.isEmpty { return "够用 · 这条线全程免签" }
        if verdict.color == .amber && verdict.blockers.isEmpty { return "有条件够用 · 满足条件即免签" }
        return "不够用 · 默认需办签证"
    }

    private var icon: String {
        switch verdict.color {
        case .green: return "✅"
        case .amber: return "⚠️"
        case .red: return "⚠️"
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    citiesChips
                    verdictCard
                    if showRules { rulesDetail }
                    Text("检测器只回答够不够用，不在此盖章收尾。绑卡 / 行前事项在「行前清单」里完成。")
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
                Text("Genius Bar 真人客服即将上线；上线后这里会带着判定结果直接转接。")
            }
        }
    }

    private var citiesChips: some View {
        let blockerSet = Set(verdict.blockers.map { $0.lowercased() })
        return LazyVGrid(columns: [GridItem(.adaptive(minimum: 80), spacing: 8, alignment: .leading)], alignment: .leading, spacing: 8) {
            ForEach(cities, id: \.self) { city in
                let blocked = blockerSet.contains(city.lowercased())
                Text((blocked ? "" : "✓ ") + city.capitalized)
                    .font(Theme.FontToken.inter(12))
                    .padding(.horizontal, 12).padding(.vertical, 6)
                    .foregroundStyle(blocked ? Theme.ColorToken.warning : Theme.ColorToken.success)
                    .overlay(Capsule().stroke(blocked ? Theme.ColorToken.warning : Theme.ColorToken.success, lineWidth: 1))
            }
        }
    }

    private var verdictCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(icon).font(.system(size: 30))
            Text(titleZh).font(Theme.FontToken.playfair(18, weight: .semibold))
            Text(verdict.headlineZh)
                .font(Theme.FontToken.inter(12))
                .foregroundStyle(Theme.ColorToken.textSecondary)
            if let exit = verdict.latestExitDate {
                Text("最晚须于 \(Self.dateLabel(exit)) 前出境。")
                    .font(Theme.FontToken.inter(12))
                    .foregroundStyle(Theme.ColorToken.textSecondary)
            }
            metaLine
            if !verdict.secondaryMatches.isEmpty {
                Text("你也符合 \(verdict.secondaryMatches.joined(separator: " / "))，但当前政策限制更少。")
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(Theme.ColorToken.textMuted)
            }
            if !verdict.blockers.isEmpty {
                Text("拖累城市：\(verdict.blockers.map { $0.capitalized }.joined(separator: " · "))。可在 Plan 里看「签证友好路线」调整。")
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(Theme.ColorToken.warning)
            }
            HStack(spacing: 10) {
                actionButton("看规则详情") { showRules.toggle() }
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

    private var metaLine: some View {
        Text("policy = \(verdict.policyKey) · "
             + (verdict.maxStayDays.map { "max_stay = \($0)d · " } ?? "")
             + "area = \(verdict.areaScope)")
            .font(.system(size: 10, design: .monospaced))
            .foregroundStyle(Theme.ColorToken.textMuted)
            .padding(.top, 2)
    }

    private var rulesDetail: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("规则详情").font(Theme.FontToken.inter(12, weight: .semibold))
            Text(rulesText)
                .font(Theme.FontToken.inter(11))
                .foregroundStyle(Theme.ColorToken.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Theme.ColorToken.backgroundSubtle)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var rulesText: String {
        switch verdict.policyKey {
        case "P1": return "互免协定：你的国籍与中国签有互免协议，落地免签，无需办理。"
        case "P2": return "单方面免签：你的国籍在中国单方面免签清单内，且入境日在适用窗口内，落地免签 30 天。"
        case "P3": return "240 小时过境免签：下一程为第三国/港澳、从开放口岸进出、停留 ≤ 240 小时即成立；活动范围限过境区域。"
        case "P4": return "海南区域免签：从海南口岸入境时适用，活动范围限海南。"
        case "GATE0": return "护照剩余有效期不足 6 个月，需先换发护照，后续政策均不再适用。"
        default: return "默认需办 L 旅游签证（约 4–7 个工作日 + 签证费）。可在 Plan 看「签证友好路线」是否能改成免签。"
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
