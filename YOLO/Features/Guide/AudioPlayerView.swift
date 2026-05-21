import AVFoundation
import Combine
import SwiftUI

@MainActor
final class AudioPlaybackController: ObservableObject {
    enum Mode: Equatable {
        case idle
        case loading
        case streaming
        case simulation
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
    private var usesSimulation = false
    private var hasFullAccess = true
    private var freeTrialSeconds: Double = 180
    private var onTrialEnded: (() -> Void)?
    private var configuredGuideId: String?
    private var configuredGuide: AudioGuide?
    private var preferLocalPlayback = true

    func configure(
        guide: AudioGuide,
        hasFullAccess: Bool,
        freeTrialSeconds: Double,
        onTrialEnded: @escaping () -> Void
    ) {
        teardown()
        configuredGuideId = guide.id
        configuredGuide = guide
        preferLocalPlayback = true
        self.hasFullAccess = hasFullAccess
        self.freeTrialSeconds = hasFullAccess ? .greatestFiniteMagnitude : freeTrialSeconds
        self.onTrialEnded = onTrialEnded
        durationSeconds = max(guide.durationSeconds, 1)

        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        try? AVAudioSession.sharedInstance().setActive(true)

        guard let url = MediaURLResolver.playbackURL(for: guide, preferLocal: preferLocalPlayback) else {
            usesSimulation = true
            mode = .simulation
            return
        }

        startStreaming(url: url)
    }

    private func startStreaming(url: URL) {
        clearPlayerObservers()

        usesSimulation = false
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

    func reconfigureIfNeeded(guide: AudioGuide, hasFullAccess: Bool, freeTrialSeconds: Double) {
        guard guide.id == configuredGuideId else { return }
        let savedProgress = progress
        let wasPlaying = isPlaying
        configure(
            guide: guide,
            hasFullAccess: hasFullAccess,
            freeTrialSeconds: freeTrialSeconds,
            onTrialEnded: onTrialEnded ?? {}
        )
        seek(to: savedProgress)
        if wasPlaying { togglePlay() }
    }

    func togglePlay() {
        if !hasFullAccess && progress >= effectiveMaxTime {
            onTrialEnded?()
            return
        }

        if usesSimulation {
            isPlaying.toggle()
            if isPlaying {
                startSimulation()
            } else {
                simulationTimer?.invalidate()
                simulationTimer = nil
            }
            return
        }

        guard let player, let item = playerItem else { return }

        switch item.status {
        case .readyToPlay:
            if isPlaying {
                player.pause()
                isPlaying = false
            } else {
                player.play()
                isPlaying = true
            }
        case .failed:
            fallbackToSimulation()
        default:
            mode = .loading
        }
    }

    func seek(to seconds: Double) {
        let capped = cappedTime(seconds)
        progress = capped
        if usesSimulation { return }
        player?.seek(to: CMTime(seconds: capped, preferredTimescale: 600))
    }

    func teardown() {
        simulationTimer?.invalidate()
        simulationTimer = nil
        clearPlayerObservers()
        player?.pause()
        player = nil
        playerItem = nil
        isPlaying = false
        progress = 0
        mode = .idle
        usesSimulation = false
        configuredGuideId = nil
        configuredGuide = nil
        preferLocalPlayback = true
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

    private var simulationTimer: Timer?

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
        case .failed:
            fallbackToSimulation()
        case .unknown:
            mode = .loading
        @unknown default:
            mode = .loading
        }
    }

    private func fallbackToSimulation() {
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
                if wasPlaying { togglePlay() }
                return
            }
        }

        clearPlayerObservers()
        player?.pause()
        player = nil
        playerItem = nil
        usesSimulation = true
        isPlaying = false
        progress = min(progress, effectiveMaxTime)
        mode = .simulation
    }

    private func handlePlaybackEnded(notifyTrial: Bool = true) {
        isPlaying = false
        progress = effectiveMaxTime
        player?.pause()
        if notifyTrial, !hasFullAccess, freeTrialSeconds > 0, progress >= freeTrialSeconds - 0.5 {
            onTrialEnded?()
        }
    }

    private func addTimeObserver() {
        guard let player else { return }
        let interval = CMTime(seconds: 0.5, preferredTimescale: 600)
        timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self else { return }
            Task { @MainActor in
                guard !self.usesSimulation else { return }
                let seconds = time.seconds
                guard seconds.isFinite else { return }
                self.progress = seconds

                if seconds >= self.effectiveMaxTime {
                    self.handlePlaybackEnded()
                }
            }
        }
    }

    private func startSimulation() {
        simulationTimer?.invalidate()
        simulationTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            Task { @MainActor in
                guard self.isPlaying else { return }
                self.progress += 1
                if self.progress >= self.effectiveMaxTime {
                    self.isPlaying = false
                    self.progress = self.effectiveMaxTime
                    self.simulationTimer?.invalidate()
                    if !self.hasFullAccess {
                        self.onTrialEnded?()
                    }
                }
            }
        }
    }
}

struct PurchaseOptionsView: View {
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
            if pro { parts.append("ChinaGo Pro") }
            if guides > 0 { parts.append("\(guides) individual guide(s)") }
            restoreMessage = "Restored \(parts.joined(separator: " and ")) from this device."
            onPurchaseComplete?()
        } else {
            restoreMessage = "No purchases found for this Apple ID."
        }
        showRestoreAlert = true
    }
}
