import SwiftUI

/// Renders a truncated preview of HTML/text content with a paywall overlay.
/// When the user has access, the full content is shown normally.
struct ContentPaywallOverlay: View {
    @Environment(AppEnvironment.self) private var appEnv

    let htmlContent: String
    let freeChars: Int
    let hasAccess: Bool
    var attraction: Attraction?
    var guide: AudioGuide?
    var onUnlock: (() -> Void)?

    @State private var showPaywall = false

    var body: some View {
        if hasAccess {
            HTMLContentView(content: htmlContent)
        } else {
            ZStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 0) {
                    HTMLContentView(content: truncatedContent)
                }
                .mask(
                    LinearGradient(
                        colors: [.black, .black.opacity(0.6), .clear],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

                VStack(spacing: 10) {
                    HStack(spacing: 6) {
                        Text("🔒")
                        Text(String(localized: "Full content locked"))
                            .font(Theme.FontToken.inter(12))
                            .foregroundStyle(Theme.ColorToken.textSecondary)
                    }

                    Button {
                        showPaywall = true
                    } label: {
                        Text(String(localized: "Unlock Full Content →"))
                            .font(Theme.FontToken.inter(12, weight: .medium))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Theme.ColorToken.accent)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.top, 24)
            }
            .sheet(isPresented: $showPaywall) {
                if let attraction {
                    MembershipPlansView(
                        attraction: attraction,
                        guide: guide,
                        onPurchaseComplete: { onUnlock?() }
                    )
                    .environment(appEnv)
                } else {
                    // No attraction context: show generic membership plans without single-attraction option
                    Text(String(localized: "Upgrade to unlock full content"))
                        .font(Theme.FontToken.playfair(17, weight: .semibold))
                        .padding(Theme.screenPadding)
                }
            }
        }
    }

    private var truncatedContent: String {
        let plain = HTMLContentView.plainText(from: htmlContent)
        guard plain.count > freeChars else { return htmlContent }
        // Build a safe plain-text preview — escape HTML special chars before wrapping in <p>
        let truncated = String(plain.prefix(freeChars))
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
        return "<p>\(truncated)…</p>"
    }
}

/// Wraps a list of visitor tips with a paywall after `freeCount` items.
struct VisitorTipsPaywallOverlay: View {
    @Environment(AppEnvironment.self) private var appEnv

    let tips: [String]
    let freeCount: Int
    let hasAccess: Bool
    var attraction: Attraction?
    var onUnlock: (() -> Void)?

    @State private var showPaywall = false

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            let visibleTips = hasAccess ? tips : Array(tips.prefix(freeCount))
            ForEach(Array(visibleTips.enumerated()), id: \.offset) { _, tip in
                HStack(alignment: .top, spacing: 8) {
                    Text("•").foregroundStyle(Theme.ColorToken.accent)
                    Text(tip)
                        .font(Theme.FontToken.inter(12))
                        .foregroundStyle(Theme.ColorToken.textSecondary)
                }
            }

            if !hasAccess && tips.count > freeCount {
                Button {
                    showPaywall = true
                } label: {
                    HStack(spacing: 6) {
                        Text("🔒")
                        Text(String(format: String(localized: "+%lld more tips — unlock"), tips.count - freeCount))
                            .font(Theme.FontToken.inter(11, weight: .medium))
                            .foregroundStyle(Theme.ColorToken.accent)
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .sheet(isPresented: $showPaywall) {
            if let attraction {
                MembershipPlansView(
                    attraction: attraction,
                    onPurchaseComplete: { onUnlock?() }
                )
                .environment(appEnv)
            } else {
                Text(String(localized: "Upgrade to unlock all visitor tips"))
                    .font(Theme.FontToken.playfair(17, weight: .semibold))
                    .padding(Theme.screenPadding)
            }
        }
    }
}
