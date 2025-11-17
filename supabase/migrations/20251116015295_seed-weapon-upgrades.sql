-- Seed weapon upgrades
-- Auto-generated from data/weapon_upgrades.json
-- Generated: 2025-11-17T08:01:51.664Z
-- Total weapon upgrades: 130

INSERT INTO weapon_upgrades (name, type, description, attaches_to, release_id, wiki_url, icon, variables)
VALUES
  (
    'Aptitude not Attitude',
    'inscription',
    'Halves casting time of spells of item''s attribute (Chance: {{PlusAttribute}}%)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Aptitude_not_Attitude',
    'https://wiki.guildwars.com/images/f/f0/Inscription_spellcasting_weapons.png',
    '{"PlusAttribute":{"min":10,"max":20}}'::jsonb
  ),
  (
    'Be Just and Fear Not',
    'inscription',
    'Armor +{{PlusArmor}} (while hexed)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Nightfall'),
    'https://wiki.guildwars.com/wiki/Be_Just_and_Fear_Not',
    'https://wiki.guildwars.com/images/5/59/Inscription_focus_items.png',
    '{"PlusArmor":{"min":5,"max":10}}'::jsonb
  ),
  (
    'Brawn over Brains',
    'inscription',
    'Damage +{{PlusDamagePercent}}%Energy -5',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Brawn_over_Brains',
    'https://wiki.guildwars.com/images/2/2e/Inscription_equippable_items.png',
    '{"PlusDamagePercent":{"min":14,"max":15}}'::jsonb
  ),
  (
    'Cast Out the Unclean',
    'inscription',
    'Reduces Disease duration on you by 20% (Stacking)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Nightfall'),
    'https://wiki.guildwars.com/wiki/Cast_Out_the_Unclean',
    'https://wiki.guildwars.com/images/5/59/Inscription_focus_items.png',
    '{}'::jsonb
  ),
  (
    'Dance with Death',
    'inscription',
    'Damage +{{PlusDamagePercent}}% (while in a Stance)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Dance_with_Death',
    'https://wiki.guildwars.com/images/2/2e/Inscription_equippable_items.png',
    '{"PlusDamagePercent":{"min":10,"max":15}}'::jsonb
  ),
  (
    'Don''t Fear the Reaper',
    'inscription',
    'Damage +{{PlusDamagePercent}}% (while Hexed)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Don''t_Fear_the_Reaper',
    'https://wiki.guildwars.com/images/2/2e/Inscription_equippable_items.png',
    '{"PlusDamagePercent":{"min":10,"max":20}}'::jsonb
  ),
  (
    'Don''t Think Twice',
    'inscription',
    'Halves casting time of spells (Chance: {{ChancePercent}}%)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Nightfall'),
    'https://wiki.guildwars.com/wiki/Don''t_Think_Twice',
    'https://wiki.guildwars.com/images/2/2e/Inscription_equippable_items.png',
    '{"ChancePercent":{"min":5,"max":10}}'::jsonb
  ),
  (
    'Don''t call it a comeback!',
    'inscription',
    'Energy +{{PlusEnergy}} (while Health is below 50%)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Nightfall'),
    'https://wiki.guildwars.com/wiki/Don''t_call_it_a_comeback!',
    'https://wiki.guildwars.com/images/f/f0/Inscription_spellcasting_weapons.png',
    '{"PlusEnergy":{"min":5,"max":7}}'::jsonb
  ),
  (
    'Down But Not Out',
    'inscription',
    'Armor +{{PlusArmor}} (while Health is below 50%)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Nightfall'),
    'https://wiki.guildwars.com/wiki/Down_But_Not_Out',
    'https://wiki.guildwars.com/images/5/59/Inscription_focus_items.png',
    '{"PlusArmor":{"min":5,"max":10}}'::jsonb
  ),
  (
    'Faith is My Shield',
    'inscription',
    'Armor +{{PlusArmor}} (while Enchanted)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Faith_is_My_Shield',
    'https://wiki.guildwars.com/images/5/59/Inscription_focus_items.png',
    '{"PlusArmor":{"min":4,"max":5}}'::jsonb
  ),
  (
    'Fear Cuts Deeper',
    'inscription',
    'Reduces Bleeding duration on you by 20% (Stacking)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Nightfall'),
    'https://wiki.guildwars.com/wiki/Fear_Cuts_Deeper',
    'https://wiki.guildwars.com/images/5/59/Inscription_focus_items.png',
    '{}'::jsonb
  ),
  (
    'Forget Me Not',
    'inscription',
    'Halves skill recharge of spells of item''s attribute (Chance: {{PlusAttribute}}%)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Forget_Me_Not',
    'https://wiki.guildwars.com/images/5/59/Inscription_focus_items.png',
    '{"PlusAttribute":{"min":15,"max":20}}'::jsonb
  ),
  (
    'Guided by Fate',
    'inscription',
    'Damage +{{PlusDamagePercent}}% (while Enchanted)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Guided_by_Fate',
    'https://wiki.guildwars.com/images/2/2e/Inscription_equippable_items.png',
    '{"PlusDamagePercent":{"min":10,"max":15}}'::jsonb
  ),
  (
    'Hail to the King',
    'inscription',
    'Armor +{{PlusArmor}} (while Health is above 50%)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Nightfall'),
    'https://wiki.guildwars.com/wiki/Hail_to_the_King',
    'https://wiki.guildwars.com/images/5/59/Inscription_focus_items.png',
    '{"PlusArmor":{"min":4,"max":5}}'::jsonb
  ),
  (
    'Hale and Hearty',
    'inscription',
    'Energy +{{PlusEnergy}} (while Health is above 50%)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Hale_and_Hearty',
    'https://wiki.guildwars.com/images/f/f0/Inscription_spellcasting_weapons.png',
    '{"PlusEnergy":{"min":4,"max":5}}'::jsonb
  ),
  (
    'Have Faith',
    'inscription',
    'Energy +{{PlusEnergy}} (while Enchanted)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Nightfall'),
    'https://wiki.guildwars.com/wiki/Have_Faith',
    'https://wiki.guildwars.com/images/f/f0/Inscription_spellcasting_weapons.png',
    '{"PlusEnergy":{"min":4,"max":5}}'::jsonb
  ),
  (
    'I Can See Clearly Now',
    'inscription',
    'Reduces Blind duration on you by 20% (Stacking)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Nightfall'),
    'https://wiki.guildwars.com/wiki/I_Can_See_Clearly_Now',
    'https://wiki.guildwars.com/images/5/59/Inscription_focus_items.png',
    '{}'::jsonb
  ),
  (
    'I am Sorrow.',
    'inscription',
    'Energy +{{PlusEnergy}} (while Hexed)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Nightfall'),
    'https://wiki.guildwars.com/wiki/I_am_Sorrow.',
    'https://wiki.guildwars.com/images/f/f0/Inscription_spellcasting_weapons.png',
    '{"PlusEnergy":{"min":5,"max":7}}'::jsonb
  ),
  (
    'I have the power!',
    'inscription',
    'Energy +5',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/I_have_the_power!',
    'https://wiki.guildwars.com/images/d/dc/Inscription_martial_weapons.png',
    '{}'::jsonb
  ),
  (
    'Ignorance is Bliss',
    'inscription',
    'Armor +{{PlusArmor}}Energy -5',
    NULL,
    (SELECT id FROM releases WHERE name = 'Nightfall'),
    'https://wiki.guildwars.com/wiki/Ignorance_is_Bliss',
    'https://wiki.guildwars.com/images/5/59/Inscription_focus_items.png',
    '{"PlusArmor":{"min":4,"max":5}}'::jsonb
  ),
  (
    'Knowing is Half the Battle',
    'inscription',
    'Armor +5 (while casting)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Nightfall'),
    'https://wiki.guildwars.com/wiki/Knowing_is_Half_the_Battle',
    'https://wiki.guildwars.com/images/5/59/Inscription_focus_items.png',
    '{}'::jsonb
  ),
  (
    'Leaf on the Wind',
    'inscription',
    'Armor +{{PlusArmor}} (vs. Cold damage)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Nightfall'),
    'https://wiki.guildwars.com/wiki/Leaf_on_the_Wind',
    'https://wiki.guildwars.com/images/5/59/Inscription_focus_items.png',
    '{"PlusArmor":{"min":5,"max":10}}'::jsonb
  ),
  (
    'Let the Memory Live Again',
    'inscription',
    'Halves skill recharge of spells (Chance: {{ChancePercent}}%)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Nightfall'),
    'https://wiki.guildwars.com/wiki/Let_the_Memory_Live_Again',
    'https://wiki.guildwars.com/images/d/dc/Inscription_martial_weapons.png',
    '{"ChancePercent":{"min":5,"max":10}}'::jsonb
  ),
  (
    'Life is Pain',
    'inscription',
    'Armor +{{PlusArmor}}Health -20',
    NULL,
    (SELECT id FROM releases WHERE name = 'Nightfall'),
    'https://wiki.guildwars.com/wiki/Life_is_Pain',
    'https://wiki.guildwars.com/images/5/59/Inscription_focus_items.png',
    '{"PlusArmor":{"min":4,"max":5}}'::jsonb
  ),
  (
    'Like a Rolling Stone',
    'inscription',
    'Armor +{{PlusArmor}} (vs. Earth damage)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Nightfall'),
    'https://wiki.guildwars.com/wiki/Like_a_Rolling_Stone',
    'https://wiki.guildwars.com/images/5/59/Inscription_focus_items.png',
    '{"PlusArmor":{"min":5,"max":10}}'::jsonb
  ),
  (
    'Live for Today',
    'inscription',
    'Energy +{{PlusEnergy}}Energy regeneration -1',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Live_for_Today',
    'https://wiki.guildwars.com/images/5/59/Inscription_focus_items.png',
    '{"PlusEnergy":{"min":10,"max":15}}'::jsonb
  ),
  (
    'Luck of the Draw',
    'inscription',
    'Received physical damage -5 (Chance: {{PlusDamagePercent}}%)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Luck_of_the_Draw',
    'https://wiki.guildwars.com/images/5/59/Inscription_focus_items.png',
    '{"PlusDamagePercent":{"min":11,"max":20}}'::jsonb
  ),
  (
    'Man for All Seasons',
    'inscription',
    'Armor +{{PlusArmor}} (vs. Elemental damage)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Nightfall'),
    'https://wiki.guildwars.com/wiki/Man_for_All_Seasons',
    'https://wiki.guildwars.com/images/5/59/Inscription_focus_items.png',
    '{"PlusArmor":{"min":4,"max":5}}'::jsonb
  ),
  (
    'Master of My Domain!',
    'inscription',
    'Item''s attribute +1 (Chance: {{PlusAttribute}}%)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Master_of_My_Domain!',
    'https://wiki.guildwars.com/images/5/59/Inscription_focus_items.png',
    '{"PlusAttribute":{"min":11,"max":20}}'::jsonb
  ),
  (
    'Measure for Measure',
    'inscription',
    'Highly salvageable',
    NULL,
    (SELECT id FROM releases WHERE name = 'Nightfall'),
    'https://wiki.guildwars.com/wiki/Measure_for_Measure',
    'https://wiki.guildwars.com/images/2/2e/Inscription_equippable_items.png',
    '{}'::jsonb
  ),
  (
    'Might Makes Right',
    'inscription',
    'Armor +{{PlusArmor}} (while attacking)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Nightfall'),
    'https://wiki.guildwars.com/wiki/Might_Makes_Right',
    'https://wiki.guildwars.com/images/5/59/Inscription_focus_items.png',
    '{"PlusArmor":{"min":4,"max":5}}'::jsonb
  ),
  (
    'Not the Face!',
    'inscription',
    'Armor +{{PlusArmor}} (vs. Blunt damage)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Nightfall'),
    'https://wiki.guildwars.com/wiki/Not_the_Face!',
    'https://wiki.guildwars.com/images/5/59/Inscription_focus_items.png',
    '{"PlusArmor":{"min":5,"max":10}}'::jsonb
  ),
  (
    'Nothing to Fear',
    'inscription',
    'Received physical damage -{{ChancePercent}} (while Hexed)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Nothing_to_Fear',
    'https://wiki.guildwars.com/images/5/59/Inscription_focus_items.png',
    '{"ChancePercent":{"min":1,"max":3}}'::jsonb
  ),
  (
    'Only the Strong Survive',
    'inscription',
    'Reduces Weakness duration on you by 20% (Stacking)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Nightfall'),
    'https://wiki.guildwars.com/wiki/Only_the_Strong_Survive',
    'https://wiki.guildwars.com/images/5/59/Inscription_focus_items.png',
    '{}'::jsonb
  ),
  (
    'Pure of Heart',
    'inscription',
    'Reduces Poison duration on you by 20% (Stacking)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Nightfall'),
    'https://wiki.guildwars.com/wiki/Pure_of_Heart',
    'https://wiki.guildwars.com/images/5/59/Inscription_focus_items.png',
    '{}'::jsonb
  ),
  (
    'Riders on the Storm',
    'inscription',
    'Armor +{{PlusArmor}} (vs. Lightning damage)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Nightfall'),
    'https://wiki.guildwars.com/wiki/Riders_on_the_Storm',
    'https://wiki.guildwars.com/images/5/59/Inscription_focus_items.png',
    '{"PlusArmor":{"min":5,"max":10}}'::jsonb
  ),
  (
    'Run For Your Life!',
    'inscription',
    'Received physical damage -{{ChancePercent}} (while in a Stance)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Run_For_Your_Life!',
    'https://wiki.guildwars.com/images/5/59/Inscription_focus_items.png',
    '{"ChancePercent":{"min":1,"max":2}}'::jsonb
  ),
  (
    'Seize the Day',
    'inscription',
    'Energy +{{PlusEnergy}}Energy regeneration -1',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Seize_the_Day',
    'https://wiki.guildwars.com/images/f/f0/Inscription_spellcasting_weapons.png',
    '{"PlusEnergy":{"min":10,"max":15}}'::jsonb
  ),
  (
    'Serenity Now',
    'inscription',
    'Halves skill recharge of spells (Chance: {{ChancePercent}}%)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Serenity_Now',
    'https://wiki.guildwars.com/images/5/59/Inscription_focus_items.png',
    '{"ChancePercent":{"min":7,"max":10}}'::jsonb
  ),
  (
    'Sheltered by Faith',
    'inscription',
    'Received physical damage -{{ChancePercent}} (while Enchanted)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Sheltered_by_Faith',
    'https://wiki.guildwars.com/images/5/59/Inscription_focus_items.png',
    '{"ChancePercent":{"min":1,"max":2}}'::jsonb
  ),
  (
    'Show me the money!',
    'inscription',
    'Improved sale value',
    NULL,
    (SELECT id FROM releases WHERE name = 'Nightfall'),
    'https://wiki.guildwars.com/wiki/Show_me_the_money!',
    'https://wiki.guildwars.com/images/2/2e/Inscription_equippable_items.png',
    '{}'::jsonb
  ),
  (
    'Sleep Now in the Fire',
    'inscription',
    'Armor +{{PlusArmor}} (vs. Fire damage)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Nightfall'),
    'https://wiki.guildwars.com/wiki/Sleep_Now_in_the_Fire',
    'https://wiki.guildwars.com/images/5/59/Inscription_focus_items.png',
    '{"PlusArmor":{"min":5,"max":10}}'::jsonb
  ),
  (
    'Soundness of Mind',
    'inscription',
    'Reduces Dazed duration on you by 20% (Stacking)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Nightfall'),
    'https://wiki.guildwars.com/wiki/Soundness_of_Mind',
    'https://wiki.guildwars.com/images/5/59/Inscription_focus_items.png',
    '{}'::jsonb
  ),
  (
    'Strength and Honor',
    'inscription',
    'Damage +{{PlusDamagePercent}}% (while Health is above 50%)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Strength_and_Honor',
    'https://wiki.guildwars.com/images/2/2e/Inscription_equippable_items.png',
    '{"PlusDamagePercent":{"min":10,"max":15}}'::jsonb
  ),
  (
    'Strength of Body',
    'inscription',
    'Reduces Deep Wound duration on you by 20% (Stacking)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Nightfall'),
    'https://wiki.guildwars.com/wiki/Strength_of_Body',
    'https://wiki.guildwars.com/images/5/59/Inscription_focus_items.png',
    '{}'::jsonb
  ),
  (
    'Survival of the Fittest',
    'inscription',
    'Armor +{{PlusArmor}} (vs. Physical damage)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Nightfall'),
    'https://wiki.guildwars.com/wiki/Survival_of_the_Fittest',
    'https://wiki.guildwars.com/images/5/59/Inscription_focus_items.png',
    '{"PlusArmor":{"min":4,"max":5}}'::jsonb
  ),
  (
    'Swift as the Wind',
    'inscription',
    'Reduces Crippled duration on you by 20% (Stacking)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Nightfall'),
    'https://wiki.guildwars.com/wiki/Swift_as_the_Wind',
    'https://wiki.guildwars.com/images/5/59/Inscription_focus_items.png',
    '{}'::jsonb
  ),
  (
    'The Riddle of Steel',
    'inscription',
    'Armor +{{PlusArmor}} (vs. Slashing damage)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Nightfall'),
    'https://wiki.guildwars.com/wiki/The_Riddle_of_Steel',
    'https://wiki.guildwars.com/images/5/59/Inscription_focus_items.png',
    '{"PlusArmor":{"min":5,"max":10}}'::jsonb
  ),
  (
    'Through Thick and Thin',
    'inscription',
    'Armor +{{PlusArmor}} (vs. Piercing damage)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Nightfall'),
    'https://wiki.guildwars.com/wiki/Through_Thick_and_Thin',
    'https://wiki.guildwars.com/images/5/59/Inscription_focus_items.png',
    '{"PlusArmor":{"min":5,"max":10}}'::jsonb
  ),
  (
    'To the Pain!',
    'inscription',
    'Damage +{{PlusDamagePercent}}%Armor -10 (while attacking)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/To_the_Pain!',
    'https://wiki.guildwars.com/images/2/2e/Inscription_equippable_items.png',
    '{"PlusDamagePercent":{"min":14,"max":15}}'::jsonb
  ),
  (
    'Too Much Information',
    'inscription',
    'Damage +{{PlusDamagePercent}}% (vs. Hexed foes)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Too_Much_Information',
    'https://wiki.guildwars.com/images/2/2e/Inscription_equippable_items.png',
    '{"PlusDamagePercent":{"min":10,"max":15}}'::jsonb
  ),
  (
    'Vengeance is Mine',
    'inscription',
    'Damage +{{PlusDamagePercent}}% (while Health is below 50%)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Vengeance_is_Mine',
    'https://wiki.guildwars.com/images/2/2e/Inscription_equippable_items.png',
    '{"PlusDamagePercent":{"min":10,"max":20}}'::jsonb
  ),
  (
    'Adept',
    'prefix',
    'Halves casting time of spells of item''s attribute (Chance: {{PlusAttribute}}%)',
    NULL,
    NULL,
    'https://wiki.guildwars.com/wiki/Adept',
    'https://wiki.guildwars.com/images/Prefix_axe.png',
    '{"PlusAttribute":{"min":10,"max":20}}'::jsonb
  ),
  (
    'Barbed',
    'prefix',
    'Lengthens Bleeding duration on foes by 33%',
    NULL,
    NULL,
    'https://wiki.guildwars.com/wiki/Barbed',
    'https://wiki.guildwars.com/images/Prefix_axe.png',
    '{}'::jsonb
  ),
  (
    'Crippling',
    'prefix',
    'Lengthens Crippled duration on foes by 33%',
    NULL,
    NULL,
    'https://wiki.guildwars.com/wiki/Crippling',
    'https://wiki.guildwars.com/images/Prefix_axe.png',
    '{}'::jsonb
  ),
  (
    'Cruel',
    'prefix',
    'Lengthens Deep Wound duration on foes by 33%',
    NULL,
    NULL,
    'https://wiki.guildwars.com/wiki/Cruel',
    'https://wiki.guildwars.com/images/Prefix_axe.png',
    '{}'::jsonb
  ),
  (
    'Defensive',
    'prefix',
    'Armor +{{PlusArmor}}',
    NULL,
    NULL,
    'https://wiki.guildwars.com/wiki/Defensive',
    'https://wiki.guildwars.com/images/Prefix_axe.png',
    '{"PlusArmor":{"min":4,"max":5}}'::jsonb
  ),
  (
    'Ebon',
    'prefix',
    'Earth damage',
    NULL,
    NULL,
    'https://wiki.guildwars.com/wiki/Ebon',
    'https://wiki.guildwars.com/images/Prefix_axe.png',
    '{}'::jsonb
  ),
  (
    'Fiery',
    'prefix',
    'Fire damage',
    NULL,
    NULL,
    'https://wiki.guildwars.com/wiki/Fiery',
    'https://wiki.guildwars.com/images/Prefix_axe.png',
    '{}'::jsonb
  ),
  (
    'Furious',
    'prefix',
    'Double Adrenaline on hit (Chance: {{ChancePercent}}%)',
    NULL,
    NULL,
    'https://wiki.guildwars.com/wiki/Furious',
    'https://wiki.guildwars.com/images/Prefix_axe.png',
    '{"ChancePercent":{"min":2,"max":10}}'::jsonb
  ),
  (
    'Hale',
    'prefix',
    'Health +{{PlusHealth}}',
    NULL,
    NULL,
    'https://wiki.guildwars.com/wiki/Hale',
    'https://wiki.guildwars.com/images/Prefix_axe.png',
    '{"PlusHealth":{"min":10,"max":30}}'::jsonb
  ),
  (
    'Heavy',
    'prefix',
    'Lengthens Weakness duration on foes by 33%',
    NULL,
    NULL,
    'https://wiki.guildwars.com/wiki/Heavy',
    'https://wiki.guildwars.com/images/Prefix_axe.png',
    '{}'::jsonb
  ),
  (
    'Icy',
    'prefix',
    'Cold damage',
    NULL,
    NULL,
    'https://wiki.guildwars.com/wiki/Icy',
    'https://wiki.guildwars.com/images/Prefix_axe.png',
    '{}'::jsonb
  ),
  (
    'Insightful',
    'prefix',
    'Energy +{{PlusEnergy}}',
    NULL,
    NULL,
    'https://wiki.guildwars.com/wiki/Insightful',
    'https://wiki.guildwars.com/images/Prefix_axe.png',
    '{"PlusEnergy":{"min":1,"max":5}}'::jsonb
  ),
  (
    'Poisonous',
    'prefix',
    'Lengthens Poison duration on foes by 33%',
    NULL,
    NULL,
    'https://wiki.guildwars.com/wiki/Poisonous',
    'https://wiki.guildwars.com/images/Prefix_axe.png',
    '{}'::jsonb
  ),
  (
    'Shocking',
    'prefix',
    'Lightning damage',
    NULL,
    NULL,
    'https://wiki.guildwars.com/wiki/Shocking',
    'https://wiki.guildwars.com/images/Prefix_axe.png',
    '{}'::jsonb
  ),
  (
    'Silencing',
    'prefix',
    'Lengthens Dazed duration on foes by 33%',
    NULL,
    NULL,
    'https://wiki.guildwars.com/wiki/Silencing',
    'https://wiki.guildwars.com/images/Prefix_axe.png',
    '{}'::jsonb
  ),
  (
    'Sundering',
    'prefix',
    'Armor penetration +20% (Chance: {{PlusArmor}}%)',
    NULL,
    NULL,
    'https://wiki.guildwars.com/wiki/Sundering',
    'https://wiki.guildwars.com/images/Prefix_axe.png',
    '{"PlusArmor":{"min":10,"max":20}}'::jsonb
  ),
  (
    'Swift',
    'prefix',
    'Halves casting time of spells (Chance: {{ChancePercent}}%)',
    NULL,
    NULL,
    'https://wiki.guildwars.com/wiki/Swift',
    'https://wiki.guildwars.com/images/Prefix_axe.png',
    '{"ChancePercent":{"min":2,"max":10}}'::jsonb
  ),
  (
    'Vampiric',
    'prefix',
    'Life Draining: {{LifeDrain}}Health regeneration: -1',
    NULL,
    NULL,
    'https://wiki.guildwars.com/wiki/Vampiric',
    'https://wiki.guildwars.com/images/Prefix_axe.png',
    '{"LifeDrain":{"low":{"min":1,"max":3,"applies_to":["Axe","Daggers","Spear","Sword"]},"high":{"min":1,"max":5,"applies_to":["Bow","Hammer","Scythe"]}}}'::jsonb
  ),
  (
    'Zealous',
    'prefix',
    'Energy gain on hit: 1Energy regeneration: -1',
    NULL,
    NULL,
    'https://wiki.guildwars.com/wiki/Zealous',
    'https://wiki.guildwars.com/images/Prefix_axe.png',
    '{}'::jsonb
  ),
  (
    'of Air Magic',
    'suffix',
    'Air Magic +1 ({{ChancePercent}}% chance while using skills)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Of_Attribute',
    'https://wiki.guildwars.com/images/Suffix_axe.png',
    '{"ChancePercent":{"min":10,"max":20}}'::jsonb
  ),
  (
    'of Aptitude',
    'suffix',
    'Halves casting time of item''s attribute spells (Chance: {{PlusAttribute}}%)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/of_Aptitude',
    'https://wiki.guildwars.com/images/Suffix_wand.png',
    '{"PlusAttribute":{"min":10,"max":20}}'::jsonb
  ),
  (
    'of Axe Mastery',
    'suffix',
    'Axe Mastery +1 ({{ChancePercent}}% chance while using skills)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Of_Attribute',
    'https://wiki.guildwars.com/images/Suffix_axe.png',
    '{"ChancePercent":{"min":10,"max":20}}'::jsonb
  ),
  (
    'of Blood Magic',
    'suffix',
    'Blood Magic +1 ({{ChancePercent}}% chance while using skills)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Of_Attribute',
    'https://wiki.guildwars.com/images/Suffix_axe.png',
    '{"ChancePercent":{"min":10,"max":20}}'::jsonb
  ),
  (
    'of Channeling Magic',
    'suffix',
    'Channeling Magic +1 ({{ChancePercent}}% chance while using skills)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Of_Attribute',
    'https://wiki.guildwars.com/images/Suffix_axe.png',
    '{"ChancePercent":{"min":10,"max":20}}'::jsonb
  ),
  (
    'of Charrslaying',
    'suffix',
    'Damage +{{PlusDamagePercent}}% (vs. Charr)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Of_slaying',
    'https://wiki.guildwars.com/images/Suffix_axe.png',
    '{"PlusDamagePercent":{"min":10,"max":20}}'::jsonb
  ),
  (
    'of Communing',
    'suffix',
    'Communing +1 ({{ChancePercent}}% chance while using skills)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Of_Attribute',
    'https://wiki.guildwars.com/images/Suffix_axe.png',
    '{"ChancePercent":{"min":10,"max":20}}'::jsonb
  ),
  (
    'of Curses',
    'suffix',
    'Curses +1 ({{ChancePercent}}% chance while using skills)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Of_Attribute',
    'https://wiki.guildwars.com/images/Suffix_axe.png',
    '{"ChancePercent":{"min":10,"max":20}}'::jsonb
  ),
  (
    'of Dagger Mastery',
    'suffix',
    'Dagger Mastery +1 ({{ChancePercent}}% chance while using skills)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Of_Attribute',
    'https://wiki.guildwars.com/images/Suffix_axe.png',
    '{"ChancePercent":{"min":10,"max":20}}'::jsonb
  ),
  (
    'of Death Magic',
    'suffix',
    'Death Magic +1 ({{ChancePercent}}% chance while using skills)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Of_Attribute',
    'https://wiki.guildwars.com/images/Suffix_axe.png',
    '{"ChancePercent":{"min":10,"max":20}}'::jsonb
  ),
  (
    'of Deathbane',
    'suffix',
    'Damage +{{PlusDamagePercent}}% (vs. Undead)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Of_slaying',
    'https://wiki.guildwars.com/images/Suffix_axe.png',
    '{"PlusDamagePercent":{"min":10,"max":20}}'::jsonb
  ),
  (
    'of Defense',
    'suffix',
    'Armor +{{PlusArmor}}',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/of_Defense',
    'https://wiki.guildwars.com/images/Suffix_axe.png',
    '{"PlusArmor":{"min":4,"max":5}}'::jsonb
  ),
  (
    'of Demonslaying',
    'suffix',
    'Damage +{{PlusDamagePercent}}% (vs. Demons)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Of_slaying',
    'https://wiki.guildwars.com/images/Suffix_axe.png',
    '{"PlusDamagePercent":{"min":10,"max":20}}'::jsonb
  ),
  (
    'of Devotion',
    'suffix',
    'Health +{{PlusHealth}} (while Enchanted)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/of_Devotion',
    'https://wiki.guildwars.com/images/Suffix_sword.png',
    '{"PlusHealth":{"min":30,"max":45}}'::jsonb
  ),
  (
    'of Divine Favor',
    'suffix',
    'Divine Favor +1 ({{ChancePercent}}% chance while using skills)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Of_Attribute',
    'https://wiki.guildwars.com/images/Suffix_axe.png',
    '{"ChancePercent":{"min":10,"max":20}}'::jsonb
  ),
  (
    'of Domination Magic',
    'suffix',
    'Domination Magic +1 ({{ChancePercent}}% chance while using skills)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Of_Attribute',
    'https://wiki.guildwars.com/images/Suffix_axe.png',
    '{"ChancePercent":{"min":10,"max":20}}'::jsonb
  ),
  (
    'of Dragonslaying',
    'suffix',
    'Damage +{{PlusDamagePercent}}% (vs. Dragons)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Of_slaying',
    'https://wiki.guildwars.com/images/Suffix_axe.png',
    '{"PlusDamagePercent":{"min":10,"max":20}}'::jsonb
  ),
  (
    'of Dwarfslaying',
    'suffix',
    'Damage +{{PlusDamagePercent}}% (vs. Dwarves)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Of_slaying',
    'https://wiki.guildwars.com/images/Suffix_axe.png',
    '{"PlusDamagePercent":{"min":10,"max":20}}'::jsonb
  ),
  (
    'of Earth Magic',
    'suffix',
    'Earth Magic +1 ({{ChancePercent}}% chance while using skills)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Of_Attribute',
    'https://wiki.guildwars.com/images/Suffix_axe.png',
    '{"ChancePercent":{"min":10,"max":20}}'::jsonb
  ),
  (
    'of Enchanting',
    'suffix',
    'Enchantments last {{DurationPercent}}% longer',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/of_Enchanting',
    'https://wiki.guildwars.com/images/Suffix_axe.png',
    '{"DurationPercent":{"min":10,"max":20}}'::jsonb
  ),
  (
    'of Endurance',
    'suffix',
    'Health +{{PlusHealth}} (while in a Stance)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/of_Endurance',
    'https://wiki.guildwars.com/images/Suffix_sword.png',
    '{"PlusHealth":{"min":30,"max":45}}'::jsonb
  ),
  (
    'of Fire Magic',
    'suffix',
    'Fire Magic +1 ({{ChancePercent}}% chance while using skills)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Of_Attribute',
    'https://wiki.guildwars.com/images/Suffix_axe.png',
    '{"ChancePercent":{"min":10,"max":20}}'::jsonb
  ),
  (
    'of Fortitude',
    'suffix',
    'Health +{{PlusHealth}}',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/of_Fortitude',
    'https://wiki.guildwars.com/images/Suffix_axe.png',
    '{"PlusHealth":{"min":10,"max":30}}'::jsonb
  ),
  (
    'of Giantslaying',
    'suffix',
    'Damage +{{PlusDamagePercent}}% (vs. Giants)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Of_slaying',
    'https://wiki.guildwars.com/images/Suffix_axe.png',
    '{"PlusDamagePercent":{"min":10,"max":20}}'::jsonb
  ),
  (
    'of Hammer Mastery',
    'suffix',
    'Hammer Mastery +1 ({{ChancePercent}}% chance while using skills)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Of_Attribute',
    'https://wiki.guildwars.com/images/Suffix_axe.png',
    '{"ChancePercent":{"min":10,"max":20}}'::jsonb
  ),
  (
    'of Healing Prayers',
    'suffix',
    'Healing Prayers +1 ({{ChancePercent}}% chance while using skills)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Of_Attribute',
    'https://wiki.guildwars.com/images/Suffix_axe.png',
    '{"ChancePercent":{"min":10,"max":20}}'::jsonb
  ),
  (
    'of Illusion Magic',
    'suffix',
    'Illusion Magic +1 ({{ChancePercent}}% chance while using skills)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Of_Attribute',
    'https://wiki.guildwars.com/images/Suffix_axe.png',
    '{"ChancePercent":{"min":10,"max":20}}'::jsonb
  ),
  (
    'of Inspiration Magic',
    'suffix',
    'Inspiration Magic +1 ({{ChancePercent}}% chance while using skills)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Of_Attribute',
    'https://wiki.guildwars.com/images/Suffix_axe.png',
    '{"ChancePercent":{"min":10,"max":20}}'::jsonb
  ),
  (
    'of Marksmanship',
    'suffix',
    'Marksmanship +1 ({{ChancePercent}}% chance while using skills)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Of_Attribute',
    'https://wiki.guildwars.com/images/Suffix_axe.png',
    '{"ChancePercent":{"min":10,"max":20}}'::jsonb
  ),
  (
    'of Mastery',
    'suffix',
    'Item''s attribute +1 ({{PlusAttribute}}% chance while using skills)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/of_Mastery',
    'https://wiki.guildwars.com/images/Suffix_sword.png',
    '{"PlusAttribute":{"min":10,"max":20}}'::jsonb
  ),
  (
    'of Memory',
    'suffix',
    'Halves skill recharge of item''s attribute spells (Chance: {{PlusAttribute}}%)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/of_Memory',
    'https://wiki.guildwars.com/images/Suffix_hammer.png',
    '{"PlusAttribute":{"min":10,"max":20}}'::jsonb
  ),
  (
    'of Ogreslaying',
    'suffix',
    'Damage +{{PlusDamagePercent}}% (vs. Ogres)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Of_slaying',
    'https://wiki.guildwars.com/images/Suffix_axe.png',
    '{"PlusDamagePercent":{"min":10,"max":20}}'::jsonb
  ),
  (
    'of Protection Prayers',
    'suffix',
    'Protection Prayers +1 ({{ChancePercent}}% chance while using skills)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Of_Attribute',
    'https://wiki.guildwars.com/images/Suffix_axe.png',
    '{"ChancePercent":{"min":10,"max":20}}'::jsonb
  ),
  (
    'of Pruning',
    'suffix',
    'Damage +{{PlusDamagePercent}}% (vs. Plants)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Of_slaying',
    'https://wiki.guildwars.com/images/Suffix_axe.png',
    '{"PlusDamagePercent":{"min":10,"max":20}}'::jsonb
  ),
  (
    'of Quickening',
    'suffix',
    'Halves skill recharge of spells (Chance: {{ChancePercent}}%)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/of_Quickening',
    'https://wiki.guildwars.com/images/Suffix_hammer.png',
    '{"ChancePercent":{"min":5,"max":10}}'::jsonb
  ),
  (
    'of Restoration Magic',
    'suffix',
    'Restoration Magic +1 ({{ChancePercent}}% chance while using skills)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Of_Attribute',
    'https://wiki.guildwars.com/images/Suffix_axe.png',
    '{"ChancePercent":{"min":10,"max":20}}'::jsonb
  ),
  (
    'of Scythe Mastery',
    'suffix',
    'Scythe Mastery +1 ({{ChancePercent}}% chance while using skills)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Of_Attribute',
    'https://wiki.guildwars.com/images/Suffix_axe.png',
    '{"ChancePercent":{"min":10,"max":20}}'::jsonb
  ),
  (
    'of Shelter',
    'suffix',
    'Armor +{{PlusArmor}} (vs. physical damage)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/of_Shelter',
    'https://wiki.guildwars.com/images/Suffix_axe.png',
    '{"PlusArmor":{"min":4,"max":7}}'::jsonb
  ),
  (
    'of Skeletonslaying',
    'suffix',
    'Damage +{{PlusDamagePercent}}% (vs. Skeletons)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Of_slaying',
    'https://wiki.guildwars.com/images/Suffix_axe.png',
    '{"PlusDamagePercent":{"min":10,"max":20}}'::jsonb
  ),
  (
    'of Smiting Prayers',
    'suffix',
    'Smiting Prayers +1 ({{ChancePercent}}% chance while using skills)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Of_Attribute',
    'https://wiki.guildwars.com/images/Suffix_axe.png',
    '{"ChancePercent":{"min":10,"max":20}}'::jsonb
  ),
  (
    'of Soul Reaping',
    'suffix',
    'Soul Reaping +1 ({{ChancePercent}}% chance while using skills)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Of_Attribute',
    'https://wiki.guildwars.com/images/Suffix_axe.png',
    '{"ChancePercent":{"min":10,"max":20}}'::jsonb
  ),
  (
    'of Spear Mastery',
    'suffix',
    'Spear Mastery +1 ({{ChancePercent}}% chance while using skills)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Of_Attribute',
    'https://wiki.guildwars.com/images/Suffix_axe.png',
    '{"ChancePercent":{"min":10,"max":20}}'::jsonb
  ),
  (
    'of Swiftness',
    'suffix',
    'Halves casting time of spells (Chance: {{ChancePercent}}%)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/of_Swiftness',
    'https://wiki.guildwars.com/images/Suffix_wand.png',
    '{"ChancePercent":{"min":5,"max":10}}'::jsonb
  ),
  (
    'of Swordsmanship',
    'suffix',
    'Swordsmanship +1 ({{ChancePercent}}% chance while using skills)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Of_Attribute',
    'https://wiki.guildwars.com/images/Suffix_axe.png',
    '{"ChancePercent":{"min":10,"max":20}}'::jsonb
  ),
  (
    'of Tenguslaying',
    'suffix',
    'Damage +{{PlusDamagePercent}}% (vs. Tengu)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Of_slaying',
    'https://wiki.guildwars.com/images/Suffix_axe.png',
    '{"PlusDamagePercent":{"min":10,"max":20}}'::jsonb
  ),
  (
    'of Trollslaying',
    'suffix',
    'Damage +{{PlusDamagePercent}}% (vs. Trolls)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Of_slaying',
    'https://wiki.guildwars.com/images/Suffix_axe.png',
    '{"PlusDamagePercent":{"min":10,"max":20}}'::jsonb
  ),
  (
    'of Valor',
    'suffix',
    'Health +{{PlusHealth}} (while Hexed)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/of_Valor',
    'https://wiki.guildwars.com/images/Suffix_sword.png',
    '{"PlusHealth":{"min":45,"max":60}}'::jsonb
  ),
  (
    'of Warding',
    'suffix',
    'Armor +{{PlusArmor}} (vs. elemental damage)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/of_Warding',
    'https://wiki.guildwars.com/images/Suffix_axe.png',
    '{"PlusArmor":{"min":4,"max":7}}'::jsonb
  ),
  (
    'of Water Magic',
    'suffix',
    'Water Magic +1 ({{ChancePercent}}% chance while using skills)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Of_Attribute',
    'https://wiki.guildwars.com/images/Suffix_axe.png',
    '{"ChancePercent":{"min":10,"max":20}}'::jsonb
  ),
  (
    'of the Assassin',
    'suffix',
    'Attribute {{PlusAttribute}} (non-stacking, PvE only)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Of_the_(Profession)',
    'https://wiki.guildwars.com/images/Suffix_axe.png',
    '{"PlusAttribute":{"min":4,"max":5}}'::jsonb
  ),
  (
    'of the Dervish',
    'suffix',
    'Attribute {{PlusAttribute}} (non-stacking, PvE only)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Of_the_(Profession)',
    'https://wiki.guildwars.com/images/Suffix_axe.png',
    '{"PlusAttribute":{"min":4,"max":5}}'::jsonb
  ),
  (
    'of the Elementalist',
    'suffix',
    'Attribute {{PlusAttribute}} (non-stacking, PvE only)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Of_the_(Profession)',
    'https://wiki.guildwars.com/images/Suffix_axe.png',
    '{"PlusAttribute":{"min":4,"max":5}}'::jsonb
  ),
  (
    'of the Mesmer',
    'suffix',
    'Attribute {{PlusAttribute}} (non-stacking, PvE only)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Of_the_(Profession)',
    'https://wiki.guildwars.com/images/Suffix_axe.png',
    '{"PlusAttribute":{"min":4,"max":5}}'::jsonb
  ),
  (
    'of the Monk',
    'suffix',
    'Attribute {{PlusAttribute}} (non-stacking, PvE only)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Of_the_(Profession)',
    'https://wiki.guildwars.com/images/Suffix_axe.png',
    '{"PlusAttribute":{"min":4,"max":5}}'::jsonb
  ),
  (
    'of the Necromancer',
    'suffix',
    'Attribute {{PlusAttribute}} (non-stacking, PvE only)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Of_the_(Profession)',
    'https://wiki.guildwars.com/images/Suffix_axe.png',
    '{"PlusAttribute":{"min":4,"max":5}}'::jsonb
  ),
  (
    'of the Paragon',
    'suffix',
    'Attribute {{PlusAttribute}} (non-stacking, PvE only)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Of_the_(Profession)',
    'https://wiki.guildwars.com/images/Suffix_axe.png',
    '{"PlusAttribute":{"min":4,"max":5}}'::jsonb
  ),
  (
    'of the Ranger',
    'suffix',
    'Attribute {{PlusAttribute}} (non-stacking, PvE only)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Of_the_(Profession)',
    'https://wiki.guildwars.com/images/Suffix_axe.png',
    '{"PlusAttribute":{"min":4,"max":5}}'::jsonb
  ),
  (
    'of the Ritualist',
    'suffix',
    'Attribute {{PlusAttribute}} (non-stacking, PvE only)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Of_the_(Profession)',
    'https://wiki.guildwars.com/images/Suffix_axe.png',
    '{"PlusAttribute":{"min":4,"max":5}}'::jsonb
  ),
  (
    'of the Warrior',
    'suffix',
    'Attribute {{PlusAttribute}} (non-stacking, PvE only)',
    NULL,
    (SELECT id FROM releases WHERE name = 'Core'),
    'https://wiki.guildwars.com/wiki/Of_the_(Profession)',
    'https://wiki.guildwars.com/images/Suffix_axe.png',
    '{"PlusAttribute":{"min":4,"max":5}}'::jsonb
  )
ON CONFLICT (name) DO UPDATE SET
  type = EXCLUDED.type,
  description = EXCLUDED.description,
  attaches_to = EXCLUDED.attaches_to,
  release_id = EXCLUDED.release_id,
  wiki_url = EXCLUDED.wiki_url,
  icon = EXCLUDED.icon,
  variables = EXCLUDED.variables;
