-- YOLO HAPPY: IAP transaction log (written by RevenueCat webhook) + refund requests

CREATE TABLE IF NOT EXISTS user_iap_transactions (
  id                       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id                  UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  rc_transaction_id        TEXT UNIQUE NOT NULL,
  apple_transaction_id     TEXT,
  product_id               TEXT NOT NULL,
  event_type               TEXT NOT NULL,
    -- 'INITIAL_PURCHASE' | 'RENEWAL' | 'CANCELLATION' | 'EXPIRATION' | 'REFUND' | 'NON_RENEWING_PURCHASE'
  plan_id                  TEXT REFERENCES membership_plans(id),
  price_usd                NUMERIC(10, 2),
  currency                 TEXT,
  purchased_at             TIMESTAMPTZ NOT NULL,
  expires_at               TIMESTAMPTZ,
  purchased_attraction_id  TEXT,
  raw_payload              JSONB,
  created_at               TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS user_iap_transactions_user_idx ON user_iap_transactions (user_id, created_at DESC);

COMMENT ON TABLE user_iap_transactions IS 'Full IAP event log written by the revenuecat-webhook Edge Function.';
COMMENT ON COLUMN user_iap_transactions.price_usd IS 'Price in USD from RevenueCat webhook — displayed in admin purchase history.';

ALTER TABLE user_iap_transactions ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users read own transactions" ON user_iap_transactions;
CREATE POLICY "Users read own transactions"
  ON user_iap_transactions FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE INDEX IF NOT EXISTS user_iap_transactions_product_id_idx ON user_iap_transactions (product_id);

-- App 内退款申请记录
CREATE TABLE IF NOT EXISTS user_refund_requests (
  id                   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id              UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  rc_transaction_id    TEXT,
  plan_id              TEXT,
  reason               TEXT,
  status               TEXT NOT NULL DEFAULT 'pending',
    -- 'pending' | 'approved' | 'rejected'
  created_at           TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS user_refund_requests_user_id_idx ON user_refund_requests (user_id);
CREATE INDEX IF NOT EXISTS user_refund_requests_status_idx ON user_refund_requests (status);

ALTER TABLE user_refund_requests ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Users manage own refund requests" ON user_refund_requests;
CREATE POLICY "Users manage own refund requests"
  ON user_refund_requests FOR ALL
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);
