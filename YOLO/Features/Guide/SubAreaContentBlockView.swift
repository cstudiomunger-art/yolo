import SwiftUI

struct SubAreaContentBlockView: View {
    let block: SubAreaContentBlock
    var onImageTap: ((String) -> Void)?

    var body: some View {
        switch block.blockType {
        case "heading":
            if let title = block.title, !title.isEmpty {
                Text(title)
                    .font(Theme.FontToken.playfair(16, weight: .semibold))
                    .foregroundStyle(Theme.ColorToken.textPrimary)
                    .padding(.top, 8)
            }
        case "image":
            imageBlock
        default:
            if let body = block.body, !body.isEmpty {
                HTMLContentView(content: body, lineSpacing: 6)
                    .padding(.bottom, 4)
            } else if let title = block.title, !title.isEmpty {
                Text(title)
                    .font(Theme.FontToken.inter(14))
                    .foregroundStyle(Theme.ColorToken.textSecondary)
                    .lineSpacing(6)
            }
        }
    }

    @ViewBuilder
    private var imageBlock: some View {
        let path = block.imagePath ?? block.body ?? ""
        if !path.isEmpty {
            Button {
                onImageTap?(path)
            } label: {
                CoverImageView(path: path, height: 200, cornerRadius: 8)
            }
            .buttonStyle(.plain)
            if let caption = block.title, !caption.isEmpty {
                Text(caption)
                    .font(Theme.FontToken.inter(12))
                    .foregroundStyle(Theme.ColorToken.textMuted)
                    .padding(.top, 4)
            }
        }
    }
}

struct SubAreaRowView: View {
    let area: SubArea
    let audioGuide: AudioGuide?
    let hasAccess: Bool

    var body: some View {
        HStack(spacing: 12) {
                if let path = area.coverImagePath {
                    CoverImageView(path: path, height: 48, cornerRadius: 4)
                        .frame(width: 48, height: 48)
                        .clipped()
                } else {
                    Rectangle()
                        .fill(Theme.ColorToken.backgroundSubtle)
                        .frame(width: 48, height: 48)
                }
                Text(area.nameEn)
                    .font(Theme.FontToken.inter(14))
                    .foregroundStyle(Theme.ColorToken.textPrimary)
                Spacer()
                if let guide = audioGuide {
                    Text("\(max(guide.durationSeconds / 60, 1)) min")
                        .font(Theme.FontToken.inter(11))
                        .foregroundStyle(Theme.ColorToken.textMuted)
                }
                Text(hasAccess ? "🎧" : "🔒")
                    .font(Theme.FontToken.inter(12))
            }
            .padding(.vertical, 10)
        .overlay(alignment: .bottom) {
            Rectangle().fill(Theme.ColorToken.borderLight).frame(height: 1)
        }
    }
}
