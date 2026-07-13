# 阶段 1：国内媒体 CDN — 详细操作指南

> 目标：音频/封面走 `media.yolohappy.com` → 阿里云 CDN → OSS，国内用户加载 < 2s。  
> 预计耗时：2–3 小时（首次配置）+ 全量同步时间（视文件量）。  
> 前提：已备案域名 **yolohappy.com**，阿里云账号，Supabase 项目 `edwvrriuwzaaqznklrgi`。

---

## 一、整体流程一览

```
1. 阿里云 OSS 建桶（cn-shanghai）
2. CDN 加速域名 media.yolohappy.com → OSS
3. DNS 解析（GeoDNS：国内 → CDN，海外 → 可选 Supabase）
4. 全量同步 Supabase Storage → OSS
5. 本地 Secrets.xcconfig 配置 MEDIA_CDN_BASE_URL
6. App 编译运行 + 国内实机验收
7. 配置增量同步 cron（可选，建议做）
```

**本阶段不需要：** 购买 ECS、gateway、改 Supabase 数据库。

---

## 二、阿里云 OSS 配置

### 2.1 创建 Bucket

1. 登录 [阿里云 OSS 控制台](https://oss.console.aliyun.com/)
2. 点击 **创建 Bucket**
3. 填写：

| 项 | 建议值 |
|----|--------|
| Bucket 名称 | `yolo-media-prod`（全局唯一，可自定） |
| 地域 | **华东2（上海）** `oss-cn-shanghai` |
| 存储类型 | 标准存储 |
| 读写权限 | **公共读**（配合 CDN；若需更安全可私有 + CDN 回源鉴权，本指南先用公共读） |
| 版本控制 | 关闭 |
| 服务端加密 | 可选 |

4. 创建完成

### 2.2 跨域 CORS（可选，App 直链 GET 通常不需要复杂 CORS）

1. 进入 Bucket → **数据安全** → **跨域设置** → **创建规则**
2. 来源：`*`
3. 允许 Methods：`GET`、`HEAD`
4. 允许 Headers：`*`
5. 暴露 Headers：`ETag`、`Content-Length`
6. 缓存：`3600`

### 2.3 目录结构约定

同步脚本会把文件放到：

```
yolo-media-prod/
  audio-guides/     ← 对应 Supabase bucket audio-guides
  cover-images/     ← 对应 Supabase bucket cover-images
```

**不要改这层目录名**，与 App `CDNRouter` 路径规则一致。

### 2.4 记录 OSS 信息（后面要用）

| 变量 | 示例 |
|------|------|
| OSS_REGION | `oss-cn-shanghai` |
| OSS_BUCKET | `yolo-media-prod` |
| OSS 外网 Endpoint | `yolo-media-prod.oss-cn-shanghai.aliyuncs.com` |

---

## 三、阿里云 CDN 配置

### 3.1 添加加速域名

1. 打开 [CDN 控制台](https://cdn.console.aliyun.com/)
2. **域名管理** → **添加域名**
3. 填写：

| 项 | 值 |
|----|-----|
| 加速域名 | `media.yolohappy.com` |
| 业务类型 | **图片小文件** 或 **全站加速**（均可；音频为主选全站加速更稳） |
| 源站类型 | **OSS 域名** |
| 源站地址 | 选择刚建的 Bucket `yolo-media-prod.oss-cn-shanghai.aliyuncs.com` |
| 加速区域 | **仅中国内地**（海外用户不走此 CDN，由 DNS 默认线路处理） |
| 端口 | 443 HTTPS |

4. 提交后等待审核/部署（通常几分钟）

### 3.2 HTTPS 证书

1. 域名详情 → **HTTPS 配置** → 开启 HTTPS
2. 证书来源：
   - **推荐**：阿里云免费证书（需先在 SSL 控制台申请 `media.yolohappy.com` 证书）
   - 或上传已有证书
3. 开启 **HTTP/2**
4. 可选：HTTP 自动跳转 HTTPS

### 3.3 缓存配置

1. 域名详情 → **缓存配置** → **缓存过期时间** → **添加**

| 类型 | 缓存时间 |
|------|----------|
| 目录 `/audio-guides/` | 30 天 |
| 目录 `/cover-images/` | 30 天 |
| `.mp3` `.m4a` `.jpg` `.jpeg` `.png` `.webp` | 30 天 |

2. **Range 回源**：**必须开启**（音频流式播放依赖 HTTP Range）
   - 路径：域名详情 → **回源配置** → 开启 **Range 回源**

### 3.4 记录 CDN CNAME

添加域名后，CDN 会分配 CNAME，形如：

```
media.yolohappy.com.w.kunlunaq.com
```

**复制保存**，下一步 DNS 要用。

### 3.5 刷新预热（日常运维）

1. 域名详情 → **刷新预热**
2. 上传新音频/封面后，可 **URL 刷新** 单条路径，例如：
   ```
   https://media.yolohappy.com/audio-guides/sub-areas/foo.mp3
   ```
3. 全量同步脚本完成后可做一次 **目录刷新**（`/audio-guides/`、`/cover-images/`）

---

## 四、DNS 解析（GeoDNS）

在 **yolohappy.com** 的 DNS 服务商（阿里云云解析或其他）配置：

### 4.1 国内线路（中国大陆）

| 记录类型 | 主机记录 | 线路 | 记录值 |
|----------|----------|------|--------|
| CNAME | `media` | **中国大陆** | CDN 分配的 CNAME（如 `xxx.w.kunlunaq.com`） |

### 4.2 海外/默认线路

海外用户不应绕路走国内 CDN。两种做法（二选一）：

**做法 A（推荐，简单）**  
默认线路 **不配置** `media` 记录。海外 App 未配置 `MEDIA_CDN_BASE_URL` 或仅国内构建带 CDN 配置。

**做法 B（GeoDNS 完整分流）**  
| 记录类型 | 主机记录 | 线路 | 记录值 |
|----------|----------|------|--------|
| CNAME | `media` | **默认** | 指向 Supabase Storage 自定义域或留空 |

> 当前 App 逻辑：配置了 `MEDIA_CDN_BASE_URL` 则国内 CDN 优先；未配置则直连 Supabase。海外 TestFlight/生产包可不注入 CDN URL。

### 4.3 验证 DNS

**国内网络**（手机 4G 或国内 VPS）：

```bash
dig media.yolohappy.com
# 或
nslookup media.yolohappy.com
```

应解析到 CDN 节点 IP（非 Supabase）。

**海外 VPS**（若配置了默认线路）应解析到不同目标。

### 4.4 HTTPS 探测

```bash
curl -I "https://media.yolohappy.com/cover-images/某个已同步文件.jpg"
```

期望：
- `HTTP/2 200`
- 响应头含 `via`、`x-cache` 或阿里云 CDN 标识
- 第二次请求可能显示 `X-Cache: HIT`

---

## 五、Supabase Storage → OSS 全量同步

### 5.1 准备密钥

| 变量 | 来源 |
|------|------|
| `SUPABASE_URL` | `Secrets.xcconfig` 或 Supabase Dashboard |
| `SUPABASE_SERVICE_ROLE_KEY` | Supabase Dashboard → Settings → API → **service_role**（勿提交 Git） |
| `OSS_ACCESS_KEY_ID` | 阿里云 RAM → 创建 AccessKey（建议子账号仅 OSS 权限） |
| `OSS_ACCESS_KEY_SECRET` | 同上 |
| `OSS_BUCKET` | `yolo-media-prod` |
| `OSS_REGION` | `oss-cn-shanghai` |

**RAM 最小权限**：该 AK 仅需目标 Bucket 的读写（`PutObject`、`HeadObject`、`ListObjects`）。

### 5.2 安装依赖

在项目根目录执行：

```bash
cd /Users/vesperal/Desktop/YOLO/scripts
npm install
```

（已包含 `@supabase/supabase-js` 与 `ali-oss`）

### 5.3 试运行（不实际上传）

```bash
cd /Users/vesperal/Desktop/YOLO/scripts

SUPABASE_URL="https://edwvrriuwzaaqznklrgi.supabase.co" \
SUPABASE_SERVICE_ROLE_KEY="你的service_role_key" \
OSS_ACCESS_KEY_ID="你的AK" \
OSS_ACCESS_KEY_SECRET="你的SK" \
OSS_BUCKET="yolo-media-prod" \
OSS_REGION="oss-cn-shanghai" \
node sync-storage-to-oss.mjs --dry-run
```

确认输出的路径列表合理、无报错。

### 5.4 正式全量同步

```bash
SUPABASE_URL="https://edwvrriuwzaaqznklrgi.supabase.co" \
SUPABASE_SERVICE_ROLE_KEY="你的service_role_key" \
OSS_ACCESS_KEY_ID="你的AK" \
OSS_ACCESS_KEY_SECRET="你的SK" \
OSS_BUCKET="yolo-media-prod" \
OSS_REGION="oss-cn-shanghai" \
npm run sync:oss
```

或只同步某一桶：

```bash
... npm run sync:oss -- --bucket=audio-guides
... npm run sync:oss -- --bucket=cover-images
```

### 5.5 查看报告

同步结束后查看：

```
scripts/generated/storage_oss_sync_report.json
```

关注 `uploaded`、`skipped`、`failed` 数量。若有 `failed`，根据 `path` 和 `error` 重跑或手动处理。

### 5.6 同步后 CDN 刷新（建议）

全量完成后，在 CDN 控制台对以下路径做 **目录刷新**：

- `/audio-guides/`
- `/cover-images/`

---

## 六、增量同步（建议配置）

CMS 上传新文件后，目前依赖定时同步（CMS 双写 OSS 尚未实现）。

**后台预览**始终走 Supabase，不要求国内 CDN 加速。国内 App 用户走 `media.yolohappy.com`，需等 OSS 同步完成。

替换已存在文件时使用 `--force`：

```bash
npm run sync:oss -- --force
```

或仅同步单个 bucket：

```bash
npm run sync:oss -- --bucket=cover-images --force
```

详见 [media-url-spec.md](media-url-spec.md)。

### 6.1 本地 cron 示例（每 15 分钟）

```bash
crontab -e
```

添加（路径与密钥换成你的）：

```cron
*/15 * * * * cd /Users/vesperal/Desktop/YOLO/scripts && SUPABASE_URL=... SUPABASE_SERVICE_ROLE_KEY=... OSS_ACCESS_KEY_ID=... OSS_ACCESS_KEY_SECRET=... OSS_BUCKET=yolo-media-prod OSS_REGION=oss-cn-shanghai /usr/local/bin/node sync-storage-to-oss.mjs >> /tmp/yolo-oss-sync.log 2>&1
```

### 6.2 GitHub Actions（可选）

仓库已包含 [`.github/workflows/sync-oss-media.yml`](../.github/workflows/sync-oss-media.yml)（每 30 分钟 + 手动触发）。在 GitHub Repository Secrets 配置：

- `SUPABASE_URL`
- `SUPABASE_SERVICE_ROLE_KEY`
- `OSS_ACCESS_KEY_ID`
- `OSS_ACCESS_KEY_SECRET`
- `OSS_BUCKET`（如 `yolo-media-prod`）
- `OSS_REGION`（如 `oss-cn-shanghai`）

也可在 `.github/workflows/` 自行调整 cron。

---

## 七、App 本地配置

### 7.1 编辑 Secrets.xcconfig

复制示例（若尚未配置）：

```bash
cp Secrets.example.xcconfig Secrets.xcconfig
```

在 `Secrets.xcconfig` 中设置（注意 xcconfig URL 写法）：

```
MEDIA_CDN_BASE_URL = https:/$()/media.yolohappy.com/
```

或：

```
ALI_CDN_BASE_URL = https:/$()/media.yolohappy.com/
MEDIA_CDN_BASE_URL = $(ALI_CDN_BASE_URL)
```

**不要提交** `Secrets.xcconfig` 到 Git。

### 7.2 Xcode 编译

1. 打开 `YOLO.xcodeproj`
2. Clean Build Folder（⇧⌘K）
3. 运行到真机（建议国内 4G 测试）

### 7.3 App 行为说明

| 场景 | 行为 |
|------|------|
| 配置了 `MEDIA_CDN_BASE_URL` | 音频/封面优先 `https://media.yolohappy.com/{bucket}/{path}` |
| CDN 404/超时 | 自动回退 Supabase Storage 直链 |
| 未配置 CDN | 与改前一致，直连 Supabase |
| 用户头像、客服私密图 | 仍走 Supabase signed URL，不经 media CDN |

---

## 八、验收测试清单

### 8.1 命令行（国内网络）

```bash
# 1. 替换为 OSS 中真实存在的文件路径
curl -I "https://media.yolohappy.com/cover-images/sub-areas/beijing/某个文件.jpg"

# 2. 音频 Range 请求
curl -I -H "Range: bytes=0-1023" "https://media.yolohappy.com/audio-guides/sub-areas/某个文件.mp3"
```

期望：`206 Partial Content` 或 `200`，且有 CDN 缓存头。

### 8.2 App 实机（国内 4G/5G）

| 测试项 | 通过标准 |
|--------|----------|
| 景点列表封面 | 首张 < 1 秒 |
| 景点详情音频起播 | < 2 秒（未离线下载） |
| 弱网降级 | 关闭 CDN 或故意错误 URL 时，仍能播放（回退 Supabase） |
| 海外 WiFi（可选） | 未配 CDN 的构建仍正常 |

### 8.3 对比基线

阶段 0 若已记录「改前」耗时，与改后对比，封面/音频应有明显下降。

---

## 九、常见问题

### Q1：CDN 返回 404，但 Supabase 有文件

**原因**：OSS 未同步或路径不一致。  
**处理**：
1. 查 `storage_oss_sync_report.json` 是否上传成功
2. 在 OSS 控制台确认对象存在：`audio-guides/...` 或 `cover-images/...`
3. 执行 CDN URL 刷新

### Q2：App 仍走 Supabase，不走 CDN

**原因**：`Secrets.xcconfig` 未配置或未编入 App。  
**处理**：
1. 确认 `MEDIA_CDN_BASE_URL` 无「你的」等占位符
2. 确认 `SupabaseConfig.plist` 含 `MEDIA_CDN_BASE_URL` 映射
3. Clean Build 后重装 App

### Q3：音频无法播放 / 一直 loading

**原因**：CDN 未开启 Range 回源。  
**处理**：CDN 控制台 → 回源配置 → 开启 Range 回源。

### Q4：HTTPS 证书错误

**原因**：`media.yolohappy.com` 证书未部署到 CDN。  
**处理**：SSL 控制台申请证书并绑定到 CDN 域名。

### Q5：国内快、海外变慢

**原因**：海外也解析到国内 CDN。  
**处理**：DNS 默认线路不要指向国内 CDN；海外包不注入 `MEDIA_CDN_BASE_URL`。

### Q6：同步脚本报错缺少 ali-oss

```bash
cd scripts && npm install
```

### Q7：同步很慢

音频文件多且大，全量首次可能需 30 分钟–数小时。可分批：

```bash
npm run sync:oss -- --bucket=cover-images
npm run sync:oss -- --bucket=audio-guides
```

---

## 十、阶段 1 完成标准

- [ ] OSS Bucket 已创建，结构与 Supabase 一致
- [ ] CDN `media.yolohappy.com` 已上线，HTTPS + Range 已开启
- [ ] DNS 国内线路指向 CDN CNAME
- [ ] 全量同步完成，`storage_oss_sync_report.json` 无致命失败
- [ ] `Secrets.xcconfig` 已配置 `MEDIA_CDN_BASE_URL`
- [ ] 国内实机：封面 < 1s，音频起播 < 2s
- [ ] CDN 故障时 App 可回退 Supabase
- [ ] （建议）增量同步 cron 已配置

---

## 十一、阶段 2 预告

阶段 1 稳定后，再配置 **gateway.yolohappy.com** 代理 Supabase（JSON / 登录 / AI），App 将 `SUPABASE_URL` 改为 gateway 域。详见完整方案文档。

---

## 附录：关键文件索引

| 文件 | 作用 |
|------|------|
| [Secrets.example.xcconfig](../Secrets.example.xcconfig) | CDN URL 配置示例 |
| [SupabaseConfig.plist](../SupabaseConfig.plist) | 注入 Info.plist |
| [YOLO/Utils/CDNRouter.swift](../YOLO/Utils/CDNRouter.swift) | URL 重写逻辑 |
| [scripts/sync-storage-to-oss.mjs](../scripts/sync-storage-to-oss.mjs) | 同步脚本 |
| [scripts/package.json](../scripts/package.json) | `npm run sync:oss` |
