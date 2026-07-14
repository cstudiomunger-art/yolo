# 国内全链路加速 — 手动配置详细操作指南

> **适用对象**：在阿里云 / Supabase / GitHub / 本机 Xcode 上需要人完成的配置。  
> **仓库代码已就绪**（同步脚本、iOS CDNRouter、签名服务模板、Nginx 模板）。  
> **前提（阶段 1 已完成）**：`media.yolohappy.com` CDN → OSS `yolo-media-prod`；GHA 公共桶同步可用。  
> **原则**：全球同一套 App 配置；**用 GeoDNS 按客户端 IP 分流**；不做 App 内 VPN/locale 检测。

**建议执行顺序（严格）**：  
GitHub Secrets → OSS 私有桶 → 全量同步 → Supabase Custom Domain → ECS + 签名 API + Nginx → GeoDNS → Gateway CDN（可选）→ 本地 App 切 gateway → 验收

**预计耗时**：1～3 天（等待证书 / Custom Domain 签发可能占大半）。

---

## 操作总览（勾选）

| # | 步骤 | 完成 |
|---|------|------|
| A | GitHub Secrets 补齐 | ☐ |
| B | OSS 私有桶 `yolo-private-prod` | ☐ |
| C | 全量同步 avatars + chat-images | ☐ |
| D | Supabase Custom Domain `gateway.yolohappy.com` | ☐ |
| E | 购买 ECS / 安全组 / 系统初始化 | ☐ |
| F | 部署客服图签名 API（Node） | ☐ |
| G | Nginx 透明代理 + HTTPS | ☐ |
| H | GeoDNS 分线路 | ☐ |
| I | Gateway CDN 缓存（推荐） | ☐ |
| J | 本机 `Secrets.xcconfig` 切换 gateway | ☐ |
| K | 国内/海外实机验收 | ☐ |
| L | 隐私政策与运营文档确认 | ☐ |

---

## A. GitHub Secrets

**入口**：GitHub 仓库 → **Settings** → **Secrets and variables** → **Actions**

### A.1 必须齐全（公共同步已用过）

| Secret 名称 | 示例值 | 说明 |
|-------------|--------|------|
| `SUPABASE_URL` | `https://edwvrriuwzaaqznklrgi.supabase.co` | **同步脚本源站**；建议保持原 Supabase 域，不要写成 gateway |
| `SUPABASE_SERVICE_ROLE_KEY` | `eyJ...` | Service Role（能列私有桶） |
| `OSS_ACCESS_KEY_ID` | AKIA… | RAM 子账号 AccessKey |
| `OSS_ACCESS_KEY_SECRET` | … | 同上 |
| `OSS_BUCKET` | `yolo-media-prod` | **公共**媒体桶 |
| `OSS_REGION` | `oss-cn-shanghai` | 华东 2 |

### A.2 本次新增

| Secret 名称 | 示例值 | 说明 |
|-------------|--------|------|
| `OSS_PRIVATE_BUCKET` | `yolo-private-prod` | **私有**客服图桶；缺了则 GHA `sync-private` job 失败 |

### A.3 验证

1. **Actions** → workflow **Sync Supabase Storage to OSS** → **Run workflow**
2. 确认两个 job 都绿：`sync-public`、`sync-private`
3. 若 `sync-private` 报错 `OSS_PRIVATE_BUCKET secret is empty` → 回到 A.2

---

## B. 阿里云 OSS — 私有桶

