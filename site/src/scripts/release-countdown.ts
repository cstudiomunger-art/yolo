// Live countdown to the next daily ticket-release moment (Beijing time, UTC+8 — China
// has no DST, so a fixed offset is correct for users in any timezone). Reads schedule
// from the root element's data-* attributes. Imported by ReleaseCountdown.astro so Astro
// emits an external bundle (no inline script → strict-CSP compatible). Display only.

const BEIJING_OFFSET = 8 * 3600_000; // UTC+8

function nextRelease(hh: number, mm: number): number {
  const now = Date.now();
  const b = new Date(now + BEIJING_OFFSET); // UTC getters now read Beijing wall clock
  let target = Date.UTC(b.getUTCFullYear(), b.getUTCMonth(), b.getUTCDate(), hh, mm, 0) - BEIJING_OFFSET;
  if (target <= now) target += 86_400_000;
  return target;
}

function beijingDateLabel(utcMs: number): string {
  const b = new Date(utcMs + BEIJING_OFFSET);
  return b.toLocaleDateString("en-US", { month: "short", day: "numeric", timeZone: "UTC" });
}

function initOne(root: HTMLElement) {
  const rel = root.dataset.release ?? "20:00";
  const [hh, mm] = rel.split(":").map((n) => parseInt(n, 10));
  if (Number.isNaN(hh) || Number.isNaN(mm)) return;
  const advance = parseInt(root.dataset.advance ?? "", 10);

  const dEl = root.querySelector<HTMLElement>(".rc-d");
  const hEl = root.querySelector<HTMLElement>(".rc-h");
  const mEl = root.querySelector<HTMLElement>(".rc-m");
  const sEl = root.querySelector<HTMLElement>(".rc-s");
  const covers = root.querySelector<HTMLElement>(".rc-covers");
  const pad = (n: number) => String(n).padStart(2, "0");
  // Only write when the value actually changed — avoids re-setting unchanged text every
  // second, which made browser auto-translate re-translate the node and flicker.
  const setText = (el: HTMLElement | null, val: string) => {
    if (el && el.textContent !== val) el.textContent = val;
  };

  function tick() {
    const target = nextRelease(hh, mm);
    let diff = Math.max(0, target - Date.now());
    const d = Math.floor(diff / 86_400_000); diff -= d * 86_400_000;
    const h = Math.floor(diff / 3_600_000); diff -= h * 3_600_000;
    const m = Math.floor(diff / 60_000); diff -= m * 60_000;
    const s = Math.floor(diff / 1000);
    setText(dEl, String(d));
    setText(hEl, pad(h));
    setText(mEl, pad(m));
    setText(sEl, pad(s));
    if (covers && !Number.isNaN(advance)) {
      const travelDate = beijingDateLabel(target + advance * 86_400_000);
      setText(covers, `This release opens tickets dated around ${travelDate}. Be ready and book the moment it opens.`);
    }
  }
  tick();
  setInterval(tick, 1000);
}

function init() {
  document.querySelectorAll<HTMLElement>(".rc").forEach(initOne);
}

if (document.readyState === "loading") document.addEventListener("DOMContentLoaded", init);
else init();
