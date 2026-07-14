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
    func image(remoteURLString: String, defaultBucket: String = "cover-images") async -> UIImage? {
        let normalized = normalize(remoteURLString)
        guard !normalized.isEmpty else { return nil }

        let stableKey = CDNRouter.cacheKey(for: normalized, defaultBucket: defaultBucket)
        let key = cacheKey(for: stableKey)
        let imageURL = imageFileURL(key: key)
        let metaURL = metaFileURL(key: key)

        if let disk = loadImage(from: imageURL) {
            if isStale(metaURL: metaURL),
               let resolved = CDNRouter.publicMediaURLs(from: normalized, bucket: defaultBucket) {
                Task { await self.fetchAndStore(resolved: resolved, key: key, coverPath: stableKey) }
            }
            return disk
        }

        guard let resolved = CDNRouter.publicMediaURLs(from: normalized, bucket: defaultBucket) else {
            return nil
        }

        return await fetchAndStore(resolved: resolved, key: key, coverPath: stableKey)
    }

    /// Loads an image cached under an arbitrary stable `key` (e.g. a private
    /// storage path whose signed download URL changes each time). Disk-first;
    /// on a miss it resolves the URL via `fetch` and stores the bytes. Content
    /// is treated as immutable for the key, so no TTL refresh.
    func image(key rawKey: String, fetch: () async -> URL?) async -> UIImage? {
        let normalized = normalize(rawKey)
        guard !normalized.isEmpty else { return nil }
        let key = cacheKey(for: normalized)
        if let disk = loadImage(from: imageFileURL(key: key)) { return disk }
        guard let url = await fetch() else { return nil }
        if let resolved = CDNRouter.publicMediaURLs(from: url.absoluteString, bucket: "cover-images") {
            return await fetchAndStore(resolved: resolved, key: key, coverPath: normalized)
        }
        return await fetchAndStoreDirect(url: url, key: key, coverPath: normalized)
    }

    /// Loads cover by CMS path; returns disk image immediately when available, refreshes in background when stale.
    func image(coverPath: String) async -> UIImage? {
        let normalized = normalize(coverPath)
        guard !normalized.isEmpty,
              let resolved = MediaURLResolver.resolvedCoverImageURLs(from: normalized) else {
            return nil
        }

        let key = cacheKey(for: CDNRouter.cacheKey(for: normalized, defaultBucket: "cover-images"))
        let imageURL = imageFileURL(key: key)
        let metaURL = metaFileURL(key: key)

        if let disk = loadImage(from: imageURL) {
            if isStale(metaURL: metaURL) {
                Task { await self.fetchAndStore(resolved: resolved, key: key, coverPath: normalized) }
            }
            return disk
        }

        return await fetchAndStore(resolved: resolved, key: key, coverPath: normalized)
    }

    /// Prime the cache with bytes already in hand (e.g. an image we just uploaded),
    /// keyed by the same stable key its loader uses, so it renders from disk instantly
    /// instead of round-tripping a signed URL + re-download.
    func store(_ data: Data, forKey rawKey: String) {
        let normalized = normalize(rawKey)
        guard !normalized.isEmpty, UIImage(data: data) != nil else { return }
        let key = cacheKey(for: normalized)
        try? data.write(to: imageFileURL(key: key), options: .atomic)
        let meta = Meta(savedAt: Date(), coverPath: normalized)
        if let metaData = try? JSONCoding.makeEncoder().encode(meta) {
            try? metaData.write(to: metaFileURL(key: key), options: .atomic)
        }
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

    private func fetchAndStore(resolved: CDNRouter.ResolvedMediaURLs, key: String, coverPath: String) async -> UIImage? {
        do {
            let data = try await MediaNetworkFetch.data(from: resolved)
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

    private func fetchAndStoreDirect(url: URL, key: String, coverPath: String) async -> UIImage? {
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

    /// Memory lookup by raw URL and by canonical storage key (CDN vs Supabase URLs share one entry).
    static func cached(_ urlString: String) -> UIImage? {
        if let hit = memory.object(forKey: urlString as NSString) { return hit }
        let canonical = CDNRouter.cacheKey(for: urlString, defaultBucket: "avatars")
        if canonical != urlString, let hit = memory.object(forKey: canonical as NSString) {
            return hit
        }
        return nil
    }

    /// Seed memory immediately after a local upload so all screens show the new image without flicker.
    static func seed(_ urlString: String, image: UIImage) {
        memory.setObject(image, forKey: urlString as NSString)
        let canonical = CDNRouter.cacheKey(for: urlString, defaultBucket: "avatars")
        if canonical != urlString {
            memory.setObject(image, forKey: canonical as NSString)
        }
    }

    /// Returns the avatar from memory, then disk, then network — caching it in memory for reuse.
    static func image(for urlString: String) async -> UIImage? {
        if let mem = cached(urlString) { return mem }
        guard let image = await ImageCacheService.shared.image(remoteURLString: urlString, defaultBucket: "avatars") else {
            return nil
        }
        seed(urlString, image: image)
        return image
    }
}
