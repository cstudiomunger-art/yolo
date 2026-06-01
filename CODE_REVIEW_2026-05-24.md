# YOLO / ChinaGo 代码审查报告

**审查日期：** 2026-05-24  
**审查方法：** Codex + Claude 双重审查工作流（需求差距分析 → 代码质量审查 → 最终裁决）  
**参考文档：** `Codex_Claude_代码审查工作流.md`  
**审查范围：** 当前工作区未提交变更（约 55 个已跟踪文件 + 若干未跟踪新文件）

---

## 1. 审查范围

### 1.1 需求来源

| 来源 | 说明 |
|------|------|
| `WORKLOG_2026-05-20.md` | 后台行前清单 v2 CRUD、清单设置、富文本修复 |
| `supabase/migrations/035–039` | 品牌、酒店种子、管理员 profiles、法务与行程分享、分享域名 |
| 新增模块（未跟踪） | 深链、删号、分享 Web、法务页、Prepare v2、用户中心等 |

### 1.2 主要变更文件（已跟踪）

- **iOS App：** `YOLO/App/*`、`YOLO/Features/*`、`YOLO/Services/*`、`YOLO/Models/*`
- **Admin CMS：** `admin/js/*`、`admin/index.html`
- **Supabase：** `supabase/functions/*`、部分迁移
- **Web：** `web/config.example.js`

### 1.3 重要未跟踪文件（审查时已存在，尚未 `git add`）

```
YOLO/App/DeepLinkHandler.swift
YOLO/Features/Auth/ForgotPasswordView.swift
YOLO/Features/Auth/SetNewPasswordView.swift
YOLO/Features/Legal/LegalDocumentView.swift
YOLO/Features/Legal/LegalDocuments.swift
YOLO/Features/Plan/ItineraryShareCardView.swift
YOLO/Features/Plan/SharedItineraryView.swift
YOLO/Features/Prepare/ChecklistItemDetailView.swift
YOLO/Services/AccountDeletionService.swift
YOLO/Services/AudioNowPlayingService.swift
YOLO/Services/ItineraryShareService.swift
YOLO/Services/PrepChecklistAssembler.swift
YOLO/Services/PrepReminderService.swift
YOLO/Services/TelemetryService.swift
YOLO/Services/TripReminderService.swift
YOLO/Utils/ShareSheet.swift
YOLO/Utils/UserDefaultsKeys.swift
YOLO/YOLO.entitlements
admin/js/users-hub.js
supabase/functions/delete-account/index.ts
supabase/migrations/035_rebrand_yolo_happy.sql
supabase/migrations/036_seed_chengdu_hotels.sql
supabase/migrations/037_admin_profiles_access.sql
supabase/migrations/038_legal_and_itinerary_share.sql
supabase/migrations/039_share_base_workers_dev.sql
web/share.html
WORKLOG_2026-05-20.md
```

---

## 2. 第一层：需求 vs 代码

### 2.1 ✅ 已完整实现

| 需求 | 关键证据 |
|------|----------|
| 行前清单 v2 全字段 CMS + 类型/城市筛选 | `admin/js/schema.js`、`core.js`（`sanitizeChecklistPayload`、`checklistItemMatchesCity`） |
| 清单设置单页编辑 | `admin/js/crud.js` → `renderChecklistSettings`；`admin/js/admin.js` 路由 |
| 富文本弹窗可编辑 | `crud.js` 先 `appendChild` 再 `mountFieldInteractions`（约 614–617 行） |
| 品牌 YOLO HAPPY | `035_rebrand_yolo_happy.sql`、`app_branding.json`、本地化字符串 |
| 隐私/条款（CMS + App 内置回退） | 迁移 `038`；`LegalDocumentView` + `LegalDocuments.resolvedHTML` |
| 分享链接**打开**（App Universal Link + 深链） | `DeepLinkHandler`、`MainTabView`、`SharedItineraryView`、`YOLO.entitlements` |
| Web 只读分享页 | `web/share.html` |
| 忘记密码 / 重置密码 | `ForgotPasswordView`、`SetNewPasswordView`、`AuthSessionStore` |
| 账号删除 | `delete-account` Edge Function、`AccountDeletionService`、`ProfileSheetView` |
| Prepare v2（分组、详情、提醒） | `PrepChecklistAssembler`、`ChecklistItemDetailView`、`PrepReminderService` |
| 后台用户中心 | `users-hub.js` + `037_admin_profiles_access.sql` |
| 行程分享**图片** | `ShareItinerarySheet`、`ItineraryShareImageRenderer` |

