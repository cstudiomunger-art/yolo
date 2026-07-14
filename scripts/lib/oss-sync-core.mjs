/**
 * Shared helpers for Supabase Storage → OSS sync scripts.
 */
import { createClient } from "@supabase/supabase-js";
import ws from "ws";
import { createWriteStream, mkdirSync, readFileSync } from "fs";
import { dirname, join } from "path";
import { fileURLToPath } from "url";
import { pipeline } from "stream/promises";
import { getSupabaseConfig, loadServiceKey } from "./supabase-service.mjs";

const __dirname = dirname(fileURLToPath(import.meta.url));
export const ROOT = join(__dirname, "../..");
export const OUT_DIR = join(ROOT, "scripts/generated");

export const CACHE_CONTROL = "public, max-age=2592000";
export const RETRYABLE = new Set(["ENOTFOUND", "ETIMEDOUT", "ECONNRESET", "EAI_AGAIN", "RequestError"]);

export async function withRetry(label, fn, { attempts = 4, baseMs = 800 } = {}) {
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

export function parseSyncArgs(argv = process.argv.slice(2)) {
  return {
    dryRun: argv.includes("--dry-run"),
    force: argv.includes("--force"),
    bucketArg: argv.find((a) => a.startsWith("--bucket="))?.split("=")[1],
  };
}

export function requireEnv(keys) {
  const missing = keys.filter((k) => !process.env[k]?.trim());
  if (missing.length) throw new Error(`缺少环境变量：${missing.join(", ")}`);
}

export async function createSupabaseServiceClient() {
  if (!loadServiceKey()) {
    console.warn("警告: 未设置 SUPABASE_SERVICE_ROLE_KEY，大目录 list 可能受限");
  }
  const { url, key } = getSupabaseConfig();
  return createClient(url, key, {
    auth: { persistSession: false, autoRefreshToken: false },
    realtime: { transport: ws },
  });
}

export async function loadOSSClient({ bucketEnv = "OSS_BUCKET", regionEnv = "OSS_REGION" } = {}) {
  const region = process.env[regionEnv] || "oss-cn-shanghai";
  const bucket = process.env[bucketEnv];
  const accessKeyId = process.env.OSS_ACCESS_KEY_ID;
  const accessKeySecret = process.env.OSS_ACCESS_KEY_SECRET;
  if (!bucket || !accessKeyId || !accessKeySecret) {
    throw new Error(`缺少 ${bucketEnv} / OSS_ACCESS_KEY_ID / OSS_ACCESS_KEY_SECRET`);
  }
  let OSS;
  try {
    OSS = (await import("ali-oss")).default;
  } catch {
    throw new Error("请先运行: cd scripts && npm install ali-oss");
  }
  return { client: new OSS({ region, bucket, accessKeyId, accessKeySecret }), bucket, region };
}

export async function listAllObjects(supabase, bucket) {
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

export async function downloadObject(supabase, bucket, objectPath, dest) {
  const { data, error } = await supabase.storage.from(bucket).download(objectPath);
  if (error) throw error;
  mkdirSync(dirname(dest), { recursive: true });
  await pipeline(data.stream(), createWriteStream(dest));
}

export async function ossObjectExists(client, key) {
  try {
    await withRetry(`head ${key}`, () => client.head(key));
    return true;
  } catch (e) {
    if (e?.status === 404 || e?.code === "NoSuchKey") return false;
    throw e;
  }
}

export async function syncBucketToOSS({
  supabase,
  oss,
  sourceBucket,
  ossKeyPrefix,
  objects,
  dryRun,
  force,
  cacheControl = CACHE_CONTROL,
}) {
  const bucketReport = { total: objects.length, uploaded: 0, skipped: 0, failed: [] };
  for (const { path } of objects) {
    const ossKey = ossKeyPrefix ? `${ossKeyPrefix}/${path}` : path;
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
      await downloadObject(supabase, sourceBucket, path, tmp);
      await withRetry(`put ${ossKey}`, () =>
        oss.put(ossKey, readFileSync(tmp), {
          headers: cacheControl ? { "Cache-Control": cacheControl } : undefined,
        })
      );
      bucketReport.uploaded++;
      console.log(`uploaded ${ossKey}`);
    } catch (e) {
      bucketReport.failed.push({ path, error: String(e?.message ?? e) });
      console.error(`FAILED ${ossKey}:`, e?.message ?? e);
    }
  }
  return bucketReport;
}
