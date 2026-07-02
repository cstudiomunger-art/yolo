import SwiftUI
import AVFoundation

// MARK: - Home (three situations)

struct PaymentHelperHomeView: View {
    @Environment(AppEnvironment.self) private var appEnv
    @Environment(\.dismiss) private var dismiss

    private var service: PaymentHelperService { appEnv.paymentHelper }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    PaymentNodeHeader(nodeKey: .home, service: service)
                    laneButton(.prep, emoji: "🧭", title: "Haven't left yet", subtitle: "Prepare at home at your own pace")
                    laneButton(.china, emoji: "✈️", title: "Already in China", subtitle: "Skip pre-departure steps")
                    laneButton(.rescue, emoji: "🆘", title: "Stuck paying right now", subtitle: "Fix it now · works offline", warm: true)
                    PaymentArticleSection(nodeKey: "home", service: service)
                    PaymentLinksSection(lane: nil, service: service)
                }
                .padding(Theme.screenPadding)
            }
            .navigationTitle("Payment Helper")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Close") { dismiss() } } }
            .navigationDestination(for: PaymentLane.self) { lane in
                switch lane {
                case .prep, .china:
                    PaymentFlowContainerView(lane: lane)
                case .rescue:
                    PaymentRescueView()
                }
            }
            .task { await appEnv.paymentHelper.load() }
        }
    }

    private func laneButton(_ lane: PaymentLane, emoji: String, title: String, subtitle: String, warm: Bool = false) -> some View {
        NavigationLink(value: lane) {
            HStack(spacing: 13) {
                Text(emoji).font(.system(size: 24))
                VStack(alignment: .leading, spacing: 2) {
                    Text(title).font(Theme.FontToken.inter(15, weight: .semibold))
                    Text(subtitle).font(Theme.FontToken.inter(11)).foregroundStyle(Theme.ColorToken.textMuted)
                }
                Spacer()
                Image(systemName: "arrow.right").foregroundStyle(Theme.ColorToken.textMuted)
            }
            .padding(15)
            .frame(maxWidth: .infinity)
            .overlay(RoundedRectangle(cornerRadius: 15).stroke(warm ? Theme.ColorToken.warning : Theme.ColorToken.border, lineWidth: 1.5))
            .background(warm ? Theme.ColorToken.warningBackground : Theme.ColorToken.background)
            .clipShape(RoundedRectangle(cornerRadius: 15))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Flow container (node-by-node navigation)

struct PaymentFlowContainerView: View {
    @Environment(AppEnvironment.self) private var appEnv
    let lane: PaymentLane
    @State private var path: [PaymentNodeKey] = []

    private var nodes: [PaymentNodeKey] {
        lane == .china ? PaymentHelperService.chinaPath() : PaymentHelperService.prepPath()
    }

    var body: some View {
        PaymentFlowNodeView(nodeKey: nodes[0], lane: lane, path: $path, nodes: nodes)
            .navigationTitle(lane == .china ? "Already in China" : "Pre-departure prep")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: PaymentNodeKey.self) { key in
                PaymentFlowNodeView(nodeKey: key, lane: lane, path: $path, nodes: nodes)
            }
    }
}

// MARK: - Single flow node screen

struct PaymentFlowNodeView: View {
    @Environment(AppEnvironment.self) private var appEnv
    let nodeKey: PaymentNodeKey
    let lane: PaymentLane
    @Binding var path: [PaymentNodeKey]
    let nodes: [PaymentNodeKey]

    private var service: PaymentHelperService { appEnv.paymentHelper }
    private var country: String { service.effectiveCountryCode(fallback: appEnv.preferences.countryCode) }
    @State private var showTrouble = false
    @State private var selectedTool = "alipay"

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                PaymentNodeHeader(nodeKey: nodeKey, service: service)
                nodeContent
                navigationFooter
            }
            .padding(Theme.screenPadding)
        }
        .onAppear {
            if nodeKey == .q1 {
                service.prefillCountryIfNeeded(fallback: appEnv.preferences.countryCode)
            }
        }
    }

    @ViewBuilder
    private var nodeContent: some View {
        switch nodeKey {
        case .q1: q1View
        case .q2: q2View
        case .q3: q3View
        case .plan: planView
        case .install, .register, .bind, .verify, .use, .china:
            stepsNodeView
        case .card: cardView
        default: EmptyView()
        }
    }

    // MARK: q1 / q2 / q3

    private var q1View: some View {
        VStack(alignment: .leading, spacing: 12) {
            PaymentChipGrid(
                items: service.countries,
                isOn: { service.selectedCountryCode?.lowercased() == $0.countryCode.lowercased() },
                label: { c in
                    let en = c.nameEn?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                    return (c.flagEmoji ?? "") + " " + (en.isEmpty ? c.nameZh : en)
                }
            ) { c in
                service.selectedCountryCode = c.countryCode
            }
            if service.selectedCountryCode == nil, !country.isEmpty {
                Text("Prefilled from your profile: \(country)")
                    .font(Theme.FontToken.inter(11)).foregroundStyle(Theme.ColorToken.textMuted)
            }
        }
    }

    private var q2View: some View {
        PaymentChipGrid(
            items: service.cardNetworks,
            isOn: { service.cardTypes.contains($0.id) },
            label: { $0.nameZh }
        ) { card in
            if service.cardTypes.contains(card.id) { service.cardTypes.remove(card.id) }
            else { service.cardTypes.insert(card.id) }
        }
    }

    private var q3View: some View {
        PaymentChipGrid(
            items: availableTripKinds,
            isOn: { service.tripKind == $0 },
            label: { tripKindLabel($0) }
        ) { trip in service.tripKind = trip }
    }

    private var availableTripKinds: [TripKind] {
        let types = Set(service.cashRules.map(\.tripType))
        if types.isEmpty { return Array(TripKind.allCases) }
        return TripKind.allCases.filter { types.contains($0.rawValue) }
    }

    // MARK: plan

    private var planView: some View {
        VStack(alignment: .leading, spacing: 14) {
            adviceCard(title: "📱 At registration", result: service.smsAdvice(countryCode: country))
            adviceCard(title: "💳 Card binding strategy", result: service.cardAdvice())
            adviceCard(title: "💴 Cash", result: service.cashAdvice())
            PaymentArticleSection(nodeKey: "plan", service: service)
        }
    }

    // MARK: steps nodes

    @ViewBuilder
    private var stepsNodeView: some View {
        let key = nodeKey.rawValue
        let tools = service.tools(for: key)
        let stableOnly = nodeKey == .verify
        if tools.count > 1 {
            Picker("App", selection: $selectedTool) {
                Text("Alipay").tag("alipay")
                Text("WeChat").tag("wechat")
            }
            .pickerStyle(.segmented)
            PaymentStepsList(steps: service.steps(for: key, tool: selectedTool, includeVolatile: !stableOnly))
        } else {
            PaymentStepsList(steps: service.steps(for: key, includeVolatile: !stableOnly))
        }
        if nodeKey == .bind {
            bindTroubleSection
        }
        if nodeKey == .verify {
            let extra = service.steps(for: key).filter(\.isVolatile)
            if !extra.isEmpty {
                Text("Alternatives (subject to live platform rules)")
                    .font(Theme.FontToken.inter(12, weight: .semibold))
                    .foregroundStyle(Theme.ColorToken.warning)
                    .padding(.top, 8)
                PaymentStepsList(steps: extra, showVolatileBadge: true)
            }
        }
        PaymentArticleSection(nodeKey: key, service: service)
    }

    private var bindTroubleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button { withAnimation { showTrouble.toggle() } } label: {
                HStack(spacing: 4) {
                    Text(showTrouble ? "Hide troubleshooting" : "Didn't work? Troubleshoot")
                        .font(Theme.FontToken.inter(12, weight: .medium))
                        .foregroundStyle(Theme.ColorToken.accent)
                    Image(systemName: showTrouble ? "chevron.up" : "chevron.down")
                        .font(.system(size: 10)).foregroundStyle(Theme.ColorToken.accent)
                }
            }
            .buttonStyle(.plain)
            if showTrouble {
                PaymentStepsList(steps: service.steps(for: "trouble"))
                Button {
                    appEnv.navigation.presentedModal = nil
                    appEnv.navigation.presentGeniusBar()
                } label: {
                    Text("Still stuck? Get human help (card binding) →")
                        .font(Theme.FontToken.inter(12, weight: .medium))
                        .foregroundStyle(Theme.ColorToken.accent)
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: card

    private var cardView: some View {
        let wxOk = service.weChatBindingViable
        let pct = service.readinessPercent
        return VStack(alignment: .leading, spacing: 14) {
            Text("\(pct)% ready")
                .font(Theme.FontToken.playfair(34, weight: .bold))
                .foregroundStyle(pct >= 100 ? Theme.ColorToken.success : Theme.ColorToken.warning)
            Text("Check off what you've already done (self-report is fine)")
                .font(Theme.FontToken.inter(12))
                .foregroundStyle(Theme.ColorToken.textMuted)
            ForEach(service.checklistItems) { item in
                let skipped = item.condition == "has_wechat" && !wxOk
                let label = skipped
                    ? "\(item.labelZh) · (card not supported, skip)"
                    : item.labelZh
                let done = skipped || service.isChecklistSelfReported(item.id)
                Button {
                    guard !skipped else { return }
                    service.toggleChecklistSelfReport(item.id)
                } label: {
                    PaymentCheckRow(label, done: done)
                }
                .buttonStyle(.plain)
                .disabled(skipped)
            }
            PaymentCallout(
                text: pct >= 100
                    ? (wxOk
                        ? "All set. Scan to pay as soon as you're in China."
                        : "All set. Your card doesn't support WeChat, but Alipay + cash cover most situations.")
                    : "\(100 - pct)% still unchecked — go back to finish earlier steps, or check off what you've already done.",
                tone: pct >= 100 ? .ok : .info
            )
        }
    }

    // MARK: footer navigation

    @ViewBuilder
    private var navigationFooter: some View {
        if let next = nextNode, canProceed {
            NavigationLink(value: next) {
                Text(nextButtonTitle)
                    .font(Theme.FontToken.inter(14, weight: .semibold))
                    .frame(maxWidth: .infinity).padding(.vertical, 14)
                    .background(Theme.ColorToken.textPrimary).foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .buttonStyle(.plain)
        } else if canProceed, nodeKey == .card {
            PaymentFinishButton(title: "Done · Close Payment Helper")
        } else if !canProceed {
            Text(blockedReason)
                .font(Theme.FontToken.inter(13))
                .foregroundStyle(Theme.ColorToken.textMuted)
                .frame(maxWidth: .infinity).padding(.vertical, 14)
                .background(Theme.ColorToken.border.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }

    private var nextNode: PaymentNodeKey? {
        guard let idx = nodes.firstIndex(of: nodeKey), idx + 1 < nodes.count else { return nil }
        return nodes[idx + 1]
    }

    private var canProceed: Bool {
        switch nodeKey {
        case .q1: return service.selectedCountryCode != nil || !appEnv.preferences.countryCode.isEmpty
        case .q2: return !service.cardTypes.isEmpty
        case .q3: return service.tripKind != nil
        default: return true
        }
    }

    private var blockedReason: String {
        switch nodeKey {
        case .q1: return "Select a country"
        case .q2: return "Select at least one card"
        case .q3: return "Select a trip type"
        default: return "Complete this step"
        }
    }

    private var nextButtonTitle: String {
        switch nodeKey {
        case .q1, .q2: return "Next →"
        case .q3: return "See your tailored plan →"
        case .plan: return lane == .china ? "Go to card binding →" : "Start prep · step by step →"
        case .use: return "Done · View my payment card →"
        default: return "Next →"
        }
    }

    private func adviceCard(title: String, result: PaymentAdviceResult) -> some View {
        let tone: PaymentCalloutTone = result.tone == "warn" ? .warn : (result.tone == "ok" ? .ok : .info)
        return PaymentCardBox(title: title) {
            HStack(alignment: .top, spacing: 8) {
                Text(tone == .warn ? "⚠️" : (tone == .ok ? "✓" : "💴"))
                PaymentMarkdownView(markdown: result.bodyZh)
            }
        }
    }

    private func tripKindLabel(_ kind: TripKind) -> String {
        switch kind {
        case .city: return "Mostly cities"
        case .both: return "Cities + rural"
        case .remote: return "Mostly remote / rural"
        case .family: return "Family trip"
        }
    }
}

// MARK: - Node header (node_texts)

struct PaymentNodeHeader: View {
    let nodeKey: PaymentNodeKey
    let service: PaymentHelperService

    init(nodeKey: PaymentNodeKey, service: PaymentHelperService) {
        self.nodeKey = nodeKey
        self.service = service
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let h1 = service.text(for: nodeKey.rawValue, slot: "h1") {
                Text(h1.textZh).font(Theme.FontToken.playfair(24, weight: .semibold))
            }
            if let intro = service.text(for: nodeKey.rawValue, slot: "intro") {
                Text(intro.textZh).font(Theme.FontToken.inter(12)).foregroundStyle(Theme.ColorToken.textMuted)
            }
            if let callout = service.text(for: nodeKey.rawValue, slot: "callout") {
                PaymentCallout(text: callout.textZh, tone: PaymentCalloutTone.from(callout.tone))
            }
        }
    }
}

// MARK: - Steps list

struct PaymentStepsList: View {
    let steps: [PaymentFlowStep]
    var showVolatileBadge: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(steps) { step in
                PaymentCardBox(title: step.titleZh) {
                    VStack(alignment: .leading, spacing: 8) {
                        if showVolatileBadge && step.isVolatile {
                            Label("Subject to live platform rules", systemImage: "exclamationmark.triangle")
                                .font(Theme.FontToken.inter(11, weight: .semibold))
                                .foregroundStyle(Theme.ColorToken.warning)
                        }
                        PaymentMarkdownView(markdown: step.instructionMdZh ?? "")
                        if let urlStr = step.screenshotUrl, !urlStr.isEmpty, let url = URL(string: urlStr) {
                            AsyncImage(url: url) { phase in
                                if let image = phase.image {
                                    image.resizable().scaledToFit().clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                            }
                        }
                        if let reasons = step.failReasons, !reasons.isEmpty {
                            ForEach(reasons, id: \.reason) { fr in
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("· \(fr.reason)").font(Theme.FontToken.inter(12, weight: .semibold))
                                    Text(fr.fix).font(Theme.FontToken.inter(12)).foregroundStyle(Theme.ColorToken.textSecondary)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Articles & links sections

struct PaymentLinksSection: View {
    let lane: String?
    let service: PaymentHelperService

    var body: some View {
        let links = service.links(for: lane)
        if !links.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Text("🔗 Reference links")
                    .font(Theme.FontToken.inter(12, weight: .semibold))
                    .foregroundStyle(Theme.ColorToken.textMuted)
                ForEach(links) { link in
                    if let url = URL(string: link.url) {
                        Link(destination: url) {
                            HStack {
                                Text(link.labelZh ?? link.labelEn ?? link.url)
                                    .font(Theme.FontToken.inter(13, weight: .medium))
                                    .foregroundStyle(Theme.ColorToken.accent)
                                Spacer()
                                Image(systemName: "arrow.up.right")
                                    .font(.system(size: 11))
                                    .foregroundStyle(Theme.ColorToken.textMuted)
                            }
                            .padding(.vertical, 10).padding(.horizontal, 13)
                            .frame(maxWidth: .infinity)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.ColorToken.border, lineWidth: 1))
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Finish button (dismiss full-screen payment helper)

struct PaymentFinishButton: View {
    @Environment(AppEnvironment.self) private var appEnv
    var title: String = "Done · Close Payment Helper"

    var body: some View {
        Button {
            appEnv.navigation.dismissModal()
        } label: {
            Text(title)
                .font(Theme.FontToken.inter(14, weight: .semibold))
                .frame(maxWidth: .infinity).padding(.vertical, 14)
                .background(Theme.ColorToken.success).foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain)
        .padding(.top, 8)
    }
}

// MARK: - Articles section

struct PaymentArticleSection: View {
    let nodeKey: String
    let service: PaymentHelperService

    var body: some View {
        let arts = service.articles(for: nodeKey)
        if !arts.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Text("📄 Detailed guides")
                    .font(Theme.FontToken.inter(12, weight: .semibold))
                    .foregroundStyle(Theme.ColorToken.textMuted)
                ForEach(arts) { art in
                    NavigationLink { PaymentArticleView(article: art) } label: {
                        HStack {
                            Text(art.titleZh)
                                .font(Theme.FontToken.inter(13, weight: .medium))
                                .foregroundStyle(Theme.ColorToken.textPrimary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 11)).foregroundStyle(Theme.ColorToken.textMuted)
                        }
                        .padding(.vertical, 10).padding(.horizontal, 13)
                        .frame(maxWidth: .infinity)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.ColorToken.border, lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

// MARK: - Rescue ladder (CMS-driven, offline)

struct PaymentRescueView: View {
    @Environment(AppEnvironment.self) private var appEnv

    private var service: PaymentHelperService { appEnv.paymentHelper }
    @State private var open: Set<String> = []

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Label("Works offline", systemImage: "wifi.slash")
                    .font(Theme.FontToken.inter(11, weight: .semibold))
                    .foregroundStyle(Theme.ColorToken.success)
                PaymentNodeHeader(nodeKey: .rescue, service: service)
                ForEach(service.rescueRungsForUser()) { rung in
                    rescueRung(rung)
                }
                NavigationLink { PaymentMerchantPhraseView() } label: {
                    Text("🗣️ Show this phrase to the merchant →")
                        .font(Theme.FontToken.inter(14, weight: .semibold))
                        .frame(maxWidth: .infinity).padding(.vertical, 14)
                        .background(Theme.ColorToken.warning).foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .buttonStyle(.plain)
                PaymentLinksSection(lane: "rescue", service: service)
                PaymentFinishButton()
            }
            .padding(Theme.screenPadding)
        }
        .navigationTitle("🆘 Rescue")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if open.isEmpty, let first = service.rescueRungsForUser().first {
                open.insert(first.id)
            }
        }
    }

    private func rescueRung(_ rung: PaymentRescueRung) -> some View {
        let n = rung.id
        let isOpen = open.contains(n)
        return VStack(alignment: .leading, spacing: 0) {
            Button {
                if isOpen { open.remove(n) } else { open.insert(n) }
            } label: {
                HStack(spacing: 12) {
                    Text("\(rung.rungOrder ?? 0)")
                        .font(Theme.FontToken.inter(13, weight: .bold))
                        .frame(width: 26, height: 26).background(Theme.ColorToken.warning).foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    VStack(alignment: .leading, spacing: 1) {
                        Text(rung.titleZh).font(Theme.FontToken.inter(14, weight: .semibold))
                        Text(rung.subtitleZh ?? "").font(Theme.FontToken.inter(11)).foregroundStyle(Theme.ColorToken.textMuted)
                    }
                    Spacer()
                    Image(systemName: isOpen ? "chevron.up" : "chevron.down").foregroundStyle(Theme.ColorToken.textMuted)
                }
                .padding(13)
            }
            .buttonStyle(.plain)
            if isOpen {
                PaymentMarkdownView(markdown: rung.detailMdZh ?? "")
                    .padding(.horizontal, 15).padding(.bottom, 13)
            }
        }
        .overlay(RoundedRectangle(cornerRadius: 13).stroke(Theme.ColorToken.border, lineWidth: 1))
    }
}

// MARK: - Merchant phrases (TTS + pre-recorded audio)

struct PaymentMerchantPhraseView: View {
    @Environment(AppEnvironment.self) private var appEnv
    @State private var player: AVPlayer?
    @State private var synthesizer = AVSpeechSynthesizer()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Label("Works offline · no network needed", systemImage: "wifi.slash")
                    .font(Theme.FontToken.inter(11, weight: .semibold))
                    .foregroundStyle(Theme.ColorToken.success)
                PaymentNodeHeader(nodeKey: .merchant, service: appEnv.paymentHelper)
                ForEach(appEnv.paymentHelper.merchantPhrases) { phrase in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(phrase.cn).font(.system(size: 28, weight: .heavy))
                        if let en = phrase.en, !en.isEmpty {
                            Text(en).font(Theme.FontToken.inter(13)).foregroundStyle(Theme.ColorToken.textMuted)
                        }
                        HStack(spacing: 8) {
                            if phrase.speakable != false {
                                Button { speak(phrase.cn) } label: {
                                    Label("Read aloud", systemImage: "speaker.wave.2.fill")
                                        .font(Theme.FontToken.inter(12, weight: .semibold))
                                        .padding(.horizontal, 14).padding(.vertical, 7)
                                        .background(Theme.ColorToken.accent).foregroundStyle(.white)
                                        .clipShape(Capsule())
                                }
                                .buttonStyle(.plain)
                            }
                            if let urlStr = phrase.audioUrl, !urlStr.isEmpty, let url = URL(string: urlStr) {
                                Button { playAudio(url) } label: {
                                    Label("Play recording", systemImage: "play.circle.fill")
                                        .font(Theme.FontToken.inter(12, weight: .semibold))
                                        .padding(.horizontal, 14).padding(.vertical, 7)
                                        .background(Theme.ColorToken.success).foregroundStyle(.white)
                                        .clipShape(Capsule())
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Theme.ColorToken.border, lineWidth: 1))
                }
                PaymentFinishButton()
            }
            .padding(Theme.screenPadding)
        }
        .navigationTitle("Show to merchant")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func speak(_ text: String) {
        synthesizer.stopSpeaking(at: .immediate)
        let u = AVSpeechUtterance(string: text)
        u.voice = AVSpeechSynthesisVoice(language: "zh-CN")
        u.rate = 0.45
        synthesizer.speak(u)
    }

    private func playAudio(_ url: URL) {
        player?.pause()
        player = AVPlayer(url: url)
        player?.play()
    }
}

// MARK: - Article detail

struct PaymentArticleView: View {
    let article: PaymentArticle

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text(article.titleZh).font(Theme.FontToken.playfair(22, weight: .semibold))
                PaymentMarkdownView(markdown: article.bodyMdZh ?? "")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(Theme.screenPadding)
        }
        .navigationTitle("Detailed guide")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Markdown renderer

struct PaymentMarkdownView: View {
    let markdown: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(Array(lines.enumerated()), id: \.offset) { _, line in
                blockView(for: line)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var lines: [String] { markdown.components(separatedBy: "\n") }

    @ViewBuilder
    private func blockView(for raw: String) -> some View {
        let line = raw.trimmingCharacters(in: .whitespaces)
        if line.isEmpty {
            Spacer().frame(height: 2)
        } else if line.hasPrefix("### ") {
            Text(inline(String(line.dropFirst(4)))).font(Theme.FontToken.inter(14, weight: .semibold))
        } else if line.hasPrefix("## ") {
            Text(inline(String(line.dropFirst(3)))).font(Theme.FontToken.inter(16, weight: .semibold))
        } else if line.hasPrefix("# ") {
            Text(inline(String(line.dropFirst(2)))).font(Theme.FontToken.playfair(18, weight: .semibold))
        } else if line.hasPrefix("> ") {
            HStack(alignment: .top, spacing: 8) {
                Rectangle().fill(Theme.ColorToken.accent).frame(width: 3)
                Text(inline(String(line.dropFirst(2)))).font(Theme.FontToken.inter(13)).foregroundStyle(Theme.ColorToken.textSecondary)
            }
        } else if line.hasPrefix("- ") || line.hasPrefix("* ") {
            HStack(alignment: .top, spacing: 6) {
                Text("•").font(Theme.FontToken.inter(13)).foregroundStyle(Theme.ColorToken.textSecondary)
                Text(inline(String(line.dropFirst(2)))).font(Theme.FontToken.inter(13)).foregroundStyle(Theme.ColorToken.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        } else if let img = imageURL(line) {
            AsyncImage(url: img) { phase in
                if let image = phase.image {
                    image.resizable().scaledToFit().clipShape(RoundedRectangle(cornerRadius: 10))
                } else {
                    Color.clear.frame(height: 1)
                }
            }
        } else {
            Text(inline(line)).font(Theme.FontToken.inter(13)).foregroundStyle(Theme.ColorToken.textSecondary)
        }
    }

    private func inline(_ s: String) -> AttributedString {
        (try? AttributedString(markdown: s)) ?? AttributedString(s)
    }

    private func imageURL(_ line: String) -> URL? {
        guard line.hasPrefix("!["), let open = line.firstIndex(of: "("), line.hasSuffix(")") else { return nil }
        let urlStr = String(line[line.index(after: open)..<line.index(before: line.endIndex)])
        return URL(string: urlStr)
    }
}

// MARK: - Shared UI helpers

enum PaymentCalloutTone { case ok, warn, info, blue
    static func from(_ tone: String?) -> PaymentCalloutTone {
        switch tone {
        case "warm", "warn": return .warn
        case "jade", "ok": return .ok
        case "blue": return .blue
        default: return .info
        }
    }
}

struct PaymentCallout: View {
    let text: String
    let tone: PaymentCalloutTone

    var body: some View {
        let color: Color = switch tone {
        case .ok: Theme.ColorToken.success
        case .warn: Theme.ColorToken.warning
        case .blue: Theme.ColorToken.accent
        case .info: Theme.ColorToken.accent
        }
        return HStack(alignment: .top, spacing: 8) {
            Rectangle().fill(color).frame(width: 3)
            Text(text).font(Theme.FontToken.inter(12)).foregroundStyle(Theme.ColorToken.textSecondary)
                .padding(.vertical, 10).padding(.trailing, 12)
        }
        .background(color.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct PaymentCardBox<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(Theme.FontToken.inter(12, weight: .semibold)).foregroundStyle(Theme.ColorToken.textMuted)
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(15)
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.ColorToken.border, lineWidth: 1))
    }
}

struct PaymentCheckRow: View {
    let text: String
    let done: Bool

    init(_ text: String, done: Bool) {
        self.text = text
        self.done = done
    }

    var body: some View {
        HStack(spacing: 9) {
            Image(systemName: done ? "checkmark.square.fill" : "exclamationmark.square")
                .foregroundStyle(done ? Theme.ColorToken.success : Theme.ColorToken.warning)
            Text(text).font(Theme.FontToken.inter(13, weight: .medium))
            Spacer()
        }
    }
}

struct PaymentChipGrid<T: Identifiable>: View {
    let items: [T]
    let isOn: (T) -> Bool
    let label: (T) -> String
    let toggle: (T) -> Void

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 8, alignment: .leading)], alignment: .leading, spacing: 8) {
            ForEach(items) { item in
                let on = isOn(item)
                Button { toggle(item) } label: {
                    Text((on ? "✓ " : "") + label(item))
                        .font(Theme.FontToken.inter(13))
                        .padding(.horizontal, 14).padding(.vertical, 9)
                        .frame(maxWidth: .infinity)
                        .background(on ? Theme.ColorToken.textPrimary : Theme.ColorToken.background)
                        .foregroundStyle(on ? .white : Theme.ColorToken.textPrimary)
                        .overlay(Capsule().stroke(on ? Theme.ColorToken.textPrimary : Theme.ColorToken.border, lineWidth: 1))
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
        }
    }
}
