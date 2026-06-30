import SwiftUI
import UIKit

/// Emergency hub — one-tap emergency numbers (with how-to guides), consular protection tutorial,
/// per-city hospitals, and a fillable first-aid card.
struct EmergencyView: View {
    @Environment(AppEnvironment.self) private var appEnv
    @Environment(\.dismiss) private var dismiss

    @State private var data: EmergencyData?
    @State private var guides: [EmergencyGuide] = []
    @State private var hospitals: [CityHospital] = []
    @State private var allCities: [City] = []
    @State private var cityNames: [String: String] = [:]
    @State private var selectedCityId = ""
    @State private var presentedNumber: EmergencyNumberPresentation?
    @State private var card = FirstAidCard.load()
    @State private var shareItems: [Any]?

    private var tripCityIds: [String] {
        if let trip = appEnv.preferences.activeItinerary {
            let ordered = SampleItinerary.orderedCityIds(from: trip)
            if !ordered.isEmpty { return ordered }
        }
        let selected = appEnv.preferences.selectedCityIds
        if !selected.isEmpty { return selected }
        return ["beijing"]
    }

    private var pickerCityIds: [String] {
        if !allCities.isEmpty { return allCities.map(\.id) }
        return tripCityIds
    }

    private var emergencyContacts: [EmergencyContact] {
        let fromData = data?.contacts.filter { !$0.number.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty } ?? []
        if !fromData.isEmpty { return fromData }
        return [
            EmergencyContact(label: "Police", number: "110", note: "24/7 emergency"),
            EmergencyContact(label: "Ambulance", number: "120", note: "Medical emergency"),
            EmergencyContact(label: "Fire", number: "119", note: nil),
            EmergencyContact(label: "Traffic", number: "122", note: "Road accidents"),
        ]
    }

    private func guide(forNumber number: String) -> EmergencyGuide? {
        let normalized = number.trimmingCharacters(in: .whitespacesAndNewlines)
        return guides.first {
            ($0.number ?? "").trimmingCharacters(in: .whitespacesAndNewlines) == normalized
        }
    }

