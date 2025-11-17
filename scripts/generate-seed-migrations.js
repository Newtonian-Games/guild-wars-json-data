#!/usr/bin/env node
/**
 * Generate SQL seed migrations from JSON skill data
 * Overwrites existing migration files with fresh data from JSON
 *
 * Usage: node scripts/generate-seed-migrations.js
 */

import fs from 'fs'
import path from 'path'
import { fileURLToPath } from 'url'

const __filename = fileURLToPath(import.meta.url)
const __dirname = path.dirname(__filename)

// Migration file mappings
const PROFESSIONS_MIGRATION = '20251116015200_seed-professions.sql'
const ATTRIBUTES_MIGRATION = '20251116015205_seed-attributes.sql'
const RELEASES_MIGRATION = '20251116015210_seed-releases.sql'
const SKILL_TYPES_MIGRATION = '20251116015215_seed-skill-types.sql'

const SKILL_MIGRATIONS = {
  'assassin': '20251116015220_seed-assassin-skills.sql',
  'common': '20251116015225_seed-common-skills.sql',
  'dervish': '20251116015230_seed-dervish-skills.sql',
  'elementalist': '20251116015235_seed-elementalist-skills.sql',
  'mesmer': '20251116015240_seed-mesmer-skills.sql',
  'monk': '20251116015245_seed-monk-skills.sql',
  'monster': '20251116015250_seed-monster-skills.sql',
  'necromancer': '20251116015255_seed-necromancer-skills.sql',
  'paragon': '20251116015260_seed-paragon-skills.sql',
  'ranger': '20251116015265_seed-ranger-skills.sql',
  'ritualist': '20251116015270_seed-ritualist-skills.sql',
  'warrior': '20251116015275_seed-warrior-skills.sql'
}

// Equipment/item migrations
const RUNES_MIGRATION = '20251116015280_seed-runes.sql'
const INSIGNIAS_MIGRATION = '20251116015285_seed-insignias.sql'
const WEAPONS_MIGRATION = '20251116015290_seed-weapons.sql'
const WEAPON_UPGRADES_MIGRATION = '20251116015295_seed-weapon-upgrades.sql'

// SQL-safe string escaping
function escapeSqlString(str) {
  if (str === null || str === undefined) return 'NULL'
  return `'${String(str).replace(/'/g, "''")}'`
}

// Convert to SQL number or NULL
function toSqlNumber(value) {
  if (value === null || value === undefined) return 'NULL'
  return String(value)
}

// Convert to SQL boolean
function toSqlBoolean(value) {
  return value ? 'true' : 'false'
}

