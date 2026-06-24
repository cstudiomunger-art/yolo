import SwiftUI

/// Visa detector: passport (from onboarding) + the engine's hard inputs (departure /
/// onward / entry+exit port / entry+planned-exit datetime / group / ticket / validity) →
/// runs the on-device VisaPolicyEngine over the current trip cities (or a self-test
/// manual city pick that is NOT written back to the real trip).
struct VisaDetectorView: View {
    @Environment(AppEnvironment.self) private var appEnv
    @Environment(\.dismiss) private var dismiss

    /// When opened from the Plan hint banner: judge this specific trip (cities + dates).
    /// nil = use the user's current selection. All other inputs stay editable.
    var presetCitySlugs: [String]? = nil
    var presetStart: Date? = nil
    var presetEnd: Date? = nil
    @State private var presetsApplied = false

    @State private var departure = ""   // defaults to passport country on appear
    @State private var onward = ""       // empty = 还没定 (undecided)
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
    @State private var showCityPicker = false

    @State private var verdict: IdentifiedRec?
    @State private var evaluatedCodes: [String] = []
    @State private var routes: [VisaRoute] = []

    // Full global country list (all 249 ISO 3166-1 entries, Chinese names) — covers every
    // country, not just the ~90 visa-relevant nationalities in `passport_countries`.
    private let countries: [PassportCountry] = ISO3166.all
    @State private var editingCountry: CountryField?
    @State private var editingPort: PortField?
    @State private var editingPassport = false

    private var country: String {
        let c = appEnv.preferences.countryCode
        return (c.isEmpty ? "GB" : c).uppercased()
    }

    /// Only a Plan preset or a saved itinerary counts as a real trip. Without one we must
    /// NOT pass off the leftover global `selectedCityIds` as "我的行程" — show the empty state.
    private var hasRealTrip: Bool {
        presetCitySlugs != nil || !appEnv.preferences.savedItineraries.isEmpty
    }

    private var tripSlugs: [String] {
        if let preset = presetCitySlugs { return preset }
        return hasRealTrip ? appEnv.preferences.selectedCityIds : []
    }

    private var tripSourceTitle: String {
        if selfTest { return "手动试算（不写回行程）" }
        return hasRealTrip ? "正在判定：我的行程" : "还没有行程"
    }

