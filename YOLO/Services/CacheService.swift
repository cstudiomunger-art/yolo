import Foundation

enum CacheService {
    static func formattedCacheSize() -> String {
        let bytes = cacheSizeBytes()
        return ByteCountFormatter.string(fromByteCount: Int64(bytes), countStyle: .file)
    }

    static func clearCache() {
        URLCache.shared.removeAllCachedResponses()
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

    private static func cacheSizeBytes() -> Int {
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
        return total + URLCache.shared.currentDiskUsage
    }
}
