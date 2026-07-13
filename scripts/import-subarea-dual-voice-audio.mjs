#!/usr/bin/env node
/**
 * Import dual-voice sub-area audio (Cleo + Milo, source files A_EN_Benedict_/A_EN_Blanchett_) from nested folder structure.
 *
 * Usage:
 *   node scripts/import-subarea-dual-voice-audio.mjs --root "/path" --dry-run
 *   node scripts/import-subarea-dual-voice-audio.mjs --root "/path" --apply
 */
import { createClient } from "@supabase/supabase-js";
import { existsSync, mkdirSync, readFileSync, readdirSync, statSync, writeFileSync } from "fs";
import { join } from "path";

const ROOT = "/Users/vesperal/Desktop/YOLO";
const OUT_DIR = join(ROOT, "scripts/generated");
const OUT_CONFIRM = join(OUT_DIR, "dual_voice_audio_confirm.md");
const OUT_REPORT = join(OUT_DIR, "dual_voice_audio_report.json");
const AUDIO_BUCKET = "audio-guides";
const EXCLUDED_ATTRACTION_IDS = new Set(["chongqing_jiujie"]);

const VOICES = {
  Benedict: { label: "Cleo", sortOrder: 0, isDefault: true, suffix: "benedict" },
  Blanchett: { label: "Milo", sortOrder: 1, isDefault: false, suffix: "blanchett" },
};

const CITY_FOLDER_TO_ID = {
  上海: "shanghai",
  北京: "beijing",
  南京: "nanjing",
  成都: "chengdu",
  杭州: "hangzhou",
  苏州: "suzhou",
  重庆: "chongqing",
};

const FOLDER_ALIASES_BY_CITY = {
  suzhou: {
    留园: "留园景区",
    沧浪亭: "沧浪亭景区",
    耦园: "耦园（又称藕园）",
    苏州环秀山庄: "环秀山庄",
  },
  shanghai: {
    徐家汇源: "徐家汇源景区",
  },
  chengdu: {
    成都熊猫基地: "大熊猫基地",
    成都大熊猫繁育研究基地: "大熊猫基地",
    熊猫基地: "大熊猫基地",
  },
};

const ATTRACTION_ALIASES = {
  国家博物馆: "国博",
  南京大屠杀纪念馆: "侵华日军南京大屠杀遇难同胞纪念馆",
  南京老门东: "老门东历史文化街区",
  "石臼湖（溧水境内）": "石臼湖",
  熊猫基地: "大熊猫基地",
  成都熊猫基地: "大熊猫基地",
  成都博物院: "成都博物馆",
  南京博物馆: "南京博物院",
  夫子庙: "南京夫子庙-秦淮河风光带",
  耦园: "耦园（又称藕园）",
  苏州环秀山庄: "环秀山庄",
  浙江省博物馆之江馆区: "浙江省博物馆",
  "浙江省博物馆（之江馆区）": "浙江省博物馆",
  丝绸博物馆: "中国丝绸博物馆",
  良渚古城: "良渚古城遗址公园",
  河坊街: "河坊街（清河坊历史街区）",
  大运河拱宸桥景区: "大运河拱宸桥",
  磁器口古镇: "磁器口",
  解放碑: "解放碑广场",
  "解放碑-八一好吃街": "解放碑",
  苏州十二国色: "苏州河十二国色",
  武隆喀斯特旅游区: "武隆喀斯特",
};

