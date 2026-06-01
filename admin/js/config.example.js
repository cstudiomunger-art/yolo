// 复制为 config.js 并填入与 iOS Secrets.xcconfig 相同的 Supabase 项目信息。
// CI / Cloudflare 构建未设置环境变量时，与 web/config.example.js 使用同一套默认值。
window.CHINAGO_ADMIN_CONFIG = {
  supabaseUrl: "https://edwvrriuwzaaqznklrgi.supabase.co",
  supabaseAnonKey: "sb_publishable_b4CZMaImh7KsCVx_uufaGw_h3-HEZPZ",
};
