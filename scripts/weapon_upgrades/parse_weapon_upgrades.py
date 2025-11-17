#!/usr/bin/env python3
"""
Parse Guild Wars weapon upgrades from the wiki.
Extracts upgrade data from https://wiki.guildwars.com/wiki/List_of_weapon_upgrades
"""

import json
import re
import subprocess
import time
from pathlib import Path

# Base URL for wiki
WIKI_BASE = "https://wiki.guildwars.com"
UPGRADES_PAGE = f"{WIKI_BASE}/wiki/List_of_weapon_upgrades"

# Output file paths
OUTPUT_FILE = Path(__file__).parent.parent.parent / "data" / "weapon_upgrades.json"
WEAPONS_FILE = Path(__file__).parent.parent.parent / "data" / "weapons.json"
CATEGORIES_FILE = Path(__file__).parent.parent.parent / "data" / "weapon_categories.json"

# All Guild Wars attributes
ATTRIBUTES = [
    # Warrior
    "Axe Mastery", "Hammer Mastery", "Swordsmanship", "Strength", "Tactics",
    # Ranger
    "Beast Mastery", "Expertise", "Marksmanship", "Wilderness Survival",
    # Monk
    "Divine Favor", "Healing Prayers", "Protection Prayers", "Smiting Prayers",
    # Necromancer
    "Blood Magic", "Curses", "Death Magic", "Soul Reaping",
    # Mesmer
    "Domination Magic", "Fast Casting", "Illusion Magic", "Inspiration Magic",
    # Elementalist
    "Air Magic", "Earth Magic", "Energy Storage", "Fire Magic", "Water Magic",
    # Assassin
    "Critical Strikes", "Dagger Mastery", "Deadly Arts", "Shadow Arts",
    # Ritualist
    "Channeling Magic", "Communing", "Restoration Magic", "Spawning Power",
    # Paragon
    "Command", "Leadership", "Motivation", "Spear Mastery",
    # Dervish
    "Earth Prayers", "Mysticism", "Scythe Mastery", "Wind Prayers"
]

# Mapping of weapon-specific attributes to their corresponding weapon
# Based on wiki note: "Versions for martial weapons always correspond to the weapon's own attribute"
ATTRIBUTE_TO_WEAPON = {
    "Axe Mastery": "Axe",
    "Hammer Mastery": "Hammer",
    "Swordsmanship": "Sword",
    "Dagger Mastery": "Daggers",
    "Scythe Mastery": "Scythe",
    "Spear Mastery": "Spear",
    "Marksmanship": "Bow",  # Bow attribute
}

# Spellcaster attributes that work on staves (per wiki note)
# Exception: Fast Casting, Energy Storage, and Spawning Power do NOT work on staves
STAFF_ATTRIBUTES = [
    # Monk
    "Divine Favor", "Healing Prayers", "Protection Prayers", "Smiting Prayers",
    # Necromancer
    "Blood Magic", "Curses", "Death Magic", "Soul Reaping",
    # Mesmer
    "Domination Magic", "Illusion Magic", "Inspiration Magic",
    # Elementalist
    "Air Magic", "Earth Magic", "Fire Magic", "Water Magic",
    # Ritualist
    "Channeling Magic", "Communing", "Restoration Magic",
]

PROFESSIONS = [
    "Warrior", "Ranger", "Monk", "Necromancer", "Mesmer",
    "Elementalist", "Assassin", "Ritualist", "Paragon", "Dervish"
]

# Creature types for "of slaying" suffix
SLAYING_TYPES = [
    {"type": "Charr", "suffix": "Charrslaying"},
    {"type": "Demons", "suffix": "Demonslaying"},
    {"type": "Dragons", "suffix": "Dragonslaying"},
    {"type": "Dwarves", "suffix": "Dwarfslaying"},
    {"type": "Giants", "suffix": "Giantslaying"},
    {"type": "Ogres", "suffix": "Ogreslaying"},
    {"type": "Plants", "suffix": "Pruning"},
    {"type": "Tengu", "suffix": "Tenguslaying"},
    {"type": "Trolls", "suffix": "Trollslaying"},
    {"type": "Undead", "suffix": "Deathbane"},
    {"type": "Skeletons", "suffix": "Skeletonslaying"}
]


