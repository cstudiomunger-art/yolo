import Foundation
import Supabase

/// Lightweight probe + recovery hint when `SUPABASE_URL` points at gateway and it becomes unreachable.
/// Full mid-session client rebuild is out of scope; emergency recovery is DNS rollback or App fallback URL rebuild on next launch via `SUPABASE_FALLBACK_URL` documentation.
@MainActor
enum GatewayFallback {
    private static let timeout: TimeInterval = 3
    private(set) static var lastProbeSucceeded: Bool?

    /// Returns true when primary SUPABASE_URL health check succeeds (or no fallback configured).
    static func probePrimaryReachable() async -> Bool {
        guard AppConfig.supabaseFallbackURL != nil else {
            lastProbeSucceeded = true
            return true
        }
        var request = URLRequest(url: AppConfig.supabaseURL.appendingPathComponent("auth/v1/health"))
        request.httpMethod = "GET"
        request.timeoutInterval = timeout
        request.setValue(AppConfig.supabaseAnonKey, forHTTPHeaderField: "apikey")
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            let ok = (response as? HTTPURLResponse).map { (200 ... 499).contains($0.statusCode) } ?? false
            lastProbeSucceeded = ok
            return ok
        } catch {
            lastProbeSucceeded = false
            return false
        }
    }

    /// Builds a one-off direct Supabase client for emergency use when gateway probe fails.
    static func makeDirectClient() -> SupabaseClient? {
        guard let url = AppConfig.supabaseFallbackURL else { return nil }
        return SupabaseClient(
            supabaseURL: url,
            supabaseKey: AppConfig.supabaseAnonKey,
            options: SupabaseClientOptions(
                db: SupabaseClientOptions.DatabaseOptions(
                    encoder: JSONCoding.makeEncoder(),
                    decoder: JSONCoding.makeDecoder()
                ),
                auth: SupabaseClientOptions.AuthOptions(
                    emitLocalSessionAsInitialSession: true
                )
            )
        )
    }
}
