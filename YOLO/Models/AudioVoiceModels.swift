import Foundation

enum AudioVoiceOwnerType: String, Codable, Sendable {
    case audioGuide = "audio_guide"
    case subArea = "sub_area"
    case cityGuide = "city_guide"
}

struct AudioVoiceOwner: Hashable, Sendable {
    let type: AudioVoiceOwnerType
    let id: String

    var preferenceKey: String { "\(type.rawValue):\(id)" }
}

struct AudioVoiceVariant: Identifiable, Codable, Sendable {
    let id: String
    let ownerType: AudioVoiceOwnerType
    let ownerId: String
    let voiceLabel: String
    let audioUrl: String
    let durationSeconds: Int
    let segments: [AudioSegment]
    let sortOrder: Int
    let isDefault: Bool

    init(
        id: String,
        ownerType: AudioVoiceOwnerType,
        ownerId: String,
        voiceLabel: String,
        audioUrl: String = "",
        durationSeconds: Int = 0,
        segments: [AudioSegment] = [],
        sortOrder: Int = 0,
        isDefault: Bool = false
    ) {
        self.id = id
        self.ownerType = ownerType
        self.ownerId = ownerId
        self.voiceLabel = voiceLabel
        self.audioUrl = audioUrl
        self.durationSeconds = durationSeconds
        self.segments = segments
        self.sortOrder = sortOrder
        self.isDefault = isDefault
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(String.self, forKey: .id)
        ownerType = try c.decode(AudioVoiceOwnerType.self, forKey: .ownerType)
        ownerId = try c.decode(String.self, forKey: .ownerId)
        voiceLabel = try c.decode(String.self, forKey: .voiceLabel)
        audioUrl = try c.decodeIfPresent(String.self, forKey: .audioUrl) ?? ""
        durationSeconds = try c.decodeIfPresent(Int.self, forKey: .durationSeconds) ?? 0
        segments = (try? c.decode([AudioSegment].self, forKey: .segments)) ?? []
        sortOrder = try c.decodeIfPresent(Int.self, forKey: .sortOrder) ?? 0
        isDefault = try c.decodeIfPresent(Bool.self, forKey: .isDefault) ?? false
    }

    private enum CodingKeys: String, CodingKey {
        case id, ownerType, ownerId, voiceLabel, audioUrl, durationSeconds, segments, sortOrder, isDefault
    }
}

enum AudioVoicePlaybackSupport {
    static func loadVariants(
        owner: AudioVoiceOwner,
        content: ContentRepositoryProtocol
    ) async -> [AudioVoiceVariant] {
        (try? await content.fetchVoiceVariants(ownerType: owner.type, ownerId: owner.id)) ?? []
    }

    static func resolveGuide(
        base: AudioGuide,
        owner: AudioVoiceOwner,
        variants: [AudioVoiceVariant],
        preferences: UserPreferencesStore
    ) -> AudioGuide {
        AudioPlaybackResolver.resolve(
            baseGuide: base,
            variants: variants,
            preferredVariantId: preferences.preferredVoiceVariantId(for: owner)
        )
    }

    static func resolveGuide(
        base: AudioGuide,
        owner: AudioVoiceOwner,
        content: ContentRepositoryProtocol,
        preferences: UserPreferencesStore
    ) async -> AudioGuide {
        let variants = await loadVariants(owner: owner, content: content)
        return resolveGuide(base: base, owner: owner, variants: variants, preferences: preferences)
    }
}

enum AudioPlaybackResolver {
    static func trackId(parentId: String, variantId: String) -> String {
        "\(parentId)__\(variantId)"
    }

    static func selectedVariant(
        from variants: [AudioVoiceVariant],
        preferredVariantId: String?
    ) -> AudioVoiceVariant? {
        let active = variants.filter { !$0.audioUrl.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        guard !active.isEmpty else { return nil }
        if let preferredVariantId,
           let match = active.first(where: { $0.id == preferredVariantId }) {
            return match
        }
        if let def = active.first(where: \.isDefault) { return def }
        return active.sorted { $0.sortOrder < $1.sortOrder }.first
    }

    static func resolve(
        baseGuide: AudioGuide,
        variants: [AudioVoiceVariant],
        preferredVariantId: String?
    ) -> AudioGuide {
        guard let variant = selectedVariant(from: variants, preferredVariantId: preferredVariantId) else {
            return baseGuide
        }
        return guide(from: baseGuide, variant: variant)
    }

    static func guide(from baseGuide: AudioGuide, variant: AudioVoiceVariant) -> AudioGuide {
        AudioGuide(
            id: trackId(parentId: baseGuide.id, variantId: variant.id),
            attractionId: baseGuide.attractionId,
            titleEn: baseGuide.titleEn,
            description: baseGuide.description,
            durationSeconds: variant.durationSeconds > 0 ? variant.durationSeconds : baseGuide.durationSeconds,
            audioUrl: variant.audioUrl,
            quote: baseGuide.quote,
            segments: variant.segments.isEmpty ? baseGuide.segments : variant.segments,
            isMainGuide: baseGuide.isMainGuide
        )
    }

    /// Extracts the voice-variant id from a composite guide id (`baseId__variantId`).
    static func variantId(from compositeGuideId: String, baseGuideId: String) -> String? {
        let prefix = baseGuideId + "__"
        guard compositeGuideId.hasPrefix(prefix) else { return nil }
        let variantId = String(compositeGuideId.dropFirst(prefix.count))
        return variantId.isEmpty ? nil : variantId
    }

    /// Whether `track` is the same logical audio as the inline section (`baseGuideId` + optional `voiceOwner`).
    static func trackMatchesSection(
        track: AudioTrack,
        baseGuideId: String,
        voiceOwner: AudioVoiceOwner?
    ) -> Bool {
        if let voiceOwner {
            guard track.voiceOwner == voiceOwner, track.baseGuide?.id == baseGuideId else { return false }
            return true
        }
        if track.baseGuide?.id == baseGuideId { return true }
        return track.guide.id == baseGuideId
    }
}

