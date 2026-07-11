import SwiftUI

struct LegalDocumentView: View {
    @Environment(AppEnvironment.self) private var appEnv
    let kind: LegalDocumentKind

    var body: some View {
        ScrollView {
            MarkdownContentView(
                content: kind.resolvedMarkdown(branding: appEnv.contentMode.branding),
                fontSize: 14,
                lineSpacing: 5
            )
            .padding(Theme.screenPadding)
        }
        .background(Theme.ColorToken.background)
        .navigationTitle(kind.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}
