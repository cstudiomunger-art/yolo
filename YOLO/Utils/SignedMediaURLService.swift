import Foundation
import Supabase

/// Resolves private chat-image URLs: gateway OSS sign API first (China), then Supabase Storage signed URL.
enum SignedMediaURLService {
    private struct SignResponse: Decodable {
        let url: String
        let expiresAt: String?
    }

    private actor SignCache {
        private var entries: [String: (url: URL, expiresAt: Date)] = [:]
        private var unavailableUntil: Date?

        func cachedURL(for path: String) -> URL? {
            guard let entry = entries[path], entry.expiresAt > Date() else {
                entries[path] = nil
                return nil
            }
            return entry.url
        }

        func store(path: String, url: URL, ttl: TimeInterval) {
            entries[path] = (url, Date().addingTimeInterval(ttl))
        }

        var isSignBlocked: Bool {
            unavailableUntil.map { $0 > Date() } ?? false
        }

        func markUnavailable(seconds: TimeInterval) {
            unavailableUntil = Date().addingTimeInterval(seconds)
        }
    }

    private static let cache = SignCache()

    static func signedChatImageURL(for path: String, client: SupabaseClient = SupabaseManager.shared) async -> URL? {
        let cleaned = path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        guard !cleaned.isEmpty else { return nil }

        if let cached = await cache.cachedURL(for: cleaned) {
            return cached
        }

        if AppConfig.mediaSignAPIURL != nil, let gatewayURL = await signViaGateway(path: cleaned) {
            await cache.store(path: cleaned, url: gatewayURL, ttl: 3300)
            return gatewayURL
        }

        guard let signed = try? await client.storage.from("chat-images").createSignedURL(path: cleaned, expiresIn: 3600) else {
            return nil
        }
        await cache.store(path: cleaned, url: signed, ttl: 3300)
        return signed
    }

    private static func signViaGateway(path: String) async -> URL? {
        if await cache.isSignBlocked { return nil }

        guard let endpoint = AppConfig.mediaSignAPIURL,
              var components = URLComponents(url: endpoint, resolvingAgainstBaseURL: false)
        else { return nil }
        components.queryItems = [URLQueryItem(name: "path", value: path)]
        guard let url = components.url else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 2.5
        request.setValue(AppConfig.supabaseAnonKey, forHTTPHeaderField: "apikey")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        guard let token = try? await SupabaseManager.shared.auth.session.accessToken else {
            return nil
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let http = response as? HTTPURLResponse else { return nil }
            switch http.statusCode {
            case 200 ... 299:
                let decoded = try JSONDecoder().decode(SignResponse.self, from: data)
                return URL(string: decoded.url)
            case 401, 403:
                return nil
            case 404, 502, 503, 504:
                // Sign route missing (overseas → Supabase Custom Domain) or gateway down.
                await cache.markUnavailable(seconds: 120)
                return nil
            default:
                return nil
            }
        } catch {
            await cache.markUnavailable(seconds: 30)
            return nil
        }
    }
}
