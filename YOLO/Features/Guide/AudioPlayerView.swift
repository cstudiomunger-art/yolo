import AVFoundation
import Combine
import Observation
import SwiftUI
import UIKit

/// One playable entry in the global audio queue. Carries the routing context needed to
/// re-resolve access (member / single purchase / parent purchase) and to present the paywall.
struct AudioTrack: Identifiable, Equatable {
    let guide: AudioGuide
    let title: String
    let artist: String
    /// Parent attraction (used for paywall routing). Nil for free city audio.
    let attraction: Attraction?
    /// Sub-area when the audio belongs to one (paywall uses its purchase flag + parent unlock).
    let subArea: SubArea?
    /// Whether a free preview is allowed when locked.
    let allowsPreview: Bool
    /// Free content (e.g. city guide audio) bypasses the paywall entirely.
    let isFree: Bool
    /// When set, the track supports multi-voice narration switching.
    let voiceOwner: AudioVoiceOwner?
    /// Unresolved base guide used to rebuild playback when the voice variant changes.
    let baseGuide: AudioGuide?

    var id: String { guide.id }

    static func == (lhs: AudioTrack, rhs: AudioTrack) -> Bool { lhs.guide.id == rhs.guide.id }

    init(
        guide: AudioGuide,
        title: String,
        artist: String,
        attraction: Attraction? = nil,
        subArea: SubArea? = nil,
        allowsPreview: Bool = true,
        isFree: Bool = false,
        voiceOwner: AudioVoiceOwner? = nil,
        baseGuide: AudioGuide? = nil
    ) {
        self.guide = guide
        self.title = title
        self.artist = artist
        self.attraction = attraction
        self.subArea = subArea
        self.allowsPreview = allowsPreview
        self.isFree = isFree
        self.voiceOwner = voiceOwner
        self.baseGuide = baseGuide
    }
}

/// Single, app-wide audio player with a queue. Drives both the inline guide sections and the
/// floating mini-player. Only one AVPlayer ever plays at a time.
@MainActor
@Observable
final class AudioQueuePlayer {
    enum Mode: Equatable {
        case idle
        case loading
        case streaming
        case unavailable(String)
    }

    // MARK: Observable state
    private(set) var isPlaying = false
    private(set) var progress: Double = 0
    private(set) var mode: Mode = .idle
    private(set) var durationSeconds: Int = 0

    private(set) var queue: [AudioTrack] = []
    private(set) var currentIndex: Int = 0

    /// Whether the floating note button is shown.
    var isVisible = false
    /// Whether the floating control bar is expanded.
    var isExpanded = false
    /// Persisted drag position of the floating button. Nil = default anchor (bottom-trailing).
    var dragPosition: CGPoint?

    /// Resolves current access for a track (member / purchase / free). Set by AppEnvironment.
    @ObservationIgnored var resolveAccess: ((AudioTrack) -> (hasFullAccess: Bool, freeTrialSeconds: Double))?
    /// Fires when a locked preview reaches its cap, so the host can present the paywall.
    @ObservationIgnored var onTrialEnded: ((AudioTrack) -> Void)?

    // MARK: AVPlayer internals
    @ObservationIgnored private var player: AVPlayer?
    @ObservationIgnored private var playerItem: AVPlayerItem?
    @ObservationIgnored private var timeObserver: Any?
    @ObservationIgnored private var statusObservation: NSKeyValueObservation?
    @ObservationIgnored private var endObserver: NSObjectProtocol?
    @ObservationIgnored private var hasFullAccess = true
    @ObservationIgnored private var freeTrialSeconds: Double = 180
    @ObservationIgnored private var configuredGuide: AudioGuide?
    @ObservationIgnored private var preferLocalPlayback = true
    @ObservationIgnored private var shouldAutoPlay = false
    @ObservationIgnored private var pendingSeek: Double?
    @ObservationIgnored private var nowPlayingTitle = ""
    @ObservationIgnored private var nowPlayingArtist = ""

    // MARK: Derived
    var currentTrack: AudioTrack? {
        queue.indices.contains(currentIndex) ? queue[currentIndex] : nil
    }

    var currentTrackId: String? { currentTrack?.id }

    var canGoNext: Bool { currentIndex + 1 < queue.count }
    var canGoPrevious: Bool { currentIndex > 0 }

    var canPlay: Bool {
        switch mode {
        case .streaming, .idle:
            return player != nil || playerItem != nil
        case .loading, .unavailable:
            return false
        }
    }

    var previewMaxSeconds: Double { effectiveMaxTime }

    var remainingPreviewSeconds: Double { max(0, effectiveMaxTime - progress) }

    /// Whether the currently loaded track is locked to a preview.
    var currentTrackIsPreview: Bool { !hasFullAccess }

    // MARK: Queue control

    /// Start playing a queue from the given index, revealing the floating player.
    func play(queue: [AudioTrack], startIndex: Int) {
        self.queue = queue
        currentIndex = max(0, min(startIndex, queue.count - 1))
        isVisible = true
        loadCurrent(autoPlay: true)
    }

