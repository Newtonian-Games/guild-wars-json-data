-- Add sort_order column to games table
ALTER TABLE games
  ADD COLUMN IF NOT EXISTS sort_order integer NOT NULL DEFAULT 999;

-- Create index for sort_order
CREATE INDEX IF NOT EXISTS idx_games_sort_order ON games(sort_order);

-- Update existing games with sort_order values
-- Card Game should be first (sort_order = 1)
UPDATE games SET sort_order = 1 WHERE slug = 'card-game';
-- Skill Guessing Game should be second (sort_order = 2)
UPDATE games SET sort_order = 2 WHERE slug = 'guessing-game';
