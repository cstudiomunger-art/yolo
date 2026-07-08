#!/usr/bin/env node
import { createClient } from "@supabase/supabase-js";
import { readFileSync } from "fs";
import { join } from "path";
import { loadLegalDocuments } from "./gen-legal-docs-from-md.mjs";

const ROOT = "/Users/vesperal/Desktop/YOLO";

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
  if (!url || !key) {
    throw new Error("缺少 SUPABASE_URL 或可用 key（建议提供 SUPABASE_SERVICE_ROLE_KEY）");
  }
  return {
    url,
    key,
    usesServiceRole: Boolean(process.env.SUPABASE_SERVICE_ROLE_KEY),
  };
}

async function main() {
  const { url, key, usesServiceRole } = getSupabaseConfig();
  const docs = loadLegalDocuments();
  const supabase = createClient(url, key, { auth: { persistSession: false } });

  console.log(`Importing ${docs.length} legal documents to app_settings.global`);
  if (!usesServiceRole) {
    console.warn("警告: 未设置 SUPABASE_SERVICE_ROLE_KEY，anon key 可能因 RLS 无法写入 app_settings");
  }

  for (const doc of docs) {
    const { error } = await supabase
      .from("app_settings")
      .update({ [doc.column]: doc.html, updated_at: new Date().toISOString() })
      .eq("id", "global");
    if (error) throw new Error(`${doc.column}: ${error.message}`);
    console.log(`  ok ${doc.column} (${doc.htmlChars} chars)`);
  }

  const { data, error: verifyError } = await supabase
    .from("app_settings")
    .select(
      "privacy_policy_body,terms_of_service_body,gdpr_compliance_body,ai_content_disclosure_body"
    )
    .eq("id", "global")
    .single();
  if (verifyError) throw verifyError;

  for (const doc of docs) {
    const len = String(data[doc.column] || "").length;
    console.log(`  verify ${doc.column}: ${len} chars`);
    if (!len) throw new Error(`验证失败: ${doc.column} 仍为空`);
  }

  console.log("Done. Refresh admin-vue 法律与合规文档页面即可看到内容。");
}

main().catch((err) => {
  console.error(err.message || err);
  process.exit(1);
});
