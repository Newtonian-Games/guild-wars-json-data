-- Remove UPDATE and DELETE policies for game_instance table
-- Users should only be able to INSERT and SELECT their own game instances
-- Updates will be handled via RPC functions or Edge Functions in the future

DROP POLICY IF EXISTS "Users can update their own game instances" ON game_instance;
DROP POLICY IF EXISTS "Users can delete their own game instances" ON game_instance;

-- Remove UPDATE and DELETE policies for achievements table
-- Users should only be able to INSERT and SELECT their own achievements
-- Updates will be handled via RPC functions or Edge Functions in the future

DROP POLICY IF EXISTS "Users can update their own achievements" ON achievements;
DROP POLICY IF EXISTS "Users can delete their own achievements" ON achievements;
