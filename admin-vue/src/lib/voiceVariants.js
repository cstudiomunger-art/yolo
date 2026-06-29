import { supabase } from "@/lib/supabase";
import { slugify } from "@/lib/storage";

/** Load active voice variants for an owner, ordered for display. */
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

/** Mirror the default variant back onto the parent row (legacy App + has_audio columns). */
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
  if (!def) {
    if (ownerType === "audio_guide") {
      await supabase.from("audio_guides").update({
        audio_url: "",
        duration_seconds: 0,
        segments: [],
        updated_at: new Date().toISOString(),
      }).eq("id", ownerId);
    } else if (ownerType === "sub_area") {
      await supabase.from("sub_areas").update({
        audio_url: "",
        updated_at: new Date().toISOString(),
      }).eq("id", ownerId);
    } else if (ownerType === "city_guide") {
      await supabase.from("city_guides").update({
        audio_url: "",
        audio_duration_seconds: 0,
        updated_at: new Date().toISOString(),
      }).eq("id", ownerId);
    }
    return;
  }

  if (ownerType === "audio_guide") {
    await supabase.from("audio_guides").update({
      audio_url: def.audio_url,
      duration_seconds: def.duration_seconds || 0,
      segments: def.segments || [],
      updated_at: new Date().toISOString(),
    }).eq("id", ownerId);
  } else if (ownerType === "sub_area") {
    await supabase.from("sub_areas").update({
      audio_url: def.audio_url,
      updated_at: new Date().toISOString(),
    }).eq("id", ownerId);
  } else if (ownerType === "city_guide") {
    await supabase.from("city_guides").update({
      audio_url: def.audio_url,
      audio_duration_seconds: def.duration_seconds || 0,
      updated_at: new Date().toISOString(),
    }).eq("id", ownerId);
  }
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
  const slug = slugify(voiceLabel, "v");
  return `avv_${ownerType.replace("_", "")}_${ownerId}_${slug}`.slice(0, 120);
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
