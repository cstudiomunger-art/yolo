import SwiftUI

/// Practical Info hub — one page collecting the trip's must-use entries. The four big
/// features swap the top-level cover (their own self-contained screens); transport and
/// phrases push as content within this stack.
struct InfoHubView: View {
    @Environment(AppEnvironment.self) private var appEnv
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    actionCard("🚨", "Emergency", "Call 110 · embassy by nationality · medical card") { appEnv.navigation.presentEmergency() }
                    actionCard("🛂", "Visa", "Does your route qualify · rules explained") { appEnv.navigation.presentVisaChecker() }
                    actionCard("💳", "Payment", "Card binding / foreign cards / cash tiers") { appEnv.navigation.presentPaymentHelper() }
                    NavigationLink { InternetAccessGuideView() } label: { cardBody("🌐", "Internet access", "Legal options · SIM cards · roaming") }
                        .buttonStyle(.plain)
                    NavigationLink { TransportView() } label: { cardBody("🚄", "Transport", "High-speed rail · taxis · metro") }
                        .buttonStyle(.plain)
                }
                .padding(Theme.screenPadding)
            }
            .navigationTitle("Practical Info")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Close") { dismiss() } } }
        }
    }

    private func actionCard(_ emoji: String, _ title: String, _ sub: String, action: @escaping () -> Void) -> some View {
        Button(action: action) { cardBody(emoji, title, sub) }.buttonStyle(.plain)
    }

    private func cardBody(_ emoji: String, _ title: String, _ sub: String) -> some View {
        HStack(spacing: 14) {
            Text(emoji).font(.system(size: 26)).frame(width: 32)
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(Theme.FontToken.inter(15, weight: .medium))
                Text(sub).font(Theme.FontToken.inter(11)).foregroundStyle(Theme.ColorToken.textMuted)
            }
            Spacer()
            Image(systemName: "chevron.right").foregroundStyle(Theme.ColorToken.textGhost)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Theme.ColorToken.border, lineWidth: 1))
        .contentShape(Rectangle())   // whole row is tappable, not just the icon/text
    }
}
