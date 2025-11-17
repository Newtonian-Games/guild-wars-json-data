-- Seed professions
-- Auto-generated from data/professions.json
-- Generated: 2025-11-17T08:55:35.739Z
-- Total professions: 10

INSERT INTO professions (name, abbreviation, icon, wiki_url, armor_bonuses)
VALUES
  ('Assassin', 'A', 'https://wiki.guildwars.com/images/thumb/3/34/Assassin-tango-icon-200.png/180px-Assassin-tango-icon-200.png', 'https://wiki.guildwars.com/wiki/Assassin', '{"BaseArmor":"70","ExtraEnergy":"5","ExtraEnergyRecovery":"2"}'::jsonb),
  ('Dervish', 'D', 'https://wiki.guildwars.com/images/thumb/b/bf/Dervish-tango-icon-200.png/180px-Dervish-tango-icon-200.png', 'https://wiki.guildwars.com/wiki/Dervish', '{"BaseArmor":"70","ExtraEnergy":"5","ExtraHealth":"25","ExtraEnergyRecovery":"2"}'::jsonb),
  ('Elementalist', 'E', 'https://wiki.guildwars.com/images/thumb/3/3c/Elementalist-tango-icon-200.png/180px-Elementalist-tango-icon-200.png', 'https://wiki.guildwars.com/wiki/Elementalist', '{"BaseArmor":"60","ExtraEnergy":"10","ExtraEnergyRecovery":"2"}'::jsonb),
  ('Mesmer', 'Me', 'https://wiki.guildwars.com/images/thumb/c/cc/Mesmer-tango-icon-200.png/180px-Mesmer-tango-icon-200.png', 'https://wiki.guildwars.com/wiki/Mesmer', '{"BaseArmor":"60","ExtraEnergy":"10","ExtraEnergyRecovery":"2"}'::jsonb),
  ('Monk', 'Mo', 'https://wiki.guildwars.com/images/thumb/8/86/Monk-tango-icon-200.png/180px-Monk-tango-icon-200.png', 'https://wiki.guildwars.com/wiki/Monk', '{"BaseArmor":"60","ExtraEnergy":"10","ExtraEnergyRecovery":"2"}'::jsonb),
  ('Necromancer', 'N', 'https://wiki.guildwars.com/images/thumb/a/a8/Necromancer-tango-icon-200.png/180px-Necromancer-tango-icon-200.png', 'https://wiki.guildwars.com/wiki/Necromancer', '{"BaseArmor":"60","ExtraEnergy":"10","ExtraEnergyRecovery":"2"}'::jsonb),
  ('Paragon', 'P', 'https://wiki.guildwars.com/images/thumb/2/21/Paragon-tango-icon-200.png/180px-Paragon-tango-icon-200.png', 'https://wiki.guildwars.com/wiki/Paragon', '{"BaseArmor":"80","ExtraEnergy":"10"}'::jsonb),
  ('Ranger', 'R', 'https://wiki.guildwars.com/images/thumb/4/43/Ranger-tango-icon-200.png/180px-Ranger-tango-icon-200.png', 'https://wiki.guildwars.com/wiki/Ranger', '{"BaseArmor":"70","ElementalArmor":"+30 armor vs. elemental damage","ExtraEnergyRecovery":"1"}'::jsonb),
  ('Ritualist', 'Rt', 'https://wiki.guildwars.com/images/thumb/1/15/Ritualist-tango-icon-200.png/180px-Ritualist-tango-icon-200.png', 'https://wiki.guildwars.com/wiki/Ritualist', '{"BaseArmor":"60","ExtraEnergy":"10","ExtraEnergyRecovery":"2"}'::jsonb),
  ('Warrior', 'W', 'https://wiki.guildwars.com/images/thumb/8/88/Warrior-tango-icon-200.png/180px-Warrior-tango-icon-200.png', 'https://wiki.guildwars.com/wiki/Warrior', '{"BaseArmor":"80","PhysicalArmor":"+20 armor vs. physical damage"}'::jsonb)
ON CONFLICT (name) DO UPDATE SET
  abbreviation = EXCLUDED.abbreviation,
  icon = EXCLUDED.icon,
  wiki_url = EXCLUDED.wiki_url,
  armor_bonuses = EXCLUDED.armor_bonuses;
