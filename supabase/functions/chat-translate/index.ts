import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import { chatCompletion, corsHeaders, type ChatMessage } from "../_shared/volcengine.ts";
import { loadTranslateSettingsFromCMS } from "../_shared/translate-settings.ts";

// Abuse limits: only eligible callers (agents / users in an open conversation) may
// translate, capped per minute, with a bounded input size — translation hits a paid
// LLM, so an authenticated user must not be able to run up the bill at will.
const MAX_PER_MIN = 30;
const MAX_TEXT_CHARS = 2000;

// Genius Bar chat translation. Translates a single message to a target language.
// Provider/model/key/url are configurable via app_settings (admin CMS); defaults
// reuse the VolcEngine LLM already wired for ai-complete.

function jsonResponse(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}

const LANG_NAMES: Record<string, string> = {
  en: "English",
  zh: "Simplified Chinese",
  "zh-Hans": "Simplified Chinese",
  ja: "Japanese",
  ko: "Korean",
  fr: "French",
  de: "German",
  es: "Spanish",
};

function languageName(code: string): string {
  return LANG_NAMES[code] ?? LANG_NAMES[code.split("-")[0]] ?? code;
}

// Same-text cache to avoid re-translating identical messages (5 min TTL).
type CacheEntry = { value: string; at: number };
const _cache = new Map<string, CacheEntry>();
const CACHE_TTL_MS = 5 * 60 * 1000;
const CACHE_MAX = 500;

function cacheGet(key: string): string | null {
  const hit = _cache.get(key);
  if (hit && Date.now() - hit.at < CACHE_TTL_MS) return hit.value;
  if (hit) _cache.delete(key);
  return null;
}

function cacheSet(key: string, value: string) {
  if (_cache.size >= CACHE_MAX) {
    const oldest = _cache.keys().next().value;
    if (oldest) _cache.delete(oldest);
  }
  _cache.set(key, { value, at: Date.now() });
}

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const body = await req.json().catch(() => ({}));
    const text = String(body.text ?? "").trim();
    const cfg = await loadTranslateSettingsFromCMS();
    const target = String(body.target_lang ?? body.targetLang ?? cfg.targetDefault).trim();

    if (!text) {
      return jsonResponse({ code: 400, error: "text is required" }, 400);
    }

    // Bound the cost of any single call. Chat messages are short; an oversized
    // body is either abuse or a non-chat use — serve the original, skip the LLM.
    if (text.length > MAX_TEXT_CHARS) {
      return jsonResponse({ code: 200, translated: text, fallback: true, reason: "too_long" });
    }

    // Eligibility + per-user rate limit, atomically, under the caller's identity.
    const supabaseUrl = Deno.env.get("SUPABASE_URL") ?? "";
    const anonKey = Deno.env.get("SUPABASE_ANON_KEY") ?? "";
    const authHeader = req.headers.get("Authorization") ?? "";
    if (!authHeader) {
      return jsonResponse({ code: 401, error: "unauthorized" }, 401);
    }
    const caller = createClient(supabaseUrl, anonKey, { global: { headers: { Authorization: authHeader } } });
    const { data: allowed, error: rlErr } = await caller.rpc("translate_rate_check", { max_per_min: MAX_PER_MIN });
    if (rlErr) {
      console.error("translate_rate_check error:", rlErr);
      return jsonResponse({ code: 500, error: "rate check failed" }, 500);
    }
    if (allowed !== true) {
      // Either not eligible to translate, or over the per-minute limit.
      return jsonResponse({ code: 429, error: "rate_limited", translated: text, fallback: true }, 429);
    }

    const cacheKey = `${target}::${text}`;
    const cached = cacheGet(cacheKey);
    if (cached !== null) {
      return jsonResponse({ code: 200, translated: cached, cached: true });
    }

    const targetName = languageName(target);
    const messages: ChatMessage[] = [
      {
        role: "system",
        content:
          `You are a translation engine. Translate the user's message into ${targetName}. ` +
          `Output ONLY the translation, with no quotes, notes, or explanation. ` +
          `Preserve emoji and tone. If the text is already in ${targetName}, return it unchanged.`,
      },
      { role: "user", content: text },
    ];

    const translated = await chatCompletion({
      messages,
      maxTokens: cfg.maxTokens,
      temperature: 0.2,
      modelId: cfg.modelId || undefined,
      apiUrl: cfg.apiUrl || undefined,
      apiKey: cfg.apiKey || undefined,
      timeoutMs: cfg.timeoutMs,
    });

    if (!translated) {
      // Translation failed — return original so chat still flows.
      return jsonResponse({ code: 200, translated: text, fallback: true });
    }

    cacheSet(cacheKey, translated);
    return jsonResponse({ code: 200, translated });
  } catch (err) {
    console.error("chat-translate error:", err);
    return jsonResponse(
      { code: 500, error: err instanceof Error ? err.message : "Internal error" },
      500,
    );
  }
});
