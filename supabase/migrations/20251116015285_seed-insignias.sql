-- Seed insignias
-- Auto-generated from data/insignias.json
-- Generated: 2025-11-17T08:55:35.818Z
-- Total insignias: 45

INSERT INTO insignias (name, profession_id, requirements, effects, description, wiki_url, icon)
VALUES
  (
    'Aeromancer Insignia',
    (SELECT id FROM professions WHERE name = 'Elementalist'),
    '{}'::jsonb,
    '{"ArmorBonus":{"value":10,"cumulative":false},"ArmorBonusVsElemental":{"value":10,"cumulative":false}}'::jsonb,
    'Armor +10 (vs. elemental damage){{br}}Armor +10 (vs. Lightning damage)',
    'https://wiki.guildwars.com/wiki/Aeromancer_Insignia',
    'https://wiki.guildwars.com/images/f/f3/Aeromancer_Insignia.png'
  ),
  (
    'Anchorite''s Insignia',
    (SELECT id FROM professions WHERE name = 'Monk'),
    '{}'::jsonb,
    '{"ArmorBonus":{"value":5,"cumulative":false}}'::jsonb,
    'Armor +5 (while recharging 1 or more skills){{br}}Armor +5 (while recharging 3 or more skills){{br}}Armor +5 (while recharging 5 or more skills)',
    'https://wiki.guildwars.com/wiki/Anchorite%27s_Insignia',
    'https://wiki.guildwars.com/images/2/2c/Anchorite%27s_Insignia.png'
  ),
  (
    'Artificer''s Insignia',
    (SELECT id FROM professions WHERE name = 'Mesmer'),
    '{}'::jsonb,
    '{"ArmorBonus":{"value":3,"cumulative":false}}'::jsonb,
    'Armor +3 (for each equipped Signet)',
    'https://wiki.guildwars.com/wiki/Artificer%27s_Insignia',
    'https://wiki.guildwars.com/images/f/fd/Artificer%27s_Insignia.png'
  ),
  (
    'Beastmaster''s Insignia',
    (SELECT id FROM professions WHERE name = 'Ranger'),
    '{}'::jsonb,
    '{"ArmorBonusWhilePetAlive":{"value":10,"cumulative":false}}'::jsonb,
    'Armor +10 (while your pet is alive)',
    'https://wiki.guildwars.com/wiki/Beastmaster%27s_Insignia',
    'https://wiki.guildwars.com/images/d/d3/Beastmaster%27s_Insignia.png'
  ),
  (
    'Blessed Insignia',
    NULL,
    '{}'::jsonb,
    '{"ArmorBonus":{"value":10,"cumulative":false}}'::jsonb,
    'Armor +10 (while affected by an Enchantment Spell)',
    'https://wiki.guildwars.com/wiki/Blessed_Insignia',
    'https://wiki.guildwars.com/images/f/ff/Blessed_Insignia.png'
  ),
  (
    'Blighter''s Insignia',
    (SELECT id FROM professions WHERE name = 'Necromancer'),
    '{}'::jsonb,
    '{"ArmorBonus":{"value":20,"cumulative":false}}'::jsonb,
    'Armor +20 (while affected by a Hex Spell)',
    'https://wiki.guildwars.com/wiki/Blighter%27s_Insignia',
    'https://wiki.guildwars.com/images/d/d7/Blighter%27s_Insignia.png'
  ),
  (
    'Bloodstained Insignia',
    (SELECT id FROM professions WHERE name = 'Necromancer'),
    '{}'::jsonb,
    '{"CastingTimeReductionCorpseSpells":{"value":0.25,"cumulative":false}}'::jsonb,
    'Reduces casting time of spells {{br}}that exploit corpses by 25% (Non-stacking)',
    'https://wiki.guildwars.com/wiki/Bloodstained_Insignia',
    'https://wiki.guildwars.com/images/8/88/Bloodstained_Insignia.png'
  ),
  (
    'Bonelace Insignia',
    (SELECT id FROM professions WHERE name = 'Necromancer'),
    '{}'::jsonb,
    '{"ArmorBonus":{"value":15,"cumulative":false}}'::jsonb,
    'Armor +15 (vs. Piercing damage)',
    'https://wiki.guildwars.com/wiki/Bonelace_Insignia',
    'https://wiki.guildwars.com/images/c/c5/Bonelace_Insignia.png'
  ),
  (
    'Brawler''s Insignia',
    NULL,
    '{}'::jsonb,
    '{"ArmorBonus":{"value":10,"cumulative":false}}'::jsonb,
    'Armor +10 (while attacking)',
    'https://wiki.guildwars.com/wiki/Brawler%27s_Insignia',
    'https://wiki.guildwars.com/images/a/a2/Brawler%27s_Insignia.png'
  ),
  (
    'Centurion''s Insignia',
    (SELECT id FROM professions WHERE name = 'Elementalist'),
    '{}'::jsonb,
    '{"ArmorBonusWhileShoutEchoChant":{"value":10,"cumulative":false}}'::jsonb,
    'Armor +10 (while affected by a Shout, Echo, or Chant)',
    'https://wiki.guildwars.com/wiki/Centurion%27s_Insignia',
    'https://wiki.guildwars.com/images/9/91/Centurion%27s_Insignia.png'
  ),
  (
    'Disciple''s Insignia',
    (SELECT id FROM professions WHERE name = 'Monk'),
    '{}'::jsonb,
    '{"ArmorBonus":{"value":15,"cumulative":false}}'::jsonb,
    'Armor +15 (while affected by a Condition)',
    'https://wiki.guildwars.com/wiki/Disciple%27s_Insignia',
    'https://wiki.guildwars.com/images/d/df/Disciple%27s_Insignia.png'
  ),
  (
    'Dreadnought Insignia',
    (SELECT id FROM professions WHERE name = 'Warrior'),
    '{}'::jsonb,
    '{"ArmorBonus":{"value":10,"cumulative":false}}'::jsonb,
    'Armor +10 (vs. elemental damage)',
    'https://wiki.guildwars.com/wiki/Dreadnought_Insignia',
    'https://wiki.guildwars.com/images/c/ce/Dreadnought_Insignia.png'
  ),
  (
    'Earthbound Insignia',
    (SELECT id FROM professions WHERE name = 'Ranger'),
    '{}'::jsonb,
    '{"ArmorBonus":{"value":15,"cumulative":false}}'::jsonb,
    'Armor +15 (vs. Earth damage)',
    'https://wiki.guildwars.com/wiki/Earthbound_Insignia',
    'https://wiki.guildwars.com/images/a/a3/Earthbound_Insignia.png'
  ),
  (
    'Forsaken Insignia',
    (SELECT id FROM professions WHERE name = 'Elementalist'),
    '{}'::jsonb,
    '{"ArmorBonusWhileNotEnchanted":{"value":10,"cumulative":false}}'::jsonb,
    'Armor +10 (while not affected by an Enchantment Spell)',
    'https://wiki.guildwars.com/wiki/Forsaken_Insignia',
    'https://wiki.guildwars.com/images/1/13/Forsaken_Insignia.png'
  ),
  (
    'Frostbound Insignia',
    (SELECT id FROM professions WHERE name = 'Ranger'),
    '{}'::jsonb,
    '{"ArmorBonus":{"value":15,"cumulative":false}}'::jsonb,
    'Armor +15 (vs. Cold damage)',
    'https://wiki.guildwars.com/wiki/Frostbound_Insignia',
    'https://wiki.guildwars.com/images/9/91/Frostbound_Insignia.png'
  ),
  (
    'Geomancer Insignia',
    (SELECT id FROM professions WHERE name = 'Elementalist'),
    '{}'::jsonb,
    '{"ArmorBonus":{"value":10,"cumulative":false},"ArmorBonusVsElemental":{"value":10,"cumulative":false}}'::jsonb,
    'Armor +10 (vs. elemental damage){{br}}Armor +10 (vs. Earth damage)',
    'https://wiki.guildwars.com/wiki/Geomancer_Insignia',
    'https://wiki.guildwars.com/images/3/35/Geomancer_Insignia.png'
  ),
  (
    'Ghost Forge Insignia',
    (SELECT id FROM professions WHERE name = 'Elementalist'),
    '{}'::jsonb,
    '{"ArmorBonus":{"value":15,"cumulative":false}}'::jsonb,
    'Armor +15 (while affected by a Weapon Spell)',
    'https://wiki.guildwars.com/wiki/Ghost_Forge_Insignia',
    'https://wiki.guildwars.com/images/2/2b/Ghost_Forge_Insignia.png'
  ),
  (
    'Herald''s Insignia',
    NULL,
    '{}'::jsonb,
    '{"ArmorBonus":{"value":10,"cumulative":false}}'::jsonb,
    'Armor +10 (while holding an item)',
    'https://wiki.guildwars.com/wiki/Herald%27s_Insignia',
    'https://wiki.guildwars.com/images/9/96/Herald%27s_Insignia.png'
  ),
  (
    'Hydromancer Insignia',
    (SELECT id FROM professions WHERE name = 'Elementalist'),
    '{}'::jsonb,
    '{"ArmorBonus":{"value":10,"cumulative":false},"ArmorBonusVsElemental":{"value":10,"cumulative":false}}'::jsonb,
    'Armor +10 (vs. elemental damage){{br}}Armor +10 (vs. Cold damage)',
    'https://wiki.guildwars.com/wiki/Hydromancer_Insignia',
    'https://wiki.guildwars.com/images/b/be/Hydromancer_Insignia.png'
  ),
  (
    'Infiltrator''s Insignia',
    (SELECT id FROM professions WHERE name = 'Elementalist'),
    '{}'::jsonb,
    '{"ArmorBonus":{"value":10,"cumulative":false},"ArmorBonusVsPhysical":{"value":10,"cumulative":false}}'::jsonb,
    'Armor +10 (vs. physical damage){{br}}Armor +10 (vs. Piercing damage)',
    'https://wiki.guildwars.com/wiki/Infiltrator%27s_Insignia',
    'https://wiki.guildwars.com/images/9/9a/Infiltrator%27s_Insignia.png'
  ),
  (
    'Knight''s Insignia',
    (SELECT id FROM professions WHERE name = 'Warrior'),
    '{}'::jsonb,
    '{"PhysicalDamageReduction":{"value":3,"cumulative":false}}'::jsonb,
    'Received physical damage -3',
    'https://wiki.guildwars.com/wiki/Knight%27s_Insignia',
    'https://wiki.guildwars.com/images/7/79/Knight%27s_Insignia.png'
  ),
  (
    'Lieutenant''s Insignia',
    (SELECT id FROM professions WHERE name = 'Warrior'),
    '{}'::jsonb,
    '{"ArmorPenalty":{"value":-20,"cumulative":false},"HexDurationReduction":{"value":0.2,"cumulative":false},"DamagePenalty":{"value":0.05,"cumulative":false}}'::jsonb,
    'Reduces Hex durations on you by 20% {{br}}and damage dealt by you by 5% (Non-stacking){{br}}Armor -20',
    'https://wiki.guildwars.com/wiki/Lieutenant%27s_Insignia',
    'https://wiki.guildwars.com/images/5/57/Lieutenant%27s_Insignia.png'
  ),
  (
    'Minion Master''s Insignia',
    (SELECT id FROM professions WHERE name = 'Necromancer'),
    '{}'::jsonb,
    '{"ArmorBonus":{"value":5,"cumulative":false}}'::jsonb,
    'Armor +5 (while you control 1 or more minions){{br}}Armor +5 (while you control 3 or more minions){{br}}Armor +5 (while you control 5 or more minions)',
    'https://wiki.guildwars.com/wiki/Minion_Master%27s_Insignia',
    'https://wiki.guildwars.com/images/8/81/Minion_Master%27s_Insignia.png'
  ),
  (
    'Mystic''s Insignia',
    (SELECT id FROM professions WHERE name = 'Elementalist'),
    '{}'::jsonb,
    '{"ArmorBonus":{"value":15,"cumulative":false}}'::jsonb,
    'Armor +15 (while activating skills)',
    'https://wiki.guildwars.com/wiki/Mystic%27s_Insignia',
    'https://wiki.guildwars.com/images/1/10/Mystic%27s_Insignia.png'
  ),
  (
    'Nightstalker''s Insignia',
    (SELECT id FROM professions WHERE name = 'Elementalist'),
    '{}'::jsonb,
    '{"ArmorBonusWhileAttacking":{"value":15,"cumulative":false}}'::jsonb,
    'Armor +15 (while attacking)',
    'https://wiki.guildwars.com/wiki/Nightstalker%27s_Insignia',
    'https://wiki.guildwars.com/images/a/a1/Nightstalker%27s_Insignia.png'
  ),
  (
    'Prismatic Insignia',
    (SELECT id FROM professions WHERE name = 'Elementalist'),
    '{}'::jsonb,
    '{"ArmorBonus":{"value":5,"cumulative":false}}'::jsonb,
    'Armor +5 (requires 9 Air Magic){{br}}Armor +5 (requires 9 Earth Magic){{br}}Armor +5 (requires 9 Fire Magic){{br}}Armor +5 (requires 9 Water Magic)',
    'https://wiki.guildwars.com/wiki/Prismatic_Insignia',
    'https://wiki.guildwars.com/images/f/f8/Prismatic_Insignia.png'
  ),
  (
    'Prodigy''s Insignia',
    (SELECT id FROM professions WHERE name = 'Mesmer'),
    '{}'::jsonb,
    '{"ArmorBonus":{"value":5,"cumulative":false}}'::jsonb,
    'Armor +5 (while recharging 1 or more skills){{br}}Armor +5 (while recharging 3 or more skills){{br}}Armor +5 (while recharging 5 or more skills)',
    'https://wiki.guildwars.com/wiki/Prodigy%27s_Insignia',
    'https://wiki.guildwars.com/images/7/72/Prodigy%27s_Insignia.png'
  ),
  (
    'Pyrebound Insignia',
    (SELECT id FROM professions WHERE name = 'Ranger'),
    '{}'::jsonb,
    '{"ArmorBonus":{"value":15,"cumulative":false}}'::jsonb,
    'Armor +15 (vs. Fire damage)',
    'https://wiki.guildwars.com/wiki/Pyrebound_Insignia',
    'https://wiki.guildwars.com/images/7/7c/Pyrebound_Insignia.png'
  ),
  (
    'Pyromancer Insignia',
    (SELECT id FROM professions WHERE name = 'Elementalist'),
    '{}'::jsonb,
    '{"ArmorBonus":{"value":10,"cumulative":false},"ArmorBonusVsElemental":{"value":10,"cumulative":false}}'::jsonb,
    'Armor +10 (vs. elemental damage){{br}}Armor +10 (vs. Fire damage)',
    'https://wiki.guildwars.com/wiki/Pyromancer_Insignia',
    'https://wiki.guildwars.com/images/4/4f/Pyromancer_Insignia.png'
  ),
  (
    'Radiant Insignia',
    NULL,
    '{}'::jsonb,
    '{"EnergyBonus":{"value":{"chest":3,"leg":2,"other":1},"cumulative":true}}'::jsonb,
    'Energy +3 (on chest armor){{br}}Energy +2 (on leg armor){{br}}Energy +1 (on other armor)',
    'https://wiki.guildwars.com/wiki/Radiant_Insignia',
    'https://wiki.guildwars.com/images/0/00/Radiant_Insignia.png'
  ),
  (
    'Saboteur''s Insignia',
    (SELECT id FROM professions WHERE name = 'Elementalist'),
    '{}'::jsonb,
    '{"ArmorBonus":{"value":10,"cumulative":false},"ArmorBonusVsPhysical":{"value":10,"cumulative":false}}'::jsonb,
    'Armor +10 (vs. physical damage){{br}}Armor +10 (vs. Slashing damage)',
    'https://wiki.guildwars.com/wiki/Saboteur%27s_Insignia',
    'https://wiki.guildwars.com/images/6/6c/Saboteur%27s_Insignia.png'
  ),
  (
    'Scout''s Insignia',
    (SELECT id FROM professions WHERE name = 'Ranger'),
    '{}'::jsonb,
    '{"ArmorBonus":{"value":10,"cumulative":false}}'::jsonb,
    'Armor +10 (while using a Preparation)',
    'https://wiki.guildwars.com/wiki/Scout%27s_Insignia',
    'https://wiki.guildwars.com/images/1/15/Scout%27s_Insignia.png'
  ),
  (
    'Sentinel''s Insignia',
    (SELECT id FROM professions WHERE name = 'Warrior'),
    '{"attribute":"Strength","value":13}'::jsonb,
    '{"ArmorBonus":{"value":20,"cumulative":false}}'::jsonb,
    'Armor +20 (Requires 13 Strength, vs. elemental damage)',
    'https://wiki.guildwars.com/wiki/Sentinel%27s_Insignia',
    'https://wiki.guildwars.com/images/1/1e/Sentinel%27s_Insignia.png'
  ),
  (
    'Sentry''s Insignia',
    NULL,
    '{}'::jsonb,
    '{"ArmorBonus":{"value":10,"cumulative":false}}'::jsonb,
    'Armor +10 (while in a stance)',
    'https://wiki.guildwars.com/wiki/Sentry%27s_Insignia',
    'https://wiki.guildwars.com/images/a/a3/Sentry%27s_Insignia.png'
  ),
  (
    'Shaman''s Insignia',
    (SELECT id FROM professions WHERE name = 'Elementalist'),
    '{}'::jsonb,
    '{"ArmorBonus":{"value":5,"cumulative":false}}'::jsonb,
    'Armor +5 (while you control 1 or more Spirits){{br}}Armor +5 (while you control 2 or more Spirits){{br}}Armor +5 (while you control 3 or more Spirits)',
    'https://wiki.guildwars.com/wiki/Shaman%27s_Insignia',
    'https://wiki.guildwars.com/images/d/dc/Shaman%27s_Insignia.png'
  ),
  (
    'Stalwart Insignia',
    NULL,
    '{}'::jsonb,
    '{"ArmorBonus":{"value":10,"cumulative":false}}'::jsonb,
    'Armor +10 (vs. physical damage)',
    'https://wiki.guildwars.com/wiki/Stalwart_Insignia',
    'https://wiki.guildwars.com/images/8/83/Stalwart_Insignia.png'
  ),
  (
    'Stonefist Insignia',
    (SELECT id FROM professions WHERE name = 'Warrior'),
    '{}'::jsonb,
    '{"KnockdownBonus":{"value":1,"cumulative":false}}'::jsonb,
    'Increases knockdown time on foes by 1 second. {{br}}(Maximum: 3 seconds)',
    'https://wiki.guildwars.com/wiki/Stonefist_Insignia',
    'https://wiki.guildwars.com/images/1/1f/Stonefist_Insignia.png'
  ),
  (
    'Stormbound Insignia',
    (SELECT id FROM professions WHERE name = 'Ranger'),
    '{}'::jsonb,
    '{"ArmorBonus":{"value":15,"cumulative":false}}'::jsonb,
    'Armor +15 (vs. Lightning damage)',
    'https://wiki.guildwars.com/wiki/Stormbound_Insignia',
    'https://wiki.guildwars.com/images/6/6a/Stormbound_Insignia.png'
  ),
  (
    'Survivor Insignia',
    NULL,
    '{}'::jsonb,
    '{"HealthBonus":{"value":{"chest":15,"leg":10,"other":5},"cumulative":true}}'::jsonb,
    'Health +15 (on chest armor){{br}}Health +10 (on leg armor){{br}}Health +5 (on other armor)',
    'https://wiki.guildwars.com/wiki/Survivor_Insignia',
    'https://wiki.guildwars.com/images/b/b7/Survivor_Insignia.png'
  ),
  (
    'Tormentor''s Insignia',
    (SELECT id FROM professions WHERE name = 'Necromancer'),
    '{}'::jsonb,
    '{"ArmorBonus":{"value":10,"cumulative":false}}'::jsonb,
    'Holy damage you receive increased by 6 (on chest armor){{br}}Holy damage you receive increased by 4 (on leg armor){{br}}Holy damage you receive increased by 2 (on other armor){{br}}Armor +10',
    'https://wiki.guildwars.com/wiki/Tormentor%27s_Insignia',
    'https://wiki.guildwars.com/images/8/8e/Tormentor%27s_Insignia.png'
  ),
  (
    'Undertaker''s Insignia',
    (SELECT id FROM professions WHERE name = 'Necromancer'),
    '{}'::jsonb,
    '{"ArmorBonus":{"value":5,"cumulative":false}}'::jsonb,
    'Armor +5 (while health is below 80%){{br}}Armor +5 (while health is below 60%){{br}}Armor +5 (while health is below 40%){{br}}Armor +5 (while health is below 20%)',
    'https://wiki.guildwars.com/wiki/Undertaker%27s_Insignia',
    'https://wiki.guildwars.com/images/f/fc/Undertaker%27s_Insignia.png'
  ),
  (
    'Vanguard''s Insignia',
    (SELECT id FROM professions WHERE name = 'Elementalist'),
    '{}'::jsonb,
    '{"ArmorBonusVsPhysical":{"value":10,"cumulative":false}}'::jsonb,
    'Armor +10 (vs. physical damage){{br}}Armor +10 (vs. Blunt damage)',
    'https://wiki.guildwars.com/wiki/Vanguard%27s_Insignia',
    'https://wiki.guildwars.com/images/0/03/Vanguard%27s_Insignia.png'
  ),
  (
    'Virtuoso''s Insignia',
    (SELECT id FROM professions WHERE name = 'Mesmer'),
    '{}'::jsonb,
    '{"ArmorBonus":{"value":15,"cumulative":false}}'::jsonb,
    'Armor +15 (while activating skills)',
    'https://wiki.guildwars.com/wiki/Virtuoso%27s_Insignia',
    'https://wiki.guildwars.com/images/c/cf/Virtuoso%27s_Insignia.png'
  ),
  (
    'Wanderer''s Insignia',
    (SELECT id FROM professions WHERE name = 'Monk'),
    '{}'::jsonb,
    '{"ArmorBonusVsElemental":{"value":10,"cumulative":false}}'::jsonb,
    'Armor +10 (vs. elemental damage)',
    'https://wiki.guildwars.com/wiki/Wanderer%27s_Insignia',
    'https://wiki.guildwars.com/images/c/c1/Wanderer%27s_Insignia.png'
  ),
  (
    'Windwalker Insignia',
    (SELECT id FROM professions WHERE name = 'Elementalist'),
    '{}'::jsonb,
    '{"ArmorBonus":{"value":5,"cumulative":false}}'::jsonb,
    'Armor +5 (while affected by 1 or more Enchantment Spells){{br}}Armor +5 (while affected by 2 or more Enchantment Spells){{br}}Armor +5 (while affected by 3 or more Enchantment Spells){{br}}Armor +5 (while affected by 4 or more Enchantment Spells)',
    'https://wiki.guildwars.com/wiki/Windwalker_Insignia',
    'https://wiki.guildwars.com/images/9/97/Windwalker_Insignia.png'
  )
ON CONFLICT (name) DO UPDATE SET
  profession_id = EXCLUDED.profession_id,
  requirements = EXCLUDED.requirements,
  effects = EXCLUDED.effects,
  description = EXCLUDED.description,
  wiki_url = EXCLUDED.wiki_url,
  icon = EXCLUDED.icon;
