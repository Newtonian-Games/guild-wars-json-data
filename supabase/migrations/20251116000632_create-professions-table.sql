-- Professions Table
CREATE TABLE professions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL UNIQUE,
  abbreviation text NOT NULL UNIQUE,
  icon text NOT NULL,
  armor_bonuses jsonb DEFAULT '{}'::jsonb, -- Stores all possible armor bonuses (UpperCamelCase keys)
  wiki_url text,
  created_at bigint NOT NULL DEFAULT (EXTRACT(EPOCH FROM now())),
  updated_at bigint NOT NULL DEFAULT (EXTRACT(EPOCH FROM now()))
);

-- Indexes for professions
CREATE INDEX idx_professions_name ON professions(name);
CREATE INDEX idx_professions_wiki_url ON professions(wiki_url);

-- Trigger for professions.updated_at
CREATE TRIGGER trg_update_updated_at_professions
BEFORE UPDATE ON professions
FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- Enable Realtime
ALTER PUBLICATION supabase_realtime ADD TABLE professions;

-- Enable Row Level Security (allow read for all users including anonymous)
ALTER TABLE professions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view professions"
  ON professions FOR SELECT
  TO authenticated, anon
  USING (true);
