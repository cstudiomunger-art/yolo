import SwiftUI

// MARK: - Guide detail (push navigation)

struct EmergencyGuideDetailView: View {
    let guideId: String
    let guides: [EmergencyGuide]

    private var guide: EmergencyGuide? {
        guides.first { $0.id == guideId }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                if let guide {
                    Text(guide.displayTitle)
                        .font(Theme.FontToken.playfair(22, weight: .semibold))
                    if !guide.displayBodyHTML.isEmpty {
                        HTMLContentView(content: guide.displayBodyHTML, fontSize: 14, lineSpacing: 5)
                    } else {
                        Text("Content is not available offline. Refresh from CMS when online.")
                            .font(Theme.FontToken.inter(13))
                            .foregroundStyle(Theme.ColorToken.textMuted)
                    }
                } else {
                    Text("Guide not found.")
                        .font(Theme.FontToken.inter(13))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(Theme.screenPadding)
        }
        .navigationTitle("Emergency Guide")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Number guide sheet (tutorial before calling)

struct EmergencyNumberPresentation: Identifiable {
    let number: String
    let label: String
    var id: String { number }
}

struct EmergencyNumberGuideSheet: View {
    @Environment(\.dismiss) private var dismiss

    let presentation: EmergencyNumberPresentation
    let guide: EmergencyGuide?
    let fallbackNote: String?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    if let guide {
                        Text(guide.displayTitle)
                            .font(Theme.FontToken.playfair(20, weight: .semibold))
                        HTMLContentView(content: guide.displayBodyHTML, fontSize: 14, lineSpacing: 5)
                    } else if let note = fallbackNote, !note.isEmpty {
                        Text(presentation.label)
                            .font(Theme.FontToken.playfair(20, weight: .semibold))
                        Text(note)
                            .font(Theme.FontToken.inter(13))
                            .foregroundStyle(Theme.ColorToken.textSecondary)
                    } else {
                        Text(presentation.label)
                            .font(Theme.FontToken.playfair(20, weight: .semibold))
                        Text("Nationwide emergency number. Tap below to call.")
                            .font(Theme.FontToken.inter(13))
                            .foregroundStyle(Theme.ColorToken.textSecondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(Theme.screenPadding)
                .padding(.bottom, 80)
            }
            .navigationTitle(presentation.number)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
            .safeAreaInset(edge: .bottom) {
                Link(destination: telURL(presentation.number)) {
                    Text("Call \(presentation.number) now")
                        .font(Theme.FontToken.inter(14, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Theme.ColorToken.warning)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal, Theme.screenPadding)
                .padding(.vertical, 10)
                .background(.ultraThinMaterial)
            }
        }
    }

    private func telURL(_ phone: String) -> URL {
        URL(string: "tel://\(phone.filter { $0.isNumber || $0 == "+" })")!
    }
}
