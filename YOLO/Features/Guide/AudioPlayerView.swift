import AVFoundation
import Combine
import SwiftUI

@MainActor
final class AudioPlaybackController: ObservableObject {
    @Published var isPlaying = false
    @Published var progress: Double = 0

    private var player: AVPlayer?
    private var timeObserver: Any?
    private var usesSimulation = false
    private var durationSeconds: Int = 0
    private var simulationTimer: Timer?

    func configure(guide: AudioGuide) {
        teardown()
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        try? AVAudioSession.sharedInstance().setActive(true)
        durationSeconds = max(guide.durationSeconds, 1)
        let trimmed = guide.audioUrl.trimmingCharacters(in: .whitespacesAndNewlines)
        if let url = URL(string: trimmed), let scheme = url.scheme, !scheme.isEmpty {
            let item = AVPlayerItem(url: url)
            player = AVPlayer(playerItem: item)
            usesSimulation = false
            addTimeObserver()
        } else {
            usesSimulation = true
        }
    }

    func togglePlay(hasFullAccess: Bool, freeTrialSeconds: Double, onTrialEnded: @escaping () -> Void) {
        if !hasFullAccess && progress >= freeTrialSeconds {
            onTrialEnded()
            return
        }
        if usesSimulation {
            isPlaying.toggle()
            if isPlaying {
                startSimulation(hasFullAccess: hasFullAccess, freeTrialSeconds: freeTrialSeconds, onTrialEnded: onTrialEnded)
            } else {
                simulationTimer?.invalidate()
                simulationTimer = nil
            }
            return
        }
        guard let player else { return }
        if isPlaying {
            player.pause()
            isPlaying = false
        } else {
            player.play()
            isPlaying = true
        }
    }

    func seek(to seconds: Double, hasFullAccess: Bool, freeTrialSeconds: Double) {
        let capped = hasFullAccess ? seconds : min(seconds, freeTrialSeconds)
        progress = capped
        if usesSimulation { return }
        player?.seek(to: CMTime(seconds: capped, preferredTimescale: 600))
    }

    func teardown() {
        simulationTimer?.invalidate()
        simulationTimer = nil
        if let timeObserver, let player {
            player.removeTimeObserver(timeObserver)
        }
        timeObserver = nil
        player?.pause()
        player = nil
        isPlaying = false
        progress = 0
    }

    private func addTimeObserver() {
        guard let player else { return }
        let interval = CMTime(seconds: 0.5, preferredTimescale: 600)
        timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self else { return }
            Task { @MainActor in
                self.progress = time.seconds
                if time.seconds >= Double(self.durationSeconds) {
                    self.isPlaying = false
                    self.player?.pause()
                }
            }
        }
    }

    private func startSimulation(
        hasFullAccess: Bool,
        freeTrialSeconds: Double,
        onTrialEnded: @escaping () -> Void
    ) {
        simulationTimer?.invalidate()
        simulationTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            Task { @MainActor in
                guard self.isPlaying else { return }
                self.progress += 1
                let maxTime = hasFullAccess ? Double(self.durationSeconds) : freeTrialSeconds
                if self.progress >= maxTime {
                    self.isPlaying = false
                    self.progress = maxTime
                    self.simulationTimer?.invalidate()
                    if !hasFullAccess {
                        onTrialEnded()
                    }
                }
            }
        }
    }
}

struct AudioPlayerView: View {
    @Environment(AppEnvironment.self) private var appEnv
    @StateObject private var playback = AudioPlaybackController()

    let attraction: Attraction
    let guide: AudioGuide

    @State private var showPurchase = false

    private var freeTrialSeconds: Double {
        Double(appEnv.contentMode.branding.freeAudioPreviewSeconds)
    }

    private var hasFullAccess: Bool {
        appEnv.preferences.hasAccessToAttraction(attraction.id, iapProductId: attraction.iapProductId)
            || !appEnv.contentMode.useRemoteIAP
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(guide.titleEn)
                    .font(Theme.FontToken.inter(14, weight: .medium))
                Spacer()
                Text(formatTime(displayDuration))
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(Theme.ColorToken.textMuted)
            }

            if let quote = guide.quote {
                Text("\"\(quote)\"")
                    .font(Theme.FontToken.inter(12))
                    .italic()
                    .foregroundStyle(Theme.ColorToken.textSecondary)
                    .lineSpacing(3)
            }

