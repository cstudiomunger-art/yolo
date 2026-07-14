import Foundation
import Supabase

/// Resolves private chat-image URLs: gateway OSS sign API first, then Supabase Storage signed URL.
enum SignedMediaURLService {
    private struct SignResponse: Decodable {
        let url: String
        let expiresAt: String?
    }

    static func signedChatImageURL(for path: String, client: SupabaseClient = SupabaseManager.shared) async -> URL? {
        let cleaned = path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        guard !cleaned.isEmpty else { return nil }

        if let gatewayURL = await signViaGateway(path: cleaned) {
            return gatewayURL
        }
        return try? await client.storage.from("chat-images").createSignedURL(path: cleaned, expiresIn: 3600)
    }

    private static func signViaGateway(path: String) async -> URL? {
        guard let endpoint = AppConfig.mediaSignAPIURL,
              var components = URLComponents(url: endpoint, resolvingAgainstBaseURL: false)
        else { return nil }
        components.queryItems = [URLQueryItem(name: "path", value: path)]
        guard let url = components.url else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 8
        request.setValue(AppConfig.supabaseAnonKey, forHTTPHeaderField: "apikey")

        if let token = try? await SupabaseManager.shared.auth.session.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            return nil
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let http = response as? HTTPURLResponse, (200 ... 299).contains(http.statusCode) else {
                return nil
            }
            let decoded = try JSONDecoder().decode(SignResponse.self, from: data)
            return URL(string: decoded.url)
        } catch {
            return nil
        }
    }
}
