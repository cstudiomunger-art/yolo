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

    private var freeTrialSeconds: Double {
        Double(appEnv.contentMode.branding.freeAudioPreviewSeconds)
    }

    private var hasFullAccess: Bool {
        _ = accessRefresh
        return appEnv.preferences.hasAccessToAttraction(attraction.id, iapProductId: attraction.iapProductId)
            || !appEnv.contentMode.useRemoteIAP
    }

    private var isDownloaded: Bool {
        AudioDownloadService.shared.isDownloaded(guideId: guide.id)
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

            if let quote = guide.quote {
                HTMLContentView(content: quote, fontSize: 12)
            }

            statusLine

            if hasFullAccess {
                unlockedControls
            } else {
                lockedControls
            }
        }
        .padding(14)
        .background(Theme.ColorToken.backgroundSubtle)
        .overlay(Rectangle().stroke(Theme.ColorToken.border, lineWidth: 1))
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
                onTrialEnded: { showPurchase = true }
            )
        }
        .onDisappear {
            playback.teardown()
        }
        .overlay(alignment: .bottom) {
            if showUnlockedToast {
                Text("🎧 Audio guide unlocked!")
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
                Text(playback.isPlaying ? "⏸ Pause preview" : "▶ Preview (\(previewMinutes) min free)")
                    .font(Theme.FontToken.inter(12, weight: .medium))
                    .foregroundStyle(Theme.ColorToken.textPrimary)
            }
            .buttonStyle(.plain)
        }

        progressBar

        HStack {
            Text("🔒 Full guide locked")
                .font(Theme.FontToken.inter(11))
                .foregroundStyle(Theme.ColorToken.textMuted)
            Spacer()
        }

        Button("Unlock Audio Guide") {
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
                Text(playback.isPlaying ? "⏸ Pause" : "▶ Play")
                    .font(Theme.FontToken.inter(12, weight: .medium))
            }
            .buttonStyle(.plain)
            .disabled(playback.mode == .loading)

            progressBar
        }

        Text("\(formatTime(Int(playback.progress))) / \(formatTime(playback.durationSeconds))")
            .font(Theme.FontToken.inter(10))
            .foregroundStyle(Theme.ColorToken.textMuted)

        downloadRow
    }

    @ViewBuilder
    private var downloadRow: some View {
        if isDownloading {
            ProgressView()
                .frame(maxWidth: .infinity, alignment: .leading)
        } else if isDownloaded {
            HStack {
                Text("✓ Downloaded")
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(Theme.ColorToken.accent)
                Spacer()
                Button("Remove") {
                    AudioDownloadService.shared.removeDownload(guideId: guide.id)
                    playback.reconfigureIfNeeded(
                        guide: guide,
                        hasFullAccess: hasFullAccess,
                        freeTrialSeconds: allowsPreview ? freeTrialSeconds : 0
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
                Text("⬇ Download for offline")
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(Theme.ColorToken.textPrimary)
            }
            .buttonStyle(.plain)
        }
        if let downloadError {
            Text(downloadError)
                .font(Theme.FontToken.inter(10))
                .foregroundStyle(.red)
        }
    }

    private var progressBar: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Rectangle().fill(Theme.ColorToken.border).frame(height: 2)
                Rectangle()
                    .fill(Theme.ColorToken.accent)
                    .frame(width: geo.size.width * progressRatio, height: 2)
            }
        }
        .frame(height: 2)
    }

    @ViewBuilder
    private var statusLine: some View {
        switch playback.mode {
        case .loading:
            Text("Loading audio…")
                .font(Theme.FontToken.inter(10))
                .foregroundStyle(Theme.ColorToken.textMuted)
        case .simulation:
            Text("Preview mode — upload MP3 in CMS to enable streaming.")
                .font(Theme.FontToken.inter(10))
                .foregroundStyle(Theme.ColorToken.warning)
        case .unavailable(let message):
            Text(message)
                .font(Theme.FontToken.inter(10))
                .foregroundStyle(.red)
        case .streaming, .idle:
            EmptyView()
        }
    }

    private var progressRatio: CGFloat {
        let total = max(playback.durationSeconds, 1)
        return min(CGFloat(playback.progress / Double(total)), 1)
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
                freeTrialSeconds: trialSeconds
            )
            accessRefresh = UUID()
        } catch {
            downloadError = error.localizedDescription
        }
    }
}
