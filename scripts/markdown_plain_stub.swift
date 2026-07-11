import Foundation

/// Test-only stand-in for `MarkdownContentView.plainText` (avoids SwiftUI in golden harness).
enum MarkdownContentView {
    static func plainText(from content: String) -> String {
        var s = content.trimmingCharacters(in: .whitespacesAndNewlines)
        if s.isEmpty { return "" }

        s = s.replacingOccurrences(of: "!\\[([^\\]]*)\\]\\([^)]+\\)", with: "$1", options: .regularExpression)
        s = s.replacingOccurrences(of: "\\[([^\\]]+)\\]\\([^)]+\\)", with: "$1", options: .regularExpression)
        s = s.replacingOccurrences(of: "^#{1,6}\\s+", with: "", options: .regularExpression)
        s = s.replacingOccurrences(of: "^>\\s?", with: "", options: .regularExpression)
        s = s.replacingOccurrences(of: "^[\\s]*[-*+]\\s+", with: "", options: .regularExpression)
        s = s.replacingOccurrences(of: "^[\\s]*\\d+\\.\\s+", with: "", options: .regularExpression)
        s = s.replacingOccurrences(of: "\\*\\*([^*]+)\\*\\*", with: "$1", options: .regularExpression)
        s = s.replacingOccurrences(of: "\\*([^*]+)\\*", with: "$1", options: .regularExpression)
        s = s.replacingOccurrences(of: "`([^`]+)`", with: "$1", options: .regularExpression)

        while s.contains("\n\n\n") {
            s = s.replacingOccurrences(of: "\n\n\n", with: "\n\n")
        }
        return s.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
