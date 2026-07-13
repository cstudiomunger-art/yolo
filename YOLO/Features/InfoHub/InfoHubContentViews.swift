import SwiftUI
import AVFoundation

// MARK: - Internet access guide

struct InternetAccessGuideView: View {
    @Environment(AppEnvironment.self) private var appEnv

    private var guide: InternetAccessGuide {
        appEnv.infoHub.content.internetAccess
            ?? InfoHubContentService.bundledFallback.internetAccess
            ?? InternetAccessGuide(id: "legal_guide", titleZh: "科学上网指南", titleEn: nil, bodyZh: nil, bodyEn: "")
    }

    private var title: String {
        let zh = guide.titleZh?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let en = guide.titleEn?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if !zh.isEmpty { return zh }
        return en.isEmpty ? "Internet Access" : en
    }

    private var bodyMarkdown: String {
        let zh = guide.bodyZh?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let en = guide.bodyEn?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if !zh.isEmpty { return zh }
        return en
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text(title)
                    .font(Theme.FontToken.playfair(22, weight: .semibold))
                MarkdownContentView(content: bodyMarkdown, fontSize: 14, lineSpacing: 5)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(Theme.screenPadding)
        }
        .navigationTitle("Internet Access")
        .navigationBarTitleDisplayMode(.inline)
        .navigationSwipeBackEnabled()
        .task { await appEnv.infoHub.load() }
    }
}

// MARK: - Transport

struct TransportView: View {
    @Environment(AppEnvironment.self) private var appEnv

    private var tips: [TransportTip] {
        let c = appEnv.infoHub.content
        return c.transport.isEmpty ? InfoHubContentService.bundledFallback.transport : c.transport
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                ForEach(tips) { tip in
                    VStack(alignment: .leading, spacing: 6) {
                        Text("\(categoryEmoji(tip.category)) \(tip.titleZh ?? tip.titleEn ?? "")")
                            .font(Theme.FontToken.inter(15, weight: .semibold))
                        MarkdownContentView(content: tip.bodyZh ?? tip.bodyEn ?? "", fontSize: 13)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(15)
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.ColorToken.border, lineWidth: 1))
                }
            }
            .padding(Theme.screenPadding)
        }
        .navigationTitle("Transport")
        .navigationBarTitleDisplayMode(.inline)
        .navigationSwipeBackEnabled()
        .task { await appEnv.infoHub.load() }
    }

    private func categoryEmoji(_ c: String) -> String {
        switch c { case "rail": return "🚄"; case "taxi": return "🚕"; case "metro": return "🚇"; default: return "🧭" }
    }
}

// MARK: - Phrases & dialect

struct PhrasesView: View {
    @Environment(AppEnvironment.self) private var appEnv
    @State private var dialect: String = ""
    @State private var bigScreen: DialectPhrase?
    @State private var audio = PhraseAudioPlayer()
    @State private var lastPlayedPhraseId: String?

