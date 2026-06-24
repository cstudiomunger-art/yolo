<script setup>
import { computed } from "vue";
import { useRefCache } from "@/stores/refCache";
import MultiCheck from "@/components/fields/MultiCheck.vue";

/** Editor for payment_advice_rules.match_json:
 *  { country?: string[], cards_exclude?: string[], trip?: 'city'|'both'|'remote' } */
const props = defineProps({ modelValue: { type: Object, default: () => ({}) } });
const emit = defineEmits(["update:modelValue"]);

const refCache = useRefCache();
const v = computed(() => props.modelValue && typeof props.modelValue === "object" ? props.modelValue : {});

const countryOptions = computed(() =>
  refCache.countries.map((c) => ({ value: c.code, label: `${c.flag || ""} ${c.name}`.trim() }))
);
const CARD_OPTIONS = [
  { value: "visa", label: "Visa" },
  { value: "mc", label: "Mastercard" },
  { value: "jcb", label: "JCB" },
  { value: "unionpay", label: "银联 UnionPay" },
  { value: "amex", label: "Amex" },
];

const country = computed({
  get: () => v.value.country || [],
  set: (val) => emit("update:modelValue", { ...v.value, country: val }),
});
const cards = computed({
  get: () => v.value.cards_exclude || [],
  set: (val) => emit("update:modelValue", { ...v.value, cards_exclude: val }),
});
const trip = computed({
  get: () => v.value.trip || "",
  set: (val) => emit("update:modelValue", { ...v.value, trip: val || undefined }),
});
</script>

<template>
  <div class="pm">
    <div class="block">
      <div class="lbl">国家 country（不选 = 对所有国家显示）</div>
      <MultiCheck v-model="country" :options="countryOptions" />
    </div>
    <div class="block">
      <div class="lbl">用户「没有」这些卡时才显示 cards_exclude（不选 = 不限）</div>
      <MultiCheck v-model="cards" :options="CARD_OPTIONS" />
    </div>
    <div class="block">
      <div class="lbl">行程类型 trip（不选 = 不限）</div>
      <select v-model="trip">
        <option value="">不限</option>
        <option value="city">大城市为主</option>
        <option value="both">城市 + 乡村</option>
        <option value="remote">主要偏远</option>
      </select>
    </div>
  </div>
</template>

<style scoped>
.pm {
  border: 1px solid var(--border);
  border-radius: var(--radius);
  padding: 12px;
}
.block {
  margin-bottom: 14px;
}
.lbl {
  font-size: 12px;
  color: var(--muted);
  margin-bottom: 6px;
}
</style>
