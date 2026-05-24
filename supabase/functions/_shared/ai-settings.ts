export type AISettings = {
  modelId: string;
  apiUrl: string;
  chatMaxTokens: number;
  itineraryMaxTokens: number;
  temperature: number;
  timeoutMs: number;
  systemPromptAssistant: string | null;
  systemPromptItinerary: string | null;
};

const DEFAULT_API_URL = "https://ark.cn-beijing.volces.com/api/v3/chat/completions";

const DEFAULT_ASSISTANT_PROMPT =
  "You are YOLO HAPPY Travel Assistant — a friendly expert helping international visitors plan and enjoy trips in China. " +
  "Reply in clear English (you may include brief Chinese phrases for place names). " +
  "Keep answers practical, warm, and under 300 words. " +
  "Cover payment, transport, food, safety, and culture when relevant.";

function envNumber(key: string, fallback: number): number {
  const raw = Deno.env.get(key);
  if (!raw) return fallback;
  const n = Number(raw);
  return Number.isFinite(n) ? n : fallback;
}

function envDefaults(): AISettings {
  return {
    modelId: Deno.env.get("VOLCENGINE_SUGGESTION_MODEL") ?? "",
    apiUrl: Deno.env.get("VOLCENGINE_CHAT_API_URL") ?? DEFAULT_API_URL,
    chatMaxTokens: envNumber("VOLCENGINE_SUGGESTION_MAX_TOKENS", 450),
    itineraryMaxTokens: envNumber("VOLCENGINE_ITINERARY_MAX_TOKENS", 1200),
    temperature: envNumber("VOLCENGINE_SUGGESTION_TEMPERATURE", 0.7),
    timeoutMs: envNumber("VOLCENGINE_SUGGESTION_TIMEOUT_MS", 20000),
    systemPromptAssistant: null,
    systemPromptItinerary: null,
  };
}

function pickString(row: Record<string, unknown>, key: string): string | null {
  const v = row[key];
  if (v == null) return null;
  const s = String(v).trim();
  return s || null;
}

function pickNumber(row: Record<string, unknown>, key: string, fallback: number): number {
  const v = row[key];
  if (v == null || v === "") return fallback;
  const n = Number(v);
  return Number.isFinite(n) ? n : fallback;
}

export function mergeAISettings(row: Record<string, unknown> | null): AISettings {
  const base = envDefaults();
  if (!row) return base;

  return {
    modelId: pickString(row, "ai_model_id") ?? base.modelId,
    apiUrl: pickString(row, "ai_chat_api_url") ?? base.apiUrl,
    chatMaxTokens: pickNumber(row, "ai_chat_max_tokens", base.chatMaxTokens),
    itineraryMaxTokens: pickNumber(row, "ai_itinerary_max_tokens", base.itineraryMaxTokens),
    temperature: pickNumber(row, "ai_temperature", base.temperature),
    timeoutMs: pickNumber(row, "ai_timeout_ms", base.timeoutMs),
    systemPromptAssistant: pickString(row, "ai_system_prompt_assistant"),
    systemPromptItinerary: pickString(row, "ai_system_prompt_itinerary"),
  };
}

export async function loadAISettingsFromCMS(): Promise<AISettings> {
  const url = Deno.env.get("SUPABASE_URL");
  const key =
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? Deno.env.get("SUPABASE_ANON_KEY");
  if (!url || !key) {
    console.warn("ai-settings: missing SUPABASE_URL or service key, using env defaults");
    return envDefaults();
  }

  try {
    const res = await fetch(
      `${url}/rest/v1/app_settings?id=eq.global&select=ai_model_id,ai_chat_api_url,ai_chat_max_tokens,ai_itinerary_max_tokens,ai_temperature,ai_timeout_ms,ai_system_prompt_assistant,ai_system_prompt_itinerary`,
      {
        headers: {
          apikey: key,
          Authorization: `Bearer ${key}`,
        },
      },
    );
    if (!res.ok) {
      console.warn("ai-settings: CMS fetch failed", res.status);
      return envDefaults();
    }
    const rows = await res.json();
    const row = Array.isArray(rows) && rows[0] ? rows[0] : null;
    return mergeAISettings(row as Record<string, unknown> | null);
  } catch (err) {
    console.warn("ai-settings: CMS fetch error", err);
    return envDefaults();
  }
}

export function defaultAssistantSystemPrompt(scenarioHint = ""): string {
  const hint = scenarioHint ? ` ${scenarioHint}` : "";
  return `${DEFAULT_ASSISTANT_PROMPT}${hint}`;
}

export function defaultItinerarySystemPrompt(_days: number, schema: string): string {
  return (
    `You are YOLO HAPPY itinerary planner. Output ONLY valid JSON (snake_case keys, no markdown) matching:\n${schema}\n` +
    `CRITICAL: You MUST only assign attractions from the provided catalog using attraction_id values exactly as given. ` +
    `Do NOT suggest any place, venue, shop, or address not in the catalog. ` +
    `Each attraction_id may appear at most once across all assignments. ` +
    `For experience_days only: output generic experience titles (no venue names, addresses, or business names). ` +
    `Do not output full itinerary days, activity names for catalog attractions, or time slots.`
  );
}
