-- Professions Table
CREATE TABLE professions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL UNIQUE,
  abbreviation text NOT NULL UNIQUE,
  icon text NOT NULL,
  created_at bigint NOT NULL DEFAULT (EXTRACT(EPOCH FROM now())),
  updated_at bigint NOT NULL DEFAULT (EXTRACT(EPOCH FROM now()))
);

-- Attributes Table
CREATE TABLE attributes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text,
  profession_id uuid REFERENCES professions(id) ON DELETE CASCADE,
  is_primary boolean NOT NULL DEFAULT false,
  created_at bigint NOT NULL DEFAULT (EXTRACT(EPOCH FROM now())),
  updated_at bigint NOT NULL DEFAULT (EXTRACT(EPOCH FROM now())),
  UNIQUE(name, profession_id)
);

-- Indexes
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

-- Note: Seeding data has been moved to seed files
-- Run: npm run seed (from supabase directory)
-- Or: npx supabase db seed

-- Enable Realtime
ALTER PUBLICATION supabase_realtime ADD TABLE professions;
ALTER PUBLICATION supabase_realtime ADD TABLE attributes;
