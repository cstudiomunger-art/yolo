import Foundation

/// Parses access/refresh tokens from auth deep links (`yoloapp://…#access_token=…` or query).
enum AuthDeepLinkTokens {
    struct Pair {
        let accessToken: String
        let refreshToken: String
    }

    static func parse(from url: URL) -> Pair? {
        let combined = [url.fragment, url.query]
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .joined(separator: "&")
        guard !combined.isEmpty else { return nil }

        var access: String?
        var refresh: String?
        for item in combined.split(separator: "&") {
            let parts = item.split(separator: "=", maxSplits: 1).map(String.init)
            guard parts.count == 2 else { continue }
            let key = parts[0]
            let value = parts[1].removingPercentEncoding ?? parts[1]
            switch key {
            case "access_token":
                access = value
            case "refresh_token":
                refresh = value
            default:
                break
            }
        }
        guard let accessToken = access, !accessToken.isEmpty,
              let refreshToken = refresh, !refreshToken.isEmpty
        else { return nil }
        return Pair(accessToken: accessToken, refreshToken: refreshToken)
    }
}
