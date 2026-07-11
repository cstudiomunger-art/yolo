import SwiftUI

enum AudioTranscriptResolver {
    static func normalized(_ raw: String?) -> String? {
        let trimmed = raw?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return trimmed.isEmpty ? nil : trimmed
    }

    static func text(for guide: AudioGuide) -> String? {
        normalized(guide.transcript)
    }

    static func text(for track: AudioTrack) -> String? {
        normalized(track.baseGuide?.transcript) ?? normalized(track.guide.transcript)
    }

    static func hasTranscript(_ raw: String?) -> Bool {
        normalized(raw) != nil
    }
}

struct AudioTranscriptButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: "doc.text")
                    .font(.system(size: 11, weight: .medium))
                Text(String(localized: "View narration script"))
                    .font(Theme.FontToken.inter(11, weight: .medium))
            }
            .foregroundStyle(Theme.ColorToken.accent)
        }
        .buttonStyle(.plain)
    }
}

struct AudioTranscriptSheet: View {
    let title: String
    let transcript: String

    var body: some View {
        NavigationStack {
            ScrollView {
                MarkdownContentView(content: transcript)
                    .padding(16)
            }
            .background(Theme.ColorToken.backgroundSubtle)
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
        }
        .presentationDetents([.medium, .large])
    }
}
