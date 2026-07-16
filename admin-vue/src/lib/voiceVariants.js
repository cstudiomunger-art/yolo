import { supabase } from "@/lib/supabase";
import { slugify } from "@/lib/storage";

/** Load voice variants for an owner (admin: includes inactive rows). */
export async function fetchVoiceVariants(ownerType, ownerId) {
  if (!ownerId) return [];
  const { data, error } = await supabase
    .from("audio_voice_variants")
    .select("*")
    .eq("owner_type", ownerType)
    .eq("owner_id", ownerId)
    .order("is_default", { ascending: false })
    .order("sort_order", { ascending: true })
    .order("voice_label", { ascending: true });
  if (error) throw error;
  return data || [];
}

async function fetchParentAudio(ownerType, ownerId) {
  if (ownerType === "audio_guide") {
    const { data, error } = await supabase
      .from("audio_guides")
      .select("audio_url, duration_seconds, segments, is_active")
      .eq("id", ownerId)
      .maybeSingle();
    if (error) throw error;
    return data
      ? {
          audio_url: data.audio_url,
          duration_seconds: data.duration_seconds,
          segments: data.segments,
          is_active: data.is_active,
        }
      : null;
  }
  if (ownerType === "sub_area") {
    const { data, error } = await supabase
      .from("sub_areas")
      .select("audio_url, is_active")
      .eq("id", ownerId)
      .maybeSingle();
    if (error) throw error;
    return data
      ? { audio_url: data.audio_url, duration_seconds: 0, segments: [], is_active: data.is_active }
      : null;
  }
  if (ownerType === "city_guide") {
    const { data, error } = await supabase
      .from("city_guides")
      .select("audio_url, audio_duration_seconds, is_published")
      .eq("id", ownerId)
      .maybeSingle();
    if (error) throw error;
    return data
      ? {
          audio_url: data.audio_url,
          duration_seconds: data.audio_duration_seconds,
          segments: [],
          is_active: data.is_published,
        }
      : null;
  }
  return null;
}

function legacyVariantId(ownerType, ownerId) {
  if (ownerType === "audio_guide") return `avv_ag_${ownerId}`;
  if (ownerType === "sub_area") return `avv_sa_${ownerId}`;
  return `avv_cg_${ownerId}`;
}

/**
 * If the parent row already has audio_url but no variant rows yet, import it as the
 * default voice (same ids as migration 096 backfill).
 */
export async function ensureLegacyVoiceVariants(ownerType, ownerId) {
  const existing = await fetchVoiceVariants(ownerType, ownerId);
  if (existing.length > 0) return existing;

  const parent = await fetchParentAudio(ownerType, ownerId);
  const url = String(parent?.audio_url || "").trim();
  if (!url) return [];

  const payload = {
    id: legacyVariantId(ownerType, ownerId),
    owner_type: ownerType,
    owner_id: ownerId,
    voice_label: "默认",
    audio_url: url,
    duration_seconds: Number(parent.duration_seconds) || 0,
    segments: parent.segments || [],
    sort_order: 0,
    is_default: true,
    is_active: parent.is_active !== false,
  };
  const { error } = await supabase.from("audio_voice_variants").upsert(payload);
  if (error) throw error;
  return fetchVoiceVariants(ownerType, ownerId);
}

async function updateParentAudio(ownerType, ownerId, patch) {
  const table =
    ownerType === "audio_guide" ? "audio_guides"
      : ownerType === "sub_area" ? "sub_areas"
        : ownerType === "city_guide" ? "city_guides"
          : null;
  if (!table) throw new Error(`不支持的音色归属类型：${ownerType}`);
  const { error } = await supabase.from(table).update(patch).eq("id", ownerId);
  if (error) throw error;
}

/**
 * Mirror the default variant back onto the parent row (legacy App + has_audio columns).
 * @returns {Promise<string>} mirrored audio_url (empty string when no active default)
 */
export async function syncParentAudioFromDefault(ownerType, ownerId) {
  const { data: variants, error } = await supabase
    .from("audio_voice_variants")
    .select("*")
    .eq("owner_type", ownerType)
    .eq("owner_id", ownerId)
    .eq("is_active", true)
    .order("is_default", { ascending: false })
    .order("sort_order", { ascending: true });
  if (error) throw error;

  const list = variants || [];
  const def = list.find((v) => v.is_default) || list[0];
  const now = new Date().toISOString();
  if (!def) {
    if (ownerType === "audio_guide") {
      await updateParentAudio(ownerType, ownerId, {
        audio_url: "",
        duration_seconds: 0,
        segments: [],
        updated_at: now,
      });
    } else if (ownerType === "sub_area") {
      await updateParentAudio(ownerType, ownerId, {
        audio_url: "",
        updated_at: now,
      });
    } else if (ownerType === "city_guide") {
      await updateParentAudio(ownerType, ownerId, {
        audio_url: "",
        audio_duration_seconds: 0,
        updated_at: now,
      });
    }
    return "";
  }

  const audioUrl = String(def.audio_url || "").trim();
  if (ownerType === "audio_guide") {
    await updateParentAudio(ownerType, ownerId, {
      audio_url: audioUrl,
      duration_seconds: def.duration_seconds || 0,
      segments: def.segments || [],
      updated_at: now,
    });
  } else if (ownerType === "sub_area") {
    await updateParentAudio(ownerType, ownerId, {
      audio_url: audioUrl,
      updated_at: now,
    });
  } else if (ownerType === "city_guide") {
    await updateParentAudio(ownerType, ownerId, {
      audio_url: audioUrl,
      audio_duration_seconds: def.duration_seconds || 0,
      updated_at: now,
    });
  }
  return audioUrl;
}

export async function setDefaultVariant(variantId, ownerType, ownerId) {
  await supabase
    .from("audio_voice_variants")
    .update({ is_default: false })
    .eq("owner_type", ownerType)
    .eq("owner_id", ownerId);
  const { error } = await supabase
    .from("audio_voice_variants")
    .update({ is_default: true, updated_at: new Date().toISOString() })
    .eq("id", variantId);
  if (error) throw error;
  await syncParentAudioFromDefault(ownerType, ownerId);
}

export function newVariantId(ownerType, ownerId, voiceLabel) {
  const slug = slugify(voiceLabel, "");
  const unique = Date.now().toString(36) + Math.random().toString(36).slice(2, 6);
  const part = slug && /[a-z0-9]/.test(slug) ? `${slug}_${unique}` : `l${unique}`;
  const typeShort = ownerType.replace(/_/g, "");
  return `avv_${typeShort}_${ownerId}_${part}`.slice(0, 120);
}

/** Case-sensitive trimmed label match within the same owner. */
export function hasDuplicateVoiceLabel(variants, label, exceptId = null) {
  const normalized = String(label || "").trim();
  if (!normalized) return false;
  return variants.some(
    (v) => v.id !== exceptId && String(v.voice_label || "").trim() === normalized
  );
}

export function duplicateVoiceLabelMessage(label) {
  return `音色名称「${label}」已存在，请换一个名称`;
}

export function readAudioDuration(file) {
  return new Promise((resolve) => {
    const a = document.createElement("audio");
    a.preload = "metadata";
    a.onloadedmetadata = () => {
      resolve(Math.round(a.duration) || 0);
      URL.revokeObjectURL(a.src);
    };
    a.onerror = () => resolve(0);
    a.src = URL.createObjectURL(file);
  });
}