### 2.2 ❌ 未实现

| 需求 | 缺少内容 | 相关位置 |
|------|----------|----------|
| **B 级行程 Web 链接分享（创建侧）** | 从未调用 `makeSlug()`，从未将 `is_shared = true` 写入云端；`shareURL` / `shareText` 未接入分享 UI | 仅 `ItineraryShareService.swift` 定义 `makeSlug`；`PlanFlowViews.swift` 的 `ShareItinerarySheet` 只分享图片 |
| 隐私文案中的「分享链接创建」埋点 | 无对应 telemetry 事件 | `LegalDocuments.swift` 内置隐私 HTML |
| 关闭分享 / 撤销公开链接 | 无 UI 将 `is_shared = false` | — |
| 工作日志后续项（可选） | `checklist_completion` 后台统计、清单 App 预览 | `WORKLOG_2026-05-20.md` 第五节 |

### 2.3 ⚠️ 实现偏差

| 需求期望 | 实际行为 | 位置 |
|----------|----------|------|
| 分享含可点击 Web 链接 | 用户只能分享图片；链接只能被他人打开，无法从 App 生成 | `ShareItinerarySheet` |
| 隐私政策描述分享能力 | 文案写「开启分享会生成链接」，App 无法开启 | `LegalDocuments.swift` |
| 品牌统一 YOLO HAPPY | CMS 侧栏仍显示 ChinaGo | `admin/index.html` |
| Web「Open in app」 | CTA 指向同一 Web URL，非 App 深链 | `web/share.html` |

### 2.4 🔍 遗漏的边界条件

- **分享 slug 碰撞：** 10 位 hex，无重试逻辑（当前未创建 slug，风险未暴露）。
- **同步合并：** `mergeItineraries` 同 ID 以 remote 为准，无 `updated_at` 比较，本地未推送编辑可能被覆盖（`ProfileSyncService.swift`）。
- **行程提醒日期：** `TripReminderService` 使用全局 `departureDate`，未使用行程 `payload` 内真实出发日。
- **未登录打开分享链接：** `RootView` 要求先登录，深链分享可能在登录前被挡住。
- **删号失败：** Edge Function 失败时会话仍在，需向用户明确提示。

### 2.5 📌 超出或未明确要求

- `TelemetryService` 仅本地 `os.log` + MetricKit，非远程分析（与隐私文案「analytics events」表述略宽）。
- Profile 中 `simulateProPurchase` 演示开关（内购未上线前的占位）。

---

## 3. 第二层：代码质量

### 3.1 ❌ 逻辑错误 / 高优先级

| 问题 | 位置 | 修改建议 |
|------|------|----------|
| 分享功能半套：读路径完整，写路径缺失 | `ItineraryShareService` vs `ShareItinerarySheet` | 分享时生成 `shareSlug`、`isShared = true`、`shared_at`，upsert 同步；系统分享同时带 URL + 文案 + 图片 |
| 公开 RLS 返回整行 | `038` policy + `ItineraryRepository.fetchByShareSlug` 使用 `.select()` | 为 anon 限制列（如 `title, payload`）或提供专用 view/RPC |
| 合并策略可能丢本地更新 | `ProfileSyncService.mergeItineraries` | 按 `updated_at` 取较新，或增加版本字段 |

### 3.2 ⚠️ 潜在问题

| 问题 | 位置 | 修改建议 |
|------|------|----------|
| 密码最少 6 位 | `SetNewPasswordView.swift` | 与 Supabase 策略对齐，建议 ≥8 位 |
| `scenePhase == .active` 全量刷新 CMS | `RootView.swift` | 加节流（如 5 分钟） |
| `delete-account` CORS `*` | `supabase/functions/delete-account/index.ts` | 生产收紧 Origin；考虑 rate limit |
| 分享需登录才能看 App 内 sheet | `RootView` + `MainTabView` | 未登录也允许只读 `SharedItineraryView` |
| 未使用的 `dismiss` | `ForgotPasswordView.swift` | 删除或成功后自动返回 |

### 3.3 🔒 安全隐患

| 问题 | 严重度 | 建议 |
|------|--------|------|
| 匿名可读 `user_itineraries` 全列（含 `user_id`） | 中 | 限制 SELECT 列；避免用户 ID 可被枚举 |
| Edge Function 仅校验 Bearer | 低（合理） | 保持；可选加强 token 校验 |
| `web/config.js` 含 anon key | 低（公开设计） | 确保 RLS 足够严；禁止 service role |

### 3.4 📖 可读性

