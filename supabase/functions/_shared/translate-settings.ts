// Translation settings, configurable from the admin CMS (app_settings.global).
// Falls back to the VolcEngine LLM (same key as ai-complete) when unset, so chat
// translation works out of the box and can be re-pointed at another provider later.

export type TranslateSettings = {
  modelId: string;        // overrides ai model for translation; "" = use VOLCENGINE default
  apiUrl: string;         // "" = use VolcEngine default
  apiKey: string;         // "" = use VOLCENGINE_API_KEY
  maxTokens: number;
  timeoutMs: number;
  targetDefault: string;  // default target language when client omits it
};

function envNumber(key: string, fallback: number): number {
  const raw = Deno.env.get(key);
  if (!raw) return fallback;
  const n = Number(raw);
  return Number.isFinite(n) ? n : fallback;
}

function envDefaults(): TranslateSettings {
  return {
    modelId: Deno.env.get("TRANSLATE_MODEL") ?? "",
    apiUrl: Deno.env.get("TRANSLATE_API_URL") ?? "",
    apiKey: Deno.env.get("TRANSLATE_API_KEY") ?? "",
    maxTokens: envNumber("TRANSLATE_MAX_TOKENS", 400),
    timeoutMs: envNumber("TRANSLATE_TIMEOUT_MS", 15000),
    targetDefault: Deno.env.get("TRANSLATE_TARGET_DEFAULT") ?? "en",
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

export function mergeTranslateSettings(row: Record<string, unknown> | null): TranslateSettings {
  const base = envDefaults();
  if (!row) return base;
  return {
    modelId: pickString(row, "translate_model") ?? base.modelId,
    apiUrl: pickString(row, "translate_api_url") ?? base.apiUrl,
    apiKey: pickString(row, "translate_api_key") ?? base.apiKey,
    maxTokens: pickNumber(row, "translate_max_tokens", base.maxTokens),
    timeoutMs: pickNumber(row, "translate_timeout_ms", base.timeoutMs),
    targetDefault: pickString(row, "translate_target_default") ?? base.targetDefault,
  };
}

let _cache: TranslateSettings | null = null;
let _cachedAt = 0;
const TTL_MS = 5 * 60 * 1000;

export async function loadTranslateSettingsFromCMS(): Promise<TranslateSettings> {
  const now = Date.now();
  if (_cache && now - _cachedAt < TTL_MS) return _cache;

  const url = Deno.env.get("SUPABASE_URL");
  const key =
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? Deno.env.get("SUPABASE_ANON_KEY");
  if (!url || !key) return envDefaults();

  try {
    const res = await fetch(
      `${url}/rest/v1/app_settings?id=eq.global&select=translate_model,translate_api_url,translate_api_key,translate_max_tokens,translate_timeout_ms,translate_target_default`,
      { headers: { apikey: key, Authorization: `Bearer ${key}` } },
    );
    if (!res.ok) return _cache ?? envDefaults();
    const rows = await res.json();
    const row = Array.isArray(rows) && rows[0] ? rows[0] : null;
    _cache = mergeTranslateSettings(row as Record<string, unknown> | null);
    _cachedAt = now;
    return _cache;
  } catch {
    return _cache ?? envDefaults();
  }
}
