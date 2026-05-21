# ChinaGo 后台管理系统（HTML + Supabase）

基于浏览器的可视化 CMS，通过 **Supabase Auth** 登录，使用 **anon key** 读写数据库（需先配置管理员 RLS）。

## 推荐工作流

1. 打开 **城市工作台** → 选择城市 → 进入工作台  
2. **景点与解说** → 编辑书面解说、**实用信息**（门票/时长/开放时间等可增删条目）、西方游客贴士、周边推荐  
3. 同一页面内管理 **语音导览**（引文、章节时间轴、上传 MP3）  
4. 全局内容（签证、助手、行程模板等）使用侧栏扁平菜单  

## 1. 数据库准备

在 [Supabase Dashboard](https://supabase.com/dashboard) → **SQL Editor** 中按顺序执行：

1. `supabase/migrations/001_app_settings_and_extensions.sql`
2. `supabase/migrations/002_profiles.sql`
3. `supabase/migrations/004_content_tables.sql`
4. `supabase/migrations/005_admin_policies.sql`
5. `supabase/migrations/006_extended_content.sql`
6. `supabase/migrations/007_extended_content_rls.sql`
7. `supabase/migrations/009_align_content_columns.sql`（缺列时）
8. `supabase/migrations/010_fix_text_primary_keys.sql`（id 为 uuid 时 **必跑**）
9. `supabase/migrations/008_seed_content.sql`（初始数据）
10. `supabase/migrations/011_app_branding_and_assistant_chips.sql`
11. `supabase/migrations/012_audio_storage.sql`（音频 Storage 桶）
12. `supabase/migrations/013_cover_images_storage.sql`（封面图 Storage 桶）
13. `supabase/migrations/014_fix_attractions_audio_guide_count.sql`（修复 audio_guide_count 空值）
14. `supabase/migrations/015_publish_all_attractions.sql`（发布未勾选「已发布」的景点）
15. `supabase/migrations/016_ai_settings.sql`（CMS 可编辑的大模型参数列）
16. `supabase/migrations/003_enable_remote_content.sql`（打开 App 远程内容）
17. `supabase/migrations/031_attraction_practical_info.sql`（景点实用信息 JSON 列表 + 旧列回填）

## 2. 导入初始内容

**方式 A — SQL（推荐）**

依次执行 `009` → `010` → `008`（幂等）。

**方式 B — Node 脚本**

```bash
cd scripts && npm install && cd ..
SUPABASE_URL=https://你的项目.supabase.co \
SUPABASE_SERVICE_ROLE_KEY=你的_service_role_key \
node scripts/seed-content.mjs
```

## 3. 创建管理员账号

1. Dashboard → **Authentication** → **Users** → **Add user**
2. 复制用户 **UUID**
3. SQL Editor：

```sql
INSERT INTO admin_users (user_id, email)
VALUES ('你的-uuid', 'admin@yourdomain.com')
ON CONFLICT (user_id) DO NOTHING;
```

## 4. 本地配置

```bash
cp admin/js/config.example.js admin/js/config.js
```

填入与 iOS `Secrets.xcconfig` 相同的 `supabaseUrl`、`supabaseAnonKey`。

## 5. 启动后台

```bash
cd admin && python3 -m http.server 8080
```

打开 **http://localhost:8080**

## 功能概览

| 功能 | 说明 |
|------|------|
| 城市工作台 | 卡片列表、按城管理景点/音频/路线/酒店/清单 |
| 可视化关联 | 城市、景点、国家、助手场景均为下拉选择，无需手写 ID |
| 结构化编辑 | 贴士列表、周边地点、音频章节、行程天数、紧急联系人 |
| 封面 / 图集 / 内容图 / 音频上传 | Storage 桶 `cover-images`、`audio-guides`；支持本地上传，保存时写入公网 URL |
| 应用配置 | Plan 深链城市/景点选择器、内购权益逐行编辑 |

## Storage 桶

| 桶 | 用途 | 写入列 |
|----|------|--------|
| `audio-guides` | 景点音频 MP3/M4A | `audio_guides.audio_url` |
| `cover-images` | 城市/景点封面、图集、富文本插图 | `cover_image_path`、`cover_images`；富文本内图片经工具栏上传至 `cover-images/{folder}/{entityId}/` |

App 播放音频需完整 HTTPS URL（含 scheme）。

### 音频 / 图片上传失败排查

| 现象 | 处理 |
|------|------|
| `网络无法连接 Supabase` / `Failed to fetch` | 必须用 `cd admin && python3 -m http.server 8080` 打开 **http://localhost:8080**（不要用 `file://`）；关闭广告拦截对 `*.supabase.co`；国内网络可开 VPN |
| 登录后顶部提示 `Storage 不可达` | 同上；在浏览器 DevTools → Network 看对 `supabase.co/storage/v1` 的请求是否被阻断 |
| `无 Storage 写入权限` / RLS | 确认账号在 `admin_users`；已执行 `012_audio_storage.sql` |
| `Storage 桶不存在` | 在 SQL Editor 执行 `012_audio_storage.sql` |
| `API Key 无效` | 在 Dashboard → API Keys 重新复制 **Publishable** 或 **Legacy anon** 到 `config.js` |

子区域音频路径为 `audio-guides/sub-areas/{子区域id}.m4a`，需先填写**英文名**（用于生成 id）再选文件上传。

## 代码结构

```
admin/js/
  core.js          # Supabase、工具函数、上传
  ref-cache.js     # 城市/景点/国家/场景缓存
  schema.js        # 表字段配置
  field-types.js   # 可视化字段组件
  crud.js          # 表格 CRUD、模态框
  city-hub.js      # 城市工作台、景点解说编辑
  admin.js         # 登录与导航
```

## 安全说明

- `admin/js/config.js` 勿提交仓库
- 网页仅使用 **anon key**；`seed-content.mjs` 仅在本地使用 **service_role**
- 仅 `admin_users` 中的账号可增删改内容

## 远程 AI（火山引擎 VolcEngine Ark）

架构：**iOS App** → Supabase Edge Function **`ai-complete`** → 火山方舟 **Chat Completions**。  
API Key 只存在 Supabase Secrets；模型 ID、温度、Prompt 等可在 **后台 → 应用配置** 编辑（写入 `app_settings` 表）。

### 前置条件

| 项目 | 说明 |
|------|------|
| 火山方舟账号 | [火山引擎控制台](https://console.volcengine.com/ark) 开通 Ark，创建**推理接入点** |
| Supabase CLI | `brew install supabase/tap/supabase` 或见官方文档 |
| 已链接项目 | 在仓库根目录执行 `supabase login` 后 `supabase link --project-ref 你的项目ref` |
| 数据库迁移 | 已执行至 **`016_ai_settings.sql`**（否则 CMS 无 AI 字段） |

### 第一步：执行数据库迁移

在 Supabase **SQL Editor** 执行（若已按上文顺序跑过 001–015，只需补跑）：

```sql
-- 文件：supabase/migrations/016_ai_settings.sql
```

或在本地已 link 的项目：

```bash
cd /path/to/YOLO
supabase db push
```

### 第二步：配置 Edge Function Secrets（仅密钥）

**不要**把 API Key 写入 CMS 或 Git。在 Dashboard → **Project Settings** → **Edge Functions** → **Secrets** 添加：

| Secret 名称 | 必填 | 说明 |
|-------------|------|------|
| `VOLCENGINE_API_KEY` | 是 | 火山方舟 API Key |
| `VOLCENGINE_SUGGESTION_MODEL` | 是* | 默认模型 Endpoint ID（CMS 未填 `ai_model_id` 时使用） |
| `VOLCENGINE_CHAT_API_URL` | 否 | 默认 `https://ark.cn-beijing.volces.com/api/v3/chat/completions` |
| `VOLCENGINE_SUGGESTION_MAX_TOKENS` | 否 | 默认 450（CMS 可覆盖助手 token） |
| `VOLCENGINE_ITINERARY_MAX_TOKENS` | 否 | 默认 1200（CMS 可覆盖行程 token） |
| `VOLCENGINE_SUGGESTION_TEMPERATURE` | 否 | 默认 0.7 |
| `VOLCENGINE_SUGGESTION_TIMEOUT_MS` | 否 | 默认 20000 |

CLI 一次性设置示例（把占位符换成真实值）：

```bash
cd /path/to/YOLO
supabase secrets set \
  VOLCENGINE_API_KEY="你的API_KEY" \
  VOLCENGINE_SUGGESTION_MODEL="ep-xxxxxxxx-xxxxx"
```

> Edge Function 会自动使用项目自带的 `SUPABASE_URL` 与 `SUPABASE_SERVICE_ROLE_KEY` 读取 CMS 中的 `app_settings`，无需额外配置。

### 第三步：部署 Edge Function

```bash
cd /path/to/YOLO
supabase functions deploy ai-complete
```

部署成功后，函数地址为：

`https://<project-ref>.supabase.co/functions/v1/ai-complete`

本地调试（需先创建 `supabase/.env.local`，**勿提交 Git**）：

```bash
# supabase/.env.local 示例
VOLCENGINE_API_KEY=你的密钥
VOLCENGINE_SUGGESTION_MODEL=ep-xxxxxxxx
SUPABASE_URL=https://xxx.supabase.co
SUPABASE_SERVICE_ROLE_KEY=你的service_role

supabase functions serve ai-complete --env-file supabase/.env.local --no-verify-jwt
```

另开终端用 curl 验证：

```bash
curl -s -X POST 'http://127.0.0.1:54321/functions/v1/ai-complete' \
  -H 'Content-Type: application/json' \
  -d '{"type":"assistant_chat","message":"How do I pay in China?"}' | jq .

curl -s -X POST 'http://127.0.0.1:54321/functions/v1/ai-complete' \
  -H 'Content-Type: application/json' \
  -d '{"type":"itinerary","cities":["beijing"],"days":3,"style":"Culture"}' | jq .
```

### 第四步：在后台管理系统编辑大模型参数

1. 启动后台：`cd admin && python3 -m http.server 8080`
2. 浏览器打开 http://localhost:8080 ，使用**管理员账号**登录
3. 侧栏进入 **应用配置**
4. 配置项说明：

| CMS 字段 | 作用 |
|----------|------|
| **远程 AI** | 总开关；关闭后 App 仅用静态 `assistant_replies` / 样本行程 |
| **模型 Endpoint ID** | 覆盖 Secrets 中的默认模型；与火山方舟「推理接入点 ID」一致 |
| **Chat API 地址** | 一般保持默认北京 Ark 地址即可 |
| **助手对话 max_tokens** | General 助手单次回复长度上限 |
| **行程生成 max_tokens** | Planning / Plan 生成 JSON 行程的上限 |
| **temperature** | 0–1，越高越发散 |
| **请求超时（毫秒）** | 单次调用 Ark 的超时 |
| **助手 System Prompt** | 可选；留空用内置 ChinaGo 助手人设 |
| **行程 System Prompt** | 可选；留空用内置 JSON 行程提示；自定义时须强调「只输出 JSON」 |

5. 点击 **保存**。Edge Function 在**每次** AI 请求时从 `app_settings`（`id=global`）读取最新配置，**无需重新部署函数**（改 Prompt / 模型 ID 后保存即可生效）。

### 第五步：开启 App 端远程 AI

1. CMS **应用配置** 中勾选 **远程 AI**，并建议同时开启 **远程内容**
2. 或在 SQL Editor：

```sql
UPDATE app_settings
SET use_remote_ai = TRUE,
    use_remote_content = TRUE
WHERE id = 'global';
```

3. iOS：`Secrets.xcconfig` 配置 `SUPABASE_URL` / `SUPABASE_ANON_KEY`，关闭 `FORCE_BUNDLED` 与 `USE_MOCK`
4. 真机/模拟器：Assistant **General Help** 发消息、**Trip Planning** 或 Plan 页生成行程，应收到模型内容（非「远程 AI 尚未连接」）

### 配置优先级（便于排错）

```
模型 ID：  CMS ai_model_id  >  Secret VOLCENGINE_SUGGESTION_MODEL
max_tokens：CMS ai_chat_max_tokens / ai_itinerary_max_tokens  >  Secret 默认值
temperature / timeout / API URL：CMS 列  >  Secret 环境变量
API Key：  仅 Secret VOLCENGINE_API_KEY（CMS 不提供）
```

### 支持的调用类型

| type | App 场景 |
|------|----------|
| `assistant_chat` | Assistant → General Help 对话 |
| `itinerary` | Plan 生成行程、Assistant → Trip Planning |

### 常见问题

| 现象 | 处理 |
|------|------|
| App 仍显示静态回复 | 确认 `use_remote_ai=true` 且未开启 `FORCE_BUNDLED` |
| 函数 500 / CONFIG_ERROR | 检查 Secrets 是否已设置 `VOLCENGINE_API_KEY` 与模型 ID |
| CMS 无 AI 字段 | 执行 `016_ai_settings.sql` 后刷新后台 |
| 改 Prompt 不生效 | 确认已保存应用配置；Edge Function 会实时读库，无需 redeploy |
| 401 调用函数失败 | 生产环境需用户登录（`verify_jwt=true`）；本地调试可用 `--no-verify-jwt` |
