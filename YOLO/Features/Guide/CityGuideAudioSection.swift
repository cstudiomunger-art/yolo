import SwiftUI

struct CityGuideAudioSection: View {
    @StateObject private var playback = AudioPlaybackController()

    let guide: CityGuide
    let audioGuide: AudioGuide

    @State private var scrubProgress: Double = 0
    @State private var isScrubbing = false
    @State private var transcriptExpanded = false

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
                    playback.togglePlay()
                } label: {
                    Text(playback.isPlaying ? String(localized: "⏸ Pause") : String(localized: "▶ Play"))
                        .font(Theme.FontToken.inter(12, weight: .medium))
                }
                .buttonStyle(.plain)
                .disabled(playback.mode == .loading || !playback.canPlay)

                scrubSlider
            }

            Text("\(formatTime(Int(scrubProgress))) / \(formatTime(playback.durationSeconds))")
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
        .task(id: audioGuide.id) {
            playback.configure(
                guide: audioGuide,
                hasFullAccess: true,
                freeTrialSeconds: 0,
                nowPlayingTitle: audioGuide.titleEn,
                nowPlayingArtist: guide.titleEn,
                onTrialEnded: {}
            )
            scrubProgress = playback.progress
        }
        .onChange(of: playback.progress) { _, newValue in
            if !isScrubbing {
                scrubProgress = newValue
            }
        }
        .onDisappear {
            if !playback.isPlaying {
                playback.teardown()
            }
        }
    }

    private var scrubSlider: some View {
        let maxValue = max(Double(playback.durationSeconds), 1)
        return Slider(
            value: Binding(
                get: { min(scrubProgress, maxValue) },
                set: { newValue in
                    scrubProgress = newValue
                    if !isScrubbing {
                        playback.seek(to: newValue)
                    }
                }
            ),
            in: 0...maxValue,
            onEditingChanged: { editing in
                isScrubbing = editing
                if !editing {
                    playback.seek(to: scrubProgress)
                }
            }
        )
        .tint(Theme.ColorToken.accent)
        .disabled(!playback.canPlay && playback.durationSeconds > 0)
    }

    private func formatTime(_ seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%d:%02d", m, s)
    }
}
