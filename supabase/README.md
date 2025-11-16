# Supabase Database Configuration

This directory contains all Supabase-related files for the Guild Wars Build Wars project.

## Directory Structure

```
supabase/
├── migrations/          # SQL migration files (schema + seed data)
└── .temp/              # Temporary files (gitignored)
```

## Setup

1. **Install Supabase CLI** (if not already installed):
   ```bash
   npm install -g supabase
   ```

2. **Initialize Supabase** (if needed):
   ```bash
   npx supabase init
   ```

## Running Migrations

To reset the database and apply all migrations from scratch:
```bash
npx supabase db reset
```

To apply only pending migrations:
```bash
npx supabase db push
```

To create a new migration:
```bash
npx supabase migration new <migration-name>
```

## Migration Files

All data is seeded via SQL migrations (no separate seed scripts needed).

### Schema Migrations

- **20251115231815_initial-tables.sql** - Initial team builds and builds tables with triggers/RLS
- **20251116000632_profession-tables-start.sql** - Professions and attributes tables

### Data Seed Migrations

All seed data is auto-generated from JSON files in `../data/`:

- **20251116015120_seed-professions.sql** - 10 Guild Wars professions
- **20251116015126_seed-attributes.sql** - Profession attributes and rank titles
- **20251116015132_seed-assassin-skills.sql** - Assassin skills (121 skills)
- **20251116015138_seed-common-skills.sql** - Common skills (55 skills)
- **20251116015147_seed-dervish-skills.sql** - Dervish skills (105 skills)
- **20251116015153_seed-elementalist-skills.sql** - Elementalist skills (159 skills)
- **20251116015157_seed-mesmer-skills.sql** - Mesmer skills (167 skills)
- **20251116015205_seed-monk-skills.sql** - Monk skills (152 skills)
- **20251116015211_seed-monster-skills.sql** - Monster skills (391 skills)
- **20251116015254_seed-necromancer-skills.sql** - Necromancer skills (153 skills)
- **20251116015302_seed-paragon-skills.sql** - Paragon skills (110 skills)
- **20251116015318_seed-ranger-skills.sql** - Ranger skills (159 skills)
- **20251116015347_seed-ritualist-skills.sql** - Ritualist skills (144 skills)
- **20251116015403_seed-warrior-skills.sql** - Warrior skills (150 skills)

**Total:** 1,866 skills across all professions

## Regenerating Seed Migrations

When JSON data changes, regenerate the SQL migrations:

```bash
# From the guild-wars-json-data directory
node scripts/generate-seed-migrations.js
```

This overwrites the seed migration files with fresh data from `data/skills/*.json`.

See `../scripts/README.md` for details.

## Development Workflow

1. Make schema changes in a new migration file
2. Update JSON data files if needed (`data/professions.json`, `data/attributes.json`, `data/skills/*.json`)
3. Regenerate seed migrations: `node scripts/generate-seed-migrations.js`
4. Reset database: `npx supabase db reset`
5. Verify data in Supabase dashboard

## Notes

- All seed migrations use `ON CONFLICT DO UPDATE` for idempotency (can be re-run safely)
- Skills are inserted as single large INSERT statements (more efficient than batching)
- All timestamps use Unix epoch format (bigint)
- JSON is the source of truth - never manually edit SQL seed files