    /// GB/T 2260 codes the engine evaluates (self-test picks are already codes).
    private var activeCodes: [String] {
        selfTest ? Array(selfTestCodes) : appEnv.visaData.adminCodes(forAppSlugs: tripSlugs)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    tripSourceSection
                    passportCard
                    selectorsSection
                    ctaButton

                    Text("行程不是输入——地理范围限制是政策的输出。引擎只收能产生确定判决的硬事实，城市来自你的行程。以边检最终判定为准。")
                        .font(Theme.FontToken.inter(10))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                        .padding(.top, 2)
                }
                .padding(.horizontal, Theme.screenPadding)
                .padding(.vertical, 20)
            }
            .navigationTitle("签证检测")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("关闭") { dismiss() } }
            }
            .task { await appEnv.visaData.load() }
            .onAppear {
                guard !presetsApplied else { return }
                presetsApplied = true
                if departure.isEmpty { departure = country }   // default from passport
                if let s = presetStart {
                    entryAt = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: s) ?? s
                }
                if let e = presetEnd { plannedExitAt = e }
            }
            .sheet(item: $verdict) { wrapped in
                VisaVerdictView(recommendation: wrapped.rec, cityCodes: evaluatedCodes,
                                data: appEnv.visaData.data, routes: routes)
            }
        }
    }

    // MARK: - Sections

    private var tripSourceSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label(tripSourceTitle,
                      systemImage: selfTest ? "slider.horizontal.3" : (hasRealTrip ? "location" : "questionmark.circle"))
                    .font(Theme.FontToken.inter(13, weight: .semibold))
                Spacer()
                Button(selfTest ? "用我的行程" : "手动选城市测一测") { selfTest.toggle() }
                    .font(Theme.FontToken.inter(11, weight: .medium))
                    .foregroundStyle(Theme.ColorToken.accent)
            }

            if selfTest {
                Button { showCityPicker = true } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 1) {
                            Text("测算城市").font(Theme.FontToken.inter(10)).foregroundStyle(Theme.ColorToken.textMuted)
                            Text(selfTestCodes.isEmpty ? "点此选择城市" : selfTestSummary)
                                .font(Theme.FontToken.inter(14, weight: .medium))
                                .foregroundStyle(selfTestCodes.isEmpty ? Theme.ColorToken.textMuted : Theme.ColorToken.textPrimary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right").font(.system(size: 12)).foregroundStyle(Theme.ColorToken.textMuted)
                    }
                    .padding(.vertical, 4)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)

                if selfTestCodes.isEmpty {
                    Text("选几座城市来试算（仅本地，不影响真实行程）")
                        .font(Theme.FontToken.inter(10))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                } else {
                    FlowChips(items: selfTestCodes.sorted()) { code in
                        Button { selfTestCodes.remove(code) } label: {
                            chip(appEnv.visaData.data.cityName(forAdminCode: code), selected: true)
                        }
                        .buttonStyle(.plain)
                    }
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
        .sheet(isPresented: $showCityPicker) {
            CitySelectSheet(cities: appEnv.visaData.data.cities, selected: $selfTestCodes)
        }
    }

    private var selfTestSummary: String {
        let names = selfTestCodes.sorted().map { appEnv.visaData.data.cityName(forAdminCode: $0) }
        return names.count <= 3 ? names.joined(separator: " · ") : "已选 \(names.count) 城"
    }

    private var ctaButton: some View {
        let ready = !activeCodes.isEmpty
        return Button(action: runEngine) {
            HStack(spacing: 8) {
                Image(systemName: "checkmark.seal.fill").font(.system(size: 14))
                Text("开始判定 · 我这条线够用吗")
                    .font(Theme.FontToken.inter(14, weight: .semibold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Theme.ColorToken.textPrimary)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .shadow(color: Theme.ColorToken.textPrimary.opacity(ready ? 0.18 : 0), radius: 10, y: 4)
        }
        .buttonStyle(.plain)
        .disabled(!ready)
        .opacity(ready ? 1 : 0.35)
    }

    private var passportCard: some View {
        Button { editingPassport = true } label: {
            HStack(spacing: 12) {
                Text("🛂").font(.system(size: 20))
                    .frame(width: 40, height: 40)
                    .background(Theme.ColorToken.accent.opacity(0.14))
                    .clipShape(RoundedRectangle(cornerRadius: 11))
                VStack(alignment: .leading, spacing: 2) {
                    Text("护照国籍 · \(countryLabel(country))")
                        .font(Theme.FontToken.inter(14, weight: .semibold))
                        .foregroundStyle(Theme.ColorToken.textPrimary)
                    Text("点此修改护照国籍（同步到「我的」）")
                        .font(Theme.FontToken.inter(10))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                }
                Spacer()
                Image(systemName: "chevron.right").font(.system(size: 12)).foregroundStyle(Theme.ColorToken.textMuted)
            }
            .padding(12)
            .background(Theme.ColorToken.backgroundSubtle)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $editingPassport) {
            CountrySelectSheet(
                title: "护照国籍",
                countries: countries,
                includeUndecided: false,
                selected: country
            ) { code in
                appEnv.preferences.countryCode = code
                editingPassport = false
                Task {
                    await appEnv.refreshVisaRule()
                    await appEnv.profileSync.pushToRemote()
                }
            }
        }
    }

    /// A captioned, bordered group of rows — gives the long form scannable hierarchy.
    private func groupCard<C: View>(_ caption: String, @ViewBuilder _ content: () -> C) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(caption)
                .font(Theme.FontToken.inter(11, weight: .semibold))
                .foregroundStyle(Theme.ColorToken.textSecondary)
                .padding(.leading, 2)
            VStack(spacing: 0) { content() }
                .background(Theme.ColorToken.background)
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.ColorToken.border, lineWidth: 1))
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }

    private var selectorsSection: some View {
        VStack(spacing: 18) {
            groupCard("路线 · 从哪来、到哪去") {
                countryRow(title: "从哪国出发", field: .departure, code: departure)
                Divider()
                countryRow(title: "下一程去哪 / 回哪国", field: .onward, code: onward)
                Divider()
                portRow(title: "入境口岸", field: .entry, code: entryPort)
                    .sheet(item: $editingPort) { field in
                        PortSelectSheet(
                            title: field.title,
                            ports: availablePorts,
                            selected: field == .entry ? entryPort : exitPort
                        ) { code in
                            if field == .entry { entryPort = code } else { exitPort = code }
                            editingPort = nil
                        }
                    }
                Divider()
                portRow(title: "出境口岸", field: .exit, code: exitPort)
            }
            .sheet(item: $editingCountry) { field in
                CountrySelectSheet(
                    title: field.title,
                    countries: countries,
                    includeUndecided: field == .onward,
                    selected: field == .departure ? departure : onward
                ) { code in
                    if field == .departure { departure = code } else { onward = code }
                    editingCountry = nil
                }
            }

            groupCard("时间 · 进出时刻") { datesRow }

            groupCard("条件 · 影响免签的开关") {
                toggleRow(title: "已出续程机票", subtitle: "过境免签需要", isOn: $ticketed)
                Divider()
                toggleRow(title: "随旅游团入境", subtitle: "团体/邮轮免签需要", isOn: $group)
                Divider()
                validityRow
            }
        }
    }

    private func countryRow(title: String, field: CountryField, code: String) -> some View {
        Button { editingCountry = field } label: {
            selectorRow(title: title, value: countryLabel(code))
        }
        .buttonStyle(.plain)
    }

    /// flag + name for a code, from the loaded full list (empty = undecided).
    private func countryLabel(_ code: String) -> String {
        if code.isEmpty { return "❓ 还没定" }
        if let c = countries.first(where: { $0.code.caseInsensitiveCompare(code) == .orderedSame }) {
            return "\(c.flag) \(c.name)"
        }
        return code
    }

    /// CMS-managed ports (`visa_ports`), falling back to the bundled list before the fetch.
    private var availablePorts: [VisaPort] {
        let p = appEnv.visaData.data.ports
        return p.isEmpty ? VisaDetectorView.fallbackPorts : p
    }

    private func portRow(title: String, field: PortField, code: String) -> some View {
        Button { editingPort = field } label: {
            selectorRow(title: title, value: portLabel(code))
        }
        .buttonStyle(.plain)
    }

    private func portLabel(_ code: String) -> String {
        availablePorts.first { $0.code == code }?.nameZh ?? code
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
            Toggle("", isOn: isOn).labelsHidden().tint(Theme.ColorToken.success)
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
        verdict = IdentifiedRec(rec: rec)
    }

    // MARK: - Options

    enum ValidityChoice { case ok, short, skip
        var months: Int? { switch self { case .ok: return 12; case .short: return 3; case .skip: return nil } }
        var label: String { switch self { case .ok: return "≥ 6 个月 ✓"; case .short: return "< 6 个月 ⚠️"; case .skip: return "不确定 / 跳过" } }
    }

    /// Which country selector the picker sheet is editing.
    enum CountryField: Identifiable {
        case departure, onward
        var id: Int { self == .departure ? 0 : 1 }
        var title: String { self == .departure ? "从哪国出发" : "下一程去哪 / 回哪国" }
    }

    /// Which port selector the picker sheet is editing.
    enum PortField: Identifiable {
        case entry, exit
        var id: Int { self == .entry ? 0 : 1 }
        var title: String { self == .entry ? "入境口岸" : "出境口岸" }
    }

    /// Used only until `visa_ports` is fetched (keeps the port menu non-empty offline).
    /// Engine matches by code, so these MUST share the namespace used in `visa_policies_v2`.
    static let fallbackPorts: [VisaPort] = [
        .init(code: "PEK", nameZh: "北京首都机场", displayOrder: 0),
        .init(code: "PKX", nameZh: "北京大兴机场", displayOrder: 1),
        .init(code: "PVG", nameZh: "上海浦东机场", displayOrder: 2),
        .init(code: "SHA", nameZh: "上海虹桥机场", displayOrder: 3),
        .init(code: "CAN", nameZh: "广州白云机场", displayOrder: 4),
        .init(code: "SZX", nameZh: "深圳宝安机场", displayOrder: 5),
        .init(code: "TFU", nameZh: "成都天府机场", displayOrder: 6),
        .init(code: "CTU", nameZh: "成都双流机场", displayOrder: 7),
        .init(code: "XIY", nameZh: "西安咸阳机场", displayOrder: 8),
        .init(code: "HGH", nameZh: "杭州萧山机场", displayOrder: 9),
        .init(code: "CKG", nameZh: "重庆江北机场", displayOrder: 10),
        .init(code: "TSN", nameZh: "天津滨海机场", displayOrder: 11),
        .init(code: "HAK", nameZh: "海口美兰机场", displayOrder: 12),
        .init(code: "SYX", nameZh: "三亚凤凰机场", displayOrder: 13),
        .init(code: "JHG", nameZh: "西双版纳机场", displayOrder: 14),
    ]
}

