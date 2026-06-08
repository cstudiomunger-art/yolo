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
    var priceTierId: String?
    var purchaseTargetId: String?
    var displayTitle: String?
    /// Hide the inline unlock CTA when the host screen already provides one (e.g. the
    /// attraction detail page's sticky bottom bar). Sub-area pages have no bar, so default on.
    var showsUnlockButton: Bool = true
    var onUnlock: (() -> Void)?

    @State private var showPaywall = false

    var body: some View {
        if hasAccess {
            HTMLContentView(content: htmlContent)
        } else {
            VStack(alignment: .leading, spacing: 0) {
                // Locked preview: text clipped with a fade-to-background mask at the bottom
                Text(previewText + "…")
                    .font(.system(size: 13, weight: .light))
                    .foregroundStyle(Theme.ColorToken.textSecondary)
                    .lineSpacing(5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(maxHeight: 132, alignment: .top)
                    .clipped()
                    .overlay(alignment: .bottom) {
                        LinearGradient(
                            colors: [Theme.ColorToken.backgroundSubtle.opacity(0), Theme.ColorToken.backgroundSubtle],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: 64)
                        .allowsHitTesting(false)
                    }

                // Paywall CTA
                VStack(alignment: .leading, spacing: 9) {
                    HStack(spacing: 6) {
                        Text("🔒").font(.system(size: 11))
                        Text(String(localized: "Full Guide locked — audio + full article"))
                            .font(Theme.FontToken.inter(11))
                            .foregroundStyle(Theme.ColorToken.textMuted)
                    }

                    if showsUnlockButton {
                        Button {
                            showPaywall = true
                        } label: {
                            Text(String(localized: "Unlock the Guide →"))
                                .font(Theme.FontToken.inter(12, weight: .medium))
                                .tracking(0.8)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 11)
                                .background(Theme.ColorToken.textPrimary)
                        }
                        .buttonStyle(.plain)
                        .fixedSize()
                    }
                }
                .padding(.top, 6)
            }
            .sheet(isPresented: $showPaywall) {
                if let attraction {
                    MembershipPlansView(
                        attraction: attraction,
                        guide: guide,
                        priceTierId: priceTierId,
                        purchaseTargetId: purchaseTargetId,
                        displayTitle: displayTitle,
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
    var priceTierId: String?
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
                    priceTierId: priceTierId,
                    onPurchaseComplete: { onUnlock?() }
                )
                .environment(appEnv)
            }
        }
    }
}
