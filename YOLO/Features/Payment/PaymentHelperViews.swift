import SwiftUI
import AVFoundation

// MARK: - Home (three situations)

/// "先问处境，不问功能" — branch by where the user is right now.
struct PaymentHelperHomeView: View {
    @Environment(AppEnvironment.self) private var appEnv
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text("你现在的处境？")
                        .font(Theme.FontToken.playfair(24, weight: .semibold))
                    Text("先问你在哪个时刻——最慌的人能一秒拿到帮助。")
                        .font(Theme.FontToken.inter(12))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                        .padding(.bottom, 4)

                    laneButton(.prep, emoji: "🧭", title: "我还没出发", subtitle: "在家慢慢准备")
                    laneButton(.china, emoji: "✈️", title: "我已经在中国了", subtitle: "跳过出发前步骤")
                    laneButton(.rescue, emoji: "🆘", title: "我正卡在付款，付不了", subtitle: "现在就要解决 · 离线可用", warm: true)
                }
                .padding(Theme.screenPadding)
            }
            .navigationTitle("支付助手")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("关闭") { dismiss() } } }
            .navigationDestination(for: PaymentLane.self) { lane in
                switch lane {
                case .prep, .china: PaymentHelperFlowView(lane: lane)
                case .rescue: PaymentRescueView()
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

// MARK: - Prep / China flow

struct PaymentHelperFlowView: View {
    @Environment(AppEnvironment.self) private var appEnv
    let lane: PaymentLane

    private enum Step { case questions, plan, steps, card }
    @State private var step: Step = .questions
    @State private var showTrouble = false   // 绑卡侧门：内联排查，不打断主线

    private var service: PaymentHelperService { appEnv.paymentHelper }
    private var country: String { (appEnv.preferences.countryCode ?? "").uppercased() }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                switch effectiveStep {
                case .questions: questionsView
                case .plan: planView
                case .steps: stepsView
                case .card: cardView
                }
            }
            .padding(Theme.screenPadding)
        }
        .navigationTitle(lane == .china ? "已经在中国" : "出发前准备")
        .navigationBarTitleDisplayMode(.inline)
    }

    // China lane skips the 3 questions if already answered; still allow plan.
    private var effectiveStep: Step { step }

    private var questionsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            if lane == .china {
                calloutView("跳过所有「出发前 X 天」。现在最稳的一步是先有现金兜底，再慢慢绑卡。", tone: .info)
                cardBox(title: "🏧 现在就做") {
                    Text("去机场或市区大银行 ATM 取 500 元（认 Visa/Mastercard/UnionPay 标识）。手机支付万一卡住，现金立刻兜底。")
                        .font(Theme.FontToken.inter(13)).foregroundStyle(Theme.ColorToken.textSecondary)
                }
            }
            Text("你有哪些卡？（可多选）").font(Theme.FontToken.inter(15, weight: .semibold))
            chipsRow(service.cardNetworks, isOn: { service.cardTypes.contains($0.id) }, label: { $0.nameZh }) { card in
                if service.cardTypes.contains(card.id) { service.cardTypes.remove(card.id) } else { service.cardTypes.insert(card.id) }
            }
            Text("这趟主要去哪？").font(Theme.FontToken.inter(15, weight: .semibold)).padding(.top, 4)
            chipsRow(TripKind.allCases, isOn: { service.tripKind == $0 }, label: { $0.label }) { trip in
                service.tripKind = trip
            }
            primaryButton(service.cardTypes.isEmpty ? "选好卡再继续" : "看为你裁好的方案 →", enabled: !service.cardTypes.isEmpty) {
                step = .plan
            }
        }
    }

    private var planView: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("为你一个人裁好的").font(Theme.FontToken.playfair(20, weight: .semibold))
            adviceCard(title: "📱 注册时", dimension: "sms")
            adviceCard(title: "💳 绑卡策略", dimension: "card")
            adviceCard(title: "💴 现金", dimension: "cash")
            primaryButton(lane == .china ? "去绑卡 →" : "开始准备 · 一步步来 →", enabled: true) { step = .steps }
        }
    }

    private var stepsView: some View {
        VStack(alignment: .leading, spacing: 14) {
            if lane != .china {
                cardBox(title: "② 装两个主 App") {
                    Text("务必出发前装好支付宝 + 微信。到了中国可能上不了 Google Play、收不到验证码。")
                        .font(Theme.FontToken.inter(13)).foregroundStyle(Theme.ColorToken.textSecondary)
                }
            }
            cardBox(title: "③ 注册账号 + 实名认证") {
                VStack(alignment: .leading, spacing: 6) {
                    Text("用境外手机号注册支付宝和微信；收不到验证码就改用邮箱注册（Gmail/Outlook）或支付宝国际版。")
                        .font(Theme.FontToken.inter(13)).foregroundStyle(Theme.ColorToken.textSecondary)
                    Text("实名认证：按护照机读区填姓名、护照号、有效期，再上传护照照片 / 人脸验证。")
                        .font(Theme.FontToken.inter(13)).foregroundStyle(Theme.ColorToken.textSecondary)
                    Text("微信注册：仅 Visa/MC/JCB 可绑，且银行预留手机号要与微信号一致。")
                        .font(Theme.FontToken.inter(12)).foregroundStyle(Theme.ColorToken.textMuted)
                }
            }
            cardBox(title: "④ 绑定银行卡") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("主线一条直线：填卡号 → 短信验证 → 完成。")
                        .font(Theme.FontToken.inter(13)).foregroundStyle(Theme.ColorToken.textSecondary)
                    Button { withAnimation { showTrouble.toggle() } } label: {
                        HStack(spacing: 4) {
                            Text(showTrouble ? "收起排查" : "没成功？对症排查")
                                .font(Theme.FontToken.inter(12, weight: .medium))
                                .foregroundStyle(Theme.ColorToken.accent)
                            Image(systemName: showTrouble ? "chevron.up" : "chevron.down")
                                .font(.system(size: 10)).foregroundStyle(Theme.ColorToken.accent)
                        }
                    }
                    .buttonStyle(.plain)
                    if showTrouble {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("侧门，不是新路——处理完回到这一步原地，主线不打断。")
                                .font(Theme.FontToken.inter(11)).foregroundStyle(Theme.ColorToken.textMuted)
                            troubleRow("发卡行拒绝交易", "打开银行 App 确认交易，或联系客服说「需开通中国大陆线上交易」；换另一张卡也行。")
                            troubleRow("姓名 / 空格不符", "严格按护照拼音填，例：护照 Zhang San 就别写 Zhangsan。")
                            troubleRow("3D 验证失败", "换一张借记卡，或换不同卡组织（Visa ↔ Mastercard）。")
                            Button {
                                appEnv.navigation.presentedModal = nil
                                appEnv.navigation.presentGeniusBar()
                            } label: {
                                Text("还不行？找真人帮你（绑卡） →")
                                    .font(Theme.FontToken.inter(12, weight: .medium))
                                    .foregroundStyle(Theme.ColorToken.accent)
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.top, 2)
                    }
                }
            }
            cardBox(title: "⑤ 验证通道（安全版）") {
                Text("不用做假订单。用支付宝官方「我的→银行卡→验证卡片」（预授权 1 元、不扣款），或把落地后第一笔真实小额消费当验证。")
                    .font(Theme.FontToken.inter(13)).foregroundStyle(Theme.ColorToken.textSecondary)
            }
            cardBox(title: "⑥ 到店怎么付（两步）") {
                VStack(alignment: .leading, spacing: 6) {
                    Text("第 1 步 · 被扫（优先）：打开支付宝/微信「付款码」，出示给商家扫。")
                        .font(Theme.FontToken.inter(13)).foregroundStyle(Theme.ColorToken.textSecondary)
                    Text("第 2 步 · 主扫：用「扫一扫」扫商家收款码，输入金额 → 确认 → 完成。")
                        .font(Theme.FontToken.inter(13)).foregroundStyle(Theme.ColorToken.textSecondary)
                    Text("失败多半是商家码不支持外卡或是个人收款码——让商家改扫你的付款码，或换另一个 App，再不行用现金。")
                        .font(Theme.FontToken.inter(12)).foregroundStyle(Theme.ColorToken.textMuted)
                }
            }
            primaryButton("完成 · 看我的随身支付卡 →", enabled: true) { step = .card }
        }
    }

    private var cardView: some View {
        let wxOk = service.weChatBindingViable
        let pct = service.readinessPercent
        return VStack(alignment: .leading, spacing: 14) {
            Text("你的随身支付卡").font(Theme.FontToken.playfair(20, weight: .semibold))
            Text("\(pct)% 就绪")
                .font(Theme.FontToken.playfair(34, weight: .bold))
                .foregroundStyle(Theme.ColorToken.success)
            ForEach(service.checklistItems) { item in
                let done = service.checklistItemDone(item)
                let label = (item.condition == "has_wechat" && !done)
                    ? "\(item.labelZh) ·（你的卡不支持，跳过）"
                    : item.labelZh
                checkRow(label, done: done)
            }
            calloutView(wxOk
                ? "\(pct)% 就绪。到了中国直接扫码即可。"
                : "\(pct)% 也够用。你的卡不支持微信，但支付宝 + 现金已能覆盖绝大多数场景。",
                tone: wxOk ? .ok : .info)
        }
    }

    // MARK: - Pieces

    private func adviceCard(title: String, dimension: String) -> some View {
        let rule = service.advice(for: dimension, country: country)
        let tone: CalloutTone = (rule?.severity == "warn") ? .warn : (rule?.severity == "ok" ? .ok : .info)
        return cardBox(title: title) {
            HStack(alignment: .top, spacing: 8) {
                Text(tone == .warn ? "⚠️" : (tone == .ok ? "✓" : "💴"))
                Text(rule?.bodyZh ?? "—")
                    .font(Theme.FontToken.inter(13)).foregroundStyle(Theme.ColorToken.textSecondary)
            }
        }
    }

    // 绑卡侧门一行：失败原因 → 解法（取自规格 steps_by_node.trouble）。
    private func troubleRow(_ reason: String, _ fix: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("· \(reason)").font(Theme.FontToken.inter(12, weight: .semibold))
            Text(fix).font(Theme.FontToken.inter(12)).foregroundStyle(Theme.ColorToken.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func checkRow(_ text: String, done: Bool) -> some View {
        HStack(spacing: 9) {
            Image(systemName: done ? "checkmark.square.fill" : "exclamationmark.square")
                .foregroundStyle(done ? Theme.ColorToken.success : Theme.ColorToken.warning)
            Text(text).font(Theme.FontToken.inter(13, weight: .medium))
            Spacer()
        }
    }

    @ViewBuilder
    private func chipsRow<T: Identifiable>(_ items: [T], isOn: @escaping (T) -> Bool, label: @escaping (T) -> String, toggle: @escaping (T) -> Void) -> some View {
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

    private func cardBox<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(Theme.FontToken.inter(12, weight: .semibold)).foregroundStyle(Theme.ColorToken.textMuted)
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(15)
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.ColorToken.border, lineWidth: 1))
    }

    private func primaryButton(_ title: String, enabled: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title).font(Theme.FontToken.inter(14, weight: .semibold))
                .frame(maxWidth: .infinity).padding(.vertical, 14)
                .background(Theme.ColorToken.textPrimary).foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain).disabled(!enabled).opacity(enabled ? 1 : 0.4)
    }
}