def fetch_page(url):
    """Fetch a wiki page using curl."""
    try:
        result = subprocess.run(
            ["curl", "-s", "-L", url],
            capture_output=True,
            text=True,
            timeout=30
        )
        return result.stdout
    except Exception as e:
        print(f"⚠️  Failed to fetch {url}: {e}")
        return None


def clean_text(text):
    """Clean HTML text."""
    if not text:
        return ""

    # Remove <sup> annotations
    text = re.sub(r'<sup[^>]*>.*?</sup>', '', text, flags=re.DOTALL)

    # Remove other HTML tags
    text = re.sub(r'<[^>]+>', '', text)

    # Clean HTML entities
    text = text.replace('&amp;', '&')
    text = text.replace('&#39;', "'")
    text = text.replace('&quot;', '"')
    text = text.replace('&nbsp;', ' ')
    text = text.replace('&#8212;', '—')
    text = text.replace('&mdash;', '—')
    text = text.replace('&lt;', '<')
    text = text.replace('&gt;', '>')

    # Clean whitespace
    text = re.sub(r'\s+', ' ', text).strip()

    return text


def load_weapon_names():
    """Load weapon names from weapons.json."""
    if WEAPONS_FILE.exists():
        with open(WEAPONS_FILE, 'r', encoding='utf-8') as f:
            weapons = json.load(f)
            return [weapon['name'] for weapon in weapons]
    return []


def load_weapon_categories():
    """Load weapon categories and create a mapping from weapon lists to category names."""
    if not CATEGORIES_FILE.exists():
        return {}

    with open(CATEGORIES_FILE, 'r', encoding='utf-8') as f:
        categories = json.load(f)

    # Create a mapping from sorted weapon tuple to category name
    weapon_list_to_category = {}
    for category in categories:
        key = tuple(sorted(category['weapons']))
        weapon_list_to_category[key] = category['name']

    return weapon_list_to_category


def map_weapon_category_to_names(category, weapon_names, categories_map):
    """Map weapon category strings from wiki to actual weapon lists, then to category names."""
    category_lower = category.lower()

    # Martial weapons
    martial_weapons = ["Axe", "Bow", "Daggers", "Hammer", "Scythe", "Spear", "Sword"]
    caster_weapons = ["Staff", "Wand"]

    weapon_list = []
    if "martial" in category_lower:
        weapon_list = [w for w in martial_weapons if w in weapon_names]
    elif "spellcasting" in category_lower or "caster" in category_lower:
        weapon_list = [w for w in caster_weapons if w in weapon_names]
    elif "wand" in category_lower:
        weapon_list = ["Wand"]
    elif "staff" in category_lower or "staves" in category_lower:
        weapon_list = ["Staff"]
    elif "focus" in category_lower:
        weapon_list = ["Focus"]
    elif "shield" in category_lower:
        weapon_list = ["Shield"]
    elif "weapon" in category_lower or "equippable" in category_lower:
        # All weapons + Focus + Shield
        weapon_list = weapon_names + ["Focus", "Shield"]

    # Convert weapon list to category name
    if weapon_list:
        key = tuple(sorted(weapon_list))
        return categories_map.get(key, "")

    return ""


def determine_semantic_variable_name(bonus_text, before_text, after_text, has_percent):
    """Determine semantic variable name based on context."""
    bonus_lower = bonus_text.lower()
    before_lower = before_text.lower()
    after_lower = after_text.lower()

    # Life draining
    if 'life drain' in before_lower or 'life drain' in bonus_lower:
        return 'LifeDrain'

    # Enchantment duration
    if 'enchant' in before_lower and ('last' in before_lower or 'duration' in before_lower):
        return 'DurationPercent'

    # Attribute bonuses (for profession upgrades)
    if 'attribute' in before_lower or 'attribute' in after_lower:
        return 'PlusAttribute'

    # Damage bonuses
    if 'damage' in before_lower and has_percent:
        return 'PlusDamagePercent'

    # Energy bonuses
    if 'energy' in before_lower:
        return 'PlusEnergy'

    # Armor bonuses
    if 'armor' in before_lower or 'armor' in after_lower:
        return 'PlusArmor'

    # Chance percentages
    if 'chance' in before_lower or 'chance' in after_lower:
        return 'ChancePercent'

    # Health bonuses
    if 'health' in before_lower:
        return 'PlusHealth'

    # Health regeneration
    if 'health regen' in before_lower or 'health regen' in bonus_lower:
        return 'HealthRegen'

    # Physical damage reduction
    if 'physical damage' in before_lower:
        return 'ChancePercent'

    # Default fallback
    if has_percent:
        return 'DurationPercent'
    return 'Value'


