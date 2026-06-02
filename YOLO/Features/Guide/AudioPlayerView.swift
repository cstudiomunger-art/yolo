import AVFoundation
import Combine
import SwiftUI
import UIKit

@MainActor
final class AudioPlaybackController: ObservableObject {
    enum Mode: Equatable {
        case idle
        case loading
        case streaming
        case unavailable(String)
    }

    @Published private(set) var isPlaying = false
    @Published private(set) var progress: Double = 0
    @Published private(set) var mode: Mode = .idle
    @Published private(set) var durationSeconds: Int = 0

    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var timeObserver: Any?
    private var statusObservation: NSKeyValueObservation?
    private var endObserver: NSObjectProtocol?
    private var hasFullAccess = true
    private var freeTrialSeconds: Double = 180
    private var onTrialEnded: (() -> Void)?
    private var configuredGuideId: String?
    private var configuredGuide: AudioGuide?
    private var preferLocalPlayback = true
    private var nowPlayingTitle = ""
    private var nowPlayingArtist = ""

    var canPlay: Bool {
        switch mode {
        case .streaming, .idle:
            return player != nil || playerItem != nil
        case .loading, .unavailable:
            return false
        }
    }

    var previewMaxSeconds: Double { effectiveMaxTime }

    var remainingPreviewSeconds: Double {
        max(0, effectiveMaxTime - progress)
    }

    func configure(
        guide: AudioGuide,
        hasFullAccess: Bool,
        freeTrialSeconds: Double,
        nowPlayingTitle: String,
        nowPlayingArtist: String,
        onTrialEnded: @escaping () -> Void
    ) {
        teardown()
        configuredGuideId = guide.id
        configuredGuide = guide
        preferLocalPlayback = true
        self.hasFullAccess = hasFullAccess
        self.freeTrialSeconds = hasFullAccess ? .greatestFiniteMagnitude : freeTrialSeconds
        self.onTrialEnded = onTrialEnded
        self.nowPlayingTitle = nowPlayingTitle
        self.nowPlayingArtist = nowPlayingArtist
        durationSeconds = max(guide.durationSeconds, 1)

        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        try? AVAudioSession.sharedInstance().setActive(true)

        AudioNowPlayingService.configureRemoteCommands(
            play: { [weak self] in self?.resumeIfPaused() },
            pause: { [weak self] in self?.pauseIfPlaying() },
            toggle: { [weak self] in self?.togglePlay() }
        )

        guard let url = MediaURLResolver.playbackURL(for: guide, preferLocal: preferLocalPlayback) else {
            markUnavailable()
            return
        }

        startStreaming(url: url)
    }

