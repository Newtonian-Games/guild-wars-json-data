-- Seed skill_types
-- Auto-generated from data/skill-types.json
-- Generated: 2025-11-17T08:55:35.742Z
-- Total skill_types: 44

INSERT INTO skill_types (name, parents, description)
VALUES
  ('Skill', '{}'::jsonb, 'Base skill type - all skills fall under this category'),
  ('Attack Skill', '["Skill"]'::jsonb, 'Skills that are attacks'),
  ('Melee Attack', '["Skill","Attack Skill"]'::jsonb, 'Close-range attack skills'),
  ('Pet Attack', '["Skill","Attack Skill","Melee Attack"]'::jsonb, 'Attack skills used by pets'),
  ('Axe Attack', '["Skill","Attack Skill","Melee Attack"]'::jsonb, 'Attack skills that require an axe'),
  ('Dagger Attack', '["Skill","Attack Skill","Melee Attack"]'::jsonb, 'Attack skills that require daggers'),
  ('Lead Attack', '["Skill","Attack Skill","Melee Attack","Dagger Attack"]'::jsonb, 'Dagger attacks that must be used first in a chain'),
  ('Off-Hand Attack', '["Skill","Attack Skill","Melee Attack","Dagger Attack"]'::jsonb, 'Dagger attacks that must follow a lead attack'),
  ('Dual Attack', '["Skill","Attack Skill","Melee Attack","Dagger Attack"]'::jsonb, 'Dagger attacks that can be used after off-hand attacks'),
  ('Hammer Attack', '["Skill","Attack Skill","Melee Attack"]'::jsonb, 'Attack skills that require a hammer'),
  ('Scythe Attack', '["Skill","Attack Skill","Melee Attack"]'::jsonb, 'Attack skills that require a scythe'),
  ('Sword Attack', '["Skill","Attack Skill","Melee Attack"]'::jsonb, 'Attack skills that require a sword'),
  ('Ranged Attack', '["Skill","Attack Skill"]'::jsonb, 'Long-range attack skills'),
  ('Bow Attack', '["Skill","Attack Skill","Ranged Attack"]'::jsonb, 'Attack skills that require a bow'),
  ('Spear Attack', '["Skill","Attack Skill","Ranged Attack"]'::jsonb, 'Attack skills that require a spear'),
  ('Blessing', '["Skill"]'::jsonb, 'Powerful beneficial effects granted by avatars'),
  ('Chant', '["Skill"]'::jsonb, 'Songs or chants that affect allies'),
  ('Condition', '["Skill"]'::jsonb, 'Negative status effects'),
  ('Disguise', '["Skill"]'::jsonb, 'Skills that change the appearance of the character'),
  ('Echo', '["Skill"]'::jsonb, 'Skills that copy other skills'),
  ('Elite Skill', '["Skill"]'::jsonb, 'Powerful skills - only one can be equipped at a time'),
  ('Environment Effect', '["Skill"]'::jsonb, 'Effects caused by the environment'),
  ('Form', '["Skill"]'::jsonb, 'Skills that transform the character'),
  ('Glyph', '["Skill"]'::jsonb, 'Skills that modify the next spell cast'),
  ('Party Bonus', '["Skill"]'::jsonb, 'Bonuses that affect the entire party'),
  ('Preparation', '["Skill"]'::jsonb, 'Skills that modify arrows or attacks'),
  ('Ritual', '["Skill"]'::jsonb, 'Skills that create spirits or ritual effects'),
  ('Binding Ritual', '["Skill","Ritual"]'::jsonb, 'Rituals that create spirits bound to a location'),
  ('Nature Ritual', '["Skill","Ritual"]'::jsonb, 'Rituals that create nature spirits'),
  ('Ebon Vanguard Ritual', '["Skill","Ritual"]'::jsonb, 'Special rituals associated with the Ebon Vanguard'),
  ('Shout', '["Skill"]'::jsonb, 'Vocal skills that affect allies or foes'),
  ('Signet', '["Skill"]'::jsonb, 'No-cost skills that can be used without energy'),
  ('Spell', '["Skill"]'::jsonb, 'Magic-based skills that can be cast'),
  ('Enchantment Spell', '["Skill","Spell"]'::jsonb, 'Spells that provide beneficial effects over time'),
  ('Flash Enchantment Spell', '["Skill","Spell","Enchantment Spell"]'::jsonb, 'Enchantments that trigger immediately when ending'),
  ('Hex Spell', '["Skill","Spell"]'::jsonb, 'Spells that inflict negative effects over time'),
  ('Item Spell', '["Skill","Spell"]'::jsonb, 'Spells that create items'),
  ('Ward Spell', '["Skill","Spell"]'::jsonb, 'Spells that create protective areas'),
  ('Weapon Spell', '["Skill","Spell"]'::jsonb, 'Spells that affect weapons'),
  ('Well Spell', '["Skill","Spell"]'::jsonb, 'Spells that create wells at corpse locations'),
  ('Stance', '["Skill"]'::jsonb, 'Combat postures that provide benefits'),
  ('Title', '["Skill"]'::jsonb, 'Skills granted by titles'),
  ('Touch Skill', '["Skill"]'::jsonb, 'Skills that require touching the target'),
  ('Trap', '["Skill"]'::jsonb, 'Skills that create traps on the ground')
ON CONFLICT (name) DO UPDATE SET
  parents = EXCLUDED.parents,
  description = EXCLUDED.description;
