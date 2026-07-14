# 国内稳定邮箱确认 / 重置密码页 — 详细操作指南

> **问题**：邮件里的确认链接打开 `https://yolo.cstudiomunger.workers.dev/auth/confirm`（Cloudflare），国内常慢或打不开。  
> **目标**：改用自家域名 **`https://auth.yolohappy.com`**，静态页部署在已有宝塔机（或 OSS+CDN），验证 API 走 **`gateway.yolohappy.com`**。  
> **不替代**：Workers 可继续保留给海外 / 旧邮件；Redirect 白名单里两个域名都留着。

**预计耗时**：1～2 小时（含 DNS + SSL + 改 App 重装）。

---

## 架构（改完之后）


| 环节 | 国内用户 |
| --- | --- |
| 邮件里的链接 | `https://auth.yolohappy.com/auth/confirm?...` |
| 打开确认页 | 解析到宝塔机（或 CDN）→ **静态 HTML**（国内可达） |
| 点击「Confirm email」 | 浏览器调 `https://gateway.yolohappy.com` 做 `verifyOtp`（经 ECS 反代） |
| 重置密码页 | `https://auth.yolohappy.com/auth/reset-password?...` 同理 |

App 通过 `AUTH_WEB_BASE_URL` 决定注册/重发邮件时的 `redirectTo`。

---

## 操作总览


| # | 步骤 | 完成 |
| --- | --- | --- |
| 1 | 宝塔新建站点 `auth.yolohappy.com` + SSL | ☐ |
| 2 | 上传确认页 / 重置页 / config / JS | ☐ |
| 3 | DNS：`auth` → ECS（建议默认+中国大陆） | ☐ |
| 4 | Supabase Redirect / Site / 邮件模板核对 | ☐ |
| 5 | App `AUTH_WEB_BASE_URL` + 重装 | ☐ |
| 6 | 真机注册一封测试邮件验收 | ☐ |

---

## 1. 宝塔新建站点

### 1.1 添加站点

1. 宝塔 → **网站** → **添加站点**（PHP 纯静态即可，可不选「反向代理」）
2. 域名：`auth.yolohappy.com`
3. 根目录：例如 `/www/wwwroot/auth.yolohappy.com`
4. FTP / 数据库：**不创建**
5. PHP：`纯静态` 或关闭 PHP

### 1.2 SSL

1. 站点 → **SSL** → Let’s Encrypt（可走 **DNS 验证**，与 gateway 相同）
2. 开启 **强制 HTTPS**

### 1.3 目录结构（目标）

上传完成后根目录应类似：

```text
/www/wwwroot/auth.yolohappy.com/
├── config.js                 # 必填，见下
├── auth/
│   ├── auth-callback.js
│   ├── confirm/
│   │   └── index.html
│   └── reset-password/
│       └── index.html
└── vendor/                   # 推荐：自托管 supabase-js，避免 jsDelivr 国内失败
    └── supabase.min.js
```

页面请求路径：

- `/config.js`
- `/auth/confirm/` → `auth/confirm/index.html`
- `/auth/reset-password/`
- `/auth/auth-callback.js`

宝塔默认一般支持上述静态路径；若 `/auth/confirm` 无尾斜杠 404，在站点配置加：

```nginx
location = /auth/confirm { return 301 /auth/confirm/; }
location = /auth/reset-password { return 301 /auth/reset-password/; }
```

---

## 2. 准备并上传文件

### 2.1 从本机仓库拷贝

在 **Mac**（仓库根目录）：

```bash
cd /Users/vesperal/Desktop/YOLO

# 本地打包一个上传目录
rm -rf /tmp/yolo-auth-web && mkdir -p /tmp/yolo-auth-web/auth /tmp/yolo-auth-web/vendor
cp web/auth/auth-callback.js /tmp/yolo-auth-web/auth/
cp -R web/auth/confirm /tmp/yolo-auth-web/auth/
cp -R web/auth/reset-password /tmp/yolo-auth-web/auth/
```

