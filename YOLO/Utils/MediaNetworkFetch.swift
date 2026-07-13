import Foundation

/// Fetches remote media with optional CDN → Supabase fallback.
enum MediaNetworkFetch {
    private static let fallbackTimeout: TimeInterval = 8

    nonisolated static func data(from resolved: CDNRouter.ResolvedMediaURLs) async throws -> Data {
        do {
            return try await data(from: resolved.primary, timeout: fallbackTimeout)
        } catch {
            guard let fallback = resolved.fallback else { throw error }
            return try await data(from: fallback, timeout: fallbackTimeout)
        }
    }

    nonisolated static func download(to destinationDirectory: URL, resolved: CDNRouter.ResolvedMediaURLs, filename: String) async throws -> URL {
        do {
            let (temp, _) = try await download(from: resolved.primary, timeout: fallbackTimeout)
            return try moveDownload(temp, to: destinationDirectory, filename: filename)
        } catch {
            guard let fallback = resolved.fallback else { throw error }
            let (temp, _) = try await download(from: fallback, timeout: fallbackTimeout)
            return try moveDownload(temp, to: destinationDirectory, filename: filename)
        }
    }

    // MARK: - Private

    private static func data(from url: URL, timeout: TimeInterval) async throws -> Data {
        var request = URLRequest(url: url)
        request.timeoutInterval = timeout
        let (data, response) = try await URLSession.shared.data(for: request)
        try validate(response: response)
        return data
    }

    private static func download(from url: URL, timeout: TimeInterval) async throws -> (URL, URLResponse) {
        var request = URLRequest(url: url)
        request.timeoutInterval = timeout
        let (temp, response) = try await URLSession.shared.download(for: request)
        try validate(response: response)
        return (temp, response)
    }

    private static func validate(response: URLResponse) throws {
        guard let http = response as? HTTPURLResponse else { return }
        guard (200 ... 299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }

    private static func moveDownload(_ temp: URL, to directory: URL, filename: String) throws -> URL {
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        let dest = directory.appendingPathComponent(filename)
        if FileManager.default.fileExists(atPath: dest.path) {
            try FileManager.default.removeItem(at: dest)
        }
        try FileManager.default.moveItem(at: temp, to: dest)
        return dest
    }
}
