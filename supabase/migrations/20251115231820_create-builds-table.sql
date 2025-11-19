-- Builds Table (individual character builds, can be standalone or part of a team)
CREATE TABLE builds (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  team_build_id uuid REFERENCES team_builds(id) ON DELETE CASCADE,
  author_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  position integer,
  name text NOT NULL,
  primary_profession uuid REFERENCES professions(id),
  secondary_profession uuid REFERENCES professions(id),
  skills jsonb,
  attributes jsonb,
  weapons jsonb,
  armor jsonb,
  notes text,
  created_at bigint NOT NULL DEFAULT (EXTRACT(EPOCH FROM now())),
  updated_at bigint NOT NULL DEFAULT (EXTRACT(EPOCH FROM now()))
);

-- Trigger for builds.updated_at
CREATE TRIGGER trg_update_updated_at
BEFORE UPDATE ON builds
FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- Indexes for builds
CREATE INDEX idx_builds_team_build_id ON builds(team_build_id);
CREATE INDEX idx_builds_author_id ON builds(author_id);
CREATE INDEX idx_builds_created_at ON builds(created_at DESC);
CREATE INDEX idx_builds_position ON builds(team_build_id, position);

-- Enable Realtime
ALTER PUBLICATION supabase_realtime ADD TABLE builds;

-- Enable Row Level Security
ALTER TABLE builds ENABLE ROW LEVEL SECURITY;

-- RLS Policies for builds
CREATE POLICY "Users can view all builds"
  ON builds FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Users can insert their own builds"
  ON builds FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = author_id);

CREATE POLICY "Users can update their own builds"
  ON builds FOR UPDATE
  TO authenticated
  USING (auth.uid() = author_id)
  WITH CHECK (auth.uid() = author_id);

CREATE POLICY "Users can delete their own builds"
  ON builds FOR DELETE
  TO authenticated
  USING (auth.uid() = author_id);
