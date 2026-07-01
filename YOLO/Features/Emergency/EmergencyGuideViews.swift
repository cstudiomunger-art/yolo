import SwiftUI

struct EmergencyContentDetailView: View {
    let item: EmergencyContentItem

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text(item.displayTitle)
                    .font(Theme.FontToken.playfair(22, weight: .semibold))
                if !item.displayBodyHTML.isEmpty {
                    HTMLContentView(content: item.displayBodyHTML, fontSize: 14, lineSpacing: 5)
                } else {
                    Text("Content is not available offline. Refresh from CMS when online.")
                        .font(Theme.FontToken.inter(13))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(Theme.screenPadding)
        }
        .navigationTitle(item.displayTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}