def parse_bonus_with_variables(bonus_text):
    """Parse bonus text and extract variables with ranges using semantic names."""
    # Pattern for ranges like "+10...15%", "+4-5", etc.
    # Matches both ellipsis (...) and hyphen (-) as range separators
    range_pattern = r'([+-]?)(\d+)(?:\.\.\.|-)(\d+)(%?)'

    variables = {}
    description = bonus_text
    var_counter = 1

    for match in re.finditer(range_pattern, bonus_text):
        sign, min_val, max_val, unit = match.groups()

        # Get context around the match for semantic naming
        match_start = match.start()
        match_end = match.end()
        before_text = bonus_text[:match_start]
        after_text = bonus_text[match_end:]

        # Determine semantic variable name
        var_name = determine_semantic_variable_name(
            bonus_text, before_text, after_text, bool(unit)
        )

        # Handle multiple variables in same description
        if var_name in variables:
            var_name = f"{var_name}{var_counter}"
            var_counter += 1

        # Replace range with mustache variable
        replacement = f"{sign}{{{{{var_name}}}}}{unit}"
        description = description.replace(match.group(0), replacement, 1)

        variables[var_name] = {
            "min": int(min_val),
            "max": int(max_val)
        }
        # Note: unit is not stored - it's implied by the semantic variable name

    return description, variables if variables else None


def extract_cells_with_rowspan(row_html):
    """Extract table cells with rowspan awareness."""
    cells = []
    cell_pattern = r'<td([^>]*)>(.*?)</td>'

    for match in re.finditer(cell_pattern, row_html, re.DOTALL):
        attrs = match.group(1)
        content = match.group(2)

        # Check for rowspan attribute
        rowspan_match = re.search(r'rowspan="(\d+)"', attrs)
        rowspan = int(rowspan_match.group(1)) if rowspan_match else 1

        cells.append({
            'content': content,
            'rowspan': rowspan
        })

    return cells


