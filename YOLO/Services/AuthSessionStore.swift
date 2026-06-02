import Auth
import Foundation
import Observation
import Supabase

@Observable
@MainActor
final class AuthSessionStore {
    private(set) var session: Session?
    private(set) var passwordRecoveryPending = false

    var userEmail: String? { session?.user.email }
    var userId: UUID? { session?.user.id }
    var isAuthenticated: Bool { session != nil }

    @ObservationIgnored
    private var observeTask: Task<Void, Never>?

    init(client: SupabaseClient = SupabaseManager.shared) {
        observeTask = Task { @MainActor in
            for await (event, session) in client.auth.authStateChanges {
                switch event {
                case .initialSession, .signedIn, .signedOut, .tokenRefreshed, .userUpdated:
                    self.session = session
                case .passwordRecovery:
                    self.session = session
                    self.passwordRecoveryPending = true
                default:
                    break
                }
            }
        }
    }

    func markPasswordRecoveryPending() {
        passwordRecoveryPending = true
    }

    func clearPasswordRecoveryPending() {
        passwordRecoveryPending = false
    }

    deinit {
        observeTask?.cancel()
    }

    func signOut() async throws {
        try await SupabaseManager.shared.auth.signOut()
    }
}
