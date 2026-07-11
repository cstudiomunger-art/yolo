#!/usr/bin/env node
/**
 * 生成全量子景点解说音频 SQL（按名称绑定）及未匹配/未使用音频清单。
 * 上海 12 个景点使用硬编码映射；其余城市用 Benedict 文件名 ↔ 子景点名贪心匹配。
 */
import { mkdirSync, readFileSync, readdirSync, statSync, writeFileSync } from "fs";
import { join } from "path";

const ROOT = "/Users/vesperal/Desktop/YOLO";
const SOURCE_BENEDICT = "/Users/vesperal/Downloads/全量英文解说音频_Benedict";
const OUT_DIR = join(ROOT, "scripts/generated");
const OUT_SQL = join(OUT_DIR, "sub_areas_audio_final.sql");
const OUT_REPORT = join(OUT_DIR, "sub_areas_audio_final_report.json");
const OUT_UNMATCHED = join(OUT_DIR, "sub_areas_audio_unmatched_and_unused.md");
const AUDIO_BUCKET = "audio-guides";
const EXCLUDED_ATTRACTION_IDS = new Set(["chongqing_jiujie"]);

/** 上海： [attraction_id, storage seq, name_zh 关键词] */
const SHANGHAI_MAPS = [
  ["shanghai_disney_resort", 1, "米奇大街"],
  ["shanghai_disney_resort", 2, "奇想花园"],
  ["shanghai_disney_resort", 3, "探险岛"],
  ["shanghai_disney_resort", 4, "宝藏湾"],
  ["shanghai_disney_resort", 5, "梦幻世界"],
  ["shanghai_disney_resort", 6, "明日世界"],
  ["shanghai_disney_resort", 7, "玩具总动员"],
  ["shanghai_disney_resort", 8, "疯狂动物城"],
  ["shanghai_disney_resort", 9, "迪士尼小镇"],
  ["shanghai_disney_resort", 10, "星愿公园"],
  ["south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market", 1, "市场入口"],
  ["south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market", 2, "成衣与皮具"],
  ["south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market", 3, "Kate"],
  ["south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market", 4, "西装定制"],
  ["south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market", 5, "进口面料"],
  ["south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market", 6, "旗袍"],
  ["south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market", 7, "传统面料"],
  ["south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market", 8, "羊绒"],
  ["south_bund_fabric_market_commonly_known_as_dongjiadu_fabric_market", 9, "黄浦邮政"],
  ["suzhou_creek_twelve_nations_colors", 1, "高陵集市"],
  ["suzhou_creek_twelve_nations_colors", 2, "曹杨新村"],
  ["suzhou_creek_twelve_nations_colors", 3, "玉佛寺"],
  ["suzhou_creek_twelve_nations_colors", 4, "M50"],
  ["suzhou_creek_twelve_nations_colors", 5, "创享塔"],
  ["suzhou_creek_twelve_nations_colors", 6, "雾苑堂"],
  ["suzhou_creek_twelve_nations_colors", 7, "竹丝编"],
  ["suzhou_creek_twelve_nations_colors", 8, "顾正红"],
  ["suzhou_creek_twelve_nations_colors", 9, "工业文明"],
  ["suzhou_creek_twelve_nations_colors", 10, "半马苏河"],
  ["suzhou_creek_twelve_nations_colors", 11, "百禧公园"],
  ["suzhou_creek_twelve_nations_colors", 12, "鸿寿坊"],
  ["yu_garden", 1, "三穗堂"],
  ["yu_garden", 2, "仰山堂"],
  ["yu_garden", 3, "大假山"],
  ["yu_garden", 4, "萃秀堂"],
  ["yu_garden", 5, "万花楼"],
  ["yu_garden", 6, "点春堂"],
  ["yu_garden", 7, "玉玲珑"],
  ["yu_garden", 8, "玉华堂"],
  ["yu_garden", 9, "会景楼"],
  ["yu_garden", 10, "得月楼"],
  ["yu_garden", 11, "内园"],
  ["lujiazui_financial_district", 1, "陆家嘴中心绿地"],
  ["lujiazui_financial_district", 2, "东方明珠"],
  ["lujiazui_financial_district", 3, "海洋水族馆"],
  ["lujiazui_financial_district", 4, "金茂"],
  ["lujiazui_financial_district", 5, "环球金融中心"],
  ["lujiazui_financial_district", 6, "上海中心"],
  ["lujiazui_financial_district", 7, "吴昌硕"],
  ["lujiazui_financial_district", 8, "世纪大道"],
  ["lujiazui_financial_district", 9, "滨江大道"],
  ["tianzifang", 1, "泰康路主入口"],
  ["tianzifang", 2, "石库门里弄"],
  ["tianzifang", 3, "陈逸飞"],
  ["tianzifang", 4, "守白"],
  ["tianzifang", 5, "画家楼"],
  ["tianzifang", 6, "气味图书馆"],
  ["tianzifang", 7, "金粉世家"],
  ["tianzifang", 8, "248"],
  ["tianzifang", 9, "274"],
  ["wukang_road", 1, "武康大楼"],
  ["wukang_road", 2, "宋庆龄"],
  ["wukang_road", 3, "黄兴"],
  ["wukang_road", 4, "周璇"],
  ["wukang_road", 5, "意大利总领事"],
  ["wukang_road", 6, "武康庭"],
  ["wukang_road", 7, "罗密欧"],
  ["wukang_road", 8, "巴金"],
  ["wukang_road", 9, "密丹"],
  ["the_bund_shanghai", 1, "十六铺"],
  ["the_bund_shanghai", 2, "外滩十八号"],
  ["the_bund_shanghai", 3, "亚细亚"],
  ["the_bund_shanghai", 4, "上海总会"],
  ["the_bund_shanghai", 5, "汇丰"],
  ["the_bund_shanghai", 6, "海关"],
  ["the_bund_shanghai", 7, "和平饭店"],
  ["the_bund_shanghai", 8, "陈毅"],
  ["the_bund_shanghai", 9, "外滩牛"],
  ["the_bund_shanghai", 10, "人民英雄"],
  ["the_bund_shanghai", 11, "外白渡"],
  ["the_bund_shanghai", 12, "外滩源"],
  ["oriental_pearl_radio_television_tower", 1, "检票"],
  ["oriental_pearl_radio_television_tower", 2, "主观光"],
  ["oriental_pearl_radio_television_tower", 3, "太空舱"],
  ["oriental_pearl_radio_television_tower", 4, "悬空观光"],
  ["oriental_pearl_radio_television_tower", 5, "户外观光"],
  ["oriental_pearl_radio_television_tower", 6, "更上海"],
  ["oriental_pearl_radio_television_tower", 7, "历史发展陈列"],
  ["shanghai_museum", 1, "青铜馆"],
  ["shanghai_museum", 2, "雕塑馆"],
  ["shanghai_museum", 3, "陶瓷馆"],
  ["shanghai_museum", 4, "书法馆"],
  ["shanghai_museum", 5, "绘画馆"],
  ["shanghai_museum", 6, "玺印馆"],
  ["shanghai_museum", 7, "玉器馆"],
  ["shanghai_museum", 8, "钱币馆"],
  ["shanghai_museum", 9, "家具馆"],
  ["shanghai_museum", 10, "少数民族"],
  ["xujiahui_source_scenic_area", 1, "徐家汇书院"],
  ["xujiahui_source_scenic_area", 2, "天主堂"],
  ["xujiahui_source_scenic_area", 3, "气象博物馆"],
  ["xujiahui_source_scenic_area", 4, "徐汇公学"],
  ["xujiahui_source_scenic_area", 5, "百代小楼"],
  ["xujiahui_source_scenic_area", 6, "电影博物馆"],
  ["xujiahui_source_scenic_area", 7, "光启公园"],
  ["xujiahui_source_scenic_area", 8, "土山湾"],
  ["xujiahui_source_scenic_area", 9, "圣母院"],
  ["zhujiajiao_ancient_town", 1, "放生桥"],
  ["zhujiajiao_ancient_town", 2, "北大街"],
  ["zhujiajiao_ancient_town", 3, "涵大隆"],
  ["zhujiajiao_ancient_town", 4, "泰安桥"],
  ["zhujiajiao_ancient_town", 5, "圆津"],
  ["zhujiajiao_ancient_town", 6, "廊桥"],
  ["zhujiajiao_ancient_town", 7, "城隍庙"],
  ["zhujiajiao_ancient_town", 8, "课植园"],
  ["zhujiajiao_ancient_town", 9, "大清邮局"],
];

