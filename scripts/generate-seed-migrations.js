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
const PROFESSIONS_MIGRATION = '20251116015120_seed-professions.sql'
const ATTRIBUTES_MIGRATION = '20251116015126_seed-attributes.sql'

const SKILL_MIGRATIONS = {
  'assassin': '20251116015132_seed-assassin-skills.sql',
  'common': '20251116015138_seed-common-skills.sql',
  'dervish': '20251116015147_seed-dervish-skills.sql',
  'elementalist': '20251116015153_seed-elementalist-skills.sql',
  'mesmer': '20251116015157_seed-mesmer-skills.sql',
  'monk': '20251116015205_seed-monk-skills.sql',
  'monster': '20251116015211_seed-monster-skills.sql',
  'necromancer': '20251116015254_seed-necromancer-skills.sql',
  'paragon': '20251116015302_seed-paragon-skills.sql',
  'ranger': '20251116015318_seed-ranger-skills.sql',
  'ritualist': '20251116015347_seed-ritualist-skills.sql',
  'warrior': '20251116015403_seed-warrior-skills.sql'
}

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
  return `  (
    ${escapeSqlString(skill.name)},
    ${escapeSqlString(skill.icon || '')},
    ${escapeSqlString(skill.concise_description || skill.description)},
    ${escapeSqlString(skill.type)},
    ${escapeSqlString(skill.profession)},
    ${escapeSqlString(skill.attribute?.name)},
    ${toSqlJsonb(skill.attribute?.progression)},
    ${toSqlNumber(skill.costs?.energy)},
    ${toSqlNumber(skill.costs?.adrenaline)},
    ${toSqlNumber(skill.costs?.upkeep)},
    ${toSqlNumber(skill.costs?.sacrifice)},
    ${toSqlNumber(skill.costs?.overcast)},
    ${toSqlNumber(skill.activation)},
    ${escapeSqlString(skill.recharge)},
    ${toSqlBoolean(skill.is_elite)},
    ${escapeSqlString(skill.campaign)},
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

INSERT INTO professions (name, abbreviation, icon)
VALUES`

  const values = professions.map(prof => {
    return `  (${escapeSqlString(prof.name)}, ${escapeSqlString(prof.abbreviation)}, ${escapeSqlString(prof.icon)})`
  }).join(',\n')

  const footer = `
ON CONFLICT (name) DO UPDATE SET
  abbreviation = EXCLUDED.abbreviation,
  icon = EXCLUDED.icon;
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
INSERT INTO attributes (name, profession_id, is_primary)
VALUES`

  const professionValues = professionAttrs.map(attr => {
    return `  (${escapeSqlString(attr.name)}, (SELECT id FROM professions WHERE name = ${escapeSqlString(attr.profession)}), ${toSqlBoolean(attr.isPrimary)})`
  }).join(',\n')

  const professionFooter = `
ON CONFLICT (name, profession_id) DO UPDATE SET
  is_primary = EXCLUDED.is_primary;

-- Insert rank attributes (no profession association)
INSERT INTO attributes (name, profession_id, is_primary)
VALUES`

  const rankValues = rankAttrs.map(attr => {
    return `  (${attr.name === null ? 'NULL' : escapeSqlString(attr.name)}, NULL, false)`
  }).join(',\n')

  const rankFooter = `
ON CONFLICT (name, profession_id) DO NOTHING;
`

  return header + '\n' + professionValues + professionFooter + '\n' + rankValues + rankFooter
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
  description,
  type,
  profession,
  attribute_name,
  attribute_progression,
  energy_cost,
  adrenaline_cost,
  upkeep_cost,
  sacrifice_cost,
  overcast_cost,
  activation_time,
  recharge_time,
  is_elite,
  campaign,
  limitation,
  wiki_url
)
VALUES`

  const values = skills.map(skillToSqlValues).join(',\n')

  const footer = `
ON CONFLICT (name) DO UPDATE SET
  icon = EXCLUDED.icon,
  description = EXCLUDED.description,
  type = EXCLUDED.type,
  profession = EXCLUDED.profession,
  attribute_name = EXCLUDED.attribute_name,
  attribute_progression = EXCLUDED.attribute_progression,
  energy_cost = EXCLUDED.energy_cost,
  adrenaline_cost = EXCLUDED.adrenaline_cost,
  upkeep_cost = EXCLUDED.upkeep_cost,
  sacrifice_cost = EXCLUDED.sacrifice_cost,
  overcast_cost = EXCLUDED.overcast_cost,
  activation_time = EXCLUDED.activation_time,
  recharge_time = EXCLUDED.recharge_time,
  is_elite = EXCLUDED.is_elite,
  campaign = EXCLUDED.campaign,
  limitation = EXCLUDED.limitation,
  wiki_url = EXCLUDED.wiki_url;
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
