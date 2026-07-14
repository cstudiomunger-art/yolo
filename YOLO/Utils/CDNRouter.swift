import Foundation

/// Resolves CMS storage paths and Supabase/gateway/CDN public URLs to CDN (primary) + Supabase (fallback).
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
    /// Buckets mirrored to OSS / media CDN (see docs/media-url-spec.md).
    private static let cdnEligibleBuckets: Set<String> = ["audio-guides", "cover-images", "avatars"]

    // MARK: - Parsing

    nonisolated static func parseStorageReference(from raw: String, defaultBucket: String) -> StorageReference? {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }

        if let url = URL(string: trimmed),
           let scheme = url.scheme?.lowercased(),
           scheme == "http" || scheme == "https",
           let host = url.host?.lowercased() {
            let path = url.path.removingPercentEncoding ?? url.path

            if host.contains("supabase.co") || isGatewayLikeHost(host) {
                if let markerRange = path.range(of: supabasePublicPathMarker) {
                    return reference(fromPublicTail: String(path[markerRange.upperBound...]))
                }
            }

            if isMediaCDNHost(host) {
                return reference(fromPublicTail: path, requireEligibleBucket: true)
            }
        }

        var path = trimmed
        if let q = path.firstIndex(of: "?") {
            path = String(path[..<q])
        }
        let bucketPrefix = "\(defaultBucket)/"
        if path.hasPrefix(bucketPrefix) {
            path = String(path.dropFirst(bucketPrefix.count))
        }
        path = path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        guard !path.isEmpty else { return nil }
        return StorageReference(bucket: defaultBucket, objectPath: path)
    }

    nonisolated private static func reference(fromPublicTail raw: String, requireEligibleBucket: Bool = false) -> StorageReference? {
        let tail = raw.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        guard let slash = tail.firstIndex(of: "/") else { return nil }
        let bucket = String(tail[..<slash])
        var objectPath = String(tail[tail.index(after: slash)...])
        objectPath = objectPath.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        guard !bucket.isEmpty, !objectPath.isEmpty else { return nil }
        if requireEligibleBucket, !cdnEligibleBuckets.contains(bucket) { return nil }
        return StorageReference(bucket: bucket, objectPath: objectPath)
    }

    // MARK: - URL building

    nonisolated static func publicMediaURLs(from raw: String, bucket: String) -> ResolvedMediaURLs? {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }

        let query = URLComponents(string: trimmed)?.query
        if let ref = parseStorageReference(from: trimmed, defaultBucket: bucket) {
            return publicMediaURLs(reference: ref, preservingQuery: query)
        }

        if let url = URL(string: trimmed),
           let scheme = url.scheme?.lowercased(),
           scheme == "http" || scheme == "https" {
            return ResolvedMediaURLs(primary: url, fallback: nil)
        }

        return nil
    }

    nonisolated static func publicMediaURLs(reference: StorageReference, preservingQuery: String? = nil) -> ResolvedMediaURLs? {
        let supabase = supabasePublicURL(bucket: reference.bucket, objectPath: reference.objectPath)
        guard let supabase else { return nil }
        let supabaseWithQuery = appendingQuery(supabase, preservingQuery)

        if cdnEligibleBuckets.contains(reference.bucket),
           let cdn = cdnPublicURL(bucket: reference.bucket, objectPath: reference.objectPath) {
            let primary = appendingQuery(cdn, preservingQuery)
            // Avoid useless dual request when CDN is unset / points at same host.
            if primary.host?.lowercased() == supabaseWithQuery.host?.lowercased(),
               primary.path == supabaseWithQuery.path {
                return ResolvedMediaURLs(primary: primary, fallback: nil)
            }
            return ResolvedMediaURLs(primary: primary, fallback: supabaseWithQuery)
        }
        return ResolvedMediaURLs(primary: supabaseWithQuery, fallback: nil)
    }

    /// Storage origin preferred for CDN fallback (direct Supabase when configured).
    nonisolated static var supabaseStorageBaseURL: URL {
        AppConfig.supabaseFallbackURL ?? AppConfig.supabaseURL
    }

    nonisolated static func supabasePublicURL(bucket: String, objectPath: String) -> URL? {
        guard AppConfig.isSupabaseConfigured else { return nil }
        return publicURL(
            base: supabaseStorageBaseURL.appendingPathComponent("storage/v1/object/public"),
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
        // Encode each path segment so spaces / unicode work on CDN/OSS.
        let encodedObject = cleanPath
            .split(separator: "/")
            .map { segment in
                segment.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? String(segment)
            }
            .joined(separator: "/")
        let encodedBucket = bucket.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? bucket
        return URL(string: "\(baseString)/\(encodedBucket)/\(encodedObject)")
    }

    nonisolated private static func appendingQuery(_ url: URL, _ query: String?) -> URL {
        guard let query, !query.isEmpty else { return url }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.query = query
        return components?.url ?? url
    }

    nonisolated private static func isMediaCDNHost(_ host: String) -> Bool {
        if let cdnHost = AppConfig.mediaCDNBaseURL?.host?.lowercased(), host == cdnHost {
            return true
        }
        return host == "media.yolohappy.com" || host.hasPrefix("staging.media.")
    }

    nonisolated private static func isGatewayLikeHost(_ host: String) -> Bool {
        host == "gateway.yolohappy.com"
            || host.hasPrefix("staging.gateway.")
            || (host.hasSuffix(".yolohappy.com") && host.contains("gateway"))
    }

    /// Canonical storage key for disk cache, or the normalized raw string for non-storage URLs.
    nonisolated static func cacheKey(for raw: String, defaultBucket: String) -> String {
        if let ref = parseStorageReference(from: raw, defaultBucket: defaultBucket) {
            return ref.canonicalKey
        }
        // Strip volatile query (?v=) so CDN and Supabase URLs share one disk entry.
        if var components = URLComponents(string: raw.trimmingCharacters(in: .whitespacesAndNewlines)) {
            components.query = nil
            components.fragment = nil
            if let stripped = components.string, !stripped.isEmpty { return stripped }
        }
        return raw.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
