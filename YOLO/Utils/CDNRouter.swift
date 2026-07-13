import Foundation

/// Resolves CMS storage paths and Supabase public URLs to CDN (primary) and Supabase (fallback) endpoints.
enum CDNRouter {
    struct StorageReference: Equatable {
        let bucket: String
        let objectPath: String

        /// Stable cache key: `cover-images/sub-areas/foo.jpg`
        var canonicalKey: String { "\(bucket)/\(objectPath)" }
    }

    struct ResolvedMediaURLs: Equatable {
        let primary: URL
        let fallback: URL?
    }

    private static let supabasePublicPathMarker = "/storage/v1/object/public/"

    // MARK: - Parsing

    nonisolated static func parseStorageReference(from raw: String, defaultBucket: String) -> StorageReference? {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }

        if let url = URL(string: trimmed),
           let scheme = url.scheme?.lowercased(),
           scheme == "http" || scheme == "https",
           let host = url.host?.lowercased(),
           host.contains("supabase.co"),
           let path = url.path.removingPercentEncoding ?? url.path,
           let markerRange = path.range(of: supabasePublicPathMarker) {
            let tail = String(path[markerRange.upperBound...]).trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            guard let slash = tail.firstIndex(of: "/") else { return nil }
            let bucket = String(tail[..<slash])
            var objectPath = String(tail[tail.index(after: slash)...])
            objectPath = objectPath.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            guard !bucket.isEmpty, !objectPath.isEmpty else { return nil }
            return StorageReference(bucket: bucket, objectPath: objectPath)
        }

        var path = trimmed
        let bucketPrefix = "\(defaultBucket)/"
        if path.hasPrefix(bucketPrefix) {
            path = String(path.dropFirst(bucketPrefix.count))
        }
        path = path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        guard !path.isEmpty else { return nil }
        return StorageReference(bucket: defaultBucket, objectPath: path)
    }

    // MARK: - URL building

    nonisolated static func publicMediaURLs(from raw: String, bucket: String) -> ResolvedMediaURLs? {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }

        if let ref = parseStorageReference(from: trimmed, defaultBucket: bucket) {
            return publicMediaURLs(reference: ref)
        }

        if let url = URL(string: trimmed),
           let scheme = url.scheme?.lowercased(),
           scheme == "http" || scheme == "https" {
            return ResolvedMediaURLs(primary: url, fallback: nil)
        }

        return nil
    }

    nonisolated static func publicMediaURLs(reference: StorageReference) -> ResolvedMediaURLs? {
        let supabase = supabasePublicURL(bucket: reference.bucket, objectPath: reference.objectPath)
        guard let supabase else { return nil }

        if let cdn = cdnPublicURL(bucket: reference.bucket, objectPath: reference.objectPath) {
            return ResolvedMediaURLs(primary: cdn, fallback: supabase)
        }
        return ResolvedMediaURLs(primary: supabase, fallback: nil)
    }

    nonisolated static func supabasePublicURL(bucket: String, objectPath: String) -> URL? {
        guard AppConfig.isSupabaseConfigured else { return nil }
        return publicURL(
            base: AppConfig.supabaseURL
                .appendingPathComponent("storage/v1/object/public"),
            bucket: bucket,
            objectPath: objectPath
        )
    }

    nonisolated static func cdnPublicURL(bucket: String, objectPath: String) -> URL? {
        guard let base = AppConfig.mediaCDNBaseURL else { return nil }
        return publicURL(base: base, bucket: bucket, objectPath: objectPath)
    }

    nonisolated private static func publicURL(base: URL, bucket: String, objectPath: String) -> URL? {
        let cleanPath = objectPath.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        guard !cleanPath.isEmpty else { return nil }
        var baseString = base.absoluteString.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        return URL(string: "\(baseString)/\(bucket)/\(cleanPath)")
    }

    /// Canonical storage key for disk cache, or the normalized raw string for non-storage URLs.
    nonisolated static func cacheKey(for raw: String, defaultBucket: String) -> String {
        if let ref = parseStorageReference(from: raw, defaultBucket: defaultBucket) {
            return ref.canonicalKey
        }
        return raw.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
