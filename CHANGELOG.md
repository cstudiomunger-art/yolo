# Changelog

## 2026-06-02

### ✨ 新功能

#### 文化贴士模块重构
- **拆分通用 + 城市特色**：`culture_tips` 表新增 `city_id` 列（NULL = 通用，非空 = 城市特色）
- **嵌入行前清单页**：用户创建行程后，PrepareView 行前清单下方自动显示对应城市的文化贴士
- **按行程城市过滤**：`fetchCultureTips(cityIds:)` 仅返回通用贴士 + 行程包含城市的特色贴士
- **后台可编辑**：Admin「签证与文化 → 文化贴士」新增城市选择字段，留空 = 通用

#### 行前清单折叠展开
- 各模块（Entry Requirements / Essential Prep / 城市专属）支持点击标题折叠/展开
- 折叠状态下右侧显示完成进度（如 2/5）
- 展开/折叠带 0.2s 动画

#### AI 助手流式输出
- Edge Function 通过 SSE 将 VolcEngine 响应实时转发给客户端
- iOS 端用 `URLSession.bytes` 逐行读取，文字边生成边显示
- 首个 token 到达即展示（约 0.3–0.5s），消除"等待黑屏"体验
- 对话历史压缩至最近 6 条，减少 token 消耗

#### AI 配置全部迁移至后台管理系统
- `ai_system_prompt_assistant`、`ai_chat_max_tokens`、`ai_temperature`、`ai_timeout_ms` 初始值写入数据库
- 代码中不再有有效的硬编码提示词，仅保留本地开发兜底最小值
- Admin「应用配置 → 大模型调用」字段说明更新，支持随时修改提示词和参数

---

### 🐛 修复

| 问题 | 修复方式 |
|------|----------|
| 文化贴士不按城市过滤，所有城市贴士全部显示 | 根因：`CultureTip.CodingKeys` 使用显式 snake_case raw value（`city_id`），与 `convertFromSnakeCase` decoder 冲突，导致 `cityId` 永远解码为 nil。改为 `case cityId`，依赖 decoder 自动映射 |
| PrepareView 打开时仍显示旧缓存数据（city_id 全为 nil） | `bootstrap()` 改为调用 `reloadContent(invalidateCache: true)`，每次打开清除所有 `culture_tips_*` 磁盘缓存文件 |
| 磁盘缓存 TTL 24h 导致 DB 更新后 App 长时间看到旧数据 | `ContentCacheStore` 新增 `removeByPrefix()` 方法，文化贴士在内容版本变化或行程切换时主动清缓存 |
| culture_tips city_id 外键约束导致 seed 失败（FK violation） | 迁移 046 改为先 DROP FK constraint，再用普通 VALUES 插入 |
| `@ViewBuilder` 内 `let` + `if` + 嵌套 `ForEach` 渲染不稳定 | 将分组逻辑提取为 `universalCultureTips` 和 `cityCultureTipGroups` 计算属性，ViewBuilder 只负责渲染 |
| AI 助手每次请求串行查两次数据库（+200–600ms 延迟） | `loadAISettingsFromCMS()` 缓存 5 分钟，`loadAssistantScenario()` 按 scenarioId 缓存 10 分钟 |

---

### ⚡ 性能优化

- **AI 设置 DB 查询缓存**：Edge Function 实例内 `app_settings` 首次查询后缓存 5 分钟
- **场景 Prompt 缓存**：`assistant_scenarios` 按 scenarioId 缓存 10 分钟
- **AI 流式输出**：用户感知响应时间从 3–8s 降至首字符 0.3–0.5s

---

### 🗃️ 数据库迁移

| 文件 | 说明 |
|------|------|
| `044_culture_tips_city.sql` | `culture_tips` 添加 `city_id` 列 |
| `045_seed_culture_tips_city.sql` | 城市特色文化贴士示例数据（条件插入） |
| `046_culture_tips_city_fix.sql` | 去掉 FK 约束 + 重跑 seed |
| `047_ai_settings_seed.sql` | 将 AI 配置初始值写入 `app_settings` |

---

### 📁 主要改动文件

**iOS**
- `YOLO/Models/DomainModels.swift` — CultureTip 添加 cityId，修复 CodingKeys
- `YOLO/Repositories/ContentRepository.swift` — fetchCultureTips(cityIds:) 签名
- `YOLO/Repositories/RemoteContentRepository.swift` — 流式 chatAssistantStream()
- `YOLO/Repositories/CachingContentRepository.swift` — culture tips 缓存失效逻辑
- `YOLO/Services/AIService.swift` — chatAssistantStream() SSE 实现
- `YOLO/Services/ContentCacheStore.swift` — removeByPrefix() 方法
- `YOLO/Features/Prepare/PrepareView.swift` — 文化贴士区块 + 折叠清单
- `YOLO/Features/Assistant/AssistantView.swift` — 流式气泡 + 自动滚动

**Edge Function**
- `supabase/functions/ai-complete/index.ts` — 流式路由 + DB 查询缓存
- `supabase/functions/_shared/volcengine.ts` — streamChatCompletion() + thinkingMode 参数
- `supabase/functions/_shared/ai-settings.ts` — AI 设置缓存 + 去掉硬编码 prompt

**Admin CMS**
- `admin/js/schema.js` — 文化贴士城市字段 + AI 配置字段说明更新
