import Foundation

enum CacheService {
    struct Breakdown: Sendable {
        var temporary: Int64
        var offlineContent: Int64
        var coverImages: Int64
        var downloadedAudio: Int64
        var appSettings: Int64
        var networkCache: Int64

        var total: Int64 {
            temporary + offlineContent + coverImages + downloadedAudio + appSettings + networkCache
        }
    }

    enum ClearTarget: Sendable {
        case temporary
        case offlineContent
        case coverImages
        case downloadedAudio
        case allExceptAudio
        case all
    }

    static func breakdown() async -> Breakdown {
        let contentBytes = await ContentCacheStore.shared.directorySizeBytes()
        let imageBytes = await ImageCacheService.shared.directorySizeBytes()
        let audioBytes = await MainActor.run { AudioDownloadService.shared.storageSizeBytes() }
        return Breakdown(
            temporary: Int64(ephemeralTemporarySizeBytes()),
            offlineContent: Int64(contentBytes),
            coverImages: Int64(imageBytes),
            downloadedAudio: Int64(audioBytes),
            appSettings: Int64(OfflineCacheLocations.fileSize(OfflineCacheLocations.appSettingsFile)),
            networkCache: Int64(OfflineCacheLocations.urlCacheSizeBytes())
        )
    }

    static func formattedCacheSize() async -> String {
        formattedBreakdown(await breakdown())
    }

    /// Total persistent offline storage (content, images, audio, settings, URL cache).
    static func formattedCacheSizeSync() -> String {
        let bytes = Int64(OfflineCacheLocations.persistentStorageSizeBytes())
        return ByteCountFormatter.string(fromByteCount: bytes, countStyle: .file)
    }

    static func formattedBreakdown(_ breakdown: Breakdown) -> String {
        ByteCountFormatter.string(fromByteCount: breakdown.total, countStyle: .file)
    }

    static func clear(_ target: ClearTarget) async {
        switch target {
        case .temporary:
            clearTemporary()
        case .offlineContent:
            await ContentCacheStore.shared.removeAll()
        case .coverImages:
            await ImageCacheService.shared.removeAll()
        case .downloadedAudio:
            await MainActor.run { AudioDownloadService.shared.removeAllDownloads() }
        case .allExceptAudio:
            clearTemporary()
            await ContentCacheStore.shared.removeAll()
            await ImageCacheService.shared.removeAll()
        case .all:
            clearTemporary()
            await ContentCacheStore.shared.removeAll()
            await ImageCacheService.shared.removeAll()
            await MainActor.run { AudioDownloadService.shared.removeAllDownloads() }
        }
    }

    /// Legacy entry — clears temporary cache only.
    static func clearCache() {
        clearTemporary()
    }

    private static func clearTemporary() {
        OfflineCacheLocations.clearPersistentURLCache()
        let tmp = FileManager.default.temporaryDirectory
        if let contents = try? FileManager.default.contentsOfDirectory(
            at: tmp,
            includingPropertiesForKeys: nil
        ) {
            for url in contents {
                try? FileManager.default.removeItem(at: url)
            }
        }
    }

    /// System temp only (not Application Support offline stores).
    private static func ephemeralTemporarySizeBytes() -> Int {
        var total = 0
        let tmp = FileManager.default.temporaryDirectory
        if let contents = try? FileManager.default.contentsOfDirectory(
            at: tmp,
            includingPropertiesForKeys: [.fileSizeKey]
        ) {
            for url in contents {
                if let size = try? url.resourceValues(forKeys: [.fileSizeKey]).fileSize {
                    total += size
                }
            }
        }
        return total
    }
}
