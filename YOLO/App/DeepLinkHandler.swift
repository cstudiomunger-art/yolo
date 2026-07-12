import Foundation

enum DeepLinkHandler {
    enum Action: Equatable {
        case openSharedItinerary(slug: String)
        case passwordRecovery
        case emailConfirmation
        case oauthCallback
        case redeemInviteCode(code: String)
    }

    static func action(for url: URL) -> Action? {
        if url.scheme?.lowercased() == "yoloapp" {
            if url.host == "auth-callback" {
                return .oauthCallback
            }
            if url.host == "auth", url.path.contains("confirm") || containsEmailConfirmationType(in: url) {
                return .emailConfirmation
            }
            if url.host == "auth", url.path.contains("reset") || containsPasswordRecoveryType(in: url) {
                return .passwordRecovery
            }
            if let slug = ItineraryShareService.parseShareSlug(from: url) {
                return .openSharedItinerary(slug: slug)
            }
            if url.host == "redeem" {
                let code = URLComponents(url: url, resolvingAgainstBaseURL: false)?
                    .queryItems?
                    .first(where: { $0.name == "code" })?
                    .value?
                    .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                if !code.isEmpty { return .redeemInviteCode(code: code) }
            }
        }
        if let slug = ItineraryShareService.parseShareSlug(from: url) {
            return .openSharedItinerary(slug: slug)
        }
        if url.absoluteString.contains("type=recovery") {
            return .passwordRecovery
        }
        if containsEmailConfirmationType(in: url) {
            return .emailConfirmation
        }
        return nil
    }

    private static func containsEmailConfirmationType(in url: URL) -> Bool {
        let combined = authParamString(in: url)
        return combined.localizedCaseInsensitiveContains("type=signup")
            || combined.localizedCaseInsensitiveContains("type=email")
    }

    private static func containsPasswordRecoveryType(in url: URL) -> Bool {
        let combined = authParamString(in: url)
        return combined.localizedCaseInsensitiveContains("type=recovery")
            || combined.localizedCaseInsensitiveContains("code=")
    }

    private static func authParamString(in url: URL) -> String {
        [url.fragment, url.query, url.absoluteString]
            .compactMap { $0 }
            .joined(separator: "&")
    }
}
