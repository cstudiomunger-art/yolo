# RevenueCat × Apple 内购 接入操作文档

> 适用项目：YOLO（Bundle ID `com.chengduyuliu.yolohappy`）
> 撰写日期：2026-06-12
> 状态：操作指南（后台配置 + 代码替换），尚未执行

---

## 0. 先弄清两个概念

| 概念 | 是什么 | 本项目是否使用 |
|---|---|---|
| **App 内购买（IAP）** | 订阅、解锁数字内容，走 Apple 的 StoreKit 支付面板，Apple 抽成 15%~30% | ✅ 会员订阅 + 单景点解锁必须走这条路（App Store 审核强制） |
| **Apple Pay** | 实体商品/线下服务付款（PassKit 框架） | ❌ RevenueCat 不支持，本项目也用不到 |

RevenueCat 的作用：替我们做 **收据校验、订阅状态机（续订/退款/宽限期）、跨平台账号绑定、数据看板**，客户端只需调它的 SDK，不用自己搭收据校验服务器。

### 本项目现状（代码侧已就绪，无需大改）

工程在前期开发时已为 RevenueCat 预留了全部接入点：

| 接入点 | 位置 | 现状 |
|---|---|---|
| API Key 槽位 | `Secrets.xcconfig` → `REVENUECAT_API_KEY` | 已有占位，填真实 key 即可 |
| Key 读取 | `YOLO/AppConfig.swift` → `revenueCatApiKey` / `isRevenueCatConfigured` | 已实现 |
| 购买服务 | `YOLO/Services/PurchaseService.swift` | 模拟模式运行中，5 处 `MARK: RevenueCat hook` 标注了替换点 |
| 数据模型 | `MembershipPlan.rcPackageId` / `.appleProductId` | 字段已预留，Supabase `membership_plans` 表同步维护 |
| UI 层 | `Features/Purchase/`（MembershipCenterView 等） | 全部面向 PurchaseService 接口编写，**零改动** |

所以整个接入 = **后台配置（第 1~2 章） + SDK 引入（第 3 章） + 替换 5 个方法体（第 4 章） + 测试（第 5 章）**。

---

## 1. App Store Connect 配置

