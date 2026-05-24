import Foundation

/// Central paths for offline data that must survive app relaunch (not `Caches/`).
enum OfflineCacheLocations {
    private static let migrationFlagKey = UserDefaultsKeys.offlineCacheMigrated

    static var applicationSupport: URL {
        FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
    }

    static var contentDirectory: URL {
        ensureDirectory(applicationSupport.appendingPathComponent("chinago-content", isDirectory: true))
    }

    static var imagesDirectory: URL {
        ensureDirectory(applicationSupport.appendingPathComponent("chinago-images", isDirectory: true))
    }

    static var audioGuidesDirectory: URL {
        ensureDirectory(applicationSupport.appendingPathComponent("AudioGuides", isDirectory: true))
    }

    static var appSettingsFile: URL {
        applicationSupport.appendingPathComponent("chinago-settings/app_settings.json")
    }

    static var urlCacheDirectory: URL {
        ensureDirectory(applicationSupport.appendingPathComponent("chinago-urlcache", isDirectory: true))
    }

    /// Call once at launch: migrate legacy `Caches/` folders and install persistent `URLCache`.
    static func bootstrap() {
        migrateLegacyCachesIfNeeded()
        installPersistentURLCache()
    }

    static func migrateLegacyCachesIfNeeded() {
        guard !UserDefaults.standard.bool(forKey: migrationFlagKey) else { return }

        let legacyRoot = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        if let legacyRoot {
            mergeContents(
                from: legacyRoot.appendingPathComponent("chinago-content", isDirectory: true),
                into: contentDirectory
            )
            mergeContents(
                from: legacyRoot.appendingPathComponent("chinago-images", isDirectory: true),
                into: imagesDirectory
            )
        }

        UserDefaults.standard.set(true, forKey: migrationFlagKey)
    }

    static func installPersistentURLCache() {
        let cache = URLCache(
            memoryCapacity: 20 * 1024 * 1024,
            diskCapacity: 120 * 1024 * 1024,
            directory: urlCacheDirectory
        )
        URLCache.shared = cache
        URLSessionConfiguration.default.urlCache = cache
    }

    static func clearPersistentURLCache() {
        URLCache.shared.removeAllCachedResponses()
    }

    static func urlCacheSizeBytes() -> Int {
        directoryByteCount(urlCacheDirectory)
    }

    static func persistentStorageSizeBytes() -> Int {
        directoryByteCount(contentDirectory)
            + directoryByteCount(imagesDirectory)
            + directoryByteCount(audioGuidesDirectory)
            + fileSize(appSettingsFile)
            + urlCacheSizeBytes()
    }

    static func clearAppSettingsFile() {
        try? FileManager.default.removeItem(at: appSettingsFile)
        let parent = appSettingsFile.deletingLastPathComponent()
        if let contents = try? FileManager.default.contentsOfDirectory(atPath: parent.path),
           contents.isEmpty {
            try? FileManager.default.removeItem(at: parent)
        }
    }

    static func ensureDirectory(_ url: URL) -> URL {
        try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        return url
    }

    // MARK: - Private

    private static func mergeContents(from source: URL, into destination: URL) {
        guard FileManager.default.fileExists(atPath: source.path),
              let files = try? FileManager.default.contentsOfDirectory(
                  at: source,
                  includingPropertiesForKeys: nil
              ) else { return }

        ensureDirectory(destination)
        for file in files {
            let target = destination.appendingPathComponent(file.lastPathComponent)
            if FileManager.default.fileExists(atPath: target.path) { continue }
            try? FileManager.default.moveItem(at: file, to: target)
        }
        try? FileManager.default.removeItem(at: source)
    }

    static func fileSize(_ url: URL) -> Int {
        guard let attrs = try? FileManager.default.attributesOfItem(atPath: url.path),
              let size = attrs[.size] as? Int else {
            return 0
        }
        return size
    }

    private static func directoryByteCount(_ url: URL) -> Int {
        guard let contents = try? FileManager.default.contentsOfDirectory(
            at: url,
            includingPropertiesForKeys: [.fileSizeKey, .isDirectoryKey]
        ) else { return 0 }
        var total = 0
        for item in contents {
            let values = try? item.resourceValues(forKeys: [.fileSizeKey, .isDirectoryKey])
            if values?.isDirectory == true {
                total += directoryByteCount(item)
            } else {
                total += values?.fileSize ?? 0
            }
        }
        return total
    }
}
