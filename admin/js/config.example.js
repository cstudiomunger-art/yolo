// 复制为 config.js 并填入与 iOS Secrets.xcconfig 相同的 Supabase 项目信息
window.CHINAGO_ADMIN_CONFIG = {
  supabaseUrl: "https://你的项目ID.supabase.co",
  // Dashboard → Settings → API Keys：Publishable key (sb_publishable_…) 或 Legacy anon JWT 均可
  supabaseAnonKey: "你的_publishable_或_anon_key",
};
