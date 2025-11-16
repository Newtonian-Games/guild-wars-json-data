-- Skills Table
CREATE TABLE skills (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  icon text,
  description text,
  type text NOT NULL,
  profession text,
  attribute_name text,
  attribute_progression jsonb DEFAULT '{}'::jsonb,
  energy_cost integer,
  adrenaline_cost integer,
  upkeep_cost integer,
  sacrifice_cost integer,
  overcast_cost integer,
  activation_time numeric,
  recharge_time text,
  is_elite boolean NOT NULL DEFAULT false,
  campaign text,
  limitation text,
  wiki_url text,
  created_at bigint NOT NULL DEFAULT (EXTRACT(EPOCH FROM now())),
  updated_at bigint NOT NULL DEFAULT (EXTRACT(EPOCH FROM now()))
);

-- Unique constraint on name (required for ON CONFLICT in seed migrations)
CREATE UNIQUE INDEX idx_skills_name_unique ON skills(name);

-- Indexes for common queries
CREATE INDEX idx_skills_profession ON skills(profession);
CREATE INDEX idx_skills_type ON skills(type);
CREATE INDEX idx_skills_attribute_name ON skills(attribute_name);
CREATE INDEX idx_skills_is_elite ON skills(is_elite);
CREATE INDEX idx_skills_campaign ON skills(campaign);

-- Full text search index on name and description
CREATE INDEX idx_skills_search ON skills USING gin(to_tsvector('english', name || ' ' || COALESCE(description, '')));

-- Trigger for skills.updated_at
CREATE TRIGGER trg_update_updated_at_skills
BEFORE UPDATE ON skills
FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- Enable Realtime
ALTER PUBLICATION supabase_realtime ADD TABLE skills;

-- Enable Row Level Security (allow read for all authenticated users)
ALTER TABLE skills ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view skills"
  ON skills FOR SELECT
  TO authenticated
  USING (true);
