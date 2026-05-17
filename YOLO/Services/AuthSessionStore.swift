import Auth
import Foundation
import Observation
import Supabase

@Observable
@MainActor
final class AuthSessionStore {
    private(set) var session: Session?

    var userEmail: String? { session?.user.email }
    var userId: UUID? { session?.user.id }
    var isAuthenticated: Bool { session != nil }

    @ObservationIgnored
    private var observeTask: Task<Void, Never>?

    init(client: SupabaseClient = SupabaseManager.shared) {
        observeTask = Task {
            for await (event, session) in client.auth.authStateChanges {
                switch event {
                case .initialSession, .signedIn, .signedOut, .tokenRefreshed, .userUpdated:
                    self.session = session
                default:
                    break
                }
            }
        }
    }

    deinit {
        observeTask?.cancel()
    }

    func signOut() async throws {
        try await SupabaseManager.shared.auth.signOut()
    }
}
