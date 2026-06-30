-- All attractions & sub-areas: paywalled, unlock via annual subscription only ($9.99/year).
-- Per-attraction price tiers are cleared; no single-purchase SKU per item.

UPDATE attractions
SET
  requires_purchase  = TRUE,
  price_tier_id      = NULL,
  iap_product_id     = NULL,
  text_paywall_free  = FALSE;

UPDATE sub_areas
SET
  requires_purchase = TRUE,
  price_tier_id     = NULL;

-- Verify:
-- SELECT COUNT(*) AS total,
--        COUNT(*) FILTER (WHERE requires_purchase) AS paywalled,
--        COUNT(*) FILTER (WHERE price_tier_id IS NOT NULL) AS with_tier
-- FROM attractions;
