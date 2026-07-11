import SwiftUI

struct AudioGuideSection: View {
    @Environment(AppEnvironment.self) private var appEnv

    let attraction: Attraction
    let guide: AudioGuide
    var voiceOwner: AudioVoiceOwner? = nil
    var includedWithLabel: String?
    var allowsPreview: Bool = true
    /// Hide the inline "Unlock Audio Guide" button when the host screen already provides an
    /// unlock entry (the attraction detail page's sticky bottom bar). Sub-area pages default on.
    var showsUnlockButton: Bool = true
    /// When this audio belongs to a sub-area, pass it so the paywall uses the sub-area's
    /// purchase flag, price tier, and unlock target (parent purchase also unlocks it).
    var subArea: SubArea?
    /// The attraction-scoped queue this guide belongs to (main guide + sub-area audios). When
    /// empty, a single-track queue is built from this guide on play.
    var queue: [AudioTrack] = []
    /// This guide's index within `queue`.
    var trackIndex: Int = 0

    @State private var showPurchase = false
    @State private var accessRefresh = UUID()
    @State private var isDownloading = false
    @State private var downloadError: String?
    @State private var showUnlockedToast = false
    @State private var scrubProgress: Double = 0
    @State private var isScrubbing = false
    @State private var voiceVariants: [AudioVoiceVariant] = []
    @State private var selectedVariantId: String?

    private var player: AudioQueuePlayer { appEnv.audioPlayer }

    private var playbackGuide: AudioGuide {
        guard voiceOwner != nil, !voiceVariants.isEmpty else { return guide }
        return AudioPlaybackResolver.resolve(
            baseGuide: guide,
            variants: voiceVariants,
            preferredVariantId: selectedVariantId
        )
    }

    /// Whether this guide is the track currently loaded in the global player.
    private var isActive: Bool {
        guard let track = player.currentTrack else { return false }
        return AudioPlaybackResolver.trackMatchesSection(
            track: track,
            baseGuideId: guide.id,
            voiceOwner: voiceOwner
        )
    }
    private var isPlayingThis: Bool { isActive && player.isPlaying }
    private var displayMode: AudioQueuePlayer.Mode { isActive ? player.mode : .idle }
    private var canPlayThis: Bool { isActive ? player.canPlay : true }
    private var displayDuration: Int { isActive ? player.durationSeconds : max(playbackGuide.durationSeconds, 1) }

    private var freeTrialSeconds: Double {
        Double(appEnv.contentMode.branding.freeAudioPreviewSeconds)
    }

    private var hasFullAccess: Bool {
        _ = accessRefresh
        if !appEnv.contentMode.effectiveUseRemoteIAP { return true }
        if let sub = subArea {
            return appEnv.purchase.hasContentAccess(
                \.audioGuides,
                requiresPurchase: sub.requiresPurchase,
                contentId: sub.id,
                parentId: sub.attractionId
            )
        }
        return appEnv.purchase.hasContentAccess(
            \.audioGuides,
            requiresPurchase: attraction.requiresPurchase,
            contentId: attraction.id
        )
    }

    private var isDownloaded: Bool {
        AudioDownloadService.shared.isDownloaded(guideId: playbackGuide.id)
    }

    private var previewCapSeconds: Int {
        if isActive { return Int(player.previewMaxSeconds.rounded()) }
        return min(max(playbackGuide.durationSeconds, 1), Int(freeTrialSeconds))
    }

    /// This guide as a standalone queue entry (used when no attraction queue is provided).
    private var selfTrack: AudioTrack {
        AudioTrack(
            guide: playbackGuide,
            title: guide.titleEn,
            artist: attraction.name,
            attraction: attraction,
            subArea: subArea,
            allowsPreview: allowsPreview,
            isFree: false,
            voiceOwner: voiceOwner,
            baseGuide: guide
        )
    }

