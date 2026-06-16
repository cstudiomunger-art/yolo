import SwiftUI

/// Visa detector: passport (from onboarding) + four selectors + optional validity →
/// runs the on-device VisaPolicyEngine over the current trip cities (or a self-test
/// manual city pick that is NOT written back to the real trip).
struct VisaDetectorView: View {
    @Environment(AppEnvironment.self) private var appEnv
    @Environment(\.dismiss) private var dismiss

    @State private var departure = "GB"
    @State private var onward = "GB"
    @State private var entryPortId: String?
    @State private var stayDays = 12
    @State private var entryDate = Date()
    @State private var validity = ValidityChoice.skip

    // Self-test (手动选城市测一测) — local only, never written back to the trip.
    @State private var selfTest = false
    @State private var selfTestCities: Set<String> = []

    @State private var verdict: VisaVerdict?

    private var country: String { (appEnv.preferences.countryCode ?? "GB").uppercased() }

    private var tripCities: [String] { appEnv.preferences.selectedCityIds }

    private var activeCities: [String] {
        selfTest ? Array(selfTestCities) : tripCities
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
                    .disabled(activeCities.isEmpty)
                    .opacity(activeCities.isEmpty ? 0.4 : 1)

                    Text("行程不是输入——地理范围限制是政策的输出。引擎只收能产生确定判决的硬事实，城市来自你的行程。")
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
            .sheet(item: Binding(get: { verdict.map { IdentifiedVerdict(verdict: $0) } }, set: { verdict = $0?.verdict })) { wrapped in
                VisaVerdictView(verdict: wrapped.verdict, cities: activeCities)
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
                Button(selfTest ? "用我的行程" : "手动选城市测一测") {
                    selfTest.toggle()
                }
                .font(Theme.FontToken.inter(11, weight: .medium))
                .foregroundStyle(Theme.ColorToken.accent)
            }

            if selfTest {
                let options = appEnv.visaData.data.cityTags.map(\.cityId)
                FlowChips(items: options.isEmpty ? tripCities : options) { city in
                    Button {
                        if selfTestCities.contains(city) { selfTestCities.remove(city) } else { selfTestCities.insert(city) }
                    } label: {
                        chip(city.capitalized, selected: selfTestCities.contains(city))
                    }
                    .buttonStyle(.plain)
                }
                if selfTestCities.isEmpty {
                    Text("选几座城市来试算（仅本地，不影响真实行程）")
                        .font(Theme.FontToken.inter(10))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                }
            } else if tripCities.isEmpty {
                Text("还没有行程。去 Plan 规划一条，或点上面「手动选城市测一测」。")
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(Theme.ColorToken.textMuted)
            } else {
                FlowChips(items: tripCities) { city in
                    chip(city.capitalized, selected: true)
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
            portMenu
            Divider()
            countryMenu(title: "下一程去哪 / 回哪国", selection: $onward, includeUndecided: true)
            Divider()
            stayRow
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

    private var portMenu: some View {
        Menu {
            ForEach(appEnv.visaData.data.ports) { port in
                Button(port.nameZh) { entryPortId = port.portId }
            }
        } label: {
            let name = appEnv.visaData.data.ports.first { $0.portId == entryPortId }?.nameZh ?? "选择口岸"
            selectorRow(title: "入境口岸", value: name)
        }
    }

    private var stayRow: some View {
        VStack(spacing: 8) {
            HStack {
                Text("入境日期").font(Theme.FontToken.inter(12)).foregroundStyle(Theme.ColorToken.textMuted)
                Spacer()
                DatePicker("", selection: $entryDate, displayedComponents: .date)
                    .labelsHidden()
            }
            HStack {
                Text("停留天数").font(Theme.FontToken.inter(12)).foregroundStyle(Theme.ColorToken.textMuted)
                Spacer()
                Stepper("\(stayDays) 天", value: $stayDays, in: 1...180)
                    .font(Theme.FontToken.inter(13, weight: .medium))
                    .fixedSize()
            }
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
        let query = VisaQuery(
            countryCode: country,
            departureCode: departure,
            onwardCode: onward.isEmpty ? nil : onward,
            onwardTicketed: true,
            entryPortId: entryPortId,
            stayDays: stayDays,
            entryDate: entryDate,
            passportValidMonths: validity.months,
            cities: activeCities
        )
        verdict = appEnv.visaData.evaluate(query)
    }

    // MARK: - Country options

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
}

private struct IdentifiedVerdict: Identifiable {
    let id = UUID()
    let verdict: VisaVerdict
}

/// Minimal wrapping flow layout for chips (avoids LazyVGrid sizing for short lists).
private struct FlowChips<Item: Hashable, Content: View>: View {
    let items: [Item]
    @ViewBuilder let content: (Item) -> Content

    var body: some View {
        // Simple wrapping via adaptive grid.
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80), spacing: 8, alignment: .leading)], alignment: .leading, spacing: 8) {
            ForEach(items, id: \.self) { content($0) }
        }
    }
}
