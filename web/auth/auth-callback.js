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
      params.refresh_token ||
      params.code ||
      params.token_hash ||
      params.type === "signup" ||
      params.type === "email" ||
      params.type === "recovery"
    );
  }

  function hasRecoveryPayload(params) {
    if (hasAuthError(params)) return false;
    return Boolean(
      params.token_hash ||
      params.code ||
      params.access_token ||
      params.type === "recovery"
    );
  }

  function authLandingPath(params) {
    const type = (params.type || "").toLowerCase();
    if (hasAuthError(params)) {
      return type === "recovery" ? "/auth/reset-password" : "/auth/confirm";
    }
    if (type === "recovery") return "/auth/reset-password";
    if (type === "signup" || type === "email" || type === "magiclink") {
      return "/auth/confirm";
    }
    if (params.token_hash) {
      return type === "recovery" ? "/auth/reset-password" : "/auth/confirm";
    }
    if (params.code) return "/auth/reset-password";
    if (params.access_token) {
      return type === "signup" || type === "email"
        ? "/auth/confirm"
        : "/auth/reset-password";
    }
    return null;
  }

  function maybeRedirectAuthLanding() {
    const params = parseAuthParams();
    const target = authLandingPath(params);
    if (!target) return false;

    const current = (location.pathname || "/").replace(/\/$/, "") || "/";
    const desired = target.replace(/\/$/, "") || "/";
    if (current === desired) return false;

    location.replace(target + location.search + location.hash);
    return true;
  }

  global.YOLOAuthCallback = {
    parseAuthParams: parseAuthParams,
    appDeepLink: appDeepLink,
    appDeepLinkFromLocation: appDeepLinkFromLocation,
    decodeJwtEmail: decodeJwtEmail,
    hasAuthError: hasAuthError,
    hasAuthPayload: hasAuthPayload,
    hasRecoveryPayload: hasRecoveryPayload,
    authLandingPath: authLandingPath,
    maybeRedirectAuthLanding: maybeRedirectAuthLanding,
  };
})(window);
