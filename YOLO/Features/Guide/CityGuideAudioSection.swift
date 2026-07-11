import SwiftUI

struct CityGuideAudioSection: View {
    @Environment(AppEnvironment.self) private var appEnv

    let guide: CityGuide
    let audioGuide: AudioGuide

    @State private var scrubProgress: Double = 0
    @State private var isScrubbing = false
    @State private var showTranscript = false
    @State private var voiceVariants: [AudioVoiceVariant] = []
    @State private var selectedVariantId: String?

    private var voiceOwner: AudioVoiceOwner {
        AudioVoiceOwner(type: .cityGuide, id: guide.id)
    }

    private var player: AudioQueuePlayer { appEnv.audioPlayer }

    private var playbackGuide: AudioGuide {
        guard !voiceVariants.isEmpty else { return audioGuide }
        return AudioPlaybackResolver.resolve(
            baseGuide: audioGuide,
            variants: voiceVariants,
            preferredVariantId: selectedVariantId
        )
    }

    private var isActive: Bool {
        guard let track = player.currentTrack else { return false }
        return AudioPlaybackResolver.trackMatchesSection(
            track: track,
            baseGuideId: audioGuide.id,
            voiceOwner: voiceOwner
        )
    }
    private var isPlayingThis: Bool { isActive && player.isPlaying }
    private var displayMode: AudioQueuePlayer.Mode { isActive ? player.mode : .idle }
    private var canPlayThis: Bool { isActive ? player.canPlay : true }
    private var displayDuration: Int {
        isActive ? player.durationSeconds : max(playbackGuide.durationSeconds, 1)
    }

    private var selfTrack: AudioTrack {
        AudioTrack(
            guide: playbackGuide,
            title: playbackGuide.titleEn,
            artist: guide.titleEn,
            allowsPreview: false,
            isFree: true,
            voiceOwner: voiceOwner,
            baseGuide: audioGuide
        )
    }

    private var transcriptText: String? {
        AudioTranscriptResolver.normalized(guide.audioTranscript)
            ?? AudioTranscriptResolver.text(for: playbackGuide)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center, spacing: 8) {
                Text("🎧")
                Text(audioGuide.titleEn)
                    .font(Theme.FontToken.inter(14, weight: .medium))
                    .lineLimit(2)
                Spacer(minLength: 4)
                if voiceVariants.count > 1 {
                    AudioVoicePicker(
                        variants: voiceVariants,
                        selectedVariantId: selectedVariantId ?? AudioPlaybackResolver.selectedVariant(
                            from: voiceVariants,
                            preferredVariantId: selectedVariantId
                        )?.id
                    ) { variant in
                        selectVoice(variant)
                    }
                }
                if playbackGuide.durationSeconds > 0 {
                    Text("\(max(playbackGuide.durationSeconds / 60, 1)) min")
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
                MarkdownContentView(content: quote, fontSize: 12)
            }

            HStack(spacing: 12) {
                Button {
                    startOrToggle()
                } label: {
                    Text(isPlayingThis ? String(localized: "⏸ Pause") : String(localized: "▶ Play"))
                        .font(Theme.FontToken.inter(14, weight: .medium))
                        .padding(.vertical, 4)
                }
                .buttonStyle(.plain)
                .disabled(displayMode == .loading || !canPlayThis)

                scrubSlider
            }

            Text("\(formatTime(Int(scrubProgress))) / \(formatTime(displayDuration))")
                .font(Theme.FontToken.inter(10))
                .foregroundStyle(Theme.ColorToken.textMuted)

            if transcriptText != nil {
                HStack {
                    Spacer()
                    AudioTranscriptButton { showTranscript = true }
                }
            }
        }
        .guideContentCardStyle()
        .sheet(isPresented: $showTranscript) {
            if let transcript = transcriptText {
                AudioTranscriptSheet(
                    title: audioGuide.titleEn,
                    transcript: transcript
                )
            }
        }
        .task(id: guide.id) {
            await loadVoiceVariants()
        }
        .onAppear {
            syncVoiceFromPlayer()
            if isActive { scrubProgress = player.progress }
        }
        .onChange(of: player.currentTrackId) { _, _ in
            syncVoiceFromPlayer()
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

    private func loadVoiceVariants() async {
        voiceVariants = await AudioVoicePlaybackSupport.loadVariants(
            owner: voiceOwner,
            content: appEnv.content
        )
        selectedVariantId = appEnv.preferences.preferredVoiceVariantId(for: voiceOwner)
    }

    private func selectVoice(_ variant: AudioVoiceVariant) {
        if isActive { player.close() }
        selectedVariantId = variant.id
        appEnv.preferences.setPreferredVoiceVariantId(variant.id, for: voiceOwner)
        scrubProgress = 0
    }

    private func syncVoiceFromPlayer() {
        guard let track = player.currentTrack,
              AudioPlaybackResolver.trackMatchesSection(
                  track: track,
                  baseGuideId: audioGuide.id,
                  voiceOwner: voiceOwner
              ),
              let variantId = AudioPlaybackResolver.variantId(from: track.guide.id, baseGuideId: audioGuide.id)
        else { return }
        guard selectedVariantId != variantId else { return }
        selectedVariantId = variantId
    }
}
