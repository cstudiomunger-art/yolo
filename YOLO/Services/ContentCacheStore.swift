import Foundation

/// Disk cache for remote CMS JSON under Application Support (persists across app relaunch).
actor ContentCacheStore {
    static let shared = ContentCacheStore()

    static let defaultTTL: TimeInterval = 24 * 60 * 60

    private let directory: URL
    private let encoder = JSONCoding.makeEncoder()
    private let decoder = JSONCoding.makeDecoder()

    private struct Envelope<T: Codable>: Codable {
        let savedAt: Date
        let value: T
    }

    struct Entry<T> {
        let value: T
        let isStale: Bool
    }

    private init() {
        directory = OfflineCacheLocations.contentDirectory
    }

    func load<T: Codable>(_ type: T.Type, key: String, ttl: TimeInterval = defaultTTL) -> Entry<T>? {
        let fileURL = fileURL(for: key)
        guard let data = try? Data(contentsOf: fileURL),
              let envelope = try? decoder.decode(Envelope<T>.self, from: data) else {
            return nil
        }
        let age = Date().timeIntervalSince(envelope.savedAt)
        return Entry(value: envelope.value, isStale: age > ttl)
    }

    func save<T: Codable>(_ value: T, key: String) {
        let envelope = Envelope(savedAt: Date(), value: value)
        guard let data = try? encoder.encode(envelope) else { return }
        try? data.write(to: fileURL(for: key), options: .atomic)
    }

    func remove(key: String) {
        try? FileManager.default.removeItem(at: fileURL(for: key))
    }

    func removeByPrefix(_ prefix: String) {
        guard let contents = try? FileManager.default.contentsOfDirectory(
            at: directory, includingPropertiesForKeys: nil
        ) else { return }
        let safe = prefix.lowercased().replacingOccurrences(of: "/", with: "_").replacingOccurrences(of: " ", with: "_")
        for url in contents where url.lastPathComponent.hasPrefix(safe) {
            try? FileManager.default.removeItem(at: url)
        }
    }

    func removeAll() {
        guard let contents = try? FileManager.default.contentsOfDirectory(
            at: directory,
            includingPropertiesForKeys: nil
        ) else { return }
        for url in contents {
            try? FileManager.default.removeItem(at: url)
        }
    }

    func directorySizeBytes() -> Int {
        directoryByteCount(directory)
    }

    private func fileURL(for key: String) -> URL {
        let safe = key
            .lowercased()
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: " ", with: "_")
        return directory.appendingPathComponent("\(safe).json")
    }

    private func directoryByteCount(_ url: URL) -> Int {
        guard let contents = try? FileManager.default.contentsOfDirectory(
            at: url,
            includingPropertiesForKeys: [.fileSizeKey, .isDirectoryKey]
        ) else { return 0 }
        var total = 0
        for item in contents {
            let values = try? item.resourceValues(forKeys: [.fileSizeKey, .isDirectoryKey])
            if values?.isDirectory == true {
                total += directoryByteCount(item)
            } else {
                total += values?.fileSize ?? 0
            }
        }
        return total
    }
}

enum ContentCacheKey {
    static func cities() -> String { "cities" }
    static func cultureTips(cityIds: [String]) -> String { "culture_tips_\(filterHash(cityIds: cityIds))" }
    static func attractions(cityId: String) -> String { "attractions_\(cityId.lowercased())" }
    static func cityGuides(cityId: String) -> String { "city_guides_\(cityId.lowercased())" }
    static func cityGuide(id: String) -> String { "city_guide_\(id.lowercased())" }
    static func attraction(id: String) -> String { "attraction_\(id.lowercased())" }
    static func audioGuides(attractionId: String) -> String { "audio_guides_\(attractionId.lowercased())" }
    static func audioGuide(id: String) -> String { "audio_guide_\(id.lowercased())" }
    static func voiceVariants(ownerType: AudioVoiceOwnerType, ownerId: String) -> String {
        "voice_variants_\(ownerType.rawValue)_\(ownerId.lowercased())"
    }
    static func subAreas(attractionId: String) -> String { "sub_areas_\(attractionId.lowercased())" }
    static func checklist(cityIds: [String], countryCode: String) -> String {
        "checklist_\(filterHash(cityIds: cityIds, countryCode: countryCode))"
    }
    static func shopping(cityIds: [String]) -> String { "shopping_\(filterHash(cityIds: cityIds))" }
    static func reading(cityIds: [String]) -> String { "reading_\(filterHash(cityIds: cityIds))" }
    static func hotels(cityId: String) -> String { "hotels_\(cityId.lowercased())" }
    static func cityHospitals(cityId: String) -> String { "city_hospitals_\(cityId.lowercased())" }
    static func cityEmbassies(cityId: String) -> String { "city_embassies_\(cityId.lowercased())" }
    static func homeTips(cityIds: [String]) -> String { "home_tips_\(filterHash(cityIds: cityIds))" }
    static func passportCountries() -> String { "passport_countries" }
    static func emergencyData() -> String { "emergency_data" }
    static func emergencyHelpItems() -> String { "emergency_help_items" }
    static func emergencyMedicalItems() -> String { "emergency_medical_items" }
    static func sampleItinerary() -> String { "sample_itinerary" }
    static func planningItinerary() -> String { "planning_itinerary" }
    static func appBranding() -> String { "app_branding" }

    private static func filterHash(cityIds: [String], countryCode: String = "") -> String {
        let cities = cityIds.map { $0.lowercased().trimmingCharacters(in: .whitespaces) }.sorted().joined(separator: ",")
        let country = countryCode.lowercased().trimmingCharacters(in: .whitespaces)
        return "\(cities)|\(country)"
    }
}