const SHANGHAI_ATTR_IDS = new Set(SHANGHAI_MAPS.map((m) => m[0]));

const ATTRACTION_ALIASES = {
  南京大屠杀纪念馆: "侵华日军南京大屠杀遇难同胞纪念馆",
  南京老门东: "老门东历史文化街区",
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

/** 用户已确认、需按 seq+关键词强绑的额外映射（非上海） */
const EXTRA_NAME_MAPS = [
  ["hangzhou_west_lake_cultural_plaza", 1, "北入口"],
  ["hangzhou_west_lake_cultural_plaza", 2, "音乐喷泉"],
  ["hangzhou_west_lake_cultural_plaza", 3, "浙江省博物馆"],
  ["hangzhou_west_lake_cultural_plaza", 4, "自然博物"],
  ["hangzhou_west_lake_cultural_plaza", 5, "科技馆"],
  ["hangzhou_west_lake_cultural_plaza", 6, "环球中心"],
  ["hangzhou_west_lake_cultural_plaza", 7, "运河景观"],
  ["hangzhou_west_lake_cultural_plaza", 8, "雕塑"],
  ["hangzhou_west_lake_cultural_plaza", 9, "下沉式"],
  ["hangzhou_west_lake_cultural_plaza", 10, "夜景"],
  ["hangzhou_zhejiang_museum", 3, "江南秘色"],
  ["hangzhou_zhejiang_museum", 4, "向东是大海"],
];

const SKIP_HINTS = /^(Welcome|Closing|Closing Words|Closing Remarks|结束语)/i;
const IGNORE_UNMATCHED_HINTS = /^(Divine Path|墓室|密丹里)$/i;

function readXcconfigValue(path, key) {
  const text = readFileSync(path, "utf8");
  const line = text.split(/\r?\n/).find((it) => it.trim().startsWith(`${key} =`));
  if (!line) return "";
  return line.split("=").slice(1).join("=").replace(/\$\(\)/g, "").trim();
}

function getSupabaseConfig() {
  const xcPath = join(ROOT, "Secrets.xcconfig");
  const url = process.env.SUPABASE_URL || readXcconfigValue(xcPath, "SUPABASE_URL");
  const key =
    process.env.SUPABASE_SERVICE_ROLE_KEY ||
    process.env.SUPABASE_ANON_KEY ||
    readXcconfigValue(xcPath, "SUPABASE_ANON_KEY");
  if (!url || !key) throw new Error("缺少 SUPABASE_URL 或 key");
  return { url, key };
}

function sqlStr(value) {
  if (value == null) return "NULL";
  return `'${String(value).replace(/'/g, "''")}'`;
}

function onlyDirs(path) {
  return readdirSync(path).filter((n) => statSync(join(path, n)).isDirectory());
}

function parseAudioSeq(filename) {
  const m = filename.match(/_([0-9]{1,3})\./);
  return m ? Number(m[1]) : 0;
}

function collectAudioFiles(scenicPath) {
  const results = [];
  function walk(dir, rel = "") {
    for (const name of readdirSync(dir)) {
      const full = join(dir, name);
      const st = statSync(full);
      if (st.isDirectory()) {
        walk(full, rel ? `${rel}/${name}` : name);
        continue;
      }
      if (!name.toLowerCase().endsWith(".mp3")) continue;
      results.push({ file: name, localPath: full, relDir: rel, fileSeq: parseAudioSeq(name) });
    }
  }
  walk(scenicPath);
  const nested = results.some((r) => r.relDir);
  if (nested) {
    results.sort(
      (a, b) =>
        a.relDir.localeCompare(b.relDir, "zh-Hans-CN") ||
        a.fileSeq - b.fileSeq ||
        a.file.localeCompare(b.file)
    );
    return results.map((r, idx) => ({ ...r, seq: idx + 1 }));
  }
  return results
    .sort((a, b) => a.fileSeq - b.fileSeq || a.file.localeCompare(b.file))
    .map((r) => ({ ...r, seq: r.fileSeq }));
}

function parseNameHint(filename) {
  const m = filename.match(/_\d+\.(.+?)\.mp3$/i);
  return m ? m[1].trim() : filename.replace(/\.mp3$/i, "");
}

function storageFileKey(attractionId, seq) {
  return `${attractionId}_${String(seq).padStart(3, "0")}.mp3`;
}

function publicStorageUrl(supabaseUrl, fileKey) {
  return `${supabaseUrl}/storage/v1/object/public/${AUDIO_BUCKET}/sub-areas/${fileKey}`;
}

function resolveAttraction(scenic, attractions) {
  const guess = ATTRACTION_ALIASES[scenic] || scenic;
  return (
    attractions.find((a) => String(a.chinese_name || "").trim() === guess) ||
    attractions.find(
      (a) =>
        String(a.chinese_name || "").includes(guess) ||
        guess.includes(String(a.chinese_name || "").trim())
    )
  );
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
  return normalizeEn(text)
    .split(/\s+/)
    .filter((w) => w.length > 2);
}

function scoreMatch(hint, subArea) {
  const manualZh = MANUAL_HINT_TO_ZH[hint];
  if (manualZh && String(subArea.name_zh || "").includes(manualZh.replace(/[（(].*$/, ""))) return 100;

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

function applyNameMaps(maps, areas, parent, supabaseUrl, bindings, usedAreas, usedFiles, meta) {
  for (const [attrId, seq, part] of maps) {
    if (attrId !== parent.id) continue;
    const area = areas.find((a) => String(a.name_zh || "").includes(part));
    if (!area) {
      meta.errors.push({ attrId, seq, part, reason: "no_sub_area" });
      continue;
    }
    const fileKey = storageFileKey(attrId, seq);
    const audioUrl = publicStorageUrl(supabaseUrl, fileKey);
    bindings.set(area.id, {
      subAreaId: area.id,
      attractionId: attrId,
      nameZh: area.name_zh,
      seq,
      fileKey,
      audioUrl,
      source: meta.source,
      sourceFile: meta.sourceFileBySeq?.get(seq) || null,
    });
    usedAreas.add(area.id);
    if (meta.sourceFileBySeq?.has(seq)) {
      usedFiles.add(meta.fileId(meta.sourceFileBySeq.get(seq)));
    }
  }
}

function markUnusedFiles(files, parent, report, meta, usedFiles) {
  for (const entry of files) {
    const hint = parseNameHint(entry.file);
    const sourceFile = entry.relDir ? `${entry.relDir}/${entry.file}` : entry.file;
    const fileId = meta.fileId(sourceFile);
    if (SKIP_HINTS.test(hint)) {
      report.skipped.push({ city: meta.city, scenic: meta.scenic, sourceFile, hint, reason: "welcome_or_closing" });
      continue;
    }
    if (usedFiles.has(fileId)) continue;
    if (IGNORE_UNMATCHED_HINTS.test(hint)) {
      report.ignored.push({ city: meta.city, scenic: meta.scenic, sourceFile, hint, reason: "user_ignored" });
      continue;
    }
    report.unmatched.push({
      city: meta.city,
      scenic: meta.scenic,
      sourceFile,
      hint,
      fileKey: storageFileKey(parent.id, entry.seq),
    });
  }
}

function assignByGreedy(areas, files, parent, supabaseUrl, bindings, usedAreas, usedFiles, report, meta) {
  const pairs = [];
  for (const entry of files) {
    const hint = parseNameHint(entry.file);
    if (SKIP_HINTS.test(hint)) {
      report.skipped.push({
        city: meta.city,
        scenic: meta.scenic,
        sourceFile: entry.relDir ? `${entry.relDir}/${entry.file}` : entry.file,
        hint,
        reason: "welcome_or_closing",
      });
      continue;
    }
    const sourceFile = entry.relDir ? `${entry.relDir}/${entry.file}` : entry.file;
    if (usedFiles.has(meta.fileId(sourceFile))) continue;
    for (const area of areas) {
      if (usedAreas.has(area.id)) continue;
      const score = scoreMatch(hint, area);
      if (score >= 50) pairs.push({ entry, area, score, hint });
    }
  }
  pairs.sort((a, b) => b.score - a.score || a.entry.seq - b.entry.seq);

  const localUsedAreas = new Set();
  const localUsedFiles = new Set();

  for (const p of pairs) {
    const fileId = meta.fileId(p.entry.relDir ? `${p.entry.relDir}/${p.entry.file}` : p.entry.file);
    if (localUsedAreas.has(p.area.id) || localUsedFiles.has(fileId)) continue;
    localUsedAreas.add(p.area.id);
    localUsedFiles.add(fileId);

    const fileKey = storageFileKey(parent.id, p.entry.seq);
    bindings.set(p.area.id, {
      subAreaId: p.area.id,
      attractionId: parent.id,
      nameZh: p.area.name_zh,
      seq: p.entry.seq,
      fileKey,
      audioUrl: publicStorageUrl(supabaseUrl, fileKey),
      source: "greedy",
      sourceFile: p.entry.relDir ? `${p.entry.relDir}/${p.entry.file}` : p.entry.file,
      hint: p.hint,
      score: p.score,
    });
    usedAreas.add(p.area.id);
    usedFiles.add(fileId);
  }

  for (const entry of files) {
    const hint = parseNameHint(entry.file);
    if (SKIP_HINTS.test(hint)) continue;
    const sourceFile = entry.relDir ? `${entry.relDir}/${entry.file}` : entry.file;
    const fileId = meta.fileId(sourceFile);
    if (usedFiles.has(fileId)) continue;

    if (IGNORE_UNMATCHED_HINTS.test(hint)) {
      report.ignored.push({ city: meta.city, scenic: meta.scenic, sourceFile, hint, reason: "user_ignored" });
      continue;
    }

    const scored = areas
      .map((a) => ({ area: a, score: scoreMatch(hint, a) }))
      .filter((s) => s.score > 0)
      .sort((a, b) => b.score - a.score);

    if (!scored.length) {
      report.unmatched.push({
        city: meta.city,
        scenic: meta.scenic,
        sourceFile,
        hint,
        fileKey: storageFileKey(parent.id, entry.seq),
      });
      continue;
    }

    const best = scored[0];
    const second = scored[1];
    if (second && best.score - second.score < 10) {
      report.ambiguous.push({
        city: meta.city,
        scenic: meta.scenic,
        sourceFile,
        hint,
        fileKey: storageFileKey(parent.id, entry.seq),
        candidates: scored.slice(0, 3).map((s) => ({
          nameZh: s.area.name_zh,
          score: s.score,
        })),
      });
    } else {
      report.unmatched.push({
        city: meta.city,
        scenic: meta.scenic,
        sourceFile,
        hint,
        fileKey: storageFileKey(parent.id, entry.seq),
        reason: "low_confidence",
        bestScore: best.score,
      });
    }
  }
}

async function rest(path, init = {}) {
  const { url, key } = getSupabaseConfig();
  const res = await fetch(`${url}${path}`, {
    ...init,
    headers: { apikey: key, Authorization: `Bearer ${key}`, ...(init.headers || {}) },
  });
  if (!res.ok) throw new Error(`${path} -> ${res.status} ${await res.text()}`);
  return res;
}

function buildUnmatchedMarkdown(report, stats) {
  const lines = [
    "# 解说音频：未匹配 / 未使用清单",
    "",
    `生成时间：${report.generatedAt}`,
    "",
    "## 统计",
    "",
    `- Benedict 源文件总数：${stats.totalFiles}`,
    `- 已绑定子景点：${stats.bound}`,
    `- 跳过（Welcome/Closing/结束语）：${report.skipped.length}`,
    `- 用户策略忽略：${report.ignored.length}`,
    `- **未匹配**（无合适子景点）：${report.unmatched.length}`,
    `- **歧义未决**（多候选，未写入 SQL）：${report.ambiguous.length}`,
    `- **未使用**（未绑定且非跳过）：${report.unmatched.length + report.ambiguous.length}`,
    "",
  ];

  if (report.skipped.length) {
    lines.push("## 已跳过（不计入未使用）", "");
    for (const u of report.skipped) {
      lines.push(`- **${u.city} / ${u.scenic}**：\`${u.sourceFile}\` — ${u.hint}`);
    }
    lines.push("");
  }

  if (report.ignored.length) {
    lines.push("## 策略忽略", "");
    for (const u of report.ignored) {
      lines.push(`- **${u.city} / ${u.scenic}**：\`${u.sourceFile}\` — ${u.hint}`);
    }
    lines.push("");
  }

  if (report.unmatched.length) {
    lines.push("## 未匹配（无候选子景点或低置信度）", "");
    for (const u of report.unmatched) {
      const extra = u.reason === "low_confidence" ? ` [best=${u.bestScore}]` : "";
      lines.push(`- **${u.city} / ${u.scenic}**：\`${u.sourceFile}\` — ${u.hint}${extra}`);
      lines.push(`  - storage: \`${u.fileKey}\``);
    }
    lines.push("");
  }

  if (report.ambiguous.length) {
    lines.push("## 歧义（有候选但未自动绑定，需人工确认）", "");
    for (const u of report.ambiguous) {
      lines.push(`- **${u.city} / ${u.scenic}**：\`${u.sourceFile}\` — ${u.hint}`);
      lines.push(`  - storage: \`${u.fileKey}\``);
      for (const [i, c] of u.candidates.entries()) {
        lines.push(`  - 候选 ${i + 1}: ${c.nameZh} [score ${c.score}]`);
      }
    }
    lines.push("");
  }

  return `${lines.join("\n")}\n`;
}

async function main() {
  mkdirSync(OUT_DIR, { recursive: true });
  const { url: supabaseUrl } = getSupabaseConfig();

  const attractions = await (await rest("/rest/v1/attractions?select=id,chinese_name")).json();
  const subAreas = await (
    await rest("/rest/v1/sub_areas?select=id,attraction_id,sort_order,audio_url,name_zh,name_en,is_active")
  ).json();

  const subAreasByAttr = new Map();
  for (const row of subAreas) {
    if (!row.is_active || EXCLUDED_ATTRACTION_IDS.has(row.attraction_id)) continue;
    if (!subAreasByAttr.has(row.attraction_id)) subAreasByAttr.set(row.attraction_id, []);
    subAreasByAttr.get(row.attraction_id).push(row);
  }

  const bindings = new Map();
  const usedAreas = new Set();
  const usedFiles = new Set();
  const report = {
    generatedAt: new Date().toISOString(),
    skipped: [],
    ignored: [],
    unmatched: [],
    ambiguous: [],
    errors: [],
  };

  let totalFiles = 0;
  const attrNameById = new Map(attractions.map((a) => [a.id, a.chinese_name]));

  for (const city of onlyDirs(SOURCE_BENEDICT).sort()) {
    const cityPath = join(SOURCE_BENEDICT, city);
    for (const scenic of onlyDirs(cityPath).sort((a, b) => a.localeCompare(b, "zh-Hans-CN"))) {
      const parent = resolveAttraction(scenic, attractions);
      if (!parent || EXCLUDED_ATTRACTION_IDS.has(parent.id)) continue;

      const areas = subAreasByAttr.get(parent.id) || [];
      const files = collectAudioFiles(join(cityPath, scenic));
      totalFiles += files.length;

      const meta = {
        city,
        scenic,
        source: SHANGHAI_ATTR_IDS.has(parent.id) ? "shanghai_map" : "greedy",
        fileId: (sf) => `${parent.id}::${sf}`,
        sourceFileBySeq: new Map(files.map((f) => [f.seq, f.relDir ? `${f.relDir}/${f.file}` : f.file])),
      };

      if (SHANGHAI_ATTR_IDS.has(parent.id)) {
        applyNameMaps(SHANGHAI_MAPS, areas, parent, supabaseUrl, bindings, usedAreas, usedFiles, {
          ...meta,
          source: "shanghai_map",
          errors: report.errors,
        });
        markUnusedFiles(files, parent, report, meta, usedFiles);
      } else {
        applyNameMaps(EXTRA_NAME_MAPS, areas, parent, supabaseUrl, bindings, usedAreas, usedFiles, {
          ...meta,
          source: "extra_map",
          errors: report.errors,
        });
        assignByGreedy(areas, files, parent, supabaseUrl, bindings, usedAreas, usedFiles, report, meta);
        applyNameMaps(EXTRA_NAME_MAPS, areas, parent, supabaseUrl, bindings, usedAreas, usedFiles, {
          ...meta,
          source: "extra_map",
          errors: report.errors,
        });
      }
    }
  }

  const bindingList = [...bindings.values()].sort(
    (a, b) =>
      a.attractionId.localeCompare(b.attractionId) ||
      a.seq - b.seq ||
      a.nameZh.localeCompare(b.nameZh, "zh-Hans-CN")
  );

  const sqlLines = [
    "-- 子景点解说音频 audio_url 全量绑定 SQL",
    `-- 生成时间: ${report.generatedAt}`,
    `-- 绑定条目: ${bindingList.length}`,
    "-- 说明: 按 Benedict 文件名 ↔ 子景点名匹配；上海 12 景点为硬编码映射",
    "-- 在 Supabase SQL Editor 中整段执行即可",
    "",
    "BEGIN;",
    "",
  ];

  let currentAttr = "";
  for (const b of bindingList) {
    if (b.attractionId !== currentAttr) {
      currentAttr = b.attractionId;
      sqlLines.push(`-- ${attrNameById.get(currentAttr) || currentAttr} (${currentAttr})`);
    }
    const comment = b.sourceFile ? `-- ${b.sourceFile}` : `-- seq ${b.seq}`;
    sqlLines.push(comment);
    sqlLines.push(
      `UPDATE sub_areas SET audio_url = ${sqlStr(b.audioUrl)}, updated_at = NOW() WHERE id = ${sqlStr(b.subAreaId)};`
    );
    sqlLines.push("");
  }

  sqlLines.push("COMMIT;", "");

  writeFileSync(OUT_SQL, `${sqlLines.join("\n")}`, "utf8");

  const stats = {
    totalFiles,
    bound: bindingList.length,
    skipped: report.skipped.length,
    ignored: report.ignored.length,
    unmatched: report.unmatched.length,
    ambiguous: report.ambiguous.length,
    errors: report.errors.length,
  };

  writeFileSync(
    OUT_REPORT,
    JSON.stringify({ ...report, stats, bindings: bindingList }, null, 2),
    "utf8"
  );
  writeFileSync(OUT_UNMATCHED, buildUnmatchedMarkdown(report, stats), "utf8");

  console.log(`sql: ${OUT_SQL} (${bindingList.length} updates)`);
  console.log(`unmatched list: ${OUT_UNMATCHED}`);
  console.log(`report: ${OUT_REPORT}`);
  console.log(JSON.stringify(stats, null, 2));
}

main().catch((err) => {
  console.error(err.message);
  process.exit(1);
});