private struct IdentifiedRec: Identifiable {
    let id = UUID()
    let rec: VisaRecommendation
}

/// Searchable full-country picker for departure / onward (full `passport_countries`,
/// same data as onboarding). `includeUndecided` adds a top「还没定」row for the onward leg.
/// Internal (not private) so the Plan create flow can reuse the same picker.
struct CountrySelectSheet: View {
    @Environment(\.dismiss) private var dismiss
    let title: String
    let countries: [PassportCountry]
    let includeUndecided: Bool
    let selected: String
    let onPick: (String) -> Void

    @State private var search = ""

    private var filtered: [PassportCountry] {
        guard !search.isEmpty else { return countries }
        return countries.filter {
            $0.name.localizedCaseInsensitiveContains(search) || $0.code.localizedCaseInsensitiveContains(search)
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 0) {
                    if includeUndecided && search.isEmpty {
                        row(flag: "❓", name: "还没定", code: "")
                        Divider().padding(.leading, Theme.screenPadding)
                    }
                    ForEach(filtered) { c in
                        row(flag: c.flag, name: c.name, code: c.code)
                        Divider().padding(.leading, Theme.screenPadding)
                    }
                }
            }
            .searchable(text: $search, prompt: "搜索国家 / 地区")
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("关闭") { dismiss() } } }
        }
    }

    private func row(flag: String, name: String, code: String) -> some View {
        Button { onPick(code) } label: {
            HStack(spacing: 12) {
                Text(flag).font(.title2)
                Text(name).font(Theme.FontToken.inter(14)).foregroundStyle(Theme.ColorToken.textPrimary)
                Spacer()
                if selected.caseInsensitiveCompare(code) == .orderedSame {
                    Image(systemName: "checkmark").foregroundStyle(Theme.ColorToken.accent)
                }
            }
            .padding(.vertical, 14)
            .padding(.horizontal, Theme.screenPadding)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

/// Searchable single-select port picker for entry / exit — same list style as the
/// country picker (picks one, dismisses). Source list is CMS-managed `visa_ports`.
private struct PortSelectSheet: View {
    @Environment(\.dismiss) private var dismiss
    let title: String
    let ports: [VisaPort]
    let selected: String
    let onPick: (String) -> Void

    @State private var search = ""

    private var filtered: [VisaPort] {
        guard !search.isEmpty else { return ports }
        return ports.filter {
            $0.nameZh.localizedCaseInsensitiveContains(search) || $0.code.localizedCaseInsensitiveContains(search)
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(filtered) { p in
                        Button { onPick(p.code) } label: {
                            HStack(spacing: 12) {
                                Text(p.nameZh).font(Theme.FontToken.inter(14)).foregroundStyle(Theme.ColorToken.textPrimary)
                                Text(p.code).font(Theme.FontToken.inter(11)).foregroundStyle(Theme.ColorToken.textMuted)
                                Spacer()
                                if selected.caseInsensitiveCompare(p.code) == .orderedSame {
                                    Image(systemName: "checkmark").foregroundStyle(Theme.ColorToken.accent)
                                }
                            }
                            .padding(.vertical, 14)
                            .padding(.horizontal, Theme.screenPadding)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        Divider().padding(.leading, Theme.screenPadding)
                    }
                }
            }
            .searchable(text: $search, prompt: "搜索口岸 / IATA")
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("关闭") { dismiss() } } }
        }
    }
}

