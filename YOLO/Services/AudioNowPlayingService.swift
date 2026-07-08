import AVFoundation
import MediaPlayer
import UIKit

@MainActor
enum AudioNowPlayingService {
    private static var isConfigured = false

    /// Install lock-screen / Control Center handlers once for the app lifetime.
    static func installRemoteCommandsIfNeeded(
        play: @escaping @MainActor () -> Void,
        pause: @escaping @MainActor () -> Void,
        toggle: @escaping @MainActor () -> Void,
        next: @escaping @MainActor () -> Void,
        previous: @escaping @MainActor () -> Void
    ) {
        guard !isConfigured else { return }
        isConfigured = true

        let center = MPRemoteCommandCenter.shared()
        center.playCommand.isEnabled = true
        center.pauseCommand.isEnabled = true
        center.togglePlayPauseCommand.isEnabled = true
        center.nextTrackCommand.isEnabled = true
        center.previousTrackCommand.isEnabled = true

        center.playCommand.addTarget { _ in
            Task { @MainActor in play() }
            return .success
        }
        center.pauseCommand.addTarget { _ in
            Task { @MainActor in pause() }
            return .success
        }
        center.togglePlayPauseCommand.addTarget { _ in
            Task { @MainActor in toggle() }
            return .success
        }
        center.nextTrackCommand.addTarget { _ in
            Task { @MainActor in next() }
            return .success
        }
        center.previousTrackCommand.addTarget { _ in
            Task { @MainActor in previous() }
            return .success
        }
    }

    static func update(
        title: String,
        artist: String,
        duration: TimeInterval,
        elapsed: TimeInterval,
        isPlaying: Bool,
        artworkImage: UIImage? = nil
    ) {
        var info: [String: Any] = [
            MPMediaItemPropertyTitle: title,
            MPMediaItemPropertyArtist: artist,
            MPMediaItemPropertyPlaybackDuration: duration,
            MPNowPlayingInfoPropertyElapsedPlaybackTime: elapsed,
            MPNowPlayingInfoPropertyPlaybackRate: isPlaying ? 1.0 : 0.0,
        ]
        if let artworkImage {
            let artwork = MPMediaItemArtwork(boundsSize: artworkImage.size) { _ in artworkImage }
            info[MPMediaItemPropertyArtwork] = artwork
        }
        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
    }

    static func clear() {
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
    }
}
