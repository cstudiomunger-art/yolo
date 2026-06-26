// Client-side filtering for the hotel directory. All hotel cards are server-rendered
// (SEO-readable); this only shows/hides them. External module → CSP-safe.

function init() {
  const root = document.getElementById("hotel-finder");
  if (!root) return;

  const city = document.getElementById("hf-city") as HTMLSelectElement | null;
  const foreigners = document.getElementById("hf-foreigners") as HTMLInputElement | null;
  const english = document.getElementById("hf-english") as HTMLInputElement | null;
  const stars = document.getElementById("hf-stars") as HTMLSelectElement | null;
  const price = document.getElementById("hf-price") as HTMLSelectElement | null;
  const countEl = document.getElementById("hf-count");
  const emptyEl = document.getElementById("hf-empty");

  const cards = Array.from(root.querySelectorAll<HTMLElement>(".hotel-card"));
  const groups = Array.from(root.querySelectorAll<HTMLElement>(".hotel-city-group"));

  function apply() {
    const fCity = city?.value || "";
    const fForeign = foreigners?.checked ?? false;
    const fEnglish = english?.checked ?? false;
    const fStars = parseInt(stars?.value || "0", 10) || 0;
    const fPrice = parseInt(price?.value || "0", 10) || 0; // max USD; 0 = any

    let visible = 0;
    for (const c of cards) {
      const ds = c.dataset;
      const ok =
        (!fCity || ds.city === fCity) &&
        (!fForeign || ds.foreigners === "1") &&
        (!fEnglish || ds.english === "1") &&
        (!fStars || Number(ds.stars) >= fStars) &&
        (!fPrice || (Number(ds.price) > 0 && Number(ds.price) <= fPrice));
      c.hidden = !ok;
      if (ok) visible++;
    }

    // Hide city groups that have no visible cards.
    for (const g of groups) {
      const any = g.querySelector(".hotel-card:not([hidden])");
      g.hidden = !any;
    }

    if (countEl) countEl.textContent = String(visible);
    if (emptyEl) emptyEl.hidden = visible !== 0;
  }

  [city, stars, price].forEach((el) => el?.addEventListener("change", apply));
  [foreigners, english].forEach((el) => el?.addEventListener("change", apply));
  apply();
}

if (document.readyState === "loading") document.addEventListener("DOMContentLoaded", init);
else init();