/// Searchable multi-select city picker for the self-test (手动选城市测一测) — same list
/// style as the country picker, but toggles multiple cities (does not dismiss on tap).
private struct CitySelectSheet: View {
    @Environment(\.dismiss) private var dismiss
    let cities: [VisaCityRow]
    @Binding var selected: Set<String>

    @State private var search = ""

    private var filtered: [VisaCityRow] {
        guard !search.isEmpty else { return cities }
        return cities.filter {
            $0.nameZh.localizedCaseInsensitiveContains(search) || $0.cityId.contains(search)
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(filtered) { c in
                        Button {
                            if selected.contains(c.cityId) { selected.remove(c.cityId) } else { selected.insert(c.cityId) }
                        } label: {
                            HStack(spacing: 12) {
                                Text(c.nameZh).font(Theme.FontToken.inter(14)).foregroundStyle(Theme.ColorToken.textPrimary)
                                Spacer()
                                if selected.contains(c.cityId) {
                                    Image(systemName: "checkmark").foregroundStyle(Theme.ColorToken.accent)
                                }
                            }
                            .padding(.vertical, 14)
                            .padding(.horizontal, Theme.screenPadding)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        Divider().padding(.leading, Theme.screenPadding)
                    }
                }
            }
            .searchable(text: $search, prompt: "搜索城市")
            .navigationTitle("选择测算城市")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .confirmationAction) { Button("完成") { dismiss() } } }
        }
    }
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
