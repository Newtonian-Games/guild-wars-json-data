-- Seed weapons
-- Auto-generated from data/weapons.json
-- Generated: 2025-11-17T07:36:05.804Z
-- Total weapons: 9

INSERT INTO weapons (name, category, subcategory, hands, attribute_id, attribute_profession_id, damage, variants, wiki_url)
VALUES
  (
    'Axe',
    'martial',
    'melee',
    'one',
    (SELECT id FROM attributes WHERE name = 'Axe Mastery' LIMIT 1),
    (SELECT id FROM professions WHERE name = 'Warrior'),
    '{"min":6,"max":28}'::jsonb,
    '[{"name":"Axe","attack_speed":1.33,"range":null,"flight_time":null,"arc_size":null,"damage_type":"slashing","properties":{},"wiki_url":"https://wiki.guildwars.com/wiki/Axe","icon":"https://wiki.guildwars.com/images/f/f2/Spiked_Axe.jpg"}]'::jsonb,
    'https://wiki.guildwars.com/wiki/Axe'
  ),
  (
    'Bow',
    'martial',
    'ranged',
    'two',
    (SELECT id FROM attributes WHERE name = 'Marksmanship' LIMIT 1),
    (SELECT id FROM professions WHERE name = 'Ranger'),
    '{"min":15,"max":28}'::jsonb,
    '[{"name":"Flatbow","attack_speed":2,"range":1.35,"flight_time":0.88,"arc_size":"high","damage_type":"piercing","properties":{},"wiki_url":"https://wiki.guildwars.com/wiki/Flatbow","icon":"https://wiki.guildwars.com/images/8/88/Flatbow.jpg"},{"name":"Hornbow","attack_speed":2.7,"range":1.2,"flight_time":0.59,"arc_size":"medium","damage_type":"piercing","properties":{"ArmorPenetration":0.1},"wiki_url":"https://wiki.guildwars.com/wiki/Hornbow","icon":"https://wiki.guildwars.com/images/1/1e/Hornbow_Serpent.jpg"},{"name":"Longbow","attack_speed":2.4,"range":1.35,"flight_time":0.59,"arc_size":"medium","damage_type":"piercing","properties":{},"wiki_url":"https://wiki.guildwars.com/wiki/Longbow","icon":"https://wiki.guildwars.com/images/4/41/Feathered_Longbow.jpg"},{"name":"Recurve Bow","attack_speed":2.4,"range":1.2,"flight_time":0.4,"arc_size":"low","damage_type":"piercing","properties":{},"wiki_url":"https://wiki.guildwars.com/wiki/Recurve_Bow","icon":"https://wiki.guildwars.com/images/e/e7/Recurve_Bow_%28weapon%29.jpg"},{"name":"Shortbow","attack_speed":2,"range":1,"flight_time":0.59,"arc_size":"medium","damage_type":"piercing","properties":{},"wiki_url":"https://wiki.guildwars.com/wiki/Shortbow","icon":"https://wiki.guildwars.com/images/2/29/Shortbow_%28weapon%29.jpg"}]'::jsonb,
    'https://wiki.guildwars.com/wiki/Bow'
  ),
  (
    'Daggers',
    'martial',
    'melee',
    'two',
    (SELECT id FROM attributes WHERE name = 'Dagger Mastery' LIMIT 1),
    (SELECT id FROM professions WHERE name = 'Assassin'),
    '{"min":7,"max":17}'::jsonb,
    '[{"name":"Daggers","attack_speed":1.33,"range":null,"flight_time":null,"arc_size":null,"damage_type":"slashing","properties":{"DoubleStrikeChancePerRank":0.02},"wiki_url":"https://wiki.guildwars.com/wiki/Daggers","icon":"https://wiki.guildwars.com/images/4/47/Elonian_Daggers_%28uncommon%29.jpg"}]'::jsonb,
    'https://wiki.guildwars.com/wiki/Daggers'
  ),
  (
    'Hammer',
    'martial',
    'melee',
    'two',
    (SELECT id FROM attributes WHERE name = 'Hammer Mastery' LIMIT 1),
    (SELECT id FROM professions WHERE name = 'Warrior'),
    '{"min":19,"max":35}'::jsonb,
    '[{"name":"Hammer","attack_speed":1.75,"range":null,"flight_time":null,"arc_size":null,"damage_type":"blunt","properties":{},"wiki_url":"https://wiki.guildwars.com/wiki/Hammer","icon":"https://wiki.guildwars.com/images/8/86/Deldrimor_Maul.jpg"}]'::jsonb,
    'https://wiki.guildwars.com/wiki/Hammer'
  ),
  (
    'Scythe',
    'martial',
    'melee',
    'two',
    (SELECT id FROM attributes WHERE name = 'Scythe Mastery' LIMIT 1),
    (SELECT id FROM professions WHERE name = 'Dervish'),
    '{"min":9,"max":41}'::jsonb,
    '[{"name":"Scythe","attack_speed":1.5,"range":null,"flight_time":null,"arc_size":null,"damage_type":"slashing","properties":{"HitsAdditionalFoes":2},"wiki_url":"https://wiki.guildwars.com/wiki/Scythe","icon":"https://wiki.guildwars.com/images/7/7e/Elegant_Scythe.jpg"}]'::jsonb,
    'https://wiki.guildwars.com/wiki/Scythe'
  ),
  (
    'Spear',
    'martial',
    'ranged',
    'one',
    (SELECT id FROM attributes WHERE name = 'Spear Mastery' LIMIT 1),
    (SELECT id FROM professions WHERE name = 'Paragon'),
    '{"min":14,"max":27}'::jsonb,
    '[{"name":"Spear","attack_speed":1.5,"range":1,"flight_time":0.6,"arc_size":"medium","damage_type":"piercing","properties":{},"wiki_url":"https://wiki.guildwars.com/wiki/Spear","icon":"https://wiki.guildwars.com/images/8/8c/Broadhead_Spear.jpg"}]'::jsonb,
    'https://wiki.guildwars.com/wiki/Spear'
  ),
  (
    'Staff',
    'caster',
    'ranged',
    'two',
    NULL,
    NULL,
    '{"min":11,"max":22}'::jsonb,
    '[{"name":"Staff","attack_speed":1.75,"range":1.2,"flight_time":0.56,"arc_size":"medium","damage_type":"by attribute","properties":{"EnergyBonus":{"min":3,"max":10},"HalfSkillRecharge":{"min":10,"max":20}},"wiki_url":"https://wiki.guildwars.com/wiki/Staff","icon":"https://wiki.guildwars.com/images/7/72/Hourglass_Staff_small.jpg"}]'::jsonb,
    'https://wiki.guildwars.com/wiki/Staff'
  ),
  (
    'Sword',
    'martial',
    'melee',
    'one',
    (SELECT id FROM attributes WHERE name = 'Swordsmanship' LIMIT 1),
    (SELECT id FROM professions WHERE name = 'Warrior'),
    '{"min":15,"max":22}'::jsonb,
    '[{"name":"Sword","attack_speed":1.33,"range":null,"flight_time":null,"arc_size":null,"damage_type":"slashing","properties":{},"wiki_url":"https://wiki.guildwars.com/wiki/Sword","icon":"https://wiki.guildwars.com/images/0/0e/Wingblade_Sword.jpg"}]'::jsonb,
    'https://wiki.guildwars.com/wiki/Sword'
  ),
  (
    'Wand',
    'caster',
    'ranged',
    'one',
    NULL,
    NULL,
    '{"min":11,"max":22}'::jsonb,
    '[{"name":"Wand","attack_speed":1.75,"range":1.2,"flight_time":0.56,"arc_size":"medium","damage_type":"by attribute","properties":{},"wiki_url":"https://wiki.guildwars.com/wiki/Wand","icon":"https://wiki.guildwars.com/images/9/97/Spiral_Rod.jpg"}]'::jsonb,
    'https://wiki.guildwars.com/wiki/Wand'
  )
ON CONFLICT (name) DO UPDATE SET
  category = EXCLUDED.category,
  subcategory = EXCLUDED.subcategory,
  hands = EXCLUDED.hands,
  attribute_id = EXCLUDED.attribute_id,
  attribute_profession_id = EXCLUDED.attribute_profession_id,
  damage = EXCLUDED.damage,
  variants = EXCLUDED.variants,
  wiki_url = EXCLUDED.wiki_url;
