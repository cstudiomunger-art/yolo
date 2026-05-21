#!/usr/bin/env bash
# Deploy Supabase Edge Function: ai-complete
# Prerequisites: supabase CLI, supabase login, VOLCENGINE secrets set

set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

PROJECT_REF="${SUPABASE_PROJECT_REF:-edwvrriuwzaaqznklrgi}"

if ! command -v supabase >/dev/null 2>&1; then
  echo "请先安装 Supabase CLI: brew install supabase/tap/supabase"
  exit 1
fi

if [[ -z "${SUPABASE_ACCESS_TOKEN:-}" ]] && [[ ! -f "$HOME/.supabase/access-token" ]]; then
  echo "未检测到 Supabase 登录。请先执行："
  echo "  supabase login"
  echo "或在 https://supabase.com/dashboard/account/tokens 创建 Access Token 后："
  echo "  export SUPABASE_ACCESS_TOKEN=你的token"
  exit 1
fi

echo "==> 部署 ai-complete 到项目 ${PROJECT_REF} ..."
supabase functions deploy ai-complete --project-ref "$PROJECT_REF"

echo ""
echo "部署完成。函数地址："
echo "  https://${PROJECT_REF}.supabase.co/functions/v1/ai-complete"
echo ""
echo "若尚未配置火山引擎密钥，请执行："
echo "  supabase secrets set VOLCENGINE_API_KEY=你的密钥 VOLCENGINE_SUGGESTION_MODEL=你的模型ID --project-ref ${PROJECT_REF}"
echo ""
echo "在 CMS 应用配置中开启「远程 AI」，并执行迁移 016_ai_settings.sql（若未执行）。"
