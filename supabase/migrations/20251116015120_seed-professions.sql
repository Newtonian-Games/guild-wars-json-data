-- Seed professions
-- Auto-generated from data/professions.json
-- Generated: 2025-11-16T05:29:24.228Z
-- Total professions: 10

INSERT INTO professions (name, abbreviation, icon)
VALUES
  ('Assassin', 'A', 'https://wiki.guildwars.com/images/thumb/3/34/Assassin-tango-icon-200.png/180px-Assassin-tango-icon-200.png'),
  ('Dervish', 'D', 'https://wiki.guildwars.com/images/thumb/b/bf/Dervish-tango-icon-200.png/180px-Dervish-tango-icon-200.png'),
  ('Elementalist', 'E', 'https://wiki.guildwars.com/images/thumb/3/3c/Elementalist-tango-icon-200.png/180px-Elementalist-tango-icon-200.png'),
  ('Mesmer', 'Me', 'https://wiki.guildwars.com/images/thumb/c/cc/Mesmer-tango-icon-200.png/180px-Mesmer-tango-icon-200.png'),
  ('Monk', 'Mo', 'https://wiki.guildwars.com/images/thumb/8/86/Monk-tango-icon-200.png/180px-Monk-tango-icon-200.png'),
  ('Necromancer', 'N', 'https://wiki.guildwars.com/images/thumb/a/a8/Necromancer-tango-icon-200.png/180px-Necromancer-tango-icon-200.png'),
  ('Paragon', 'P', 'https://wiki.guildwars.com/images/thumb/2/21/Paragon-tango-icon-200.png/180px-Paragon-tango-icon-200.png'),
  ('Ranger', 'R', 'https://wiki.guildwars.com/images/thumb/4/43/Ranger-tango-icon-200.png/180px-Ranger-tango-icon-200.png'),
  ('Ritualist', 'Rt', 'https://wiki.guildwars.com/images/thumb/1/15/Ritualist-tango-icon-200.png/180px-Ritualist-tango-icon-200.png'),
  ('Warrior', 'W', 'https://wiki.guildwars.com/images/thumb/8/88/Warrior-tango-icon-200.png/180px-Warrior-tango-icon-200.png')
ON CONFLICT (name) DO UPDATE SET
  abbreviation = EXCLUDED.abbreviation,
  icon = EXCLUDED.icon;
