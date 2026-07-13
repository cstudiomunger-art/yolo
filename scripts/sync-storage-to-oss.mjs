#!/usr/bin/env node
/**
 * Sync Supabase Storage public buckets to Aliyun OSS for China CDN origin.
 *
 * Usage:
 *   cd scripts && npm install
 *   SUPABASE_SERVICE_ROLE_KEY=... \
 *   OSS_ACCESS_KEY_ID=... OSS_ACCESS_KEY_SECRET=... \
 *   OSS_BUCKET=yolo-media-prod OSS_REGION=oss-cn-shanghai \
 *   node sync-storage-to-oss.mjs
 *
 * Options:
 *   --dry-run     List actions without uploading
 *   --force       Re-upload even when object already exists in OSS
 *   --bucket=X    Sync only one bucket (audio-guides | cover-images)
 */

import { createClient } from "@supabase/supabase-js";
import ws from "ws";
import { createWriteStream, mkdirSync, readFileSync, writeFileSync } from "fs";
import { join, dirname } from "path";
import { fileURLToPath } from "url";
import { pipeline } from "stream/promises";
import { getSupabaseConfig, loadServiceKey } from "./lib/supabase-service.mjs";

const __dirname = dirname(fileURLToPath(import.meta.url));
const ROOT = join(__dirname, "..");
const OUT_DIR = join(ROOT, "scripts/generated");
const REPORT_PATH = join(OUT_DIR, "storage_oss_sync_report.json");

const BUCKETS = ["audio-guides", "cover-images"];
const CACHE_CONTROL = "public, max-age=2592000";
const RETRYABLE = new Set(["ENOTFOUND", "ETIMEDOUT", "ECONNRESET", "EAI_AGAIN", "RequestError"]);

async function withRetry(label, fn, { attempts = 4, baseMs = 800 } = {}) {
  let last;
  for (let i = 1; i <= attempts; i++) {
    try {
      return await fn();
    } catch (e) {
      last = e;
      const code = e?.code ?? e?.name;
      if (!RETRYABLE.has(code) || i === attempts) throw e;
      const wait = baseMs * 2 ** (i - 1);
      console.warn(`retry ${i}/${attempts - 1} ${label} (${code}), wait ${wait}ms`);
      await new Promise((r) => setTimeout(r, wait));
    }
  }
  throw last;
}

const args = process.argv.slice(2);
const dryRun = args.includes("--dry-run");
const force = args.includes("--force");
const bucketArg = args.find((a) => a.startsWith("--bucket="))?.split("=")[1];
const buckets = bucketArg ? [bucketArg] : BUCKETS;

async function loadOSSClient() {
  const region = process.env.OSS_REGION || "oss-cn-shanghai";
  const bucket = process.env.OSS_BUCKET;
  const accessKeyId = process.env.OSS_ACCESS_KEY_ID;
  const accessKeySecret = process.env.OSS_ACCESS_KEY_SECRET;
  if (!bucket || !accessKeyId || !accessKeySecret) {
    throw new Error("缺少 OSS_BUCKET / OSS_ACCESS_KEY_ID / OSS_ACCESS_KEY_SECRET");
  }
  let OSS;
  try {
    OSS = (await import("ali-oss")).default;
  } catch {
    throw new Error("请先运行: cd scripts && npm install ali-oss");
  }
  return { client: new OSS({ region, bucket, accessKeyId, accessKeySecret }), bucket };
}

async function listAllObjects(supabase, bucket) {
  const results = [];
  const queue = [""];
  while (queue.length) {
    const prefix = queue.shift();
    const { data, error } = await supabase.storage.from(bucket).list(prefix, {
      limit: 1000,
      sortBy: { column: "name", order: "asc" },
    });
    if (error) throw new Error(`list ${bucket}/${prefix}: ${error.message}`);
    for (const item of data ?? []) {
      const path = prefix ? `${prefix}/${item.name}` : item.name;
      const isFile = item.metadata?.size != null;
      if (!isFile) {
        queue.push(path);
      } else {
        results.push({ path, size: item.metadata.size });
      }
    }
  }
  return results;
}

async function downloadObject(supabase, bucket, objectPath, dest) {
  const { data, error } = await supabase.storage.from(bucket).download(objectPath);
  if (error) throw error;
  mkdirSync(dirname(dest), { recursive: true });
  await pipeline(data.stream(), createWriteStream(dest));
}

async function ossObjectExists(client, key) {
  try {
    await withRetry(`head ${key}`, () => client.head(key));
    return true;
  } catch (e) {
    if (e?.status === 404 || e?.code === "NoSuchKey") return false;
    throw e;
  }
}

async function main() {
  const missing = [];
  if (!process.env.SUPABASE_SERVICE_ROLE_KEY?.trim()) {
    missing.push("SUPABASE_SERVICE_ROLE_KEY");
  }
  for (const k of ["OSS_ACCESS_KEY_ID", "OSS_ACCESS_KEY_SECRET", "OSS_BUCKET", "OSS_REGION"]) {
    if (!process.env[k]?.trim()) missing.push(k);
  }
  if (missing.length) {
    throw new Error(`缺少环境变量：${missing.join(", ")}`);
  }

  if (!loadServiceKey()) {
    console.warn("警告: 未设置 SUPABASE_SERVICE_ROLE_KEY，大目录 list 可能受限");
  }
  const { url, key } = getSupabaseConfig();
  const supabase = createClient(url, key, {
    auth: { persistSession: false, autoRefreshToken: false },
    realtime: { transport: ws },
  });
  const { client: oss, bucket: ossBucket } = await loadOSSClient();

  const report = {
    generatedAt: new Date().toISOString(),
    dryRun,
    force,
    ossBucket,
    buckets: {},
  };

  for (const bucket of buckets) {
    console.log(`\n==> ${bucket}`);
    const objects = await listAllObjects(supabase, bucket);
    const bucketReport = { total: objects.length, uploaded: 0, skipped: 0, failed: [] };
    report.buckets[bucket] = bucketReport;

    for (const { path } of objects) {
      const ossKey = `${bucket}/${path}`;
      try {
        const exists = !force && (await ossObjectExists(oss, ossKey));
        if (exists) {
          bucketReport.skipped++;
          continue;
        }
        if (dryRun) {
          console.log(`[dry-run] upload ${ossKey}`);
          bucketReport.uploaded++;
          continue;
        }
        const tmp = join(OUT_DIR, ".tmp-sync", ossKey);
        await downloadObject(supabase, bucket, path, tmp);
        await withRetry(`put ${ossKey}`, () =>
          oss.put(ossKey, readFileSync(tmp), {
            headers: { "Cache-Control": CACHE_CONTROL },
          })
        );
        bucketReport.uploaded++;
        console.log(`uploaded ${ossKey}`);
      } catch (e) {
        bucketReport.failed.push({ path, error: String(e?.message ?? e) });
        console.error(`FAILED ${ossKey}:`, e?.message ?? e);
      }
    }
  }

  mkdirSync(OUT_DIR, { recursive: true });
  writeFileSync(REPORT_PATH, JSON.stringify(report, null, 2));
  console.log(`\nReport: ${REPORT_PATH}`);

  const failedCount = Object.values(report.buckets).reduce((n, b) => n + (b.failed?.length ?? 0), 0);
  if (failedCount > 0) {
    console.error(`\n${failedCount} file(s) failed — see report`);
    process.exit(1);
  }
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
