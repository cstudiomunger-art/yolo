# 国内全链路加速 — 手动配置详细操作指南

> **适用对象**：在阿里云 / Supabase / GitHub / 本机 Xcode 上需要人完成的配置。  
> **仓库代码已就绪**（同步脚本、iOS CDNRouter、签名服务模板、Nginx 模板）。  
> **前提（阶段 1 已完成）**：`media.yolohappy.com` CDN → OSS `yolo-media-prod`；GHA 公共桶同步可用。  
> **原则**：全球同一套 App 配置；**用 GeoDNS 按客户端 IP 分流**；不做 App 内 VPN/locale 检测。

**建议执行顺序（严格）**：  
GitHub Secrets → OSS 私有桶 → 全量同步 → Supabase Custom Domain → ECS + 签名 API + Nginx → GeoDNS → Gateway CDN（可选）→ 本地 App 切 gateway → 验收

**预计耗时**：1～3 天（等待证书 / Custom Domain 签发可能占大半）。

---

## 当前实施方案（复用已有服务器 · 推荐照此执行）

> **现状约定**：不新购 ECS；在你**已有、且上面还有其它程序**的机器上叠加 YOLO gateway。  
> **媒体加速已通**：`media.yolohappy.com` → OSS `yolo-media-prod`。  
> **App 暂不切**：`Secrets.xcconfig` 的 `SUPABASE_URL` 仍保持 `*.supabase.co`，直到本节第 6 步验收通过。

### 目标形态

```text
国内用户 ──DNS(中国大陆)──► 已有服务器:443 Nginx
                              ├─ /api/v1/media/sign → 127.0.0.1:3001（签名 → OSS 私有桶）
                              └─ /auth|/rest|/realtime|… → 反代 Supabase 源站

海外用户 ──DNS(默认)──► gateway.yolohappy.com Custom Domain → Supabase
（若暂时全球都指这台服务器：海外也能用，只是稍绕；Custom Domain Ready 后再把「默认」改回 Supabase）

封面/音频/头像 ──► media.yolohappy.com（CDN，与 gateway 无关）
```

### 进度假设与待办


| 项 | 状态（请按实改勾） | 说明 |
| --- | --- | --- |
| 阶段 1 媒体 CDN | ✅ 已完成 | 不动 |
| B 私有桶 `yolo-private-prod` | ✅ 多半已建 | 确认地域上海、权限私有 |
| A `OSS_PRIVATE_BUCKET` Secret | ☐ | GitHub Actions → 补 Secret |
| C 私有桶同步 | ☐ | 桶内应有 `chat-images/...`（现在常是空的） |
| D Custom Domain | 🔄 进行中 | CNAME + TXT `_acme-challenge.gateway` → Verify → Active |
| E 机器 | **改为「改造已有机」** | **不要**按「新购」走；见下方逐步 |
| F 签名 API | ☐ | 与现有其它服务**并列**安装 |
| G Nginx | ☐ | **合进现有 Nginx**，勿覆盖其它站点 |
| H / I / J / K | ☐ | gateway 冒烟后再动 DNS / 切 App |

### 逐步操作（按天）

#### 第 0 步 — 冻结变更（5 分钟）

1. **不要**改 App `SUPABASE_URL` 为 gateway。  
2. **不要**删已有站点的 Nginx conf / 宝塔站点。  
3. DNS：保留正在做的 Custom Domain 相关记录；**暂不**把「中国大陆」`gateway` 指到这台机（等 G 冒烟）。

#### 第 1 步 — 收尾 D（Custom Domain）

1. 阿里云 TXT：`_acme-challenge.gateway` = 弹窗 Content（一字不差）。  
2. 本机 DNS 若超时，改查：`dig +short TXT _acme-challenge.gateway.yolohappy.com @223.5.5.5`  
3. Supabase → **Verify** → 等到状态 **Active**。  
4. 保留 `gateway` **默认** CNAME → `edwvrriuwzaaqznklrgi.supabase.co`（海外直连用）。

#### 第 2 步 — 摸清已有服务器（改造代替「购买」）

SSH 登录**现有机器**后执行并记下结果：

```bash
uname -a
node -v 2>/dev/null || echo "no node"
nginx -v 2>&1
ss -lntp | egrep ':80|:443|:3001' || netstat -lntp | egrep ':80|:443|:3001'
ls /etc/nginx/conf.d 2>/dev/null; ls /www/server/panel 2>/dev/null   # 有 panel 多为宝塔
curl -sS -o /dev/null -w "%{http_code}\n" \
  "https://edwvrriuwzaaqznklrgi.supabase.co/auth/v1/health"
```

| 检查项 | 合格标准 | 不合格怎么办 |
| --- | --- | --- |
| 能 SSH、有公网 IP | 记下 IP | — |
| 出网访问 Supabase | 非超时 | 放行出网 / DNS |
| **443/80** | 已有 Nginx/Caddy/宝塔 | **不要重装抢端口**；只加一个 `server_name` |
| **3001** | 未被占用 | 换 `PORT=3002` 并改 Nginx 反代（少见） |
| Node | ≥ 20，或可再装 20 | 用 nvm / NodeSource，避免弄坏系统里旧 Node（见下） |
| 内存/负载 | 余量大致够再跑一个小 Node | 过载则另开轻量机 |

**Node 共存**：若机上已有旧 Node（如 16）被其它程序依赖，优先：

```bash
# 示例：用 nvm 仅给签名服务用 20（勿覆盖全局其它服务）
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
# 装好后：nvm install 20 && 在 systemd ExecStart 写绝对路径，例如：
# which node  →  /home/xxx/.nvm/versions/node/v20.*/bin/node
```

安全组 / 防火墙：确认 **443（及 80）** 开着；**不要**对公网开 3001；22 仍建议仅办公 IP。

> 细节命令仍可参考下文 **E / F**；凡写「创建实例 / 新装 Nginx」的句子，在本路径下**跳过**，只保留安装 Node（共存）、签名目录、**追加** Nginx server。

#### 第 3 步 — F 签名 API（与其它程序并列）

完全按 **F** 节：`/opt/yolo-sign-api` + `/etc/yolo-sign-api.env` + systemd。  
要求：`SUPABASE_URL` = 源站 `*.supabase.co`；`curl 127.0.0.1:3001/health` → `{"ok":true}`。  
不影响其它已有服务（不占用 80/443）。

#### 第 4 步 — G Nginx：只新增 gateway 站点

