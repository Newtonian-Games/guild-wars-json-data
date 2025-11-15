# Skill Progression Script

This script adds progression data to skills by fetching EXACT values from the Guild Wars Wiki.

## Important

**NO GUESSING OR INTERPOLATION** - The script only uses exact values from wiki progression tables.

**NO AUTOMATIC DESCRIPTION UPDATES** - The script does NOT modify skill descriptions. Description updates must be done manually with human judgment to ensure patterns are matched to the correct variables based on context.

## Usage

```bash
# Process first 10 skills that need progression data
./add_skill_progression.py --count 10

# Process a single skill by name
./add_skill_progression.py --skill "Death Nova"

# Process all skills for a profession
./add_skill_progression.py --profession Necromancer

# Dry run (see what would happen)
./add_skill_progression.py --count 10 --dry-run
```

## What It Does

1. Fetches wiki page for the skill
2. Parses the "Progression" table
3. Converts variable names to UpperCamelCase:
   - `%` is converted to "Percent" (e.g., "% of Damage" → `PercentOfDamage`, "Speed boost %" → `SpeedBoostPercent`)
   - Special characters and spaces are removed (e.g., "Health degeneration" → `HealthDegeneration`)
4. Stores EXACT values in `attribute.progression`

## What You Must Do Manually

After running the script, you must manually update skill descriptions:
- Find patterns like `26...85...100` in the description
- Replace with `{{VariableName}}` based on context
- This requires judgment when multiple variables have the same numeric pattern
