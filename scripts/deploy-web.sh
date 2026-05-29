#!/usr/bin/env bash
# Deploy web/ (share pages + auth landing pages) to Cloudflare Workers project「yolo」
# Same flow as web/README.md — static assets via wrangler [assets].

set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
WEB="$ROOT/web"
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
export SHARE_WEB_BASE_URL="${SHARE_WEB_BASE_URL:-https://yolo.cstudiomunger.workers.dev}"

if [[ -z "${SUPABASE_URL}" || -z "${SUPABASE_ANON_KEY}" ]]; then
  echo "缺少 Supabase 配置。请设置环境变量或在 ${SECRETS_FILE} 中配置："
  echo "  SUPABASE_URL"
  echo "  SUPABASE_ANON_KEY"
  exit 1
fi

if [[ -z "${CLOUDFLARE_API_TOKEN:-}" ]] && ! npx wrangler whoami >/dev/null 2>&1; then
  echo "未检测到 Cloudflare 认证。请先执行其一："
  echo "  npx wrangler login"
  echo "或设置 CLOUDFLARE_API_TOKEN（见 https://developers.cloudflare.com/fundamentals/api/get-started/create-token/）"
  exit 1
fi

if scutil --proxy 2>/dev/null | grep -q "HTTPEnable : 1"; then
  echo "⚠️  检测到系统 HTTP/HTTPS 代理（常见于 Clash/Surge）。"
  echo "   若 wrangler deploy 报 fetch failed / certificate mismatch，请先："
  echo "   1) 关闭代理软件的「系统代理」后重试，或"
  echo "   2) 在代理规则中将 cloudflare.com、workers.dev 设为 DIRECT，或"
  echo "   3) 换手机热点等无代理网络执行部署。"
  echo ""
fi

echo "==> 生成 web/config.js ..."
cd "$WEB"
npm run build

echo "==> 部署到 Cloudflare Workers（项目 yolo）..."
npx wrangler deploy

echo ""
echo "部署完成。请验证："
echo "  ${SHARE_WEB_BASE_URL}/.well-known/apple-app-site-association"
echo "  ${SHARE_WEB_BASE_URL}/i/<share_slug>"
echo "  ${SHARE_WEB_BASE_URL}/auth/confirm"
echo "  ${SHARE_WEB_BASE_URL}/auth/reset-password"
