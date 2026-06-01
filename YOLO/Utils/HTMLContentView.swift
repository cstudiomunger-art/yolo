import SwiftUI
import WebKit

/// Renders CMS HTML or plain text (backward compatible with legacy string fields).
struct HTMLContentView: View {
    let content: String
    var fontSize: CGFloat = 14
    var foregroundColor: Color = Theme.ColorToken.textSecondary
    var lineSpacing: CGFloat = 6
    var lineLimit: Int?
    var allowsInteraction: Bool = true

    var body: some View {
        if lineLimit != nil || !Self.isLikelyHTML(content) {
            Text(Self.plainText(from: content))
                .font(Theme.FontToken.inter(fontSize))
                .foregroundStyle(foregroundColor)
                .lineSpacing(lineSpacing)
                .lineLimit(lineLimit)
        } else {
            HTMLWebContentView(
                html: content,
                fontSize: fontSize,
                foregroundColor: foregroundColor,
                lineSpacing: lineSpacing,
                allowsInteraction: allowsInteraction
            )
        }
    }

    static func isLikelyHTML(_ text: String) -> Bool {
        text.range(of: #"<[a-z][\s\S]*?>"#, options: .regularExpression) != nil
    }

    /// Rewrites relative Storage paths in `<img src>` to full HTTPS URLs for display.
    static func htmlForDisplay(_ html: String) -> String {
        guard isLikelyHTML(html),
              let regex = try? NSRegularExpression(
                pattern: #"<img([^>]*?)\bsrc=(["'])([^"']+)\2"#,
                options: .caseInsensitive
              )
        else { return html }

        let ns = html as NSString
        let mutable = NSMutableString(string: html)
        let matches = regex.matches(in: html, range: NSRange(location: 0, length: ns.length))
        for match in matches.reversed() {
            let src = ns.substring(with: match.range(at: 3))
            guard !src.lowercased().hasPrefix("http") else { continue }
            guard let url = MediaURLResolver.coverImageURL(from: src) else { continue }
            mutable.replaceCharacters(in: match.range(at: 3), with: url.absoluteString)
        }
        return mutable as String
    }

    /// Plain text for list previews / line-limited snippets. Avoids `NSAttributedString` HTML parsing (can SIGABRT).
    static func plainText(from content: String) -> String {
        let trimmed = content.trimmingCharacters(in: .whitespacesAndNewlines)
        guard isLikelyHTML(trimmed) else { return trimmed }
        return stripHTMLTags(trimmed)
    }

    private static func stripHTMLTags(_ html: String) -> String {
        var text = html
        text = text.replacingOccurrences(
            of: #"<(br|hr)\s*/?>"#,
            with: "\n",
            options: [.regularExpression, .caseInsensitive]
        )
        text = text.replacingOccurrences(
            of: #"</(p|div|h[1-6]|li|tr)>"#,
            with: "\n",
            options: [.regularExpression, .caseInsensitive]
        )
        text = text.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
        text = decodeBasicHTMLEntities(text)
        while text.contains("\n\n\n") {
            text = text.replacingOccurrences(of: "\n\n\n", with: "\n\n")
        }
        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private static func decodeBasicHTMLEntities(_ text: String) -> String {
        text
            .replacingOccurrences(of: "&nbsp;", with: " ")
            .replacingOccurrences(of: "&amp;", with: "&")
            .replacingOccurrences(of: "&lt;", with: "<")
            .replacingOccurrences(of: "&gt;", with: ">")
            .replacingOccurrences(of: "&quot;", with: "\"")
            .replacingOccurrences(of: "&#39;", with: "'")
    }
}

// MARK: - WKWebView (stable HTML rendering)

private struct HTMLWebContentView: View {
    let html: String
    let fontSize: CGFloat
    let foregroundColor: Color
    let lineSpacing: CGFloat
    var allowsInteraction: Bool = true

    @State private var contentHeight: CGFloat = 120

    var body: some View {
        HTMLWebViewRepresentable(
            html: html,
            fontSize: fontSize,
            foregroundColor: foregroundColor,
            lineSpacing: lineSpacing,
            allowsInteraction: allowsInteraction,
            contentHeight: $contentHeight
        )
        .frame(height: contentHeight)
        .allowsHitTesting(allowsInteraction)
    }
}

private struct HTMLWebViewRepresentable: UIViewRepresentable {
    let html: String
    let fontSize: CGFloat
    let foregroundColor: Color
    let lineSpacing: CGFloat
    let allowsInteraction: Bool
    @Binding var contentHeight: CGFloat

    func makeCoordinator() -> Coordinator {
        Coordinator(contentHeight: $contentHeight)
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        webView.scrollView.isScrollEnabled = false
        webView.isUserInteractionEnabled = allowsInteraction
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        context.coordinator.contentHeight = $contentHeight
        webView.isUserInteractionEnabled = allowsInteraction
        let uiColor = UIColor(foregroundColor)
        let displayHtml = HTMLContentView.htmlForDisplay(html)
        let wrapped = """
        <!DOCTYPE html><html><head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style>
        body {
          font-family: -apple-system, sans-serif;
          font-size: \(fontSize)px;
          color: \(uiColor.hexString);
          line-height: \(fontSize + lineSpacing)px;
          margin: 0;
          padding: 0;
          -webkit-text-size-adjust: 100%;
        }
        p { margin: 0 0 0.6em 0; }
        ul, ol { margin: 0.4em 0; padding-left: 1.2em; }
        a { color: #c45c26; }
        img { max-width: 100%; height: auto; border-radius: 8px; margin: 8px 0; display: block; }
        </style>
        </head><body>\(displayHtml)</body></html>
        """
        if context.coordinator.lastHTML != wrapped {
            context.coordinator.lastHTML = wrapped
            webView.loadHTMLString(wrapped, baseURL: nil)
        }
    }

    final class Coordinator: NSObject, WKNavigationDelegate {
        var contentHeight: Binding<CGFloat>
        var lastHTML: String?

        init(contentHeight: Binding<CGFloat>) {
            self.contentHeight = contentHeight
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript("document.body.scrollHeight") { [weak self] result, _ in
                guard let self, let height = result as? CGFloat, height > 0 else { return }
                DispatchQueue.main.async {
                    self.contentHeight.wrappedValue = max(height + 8, 44)
                }
            }
        }
    }
}

private extension UIColor {
    var hexString: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
    }
}
