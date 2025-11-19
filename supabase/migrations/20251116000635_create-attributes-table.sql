-- Attributes Table
CREATE TABLE attributes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text,
  profession_id uuid REFERENCES professions(id) ON DELETE CASCADE,
  is_primary boolean NOT NULL DEFAULT false,
  inherent_effects jsonb DEFAULT '{}'::jsonb, -- Stores primary attribute effects (e.g., crit chance, UpperCamelCase keys)
  description text,
  wiki_url text,
  created_at bigint NOT NULL DEFAULT (EXTRACT(EPOCH FROM now())),
  updated_at bigint NOT NULL DEFAULT (EXTRACT(EPOCH FROM now())),
  UNIQUE(name, profession_id)
);

-- Indexes for attributes
CREATE INDEX idx_attributes_name ON attributes(name);
CREATE INDEX idx_attributes_profession_id ON attributes(profession_id);
CREATE INDEX idx_attributes_is_primary ON attributes(is_primary);
CREATE INDEX idx_attributes_wiki_url ON attributes(wiki_url);
CREATE INDEX idx_attributes_description ON attributes(description);

-- Trigger for attributes.updated_at
CREATE TRIGGER trg_update_updated_at_attributes
BEFORE UPDATE ON attributes
FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- Enable Realtime
ALTER PUBLICATION supabase_realtime ADD TABLE attributes;

-- Enable Row Level Security (allow read for all users including anonymous)
ALTER TABLE attributes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view attributes"
  ON attributes FOR SELECT
  TO authenticated, anon
  USING (true);
