-- Insignias Table
CREATE TABLE insignias (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL UNIQUE,
  profession_id uuid REFERENCES professions(id) ON DELETE SET NULL,
  requirements jsonb,
  effects jsonb NOT NULL DEFAULT '{}'::jsonb,
  description text NOT NULL,
  wiki_url text NOT NULL,
  icon text,
  created_at bigint NOT NULL DEFAULT (EXTRACT(EPOCH FROM now())),
  updated_at bigint NOT NULL DEFAULT (EXTRACT(EPOCH FROM now()))
);

-- Indexes for common queries
CREATE INDEX idx_insignias_name ON insignias(name);
CREATE INDEX idx_insignias_profession_id ON insignias(profession_id);

-- Full text search index on name and description
CREATE INDEX idx_insignias_search ON insignias USING gin(to_tsvector('english', name || ' ' || COALESCE(description, '')));

-- Trigger for insignias.updated_at
CREATE TRIGGER trg_update_updated_at_insignias
BEFORE UPDATE ON insignias
FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- Enable Realtime
ALTER PUBLICATION supabase_realtime ADD TABLE insignias;

-- Enable Row Level Security (allow read for all authenticated users)
ALTER TABLE insignias ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view insignias"
  ON insignias FOR SELECT
  TO authenticated
  USING (true);
