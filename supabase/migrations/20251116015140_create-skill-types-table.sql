-- Skill Types Table
CREATE TABLE skill_types (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL UNIQUE,
  parents jsonb NOT NULL DEFAULT '[]'::jsonb,
  description text,
  created_at bigint NOT NULL DEFAULT (EXTRACT(EPOCH FROM now())),
  updated_at bigint NOT NULL DEFAULT (EXTRACT(EPOCH FROM now()))
);

-- Indexes
CREATE INDEX idx_skill_types_name ON skill_types(name);

-- Full text search index
CREATE INDEX idx_skill_types_search ON skill_types USING gin(to_tsvector('english', name || ' ' || COALESCE(description, '')));

-- Trigger for skill_types.updated_at
CREATE TRIGGER trg_update_updated_at_skill_types
BEFORE UPDATE ON skill_types
FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- Enable Realtime
ALTER PUBLICATION supabase_realtime ADD TABLE skill_types;

-- Enable Row Level Security (allow read for all authenticated users)
ALTER TABLE skill_types ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view skill_types"
  ON skill_types FOR SELECT
  TO authenticated
  USING (true);
