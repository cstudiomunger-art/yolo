import Foundation

/// Resolves CMS media paths to playable HTTPS URLs (Supabase Storage + optional CDN bases).
enum MediaURLResolver {
    nonisolated static func audioURL(from raw: String) -> URL? {
        resolve(raw, bucket: "audio-guides")
    }

    @MainActor
    static func playbackURL(for guide: AudioGuide, preferLocal: Bool = true) -> URL? {
        if preferLocal, let local = AudioDownloadService.shared.localFileURL(guideId: guide.id) {
            return local
        }
        return audioURL(from: guide.audioUrl)
    }

    nonisolated static func coverImageURL(from raw: String) -> URL? {
        resolve(raw, bucket: "cover-images")
    }

    nonisolated private static func resolve(_ raw: String, bucket: String) -> URL? {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }

        if let url = URL(string: trimmed),
           let scheme = url.scheme?.lowercased(),
           scheme == "http" || scheme == "https" {
            return url
        }

        guard AppConfig.isSupabaseConfigured else { return nil }

        var path = trimmed
        let bucketPrefix = "\(bucket)/"
        if path.hasPrefix(bucketPrefix) {
            path = String(path.dropFirst(bucketPrefix.count))
        }
        path = path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        guard !path.isEmpty else { return nil }

        return AppConfig.supabaseURL
            .appendingPathComponent("storage/v1/object/public")
            .appendingPathComponent(bucket)
            .appendingPathComponent(path)
    }
}
