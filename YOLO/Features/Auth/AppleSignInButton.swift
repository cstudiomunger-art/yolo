import AuthenticationServices
import CryptoKit
import Supabase
import SwiftUI

/// Native Sign in with Apple → exchanges the Apple identity token for a Supabase session.
/// Requires the bundle id to be listed in Supabase Dashboard → Auth → Providers → Apple → Client IDs.
struct AppleSignInButton: View {
    @Environment(\.colorScheme) private var colorScheme

    var onStart: () -> Void = {}
    var onSuccess: () -> Void = {}
    var onError: (String) -> Void = { _ in }

    @State private var currentNonce: String?

    var body: some View {
        SignInWithAppleButton(.continue) { request in
            let nonce = Nonce.random()
            currentNonce = nonce
            request.requestedScopes = [.email, .fullName]
            // Apple receives the SHA256 digest; the raw nonce goes to Supabase for verification.
            request.nonce = Nonce.sha256(nonce)
        } onCompletion: { result in
            handle(result)
        }
        .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
        .frame(height: 48)
    }

    private func handle(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .failure(let error):
            if let authError = error as? ASAuthorizationError, authError.code == .canceled {
                return
            }
            onError(error.localizedDescription)

        case .success(let authorization):
            guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
                  let tokenData = credential.identityToken,
                  let idToken = String(data: tokenData, encoding: .utf8),
                  let nonce = currentNonce
            else {
                onError(String(localized: "Apple sign-in failed. Please try again."))
                return
            }

            // Apple only returns the name on the very first authorization.
            let fullName = credential.fullName.flatMap { components -> String? in
                let name = PersonNameComponentsFormatter().string(from: components)
                return name.isEmpty ? nil : name
            }

            onStart()
            Task {
                do {
                    try await SupabaseManager.shared.auth.signInWithIdToken(
                        credentials: .init(provider: .apple, idToken: idToken, nonce: nonce)
                    )
                    if let fullName {
                        try? await SupabaseManager.shared.auth.update(
                            user: UserAttributes(data: ["full_name": .string(fullName)])
                        )
                    }
                    TelemetryService.shared.logEvent("sign_in_apple")
                    onSuccess()
                } catch {
                    onError(AuthFormSupport.errorMessage(for: error))
                }
            }
        }
    }

    private enum Nonce {
        static func random(length: Int = 32) -> String {
            let charset = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-._")
            var result = ""
            result.reserveCapacity(length)
            while result.count < length {
                var random: UInt8 = 0
                guard SecRandomCopyBytes(kSecRandomDefault, 1, &random) == errSecSuccess else {
                    continue
                }
                if random < charset.count {
                    result.append(charset[Int(random)])
                }
            }
            return result
        }

        static func sha256(_ input: String) -> String {
            SHA256.hash(data: Data(input.utf8))
                .map { String(format: "%02x", $0) }
                .joined()
        }
    }
}

#Preview {
    AppleSignInButton()
        .padding()
}
