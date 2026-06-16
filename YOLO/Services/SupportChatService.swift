import Foundation
import Observation
import Supabase

/// Genius Bar live support. Agents + conversations + messages over Supabase. Messages
/// refresh via a short polling loop while a chat is open (the tables are in the
/// `supabase_realtime` publication, so this can be swapped for Realtime later).
/// User messages are translated to the agent's language via the chat-translate EF.
@Observable
@MainActor
final class SupportChatService {

    private(set) var agents: [SupportAgent] = []
    private(set) var messages: [SupportMessage] = []
    private(set) var conversation: SupportConversation?
    private(set) var isSending = false
    var lastError: String?

    @ObservationIgnored private var pollTask: Task<Void, Never>?

    private var client: SupabaseClient { SupabaseManager.shared }

    // MARK: - Agents

    func loadAgents() async {
        guard AppConfig.isSupabaseConfigured else { agents = []; return }
        do {
            agents = try await client.from("support_agents")
                .select()
                .eq("is_active", value: true)
                .order("display_order")
                .execute().value
        } catch {
            lastError = error.localizedDescription
        }
    }

    // MARK: - Conversation lifecycle

    /// The user's own open conversations (one per agent) — drives the "我的会话" inbox.
    private(set) var myConversations: [SupportConversation] = []

    private struct NewConversation: Encodable {
        let user_id: String
        let agent_id: String?
        let priority: String
        let context_json: AnyJSON?
    }

    func loadMyConversations(userId: UUID) async {
        guard AppConfig.isSupabaseConfigured else { return }
        do {
            myConversations = try await client.from("support_conversations")
                .select()
                .eq("user_id", value: userId.uuidString.lowercased())
                .eq("status", value: "open")
                .order("updated_at", ascending: false)
                .execute().value
        } catch {
            lastError = error.localizedDescription
        }
    }

    /// Resume an existing conversation (from the inbox).
    func openConversation(_ conv: SupportConversation) async {
        conversation = conv
        await loadMessages()
        startPolling()
    }

    /// Start or resume a conversation. One user ↔ one agent = one open thread; tapping
    /// the same agent again resumes it instead of duplicating. SOS always opens fresh.
    /// The user's name/email are stashed in context_json so the agent console shows who it is.
    func startConversation(
        userId: UUID, agentId: String?, priority: String = "normal",
        context: [String: String]? = nil, displayName: String? = nil, email: String? = nil
    ) async {
        let uid = userId.uuidString.lowercased()

        if let agentId, priority == "normal" {
            let existing: [SupportConversation] = (try? await client.from("support_conversations")
                .select().eq("user_id", value: uid).eq("agent_id", value: agentId)
                .eq("status", value: "open").order("updated_at", ascending: false).limit(1)
                .execute().value) ?? []
            if let conv = existing.first { await openConversation(conv); return }
        }

        var merged = context ?? [:]
        if let displayName, !displayName.isEmpty { merged["user_name"] = displayName }
        if let email, !email.isEmpty { merged["user_email"] = email }
        let ctx: AnyJSON? = merged.isEmpty ? nil : (try? AnyJSON(merged))

        let payload = NewConversation(user_id: uid, agent_id: agentId, priority: priority, context_json: ctx)
        do {
            let row: SupportConversation = try await client.from("support_conversations")
                .insert(payload).select().single().execute().value
            conversation = row
            await loadMessages()
            startPolling()
        } catch {
            lastError = error.localizedDescription
        }
    }

    func loadMessages() async {
        guard let convId = conversation?.id else { return }
        do {
            messages = try await client.from("support_messages")
                .select()
                .eq("conversation_id", value: convId)
                .order("created_at")
                .execute().value
        } catch {
            lastError = error.localizedDescription
        }
    }

    // MARK: - Sending

    private struct NewMessage: Encodable {
        let conversation_id: String
        let sender_type: String
        let sender_id: String?
        let body_original: String?
        let body_translated: String?
        let image_url: String?
    }

    func sendText(_ text: String, userId: UUID) async {
        guard let convId = conversation?.id, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        isSending = true
        defer { isSending = false }
        let translated = await translate(text, target: "zh")  // agent reads Chinese
        let msg = NewMessage(
            conversation_id: convId, sender_type: "user", sender_id: userId.uuidString.lowercased(),
            body_original: text, body_translated: translated, image_url: nil
        )
        await insert(msg)
    }

    func sendImage(_ data: Data, userId: UUID) async {
        guard let convId = conversation?.id else { return }
        isSending = true
        defer { isSending = false }
        let path = "\(convId)/\(UUID().uuidString).jpg"
        do {
            _ = try await client.storage.from("chat-images")
                .upload(path, data: data, options: FileOptions(contentType: "image/jpeg", upsert: false))
            let msg = NewMessage(
                conversation_id: convId, sender_type: "user", sender_id: userId.uuidString.lowercased(),
                body_original: nil, body_translated: nil, image_url: path
            )
            await insert(msg)
        } catch {
            lastError = error.localizedDescription
        }
    }

    private func insert(_ msg: NewMessage) async {
        do {
            _ = try await client.from("support_messages").insert(msg).execute()
            await loadMessages()
        } catch {
            lastError = error.localizedDescription
        }
    }

    /// Resolve a signed URL for a stored chat image path (private bucket).
    func signedImageURL(for path: String) async -> URL? {
        try? await client.storage.from("chat-images").createSignedURL(path: path, expiresIn: 3600)
    }

    // MARK: - Translation (chat-translate Edge Function)

    private struct TranslateResult: Decodable { let translated: String? }

    private func translate(_ text: String, target: String) async -> String? {
        do {
            let result: TranslateResult = try await client.functions.invoke(
                "chat-translate",
                options: FunctionInvokeOptions(body: ["text": text, "target_lang": target])
            )
            return result.translated
        } catch {
            return nil  // translation is best-effort; chat still flows
        }
    }

    // MARK: - Polling

    private func startPolling() {
        pollTask?.cancel()
        pollTask = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 3_000_000_000)
                if Task.isCancelled { break }
                await self?.loadMessages()
            }
        }
    }

    func stopPolling() {
        pollTask?.cancel()
        pollTask = nil
    }
}
