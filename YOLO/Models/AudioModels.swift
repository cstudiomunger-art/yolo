import Foundation

struct AudioGuide: Identifiable, Codable {
    let id: String
    let attractionId: String
    let titleEn: String
    let description: String?
    let durationSeconds: Int
    let audioUrl: String
    let quote: String?
    let transcript: String?
    let segments: [AudioSegment]
    let isMainGuide: Bool

    init(
        id: String,
        attractionId: String,
        titleEn: String,
        description: String? = nil,
        durationSeconds: Int = 0,
        audioUrl: String,
        quote: String? = nil,
        transcript: String? = nil,
        segments: [AudioSegment] = [],
        isMainGuide: Bool = false
    ) {
        self.id = id
        self.attractionId = attractionId
        self.titleEn = titleEn
        self.description = description
        self.durationSeconds = durationSeconds
        self.audioUrl = audioUrl
        self.quote = quote
        self.transcript = transcript
        self.segments = segments
        self.isMainGuide = isMainGuide
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(String.self, forKey: .id)
        attractionId = try c.decode(String.self, forKey: .attractionId)
        titleEn = try c.decode(String.self, forKey: .titleEn)
        description = try c.decodeIfPresent(String.self, forKey: .description)
        durationSeconds = try c.decodeIfPresent(Int.self, forKey: .durationSeconds) ?? 0
        audioUrl = try c.decodeIfPresent(String.self, forKey: .audioUrl) ?? ""
        quote = try c.decodeIfPresent(String.self, forKey: .quote)
        transcript = try c.decodeIfPresent(String.self, forKey: .transcript)
        segments = (try? c.decode([AudioSegment].self, forKey: .segments)) ?? []
        isMainGuide = try c.decodeIfPresent(Bool.self, forKey: .isMainGuide) ?? false
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(attractionId, forKey: .attractionId)
        try c.encode(titleEn, forKey: .titleEn)
        try c.encodeIfPresent(description, forKey: .description)
        try c.encode(durationSeconds, forKey: .durationSeconds)
        try c.encode(audioUrl, forKey: .audioUrl)
        try c.encodeIfPresent(quote, forKey: .quote)
        try c.encodeIfPresent(transcript, forKey: .transcript)
        try c.encode(segments, forKey: .segments)
        try c.encode(isMainGuide, forKey: .isMainGuide)
    }

    private enum CodingKeys: String, CodingKey {
        case id, attractionId, titleEn, description, durationSeconds, audioUrl, quote, transcript, segments, isMainGuide
    }
}

struct AudioSegment: Identifiable, Hashable, Codable {
    let id: String
    let title: String
    let startSeconds: Int

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        title = try c.decodeIfPresent(String.self, forKey: .title) ?? ""
        startSeconds = try c.decodeIfPresent(Int.self, forKey: .startSeconds) ?? 0
        id = try c.decodeIfPresent(String.self, forKey: .id) ?? "\(title)-\(startSeconds)"
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(title, forKey: .title)
        try c.encode(startSeconds, forKey: .startSeconds)
    }

    private enum CodingKeys: String, CodingKey {
        case id, title, startSeconds
    }
}