#!/usr/bin/env node
import { createClient } from "@supabase/supabase-js";
import { loadLegalDocuments } from "./gen-legal-docs-from-md.mjs";
import { getSupabaseConfig, loadServiceKey } from "./lib/supabase-service.mjs";

async function main() {
  const serviceKey = loadServiceKey();
  if (!serviceKey) throw new Error("缺少 SUPABASE_SERVICE_ROLE_KEY");
  const { url } = getSupabaseConfig();
  const docs = loadLegalDocuments();
  const supabase = createClient(url, serviceKey, { auth: { persistSession: false } });

  for (const doc of docs) {
    const { error } = await supabase
      .from("app_settings")
      .update({ [doc.column]: doc.markdown, updated_at: new Date().toISOString() })
      .eq("id", "global");
    if (error) throw new Error(`${doc.column}: ${error.message}`);
    console.log(`  ok ${doc.column} (${doc.markdownChars} chars)`);
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
