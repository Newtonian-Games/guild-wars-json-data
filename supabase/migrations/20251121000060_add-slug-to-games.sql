-- Add slug column to games table
ALTER TABLE games
  ADD COLUMN IF NOT EXISTS slug text UNIQUE;

-- Create index for slug lookups
CREATE INDEX IF NOT EXISTS idx_games_slug ON games(slug);

-- Update existing games with their slugs
UPDATE games SET slug = 'guessing-game' WHERE name = 'Skill Guessing Game';
UPDATE games SET slug = 'card-game' WHERE name = 'GW Card Game';
