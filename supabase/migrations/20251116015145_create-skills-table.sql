-- Skills Table
CREATE TABLE skills (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  icon text,
  is_high_res_icon boolean NOT NULL DEFAULT false,
  description text,
  skill_type_id uuid REFERENCES skill_types(id) ON DELETE SET NULL,
  profession_id uuid REFERENCES professions(id) ON DELETE SET NULL,
  attribute_id uuid REFERENCES attributes(id) ON DELETE SET NULL,
  attribute_progression jsonb DEFAULT '{}'::jsonb,
  energy_cost integer,
  adrenaline_cost integer,
  upkeep_cost integer,
  sacrifice_cost integer,
  overcast_cost integer,
  activation_time numeric,
  recharge_time text,
  is_elite boolean NOT NULL DEFAULT false,
  release_id uuid REFERENCES releases(id) ON DELETE SET NULL,
  limitation text,
  wiki_url text,
  created_at bigint NOT NULL DEFAULT (EXTRACT(EPOCH FROM now())),
  updated_at bigint NOT NULL DEFAULT (EXTRACT(EPOCH FROM now()))
);

-- Unique constraint on name (required for ON CONFLICT in seed migrations)
CREATE UNIQUE INDEX idx_skills_name_unique ON skills(name);

-- Indexes for common queries
CREATE INDEX idx_skills_profession_id ON skills(profession_id);
CREATE INDEX idx_skills_skill_type_id ON skills(skill_type_id);
CREATE INDEX idx_skills_attribute_id ON skills(attribute_id);
CREATE INDEX idx_skills_is_elite ON skills(is_elite);
CREATE INDEX idx_skills_release_id ON skills(release_id);
CREATE INDEX idx_skills_profession_attribute ON skills(profession_id, attribute_id);
CREATE INDEX idx_skills_profession_elite ON skills(profession_id, is_elite);

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
  TO authenticated, anon
  USING (true);
