import SwiftUI
import AVFoundation

// MARK: - Hub

struct PaymentHelperHomeView: View {
    @Environment(AppEnvironment.self) private var appEnv
    @Environment(\.dismiss) private var dismiss

    private var service: PaymentHelperService { appEnv.paymentHelper }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    PaymentGuideHero(
                        fullIntro: {
                            let cms = service.nodeText(nodeKey: "home", slot: "intro", fallback: "")
                            return cms == PaymentGuideContent.hubIntroBold ? nil : (cms.isEmpty ? nil : cms)
                        }()
                    )
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

                    if service.article(id: PaymentGuideCMSArticles.hubFAQ) != nil {
                        PaymentGuideArticlesSection(
                            articles: service.articles(ids: [PaymentGuideCMSArticles.hubFAQ])
                        )
                        .padding(.horizontal, PaymentGuideLayout.horizontalPadding)
                        .padding(.top, 8)
                    }
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
            case .article(let id): PaymentGuideArticleView(articleId: id)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationSwipeBackEnabled()
        .toolbar(.hidden, for: .navigationBar)
    }
}

// MARK: - Sub-page shell

private struct PaymentGuideSubPage<Content: View>: View {
    let destination: PaymentGuideDestination
    var titleOverride: String?
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(spacing: 0) {
            PaymentGuideSubNav(title: titleOverride ?? PaymentGuideContent.screenTitle(for: destination))
            ScrollView {
                PaymentGuidePagePad { content() }
            }
        }
        .safeAreaPadding(.top, 8)
        .background(Theme.ColorToken.background)
    }
}

// MARK: - Article detail

private struct PaymentGuideArticleView: View {
    @Environment(AppEnvironment.self) private var appEnv
    let articleId: String

    private var article: PaymentArticle? {
        appEnv.paymentHelper.article(id: articleId)
    }

    var body: some View {
        PaymentGuideSubPage(
            destination: .article(id: articleId),
            titleOverride: article.map { PaymentGuideCMSMapper.articleTitle($0) }
        ) {
            if let article {
                MarkdownContentView(
                    content: PaymentGuideCMSMapper.articleBody(article),
                    lineSpacing: 5
                )
            } else {
                Text("This guide is no longer available.")
                    .font(Theme.FontToken.inter(13))
                    .foregroundStyle(Theme.ColorToken.textMuted)
            }
        }
        .navigationDestination(for: PaymentGuideDestination.self) { destination in
            PaymentGuideScreenView(destination: destination)
        }
    }
}

// MARK: - Mobile Pay

private struct PaymentGuideMobilePayView: View {
    @Environment(AppEnvironment.self) private var appEnv
    @State private var howSegment = 1

    private var service: PaymentHelperService { appEnv.paymentHelper }

    var body: some View {
        PaymentGuideSubPage(destination: .mobile) {
            PaymentGuideLead(text: service.nodeText(nodeKey: "use", slot: "h1", fallback: PaymentGuideContent.mobileLead))
            PaymentGuideSub(text: service.nodeText(nodeKey: "use", slot: "intro", fallback: PaymentGuideContent.mobileSub))
            PaymentGuideBrandChips(chips: PaymentGuideContent.mobileBrandChips)

            ForEach(Array(service.nodeCallouts(nodeKey: "install").enumerated()), id: \.offset) { _, callout in
                PaymentGuideCallout(text: callout)
            }

            PaymentGuideSection(title: "Before You Fly") {
                ForEach(service.mobileBeforeFlySteps) { step in
                    PaymentGuideStepView(step: step)
                }
                NavigationLink(value: PaymentGuideDestination.setup) {
                    PaymentGuideDeepLink(title: PaymentGuideContent.mobileSetupLink)
                }
                .buttonStyle(.plain)
            }

            PaymentGuideSection(title: "How to Pay In-Store") {
                PaymentGuideSegment(
                    options: service.mobileHowSegments,
                    selectedID: $howSegment
                )
            }

            PaymentGuideSection(title: "Where It Works") {
                if let body = service.articleBody(id: PaymentGuideCMSArticles.mobileGuides[0]) {
                    MarkdownContentView(content: body, fontSize: 13, lineSpacing: 4)
                } else {
                    ForEach(PaymentGuideContent.mobileCoverageRows) { row in
                        PaymentGuideRowView(row: row)
                    }
                }
            }

            PaymentGuideArticlesSection(articles: service.articles(nodeKey: "use"))
            PaymentGuideLinksSection(links: service.helperLinks(lane: "prep"))
        }
        .navigationDestination(for: PaymentGuideDestination.self) { destination in
            PaymentGuideScreenView(destination: destination)
        }
    }
}

