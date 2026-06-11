import Foundation
import Supabase

enum AIService {
    private static let functionName = "ai-complete"

    // MARK: - Public API

    static func chatAssistant(
        message: String,
        history: [(role: String, content: String)],
        scenarioId: String? = nil
    ) async -> String {
        guard AppConfig.isSupabaseConfigured, !AppConfig.forceBundled else {
            return offlineHint
        }
        guard isAuthenticated else { return loginRequiredHint }
        let payload = AssistantChatRequest(
            type: "assistant_chat",
            message: message,
            history: history.map { ChatHistoryItem(role: $0.role, content: $0.content) },
            scenarioId: scenarioId
        )
        let result: Result<AssistantChatResponse, AIInvokeError> = await invokeResult(payload)
        switch result {
        case .success(let response):
            if response.code == 200, let text = response.text, !text.isEmpty {
                return text
            }
            return "AI 返回为空，请稍后重试。"
        case .failure(let error):
            return "AI 调用失败：\(error.message)"
        }
    }

    /// Streams the assistant reply via SSE, calling onChunk for each content token.
    /// Thinking tokens (reasoning_content / thinking_content) are silently skipped.
    static func chatAssistantStream(
        message: String,
        history: [(role: String, content: String)],
        scenarioId: String? = nil,
        onChunk: @escaping @Sendable (String) -> Void
    ) async {
        guard AppConfig.isSupabaseConfigured, !AppConfig.forceBundled else {
            onChunk(offlineHint); return
        }
        // ai-complete 现要求登录用户 JWT（verify_jwt=true）；用当前会话的 access token。
        guard let accessToken = try? await SupabaseManager.shared.auth.session.accessToken else {
            onChunk(loginRequiredHint); return
        }
        var request = URLRequest(
            url: AppConfig.supabaseURL.appendingPathComponent("functions/v1/ai-complete")
        )
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(AppConfig.supabaseAnonKey, forHTTPHeaderField: "apikey")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 90
        let payload = AssistantChatRequest(
            type: "assistant_chat",
            message: message,
            history: history.map { ChatHistoryItem(role: $0.role, content: $0.content) },
            scenarioId: scenarioId
        )
        guard let body = try? JSONCoding.makeEncoder().encode(payload) else { return }
        request.httpBody = body
        do {
            let (bytes, resp) = try await URLSession.shared.bytes(for: request)
            guard (resp as? HTTPURLResponse)?.statusCode == 200 else {
                onChunk(String(localized: "⚠️ AI service unavailable. Please try again."))
                return
            }
            for try await line in bytes.lines {
                guard line.hasPrefix("data: ") else { continue }
                let data = String(line.dropFirst(6))
                guard data != "[DONE]",
                      let json = data.data(using: .utf8),
                      let chunk = try? JSONDecoder().decode(SSEChunk.self, from: json),
                      let content = chunk.choices.first?.delta.content,
                      !content.isEmpty
                else { continue }
                onChunk(content)
            }
        } catch is CancellationError {
            // Task cancelled intentionally — no user-facing message needed.
        } catch {
            onChunk(String(localized: "⚠️ Connection failed. Please try again."))
        }
    }

    static func generateItinerary(
        content: any ContentRepositoryProtocol,
        cities: [String],
        days: Int,
        useRemoteAI: Bool,
        userNotes: String? = nil
    ) async throws -> SampleItinerary {
        if useRemoteAI, isAuthenticated, AppConfig.isSupabaseConfigured, !AppConfig.forceBundled {
            let payload = ItineraryRequest(
                type: "itinerary",
                cities: cities,
                days: days,
                userNotes: userNotes
            )
            let result: Result<ItineraryResponse, AIInvokeError> = await invokeResult(payload)
            if case .success(let response) = result,
               response.code == 200,
               let itinerary = response.itinerary {
                return itinerary
            }
        }
        return try await localItineraryFallback(
            content: content,
            cities: cities,
            days: days
        )
    }

