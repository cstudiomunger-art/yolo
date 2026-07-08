-- Prevent support agents from modifying admin-only columns on their own row.
-- Agents may still update profile fields (name, role, languages, social_url,
-- avatar_url, avatar_seed, status) via the web console; admins retain full control.

CREATE OR REPLACE FUNCTION public.guard_support_agent_self_update()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
  IF public.is_admin() THEN RETURN NEW; END IF;
  IF OLD.user_id IS DISTINCT FROM auth.uid() THEN RETURN NEW; END IF;
  NEW.user_id := OLD.user_id;
  NEW.is_active := OLD.is_active;
  NEW.display_order := OLD.display_order;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS support_agents_self_update_guard ON support_agents;
CREATE TRIGGER support_agents_self_update_guard
  BEFORE UPDATE ON support_agents
  FOR EACH ROW EXECUTE FUNCTION public.guard_support_agent_self_update();
