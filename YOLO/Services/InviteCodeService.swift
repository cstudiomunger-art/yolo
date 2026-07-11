import Foundation
import Supabase

enum InviteCodeError: Error, LocalizedError {
    case notConfigured
    case invalidCode
    case expired
    case notYetValid
    case exhausted
    case codeAlreadyUsed
    case alreadyRedeemed
    case accountAlreadyRedeemed
    case campaignAlreadyRedeemed
    case accountBlocked
    case notEligible
    case notAuthenticated
    case rateLimited
    case server(String)

    var errorDescription: String? {
        switch self {
        case .notConfigured:
            String(localized: "Invite code redemption is not available in this build.")
        case .invalidCode:
            String(localized: "This invite code isn't valid.")
        case .expired:
            String(localized: "This invite code has expired.")
        case .notYetValid:
            String(localized: "This invite code isn't active yet.")
        case .exhausted:
            String(localized: "This invite code has reached its limit.")
        case .codeAlreadyUsed:
            String(localized: "This code has already been used.")
        case .alreadyRedeemed:
            String(localized: "You've already used this code.")
        case .accountAlreadyRedeemed:
            String(localized: "Your account has already redeemed an invite code.")
        case .campaignAlreadyRedeemed:
            String(localized: "You've already claimed a code from this promotion.")
        case .accountBlocked:
            String(localized: "Your account can't redeem codes right now.")
        case .notEligible:
            String(localized: "This code is only for new members.")
        case .notAuthenticated:
            String(localized: "Sign in to redeem an invite code.")
        case .rateLimited:
            String(localized: "Too many attempts. Please try again later.")
        case .server(let message):
            message
        }
    }

    static func from(code: String?) -> InviteCodeError {
        guard let code, !code.isEmpty else {
            return .server(String(localized: "Could not redeem code. Please try again."))
        }
        switch code {
        case "INVALID_CODE": return .invalidCode
        case "EXPIRED": return .expired
        case "NOT_YET_VALID": return .notYetValid
        case "EXHAUSTED": return .exhausted
        case "CODE_ALREADY_USED": return .codeAlreadyUsed
        case "ALREADY_REDEEMED": return .alreadyRedeemed
        case "ACCOUNT_ALREADY_REDEEMED": return .accountAlreadyRedeemed
        case "CAMPAIGN_ALREADY_REDEEMED": return .campaignAlreadyRedeemed
        case "ACCOUNT_BLOCKED": return .accountBlocked
        case "NOT_ELIGIBLE": return .notEligible
        case "NOT_AUTHENTICATED": return .notAuthenticated
        case "RATE_LIMITED": return .rateLimited
        default:
            return .server(String(localized: "Could not redeem code. Please try again."))
        }
    }
}

struct InviteCodeRedeemResult: Decodable, Sendable {
    let ok: Bool
    let error: String?
    let expiresAtRaw: String?
    let isLifetime: Bool?
    let alreadyLifetime: Bool?
    let planId: String?
    let benefitLabel: String?

    var expiresAt: Date? {
        guard let expiresAtRaw else { return nil }
        return ISO8601DateFormatter().date(from: expiresAtRaw)
    }

    enum CodingKeys: String, CodingKey {
        case ok, error
        case expiresAtRaw = "expires_at"
        case isLifetime = "is_lifetime"
        case alreadyLifetime = "already_lifetime"
        case planId = "plan_id"
        case benefitLabel = "benefit_label"
    }
}

enum InviteCodeService {
    static func normalize(_ raw: String) -> String {
        raw.uppercased().filter { $0.isLetter || $0.isNumber }
    }

    static func redeem(code raw: String) async throws -> InviteCodeRedeemResult {
        guard AppConfig.isSupabaseConfigured, !AppConfig.useMock else {
            throw InviteCodeError.notConfigured
        }

        let code = normalize(raw)
        guard code.count >= 6 else { throw InviteCodeError.invalidCode }

        let result: InviteCodeRedeemResult = try await SupabaseManager.shared
            .rpc("redeem_invite_code", params: ["p_code": code])
            .execute()
            .value

        if result.ok {
            TelemetryService.shared.logEvent("invite_redeem_success")
            return result
        }

        let err = InviteCodeError.from(code: result.error)
        TelemetryService.shared.logEvent("invite_redeem_fail", parameters: ["error": result.error ?? "unknown"])
        throw err
    }
}
