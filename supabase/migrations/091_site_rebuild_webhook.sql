-- Auto-rebuild the marketing site (Cloudflare Worker「yolo-pc」) when CMS content changes.
-- The site is statically generated (SSG), so DB edits only go live on a rebuild. A
-- statement-level AFTER trigger on the site-driving content tables POSTs to the Cloudflare
-- deploy hook, which kicks off a fresh build (~1-2 min).
--
-- SECURITY: the deploy hook URL can trigger builds for anyone who has it, and THIS REPO IS
-- PUBLIC — so the URL is NOT stored here. It lives in Supabase Vault under the name
-- 'cf_deploy_hook_url'. Store it once (do NOT commit this) in the SQL editor:
--
--   select vault.create_secret(
--     'https://api.cloudflare.com/client/v4/workers/builds/deploy_hooks/XXXXXXXX',
--     'cf_deploy_hook_url');
--
-- Until the secret exists, the trigger is a no-op (safe to apply in any order).

create extension if not exists pg_net;
create extension if not exists supabase_vault;

create or replace function public.notify_site_rebuild()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  hook_url text;
begin
  select decrypted_secret into hook_url
  from vault.decrypted_secrets
  where name = 'cf_deploy_hook_url'
  limit 1;

  if hook_url is null or hook_url = '' then
    return null; -- not configured yet → do nothing
  end if;

  perform net.http_post(
    url := hook_url,
    headers := jsonb_build_object('Content-Type', 'application/json'),
    body := jsonb_build_object('source', 'supabase', 'table', tg_table_name, 'at', now())
  );
  return null;
end;
$$;

-- Statement-level (one POST per edit, not per row) on the tables the website renders from.
do $$
declare
  t text;
  site_tables text[] := array[
    'ticket_attractions',
    'cities', 'attractions', 'sub_areas', 'city_guides', 'culture_tips',
    'visa_policies_v2', 'visa_policy_grants_v2', 'visa_cities', 'visa_city_policy_matrix'
  ];
begin
  foreach t in array site_tables loop
    if to_regclass('public.' || t) is not null then
      execute format('drop trigger if exists trg_site_rebuild on public.%I', t);
      execute format(
        'create trigger trg_site_rebuild after insert or update or delete on public.%I '
        || 'for each statement execute function public.notify_site_rebuild()', t);
    end if;
  end loop;
end $$;