- `ProfileSheetView` 中英混用（如「退出登录」与 `String(localized:)` 并存）。
- `ItineraryShareService` 中 `shareText` / `makeSlug` 未被调用，易误导维护者。

### 3.5 ⚡ 性能

- `pushItineraries` 每次保存推送全部行程，行程多时偏慢；可改为增量 upsert。
- `PrepareView` 在多处触发 `reloadContent`，需关注重复网络请求。

---

## 4. 最终裁决

| 级别 | 项 | 说明 |
|------|-----|------|
| **必须修** | Web 链接分享的创建/同步 | 与迁移 038、web 页、深链、隐私文案不一致；非误报 |
| **建议修** | 公开 SELECT 列收敛；`mergeItineraries` 冲突；分享关闭流程；Web CTA 改 Universal Link | 安全与体验 |
| **可暂缓** | CMS 侧栏 ChinaGo 文案；远程 Telemetry；completion 后台统计 | 非阻塞 |
| **可接受** | `delete-account` 依赖 CASCADE | 迁移已正确配置 |
| **文案调整** | Telemetry 仅本地日志 | 宜与隐私政策表述对齐 |

---

## 5. 建议修复顺序

| 优先级 | 任务 |
|--------|------|
| **P0** | 在 `ShareItinerarySheet` 启用 `is_shared` + `share_slug` 并 `pushItinerariesNow()`；分享项包含 URL + 文案 |
| **P1** | `fetchByShareSlug` / 迁移层限制 anon 可见列 |
| **P1** | 提供「停止分享」开关 |
| **P2** | 同步合并按时间戳；行程提醒对齐行程日期 |
| **P2** | 将未跟踪文件纳入 git 并部署迁移 035–039、`delete-account` 等 |

---

## 6. 交付前自测清单

- [ ] CMS：行前清单新建/编辑富文本、类型筛选、清单设置、城市工作台 Tab
- [ ] App：分享行程 → 出现 `https://…/i/{slug}` 且 DB `is_shared = true`
- [ ] 匿名浏览器打开该 URL → `web/share.html` 正常展示
- [ ] 另一设备 Universal Link → `SharedItineraryView`
- [ ] 忘记密码邮件 → `yoloapp://auth/reset-password` → 改密成功
- [ ] Profile 删号 → 无法再登录，云端行程不可见
- [ ] Prepare：entry / universal / city 分组 + 提醒 banner + 详情页外链

---

## 7. 总结

后台行前清单与工作日志描述**高度一致**，富文本修复与 v2 字段 CRUD 实现到位。

**最大缺口：** 迁移 `038` 定义的「行程 Web 公开分享」只完成了**读链路**（数据库字段、RLS、Web 页、App 深链打开），**App 侧从未开启分享**（未写入 `share_slug` / `is_shared`），导致端到端功能不可用。隐私政策与分享 UI 文案已承诺该能力，需优先补齐。

---

## 8. 附录：关键代码引用

### 8.1 分享服务（slug 生成存在但未使用）

```4:12:YOLO/Services/ItineraryShareService.swift
    static func makeSlug() -> String {
        String(UUID().uuidString.replacingOccurrences(of: "-", with: "").prefix(10)).lowercased()
    }

    static func shareURL(slug: String, branding: AppBranding) -> URL? {
        let base = branding.shareWebBaseURL.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        guard !base.isEmpty else { return nil }
        return URL(string: "\(base)/i/\(slug)")
    }
```

### 8.2 分享 UI 仅图片

```744:826:YOLO/Features/Plan/PlanFlowViews.swift
struct ShareItinerarySheet: View {
    // ...
    // 仅生成 shareImage，shareItems 只包含 [image]
    private func shareItems(image: UIImage) -> [Any] {
        [image]
    }
}
```

### 8.3 公开读策略（迁移 038）

```23:30:supabase/migrations/038_legal_and_itinerary_share.sql
DROP POLICY IF EXISTS "Public read shared itineraries" ON user_itineraries;
CREATE POLICY "Public read shared itineraries" ON user_itineraries
  FOR SELECT TO anon, authenticated
  USING (
    is_shared = TRUE
    AND share_slug IS NOT NULL
    AND NOT is_deleted
  );
```

### 8.4 富文本修复（先挂载 DOM）

```614:617:admin/js/crud.js
    document.body.appendChild(backdrop);
    App.mountFieldInteractions(form, meta, mountCtx);
    if (table === "checklist_items") App.mountChecklistTypeVisibility(form, meta);
    App.ensurePendingQuillHosts(backdrop);
```

---

*本报告由代码审查工作流生成，供团队评审与排期使用。*