    static func planningItineraryCard(
        content: any ContentRepositoryProtocol,
        useRemoteAI: Bool,
        cities: [String],
        userNotes: String? = nil
    ) async throws -> SampleItinerary {
        if useRemoteAI, isAuthenticated, AppConfig.isSupabaseConfigured, !AppConfig.forceBundled {
            return try await generateItinerary(
                content: content,
                cities: cities.isEmpty ? ["beijing"] : cities,
                days: 7,
                useRemoteAI: true,
                userNotes: userNotes
            )
        }
        return try await content.fetchPlanningItinerary()
    }

    // MARK: - Edge Function

    private struct AIInvokeError: Error {
        let message: String
    }

    private static func invokeResult<T: Decodable>(
        _ body: some Encodable
    ) async -> Result<T, AIInvokeError> {
        do {
            let value: T = try await SupabaseManager.shared.functions.invoke(
                functionName,
                options: FunctionInvokeOptions(body: body, encoder: JSONCoding.makeEncoder()),
                decoder: JSONCoding.makeDecoder()
            )
            return .success(value)
        } catch let error as FunctionsError {
            return .failure(AIInvokeError(message: describeFunctionsError(error)))
        } catch {
            return .failure(AIInvokeError(message: error.localizedDescription))
        }
    }

    private static func describeFunctionsError(_ error: FunctionsError) -> String {
        switch error {
        case .httpError(let code, let data):
            let body = String(data: data, encoding: .utf8) ?? ""
            return "HTTP \(code)\(body.isEmpty ? "" : " — \(body.prefix(120))")"
        case .relayError:
            return "Edge Function relay error"
        }
    }

    private static func localItineraryFallback(
        content: any ContentRepositoryProtocol,
        cities: [String],
        days: Int
    ) async throws -> SampleItinerary {
        let cityIds = cities.isEmpty ? ["beijing"] : cities
        var catalog: [Attraction] = []
        for cityId in cityIds {
            let list = (try? await content.fetchAttractions(cityId: cityId)) ?? []
            catalog.append(contentsOf: list)
        }
        return PlanItineraryAssembler.build(
            cities: cityIds,
            tripDays: days,
            attractions: catalog
        )
    }

    private static var offlineHint: String {
        "当前为离线/演示模式，无法调用 AI。请在 CMS 开启「远程 AI」并配置 Supabase。"
    }

    /// ai-complete 要求登录用户 JWT（verify_jwt=true）；游客一律走本地兜底，不调用远程。
    private static var isAuthenticated: Bool {
        SupabaseManager.shared.auth.currentSession != nil
    }

    private static var loginRequiredHint: String {
        String(localized: "请先登录后再使用 AI 助手。")
    }
}

// MARK: - Request / Response types

private struct AssistantChatRequest: Encodable {
    let type: String
    let message: String
    let history: [ChatHistoryItem]
    let scenarioId: String?

    enum CodingKeys: String, CodingKey {
        case type, message, history
        case scenarioId = "scenario_id"
    }
}

private struct ChatHistoryItem: Encodable {
    let role: String
    let content: String
}

private struct AssistantChatResponse: Decodable {
    let code: Int
    let text: String?
}

private struct ItineraryRequest: Encodable {
    let type: String
    let cities: [String]
    let days: Int
    let userNotes: String?

    enum CodingKeys: String, CodingKey {
        case type, cities, days
        case userNotes = "user_notes"
    }
}

private struct ItineraryResponse: Decodable {
    let code: Int
    let itinerary: SampleItinerary?
}

// MARK: - SSE types

private struct SSEChunk: Decodable {
    let choices: [SSEChoice]
}
private struct SSEChoice: Decodable {
    let delta: SSEDelta
}
private struct SSEDelta: Decodable {
    // Regular answer token
    let content: String?
    // Thinking tokens — present when thinking:auto is active; we skip these.
    let reasoningContent: String?
    let thinkingContent: String?
}
