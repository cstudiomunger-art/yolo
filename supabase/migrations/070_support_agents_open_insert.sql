-- Relax INSERT on support_agents: adding an agent no longer requires the
-- operator to be in admin_users. Any authenticated user can now insert a row.
-- (Trade-off: any signed-in account — including app users — could insert into
-- this table if they call the API directly. SELECT/UPDATE/DELETE rules are
-- unchanged: public read of active agents, agent edits own row, admin deletes.)

DROP POLICY IF EXISTS "Admin writes support_agents" ON support_agents;
CREATE POLICY "Authenticated inserts support_agents" ON support_agents
  FOR INSERT TO authenticated WITH CHECK (TRUE);