1. 阿里云申请 / 下载 `gateway.yolohappy.com` 证书，放到现机（如 `/etc/nginx/certs/`），**勿覆盖**其它域名证书。  
2. 将仓库 [`infra/gateway/nginx.conf.snippet`](../infra/gateway/nginx.conf.snippet) **另存为独立 conf**（例：`/etc/nginx/conf.d/yolo-gateway.conf` 或宝塔「添加站点」后改配置）。  
3. `server_name` 仅为 `gateway.yolohappy.com`；保留原有站点的其它 `server { }`。  
4. `nginx -t && systemctl reload nginx`（宝塔则用面板重载）。  
5. **临时**本机 hosts 或 dig：把 `gateway` 指到该机公网 IP，测：

```bash
curl -Ik --resolve gateway.yolohappy.com:443:服务器公网IP \
  https://gateway.yolohappy.com/auth/v1/health
curl -sS --resolve gateway.yolohappy.com:443:服务器公网IP \
  http://127.0.0.1:3001/health   # 签名仍建议先在机内测；外网测 sign 见 G.5
```

原有业务域名应仍正常（改完做一次冒烟）。

#### 第 5 步 — 同步与 GeoDNS

1. 完成 **A.2 + C**（`sync-private`，私有桶有图）。  
2. **H**：  
   - `gateway` **中国大陆** → 这台机（A 记录 IP，或先接 Gateway CDN 再回源该机）  
   - `gateway` **默认** → Custom Domain（Supabase CNAME）  
3. **I** Gateway CDN 可选：减轻源站、缓存匿名 GET。

#### 第 6 步 — 再切 App（J）与验收（K）

国内 4G 下把 `SUPABASE_URL` 改为 `https://gateway.yolohappy.com/`，并设好 `SUPABASE_FALLBACK_URL` 为原 supabase.co。  
验收登录 / 列表 / 客服图 / Realtime；出问题 DNS 回滚中国大陆或把 URL 改回源站。

### 风险与回滚（共用机特有）

| 风险 | 规避 |
| --- | --- |
| `reload nginx` 弄挂旧站 | 先 `nginx -t`；conf 独立文件；保留备份 |
| 升级全局 Node 弄挂旧程序 | 用 nvm / 独立绝对路径跑签名服务 |
| 磁盘写满 | 日志轮转；签名服务几乎无本地存文件 |
| 验证期误指 DNS | 用 `--resolve` / hosts 测通后再改正式解析 |

**紧急回滚 DNS**：删掉或改掉「中国大陆」`gateway` 记录，只留默认 → Supabase；App 未切则用户无感。

### 本路径下「可跳过」的原文段落

- **E.1 购买实例**整段 → 跳过  
- **E.3.3「新启一个空 Nginx」** → 改为确认已有 Nginx 可追加 server  
- 开机器阶段的「全球都先指 ECS」→ 你有 Custom Domain 后，**优先 H 分线路**，不要长期全球回源到共用机（减少对旧业务与海外延迟的影响）

下文 **A～L** 仍是完整手册；执行时以**本节顺序**为准，遇到冲突以「复用已有服务器」为准。

---

## 网关已通后的详细操作方案（实机 · 2026-07）

> **适用**：宝塔共用机 + 签名 `3102` + SSL 已签发，且 `--resolve` 冒烟已通过。  
> **实机参数（写死，改机再改文档）**：

| 项 | 值 |
| --- | --- |
| 公网 IP | `101.201.125.178`（华北2 北京） |
| 域名 | `gateway.yolohappy.com` |
| 签名服务 | `127.0.0.1:3102`（systemd `yolo-sign-api`） |
| 上游 API | `https://edwvrriuwzaaqznklrgi.supabase.co` |
| 私有 OSS | `yolo-private-prod` / `oss-cn-shanghai` |
| 媒体 CDN | `media.yolohappy.com`（已通，本方案不动） |

### 已完成（勿重复）

- [x] Custom Domain / 宝塔 SSL for `gateway`
- [x] 签名 API 安装、`PORT=3102`、`curl 127.0.0.1:3102/health` → `{"ok":true}`
- [x] Nginx 反代 + `/api/v1/media/sign` → 3102
- [x] 冒烟：`/auth/v1/health` → 401 missing apikey；`/api/v1/media/sign` → `missing_token`

### 尚未完成（严格按 ①→⑤）

| 序 | 内容 | 约耗时 |
| --- | --- | --- |
| ① | GitHub Secret + 私有桶同步 | 15～40 分钟 |
| ② | GeoDNS 分线路 | 10 分钟 + TTL 等待 |
| ③ | 公网再验（不依赖 `--resolve`） | 5 分钟 |
| ④ | 切本机 `Secrets.xcconfig` | 5 分钟 |
| ⑤ | 国内 4G 实机验收 | 30 分钟 |

**I（Gateway CDN）可后置**；先不切 CDN 也能用。

---

### ① 私有桶同步（客服图镜像）

没有 OSS 对象时，签名返回的 URL 会 **404**，App 再回退 Supabase。

#### ①-1 GitHub Secret

1. 仓库 → **Settings** → **Secrets and variables** → **Actions**
2. New / Update：

| Name | Value |
| --- | --- |
| `OSS_PRIVATE_BUCKET` | `yolo-private-prod` |

3. 确认已有：`SUPABASE_URL`（源站）、`SUPABASE_SERVICE_ROLE_KEY`、`OSS_ACCESS_KEY_ID`、`OSS_ACCESS_KEY_SECRET`、`OSS_REGION=oss-cn-shanghai`

#### ①-2 跑同步（二选一）

**GitHub Actions（推荐）**

1. **Actions** → workflow 名含 `Sync` / `OSS` 的 → **Run workflow**
2. 等 `sync-public`、`sync-private` 都绿

**本机（Mac，仓库根目录）**

```bash
cd /Users/vesperal/Desktop/YOLO
# 使用你本机已有的 export；同步脚本需要 SERVICE_ROLE 列私有桶
export OSS_PRIVATE_BUCKET=yolo-private-prod
export OSS_REGION=oss-cn-shanghai
npm run sync:oss:private
```

#### ①-3 验收

阿里云 OSS 控制台 → `yolo-private-prod` → 应有前缀：

`chat-images/{conversationId}/....jpg`

若桶仍为空：查 Actions 日志 / Service Role 是否能读 Supabase Storage `chat-images`。

---

### ② GeoDNS（核心：国内走 ECS，海外走 Supabase）

