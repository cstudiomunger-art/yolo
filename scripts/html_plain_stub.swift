import Foundation

/// Test-only stand-in for `HTMLContentView.plainText` (avoids SwiftUI in golden harness).
enum HTMLContentView {
    static func plainText(from content: String) -> String {
        content.replacingOccurrences(
            of: "<[^>]+>",
            with: "",
            options: .regularExpression
        ).trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