def parse_inscription_table(html, weapon_names, categories_map):
    """Parse inscription upgrades table with rowspan support."""
    upgrades = []

    # Find the Inscription section
    inscription_section = re.search(
        r'<h2[^>]*><span[^>]*id="Inscription_bonuses".*?</h2>(.*?)<h2',
        html,
        re.DOTALL | re.IGNORECASE
    )

    if not inscription_section:
        print("⚠️  Could not find inscription section")
        return upgrades

    section_html = inscription_section.group(1)

    # Find the table
    table_match = re.search(r'<table[^>]*>(.*?)</table>', section_html, re.DOTALL)
    if not table_match:
        print("⚠️  Could not find inscription table")
        return upgrades

    table_html = table_match.group(1)

    # Extract rows
    rows = re.findall(r'<tr[^>]*>(.*?)</tr>', table_html, re.DOTALL)

    # Track rowspan carry-over: {col_index: (value, remaining_rows)}
    rowspan_carry = {}

    for row_idx, row in enumerate(rows[1:], start=1):  # Skip header row
        cells_data = extract_cells_with_rowspan(row)

        # Build complete cell list with rowspan values
        complete_cells = []
        cell_idx = 0

        for col_idx in range(4):  # We expect 4 columns: Name, Bonus, Attaches to, Campaign
            if col_idx in rowspan_carry and rowspan_carry[col_idx][1] > 0:
                # Use carried-over value
                complete_cells.append(rowspan_carry[col_idx][0])
                rowspan_carry[col_idx] = (rowspan_carry[col_idx][0], rowspan_carry[col_idx][1] - 1)
            elif cell_idx < len(cells_data):
                # Use current cell
                cell_content = clean_text(cells_data[cell_idx]['content'])
                complete_cells.append(cell_content)

                # If rowspan > 1, add to carry-over
                if cells_data[cell_idx]['rowspan'] > 1:
                    rowspan_carry[col_idx] = (cell_content, cells_data[cell_idx]['rowspan'] - 1)

                cell_idx += 1
            else:
                complete_cells.append("")

        # Clean up expired rowspans
        rowspan_carry = {k: v for k, v in rowspan_carry.items() if v[1] > 0}

        if len(complete_cells) < 4:
            continue

        name = complete_cells[0]
        bonus = complete_cells[1]
        attaches_to = complete_cells[2]
        campaign = complete_cells[3]

        if not name or name.startswith("No corresponding"):
            continue

        # Remove quotes from name
        name = name.strip('"')

        # Parse bonus with variables
        description, variables = parse_bonus_with_variables(bonus)

        # Map attaches_to to category name
        attaches_to_category = map_weapon_category_to_names(attaches_to, weapon_names, categories_map)

        upgrade = {
            "name": name,
            "type": "inscription",
            "attaches_to": attaches_to_category,
            "description": description,
            "campaign": campaign,
            "wiki_url": f"{WIKI_BASE}/wiki/{name.replace(' ', '_')}",
            "icon": None
        }

        if variables:
            upgrade["variables"] = variables

        upgrades.append(upgrade)

    return upgrades


def parse_prefix_table(html, weapon_names, categories_map):
    """Parse prefix upgrades table."""
    upgrades = []

    # Find the Prefix section
    prefix_section = re.search(
        r'<h2[^>]*><span[^>]*id="Prefix_bonuses".*?</h2>(.*?)<h2',
        html,
        re.DOTALL | re.IGNORECASE
    )

    if not prefix_section:
        print("⚠️  Could not find prefix section")
        return upgrades

    section_html = prefix_section.group(1)

    # Find the table
    table_match = re.search(r'<table[^>]*>(.*?)</table>', section_html, re.DOTALL)
    if not table_match:
        print("⚠️  Could not find prefix table")
        return upgrades

    table_html = table_match.group(1)

    # Extract rows (skip header)
    rows = re.findall(r'<tr[^>]*>(.*?)</tr>', table_html, re.DOTALL)

    for row in rows[1:]:  # Skip header row
        cells = re.findall(r'<td[^>]*>(.*?)</td>', row, re.DOTALL)

        if len(cells) < 3:
            continue

        name = clean_text(cells[0])
        bonus = clean_text(cells[1])
        campaign = clean_text(cells[2])

        if not name:
            continue

        # Special handling for Vampiric upgrade (has different ranges for different weapons)
        if name.lower() == "vampiric":
            # Vampiric has two ranges: 1-3 for some weapons, 1-5 for others
            # From wiki: Axes, daggers, spears, and swords: 1-3
            #           Bows, hammers, and scythes: 1-5
            description = "Life Draining: {{LifeDrain}}Health regeneration: -1"
            variables = {
                "LifeDrain": {
                    "low": {
                        "min": 1,
                        "max": 3,
                        "applies_to": ["Axe", "Daggers", "Spear", "Sword"]
                    },
                    "high": {
                        "min": 1,
                        "max": 5,
                        "applies_to": ["Bow", "Hammer", "Scythe"]
                    }
                }
            }
        else:
            # Parse bonus with variables normally
            description, variables = parse_bonus_with_variables(bonus)

        # Prefix upgrades attach to martial weapons
        attaches_to_category = map_weapon_category_to_names("martial weapons", weapon_names, categories_map)

        upgrade = {
            "name": name,
            "type": "prefix",
            "attaches_to": attaches_to_category,
            "description": description,
            "campaign": campaign,
            "wiki_url": f"{WIKI_BASE}/wiki/{name.replace(' ', '_')}",
            "icon": None
        }

        if variables:
            upgrade["variables"] = variables

        upgrades.append(upgrade)

    return upgrades


