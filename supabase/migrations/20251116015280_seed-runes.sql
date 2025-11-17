-- Seed runes
-- Auto-generated from data/runes.json
-- Generated: 2025-11-17T05:10:24.842Z
-- Total runes: 141

INSERT INTO runes (name, type, rarity, profession_id, attribute_id, icon, effects, description, wiki_url)
VALUES
  (
    'Rune of Attunement',
    'armor',
    'common',
    NULL,
    NULL,
    'https://wiki.guildwars.com/images/f/fb/Rune_All_Minor.png',
    '{"EnergyBonus":{"value":2,"cumulative":true}}'::jsonb,
    'Energy +2',
    'https://wiki.guildwars.com/wiki/Rune_of_Attunement'
  ),
  (
    'Rune of Belt Holding',
    'inventory',
    'rare',
    NULL,
    NULL,
    'https://wiki.guildwars.com/images/1/18/Rune_of_Belt_Holding.png',
    '{"BeltPouchSlots":{"value":10,"cumulative":false}}'::jsonb,
    'Upgrades belt pouch carrying capacity by +10 slots',
    'https://wiki.guildwars.com/wiki/Rune_of_Belt_Holding'
  ),
  (
    'Rune of Clarity',
    'armor',
    'uncommon',
    NULL,
    NULL,
    'https://wiki.guildwars.com/images/f/f6/Rune_All_Major.png',
    '{"ConditionReduction":{"value":{"Blind":0.2,"Weakness":0.2},"cumulative":false}}'::jsonb,
    'Reduces Blind duration on you by 20% (Non-stacking)
Reduces Weakness duration on you by 20% (Non-stacking)',
    'https://wiki.guildwars.com/wiki/Rune_of_Clarity'
  ),
  (
    'Rune of Holding',
    'inventory',
    'common',
    NULL,
    NULL,
    'https://wiki.guildwars.com/images/5/58/Rune_of_Holding.png',
    '{"BagSlots":{"value":10,"cumulative":false}}'::jsonb,
    'Upgrades bag carrying capacity by +10 slots',
    'https://wiki.guildwars.com/wiki/Rune_of_Holding'
  ),
  (
    'Rune of Major Air Magic',
    'armor',
    'uncommon',
    (SELECT id FROM professions WHERE name = 'Elementalist'),
    (SELECT id FROM attributes WHERE name = 'Air Magic' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/1/14/Rune_Elementalist_Major.png',
    '{"AttributeBonus":{"value":2,"cumulative":false},"HealthPenalty":{"value":-35,"cumulative":true}}'::jsonb,
    'Air Magic +2 (Non-stacking)
Health -35',
    'https://wiki.guildwars.com/wiki/Rune_of_Major_Air_Magic'
  ),
  (
    'Rune of Major Axe Mastery',
    'armor',
    'uncommon',
    (SELECT id FROM professions WHERE name = 'Warrior'),
    (SELECT id FROM attributes WHERE name = 'Axe Mastery' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/4/46/Rune_Warrior_Major.png',
    '{"AttributeBonus":{"value":2,"cumulative":false},"HealthPenalty":{"value":-35,"cumulative":true}}'::jsonb,
    'Axe Mastery +2 (Non-stacking)
Health -35',
    'https://wiki.guildwars.com/wiki/Rune_of_Major_Axe_Mastery'
  ),
  (
    'Rune of Major Beast Mastery',
    'armor',
    'uncommon',
    (SELECT id FROM professions WHERE name = 'Ranger'),
    (SELECT id FROM attributes WHERE name = 'Beast Mastery' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/8/85/Rune_Ranger_Major.png',
    '{"AttributeBonus":{"value":2,"cumulative":false},"HealthPenalty":{"value":-35,"cumulative":true}}'::jsonb,
    'Beast Mastery +2 (Non-stacking)
Health -35',
    'https://wiki.guildwars.com/wiki/Rune_of_Major_Beast_Mastery'
  ),
  (
    'Rune of Major Blood Magic',
    'armor',
    'uncommon',
    (SELECT id FROM professions WHERE name = 'Necromancer'),
    (SELECT id FROM attributes WHERE name = 'Blood Magic' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/8/85/Rune_Necromancer_Major.png',
    '{"AttributeBonus":{"value":2,"cumulative":false},"HealthPenalty":{"value":-35,"cumulative":true}}'::jsonb,
    'Blood Magic +2 (Non-stacking)
Health -35',
    'https://wiki.guildwars.com/wiki/Rune_of_Major_Blood_Magic'
  ),
  (
    'Rune of Major Channeling Magic',
    'armor',
    'uncommon',
    (SELECT id FROM professions WHERE name = 'Ritualist'),
    (SELECT id FROM attributes WHERE name = 'Channeling Magic' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/9/90/Rune_Ritualist_Major.png',
    '{"AttributeBonus":{"value":2,"cumulative":false},"HealthPenalty":{"value":-35,"cumulative":true}}'::jsonb,
    'Channeling Magic +2 (Non-stacking)
Health -35',
    'https://wiki.guildwars.com/wiki/Rune_of_Major_Channeling_Magic'
  ),
  (
    'Rune of Major Command',
    'armor',
    'uncommon',
    (SELECT id FROM professions WHERE name = 'Paragon'),
    (SELECT id FROM attributes WHERE name = 'Command' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/9/9a/Rune_Paragon_Major.png',
    '{"AttributeBonus":{"value":2,"cumulative":false},"HealthPenalty":{"value":-35,"cumulative":true}}'::jsonb,
    'Command +2 (Non-stacking)
Health -35',
    'https://wiki.guildwars.com/wiki/Rune_of_Major_Command'
  ),
  (
    'Rune of Major Communing',
    'armor',
    'uncommon',
    (SELECT id FROM professions WHERE name = 'Ritualist'),
    (SELECT id FROM attributes WHERE name = 'Communing' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/9/90/Rune_Ritualist_Major.png',
    '{"AttributeBonus":{"value":2,"cumulative":false},"HealthPenalty":{"value":-35,"cumulative":true}}'::jsonb,
    'Communing +2 (Non-stacking)
Health -35',
    'https://wiki.guildwars.com/wiki/Rune_of_Major_Communing'
  ),
  (
    'Rune of Major Critical Strikes',
    'armor',
    'uncommon',
    (SELECT id FROM professions WHERE name = 'Assassin'),
    (SELECT id FROM attributes WHERE name = 'Critical Strikes' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/c/cc/Rune_Assassin_Major.png',
    '{"AttributeBonus":{"value":2,"cumulative":false},"HealthPenalty":{"value":-35,"cumulative":true}}'::jsonb,
    'Critical Strikes +2 (Non-stacking)
Health -35',
    'https://wiki.guildwars.com/wiki/Rune_of_Major_Critical_Strikes'
  ),
  (
    'Rune of Major Curses',
    'armor',
    'uncommon',
    (SELECT id FROM professions WHERE name = 'Necromancer'),
    (SELECT id FROM attributes WHERE name = 'Curses' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/8/85/Rune_Necromancer_Major.png',
    '{"AttributeBonus":{"value":2,"cumulative":false},"HealthPenalty":{"value":-35,"cumulative":true}}'::jsonb,
    'Curses +2 (Non-stacking)
Health -35',
    'https://wiki.guildwars.com/wiki/Rune_of_Major_Curses'
  ),
  (
    'Rune of Major Dagger Mastery',
    'armor',
    'uncommon',
    (SELECT id FROM professions WHERE name = 'Assassin'),
    (SELECT id FROM attributes WHERE name = 'Dagger Mastery' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/c/cc/Rune_Assassin_Major.png',
    '{"AttributeBonus":{"value":2,"cumulative":false},"HealthPenalty":{"value":-35,"cumulative":true}}'::jsonb,
    'Dagger Mastery +2 (Non-stacking)
Health -35',
    'https://wiki.guildwars.com/wiki/Rune_of_Major_Dagger_Mastery'
  ),
  (
    'Rune of Major Deadly Arts',
    'armor',
    'uncommon',
    (SELECT id FROM professions WHERE name = 'Assassin'),
    (SELECT id FROM attributes WHERE name = 'Deadly Arts' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/c/cc/Rune_Assassin_Major.png',
    '{"AttributeBonus":{"value":2,"cumulative":false},"HealthPenalty":{"value":-35,"cumulative":true}}'::jsonb,
    'Deadly Arts +2 (Non-stacking)
Health -35',
    'https://wiki.guildwars.com/wiki/Rune_of_Major_Deadly_Arts'
  ),
  (
    'Rune of Major Death Magic',
    'armor',
    'uncommon',
    (SELECT id FROM professions WHERE name = 'Necromancer'),
    (SELECT id FROM attributes WHERE name = 'Death Magic' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/8/85/Rune_Necromancer_Major.png',
    '{"AttributeBonus":{"value":2,"cumulative":false},"HealthPenalty":{"value":-35,"cumulative":true}}'::jsonb,
    'Death Magic +2 (Non-stacking)
Health -35',
    'https://wiki.guildwars.com/wiki/Rune_of_Major_Death_Magic'
  ),
  (
    'Rune of Major Divine Favor',
    'armor',
    'uncommon',
    (SELECT id FROM professions WHERE name = 'Monk'),
    (SELECT id FROM attributes WHERE name = 'Divine Favor' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/2/27/Rune_Monk_Major.png',
    '{"AttributeBonus":{"value":2,"cumulative":false},"HealthPenalty":{"value":-35,"cumulative":true}}'::jsonb,
    'Divine Favor +2 (Non-stacking)
Health -35',
    'https://wiki.guildwars.com/wiki/Rune_of_Major_Divine_Favor'
  ),
  (
    'Rune of Major Domination Magic',
    'armor',
    'uncommon',
    (SELECT id FROM professions WHERE name = 'Mesmer'),
    (SELECT id FROM attributes WHERE name = 'Domination Magic' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/f/f9/Rune_Mesmer_Major.png',
    '{"AttributeBonus":{"value":2,"cumulative":false},"HealthPenalty":{"value":-35,"cumulative":true}}'::jsonb,
    'Domination Magic +2 (Non-stacking)
Health -35',
    'https://wiki.guildwars.com/wiki/Rune_of_Major_Domination_Magic'
  ),
  (
    'Rune of Major Earth Magic',
    'armor',
    'uncommon',
    (SELECT id FROM professions WHERE name = 'Elementalist'),
    (SELECT id FROM attributes WHERE name = 'Earth Magic' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/1/14/Rune_Elementalist_Major.png',
    '{"AttributeBonus":{"value":2,"cumulative":false},"HealthPenalty":{"value":-35,"cumulative":true}}'::jsonb,
    'Earth Magic +2 (Non-stacking)
Health -35',
    'https://wiki.guildwars.com/wiki/Rune_of_Major_Earth_Magic'
  ),
  (
    'Rune of Major Earth Prayers',
    'armor',
    'uncommon',
    (SELECT id FROM professions WHERE name = 'Dervish'),
    (SELECT id FROM attributes WHERE name = 'Earth Prayers' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/4/44/Rune_Dervish_Major.png',
    '{"AttributeBonus":{"value":2,"cumulative":false},"HealthPenalty":{"value":-35,"cumulative":true}}'::jsonb,
    'Earth Prayers +2 (Non-stacking)
Health -35',
    'https://wiki.guildwars.com/wiki/Rune_of_Major_Earth_Prayers'
  ),
  (
    'Rune of Major Energy Storage',
    'armor',
    'uncommon',
    (SELECT id FROM professions WHERE name = 'Elementalist'),
    (SELECT id FROM attributes WHERE name = 'Energy Storage' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/1/14/Rune_Elementalist_Major.png',
    '{"AttributeBonus":{"value":2,"cumulative":false},"HealthPenalty":{"value":-35,"cumulative":true}}'::jsonb,
    'Energy Storage +2 (Non-stacking)
Health -35',
    'https://wiki.guildwars.com/wiki/Rune_of_Major_Energy_Storage'
  ),
  (
    'Rune of Major Expertise',
    'armor',
    'uncommon',
    (SELECT id FROM professions WHERE name = 'Ranger'),
    (SELECT id FROM attributes WHERE name = 'Expertise' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/8/85/Rune_Ranger_Major.png',
    '{"AttributeBonus":{"value":2,"cumulative":false},"HealthPenalty":{"value":-35,"cumulative":true}}'::jsonb,
    'Expertise +2 (Non-stacking)
Health -35',
    'https://wiki.guildwars.com/wiki/Rune_of_Major_Expertise'
  ),
  (
    'Rune of Major Fast Casting',
    'armor',
    'uncommon',
    (SELECT id FROM professions WHERE name = 'Mesmer'),
    (SELECT id FROM attributes WHERE name = 'Fast Casting' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/f/f9/Rune_Mesmer_Major.png',
    '{"AttributeBonus":{"value":2,"cumulative":false},"HealthPenalty":{"value":-35,"cumulative":true}}'::jsonb,
    'Fast Casting +2 (Non-stacking)
Health -35',
    'https://wiki.guildwars.com/wiki/Rune_of_Major_Fast_Casting'
  ),
  (
    'Rune of Major Fire Magic',
    'armor',
    'uncommon',
    (SELECT id FROM professions WHERE name = 'Elementalist'),
    (SELECT id FROM attributes WHERE name = 'Fire Magic' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/1/14/Rune_Elementalist_Major.png',
    '{"AttributeBonus":{"value":2,"cumulative":false},"HealthPenalty":{"value":-35,"cumulative":true}}'::jsonb,
    'Fire Magic +2 (Non-stacking)
Health -35',
    'https://wiki.guildwars.com/wiki/Rune_of_Major_Fire_Magic'
  ),
  (
    'Rune of Major Hammer Mastery',
    'armor',
    'uncommon',
    (SELECT id FROM professions WHERE name = 'Warrior'),
    (SELECT id FROM attributes WHERE name = 'Hammer Mastery' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/4/46/Rune_Warrior_Major.png',
    '{"AttributeBonus":{"value":2,"cumulative":false},"HealthPenalty":{"value":-35,"cumulative":true}}'::jsonb,
    'Hammer Mastery +2 (Non-stacking)
Health -35',
    'https://wiki.guildwars.com/wiki/Rune_of_Major_Hammer_Mastery'
  ),
  (
    'Rune of Major Healing Prayers',
    'armor',
    'uncommon',
    (SELECT id FROM professions WHERE name = 'Monk'),
    (SELECT id FROM attributes WHERE name = 'Healing Prayers' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/2/27/Rune_Monk_Major.png',
    '{"AttributeBonus":{"value":2,"cumulative":false},"HealthPenalty":{"value":-35,"cumulative":true}}'::jsonb,
    'Healing Prayers +2 (Non-stacking)
Health -35',
    'https://wiki.guildwars.com/wiki/Rune_of_Major_Healing_Prayers'
  ),
  (
    'Rune of Major Illusion Magic',
    'armor',
    'uncommon',
    (SELECT id FROM professions WHERE name = 'Mesmer'),
    (SELECT id FROM attributes WHERE name = 'Illusion Magic' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/f/f9/Rune_Mesmer_Major.png',
    '{"AttributeBonus":{"value":2,"cumulative":false},"HealthPenalty":{"value":-35,"cumulative":true}}'::jsonb,
    'Illusion Magic +2 (Non-stacking)
Health -35',
    'https://wiki.guildwars.com/wiki/Rune_of_Major_Illusion_Magic'
  ),
  (
    'Rune of Major Inspiration Magic',
    'armor',
    'uncommon',
    (SELECT id FROM professions WHERE name = 'Mesmer'),
    (SELECT id FROM attributes WHERE name = 'Inspiration Magic' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/f/f9/Rune_Mesmer_Major.png',
    '{"AttributeBonus":{"value":2,"cumulative":false},"HealthPenalty":{"value":-35,"cumulative":true}}'::jsonb,
    'Inspiration Magic +2 (Non-stacking)
Health -35',
    'https://wiki.guildwars.com/wiki/Rune_of_Major_Inspiration_Magic'
  ),
  (
    'Rune of Major Leadership',
    'armor',
    'uncommon',
    (SELECT id FROM professions WHERE name = 'Paragon'),
    (SELECT id FROM attributes WHERE name = 'Leadership' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/9/9a/Rune_Paragon_Major.png',
    '{"AttributeBonus":{"value":2,"cumulative":false},"HealthPenalty":{"value":-35,"cumulative":true}}'::jsonb,
    'Leadership +2 (Non-stacking)
Health -35',
    'https://wiki.guildwars.com/wiki/Rune_of_Major_Leadership'
  ),
  (
    'Rune of Major Marksmanship',
    'armor',
    'uncommon',
    (SELECT id FROM professions WHERE name = 'Ranger'),
    (SELECT id FROM attributes WHERE name = 'Marksmanship' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/8/85/Rune_Ranger_Major.png',
    '{"AttributeBonus":{"value":2,"cumulative":false},"HealthPenalty":{"value":-35,"cumulative":true}}'::jsonb,
    'Marksmanship +2 (Non-stacking)
Health -35',
    'https://wiki.guildwars.com/wiki/Rune_of_Major_Marksmanship'
  ),
  (
    'Rune of Major Motivation',
    'armor',
    'uncommon',
    (SELECT id FROM professions WHERE name = 'Paragon'),
    (SELECT id FROM attributes WHERE name = 'Motivation' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/9/9a/Rune_Paragon_Major.png',
    '{"AttributeBonus":{"value":2,"cumulative":false},"HealthPenalty":{"value":-35,"cumulative":true}}'::jsonb,
    'Motivation +2 (Non-stacking)
Health -35',
    'https://wiki.guildwars.com/wiki/Rune_of_Major_Motivation'
  ),
  (
    'Rune of Major Mysticism',
    'armor',
    'uncommon',
    (SELECT id FROM professions WHERE name = 'Dervish'),
    (SELECT id FROM attributes WHERE name = 'Mysticism' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/4/44/Rune_Dervish_Major.png',
    '{"AttributeBonus":{"value":2,"cumulative":false},"HealthPenalty":{"value":-35,"cumulative":true}}'::jsonb,
    'Mysticism +2 (Non-stacking)
Health -35',
    'https://wiki.guildwars.com/wiki/Rune_of_Major_Mysticism'
  ),
  (
    'Rune of Major Protection Prayers',
    'armor',
    'uncommon',
    (SELECT id FROM professions WHERE name = 'Monk'),
    (SELECT id FROM attributes WHERE name = 'Protection Prayers' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/2/27/Rune_Monk_Major.png',
    '{"AttributeBonus":{"value":2,"cumulative":false},"HealthPenalty":{"value":-35,"cumulative":true}}'::jsonb,
    'Protection Prayers +2 (Non-stacking)
Health -35',
    'https://wiki.guildwars.com/wiki/Rune_of_Major_Protection_Prayers'
  ),
  (
    'Rune of Major Restoration Magic',
    'armor',
    'uncommon',
    (SELECT id FROM professions WHERE name = 'Ritualist'),
    (SELECT id FROM attributes WHERE name = 'Restoration Magic' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/9/90/Rune_Ritualist_Major.png',
    '{"AttributeBonus":{"value":2,"cumulative":false},"HealthPenalty":{"value":-35,"cumulative":true}}'::jsonb,
    'Restoration Magic +2 (Non-stacking)
Health -35',
    'https://wiki.guildwars.com/wiki/Rune_of_Major_Restoration_Magic'
  ),
  (
    'Rune of Major Scythe Mastery',
    'armor',
    'uncommon',
    (SELECT id FROM professions WHERE name = 'Dervish'),
    (SELECT id FROM attributes WHERE name = 'Scythe Mastery' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/4/44/Rune_Dervish_Major.png',
    '{"AttributeBonus":{"value":2,"cumulative":false},"HealthPenalty":{"value":-35,"cumulative":true}}'::jsonb,
    'Scythe Mastery +2 (Non-stacking)
Health -35',
    'https://wiki.guildwars.com/wiki/Rune_of_Major_Scythe_Mastery'
  ),
  (
    'Rune of Major Shadow Arts',
    'armor',
    'uncommon',
    (SELECT id FROM professions WHERE name = 'Assassin'),
    (SELECT id FROM attributes WHERE name = 'Shadow Arts' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/c/cc/Rune_Assassin_Major.png',
    '{"AttributeBonus":{"value":2,"cumulative":false},"HealthPenalty":{"value":-35,"cumulative":true}}'::jsonb,
    'Shadow Arts +2 (Non-stacking)
Health -35',
    'https://wiki.guildwars.com/wiki/Rune_of_Major_Shadow_Arts'
  ),
  (
    'Rune of Major Smiting Prayers',
    'armor',
    'uncommon',
    (SELECT id FROM professions WHERE name = 'Monk'),
    (SELECT id FROM attributes WHERE name = 'Smiting Prayers' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/2/27/Rune_Monk_Major.png',
    '{"AttributeBonus":{"value":2,"cumulative":false},"HealthPenalty":{"value":-35,"cumulative":true}}'::jsonb,
    'Smiting Prayers +2 (Non-stacking)
Health -35',
    'https://wiki.guildwars.com/wiki/Rune_of_Major_Smiting_Prayers'
  ),
  (
    'Rune of Major Soul Reaping',
    'armor',
    'uncommon',
    (SELECT id FROM professions WHERE name = 'Necromancer'),
    (SELECT id FROM attributes WHERE name = 'Soul Reaping' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/8/85/Rune_Necromancer_Major.png',
    '{"AttributeBonus":{"value":2,"cumulative":false},"HealthPenalty":{"value":-35,"cumulative":true}}'::jsonb,
    'Soul Reaping +2 (Non-stacking)
Health -35',
    'https://wiki.guildwars.com/wiki/Rune_of_Major_Soul_Reaping'
  ),
  (
    'Rune of Major Spawning Power',
    'armor',
    'uncommon',
    (SELECT id FROM professions WHERE name = 'Ritualist'),
    (SELECT id FROM attributes WHERE name = 'Spawning Power' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/9/90/Rune_Ritualist_Major.png',
    '{"AttributeBonus":{"value":2,"cumulative":false},"HealthPenalty":{"value":-35,"cumulative":true}}'::jsonb,
    'Spawning Power +2 (Non-stacking)
Health -35',
    'https://wiki.guildwars.com/wiki/Rune_of_Major_Spawning_Power'
  ),
  (
    'Rune of Major Spear Mastery',
    'armor',
    'uncommon',
    (SELECT id FROM professions WHERE name = 'Paragon'),
    (SELECT id FROM attributes WHERE name = 'Spear Mastery' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/9/9a/Rune_Paragon_Major.png',
    '{"AttributeBonus":{"value":2,"cumulative":false},"HealthPenalty":{"value":-35,"cumulative":true}}'::jsonb,
    'Spear Mastery +2 (Non-stacking)
Health -35',
    'https://wiki.guildwars.com/wiki/Rune_of_Major_Spear_Mastery'
  ),
  (
    'Rune of Major Strength',
    'armor',
    'uncommon',
    (SELECT id FROM professions WHERE name = 'Warrior'),
    (SELECT id FROM attributes WHERE name = 'Strength' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/4/46/Rune_Warrior_Major.png',
    '{"AttributeBonus":{"value":2,"cumulative":false},"HealthPenalty":{"value":-35,"cumulative":true}}'::jsonb,
    'Strength +2 (Non-stacking)
Health -35',
    'https://wiki.guildwars.com/wiki/Rune_of_Major_Strength'
  ),
  (
    'Rune of Major Swordsmanship',
    'armor',
    'uncommon',
    (SELECT id FROM professions WHERE name = 'Warrior'),
    (SELECT id FROM attributes WHERE name = 'Swordsmanship' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/4/46/Rune_Warrior_Major.png',
    '{"AttributeBonus":{"value":2,"cumulative":false},"HealthPenalty":{"value":-35,"cumulative":true}}'::jsonb,
    'Swordsmanship +2 (Non-stacking)
Health -35',
    'https://wiki.guildwars.com/wiki/Rune_of_Major_Swordsmanship'
  ),
  (
    'Rune of Major Tactics',
    'armor',
    'uncommon',
    (SELECT id FROM professions WHERE name = 'Warrior'),
    (SELECT id FROM attributes WHERE name = 'Tactics' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/4/46/Rune_Warrior_Major.png',
    '{"AttributeBonus":{"value":2,"cumulative":false},"HealthPenalty":{"value":-35,"cumulative":true}}'::jsonb,
    'Tactics +2 (Non-stacking)
Health -35',
    'https://wiki.guildwars.com/wiki/Rune_of_Major_Tactics'
  ),
  (
    'Rune of Major Vigor',
    'armor',
    'uncommon',
    NULL,
    NULL,
    'https://wiki.guildwars.com/images/f/f6/Rune_All_Major.png',
    '{"HealthBonus":{"value":41,"cumulative":false}}'::jsonb,
    'Health +41 (Non-stacking)',
    'https://wiki.guildwars.com/wiki/Rune_of_Major_Vigor'
  ),
  (
    'Rune of Major Water Magic',
    'armor',
    'uncommon',
    (SELECT id FROM professions WHERE name = 'Elementalist'),
    (SELECT id FROM attributes WHERE name = 'Water Magic' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/1/14/Rune_Elementalist_Major.png',
    '{"AttributeBonus":{"value":2,"cumulative":false},"HealthPenalty":{"value":-35,"cumulative":true}}'::jsonb,
    'Water Magic +2 (Non-stacking)
Health -35',
    'https://wiki.guildwars.com/wiki/Rune_of_Major_Water_Magic'
  ),
  (
    'Rune of Major Wilderness Survival',
    'armor',
    'uncommon',
    (SELECT id FROM professions WHERE name = 'Ranger'),
    (SELECT id FROM attributes WHERE name = 'Wilderness Survival' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/8/85/Rune_Ranger_Major.png',
    '{"AttributeBonus":{"value":2,"cumulative":false},"HealthPenalty":{"value":-35,"cumulative":true}}'::jsonb,
    'Wilderness Survival +2 (Non-stacking)
Health -35',
    'https://wiki.guildwars.com/wiki/Rune_of_Major_Wilderness_Survival'
  ),
  (
    'Rune of Major Wind Prayers',
    'armor',
    'uncommon',
    (SELECT id FROM professions WHERE name = 'Dervish'),
    (SELECT id FROM attributes WHERE name = 'Wind Prayers' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/4/44/Rune_Dervish_Major.png',
    '{"AttributeBonus":{"value":2,"cumulative":false},"HealthPenalty":{"value":-35,"cumulative":true}}'::jsonb,
    'Wind Prayers +2 (Non-stacking)
Health -35',
    'https://wiki.guildwars.com/wiki/Rune_of_Major_Wind_Prayers'
  ),
  (
    'Rune of Minor Air Magic',
    'armor',
    'common',
    (SELECT id FROM professions WHERE name = 'Elementalist'),
    (SELECT id FROM attributes WHERE name = 'Air Magic' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/6/6f/Rune_Elementalist_Minor.png',
    '{"AttributeBonus":{"value":1,"cumulative":false}}'::jsonb,
    'Air Magic +1 (Non-stacking)',
    'https://wiki.guildwars.com/wiki/Rune_of_Minor_Air_Magic'
  ),
  (
    'Rune of Minor Axe Mastery',
    'armor',
    'common',
    (SELECT id FROM professions WHERE name = 'Warrior'),
    (SELECT id FROM attributes WHERE name = 'Axe Mastery' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/2/2f/Rune_Warrior_Minor.png',
    '{"AttributeBonus":{"value":1,"cumulative":false}}'::jsonb,
    'Axe Mastery +1 (Non-stacking)',
    'https://wiki.guildwars.com/wiki/Rune_of_Minor_Axe_Mastery'
  ),
  (
    'Rune of Minor Beast Mastery',
    'armor',
    'common',
    (SELECT id FROM professions WHERE name = 'Ranger'),
    (SELECT id FROM attributes WHERE name = 'Beast Mastery' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/1/15/Rune_Ranger_Minor.png',
    '{"AttributeBonus":{"value":1,"cumulative":false}}'::jsonb,
    'Beast Mastery +1 (Non-stacking)',
    'https://wiki.guildwars.com/wiki/Rune_of_Minor_Beast_Mastery'
  ),
  (
    'Rune of Minor Blood Magic',
    'armor',
    'common',
    (SELECT id FROM professions WHERE name = 'Necromancer'),
    (SELECT id FROM attributes WHERE name = 'Blood Magic' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/c/c5/Rune_Necromancer_Minor.png',
    '{"AttributeBonus":{"value":1,"cumulative":false}}'::jsonb,
    'Blood Magic +1 (Non-stacking)',
    'https://wiki.guildwars.com/wiki/Rune_of_Minor_Blood_Magic'
  ),
  (
    'Rune of Minor Channeling Magic',
    'armor',
    'common',
    (SELECT id FROM professions WHERE name = 'Ritualist'),
    (SELECT id FROM attributes WHERE name = 'Channeling Magic' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/c/cb/Rune_Ritualist_Minor.png',
    '{"AttributeBonus":{"value":1,"cumulative":false}}'::jsonb,
    'Channeling Magic +1 (Non-stacking)',
    'https://wiki.guildwars.com/wiki/Rune_of_Minor_Channeling_Magic'
  ),
  (
    'Rune of Minor Command',
    'armor',
    'common',
    (SELECT id FROM professions WHERE name = 'Paragon'),
    (SELECT id FROM attributes WHERE name = 'Command' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/e/e8/Rune_Paragon_Minor.png',
    '{"AttributeBonus":{"value":1,"cumulative":false}}'::jsonb,
    'Command +1 (Non-stacking)',
    'https://wiki.guildwars.com/wiki/Rune_of_Minor_Command'
  ),
  (
    'Rune of Minor Communing',
    'armor',
    'common',
    (SELECT id FROM professions WHERE name = 'Ritualist'),
    (SELECT id FROM attributes WHERE name = 'Communing' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/c/cb/Rune_Ritualist_Minor.png',
    '{"AttributeBonus":{"value":1,"cumulative":false}}'::jsonb,
    'Communing +1 (Non-stacking)',
    'https://wiki.guildwars.com/wiki/Rune_of_Minor_Communing'
  ),
  (
    'Rune of Minor Critical Strikes',
    'armor',
    'common',
    (SELECT id FROM professions WHERE name = 'Assassin'),
    (SELECT id FROM attributes WHERE name = 'Critical Strikes' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/d/dd/Rune_Assassin_Minor.png',
    '{"AttributeBonus":{"value":1,"cumulative":false}}'::jsonb,
    'Critical Strikes +1 (Non-stacking)',
    'https://wiki.guildwars.com/wiki/Rune_of_Minor_Critical_Strikes'
  ),
  (
    'Rune of Minor Curses',
    'armor',
    'common',
    (SELECT id FROM professions WHERE name = 'Necromancer'),
    (SELECT id FROM attributes WHERE name = 'Curses' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/c/c5/Rune_Necromancer_Minor.png',
    '{"AttributeBonus":{"value":1,"cumulative":false}}'::jsonb,
    'Curses +1 (Non-stacking)',
    'https://wiki.guildwars.com/wiki/Rune_of_Minor_Curses'
  ),
  (
    'Rune of Minor Dagger Mastery',
    'armor',
    'common',
    (SELECT id FROM professions WHERE name = 'Assassin'),
    (SELECT id FROM attributes WHERE name = 'Dagger Mastery' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/d/dd/Rune_Assassin_Minor.png',
    '{"AttributeBonus":{"value":1,"cumulative":false}}'::jsonb,
    'Dagger Mastery +1 (Non-stacking)',
    'https://wiki.guildwars.com/wiki/Rune_of_Minor_Dagger_Mastery'
  ),
  (
    'Rune of Minor Deadly Arts',
    'armor',
    'common',
    (SELECT id FROM professions WHERE name = 'Assassin'),
    (SELECT id FROM attributes WHERE name = 'Deadly Arts' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/d/dd/Rune_Assassin_Minor.png',
    '{"AttributeBonus":{"value":1,"cumulative":false}}'::jsonb,
    'Deadly Arts +1 (Non-stacking)',
    'https://wiki.guildwars.com/wiki/Rune_of_Minor_Deadly_Arts'
  ),
  (
    'Rune of Minor Death Magic',
    'armor',
    'common',
    (SELECT id FROM professions WHERE name = 'Necromancer'),
    (SELECT id FROM attributes WHERE name = 'Death Magic' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/c/c5/Rune_Necromancer_Minor.png',
    '{"AttributeBonus":{"value":1,"cumulative":false}}'::jsonb,
    'Death Magic +1 (Non-stacking)',
    'https://wiki.guildwars.com/wiki/Rune_of_Minor_Death_Magic'
  ),
  (
    'Rune of Minor Divine Favor',
    'armor',
    'common',
    (SELECT id FROM professions WHERE name = 'Monk'),
    (SELECT id FROM attributes WHERE name = 'Divine Favor' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/2/28/Rune_Monk_Minor.png',
    '{"AttributeBonus":{"value":1,"cumulative":false}}'::jsonb,
    'Divine Favor +1 (Non-stacking)',
    'https://wiki.guildwars.com/wiki/Rune_of_Minor_Divine_Favor'
  ),
  (
    'Rune of Minor Domination Magic',
    'armor',
    'common',
    (SELECT id FROM professions WHERE name = 'Mesmer'),
    (SELECT id FROM attributes WHERE name = 'Domination Magic' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/6/6c/Rune_Mesmer_Minor.png',
    '{"AttributeBonus":{"value":1,"cumulative":false}}'::jsonb,
    'Domination Magic +1 (Non-stacking)',
    'https://wiki.guildwars.com/wiki/Rune_of_Minor_Domination_Magic'
  ),
  (
    'Rune of Minor Earth Magic',
    'armor',
    'common',
    (SELECT id FROM professions WHERE name = 'Elementalist'),
    (SELECT id FROM attributes WHERE name = 'Earth Magic' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/6/6f/Rune_Elementalist_Minor.png',
    '{"AttributeBonus":{"value":1,"cumulative":false}}'::jsonb,
    'Earth Magic +1 (Non-stacking)',
    'https://wiki.guildwars.com/wiki/Rune_of_Minor_Earth_Magic'
  ),
  (
    'Rune of Minor Earth Prayers',
    'armor',
    'common',
    (SELECT id FROM professions WHERE name = 'Dervish'),
    (SELECT id FROM attributes WHERE name = 'Earth Prayers' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/4/45/Rune_Dervish_Minor.png',
    '{"AttributeBonus":{"value":1,"cumulative":false}}'::jsonb,
    'Earth Prayers +1 (Non-stacking)',
    'https://wiki.guildwars.com/wiki/Rune_of_Minor_Earth_Prayers'
  ),
  (
    'Rune of Minor Energy Storage',
    'armor',
    'common',
    (SELECT id FROM professions WHERE name = 'Elementalist'),
    (SELECT id FROM attributes WHERE name = 'Energy Storage' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/6/6f/Rune_Elementalist_Minor.png',
    '{"AttributeBonus":{"value":1,"cumulative":false}}'::jsonb,
    'Energy Storage +1 (Non-stacking)',
    'https://wiki.guildwars.com/wiki/Rune_of_Minor_Energy_Storage'
  ),
  (
    'Rune of Minor Expertise',
    'armor',
    'common',
    (SELECT id FROM professions WHERE name = 'Ranger'),
    (SELECT id FROM attributes WHERE name = 'Expertise' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/1/15/Rune_Ranger_Minor.png',
    '{"AttributeBonus":{"value":1,"cumulative":false}}'::jsonb,
    'Expertise +1 (Non-stacking)',
    'https://wiki.guildwars.com/wiki/Rune_of_Minor_Expertise'
  ),
  (
    'Rune of Minor Fast Casting',
    'armor',
    'common',
    (SELECT id FROM professions WHERE name = 'Mesmer'),
    (SELECT id FROM attributes WHERE name = 'Fast Casting' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/6/6c/Rune_Mesmer_Minor.png',
    '{"AttributeBonus":{"value":1,"cumulative":false}}'::jsonb,
    'Fast Casting +1 (Non-stacking)',
    'https://wiki.guildwars.com/wiki/Rune_of_Minor_Fast_Casting'
  ),
  (
    'Rune of Minor Fire Magic',
    'armor',
    'common',
    (SELECT id FROM professions WHERE name = 'Elementalist'),
    (SELECT id FROM attributes WHERE name = 'Fire Magic' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/6/6f/Rune_Elementalist_Minor.png',
    '{"AttributeBonus":{"value":1,"cumulative":false}}'::jsonb,
    'Fire Magic +1 (Non-stacking)',
    'https://wiki.guildwars.com/wiki/Rune_of_Minor_Fire_Magic'
  ),
  (
    'Rune of Minor Hammer Mastery',
    'armor',
    'common',
    (SELECT id FROM professions WHERE name = 'Warrior'),
    (SELECT id FROM attributes WHERE name = 'Hammer Mastery' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/2/2f/Rune_Warrior_Minor.png',
    '{"AttributeBonus":{"value":1,"cumulative":false}}'::jsonb,
    'Hammer Mastery +1 (Non-stacking)',
    'https://wiki.guildwars.com/wiki/Rune_of_Minor_Hammer_Mastery'
  ),
  (
    'Rune of Minor Healing Prayers',
    'armor',
    'common',
    (SELECT id FROM professions WHERE name = 'Monk'),
    (SELECT id FROM attributes WHERE name = 'Healing Prayers' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/2/28/Rune_Monk_Minor.png',
    '{"AttributeBonus":{"value":1,"cumulative":false}}'::jsonb,
    'Healing Prayers +1 (Non-stacking)',
    'https://wiki.guildwars.com/wiki/Rune_of_Minor_Healing_Prayers'
  ),
  (
    'Rune of Minor Illusion Magic',
    'armor',
    'common',
    (SELECT id FROM professions WHERE name = 'Mesmer'),
    (SELECT id FROM attributes WHERE name = 'Illusion Magic' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/6/6c/Rune_Mesmer_Minor.png',
    '{"AttributeBonus":{"value":1,"cumulative":false}}'::jsonb,
    'Illusion Magic +1 (Non-stacking)',
    'https://wiki.guildwars.com/wiki/Rune_of_Minor_Illusion_Magic'
  ),
  (
    'Rune of Minor Inspiration Magic',
    'armor',
    'common',
    (SELECT id FROM professions WHERE name = 'Mesmer'),
    (SELECT id FROM attributes WHERE name = 'Inspiration Magic' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/6/6c/Rune_Mesmer_Minor.png',
    '{"AttributeBonus":{"value":1,"cumulative":false}}'::jsonb,
    'Inspiration Magic +1 (Non-stacking)',
    'https://wiki.guildwars.com/wiki/Rune_of_Minor_Inspiration_Magic'
  ),
  (
    'Rune of Minor Leadership',
    'armor',
    'common',
    (SELECT id FROM professions WHERE name = 'Paragon'),
    (SELECT id FROM attributes WHERE name = 'Leadership' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/e/e8/Rune_Paragon_Minor.png',
    '{"AttributeBonus":{"value":1,"cumulative":false}}'::jsonb,
    'Leadership +1 (Non-stacking)',
    'https://wiki.guildwars.com/wiki/Rune_of_Minor_Leadership'
  ),
  (
    'Rune of Minor Marksmanship',
    'armor',
    'common',
    (SELECT id FROM professions WHERE name = 'Ranger'),
    (SELECT id FROM attributes WHERE name = 'Marksmanship' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/1/15/Rune_Ranger_Minor.png',
    '{"AttributeBonus":{"value":1,"cumulative":false}}'::jsonb,
    'Marksmanship +1 (Non-stacking)',
    'https://wiki.guildwars.com/wiki/Rune_of_Minor_Marksmanship'
  ),
  (
    'Rune of Minor Motivation',
    'armor',
    'common',
    (SELECT id FROM professions WHERE name = 'Paragon'),
    (SELECT id FROM attributes WHERE name = 'Motivation' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/e/e8/Rune_Paragon_Minor.png',
    '{"AttributeBonus":{"value":1,"cumulative":false}}'::jsonb,
    'Motivation +1 (Non-stacking)',
    'https://wiki.guildwars.com/wiki/Rune_of_Minor_Motivation'
  ),
  (
    'Rune of Minor Mysticism',
    'armor',
    'common',
    (SELECT id FROM professions WHERE name = 'Dervish'),
    (SELECT id FROM attributes WHERE name = 'Mysticism' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/4/45/Rune_Dervish_Minor.png',
    '{"AttributeBonus":{"value":1,"cumulative":false}}'::jsonb,
    'Mysticism +1 (Non-stacking)',
    'https://wiki.guildwars.com/wiki/Rune_of_Minor_Mysticism'
  ),
  (
    'Rune of Minor Protection Prayers',
    'armor',
    'common',
    (SELECT id FROM professions WHERE name = 'Monk'),
    (SELECT id FROM attributes WHERE name = 'Protection Prayers' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/2/28/Rune_Monk_Minor.png',
    '{"AttributeBonus":{"value":1,"cumulative":false}}'::jsonb,
    'Protection Prayers +1 (Non-stacking)',
    'https://wiki.guildwars.com/wiki/Rune_of_Minor_Protection_Prayers'
  ),
  (
    'Rune of Minor Restoration Magic',
    'armor',
    'common',
    (SELECT id FROM professions WHERE name = 'Ritualist'),
    (SELECT id FROM attributes WHERE name = 'Restoration Magic' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/c/cb/Rune_Ritualist_Minor.png',
    '{"AttributeBonus":{"value":1,"cumulative":false}}'::jsonb,
    'Restoration Magic +1 (Non-stacking)',
    'https://wiki.guildwars.com/wiki/Rune_of_Minor_Restoration_Magic'
  ),
  (
    'Rune of Minor Scythe Mastery',
    'armor',
    'common',
    (SELECT id FROM professions WHERE name = 'Dervish'),
    (SELECT id FROM attributes WHERE name = 'Scythe Mastery' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/4/45/Rune_Dervish_Minor.png',
    '{"AttributeBonus":{"value":1,"cumulative":false}}'::jsonb,
    'Scythe Mastery +1 (Non-stacking)',
    'https://wiki.guildwars.com/wiki/Rune_of_Minor_Scythe_Mastery'
  ),
  (
    'Rune of Minor Shadow Arts',
    'armor',
    'common',
    (SELECT id FROM professions WHERE name = 'Assassin'),
    (SELECT id FROM attributes WHERE name = 'Shadow Arts' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/d/dd/Rune_Assassin_Minor.png',
    '{"AttributeBonus":{"value":1,"cumulative":false}}'::jsonb,
    'Shadow Arts +1 (Non-stacking)',
    'https://wiki.guildwars.com/wiki/Rune_of_Minor_Shadow_Arts'
  ),
  (
    'Rune of Minor Smiting Prayers',
    'armor',
    'common',
    (SELECT id FROM professions WHERE name = 'Monk'),
    (SELECT id FROM attributes WHERE name = 'Smiting Prayers' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/2/28/Rune_Monk_Minor.png',
    '{"AttributeBonus":{"value":1,"cumulative":false}}'::jsonb,
    'Smiting Prayers +1 (Non-stacking)',
    'https://wiki.guildwars.com/wiki/Rune_of_Minor_Smiting_Prayers'
  ),
  (
    'Rune of Minor Soul Reaping',
    'armor',
    'common',
    (SELECT id FROM professions WHERE name = 'Necromancer'),
    (SELECT id FROM attributes WHERE name = 'Soul Reaping' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/c/c5/Rune_Necromancer_Minor.png',
    '{"AttributeBonus":{"value":1,"cumulative":false}}'::jsonb,
    'Soul Reaping +1 (Non-stacking)',
    'https://wiki.guildwars.com/wiki/Rune_of_Minor_Soul_Reaping'
  ),
  (
    'Rune of Minor Spawning Power',
    'armor',
    'common',
    (SELECT id FROM professions WHERE name = 'Ritualist'),
    (SELECT id FROM attributes WHERE name = 'Spawning Power' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/c/cb/Rune_Ritualist_Minor.png',
    '{"AttributeBonus":{"value":1,"cumulative":false}}'::jsonb,
    'Spawning Power +1 (Non-stacking)',
    'https://wiki.guildwars.com/wiki/Rune_of_Minor_Spawning_Power'
  ),
  (
    'Rune of Minor Spear Mastery',
    'armor',
    'common',
    (SELECT id FROM professions WHERE name = 'Paragon'),
    (SELECT id FROM attributes WHERE name = 'Spear Mastery' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/e/e8/Rune_Paragon_Minor.png',
    '{"AttributeBonus":{"value":1,"cumulative":false}}'::jsonb,
    'Spear Mastery +1 (Non-stacking)',
    'https://wiki.guildwars.com/wiki/Rune_of_Minor_Spear_Mastery'
  ),
  (
    'Rune of Minor Strength',
    'armor',
    'common',
    (SELECT id FROM professions WHERE name = 'Warrior'),
    (SELECT id FROM attributes WHERE name = 'Strength' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/2/2f/Rune_Warrior_Minor.png',
    '{"AttributeBonus":{"value":1,"cumulative":false}}'::jsonb,
    'Strength +1 (Non-stacking)',
    'https://wiki.guildwars.com/wiki/Rune_of_Minor_Strength'
  ),
  (
    'Rune of Minor Swordsmanship',
    'armor',
    'common',
    (SELECT id FROM professions WHERE name = 'Warrior'),
    (SELECT id FROM attributes WHERE name = 'Swordsmanship' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/2/2f/Rune_Warrior_Minor.png',
    '{"AttributeBonus":{"value":1,"cumulative":false}}'::jsonb,
    'Swordsmanship +1 (Non-stacking)',
    'https://wiki.guildwars.com/wiki/Rune_of_Minor_Swordsmanship'
  ),
  (
    'Rune of Minor Tactics',
    'armor',
    'common',
    (SELECT id FROM professions WHERE name = 'Warrior'),
    (SELECT id FROM attributes WHERE name = 'Tactics' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/2/2f/Rune_Warrior_Minor.png',
    '{"AttributeBonus":{"value":1,"cumulative":false}}'::jsonb,
    'Tactics +1 (Non-stacking)',
    'https://wiki.guildwars.com/wiki/Rune_of_Minor_Tactics'
  ),
  (
    'Rune of Minor Vigor',
    'armor',
    'common',
    NULL,
    NULL,
    'https://wiki.guildwars.com/images/f/fb/Rune_All_Minor.png',
    '{"HealthBonus":{"value":30,"cumulative":false}}'::jsonb,
    'Health +30 (Non-stacking)',
    'https://wiki.guildwars.com/wiki/Rune_of_Minor_Vigor'
  ),
  (
    'Rune of Minor Water Magic',
    'armor',
    'common',
    (SELECT id FROM professions WHERE name = 'Elementalist'),
    (SELECT id FROM attributes WHERE name = 'Water Magic' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/6/6f/Rune_Elementalist_Minor.png',
    '{"AttributeBonus":{"value":1,"cumulative":false}}'::jsonb,
    'Water Magic +1 (Non-stacking)',
    'https://wiki.guildwars.com/wiki/Rune_of_Minor_Water_Magic'
  ),
  (
    'Rune of Minor Wilderness Survival',
    'armor',
    'common',
    (SELECT id FROM professions WHERE name = 'Ranger'),
    (SELECT id FROM attributes WHERE name = 'Wilderness Survival' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/1/15/Rune_Ranger_Minor.png',
    '{"AttributeBonus":{"value":1,"cumulative":false}}'::jsonb,
    'Wilderness Survival +1 (Non-stacking)',
    'https://wiki.guildwars.com/wiki/Rune_of_Minor_Wilderness_Survival'
  ),
  (
    'Rune of Minor Wind Prayers',
    'armor',
    'common',
    (SELECT id FROM professions WHERE name = 'Dervish'),
    (SELECT id FROM attributes WHERE name = 'Wind Prayers' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/4/45/Rune_Dervish_Minor.png',
    '{"AttributeBonus":{"value":1,"cumulative":false}}'::jsonb,
    'Wind Prayers +1 (Non-stacking)',
    'https://wiki.guildwars.com/wiki/Rune_of_Minor_Wind_Prayers'
  ),
  (
    'Rune of Purity',
    'armor',
    'uncommon',
    NULL,
    NULL,
    'https://wiki.guildwars.com/images/f/f6/Rune_All_Major.png',
    '{"ConditionReduction":{"value":{"Disease":0.2,"Poison":0.2},"cumulative":false}}'::jsonb,
    'Reduces Disease duration on you by 20% (Non-stacking)
Reduces Poison duration on you by 20% (Non-stacking)',
    'https://wiki.guildwars.com/wiki/Rune_of_Purity'
  ),
  (
    'Rune of Recovery',
    'armor',
    'uncommon',
    NULL,
    NULL,
    'https://wiki.guildwars.com/images/f/f6/Rune_All_Major.png',
    '{"ConditionReduction":{"value":{"Dazed":0.2,"Deep Wound":0.2},"cumulative":false}}'::jsonb,
    'Reduces Dazed duration on you by 20% (Non-stacking)
Reduces Deep Wound duration on you by 20% (Non-stacking)',
    'https://wiki.guildwars.com/wiki/Rune_of_Recovery'
  ),
  (
    'Rune of Restoration',
    'armor',
    'uncommon',
    NULL,
    NULL,
    'https://wiki.guildwars.com/images/f/f6/Rune_All_Major.png',
    '{"ConditionReduction":{"value":{"Bleeding":0.2,"Crippled":0.2},"cumulative":false}}'::jsonb,
    'Reduces Bleeding duration on you by 20% (Non-stacking)
Reduces Crippled duration on you by 20% (Non-stacking)',
    'https://wiki.guildwars.com/wiki/Rune_of_Restoration'
  ),
  (
    'Rune of Superior Air Magic',
    'armor',
    'rare',
    (SELECT id FROM professions WHERE name = 'Elementalist'),
    (SELECT id FROM attributes WHERE name = 'Air Magic' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/8/83/Rune_Elementalist_Sup.png',
    '{"AttributeBonus":{"value":3,"cumulative":false},"HealthPenalty":{"value":-75,"cumulative":true}}'::jsonb,
    'Air Magic +3 (Non-stacking)
Health -75',
    'https://wiki.guildwars.com/wiki/Rune_of_Superior_Air_Magic'
  ),
  (
    'Rune of Superior Axe Mastery',
    'armor',
    'rare',
    (SELECT id FROM professions WHERE name = 'Warrior'),
    (SELECT id FROM attributes WHERE name = 'Axe Mastery' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/3/31/Rune_Warrior_Sup.png',
    '{"AttributeBonus":{"value":3,"cumulative":false},"HealthPenalty":{"value":-75,"cumulative":true}}'::jsonb,
    'Axe Mastery +3 (Non-stacking)
Health -75',
    'https://wiki.guildwars.com/wiki/Rune_of_Superior_Axe_Mastery'
  ),
  (
    'Rune of Superior Beast Mastery',
    'armor',
    'rare',
    (SELECT id FROM professions WHERE name = 'Ranger'),
    (SELECT id FROM attributes WHERE name = 'Beast Mastery' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/4/4d/Rune_Ranger_Sup.png',
    '{"AttributeBonus":{"value":3,"cumulative":false},"HealthPenalty":{"value":-75,"cumulative":true}}'::jsonb,
    'Beast Mastery +3 (Non-stacking)
Health -75',
    'https://wiki.guildwars.com/wiki/Rune_of_Superior_Beast_Mastery'
  ),
  (
    'Rune of Superior Blood Magic',
    'armor',
    'rare',
    (SELECT id FROM professions WHERE name = 'Necromancer'),
    (SELECT id FROM attributes WHERE name = 'Blood Magic' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/d/d9/Rune_Necromancer_Sup.png',
    '{"AttributeBonus":{"value":3,"cumulative":false},"HealthPenalty":{"value":-75,"cumulative":true}}'::jsonb,
    'Blood Magic +3 (Non-stacking)
Health -75',
    'https://wiki.guildwars.com/wiki/Rune_of_Superior_Blood_Magic'
  ),
  (
    'Rune of Superior Channeling Magic',
    'armor',
    'rare',
    (SELECT id FROM professions WHERE name = 'Ritualist'),
    (SELECT id FROM attributes WHERE name = 'Channeling Magic' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/1/13/Rune_Ritualist_Sup.png',
    '{"AttributeBonus":{"value":3,"cumulative":false},"HealthPenalty":{"value":-75,"cumulative":true}}'::jsonb,
    'Channeling Magic +3 (Non-stacking)
Health -75',
    'https://wiki.guildwars.com/wiki/Rune_of_Superior_Channeling_Magic'
  ),
  (
    'Rune of Superior Command',
    'armor',
    'rare',
    (SELECT id FROM professions WHERE name = 'Paragon'),
    (SELECT id FROM attributes WHERE name = 'Command' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/3/35/Rune_Paragon_Sup.png',
    '{"AttributeBonus":{"value":3,"cumulative":false},"HealthPenalty":{"value":-75,"cumulative":true}}'::jsonb,
    'Command +3 (Non-stacking)
Health -75',
    'https://wiki.guildwars.com/wiki/Rune_of_Superior_Command'
  ),
  (
    'Rune of Superior Communing',
    'armor',
    'rare',
    (SELECT id FROM professions WHERE name = 'Ritualist'),
    (SELECT id FROM attributes WHERE name = 'Communing' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/1/13/Rune_Ritualist_Sup.png',
    '{"AttributeBonus":{"value":3,"cumulative":false},"HealthPenalty":{"value":-75,"cumulative":true}}'::jsonb,
    'Communing +3 (Non-stacking)
Health -75',
    'https://wiki.guildwars.com/wiki/Rune_of_Superior_Communing'
  ),
  (
    'Rune of Superior Critical Strikes',
    'armor',
    'rare',
    (SELECT id FROM professions WHERE name = 'Assassin'),
    (SELECT id FROM attributes WHERE name = 'Critical Strikes' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/7/75/Rune_Assassin_Sup.png',
    '{"AttributeBonus":{"value":3,"cumulative":false},"HealthPenalty":{"value":-75,"cumulative":true}}'::jsonb,
    'Critical Strikes +3 (Non-stacking)
Health -75',
    'https://wiki.guildwars.com/wiki/Rune_of_Superior_Critical_Strikes'
  ),
  (
    'Rune of Superior Curses',
    'armor',
    'rare',
    (SELECT id FROM professions WHERE name = 'Necromancer'),
    (SELECT id FROM attributes WHERE name = 'Curses' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/d/d9/Rune_Necromancer_Sup.png',
    '{"AttributeBonus":{"value":3,"cumulative":false},"HealthPenalty":{"value":-75,"cumulative":true}}'::jsonb,
    'Curses +3 (Non-stacking)
Health -75',
    'https://wiki.guildwars.com/wiki/Rune_of_Superior_Curses'
  ),
  (
    'Rune of Superior Dagger Mastery',
    'armor',
    'rare',
    (SELECT id FROM professions WHERE name = 'Assassin'),
    (SELECT id FROM attributes WHERE name = 'Dagger Mastery' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/7/75/Rune_Assassin_Sup.png',
    '{"AttributeBonus":{"value":3,"cumulative":false},"HealthPenalty":{"value":-75,"cumulative":true}}'::jsonb,
    'Dagger Mastery +3 (Non-stacking)
Health -75',
    'https://wiki.guildwars.com/wiki/Rune_of_Superior_Dagger_Mastery'
  ),
  (
    'Rune of Superior Deadly Arts',
    'armor',
    'rare',
    (SELECT id FROM professions WHERE name = 'Assassin'),
    (SELECT id FROM attributes WHERE name = 'Deadly Arts' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/7/75/Rune_Assassin_Sup.png',
    '{"AttributeBonus":{"value":3,"cumulative":false},"HealthPenalty":{"value":-75,"cumulative":true}}'::jsonb,
    'Deadly Arts +3 (Non-stacking)
Health -75',
    'https://wiki.guildwars.com/wiki/Rune_of_Superior_Deadly_Arts'
  ),
  (
    'Rune of Superior Death Magic',
    'armor',
    'rare',
    (SELECT id FROM professions WHERE name = 'Necromancer'),
    (SELECT id FROM attributes WHERE name = 'Death Magic' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/d/d9/Rune_Necromancer_Sup.png',
    '{"AttributeBonus":{"value":3,"cumulative":false},"HealthPenalty":{"value":-75,"cumulative":true}}'::jsonb,
    'Death Magic +3 (Non-stacking)
Health -75',
    'https://wiki.guildwars.com/wiki/Rune_of_Superior_Death_Magic'
  ),
  (
    'Rune of Superior Divine Favor',
    'armor',
    'rare',
    (SELECT id FROM professions WHERE name = 'Monk'),
    (SELECT id FROM attributes WHERE name = 'Divine Favor' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/e/e5/Rune_Monk_Sup.png',
    '{"AttributeBonus":{"value":3,"cumulative":false},"HealthPenalty":{"value":-75,"cumulative":true}}'::jsonb,
    'Divine Favor +3 (Non-stacking)
Health -75',
    'https://wiki.guildwars.com/wiki/Rune_of_Superior_Divine_Favor'
  ),
  (
    'Rune of Superior Domination Magic',
    'armor',
    'rare',
    (SELECT id FROM professions WHERE name = 'Mesmer'),
    (SELECT id FROM attributes WHERE name = 'Domination Magic' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/0/08/Rune_Mesmer_Sup.png',
    '{"AttributeBonus":{"value":3,"cumulative":false},"HealthPenalty":{"value":-75,"cumulative":true}}'::jsonb,
    'Domination Magic +3 (Non-stacking)
Health -75',
    'https://wiki.guildwars.com/wiki/Rune_of_Superior_Domination_Magic'
  ),
  (
    'Rune of Superior Earth Magic',
    'armor',
    'rare',
    (SELECT id FROM professions WHERE name = 'Elementalist'),
    (SELECT id FROM attributes WHERE name = 'Earth Magic' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/8/83/Rune_Elementalist_Sup.png',
    '{"AttributeBonus":{"value":3,"cumulative":false},"HealthPenalty":{"value":-75,"cumulative":true}}'::jsonb,
    'Earth Magic +3 (Non-stacking)
Health -75',
    'https://wiki.guildwars.com/wiki/Rune_of_Superior_Earth_Magic'
  ),
  (
    'Rune of Superior Earth Prayers',
    'armor',
    'rare',
    (SELECT id FROM professions WHERE name = 'Dervish'),
    (SELECT id FROM attributes WHERE name = 'Earth Prayers' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/e/e1/Rune_Dervish_Sup.png',
    '{"AttributeBonus":{"value":3,"cumulative":false},"HealthPenalty":{"value":-75,"cumulative":true}}'::jsonb,
    'Earth Prayers +3 (Non-stacking)
Health -75',
    'https://wiki.guildwars.com/wiki/Rune_of_Superior_Earth_Prayers'
  ),
  (
    'Rune of Superior Energy Storage',
    'armor',
    'rare',
    (SELECT id FROM professions WHERE name = 'Elementalist'),
    (SELECT id FROM attributes WHERE name = 'Energy Storage' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/8/83/Rune_Elementalist_Sup.png',
    '{"AttributeBonus":{"value":3,"cumulative":false},"HealthPenalty":{"value":-75,"cumulative":true}}'::jsonb,
    'Energy Storage +3 (Non-stacking)
Health -75',
    'https://wiki.guildwars.com/wiki/Rune_of_Superior_Energy_Storage'
  ),
  (
    'Rune of Superior Expertise',
    'armor',
    'rare',
    (SELECT id FROM professions WHERE name = 'Ranger'),
    (SELECT id FROM attributes WHERE name = 'Expertise' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/4/4d/Rune_Ranger_Sup.png',
    '{"AttributeBonus":{"value":3,"cumulative":false},"HealthPenalty":{"value":-75,"cumulative":true}}'::jsonb,
    'Expertise +3 (Non-stacking)
Health -75',
    'https://wiki.guildwars.com/wiki/Rune_of_Superior_Expertise'
  ),
  (
    'Rune of Superior Fast Casting',
    'armor',
    'rare',
    (SELECT id FROM professions WHERE name = 'Mesmer'),
    (SELECT id FROM attributes WHERE name = 'Fast Casting' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/0/08/Rune_Mesmer_Sup.png',
    '{"AttributeBonus":{"value":3,"cumulative":false},"HealthPenalty":{"value":-75,"cumulative":true}}'::jsonb,
    'Fast Casting +3 (Non-stacking)
Health -75',
    'https://wiki.guildwars.com/wiki/Rune_of_Superior_Fast_Casting'
  ),
  (
    'Rune of Superior Fire Magic',
    'armor',
    'rare',
    (SELECT id FROM professions WHERE name = 'Elementalist'),
    (SELECT id FROM attributes WHERE name = 'Fire Magic' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/8/83/Rune_Elementalist_Sup.png',
    '{"AttributeBonus":{"value":3,"cumulative":false},"HealthPenalty":{"value":-75,"cumulative":true}}'::jsonb,
    'Fire Magic +3 (Non-stacking)
Health -75',
    'https://wiki.guildwars.com/wiki/Rune_of_Superior_Fire_Magic'
  ),
  (
    'Rune of Superior Hammer Mastery',
    'armor',
    'rare',
    (SELECT id FROM professions WHERE name = 'Warrior'),
    (SELECT id FROM attributes WHERE name = 'Hammer Mastery' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/3/31/Rune_Warrior_Sup.png',
    '{"AttributeBonus":{"value":3,"cumulative":false},"HealthPenalty":{"value":-75,"cumulative":true}}'::jsonb,
    'Hammer Mastery +3 (Non-stacking)
Health -75',
    'https://wiki.guildwars.com/wiki/Rune_of_Superior_Hammer_Mastery'
  ),
  (
    'Rune of Superior Healing Prayers',
    'armor',
    'rare',
    (SELECT id FROM professions WHERE name = 'Monk'),
    (SELECT id FROM attributes WHERE name = 'Healing Prayers' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/e/e5/Rune_Monk_Sup.png',
    '{"AttributeBonus":{"value":3,"cumulative":false},"HealthPenalty":{"value":-75,"cumulative":true}}'::jsonb,
    'Healing Prayers +3 (Non-stacking)
Health -75',
    'https://wiki.guildwars.com/wiki/Rune_of_Superior_Healing_Prayers'
  ),
  (
    'Rune of Superior Illusion Magic',
    'armor',
    'rare',
    (SELECT id FROM professions WHERE name = 'Mesmer'),
    (SELECT id FROM attributes WHERE name = 'Illusion Magic' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/0/08/Rune_Mesmer_Sup.png',
    '{"AttributeBonus":{"value":3,"cumulative":false},"HealthPenalty":{"value":-75,"cumulative":true}}'::jsonb,
    'Illusion Magic +3 (Non-stacking)
Health -75',
    'https://wiki.guildwars.com/wiki/Rune_of_Superior_Illusion_Magic'
  ),
  (
    'Rune of Superior Inspiration Magic',
    'armor',
    'rare',
    (SELECT id FROM professions WHERE name = 'Mesmer'),
    (SELECT id FROM attributes WHERE name = 'Inspiration Magic' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/0/08/Rune_Mesmer_Sup.png',
    '{"AttributeBonus":{"value":3,"cumulative":false},"HealthPenalty":{"value":-75,"cumulative":true}}'::jsonb,
    'Inspiration Magic +3 (Non-stacking)
Health -75',
    'https://wiki.guildwars.com/wiki/Rune_of_Superior_Inspiration_Magic'
  ),
  (
    'Rune of Superior Leadership',
    'armor',
    'rare',
    (SELECT id FROM professions WHERE name = 'Paragon'),
    (SELECT id FROM attributes WHERE name = 'Leadership' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/3/35/Rune_Paragon_Sup.png',
    '{"AttributeBonus":{"value":3,"cumulative":false},"HealthPenalty":{"value":-75,"cumulative":true}}'::jsonb,
    'Leadership +3 (Non-stacking)
Health -75',
    'https://wiki.guildwars.com/wiki/Rune_of_Superior_Leadership'
  ),
  (
    'Rune of Superior Marksmanship',
    'armor',
    'rare',
    (SELECT id FROM professions WHERE name = 'Ranger'),
    (SELECT id FROM attributes WHERE name = 'Marksmanship' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/4/4d/Rune_Ranger_Sup.png',
    '{"AttributeBonus":{"value":3,"cumulative":false},"HealthPenalty":{"value":-75,"cumulative":true}}'::jsonb,
    'Marksmanship +3 (Non-stacking)
Health -75',
    'https://wiki.guildwars.com/wiki/Rune_of_Superior_Marksmanship'
  ),
  (
    'Rune of Superior Motivation',
    'armor',
    'rare',
    (SELECT id FROM professions WHERE name = 'Paragon'),
    (SELECT id FROM attributes WHERE name = 'Motivation' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/3/35/Rune_Paragon_Sup.png',
    '{"AttributeBonus":{"value":3,"cumulative":false},"HealthPenalty":{"value":-75,"cumulative":true}}'::jsonb,
    'Motivation +3 (Non-stacking)
Health -75',
    'https://wiki.guildwars.com/wiki/Rune_of_Superior_Motivation'
  ),
  (
    'Rune of Superior Mysticism',
    'armor',
    'rare',
    (SELECT id FROM professions WHERE name = 'Dervish'),
    (SELECT id FROM attributes WHERE name = 'Mysticism' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/e/e1/Rune_Dervish_Sup.png',
    '{"AttributeBonus":{"value":3,"cumulative":false},"HealthPenalty":{"value":-75,"cumulative":true}}'::jsonb,
    'Mysticism +3 (Non-stacking)
Health -75',
    'https://wiki.guildwars.com/wiki/Rune_of_Superior_Mysticism'
  ),
  (
    'Rune of Superior Protection Prayers',
    'armor',
    'rare',
    (SELECT id FROM professions WHERE name = 'Monk'),
    (SELECT id FROM attributes WHERE name = 'Protection Prayers' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/e/e5/Rune_Monk_Sup.png',
    '{"AttributeBonus":{"value":3,"cumulative":false},"HealthPenalty":{"value":-75,"cumulative":true}}'::jsonb,
    'Protection Prayers +3 (Non-stacking)
Health -75',
    'https://wiki.guildwars.com/wiki/Rune_of_Superior_Protection_Prayers'
  ),
  (
    'Rune of Superior Restoration Magic',
    'armor',
    'rare',
    (SELECT id FROM professions WHERE name = 'Ritualist'),
    (SELECT id FROM attributes WHERE name = 'Restoration Magic' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/1/13/Rune_Ritualist_Sup.png',
    '{"AttributeBonus":{"value":3,"cumulative":false},"HealthPenalty":{"value":-75,"cumulative":true}}'::jsonb,
    'Restoration Magic +3 (Non-stacking)
Health -75',
    'https://wiki.guildwars.com/wiki/Rune_of_Superior_Restoration_Magic'
  ),
  (
    'Rune of Superior Scythe Mastery',
    'armor',
    'rare',
    (SELECT id FROM professions WHERE name = 'Dervish'),
    (SELECT id FROM attributes WHERE name = 'Scythe Mastery' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/e/e1/Rune_Dervish_Sup.png',
    '{"AttributeBonus":{"value":3,"cumulative":false},"HealthPenalty":{"value":-75,"cumulative":true}}'::jsonb,
    'Scythe Mastery +3 (Non-stacking)
Health -75',
    'https://wiki.guildwars.com/wiki/Rune_of_Superior_Scythe_Mastery'
  ),
  (
    'Rune of Superior Shadow Arts',
    'armor',
    'rare',
    (SELECT id FROM professions WHERE name = 'Assassin'),
    (SELECT id FROM attributes WHERE name = 'Shadow Arts' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/7/75/Rune_Assassin_Sup.png',
    '{"AttributeBonus":{"value":3,"cumulative":false},"HealthPenalty":{"value":-75,"cumulative":true}}'::jsonb,
    'Shadow Arts +3 (Non-stacking)
Health -75',
    'https://wiki.guildwars.com/wiki/Rune_of_Superior_Shadow_Arts'
  ),
  (
    'Rune of Superior Smiting Prayers',
    'armor',
    'rare',
    (SELECT id FROM professions WHERE name = 'Monk'),
    (SELECT id FROM attributes WHERE name = 'Smiting Prayers' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/e/e5/Rune_Monk_Sup.png',
    '{"AttributeBonus":{"value":3,"cumulative":false},"HealthPenalty":{"value":-75,"cumulative":true}}'::jsonb,
    'Smiting Prayers +3 (Non-stacking)
Health -75',
    'https://wiki.guildwars.com/wiki/Rune_of_Superior_Smiting_Prayers'
  ),
  (
    'Rune of Superior Soul Reaping',
    'armor',
    'rare',
    (SELECT id FROM professions WHERE name = 'Necromancer'),
    (SELECT id FROM attributes WHERE name = 'Soul Reaping' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/d/d9/Rune_Necromancer_Sup.png',
    '{"AttributeBonus":{"value":3,"cumulative":false},"HealthPenalty":{"value":-75,"cumulative":true}}'::jsonb,
    'Soul Reaping +3 (Non-stacking)
Health -75',
    'https://wiki.guildwars.com/wiki/Rune_of_Superior_Soul_Reaping'
  ),
  (
    'Rune of Superior Spawning Power',
    'armor',
    'rare',
    (SELECT id FROM professions WHERE name = 'Ritualist'),
    (SELECT id FROM attributes WHERE name = 'Spawning Power' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/1/13/Rune_Ritualist_Sup.png',
    '{"AttributeBonus":{"value":3,"cumulative":false},"HealthPenalty":{"value":-75,"cumulative":true}}'::jsonb,
    'Spawning Power +3 (Non-stacking)
Health -75',
    'https://wiki.guildwars.com/wiki/Rune_of_Superior_Spawning_Power'
  ),
  (
    'Rune of Superior Spear Mastery',
    'armor',
    'rare',
    (SELECT id FROM professions WHERE name = 'Paragon'),
    (SELECT id FROM attributes WHERE name = 'Spear Mastery' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/3/35/Rune_Paragon_Sup.png',
    '{"AttributeBonus":{"value":3,"cumulative":false},"HealthPenalty":{"value":-75,"cumulative":true}}'::jsonb,
    'Spear Mastery +3 (Non-stacking)
Health -75',
    'https://wiki.guildwars.com/wiki/Rune_of_Superior_Spear_Mastery'
  ),
  (
    'Rune of Superior Strength',
    'armor',
    'rare',
    (SELECT id FROM professions WHERE name = 'Warrior'),
    (SELECT id FROM attributes WHERE name = 'Strength' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/3/31/Rune_Warrior_Sup.png',
    '{"AttributeBonus":{"value":3,"cumulative":false},"HealthPenalty":{"value":-75,"cumulative":true}}'::jsonb,
    'Strength +3 (Non-stacking)
Health -75',
    'https://wiki.guildwars.com/wiki/Rune_of_Superior_Strength'
  ),
  (
    'Rune of Superior Swordsmanship',
    'armor',
    'rare',
    (SELECT id FROM professions WHERE name = 'Warrior'),
    (SELECT id FROM attributes WHERE name = 'Swordsmanship' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/3/31/Rune_Warrior_Sup.png',
    '{"AttributeBonus":{"value":3,"cumulative":false},"HealthPenalty":{"value":-75,"cumulative":true}}'::jsonb,
    'Swordsmanship +3 (Non-stacking)
Health -75',
    'https://wiki.guildwars.com/wiki/Rune_of_Superior_Swordsmanship'
  ),
  (
    'Rune of Superior Tactics',
    'armor',
    'rare',
    (SELECT id FROM professions WHERE name = 'Warrior'),
    (SELECT id FROM attributes WHERE name = 'Tactics' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/3/31/Rune_Warrior_Sup.png',
    '{"AttributeBonus":{"value":3,"cumulative":false},"HealthPenalty":{"value":-75,"cumulative":true}}'::jsonb,
    'Tactics +3 (Non-stacking)
Health -75',
    'https://wiki.guildwars.com/wiki/Rune_of_Superior_Tactics'
  ),
  (
    'Rune of Superior Vigor',
    'armor',
    'rare',
    NULL,
    NULL,
    'https://wiki.guildwars.com/images/9/9e/Rune_All_Sup.png',
    '{"HealthBonus":{"value":50,"cumulative":false}}'::jsonb,
    'Health +50 (Non-stacking)',
    'https://wiki.guildwars.com/wiki/Rune_of_Superior_Vigor'
  ),
  (
    'Rune of Superior Water Magic',
    'armor',
    'rare',
    (SELECT id FROM professions WHERE name = 'Elementalist'),
    (SELECT id FROM attributes WHERE name = 'Water Magic' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/8/83/Rune_Elementalist_Sup.png',
    '{"AttributeBonus":{"value":3,"cumulative":false},"HealthPenalty":{"value":-75,"cumulative":true}}'::jsonb,
    'Water Magic +3 (Non-stacking)
Health -75',
    'https://wiki.guildwars.com/wiki/Rune_of_Superior_Water_Magic'
  ),
  (
    'Rune of Superior Wilderness Survival',
    'armor',
    'rare',
    (SELECT id FROM professions WHERE name = 'Ranger'),
    (SELECT id FROM attributes WHERE name = 'Wilderness Survival' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/4/4d/Rune_Ranger_Sup.png',
    '{"AttributeBonus":{"value":3,"cumulative":false},"HealthPenalty":{"value":-75,"cumulative":true}}'::jsonb,
    'Wilderness Survival +3 (Non-stacking)
Health -75',
    'https://wiki.guildwars.com/wiki/Rune_of_Superior_Wilderness_Survival'
  ),
  (
    'Rune of Superior Wind Prayers',
    'armor',
    'rare',
    (SELECT id FROM professions WHERE name = 'Dervish'),
    (SELECT id FROM attributes WHERE name = 'Wind Prayers' AND profession_id IS NOT NULL LIMIT 1),
    'https://wiki.guildwars.com/images/e/e1/Rune_Dervish_Sup.png',
    '{"AttributeBonus":{"value":3,"cumulative":false},"HealthPenalty":{"value":-75,"cumulative":true}}'::jsonb,
    'Wind Prayers +3 (Non-stacking)
Health -75',
    'https://wiki.guildwars.com/wiki/Rune_of_Superior_Wind_Prayers'
  ),
  (
    'Rune of Vitae',
    'armor',
    'common',
    NULL,
    NULL,
    'https://wiki.guildwars.com/images/f/fb/Rune_All_Minor.png',
    '{"HealthBonus":{"value":10,"cumulative":true}}'::jsonb,
    'Health +10',
    'https://wiki.guildwars.com/wiki/Rune_of_Vitae'
  ),
  (
    'Superior Rune of Holding',
    'inventory',
    'rare',
    NULL,
    NULL,
    'https://wiki.guildwars.com/images/f/f2/Superior_Rune_of_Holding.png',
    '{"BagSlots":{"value":15,"cumulative":false}}'::jsonb,
    'Upgrades bag carrying capacity by +15 slots',
    'https://wiki.guildwars.com/wiki/Superior_Rune_of_Holding'
  ),
  (
    'Warrior Rune of Major Absorption',
    'armor',
    'uncommon',
    (SELECT id FROM professions WHERE name = 'Warrior'),
    NULL,
    'https://wiki.guildwars.com/images/4/46/Rune_Warrior_Major.png',
    '{"DamageReduction":{"value":2,"cumulative":false}}'::jsonb,
    'Reduces physical damage by 2 (Non-stacking)',
    'https://wiki.guildwars.com/wiki/Warrior_Rune_of_Major_Absorption'
  ),
  (
    'Warrior Rune of Minor Absorption',
    'armor',
    'common',
    (SELECT id FROM professions WHERE name = 'Warrior'),
    NULL,
    'https://wiki.guildwars.com/images/2/2f/Rune_Warrior_Minor.png',
    '{"DamageReduction":{"value":1,"cumulative":false}}'::jsonb,
    'Reduces physical damage by 1 (Non-stacking)',
    'https://wiki.guildwars.com/wiki/Warrior_Rune_of_Minor_Absorption'
  ),
  (
    'Warrior Rune of Superior Absorption',
    'armor',
    'rare',
    (SELECT id FROM professions WHERE name = 'Warrior'),
    NULL,
    'https://wiki.guildwars.com/images/3/31/Rune_Warrior_Sup.png',
    '{"DamageReduction":{"value":3,"cumulative":false}}'::jsonb,
    'Reduces physical damage by 3 (Non-stacking)',
    'https://wiki.guildwars.com/wiki/Warrior_Rune_of_Superior_Absorption'
  )
ON CONFLICT (name) DO UPDATE SET
  type = EXCLUDED.type,
  rarity = EXCLUDED.rarity,
  profession_id = EXCLUDED.profession_id,
  attribute_id = EXCLUDED.attribute_id,
  icon = EXCLUDED.icon,
  effects = EXCLUDED.effects,
  description = EXCLUDED.description,
  wiki_url = EXCLUDED.wiki_url;
