import AVFoundation

/// Short-form AVPlayer helper with CDN primary → Supabase fallback (Payment / InfoHub phrases).
@MainActor
final class MediaAVPlayback {
    private var player: AVPlayer?
    private var itemObserver: NSKeyValueObservation?
    private var usedFallback = false
    private var pendingFallback: URL?

    func stop() {
        itemObserver?.invalidate()
        itemObserver = nil
        player?.pause()
        player = nil
        usedFallback = false
        pendingFallback = nil
    }

    func play(resolved: CDNRouter.ResolvedMediaURLs) {
        play(primary: resolved.primary, fallback: resolved.fallback)
    }

    func play(primary: URL, fallback: URL?) {
        stop()
        pendingFallback = fallback
        start(url: primary)
    }

    private func start(url: URL) {
        let item = AVPlayerItem(url: url)
        itemObserver = item.observe(\.status, options: [.new]) { [weak self] item, _ in
            guard let self else { return }
            Task { @MainActor in
                if item.status == .failed {
                    self.fallbackIfNeeded()
                }
            }
        }
        player = AVPlayer(playerItem: item)
        player?.play()
    }

    private func fallbackIfNeeded() {
        guard !usedFallback, let fallback = pendingFallback else { return }
        usedFallback = true
        pendingFallback = nil
        itemObserver?.invalidate()
        itemObserver = nil
        start(url: fallback)
    }
}
