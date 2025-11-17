-- Seed releases
-- Auto-generated from data/releases.json
-- Generated: 2025-11-17T08:55:35.742Z
-- Total releases: 8

INSERT INTO releases (name, order_index, description)
VALUES
  ('Core', 0, 'Core skills available across all campaigns'),
  ('Prophecies', 1, 'Guild Wars Prophecies campaign'),
  ('Factions', 2, 'Guild Wars Factions campaign'),
  ('Nightfall', 3, 'Guild Wars Nightfall campaign'),
  ('Eye of the North', 4, 'Guild Wars: Eye of the North expansion'),
  ('Bonus Mission Pack', 5, 'Bonus Mission Pack DLC'),
  ('Hearts of the North', 6, 'Hearts of the North quest pack'),
  ('Winds of Change', 7, 'Winds of Change quest series')
ON CONFLICT (name) DO UPDATE SET
  order_index = EXCLUDED.order_index,
  description = EXCLUDED.description;
