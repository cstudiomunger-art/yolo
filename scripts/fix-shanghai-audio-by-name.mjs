#!/usr/bin/env node
import { mkdirSync, readFileSync, writeFileSync } from "fs";
import { join } from "path";

const ROOT = "/Users/vesperal/Desktop/YOLO";
const OUT = join(ROOT, "scripts/generated/shanghai_audio_remap_report.json");

/** [attraction_id, seq, sub_area name_zh 包含关键词] */
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

function readXc(k) {
  const t = readFileSync(join(ROOT, "Secrets.xcconfig"), "utf8");
  const line = t.split(/\r?\n/).find((it) => it.trim().startsWith(`${k} =`));
  return line ? line.split("=").slice(1).join("=").replace(/\$\(\)/g, "").trim() : "";
}

function loadServiceKey() {
  if (process.env.SUPABASE_SERVICE_ROLE_KEY) return process.env.SUPABASE_SERVICE_ROLE_KEY;
  const tmp = join(ROOT, ".env.local.tmp");
  try {
    const m = readFileSync(tmp, "utf8").match(/SUPABASE_SERVICE_ROLE_KEY\s*=\s*"?([^"\n]+)"?/);
    if (m?.[1]) return m[1].trim();
  } catch {
    /* optional local file */
  }
  return "";
}

async function main() {
  mkdirSync(join(ROOT, "scripts/generated"), { recursive: true });
  const url = process.env.SUPABASE_URL || readXc("SUPABASE_URL");
  const key = loadServiceKey();
  if (!key) {
    console.error("缺少 SUPABASE_SERVICE_ROLE_KEY（或项目根 .env.local.tmp）");
    process.exit(1);
  }
  const h = { apikey: key, Authorization: `Bearer ${key}` };
  const report = { updated: [], errors: [], skipped: [] };

  for (const [attrId, seq, part] of SHANGHAI_MAPS) {
    const sa = await fetch(
      `${url}/rest/v1/sub_areas?select=id,name_zh,audio_url&attraction_id=eq.${attrId}`,
      { headers: h }
    ).then((r) => r.json());

    const row = sa.find((s) => String(s.name_zh || "").includes(part));
    if (!row) {
      report.errors.push({ attrId, seq, part, reason: "no_sub_area" });
      continue;
    }

    const audioUrl = `${url}/storage/v1/object/public/audio-guides/sub-areas/${attrId}_${String(seq).padStart(3, "0")}.mp3`;
    const current = String(row.audio_url || "").trim();

    const res = await fetch(`${url}/rest/v1/sub_areas?id=eq.${encodeURIComponent(row.id)}`, {
      method: "PATCH",
      headers: { ...h, "Content-Type": "application/json", Prefer: "return=representation" },
      body: JSON.stringify({ audio_url: audioUrl }),
    });
    const body = await res.json().catch(() => null);
    if (!res.ok || !Array.isArray(body) || body.length === 0) {
      report.errors.push({
        attrId,
        seq,
        part,
        reason: res.ok ? "rls_blocked_or_no_row" : JSON.stringify(body),
      });
      continue;
    }

    if (current === audioUrl) report.skipped.push({ attrId, nameZh: row.name_zh, seq });
    else report.updated.push({ attrId, seq, nameZh: row.name_zh, part, audioUrl });
    console.log(`${attrId} ${row.name_zh} <- _${String(seq).padStart(3, "0")}`);
  }

  writeFileSync(OUT, JSON.stringify(report, null, 2), "utf8");
  console.log(`\nupdated: ${report.updated.length}, skipped: ${report.skipped.length}, errors: ${report.errors.length}`);
  console.log(`report: ${OUT}`);
}

main().catch((e) => {
  console.error(e.message);
  process.exit(1);
});
