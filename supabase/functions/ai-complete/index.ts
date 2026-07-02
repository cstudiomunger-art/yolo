import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import {
  defaultAssistantSystemPrompt,
  defaultItinerarySystemPrompt,
  loadAISettingsFromCMS,
  type AISettings,
} from "../_shared/ai-settings.ts";
import {
  commuteSlots,
  fetchCitiesMeta,
  travelHours,
} from "../_shared/city-travel-hints.ts";
import {
  AI_PLAN_JSON_SCHEMA,
  buildDayPlan,
  buildItineraryPipeline,
  fetchAttractionsForCities,
  ITINERARY_HARD_CONSTRAINTS,
  parseAIPlanResponse,
  supabaseHeaders,
  type AttractionRow,
  type SampleItinerary,
} from "../_shared/itinerary-assembler.ts";
import { parseDurationSlots } from "../_shared/itinerary-duration.ts";
import {
  chatCompletion,
  corsHeaders,
  type ChatMessage,
} from "../_shared/volcengine.ts";

type HistoryItem = { role: string; content: string };

function jsonResponse(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, "Content-Type": "application/json" },
  });
}

function normalizeHistory(raw: unknown): ChatMessage[] {
  if (!Array.isArray(raw)) return [];
  return raw
    .map((item) => {
      const role = String((item as HistoryItem)?.role ?? "").toLowerCase();
      const content = String((item as HistoryItem)?.content ?? "").trim();
      if (!content) return null;
      if (role === "assistant") return { role: "assistant" as const, content };
      if (role === "user") return { role: "user" as const, content };
      return null;
    })
    .filter((x): x is ChatMessage => x !== null)
    .slice(-12);
}

function extractJsonObject(text: string): string | null {
  const trimmed = text.trim();
  if (trimmed.startsWith("{")) {
    const end = trimmed.lastIndexOf("}");
    if (end > 0) return trimmed.slice(0, end + 1);
  }
  const fence = trimmed.match(/```(?:json)?\s*([\s\S]*?)```/i);
  if (fence?.[1]) return fence[1].trim();
  const start = trimmed.indexOf("{");
  const end = trimmed.lastIndexOf("}");
  if (start >= 0 && end > start) return trimmed.slice(start, end + 1);
  return null;
}

function buildItineraryUserPrompt(params: {
  cities: string[];
  days: number;
  userNotes: string;
  catalog: AttractionRow[];
  plan: ReturnType<typeof buildDayPlan>;
  citiesMeta: Awaited<ReturnType<typeof fetchCitiesMeta>>;
  travelContext: string;
}): string {
  const catalogCompact = compactCatalogForPrompt(params.catalog).map((a) => ({
    id: a.id,
    city_id: a.city_id,
    name: a.name,
    recommended_duration: a.recommended_duration,
    duration_slots: parseDurationSlots(a.recommended_duration),
    closed_weekdays: a.closed_weekdays ?? [],
    open_time: a.open_time,
    close_time: a.close_time,
    last_entry_time: a.last_entry_time,
    planning_zone: a.planning_zone ?? null,
    summary: a.summary ? a.summary.slice(0, 160) : null,
  }));

  const metaCompact = params.citiesMeta.map((c) => ({
    id: c.id,
    avg_days_recommended: c.avg_days_recommended,
    attraction_count: c.attraction_count,
  }));

  const sortedCities = [...params.cities].sort();

  return (
    `Plan a ${params.days}-day China trip using exactly ${params.days} activity day slots (fixed budget).\n` +
    `Selected cities (unordered — YOU choose the optimal visit_order): ${sortedCities.join(", ") || "beijing"}\n` +
    (params.userNotes ? `User preferences: ${params.userNotes}\n` : "") +
    `\nCity metadata:\n${JSON.stringify(metaCompact)}\n` +
    `\nTravel hints (same-day only when sameDayOk):\n${params.travelContext}\n` +
    `\nAttraction catalog (ONLY these ids are valid):\n${JSON.stringify(catalogCompact)}\n` +
    `\nRules: max ${params.plan.maxPerDay} attraction_ids per non-travel day; no duplicate ids; ` +
    `distant cities cannot share a day; use experience_days (kind travel/rest) for intercity moves within the ${params.days}-day budget.\n` +
    `Respect opening constraints: do not assign closed_weekdays to matching dates; if only afternoon-open, avoid Morning slot assumptions.\n` +
    `Return JSON with visit_order, assignments, experience_days, optional title and estimated_budget.`
  );
}

