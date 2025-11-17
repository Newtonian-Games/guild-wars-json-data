-- Professions Table
CREATE TABLE professions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL UNIQUE,
  abbreviation text NOT NULL UNIQUE,
  icon text NOT NULL,
  armor_bonuses jsonb DEFAULT '{}'::jsonb, -- Stores all possible armor bonuses (UpperCamelCase keys)
  created_at bigint NOT NULL DEFAULT (EXTRACT(EPOCH FROM now())),
  updated_at bigint NOT NULL DEFAULT (EXTRACT(EPOCH FROM now()))
);

-- Attributes Table
CREATE TABLE attributes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text,
  profession_id uuid REFERENCES professions(id) ON DELETE CASCADE,
  is_primary boolean NOT NULL DEFAULT false,
  inherent_effects jsonb DEFAULT '{}'::jsonb, -- Stores primary attribute effects (e.g., crit chance, UpperCamelCase keys)
  created_at bigint NOT NULL DEFAULT (EXTRACT(EPOCH FROM now())),
  updated_at bigint NOT NULL DEFAULT (EXTRACT(EPOCH FROM now())),
  UNIQUE(name, profession_id)
);

-- Indexes for professions
CREATE INDEX idx_professions_name ON professions(name);

-- Indexes for attributes
CREATE INDEX idx_attributes_name ON attributes(name);
CREATE INDEX idx_attributes_profession_id ON attributes(profession_id);
CREATE INDEX idx_attributes_is_primary ON attributes(is_primary);

-- Trigger for professions.updated_at
CREATE TRIGGER trg_update_updated_at_professions
BEFORE UPDATE ON professions
FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- Trigger for attributes.updated_at
CREATE TRIGGER trg_update_updated_at_attributes
BEFORE UPDATE ON attributes
FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- Enable Realtime
ALTER PUBLICATION supabase_realtime ADD TABLE professions;
ALTER PUBLICATION supabase_realtime ADD TABLE attributes;

-- Enable Row Level Security (allow read for all authenticated users)
ALTER TABLE professions ENABLE ROW LEVEL SECURITY;
ALTER TABLE attributes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view professions"
  ON professions FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Anyone can view attributes"
  ON attributes FOR SELECT
  TO authenticated
  USING (true);
