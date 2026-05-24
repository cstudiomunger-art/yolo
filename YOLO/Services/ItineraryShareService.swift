import Foundation

enum ItineraryShareService {
    static func makeSlug() -> String {
        String(UUID().uuidString.replacingOccurrences(of: "-", with: "").prefix(10)).lowercased()
    }

    static func shareURL(slug: String, branding: AppBranding) -> URL? {
        let base = branding.shareWebBaseURL.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        guard !base.isEmpty else { return nil }
        return URL(string: "\(base)/i/\(slug)")
    }

    static func shareText(itinerary: SampleItinerary, url: URL?) -> String {
        var lines = ["🇨🇳 \(itinerary.title)", "──────────────────"]
        for day in itinerary.days {
            lines.append(day.dateLabel)
            for act in day.activities {
                lines.append("  • \(act.name)")
            }
        }
        lines.append("──────────────────")
        if let url {
            lines.append(url.absoluteString)
        }
        lines.append(String(localized: "Made with YOLO HAPPY app"))
        return lines.joined(separator: "\n")
    }

    /// Parses `/i/{slug}` from universal links or custom scheme URLs.
    static func parseShareSlug(from url: URL) -> String? {
        if url.scheme?.lowercased() == "yoloapp", url.host == "trip" {
            let slug = url.path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            return slug.isEmpty ? nil : slug
        }
        let parts = url.path.split(separator: "/").map(String.init)
        guard parts.count >= 2, parts[parts.count - 2] == "i" else { return nil }
        let slug = parts.last ?? ""
        return slug.isEmpty ? nil : slug
    }
}
