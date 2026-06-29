import SwiftUI

/// Compact voice selector: a single pill button that opens a menu of narration variants.
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

    private var resolvedSelectionId: String? {
        selectedVariantId ?? AudioPlaybackResolver.selectedVariant(
            from: variants,
            preferredVariantId: selectedVariantId
        )?.id
    }

    private var selectedLabel: String {
        sortedVariants.first(where: { $0.id == resolvedSelectionId })?.voiceLabel
            ?? sortedVariants.first?.voiceLabel
            ?? String(localized: "Voice")
    }

    var body: some View {
        Menu {
            ForEach(sortedVariants) { variant in
                let selected = variant.id == resolvedSelectionId
                Button {
                    onSelect(variant)
                } label: {
                    if selected {
                        Label(variant.voiceLabel, systemImage: "checkmark")
                    } else {
                        Text(variant.voiceLabel)
                    }
                }
            }
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "waveform")
                    .font(.system(size: 9, weight: .medium))
                Text(selectedLabel)
                    .lineLimit(1)
                Image(systemName: "chevron.down")
                    .font(.system(size: 8, weight: .semibold))
            }
            .font(Theme.FontToken.inter(11, weight: .medium))
            .foregroundStyle(Theme.ColorToken.accent)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Theme.ColorToken.accent.opacity(0.6), lineWidth: 1)
            )
        }
        .menuStyle(.borderlessButton)
        .fixedSize()
    }
}

/// Loads voice variants for a queue track and renders `AudioVoicePicker` when multiple exist.
struct AudioTrackVoiceSwitcher: View {
    @Environment(AppEnvironment.self) private var appEnv

    let track: AudioTrack
    let onSelect: (AudioVoiceVariant) -> Void

    @State private var variants: [AudioVoiceVariant] = []

    private var selectedVariantId: String? {
        guard let base = track.baseGuide else { return nil }
        let composite = track.guide.id
        let marker = "__"
        if let range = composite.range(of: marker),
           composite.hasPrefix(base.id + marker) {
            return String(composite[range.upperBound...])
        }
        if let owner = track.voiceOwner {
            return appEnv.preferences.preferredVoiceVariantId(for: owner)
        }
        return nil
    }

    var body: some View {
        Group {
            if variants.count > 1 {
                AudioVoicePicker(
                    variants: variants,
                    selectedVariantId: selectedVariantId
                ) { variant in
                    if let owner = track.voiceOwner {
                        appEnv.preferences.setPreferredVoiceVariantId(variant.id, for: owner)
                    }
                    onSelect(variant)
                }
            }
        }
        .task(id: track.voiceOwner?.preferenceKey) {
            guard let owner = track.voiceOwner else {
                variants = []
                return
            }
            variants = await AudioVoicePlaybackSupport.loadVariants(
                owner: owner,
                content: appEnv.content
            )
        }
    }
}
