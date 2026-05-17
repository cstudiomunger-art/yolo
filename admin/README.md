# ChinaGo 后台管理系统（HTML + Supabase）

基于浏览器的可视化 CMS，通过 **Supabase Auth** 登录，使用 **anon key** 读写数据库（需先配置管理员 RLS）。

## 推荐工作流

1. 打开 **城市工作台** → 选择城市 → 进入工作台  
2. **景点与解说** → 编辑书面解说（`introduction`）、西方游客贴士、周边推荐  
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
13. `supabase/migrations/003_enable_remote_content.sql`（打开 App 远程内容）

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
| 封面 / 音频上传 | Storage 桶 `cover-images`、`audio-guides`，自动写入公网 URL |
| 应用配置 | Plan 深链城市/景点选择器、内购权益逐行编辑 |

## Storage 桶

| 桶 | 用途 | 写入列 |
|----|------|--------|
| `audio-guides` | 景点音频 MP3/M4A | `audio_guides.audio_url` |
| `cover-images` | 城市/景点封面 | `cities.cover_image_path` / `attractions.cover_image_path` |

App 播放音频需完整 HTTPS URL（含 scheme）。

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
