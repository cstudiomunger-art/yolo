import Foundation

struct SupportAgent: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let role: String
    let avatarSeed: String
    let languages: [String]
    let status: String          // "online" | "busy" | "offline"
    let socialUrl: String

    var isReachable: Bool { status == "online" || status == "busy" }
}

struct SupportConversation: Codable, Identifiable, Hashable {
    let id: String
    let userId: String
    let agentId: String?
    let priority: String        // "normal" | "emergency"
    let status: String          // "open" | "closed"
    let userLastReadAt: String?
    let agentLastReadAt: String?
    let userTypingAt: String?
    let agentTypingAt: String?
}

struct SupportMessage: Codable, Identifiable, Hashable {
    let id: String
    let conversationId: String
    let senderType: String      // "user" | "agent"
    let senderId: String?
    let bodyOriginal: String?
    let bodyTranslated: String?
    let imageUrl: String?
    let createdAt: String?

    var isFromUser: Bool { senderType == "user" }
}
