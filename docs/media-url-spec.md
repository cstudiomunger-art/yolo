# 媒体 URL 规范（CDN 阶段 1）

三端契约：Admin 写入、iOS 读取（CDN）、官网读取（Supabase）。与 [content-markdown-spec.md](content-markdown-spec.md) 互补。

## 写入（Admin → Supabase）

- Admin（admin-vue）上传至 Supabase Storage，DB 存 **完整 Supabase public URL** 或 bucket 内相对路径。
- **不上传 OSS**，不双写。

## CDN 同步 bucket

仅以下 bucket 会同步到 OSS / `media.yolohappy.com`：

| bucket | 同步 OSS | iOS CDN |
|--------|----------|---------|
| `audio-guides` | 是 | primary |
| `cover-images` | 是 | primary |
| `avatars` | 否 | Supabase only |
| `chat-images` | 否 | signed URL only |

## OSS / CDN 路径

```
OSS key:  {bucket}/{objectPath}
CDN URL:  https://media.yolohappy.com/{bucket}/{objectPath}
Supabase: https://{ref}.supabase.co/storage/v1/object/public/{bucket}/{objectPath}
```

示例：

```
audio-guides/city-guides/beijing_hutong_citywalk.mp3
audio-guides/voices/sub_area/{id}/{variantId}.mp3
cover-images/sub-areas/beijing/foo.jpg
```

## 各端读取策略

| 端 | 策略 |
|----|------|
| **iOS App** | `CDNRouter`：eligible bucket → CDN primary，失败回退 Supabase |
| **Admin 预览** | 直连 Supabase（不参与 CDN） |
| **site 官网** | `resolveCoverImageUrl` → Supabase（全球受众，默认不走 CDN） |

## CMS 上传后 App 生效

1. Admin 上传并保存 DB
2. `npm run sync:oss`（或 GHA 定时，约 30 分钟）— 替换文件加 `--force`
3. 可选：CDN 控制台目录刷新 `/audio-guides/`、`/cover-images/`
4. App：Profile → Refresh from CMS

## 相关文件

- iOS：[`YOLO/Utils/CDNRouter.swift`](../YOLO/Utils/CDNRouter.swift)
- 同步：[`scripts/sync-storage-to-oss.mjs`](../scripts/sync-storage-to-oss.mjs)
- 操作指南：[`china-cdn-phase1-操作指南.md`](china-cdn-phase1-操作指南.md)
