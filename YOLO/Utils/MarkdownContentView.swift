import SwiftUI
import MarkdownUI

/// Renders CMS Markdown (replaces legacy HTMLContentView / WKWebView).
struct MarkdownContentView: View {
    let content: String
    var fontSize: CGFloat = 14
    var foregroundColor: Color = Theme.ColorToken.textSecondary
    var lineSpacing: CGFloat = 6
    var lineLimit: Int?
    var allowsInteraction: Bool = true
    var onImageTap: ((URL) -> Void)?

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        let trimmed = content.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            EmptyView()
        } else if lineLimit != nil {
            Text(Self.plainText(from: content))
                .font(Theme.FontToken.inter(fontSize))
                .foregroundStyle(foregroundColor)
                .lineSpacing(lineSpacing)
                .lineLimit(lineLimit)
        } else {
            Markdown(Self.markdownForDisplay(content))
                .markdownTheme(Self.theme(
                    fontSize: fontSize,
                    foregroundColor: foregroundColor,
                    lineSpacing: lineSpacing,
                    colorScheme: colorScheme
                ))
                .markdownImageProvider(TapImageProvider(onTap: onImageTap))
                .allowsHitTesting(allowsInteraction)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    // MARK: - Preprocessing

    static func markdownForDisplay(_ markdown: String) -> String {
        guard let regex = try? NSRegularExpression(
            pattern: #"!\[([^\]]*)\]\(([^)]+)\)"#,
            options: []
        ) else { return markdown }

        let ns = markdown as NSString
        let mutable = NSMutableString(string: markdown)
        let matches = regex.matches(in: markdown, range: NSRange(location: 0, length: ns.length))
        for match in matches.reversed() {
            let urlPart = ns.substring(with: match.range(at: 2)).trimmingCharacters(in: .whitespacesAndNewlines)
            guard !urlPart.lowercased().hasPrefix("http"),
                  let resolved = MediaURLResolver.coverImageURL(from: urlPart) else { continue }
            mutable.replaceCharacters(in: match.range(at: 2), with: resolved.absoluteString)
        }
        return mutable as String
    }

    /// Plain text for list previews / line-limited snippets.
    static func plainText(from content: String) -> String {
        var s = content.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !s.isEmpty else { return "" }

        if let img = try? NSRegularExpression(pattern: #"!\[([^\]]*)\]\([^)]+\)"#) {
            s = img.stringByReplacingMatches(in: s, range: NSRange(s.startIndex..., in: s), withTemplate: "$1")
        }
        if let link = try? NSRegularExpression(pattern: #"\[([^\]]+)\]\([^)]+\)"#) {
            s = link.stringByReplacingMatches(in: s, range: NSRange(s.startIndex..., in: s), withTemplate: "$1")
        }
        s = s.replacingOccurrences(of: #"^#{1,6}\s+"#, with: "", options: .regularExpression)
        s = s.replacingOccurrences(of: #"^>\s?"#, with: "", options: .regularExpression)
        s = s.replacingOccurrences(of: #"^[\s]*[-*+]\s+"#, with: "", options: .regularExpression)
        s = s.replacingOccurrences(of: #"^[\s]*\d+\.\s+"#, with: "", options: .regularExpression)
        s = s.replacingOccurrences(of: #"\*\*([^*]+)\*\*"#, with: "$1", options: .regularExpression)
        s = s.replacingOccurrences(of: #"\*([^*]+)\*"#, with: "$1", options: .regularExpression)
        s = s.replacingOccurrences(of: #"`([^`]+)`"#, with: "$1", options: .regularExpression)
        s = s.replacingOccurrences(of: #"\|[-:\s|]+\|"#, with: "", options: .regularExpression)
        while s.contains("\n\n\n") {
            s = s.replacingOccurrences(of: "\n\n\n", with: "\n\n")
        }
        return s.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    // MARK: - Theme

    static func theme(
        fontSize: CGFloat,
        foregroundColor: Color,
        lineSpacing: CGFloat,
        colorScheme: ColorScheme
    ) -> MarkdownUI.Theme {
        let accent = Theme.ColorToken.accent
        let border = Theme.ColorToken.border
        let subtle = Theme.ColorToken.backgroundSubtle

        return MarkdownUI.Theme()
            .text {
                FontSize(fontSize)
                ForegroundColor(foregroundColor)
            }
            .strong {
                FontWeight(.semibold)
                ForegroundColor(Theme.ColorToken.textPrimary)
            }
            .emphasis {
                FontStyle(.italic)
            }
            .link {
                ForegroundColor(accent)
            }
            .heading2 { configuration in
                configuration.label
                    .markdownTextStyle {
                        FontSize(fontSize * 1.15)
                        FontWeight(.semibold)
                        ForegroundColor(Theme.ColorToken.textPrimary)
                    }
                    .padding(.top, 8)
            }
            .heading3 { configuration in
                configuration.label
                    .markdownTextStyle {
                        FontSize(fontSize * 1.08)
                        FontWeight(.semibold)
                        ForegroundColor(Theme.ColorToken.textPrimary)
                    }
                    .padding(.top, 6)
            }
            .paragraph { configuration in
                configuration.label
                    .padding(.bottom, 4)
                    .lineSpacing(lineSpacing)
            }
            .blockquote { configuration in
                configuration.label
                    .padding(.vertical, 8)
                    .padding(.leading, 10)
                    .overlay(alignment: .leading) {
                        Rectangle().fill(accent).frame(width: 2)
                    }
                    .background(subtle)
            }
            .table { configuration in
                configuration.label
                    .fixedSize(horizontal: false, vertical: true)
                    .markdownTableBorderStyle(.init(color: border))
                    .markdownTableBackgroundStyle(
                        .alternatingRows(
                            Theme.ColorToken.background,
                            subtle
                        )
                    )
                    .padding(.vertical, 4)
            }
            .tableCell { configuration in
                configuration.label
                    .markdownTextStyle {
                        FontSize(fontSize * 0.92)
                        if configuration.row == 0 {
                            FontWeight(.semibold)
                            ForegroundColor(Theme.ColorToken.textPrimary)
                        }
                    }
                    .padding(.vertical, 4)
                    .padding(.horizontal, 6)
            }
    }
}

// MARK: - Image provider

private struct TapImageProvider: ImageProvider {
    let onTap: ((URL) -> Void)?

    func makeImage(url: URL?) -> some View {
        Group {
            if let url {
                if let onTap {
                    Button {
                        onTap(url)
                    } label: {
                        imageBody(url: url)
                    }
                    .buttonStyle(.plain)
                } else {
                    imageBody(url: url)
                }
            }
        }
    }

    @ViewBuilder
    private func imageBody(url: URL) -> some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: Theme.CornerRadius.medium))
            case .failure:
                Rectangle()
                    .fill(Theme.ColorToken.backgroundSubtle)
                    .frame(height: 120)
                    .overlay {
                        Image(systemName: "photo")
                            .foregroundStyle(Theme.ColorToken.textMuted)
                    }
            default:
                Rectangle()
                    .fill(Theme.ColorToken.backgroundSubtle)
                    .frame(height: 120)
                    .overlay { ProgressView() }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 6)
    }
}
