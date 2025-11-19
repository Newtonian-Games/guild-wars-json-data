-- Team Builds Table
CREATE TABLE team_builds (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  author_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  name text NOT NULL,
  description text,
  notes text,
  created_at bigint NOT NULL DEFAULT (EXTRACT(EPOCH FROM now())),
  updated_at bigint NOT NULL DEFAULT (EXTRACT(EPOCH FROM now()))
);

-- Trigger for team_builds.updated_at
CREATE TRIGGER trg_update_updated_at
BEFORE UPDATE ON team_builds
FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- Indexes for team_builds
CREATE INDEX idx_team_builds_author_id ON team_builds(author_id);
CREATE INDEX idx_team_builds_created_at ON team_builds(created_at DESC);
CREATE INDEX idx_team_builds_author_created ON team_builds(author_id, created_at DESC);

-- Enable Realtime
ALTER PUBLICATION supabase_realtime ADD TABLE team_builds;

-- Enable Row Level Security
ALTER TABLE team_builds ENABLE ROW LEVEL SECURITY;

-- RLS Policies for team_builds
CREATE POLICY "Users can view all team builds"
  ON team_builds FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Users can insert their own team builds"
  ON team_builds FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = author_id);

CREATE POLICY "Users can update their own team builds"
  ON team_builds FOR UPDATE
  TO authenticated
  USING (auth.uid() = author_id)
  WITH CHECK (auth.uid() = author_id);

CREATE POLICY "Users can delete their own team builds"
  ON team_builds FOR DELETE
  TO authenticated
  USING (auth.uid() = author_id);
