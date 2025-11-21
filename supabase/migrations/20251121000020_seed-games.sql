-- Seed games
-- Generated: 2025-11-21T00:00:20.000Z
-- Total games: 2

INSERT INTO games (name, description)
VALUES
  (
    'Skill Guessing Game',
    'Test your GW knowledge'
  ),
  (
    'GW Card Game',
    'Planned out and working on it!'
  )
ON CONFLICT (name) DO UPDATE SET
  description = EXCLUDED.description;
