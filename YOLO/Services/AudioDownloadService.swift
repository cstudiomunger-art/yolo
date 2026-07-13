import Foundation

@MainActor
final class AudioDownloadService {
    static let shared = AudioDownloadService()

    private let defaultsKey = UserDefaultsKeys.downloadedAudioGuideIds

    private(set) var downloadedGuideIds: Set<String> = []
    private var activeDownloads: Set<String> = []

    private init() {
        downloadedGuideIds = Set(UserDefaults.standard.stringArray(forKey: defaultsKey) ?? [])
    }

    private var storageDirectory: URL {
        OfflineCacheLocations.audioGuidesDirectory
    }

    func isDownloaded(guideId: String) -> Bool {
        downloadedGuideIds.contains(guideId) && localFileURL(guideId: guideId) != nil
    }

    func localFileURL(guideId: String) -> URL? {
        guard let files = try? FileManager.default.contentsOfDirectory(
            at: storageDirectory,
            includingPropertiesForKeys: nil
        ) else {
            return nil
        }
        return files.first { $0.deletingPathExtension().lastPathComponent == guideId }
    }

    func download(guide: AudioGuide) async throws {
        guard !activeDownloads.contains(guide.id) else { return }
        guard let resolved = MediaURLResolver.resolvedAudioURLs(from: guide.audioUrl) else {
            throw AudioDownloadError.noRemoteURL
        }
        activeDownloads.insert(guide.id)
        defer { activeDownloads.remove(guide.id) }
        let ext = Self.fileExtension(for: resolved.primary)
        let filename = "\(guide.id).\(ext)"
        let dest = try await MediaNetworkFetch.download(
            to: storageDirectory,
            resolved: resolved,
            filename: filename
        )
        for existing in try FileManager.default.contentsOfDirectory(at: storageDirectory, includingPropertiesForKeys: nil)
            where existing.deletingPathExtension().lastPathComponent == guide.id && existing != dest {
            try? FileManager.default.removeItem(at: existing)
        }
        downloadedGuideIds.insert(guide.id)
        persist()
    }

    func removeDownload(guideId: String) {
        discardLocalFile(guideId: guideId)
    }

    func removeAllDownloads() {
        guard let files = try? FileManager.default.contentsOfDirectory(
            at: storageDirectory,
            includingPropertiesForKeys: nil
        ) else {
            downloadedGuideIds.removeAll()
            persist()
            return
        }
        for url in files {
            try? FileManager.default.removeItem(at: url)
        }
        downloadedGuideIds.removeAll()
        persist()
    }

    func storageSizeBytes() -> Int {
        guard let files = try? FileManager.default.contentsOfDirectory(
            at: storageDirectory,
            includingPropertiesForKeys: [.fileSizeKey]
        ) else { return 0 }
        return files.reduce(0) { partial, url in
            partial + ((try? url.resourceValues(forKeys: [.fileSizeKey]).fileSize) ?? 0)
        }
    }

    /// Removes on-disk audio without clearing the "downloaded" bookmark (used when local file is corrupt).
    func discardLocalFile(guideId: String) {
        guard let files = try? FileManager.default.contentsOfDirectory(
            at: storageDirectory,
            includingPropertiesForKeys: nil
        ) else { return }
        for url in files where url.deletingPathExtension().lastPathComponent == guideId {
            try? FileManager.default.removeItem(at: url)
        }
        downloadedGuideIds.remove(guideId)
        persist()
    }

    private static func fileExtension(for remote: URL) -> String {
        let ext = remote.pathExtension.lowercased()
        switch ext {
        case "mp3", "m4a", "aac", "wav", "mp4":
            return ext
        case "mpeg":
            return "mp3"
        default:
            return "mp3"
        }
    }

    private func persist() {
        UserDefaults.standard.set(Array(downloadedGuideIds), forKey: defaultsKey)
    }
}

enum AudioDownloadError: LocalizedError {
    case noRemoteURL

    var errorDescription: String? {
        switch self {
        case .noRemoteURL: "No audio file is available to download."
        }
    }
}