    private var effectiveQueue: [AudioTrack] {
        guard !queue.isEmpty else { return [selfTrack] }
        var tracks = queue
        if voiceOwner != nil, tracks.indices.contains(trackIndex) {
            tracks[trackIndex] = selfTrack
        }
        return tracks
    }
    private var effectiveIndex: Int { queue.isEmpty ? 0 : trackIndex }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center, spacing: 8) {
                Text("🎧")
                Text(guide.titleEn)
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
                Text("\(max(playbackGuide.durationSeconds / 60, 1)) min")
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
                MarkdownContentView(content: quote, fontSize: 12)
            }

            statusLine

            if hasFullAccess {
                unlockedControls
            } else {
                lockedControls
            }

            if playbackGuide.segments.count > 1 {
                chapterList
            }
        }
        .guideContentCardStyle()
        .task(id: voiceOwner?.preferenceKey) {
            await loadVoiceVariants()
        }
        .sheet(isPresented: $showPurchase) {
            MembershipPlansView(
                attraction: attraction,
                guide: guide,
                priceTierId: subArea?.priceTierId ?? attraction.priceTierId,
                purchaseTargetId: subArea?.id,
                displayTitle: subArea?.nameEn
            ) {
                accessRefresh = UUID()
                if isActive { player.refreshCurrentTrackAccess() }
                showUnlockedToast = true
            }
            .environment(appEnv)
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
        .onChange(of: appEnv.preferences.purchasedAttractionIds) { _, _ in
            accessRefresh = UUID()
            if isActive { player.refreshCurrentTrackAccess() }
        }
        .onChange(of: appEnv.purchase.isProActive) { _, _ in
            accessRefresh = UUID()
            if isActive { player.refreshCurrentTrackAccess() }
        }
        .onChange(of: appEnv.membershipRevision) { _, _ in
            accessRefresh = UUID()
            if isActive { player.refreshCurrentTrackAccess() }
        }
        .overlay(alignment: .bottom) {
            if showUnlockedToast {
                Text(String(localized: "🎧 Audio guide unlocked!"))
                    .font(Theme.FontToken.inter(11, weight: .medium))
                    .emphasisButtonStyle(horizontalPadding: 14, verticalPadding: 8)
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

    /// Start this guide in the global player, or toggle play/pause if it is already active.
    private func startOrToggle() {
        if isActive {
            player.togglePlay()
        } else {
            player.play(queue: effectiveQueue, startIndex: effectiveIndex)
        }
    }

    private func seekOrStart(to seconds: Double) {
        if isActive {
            player.seek(to: seconds)
        } else {
            player.play(queue: effectiveQueue, startIndex: effectiveIndex)
        }
    }

    @ViewBuilder
    private var lockedControls: some View {
        let previewMinutes = max(Int(freeTrialSeconds / 60), 1)
        if allowsPreview {
            if displayMode == .loading {
                HStack(spacing: 6) {
                    ProgressView().scaleEffect(0.7)
                    Text(String(localized: "Loading preview…"))
                        .font(Theme.FontToken.inter(11))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                }
            } else {
                Button {
                    startOrToggle()
                } label: {
                    if isPlayingThis {
                        Text(String(localized: "⏸ Pause preview"))
                    } else {
                        Text(String(format: String(localized: "▶ Preview (%lld min free)"), previewMinutes))
                    }
                }
                .font(Theme.FontToken.inter(14, weight: .medium))
                .padding(.vertical, 2)
                .foregroundStyle(canPlayThis ? Theme.ColorToken.textPrimary : Theme.ColorToken.textMuted)
                .buttonStyle(.plain)
                .disabled(!canPlayThis)
            }
        }

        if previewCapSeconds > 0 {
            scrubSlider(maxSeconds: previewCapSeconds)
        }

        if previewCapSeconds > 0 {
            Text("\(formatTime(Int(scrubProgress))) / \(formatTime(previewCapSeconds))")
                .font(Theme.FontToken.inter(10))
                .foregroundStyle(Theme.ColorToken.textMuted)
        }

        if allowsPreview, isPlayingThis, player.remainingPreviewSeconds > 0 {
            Text(String(
                format: String(localized: "%lld sec left in preview"),
                Int(player.remainingPreviewSeconds.rounded())
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

        if showsUnlockButton {
            Button {
                showPurchase = true
            } label: {
                Text(String(localized: "Unlock Audio Guide"))
                    .emphasisButtonStyle()
            }
            .buttonStyle(.plain)
            .fixedSize()
        }
    }

    @ViewBuilder
    private var unlockedControls: some View {
        HStack(spacing: 10) {
            Button {
                startOrToggle()
            } label: {
                Text(isPlayingThis ? String(localized: "⏸ Pause") : String(localized: "▶ Play"))
                    .font(Theme.FontToken.inter(14, weight: .medium))
                    .padding(.vertical, 4)
            }
            .buttonStyle(.plain)
            .disabled(displayMode == .loading || !canPlayThis)

            scrubSlider(maxSeconds: displayDuration)
        }

        HStack {
            Text("\(formatTime(Int(scrubProgress))) / \(formatTime(displayDuration))")
                .font(Theme.FontToken.inter(10))
                .foregroundStyle(Theme.ColorToken.textMuted)
            Spacer()
            downloadRow
        }
    }

    @ViewBuilder
    private func scrubSlider(maxSeconds: Int) -> some View {
        let maxValue = max(Double(maxSeconds), 1)
        Slider(
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
                    seekOrStart(to: scrubProgress)
                }
            }
        )
        .tint(Theme.ColorToken.accent)
        .disabled(!isActive)
    }

    @ViewBuilder
    private var downloadRow: some View {
        if isDownloading {
            ProgressView()
                .scaleEffect(0.8)
        } else if isDownloaded {
            HStack(spacing: 6) {
                Image(systemName: "checkmark.circle")
                    .font(.system(size: 12))
                    .foregroundStyle(Theme.ColorToken.accent)
                Text(String(localized: "Downloaded"))
                    .font(Theme.FontToken.inter(11))
                    .foregroundStyle(Theme.ColorToken.accent)
                Button(String(localized: "Remove")) {
                    AudioDownloadService.shared.removeDownload(guideId: playbackGuide.id)
                    player.reloadIfCurrent(guideId: playbackGuide.id)
                    accessRefresh = UUID()
                }
                .font(Theme.FontToken.inter(10))
                .foregroundStyle(Theme.ColorToken.textMuted)
            }
        } else {
            Button {
                Task { await downloadAudio() }
            } label: {
                HStack(spacing: 5) {
                    Image(systemName: "arrow.down.to.line")
                        .font(.system(size: 12, weight: .medium))
                    Text(String(localized: "Download for offline"))
                        .font(Theme.FontToken.inter(11))
                }
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

    @ViewBuilder
    private var statusLine: some View {
        switch displayMode {
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
        let segments = playbackGuide.segments.sorted { $0.startSeconds < $1.startSeconds }
        VStack(alignment: .leading, spacing: 6) {
            Text(String(localized: "Chapters"))
                .font(Theme.FontToken.inter(11, weight: .medium))
                .foregroundStyle(Theme.ColorToken.textMuted)
            ForEach(Array(segments.enumerated()), id: \.element.id) { index, segment in
                let isActiveSegment = isActive && player.activeSegmentIndex(in: segments) == index
                Button {
                    seekOrStart(to: Double(segment.startSeconds))
                } label: {
                    HStack {
                        Text(segment.title)
                            .font(Theme.FontToken.inter(12, weight: isActiveSegment ? .semibold : .regular))
                            .foregroundStyle(isActiveSegment ? Theme.ColorToken.textPrimary : Theme.ColorToken.textSecondary)
                        Spacer()
                        Text(formatTime(segment.startSeconds))
                            .font(Theme.FontToken.inter(10))
                            .foregroundStyle(Theme.ColorToken.textMuted)
                    }
                }
                .buttonStyle(.plain)
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
            try await AudioDownloadService.shared.download(guide: playbackGuide)
            player.reloadIfCurrent(guideId: playbackGuide.id)
            accessRefresh = UUID()
        } catch {
            downloadError = error.localizedDescription
        }
    }

    private func loadVoiceVariants() async {
        guard let voiceOwner else {
            voiceVariants = []
            selectedVariantId = nil
            return
        }
        let loaded = await AudioVoicePlaybackSupport.loadVariants(owner: voiceOwner, content: appEnv.content)
        voiceVariants = loaded
        selectedVariantId = appEnv.preferences.preferredVoiceVariantId(for: voiceOwner)
    }

    private func selectVoice(_ variant: AudioVoiceVariant) {
        if isActive { player.close() }
        selectedVariantId = variant.id
        if let voiceOwner {
            appEnv.preferences.setPreferredVoiceVariantId(variant.id, for: voiceOwner)
        }
        scrubProgress = 0
    }

    /// Keep inline picker / download state aligned when voice changes in the mini-player or playlist.
    private func syncVoiceFromPlayer() {
        guard let voiceOwner,
              let track = player.currentTrack,
              AudioPlaybackResolver.trackMatchesSection(
                  track: track,
                  baseGuideId: guide.id,
                  voiceOwner: voiceOwner
              ),
              let variantId = AudioPlaybackResolver.variantId(from: track.guide.id, baseGuideId: guide.id)
        else { return }
        guard selectedVariantId != variantId else { return }
        selectedVariantId = variantId
    }
}
