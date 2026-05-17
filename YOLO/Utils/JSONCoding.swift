import Foundation

/// Shared JSON codec for bundled Static/*.json and Supabase (snake_case columns).
enum JSONCoding {
    static func makeDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }

    static func makeEncoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }

    static func describe(_ error: DecodingError) -> String {
        switch error {
        case .keyNotFound(let key, let context):
            return "缺少字段 \(key.stringValue)（\(context.codingPath.map(\.stringValue).joined(separator: "."))）"
        case .valueNotFound(let type, let context):
            return "字段为空 \(type)（\(context.codingPath.map(\.stringValue).joined(separator: "."))）"
        case .typeMismatch(let type, let context):
            return "类型不匹配 \(type)（\(context.codingPath.map(\.stringValue).joined(separator: "."))）"
        case .dataCorrupted(let context):
            return context.debugDescription
        @unknown default:
            return error.localizedDescription
        }
    }

    static func describe(_ error: Error) -> String {
        if let decoding = error as? DecodingError {
            return describe(decoding)
        }
        return error.localizedDescription
    }
}
