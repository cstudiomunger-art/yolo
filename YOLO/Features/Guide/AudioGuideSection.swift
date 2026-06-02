import SwiftUI

struct AudioGuideSection: View {
    @Environment(AppEnvironment.self) private var appEnv
    @StateObject private var playback = AudioPlaybackController()

    let attraction: Attraction
    let guide: AudioGuide
    var includedWithLabel: String?
    var allowsPreview: Bool = true

    @State private var showPurchase = false
    @State private var accessRefresh = UUID()
    @State private var isDownloading = false
    @State private var downloadError: String?
    @State private var showUnlockedToast = false
    @State private var scrubProgress: Double = 0
    @State private var isScrubbing = false

    private var freeTrialSeconds: Double {
        Double(appEnv.contentMode.branding.freeAudioPreviewSeconds)
    }

    private var hasFullAccess: Bool {
        _ = accessRefresh
        if !appEnv.contentMode.useRemoteIAP { return true }
        return appEnv.purchase.hasAccess(to: \.audioGuides, for: attraction.id)
            || appEnv.preferences.hasAccessToAttraction(attraction.id, iapProductId: attraction.iapProductId)
    }

    private var isDownloaded: Bool {
        AudioDownloadService.shared.isDownloaded(guideId: guide.id)
    }

    private var previewCapSeconds: Int {
        Int(playback.previewMaxSeconds.rounded())
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("🎧")
                Text(guide.titleEn)
                    .font(Theme.FontToken.inter(14, weight: .medium))
                Spacer()
                Text("\(max(guide.durationSeconds / 60, 1)) min")
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(Theme.ColorToken.textMuted)
            }

            if let includedWithLabel {
                Text(includedWithLabel)
                    .font(Theme.FontToken.inter(10))
                    .foregroundStyle(Theme.ColorToken.textMuted)
            }

            if !hasFullAccess, allowsPreview {
                Text(String(localized: "3 min free preview · Unlock full guide"))
                    .font(Theme.FontToken.inter(10))
                    .foregroundStyle(Theme.ColorToken.textMuted)
            }

            if let quote = guide.quote {
                HTMLContentView(content: quote, fontSize: 12)
            }

            statusLine

            if hasFullAccess {
                unlockedControls
            } else {
                lockedControls
            }

