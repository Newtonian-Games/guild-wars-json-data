-- Restore UPDATE policy for game_instance table
-- This is needed for the guessing game to persist game state updates
-- Users can update their own game instances

CREATE POLICY "Users can update their own game instances"
  ON game_instance FOR UPDATE
  TO authenticated
  USING (auth.uid() = player_id)
  WITH CHECK (auth.uid() = player_id);
