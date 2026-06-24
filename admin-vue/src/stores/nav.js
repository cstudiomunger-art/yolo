import { defineStore } from "pinia";
import { ref } from "vue";

/**
 * Drives the main work area from sidebar tree clicks.
 * selection kinds:
 *   { kind:'table',  tableKey, fixedCityId? }      filtered list
 *   { kind:'record', tableKey, id }                edit existing row
 *   { kind:'new',    tableKey, presets? }          create row
 *   { kind:'placeholder', label }                  not-yet-built hub
 */
export const useNav = defineStore("nav", () => {
  const selection = ref({ kind: "placeholder", label: "← 从左侧选择内容" });

  function select(sel) {
    selection.value = sel;
  }

  return { selection, select };
});