const MANUAL_HINT_TO_ZH = {
  "Floor 1 — Riverside Entrance (Starting Point)": "层临江入口（起点）",
  "Floor 10 — Sky Public Corridor": "层空中公共连廊",
  "Yangtze Cable Car Frame Window": "长江索道同框观景窗",
  "Floor 15 — Jiefang East Road Exit (Final Stop)": "层解放东路出口（终点）",
  "Jiushigang Riverbank": "九石缸河滩",
  "Tianlong Bridge": "天龙桥",
  "Tianfu Post Station": "天官赐福",
  "Qinglong Bridge": "青龙桥",
  "Shenying Tiankeng": "神鹰天坑",
  "Heilong Bridge": "黑龙桥",
  "Longquan Cave": "龙泉洞",
  "Longshuixia Slot Canyon": "龙水峡地缝",
  "Milky Way Falls": "银河飞瀑",
  "Jiaolong Cold Cave": "蛟龙寒窟",
  "Muti Station": "仙女山国家公园-木梯子站",
  "Grand Grassland Station": "仙女山国家公园-大草原站",
  "Jiefangbei Square": "解放碑广场",
  "Monument to the Liberation of the People": "解放碑纪念碑",
  "Jiefangbei Pedestrian Street Sculpture Group": "解放碑步行街雕塑群",
  "Zouronglu Pedestrian Street": "邹容路步行街",
  "Bayi Road Snack Street": "八一路好吃街",
  "WFC Huixian Tower Observation Deck": "环球金融中心会仙楼观景台",
  "North Station (Xinhua Road, Yuzhong District)": "北站（渝中区新华路站）",
  "The Cabin": "索道轿厢",
  "South Station (Longmenghao, Nan'an District)": "南站（南岸区龙门浩站）",
  "Floor 8 — Zone 78 Trendy Play World (Upper Level)": "八楼：78 区潮玩世界",
  "Floor 7 — Zone 78 Trendy Play World (Lower Level)": "七楼：78 区潮玩世界",
};

const SKIP_HINTS = /^(Welcome|Closing|结束语|Closing Words|Closing Remarks)/i;
const SKIP_FOLDER = /结束语|结束（|结束$/;
const SUB_FOLDER_RE_SIMPLE = /^(\d{1,2})_(.+)$/;
const SUB_FOLDER_RE_COMPOUND = /^(.+)-(\d{1,2})_(.+)$/;
const VOICE_FILE_RE = /^A_EN_(Benedict|Blanchett)_/i;

const args = process.argv.slice(2);
const dryRun = args.includes("--dry-run") || !args.includes("--apply");

function argValue(flag) {
  const i = args.indexOf(flag);
  return i >= 0 && args[i + 1] ? args[i + 1] : "";
}

const sourceRoot = argValue("--root");
const cityFilter = argValue("--city");

if (!sourceRoot) {
  console.error(
    "Usage: node scripts/import-subarea-dual-voice-audio.mjs --root <path> [--city 上海] [--dry-run|--apply]"
  );
  process.exit(1);
}

function readXcconfigValue(path, key) {
  const text = readFileSync(path, "utf8");
  const line = text.split(/\r?\n/).find((it) => it.trim().startsWith(`${key} =`));
  if (!line) return "";
  return line.split("=").slice(1).join("=").replace(/\$\(\)/g, "").trim();
}

function loadServiceKey() {
  if (process.env.SUPABASE_SERVICE_ROLE_KEY) return process.env.SUPABASE_SERVICE_ROLE_KEY;
  const tmp = join(ROOT, ".env.local.tmp");
  try {
    const m = readFileSync(tmp, "utf8").match(/SUPABASE_SERVICE_ROLE_KEY\s*=\s*"?([^"\n]+)"?/);
    if (m?.[1]) return m[1].trim();
  } catch {
    /* optional */
  }
  return "";
}

function getSupabaseConfig() {
  const xcPath = join(ROOT, "Secrets.xcconfig");
  const url = (process.env.SUPABASE_URL || readXcconfigValue(xcPath, "SUPABASE_URL")).replace(/\$\(\)/g, "");
  const key =
    loadServiceKey() ||
    process.env.SUPABASE_ANON_KEY ||
    readXcconfigValue(xcPath, "SUPABASE_ANON_KEY");
  if (!url || !key) throw new Error("缺少 SUPABASE_URL 或 key");
  return { url, key, usesServiceRole: Boolean(loadServiceKey()) };
}

