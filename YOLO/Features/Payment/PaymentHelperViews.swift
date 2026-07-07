import SwiftUI
import AVFoundation

// MARK: - Hub

struct PaymentHelperHomeView: View {
    @Environment(AppEnvironment.self) private var appEnv
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    PaymentGuideHero()
                    PaymentGuideRule()

                    PaymentGuideSectionHeader(title: PaymentGuideContent.threeWaysHeader)

                    VStack(spacing: 0) {
                        ForEach(PaymentGuideContent.hubActions) { action in
                            NavigationLink(value: action.id) {
                                PaymentGuideActionRow(action: action)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, PaymentGuideLayout.horizontalPadding)

                    NavigationLink(value: PaymentGuideDestination.failed) {
                        PaymentGuideSOSBar()
                    }
                    .buttonStyle(.plain)

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                        ForEach(PaymentGuideContent.miniTiles) { tile in
                            NavigationLink(value: tile.id) {
                                PaymentGuideMiniTileView(tile: tile)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, PaymentGuideLayout.horizontalPadding)
                    .padding(.top, 18)
                }
                .padding(.bottom, PaymentGuideLayout.bottomPadding)
            }
            .background(Theme.ColorToken.background)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
            .navigationDestination(for: PaymentGuideDestination.self) { destination in
                PaymentGuideScreenView(destination: destination)
            }
            .task { await appEnv.paymentHelper.load() }
        }
    }
}

// MARK: - Screen router

private struct PaymentGuideScreenView: View {
    let destination: PaymentGuideDestination

