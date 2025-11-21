-- Game Instance Table
CREATE TABLE game_instance (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  player_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  game_id uuid NOT NULL REFERENCES games(id) ON DELETE CASCADE,
  game_state jsonb DEFAULT '{}'::jsonb,
  game_result jsonb DEFAULT '{}'::jsonb,
  completed_at bigint,
  created_at bigint NOT NULL DEFAULT (EXTRACT(EPOCH FROM now())),
  updated_at bigint NOT NULL DEFAULT (EXTRACT(EPOCH FROM now()))
);

-- Indexes for game_instance
CREATE INDEX idx_game_instance_player_id ON game_instance(player_id);
CREATE INDEX idx_game_instance_game_id ON game_instance(game_id);
CREATE INDEX idx_game_instance_completed_at ON game_instance(completed_at);
CREATE INDEX idx_game_instance_created_at ON game_instance(created_at DESC);

-- Trigger for game_instance.updated_at
CREATE TRIGGER trg_update_updated_at_game_instance
BEFORE UPDATE ON game_instance
FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- Enable Realtime
ALTER PUBLICATION supabase_realtime ADD TABLE game_instance;

-- Enable Row Level Security
ALTER TABLE game_instance ENABLE ROW LEVEL SECURITY;

-- RLS Policies for game_instance
CREATE POLICY "Users can view their own game instances"
  ON game_instance FOR SELECT
  TO authenticated
  USING (auth.uid() = player_id);

CREATE POLICY "Users can insert their own game instances"
  ON game_instance FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = player_id);

CREATE POLICY "Users can update their own game instances"
  ON game_instance FOR UPDATE
  TO authenticated
  USING (auth.uid() = player_id)
  WITH CHECK (auth.uid() = player_id);

CREATE POLICY "Users can delete their own game instances"
  ON game_instance FOR DELETE
  TO authenticated
  USING (auth.uid() = player_id);