    func next() {
        guard canGoNext else { return }
        currentIndex += 1
        loadCurrent(autoPlay: true)
    }

    func previous() {
        guard canGoPrevious else { return }
        currentIndex -= 1
        loadCurrent(autoPlay: true)
    }

    func playTrack(at index: Int) {
        guard queue.indices.contains(index) else { return }
        if index == currentIndex, canPlay {
            togglePlay()
            return
        }
        currentIndex = index
        loadCurrent(autoPlay: true)
    }

    /// Swap the narration voice for a queue item and reload playback when it is the active track.
    func applyVoiceVariant(_ variant: AudioVoiceVariant, at index: Int) {
        guard queue.indices.contains(index),
              let base = queue[index].baseGuide else { return }
        let newGuide = AudioPlaybackResolver.guide(from: base, variant: variant)
        guard queue[index].guide.id != newGuide.id else { return }

        let old = queue[index]
        queue[index] = AudioTrack(
            guide: newGuide,
            title: old.title,
            artist: old.artist,
            attraction: old.attraction,
            subArea: old.subArea,
            allowsPreview: old.allowsPreview,
            isFree: old.isFree,
            voiceOwner: old.voiceOwner,
            baseGuide: base
        )

        if index == currentIndex {
            let wasPlaying = isPlaying
            pendingSeek = 0
            loadCurrent(autoPlay: wasPlaying)
        }
    }

    /// X button: stop everything and hide the floating player.
    func close() {
        teardownPlayer()
        progress = 0
        mode = .idle
        queue = []
        currentIndex = 0
        isVisible = false
        isExpanded = false
        AudioNowPlayingService.clear()
    }

    /// Re-resolve access for the current track (call after a purchase / subscription change).
    func refreshCurrentTrackAccess() {
        guard let track = currentTrack, let access = resolveAccess?(track) else { return }
        updateAccess(hasFullAccess: access.hasFullAccess, freeTrialSeconds: access.freeTrialSeconds)
    }

    /// Swap to a freshly downloaded/removed local file if the affected guide is playing.
    func reloadIfCurrent(guideId: String) {
        guard currentTrack?.guide.id == guideId else { return }
        let savedProgress = progress
        let wasPlaying = isPlaying
        pendingSeek = savedProgress
        loadCurrent(autoPlay: wasPlaying)
    }

    private func loadCurrent(autoPlay: Bool) {
        guard let track = currentTrack else {
            close()
            return
        }
        let access = resolveAccess?(track) ?? (hasFullAccess: true, freeTrialSeconds: .greatestFiniteMagnitude)
        configure(track: track, hasFullAccess: access.hasFullAccess, freeTrialSeconds: access.freeTrialSeconds, autoPlay: autoPlay)
    }

    // MARK: Playback core

    private func configure(track: AudioTrack, hasFullAccess: Bool, freeTrialSeconds: Double, autoPlay: Bool) {
        teardownPlayer()
        let guide = track.guide
        configuredGuide = guide
        preferLocalPlayback = true
        self.hasFullAccess = hasFullAccess
        self.freeTrialSeconds = hasFullAccess ? .greatestFiniteMagnitude : freeTrialSeconds
        shouldAutoPlay = autoPlay
        nowPlayingTitle = track.title
        nowPlayingArtist = track.artist
        durationSeconds = max(guide.durationSeconds, 1)
        progress = 0

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
                self?.handleTrackFinished()
            }
        }

        addTimeObserver()
    }

    func updateAccess(hasFullAccess: Bool, freeTrialSeconds: Double) {
        self.hasFullAccess = hasFullAccess
        self.freeTrialSeconds = hasFullAccess ? .greatestFiniteMagnitude : freeTrialSeconds
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
            if let track = currentTrack { onTrialEnded?(track) }
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

    /// Tears down the AVPlayer only, keeping the queue + visibility intact (used when switching tracks).
    private func teardownPlayer() {
        clearPlayerObservers()
        player?.pause()
        player = nil
        playerItem = nil
        isPlaying = false
        configuredGuide = nil
        preferLocalPlayback = true
        shouldAutoPlay = false
        pendingSeek = nil
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
            if let pendingSeek {
                self.pendingSeek = nil
                seek(to: pendingSeek)
            }
            syncNowPlaying()
            if shouldAutoPlay {
                shouldAutoPlay = false
                togglePlay()
            }
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
                shouldAutoPlay = wasPlaying
                pendingSeek = savedProgress
                startStreaming(url: remote)
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

    /// A locked preview reached its cap: pause and surface the paywall.
    private func handleTrialEnded() {
        isPlaying = false
        progress = effectiveMaxTime
        player?.pause()
        if let track = currentTrack { onTrialEnded?(track) }
    }

    /// A full track played to the end: auto-advance to the next queue item if any.
    private func handleTrackFinished() {
        isPlaying = false
        if canGoNext {
            next()
        } else {
            progress = Double(durationSeconds)
            player?.pause()
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

                if !self.hasFullAccess, seconds >= self.effectiveMaxTime {
                    self.handleTrialEnded()
                }
            }
        }
    }
}