    private func startStreaming(url: URL) {
        clearPlayerObservers()

        mode = .loading
        let item = AVPlayerItem(url: url)
        playerItem = item
        player = AVPlayer(playerItem: item)

        statusObservation = item.observe(\.status, options: [.initial, .new]) { [weak self] item, _ in
            Task { @MainActor in
                self?.handleItemStatus(item)
            }
        }

        endObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: item,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.handlePlaybackEnded(notifyTrial: false)
            }
        }

        addTimeObserver()
    }

    func updateAccess(hasFullAccess: Bool, freeTrialSeconds: Double) {
        self.hasFullAccess = hasFullAccess
        self.freeTrialSeconds = hasFullAccess ? .greatestFiniteMagnitude : freeTrialSeconds
    }

    func reconfigureIfNeeded(
        guide: AudioGuide,
        hasFullAccess: Bool,
        freeTrialSeconds: Double,
        nowPlayingTitle: String,
        nowPlayingArtist: String
    ) {
        guard guide.id == configuredGuideId else { return }
        let savedProgress = progress
        let wasPlaying = isPlaying
        configure(
            guide: guide,
            hasFullAccess: hasFullAccess,
            freeTrialSeconds: freeTrialSeconds,
            nowPlayingTitle: nowPlayingTitle,
            nowPlayingArtist: nowPlayingArtist,
            onTrialEnded: onTrialEnded ?? {}
        )
        seek(to: savedProgress)
        if wasPlaying, canPlay { togglePlay() }
    }

    func activeSegmentIndex(in segments: [AudioSegment]) -> Int? {
        guard !segments.isEmpty else { return nil }
        let seconds = Int(progress.rounded())
        return segments.enumerated().last(where: { $0.element.startSeconds <= seconds })?.offset
    }

    private func resumeIfPaused() {
        guard canPlay, !isPlaying else { return }
        togglePlay()
    }

    private func pauseIfPlaying() {
        guard isPlaying else { return }
        togglePlay()
    }

    func togglePlay() {
        guard canPlay else { return }

        if !hasFullAccess && progress >= effectiveMaxTime {
            onTrialEnded?()
            return
        }

        guard let player, let item = playerItem else { return }

        switch item.status {
        case .readyToPlay:
            if isPlaying {
                player.pause()
                isPlaying = false
                syncNowPlaying()
            } else {
                player.play()
                isPlaying = true
                syncNowPlaying()
            }
        case .failed:
            fallbackAfterStreamFailure()
        default:
            mode = .loading
        }
    }

    func seek(to seconds: Double) {
        let capped = cappedTime(seconds)
        progress = capped
        guard canPlay else { return }
        player?.seek(to: CMTime(seconds: capped, preferredTimescale: 600))
        syncNowPlaying()
    }

    func teardown() {
        clearPlayerObservers()
        player?.pause()
        player = nil
        playerItem = nil
        isPlaying = false
        progress = 0
        mode = .idle
        configuredGuideId = nil
        configuredGuide = nil
        preferLocalPlayback = true
        AudioNowPlayingService.clear()
    }

    private func syncNowPlaying() {
        guard !nowPlayingTitle.isEmpty else { return }
        AudioNowPlayingService.update(
            title: nowPlayingTitle,
            artist: nowPlayingArtist,
            duration: TimeInterval(durationSeconds),
            elapsed: progress,
            isPlaying: isPlaying
        )
    }

    private func clearPlayerObservers() {
        if let endObserver {
            NotificationCenter.default.removeObserver(endObserver)
        }
        endObserver = nil
        statusObservation?.invalidate()
        statusObservation = nil
        if let timeObserver, let player {
            player.removeTimeObserver(timeObserver)
        }
        timeObserver = nil
    }

    private var effectiveMaxTime: Double {
        if hasFullAccess { return Double(durationSeconds) }
        return min(Double(durationSeconds), freeTrialSeconds)
    }

    private func cappedTime(_ seconds: Double) -> Double {
        min(max(0, seconds), effectiveMaxTime)
    }

    private func handleItemStatus(_ item: AVPlayerItem) {
        switch item.status {
        case .readyToPlay:
            let actual = item.duration.seconds
            if actual.isFinite, actual > 1 {
                durationSeconds = Int(actual.rounded())
            }
            mode = .streaming
            syncNowPlaying()
        case .failed:
            fallbackAfterStreamFailure()
        case .unknown:
            mode = .loading
        @unknown default:
            mode = .loading
        }
    }

    private func fallbackAfterStreamFailure() {
        if preferLocalPlayback,
           let guide = configuredGuide,
           MediaURLResolver.audioURL(from: guide.audioUrl) != nil {
            preferLocalPlayback = false
            AudioDownloadService.shared.discardLocalFile(guideId: guide.id)
            let savedProgress = progress
            let wasPlaying = isPlaying
            if let remote = MediaURLResolver.playbackURL(for: guide, preferLocal: false) {
                startStreaming(url: remote)
                seek(to: savedProgress)
                if wasPlaying, canPlay { togglePlay() }
                return
            }
        }

        clearPlayerObservers()
        player?.pause()
        player = nil
        playerItem = nil
        isPlaying = false
        progress = min(progress, effectiveMaxTime)
        markUnavailable()
    }

    private func markUnavailable() {
        clearPlayerObservers()
        player?.pause()
        player = nil
        playerItem = nil
        isPlaying = false
        mode = .unavailable(String(localized: "Audio not available yet."))
    }

    private func handlePlaybackEnded(notifyTrial: Bool = true) {
        isPlaying = false
        progress = effectiveMaxTime
        player?.pause()
        if notifyTrial, !hasFullAccess, freeTrialSeconds < .greatestFiniteMagnitude, progress >= freeTrialSeconds - 0.5 {
            onTrialEnded?()
        }
    }

    private func addTimeObserver() {
        guard let player else { return }
        let interval = CMTime(seconds: 0.5, preferredTimescale: 600)
        timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self else { return }
            Task { @MainActor in
                let seconds = time.seconds
                guard seconds.isFinite else { return }
                self.progress = seconds
                self.syncNowPlaying()

                if seconds >= self.effectiveMaxTime {
                    self.handlePlaybackEnded()
                }
            }
        }
    }
}

// PurchaseOptionsView has been replaced by MembershipPlansView (Features/Purchase/MembershipPlansView.swift).
// This typealias keeps any stray references compiling during the transition.
typealias PurchaseOptionsView = MembershipPlansView

private struct _LegacyPurchaseOptionsViewUnused: View {
    @Environment(AppEnvironment.self) private var appEnv
    @Environment(\.dismiss) private var dismiss
    @State private var showLogin = false
    @State private var showRestoreAlert = false
    @State private var restoreMessage = ""
    @State private var purchaseError: String?

    let attraction: Attraction
    var guide: AudioGuide?
    var onPurchaseComplete: (() -> Void)?

    private var guideDurationLabel: String {
        if let guide {
            return "\(max(guide.durationSeconds / 60, 1)) min"
        }
        let minutes = max(attraction.audioGuideCount * 12, 12)
        return "\(minutes) min"
    }