登录 [appstoreconnect.apple.com](https://appstoreconnect.apple.com)。

### 1.1 签署付费应用协议（最容易漏、最常见的「产品拉不到」原因）

1. 首页 → **协议、税务和银行业务**（Agreements, Tax, and Banking）。
2. 找到 **Paid Apps / 付费 App** 协议 → 查看并同意。
3. 补全 **银行账户**（收款账户）和 **税务表格**（中国大陆开发者填 W-8BEN 等向导会引导）。
4. 状态必须变为 **Active / 有效**。⚠️ 协议未生效时，客户端 `offerings` 会一直为空。

### 1.2 创建订阅产品（3 个）

路径：**我的 App → YOLO → 订阅（Subscriptions）**

1. 先创建一个 **订阅群组**（Subscription Group），命名 `YOLO Membership`。三个档位放同一群组内（用户在档位间是升降级关系，不是叠加购买）。
2. 在群组内逐个创建，Product ID 必须与代码/数据库已预留的完全一致：

| 产品 | Product ID（不可改，提交后永久占用） | 时长 | 定价 | 试用 |
|---|---|---|---|---|
| 年度会员 | `com.yolohappy.sub.annual` | 1 年 | $19.99 | 7 天免费试用 |
| 季度会员 | `com.yolohappy.sub.quarterly` | 3 个月 | $7.99 | 无 |
| 月度会员 | `com.yolohappy.sub.monthly` | 1 个月 | $3.99 | 无 |

3. 每个产品需要：
   - **订阅时长**：选对应周期。
   - **价格**：点「添加定价」，选基准国家（美国 $19.99 等），其他地区让 Apple 自动换算即可。
   - **App Store 本地化**：至少填一种语言的显示名称和描述（英文即可，例：`Annual Membership` / `Unlimited audio guides, full content & AI itinerary planning`）。
   - **审核截图**：可后补，但提交审核前必须有（付费墙界面截图即可）。
4. 年度会员的 7 天试用：产品页 → **订阅价格 → 推介促销优惠（Introductory Offers）** → 类型选「免费试用」→ 时长 7 天。
5. 全部填完后状态应为 **「准备提交」（Ready to Submit）**。

### 1.3 创建单景点解锁产品（1 个）

路径：**我的 App → YOLO → App 内购买项目（In-App Purchases）**

| 产品 | Product ID | 类型 |
|---|---|---|
| 单景点解锁 | `com.yolohappy.attraction.single` | **消耗型（Consumable）** ⚠️ |

⚠️ **类型必须选消耗型，不能选非消耗型**，原因：
- 我们用 **同一个 $2.99 产品** 给所有景点共用，用户会对不同景点重复购买。
- 非消耗型每个 Apple ID 只能买一次，第二个景点就买不了了。
- 消耗型可重复购买；「哪些景点已解锁」由我们自己记录——现有代码已经是这么做的（`preferences.purchasedAttractionIds` + Supabase profile 同步），无需新增逻辑。
- 代价：消耗型不参与 Apple 的「恢复购买」，恢复靠登录账号后从 Supabase 拉取（`restorePurchases()` 现有实现已覆盖）。

同样填好价格（$2.99）和本地化信息。

### 1.4 生成 In-App Purchase Key（给 RevenueCat 用）

1. **用户和访问（Users and Access）→ 集成（Integrations）→ App 内购买（In-App Purchase）**。
2. 点 **生成 API 密钥**，名称填 `RevenueCat`。
3. 下载 `.p8` 文件（**只能下载一次**，保管好），记下页面上的 **Key ID** 和 **Issuer ID**。

### 1.5 配置 App Store Server Notifications V2（强烈建议）

让退款、续订失败、宽限期等事件实时推给 RevenueCat（否则状态更新有延迟）：

1. 先完成第 2 章，在 RevenueCat 后台 **Project → Apps → YOLO (App Store) → App Store Server Notifications** 处复制专属 URL。
2. 回到 App Store Connect → **我的 App → YOLO → App 信息 → App Store 服务器通知**：
   - **生产服务器 URL** 和 **沙盒服务器 URL** 都填这个地址，版本选 **Version 2**。

---

## 2. RevenueCat 后台配置

登录 [app.revenuecat.com](https://app.revenuecat.com)（没有账号先注册，免费档月追踪收入 $2,500 以内不收费，足够起步）。

### 2.1 创建 Project 和 App

1. **Create Project**，名称 `YOLO`。
2. Project 内 **Add App** → 平台选 **App Store**：
   - App name：`YOLO iOS`
   - Bundle ID：`com.chengduyuliu.yolohappy`
   - **In-App Purchase Key**：上传 1.4 下载的 `.p8`，填 Key ID 和 Issuer ID。
   - （App Specific Shared Secret 是旧式校验，配了 IAP Key 可不填。）

### 2.2 导入 Products

**Product catalog → Products → + New**，逐个添加，Identifier 与 App Store Connect 完全一致：

```
com.yolohappy.sub.annual
com.yolohappy.sub.quarterly
com.yolohappy.sub.monthly
com.yolohappy.attraction.single
```

### 2.3 创建 Entitlement（权益）

**Product catalog → Entitlements → + New**：

- Identifier：`pro`
- 把三个 **订阅** 产品 attach 到 `pro` 上。
- ⚠️ `com.yolohappy.attraction.single` **不要** attach（消耗型不产生持久权益，解锁记录走 Supabase）。

说明：本项目三个档位的权益范围不同（月度只含音频导览，年/季含全部），「具体解锁什么」由 Supabase `membership_plans.access_flags` 按 planId 决定；RC 的 `pro` entitlement 只回答「订阅是否在有效期内」。这正好匹配现有代码：`isProActive` × `currentAccessFlags` 双重判断。

### 2.4 创建 Offering 和 Packages

**Product catalog → Offerings**，默认有一个 `default`，在其中创建 packages：

| Package identifier | 挂载产品 | 对应数据库 `rc_package_id` |
|---|---|---|
| `$rc_annual`（内置 Annual 类型） | `com.yolohappy.sub.annual` | `$rc_annual` ✅ 已预留 |
| `$rc_three_month`（内置 Three Month 类型） | `com.yolohappy.sub.quarterly` | `$rc_three_month` ✅ 已预留 |
| `$rc_monthly`（内置 Monthly 类型） | `com.yolohappy.sub.monthly` | `$rc_monthly` ✅ 已预留 |
| `attraction_single`（Custom 类型） | `com.yolohappy.attraction.single` | `$rc_attraction_single` ⚠️ 见下 |

⚠️ 自定义 package 的 identifier 没有 `$rc_` 前缀（那是内置类型专用）。两种处理任选其一：
- **方案 A（推荐）**：RC 后台自定义 package 就叫 `attraction_single`，同时把 Supabase `membership_plans` 表及 `PurchaseService.bundledFallbackPlans` 里的 `$rc_attraction_single` 改成 `attraction_single`。
- 方案 B：代码匹配 package 时做一次前缀兼容映射（不推荐，留坑）。

### 2.5 获取 Public API Key

**Project settings → API Keys** → 复制 **Public app-specific API key**（`appl_` 开头）。

这是公开 key（只能发起购买/读自己的状态，无法读后台数据），可进客户端；按本项目惯例放 `Secrets.xcconfig`，不进 git。

---

## 3. Xcode 工程配置

### 3.1 添加 SPM 依赖

1. Xcode 打开 `YOLO.xcodeproj` → **File → Add Package Dependencies…**
2. 输入 `https://github.com/RevenueCat/purchases-ios`
3. Dependency Rule：**Up to Next Major Version**（当前主版本 5.x）
4. 勾选库 **RevenueCat**，加到 YOLO target。（`RevenueCatUI` 是 RC 的远程付费墙组件，本项目已有自己的 MembershipCenterView，不需要。）

### 3.2 添加 Capability

Target `YOLO` → **Signing & Capabilities → + Capability → In-App Purchase**。
（会同步更新 `YOLO.entitlements`；首次真机跑沙盒购买需要这个。）

### 3.3 填入 API Key

编辑本地 `Secrets.xcconfig`（已在 .gitignore，不会提交）：

```
REVENUECAT_API_KEY = appl_你的真实Key
```

`AppConfig.revenueCatApiKey` / `isRevenueCatConfigured` 已经会读这个值，无需改代码。

---

## 4. 代码替换（5 个钩子 + 1 处初始化）

> 原则：`PurchaseService` 对外接口零变化，UI 层不动。所有替换点在文件内搜 `MARK: RevenueCat hook`。

### 4.1 初始化（`YOLO/YOLOApp.swift` 的 `init()`）

越早越好（RC 要在任何购买/状态查询前 configure）：

```swift
import RevenueCat

init() {
    UserDefaultsKeys.migrateLegacyKeysIfNeeded()
    OfflineCacheLocations.bootstrap()
    _ = TelemetryService.shared

    if let key = AppConfig.revenueCatApiKey {
        #if DEBUG
        Purchases.logLevel = .debug
        #endif
        Purchases.configure(with: .builder(withAPIKey: key).build())
    }
}
```

不传 `appUserID` → 先以匿名身份运行（游客模式可直接买单景点），登录后再 `logIn` 绑定（见 4.5）。

### 4.2 状态落地的公共方法（新增到 PurchaseService）

RC 的 customerInfo 是订阅状态唯一真相源，统一经此方法写回现有的 preferences 体系（UI 全部读 preferences，保持不变）：

```swift
import RevenueCat

private func applyCustomerInfo(_ info: CustomerInfo) async {
    guard let prefs = preferences else { return }
    if let pro = info.entitlements["pro"], pro.isActive {
        // 由当前生效的 Apple 产品反查 plan，决定 access flags 档位
        let plan = availablePlans.first { $0.appleProductId == pro.productIdentifier }
        prefs.subscriptionPlanId = plan?.id ?? prefs.subscriptionPlanId
        prefs.subscriptionExpiresAt = pro.expirationDate
    } else {
        prefs.subscriptionPlanId = nil
        prefs.subscriptionExpiresAt = nil
    }
    await profileSync?.schedulePush()
}

/// 由 rcPackageId 在当前 offering 中定位 package
private func rcPackage(for plan: MembershipPlan) async throws -> Package {
    let offerings = try await Purchases.shared.offerings()
    guard let package = offerings.current?.availablePackages
        .first(where: { $0.identifier == plan.rcPackageId }) else {
        throw PurchaseError.packageNotFound(plan.rcPackageId)
    }
    return package
}
```

（`PurchaseError` 自定义个简单 enum 即可；`lastError` 沿用现有展示链路。）

### 4.3 订阅购买（替换 `purchase(plan:)` 钩子块）

```swift
do {
    let package = try await rcPackage(for: plan)
    let result = try await Purchases.shared.purchase(package: package)
    guard !result.userCancelled else { return }
    await applyCustomerInfo(result.customerInfo)
} catch ErrorCode.purchaseCancelledError {
    return                      // 用户取消不算错误
} catch {
    lastError = error.localizedDescription
    TelemetryService.recordError(error)   // 按项目现有遥测习惯
}
```

### 4.4 单景点购买（替换 `purchaseSingleAttraction` 钩子块）

```swift
do {
    let package = try await rcPackage(for: plan)
    let result = try await Purchases.shared.purchase(package: package)
    guard !result.userCancelled else { return }
    // 消耗型产品：解锁记录由我们自己维护（现有逻辑原样保留）
    preferences?.purchaseAttraction(attractionId)
    await profileSync?.schedulePush()
} catch ErrorCode.purchaseCancelledError {
    return
} catch {
    lastError = error.localizedDescription
}
```

### 4.5 登录/登出（替换 `login(userId:)` / `logout()` 钩子块）

调用点已存在（Supabase 登录/登出流程会调这两个方法），补方法体即可：

```swift
func login(userId: UUID) async {
    guard AppConfig.isRevenueCatConfigured else { return }
    do {
        let (info, _) = try await Purchases.shared.logIn(userId.uuidString)
        await applyCustomerInfo(info)
    } catch { TelemetryService.recordError(error) }
}

func logout() async {
    guard AppConfig.isRevenueCatConfigured else { return }
    _ = try? await Purchases.shared.logOut()
}
```

用 Supabase user UUID 作 RC app user ID → 换设备登录同一账号，订阅状态自动跟随。

### 4.6 恢复购买（替换 `restorePurchases()` 钩子块）

```swift
func restorePurchases() async throws {
    if AppConfig.isRevenueCatConfigured {
        let info = try await Purchases.shared.restorePurchases()
        await applyCustomerInfo(info)
    }
    // 单景点解锁（消耗型，Apple 不恢复）继续从 Supabase profile 拉
    guard let auth, auth.isAuthenticated else { return }
    await profileSync?.syncAfterSignIn()
}
```

### 4.7 退款（替换 `beginRefundRequest` 钩子块）

```swift
do {
    _ = try await Purchases.shared.beginRefundRequest(forEntitlement: "pro")
} catch {
    // 兜底：跳 App Store 订阅管理（现有实现保留为 fallback）
    if let url = URL(string: "itms-apps://apps.apple.com/account/subscriptions") {
        await UIApplication.shared.open(url)
    }
}
```

### 4.8 保留模拟模式（建议）

每个替换点外面包一层开关，未配 key 时回落到现行模拟逻辑，开发期不依赖网络/沙盒：

```swift
guard AppConfig.isRevenueCatConfigured else {
    // …原模拟代码…
    return
}
```

---

## 5. 测试

### 5.1 本地 StoreKit Configuration（最快，模拟器可用）

1. Xcode → **File → New → File → StoreKit Configuration File**，命名 `YOLO.storekit`（不勾 Sync with App Store Connect 也行，手动录入 4 个产品 ID、价格、订阅周期、年度档 7 天试用）。
2. **Product → Scheme → Edit Scheme → Run → Options → StoreKit Configuration** 选中该文件。
3. 模拟器即可弹出完整购买面板，可在 Xcode 的 **Debug → StoreKit → Manage Transactions** 里模拟退款、续订失败。
4. ⚠️ 局限：本地 StoreKit 的凭证 RevenueCat **无法校验**，RC 后台看不到交易、entitlement 不生效。只用于调 UI 流程；验证 RC 链路必须走沙盒。

### 5.2 沙盒测试（真实链路）

1. App Store Connect → **用户和访问 → 沙盒（Sandbox）→ 测试员** → 创建沙盒账号（用没注册过 Apple ID 的邮箱，如 `yolo.sandbox1@gmail.com`）。
2. 真机：**设置 → App Store → 沙盒账户** 登录该账号（不要登录到正式 iCloud！）。
3. Xcode scheme 里把 StoreKit Configuration 改回 **None**，真机运行 Debug 构建。
4. 走一遍购买 → 弹出的是带 `[Environment: Sandbox]` 水印的支付面板。
5. **验证 RC 收到**：RevenueCat 后台 → **Customers** → 应出现该用户（ID 为 Supabase UUID 或匿名 ID），Entitlement `pro` 为 Active。
6. 沙盒订阅时间加速：1 年 → 1 小时，1 个月 → 5 分钟，方便测续订/过期。

### 5.3 验收清单

- [ ] 未登录（游客）买单景点 → 拦截弹登录（现有逻辑）→ 登录后购买成功，景点解锁
- [ ] 购买年度会员 → 7 天试用弹窗正确 → `pro` 生效 → 音频/文字/贴士全解锁
- [ ] 购买月度会员 → 仅音频解锁（access flags 档位正确）
- [ ] 同一景点产品在第二个景点上可再次购买（消耗型验证）
- [ ] 删 App 重装 → 登录 → 恢复购买：订阅回来（RC）+ 已购景点回来（Supabase）
- [ ] 换一台真机登录同一账号 → 订阅状态自动跟随
- [ ] 沙盒里取消订阅 → 到期后 `isProActive` 翻 false，内容重新上锁
- [ ] 断网启动 → 缓存的订阅状态仍可用（RC SDK 本地缓存 + preferences 持久化双保险）

---

## 6. 提交审核注意事项

1. **首次带 IAP 的版本**：提交 App 版本时，在版本页面底部把 4 个内购产品一起勾选送审（产品不会单独过审）。
2. **恢复购买按钮**必须可见（审核 3.1.1 要求）——MembershipCenterView 已有，确认入口没被藏太深。
3. **订阅说明文案**（审核 3.1.2）：付费墙上需明示订阅时长、价格、自动续订条款，并附「服务条款」「隐私政策」链接（项目已有 LegalDocumentView，可直接挂）。
4. **隐私标签**：App Store Connect → App 隐私 → 勾选「购买记录」（与用户身份关联，用于 App 功能）。
5. RevenueCat 属于第三方 SDK，记得在隐私政策中提及购买数据经 RevenueCat 处理。

---

## 7. 常见问题排查

| 症状 | 最可能原因 |
|---|---|
| `offerings` 为空 / products 拉不到 | ① 付费协议没签或未生效（最常见）② Product ID 不一致 ③ 产品本地化信息没填全，状态没到「准备提交」④ 新建产品要等几小时才能在沙盒可见 |
| 购买报 `receipt is not valid` | RC 后台的 IAP Key（.p8）没传或 Issuer ID/Key ID 填错 |
| RC Customers 里看不到测试用户 | 跑的是本地 StoreKit Configuration（RC 收不到），切回沙盒 |
| 模拟器弹不出支付面板 | 模拟器只支持 StoreKit Configuration 模式；沙盒购买必须真机 |
| 订阅状态不同步/退款不生效 | App Store Server Notifications V2 没配（1.5 节） |
| `logIn` 后权益丢失 | 匿名期购买未触发 transfer——RC 默认 `.transferIfNoSubscribers`，检查 Project settings → Restore behavior |

---

## 8. 上线前总检查清单

- [ ] Paid Apps 协议 Active，银行/税务齐全
- [ ] 4 个产品「准备提交」，Product ID 与 `membership_plans` 表逐字一致
- [ ] 单景点产品类型 = **消耗型**
- [ ] 年度档 7 天试用已配置
- [ ] RC：.p8 已传、4 产品已建、`pro` entitlement 挂 3 订阅、`default` offering 4 packages
- [ ] `rc_package_id` 命名对齐（处理 `$rc_attraction_single` → `attraction_single`，含 Supabase 表 + bundledFallbackPlans）
- [ ] Server Notifications V2 双 URL 已填
- [ ] `Secrets.xcconfig` 填入 `appl_` key（**不进 git**）
- [ ] In-App Purchase capability 已加
- [ ] 5 个 hook 替换完成，`xcodebuild build` 通过
- [ ] 沙盒全链路验收清单（5.3）通过
- [ ] 版本送审时勾选 4 个内购产品
