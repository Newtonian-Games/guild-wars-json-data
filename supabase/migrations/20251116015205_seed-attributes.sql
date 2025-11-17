-- Seed attributes
-- Auto-generated from data/attributes.json
-- Generated: 2025-11-17T08:01:51.586Z
-- Total attributes: 51 (42 profession attributes + 9 rank attributes)

-- Insert profession-specific attributes
INSERT INTO attributes (name, profession_id, is_primary)
VALUES
  ('Critical Strikes', (SELECT id FROM professions WHERE name = 'Assassin'), true),
  ('Dagger Mastery', (SELECT id FROM professions WHERE name = 'Assassin'), false),
  ('Deadly Arts', (SELECT id FROM professions WHERE name = 'Assassin'), false),
  ('Shadow Arts', (SELECT id FROM professions WHERE name = 'Assassin'), false),
  ('Mysticism', (SELECT id FROM professions WHERE name = 'Dervish'), true),
  ('Earth Prayers', (SELECT id FROM professions WHERE name = 'Dervish'), false),
  ('Scythe Mastery', (SELECT id FROM professions WHERE name = 'Dervish'), false),
  ('Wind Prayers', (SELECT id FROM professions WHERE name = 'Dervish'), false),
  ('Energy Storage', (SELECT id FROM professions WHERE name = 'Elementalist'), true),
  ('Air Magic', (SELECT id FROM professions WHERE name = 'Elementalist'), false),
  ('Earth Magic', (SELECT id FROM professions WHERE name = 'Elementalist'), false),
  ('Fire Magic', (SELECT id FROM professions WHERE name = 'Elementalist'), false),
  ('Water Magic', (SELECT id FROM professions WHERE name = 'Elementalist'), false),
  ('Fast Casting', (SELECT id FROM professions WHERE name = 'Mesmer'), true),
  ('Domination Magic', (SELECT id FROM professions WHERE name = 'Mesmer'), false),
  ('Illusion Magic', (SELECT id FROM professions WHERE name = 'Mesmer'), false),
  ('Inspiration Magic', (SELECT id FROM professions WHERE name = 'Mesmer'), false),
  ('Divine Favor', (SELECT id FROM professions WHERE name = 'Monk'), true),
  ('Healing Prayers', (SELECT id FROM professions WHERE name = 'Monk'), false),
  ('Protection Prayers', (SELECT id FROM professions WHERE name = 'Monk'), false),
  ('Smiting Prayers', (SELECT id FROM professions WHERE name = 'Monk'), false),
  ('Soul Reaping', (SELECT id FROM professions WHERE name = 'Necromancer'), true),
  ('Blood Magic', (SELECT id FROM professions WHERE name = 'Necromancer'), false),
  ('Curses', (SELECT id FROM professions WHERE name = 'Necromancer'), false),
  ('Death Magic', (SELECT id FROM professions WHERE name = 'Necromancer'), false),
  ('Leadership', (SELECT id FROM professions WHERE name = 'Paragon'), true),
  ('Command', (SELECT id FROM professions WHERE name = 'Paragon'), false),
  ('Motivation', (SELECT id FROM professions WHERE name = 'Paragon'), false),
  ('Spear Mastery', (SELECT id FROM professions WHERE name = 'Paragon'), false),
  ('Expertise', (SELECT id FROM professions WHERE name = 'Ranger'), true),
  ('Beast Mastery', (SELECT id FROM professions WHERE name = 'Ranger'), false),
  ('Marksmanship', (SELECT id FROM professions WHERE name = 'Ranger'), false),
  ('Wilderness Survival', (SELECT id FROM professions WHERE name = 'Ranger'), false),
  ('Spawning Power', (SELECT id FROM professions WHERE name = 'Ritualist'), true),
  ('Channeling Magic', (SELECT id FROM professions WHERE name = 'Ritualist'), false),
  ('Communing', (SELECT id FROM professions WHERE name = 'Ritualist'), false),
  ('Restoration Magic', (SELECT id FROM professions WHERE name = 'Ritualist'), false),
  ('Strength', (SELECT id FROM professions WHERE name = 'Warrior'), true),
  ('Axe Mastery', (SELECT id FROM professions WHERE name = 'Warrior'), false),
  ('Hammer Mastery', (SELECT id FROM professions WHERE name = 'Warrior'), false),
  ('Swordsmanship', (SELECT id FROM professions WHERE name = 'Warrior'), false),
  ('Tactics', (SELECT id FROM professions WHERE name = 'Warrior'), false)
ON CONFLICT (name, profession_id) DO UPDATE SET
  is_primary = EXCLUDED.is_primary;

-- Insert rank attributes (no profession association)
INSERT INTO attributes (name, profession_id, is_primary)
VALUES
  (NULL, NULL, false),
  ('Lightbringer rank', NULL, false),
  ('Sunspear rank', NULL, false),
  ('Asura rank', NULL, false),
  ('Deldrimor rank', NULL, false),
  ('Ebon Vanguard rank', NULL, false),
  ('Norn rank', NULL, false),
  ('Kurzick rank', NULL, false),
  ('Luxon rank', NULL, false)
ON CONFLICT (name, profession_id) DO NOTHING;