function compactCatalogForPrompt(catalog: AttractionRow[]): AttractionRow[] {
  const byCity = new Map<string, AttractionRow[]>();
  for (const row of catalog) {
    const list = byCity.get(row.city_id) ?? [];
    list.push(row);
    byCity.set(row.city_id, list);
  }

  const picked: AttractionRow[] = [];
  for (const rows of byCity.values()) {
    const sorted = [...rows].sort((a, b) => {
      const pa = a.priority === "P0" ? 0 : a.priority === "P1" ? 1 : 2;
      const pb = b.priority === "P0" ? 0 : b.priority === "P1" ? 1 : 2;
      if (pa !== pb) return pa - pb;
      return a.display_order - b.display_order;
    });
    picked.push(...sorted.slice(0, 18));
  }
  return picked;
}

function buildTravelContext(cityIds: string[]): string {
  const sorted = [...cityIds].sort();
  const lines: string[] = [];
  for (let i = 0; i < sorted.length; i++) {
    for (let j = i + 1; j < sorted.length; j++) {
      const a = sorted[i];
      const b = sorted[j];
      const h = travelHours(a, b);
      lines.push(`${a}↔${b}: ${h}h, commuteSlots=${commuteSlots(h)}, sameDayOk=${h <= 2}`);
    }
  }
  return lines.length ? lines.join("\n") : "Single city trip.";
}

async function buildItineraryFromAI(
  cities: string[],
  days: number,
  userNotes: string,
  aiPlanRaw: string | null,
  citiesMeta: Awaited<ReturnType<typeof fetchCitiesMeta>>,
  entryCityId: string | null,
  exitCityId: string | null,
  startDateLocal: string | null,
): Promise<SampleItinerary> {
  const cityIds = cities.length ? cities : ["beijing"];
  const catalog = await fetchAttractionsForCities(cityIds);

  let aiPlan = null;
  if (aiPlanRaw) {
    const jsonStr = extractJsonObject(aiPlanRaw);
    if (jsonStr) {
      try {
        aiPlan = parseAIPlanResponse(JSON.parse(jsonStr));
      } catch {
        aiPlan = null;
      }
    }
  }

  return buildItineraryPipeline({
    cityIds,
    tripDays: days,
    catalog,
    citiesMeta,
    aiPlan,
    userNotes,
    entryCityId,
    exitCityId,
    startDateLocal,
  });
}

type ScenarioCache = { aiSystemPrompt: string | null; responseMode: string };
const _scenarioCache = new Map<string, { value: ScenarioCache | null; cachedAt: number }>();
const SCENARIO_TTL_MS = 10 * 60 * 1000;

async function loadAssistantScenario(
  scenarioId: string,
): Promise<ScenarioCache | null> {
  const now = Date.now();
  const cached = _scenarioCache.get(scenarioId);
  if (cached && now - cached.cachedAt < SCENARIO_TTL_MS) {
    return cached.value;
  }

  const url = Deno.env.get("SUPABASE_URL");
  const key =
    Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? Deno.env.get("SUPABASE_ANON_KEY");
  if (!url || !key) return null;

  try {
    const res = await fetch(
      `${url}/rest/v1/assistant_scenarios?id=eq.${encodeURIComponent(scenarioId)}&select=ai_system_prompt,response_mode&limit=1`,
      {
        headers: {
          apikey: key,
          Authorization: `Bearer ${key}`,
        },
      },
    );
    if (!res.ok) {
      _scenarioCache.set(scenarioId, { value: null, cachedAt: now });
      return null;
    }
    const rows = await res.json();
    if (!Array.isArray(rows) || rows.length === 0) {
      _scenarioCache.set(scenarioId, { value: null, cachedAt: now });
      return null;
    }
    const row = rows[0] as Record<string, unknown>;
    const value: ScenarioCache = {
      aiSystemPrompt: row.ai_system_prompt
        ? String(row.ai_system_prompt).trim() || null
        : null,
      responseMode: String(row.response_mode ?? "ai"),
    };
    _scenarioCache.set(scenarioId, { value, cachedAt: now });
    return value;
  } catch {
    return null;
  }
}

