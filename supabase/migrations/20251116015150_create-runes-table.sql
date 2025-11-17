-- Runes Table
CREATE TABLE runes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL UNIQUE,
  type text NOT NULL CHECK (type IN ('armor', 'inventory')),
  rarity text NOT NULL CHECK (rarity IN ('common', 'uncommon', 'rare')),
  profession_id uuid REFERENCES professions(id) ON DELETE SET NULL,
  attribute_id uuid REFERENCES attributes(id) ON DELETE SET NULL,
  icon text,
  effects jsonb NOT NULL DEFAULT '{}'::jsonb,
  description text NOT NULL,
  wiki_url text NOT NULL,
  created_at bigint NOT NULL DEFAULT (EXTRACT(EPOCH FROM now())),
  updated_at bigint NOT NULL DEFAULT (EXTRACT(EPOCH FROM now()))
);

-- Indexes for common queries
CREATE INDEX idx_runes_name ON runes(name);
CREATE INDEX idx_runes_type ON runes(type);
CREATE INDEX idx_runes_rarity ON runes(rarity);
CREATE INDEX idx_runes_profession_id ON runes(profession_id);
CREATE INDEX idx_runes_attribute_id ON runes(attribute_id);
CREATE INDEX idx_runes_type_profession ON runes(type, profession_id);

-- Full text search index on name and description
CREATE INDEX idx_runes_search ON runes USING gin(to_tsvector('english', name || ' ' || COALESCE(description, '')));

-- Trigger for runes.updated_at
CREATE TRIGGER trg_update_updated_at_runes
BEFORE UPDATE ON runes
FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- Enable Realtime
ALTER PUBLICATION supabase_realtime ADD TABLE runes;

-- Enable Row Level Security (allow read for all authenticated users)
ALTER TABLE runes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view runes"
  ON runes FOR SELECT
  TO authenticated
  USING (true);
