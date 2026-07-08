import { supabase } from "@/lib/supabase";

export const COVER_BUCKET = "cover-images";
export const AUDIO_BUCKET = "audio-guides";
export const AVATARS_BUCKET = "avatars";

/** Slugify identical to legacy core.js App.slugify. */
export function slugify(text, prefix) {
  const part = String(text || "")
    .toLowerCase()
    .normalize("NFD")
    .replace(/[̀-ͯ]/g, "")
    .replace(/[^a-z0-9]+/g, "_")
    .replace(/^_+|_+$/g, "");
  if (prefix) return `${prefix}_${part}`.replace(/__+/g, "_");
  return part || "item";
}

function normalizeAudioContentType(file) {
  const ext = (file.name.split(".").pop() || "").toLowerCase();
  const byExt = {
    mp3: "audio/mpeg",
    m4a: "audio/mp4",
    mp4: "audio/mp4",
    wav: "audio/wav",
    aac: "audio/aac",
  };
  return byExt[ext] || file.type || "audio/mpeg";
}

export async function uploadStorageFile(bucket, path, file, contentType) {
  const ct = contentType || file.type || "application/octet-stream";
  const { error } = await supabase.storage
    .from(bucket)
    .upload(path, file, { upsert: true, contentType: ct });
  if (error) {
    throw new Error(`上传到 ${bucket} 失败：${error.message}（请确认账号在 admin_users 且已建好 Storage 桶/策略）`);
  }
  const { data } = supabase.storage.from(bucket).getPublicUrl(path);
  return data.publicUrl;
}

/** Resolve cover_image_path for preview: full URL passthrough, relative → public Storage URL. */
export function resolveCoverImageUrl(raw, bucket = COVER_BUCKET) {
  const trimmed = String(raw ?? "").trim();
  if (!trimmed) return "";

  if (/^https?:\/\//i.test(trimmed)) return trimmed;

  let path = trimmed;
  const prefix = `${bucket}/`;
  if (path.startsWith(prefix)) path = path.slice(prefix.length);
  path = path.replace(/^\/+/, "");
  if (!path) return "";

  const { data } = supabase.storage.from(bucket).getPublicUrl(path);
  return data.publicUrl;
}

/** Cover image → cover-images/{folder}/{entityId}.{ext} */
export async function uploadCoverImage(file, folder, entityId) {
  const ext = (file.name.split(".").pop() || "jpg").toLowerCase();
  const path = `${folder}/${entityId}.${ext}`;
  return uploadStorageFile(COVER_BUCKET, path, file, file.type || "image/jpeg");
}

/** Gallery / inline image → cover-images/{folder}/{entityId}/{key}.{ext} */
export async function uploadGalleryImage(file, folder, entityId, uniqueKey) {
  const ext = (file.name.split(".").pop() || "jpg").toLowerCase();
  const safeKey = String(uniqueKey || Date.now())
    .replace(/[^a-zA-Z0-9_-]/g, "_")
    .slice(0, 64);
  const path = `${folder}/${entityId}/${safeKey}.${ext}`;
  return uploadStorageFile(COVER_BUCKET, path, file, file.type || "image/jpeg");
}

/** Audio guide → audio-guides/{guideId}.{ext} */
export async function uploadAudioGuideFile(file, guideId) {
  const ext = (file.name.split(".").pop() || "m4a").toLowerCase().replace(/[^a-z0-9]/g, "") || "m4a";
  return uploadStorageFile(AUDIO_BUCKET, `${guideId}.${ext}`, file, normalizeAudioContentType(file));
}

/** Sub-area audio → audio-guides/sub-areas/{subAreaId}.{ext} */
export async function uploadSubAreaAudioFile(file, subAreaId) {
  if (!subAreaId) throw new Error("请先填写子区域英文名后再上传音频");
  const ext = (file.name.split(".").pop() || "m4a").toLowerCase().replace(/[^a-z0-9]/g, "") || "m4a";
  return uploadStorageFile(AUDIO_BUCKET, `sub-areas/${subAreaId}.${ext}`, file, normalizeAudioContentType(file));
}

/** City-guide audio → audio-guides/city-guides/{guideId}.{ext} */
export async function uploadCityGuideAudioFile(file, guideId) {
  if (!guideId) throw new Error("请先填写指南英文标题后再上传音频");
  const ext = (file.name.split(".").pop() || "m4a").toLowerCase().replace(/[^a-z0-9]/g, "") || "m4a";
  return uploadStorageFile(AUDIO_BUCKET, `city-guides/${guideId}.${ext}`, file, normalizeAudioContentType(file));
}

/** Voice variant → audio-guides/voices/{ownerType}/{ownerId}/{variantId}.{ext} */
export async function uploadVoiceVariantFile(file, ownerType, ownerId, variantId) {
  if (!ownerId) throw new Error("请先保存记录并填写 ID 后再上传音频");
  if (!variantId) throw new Error("缺少音色 ID");
  const ext = (file.name.split(".").pop() || "m4a").toLowerCase().replace(/[^a-z0-9]/g, "") || "m4a";
  const path = `voices/${ownerType}/${ownerId}/${variantId}.${ext}`;
  return uploadStorageFile(AUDIO_BUCKET, path, file, normalizeAudioContentType(file));
}

/** Phrase audio → audio-guides/phrases/{id}.{ext} */
export async function uploadPhraseAudioFile(file, phraseId) {
  if (!phraseId) throw new Error("请先填写内容（生成 id）后再上传音频");
  const ext = (file.name.split(".").pop() || "m4a").toLowerCase().replace(/[^a-z0-9]/g, "") || "m4a";
  return uploadStorageFile(AUDIO_BUCKET, `phrases/${phraseId}.${ext}`, file, normalizeAudioContentType(file));
}

// ═══════════════════════════════════════════════════════════════
// Avatar Upload Functions
// ═══════════════════════════════════════════════════════════════

/** User avatar → avatars/{userId}.{ext} */
export async function uploadUserAvatar(file, userId) {
  if (!userId) throw new Error("用户 ID 不能为空");
  const ext = (file.name.split(".").pop() || "jpg").toLowerCase();
  return uploadStorageFile(AVATARS_BUCKET, `${userId}.${ext}`, file, file.type || "image/jpeg");
}

/** Support agent avatar → avatars/agents/{agentId}.{ext} */
export async function uploadAgentAvatar(file, agentId) {
  if (!agentId) throw new Error("客服 ID 不能为空");
  const ext = (file.name.split(".").pop() || "jpg").toLowerCase();
  return uploadStorageFile(AVATARS_BUCKET, `agents/${agentId}.${ext}`, file, file.type || "image/jpeg");
}
