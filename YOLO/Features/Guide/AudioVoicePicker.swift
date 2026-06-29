import SwiftUI

struct AudioVoicePicker: View {
    let variants: [AudioVoiceVariant]
    let selectedVariantId: String?
    let onSelect: (AudioVoiceVariant) -> Void

    private var sortedVariants: [AudioVoiceVariant] {
        variants.sorted {
            if $0.sortOrder != $1.sortOrder { return $0.sortOrder < $1.sortOrder }
            return $0.voiceLabel < $1.voiceLabel
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(String(localized: "Voice"))
                .font(Theme.FontToken.inter(10, weight: .medium))
                .foregroundStyle(Theme.ColorToken.textMuted)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(sortedVariants) { variant in
                        let selected = variant.id == selectedVariantId
                            || (selectedVariantId == nil && variant.isDefault)
                        Button {
                            onSelect(variant)
                        } label: {
                            Text(variant.voiceLabel)
                                .font(Theme.FontToken.inter(11, weight: selected ? .medium : .regular))
                                .foregroundStyle(selected ? Theme.ColorToken.accent : Theme.ColorToken.textMuted)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(
                                            selected ? Theme.ColorToken.accent : Theme.ColorToken.border,
                                            lineWidth: 1
                                        )
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}
