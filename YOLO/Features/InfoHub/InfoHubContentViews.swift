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
        return en.isEmpty ? "科学上网" : en
    }

    private var bodyHTML: String {
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
                HTMLContentView(content: bodyHTML, fontSize: 14, lineSpacing: 5)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(Theme.screenPadding)
        }
        .navigationTitle("科学上网")
        .navigationBarTitleDisplayMode(.inline)
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
                        Text(tip.bodyZh ?? tip.bodyEn ?? "")
                            .font(Theme.FontToken.inter(13)).foregroundStyle(Theme.ColorToken.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(15)
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.ColorToken.border, lineWidth: 1))
                }
            }
            .padding(Theme.screenPadding)
        }
        .navigationTitle("交通")
        .navigationBarTitleDisplayMode(.inline)
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
                Text("💬 常用语").font(Theme.FontToken.inter(14, weight: .semibold))
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 8)], spacing: 8) {
                    ForEach(content.common) { p in
                        Button { audio.play(text: p.cn, url: p.audioUrl) } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 1) {
                                    Text(p.cn).font(Theme.FontToken.inter(13, weight: .medium))
                                    Text([p.pinyin, p.en].compactMap { $0 }.joined(separator: " · "))
                                        .font(Theme.FontToken.inter(10)).foregroundStyle(Theme.ColorToken.textMuted)
                                }
                                Spacer()
                                Image(systemName: "speaker.wave.2").font(.system(size: 12)).foregroundStyle(Theme.ColorToken.accent)
                            }
                            .padding(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.ColorToken.border, lineWidth: 1))
                        }
                        .buttonStyle(.plain)
                    }
                }

                if !dialects.isEmpty {
                    Text("🗣 方言彩蛋 · 长按卡片给本地人看大字")
                        .font(Theme.FontToken.inter(14, weight: .semibold)).padding(.top, 6)
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
        .navigationTitle("表达 / 方言")
        .navigationBarTitleDisplayMode(.inline)
        .task { await appEnv.infoHub.load() }
        .fullScreenCover(item: $bigScreen) { d in
            DialectBigScreen(phrase: d)
        }
    }

    private func dialectCard(_ d: DialectPhrase) -> some View {
        VStack(spacing: 6) {
            Text(d.emoji ?? "💬").font(.system(size: 34))
            Text(d.cn).font(Theme.FontToken.playfair(15, weight: .semibold))
            Text([d.pinyin, d.en].compactMap { $0 }.joined(separator: " · "))
                .font(Theme.FontToken.inter(10)).foregroundStyle(Theme.ColorToken.textMuted)
                .multilineTextAlignment(.center)
            Button { audio.play(text: d.cn, url: d.audioUrl) } label: {
                Text("▶ 听").font(Theme.FontToken.inter(11)).foregroundStyle(Theme.ColorToken.accent)
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.ColorToken.border, lineWidth: 1))
        .onLongPressGesture { bigScreen = d }
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
                    Button("✕ 收起") { dismiss() }.foregroundStyle(.white.opacity(0.7)).padding()
                }
                Spacer()
                Text("把屏幕转给本地人看 · 大字模式").font(.system(size: 12)).foregroundStyle(.white.opacity(0.5)).padding(.bottom, 40)
            }
        }
    }
}

/// Plays uploaded phrase audio when present; falls back to system TTS otherwise.
final class PhraseAudioPlayer {
    private var player: AVPlayer?
    private let synth = AVSpeechSynthesizer()

    func play(text: String, url: String?) {
        if let url, !url.isEmpty, let u = URL(string: url) {
            player = AVPlayer(url: u)
            player?.play()
        } else {
            synth.stopSpeaking(at: .immediate)
            let utt = AVSpeechUtterance(string: text)
            utt.voice = AVSpeechSynthesisVoice(language: "zh-CN")
            utt.rate = 0.45
            synth.speak(utt)
        }
    }
}