    private var branding: AppBranding { appEnv.contentMode.branding }
    private var paywall: PaywallCopy { branding.paywall }

    private var paywallSubtitle: String {
        if let override = attraction.paywallSubtitleOverride, !override.isEmpty {
            return override
        }
        return paywall.previewLine(duration: guideDurationLabel)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(paywall.title(for: attraction.name))
                        .font(Theme.FontToken.playfair(20, weight: .semibold))
                    Text(paywallSubtitle)
                        .font(Theme.FontToken.inter(12))
                        .foregroundStyle(Theme.ColorToken.textMuted)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("★ Best Value")
                            .font(Theme.FontToken.inter(9, weight: .medium))
                            .foregroundStyle(Theme.ColorToken.accent)
                        Text(paywall.proTitle)
                            .font(Theme.FontToken.playfair(16, weight: .semibold))
                        Text(paywall.proSubtitle)
                            .font(Theme.FontToken.inter(11))
                            .foregroundStyle(Theme.ColorToken.textMuted)
                        Text("\(branding.iapProPrice) · \(paywall.proPriceHint)")
                            .font(Theme.FontToken.inter(11))
                            .foregroundStyle(Theme.ColorToken.textMuted)
                        VStack(alignment: .leading, spacing: 4) {
                            ForEach(branding.iapProFeatureLines, id: \.self) { line in
                                Text("• \(line)")
                                    .font(Theme.FontToken.inter(11))
                                    .foregroundStyle(Theme.ColorToken.textSecondary)
                            }
                        }
                        Button("\(paywall.proCta) →") {
                            purchase(pro: true)
                        }
                        .font(Theme.FontToken.inter(11, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Theme.ColorToken.textPrimary)
                        .buttonStyle(.plain)
                    }
                    .padding(16)
                    .overlay(Rectangle().stroke(Theme.ColorToken.accent, lineWidth: 1))

                    VStack(alignment: .leading, spacing: 6) {
                        Text(paywall.singleTitle)
                            .font(Theme.FontToken.inter(11, weight: .medium))
                        Text(paywall.singleSubtitle)
                            .font(Theme.FontToken.inter(11))
                            .foregroundStyle(Theme.ColorToken.textMuted)
                        Text(branding.iapSinglePriceLabel)
                            .font(Theme.FontToken.inter(11))
                            .foregroundStyle(Theme.ColorToken.textMuted)
                    }
                    Button(paywall.singleCta) {
                        purchase(pro: false)
                    }
                    .font(Theme.FontToken.inter(11, weight: .medium))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .overlay(Rectangle().stroke(Theme.ColorToken.textPrimary, lineWidth: 1))
                    .buttonStyle(.plain)

                    if let purchaseError {
                        Text(purchaseError)
                            .font(Theme.FontToken.inter(11))
                            .foregroundStyle(.red)
                    }

                    Button(paywall.restore) {
                        restorePurchases()
                    }
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(Theme.ColorToken.textMuted)

                    Button(paywall.maybeLater) {
                        dismiss()
                    }
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(Theme.ColorToken.textMuted)
                    .frame(maxWidth: .infinity)

                    Text(paywall.footnote)
                        .font(Theme.FontToken.inter(10))
                        .foregroundStyle(Theme.ColorToken.textGhost)
                }
                .padding(Theme.screenPadding)
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
            .sheet(isPresented: $showLogin) {
                NavigationStack {
                    LoginView()
                        .environment(appEnv)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Close") { showLogin = false }
                            }
                        }
                }
            }
            .onChange(of: appEnv.auth.isAuthenticated) { _, isAuthenticated in
                if isAuthenticated {
                    showLogin = false
                }
            }
            .alert("Restore Purchases", isPresented: $showRestoreAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(restoreMessage)
            }
        }
        .presentationDetents([.medium, .large])
    }

    private func purchase(pro: Bool) {
        if appEnv.contentMode.useRemoteIAP {
            showLogin = true
            return
        }
        if pro {
            appEnv.preferences.simulateProPurchase = true
        } else {
            appEnv.preferences.purchaseAttraction(attraction.id)
        }
        Task { await appEnv.profileSync.pushToRemote() }
        dismiss()
        onPurchaseComplete?()
    }

    private func restorePurchases() {
        if appEnv.contentMode.useRemoteIAP {
            showLogin = true
            return
        }
        let pro = appEnv.preferences.simulateProPurchase
        let guides = appEnv.preferences.purchasedAttractionIds.count
        if pro || guides > 0 {
            var parts: [String] = []
            if pro { parts.append("YOLO HAPPY Pro") }
            if guides > 0 { parts.append("\(guides) individual guide(s)") }
            restoreMessage = "Restored \(parts.joined(separator: " and ")) from this device."
            onPurchaseComplete?()
        } else {
            restoreMessage = "No purchases found for this Apple ID."
        }
        showRestoreAlert = true
    }
} // end _LegacyPurchaseOptionsViewUnused