def parse_suffix_table(html, weapon_names, categories_map):
    """Parse suffix upgrades table with rowspan support."""
    upgrades = []

    # Find the Suffix section
    suffix_section = re.search(
        r'<h2[^>]*><span[^>]*id="Suffix_bonuses".*?</h2>(.*?)<h2',
        html,
        re.DOTALL | re.IGNORECASE
    )

    if not suffix_section:
        print("⚠️  Could not find suffix section")
        return upgrades

    section_html = suffix_section.group(1)

    # Find the table
    table_match = re.search(r'<table[^>]*>(.*?)</table>', section_html, re.DOTALL)
    if not table_match:
        print("⚠️  Could not find suffix table")
        return upgrades

    table_html = table_match.group(1)

    # Extract rows
    rows = re.findall(r'<tr[^>]*>(.*?)</tr>', table_html, re.DOTALL)

    # Track rowspan carry-over for first two columns (name and bonus can have rowspan)
    rowspan_carry = {}

    for row_idx, row in enumerate(rows[1:], start=1):  # Skip header row
        cells_data = extract_cells_with_rowspan(row)

        # Build complete cell list with rowspan values
        complete_cells = []
        cell_idx = 0

        # Suffix table has: Name, Bonus, 6 weapon columns
        for col_idx in range(8):
            if col_idx in rowspan_carry and rowspan_carry[col_idx][1] > 0:
                # Use carried-over value
                complete_cells.append(rowspan_carry[col_idx][0])
                rowspan_carry[col_idx] = (rowspan_carry[col_idx][0], rowspan_carry[col_idx][1] - 1)
            elif cell_idx < len(cells_data):
                # Use current cell
                cell_content = cells_data[cell_idx]['content']
                complete_cells.append(cell_content)

                # If rowspan > 1, add to carry-over
                if cells_data[cell_idx]['rowspan'] > 1:
                    rowspan_carry[col_idx] = (cell_content, cells_data[cell_idx]['rowspan'] - 1)

                cell_idx += 1
            else:
                complete_cells.append("")

        # Clean up expired rowspans
        rowspan_carry = {k: v for k, v in rowspan_carry.items() if v[1] > 0}

        if len(complete_cells) < 3:
            continue

        name = clean_text(complete_cells[0])
        bonus = clean_text(complete_cells[1])

        # Get applicable weapon types from checkmarks
        # Suffix table columns: Name, Description, Martial weapons, Wands, Staves, Shields, Focus items
        applicable_weapons = []
        if len(complete_cells) >= 7:
            # Check each weapon category column
            weapon_cols = complete_cells[2:7]

            # Map column index to weapon categories
            # Column 0: Martial weapons (Axe, Bow, Daggers, Hammer, Scythe, Spear, Sword)
            # Column 1: Wands
            # Column 2: Staves
            # Column 3: Shields
            # Column 4: Focus items

            for idx, col in enumerate(weapon_cols):
                if "Tick_green" in col or "Tick_yellow" in col:
                    if idx == 0:
                        # Martial weapons
                        applicable_weapons.extend(["Axe", "Bow", "Daggers", "Hammer", "Scythe", "Spear", "Sword"])
                    elif idx == 1:
                        # Wands
                        applicable_weapons.append("Wand")
                    elif idx == 2:
                        # Staves
                        applicable_weapons.append("Staff")
                    elif idx == 3:
                        # Shields
                        applicable_weapons.append("Shield")
                    elif idx == 4:
                        # Focus items
                        applicable_weapons.append("Focus")

        if not name:
            continue

        # Handle variable suffixes (check for both HTML entities and actual brackets)
        has_variable = (("<" in name and ">" in name) or ("&lt;" in name and "&gt;" in name) or
                       ("(" in name and ")" in name and "Profession" in name))

        if has_variable:
            # Special handling for different variable types
            if "<Attribute>" in name:
                # Expand to all attributes that actually exist as upgrades
                # Per wiki: only weapon-specific attributes (on their weapon) and certain caster attributes (on staves)
                for attr in ATTRIBUTES:
                    attr_name = name.replace("<Attribute>", attr)
                    attr_description, variables = parse_bonus_with_variables(bonus.replace("Attribute", attr))

                    # Determine weapon compatibility based on attribute type
                    attr_weapons = []

                    # Check if this is a weapon-specific attribute
                    if attr in ATTRIBUTE_TO_WEAPON:
                        # Only add the specific weapon for this attribute
                        attr_weapons.append(ATTRIBUTE_TO_WEAPON[attr])

                    # Check if this attribute works on staves
                    if attr in STAFF_ATTRIBUTES:
                        attr_weapons.append("Staff")

                    # Skip attributes that don't map to any weapon (e.g., Strength, Tactics, Command, etc.)
                    if not attr_weapons:
                        continue

                    # Convert weapon list to category name
                    weapon_key = tuple(sorted(attr_weapons)) if attr_weapons else ()
                    attaches_to_category = categories_map.get(weapon_key, "")

                    upgrade = {
                        "name": attr_name,
                        "type": "suffix",
                        "attaches_to": attaches_to_category,
                        "description": attr_description,
                        "campaign": "Core",
                        "wiki_url": f"{WIKI_BASE}/wiki/Of_Attribute",
                        "icon": None
                    }

                    if variables:
                        upgrade["variables"] = variables

                    upgrades.append(upgrade)
                continue

            elif "<affiliation or creature type>slaying" in name or "slaying" in name.lower():
                # Expand to all slaying types
                # Per wiki note: "Only for axes, bows, hammers, and swords"
                # Excludes: Daggers, Scythe, Spear
                slaying_weapons = ["Axe", "Bow", "Hammer", "Sword"]

                for slaying in SLAYING_TYPES:
                    slaying_name = f"of {slaying['suffix']}"
                    slaying_desc, variables = parse_bonus_with_variables(
                        bonus.replace("<affiliation or creature type>", slaying['type'])
                    )

                    # Convert weapon list to category name
                    weapon_key = tuple(sorted(slaying_weapons))
                    attaches_to_category = categories_map.get(weapon_key, "")

                    upgrade = {
                        "name": slaying_name,
                        "type": "suffix",
                        "attaches_to": attaches_to_category,
                        "description": slaying_desc,
                        "campaign": "Core",
                        "wiki_url": f"{WIKI_BASE}/wiki/Of_slaying",
                        "icon": None
                    }

                    if variables:
                        upgrade["variables"] = variables

                    upgrades.append(upgrade)
                continue

            elif "Profession" in name:
                # Expand to all professions
                for prof in PROFESSIONS:
                    # Create name like "of the Warrior"
                    prof_name = f"of the {prof}"
                    prof_desc, variables = parse_bonus_with_variables(bonus)

                    # Convert weapon list to category name
                    weapon_key = tuple(sorted(applicable_weapons)) if applicable_weapons else ()
                    attaches_to_category = categories_map.get(weapon_key, "")

                    upgrade = {
                        "name": prof_name,
                        "type": "suffix",
                        "attaches_to": attaches_to_category,
                        "description": prof_desc,
                        "campaign": "Core",
                        "wiki_url": f"{WIKI_BASE}/wiki/Of_the_(Profession)",
                        "icon": None
                    }

                    if variables:
                        upgrade["variables"] = variables

                    upgrades.append(upgrade)
                continue

        # Regular suffix (no variables)
        description, variables = parse_bonus_with_variables(bonus)

        # Convert weapon list to category name
        weapon_key = tuple(sorted(applicable_weapons)) if applicable_weapons else ()
        attaches_to_category = categories_map.get(weapon_key, "")

        upgrade = {
            "name": name,
            "type": "suffix",
            "attaches_to": attaches_to_category,
            "description": description,
            "campaign": "Core",
            "wiki_url": f"{WIKI_BASE}/wiki/{name.replace(' ', '_')}",
            "icon": None
        }

        if variables:
            upgrade["variables"] = variables

        upgrades.append(upgrade)

    return upgrades


