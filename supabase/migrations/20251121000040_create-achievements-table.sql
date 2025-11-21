-- Achievements Table
CREATE TABLE achievements (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  player_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  game_id uuid NOT NULL REFERENCES games(id) ON DELETE CASCADE,
  name text NOT NULL,
  description text,
  icon text,
  progress jsonb DEFAULT '{}'::jsonb,
  is_maxed boolean NOT NULL DEFAULT false,
  achieved_at bigint,
  created_at bigint NOT NULL DEFAULT (EXTRACT(EPOCH FROM now())),
  updated_at bigint NOT NULL DEFAULT (EXTRACT(EPOCH FROM now()))
);

-- Indexes for achievements
CREATE INDEX idx_achievements_player_id ON achievements(player_id);
CREATE INDEX idx_achievements_game_id ON achievements(game_id);
CREATE INDEX idx_achievements_is_maxed ON achievements(is_maxed);
CREATE INDEX idx_achievements_achieved_at ON achievements(achieved_at);
CREATE INDEX idx_achievements_player_game ON achievements(player_id, game_id);

-- Trigger for achievements.updated_at
CREATE TRIGGER trg_update_updated_at_achievements
BEFORE UPDATE ON achievements
FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- Enable Realtime
ALTER PUBLICATION supabase_realtime ADD TABLE achievements;

-- Enable Row Level Security
ALTER TABLE achievements ENABLE ROW LEVEL SECURITY;

-- RLS Policies for achievements
CREATE POLICY "Users can view their own achievements"
  ON achievements FOR SELECT
  TO authenticated
  USING (auth.uid() = player_id);

CREATE POLICY "Users can insert their own achievements"
  ON achievements FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = player_id);

CREATE POLICY "Users can update their own achievements"
  ON achievements FOR UPDATE
  TO authenticated
  USING (auth.uid() = player_id)
  WITH CHECK (auth.uid() = player_id);

CREATE POLICY "Users can delete their own achievements"
  ON achievements FOR DELETE
  TO authenticated
  USING (auth.uid() = player_id);