**入口**：[OSS 控制台](https://oss.console.aliyun.com/)

### B.1 创建桶

1. **创建 Bucket**
2. 填写：

| 项 | 值 |
|----|-----|
| 名称 | `yolo-private-prod`（全局唯一；如被占用可加后缀，并同步改 GitHub Secret） |
| 地域 | **华东2（上海）** `oss-cn-shanghai`（与公共桶同区） |
| 存储类型 | 标准 |
| 读写权限 | **私有** |
| 版本控制 | 关闭 |
| 服务端加密 | 可选 |

3. 创建完成后进入 Bucket → **概览**，记下 Bucket 名称与 Endpoint。

### B.2 权限（给同步与 ECS 用）

1. 打开 [RAM 控制台](https://ram.console.aliyun.com/)
2. 确认用于同步的 AccessKey 所属用户至少有：
   - 对 `yolo-media-prod`：`oss:PutObject` / `GetObject` / `HeadObject` / `ListObjects`
   - 对 `yolo-private-prod`：同上
3. **ECS 签名服务**二选一：
   - **推荐**：给 ECS 挂实例 **RAM 角色**，策略含对该私有桶的 `GetObject`（用于 `signatureUrl`）
   - 或：在 ECS 上用环境变量注入与 GHA 相同的 `OSS_ACCESS_KEY_*`（勿提交到 Git）

### B.3 验证

- OSS 控制台能看到空桶 `yolo-private-prod`
- 权限为私有（公网匿名 URL 应 403）

---

## C. 全量同步（avatars + chat-images）

公共桶里 **avatars/** 与私有桶 **chat-images/** 需先灌满，再切 App。

### C.1 本机执行（推荐首次）

1. 打开终端，进入仓库 `scripts` 目录
2. 执行 `npm ci`（已装依赖可跳过）
3. **公共同步**（含 `audio-guides`、`cover-images`、`avatars`）：

在环境里准备好 `SUPABASE_URL`、`SUPABASE_SERVICE_ROLE_KEY`、`OSS_ACCESS_KEY_ID`、`OSS_ACCESS_KEY_SECRET`、`OSS_BUCKET=yolo-media-prod`、`OSS_REGION=oss-cn-shanghai`，然后运行：

```bash
npm run sync:oss
```

4. **私有同步**：

```bash
OSS_PRIVATE_BUCKET=yolo-private-prod npm run sync:oss:private
```

5. 查看报告：
   - `scripts/generated/storage_oss_sync_report.json`
   - `scripts/generated/storage_oss_private_sync_report.json`  
   要求各 bucket 的 `failed` 为空数组。

### C.2 或用 GitHub Actions

1. 先完成 **A.2**
2. Actions → **Run workflow**
3. 两个 job 均成功；artifact 里无失败报告

### C.3 验证

| 检查 | 期望 |
|------|------|
| OSS 公共桶 | 有 `avatars/{userId}/avatar.jpg` 一类对象 |
| OSS 私有桶 | 有 `chat-images/{convId}/....jpg` |
| CDN（可选） | `https://media.yolohappy.com/avatars/...` 对已同步头像返回 200 |

若头像刚传到 Supabase、CDN 仍 404：属正常（最多约 30 分钟；App 会回退 Supabase）。

---

## D. Supabase Custom Domain（海外线路专用）

**目的**：海外 IP 经 GeoDNS 把 `gateway.yolohappy.com` 解析到 Supabase 时，**HTTPS 证书仍然有效**。

**入口**：[Supabase Dashboard](https://supabase.com/dashboard) → 项目 `edwvrriuwzaaqznklrgi`

### D.1 添加域名

1. **Project Settings** → **Custom Domains**（部分账号在 API / Domain 相关页）
2. 添加域名：`gateway.yolohappy.com`
3. 记下控制台给出的验证记录（通常是 TXT 或 CNAME）

### D.2 在阿里云 DNS 添加验证记录

**入口**：[云解析 DNS](https://dns.console.aliyun.com/) → 域名 `yolohappy.com`

1. 按 Supabase 提示添加 **TXT / CNAME**（主机记录可能是 `_acme-challenge` 或官方给出的子域）
2. 保存后等 1～10 分钟
3. 回 Supabase 点 **Verify**，等待证书状态变为 Active

### D.3 临时验证（DNS 仍未分线路前）

若暂时把 `gateway` **默认线路**指到 Custom Domain 目标，在海外 VPS：

```bash
curl -I "https://gateway.yolohappy.com/auth/v1/health"
```

期望：证书合法、HTTP 状态 200 或需 apikey 时的 401（均说明 HTTPS 通）。

**注意**：国内线路稍后会指向 ECS；此时不要急着改中国大陆解析，等 E～G 完成。

### D.4 完成标准

- [ ] Custom Domain 状态 Active
- [ ] 海外 HTTPS 无证书错误

---

## E. 购买并初始化 ECS

**入口**：[ECS 控制台](https://ecs.console.aliyun.com/)

### E.1 创建实例

| 项 | 建议 |
|----|------|
| 地域 | **华东2（上海）** |
| 规格 | 2 核 4G（轻量应用服务器同等亦可） |
| 镜像 | Alibaba Cloud Linux 3 或 Ubuntu 22.04 |
| 系统盘 | ≥ 40GB |
| 公网 IP | 需要（或后续挂 SLB；本指南用公网 IP） |
| 安全组 | 新建专用组（见下） |

### E.2 安全组入站

| 端口 | 来源 | 用途 |
|------|------|------|
| 22 | **仅你的办公 IP** | SSH |
| 443 | `0.0.0.0/0`（或仅阿里云 CDN 回源网段） | HTTPS |
| 80 | `0.0.0.0/0` | HTTP 跳转 HTTPS（可选） |

**不要**对公网开放 3001（签名 API 只监听本机）。

### E.3 系统初始化

SSH 登录后安装：

- Nginx（或 Nginx + OpenResty）
- Node.js **20** LTS
- 可选：`certbot` 或直接用阿里云 SSL 证书文件

记下 **公网 IP**，后面 GeoDNS 中国大陆 A 记录要用。

---

## F. 部署客服图签名 API

仓库模板目录：`scripts/gateway-sign-api/`

### F.1 上传文件

将 `package.json`、`server.mjs` 拷到 ECS，例如 `/opt/yolo-sign-api/`。

### F.2 环境变量（systemd 或 `.env`，勿入库）

| 变量 | 值 |
|------|-----|
| `PORT` | `3001` |
| `SUPABASE_URL` | `https://edwvrriuwzaaqznklrgi.supabase.co`（**直连源站**，勿填 gateway，防环） |
| `SUPABASE_ANON_KEY` | App 同款 anon（签名里用用户 JWT 验权） |
| `OSS_REGION` | `oss-cn-shanghai` |
| `OSS_PRIVATE_BUCKET` | `yolo-private-prod` |
| `OSS_ACCESS_KEY_ID` / `OSS_ACCESS_KEY_SECRET` | 或依赖 ECS RAM 角色（若改过代码支持 STS 则另说；当前模板用 AK） |
| `SIGN_EXPIRES_SEC` | `3600` |

### F.3 安装与守护

1. 目录内执行 `npm ci`
2. 用 **systemd** 或 **pm2** 常驻：`node server.mjs`
3. 开机自启

### F.4 本机冒烟（在 ECS 上）

```bash
curl -s http://127.0.0.1:3001/health
```

期望 JSON：`{"ok":true}`

带真实用户 JWT 与已有会话图 path 再测（从外网经 Nginx 测亦可，见 G.5）：

- 无 Token → 401  
- 无权会话 path → 403  
- 合法 → 200 + `url` 字段为 OSS 预签名链接  

---

## G. Nginx 透明代理 + HTTPS

模板：`infra/gateway/nginx.conf.snippet`

### G.1 证书

1. [SSL 证书控制台](https://yundun.console.aliyun.com/) 申请免费 DV：`gateway.yolohappy.com`
2. 下载 Nginx 格式，放到 ECS（例如 `/etc/nginx/certs/`）
3. 在站点配置中填入 `ssl_certificate` / `ssl_certificate_key`（模板里已注释占位）

### G.2 配置要点（对照模板勾选）

| 路径 | 行为 |
|------|------|
| `/api/v1/media/sign` | 反代本机 `127.0.0.1:3001` |
| `/realtime/v1/` | 反代 Supabase，**开启 WebSocket**，超时 ≥ 3600s |
| `/auth/v1/`、`/functions/v1/`、`/storage/v1/` | 反代；`Cache-Control: private, no-store` |
| `/rest/v1/` | 反代；可按是否用户 JWT 区分缓存头 |
| 回源 Host | 必须为 `edwvrriuwzaaqznklrgi.supabase.co` |
| 透传头 | `apikey`、`Authorization`、`Prefer`、`Range`、`Content-Type` |

### G.3 临时用 hosts 验证（未改公网 DNS 前）

在**你自己的电脑** `/etc/hosts`（或 Windows hosts）加：

```text
{ECS公网IP}  gateway.yolohappy.com
```

然后：

```bash
curl -I -H "apikey: {ANON_KEY}" \
  "https://gateway.yolohappy.com/rest/v1/cities?select=id&limit=1"
```

期望：200（或 PostgREST 正常响应）。证书若因 hosts 与签发域一致通常可通过。

WebSocket：用 App 连 Genius Bar，或 wscat 测 `wss://gateway.yolohappy.com/realtime/v1/websocket`。

测完删掉本机 hosts，避免与后续 GeoDNS 混淆。

### G.4 完成标准

- [ ] HTTPS 正常
- [ ] REST / Auth / Functions 可通
- [ ] Realtime 可握手
- [ ] 签名 API 仅经 443 对外，3001 不对公网

---

## H. GeoDNS 分线路（核心分流）

**入口**：云解析 DNS → `yolohappy.com`

### H.1 解析表（最终态）

| 主机记录 | 线路类型 | 记录类型 | 记录值 | 说明 |
|----------|----------|----------|--------|------|
| `gateway` | **中国大陆** | A | ECS 公网 IP | 国内走 Nginx 代理 |
| 或 `gateway` | **中国大陆** | CNAME | gateway CDN 域名 | 若启用第 I 节 |
| `gateway` | **默认** | CNAME | Supabase Custom Domain 目标 | 海外直连 Supabase |
| `media` | **中国大陆** | CNAME | 现有阿里云 CDN CNAME | 阶段 1 已配 |
| `media` | **默认** | CNAME | **同一** CDN CNAME | 海外也可用 CDN；失败由 App fallback |

TTL 建议 **600 秒**，便于紧急回滚。

### H.2 配置注意

1. 先保证 **默认线路** 的 `gateway` 指向 Custom Domain（海外可用）
2. 再加 **中国大陆** 指向 ECS（或 gateway CDN）
3. 不要用「搜索引擎」等特殊线路覆盖默认
4. 配置后等 5～30 分钟再验

### H.3 验证（必做）

**国内网络**（手机热点 / 国内 VPS）：

```bash
dig +short gateway.yolohappy.com @114.114.114.114
dig +short media.yolohappy.com @114.114.114.114
```

期望：`gateway` → ECS IP（或国内 CDN）；`media` → CDN。

**海外 VPS**：

```bash
dig +short gateway.yolohappy.com @8.8.8.8
dig +short media.yolohappy.com @8.8.8.8
```

期望：`gateway` 解析结果 **不同于** 国内（应接近 Supabase / Custom Domain）；`media` 可为同一 CDN。

**完成标准**：国内与海外 `gateway` 解析不同。

---

## I. Gateway 前 CDN（推荐，冷启动更稳）

**入口**：[CDN 控制台](https://cdn.console.aliyun.com/)

### I.1 添加域名

| 项 | 值 |
|----|-----|
| 加速域名 | `gateway.yolohappy.com` |
| 源站 | ECS 公网 IP（或源站域名） |
| 端口 | 443 |
| 协议 | HTTPS |
| WebSocket | **开启** |
| 证书 | 绑定 `gateway.yolohappy.com` 证书 |

### I.2 缓存规则（防污染）

**强制不缓存 / 不缓存或过滤**：

- `/auth/v1/*`
- `/realtime/v1/*`
- `/functions/v1/*`
- `/storage/v1/*`
- `/api/v1/*`
- `/rest/v1/profiles*`
- `/rest/v1/support_*`
- `/rest/v1/favorite_*`
- `/rest/v1/user_*`
- 全部 POST / PATCH / DELETE

**可缓存**（仅 GET，TTL 5～15 分钟，且源站对「用户 JWT」已返回 `private, no-store`）：

- `/rest/v1/cities*`
- `/rest/v1/attractions*`
- `/rest/v1/city_guides*`
- `/rest/v1/sub_areas*`
- `/rest/v1/audio_guides*`
- `/rest/v1/hotels*`
- `/rest/v1/membership_plans*`
- `/rest/v1/payment_*`
- `/rest/v1/visa_*`
- `/rest/v1/transport_tips*`
- `/rest/v1/common_phrases*`
- `/rest/v1/emergency_*`
- `/rest/v1/app_settings*`  
（其余公开内容表同理）

### I.3 解析调整

GeoDNS **中国大陆** `gateway`：由 A 记录改为 **CNAME → 阿里云 CDN 分配的 CNAME**。  
**默认**线路仍指向 Supabase Custom Domain（海外不进国内 CDN 源站）。

### I.4 验证

同一 anon GET 连打两次：第二次应出现 CDN HIT 头。  
带用户 `Authorization: Bearer eyJ...` 的同 URL：必须 MISS / 不缓存。

---

## J. 本机 App 配置切换

**文件**：仓库根目录 `Secrets.xcconfig`（**禁止 git commit**）

### J.1 切换前确认

- [ ] D～H（建议含 I）均已完成
- [ ] 国内 `dig gateway` 指向 ECS/CDN
- [ ] hosts 临时改过的已删掉

### J.2 写入内容（xcconfig 注意 URL 写法）

```
SUPABASE_URL = https:/$()/gateway.yolohappy.com/
SUPABASE_FALLBACK_URL = https:/$()/edwvrriuwzaaqznklrgi.supabase.co/
MEDIA_CDN_BASE_URL = https:/$()/media.yolohappy.com/
ALI_CDN_BASE_URL = $(MEDIA_CDN_BASE_URL)

INFOPLIST_KEY_SUPABASE_URL = $(SUPABASE_URL)
INFOPLIST_KEY_SUPABASE_FALLBACK_URL = $(SUPABASE_FALLBACK_URL)
INFOPLIST_KEY_MEDIA_CDN_BASE_URL = $(MEDIA_CDN_BASE_URL)
INFOPLIST_KEY_ALI_CDN_BASE_URL = $(ALI_CDN_BASE_URL)
```

`SUPABASE_ANON_KEY` 等其它键保持原样。

### J.3 编译安装

1. Xcode → **Product → Clean Build Folder**
2. 删除手机上旧 App（避免钥匙串 / 缓存干扰，可选）
3. 真机运行（建议国内 4G/5G）
4. Charles / Proxyman：封面/音频/头像应为 `media.yolohappy.com`；API 应为 `gateway.yolohappy.com`

### J.4 切回（紧急）

把 `SUPABASE_URL` 改回：

```
SUPABASE_URL = https:/$()/edwvrriuwzaaqznklrgi.supabase.co/
```

或阿里云 DNS 把 **中国大陆** `gateway` 临时改成与 **默认** 相同（Custom Domain），无需发版。

---

## K. 验收清单

### K.1 国内 4G 实机

| # | 场景 | 通过标准 | ☐ |
|---|------|----------|---|
| 1 | 邮箱登录/注册 | < 2s | ☐ |
| 2 | Apple 登录 | 回调成功 | ☐ |
| 3 | 冷启动城市列表 | < 2s | ☐ |
| 4 | 封面 | < 1s | ☐ |
| 5 | 音频起播（未离线） | < 2s | ☐ |
| 6 | 换头像 | 本机即时；其它页 < 1s | ☐ |
| 7 | 客服发图/收图 | 发送即时；收图 < 2s | ☐ |
| 8 | 客服消息 | Realtime < 5s | ☐ |
| 9 | 收藏 / 会员状态 | 正常 | ☐ |

### K.2 分流

| # | 场景 | 期望 | ☐ |
|---|------|------|---|
| R1 | 国内 4G | Charles 见 `gateway` + `media` | ☐ |
| R2 | 海外 WiFi | `gateway` 不经国内 ECS IP | ☐ |
| R3 | 来华 en_US 国内网 | 与 R1 相同（不看语言） | ☐ |
| R4 | 国内开美国出口 VPN | `gateway` 走默认线路（海外） | ☐ |

### K.3 故障演练

| 场景 | 操作 | 期望 | ☐ |
|------|------|------|---|
| CDN 新文件 404 | 新传头像后立刻打开 | 回退 Supabase 仍可显示 | ☐ |
| 停 ECS（或安全组拒 443） | 模拟 gateway 挂 | 媒体仍可能靠 CDN/fallback；下次冷启动可能粘性切 FALLBACK_URL | ☐ |
| DNS 回滚 | 中国大陆 `gateway` → Custom Domain | 国内恢复直连 Supabase | ☐ |

---

## L. 运营与合规（上线同步做）

1. **隐私政策**：补充媒体经阿里云 CDN/OSS、API 经国内 ECS 转发至美西 Supabase
2. **Admin**：继续直连 `*.supabase.co`，无需改后台域名
3. **内容上新**：上传后最多约 30 分钟 OSS 可见；大替换可手动 Run GHA 或本机 `npm run sync:oss -- --force`
4. **CDN 刷新**：大批量更新后可在 CDN 控制台刷新 `/audio-guides/`、`/cover-images/`、`/avatars/`

---

## 紧急回滚速查

| 手段 | 操作 | 生效时间 |
|------|------|----------|
| DNS | `gateway` 中国大陆改为与默认相同（Custom Domain） | TTL 内，约 5～10 分钟 |
| App | `SUPABASE_URL` 改回 `*.supabase.co` 重装 | 立即 |
| 媒体 | 清空 `MEDIA_CDN_BASE_URL` hotfix | 发版后 |

---

## 常见问题

**Q1：海外 App 报证书错误**  
Custom Domain 未生效，或默认线路仍指 ECS 且证书不匹配 → 检查 D 与 H。

**Q2：国内登录快但客服图仍慢**  
私有桶未同步或签名 API 未通 → 查 C 与 F；App 会回退 Supabase signed URL。

**Q3：换头像后仍是旧图**  
`?v=` 已有；若 CDN 强缓存可短时刷新 `/avatars/`；或等 TTL / 用 fallback。

**Q4：GHA sync-private 失败**  
未配 `OSS_PRIVATE_BUCKET`，或 Service Role 无权列 `chat-images`。

**Q5：Realtime 频繁断线**  
确认 Nginx WebSocket Upgrade；Gateway CDN 对 `/realtime` **不缓存**且开启 WS 回源。

---

## 相关仓库文件（只读参考，操作以本指南为准）

| 路径 | 用途 |
|------|------|
| [`docs/media-url-spec.md`](media-url-spec.md) | URL 契约 |
| [`docs/china-cdn-phase1-操作指南.md`](china-cdn-phase1-操作指南.md) | 阶段 1（已完成） |
| [`Secrets.example.xcconfig`](../Secrets.example.xcconfig) | 三键示例 |
| [`infra/gateway/nginx.conf.snippet`](../infra/gateway/nginx.conf.snippet) | Nginx 模板 |
| [`scripts/gateway-sign-api/`](../scripts/gateway-sign-api/) | 签名服务 |
| [`.github/workflows/sync-oss-media.yml`](../.github/workflows/sync-oss-media.yml) | 双 job 同步 |

按 **A → K** 顺序勾选执行即可完成手动侧全链路配置。
