import Foundation
import Supabase

enum AccountDeletionService {
    enum DeletionError: LocalizedError {
        case notConfigured
        case server(String)

        var errorDescription: String? {
            switch self {
            case .notConfigured: String(localized: "Account deletion is not available in this build.")
            case .server(let message): message
            }
        }
    }

    static func deleteCurrentAccount() async throws {
        guard AppConfig.isSupabaseConfigured, !AppConfig.useMock else {
            throw DeletionError.notConfigured
        }

        struct EmptyBody: Encodable {}
        let response: DeleteAccountResponse = try await SupabaseManager.shared.functions.invoke(
            "delete-account",
            options: FunctionInvokeOptions(method: .post, body: EmptyBody()),
            decoder: JSONCoding.makeDecoder()
        )

        if !response.ok {
            let message = response.error ?? String(localized: "Could not delete account. Please try again.")
            throw DeletionError.server(message)
        }
    }
}

private struct DeleteAccountResponse: Decodable {
    let ok: Bool
    let error: String?
}
