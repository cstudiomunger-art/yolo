import SwiftUI

/// Shows a truncated preview of HTML content followed by a paywall CTA.
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
            VStack(alignment: .leading, spacing: 0) {
                // Preview: show truncated plain text clearly, no masking
                if !previewText.isEmpty {
                    Text(previewText + "…")
                        .font(.system(size: 13))
                        .foregroundStyle(Theme.ColorToken.textSecondary)
                        .lineSpacing(4)
                        .padding(.bottom, 12)
                }

                // Paywall CTA
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 6) {
                        Text("🔒")
                        Text(String(localized: "Full content locked"))
                            .font(Theme.FontToken.inter(12))
                            .foregroundStyle(Theme.ColorToken.textMuted)
                    }

                    Button {
                        showPaywall = true
                    } label: {
                        Text(String(localized: "Unlock Full Content →"))
                            .font(Theme.FontToken.inter(12, weight: .medium))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(Theme.ColorToken.accent)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.top, 4)
            }
            .sheet(isPresented: $showPaywall) {
                if let attraction {
                    MembershipPlansView(
                        attraction: attraction,
                        guide: guide,
                        onPurchaseComplete: { onUnlock?() }
                    )
                    .environment(appEnv)
                }
            }
        }
    }

    private var previewText: String {
        let plain = HTMLContentView.plainText(from: htmlContent)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        guard !plain.isEmpty else { return "" }
        let limit = max(freeChars, 80)  // 最少展示 80 字符，避免过短
        guard plain.count > limit else { return plain }
        // 在单词边界截断，避免截断中间
        var end = plain.index(plain.startIndex, offsetBy: limit)
        if let spaceIdx = plain[end...].firstIndex(of: " ") ?? plain[end...].firstIndex(of: "\n") {
            end = spaceIdx
        }
        return String(plain[..<end])
    }
}

/// Shows visitor tips with a paywall after `freeCount` items.
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
            let visibleTips = hasAccess ? tips : Array(tips.prefix(max(freeCount, 1)))
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
                .padding(.top, 2)
            } else if !hasAccess && tips.isEmpty {
                Button {
                    showPaywall = true
                } label: {
                    HStack(spacing: 6) {
                        Text("🔒")
                        Text(String(localized: "Unlock visitor tips →"))
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
            }
        }
    }
}
