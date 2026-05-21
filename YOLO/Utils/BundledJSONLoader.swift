import Foundation

enum BundledJSONLoader {
    static func load<T: Decodable>(_ type: T.Type, resource: String, subdirectory: String = "Static") -> T {
        guard let url = resolveURL(resource: resource, subdirectory: subdirectory) else {
            fatalError("Missing bundled resource: \(resource).json (tried Static/, Resources/Static/, bundle root)")
        }
        do {
            let data = try Data(contentsOf: url)
            return try JSONCoding.makeDecoder().decode(T.self, from: data)
        } catch {
            fatalError("Failed to decode \(resource).json: \(JSONCoding.describe(error))")
        }
    }

    private static func resolveURL(resource: String, subdirectory: String) -> URL? {
        let candidates = [subdirectory, "Resources/\(subdirectory)", nil as String?]
        for sub in candidates {
            if let sub {
                if let url = Bundle.main.url(forResource: resource, withExtension: "json", subdirectory: sub) {
                    return url
                }
            } else if let url = Bundle.main.url(forResource: resource, withExtension: "json") {
                return url
            }
        }
        return nil
    }

    static func loadOptional<T: Decodable>(_ type: T.Type, resource: String, subdirectory: String = "Static") -> T? {
        guard let url = resolveURL(resource: resource, subdirectory: subdirectory) else {
            return nil
        }
        guard let data = try? Data(contentsOf: url) else { return nil }
        return try? JSONCoding.makeDecoder().decode(T.self, from: data)
    }
}
