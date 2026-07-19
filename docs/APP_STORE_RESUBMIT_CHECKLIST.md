# App Store 重提清单（3.1.1 + 3.1.2(c) + Offer Codes）

代码侧整改完成后，按本清单完成 **人工运营 / ASC / 录屏** 步骤。

## A. App Store Connect 元数据（必做）

1. **隐私政策 URL**（App 信息 → 隐私政策）  
   `https://yolo.cstudiomunger.workers.dev/privacy`  
   （需先部署含 `web/privacy` 的 Worker；浏览器确认可打开）

2. **EULA**（二选一）  
   - 推荐：在 App **描述**末尾加入：  
     `Terms of Use (EULA): https://www.apple.com/legal/internet-services/itunes/dev/stdeula/`  
   - 或：ASC 上传自定义 License Agreement（可链到 `https://yolo.cstudiomunger.workers.dev/terms`）

3. **审核备注**示例：  
   - Paywall: open any attraction → Unlock → plan card shows name, 1 year / billed annually, price  
   - Footer: Restore, Redeem Offer Code, Privacy Policy, Terms of Use (EULA)  
   - Privacy URL: `https://yolo.cstudiomunger.workers.dev/privacy`  
   - EULA: Apple Standard EULA link in description  
   - Sandbox Apple ID: （填你们的沙盒账号）

## B. Offer Codes（ASC + RevenueCat）

1. RevenueCat → App Store app → 确认已上传 **In-App Purchase Key (.p8)**  
2. ASC → Subscriptions → `com.yolohappy.sub.annual` → Create **Offer Codes**  
   - 建议：Free 1 month（或按运营定）· New subscribers · 优惠结束后续标准年费  
3. 生成 **Sandbox Codes** 做真机自测（正式 one-time 码需 **Ready for Sale**）  
4. App 内：登录 → 付费墙 **Redeem Offer Code** → 系统兑换页  

## C. 重提与回复

1. 使用本仓库 **build ≥ 10** 重新 Archive 上传  
2. 录屏：付费墙展示名称 / 1 year / 价格 → 点 Privacy / Terms → 展示 Redeem Offer Code / Restore  
3. Resolution Center 英文回复（可复制）：

```
We have addressed the issues as follows:

3.1.1: Removed all in-app invite-code redemption (UI, deep links, and server redeem for end users). Promotional access is now provided only via App Store Offer Codes using StoreKit’s code redemption sheet (presentCodeRedemptionSheet), or via App Store subscription purchase.

3.1.2(c): Updated App Store metadata with a working Privacy Policy URL and Terms of Use (EULA) link. The in-app paywall now shows subscription name, duration (1 year / billed annually), price, auto-renewal disclosure, and tappable Privacy Policy and Terms links, plus Restore Purchases.

Please see the attached screen recording of the paywall.
```

4. 选中新 build → 提交审核  

## D. 上架后

- 再生成正式 one-time / custom Offer Codes 对外分发  
- 个别补会员仍用 CMS **用户管理 → 开通会员**