### 2.2 写国内用的 `config.js`

> 注意：确认页点按钮后会请求这里的 `supabaseUrl`。国内务必填 **gateway**，不要填 Workers，也不要只填裸 `supabase.co`（会回到慢链路）。

在 `/tmp/yolo-auth-web/config.js`：

```javascript
window.YOLO_WEB_CONFIG = {
  supabaseUrl: "https://gateway.yolohappy.com",
  supabaseAnonKey: "你的 sb_publishable_…（与 App 相同）",
  appStoreUrl: "https://apps.apple.com/app/id0000000000",
  shareWebBaseUrl: "https://auth.yolohappy.com"
};
```

`supabaseAnonKey` 与 `Secrets.xcconfig` 里 `SUPABASE_ANON_KEY` 相同即可（publishable，可进前端）。

### 2.3（强烈推荐）自托管 supabase-js

确认页默认可能从 `cdn.jsdelivr.net` 拉 JS，**国内常失败**。改为本地文件：

```bash
# 在有外网的 Mac 上下载 UMD 构建
curl -fsSL \
  "https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2/dist/umd/supabase.min.js" \
  -o /tmp/yolo-auth-web/vendor/supabase.min.js
```

然后改两个 HTML（若仓库尚未改好，在服务器上的副本改）：

把：

```html
<script type="module">
  import { createClient } from "https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2/+esm";
```

换成（经典脚本，不依赖 jsDelivr）：

在 `</body>` 前、业务脚本前增加：

```html
<script src="/vendor/supabase.min.js"></script>
```

业务脚本里用：

```javascript
const { createClient } = window.supabase;
```

（仓库若已提供「中国部署版」HTML，可直接拷 `web/auth/**`。）

### 2.4 上传到服务器

任选：

- 宝塔 **文件** → 进 `/www/wwwroot/auth.yolohappy.com` → 上传 `/tmp/yolo-auth-web` 全部内容  
- 或本机 `scp -r /tmp/yolo-auth-web/* root@101.201.125.178:/www/wwwroot/auth.yolohappy.com/`  
  （若 22 被拒，继续用宝塔上传）

### 2.5 本机冒烟（DNS 好之前可用 --resolve）

```bash
curl -Ik --resolve auth.yolohappy.com:443:101.201.125.178 \
  https://auth.yolohappy.com/auth/confirm/

curl -sS --resolve auth.yolohappy.com:443:101.201.125.178 \
  https://auth.yolohappy.com/config.js | head
```

期望：HTML 200；`config.js` 含 `gateway.yolohappy.com`。

**更新确认页（邮箱确认后回 App）**：仓库改 [`web/auth/confirm/index.html`](../web/auth/confirm/index.html) 后，覆盖上传到：

`/www/wwwroot/auth.yolohappy.com/auth/confirm/index.html`

成功页须**点「Open YOLO App」**才跳深链（无自动跳转）。App 侧可点 **I've confirmed — Sign in** 兜底。

---

## 3. DNS

