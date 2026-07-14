# 认证页国内外分流 — 详细操作

邮件里的链接在**发送时就写死**。要让国内打开快、海外也不绕远，有两种做法：

| 方案 | 邮件里的链接 | 谁决定走国内站还是 Workers | 推荐度 |
| --- | --- | --- | --- |
| **A. 同一域名 + GeoDNS** | 一律 `https://auth.yolohappy.com/...` | **打开网页时** DNS 按 IP 分流 | ★★★★★ 更准，与 API 加速一致 |
| **B. App 按地区发不同链接** | 国内设备发 `auth...`，海外发 `workers.dev` | **发信时** App 猜地区 | ★★☆ 你点名要的；有误判 |

> API 你们已约定不做 App 侦测、用 GeoDNS。认证页**同样更推荐方案 A**。方案 B 作备选，文末写清局限。

**前提**：国内站 `auth.yolohappy.com` 已能打开；Workers `yolo.cstudiomunger.workers.dev` 仍在线；Supabase Redirect 白名单两个域名都有。

---

## 方案 A（推荐）：同一链接 + GeoDNS

海外用户点的也是 `auth.yolohappy.com`，但解析到 Cloudflare Workers；国内解析到北京 ECS。

### A.1 给 Workers 绑定自定义域 `auth.yolohappy.com`

