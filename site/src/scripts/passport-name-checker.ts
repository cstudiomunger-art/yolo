// Generic passport-name format checker (client island). User input is only ever read
// and echoed via textContent — never interpolated into innerHTML — so there is no XSS
// surface. Imported by PassportNameChecker.astro so Astro emits an external bundle
// (keeps the page free of inline scripts → compatible with a strict CSP).

interface Verdict {
  tone: "ok" | "warn" | "bad";
  title: string;
  notes: string[];
}

function checkName(): Verdict {
  const el = document.getElementById("pnc-input") as HTMLInputElement | null;
  const raw = el?.value ?? "";
  const name = raw.trim();
  const notes: string[] = [];

  if (!name) return { tone: "warn", title: "Type your name to check it.", notes: [] };
  if (/[㐀-鿿぀-ヿ가-힯]/.test(name))
    return {
      tone: "bad",
      title: "Use the Latin spelling from your passport — not Chinese/Japanese/Korean characters.",
      notes: ["Real-name ticketing matches the Latin (pinyin/romanized) name in your passport's data page."],
    };
  if (/\d/.test(name))
    return { tone: "bad", title: "A passport name shouldn't contain digits.", notes: ["Remove any numbers."] };

  if (/[^A-Za-z .,'\-]/.test(name))
    notes.push("Contains unusual characters — keep to letters, spaces, hyphens and apostrophes as in your passport.");
  if (/\s{2,}/.test(raw) || raw !== name)
    notes.push("Extra or leading/trailing spaces can cause a mismatch — use single spaces.");
  if (!name.includes(" "))
    notes.push("Only one word entered — most passports have a surname and given name(s); enter both.");
  if (name.length < 2) notes.push("That looks too short to match a passport name.");

  const bad = notes.length > 0;
  return {
    tone: bad ? "warn" : "ok",
    title: bad ? "Close — double-check the points below" : "Looks valid for real-name booking",
    notes: [
      ...notes,
      "Enter the surname and given names in the same order the booking form asks for (China often lists surname first).",
      "It must be identical to your passport — staff check the physical passport against your ticket at the gate.",
    ],
  };
}

function render() {
  const out = document.getElementById("pnc-result");
  if (!out) return;
  const r = checkName();
  out.textContent = "";
  out.className = `pnc-result tone-${r.tone}`;
  const h = document.createElement("p");
  h.className = "pnc-title";
  h.textContent = r.title; // textContent → no HTML injection
  out.appendChild(h);
  if (r.notes.length) {
    const ul = document.createElement("ul");
    for (const n of r.notes) {
      const li = document.createElement("li");
      li.textContent = n;
      ul.appendChild(li);
    }
    out.appendChild(ul);
  }
}

function init() {
  document.getElementById("pnc-check")?.addEventListener("click", render);
  document.getElementById("pnc-input")?.addEventListener("keydown", (e) => {
    if ((e as KeyboardEvent).key === "Enter") render();
  });
}

if (document.readyState === "loading") document.addEventListener("DOMContentLoaded", init);
else init();