// MARK: - Rescue ladder

struct PaymentRescueView: View {
    @Environment(AppEnvironment.self) private var appEnv

    private var wxOk: Bool { appEnv.paymentHelper.weChatBindingViable }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Label("离线可用 · Works offline", systemImage: "wifi.slash")
                    .font(Theme.FontToken.inter(11, weight: .semibold))
                    .foregroundStyle(Theme.ColorToken.success)
                Text("别慌，一步步换").font(Theme.FontToken.playfair(20, weight: .semibold))

                rung(1, "换个动作", "让商家扫你，而不是你扫商家", "打开你自己的付款码给店员扫。很多失败只是因为商家的码不支持外卡。")
                rung(2, "换个 App", "支付宝 ↔ 微信", "支付宝失败试微信；微信失败试支付宝。" + (wxOk ? "" : "（你的卡不支持微信，这步可跳过）"))
                rung(3, "换张卡", "另一张不同银行的卡", "大额失败可拆成两笔（如 1200 = 600+600），或在 App 里换绑另一张卡。")
                rung(4, "用现金", "永远的兜底", "小商户/夜市/个人码搞不定时，现金最现实。建议每天随身 100–300 元小面额。")

                NavigationLink {
                    PaymentMerchantPhraseView()
                } label: {
                    Text("🗣️ 给商家看这句话 →")
                        .font(Theme.FontToken.inter(14, weight: .semibold))
                        .frame(maxWidth: .infinity).padding(.vertical, 14)
                        .background(Theme.ColorToken.warning).foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .buttonStyle(.plain)
            }
            .padding(Theme.screenPadding)
        }
        .navigationTitle("🆘 救援")
        .navigationBarTitleDisplayMode(.inline)
    }

    @State private var open: Set<Int> = [1]

    private func rung(_ n: Int, _ title: String, _ sub: String, _ detail: String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                if open.contains(n) { open.remove(n) } else { open.insert(n) }
            } label: {
                HStack(spacing: 12) {
                    Text("\(n)").font(Theme.FontToken.inter(13, weight: .bold))
                        .frame(width: 26, height: 26).background(Theme.ColorToken.warning).foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    VStack(alignment: .leading, spacing: 1) {
                        Text(title).font(Theme.FontToken.inter(14, weight: .semibold))
                        Text(sub).font(Theme.FontToken.inter(11)).foregroundStyle(Theme.ColorToken.textMuted)
                    }
                    Spacer()
                    Image(systemName: open.contains(n) ? "chevron.up" : "chevron.down").foregroundStyle(Theme.ColorToken.textMuted)
                }
                .padding(13)
            }
            .buttonStyle(.plain)
            if open.contains(n) {
                Text(detail).font(Theme.FontToken.inter(12)).foregroundStyle(Theme.ColorToken.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 15).padding(.bottom, 13)
            }
        }
        .overlay(RoundedRectangle(cornerRadius: 13).stroke(Theme.ColorToken.border, lineWidth: 1))
    }
}