function createSupabase() {
  const { url, key } = getSupabaseConfig();
  return createClient(url, key, { auth: { persistSession: false, autoRefreshToken: false } });
}

async function rest(path, init = {}) {
  const { url, key } = getSupabaseConfig();
  let lastErr;
  for (let attempt = 0; attempt < 3; attempt += 1) {
    try {
      const res = await fetch(`${url}${path}`, {
        ...init,
        headers: { apikey: key, Authorization: `Bearer ${key}`, ...(init.headers || {}) },
      });
      if (!res.ok) throw new Error(`${path} -> ${res.status} ${await res.text()}`);
      return res;
    } catch (err) {
      lastErr = err;
      if (attempt < 2) await new Promise((r) => setTimeout(r, 1000 * (attempt + 1)));
    }
  }
  throw lastErr;
}

function onlyDirs(path) {
  if (!existsSync(path)) return [];
  return readdirSync(path).filter((n) => {
    try {
      return statSync(join(path, n)).isDirectory() && !n.startsWith(".");
    } catch {
      return false;
    }
  });
}

function parseNameHint(filename) {
  const m = filename.match(/_\d+\.(.+?)\.mp3$/i);
  return m ? m[1].trim() : "";
}

function parseVoiceKey(filename) {
  const m = filename.match(VOICE_FILE_RE);
  if (!m) return null;
  const key = m[1];
  return key.charAt(0).toUpperCase() + key.slice(1).toLowerCase();
}

function normalizeName(value) {
  return String(value || "")
    .replace(/[（(].*?[）)]/g, "")
    .replace(/[·\-—–、，,。.\s]/g, "")
    .toLowerCase();
}

function normalizeEn(value) {
  return String(value || "")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, " ")
    .trim();
}

function hasCjk(text) {
  return /[\u3400-\u9fff]/.test(text);
}

function tokenizeEn(text) {
  return normalizeEn(text).split(/\s+/).filter((w) => w.length > 2);
}

