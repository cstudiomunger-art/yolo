import SwiftUI

struct CityGuideAudioSection: View {
    @Environment(AppEnvironment.self) private var appEnv

    let guide: CityGuide
    let audioGuide: AudioGuide

    @State private var scrubProgress: Double = 0
    @State private var isScrubbing = false
    @State private var transcriptExpanded = false

    private var player: AudioQueuePlayer { appEnv.audioPlayer }
    private var isActive: Bool { player.currentTrackId == audioGuide.id }
    private var isPlayingThis: Bool { isActive && player.isPlaying }
    private var displayMode: AudioQueuePlayer.Mode { isActive ? player.mode : .idle }
    private var canPlayThis: Bool { isActive ? player.canPlay : true }
    private var displayDuration: Int {
        isActive ? player.durationSeconds : max(audioGuide.durationSeconds, 1)
    }

    private var selfTrack: AudioTrack {
        AudioTrack(
            guide: audioGuide,
            title: audioGuide.titleEn,
            artist: guide.titleEn,
            allowsPreview: false,
            isFree: true
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                Text("🎧")
                Text(audioGuide.titleEn)
                    .font(Theme.FontToken.inter(14, weight: .medium))
                Spacer()
                if audioGuide.durationSeconds > 0 {
                    Text("\(max(audioGuide.durationSeconds / 60, 1)) min")
                        .font(Theme.FontToken.inter(11))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                }
            }

            Text(String(localized: "Free"))
                .font(Theme.FontToken.inter(9, weight: .medium))
                .foregroundStyle(Theme.ColorToken.accent)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(Theme.ColorToken.accent, lineWidth: 1)
                )

            if let quote = audioGuide.quote, !quote.isEmpty {
                HTMLContentView(content: quote, fontSize: 12)
            }

            HStack(spacing: 12) {
                Button {
                    startOrToggle()
                } label: {
                    Text(isPlayingThis ? String(localized: "⏸ Pause") : String(localized: "▶ Play"))
                        .font(Theme.FontToken.inter(12, weight: .medium))
                }
                .buttonStyle(.plain)
                .disabled(displayMode == .loading || !canPlayThis)

                scrubSlider
            }

            Text("\(formatTime(Int(scrubProgress))) / \(formatTime(displayDuration))")
                .font(Theme.FontToken.inter(10))
                .foregroundStyle(Theme.ColorToken.textMuted)

            if let transcript = guide.audioTranscript?.trimmingCharacters(in: .whitespacesAndNewlines),
               !transcript.isEmpty {
                Button {
                    transcriptExpanded.toggle()
                } label: {
                    HStack {
                        Text("📝 \(String(localized: "Audio transcript"))")
                            .font(Theme.FontToken.inter(11, weight: .medium))
                        Spacer()
                        Text(transcriptExpanded ? "▴" : "▾")
                            .font(Theme.FontToken.inter(10))
                    }
                    .foregroundStyle(Theme.ColorToken.accent)
                }
                .buttonStyle(.plain)

                if transcriptExpanded {
                    HTMLContentView(content: transcript, fontSize: 11)
                        .padding(12)
                        .background(Theme.ColorToken.backgroundSubtle)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }
            }
        }
        .guideContentCardStyle()
        .onAppear {
            if isActive { scrubProgress = player.progress }
        }
        .onChange(of: player.progress) { _, newValue in
            if isActive, !isScrubbing { scrubProgress = newValue }
        }
        .onChange(of: isActive) { _, active in
            if active {
                scrubProgress = player.progress
            } else {
                scrubProgress = 0
                isScrubbing = false
            }
        }
    }

    private func startOrToggle() {
        if isActive {
            player.togglePlay()
        } else {
            player.play(queue: [selfTrack], startIndex: 0)
        }
    }

    private var scrubSlider: some View {
        let maxValue = max(Double(displayDuration), 1)
        return Slider(
            value: Binding(
                get: { min(scrubProgress, maxValue) },
                set: { newValue in
                    scrubProgress = newValue
                    if isActive, !isScrubbing {
                        player.seek(to: newValue)
                    }
                }
            ),
            in: 0...maxValue,
            onEditingChanged: { editing in
                isScrubbing = editing
                if !editing {
                    if isActive {
                        player.seek(to: scrubProgress)
                    } else {
                        player.play(queue: [selfTrack], startIndex: 0)
                    }
                }
            }
        )
        .tint(Theme.ColorToken.accent)
        .disabled(!isActive)
    }

    private func formatTime(_ seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%d:%02d", m, s)
    }
}
