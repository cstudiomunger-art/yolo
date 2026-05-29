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

    static func isRateLimitError(_ error: Error) -> Bool {
        let description = error.localizedDescription
        return description.localizedCaseInsensitiveContains("rate limit")
            || description.localizedCaseInsensitiveContains("over_email_send_rate_limit")
            || description.localizedCaseInsensitiveContains("too many requests")
    }

    static func errorMessage(for error: Error) -> String {
        let description = error.localizedDescription
        if description.localizedCaseInsensitiveContains("email not confirmed") {
            return String(localized: "Email not confirmed. Check your sign-up confirmation email before signing in.")
        }
        if description.localizedCaseInsensitiveContains("invalid login credentials") {
            return String(localized: "Incorrect email or password. Please try again.")
        }
        if description.localizedCaseInsensitiveContains("rate limit")
            || description.localizedCaseInsensitiveContains("over_email_send_rate_limit")
            || description.localizedCaseInsensitiveContains("too many requests") {
            return String(localized: "Too many password reset emails sent. Wait a few minutes, check your inbox and spam folder, then try again.")
        }
        if description.localizedCaseInsensitiveContains("user already registered")
            || description.localizedCaseInsensitiveContains("email_exists")
            || description.localizedCaseInsensitiveContains("already been registered") {
            return String(localized: "An account with this email already exists. Try signing in instead.")
        }
        return description
    }
}
