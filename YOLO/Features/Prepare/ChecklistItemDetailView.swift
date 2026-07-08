import SwiftUI

struct ChecklistItemDetailView: View {
    @Environment(AppEnvironment.self) private var appEnv
    @Environment(\.dismiss) private var dismiss

    let item: ChecklistItem

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(item.titleEn)
                    .font(Theme.FontToken.playfair(22, weight: .semibold))

                if let why = item.whyImportant, !why.isEmpty {
                    sectionTitle("Why this matters")
                    HTMLContentView(content: why, fontSize: 14, lineSpacing: 4)
                }

                if let how = item.howToComplete, !how.isEmpty {
                    sectionTitle("How to complete")
                    HTMLContentView(content: how, fontSize: 14, foregroundColor: Theme.ColorToken.textSecondary, lineSpacing: 4)
                }

                ForEach(item.externalLinks, id: \.url) { link in
                    if let url = URL(string: link.url) {
                        Link(destination: url) {
                            HStack {
                                Text(link.label)
                                Spacer()
                                Text("→")
                            }
                            .font(Theme.FontToken.inter(13, weight: .medium))
                            .foregroundStyle(Theme.ColorToken.accent)
                        }
                    }
                }

                if let tip = item.culturalTip, !tip.isEmpty {
                    HTMLContentView(content: tip, fontSize: 12, foregroundColor: Theme.ColorToken.textSecondary)
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Theme.ColorToken.backgroundSubtle)
                        .overlay(alignment: .leading) {
                            Rectangle().fill(Color.yellow.opacity(0.6)).frame(width: 3)
                        }
                }

                actionButtons
            }
            .padding(Theme.screenPadding)
            .padding(.bottom, 24)
        }
        .background(Theme.ColorToken.background)
        .navigationBarBackButtonHidden(true)
        .navigationSwipeBackEnabled()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Text("← Prepare")
                        .font(Theme.FontToken.inter(12))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                }
            }
        }
    }

    private func sectionTitle(_ text: String) -> some View {
        Text(text)
            .font(Theme.FontToken.inter(11, weight: .medium))
            .foregroundStyle(Theme.ColorToken.textDisabled)
            .textCase(.uppercase)
    }

    private var actionButtons: some View {
        let status = appEnv.preferences.checklistStatus(for: item.id, type: item.type)
        return VStack(spacing: 10) {
            Button {
                appEnv.preferences.setChecklistStatus(itemId: item.id, type: item.type, status: .done)
                dismiss()
            } label: {
                Text(status == .done ? "Marked as Done" : "Mark as Done")
                    .font(Theme.FontToken.inter(13, weight: .medium))
                    .foregroundStyle(Theme.ColorToken.onSurfaceEmphasis)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Theme.ColorToken.surfaceEmphasis)
            }
            .buttonStyle(.plain)
            .disabled(status == .done)

            Button {
                appEnv.preferences.setChecklistStatus(itemId: item.id, type: item.type, status: .skipped)
                dismiss()
            } label: {
                Text(status == .skipped ? "Skipped" : "Mark as Skipped")
                    .font(Theme.FontToken.inter(13, weight: .medium))
                    .foregroundStyle(Theme.ColorToken.textSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .cardBorderStyle()
            }
            .buttonStyle(.plain)
            .disabled(status == .skipped)
        }
        .padding(.top, 8)
    }
}
