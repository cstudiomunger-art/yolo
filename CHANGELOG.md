# Changelog — 2026-06-02

---

## 一、文化贴士模块重构

### 功能
- **通用 + 城市特色拆分**：`culture_tips` 表新增 `city_id` 列（`NULL` = 通用，非空 = 城市特色）
- **嵌入行前清单页**：用户创建行程后，PrepareView 行前清单下方自动显示对应城市的文化贴士；未创建行程时不显示
- **按行程城市精确过滤**：`fetchCultureTips(cityIds:)` 仅返回通用贴士 + 行程城市对应特色贴士，其他城市贴士不加载
- **后台可配置**：Admin「签证与文化 → 文化贴士」新增城市选择字段，留空 = 通用

### Bug 修复
| 问题 | 根因 | 修复 |
|------|------|------|
| 所有城市贴士全部显示，不按行程过滤 | `CultureTip.CodingKeys` 使用显式 `case cityId = "city_id"`，与 Supabase decoder 的 `convertFromSnakeCase` 冲突，`cityId` 永远解码为 `nil` | 改为 `case cityId`，依赖 decoder 自动映射 |
| 打开 PrepareView 仍显示旧缓存（全 NULL city_id） | `bootstrap()` 未清缓存，磁盘缓存 TTL 24h 导致 DB 更新后长期看到旧数据 | `bootstrap()` 改为 `reloadContent(invalidateCache: true)`，每次打开清除所有 `culture_tips_*` 缓存文件 |
| 切换城市后缓存未更新 | `invalidateCultureTips` 只清当前 cityIds 的 key | 改为 `removeByPrefix("culture_tips_")`，清除所有城市组合的旧缓存 |
| seed 数据插入报 FK 约束错误 | `culture_tips_city_id_fkey` 约束，但 `cities` 表未完整导入 | 迁移 046 先 DROP FK constraint，再用普通 VALUES 插入 |
| `@ViewBuilder` 内嵌套 `ForEach` + `let` + `if` 渲染不稳定 | SwiftUI ViewBuilder 限制 | 分组逻辑提取为 `universalCultureTips` / `cityCultureTipGroups` 计算属性，ViewBuilder 只负责渲染 |

### 数据库迁移
- `044_culture_tips_city.sql` — `culture_tips` 添加可空 `city_id` 列
- `045_seed_culture_tips_city.sql` — 7 条示例贴士（2 通用 + 北京/上海/成都/西安各城市特色）
- `046_culture_tips_city_fix.sql` — 去掉 FK 约束 + 重跑 seed 数据

---

## 二、行前清单折叠展开

- 各模块（Entry Requirements / Essential Prep / 城市专属）支持点击标题折叠 / 展开
- 折叠状态下右侧显示该模块完成进度（如 `2/5`）
- 切换带 `easeInOut(duration: 0.2)` 动画，整行可点击
- 默认全部展开

---

## 三、AI 助手优化

### DB 查询缓存（减少每次请求 200–600ms）
- `loadAISettingsFromCMS()` 结果在 Edge Function 实例内存中缓存 5 分钟，同一实例内只查一次数据库
- `loadAssistantScenario()` 按 `scenarioId` 缓存 10 分钟，首次查 DB 后命中内存
- 查询失败时返回上次成功的缓存值（而非 fallback 默认值）

### AI 配置全部迁移至后台管理系统
- **之前**：`ai_system_prompt_assistant`、`ai_chat_max_tokens`、`ai_temperature`、`ai_timeout_ms` 均为 NULL，代码回退硬编码默认值
- **之后**：迁移 047 将所有初始值写入 `app_settings` 数据库，管理员在后台「应用配置 → 大模型调用」可随时修改，5 分钟内生效
- 代码中仅保留最小兜底（`"You are a helpful China travel assistant. Be concise."`），仅本地开发无 DB 时触发
- Admin 字段说明更新，去掉"可选"说明，改为明确用途和生效时机

### 系统 Prompt 优化
- 新增长度控制规则：greeting → 1 句，简单问题 → 1–3 句，复杂规划 → 最多 150 词
- 明确禁止自我介绍和列举能力，回答完即停止
- 默认 `max_tokens` 从 450 降至 200

### 数据库迁移
- `047_ai_settings_seed.sql` — 将所有 AI 配置初始值写入 `app_settings`

---

## 四、主要改动文件

**iOS**
| 文件 | 改动内容 |
|------|----------|
| `Models/DomainModels.swift` | `CultureTip` 添加 `cityId`，修复 `CodingKeys` snake_case 解码问题 |
| `Repositories/ContentRepository.swift` | `fetchCultureTips(cityIds:)` 协议签名更新 |
| `Repositories/RemoteContentRepository.swift` | 同上，客户端城市过滤逻辑 |
| `Repositories/CachingContentRepository.swift` | `invalidateCultureTips()` 按前缀清缓存 |
| `Services/AIService.swift` | `chatAssistantStream()` SSE 流式方法（备用） |
| `Services/ContentCacheStore.swift` | 新增 `removeByPrefix()` |
| `Features/Prepare/PrepareView.swift` | 文化贴士区块 + 行前清单折叠展开 |
| `Features/Assistant/AssistantView.swift` | 非流式恢复，保留流式相关状态变量 |

**Edge Function**
| 文件 | 改动内容 |
|------|----------|
| `ai-complete/index.ts` | 非流式调用 + 场景 Prompt 缓存 |
| `_shared/volcengine.ts` | `thinkingMode` 参数 + `streamChatCompletion()`（备用） |
| `_shared/ai-settings.ts` | AI 设置 5 分钟内存缓存 + 去掉硬编码 prompt |

**Admin CMS**
| 文件 | 改动内容 |
|------|----------|
| `admin/js/schema.js` | 文化贴士城市字段 + AI 配置字段说明更新 |

---

## 五、回滚记录

| 时间 | 操作 | 原因 |
|------|------|------|
| 2026-06-02 | 回滚流式输出（`978d44d`） | 流式实现待验证，暂时恢复非流式 |
| 2026-06-02 | 回滚流式 + Changelog（`ab502e9`） | 流式开启后 AI 始终返回默认回复，原因待查 |

> **存档点**：`checkpoint/before-culture-tips-refactor`（tag），对应文化贴士重构前的 `main` 状态，可随时 `git checkout` 回滚。
