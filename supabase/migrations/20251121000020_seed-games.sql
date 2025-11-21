-- Seed games
-- Generated: 2025-11-21T00:00:20.000Z
-- Total games: 2

INSERT INTO games (name, description, slug, sort_order)
VALUES
  (
    'Skill Guessing Game',
    'Test your GW knowledge',
    'guessing-game',
    1
  ),
  (
    'GW Card Game',
    'Planned out and working on it!',
    'card-game',
    2
  )
ON CONFLICT (name) DO UPDATE SET
  description = EXCLUDED.description,
  slug = EXCLUDED.slug,
  sort_order = EXCLUDED.sort_order;
