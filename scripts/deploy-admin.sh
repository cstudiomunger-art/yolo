#!/usr/bin/env bash
# Deploy admin/ CMS to Cloudflare Workers static assets (project「yolo-admin」).
# Default URL: https://yolo-admin.<account>.workers.dev

set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ADMIN="$ROOT/admin"
SECRETS_FILE="$ROOT/Secrets.xcconfig"

read_xcconfig() {
  local key="$1"
  [[ -f "$SECRETS_FILE" ]] || return 1
  local line
  line="$(grep -E "^${key}[[:space:]]*=" "$SECRETS_FILE" | tail -1)" || return 1
  local value="${line#*=}"
  value="$(echo "$value" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
  value="${value//https:\/\$()\/https:\/\/}"
  echo "$value"
}

export SUPABASE_URL="${SUPABASE_URL:-$(read_xcconfig SUPABASE_URL || true)}"
export SUPABASE_ANON_KEY="${SUPABASE_ANON_KEY:-$(read_xcconfig SUPABASE_ANON_KEY || true)}"

if [[ -z "${SUPABASE_URL}" || -z "${SUPABASE_ANON_KEY}" ]]; then
  echo "缺少 Supabase 配置。请设置环境变量或在 ${SECRETS_FILE} 中配置："
  echo "  SUPABASE_URL"
  echo "  SUPABASE_ANON_KEY"
  exit 1
fi

if [[ -z "${CLOUDFLARE_API_TOKEN:-}" ]] && ! npx wrangler whoami >/dev/null 2>&1; then
  echo "未检测到 Cloudflare 认证。请先执行："
  echo "  npx wrangler login"
  echo "或设置 CLOUDFLARE_API_TOKEN"
  exit 1
fi

if scutil --proxy 2>/dev/null | grep -q "HTTPEnable : 1"; then
  echo "⚠️  检测到系统 HTTP/HTTPS 代理。若 deploy 失败，请关闭系统代理或将 cloudflare.com、workers.dev 设为 DIRECT。"
  echo ""
fi

echo "==> 生成 admin/js/config.js ..."
cd "$ADMIN"
npm run build

echo "==> 部署到 Cloudflare Workers（项目 yolo-admin）..."
cd "$ROOT"
npx wrangler deploy --config wrangler.admin.jsonc

echo ""
echo "部署完成。在 Dashboard → Workers → yolo-admin 查看访问 URL。"
echo "建议仅团队使用；可在 Cloudflare Zero Trust 为该 Worker 加 Access 登录保护。"
