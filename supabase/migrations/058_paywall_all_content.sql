-- Put ALL content behind the paywall.
--
-- Background: migration 055 added attractions/sub_areas.requires_purchase with a
-- default of FALSE ("default-free, admins opt items in"). No content was ever opted
-- in, so the per-item gate (PurchaseService.hasContentAccess: `if !requiresPurchase
-- { return true }`) granted free access to everything and the paywall never showed —
-- even though the global use_remote_iap switch was on (migration 053).
--
-- This migration flips every attraction and sub-area to paid and assigns the default
-- price tier (single_t1) wherever one isn't set. Admins can still mark individual
-- items free again in the CMS by setting requires_purchase = FALSE.

UPDATE attractions
SET requires_purchase = TRUE,
    price_tier_id = COALESCE(price_tier_id, 'single_t1');

UPDATE sub_areas
SET requires_purchase = TRUE,
    price_tier_id = COALESCE(price_tier_id, 'single_t1');
