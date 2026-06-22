import SwiftUI

/// Visa detector: passport (from onboarding) + the engine's hard inputs (departure /
/// onward / entry+exit port / entry+planned-exit datetime / group / ticket / validity) →
/// runs the on-device VisaPolicyEngine over the current trip cities (or a self-test
/// manual city pick that is NOT written back to the real trip).
struct VisaDetectorView: View {
    @Environment(AppEnvironment.self) private var appEnv
    @Environment(\.dismiss) private var dismiss

    @State private var departure = "GB"
    @State private var onward = "GB"
    @State private var entryPort = "PVG"
    @State private var exitPort = "PVG"
    @State private var entryAt = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date()) ?? Date()
    @State private var plannedExitAt = Calendar.current.date(byAdding: .day, value: 12, to: Date()) ?? Date()
    @State private var ticketed = true
    @State private var group = false
    @State private var validity = ValidityChoice.skip

    // Self-test (手动选城市测一测) — local only, never written back to the trip.
    @State private var selfTest = false
    @State private var selfTestCodes: Set<String> = []

    @State private var recommendation: VisaRecommendation?
    @State private var evaluatedCodes: [String] = []
    @State private var routes: [VisaRoute] = []

    private var country: String {
        let c = appEnv.preferences.countryCode
        return (c.isEmpty ? "GB" : c).uppercased()
    }

    private var tripSlugs: [String] { appEnv.preferences.selectedCityIds }

    /// GB/T 2260 codes the engine evaluates (self-test picks are already codes).
    private var activeCodes: [String] {
        selfTest ? Array(selfTestCodes) : appEnv.visaData.adminCodes(forAppSlugs: tripSlugs)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    tripSourceSection
                    passportRow
                    selectorsSection
                    Button(action: runEngine) {
                        Text("开始判定 · 我这条线够用吗")
                            .font(Theme.FontToken.inter(13, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Theme.ColorToken.textPrimary)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .buttonStyle(.plain)
                    .disabled(activeCodes.isEmpty)
                    .opacity(activeCodes.isEmpty ? 0.4 : 1)

                    Text("行程不是输入——地理范围限制是政策的输出。引擎只收能产生确定判决的硬事实，城市来自你的行程。以边检最终判定为准。")
                        .font(Theme.FontToken.inter(10))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                }
                .padding(Theme.screenPadding)
            }
            .navigationTitle("签证检测")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("关闭") { dismiss() } }
            }
            .task { await appEnv.visaData.load() }
            .sheet(item: Binding(get: { recommendation.map { IdentifiedRec(rec: $0) } }, set: { recommendation = $0?.rec })) { wrapped in
                VisaVerdictView(recommendation: wrapped.rec, cityCodes: evaluatedCodes,
                                data: appEnv.visaData.data, routes: routes)
            }
        }
    }

    // MARK: - Sections

    private var tripSourceSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label(selfTest ? "手动试算（不写回行程）" : "正在判定：我的行程",
                      systemImage: selfTest ? "slider.horizontal.3" : "location")
                    .font(Theme.FontToken.inter(13, weight: .semibold))
                Spacer()
                Button(selfTest ? "用我的行程" : "手动选城市测一测") { selfTest.toggle() }
                    .font(Theme.FontToken.inter(11, weight: .medium))
                    .foregroundStyle(Theme.ColorToken.accent)
            }

            if selfTest {
                let options = appEnv.visaData.data.cities
                FlowChips(items: options.map(\.cityId)) { code in
                    Button {
                        if selfTestCodes.contains(code) { selfTestCodes.remove(code) } else { selfTestCodes.insert(code) }
                    } label: {
                        chip(appEnv.visaData.data.cityName(forAdminCode: code), selected: selfTestCodes.contains(code))
                    }
                    .buttonStyle(.plain)
                }
                if selfTestCodes.isEmpty {
                    Text("选几座城市来试算（仅本地，不影响真实行程）")
                        .font(Theme.FontToken.inter(10))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                }
            } else if tripSlugs.isEmpty {
                Text("还没有行程。去 Plan 规划一条，或点上面「手动选城市测一测」。")
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(Theme.ColorToken.textMuted)
            } else {
                FlowChips(items: activeCodes) { code in
                    chip(appEnv.visaData.data.cityName(forAdminCode: code), selected: true)
                }
            }
        }
        .padding(14)
        .background(Theme.ColorToken.backgroundSubtle)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private var passportRow: some View {
        HStack(spacing: 10) {
            Text("🛂").font(.system(size: 22))
            VStack(alignment: .leading, spacing: 1) {
                Text("护照国籍 · \(country)")
                    .font(Theme.FontToken.inter(14, weight: .medium))
                Text("来自 onboarding（在「我的」里修改）")
                    .font(Theme.FontToken.inter(10))
                    .foregroundStyle(Theme.ColorToken.textMuted)
            }
            Spacer()
        }
    }

    private var selectorsSection: some View {
        VStack(spacing: 0) {
            countryMenu(title: "从哪国出发", selection: $departure, includeUndecided: false)
            Divider()
            countryMenu(title: "下一程去哪 / 回哪国", selection: $onward, includeUndecided: true)
            Divider()
            portMenu(title: "入境口岸", selection: $entryPort)
            Divider()
            portMenu(title: "出境口岸", selection: $exitPort)
            Divider()
            datesRow
            Divider()
            toggleRow(title: "已出续程机票", subtitle: "过境免签需要", isOn: $ticketed)
            Divider()
            toggleRow(title: "随旅游团入境", subtitle: "团体/邮轮免签需要", isOn: $group)
            Divider()
            validityRow
        }
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.ColorToken.border, lineWidth: 1))
    }

    private func countryMenu(title: String, selection: Binding<String>, includeUndecided: Bool) -> some View {
        Menu {
            ForEach(VisaDetectorView.countryOptions(includeUndecided: includeUndecided)) { opt in
                Button("\(opt.flag) \(opt.name)") { selection.wrappedValue = opt.code }
            }
        } label: {
            selectorRow(title: title, value: VisaDetectorView.label(for: selection.wrappedValue))
        }
    }

    private func portMenu(title: String, selection: Binding<String>) -> some View {
        Menu {
            ForEach(VisaDetectorView.portOptions) { p in
                Button("\(p.nameZh) · \(p.code)") { selection.wrappedValue = p.code }
            }
        } label: {
            let name = VisaDetectorView.portOptions.first { $0.code == selection.wrappedValue }?.nameZh ?? selection.wrappedValue
            selectorRow(title: title, value: name)
        }
    }

    private var datesRow: some View {
        VStack(spacing: 8) {
            HStack {
                Text("入境日期时间").font(Theme.FontToken.inter(12)).foregroundStyle(Theme.ColorToken.textMuted)
                Spacer()
                DatePicker("", selection: $entryAt, displayedComponents: [.date, .hourAndMinute]).labelsHidden()
            }
            HStack {
                Text("计划离境日期时间").font(Theme.FontToken.inter(12)).foregroundStyle(Theme.ColorToken.textMuted)
                Spacer()
                DatePicker("", selection: $plannedExitAt, displayedComponents: [.date, .hourAndMinute]).labelsHidden()
            }
            Text("24 小时过境免签按入境精确时刻计时；其余按入境次日 0 时起算。")
                .font(Theme.FontToken.inter(9))
                .foregroundStyle(Theme.ColorToken.textMuted)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(14)
    }

    private func toggleRow(title: String, subtitle: String, isOn: Binding<Bool>) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 1) {
                Text(title).font(Theme.FontToken.inter(13, weight: .medium))
                Text(subtitle).font(Theme.FontToken.inter(10)).foregroundStyle(Theme.ColorToken.textMuted)
            }
            Spacer()
            Toggle("", isOn: isOn).labelsHidden()
        }
        .padding(14)
    }

    private var validityRow: some View {
        Menu {
            Button("≥ 6 个月 ✓") { validity = .ok }
            Button("< 6 个月 ⚠️") { validity = .short }
            Button("不确定 / 跳过") { validity = .skip }
        } label: {
            selectorRow(title: "护照剩余有效期（可选）", value: validity.label)
        }
    }

    private func selectorRow(title: String, value: String) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 1) {
                Text(title).font(Theme.FontToken.inter(10)).foregroundStyle(Theme.ColorToken.textMuted)
                Text(value).font(Theme.FontToken.inter(14, weight: .medium)).foregroundStyle(Theme.ColorToken.textPrimary)
            }
            Spacer()
            Image(systemName: "chevron.right").font(.system(size: 12)).foregroundStyle(Theme.ColorToken.textMuted)
        }
        .padding(14)
        .contentShape(Rectangle())
    }

    private func chip(_ text: String, selected: Bool) -> some View {
        Text(selected ? "✓ \(text)" : text)
            .font(Theme.FontToken.inter(12))
            .padding(.horizontal, 12).padding(.vertical, 6)
            .background(selected ? Theme.ColorToken.success.opacity(0.12) : Theme.ColorToken.background)
            .foregroundStyle(selected ? Theme.ColorToken.success : Theme.ColorToken.textPrimary)
            .overlay(Capsule().stroke(selected ? Theme.ColorToken.success : Theme.ColorToken.border, lineWidth: 1))
            .clipShape(Capsule())
    }

    // MARK: - Engine

    private func runEngine() {
        let codes = activeCodes
        let query = VisaQuery(
            countryCode: country,
            departure: departure,
            onward: onward.isEmpty ? nil : onward,
            entryPort: entryPort,
            exitPort: exitPort,
            entryAt: entryAt,
            plannedExitAt: plannedExitAt,
            cities: codes,
            ticketed: ticketed,
            group: group,
            passportValidMonths: validity.months,
            today: Date())
        let rec = appEnv.visaData.evaluate(query)
        let appCities = selfTest
            ? codes.compactMap { appEnv.visaData.data.city(forAdminCode: $0)?.appCitySlug }
            : tripSlugs
        routes = VisaTripChecker.routes(query: query, appCities: appCities,
                                        data: appEnv.visaData.data, recommendation: rec)
        evaluatedCodes = codes
        recommendation = rec
    }

    // MARK: - Options

    enum ValidityChoice { case ok, short, skip
        var months: Int? { switch self { case .ok: return 12; case .short: return 3; case .skip: return nil } }
        var label: String { switch self { case .ok: return "≥ 6 个月 ✓"; case .short: return "< 6 个月 ⚠️"; case .skip: return "不确定 / 跳过" } }
    }

    struct CountryOption: Identifiable { let code: String; let flag: String; let name: String; var id: String { code } }

    static func countryOptions(includeUndecided: Bool) -> [CountryOption] {
        var list: [CountryOption] = [
            .init(code: "GB", flag: "🇬🇧", name: "United Kingdom"),
            .init(code: "US", flag: "🇺🇸", name: "United States"),
            .init(code: "FR", flag: "🇫🇷", name: "France"),
            .init(code: "DE", flag: "🇩🇪", name: "Germany"),
            .init(code: "SG", flag: "🇸🇬", name: "Singapore"),
            .init(code: "JP", flag: "🇯🇵", name: "Japan"),
            .init(code: "HK", flag: "🇭🇰", name: "Hong Kong"),
            .init(code: "MO", flag: "🇲🇴", name: "Macao"),
        ]
        if includeUndecided { list.append(.init(code: "", flag: "❓", name: "还没定")) }
        return list
    }

    static func label(for code: String) -> String {
        if code.isEmpty { return "❓ 还没定" }
        if let opt = countryOptions(includeUndecided: false).first(where: { $0.code == code }) {
            return "\(opt.flag) \(opt.name)"
        }
        return code
    }

    struct PortOption: Identifiable { let code: String; let nameZh: String; var id: String { code } }

    /// Curated major international entry/exit ports (IATA). Engine matches by code.
    static let portOptions: [PortOption] = [
        .init(code: "PEK", nameZh: "北京首都机场"),
        .init(code: "PKX", nameZh: "北京大兴机场"),
        .init(code: "PVG", nameZh: "上海浦东机场"),
        .init(code: "SHA", nameZh: "上海虹桥机场"),
        .init(code: "CAN", nameZh: "广州白云机场"),
        .init(code: "SZX", nameZh: "深圳宝安机场"),
        .init(code: "CTU", nameZh: "成都天府机场"),
        .init(code: "XIY", nameZh: "西安咸阳机场"),
        .init(code: "HGH", nameZh: "杭州萧山机场"),
        .init(code: "CKG", nameZh: "重庆江北机场"),
        .init(code: "HAK", nameZh: "海口美兰机场"),
        .init(code: "SYX", nameZh: "三亚凤凰机场"),
        .init(code: "JHG", nameZh: "西双版纳机场"),
    ]
}

private struct IdentifiedRec: Identifiable {
    let id = UUID()
    let rec: VisaRecommendation
}

/// Minimal wrapping flow layout for chips (avoids LazyVGrid sizing for short lists).
private struct FlowChips<Item: Hashable, Content: View>: View {
    let items: [Item]
    @ViewBuilder let content: (Item) -> Content

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80), spacing: 8, alignment: .leading)], alignment: .leading, spacing: 8) {
            ForEach(items, id: \.self) { content($0) }
        }
    }
}
