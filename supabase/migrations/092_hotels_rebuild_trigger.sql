-- Add the hotels table to the site auto-rebuild trigger (see 091). The website now
-- renders a filterable hotel directory from this table, so CMS edits should trigger a
-- rebuild like the other content tables.

do $$
begin
  if to_regclass('public.hotels') is not null then
    drop trigger if exists trg_site_rebuild on public.hotels;
    create trigger trg_site_rebuild after insert or update or delete on public.hotels
      for each statement execute function public.notify_site_rebuild();
  end if;
end $$;
