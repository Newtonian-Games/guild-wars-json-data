-- Seed heroes
-- Auto-generated from data scraped from https://wiki.guildwars.com/wiki/Hero
-- Generated: 2025-11-20T00:00:10.000Z
-- Total heroes: 29

INSERT INTO heroes (name, profession, wiki_url)
VALUES
  -- Nightfall Heroes
  (
    'Koss',
    (SELECT id FROM professions WHERE name = 'Warrior'),
    'https://wiki.guildwars.com/wiki/Koss'
  ),
  (
    'Dunkoro',
    (SELECT id FROM professions WHERE name = 'Monk'),
    'https://wiki.guildwars.com/wiki/Dunkoro'
  ),
  (
    'Melonni',
    (SELECT id FROM professions WHERE name = 'Dervish'),
    'https://wiki.guildwars.com/wiki/Melonni'
  ),
  (
    'Acolyte Jin',
    (SELECT id FROM professions WHERE name = 'Ranger'),
    'https://wiki.guildwars.com/wiki/Acolyte_Jin'
  ),
  (
    'Acolyte Sousuke',
    (SELECT id FROM professions WHERE name = 'Elementalist'),
    'https://wiki.guildwars.com/wiki/Acolyte_Sousuke'
  ),
  (
    'Tahlkora',
    (SELECT id FROM professions WHERE name = 'Monk'),
    'https://wiki.guildwars.com/wiki/Tahlkora'
  ),
  (
    'Zhed Shadowhoof',
    (SELECT id FROM professions WHERE name = 'Elementalist'),
    'https://wiki.guildwars.com/wiki/Zhed_Shadowhoof'
  ),
  (
    'Margrid the Sly',
    (SELECT id FROM professions WHERE name = 'Ranger'),
    'https://wiki.guildwars.com/wiki/Margrid_the_Sly'
  ),
  (
    'Master of Whispers',
    (SELECT id FROM professions WHERE name = 'Necromancer'),
    'https://wiki.guildwars.com/wiki/Master_of_Whispers'
  ),
  (
    'Goren',
    (SELECT id FROM professions WHERE name = 'Warrior'),
    'https://wiki.guildwars.com/wiki/Goren'
  ),
  (
    'Norgu',
    (SELECT id FROM professions WHERE name = 'Mesmer'),
    'https://wiki.guildwars.com/wiki/Norgu'
  ),
  (
    'General Morgahn',
    (SELECT id FROM professions WHERE name = 'Paragon'),
    'https://wiki.guildwars.com/wiki/General_Morgahn'
  ),
  (
    'Razah',
    NULL, -- Variable profession (Any)
    'https://wiki.guildwars.com/wiki/Razah'
  ),
  -- Eye of the North Heroes
  (
    'Jora',
    (SELECT id FROM professions WHERE name = 'Warrior'),
    'https://wiki.guildwars.com/wiki/Jora'
  ),
  (
    'Pyre Fierceshot',
    (SELECT id FROM professions WHERE name = 'Ranger'),
    'https://wiki.guildwars.com/wiki/Pyre_Fierceshot'
  ),
  (
    'Ogden Stonehealer',
    (SELECT id FROM professions WHERE name = 'Monk'),
    'https://wiki.guildwars.com/wiki/Ogden_Stonehealer'
  ),
  (
    'Livia',
    (SELECT id FROM professions WHERE name = 'Necromancer'),
    'https://wiki.guildwars.com/wiki/Livia'
  ),
  (
    'Gwen',
    (SELECT id FROM professions WHERE name = 'Mesmer'),
    'https://wiki.guildwars.com/wiki/Gwen'
  ),
  (
    'Vekk',
    (SELECT id FROM professions WHERE name = 'Elementalist'),
    'https://wiki.guildwars.com/wiki/Vekk'
  ),
  (
    'Anton',
    (SELECT id FROM professions WHERE name = 'Assassin'),
    'https://wiki.guildwars.com/wiki/Anton'
  ),
  (
    'Xandra',
    (SELECT id FROM professions WHERE name = 'Ritualist'),
    'https://wiki.guildwars.com/wiki/Xandra'
  ),
  (
    'Hayda',
    (SELECT id FROM professions WHERE name = 'Paragon'),
    'https://wiki.guildwars.com/wiki/Hayda'
  ),
  (
    'Kahmu',
    (SELECT id FROM professions WHERE name = 'Dervish'),
    'https://wiki.guildwars.com/wiki/Kahmu'
  ),
  -- Beyond & Other Heroes
  (
    'Olias',
    (SELECT id FROM professions WHERE name = 'Necromancer'),
    'https://wiki.guildwars.com/wiki/Olias'
  ),
  (
    'Miku',
    (SELECT id FROM professions WHERE name = 'Assassin'),
    'https://wiki.guildwars.com/wiki/Miku'
  ),
  (
    'Zenmai',
    (SELECT id FROM professions WHERE name = 'Assassin'),
    'https://wiki.guildwars.com/wiki/Zenmai'
  ),
  (
    'Zei Ri',
    (SELECT id FROM professions WHERE name = 'Ritualist'),
    'https://wiki.guildwars.com/wiki/Zei_Ri'
  ),
  (
    'Keiran Thackeray',
    (SELECT id FROM professions WHERE name = 'Paragon'),
    'https://wiki.guildwars.com/wiki/Keiran_Thackeray'
  ),
  (
    'M.O.X.',
    (SELECT id FROM professions WHERE name = 'Dervish'),
    'https://wiki.guildwars.com/wiki/M.O.X.'
  )
ON CONFLICT (name) DO UPDATE SET
  profession = EXCLUDED.profession,
  wiki_url = EXCLUDED.wiki_url;
