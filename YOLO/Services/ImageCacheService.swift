import CryptoKit
import Foundation
import UIKit

/// Persistent cover image cache under Application Support (not purged like Caches on relaunch).
actor ImageCacheService {
    static let shared = ImageCacheService()

    static let defaultTTL: TimeInterval = 7 * 24 * 60 * 60

    private let directory: URL
    private let metaSuffix = ".meta.json"

    private init() {
        directory = OfflineCacheLocations.imagesDirectory
    }

    /// Loads an image by its full remote URL (e.g. a Supabase public avatar URL);
    /// returns disk image immediately when available, refreshes in background when stale.
    func image(remoteURLString: String) async -> UIImage? {
        let normalized = normalize(remoteURLString)
        guard !normalized.isEmpty, let url = URL(string: normalized) else { return nil }

        let key = cacheKey(for: normalized)
        let imageURL = imageFileURL(key: key)
        let metaURL = metaFileURL(key: key)

        if let disk = loadImage(from: imageURL) {
            if isStale(metaURL: metaURL) {
                Task { _ = await self.fetchAndStore(url: url, key: key, coverPath: normalized) }
            }
            return disk
        }

        return await fetchAndStore(url: url, key: key, coverPath: normalized)
    }

    /// Loads cover by CMS path; returns disk image immediately when available, refreshes in background when stale.
    func image(coverPath: String) async -> UIImage? {
        let normalized = normalize(coverPath)
        guard !normalized.isEmpty,
              let url = MediaURLResolver.coverImageURL(from: normalized) else {
            return nil
        }

        let key = cacheKey(for: normalized)
        let imageURL = imageFileURL(key: key)
        let metaURL = metaFileURL(key: key)

        if let disk = loadImage(from: imageURL) {
            if isStale(metaURL: metaURL) {
                Task { await self.fetchAndStore(url: url, key: key, coverPath: normalized) }
            }
            return disk
        }

        return await fetchAndStore(url: url, key: key, coverPath: normalized)
    }

    func removeAll() {
        guard let contents = try? FileManager.default.contentsOfDirectory(
            at: directory,
            includingPropertiesForKeys: nil
        ) else { return }
        for url in contents {
            try? FileManager.default.removeItem(at: url)
        }
    }

    func directorySizeBytes() -> Int {
        guard let contents = try? FileManager.default.contentsOfDirectory(
            at: directory,
            includingPropertiesForKeys: [.fileSizeKey]
        ) else { return 0 }
        return contents.reduce(0) { partial, url in
            partial + ((try? url.resourceValues(forKeys: [.fileSizeKey]).fileSize) ?? 0)
        }
    }

    // MARK: - Private

    private func normalize(_ path: String) -> String {
        path.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func cacheKey(for normalizedPath: String) -> String {
        let digest = SHA256.hash(data: Data(normalizedPath.utf8))
        return digest.map { String(format: "%02x", $0) }.joined()
    }

    private func imageFileURL(key: String) -> URL {
        directory.appendingPathComponent("\(key).img")
    }

    private func metaFileURL(key: String) -> URL {
        directory.appendingPathComponent("\(key)\(metaSuffix)")
    }

    private struct Meta: Codable {
        let savedAt: Date
        let coverPath: String
    }

    private func isStale(metaURL: URL, ttl: TimeInterval = defaultTTL) -> Bool {
        guard let meta = loadMeta(metaURL) else { return true }
        return Date().timeIntervalSince(meta.savedAt) > ttl
    }

    private func loadMeta(_ url: URL) -> Meta? {
        guard let data = try? Data(contentsOf: url) else { return nil }
        return try? JSONCoding.makeDecoder().decode(Meta.self, from: data)
    }

    private func loadImage(from url: URL) -> UIImage? {
        guard FileManager.default.fileExists(atPath: url.path),
              let data = try? Data(contentsOf: url) else {
            return nil
        }
        return UIImage(data: data)
    }

    private func fetchAndStore(url: URL, key: String, coverPath: String) async -> UIImage? {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return nil }
            let imageURL = imageFileURL(key: key)
            let metaURL = metaFileURL(key: key)
            try? data.write(to: imageURL, options: .atomic)
            let meta = Meta(savedAt: Date(), coverPath: coverPath)
            if let metaData = try? JSONCoding.makeEncoder().encode(meta) {
                try? metaData.write(to: metaURL, options: .atomic)
            }
            return image
        } catch {
            return loadImage(from: imageFileURL(key: key))
        }
    }
}

/// Fast, synchronous in-memory cache for the signed-in user's avatar, shared by
/// every screen that shows it (home header, profile sheet, edit screen) so they
/// all display the exact same image with no flicker. Backed by `ImageCacheService`
/// for disk persistence across launches.
enum AvatarImageCache {
    private static let memory = NSCache<NSString, UIImage>()

    /// Synchronous lookup — used to seed a view's initial state and avoid a flash of initials.
    static func cached(_ urlString: String) -> UIImage? {
        memory.object(forKey: urlString as NSString)
    }

    /// Returns the avatar from memory, then disk, then network — caching it in memory for reuse.
    static func image(for urlString: String) async -> UIImage? {
        if let mem = cached(urlString) { return mem }
        guard let image = await ImageCacheService.shared.image(remoteURLString: urlString) else {
            return nil
        }
        memory.setObject(image, forKey: urlString as NSString)
        return image
    }
}