[云解析](https://dns.console.aliyun.com/) → `yolohappy.com`：


| 主机记录 | 线路 | 类型 | 记录值 |
| --- | --- | --- | --- |
| `auth` | **默认** | A | `101.201.125.178` |
| `auth` | **中国大陆/中国地区** | A | `101.201.125.178` |


（全球先都指 ECS 即可；静态页体积小。日后可再给 `auth` 套阿里云 CDN。）

```bash
dig +short auth.yolohappy.com @223.5.5.5
# 期望 101.201.125.178

curl -Ik https://auth.yolohappy.com/auth/confirm/
```

---

## 4. Supabase Auth 配置

入口：[Supabase Dashboard](https://supabase.com/dashboard) → 项目 → **Authentication** → **URL Configuration**

### 4.1 Redirect URLs（追加，勿删旧的）

在原有 Workers 地址之外**追加**：

```text
https://auth.yolohappy.com/auth/confirm
https://auth.yolohappy.com/auth/reset-password
```

建议仍保留：

```text
https://yolo.cstudiomunger.workers.dev/auth/confirm
https://yolo.cstudiomunger.workers.dev/auth/reset-password
```

（旧邮件、未升级 App 仍可用 Workers。）

### 4.2 Site URL（可选）

- 可继续用 Workers，或改为 `https://auth.yolohappy.com`
- 改 Site URL 前确认 Redirect 列表已含 auth 域名

### 4.3 邮件模板（若尚未改过）

**Confirm signup** 应用用户点击页，而不是默认立刻消耗的 `ConfirmationURL`：

```html
<h2>Confirm your signup</h2>
<p>Follow this link to confirm your YOLO HAPPY account:</p>
<p><a href="{{ .RedirectTo }}?token_hash={{ .TokenHash }}&type=signup">Confirm your email</a></p>
```

重置密码模板同理可用：

```html
<a href="{{ .RedirectTo }}?token_hash={{ .TokenHash }}&type=recovery">Reset password</a>
```

`RedirectTo` 来自 App 发起注册/找回时传入的 URL → 即下面的 `AUTH_WEB_BASE_URL` + 路径。

---

## 5. 修改 App（本机 Secrets）

### 5.1 `Secrets.xcconfig` 增加（勿提交 Git）

```xcconfig
AUTH_WEB_BASE_URL = https:/$()/auth.yolohappy.com
INFOPLIST_KEY_AUTH_WEB_BASE_URL = $(AUTH_WEB_BASE_URL)
```

并确保 `SupabaseConfig.plist` 含：

```xml
<key>AUTH_WEB_BASE_URL</key>
<string>$(AUTH_WEB_BASE_URL)</string>
```

（仓库若已加好则无需再改 plist。）

效果：

- 注册确认 → `https://auth.yolohappy.com/auth/confirm`
- 重置密码 → `https://auth.yolohappy.com/auth/reset-password`

### 5.2 重装

Xcode → Clean Build Folder → 真机安装。  
**未重装的旧包仍会发 Workers 链接。**

---

## 6. 验收清单


| # | 操作 | 通过标准 |
| --- | --- | --- |
| 1 | 国内 4G/Wi‑Fi 打开 `https://auth.yolohappy.com/auth/confirm/` | 页面秒开或明显快于 Workers |
| 2 | 新装 App 注册测试邮箱 | 邮件链接主机名为 **`auth.yolohappy.com`** |
| 3 | 手机浏览器打开链接 → 点 Confirm | 成功；可跳转 App |
| 4 | 重置密码走一轮 | `auth.yolohappy.com/.../reset-password` 可用 |
| 5 | Charles：确认页请求 API | Host 为 **`gateway.yolohappy.com`**（来自 config.js） |

---

## 7. 回滚


| 回滚项 | 做法 |
| --- | --- |
| App | 删掉 `AUTH_WEB_BASE_URL` 或改回 Workers 域名后重装 |
| 邮件 | Redirect 仍留着 Workers，旧模板/旧包不受影响 |
| 站点 | 宝塔停用 `auth` 站点；DNS 可先留着 |

---

## 8. 常见问题


| 现象 | 处理 |
| --- | --- |
| 页面开了但点确认转圈/失败 | `config.js` 的 `supabaseUrl` 是否 gateway；gateway 是否健康；anon key 是否对 |
| 页面脚本报错 / createClient undefined | 未放 `/vendor/supabase.min.js` 或仍走被墙的 jsDelivr |
| 邮件链接仍是 workers.dev | App 未带上新 `AUTH_WEB_BASE_URL` 或未重装 |
| Supabase 拒绝 redirect | Redirect allow list 未加 `https://auth.yolohappy.com/auth/...` |
| `/auth/confirm` 404 | 目录或 Nginx 尾斜杠；确认 `confirm/index.html` 已上传 |

---

## 与本次 API 加速的关系

- **gateway**：App API + 确认页上的 `verifyOtp`  
- **media**：封面音频  
- **auth.yolohappy.com**：仅邮件落地页（静态）  

三者分开配置，互不替代。
