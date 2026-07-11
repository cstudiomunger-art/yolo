import SwiftUI

struct AboutChinaGoView: View {
    @Environment(AppEnvironment.self) private var appEnv
    @Environment(\.dismiss) private var dismiss

    private var branding: AppBranding { appEnv.contentMode.branding }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(branding.aboutTitle)
                        .font(Theme.FontToken.playfair(24, weight: .bold))
                    Text("Version \(branding.aboutVersion)")
                        .font(Theme.FontToken.inter(12))
                        .foregroundStyle(Theme.ColorToken.textMuted)

                    MarkdownContentView(content: branding.aboutBody, fontSize: 13, lineSpacing: 4)

                    VStack(alignment: .leading, spacing: 8) {
                        aboutRow("Prepare", "City-aware checklists and cultural tips")
                        aboutRow("Plan", "Build and save multi-city itineraries")
                        aboutRow("Guide", "Attraction details and audio tours")
                    }
                    .padding(.top, 8)
                }
                .padding(Theme.screenPadding)
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .sheetDragToDismiss()
    }

    private func aboutRow(_ title: String, _ detail: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(Theme.FontToken.inter(13, weight: .medium))
            Text(detail)
                .font(Theme.FontToken.inter(11))
                .foregroundStyle(Theme.ColorToken.textMuted)
        }
    }
}