async function handleAssistantChat(
  body: Record<string, unknown>,
  ai: AISettings,
) {
  const message = String(body.message ?? "").trim();
  const scenarioId = body.scenarioId ?? body.scenario_id
    ? String(body.scenarioId ?? body.scenario_id)
    : undefined;
  const history = normalizeHistory(body.history);

  if (!message) {
    return jsonResponse({ code: 400, error: "message is required" }, 400);
  }

  const scenario = scenarioId ? await loadAssistantScenario(scenarioId) : null;
  if (scenario?.responseMode === "offline") {
    return jsonResponse({
      code: 200,
      text:
        "This topic uses offline help in the app. Open Emergency from Home if you need immediate assistance.",
    });
  }

  const scenarioHint = scenarioId
    ? `The user tapped quick-help topic "${scenarioId}". Tailor your answer to that topic when relevant.`
    : "";

  const scenarioPrompt = scenario?.aiSystemPrompt?.trim() ?? "";
  const globalPrompt = ai.systemPromptAssistant?.trim() ?? "";

  let systemPrompt: string;
  if (scenarioPrompt && globalPrompt) {
    systemPrompt = `${globalPrompt}\n\n${scenarioPrompt}`;
  } else if (scenarioPrompt) {
    systemPrompt = scenarioPrompt;
  } else if (globalPrompt) {
    systemPrompt = `${globalPrompt}${scenarioHint ? ` ${scenarioHint}` : ""}`;
  } else {
    systemPrompt = defaultAssistantSystemPrompt(scenarioHint);
  }

  const messages: ChatMessage[] = [
    { role: "system", content: systemPrompt },
    ...history,
    { role: "user", content: message },
  ];

  const text =
    (await chatCompletion({
      messages,
      maxTokens: ai.chatMaxTokens,
      temperature: ai.temperature,
      modelId: ai.modelId,
      apiUrl: ai.apiUrl,
      timeoutMs: ai.timeoutMs,
    })) ??
    "I'm here to help with your China trip. Please try again in a moment, or use the quick-help chips above.";

  return jsonResponse({ code: 200, text });
}

async function handleItinerary(
  body: Record<string, unknown>,
  ai: AISettings,
) {
  const cities = Array.isArray(body.cities)
    ? body.cities.map((c) => String(c).trim().toLowerCase()).filter(Boolean)
    : [];
  const days = Math.max(1, Math.min(Number(body.days) || 7, 21));
  const userNotes = String(body.userNotes ?? body.user_notes ?? "").trim();
  const entryCityId = body.entry_city_id ? String(body.entry_city_id).trim().toLowerCase() : null;
  const exitCityId = body.exit_city_id ? String(body.exit_city_id).trim().toLowerCase() : null;
  const startDateLocal = body.start_date ? String(body.start_date).trim() : null;

  const cityIds = cities.length ? cities : ["beijing"];
  const creds = supabaseHeaders();
  const catalog = await fetchAttractionsForCities(cityIds);
  const citiesMeta = await fetchCitiesMeta(cityIds, creds);
  const plan = buildDayPlan(days, catalog);

  const cmsPrompt = ai.systemPromptItinerary?.trim();
  const baseSystem = cmsPrompt ||
    defaultItinerarySystemPrompt(days, AI_PLAN_JSON_SCHEMA);
  const systemPrompt = `${baseSystem}\n\n${ITINERARY_HARD_CONSTRAINTS}`;

  const userPrompt = buildItineraryUserPrompt({
    cities: cityIds,
    days,
    userNotes,
    catalog,
    plan,
    citiesMeta,
    travelContext: buildTravelContext(cityIds),
  });

  const raw =
    (await chatCompletion({
      messages: [
        { role: "system", content: systemPrompt },
        { role: "user", content: userPrompt },
      ],
      maxTokens: ai.itineraryMaxTokens,
      temperature: ai.temperature,
      modelId: ai.modelId,
      apiUrl: ai.apiUrl,
      timeoutMs: ai.timeoutMs,
    })) ?? "";

  const hasAI = Boolean(raw.trim());
  const itinerary = await buildItineraryFromAI(
    cityIds,
    days,
    userNotes,
    hasAI ? raw : null,
    citiesMeta,
    entryCityId,
    exitCityId,
    startDateLocal,
  );

  return jsonResponse({
    code: 200,
    itinerary,
    entry_city_id: entryCityId,
    exit_city_id: exitCityId,
    is_default: !hasAI,
  });
}

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const body = await req.json().catch(() => ({}));
    const type = String(body.type ?? "");
    console.log("ai-complete invoke", { type, hasMessage: Boolean(body.message) });
    const ai = await loadAISettingsFromCMS();

    switch (type) {
      case "assistant_chat":
        return await handleAssistantChat(body, ai);
      case "itinerary":
        return await handleItinerary(body, ai);
      default:
        return jsonResponse(
          { code: 400, error: "Unknown type. Use assistant_chat or itinerary." },
          400,
        );
    }
  } catch (err) {
    console.error("ai-complete error:", err);
    return jsonResponse(
      {
        code: 500,
        error: err instanceof Error ? err.message : "Internal error",
      },
      500,
    );
  }
});
