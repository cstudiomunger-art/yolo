export type ParityInputV1 = {
  trip: {
    start_date_local: string;
    trip_days: number;
    entry_city_id?: string | null;
    exit_city_id?: string | null;
  };
  cities: Array<{
    id: string;
    region?: string | null;
    visit_order_hint?: number | null;
  }>;
  attractions: Array<{
    id: string;
    city_id: string;
    priority?: string | null;
    display_order?: number | null;
    planning_zone?: string | null;
    duration_slots?: number | null;
    closed_weekdays?: string[] | null;
    open_time?: string | null;
    close_time?: string | null;
    last_entry_time?: string | null;
  }>;
  constraints?: {
    max_attractions_per_day?: number;
    allow_silent_drop?: boolean;
  };
};

export type ParityDropReason = "closed_day" | "capacity" | "invalid_slot";

export type ParityOutputV1 = {
  days: Array<{
    day_index: number;
    date_local: string;
    city_id: string;
    day_kind: string;
  }>;
  assignments: Array<{
    attraction_id: string;
    day_index: number;
    time_slot: string;
  }>;
  dropped: Array<{
    attraction_id: string;
    reason: ParityDropReason;
  }>;
};
