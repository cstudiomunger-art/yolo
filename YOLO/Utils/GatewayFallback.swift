import Foundation
import Supabase

/// Gateway outage handling: sticky pin of `SUPABASE_FALLBACK_URL` for the next process launch.
/// Mid-session SupabaseClient rebuild is intentionally avoided (auth observers bind once).
/// Media still falls back via `CDNRouter` / `MediaNetworkFetch` within the same session.
enum GatewayFallback {
    private static let stickyKey = "yolohappy.gateway.stickyFallback.v1"
    private static let failCountKey = "yolohappy.gateway.failCount.v1"
    private static let timeout: TimeInterval = 2.5
    private static let failsBeforePin = 3

    /// URL SupabaseManager should use when constructing the shared client.
    nonisolated static var preferredSupabaseURL: URL {
        if isStickyFallbackEnabled, let fallback = AppConfig.supabaseFallbackURL {
            return fallback
        }
        return AppConfig.supabaseURL
    }

    nonisolated static var isStickyFallbackEnabled: Bool {
        guard AppConfig.isGatewayConfigured, AppConfig.supabaseFallbackURL != nil else { return false }
        return UserDefaults.standard.bool(forKey: stickyKey)
    }

    /// Clears sticky fallback so the next cold start prefers gateway again (call after successful gateway use).
    nonisolated static func clearStickyFallback() {
        UserDefaults.standard.set(false, forKey: stickyKey)
        UserDefaults.standard.set(0, forKey: failCountKey)
    }

    /// Pins fallback for next launch after repeated gateway reachability failures.
    nonisolated static func pinStickyFallback() {
        guard AppConfig.isGatewayConfigured, AppConfig.supabaseFallbackURL != nil else { return }
        UserDefaults.standard.set(true, forKey: stickyKey)
    }

    /// Probe gateway health; update sticky pin for subsequent launches.
    @MainActor
    static func refreshReachability() async {
        guard AppConfig.isGatewayConfigured, AppConfig.supabaseFallbackURL != nil else {
            clearStickyFallback()
            return
        }

        // Already pinned — occasionally re-probe gateway so we can recover.
        let url = AppConfig.supabaseURL.appendingPathComponent("auth/v1/health")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = timeout
        request.setValue(AppConfig.supabaseAnonKey, forHTTPHeaderField: "apikey")

        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            let code = (response as? HTTPURLResponse)?.statusCode ?? 0
            if (200 ... 499).contains(code) {
                clearStickyFallback()
            } else {
                recordFailure()
            }
        } catch {
            recordFailure()
        }
    }

    nonisolated private static func recordFailure() {
        let next = UserDefaults.standard.integer(forKey: failCountKey) + 1
        UserDefaults.standard.set(next, forKey: failCountKey)
        if next >= failsBeforePin {
            pinStickyFallback()
        }
    }
}