1. 打开 [Cloudflare Dashboard](https://dash.cloudflare.com) → **Workers & Pages** → 项目 **`yolo`**
2. **Settings** → **Domains & Routes**（或 Custom Domains）→ **Add**
3. 添加：`auth.yolohappy.com`
4. 按提示完成所有权验证（通常在阿里云加一条 Cloudflare 要求的 TXT / CNAME）
5. 记下手册给出的 **目标 CNAME**（形如 `xxx.workers.dev` 或 Cloudflare 专用接入域）

部署需包含最新 `web/auth/**` 与 `web/vendor/supabase.min.js`（与国内站同一套页面）。Workers 的 `config.js` 里：

- 海外：`supabaseUrl` 可用 `https://edwvrriuwzaaqznklrgi.supabase.co` 或 `https://gateway.yolohappy.com`（gateway 海外 GeoDNS 会进 Supabase）
- 国内 ECS 上的 `config.js` 继续用 `https://gateway.yolohappy.com`

两边可以各保留一份 `config.js`（Workers 构建变量 vs 宝塔手改文件）。

### A.2 阿里云 DNS 分线路

[云解析](https://dns.console.aliyun.com/) → `yolohappy.com` → 主机 **`auth`**：


| 主机 | 线路 | 类型 | 记录值 |
| --- | --- | --- | --- |
| `auth` | **中国大陆 / 中国地区** | **A** | `101.201.125.178`（宝塔） |
| `auth` | **默认** | **CNAME** | Cloudflare 给的 Workers 接入目标（A.1） |


不要两条线路都指 ECS。若默认仍是 A→ECS，海外会一直绕中国。

### A.3 App / Supabase（保持单一地址）

`Secrets.xcconfig`：

```xcconfig
AUTH_WEB_BASE_URL = https:/$()/auth.yolohappy.com
```

Supabase：

- **Site URL**：`https://auth.yolohappy.com`
- **Redirect URLs** 含：
  - `https://auth.yolohappy.com/auth/confirm`
  - `https://auth.yolohappy.com/auth/reset-password`
  - （可选保留）`https://yolo.cstudiomunger.workers.dev/auth/...` 兼容旧邮件

邮件模板继续用 `{{ .RedirectTo }}?token_hash=...`（见下文模板）。

### A.4 验收


| 网络 | `dig auth.yolohappy.com` | 打开确认页 |
| --- | --- | --- |
| 国内 | → `101.201.125.178` | 宝塔站，快 |
| 海外 / 关「海外」VPN 测 `@8.8.8.8` | → Workers/CF | Workers 页，海外快 |

邮件链接**始终**是 `auth.yolohappy.com`，无需 App 分地区。

---

## 方案 B：海外继续 `workers.dev` + App 按地区发不同链接

发信瞬间由 App 选择 `redirectTo`：

- 判定「像在中国」→ `https://auth.yolohappy.com/auth/confirm`（或 reset-password）
- 否则 → `https://yolo.cstudiomunger.workers.dev/auth/confirm`

### B.0 局限（先读再做）

| 情况 | 结果 |
| --- | --- |
| 中国手机 Locale=CN，人在美国 | 仍发 `auth` 链接 → 人在海外打开北京站，偏慢 |
| 外国游客手机 Locale=US，人在中国 | 仍发 `workers.dev` → 国内可能慢/打不开 |
| 用户改系统语言/地区 | 与真实网络不一致 |
| **不要用「国籍」**（App 里选的 nationality） | 游客多为非中国国籍，会几乎全员收到 Workers |

GeoDNS（方案 A）按**打开链接时的 IP** 分流，比发信时猜 Locale 准。

### B.1 Supabase 白名单（两个宿主都要）

**Authentication → URL Configuration → Redirect URLs** 全部加上：

```text
https://auth.yolohappy.com/auth/confirm
https://auth.yolohappy.com/auth/reset-password
https://yolo.cstudiomunger.workers.dev/auth/confirm
https://yolo.cstudiomunger.workers.dev/auth/reset-password
```

**Site URL** 建议仍用一个主站，例如：

```text
https://auth.yolohappy.com
```

（仅作回落；真正链接以邮件里 `RedirectTo` 为准。）

### B.2 邮件模板（确认 + 重置）

**Confirm signup：**

```html
<h2>Confirm your signup</h2>
<p>Follow this link to confirm your YOLO HAPPY account:</p>
<p><a href="{{ .RedirectTo }}?token_hash={{ .TokenHash }}&type=signup">Confirm your email</a></p>
```

**Reset password：**

```html
<h2>Reset your password</h2>
<p>Follow this link to reset the password for your YOLO HAPPY account:</p>
<p><a href="{{ .RedirectTo }}?token_hash={{ .TokenHash }}&type=recovery">Reset password</a></p>
<p>If you did not request a password reset, you can ignore this email.</p>
```

### B.3 Secrets / 双基址配置

`Secrets.xcconfig`（示例）：

```xcconfig
// 不再只写一个 AUTH_WEB_BASE_URL 一刀切时：
AUTH_WEB_BASE_URL_CN = https:/$()/auth.yolohappy.com
AUTH_WEB_BASE_URL_INTL = https:/$()/yolo.cstudiomunger.workers.dev
// 可选：强制只用一个（排障时）
// AUTH_WEB_BASE_URL = https:/$()/auth.yolohappy.com

INFOPLIST_KEY_AUTH_WEB_BASE_URL_CN = $(AUTH_WEB_BASE_URL_CN)
INFOPLIST_KEY_AUTH_WEB_BASE_URL_INTL = $(AUTH_WEB_BASE_URL_INTL)
```

`SupabaseConfig.plist` 增加对应 key（与现有 `AUTH_WEB_BASE_URL` 并列）。

### B.4 App 逻辑（`AppConfig`）

伪代码（实现时写进 `AppConfig.swift`）：

```swift
nonisolated static var authWebBaseURL: String {
    // 排障：若配置了单一 AUTH_WEB_BASE_URL，永远用它
    if let forced = plistString(forKey: "AUTH_WEB_BASE_URL")?
        .trimmingCharacters(in: CharacterSet(charactersIn: "/")),
       !forced.isEmpty {
        return forced
    }
    let cn = plistString(forKey: "AUTH_WEB_BASE_URL_CN")
        ?? "https://auth.yolohappy.com"
    let intl = plistString(forKey: "AUTH_WEB_BASE_URL_INTL")
        ?? "https://yolo.cstudiomunger.workers.dev"
    return prefersChinaAuthLanding ? trimSlash(cn) : trimSlash(intl)
}

/// 发信时「像在中国」——仅用系统地区，不用国籍、不做 VPN 探测
nonisolated static var prefersChinaAuthLanding: Bool {
    if #available(iOS 16, *) {
        if let region = Locale.current.region?.identifier {
            return region.uppercased() == "CN"
        }
    } else if let region = Locale.current.regionCode {
        return region.uppercased() == "CN"
    }
    // 弱回落：简体中文语言（误判更多，可按产品关掉）
    return Locale.current.language.languageCode?.identifier == "zh"
}
```

`emailConfirmationRedirectURL` / `authRedirectURL` 继续基于 `authWebBaseURL` 拼路径（现有代码已如此）。

### B.5 编译与测试


| 步骤 | 操作 |
| --- | --- |
| 1 | 实现 B.3 / B.4 后 Clean + 删 App + 重装 |
| 2 | iPhone **设置 → 通用 → 语言与地区 → 地区 = 中国** → 注册测试邮箱 |
| 3 | 新邮件链接主机应为 **`auth.yolohappy.com`** |
| 4 | 把地区改成 **美国** → 再发重置密码 |
| 5 | 新邮件主机应为 **`yolo.cstudiomunger.workers.dev`** |

旧邮件不会变；只看**新发**的。

### B.6 Workers `config.js`（海外页）

海外落在 Workers 时，`web/config.js`（或 CF 构建变量）建议：

```javascript
supabaseUrl: "https://edwvrriuwzaaqznklrgi.supabase.co"
// 或 gateway（海外 GeoDNS 会进 Supabase）
```

不要写成只有国内才通的地址。国内宝塔 `config.js` 继续 `gateway.yolohappy.com`。

### B.7 回滚方案 B

1. `Secrets` 只保留  
   `AUTH_WEB_BASE_URL = https:/$()/auth.yolohappy.com`  
2. 去掉 CN/INTL 分支或强制 `AUTH_WEB_BASE_URL`  
3. 重装 App  
4. 需要海外体验时改上方案 A 的 DNS  

---

## 怎么选？

| 目标 | 选 |
| --- | --- |
| 国内稳、海外也尽量对、少改 App | **方案 A** |
| 必须海外邮件域名仍是 `workers.dev` 字样 | **方案 B** |
| 既要准又要 `workers.dev` 字样 | A 做打开分流 + 品牌上仍显示 auth 域名；或接受 B 的误判 |

---

## 相关文档

- 国内站部署：[`china-auth-web-ops.md`](china-auth-web-ops.md)
- API GeoDNS：[`china-cdn-full-ops.md`](china-cdn-full-ops.md)