**入口**：[云解析 DNS](https://dns.console.aliyun.com/) → `yolohappy.com`

#### ②-1 保留「默认」→ Supabase（海外）

现有记录（Custom Domain 用）应类似：

| 主机记录 | 线路 | 类型 | 记录值 |
| --- | --- | --- | --- |
| `gateway` | **默认** | CNAME | `edwvrriuwzaaqznklrgi.supabase.co` |

**不要删**这条（海外 HTTPS + Custom Domain 靠它）。

#### ②-2 新增「中国大陆」→ 本机

| 主机记录 | 线路 | 类型 | 记录值 | TTL |
| --- | --- | --- | --- | --- |
| `gateway` | **中国大陆** | **A** | `101.201.125.178` | 10 分钟（先短，稳定后再加长） |

同一主机、**不同线路**可以并存，不会和默认 CNAME 冲突。

#### ②-3 等生效后检查

**国内网络 / 本机试：**

```bash
dig +short gateway.yolohappy.com @223.5.5.5
# 期望：101.201.125.178
```

**海外 DNS（或 VPN 出口在国外）：**

```bash
dig +short gateway.yolohappy.com @8.8.8.8
# 期望：CNAME 到 *.supabase.co（或最终不是 101.201.125.178）
```

公网 HTTPS（国内预期打到 ECS）：

```bash
curl -Ik https://gateway.yolohappy.com/auth/v1/health
curl -sS https://gateway.yolohappy.com/api/v1/media/sign
# 同冒烟：401 missing apikey / missing_token
```

#### ②-4 回滚（出问题立刻）

删掉或暂停 **中国大陆** 那条 A 记录 → 全国回落到默认 CNAME（Supabase）。App 若尚未改 URL，用户完全无感。

---

### ③ 公网再验清单（改 DNS 后、切 App 前）


| # | 命令或操作 | 通过标准 |
| --- | --- | --- |
| 1 | `systemctl is-active yolo-sign-api` | `active` |
| 2 | `curl -sS http://127.0.0.1:3102/health` | `{"ok":true}` |
| 3 | 国内 dig `@223.5.5.5` | IP = `101.201.125.178` |
| 4 | `curl -Ik https://gateway.../auth/v1/health` | 401 + missing apikey |
| 5 | `curl -sS https://gateway.../api/v1/media/sign` | `missing_token` |
| 6 | 打开原先宝塔其它站点 | 仍正常 |

可选（有真实会话图 + 用户 JWT 后）：带 Bearer 调 sign，再 `curl` 返回的 OSS URL，期望 200。

---

### ④ 切本机 App（`Secrets.xcconfig`）

**文件**：仓库根目录 `Secrets.xcconfig`（**禁止 commit / push**）

#### ④-1 修改内容

```xcconfig
// 国内加速入口（GeoDNS 已分线路）
SUPABASE_URL = https:/$()/gateway.yolohappy.com/

// 探活失败时粘性回退源站（代码已支持）
SUPABASE_FALLBACK_URL = https:/$()/edwvrriuwzaaqznklrgi.supabase.co/

// anon 等其它键保持不动
```

确保 Xcode / Info.plist 能读到 `SUPABASE_FALLBACK_URL`（若工程已按仓库接好则无需再改代码）。

#### ④-2 编译安装

1. Xcode → **Product → Clean Build Folder**
2. 真机删除旧 App（可选）
3. **国内 4G/5G** 安装运行（别只用连着公司代理的 WiFi 验收国内链路）

#### ④-3 紧急切回

把 `SUPABASE_URL` 改回：

```xcconfig
SUPABASE_URL = https:/$()/edwvrriuwzaaqznklrgi.supabase.co/
```

或只回滚 DNS 中国大陆记录（见 ②-4）。

---

### ⑤ 验收（K 浓缩版）


| # | 场景 | 通过 |
| --- | --- | --- |
| 1 | 邮箱 / Apple 登录 | 成功，体感可接受 |
| 2 | 冷启动城市列表 | 正常加载 |
| 3 | 封面 / 音频 | 仍走 `media.yolohappy.com` |
| 4 | 客服发图 / 收图 | 能显示（已同步的图） |
| 5 | 客服 Realtime | 消息可达 |
| 6 | Charles 等 | API Host 为 `gateway.yolohappy.com`（国内） |

海外 WiFi：`gateway` 应解析到 Supabase，不应长期停在北京 IP。

---

### 推荐执行日历


| 时间 | 动作 |
| --- | --- |
| 今天 | ① Secret + sync-private → ② 加中国大陆 A 记录 |
| DNS 生效后 | ③ 公网 curl 清单全绿 |
| 当晚或次日 | ④ 切 Secrets → ⑤ 真机验收 |
| 稳定一周后 | 可选 I：gateway 前面加阿里云 CDN；拉长 TTL |

### 出问题怎么查


| 现象 | 查 |
| --- | --- |
| 国内仍解析到 supabase | 中国大陆 A 未加 / TTL 未刷新 / 本机 DNS 缓存 |
| sign 仍 HTML / 404 | Nginx 是否把 `/api/v1/media/sign` 指到 `3102`；`systemctl status yolo-sign-api` |
| 签名 200 但图裂 | 私有桶无对象 → 回 ① |
| 登录异常 | Nginx 是否漏传 `apikey` / `Authorization`；证书是否过期 |
| 旧站挂了 | 宝塔其它站点 conf；`nginx -t`；回滚最近改动 |
| media -1003 找不到主机 | DNS 无 `media` 记录 → 见下方 **应急 M 节** |

---

## 应急：`media.yolohappy.com` 解析失败（NSURL -1003）

> **症状**：`未能找到使用指定主机名的服务器`，URL 为 `https://media.yolohappy.com/cover-images/...` / `avatars/...`。  
> **原因**：云解析缺少 `media`，或只有「中国大陆」而当前网络走「默认」→ NXDOMAIN。  
> **与 gateway / SUPABASE_URL 无关**；补 DNS 即可，不必回滚 App。

### M.1 从 CDN 抄 CNAME

1. 打开 [CDN 域名管理](https://cdn.console.aliyun.com/domain/list)
2. 找到 **`media.yolohappy.com`**
   - 没有此域名 → 按 [阶段1指南·第三节](china-cdn-phase1-操作指南.md) 重新添加（源站 `yolo-media-prod`）
   - 已停止 → 先 **启用**
3. 进入域名 → 复制 **CNAME**（如 `media.yolohappy.com.w.kunlunaq.com`）

### M.2 云解析补 `media`（默认 + 国内都要有）

[云解析](https://dns.console.aliyun.com/) → `yolohappy.com` → 搜索主机 **`media`**

| 主机记录 | 解析线路 | 类型 | 记录值 | TTL |
| --- | --- | --- | --- | --- |
| `media` | **默认** | CNAME | M.1 的 CDN CNAME | 10 分钟 |
| `media` | **中国大陆** 或 **中国地区** | CNAME | **同一** CDN CNAME | 10 分钟 |

注意：App 全量配置了 `MEDIA_CDN_BASE_URL`，**默认线路不能空**；不要填 ECS IP / gateway。

### M.3 本机验收

```bash
dig +short media.yolohappy.com @223.5.5.5
curl -I --connect-timeout 10 \
  "https://media.yolohappy.com/cover-images/cities/chongqing.png"
```

期望：`dig` 非空；`curl` 能连上（**200** 最好；**404** 也说明解析已通）。

### M.4 真机

开关飞行模式清 DNS → 杀掉 App 重开 → 封面/头像不应再 -1003。

### M.5 完成标准

- [ ] CDN 域名运行中且 CNAME 已抄对  
- [ ] `media` 默认 + 中国大陆/地区均有记录  
- [ ] `dig` / `curl` 通过；真机无 -1003  

---

## 操作总览（勾选）


| #   | 步骤 | 完成 |
| --- | --- | --- |
| A   | GitHub Secrets 补齐（含 `OSS_PRIVATE_BUCKET`） | ☐ |
| B   | OSS 私有桶 `yolo-private-prod` | ☐ |
| C   | 全量同步 avatars + chat-images | ☐ |
| D   | Supabase Custom Domain `gateway.yolohappy.com` | ☐ |
| E   | **改造已有服务器**（安全组 / Node20 共存 / 摸底）；非必须新购 | ☐ |
| F   | 部署客服图签名 API（Node，并列） | ☐ |
| G   | **追加** Nginx server + HTTPS（不覆盖旧站） | ☐ |
| H   | GeoDNS 分线路 | ☐ |
| I   | Gateway CDN 缓存（推荐） | ☐ |
| J   | 本机 `Secrets.xcconfig` 切换 gateway | ☐ |
| K   | 国内/海外实机验收 | ☐ |
| L   | 隐私政策与运营文档确认 | ☐ |


---



## A. GitHub Secrets

**入口**：GitHub 仓库 → **Settings** → **Secrets and variables** → **Actions**

### A.1 必须齐全（公共同步已用过）


| Secret 名称                   | 示例值                                        | 说明                                       |
| --------------------------- | ------------------------------------------ | ---------------------------------------- |
| `SUPABASE_URL`              | `https://edwvrriuwzaaqznklrgi.supabase.co` | **同步脚本源站**；建议保持原 Supabase 域，不要写成 gateway |
| `SUPABASE_SERVICE_ROLE_KEY` | `eyJ...`                                   | Service Role（能列私有桶）                      |
| `OSS_ACCESS_KEY_ID`         | AKIA…                                      | RAM 子账号 AccessKey                        |
| `OSS_ACCESS_KEY_SECRET`     | …                                          | 同上                                       |
| `OSS_BUCKET`                | `yolo-media-prod`                          | **公共**媒体桶                                |
| `OSS_REGION`                | `oss-cn-shanghai`                          | 华东 2                                     |




### A.2 本次新增


| Secret 名称            | 示例值                 | 说明                                       |
| -------------------- | ------------------- | ---------------------------------------- |
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


| 项     | 值                                     |
| ----- | ------------------------------------- |
| 名称    | ``（全局唯一；如被占用可加后缀，并同步改 GitHub Secret）  |
| 地域    | **华东2（上海）** `oss-cn-shanghai`（与公共桶同区） |
| 存储类型  | 标准                                    |
| 读写权限  | **私有**                                |
| 版本控制  | 关闭                                    |
| 服务端加密 | 可选                                    |


1. 创建完成后进入 Bucket → **概览**，记下 Bucket 名称与 Endpoint。



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

1. **私有同步**：

```bash
OSS_PRIVATE_BUCKET=yolo-private-prod npm run sync:oss:private
```

1. 查看报告：
  - `scripts/generated/storage_oss_sync_report.json`
  - `scripts/generated/storage_oss_private_sync_report.json`  
   要求各 bucket 的 `failed` 为空数组。



### C.2 或用 GitHub Actions

1. 先完成 **A.2**
2. Actions → **Run workflow**
3. 两个 job 均成功；artifact 里无失败报告



### C.3 验证


| 检查      | 期望                                                     |
| ------- | ------------------------------------------------------ |
| OSS 公共桶 | 有 `avatars/{userId}/avatar.jpg` 一类对象                   |
| OSS 私有桶 | 有 `chat-images/{convId}/....jpg`                       |
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

> **若复用已有服务器（当前推荐）**：不要走 E.1 购买；先按文首 **「当前实施方案」第 2 步** 摸底，再只做安全组核对 + Node 20 共存 +（已有则跳过）Nginx。下文按「新机」写全，便于对照。

本机将作为 **`gateway.yolohappy.com` 中国大陆（及暂不分流时全球）入口**：Nginx 反代 Supabase + 本机签名 API。  
证书申请、站点 conf 细节在 **G**；本节只做到：机器能 SSH、安全组正确、装好 Nginx + Node 20、能出网访问 Supabase。

**入口（二选一）**：

| 产品 | 入口 | 说明 |
| --- | --- | --- |
| **云服务器 ECS**（推荐，与安全组文档一致） | [ECS 控制台](https://ecs.console.aliyun.com/) | 下面按 ECS 写 |
| **轻量应用服务器** | [轻量控制台](https://swas.console.aliyun.com/) | 同等 2核4G 亦可；防火墙在轻量面板里配端口，逻辑同 E.2 |

**前置**：账号已实名；域名仍在阿里云；记事本准备写 **公网 IP**。

---

### E.0 先建专用安全组（建议在开实例前）

1. ECS 控制台 → **网络与安全** → **安全组** → **创建安全组**
2. 名称例如：`yolo-gateway-sg`
3. 网络：**与即将使用的 VPC 相同**（新建实例时默认 VPC 即可）
4. **入方向**规则（先按下面建；出方向一般默认放行全部即可）：

| 优先级 | 协议 | 端口 | 授权对象 | 用途 |
| --- | --- | --- | --- | --- |
| 1 | TCP | **22** | **你当前公网 IP/32**（[查本机 IP](https://www.ip.cn/)） | SSH；勿对 `0.0.0.0/0` 长期开放 |
| 1 | TCP | **443** | `0.0.0.0/0`（IPv6 不需要可不管） | HTTPS |
| 1 | TCP | **80** | `0.0.0.0/0` | HTTP→HTTPS / ACME（可选） |

**禁止**：

- 不要放行 **3001**（签名服务只绑 `127.0.0.1`）
- 不要放行 **5432 / 3306** 等数据库口
- 不要对世界开放 22（办公 IP 变了再改安全组）

办公 IP 经常变：可临时改成 `0.0.0.0/0` 调试 SSH，**连上后立刻改回你的 IP/32**。

---

### E.1 购买 / 创建实例

ECS 控制台 → **实例** → **创建实例**（自定义购买）。

#### E.1.1 必填项建议


| 项 | 建议值 | 备注 |
| --- | --- | --- |
| 付费模式 | 按量 或 包年包月 | 先跑通可用按量 |
| 地域 | **华东2（上海）** | 与 OSS `oss-cn-shanghai` 同区，延迟更短 |
| 可用区 | 任意 | — |
| 实例规格 | **2 vCPU / 4 GiB**（如 `ecs.u1-c1m2.large` 或同级） | 初期够用；流量大再升配 |
| 镜像 | **Alibaba Cloud Linux 3** 或 **Ubuntu 22.04** | 下文命令分两种写 |
| 系统盘 | ESSD / 高效云盘 **≥ 40GB** | — |
| 公网 IP | **分配公网 IPv4** | 带宽建议先 **5 Mbps**（可再升）；或后挂 SLB（本指南用公网 IP） |
| 安全组 | 选 **E.0** 建好的 `yolo-gateway-sg` | 勿漏绑 |
| 登录凭证 | **密钥对**（推荐）或自定义密码 | 密钥更安全 |

#### E.1.2 密钥对（推荐）

1. 创建实例向导里选 **密钥对** → **创建密钥对**
2. 下载 `.pem`，本机权限：

```bash
chmod 400 ~/Downloads/yolo-gateway.pem
# 挪到固定位置，例如：
mkdir -p ~/.ssh && mv ~/Downloads/yolo-gateway.pem ~/.ssh/yolo-gateway.pem
chmod 400 ~/.ssh/yolo-gateway.pem
```

3. **私钥只留本机**，不要提交 Git、不要发聊天。

#### E.1.3 创建完成后记下


| 信息 | 写在哪里 |
| --- | --- |
| **公网 IP** | 记事本 / 密码管理器；后面 GeoDNS「中国大陆」A 记录、`ssh` 都要用 |
| 实例 ID | 可选 |
| 用户名 | Alibaba Cloud Linux / Ubuntu 常见为 **`root`**（若选了其它镜像可能是 `ubuntu`） |

控制台实例列表应显示：**运行中**，安全组已关联，公网 IP 非空。

---

### E.2 核对安全组（开完机再看一眼）

实例 → **安全组** → **配置规则** → **入方向**：

- [ ] 有 443 /（可选）80  
- [ ] 22 来源是你的 IP（或你已知的调试源）  
- [ ] **没有** 3001  

从本机试能否连（把 IP / 密钥换成你的）：

```bash
ssh -i ~/.ssh/yolo-gateway.pem root@ECS公网IP
```

若超时：

1. 安全组 22 是否放行了**当前**出口 IP  
2. 本机网络是否拦了 22  
3. 实例是否「运行中」、公网 IP 是否看对

能出现 shell 即 SSH 通。

---

### E.3 系统初始化（SSH 登录后）

下列在 **ECS 上**执行。按镜像选一列；装完应用 `F`（签名）和 `G`（Nginx 站点）。

#### E.3.1 更新与基础工具


**Alibaba Cloud Linux 3：**

```bash
sudo dnf -y update
sudo dnf -y install nginx curl git vim tar
```

**Ubuntu 22.04：**

```bash
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y install nginx curl git vim tar ca-certificates gnupg
```

#### E.3.2 安装 Node.js 20 LTS


**Alibaba Cloud Linux 3（NodeSource）：**

```bash
curl -fsSL https://rpm.nodesource.com/setup_20.x | sudo bash -
sudo dnf -y install nodejs
node -v   # 期望 v20.x
npm -v
```

**Ubuntu 22.04：**

```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs
node -v   # 期望 v20.x
npm -v
```

若 NodeSource 不可用，可从 [nodejs.org](https://nodejs.org/) 下官方 Linux x64 二进制，解压后把 `bin` 加入 `PATH`，保证 `which node` 指向 20.x。

#### E.3.3 启动 Nginx（先默认页即可）

```bash
sudo systemctl enable --now nginx
sudo systemctl status nginx --no-pager
curl -sS -o /dev/null -w "%{http_code}\n" http://127.0.0.1/
# 期望 200（欢迎页）
```

站点 HTTPS、反代 Supabase、`/api/v1/media/sign` → **放到 G 节**；本节只要 Nginx **已安装且能起来**。

#### E.3.4 出网连通性（后面代理 / 签名都要）

```bash
curl -sS -o /dev/null -w "%{http_code}\n" \
  "https://edwvrriuwzaaqznklrgi.supabase.co/auth/v1/health"
# 期望 200，或需 key 时的 401 —— 只要不是连不上 / 超时
```

若超时：检查 ECS 是否有公网、安全组**出方向**是否被改成拒绝、公司镜像是否拦 HTTPS。

#### E.3.5（可选）目录与时区

```bash
sudo timedatectl set-timezone Asia/Shanghai
sudo mkdir -p /opt/yolo-sign-api /etc/nginx/certs
sudo chown "$USER":"$USER" /opt/yolo-sign-api
```

证书文件放到 `/etc/nginx/certs/` 的步骤见 **G.1**。

#### E.3.6 本机 SSH 配置别名（可选，本机执行）

```bash
cat >> ~/.ssh/config <<'EOF'
Host yolo-gw
  HostName ECS公网IP
  User root
  IdentityFile ~/.ssh/yolo-gateway.pem
EOF
chmod 600 ~/.ssh/config
ssh yolo-gw
```

---

### E.4 轻量应用服务器差异（若你买的是轻量）

| ECS 概念 | 轻量对应 |
| --- | --- |
| 安全组 | 实例 → **防火墙**，放行 22 / 80 / 443；同样 **不要** 放 3001 |
| 公网 IP | 实例概览里直接有 |
| 系统初始化 | SSH 后同样装 Nginx + Node 20（E.3） |

地域仍选 **上海** 或与 OSS 同区。

---

### E.5 故障排查


| 现象 | 处理 |
| --- | --- |
| SSH `Connection timed out` | 安全组 22 源 IP、实例状态、公网 IP |
| SSH `Permission denied` | 密钥路径 / 用户名（root vs ubuntu）、`.pem` 权限是否 `400` |
| `node -v` 找不到 | Node 未装入 PATH；重装 NodeSource 或检查符号链接 |
| `nginx` 起不来 | `journalctl -u nginx -n 50`；端口 80 是否被占用 |
| curl Supabase 失败 | 出网 / DNS；可试 `curl -I https://www.aliyun.com` 对比 |
| 本机 `dig` 超时 | 与 ECS 无关：换 `@223.5.5.5` 或看系统 DNS；不影响 ECS 初始化 |

---

### E.6 完成标准

- [ ] 华东 2（上海）实例 **运行中**，有固定 **公网 IPv4**（已抄下来）
- [ ] 安全组 / 防火墙：22（收紧）、80（可选）、443 开放；**无 3001**
- [ ] 本机能 `ssh` 登录
- [ ] `node -v` ≥ 20、`npm -v` 正常
- [ ] `systemctl is-active nginx` 为 `active`
- [ ] ECS 上 `curl` Supabase health 非超时
- [ ] 已建 `/opt/yolo-sign-api`（可选但建议）

完成后继续 **F. 部署客服图签名 API**，再做 **G. Nginx + HTTPS**。  
（`gateway` 的中国大陆解析先别急着改；等 G 冒烟通过后再动 GeoDNS。）

---



## F. 部署客服图签名 API

仓库模板目录：[`scripts/gateway-sign-api/`](../scripts/gateway-sign-api/)  
（`package.json`、`package-lock.json`、`server.mjs`）

**作用**：App（经 Nginx）请求 `GET /api/v1/media/sign?path={convId}/{file}.jpg`，本服务用用户 JWT 调 Supabase RPC `can_access_conversation` 验权后，返回私有桶 `chat-images/...` 的 **OSS 预签名 URL**（约 1 小时有效）。

**前置（必须先完成）**：

| 项 | 说明 |
| --- | --- |
| E 节 | ECS 已 SSH、已装 **Node.js 20**、安全组 **未开放 3001** |
| B + C | 私有桶 `yolo-private-prod` 里已有 `chat-images/{convId}/...`（否则合法签名仍会 404） |
| 密钥 | 手头有：`SUPABASE_ANON_KEY`、与同步脚本同款的 `OSS_ACCESS_KEY_*` |

**本机不要做**：不要把 `.env` / `EnvironmentFile` 提交进 Git；不要对公网监听 3001。

---

### F.0 确认 ECS 上 Node 版本

SSH 登录 ECS 后：

```bash
node -v   # 期望 v20.x 或以上
npm -v
sudo mkdir -p /opt/yolo-sign-api
sudo chown "$USER":"$USER" /opt/yolo-sign-api
```

若未装 Node 20（Alibaba Cloud Linux / Ubuntu 示例，二选一）：

```bash
# Ubuntu 22.04 — NodeSource 20.x
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

# 或官方二进制：https://nodejs.org/en/download
```

---

### F.1 把模板拷到 ECS

在 **本机笔记本**（仓库根目录）执行，把 `ECS_HOST` 换成公网 IP 或 SSH 别名：

```bash
cd /path/to/YOLO
scp scripts/gateway-sign-api/package.json \
    scripts/gateway-sign-api/package-lock.json \
    scripts/gateway-sign-api/server.mjs \
    root@ECS_HOST:/opt/yolo-sign-api/
```

若用普通用户 + sudo：

```bash
scp scripts/gateway-sign-api/{package.json,package-lock.json,server.mjs} \
    YOUR_USER@ECS_HOST:/tmp/yolo-sign-api-upload/
# 再在 ECS 上：
ssh YOUR_USER@ECS_HOST
sudo mkdir -p /opt/yolo-sign-api
sudo cp /tmp/yolo-sign-api-upload/* /opt/yolo-sign-api/
sudo chown -R "$USER":"$USER" /opt/yolo-sign-api
```

确认：

```bash
ls -la /opt/yolo-sign-api
# 应看到 package.json  package-lock.json  server.mjs
```

---

### F.2 编写环境变量文件（勿入库）

```bash
sudo tee /etc/yolo-sign-api.env >/dev/null <<'EOF'
PORT=3001
SUPABASE_URL=https://edwvrriuwzaaqznklrgi.supabase.co
SUPABASE_ANON_KEY=这里粘贴与 Secrets.xcconfig 相同的 anon key
OSS_REGION=oss-cn-shanghai
OSS_PRIVATE_BUCKET=yolo-private-prod
OSS_ACCESS_KEY_ID=这里粘贴 RAM AccessKeyId
OSS_ACCESS_KEY_SECRET=这里粘贴 AccessKeySecret
SIGN_EXPIRES_SEC=3600
EOF

# 仅 root / 服务可读
sudo chmod 600 /etc/yolo-sign-api.env
sudo chown root:root /etc/yolo-sign-api.env
```

| 变量 | 必填 | 说明 |
| --- | --- | --- |
| `PORT` | 是 | 固定 `3001`；仅监听 `127.0.0.1` |
| `SUPABASE_URL` | 是 | **必须是** `*.supabase.co` 源站；**禁止**填 `gateway.yolohappy.com`（会形成环） |
| `SUPABASE_ANON_KEY` | 强烈建议 | 与 App 同款 anon；用户 JWT 才能让 `auth.uid()` / RPC 生效 |
| `OSS_*` | 是 | 当前模板只用 AK/SK，**不**读 ECS RAM 角色 |
| `OSS_PRIVATE_BUCKET` | 是 | 与 GitHub Secret / B 节一致 |
| `SIGN_EXPIRES_SEC` | 否 | 默认 3600 |

可选兜底：未设 `SUPABASE_ANON_KEY` 时可用 `SUPABASE_SERVICE_ROLE_KEY`，但 RPC 鉴权语义变弱，**生产请用 anon + 用户 Bearer**。

抽查（不要把整段 key 打到聊天记录里）：

```bash
sudo grep -E '^(PORT|SUPABASE_URL|OSS_REGION|OSS_PRIVATE_BUCKET|SIGN_)' /etc/yolo-sign-api.env
# SUPABASE_URL 必须含 supabase.co，不能含 gateway
```

---

### F.3 安装依赖

```bash
cd /opt/yolo-sign-api
npm ci
# 若无 lock 或 ci 失败，可退一步：npm install --omit=dev
```

期望出现 `node_modules/`，且无报错。

---

### F.4 用 systemd 守护（推荐）

```bash
sudo tee /etc/systemd/system/yolo-sign-api.service >/dev/null <<'EOF'
[Unit]
Description=YOLO gateway chat-image sign API
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
WorkingDirectory=/opt/yolo-sign-api
EnvironmentFile=/etc/yolo-sign-api.env
ExecStart=/usr/bin/node server.mjs
Restart=on-failure
RestartSec=3
# 最小权限：仅本机环回对外（进程自己 bind 127.0.0.1）
NoNewPrivileges=true

[Install]
WantedBy=multi-user.target
EOF

# 若 which node 不是 /usr/bin/node，改掉 ExecStart：
which node

sudo systemctl daemon-reload
sudo systemctl enable --now yolo-sign-api
sudo systemctl status yolo-sign-api --no-pager
```

期望：`Active: active (running)`，日志含：

```text
gateway-sign-api listening on 127.0.0.1:3001
```

常用运维：

```bash
sudo journalctl -u yolo-sign-api -f          # 跟日志
sudo systemctl restart yolo-sign-api         # 改完 .env 后必重启
sudo systemctl stop yolo-sign-api
```

#### 备选：pm2（不推荐与 systemd 混用）

```bash
sudo npm i -g pm2
cd /opt/yolo-sign-api
set -a && source /etc/yolo-sign-api.env && set +a
pm2 start server.mjs --name yolo-sign-api
pm2 save
pm2 startup   # 按提示执行生成的命令
```

---

### F.5 本机冒烟（Nginx 配好之前先在 ECS 上测）

#### F.5.1 健康检查

```bash
curl -sS http://127.0.0.1:3001/health
```

期望：

```json
{"ok":true}
```

#### F.5.2 无 Token → 401

```bash
curl -sS -o /tmp/sign-out.txt -w "%{http_code}\n" \
  "http://127.0.0.1:3001/api/v1/media/sign?path=00000000-0000-0000-0000-000000000001/demo.jpg"
cat /tmp/sign-out.txt
```

期望状态码 **401**，body 含 `"missing_token"`。

#### F.5.3 非法 path → 400

```bash
TOKEN='先填一个任意假 JWT 字符串'
curl -sS -H "Authorization: Bearer $TOKEN" \
  "http://127.0.0.1:3001/api/v1/media/sign?path=not-a-uuid/x.jpg"
```

期望 **400** / `"invalid_path"`（path 第一段必须是 UUID）。

#### F.5.4 合法用户 + 真实会话图（完整验权）

1. App 或 Supabase Dashboard 登录某测试用户，复制 **access_token**（JWT）。
2. 在库里找该用户能访问的会话图 path（存储相对路径，**不含** `chat-images/` 前缀），形如：

   `{conversation_uuid}/{uuid}.jpg`

3. 确认 OSS 私有桶存在对象：

   `chat-images/{conversation_uuid}/{uuid}.jpg`

4. 在 ECS 上：

```bash
export TOKEN='用户 access_token'
export PATH_IMG='会话UUID/文件名.jpg'   # 不要带 chat-images/ 前缀

curl -sS -H "Authorization: Bearer $TOKEN" \
  "http://127.0.0.1:3001/api/v1/media/sign?path=${PATH_IMG}"
```

| 结果 | 含义 |
| --- | --- |
| **200** + `url` + `expiresAt` | 成功；`url` 应为 `*.aliyuncs.com` 的 OSS 预签名 GET |
| **403** `forbidden` | JWT 有效但对该 `conv` 无 `can_access_conversation` |
| **500** `server_misconfigured` | 缺 `SUPABASE_URL` / key |
| **500** 含 OSS / missing credentials | `.env` 里 AK 未加载或写错 → `restart` 后再看 |

用返回的 `url` 再测（可在 ECS 上）：

```bash
SIGNED_URL='上一步 JSON 里的 url'
curl -sS -o /dev/null -w "%{http_code}\n" "$SIGNED_URL"
# 期望 200；若 404 → OSS 尚未同步该对象（回 C 节）
```

**说明**：外网经 `https://gateway.../api/v1/media/sign` 的测试放到 **G.5**（需先完成 Nginx）。在 F 阶段只要求 **本机 127.0.0.1:3001** 通过即可。

---

### F.6 安全自检

```bash
# 进程应只绑 127.0.0.1
ss -lntp | grep 3001
# 期望类似：127.0.0.1:3001  …… node

# 安全组不应有 3001；本机从公网自测应不通（在你笔记本上）：
curl -m 3 "http://ECS公网IP:3001/health" || echo "拒绝或超时 = 正确"
```

---

### F.7 故障排查速查


| 现象 | 排查 |
| --- | --- |
| `systemctl` 起不来 / exit | `journalctl -u yolo-sign-api -n 50`；常见：`EnvironmentFile` 路径错、Node 路径错、语法环境变量有空格 |
| health 不通 | `systemctl status`；`ss -lntp \| grep 3001` |
| 500 `missing OSS credentials` | `.env` 未设 AK/SK，或改完未 `restart` |
| 401 但有 Bearer | Header 写成了 `Authorization: <token>`（缺 `Bearer `） |
| 403 | path 的 convId 对，但该用户不是会话成员；或误用了 service role 导致 RPC 行为异常 |
| 200 但拉图 404 | OSS 无私有对象 → 跑 C 节 `sync-private`；或 path 前多/少了 `chat-images/` |
| 验权请求很慢/失败 | `SUPABASE_URL` 是否被误写成 gateway；ECS 出网是否可访问 `*.supabase.co` |

---

### F.8 完成标准

- [ ] `/opt/yolo-sign-api` 有三文件 + `node_modules`
- [ ] `/etc/yolo-sign-api.env` 权限 `600`，`SUPABASE_URL` 为 supabase.co 源站
- [ ] `yolo-sign-api` systemd **enabled + running**
- [ ] `curl 127.0.0.1:3001/health` → `{"ok":true}`
- [ ] 无 Token → 401；合法 JWT + 已同步图 → 200 且 OSS URL 可 200 下载
- [ ] `ss` 显示仅 `127.0.0.1:3001`；安全组未放行 3001

完成后继续 **G. Nginx**（把 `/api/v1/media/sign` 反代到 `127.0.0.1:3001`）。

---



## G. Nginx 透明代理 + HTTPS

模板：`infra/gateway/nginx.conf.snippet`

### G.1 证书

1. [SSL 证书控制台](https://yundun.console.aliyun.com/) 申请免费 DV：`gateway.yolohappy.com`
2. 下载 Nginx 格式，放到 ECS（例如 `/etc/nginx/certs/`）
3. 在站点配置中填入 `ssl_certificate` / `ssl_certificate_key`（模板里已注释占位）



### G.2 配置要点（对照模板勾选）


| 路径                                          | 行为                                                       |
| ------------------------------------------- | -------------------------------------------------------- |
| `/api/v1/media/sign`                        | 反代本机 `127.0.0.1:3001`                                    |
| `/realtime/v1/`                             | 反代 Supabase，**开启 WebSocket**，超时 ≥ 3600s                  |
| `/auth/v1/`、`/functions/v1/`、`/storage/v1/` | 反代；`Cache-Control: private, no-store`                    |
| `/rest/v1/`                                 | 反代；可按是否用户 JWT 区分缓存头                                      |
| 回源 Host                                     | 必须为 `edwvrriuwzaaqznklrgi.supabase.co`                   |
| 透传头                                         | `apikey`、`Authorization`、`Prefer`、`Range`、`Content-Type` |




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


| 主机记录        | 线路类型     | 记录类型  | 记录值                       | 说明                         |
| ----------- | -------- | ----- | ------------------------- | -------------------------- |
| `gateway`   | **中国大陆** | A     | ECS 公网 IP                 | 国内走 Nginx 代理               |
| 或 `gateway` | **中国大陆** | CNAME | gateway CDN 域名            | 若启用第 I 节                   |
| `gateway`   | **默认**   | CNAME | Supabase Custom Domain 目标 | 海外直连 Supabase              |
| `media`     | **中国大陆** | CNAME | 现有阿里云 CDN CNAME           | 阶段 1 已配                    |
| `media`     | **默认**   | CNAME | **同一** CDN CNAME          | 海外也可用 CDN；失败由 App fallback |


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


| 项         | 值                             |
| --------- | ----------------------------- |
| 加速域名      | `gateway.yolohappy.com`       |
| 源站        | ECS 公网 IP（或源站域名）              |
| 端口        | 443                           |
| 协议        | HTTPS                         |
| WebSocket | **开启**                        |
| 证书        | 绑定 `gateway.yolohappy.com` 证书 |




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


| #   | 场景        | 通过标准          | ☐   |
| --- | --------- | ------------- | --- |
| 1   | 邮箱登录/注册   | < 2s          | ☐   |
| 2   | Apple 登录  | 回调成功          | ☐   |
| 3   | 冷启动城市列表   | < 2s          | ☐   |
| 4   | 封面        | < 1s          | ☐   |
| 5   | 音频起播（未离线） | < 2s          | ☐   |
| 6   | 换头像       | 本机即时；其它页 < 1s | ☐   |
| 7   | 客服发图/收图   | 发送即时；收图 < 2s  | ☐   |
| 8   | 客服消息      | Realtime < 5s | ☐   |
| 9   | 收藏 / 会员状态 | 正常            | ☐   |




### K.2 分流


| #   | 场景           | 期望                            | ☐   |
| --- | ------------ | ----------------------------- | --- |
| R1  | 国内 4G        | Charles 见 `gateway` + `media` | ☐   |
| R2  | 海外 WiFi      | `gateway` 不经国内 ECS IP         | ☐   |
| R3  | 来华 en_US 国内网 | 与 R1 相同（不看语言）                 | ☐   |
| R4  | 国内开美国出口 VPN  | `gateway` 走默认线路（海外）           | ☐   |




### K.3 故障演练


| 场景               | 操作                             | 期望                                          | ☐   |
| ---------------- | ------------------------------ | ------------------------------------------- | --- |
| CDN 新文件 404      | 新传头像后立刻打开                      | 回退 Supabase 仍可显示                            | ☐   |
| 停 ECS（或安全组拒 443） | 模拟 gateway 挂                   | 媒体仍可能靠 CDN/fallback；下次冷启动可能粘性切 FALLBACK_URL | ☐   |
| DNS 回滚           | 中国大陆 `gateway` → Custom Domain | 国内恢复直连 Supabase                             | ☐   |


---



## L. 运营与合规（上线同步做）

1. **隐私政策**：补充媒体经阿里云 CDN/OSS、API 经国内 ECS 转发至美西 Supabase
2. **Admin**：继续直连 `*.supabase.co`，无需改后台域名
3. **内容上新**：上传后最多约 30 分钟 OSS 可见；大替换可手动 Run GHA 或本机 `npm run sync:oss -- --force`
4. **CDN 刷新**：大批量更新后可在 CDN 控制台刷新 `/audio-guides/`、`/cover-images/`、`/avatars/`

---



## 紧急回滚速查


| 手段  | 操作                                   | 生效时间            |
| --- | ------------------------------------ | --------------- |
| DNS | `gateway` 中国大陆改为与默认相同（Custom Domain） | TTL 内，约 5～10 分钟 |
| App | `SUPABASE_URL` 改回 `*.supabase.co` 重装 | 立即              |
| 媒体  | 清空 `MEDIA_CDN_BASE_URL` hotfix       | 发版后             |


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


| 路径                                                                                | 用途        |
| --------------------------------------------------------------------------------- | --------- |
| `[docs/media-url-spec.md](media-url-spec.md)`                                     | URL 契约    |
| `[docs/china-cdn-phase1-操作指南.md](china-cdn-phase1-操作指南.md)`                       | 阶段 1（已完成） |
| `[Secrets.example.xcconfig](../Secrets.example.xcconfig)`                         | 三键示例      |
| `[infra/gateway/nginx.conf.snippet](../infra/gateway/nginx.conf.snippet)`         | Nginx 模板  |
| `[scripts/gateway-sign-api/](../scripts/gateway-sign-api/)`                       | 签名服务      |
| `[.github/workflows/sync-oss-media.yml](../.github/workflows/sync-oss-media.yml)` | 双 job 同步  |


按 **A → K** 顺序勾选执行即可完成手动侧全链路配置。