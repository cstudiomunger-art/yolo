(function (global) {
  function parseAuthParams() {
    const hash = (location.hash || "").replace(/^#/, "");
    const search = (location.search || "").replace(/^\?/, "");
    const raw = [hash, search].filter(Boolean).join("&");
    const params = new URLSearchParams(raw);
    const out = {};
    params.forEach(function (v, k) {
      out[k] = v;
    });
    return out;
  }

  function appDeepLink(appScheme, params) {
    const qs = new URLSearchParams(params).toString();
    return appScheme + (qs ? "#" + qs : "");
  }

  function appDeepLinkFromLocation(appScheme) {
    const search = location.search || "";
    const hash = location.hash || "";
    if (hash) {
      return appScheme + hash;
    }
    if (search) {
      return appScheme + search;
    }
    return appScheme;
  }

  function decodeJwtEmail(token) {
    try {
      const payload = token.split(".")[1];
      if (!payload) return null;
      const json = JSON.parse(atob(payload.replace(/-/g, "+").replace(/_/g, "/")));
      return json.email || null;
    } catch (_) {
      return null;
    }
  }

  function hasAuthError(params) {
    return Boolean(params.error || params.error_code);
  }

  function hasAuthPayload(params) {
    return Boolean(
      params.access_token ||
      params.code ||
      params.type === "signup" ||
      params.type === "email" ||
      params.type === "recovery"
    );
  }

  global.YOLOAuthCallback = {
    parseAuthParams: parseAuthParams,
    appDeepLink: appDeepLink,
    appDeepLinkFromLocation: appDeepLinkFromLocation,
    decodeJwtEmail: decodeJwtEmail,
    hasAuthError: hasAuthError,
    hasAuthPayload: hasAuthPayload,
  };
})(window);
