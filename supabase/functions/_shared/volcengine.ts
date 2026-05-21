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
  const maxTokens = envNumber("VOLCENGINE_SUGGESTION_MAX_TOKENS", 450);
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
  const temperature = options.temperature ?? cfg.temperature;
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

export const corsHeaders: Record<string, string> = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};