    private func cityLabel(_ cityId: String) -> String {
        if let city = allCities.first(where: { $0.id == cityId }) {
            let emoji = city.emoji ?? ""
            let label = "\(emoji) \(city.name)".trimmingCharacters(in: .whitespaces)
            return label.isEmpty ? city.name : label
        }
        return cityNames[cityId] ?? cityId.capitalized
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    geniusCard
                    callBlock
                    splitCallout
                    medicalSection
                    embassySection
                    firstAidCard
                }
                .padding(Theme.screenPadding)
            }
            .navigationTitle("紧急 · Emergency")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .confirmationAction) { Button("完成") { dismiss() } } }
            .task { await loadContent() }
            .onChange(of: selectedCityId) { _, _ in
                Task { await loadCityResources() }
            }
            .sheet(isPresented: Binding(get: { shareItems != nil }, set: { if !$0 { shareItems = nil } })) {
                if let shareItems { ActivityView(items: shareItems) }
            }
            .sheet(item: $presentedNumber) { presentation in
                EmergencyNumberGuideSheet(
                    presentation: presentation,
                    guide: guide(forNumber: presentation.number),
                    fallbackNote: emergencyContacts.first { $0.number == presentation.number }?.note
                )
            }
        }
    }

    // MARK: - Genius Bar

    private var geniusCard: some View {
        Button { appEnv.navigation.presentGeniusBar() } label: {
            HStack(spacing: 12) {
                Text("💬").font(.system(size: 22))
                VStack(alignment: .leading, spacing: 2) {
                    Text("需要真人帮忙？Genius Bar").font(Theme.FontToken.inter(13, weight: .semibold)).foregroundStyle(.white)
                    Text("紧急情况也能找到我们团队的活人").font(Theme.FontToken.inter(10)).foregroundStyle(.white.opacity(0.6))
                }
                Spacer()
                Image(systemName: "chevron.right").foregroundStyle(.white.opacity(0.5))
            }
            .padding(15)
            .background(Theme.ColorToken.textPrimary)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }

    // MARK: - One-tap call

    private var callBlock: some View {
        VStack(alignment: .leading, spacing: 12) {
            blockLabel("🚨 紧急电话 · 一键拨号")
            Text("Tap a number to read when & how to call, then dial.")
                .font(Theme.FontToken.inter(10))
                .foregroundStyle(Theme.ColorToken.textMuted)
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(emergencyContacts) { contact in
                    callButton(contact: contact)
                }
            }
        }
        .padding(16)
        .background(Theme.ColorToken.warningBackground)
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.ColorToken.warning.opacity(0.35), lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private func callButton(contact: EmergencyContact) -> some View {
        Button {
            presentedNumber = EmergencyNumberPresentation(number: contact.number, label: contact.label)
        } label: {
            VStack(spacing: 4) {
                Text(contact.number).font(Theme.FontToken.playfair(26, weight: .bold)).foregroundStyle(Theme.ColorToken.warning)
                Text(contact.label).font(Theme.FontToken.inter(10)).foregroundStyle(Theme.ColorToken.textMuted)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Theme.ColorToken.background)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.ColorToken.warning.opacity(0.4), lineWidth: 1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }

    private var splitCallout: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("ⓘ 你习惯的 911 在中国分三个号").font(Theme.FontToken.inter(10, weight: .semibold)).foregroundStyle(Theme.ColorToken.accent)
            calloutRow("Police 报警", "110")
            calloutRow("Ambulance 急救", "120")
            calloutRow("Fire 火警", "119")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Theme.ColorToken.backgroundSubtle)
        .overlay(alignment: .leading) { Rectangle().fill(Theme.ColorToken.accent).frame(width: 2) }
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private func calloutRow(_ name: String, _ num: String) -> some View {
        HStack {
            Text(name).font(Theme.FontToken.inter(12)).foregroundStyle(Theme.ColorToken.textSecondary)
            Spacer()
            Text(num).font(Theme.FontToken.inter(12, weight: .medium))
        }
    }

    // MARK: - Medical & meds

    private var medicalSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            blockLabel("🏥 医疗 & 药品")
            cityPickerCard
            disclosure(icon: "🩺", title: "就医流程：挂号 → 候诊 → 取药", subtitle: hospitals.isEmpty ? "通用就医指引" : "外国人友好医院清单") {
                Text("① 挂号（门诊大厅自助机/窗口，带护照）→ ② 候诊（按叫号）→ ③ 医生问诊开单 → ④ 缴费（自助机/窗口）→ ⑤ 检查/取药。\n大城市三甲医院多设国际部/外宾门诊，有英文导诊；急症直接去「急诊」。")
                    .font(Theme.FontToken.inter(12)).foregroundStyle(Theme.ColorToken.textSecondary)
            }
            if !hospitals.isEmpty {
                disclosure(icon: "🏥", title: "推荐医院 · \(cityLabel(selectedCityId))", subtitle: "\(hospitals.count) 家") {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(hospitals) { hospital in
                            hospitalRow(hospital)
                        }
                    }
                }
            } else {
                Text("暂无 \(cityLabel(selectedCityId)) 的推荐医院，请切换城市或拨打 120。")
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(Theme.ColorToken.textMuted)
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.ColorToken.border, lineWidth: 1))
            }
            disclosure(icon: "💊", title: "常见药中英对照", subtitle: "感冒 / 止痛 / 肠胃 / 过敏") {
                VStack(alignment: .leading, spacing: 4) {
                    medRow("感冒 Cold", "感冒灵 / 复方氨酚")
                    medRow("止痛 Pain", "布洛芬 Ibuprofen")
                    medRow("肠胃 Stomach", "蒙脱石散 / 健胃消食")
                    medRow("过敏 Allergy", "氯雷他定 Loratadine")
                }
            }
        }
    }

    private func medRow(_ en: String, _ zh: String) -> some View {
        HStack {
            Text(en).font(Theme.FontToken.inter(12)).foregroundStyle(Theme.ColorToken.textSecondary)
            Spacer()
            Text(zh).font(Theme.FontToken.inter(12, weight: .medium))
        }
    }

    private func hospitalRow(_ hospital: CityHospital) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(hospital.displayName)
                        .font(Theme.FontToken.inter(12, weight: .medium))
                    if hospital.hasInternationalDept {
                        Text("国际部 / International")
                            .font(Theme.FontToken.inter(10))
                            .foregroundStyle(Theme.ColorToken.accent)
                    }
                    if let address = hospital.displayAddress {
                        Text(address)
                            .font(Theme.FontToken.inter(10))
                            .foregroundStyle(Theme.ColorToken.textMuted)
                    }
                    if !hospital.note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        Text(hospital.note)
                            .font(Theme.FontToken.inter(10))
                            .foregroundStyle(Theme.ColorToken.textSecondary)
                    }
                }
                Spacer(minLength: 8)
                if !hospital.phone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    Link(hospital.phone, destination: telURL(hospital.phone))
                        .font(Theme.FontToken.playfair(13, weight: .semibold))
                        .foregroundStyle(Theme.ColorToken.textPrimary)
                }
            }
        }
        .padding(.top, 8)
        .overlay(alignment: .top) { Rectangle().fill(Theme.ColorToken.borderLight).frame(height: 1) }
    }

    // MARK: - Consular protection tutorial

    private var embassySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            blockLabel("🏛 领事保护 · 紧急求助")
            NavigationLink {
                EmergencyGuideDetailView(guideId: "consular_protection", guides: guides)
            } label: {
                HStack(spacing: 12) {
                    Text("📖").font(.system(size: 22))
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Consular Protection Guide")
                            .font(Theme.FontToken.inter(13, weight: .semibold))
                            .foregroundStyle(Theme.ColorToken.textPrimary)
                        Text("What to do · language tips · find your embassy via official channels")
                            .font(Theme.FontToken.inter(10))
                            .foregroundStyle(Theme.ColorToken.textMuted)
                            .multilineTextAlignment(.leading)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                }
                .padding(14)
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.ColorToken.border, lineWidth: 1))
            }
            .buttonStyle(.plain)
        }
    }

    private var cityPickerCard: some View {
        cityPickerRow
            .padding(12)
            .background(Theme.ColorToken.backgroundSubtle)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    private var cityPickerRow: some View {
        HStack {
            Text("查看城市").font(Theme.FontToken.inter(11)).foregroundStyle(Theme.ColorToken.textMuted)
            Spacer()
            Menu {
                ForEach(pickerCityIds, id: \.self) { cityId in
                    Button(cityLabel(cityId)) { selectedCityId = cityId }
                }
            } label: {
                Text("\(cityLabel(selectedCityId)) ⌄")
                    .font(Theme.FontToken.inter(12, weight: .medium))
                    .foregroundStyle(Theme.ColorToken.accent)
            }
        }
    }

    private func telURL(_ phone: String) -> URL {
        URL(string: "tel://\(phone.filter { $0.isNumber || $0 == "+" })")!
    }

    @MainActor
    private func loadContent() async {
        data = try? await appEnv.content.fetchEmergencyData()
        guides = (try? await appEnv.content.fetchEmergencyGuides()) ?? []
        if let cities = try? await appEnv.content.fetchCities() {
            allCities = cities
            cityNames = Dictionary(uniqueKeysWithValues: cities.map { ($0.id, $0.name) })
        }
        if selectedCityId.isEmpty {
            let preferred = tripCityIds.first { pickerCityIds.contains($0) }
                ?? pickerCityIds.first
                ?? "beijing"
            selectedCityId = preferred
        }
        await loadCityResources()
    }

    @MainActor
    private func loadCityResources() async {
        guard !selectedCityId.isEmpty else { return }
        hospitals = (try? await appEnv.content.fetchCityHospitals(cityId: selectedCityId)) ?? []
    }

    // MARK: - First-aid card

    private var firstAidCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            blockLabel("📋 我的急救卡")
            VStack(alignment: .leading, spacing: 0) {
                Text("急救卡模板（可打印随身带）").font(Theme.FontToken.playfair(14, weight: .semibold)).padding(.bottom, 8)
                cardField("血型 Blood type", text: $card.bloodType)
                cardField("过敏 Allergies", text: $card.allergies)
                cardField("慢性病史 History", text: $card.history)
                cardField("紧急联系人 ICE", text: $card.ice)
                Text("🔒 信息仅用于紧急求助，我们不收集你的数据。建议参照 iPhone「健康」填写，翻译好打印一张放兜里。")
                    .font(Theme.FontToken.inter(10)).foregroundStyle(Theme.ColorToken.accent)
                    .padding(.top, 10)
                HStack(spacing: 8) {
                    Button { shareItems = [renderCardImage() as Any].compactMap { $0 } } label: {
                        Text("保存图片").font(Theme.FontToken.inter(10, weight: .semibold)).foregroundStyle(.white)
                            .frame(maxWidth: .infinity).padding(.vertical, 9)
                            .background(Theme.ColorToken.textPrimary).clipShape(RoundedRectangle(cornerRadius: 10))
                    }.buttonStyle(.plain)
                    Button { copyChinese() } label: {
                        Text("复制中文版").font(Theme.FontToken.inter(10, weight: .semibold))
                            .frame(maxWidth: .infinity).padding(.vertical, 9)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.ColorToken.textPrimary, lineWidth: 1))
                    }.buttonStyle(.plain)
                }
                .padding(.top, 12)
            }
            .padding(14)
            .background(Theme.ColorToken.backgroundSubtle)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.ColorToken.accent.opacity(0.4), style: StrokeStyle(lineWidth: 1, dash: [4])))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .onChange(of: card) { _, c in c.save() }
    }

    private func cardField(_ label: String, text: Binding<String>) -> some View {
        HStack {
            Text(label).font(Theme.FontToken.inter(12)).foregroundStyle(Theme.ColorToken.textSecondary)
            Spacer()
            TextField("填写…", text: text)
                .font(Theme.FontToken.inter(12))
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: 180)
        }
        .padding(.vertical, 7)
        .overlay(alignment: .bottom) { Rectangle().fill(Theme.ColorToken.borderLight).frame(height: 1) }
    }

    @MainActor private func renderCardImage() -> UIImage? {
        let renderer = ImageRenderer(content:
            VStack(alignment: .leading, spacing: 6) {
                Text("急救卡 First-Aid Card").font(.system(size: 18, weight: .bold))
                Text("血型 Blood type: \(card.bloodType)")
                Text("过敏 Allergies: \(card.allergies)")
                Text("慢性病史 History: \(card.history)")
                Text("紧急联系人 ICE: \(card.ice)")
                Text("中国急救 120 · 报警 110 · 火警 119").font(.system(size: 12)).foregroundStyle(.secondary)
            }
            .font(.system(size: 15))
            .padding(20)
            .frame(width: 360, alignment: .leading)
            .background(Color.white)
        )
        renderer.scale = UIScreen.main.scale
        return renderer.uiImage
    }

    private func copyChinese() {
        let text = """
        急救卡
        血型：\(card.bloodType)
        过敏：\(card.allergies)
        慢性病史：\(card.history)
        紧急联系人：\(card.ice)
        中国急救 120 · 报警 110 · 火警 119
        """
        UIPasteboard.general.string = text
    }

    // MARK: - Shared pieces

    private func blockLabel(_ text: String) -> some View {
        Text(text).font(Theme.FontToken.playfair(15, weight: .semibold))
    }

    @ViewBuilder
    private func disclosure<Content: View>(icon: String, title: String, subtitle: String, @ViewBuilder content: @escaping () -> Content) -> some View {
        DisclosureGroup {
            content().frame(maxWidth: .infinity, alignment: .leading).padding(.top, 6)
        } label: {
            HStack(spacing: 12) {
                Text(icon).font(.system(size: 18)).frame(width: 22)
                VStack(alignment: .leading, spacing: 1) {
                    Text(title).font(Theme.FontToken.inter(13, weight: .medium))
                    Text(subtitle).font(Theme.FontToken.inter(10)).foregroundStyle(Theme.ColorToken.textMuted)
                }
            }
        }
        .padding(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.ColorToken.border, lineWidth: 1))
    }
}

// MARK: - First-aid card persistence

struct FirstAidCard: Equatable {
    var bloodType = ""
    var allergies = ""
    var history = ""
    var ice = ""

    private static let key = "yolohappy.firstAidCard.v1"

    static func load() -> FirstAidCard {
        guard let data = UserDefaults.standard.data(forKey: key),
              let dict = try? JSONDecoder().decode([String: String].self, from: data) else { return FirstAidCard() }
        return FirstAidCard(
            bloodType: dict["bloodType"] ?? "", allergies: dict["allergies"] ?? "",
            history: dict["history"] ?? "", ice: dict["ice"] ?? ""
        )
    }

    func save() {
        let dict = ["bloodType": bloodType, "allergies": allergies, "history": history, "ice": ice]
        if let data = try? JSONEncoder().encode(dict) {
            UserDefaults.standard.set(data, forKey: Self.key)
        }
    }
}

// MARK: - Share sheet

private struct ActivityView: UIViewControllerRepresentable {
    let items: [Any]
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    func updateUIViewController(_ vc: UIActivityViewController, context: Context) {}
}
