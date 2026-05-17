# ChinaGo 后台管理系统（HTML + Supabase）

基于浏览器的 CMS，通过 **Supabase Auth** 登录，使用 **anon key** 读写数据库（需先配置管理员 RLS）。

## 1. 数据库准备

在 [Supabase Dashboard](https://supabase.com/dashboard) → **SQL Editor** 中按顺序执行：

1. `supabase/migrations/001_app_settings_and_extensions.sql`
2. `supabase/migrations/002_profiles.sql`
3. `supabase/migrations/004_content_tables.sql`
4. `supabase/migrations/005_admin_policies.sql`
5. `supabase/migrations/006_extended_content.sql`
6. `supabase/migrations/007_extended_content_rls.sql`
7. `supabase/migrations/009_align_content_columns.sql`（**若表已存在但缺列**，例如没有 `emoji`）
8. `supabase/migrations/010_fix_text_primary_keys.sql`（**若 id 是 uuid**，seed 会报 `invalid input syntax for type uuid`）
9. `supabase/migrations/008_seed_content.sql`（**初始数据**，来自 `YOLO/Resources/Static/*.json`）
10. `supabase/migrations/011_app_branding_and_assistant_chips.sql`（应用文案 / 助手芯片）
11. `supabase/migrations/012_audio_storage.sql`（音频 Storage 桶，供后台上传）
12. `supabase/migrations/003_enable_remote_content.sql`（打开 App 远程内容）

## 2. 导入初始内容

**方式 A — SQL（推荐）**

在 SQL Editor 依次执行：

1. `009_align_content_columns.sql`（缺列时）
2. `010_fix_text_primary_keys.sql`（`city_routes` 等 id 为 uuid 时 **必跑**；会重建子表，保留 `cities` 数据）
3. `008_seed_content.sql`（幂等，可重复执行）

**方式 B — Node 脚本**

```bash
cd scripts && npm install && cd ..
SUPABASE_URL=https://你的项目.supabase.co \
SUPABASE_SERVICE_ROLE_KEY=你的_service_role_key \
node scripts/seed-content.mjs
```

**重新生成 SQL**（修改了 Static JSON 后）：

```bash
node scripts/generate-seed-sql.mjs
```

之后所有内容请在 **本后台** 或 Supabase Table Editor 中维护。

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

## CMS 菜单与数据表

| 菜单 | 表 | App 用途 |
|------|-----|----------|
| 应用配置 | `app_settings` | 远程开关、关于页、内购文案、Plan 警告、反馈邮箱、试听时长 |
| 助手芯片 | `assistant_chips` | Assistant 底部快捷按钮（关联 `assistant_replies`） |
| 护照国家 | `passport_countries` | 引导 & Profile 选国 |
| 签证规则 | `visa_rules` | Home 签证标签 |
| 城市 / 景点 / 清单等 | 见侧栏 | 各 Tab 内容 |
| 文化贴士 | `culture_tips` | Guide |
| 助手回复 | `assistant_replies` | Assistant 场景回复 |
| 紧急联系 | `emergency_config` | Assistant 紧急 Sheet |
| 行程模板 | `content_itineraries` | Plan 样本 & Assistant 规划卡 |

### 音频导览

1. 在 **音频导览** 中填写 `id` 与景点 `attraction_id`
2. 使用编辑弹窗中的 **上传音频文件**（需已执行 `012_audio_storage.sql`）
3. 保存后 `audio_url` 会写入 Supabase Storage 公网地址；App 在远程内容模式下即可播放

## 安全说明

- `admin/js/config.js` 勿提交仓库
- 网页仅使用 **anon key**；`seed-content.mjs` 仅在本地使用 **service_role**
- 仅 `admin_users` 中的账号可增删改内容