// MARK: - Cash + Cards

private struct PaymentGuideCashCardsView: View {
    @Environment(AppEnvironment.self) private var appEnv

    private var service: PaymentHelperService { appEnv.paymentHelper }

    var body: some View {
        PaymentGuideSubPage(destination: .cash) {
            PaymentGuideLead(text: service.nodeText(nodeKey: "card", slot: "h1", fallback: PaymentGuideContent.cashLead))
            PaymentGuideSub(text: PaymentGuideContent.cashSub)

            PaymentGuideSection(title: "How Much Cash to Carry") {
                ForEach(service.cashAmountRows) { row in
                    PaymentGuideRowView(row: row)
                }
            }

            PaymentGuideCallout(text: PaymentGuideContent.cashBreakNote)

            if let body = service.articleBody(id: "cash_guide") {
                PaymentGuideSection(title: "Where to Get Cash") {
                    MarkdownContentView(content: body, fontSize: 13, lineSpacing: 4)
                }
            } else {
                PaymentGuideSection(title: "Where to Get Cash") {
                    ForEach(PaymentGuideContent.cashSourceRows) { row in
                        PaymentGuideRowView(row: row)
                    }
                }
            }

            PaymentGuideSection(title: "Where Physical Cards Work") {
                ForEach(service.cashCardRows) { row in
                    PaymentGuideRowView(row: row)
                }
            }

            PaymentGuideCallout(text: PaymentGuideContent.cashDCCWarning, warn: true)

            NavigationLink(value: PaymentGuideDestination.limits) {
                PaymentGuideDeepLink(title: PaymentGuideContent.cashLimitsLink)
            }
            .buttonStyle(.plain)

            PaymentGuideArticlesSection(articles: service.articles(ids: PaymentGuideCMSArticles.cashGuides))
            PaymentGuideLinksSection(links: service.helperLinks(lane: "prep"))
        }
        .navigationDestination(for: PaymentGuideDestination.self) { destination in
            PaymentGuideScreenView(destination: destination)
        }
    }
}

// MARK: - Prepay

private struct PaymentGuidePrepayView: View {
    @Environment(AppEnvironment.self) private var appEnv

    private var service: PaymentHelperService { appEnv.paymentHelper }

    var body: some View {
        PaymentGuideSubPage(destination: .prepay) {
            PaymentGuideLead(text: PaymentGuideContent.prepayLead)
            PaymentGuideSub(text: PaymentGuideContent.prepaySub)

            if let body = service.articleBody(id: PaymentGuideCMSArticles.prepayGuide) {
                MarkdownContentView(content: body, lineSpacing: 5)
            } else {
                PaymentGuideSection(title: "Best Paid in Advance") {
                    ForEach(PaymentGuideContent.prepayRows) { row in
                        PaymentGuideRowView(row: row)
                    }
                }
                PaymentGuideCallout(text: PaymentGuideContent.prepayCallout)
            }

            PaymentGuideLinksSection(links: service.helperLinks(lane: "prep"))
        }
    }
}

// MARK: - Payment Failed

private struct PaymentGuideFailedView: View {
    @Environment(AppEnvironment.self) private var appEnv

    private var service: PaymentHelperService { appEnv.paymentHelper }

    var body: some View {
        PaymentGuideSubPage(destination: .failed) {
            PaymentGuideLead(text: service.nodeText(nodeKey: "rescue", slot: "h1", fallback: PaymentGuideContent.failedLead))
            PaymentGuideSub(text: PaymentGuideContent.failedSub)

            ForEach(service.failedSteps) { step in
                PaymentGuideStepView(step: step)
            }

            PaymentGuideCallout(text: PaymentGuideContent.failedWarning, warn: true)

            PaymentGuideLinksSection(links: service.helperLinks(lane: "rescue"))
        }
    }
}

// MARK: - Before You Fly

private struct PaymentGuideBeforeYouFlyView: View {
    @Environment(AppEnvironment.self) private var appEnv

    private var service: PaymentHelperService { appEnv.paymentHelper }
    private var total: Int { service.checklistEntries.count }

