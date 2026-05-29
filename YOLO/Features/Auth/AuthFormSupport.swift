import Auth
import Foundation

enum AuthFormSupport {
    static let minimumPasswordLength = 6

    static func trimmedEmail(_ email: String) -> String {
        email.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    static func isValidEmail(_ value: String) -> Bool {
        let parts = value.split(separator: "@", omittingEmptySubsequences: false)
        guard parts.count == 2,
              !parts[0].isEmpty,
              parts[1].contains(".")
        else {
            return false
        }
        return true
    }

    /// Supabase returns an obfuscated user with empty identities when the email is already registered
    /// and email confirmation is enabled.
    static func isAlreadyRegisteredUser(_ user: User?) -> Bool {
        guard let user else { return false }
        return user.identities?.isEmpty == true
    }

    static func errorMessage(for error: Error) -> String {
        let description = error.localizedDescription
        if description.localizedCaseInsensitiveContains("email not confirmed") {
            return String(localized: "Email not confirmed. Check your sign-up confirmation email before signing in.")
        }
        if description.localizedCaseInsensitiveContains("invalid login credentials") {
            return String(localized: "Incorrect email or password. Please try again.")
        }
        if description.localizedCaseInsensitiveContains("rate limit") {
            return String(localized: "Too many attempts. Please try again later.")
        }
        if description.localizedCaseInsensitiveContains("user already registered")
            || description.localizedCaseInsensitiveContains("email_exists")
            || description.localizedCaseInsensitiveContains("already been registered") {
            return String(localized: "An account with this email already exists. Try signing in instead.")
        }
        return description
    }
}
