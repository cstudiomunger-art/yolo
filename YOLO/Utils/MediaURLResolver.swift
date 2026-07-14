import Foundation

/// Resolves CMS media paths to playable HTTPS URLs (CDN primary, Supabase fallback).
enum MediaURLResolver {
    nonisolated static func audioURL(from raw: String) -> URL? {
        resolved(from: raw, bucket: "audio-guides")?.primary
    }

    nonisolated static func audioFallbackURL(from raw: String) -> URL? {
        resolved(from: raw, bucket: "audio-guides")?.fallback
    }

    nonisolated static func resolvedAudioURLs(from raw: String) -> CDNRouter.ResolvedMediaURLs? {
        resolved(from: raw, bucket: "audio-guides")
    }

    @MainActor
    static func playbackURL(for guide: AudioGuide, preferLocal: Bool = true) -> URL? {
        if preferLocal, let local = AudioDownloadService.shared.localFileURL(guideId: guide.id) {
            return local
        }
        return audioURL(from: guide.audioUrl)
    }

    @MainActor
    static func playbackResolvedURLs(for guide: AudioGuide, preferLocal: Bool = true) -> CDNRouter.ResolvedMediaURLs? {
        if preferLocal, AudioDownloadService.shared.localFileURL(guideId: guide.id) != nil {
            return nil
        }
        return resolvedAudioURLs(from: guide.audioUrl)
    }

    nonisolated static func coverImageURL(from raw: String) -> URL? {
        resolved(from: raw, bucket: "cover-images")?.primary
    }

    nonisolated static func resolvedCoverImageURLs(from raw: String) -> CDNRouter.ResolvedMediaURLs? {
        resolved(from: raw, bucket: "cover-images")
    }

    nonisolated static func resolvedAvatarURLs(from raw: String) -> CDNRouter.ResolvedMediaURLs? {
        resolved(from: raw, bucket: "avatars")
    }

    nonisolated private static func resolved(from raw: String, bucket: String) -> CDNRouter.ResolvedMediaURLs? {
        CDNRouter.publicMediaURLs(from: raw, bucket: bucket)
    }
}