            HStack(spacing: 12) {
                Button {
                    playback.togglePlay(hasFullAccess: hasFullAccess, freeTrialSeconds: freeTrialSeconds) {
                        showPurchase = true
                    }
                } label: {
                    Image(systemName: playback.isPlaying ? "pause.fill" : "play.fill")
                        .font(.title2)
                        .foregroundStyle(Theme.ColorToken.textPrimary)
                }
                .buttonStyle(.plain)

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Rectangle().fill(Theme.ColorToken.border).frame(height: 2)
                        Rectangle()
                            .fill(Theme.ColorToken.accent)
                            .frame(width: geo.size.width * progressRatio, height: 2)
                    }
                }
                .frame(height: 2)

                Text("\(formatTime(Int(playback.progress))) / \(formatTime(displayDuration))")
                    .font(Theme.FontToken.inter(10))
                    .foregroundStyle(Theme.ColorToken.textMuted)
            }

            if !guide.segments.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(guide.segments) { seg in
                            Text(seg.title)
                                .font(Theme.FontToken.inter(10))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Theme.ColorToken.backgroundSubtle)
                                .overlay(Rectangle().stroke(Theme.ColorToken.accent, lineWidth: 1))
                                .onTapGesture {
                                    playback.seek(
                                        to: Double(seg.startSeconds),
                                        hasFullAccess: hasFullAccess,
                                        freeTrialSeconds: freeTrialSeconds
                                    )
                                }
                        }
                    }
                }
            }

            if !hasFullAccess {
                let previewMinutes = max(appEnv.contentMode.branding.freeAudioPreviewSeconds / 60, 1)
                Text("\(previewMinutes) min free preview · Unlock full guide")
                    .font(Theme.FontToken.inter(10))
                    .foregroundStyle(Theme.ColorToken.accent)
            }
        }
        .padding(14)
        .background(Theme.ColorToken.backgroundSubtle)
        .overlay(Rectangle().stroke(Theme.ColorToken.border, lineWidth: 1))
        .sheet(isPresented: $showPurchase) {
            PurchaseOptionsView(attraction: attraction)
        }
        .onAppear {
            playback.configure(guide: guide)
        }
        .onDisappear {
            playback.teardown()
        }
    }

    private var displayDuration: Int {
        max(guide.durationSeconds, 1)
    }

    private var progressRatio: CGFloat {
        guard displayDuration > 0 else { return 0 }
        return min(CGFloat(playback.progress / Double(displayDuration)), 1)
    }

    private func formatTime(_ seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%d:%02d", m, s)
    }
}

struct PurchaseOptionsView: View {
    @Environment(AppEnvironment.self) private var appEnv
    @Environment(\.dismiss) private var dismiss
    @State private var showLogin = false
    @State private var showRestoreAlert = false
    @State private var restoreMessage = ""

    let attraction: Attraction

    private var guideDurationLabel: String {
        let minutes = max(attraction.audioGuideCount * 12, 12)
        return "\(minutes) min"
    }

    private var branding: AppBranding { appEnv.contentMode.branding }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Unlock Full Audio Guide")
                        .font(Theme.FontToken.playfair(20, weight: .semibold))
                    Text("\(attraction.name) · \(guideDurationLabel)")
                        .font(Theme.FontToken.inter(12))
                        .foregroundStyle(Theme.ColorToken.textMuted)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("★ Best Value")
                            .font(Theme.FontToken.inter(9, weight: .medium))
                            .foregroundStyle(Theme.ColorToken.accent)
                        Text(branding.iapProTitle)
                            .font(Theme.FontToken.playfair(16, weight: .semibold))
                        Text("\(branding.iapProPrice) · \(branding.iapProTrialText)")
                            .font(Theme.FontToken.inter(11))
                            .foregroundStyle(Theme.ColorToken.textMuted)
                        VStack(alignment: .leading, spacing: 4) {
                            ForEach(branding.iapProFeatureLines, id: \.self) { line in
                                Text("• \(line)")
                                    .font(Theme.FontToken.inter(11))
                                    .foregroundStyle(Theme.ColorToken.textSecondary)
                            }
                        }
                        Button("Start Free Trial →") {
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

                    Text("Or buy just this guide")
                        .font(Theme.FontToken.inter(11))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                    Button(branding.iapSinglePriceLabel) {
                        purchase(pro: false)
                    }
                    .font(Theme.FontToken.inter(11, weight: .medium))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .overlay(Rectangle().stroke(Theme.ColorToken.textPrimary, lineWidth: 1))
                    .buttonStyle(.plain)

                    Button("Restore Purchases") {
                        restorePurchases()
                    }
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(Theme.ColorToken.textMuted)
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
        } else {
            restoreMessage = "No purchases found on this device. Production builds use App Store restore."
        }
        showRestoreAlert = true
    }
}
