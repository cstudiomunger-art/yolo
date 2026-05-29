# YOLO HAPPY Web

默认域名：**https://yolo.cstudiomunger.workers.dev**

分享页、邮箱确认页、重置密码页均在同一 `web/` 目录，**一次部署全部生效**。

## 推荐：Cloudflare 连接 GitHub（无需本机终端）

部署在 Cloudflare 云端执行，不受本机代理影响。配置文件为仓库根目录 `wrangler.jsonc`。

### 一次性设置

1. 将本仓库推送到 GitHub（可用 GitHub Desktop 等图形工具，无需终端）。

2. 打开 [Cloudflare Dashboard](https://dash.cloudflare.com) → **Workers & Pages** → 选择已有项目 **`yolo`**。

3. 进入 **Settings** → **Builds** → **Connect Git**（或 **Connect to repository**），授权并选择本仓库。

4. 构建配置：

| 配置项 | 值 |
|--------|-----|
| Production branch | `main`（或你的主分支名） |
| Root directory | `/`（仓库根目录） |
| Build command | `npm run build:web` |
| Deploy command | `npx wrangler deploy` |

构建会生成并提交 `web/config.js`（anon key 为公开客户端密钥）。若使用 Cloudflare 环境变量 `SUPABASE_ANON_KEY`，构建时会覆盖 example 中的默认值。

5. **Environment variables**（构建阶段需要，用于生成 `web/config.js`）：

| 变量名 | 值 |
|--------|-----|
| `SUPABASE_URL` | `https://edwvrriuwzaaqznklrgi.supabase.co` |
| `SUPABASE_ANON_KEY` | 你的 Publishable / anon key |
| `SHARE_WEB_BASE_URL` | `https://yolo.cstudiomunger.workers.dev` |

6. 保存并点击 **Deploy**。之后每次向生产分支 **push** 代码会自动重新部署。

### 部署后验证

- https://yolo.cstudiomunger.workers.dev/.well-known/apple-app-site-association
- https://yolo.cstudiomunger.workers.dev/i/\<share_slug\>
- https://yolo.cstudiomunger.workers.dev/auth/confirm
- https://yolo.cstudiomunger.workers.dev/auth/reset-password

---

## 备选：本机终端 + Wrangler

```bash
chmod +x scripts/deploy-web.sh
./scripts/deploy-web.sh
```

或手动（在 `web/` 目录，使用 `web/wrangler.toml`）：

```bash
cd web
export SUPABASE_URL="https://edwvrriuwzaaqznklrgi.supabase.co"
export SUPABASE_ANON_KEY="你的anon_key"
export SHARE_WEB_BASE_URL="https://yolo.cstudiomunger.workers.dev"
npm run build
npx wrangler login
npx wrangler deploy
```

---

## Supabase Auth

```bash
supabase db push   # 含 039_share_base_workers_dev.sql
```

Auth → **URL Configuration**：

| 项 | 值 |
|----|-----|
| Site URL | `https://yolo.cstudiomunger.workers.dev` |
| Redirect URLs | `https://yolo.cstudiomunger.workers.dev/auth/confirm` |
| | `https://yolo.cstudiomunger.workers.dev/auth/reset-password` |

重置密码邮件链接会在网页完成验证与改密；App 通过非 PKCE 的 `/auth/v1/recover` 发起，回调后浏览器 URL 带 `#access_token`（implicit flow）。若使用自定义邮件模板，也可改为 `{{ .RedirectTo }}?token_hash={{ .TokenHash }}&type=recovery`。
