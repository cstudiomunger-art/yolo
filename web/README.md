# YOLO HAPPY Web

默认域名：**https://yolo.cstudiomunger.workers.dev**

## Cloudflare Worker 部署（与控制台项目名 `yolo` 一致）

```bash
cd web

export SUPABASE_URL="https://edwvrriuwzaaqznklrgi.supabase.co"
export SUPABASE_ANON_KEY="你的anon_key"
npm run build

npx wrangler login
npx wrangler deploy
```

部署后验证：

- https://yolo.cstudiomunger.workers.dev/.well-known/apple-app-site-association
- https://yolo.cstudiomunger.workers.dev/i/\<share_slug\>

## Supabase

```bash
supabase db push   # 含 039_share_base_workers_dev.sql
```

Auth → Site URL：`https://yolo.cstudiomunger.workers.dev`  
Redirect URLs：`yoloapp://auth/reset-password`