    private var content: InfoHubContent {
        let c = appEnv.infoHub.content
        return (c.common.isEmpty && c.dialect.isEmpty) ? InfoHubContentService.bundledFallback : c
    }
    private var dialects: [String] {
        var seen: [String] = []
        for d in content.dialect where !seen.contains(d.dialect) { seen.append(d.dialect) }
        return seen
    }
    private var currentDialect: String { dialect.isEmpty ? (dialects.first ?? "") : dialect }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Common phrases").font(Theme.FontToken.inter(14, weight: .semibold))
                    Text("常用语").font(Theme.FontToken.inter(11)).foregroundStyle(Theme.ColorToken.textMuted)
                }
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 8)], spacing: 8) {
                    ForEach(content.common) { p in
                        let display = phraseDisplay(en: p.en, cn: p.cn, pinyin: p.pinyin)
                        Button { playPhrase(id: p.id, text: p.cn, url: p.audioUrl) } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 1) {
                                    Text(display.primary).font(Theme.FontToken.inter(13, weight: .medium))
                                    if !display.secondary.isEmpty {
                                        Text(display.secondary)
                                            .font(Theme.FontToken.inter(10))
                                            .foregroundStyle(Theme.ColorToken.textMuted)
                                    }
                                }
                                Spacer()
                                Image(systemName: "speaker.wave.2").font(.system(size: 12)).foregroundStyle(Theme.ColorToken.accent)
                            }
                            .padding(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.ColorToken.border, lineWidth: 1))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .buttonStyle(PhraseCardButtonStyle())
                    }
                }

                if !dialects.isEmpty {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Dialect gems · tap to listen · long-press for large text")
                            .font(Theme.FontToken.inter(14, weight: .semibold))
                        Text("趣味方言").font(Theme.FontToken.inter(11)).foregroundStyle(Theme.ColorToken.textMuted)
                    }
                    .padding(.top, 6)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 14) {
                            ForEach(dialects, id: \.self) { d in
                                Button { dialect = d } label: {
                                    Text(d).font(Theme.FontToken.inter(12, weight: d == currentDialect ? .semibold : .regular))
                                        .foregroundStyle(d == currentDialect ? Theme.ColorToken.textPrimary : Theme.ColorToken.textMuted)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                        ForEach(content.dialect.filter { $0.dialect == currentDialect }) { d in
                            dialectCard(d)
                        }
                    }
                }
            }
            .padding(Theme.screenPadding)
        }
        .navigationTitle("Phrases / Dialect")
        .navigationBarTitleDisplayMode(.inline)
        .sensoryFeedback(.selection, trigger: lastPlayedPhraseId)
        .task { await appEnv.infoHub.load() }
        .fullScreenCover(item: $bigScreen) { d in
            DialectBigScreen(phrase: d)
        }
    }

    private func playPhrase(id: String, text: String, url: String?) {
        lastPlayedPhraseId = id
        audio.play(text: text, url: url)
    }

    private func phraseDisplay(en: String?, cn: String, pinyin: String?) -> (primary: String, secondary: String) {
        let trimmedEn = en?.trimmingCharacters(in: .whitespacesAndNewlines)
        let primary = (trimmedEn?.isEmpty == false ? trimmedEn : nil) ?? cn
        let secondaryParts: [String]
        if primary == cn {
            secondaryParts = [pinyin].compactMap { $0 }.filter { !$0.isEmpty }
        } else {
            secondaryParts = [cn, pinyin].compactMap { $0 }.filter { !$0.isEmpty }
        }
        return (primary, secondaryParts.joined(separator: " · "))
    }

    private func dialectCard(_ d: DialectPhrase) -> some View {
        let display = phraseDisplay(en: d.en, cn: d.cn, pinyin: d.pinyin)
        return Button { playPhrase(id: d.id, text: d.cn, url: d.audioUrl) } label: {
            VStack(spacing: 6) {
                Text(d.emoji ?? "💬").font(.system(size: 34))
                Text(display.primary).font(Theme.FontToken.playfair(15, weight: .semibold))
                if !display.secondary.isEmpty {
                    Text(display.secondary)
                        .font(Theme.FontToken.inter(10))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                        .multilineTextAlignment(.center)
                }
                Text("▶ Listen").font(Theme.FontToken.inter(11)).foregroundStyle(Theme.ColorToken.accent)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.ColorToken.border, lineWidth: 1))
            .contentShape(RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(PhraseCardButtonStyle())
        .onLongPressGesture { bigScreen = d }
    }
}

private struct PhraseCardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .opacity(configuration.isPressed ? 0.88 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

/// Full-screen big text to show a local person.
private struct DialectBigScreen: View {
    @Environment(\.dismiss) private var dismiss
    let phrase: DialectPhrase

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 20) {
                Text(phrase.emoji ?? "💬").font(.system(size: 80))
                Text(phrase.cn).font(.system(size: 52, weight: .heavy)).foregroundStyle(.white).multilineTextAlignment(.center)
                if let p = phrase.pinyin { Text(p).font(.system(size: 18)).foregroundStyle(.white.opacity(0.7)) }
            }
            .padding()
            VStack {
                HStack {
                    Spacer()
                    Button("✕ Close") { dismiss() }.foregroundStyle(.white.opacity(0.7)).padding()
                }
                Spacer()
                Text("Show to locals · Large text").font(.system(size: 12)).foregroundStyle(.white.opacity(0.5)).padding(.bottom, 40)
            }
        }
    }
}

/// Plays uploaded phrase audio when present; falls back to system TTS otherwise.
@MainActor
final class PhraseAudioPlayer {
    private let playback = MediaAVPlayback()
    private let synth = AVSpeechSynthesizer()

    func play(text: String, url: String?) {
        if let url, !url.isEmpty,
           let resolved = MediaURLResolver.resolvedAudioURLs(from: url)
            ?? URL(string: url).map({ CDNRouter.ResolvedMediaURLs(primary: $0, fallback: nil) }) {
            playback.play(resolved: resolved)
        } else {
            playback.stop()
            synth.stopSpeaking(at: .immediate)
            let utt = AVSpeechUtterance(string: text)
            utt.voice = AVSpeechSynthesisVoice(language: "zh-CN")
            utt.rate = 0.45
            synth.speak(utt)
        }
    }
}