    var body: some View {
        Group {
            switch destination {
            case .mobile: PaymentGuideMobilePayView()
            case .cash: PaymentGuideCashCardsView()
            case .prepay: PaymentGuidePrepayView()
            case .failed: PaymentGuideFailedView()
            case .before: PaymentGuideBeforeYouFlyView()
            case .phrases: PaymentGuidePhrasesView()
            case .setup: PaymentGuideSetupView()
            case .limits: PaymentGuideLimitsView()
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
}

// MARK: - Sub-page shell

private struct PaymentGuideSubPage<Content: View>: View {
    let destination: PaymentGuideDestination
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(spacing: 0) {
            PaymentGuideSubNav(title: PaymentGuideContent.screenTitle(for: destination))
            ScrollView {
                PaymentGuidePagePad { content() }
            }
        }
        .safeAreaPadding(.top, 8)
        .background(Theme.ColorToken.background)
    }
}

// MARK: - Mobile Pay

private struct PaymentGuideMobilePayView: View {
    @State private var howSegment = 1

    var body: some View {
        PaymentGuideSubPage(destination: .mobile) {
            PaymentGuideLead(text: PaymentGuideContent.mobileLead)
            PaymentGuideSub(text: PaymentGuideContent.mobileSub)
            PaymentGuideBrandChips(chips: PaymentGuideContent.mobileBrandChips)

            PaymentGuideSection(title: "Before You Fly") {
                ForEach(PaymentGuideContent.mobileBeforeFlySteps) { step in
                    PaymentGuideStepView(step: step)
                }
                NavigationLink(value: PaymentGuideDestination.setup) {
                    PaymentGuideDeepLink(title: PaymentGuideContent.mobileSetupLink)
                }
                .buttonStyle(.plain)
            }

            PaymentGuideSection(title: "How to Pay In-Store") {
                PaymentGuideSegment(
                    options: PaymentGuideContent.mobileHowSegments,
                    selectedID: $howSegment
                )
            }

            PaymentGuideSection(title: "Where It Works") {
                ForEach(PaymentGuideContent.mobileCoverageRows) { row in
                    PaymentGuideRowView(row: row)
                }
            }
        }
        .navigationDestination(for: PaymentGuideDestination.self) { destination in
            PaymentGuideScreenView(destination: destination)
        }
    }
}

// MARK: - Cash + Cards

private struct PaymentGuideCashCardsView: View {
    var body: some View {
        PaymentGuideSubPage(destination: .cash) {
            PaymentGuideLead(text: PaymentGuideContent.cashLead)
            PaymentGuideSub(text: PaymentGuideContent.cashSub)

            PaymentGuideSection(title: "How Much Cash to Carry") {
                ForEach(PaymentGuideContent.cashAmountRows) { row in
                    PaymentGuideRowView(row: row)
                }
            }

            PaymentGuideCallout(text: PaymentGuideContent.cashBreakNote)

            PaymentGuideSection(title: "Where to Get Cash") {
                ForEach(PaymentGuideContent.cashSourceRows) { row in
                    PaymentGuideRowView(row: row)
                }
            }

            PaymentGuideSection(title: "Where Physical Cards Work") {
                ForEach(PaymentGuideContent.cashCardRows) { row in
                    PaymentGuideRowView(row: row)
                }
            }

            PaymentGuideCallout(text: PaymentGuideContent.cashDCCWarning, warn: true)

            NavigationLink(value: PaymentGuideDestination.limits) {
                PaymentGuideDeepLink(title: PaymentGuideContent.cashLimitsLink)
            }
            .buttonStyle(.plain)
        }
        .navigationDestination(for: PaymentGuideDestination.self) { destination in
            PaymentGuideScreenView(destination: destination)
        }
    }
}

// MARK: - Prepay

private struct PaymentGuidePrepayView: View {
    var body: some View {
        PaymentGuideSubPage(destination: .prepay) {
            PaymentGuideLead(text: PaymentGuideContent.prepayLead)
            PaymentGuideSub(text: PaymentGuideContent.prepaySub)

            PaymentGuideSection(title: "Best Paid in Advance") {
                ForEach(PaymentGuideContent.prepayRows) { row in
                    PaymentGuideRowView(row: row)
                }
            }

            PaymentGuideCallout(text: PaymentGuideContent.prepayCallout)
        }
    }
}

// MARK: - Payment Failed

private struct PaymentGuideFailedView: View {
    var body: some View {
        PaymentGuideSubPage(destination: .failed) {
            PaymentGuideLead(text: PaymentGuideContent.failedLead)
            PaymentGuideSub(text: PaymentGuideContent.failedSub)

            ForEach(PaymentGuideContent.failedSteps) { step in
                PaymentGuideStepView(step: step)
            }

            PaymentGuideCallout(text: PaymentGuideContent.failedWarning, warn: true)
        }
    }
}

// MARK: - Before You Fly

private struct PaymentGuideBeforeYouFlyView: View {
    @Environment(AppEnvironment.self) private var appEnv

    private var service: PaymentHelperService { appEnv.paymentHelper }
    private var total: Int { PaymentGuideContent.checklistItems.count }

    var body: some View {
        PaymentGuideSubPage(destination: .before) {
            PaymentGuideLead(text: PaymentGuideContent.beforeLead)
            PaymentGuideSub(text: PaymentGuideContent.beforeSub)

            PaymentGuideProgressHeader(done: service.checklistDoneCount, total: total)

            PaymentGuideChecklist(
                items: PaymentGuideContent.checklistItems,
                isDone: { service.isChecklistDone($0) },
                onToggle: { service.toggleChecklist($0) }
            )
        }
    }
}

// MARK: - Phrases

private struct PaymentGuidePhrasesView: View {
    @Environment(AppEnvironment.self) private var appEnv
    @State private var player: AVPlayer?
    @State private var synthesizer = AVSpeechSynthesizer()

    private var service: PaymentHelperService { appEnv.paymentHelper }

    var body: some View {
        PaymentGuideSubPage(destination: .phrases) {
            PaymentGuideLead(text: PaymentGuideContent.phrasesLead)
            PaymentGuideSub(text: PaymentGuideContent.phrasesSub)

            ForEach(service.displayPhrases) { phrase in
                PaymentGuidePhraseView(phrase: phrase) {
                    speak(phrase.chinese)
                }
                .overlay(alignment: .bottomTrailing) {
                    if let url = service.audioURL(for: phrase.id) {
                        Button { playAudio(url) } label: {
                            Image(systemName: "play.circle.fill")
                                .font(.system(size: 18))
                                .foregroundStyle(Theme.ColorToken.accent)
                        }
                        .buttonStyle(.plain)
                        .padding(.bottom, 14)
                    }
                }
            }
        }
    }

    private func speak(_ text: String) {
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "zh-CN")
        utterance.rate = 0.45
        synthesizer.speak(utterance)
    }

    private func playAudio(_ url: URL) {
        player?.pause()
        player = AVPlayer(url: url)
        player?.play()
    }
}

// MARK: - Full Setup

private struct PaymentGuideSetupView: View {
    var body: some View {
        PaymentGuideSubPage(destination: .setup) {
            PaymentGuideLead(text: PaymentGuideContent.setupLead)
            PaymentGuideSub(text: PaymentGuideContent.setupSub)

            PaymentGuideSection(title: "支付宝 Alipay") {
                ForEach(PaymentGuideContent.alipaySetupSteps) { step in
                    PaymentGuideStepView(step: step)
                }
            }

            PaymentGuideSection(title: "微信支付 WeChat Pay") {
                ForEach(PaymentGuideContent.wechatSetupSteps) { step in
                    PaymentGuideStepView(step: step)
                }
            }
        }
    }
}

// MARK: - Limits & Fees

private struct PaymentGuideLimitsView: View {
    var body: some View {
        PaymentGuideSubPage(destination: .limits) {
            PaymentGuideLead(text: PaymentGuideContent.limitsLead)
            PaymentGuideSub(text: PaymentGuideContent.limitsSub)

            PaymentGuideSection(title: "Payment Limits") {
                ForEach(PaymentGuideContent.limitRows) { row in
                    PaymentGuideRowView(row: row)
                }
            }

            PaymentGuideSection(title: "Also Watch For") {
                ForEach(PaymentGuideContent.watchForRows) { row in
                    PaymentGuideRowView(row: row)
                }
            }

            PaymentGuideCallout(text: PaymentGuideContent.limitsWarning, warn: true)
        }
    }
}