// MARK: - Merchant phrases (offline TTS)

struct PaymentMerchantPhraseView: View {
    @Environment(AppEnvironment.self) private var appEnv
    private let synthesizer = AVSpeechSynthesizer()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Label("离线可用 · 没网也能调出", systemImage: "wifi.slash")
                    .font(Theme.FontToken.inter(11, weight: .semibold))
                    .foregroundStyle(Theme.ColorToken.success)
                ForEach(appEnv.paymentHelper.merchantPhrases) { phrase in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(phrase.cn).font(.system(size: 28, weight: .heavy))
                        if let en = phrase.en, !en.isEmpty {
                            Text(en).font(Theme.FontToken.inter(13)).foregroundStyle(Theme.ColorToken.textMuted)
                        }
                        Button { speak(phrase.cn) } label: {
                            Label("读出来 Speak", systemImage: "speaker.wave.2.fill")
                                .font(Theme.FontToken.inter(12, weight: .semibold))
                                .padding(.horizontal, 14).padding(.vertical, 7)
                                .background(Theme.ColorToken.accent).foregroundStyle(.white)
                                .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Theme.ColorToken.border, lineWidth: 1))
                }
            }
            .padding(Theme.screenPadding)
        }
        .navigationTitle("给商家看")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func speak(_ text: String) {
        synthesizer.stopSpeaking(at: .immediate)
        let u = AVSpeechUtterance(string: text)
        u.voice = AVSpeechSynthesisVoice(language: "zh-CN")
        u.rate = 0.45
        synthesizer.speak(u)
    }
}

private enum CalloutTone { case ok, warn, info }

private extension View {
    func calloutView(_ text: String, tone: CalloutTone) -> some View {
        let color: Color
        switch tone {
        case .ok: color = Theme.ColorToken.success
        case .warn: color = Theme.ColorToken.warning
        case .info: color = Theme.ColorToken.accent
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