    var body: some View {
        PaymentGuideSubPage(destination: .before) {
            PaymentGuideLead(text: service.nodeText(nodeKey: "plan", slot: "h1", fallback: PaymentGuideContent.beforeLead))
            PaymentGuideSub(text: PaymentGuideContent.beforeSub)

            PaymentGuideProgressHeader(done: service.checklistDoneCount, total: total)

            PaymentGuideChecklist(
                items: service.checklistEntries,
                isDone: { service.isChecklistDone($0) },
                onToggle: { service.toggleChecklist($0) }
            )

            PaymentGuideArticlesSection(articles: service.articles(ids: ["pre_trip_checklist"]))
            PaymentGuideLinksSection(links: service.helperLinks(lane: "prep"))
        }
    }
}

// MARK: - Phrases

private struct PaymentGuidePhrasesView: View {
    @Environment(AppEnvironment.self) private var appEnv
    @State private var playback = MediaAVPlayback()
    @State private var synthesizer = AVSpeechSynthesizer()

    private var service: PaymentHelperService { appEnv.paymentHelper }

    var body: some View {
        PaymentGuideSubPage(destination: .phrases) {
            PaymentGuideLead(text: service.nodeText(nodeKey: "merchant", slot: "h1", fallback: PaymentGuideContent.phrasesLead))
            PaymentGuideSub(text: PaymentGuideContent.phrasesSub)

            ForEach(service.displayPhrases) { phrase in
                PaymentGuidePhraseView(phrase: phrase) {
                    speak(phrase.chinese)
                }
                .overlay(alignment: .bottomTrailing) {
                    if service.resolvedAudioURLs(for: phrase.id) != nil {
                        Button { playAudio(phraseID: phrase.id) } label: {
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

    private func playAudio(phraseID: String) {
        guard let resolved = service.resolvedAudioURLs(for: phraseID) else { return }
        playback.play(resolved: resolved)
    }
}

// MARK: - Full Setup

private struct PaymentGuideSetupView: View {
    @Environment(AppEnvironment.self) private var appEnv

    private var service: PaymentHelperService { appEnv.paymentHelper }

    var body: some View {
        PaymentGuideSubPage(destination: .setup) {
            PaymentGuideLead(text: service.nodeText(nodeKey: "bind", slot: "h1", fallback: PaymentGuideContent.setupLead))
            PaymentGuideSub(text: service.nodeText(nodeKey: "bind", slot: "intro", fallback: PaymentGuideContent.setupSub))

            ForEach(Array(service.nodeCallouts(nodeKey: "verify").enumerated()), id: \.offset) { _, callout in
                PaymentGuideCallout(text: callout)
            }

            PaymentGuideSection(title: "支付宝 Alipay") {
                ForEach(service.alipaySetupSteps) { step in
                    PaymentGuideStepView(step: step)
                }
            }

            PaymentGuideSection(title: "微信支付 WeChat Pay") {
                ForEach(service.wechatSetupSteps) { step in
                    PaymentGuideStepView(step: step)
                }
            }

            PaymentGuideArticlesSection(articles: service.articles(nodeKey: "bind"))

            if !service.chinaSteps.isEmpty {
                PaymentGuideSection(title: "Already in China?") {
                    ForEach(service.chinaSteps) { step in
                        PaymentGuideStepView(step: step)
                    }
                }
            }

            PaymentGuideLinksSection(links: service.helperLinks(lane: "china"))
        }
        .navigationDestination(for: PaymentGuideDestination.self) { destination in
            PaymentGuideScreenView(destination: destination)
        }
    }
}

// MARK: - Limits & Fees

private struct PaymentGuideLimitsView: View {
    @Environment(AppEnvironment.self) private var appEnv

    private var service: PaymentHelperService { appEnv.paymentHelper }

    var body: some View {
        PaymentGuideSubPage(destination: .limits) {
            PaymentGuideLead(text: PaymentGuideContent.limitsLead)
            PaymentGuideSub(text: PaymentGuideContent.limitsSub)

            if let body = service.articleBody(id: PaymentGuideCMSArticles.limitsGuide) {
                MarkdownContentView(content: body, lineSpacing: 5)
            } else {
                PaymentGuideSection(title: "Payment Limits") {
                    ForEach(PaymentGuideContent.limitRows) { row in
                        PaymentGuideRowView(row: row)
                    }
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