def load_existing_data():
    """Load existing data from the output file."""
    if OUTPUT_FILE.exists():
        try:
            with open(OUTPUT_FILE, 'r', encoding='utf-8') as f:
                data = json.load(f)
                return {item['name']: item for item in data}
        except Exception as e:
            print(f"⚠️  Could not load existing data: {e}")
    return {}


def merge_existing_data(upgrades, existing_data):
    """Merge existing data (icons only) into parsed data."""
    for upgrade in upgrades:
        upgrade_name = upgrade['name']
        if upgrade_name in existing_data:
            existing = existing_data[upgrade_name]
            # Preserve icon if it exists
            if existing.get('icon'):
                upgrade['icon'] = existing['icon']
            # Note: attaches_to is NOT preserved as it's derived from parsing logic


def save_upgrades(upgrades):
    """Save upgrades to JSON file."""
    # Sort by type, then name
    upgrades.sort(key=lambda x: (x['type'], x['name']))

    with open(OUTPUT_FILE, 'w', encoding='utf-8') as f:
        json.dump(upgrades, f, indent=2, ensure_ascii=False)

    print(f"✓ Saved {len(upgrades)} upgrades to {OUTPUT_FILE}")


def main():
    """Main parsing function."""
    print("=" * 60)
    print("Parsing Guild Wars Weapon Upgrades")
    print("=" * 60)

    # Load weapon names
    print("\n📋 Loading weapon names...")
    weapon_names = load_weapon_names()
    print(f"✓ Found {len(weapon_names)} weapon types")

    # Load weapon categories
    print("\n📋 Loading weapon categories...")
    categories_map = load_weapon_categories()
    print(f"✓ Found {len(categories_map)} weapon categories")

    # Load existing data
    print("\n📋 Loading existing data...")
    existing_data = load_existing_data()
    print(f"✓ Found {len(existing_data)} existing upgrades")

    # Fetch main page
    print(f"\n🌐 Fetching {UPGRADES_PAGE}...")
    html = fetch_page(UPGRADES_PAGE)

    if not html:
        print("❌ Failed to fetch upgrades page")
        return

    print("✓ Page fetched successfully")

    # Parse all tables
    all_upgrades = []

    print("\n📊 Parsing inscription bonuses...")
    inscriptions = parse_inscription_table(html, weapon_names, categories_map)
    print(f"✓ Parsed {len(inscriptions)} inscription bonuses")
    all_upgrades.extend(inscriptions)

    print("\n📊 Parsing prefix bonuses...")
    prefixes = parse_prefix_table(html, weapon_names, categories_map)
    print(f"✓ Parsed {len(prefixes)} prefix bonuses")
    all_upgrades.extend(prefixes)

    print("\n📊 Parsing suffix bonuses...")
    suffixes = parse_suffix_table(html, weapon_names, categories_map)
    print(f"✓ Parsed {len(suffixes)} suffix bonuses")
    all_upgrades.extend(suffixes)

    # Merge existing data
    print("\n🔗 Merging existing data...")
    merge_existing_data(all_upgrades, existing_data)
    icons_preserved = sum(1 for u in all_upgrades if u.get('icon'))
    print(f"✓ Preserved {icons_preserved} icon URLs")

    # Save data
    print("\n💾 Saving data...")
    save_upgrades(all_upgrades)

    print("\n" + "=" * 60)
    print("✓ Parsing complete!")
    print("=" * 60)

    # Summary
    print("\nSummary:")
    print(f"  • Total upgrades: {len(all_upgrades)}")
    print(f"  • Inscriptions: {len(inscriptions)}")
    print(f"  • Prefixes: {len(prefixes)}")
    print(f"  • Suffixes: {len(suffixes)}")
    print(f"  • With icons: {sum(1 for u in all_upgrades if u.get('icon'))}")
    print(f"  • Without icons: {sum(1 for u in all_upgrades if not u.get('icon'))}")
    print(f"\nNext steps:")
    print(f"  1. Run fetch_weapon_upgrades_icons.py to fetch missing icons")
    print(f"  2. Run validate_weapon_upgrades.sh to verify data")


if __name__ == "__main__":
    main()
