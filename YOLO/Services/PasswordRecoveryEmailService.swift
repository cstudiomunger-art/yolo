import Foundation

/// Sends password recovery email via GoTrue REST API without PKCE.
/// Email links then redirect to the web page with tokens in the URL hash (implicit flow),
/// so users can reset their password in the browser without opening the app.
enum PasswordRecoveryEmailService {
    enum ServiceError: LocalizedError {
        case invalidResponse
        case server(message: String)

        var errorDescription: String? {
            switch self {
            case .invalidResponse:
                return String(localized: "Unable to send password reset email. Please try again.")
            case .server(let message):
                return message
            }
        }
    }

    static func sendResetEmail(to email: String) async throws {
        let url = AppConfig.supabaseURL.appendingPathComponent("auth/v1/recover")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(AppConfig.supabaseAnonKey, forHTTPHeaderField: "apikey")
        request.setValue("Bearer \(AppConfig.supabaseAnonKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = try JSONSerialization.data(withJSONObject: [
            "email": email,
            "redirect_to": AppConfig.authRedirectURL.absoluteString,
        ])

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse else {
            throw ServiceError.invalidResponse
        }

        guard (200 ... 299).contains(http.statusCode) else {
            let body = try? JSONDecoder().decode(ServerErrorBody.self, from: data)
            throw ServiceError.server(message: body?.resolvedMessage ?? ServiceError.invalidResponse.errorDescription!)
        }
    }

    private struct ServerErrorBody: Decodable {
        let message: String?
        let error_description: String?

        var resolvedMessage: String? {
            message ?? error_description
        }
    }
}
