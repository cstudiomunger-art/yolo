#!/usr/bin/env node
/**
 * Sync private Supabase Storage buckets (chat-images) to a private Aliyun OSS bucket.
 *
 * Usage:
 *   cd scripts && npm install
 *   SUPABASE_SERVICE_ROLE_KEY=... \
 *   OSS_ACCESS_KEY_ID=... OSS_ACCESS_KEY_SECRET=... \
 *   OSS_PRIVATE_BUCKET=yolo-private-prod OSS_REGION=oss-cn-shanghai \
 *   node sync-private-storage-to-oss.mjs
 *
 * Options:
 *   --dry-run
 *   --force
 *   --bucket=chat-images
 */

import { mkdirSync, writeFileSync } from "fs";
import { join } from "path";
import {
  OUT_DIR,
  createSupabaseServiceClient,
  loadOSSClient,
  listAllObjects,
  parseSyncArgs,
  requireEnv,
  syncBucketToOSS,
} from "./lib/oss-sync-core.mjs";

const REPORT_PATH = join(OUT_DIR, "storage_oss_private_sync_report.json");
const BUCKETS = ["chat-images"];

const { dryRun, force, bucketArg } = parseSyncArgs();
const buckets = bucketArg ? [bucketArg] : BUCKETS;

async function main() {
  requireEnv([
    "SUPABASE_SERVICE_ROLE_KEY",
    "OSS_ACCESS_KEY_ID",
    "OSS_ACCESS_KEY_SECRET",
    "OSS_PRIVATE_BUCKET",
    "OSS_REGION",
  ]);

  const supabase = await createSupabaseServiceClient();
  const { client: oss, bucket: ossBucket } = await loadOSSClient({ bucketEnv: "OSS_PRIVATE_BUCKET" });

  const report = {
    generatedAt: new Date().toISOString(),
    dryRun,
    force,
    ossBucket,
    buckets: {},
  };

  for (const bucket of buckets) {
    console.log(`\n==> private ${bucket} → ${ossBucket}/${bucket}/`);
    const objects = await listAllObjects(supabase, bucket);
    // Private objects: no long public Cache-Control
    report.buckets[bucket] = await syncBucketToOSS({
      supabase,
      oss,
      sourceBucket: bucket,
      ossKeyPrefix: bucket,
      objects,
      dryRun,
      force,
      cacheControl: "private, max-age=3600",
    });
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
