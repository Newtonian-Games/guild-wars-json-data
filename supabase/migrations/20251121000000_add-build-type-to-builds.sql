-- Add build type columns to builds table
-- is_human: true for human players, false for heroes and mercenaries
-- hero_id: references heroes table when build is for a specific hero

ALTER TABLE builds
  ADD COLUMN IF NOT EXISTS is_human boolean NOT NULL DEFAULT true,
  ADD COLUMN IF NOT EXISTS hero_id uuid REFERENCES heroes(id) ON DELETE SET NULL;

-- Create index for hero_id lookups
CREATE INDEX IF NOT EXISTS idx_builds_hero_id ON builds(hero_id);

-- Create index for is_human queries
CREATE INDEX IF NOT EXISTS idx_builds_is_human ON builds(is_human);

-- Update existing builds to be human by default (they already are via DEFAULT, but explicit is better)
UPDATE builds SET is_human = true WHERE is_human IS NULL;
