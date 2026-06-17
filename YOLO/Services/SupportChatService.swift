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
    private(set) var unreadByConversation: [String: Int] = [:]
    private(set) var agentIsTyping = false
    /// Message ids currently being translated (drives the "翻译中…" indicator).
    private(set) var translatingIds: Set<String> = []
    /// Auto-translate received (incoming, agent-sent) messages for this user. Default off.
    var autoTranslate: Bool {
        didSet { UserDefaults.standard.set(autoTranslate, forKey: Self.autoTranslateKey) }
    }
    var lastError: String?

    private static let autoTranslateKey = "yolohappy.supportAutoTranslate.v1"

    init() {
        autoTranslate = UserDefaults.standard.bool(forKey: Self.autoTranslateKey)
    }

    var totalUnread: Int { unreadByConversation.values.reduce(0, +) }

    @ObservationIgnored private var pollTask: Task<Void, Never>?

    private var client: SupabaseClient { SupabaseManager.shared }

    // MARK: - Agents

    func loadAgents() async {
        guard AppConfig.isSupabaseConfigured else { agents = []; return }
        do {
            let fetched: [SupportAgent] = try await client.from("support_agents")
                .select()
                .eq("is_active", value: true)
                .order("display_order")
                .execute().value
            if fetched != agents { agents = fetched }
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

    /// Active (open) conversations — the inbox top section, with unread/typing.
    var activeConversations: [SupportConversation] { myConversations.filter { !$0.isClosed } }
    /// History (closed) conversations — read-only transcripts.
    var historyConversations: [SupportConversation] { myConversations.filter { $0.isClosed } }

    func loadMyConversations(userId: UUID) async {
        guard AppConfig.isSupabaseConfigured else { return }
        do {
            let fetched: [SupportConversation] = try await client.from("support_conversations")
                .select()
                .eq("user_id", value: userId.uuidString.lowercased())
                .in("status", values: ["open", "closed"])
                .is("user_deleted_at", value: nil)
                .order("updated_at", ascending: false)
                .execute().value
            if fetched != myConversations { myConversations = fetched }
            await recomputeUnread()
        } catch {
            lastError = error.localizedDescription
        }
    }

    /// User ends the active conversation (→ history, ticket closed).
    func endConversation() async {
        guard let id = conversation?.id else { return }
        do {
            _ = try await client.from("support_conversations")
                .update(["status": "closed"]).eq("id", value: id).execute()
            if let c = conversation {
                conversation = SupportConversation(
                    id: c.id, userId: c.userId, agentId: c.agentId, priority: c.priority, status: "closed",
                    userLastReadAt: c.userLastReadAt, agentLastReadAt: c.agentLastReadAt,
                    userTypingAt: c.userTypingAt, agentTypingAt: c.agentTypingAt,
                    userDeletedAt: c.userDeletedAt, agentDeletedAt: c.agentDeletedAt
                )
            }
            stopPolling()
        } catch {
            lastError = error.localizedDescription
        }
    }

    /// Soft-delete a conversation from the user's side only (agent/admin retain it).
    func deleteMyConversation(_ id: String) async {
        do {
            _ = try await client.from("support_conversations")
                .update(["user_deleted_at": ChatDate.now()]).eq("id", value: id).execute()
            myConversations.removeAll { $0.id == id }
            unreadByConversation[id] = nil
        } catch {
            lastError = error.localizedDescription
        }
    }

    /// Unread = agent messages newer than the user's last-read marker, per conversation.
    private func recomputeUnread() async {
        let ids = myConversations.map(\.id)
        guard !ids.isEmpty else { unreadByConversation = [:]; return }
        let msgs: [SupportMessage] = (try? await client.from("support_messages")
            .select().in("conversation_id", values: ids)
            .order("created_at", ascending: false).limit(300).execute().value) ?? []
        var counts: [String: Int] = [:]
        for conv in myConversations {
            let readAt = ChatDate.parse(conv.userLastReadAt)
            counts[conv.id] = msgs.filter {
                $0.conversationId == conv.id && $0.senderType == "agent" && ChatDate.newer($0.createdAt, than: readAt)
            }.count
        }
        if counts != unreadByConversation { unreadByConversation = counts }
    }

    func unread(for conversationId: String) -> Int { unreadByConversation[conversationId] ?? 0 }

    /// Resume an existing conversation (from the inbox); marks it read.
    func openConversation(_ conv: SupportConversation, userId: UUID? = nil) async {
        conversation = conv
        agentIsTyping = false
        await loadMessages()
        await markRead(conv.id)
        startPolling()
        subscribeRealtime()
    }

    @ObservationIgnored private var lastReadWrite: [String: Date] = [:]

    /// Mark the active conversation read by the user (clears its unread badge).
    /// The DB write is throttled (~10s): the 15s poll + every incoming message would
    /// otherwise write `user_last_read_at` constantly, and each write echoes back through
    /// realtime (conversation UPDATE + home inbox reload) as pure main-thread churn.
    func markRead(_ convId: String) async {
        if unreadByConversation[convId] != 0 { unreadByConversation[convId] = 0 }
        if Date().timeIntervalSince(lastReadWrite[convId] ?? .distantPast) < 10 { return }
        lastReadWrite[convId] = Date()
        _ = try? await client.from("support_conversations")
            .update(["user_last_read_at": ChatDate.now()]).eq("id", value: convId).execute()
    }

    // MARK: - Typing

    @ObservationIgnored private var lastTypingPush = Date.distantPast

    /// Throttled (~3s) update of the user's typing marker on the active conversation.
    func userIsTyping() async {
        guard let id = conversation?.id, Date().timeIntervalSince(lastTypingPush) > 3 else { return }
        lastTypingPush = Date()
        _ = try? await client.from("support_conversations")
            .update(["user_typing_at": ChatDate.now()]).eq("id", value: id).execute()
    }

    // MARK: - Device push token

    private struct DeviceTokenRow: Encodable { let user_id: String; let token: String; let platform: String }

    func registerDeviceToken(_ token: String, userId: UUID) async {
        _ = try? await client.from("device_tokens")
            .upsert(DeviceTokenRow(user_id: userId.uuidString.lowercased(), token: token, platform: "ios"))
            .execute()
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
            subscribeRealtime()
        } catch {
            lastError = error.localizedDescription
        }
    }

    func loadMessages() async {
        guard let convId = conversation?.id else { return }
        do {
            let fetched: [SupportMessage] = try await client.from("support_messages")
                .select()
                .eq("conversation_id", value: convId)
                .order("created_at")
                .limit(200)
                .execute().value
            // Only publish when something actually changed — the 15s poll and the
            // realtime UPDATE echoes (e.g. our own markRead / translate writes) otherwise
            // reassign an identical array and force a full list re-render every time.
            if fetched != messages { messages = fetched }
            // No bulk translate here — the chat view auto-translates each incoming
            // message only when it scrolls into view (visible range), via translateMessage.
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
        // Send instantly with original only — translation happens on the receiving side
        // (agent's auto-toggle or manual button), never blocking the send.
        let msg = NewMessage(
            conversation_id: convId, sender_type: "user", sender_id: userId.uuidString.lowercased(),
            body_original: text, body_translated: nil, image_url: nil
        )
        await insert(msg)
    }

    /// Translate one message into the recipient's language and persist body_translated
    /// (visible to both sides). Target by sender: user→zh (agent reads), agent→en (user reads).
    func translateMessage(_ message: SupportMessage) async {
        guard let text = message.bodyOriginal, !text.isEmpty,
              !translatingIds.contains(message.id) else { return }
        let target = message.senderType == "user" ? "zh" : "en"
        translatingIds.insert(message.id)
        defer { translatingIds.remove(message.id) }
        guard let translated = await translate(text, target: target), !translated.isEmpty else { return }
        _ = try? await client.from("support_messages")
            .update(["body_translated": translated]).eq("id", value: message.id).execute()
        // Patch just this row locally instead of refetching the whole thread — avoids a
        // full reload + re-render per translation during auto-translate bursts. The
        // realtime UPDATE echo from our own write then no-ops against the loadMessages guard.
        if let idx = messages.firstIndex(where: { $0.id == message.id }) {
            let m = messages[idx]
            messages[idx] = SupportMessage(
                id: m.id, conversationId: m.conversationId, senderType: m.senderType,
                senderId: m.senderId, bodyOriginal: m.bodyOriginal, bodyTranslated: translated,
                imageUrl: m.imageUrl, createdAt: m.createdAt
            )
        }
    }

    /// Whether an incoming message should be auto-translated (toggle on, from agent,
    /// not yet translated, not in flight). Driven by the chat view's onAppear so only
    /// messages scrolled into view (visible range) are translated.
    func shouldAutoTranslate(_ m: SupportMessage) -> Bool {
        autoTranslate && m.senderType == "agent"
            && (m.bodyTranslated ?? "").isEmpty
            && (m.bodyOriginal ?? "").isEmpty == false
            && !translatingIds.contains(m.id)
    }

    /// When the toggle is switched on, translate just the visible tail (most recent),
    /// not the whole history; older messages translate as they scroll into view.
    func autoTranslateVisibleTail(limit: Int = 15) {
        for m in messages.suffix(limit) where shouldAutoTranslate(m) {
            Task { await translateMessage(m) }
        }
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

    // MARK: - Realtime + polling fallback

    @ObservationIgnored private var rtChannel: RealtimeChannelV2?
    @ObservationIgnored private var rtTasks: [Task<Void, Never>] = []

    /// Subscribe to live postgres changes for the active conversation. RLS limits events
    /// to rows this user may see. Polling (below) stays as a low-frequency safety net.
    private func subscribeRealtime() {
        Task { [weak self] in await self?.startRealtime() }
    }

    private func startRealtime() async {
        guard AppConfig.isSupabaseConfigured else { return }
        await stopRealtime()
        let channel = client.channel("support-chat-rt")
        let inserts = channel.postgresChange(InsertAction.self, schema: "public", table: "support_messages")
        let updates = channel.postgresChange(UpdateAction.self, schema: "public", table: "support_messages")
        let convs = channel.postgresChange(UpdateAction.self, schema: "public", table: "support_conversations")
        try? await channel.subscribeWithError()
        rtChannel = channel
        rtTasks = [
            Task { [weak self] in for await _ in inserts { await self?.onIncomingMessageChange() } },
            Task { [weak self] in for await _ in updates { await self?.loadMessages() } },
            Task { [weak self] in for await _ in convs { await self?.refreshConversationMeta() } },
        ]
    }

    private func onIncomingMessageChange() async {
        await loadMessages()
        await markReadCurrent()
    }

    private func stopRealtime() async {
        rtTasks.forEach { $0.cancel() }
        rtTasks = []
        if let ch = rtChannel { await client.realtimeV2.removeChannel(ch) }
        rtChannel = nil
    }

    // MARK: - Home (inbox + agent status) realtime

    @ObservationIgnored private var homeChannel: RealtimeChannelV2?
    @ObservationIgnored private var homeTasks: [Task<Void, Never>] = []

    /// Live agent online-status + inbox unread on the Genius Bar home screen.
    func subscribeHomeRealtime(userId: UUID) {
        Task { [weak self] in await self?.startHomeRealtime(userId: userId) }
    }

    private func startHomeRealtime(userId: UUID) async {
        guard AppConfig.isSupabaseConfigured else { return }
        await stopHomeRealtime()
        let channel = client.channel("support-home-rt")
        let agentsCh = channel.postgresChange(AnyAction.self, schema: "public", table: "support_agents")
        let convCh = channel.postgresChange(AnyAction.self, schema: "public", table: "support_conversations")
        let msgCh = channel.postgresChange(InsertAction.self, schema: "public", table: "support_messages")
        try? await channel.subscribeWithError()
        homeChannel = channel
        homeTasks = [
            Task { [weak self] in for await _ in agentsCh { await self?.loadAgents() } },
            Task { [weak self] in for await _ in convCh { await self?.loadMyConversations(userId: userId) } },
            Task { [weak self] in for await _ in msgCh { await self?.loadMyConversations(userId: userId) } },
        ]
    }

    func stopHomeRealtime() async {
        homeTasks.forEach { $0.cancel() }
        homeTasks = []
        if let ch = homeChannel { await client.realtimeV2.removeChannel(ch) }
        homeChannel = nil
    }

    private func startPolling() {
        pollTask?.cancel()
        pollTask = Task { [weak self] in
            while !Task.isCancelled {
                // Realtime is primary; this is a 15s safety net (missed events / reconnect).
                try? await Task.sleep(nanoseconds: 15_000_000_000)
                if Task.isCancelled { break }
                await self?.loadMessages()
                await self?.refreshConversationMeta()
                await self?.markReadCurrent()
            }
        }
    }

    /// Refresh the active conversation row for the agent's typing marker. Must NOT write
    /// (a write would re-trigger the realtime conversation-update handler → loop); read marker
    /// is updated separately in markReadCurrent / on new messages.
    private func refreshConversationMeta() async {
        guard let id = conversation?.id else { return }
        let rows: [SupportConversation] = (try? await client.from("support_conversations")
            .select().eq("id", value: id).limit(1).execute().value) ?? []
        if let c = rows.first {
            if c != conversation { conversation = c }
            let typing = ChatDate.isRecent(c.agentTypingAt)
            if typing != agentIsTyping { agentIsTyping = typing }
        }
    }

    private func markReadCurrent() async {
        if let id = conversation?.id { await markRead(id) }
    }

    func stopPolling() {
        pollTask?.cancel()
        pollTask = nil
        Task { [weak self] in await self?.stopRealtime() }
    }
}

/// Lenient ISO-8601 helpers for chat read/typing markers (best-effort, non-critical).
enum ChatDate {
    private static let withFraction: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter(); f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]; return f
    }()
    private static let plain: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter(); f.formatOptions = [.withInternetDateTime]; return f
    }()

    static func now() -> String { plain.string(from: Date()) }

    static func parse(_ s: String?) -> Date? {
        guard let s, !s.isEmpty else { return nil }
        return withFraction.date(from: s) ?? plain.date(from: s)
    }

    static func newer(_ a: String?, than b: Date?) -> Bool {
        guard let ad = parse(a) else { return false }
        guard let bd = b else { return true }
        return ad > bd
    }

    static func isRecent(_ s: String?, within seconds: TimeInterval = 6) -> Bool {
        guard let d = parse(s) else { return false }
        return Date().timeIntervalSince(d) < seconds
    }
}