            if guide.segments.count > 1 {
                chapterList
            }
        }
        .guideContentCardStyle()
        .sheet(isPresented: $showPurchase) {
            PurchaseOptionsView(attraction: attraction, guide: guide) {
                playback.updateAccess(hasFullAccess: true, freeTrialSeconds: freeTrialSeconds)
                accessRefresh = UUID()
                if playback.progress > 0 {
                    playback.togglePlay()
                }
                showUnlockedToast = true
            }
        }
        .task(id: guide.id) {
            playback.configure(
                guide: guide,
                hasFullAccess: hasFullAccess,
                freeTrialSeconds: allowsPreview ? freeTrialSeconds : 0,
                nowPlayingTitle: guide.titleEn,
                nowPlayingArtist: attraction.name,
                onTrialEnded: { showPurchase = true }
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
        .overlay(alignment: .bottom) {
            if showUnlockedToast {
                Text(String(localized: "🎧 Audio guide unlocked!"))
                    .font(Theme.FontToken.inter(11, weight: .medium))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(Theme.ColorToken.textPrimary)
                    .padding(.bottom, 4)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .onAppear {
                        Task {
                            try? await Task.sleep(for: .seconds(2.5))
                            showUnlockedToast = false
                        }
                    }
            }
        }
        .animation(.easeInOut, value: showUnlockedToast)
    }

    @ViewBuilder
    private var lockedControls: some View {
        let previewMinutes = max(Int(freeTrialSeconds / 60), 1)
        if allowsPreview {
            Button {
                playback.togglePlay()
            } label: {
                if playback.isPlaying {
                    Text(String(localized: "⏸ Pause preview"))
                } else {
                    Text(String(format: String(localized: "▶ Preview (%lld min free)"), previewMinutes))
                }
            }
            .font(Theme.FontToken.inter(12, weight: .medium))
            .foregroundStyle(playback.canPlay ? Theme.ColorToken.textPrimary : Theme.ColorToken.textMuted)
            .buttonStyle(.plain)
            .disabled(!playback.canPlay)
        }

        scrubSlider(maxSeconds: previewCapSeconds)

        Text("\(formatTime(Int(scrubProgress))) / \(formatTime(previewCapSeconds))")
            .font(Theme.FontToken.inter(10))
            .foregroundStyle(Theme.ColorToken.textMuted)

        if allowsPreview, playback.isPlaying, playback.canPlay, playback.remainingPreviewSeconds > 0 {
            Text(String(
                format: String(localized: "%lld sec left in preview"),
                Int(playback.remainingPreviewSeconds.rounded())
            ))
                .font(Theme.FontToken.inter(10))
                .foregroundStyle(Theme.ColorToken.textMuted)
        }

        HStack {
            Text(String(localized: "🔒 Full guide locked"))
                .font(Theme.FontToken.inter(11))
                .foregroundStyle(Theme.ColorToken.textMuted)
            Spacer()
        }

        Button(String(localized: "Unlock Audio Guide")) {
            showPurchase = true
        }
        .font(Theme.FontToken.inter(12, weight: .medium))
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Theme.ColorToken.accent)
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var unlockedControls: some View {
        HStack(spacing: 12) {
            Button {
                playback.togglePlay()
            } label: {
                Text(playback.isPlaying ? String(localized: "⏸ Pause") : String(localized: "▶ Play"))
                    .font(Theme.FontToken.inter(12, weight: .medium))
            }
            .buttonStyle(.plain)
            .disabled(playback.mode == .loading || !playback.canPlay)

            scrubSlider(maxSeconds: playback.durationSeconds)
        }

        Text("\(formatTime(Int(scrubProgress))) / \(formatTime(playback.durationSeconds))")
            .font(Theme.FontToken.inter(10))
            .foregroundStyle(Theme.ColorToken.textMuted)

        downloadRow
    }

    @ViewBuilder
    private func scrubSlider(maxSeconds: Int) -> some View {
        let maxValue = max(Double(maxSeconds), 1)
        Slider(
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
        .disabled(!playback.canPlay && maxSeconds > 0)
    }

    @ViewBuilder
    private var downloadRow: some View {
        if isDownloading {
            ProgressView()
                .frame(maxWidth: .infinity, alignment: .leading)
        } else if isDownloaded {
            HStack {
                Text(String(localized: "✓ Downloaded"))
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(Theme.ColorToken.accent)
                Spacer()
                Button(String(localized: "Remove")) {
                    AudioDownloadService.shared.removeDownload(guideId: guide.id)
                    playback.reconfigureIfNeeded(
                        guide: guide,
                        hasFullAccess: hasFullAccess,
                        freeTrialSeconds: allowsPreview ? freeTrialSeconds : 0,
                        nowPlayingTitle: guide.titleEn,
                        nowPlayingArtist: attraction.name
                    )
                    accessRefresh = UUID()
                }
                .font(Theme.FontToken.inter(10))
                .foregroundStyle(Theme.ColorToken.textMuted)
            }
        } else {
            Button {
                Task { await downloadAudio() }
            } label: {
                Text(String(localized: "⬇ Download for offline"))
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(Theme.ColorToken.textPrimary)
            }
            .buttonStyle(.plain)
            .disabled(!playback.canPlay)
        }
        if let downloadError {
            Text(downloadError)
                .font(Theme.FontToken.inter(10))
                .foregroundStyle(.red)
        }
    }

    @ViewBuilder
    private var statusLine: some View {
        switch playback.mode {
        case .loading:
            Text(String(localized: "Loading audio…"))
                .font(Theme.FontToken.inter(10))
                .foregroundStyle(Theme.ColorToken.textMuted)
        case .unavailable(let message):
            Text(message)
                .font(Theme.FontToken.inter(10))
                .foregroundStyle(.red)
        case .streaming, .idle:
            EmptyView()
        }
    }

    @ViewBuilder
    private var chapterList: some View {
        let segments = guide.segments.sorted { $0.startSeconds < $1.startSeconds }
        VStack(alignment: .leading, spacing: 6) {
            Text(String(localized: "Chapters"))
                .font(Theme.FontToken.inter(11, weight: .medium))
                .foregroundStyle(Theme.ColorToken.textMuted)
            ForEach(Array(segments.enumerated()), id: \.element.id) { index, segment in
                let isActive = playback.activeSegmentIndex(in: segments) == index
                Button {
                    playback.seek(to: Double(segment.startSeconds))
                } label: {
                    HStack {
                        Text(segment.title)
                            .font(Theme.FontToken.inter(12, weight: isActive ? .semibold : .regular))
                            .foregroundStyle(isActive ? Theme.ColorToken.textPrimary : Theme.ColorToken.textSecondary)
                        Spacer()
                        Text(formatTime(segment.startSeconds))
                            .font(Theme.FontToken.inter(10))
                            .foregroundStyle(Theme.ColorToken.textMuted)
                    }
                }
                .buttonStyle(.plain)
                .disabled(!playback.canPlay)
            }
        }
    }

    private func formatTime(_ seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%d:%02d", m, s)
    }

    private func downloadAudio() async {
        isDownloading = true
        downloadError = nil
        defer { isDownloading = false }
        do {
            try await AudioDownloadService.shared.download(guide: guide)
            let trialSeconds = allowsPreview ? freeTrialSeconds : 0
            playback.reconfigureIfNeeded(
                guide: guide,
                hasFullAccess: hasFullAccess,
                freeTrialSeconds: trialSeconds,
                nowPlayingTitle: guide.titleEn,
                nowPlayingArtist: attraction.name
            )
            accessRefresh = UUID()
        } catch {
            downloadError = error.localizedDescription
        }
    }
}
