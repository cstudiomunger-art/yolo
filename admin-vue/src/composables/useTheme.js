import { ref } from "vue";

const STORAGE_KEY = "yolo.admin.theme";
const order = ["system", "light", "dark"];
const pref = ref(localStorage.getItem(STORAGE_KEY) || "system");

function resolve(p) {
  if (p === "system") {
    return window.matchMedia &&
      window.matchMedia("(prefers-color-scheme: dark)").matches
      ? "dark"
      : "light";
  }
  return p;
}

function apply() {
  document.documentElement.dataset.theme = resolve(pref.value);
}

export function useTheme() {
  function cycle() {
    const idx = order.indexOf(pref.value);
    pref.value = order[(idx + 1) % order.length];
    localStorage.setItem(STORAGE_KEY, pref.value);
    apply();
  }
  apply();
  return { pref, cycle };
}
