import SwiftUI
import UIKit

/// Emergency hub — one screen reachable when panicking. Mirrors the 00_首页与实用信息中心
/// design: one-tap calls (110/120/119), the "911 splits into three" note, medical &
/// meds, embassy by nationality, and a fillable first-aid card.
struct EmergencyView: View {
    @Environment(AppEnvironment.self) private var appEnv
    @Environment(\.dismiss) private var dismiss

    @State private var data: EmergencyData?
    @State private var selectedNationality: String = ""
    @State private var card = FirstAidCard.load()
    @State private var shareItems: [Any]?

    private var country: String {
        let cc = appEnv.preferences.countryCode.uppercased()
        return cc.isEmpty ? "GB" : cc
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
            .task {
                if selectedNationality.isEmpty { selectedNationality = country }
                data = try? await appEnv.content.fetchEmergencyData()
            }
            .sheet(isPresented: Binding(get: { shareItems != nil }, set: { if !$0 { shareItems = nil } })) {
                if let shareItems { ActivityView(items: shareItems) }
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
            HStack(spacing: 10) {
                callButton(number: "110", label: "警察 Police")
                callButton(number: "120", label: "急救 Medical")
                callButton(number: "119", label: "火警 Fire")
            }
        }
        .padding(16)
        .background(Theme.ColorToken.warningBackground)
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.ColorToken.warning.opacity(0.35), lineWidth: 1))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private func callButton(number: String, label: String) -> some View {
        Link(destination: URL(string: "tel://\(number)")!) {
            VStack(spacing: 4) {
                Text(number).font(Theme.FontToken.playfair(26, weight: .bold)).foregroundStyle(Theme.ColorToken.warning)
                Text(label).font(Theme.FontToken.inter(10)).foregroundStyle(Theme.ColorToken.textMuted)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Theme.ColorToken.background)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.ColorToken.warning.opacity(0.4), lineWidth: 1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
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
            disclosure(icon: "🩺", title: "就医流程：挂号 → 候诊 → 取药", subtitle: "外国人友好医院清单") {
                Text("① 挂号（门诊大厅自助机/窗口，带护照）→ ② 候诊（按叫号）→ ③ 医生问诊开单 → ④ 缴费（自助机/窗口）→ ⑤ 检查/取药。\n大城市三甲医院多设国际部/外宾门诊，有英文导诊；急症直接去「急诊」。")
                    .font(Theme.FontToken.inter(12)).foregroundStyle(Theme.ColorToken.textSecondary)
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

    // MARK: - Embassy by nationality

    private var embassySection: some View {
        let info = EmbassyDirectory.entry(for: selectedNationality)
        return VStack(alignment: .leading, spacing: 8) {
            blockLabel("🏛 使馆 · 按你的国籍")
            VStack(spacing: 10) {
                HStack {
                    Text("当前国籍").font(Theme.FontToken.inter(11)).foregroundStyle(Theme.ColorToken.textMuted)
                    Spacer()
                    Menu {
                        ForEach(EmbassyDirectory.all) { e in
                            Button("\(e.flag) \(e.name)") { selectedNationality = e.code }
                        }
                    } label: {
                        Text("\(info.flag) \(info.name) ⌄").font(Theme.FontToken.inter(12, weight: .medium)).foregroundStyle(Theme.ColorToken.accent)
                    }
                }
                if let embassy = info.embassy {
                    embassyRow("驻华大使馆 · 北京", embassy)
                    if let hotline = info.consularHotline {
                        embassyRow("领事保护 24h 热线", hotline)
                    }
                } else {
                    Text("未收录你国使馆信息。请搜索「\(info.name) 驻华大使馆」获取电话。")
                        .font(Theme.FontToken.inter(11)).foregroundStyle(Theme.ColorToken.textMuted)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    if let note = data?.embassyNote, !note.isEmpty {
                        HTMLContentView(content: note, fontSize: 11)
                    }
                }
            }
            .padding(14)
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.ColorToken.border, lineWidth: 1))
        }
    }

    private func embassyRow(_ label: String, _ phone: String) -> some View {
        HStack {
            Text(label).font(Theme.FontToken.inter(12)).foregroundStyle(Theme.ColorToken.textSecondary)
            Spacer()
            Link(phone, destination: URL(string: "tel://\(phone.filter { $0.isNumber || $0 == "+" })")!)
                .font(Theme.FontToken.playfair(13, weight: .semibold))
                .foregroundStyle(Theme.ColorToken.textPrimary)
        }
        .padding(.top, 8)
        .overlay(alignment: .top) { Rectangle().fill(Theme.ColorToken.borderLight).frame(height: 1) }
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

// MARK: - Embassy directory (seed content from design; verify numbers before launch)

struct EmbassyEntry: Identifiable {
    let code: String
    let flag: String
    let name: String
    let embassy: String?
    let consularHotline: String?
    var id: String { code }
}

enum EmbassyDirectory {
    static let all: [EmbassyEntry] = [
        EmbassyEntry(code: "GB", flag: "🇬🇧", name: "United Kingdom", embassy: "+86 10 5192 4000", consularHotline: "+86 10 5192 4000"),
        EmbassyEntry(code: "US", flag: "🇺🇸", name: "United States", embassy: "+86 10 8531 3000", consularHotline: "+86 10 8531 4000"),
        EmbassyEntry(code: "AU", flag: "🇦🇺", name: "Australia", embassy: "+86 10 5140 4111", consularHotline: "+61 2 6261 3305"),
        EmbassyEntry(code: "CA", flag: "🇨🇦", name: "Canada", embassy: "+86 10 5139 4000", consularHotline: "+1 613 996 8885"),
    ]

    static func entry(for code: String) -> EmbassyEntry {
        if let e = all.first(where: { $0.code == code.uppercased() }) { return e }
        return EmbassyEntry(code: code, flag: "🏛", name: code, embassy: nil, consularHotline: nil)
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
