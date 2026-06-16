-- Agent avatar: public column on support_agents so the App can show the agent's
-- real photo. Synced from the agent's own profile when they sign into the web
-- console (RLS lets an agent update their own row), or set in the admin CMS.

ALTER TABLE support_agents ADD COLUMN IF NOT EXISTS avatar_url TEXT NOT NULL DEFAULT '';