function scoreMatch(hint, subArea, folderNameZh = "") {
  const manualZh = MANUAL_HINT_TO_ZH[hint];
  if (manualZh && String(subArea.name_zh || "").includes(manualZh.replace(/[（(].*$/, ""))) return 100;

  if (folderNameZh) {
    const fn = normalizeName(folderNameZh);
    const zh = normalizeName(subArea.name_zh);
    if (fn && zh) {
      if (fn === zh) return 98;
      if (zh.includes(fn) || fn.includes(zh)) return 90;
    }
  }

  const zh = normalizeName(subArea.name_zh);
  const en = normalizeEn(subArea.name_en);
  const h = hasCjk(hint) ? normalizeName(hint) : normalizeEn(hint);
  if (!h) return 0;

  if (hasCjk(hint) && zh) {
    if (h === zh) return 100;
    if (zh.includes(h) || h.includes(zh)) return 85;
    const h4 = h.slice(0, 4);
    const z4 = zh.slice(0, 4);
    if (h4.length >= 3 && h4 === z4) return 65;
    let overlap = 0;
    for (let i = 0; i < Math.min(h.length, zh.length); i++) {
      if (h[i] === zh[i]) overlap++;
    }
    return overlap >= 4 ? 45 : 0;
  }

  const hw = tokenizeEn(hint);
  const ew = tokenizeEn(subArea.name_en);
  if (ew.length) {
    const overlap = hw.filter((w) => ew.some((x) => x.includes(w) || w.includes(x)));
    if (overlap.length >= 3) return 95;
    if (overlap.length >= 2) return 85;
    if (overlap.length === 1) return 55;
  }

  const zhParts = String(subArea.name_zh || "")
    .split(/[·\-—–]/)
    .map((p) => normalizeName(p))
    .filter(Boolean);
  for (const part of zhParts) {
    const overlap = hw.filter((w) => part.includes(w.slice(0, 4)) || w.length >= 5);
    if (overlap.length >= 2) return 75;
  }

  if (en && (h.includes(en) || en.includes(h))) return 60;
  return 0;
}

function resolveAttraction(folderName, attractions, cityId) {
  const cityAliases = FOLDER_ALIASES_BY_CITY[cityId] || {};
  const lookup = cityAliases[folderName] || ATTRACTION_ALIASES[folderName] || folderName;
  const pool = attractions.filter((a) => a.city_id === cityId);
  const candidates = [
    lookup,
    folderName,
    folderName.replace(/子景点信息/g, "").replace(/景点信息/g, ""),
    folderName.replace(/^成都|^上海|^重庆|^南京|^杭州|^苏州/g, ""),
  ].filter(Boolean);

  for (const guess of candidates) {
    const exact = pool.find((a) => String(a.chinese_name || "").trim() === guess);
    if (exact) return exact;
  }
  for (const guess of candidates) {
    const fuzzy = pool
      .filter((a) => {
        const cn = String(a.chinese_name || "").trim();
        return cn.includes(guess) || guess.includes(cn);
      })
      .sort((a, b) => String(b.chinese_name || "").length - String(a.chinese_name || "").length);
    if (fuzzy.length) return fuzzy[0];
  }
  return null;
}

function parseSubFolder(folderName) {
  let m = folderName.match(SUB_FOLDER_RE_SIMPLE);
  if (m) {
    return {
      seq: Number(m[1]),
      folderNameZh: m[2].trim(),
      sortOrder: Number(m[1]) - 1,
      zonePrefix: "",
      isCompound: false,
    };
  }
  m = folderName.match(SUB_FOLDER_RE_COMPOUND);
  if (!m) return null;
  return {
    seq: Number(m[2]),
    folderNameZh: m[3].trim(),
    sortOrder: Number(m[2]) - 1,
    zonePrefix: m[1].trim(),
    isCompound: true,
  };
}

function variantId(subAreaId, suffix) {
  return `avv_sa_${subAreaId}_${suffix}`;
}

function storagePath(subAreaId, varId) {
  return `voices/sub_area/${subAreaId}/${varId}.mp3`;
}

function publicUrl(supabaseUrl, path) {
  return `${supabaseUrl}/storage/v1/object/public/${AUDIO_BUCKET}/${path}`;
}

function collectSubAreaEntries(attractionPath) {
  const entries = [];
  for (const subFolder of onlyDirs(attractionPath).sort((a, b) => a.localeCompare(b, "zh-Hans-CN"))) {
    if (SKIP_FOLDER.test(subFolder)) continue;
    const parsed = parseSubFolder(subFolder);
    if (!parsed) continue;
    const subPath = join(attractionPath, subFolder);
    const files = readdirSync(subPath).filter((n) => n.toLowerCase().endsWith(".mp3"));
    const voices = {};
    for (const file of files) {
      const voiceKey = parseVoiceKey(file);
      if (!voiceKey || !VOICES[voiceKey]) continue;
      voices[voiceKey] = { file, localPath: join(subPath, file), hint: parseNameHint(file) };
    }
    entries.push({
      subFolder,
      ...parsed,
      voices,
      relPath: subFolder,
    });
  }
  return entries;
}

function matchSubArea(entry, areas) {
  const seqPadded = String(entry.seq).padStart(2, "0");

  if (!entry.isCompound) {
    const byIdSuffix = areas.find((a) => a.id.endsWith(`_sa_${seqPadded}`));
    if (byIdSuffix) return { area: byIdSuffix, method: "id_suffix", score: 100 };

    const bySort = areas.find((a) => a.sort_order === entry.sortOrder);
    if (bySort) return { area: bySort, method: "sort_order", score: 100 };
  }

  if (entry.zonePrefix) {
    const raw = entry.zonePrefix.replace(/^大足石刻-?/, "").replace(/国家森林公园$/, "");
    const zp = normalizeName(raw);
    const zoneHits = areas.filter((a) => {
      const zh = normalizeName(a.name_zh);
      return zh.includes(zp) || zp.includes(zh);
    });
    if (zoneHits.length >= 1 && entry.seq === 1) {
      return { area: zoneHits[0], method: "zone_prefix", score: 95 };
    }
  }

  const hints = Object.values(entry.voices)
    .map((v) => v.hint)
    .filter(Boolean);
  const folderZh = entry.folderNameZh;
  let best = null;
  for (const area of areas) {
    for (const hint of hints.length ? hints : [folderZh]) {
      if (SKIP_HINTS.test(hint)) continue;
      const score = scoreMatch(hint, area, folderZh);
      if (!best || score > best.score) best = { area, score, hint, method: "name" };
    }
  }
  if (best && best.score >= 50) {
    const bestSuffix = best.area.id.match(/_sa_(\d+)$/)?.[1];
    if (bestSuffix && Number(bestSuffix) !== entry.seq) return null;
    return best;
  }
  return null;
}

async function withRetry(fn, label, attempts = 5) {
  let lastErr;
  for (let i = 0; i < attempts; i += 1) {
    try {
      return await fn();
    } catch (err) {
      lastErr = err;
      if (i < attempts - 1) await new Promise((r) => setTimeout(r, 2000 * (i + 1)));
    }
  }
  throw new Error(`${label}: ${lastErr?.message || lastErr}`);
}

async function uploadAudio(storagePathKey, localPath) {
  return withRetry(async () => {
    const body = readFileSync(localPath);
    await rest(`/storage/v1/object/${AUDIO_BUCKET}/${storagePathKey}`, {
      method: "POST",
      headers: { "x-upsert": "true", "content-type": "audio/mpeg" },
      body,
    });
    const { url } = getSupabaseConfig();
    return publicUrl(url, storagePathKey);
  }, `upload ${storagePathKey}`);
}

function storagePathFromPublicUrl(audioUrl) {
  const u = String(audioUrl || "").trim();
  if (!u) return "";
  const marker = `/storage/v1/object/public/${AUDIO_BUCKET}/`;
  const i = u.indexOf(marker);
  if (i < 0) return "";
  return decodeURIComponent(u.slice(i + marker.length).split("?")[0]);
}

function legacyStoragePaths(rec, existingVariants, previousAudioUrl) {
  const keep = new Set([rec.voices.Benedict?.storagePath, rec.voices.Blanchett?.storagePath].filter(Boolean));
  const paths = new Set();

  const addFromUrl = (url) => {
    const p = storagePathFromPublicUrl(url);
    if (p && !keep.has(p)) paths.add(p);
  };

  addFromUrl(previousAudioUrl);
  for (const v of existingVariants || []) addFromUrl(v.audio_url);

  const seqSuffix = rec.subAreaId.match(/_sa_(\d+)$/)?.[1];
  if (seqSuffix) {
    paths.add(`sub-areas/${rec.attractionId}_${String(Number(seqSuffix)).padStart(3, "0")}.mp3`);
    paths.add(`sub-areas/${rec.attractionId}_${seqSuffix.padStart(2, "0")}.mp3`);
  }
  paths.add(`sub-areas/${rec.subAreaId}.mp3`);
  paths.add(`sub-areas/all/${rec.subAreaId}.mp3`);
  paths.add(`sub-areas/beijing/${rec.subAreaId}.mp3`);

  return [...paths].filter((p) => p && !keep.has(p));
}

async function deleteStorageObject(storagePathKey) {
  if (!storagePathKey) return false;
  return withRetry(async () => {
    const { url, key } = getSupabaseConfig();
    const res = await fetch(`${url}/storage/v1/object/${AUDIO_BUCKET}/${storagePathKey}`, {
      method: "DELETE",
      headers: { apikey: key, Authorization: `Bearer ${key}` },
    });
    if (res.ok) return true;
    if (res.status === 404) return false;
    const text = await res.text();
    if (res.status === 400 && /not_found|not found/i.test(text)) return false;
    throw new Error(`delete storage ${storagePathKey} -> ${res.status} ${text}`);
  }, `delete ${storagePathKey}`, 3);
}

function buildConfirmMarkdown(matched, unmatched, warnings) {
  const lines = [
    "# Dual-voice audio import confirm",
    "",
    `Generated: ${new Date().toISOString()}`,
    `Mode: ${dryRun ? "dry-run" : "apply"}`,
    "",
    `Matched: ${matched.length} | Unmatched folders: ${unmatched.length} | Warnings: ${warnings.length}`,
    "",
  ];
  let lastCity = "";
  let lastAttr = "";
  for (const m of matched) {
    if (m.cityFolder !== lastCity) {
      lines.push(`## ${m.cityFolder} (${m.cityId})`);
      lastCity = m.cityFolder;
      lastAttr = "";
    }
    if (m.attractionFolder !== lastAttr) {
      lines.push(`### ${m.attractionFolder}`);
      lastAttr = m.attractionFolder;
    }
    lines.push(
      `- \`${m.subFolder}\` → \`${m.subAreaId}\` ${m.nameZh} [${m.matchMethod}] Cleo:${m.hasBenedict ? "✓" : "✗"} Milo:${m.hasBlanchett ? "✓" : "✗"}`
    );
  }
  if (unmatched.length) {
    lines.push("", "## Unmatched", "");
    for (const u of unmatched) {
      lines.push(`- ${u.cityFolder}/${u.attractionFolder}/${u.subFolder}: ${u.reason}`);
    }
  }
  if (warnings.length) {
    lines.push("", "## Warnings", "");
    for (const w of warnings) {
      lines.push(`- ${w}`);
    }
  }
  return lines.join("\n");
}

async function main() {
  mkdirSync(OUT_DIR, { recursive: true });
  if (!existsSync(sourceRoot)) throw new Error(`源目录不存在: ${sourceRoot}`);

  const { url: supabaseUrl, usesServiceRole } = getSupabaseConfig();
  if (!dryRun && !usesServiceRole) {
    throw new Error("缺少 SUPABASE_SERVICE_ROLE_KEY：--apply 需 service role");
  }

  const attractions = await (await rest("/rest/v1/attractions?select=id,chinese_name,city_id")).json();
  const subAreas = await (
    await rest("/rest/v1/sub_areas?select=id,attraction_id,sort_order,name_zh,name_en,audio_url,is_active")
  ).json();

  const subAreasByAttr = new Map();
  for (const row of subAreas) {
    if (!row.is_active || EXCLUDED_ATTRACTION_IDS.has(row.attraction_id)) continue;
    if (!subAreasByAttr.has(row.attraction_id)) subAreasByAttr.set(row.attraction_id, []);
    subAreasByAttr.get(row.attraction_id).push(row);
  }

  const stats = {
    subAreaFolders: 0,
    matched: 0,
    unmatchedFolders: 0,
    unmatchedAttractions: 0,
    missingBenedict: 0,
    missingBlanchett: 0,
    uploaded: 0,
    storageDeleted: 0,
    variantsUpserted: 0,
    variantsDeleted: 0,
    subAreasUpdated: 0,
  };

  const matched = [];
  const unmatched = [];
  const warnings = [];
  const applyQueue = [];

  let cityFolders = onlyDirs(sourceRoot).sort((a, b) => a.localeCompare(b, "zh-Hans-CN"));
  if (cityFilter) cityFolders = cityFolders.filter((c) => c === cityFilter);

  for (const cityFolder of cityFolders) {
    const cityId = CITY_FOLDER_TO_ID[cityFolder];
    if (!cityId) {
      warnings.push(`未知城市文件夹: ${cityFolder}`);
      continue;
    }
    const cityPath = join(sourceRoot, cityFolder);

    for (const attractionFolder of onlyDirs(cityPath).sort((a, b) => a.localeCompare(b, "zh-Hans-CN"))) {
      const parent = resolveAttraction(attractionFolder, attractions, cityId);
      if (!parent) {
        stats.unmatchedAttractions += 1;
        unmatched.push({
          cityFolder,
          attractionFolder,
          subFolder: "*",
          reason: "主景点未匹配",
        });
        continue;
      }
      if (EXCLUDED_ATTRACTION_IDS.has(parent.id)) continue;

      const areas = subAreasByAttr.get(parent.id) || [];
      const entries = collectSubAreaEntries(join(cityPath, attractionFolder));
      const usedAreaIds = new Set();

      for (const entry of entries) {
        if (entry.isCompound && entry.seq !== 1) continue;
        stats.subAreaFolders += 1;
        const match = matchSubArea(entry, areas.filter((a) => !usedAreaIds.has(a.id)));
        if (!match) {
          stats.unmatchedFolders += 1;
          unmatched.push({
            cityFolder,
            attractionFolder,
            subFolder: entry.subFolder,
            reason: "子景点未匹配",
          });
          continue;
        }

        usedAreaIds.add(match.area.id);
        stats.matched += 1;

        const benedict = entry.voices.Benedict;
        const blanchett = entry.voices.Blanchett;
        if (!benedict) stats.missingBenedict += 1;
        if (!blanchett) stats.missingBlanchett += 1;
        if (!benedict || !blanchett) {
          warnings.push(
            `${cityFolder}/${attractionFolder}/${entry.subFolder}: 缺少 ${!benedict ? "Cleo" : ""}${!benedict && !blanchett ? " + " : ""}${!blanchett ? "Milo" : ""}`
          );
        }

        const record = {
          cityFolder,
          cityId,
          attractionFolder,
          attractionId: parent.id,
          subFolder: entry.subFolder,
          subAreaId: match.area.id,
          nameZh: match.area.name_zh,
          previousAudioUrl: match.area.audio_url || "",
          matchMethod: match.method,
          matchScore: match.score ?? 100,
          hasBenedict: Boolean(benedict),
          hasBlanchett: Boolean(blanchett),
          voices: {},
        };

        for (const [voiceKey, fileInfo] of Object.entries(entry.voices)) {
          if (!VOICES[voiceKey] || !fileInfo) continue;
          const cfg = VOICES[voiceKey];
          const varId = variantId(match.area.id, cfg.suffix);
          record.voices[voiceKey] = {
            variantId: varId,
            voiceLabel: cfg.label,
            localPath: fileInfo.localPath,
            storagePath: storagePath(match.area.id, varId),
            sortOrder: cfg.sortOrder,
            isDefault: cfg.isDefault,
          };
        }
        matched.push(record);
        if (benedict && blanchett) applyQueue.push(record);
      }
    }
  }

  const supabase = createSupabase();

  const existingVariants = await (
    await rest("/rest/v1/audio_voice_variants?owner_type=eq.sub_area&select=id,owner_id,audio_url,voice_label")
  ).json();
  const variantsByOwner = new Map();
  for (const v of existingVariants) {
    if (!variantsByOwner.has(v.owner_id)) variantsByOwner.set(v.owner_id, []);
    variantsByOwner.get(v.owner_id).push(v);
  }

  for (let i = 0; i < applyQueue.length; i++) {
    const rec = applyQueue[i];
    const ben = rec.voices.Benedict;
    const bla = rec.voices.Blanchett;
    if (!ben || !bla) continue;

    const oldVariants = variantsByOwner.get(rec.subAreaId) || [];
    const pathsToDelete = legacyStoragePaths(rec, oldVariants, rec.previousAudioUrl);

    if (!dryRun) {
      const existing = variantsByOwner.get(rec.subAreaId) || [];
      const alreadyDone =
        existing.some(
          (v) => ["Cleo", "Benedict"].includes(v.voice_label) && v.audio_url?.includes("/voices/sub_area/")
        ) &&
        existing.some(
          (v) => ["Milo", "Blanchett"].includes(v.voice_label) && v.audio_url?.includes("/voices/sub_area/")
        );
      if (alreadyDone) {
        if ((i + 1) % 50 === 0 || i + 1 === applyQueue.length) {
          console.log(`[apply] ${i + 1}/${applyQueue.length} sub-areas processed (skip done)`);
        }
        continue;
      }

      ben.audioUrl = await uploadAudio(ben.storagePath, ben.localPath);
      bla.audioUrl = await uploadAudio(bla.storagePath, bla.localPath);
      stats.uploaded += 2;

      for (const p of pathsToDelete) {
        await deleteStorageObject(p);
        stats.storageDeleted += 1;
      }

      const { error: delAllErr } = await supabase
        .from("audio_voice_variants")
        .delete()
        .eq("owner_type", "sub_area")
        .eq("owner_id", rec.subAreaId);
      if (delAllErr) throw new Error(`delete variants ${rec.subAreaId}: ${delAllErr.message}`);
      stats.variantsDeleted += oldVariants.length || 1;

      const variantRows = [
        {
          id: ben.variantId,
          owner_type: "sub_area",
          owner_id: rec.subAreaId,
          voice_label: ben.voiceLabel,
          audio_url: ben.audioUrl,
          duration_seconds: 0,
          segments: [],
          sort_order: ben.sortOrder,
          is_default: true,
          is_active: true,
          updated_at: new Date().toISOString(),
        },
        {
          id: bla.variantId,
          owner_type: "sub_area",
          owner_id: rec.subAreaId,
          voice_label: bla.voiceLabel,
          audio_url: bla.audioUrl,
          duration_seconds: 0,
          segments: [],
          sort_order: bla.sortOrder,
          is_default: false,
          is_active: true,
          updated_at: new Date().toISOString(),
        },
      ];
      const { error: upsertErr } = await supabase.from("audio_voice_variants").upsert(variantRows);
      if (upsertErr) throw new Error(`upsert variants ${rec.subAreaId}: ${upsertErr.message}`);
      stats.variantsUpserted += 2;

      const { error: saErr } = await supabase
        .from("sub_areas")
        .update({ audio_url: ben.audioUrl, updated_at: new Date().toISOString() })
        .eq("id", rec.subAreaId);
      if (saErr) throw new Error(`update sub_area ${rec.subAreaId}: ${saErr.message}`);
      stats.subAreasUpdated += 1;

      if ((i + 1) % 50 === 0 || i + 1 === applyQueue.length) {
        console.log(`[apply] ${i + 1}/${applyQueue.length} sub-areas processed`);
      }
    } else {
      ben.audioUrl = publicUrl(supabaseUrl, ben.storagePath);
      bla.audioUrl = publicUrl(supabaseUrl, bla.storagePath);
      rec.wouldDeleteStorage = pathsToDelete;
      rec.wouldDeleteVariants = oldVariants.map((v) => v.voice_label);
    }
  }

  const report = {
    generatedAt: new Date().toISOString(),
    mode: dryRun ? "dry-run" : "apply",
    sourceRoot,
    cityFilter: cityFilter || null,
    stats,
    matchedCount: matched.length,
    applyQueueCount: applyQueue.length,
    unmatched,
    warnings: warnings.slice(0, 100),
    sampleMatched: matched.slice(0, 5),
  };

  writeFileSync(OUT_REPORT, JSON.stringify(report, null, 2));
  writeFileSync(OUT_CONFIRM, buildConfirmMarkdown(matched, unmatched, warnings));

  console.log(JSON.stringify(stats, null, 2));
  console.log(`Confirm: ${OUT_CONFIRM}`);
  console.log(`Report: ${OUT_REPORT}`);
  if (dryRun) console.log("\n[dry-run] 未上传、未写库。核对后运行 --apply");
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
