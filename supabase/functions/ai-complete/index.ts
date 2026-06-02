import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import {
  defaultAssistantSystemPrompt,
  defaultItinerarySystemPrompt,
  loadAISettingsFromCMS,
  type AISettings,
} from "../_shared/ai-settings.ts";
import {
  AI_PLAN_JSON_SCHEMA,
  assembleItinerary,
  assignExperienceCities,
  buildDayPlan,
  dedupeAssignmentIds,
  deterministicAssignments,
  fetchAttractionsForCities,
  parseAIPlanResponse,
  type AttractionRow,
  type SampleItinerary,
} from "../_shared/itinerary-assembler.ts";
import {
  chatCompletion,
  streamChatCompletion,
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
  experienceDaySpecs: { day_index: number; city_id: string }[];
}): string {
  const catalogCompact = params.catalog.map((a) => ({
    id: a.id,
    city_id: a.city_id,
    name: a.name,
    recommended_duration: a.recommended_duration,
    summary: a.summary ? a.summary.slice(0, 160) : null,
  }));

  return (
    `Plan a ${params.days}-day China trip.\n` +
    `Cities in visit order: ${params.cities.join(", ") || "beijing"}\n` +
    (params.userNotes ? `User preferences: ${params.userNotes}\n` : "") +
    `\nAttraction catalog (ONLY these ids are valid):\n` +
    `${JSON.stringify(catalogCompact)}\n` +
    `\nAttraction days (assign 1–${params.plan.maxPerDay} attraction_ids per day, no duplicates): ` +
    `${JSON.stringify(params.plan.attractionDayIndices)}\n` +
    `Experience suggestion days (generic titles only, no venues): ` +
    `${JSON.stringify(params.experienceDaySpecs)}\n` +
    `Return JSON only with assignments and experience_days.`
  );
}

async function buildItineraryFromAI(
  cities: string[],
  days: number,
  userNotes: string,
  aiPlanRaw: string | null,
): Promise<SampleItinerary> {
  const cityIds = cities.length ? cities : ["beijing"];
  const catalog = await fetchAttractionsForCities(cityIds);
  const plan = buildDayPlan(days, catalog);
  const experienceDaySpecs = assignExperienceCities(
    plan.experienceDaySpecs,
    cityIds,
  );

  const deterministic = deterministicAssignments(plan, catalog);
  let assignments = deterministic;
  let experienceDays = experienceDaySpecs.map((spec) => ({
    day_index: spec.day_index,
    city_id: spec.city_id,
    items: [] as string[],
  }));

  let title: string | undefined;
  let estimatedBudget: string | undefined;

  if (aiPlanRaw) {
    const jsonStr = extractJsonObject(aiPlanRaw);
    if (jsonStr) {
      try {
        const parsed = parseAIPlanResponse(JSON.parse(jsonStr));
        if (parsed) {
          const catalogById = new Map(catalog.map((a) => [a.id, a]));
          if (parsed.assignments?.length) {
            const aiAssignments = dedupeAssignmentIds(
              parsed.assignments,
              catalogById,
            );
            assignments = plan.attractionDayIndices.map((dayIndex) => {
              const ai = aiAssignments.find((a) => a.day_index === dayIndex);
              const det = deterministic.find((a) => a.day_index === dayIndex);
              const ids = (ai?.attraction_ids?.length
                ? ai.attraction_ids
                : det?.attraction_ids) ?? [];
              return { day_index: dayIndex, attraction_ids: ids };
            });
          }
          if (parsed.experience_days?.length) {
            experienceDays = experienceDaySpecs.map((spec) => {
              const ai = parsed.experience_days?.find((e) =>
                e.day_index === spec.day_index
              );
              return {
                day_index: spec.day_index,
                city_id: ai?.city_id || spec.city_id,
                items: ai?.items?.length ? ai.items : [],
              };
            });
          }
          title = parsed.title;
          estimatedBudget = parsed.estimated_budget;
        }
      } catch {
        // use deterministic assignments
      }
    }
  }

  return assembleItinerary({
    cities: cityIds,
    tripDays: days,
    catalog,
    plan: { ...plan, experienceDaySpecs },
    assignments,
    experienceDays,
    userNotes,
    title,
    estimatedBudget,
  });
}

async function loadAssistantScenario(
  scenarioId: string,
): Promise<{ aiSystemPrompt: string | null; responseMode: string } | null> {
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
    if (!res.ok) return null;
    const rows = await res.json();
    if (!Array.isArray(rows) || rows.length === 0) return null;
    const row = rows[0] as Record<string, unknown>;
    return {
      aiSystemPrompt: row.ai_system_prompt
        ? String(row.ai_system_prompt).trim() || null
        : null,
      responseMode: String(row.response_mode ?? "ai"),
    };
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

  const cityIds = cities.length ? cities : ["beijing"];
  const catalog = await fetchAttractionsForCities(cityIds);
  const plan = buildDayPlan(days, catalog);
  const experienceDaySpecs = assignExperienceCities(
    plan.experienceDaySpecs,
    cityIds,
  );

  const cmsPrompt = ai.systemPromptItinerary?.trim();
  const systemPrompt = cmsPrompt ||
    defaultItinerarySystemPrompt(days, AI_PLAN_JSON_SCHEMA);

  const userPrompt = buildItineraryUserPrompt({
    cities: cityIds,
    days,
    userNotes,
    catalog,
    plan,
    experienceDaySpecs,
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
  );

  return jsonResponse({
    code: 200,
    itinerary,
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
