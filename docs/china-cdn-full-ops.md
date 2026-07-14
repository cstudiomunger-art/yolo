# 国内全链路加速 — 运维执行清单（控制台操作）

> 仓库内代码/脚本已就绪。以下步骤需在你的阿里云 / Supabase / DNS 控制台完成。  
> 对照完整方案：`.cursor/plans/国内全链路加速_c45f3503.plan.md`

---

## 0. GitHub Secrets（新增）

在仓库 Settings → Secrets 增加：

| Secret | 示例 |
|--------|------|
| `OSS_PRIVATE_BUCKET` | `yolo-private-prod` |

已有 `OSS_BUCKET`（公共 `yolo-media-prod`）保持不变。GHA 现含两个 job：`sync-public`、`sync-private`。

---

## 1. Supabase Custom Domain

1. Dashboard → 项目 `edwvrriuwzaaqznklrgi` → Custom Domains
2. 添加 `gateway.yolohappy.com`
3. 按提示添加 DNS TXT/CNAME 验证
4. 等待证书签发
5. 海外网络验证：`curl -I https://gateway.yolohappy.com/auth/v1/health`

---

## 2. OSS

### 2.1 公共桶（已有）

- 桶：`yolo-media-prod`
- 新增确认目录：`avatars/`（首次 sync:oss 会自动创建对象）

### 2.2 新建私有桶

1. 创建 `yolo-private-prod`，地域华东 2（上海）
2. 读写权限：**私有**
3. 无需挂 CDN

### 2.3 全量同步（本机或 GHA）

```bash
cd scripts && npm ci
# 公共（含 avatars）
SUPABASE_URL=... SUPABASE_SERVICE_ROLE_KEY=... \
OSS_ACCESS_KEY_ID=... OSS_ACCESS_KEY_SECRET=... \
OSS_BUCKET=yolo-media-prod OSS_REGION=oss-cn-shanghai \
npm run sync:oss

# 私有 chat-images
OSS_PRIVATE_BUCKET=yolo-private-prod npm run sync:oss:private
```

报告：`scripts/generated/storage_oss_sync_report.json`、`storage_oss_private_sync_report.json`

---

## 3. ECS Gateway

1. 华东 2 购买 2C4G ECS（或轻量应用服务器）
2. 安装 Nginx + Node 20
3. 部署签名服务：
   - 拷贝 `scripts/gateway-sign-api/` 到 ECS
   - `npm ci && node server.mjs`（systemd/pm2 守护）
   - 环境变量：`SUPABASE_URL`、`SUPABASE_SERVICE_ROLE_KEY`、`OSS_*`、`OSS_PRIVATE_BUCKET`、`PORT=3001`
4. Nginx：参考 `infra/gateway/nginx.conf.snippet`，配置证书到 `gateway.yolohappy.com`
5. 冒烟：
   - `curl -I -H "apikey: ANON" https://gateway.yolohappy.com/rest/v1/cities?select=id&limit=1`
   - 登录用户 JWT 测 `/api/v1/media/sign?path={convId}/x.jpg`

---

## 4. Gateway CDN（可选但已规划）

1. CDN 添加 `gateway.yolohappy.com` → 源站 ECS
2. HTTPS + WebSocket 回源
3. **不缓存**：`/auth`、`/realtime`、`/functions`、`/storage`、用户态 REST
4. **可缓存**：anon GET `/rest/v1/cities*` 等白名单（见方案正文）

---

## 5. GeoDNS

| 主机 | 线路 | 值 |
|------|------|-----|
| `gateway` | 中国大陆 | ECS IP 或 gateway CDN CNAME |
| `gateway` | 默认 | Supabase Custom Domain |
| `media` | 中国大陆 | 现有 media CDN CNAME |
| `media` | 默认 | 同上 CDN CNAME |

验证：

```bash
dig +short gateway.yolohappy.com @114.114.114.114
dig +short gateway.yolohappy.com @8.8.8.8
```

国内与海外解析结果必须不同。

---

## 6. App 切换（gateway 上线后）

本地 `Secrets.xcconfig`（勿提交）：

```
SUPABASE_URL = https:/$()/gateway.yolohappy.com/
SUPABASE_FALLBACK_URL = https:/$()/edwvrriuwzaaqznklrgi.supabase.co/
MEDIA_CDN_BASE_URL = https:/$()/media.yolohappy.com/
```

Xcode Clean → 真机安装 → Charles 确认 host。

**当前代码已支持**：avatars CDN、客服图签名回退、CDNRouter media 主机解析；在 gateway DNS 未就绪前请保持 `SUPABASE_URL` 为原 Supabase 域。

---

## 7. 验收摘要

- 国内 4G：登录 < 2s；封面/头像 < 1s；客服图 < 2s；Realtime < 5s
- 海外：gateway 不经国内 ECS
- 停 ECS：App 媒体仍可用（CDNRouter fallback）；紧急 DNS 改默认线路

---

## 仓库内已交付文件

| 路径 | 作用 |
|------|------|
| `scripts/sync-storage-to-oss.mjs` | 公共桶含 avatars |
| `scripts/sync-private-storage-to-oss.mjs` | chat-images → 私有桶 |
| `scripts/gateway-sign-api/` | ECS 签名服务 |
| `infra/gateway/nginx.conf.snippet` | Nginx 模板 |
| `.github/workflows/sync-oss-media.yml` | 公共 + 私有双 job |
| `YOLO/Utils/CDNRouter.swift` | avatars + media 主机 |
| `YOLO/Utils/SignedMediaURLService.swift` | 客服图签名 |
| `YOLO/Utils/GatewayFallback.swift` | gateway 探活辅助 |
| `docs/media-url-spec.md` | URL 契约 |
