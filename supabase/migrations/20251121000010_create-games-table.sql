-- Games Table
CREATE TABLE games (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL UNIQUE,
  description text,
  created_at bigint NOT NULL DEFAULT (EXTRACT(EPOCH FROM now())),
  updated_at bigint NOT NULL DEFAULT (EXTRACT(EPOCH FROM now()))
);

-- Indexes for games
CREATE INDEX idx_games_name ON games(name);

-- Trigger for games.updated_at
CREATE TRIGGER trg_update_updated_at_games
BEFORE UPDATE ON games
FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- Enable Realtime
ALTER PUBLICATION supabase_realtime ADD TABLE games;

-- Enable Row Level Security (allow read for all users including anonymous)
ALTER TABLE games ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view games"
  ON games FOR SELECT
  TO authenticated, anon
  USING (true);
