# 媒体 URL 规范（CDN + gateway）

三端契约：Admin 写入、iOS 读取（CDN / gateway）、官网读取（Supabase）。与 [content-markdown-spec.md](content-markdown-spec.md) 互补。

## 写入（Admin → Supabase）

- Admin（admin-vue）上传至 Supabase Storage，DB 存 **完整 Supabase public URL** 或 bucket 内相对路径。
- **不上传 OSS**，不双写；靠 GHA cron（约 30 分钟）镜像。

## OSS / CDN 同步 bucket


| bucket | OSS 桶 | 同步 | iOS 读取 |
|--------|--------|------|----------|
| `audio-guides` | `yolo-media-prod`（公共） | 是 | media CDN primary → Supabase fallback |
| `cover-images` | `yolo-media-prod` | 是 | media CDN primary → Supabase fallback |
| `avatars` | `yolo-media-prod` | 是 | media CDN primary → Supabase fallback |
| `chat-images` | `yolo-private-prod`（私有） | 是 | 国内：gateway `/api/v1/media/sign` → OSS 预签名；失败或海外：Supabase `createSignedURL` |

## OSS / CDN 路径

```
公共 OSS key:  {bucket}/{objectPath}
CDN URL:       https://media.yolohappy.com/{bucket}/{objectPath}
私有 OSS key:  chat-images/{convId}/{uuid}.jpg
Supabase:      https://{ref|gateway}/storage/v1/object/public/{bucket}/{objectPath}
```

示例：

```
audio-guides/city-guides/beijing_hutong_citywalk.mp3
cover-images/sub-areas/beijing/foo.jpg
avatars/{userId}/avatar.jpg
chat-images/{convId}/{uuid}.jpg
```

## 各端读取策略

| 端 | 策略 |
|----|------|
| **iOS App** | `CDNRouter`：eligible bucket → CDN primary，失败回退 Supabase；客服图走 `SignedMediaURLService` |
| **Admin 预览** | 直连 Supabase（不参与 CDN / gateway） |
| **site 官网** | `resolveCoverImageUrl` → Supabase（全球受众，默认不走国内 CDN） |

## API / Auth（gateway）

| 配置 | 含义 |
|------|------|
| `SUPABASE_URL` | `https://gateway.yolohappy.com/`（GeoDNS：国内 ECS / 海外 Custom Domain） |
| `SUPABASE_FALLBACK_URL` | 原 `*.supabase.co`（媒体回退源；gateway 故障时备用） |
| `MEDIA_CDN_BASE_URL` | `https://media.yolohappy.com/` |

## CMS 上传后 App 生效

1. Admin 上传并保存 DB
2. `npm run sync:oss` / `npm run sync:oss:private`（或 GHA 定时，约 30 分钟）— 替换文件加 `--force`
3. 可选：CDN 控制台刷新 `/audio-guides/`、`/cover-images/`、`/avatars/`
4. App：Profile → Refresh from CMS

## 相关文件

- iOS：[`YOLO/Utils/CDNRouter.swift`](../YOLO/Utils/CDNRouter.swift)、[`YOLO/Utils/SignedMediaURLService.swift`](../YOLO/Utils/SignedMediaURLService.swift)
- 同步：[`scripts/sync-storage-to-oss.mjs`](../scripts/sync-storage-to-oss.mjs)、[`scripts/sync-private-storage-to-oss.mjs`](../scripts/sync-private-storage-to-oss.mjs)
- 运维：[`docs/china-cdn-full-ops.md`](china-cdn-full-ops.md)
