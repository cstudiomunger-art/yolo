export type ChatMessage = {
  role: "system" | "user" | "assistant";
  content: string;
};

export type ChatCompletionOptions = {
  messages: ChatMessage[];
  maxTokens?: number;
  temperature?: number;
  modelId?: string;
  apiUrl?: string;
  timeoutMs?: number;
  /** "auto" lets the model decide when to think; omit to disable thinking. */
  thinkingMode?: "auto" | "enabled" | "disabled";
};

const DEFAULT_API_URL = "https://ark.cn-beijing.volces.com/api/v3/chat/completions";
const MAX_RETRIES = 2;
const RETRY_DELAY_MS = 1000;

function envNumber(key: string, fallback: number): number {
  const raw = Deno.env.get(key);
  if (!raw) return fallback;
  const n = Number(raw);
  return Number.isFinite(n) ? n : fallback;
}

export function volcengineConfig() {
  const apiKey = Deno.env.get("VOLCENGINE_API_KEY") ?? "";
  const model = Deno.env.get("VOLCENGINE_SUGGESTION_MODEL") ?? "";
  const apiUrl = Deno.env.get("VOLCENGINE_CHAT_API_URL") ?? DEFAULT_API_URL;
  // These env-var fallbacks are last-resort for local dev only.
  // Production values must be set in app_settings via the admin CMS.
  const maxTokens = envNumber("VOLCENGINE_SUGGESTION_MAX_TOKENS", 200);
  const temperature = envNumber("VOLCENGINE_SUGGESTION_TEMPERATURE", 0.7);
  const timeoutMs = envNumber("VOLCENGINE_SUGGESTION_TIMEOUT_MS", 20000);
  return { apiKey, model, apiUrl, maxTokens, temperature, timeoutMs };
}

export async function chatCompletion(
  options: ChatCompletionOptions,
): Promise<string | null> {
  const cfg = volcengineConfig();
  const apiKey = cfg.apiKey;
  const model = options.modelId?.trim() || cfg.model;
  const apiUrl = options.apiUrl?.trim() || cfg.apiUrl;
  const timeoutMs = options.timeoutMs ?? cfg.timeoutMs;

  if (!apiKey || !model) {
    throw new Error("Missing VOLCENGINE_API_KEY or model id (CMS ai_model_id / VOLCENGINE_SUGGESTION_MODEL)");
  }

  const maxTokens = options.maxTokens ?? cfg.maxTokens;
  // thinking requires temperature = 1
  const useThinking = options.thinkingMode && options.thinkingMode !== "disabled";
  const temperature = useThinking ? 1 : (options.temperature ?? cfg.temperature);
  const thinkingParam = useThinking ? { type: options.thinkingMode } : undefined;
  let lastError: unknown;

  for (let attempt = 0; attempt < MAX_RETRIES; attempt++) {
    try {
      const controller = new AbortController();
      const timer = setTimeout(() => controller.abort(), timeoutMs);
      const response = await fetch(apiUrl, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${apiKey}`,
        },
        body: JSON.stringify({
          model,
          messages: options.messages,
          max_tokens: maxTokens,
          temperature,
          ...(thinkingParam ? { thinking: thinkingParam } : {}),
        }),
        signal: controller.signal,
      });
      clearTimeout(timer);

      if (!response.ok) {
        const body = await response.text();
        throw new Error(`VolcEngine HTTP ${response.status}: ${body.slice(0, 200)}`);
      }

      const data = await response.json();
      const content =
        data?.choices?.[0]?.message?.content ??
        data?.choices?.[0]?.message?.text;
      if (typeof content === "string" && content.trim()) {
        return content.trim();
      }
      throw new Error("Empty model response");
    } catch (err) {
      lastError = err;
      if (attempt < MAX_RETRIES - 1) {
        await new Promise((r) => setTimeout(r, RETRY_DELAY_MS));
      }
    }
  }

  console.error("VolcEngine chatCompletion failed:", lastError);
  return null;
}

/** Open a streaming chat completion and return the raw SSE Response for forwarding. */
export async function streamChatCompletion(
  options: ChatCompletionOptions,
): Promise<Response> {
  const cfg = volcengineConfig();
  const apiKey = cfg.apiKey;
  const model = options.modelId?.trim() || cfg.model;
  const apiUrl = options.apiUrl?.trim() || cfg.apiUrl;
  const maxTokens = options.maxTokens ?? cfg.maxTokens;
  const useThinking = options.thinkingMode && options.thinkingMode !== "disabled";
  const temperature = useThinking ? 1 : (options.temperature ?? cfg.temperature);
  const thinkingParam = useThinking ? { type: options.thinkingMode } : undefined;

  if (!apiKey || !model) {
    throw new Error("Missing VOLCENGINE_API_KEY or model id");
  }

  const upstream = await fetch(apiUrl, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${apiKey}`,
    },
    body: JSON.stringify({
      model,
      messages: options.messages,
      max_tokens: maxTokens,
      temperature,
      stream: true,
      ...(thinkingParam ? { thinking: thinkingParam } : {}),
    }),
  });

  if (!upstream.ok || !upstream.body) {
    const err = await upstream.text().catch(() => "");
    throw new Error(`VolcEngine stream HTTP ${upstream.status}: ${err.slice(0, 200)}`);
  }

  return new Response(upstream.body, {
    headers: {
      ...corsHeaders,
      "Content-Type": "text/event-stream",
      "Cache-Control": "no-cache",
      "X-Accel-Buffering": "no",
    },
  });
}

export const corsHeaders: Record<string, string> = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};