// Convert object to PostgreSQL JSONB
function toSqlJsonb(obj) {
  if (!obj || Object.keys(obj).length === 0) return "'{}'::jsonb"
  const jsonStr = JSON.stringify(obj).replace(/'/g, "''")
  return `'${jsonStr}'::jsonb`
}

// Generate SQL VALUES clause for a single skill
function skillToSqlValues(skill) {
  // Use subqueries for FK lookups
  const skillTypeId = skill.type
    ? `(SELECT id FROM skill_types WHERE name = ${escapeSqlString(skill.type)})`
    : 'NULL'

  const professionId = skill.profession
    ? `(SELECT id FROM professions WHERE name = ${escapeSqlString(skill.profession)})`
    : 'NULL'

  const attributeId = skill.attribute?.name
    ? `(SELECT id FROM attributes WHERE name = ${escapeSqlString(skill.attribute.name)} LIMIT 1)`
    : 'NULL'

  const releaseId = skill.campaign
    ? `(SELECT id FROM releases WHERE name = ${escapeSqlString(skill.campaign)})`
    : 'NULL'

  return `  (
    ${escapeSqlString(skill.name)},
    ${escapeSqlString(skill.icon || '')},
    ${toSqlBoolean(skill.is_high_res_icon)},
    ${escapeSqlString(skill.concise_description || skill.description)},
    ${skillTypeId},
    ${professionId},
    ${attributeId},
    ${toSqlJsonb(skill.attribute?.progression)},
    ${toSqlNumber(skill.costs?.energy)},
    ${toSqlNumber(skill.costs?.adrenaline)},
    ${toSqlNumber(skill.costs?.upkeep)},
    ${toSqlNumber(skill.costs?.sacrifice)},
    ${toSqlNumber(skill.costs?.overcast)},
    ${toSqlNumber(skill.activation)},
    ${escapeSqlString(skill.recharge)},
    ${toSqlBoolean(skill.is_elite)},
    ${releaseId},
    ${escapeSqlString(skill.limitation)},
    ${escapeSqlString(skill.wiki_url)}
  )`
}

// Generate SQL for professions
function generateProfessionsSql(professions) {
  const header = `-- Seed professions
-- Auto-generated from data/professions.json
-- Generated: ${new Date().toISOString()}
-- Total professions: ${professions.length}

INSERT INTO professions (name, abbreviation, icon, wiki_url, armor_bonuses)
VALUES`

  const values = professions.map(prof => {
    return `  (${escapeSqlString(prof.name)}, ${escapeSqlString(prof.abbreviation)}, ${escapeSqlString(prof.icon)}, ${escapeSqlString(prof.wiki_url)}, ${toSqlJsonb(prof.armor_bonuses)})`
  }).join(',\n')

  const footer = `
ON CONFLICT (name) DO UPDATE SET
  abbreviation = EXCLUDED.abbreviation,
  icon = EXCLUDED.icon,
  wiki_url = EXCLUDED.wiki_url,
  armor_bonuses = EXCLUDED.armor_bonuses;
`

  return header + '\n' + values + footer
}

// Generate SQL for attributes
function generateAttributesSql(attributes) {
  const professionAttrs = attributes.filter(attr => attr.profession !== null)
  const rankAttrs = attributes.filter(attr => attr.profession === null)

  const header = `-- Seed attributes
-- Auto-generated from data/attributes.json
-- Generated: ${new Date().toISOString()}
-- Total attributes: ${attributes.length} (${professionAttrs.length} profession attributes + ${rankAttrs.length} rank attributes)

-- Insert profession-specific attributes
INSERT INTO attributes (name, profession_id, is_primary, wiki_url, description, inherent_effects)
VALUES`

  const professionValues = professionAttrs.map(attr => {
    return `  (${escapeSqlString(attr.name)}, (SELECT id FROM professions WHERE name = ${escapeSqlString(attr.profession)}), ${toSqlBoolean(attr.isPrimary)}, ${escapeSqlString(attr.wiki_url)}, ${escapeSqlString(attr.description)}, ${toSqlJsonb(attr.inherent_effects)})`
  }).join(',\n')

  const professionFooter = `
ON CONFLICT (name, profession_id) DO UPDATE SET
  is_primary = EXCLUDED.is_primary,
  wiki_url = EXCLUDED.wiki_url,
  description = EXCLUDED.description,
  inherent_effects = EXCLUDED.inherent_effects;

-- Insert rank attributes (no profession association)
INSERT INTO attributes (name, profession_id, is_primary, wiki_url, description, inherent_effects)
VALUES`

  const rankValues = rankAttrs.map(attr => {
    return `  (${attr.name === null ? 'NULL' : escapeSqlString(attr.name)}, NULL, false, ${escapeSqlString(attr.wiki_url)}, ${escapeSqlString(attr.description)}, ${toSqlJsonb(attr.inherent_effects)})`
  }).join(',\n')

  const rankFooter = `
ON CONFLICT (name, profession_id) DO UPDATE SET
  wiki_url = EXCLUDED.wiki_url,
  description = EXCLUDED.description,
  inherent_effects = EXCLUDED.inherent_effects;
`

  return header + '\n' + professionValues + professionFooter + '\n' + rankValues + rankFooter
}

// Generate SQL for releases
function generateReleasesSql(releases) {
  const header = `-- Seed releases
-- Auto-generated from data/releases.json
-- Generated: ${new Date().toISOString()}
-- Total releases: ${releases.length}

INSERT INTO releases (name, order_index, description)
VALUES`

  const values = releases.map(release => {
    return `  (${escapeSqlString(release.name)}, ${release.order}, ${escapeSqlString(release.description)})`
  }).join(',\n')

  const footer = `
ON CONFLICT (name) DO UPDATE SET
  order_index = EXCLUDED.order_index,
  description = EXCLUDED.description;
`

  return header + '\n' + values + footer
}

// Generate SQL for skill_types
function generateSkillTypesSql(skillTypes) {
  const header = `-- Seed skill_types
-- Auto-generated from data/skill-types.json
-- Generated: ${new Date().toISOString()}
-- Total skill_types: ${skillTypes.length}

INSERT INTO skill_types (name, parents, description)
VALUES`

  const values = skillTypes.map(skillType => {
    return `  (${escapeSqlString(skillType.name)}, ${toSqlJsonb(skillType.parents)}, ${escapeSqlString(skillType.description)})`
  }).join(',\n')

  const footer = `
ON CONFLICT (name) DO UPDATE SET
  parents = EXCLUDED.parents,
  description = EXCLUDED.description;
`

  return header + '\n' + values + footer
}

// Generate complete SQL INSERT migration for skills
function generateSkillsSql(skills, profession) {
  const header = `-- Seed ${profession} skills
-- Auto-generated from data/skills/${profession}.json
-- Generated: ${new Date().toISOString()}
-- Total skills: ${skills.length}

INSERT INTO skills (
  name,
  icon,
  is_high_res_icon,
  description,
  skill_type_id,
  profession_id,
  attribute_id,
  attribute_progression,
  energy_cost,
  adrenaline_cost,
  upkeep_cost,
  sacrifice_cost,
  overcast_cost,
  activation_time,
  recharge_time,
  is_elite,
  release_id,
  limitation,
  wiki_url
)
VALUES`

  const values = skills.map(skillToSqlValues).join(',\n')

  const footer = `
ON CONFLICT (name) DO UPDATE SET
  icon = EXCLUDED.icon,
  is_high_res_icon = EXCLUDED.is_high_res_icon,
  description = EXCLUDED.description,
  skill_type_id = EXCLUDED.skill_type_id,
  profession_id = EXCLUDED.profession_id,
  attribute_id = EXCLUDED.attribute_id,
  attribute_progression = EXCLUDED.attribute_progression,
  energy_cost = EXCLUDED.energy_cost,
  adrenaline_cost = EXCLUDED.adrenaline_cost,
  upkeep_cost = EXCLUDED.upkeep_cost,
  sacrifice_cost = EXCLUDED.sacrifice_cost,
  overcast_cost = EXCLUDED.overcast_cost,
  activation_time = EXCLUDED.activation_time,
  recharge_time = EXCLUDED.recharge_time,
  is_elite = EXCLUDED.is_elite,
  release_id = EXCLUDED.release_id,
  limitation = EXCLUDED.limitation,
  wiki_url = EXCLUDED.wiki_url;
`

  return header + '\n' + values + footer
}

// Generate SQL VALUES clause for a single rune
function runeToSqlValues(rune) {
  // Use subquery for profession_id lookup
  const professionId = rune.profession
    ? `(SELECT id FROM professions WHERE name = ${escapeSqlString(rune.profession)})`
    : 'NULL'

  // Use subquery for attribute_id lookup
  const attributeId = rune.attribute
    ? `(SELECT id FROM attributes WHERE name = ${escapeSqlString(rune.attribute)} AND profession_id IS NOT NULL LIMIT 1)`
    : 'NULL'

  return `  (
    ${escapeSqlString(rune.name)},
    ${escapeSqlString(rune.type)},
    ${escapeSqlString(rune.rarity)},
    ${professionId},
    ${attributeId},
    ${escapeSqlString(rune.icon)},
    ${toSqlJsonb(rune.effects)},
    ${escapeSqlString(rune.description)},
    ${escapeSqlString(rune.wiki_url)}
  )`
}

// Generate SQL for runes
function generateRunesSql(runes) {
  const header = `-- Seed runes
-- Auto-generated from data/runes.json
-- Generated: ${new Date().toISOString()}
-- Total runes: ${runes.length}

INSERT INTO runes (name, type, rarity, profession_id, attribute_id, icon, effects, description, wiki_url)
VALUES`

  const values = runes.map(runeToSqlValues).join(',\n')

  const footer = `
ON CONFLICT (name) DO UPDATE SET
  type = EXCLUDED.type,
  rarity = EXCLUDED.rarity,
  profession_id = EXCLUDED.profession_id,
  attribute_id = EXCLUDED.attribute_id,
  icon = EXCLUDED.icon,
  effects = EXCLUDED.effects,
  description = EXCLUDED.description,
  wiki_url = EXCLUDED.wiki_url;
`

  return header + '\n' + values + footer
}

// Generate SQL VALUES clause for a single insignia
function insigniaToSqlValues(insignia) {
  // Use subquery for profession_id lookup
  const professionId = insignia.profession
    ? `(SELECT id FROM professions WHERE name = ${escapeSqlString(insignia.profession)})`
    : 'NULL'

  return `  (
    ${escapeSqlString(insignia.name)},
    ${professionId},
    ${toSqlJsonb(insignia.requirements)},
    ${toSqlJsonb(insignia.effects)},
    ${escapeSqlString(insignia.description)},
    ${escapeSqlString(insignia.wiki_url)},
    ${escapeSqlString(insignia.icon)}
  )`
}

// Generate SQL for insignias
function generateInsigniasSql(insignias) {
  const header = `-- Seed insignias
-- Auto-generated from data/insignias.json
-- Generated: ${new Date().toISOString()}
-- Total insignias: ${insignias.length}

INSERT INTO insignias (name, profession_id, requirements, effects, description, wiki_url, icon)
VALUES`

  const values = insignias.map(insigniaToSqlValues).join(',\n')

  const footer = `
ON CONFLICT (name) DO UPDATE SET
  profession_id = EXCLUDED.profession_id,
  requirements = EXCLUDED.requirements,
  effects = EXCLUDED.effects,
  description = EXCLUDED.description,
  wiki_url = EXCLUDED.wiki_url,
  icon = EXCLUDED.icon;
`

  return header + '\n' + values + footer
}

// Generate SQL VALUES clause for a single weapon
function weaponToSqlValues(weapon) {
  // Handle attribute foreign keys
  let attributeId = 'NULL'
  let attributeProfessionId = 'NULL'

  if (weapon.attribute && weapon.attribute.name) {
    attributeId = `(SELECT id FROM attributes WHERE name = ${escapeSqlString(weapon.attribute.name)} LIMIT 1)`
    if (weapon.attribute.profession) {
      attributeProfessionId = `(SELECT id FROM professions WHERE name = ${escapeSqlString(weapon.attribute.profession)})`
    }
  }

  return `  (
    ${escapeSqlString(weapon.name)},
    ${escapeSqlString(weapon.category)},
    ${escapeSqlString(weapon.subcategory)},
    ${escapeSqlString(weapon.hands)},
    ${attributeId},
    ${attributeProfessionId},
    ${toSqlJsonb(weapon.damage)},
    ${toSqlJsonb(weapon.variants)},
    ${escapeSqlString(weapon.wiki_url)}
  )`
}

// Generate SQL for weapons
function generateWeaponsSql(weapons) {
  const header = `-- Seed weapons
-- Auto-generated from data/weapons.json
-- Generated: ${new Date().toISOString()}
-- Total weapons: ${weapons.length}

INSERT INTO weapons (name, category, subcategory, hands, attribute_id, attribute_profession_id, damage, variants, wiki_url)
VALUES`

  const values = weapons.map(weaponToSqlValues).join(',\n')

  const footer = `
ON CONFLICT (name) DO UPDATE SET
  category = EXCLUDED.category,
  subcategory = EXCLUDED.subcategory,
  hands = EXCLUDED.hands,
  attribute_id = EXCLUDED.attribute_id,
  attribute_profession_id = EXCLUDED.attribute_profession_id,
  damage = EXCLUDED.damage,
  variants = EXCLUDED.variants,
  wiki_url = EXCLUDED.wiki_url;
`

  return header + '\n' + values + footer
}

// Generate SQL VALUES clause for a single weapon upgrade
function weaponUpgradeToSqlValues(upgrade) {
  // Convert attaches_to array to comma-separated string
  const attachesTo = Array.isArray(upgrade.attaches_to) && upgrade.attaches_to.length > 0
    ? escapeSqlString(upgrade.attaches_to.join(', '))
    : 'NULL'

  // Use subquery for release_id lookup
  const releaseId = upgrade.campaign
    ? `(SELECT id FROM releases WHERE name = ${escapeSqlString(upgrade.campaign)})`
    : 'NULL'

  return `  (
    ${escapeSqlString(upgrade.name)},
    ${escapeSqlString(upgrade.type)},
    ${escapeSqlString(upgrade.description)},
    ${attachesTo},
    ${releaseId},
    ${escapeSqlString(upgrade.wiki_url)},
    ${escapeSqlString(upgrade.icon)},
    ${toSqlJsonb(upgrade.variables)}
  )`
}

// Generate SQL for weapon upgrades
function generateWeaponUpgradesSql(upgrades) {
  const header = `-- Seed weapon upgrades
-- Auto-generated from data/weapon_upgrades.json
-- Generated: ${new Date().toISOString()}
-- Total weapon upgrades: ${upgrades.length}

INSERT INTO weapon_upgrades (name, type, description, attaches_to, release_id, wiki_url, icon, variables)
VALUES`

  const values = upgrades.map(weaponUpgradeToSqlValues).join(',\n')

  const footer = `
ON CONFLICT (name) DO UPDATE SET
  type = EXCLUDED.type,
  description = EXCLUDED.description,
  attaches_to = EXCLUDED.attaches_to,
  release_id = EXCLUDED.release_id,
  wiki_url = EXCLUDED.wiki_url,
  icon = EXCLUDED.icon,
  variables = EXCLUDED.variables;
`

  return header + '\n' + values + footer
}

// Main execution
function main() {
  console.log('🔨 Generating SQL seed migrations from JSON...\n')

  let successCount = 0
  let errorCount = 0

  // Generate professions migration
  try {
    const professionsPath = path.join(__dirname, '..', 'data', 'professions.json')
    const professions = JSON.parse(fs.readFileSync(professionsPath, 'utf-8'))

    const sql = generateProfessionsSql(professions)
    const migrationPath = path.join(__dirname, '..', 'supabase', 'migrations', PROFESSIONS_MIGRATION)
    fs.writeFileSync(migrationPath, sql, 'utf-8')

    console.log(`✅ professions      → ${PROFESSIONS_MIGRATION.padEnd(45)} (${professions.length} professions)`)
    successCount++
  } catch (error) {
    console.error(`❌ professions: ${error.message}`)
    errorCount++
  }

  // Generate attributes migration
  try {
    const attributesPath = path.join(__dirname, '..', 'data', 'attributes.json')
    const attributes = JSON.parse(fs.readFileSync(attributesPath, 'utf-8'))

    const sql = generateAttributesSql(attributes)
    const migrationPath = path.join(__dirname, '..', 'supabase', 'migrations', ATTRIBUTES_MIGRATION)
    fs.writeFileSync(migrationPath, sql, 'utf-8')

    console.log(`✅ attributes       → ${ATTRIBUTES_MIGRATION.padEnd(45)} (${attributes.length} attributes)`)
    successCount++
  } catch (error) {
    console.error(`❌ attributes: ${error.message}`)
    errorCount++
  }

  // Generate releases migration
  try {
    const releasesPath = path.join(__dirname, '..', 'data', 'releases.json')
    const releases = JSON.parse(fs.readFileSync(releasesPath, 'utf-8'))

    const sql = generateReleasesSql(releases)
    const migrationPath = path.join(__dirname, '..', 'supabase', 'migrations', RELEASES_MIGRATION)
    fs.writeFileSync(migrationPath, sql, 'utf-8')

    console.log(`✅ releases         → ${RELEASES_MIGRATION.padEnd(45)} (${releases.length} releases)`)
    successCount++
  } catch (error) {
    console.error(`❌ releases: ${error.message}`)
    errorCount++
  }

  // Generate skill_types migration
  try {
    const skillTypesPath = path.join(__dirname, '..', 'data', 'skill-types.json')
    const skillTypes = JSON.parse(fs.readFileSync(skillTypesPath, 'utf-8'))

    const sql = generateSkillTypesSql(skillTypes)
    const migrationPath = path.join(__dirname, '..', 'supabase', 'migrations', SKILL_TYPES_MIGRATION)
    fs.writeFileSync(migrationPath, sql, 'utf-8')

    console.log(`✅ skill_types      → ${SKILL_TYPES_MIGRATION.padEnd(45)} (${skillTypes.length} skill_types)`)
    successCount++
  } catch (error) {
    console.error(`❌ skill_types: ${error.message}`)
    errorCount++
  }

  // Generate skills migrations
  for (const [profession, migrationFile] of Object.entries(SKILL_MIGRATIONS)) {
    try {
      // Read JSON file
      const jsonPath = path.join(__dirname, '..', 'data', 'skills', `${profession}.json`)

      if (!fs.existsSync(jsonPath)) {
        console.error(`❌ ${profession}: JSON file not found: ${jsonPath}`)
        errorCount++
        continue
      }

      const fileContent = fs.readFileSync(jsonPath, 'utf-8')
      const skills = JSON.parse(fileContent)

      if (!Array.isArray(skills) || skills.length === 0) {
        console.error(`❌ ${profession}: Invalid or empty JSON array`)
        errorCount++
        continue
      }

      // Generate SQL
      const sql = generateSkillsSql(skills, profession)

      // Write to migration file
      const migrationPath = path.join(__dirname, '..', 'supabase', 'migrations', migrationFile)
      fs.writeFileSync(migrationPath, sql, 'utf-8')

      console.log(`✅ ${profession.padEnd(15)} → ${migrationFile.padEnd(45)} (${skills.length} skills)`)
      successCount++

    } catch (error) {
      console.error(`❌ ${profession}: ${error.message}`)
      errorCount++
    }
  }

  // Generate runes migration
  try {
    const runesPath = path.join(__dirname, '..', 'data', 'runes.json')
    const runes = JSON.parse(fs.readFileSync(runesPath, 'utf-8'))

    const sql = generateRunesSql(runes)
    const migrationPath = path.join(__dirname, '..', 'supabase', 'migrations', RUNES_MIGRATION)
    fs.writeFileSync(migrationPath, sql, 'utf-8')

    console.log(`✅ runes            → ${RUNES_MIGRATION.padEnd(45)} (${runes.length} runes)`)
    successCount++
  } catch (error) {
    console.error(`❌ runes: ${error.message}`)
    errorCount++
  }

  // Generate insignias migration
  try {
    const insigniasPath = path.join(__dirname, '..', 'data', 'insignias.json')
    const insignias = JSON.parse(fs.readFileSync(insigniasPath, 'utf-8'))

    const sql = generateInsigniasSql(insignias)
    const migrationPath = path.join(__dirname, '..', 'supabase', 'migrations', INSIGNIAS_MIGRATION)
    fs.writeFileSync(migrationPath, sql, 'utf-8')

    console.log(`✅ insignias        → ${INSIGNIAS_MIGRATION.padEnd(45)} (${insignias.length} insignias)`)
    successCount++
  } catch (error) {
    console.error(`❌ insignias: ${error.message}`)
    errorCount++
  }

  // Generate weapons migration
  try {
    const weaponsPath = path.join(__dirname, '..', 'data', 'weapons.json')
    const weapons = JSON.parse(fs.readFileSync(weaponsPath, 'utf-8'))

    const sql = generateWeaponsSql(weapons)
    const migrationPath = path.join(__dirname, '..', 'supabase', 'migrations', WEAPONS_MIGRATION)
    fs.writeFileSync(migrationPath, sql, 'utf-8')

    console.log(`✅ weapons          → ${WEAPONS_MIGRATION.padEnd(45)} (${weapons.length} weapons)`)
    successCount++
  } catch (error) {
    console.error(`❌ weapons: ${error.message}`)
    errorCount++
  }

  // Generate weapon upgrades migration
  try {
    const upgradesPath = path.join(__dirname, '..', 'data', 'weapon_upgrades.json')
    const upgrades = JSON.parse(fs.readFileSync(upgradesPath, 'utf-8'))

    const sql = generateWeaponUpgradesSql(upgrades)
    const migrationPath = path.join(__dirname, '..', 'supabase', 'migrations', WEAPON_UPGRADES_MIGRATION)
    fs.writeFileSync(migrationPath, sql, 'utf-8')

    console.log(`✅ weapon_upgrades  → ${WEAPON_UPGRADES_MIGRATION.padEnd(45)} (${upgrades.length} upgrades)`)
    successCount++
  } catch (error) {
    console.error(`❌ weapon_upgrades: ${error.message}`)
    errorCount++
  }

  console.log(`\n${'='.repeat(80)}`)
  console.log(`✅ Successfully generated: ${successCount} migrations`)
  if (errorCount > 0) {
    console.log(`❌ Failed: ${errorCount} migrations`)
  }
  console.log(`${'='.repeat(80)}`)
  console.log('\nNext steps:')
  console.log('  1. Review the generated migrations')
  console.log('  2. Run: supabase db reset')
  console.log('  3. Verify data in your database')
}

main()
