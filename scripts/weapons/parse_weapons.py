#!/usr/bin/env python3
"""
Parse and generate weapons.json from Guild Wars Wiki.

This script should be run from the project root directory:
    cd /srv/www/build-wars
    python3 guild-wars-json-data/scripts/weapons/parse_weapons.py
"""
import json
import re
import os
import subprocess
import time

# Ensure we're working from the project root
if os.path.basename(os.getcwd()) in ['weapons', 'scripts']:
    os.chdir('/srv/www/build-wars')

def fetch_page(url):
    """Fetch a wiki page using curl."""
    try:
        result = subprocess.run(
            ['curl', '-s', url],
            capture_output=True,
            text=True,
            timeout=10
        )
        if result.returncode == 0:
            return result.stdout
        return None
    except Exception as e:
        print(f"  ⚠️  Error fetching {url}: {str(e)}")
        return None

def parse_damage_range(damage_str):
    """Parse damage range string like '6-28' into min/max dict."""
    match = re.search(r'(\d+)-(\d+)', damage_str)
    if match:
        return {"min": int(match.group(1)), "max": int(match.group(2))}
    return {"min": 0, "max": 0}

def parse_attack_speed(speed_str):
    """Parse attack speed string into float."""
    # Remove sup tags and extract number
    cleaned = re.sub(r'<[^>]+>', '', speed_str)
    match = re.search(r'(\d+\.?\d*)', cleaned)
    if match:
        return float(match.group(1))
    return 0.0

def parse_range(range_str):
    """Parse range string into float."""
    match = re.search(r'(\d+\.?\d*)', range_str)
    if match:
        return float(match.group(1))
    return None

def clean_sup_tags(text):
    """Remove <sup> annotation tags from text."""
    return re.sub(r'<sup[^>]*>.*?</sup>', '', text).strip()

def parse_damage_type(type_str):
    """Parse damage type from HTML string."""
    # Remove HTML tags and sup references
    cleaned = re.sub(r'<[^>]+>', '', type_str).lower().strip()
    if 'slashing' in cleaned:
        return 'slashing'
    elif 'piercing' in cleaned:
        return 'piercing'
    elif 'blunt' in cleaned:
        return 'blunt'
    elif 'by attribute' in cleaned or 'attribute' in cleaned:
        return 'by attribute'
    return 'unknown'

def extract_melee_weapons():
    """Extract melee weapons from the main weapon page."""
    print("Fetching main Weapon page...")
    html = fetch_page("https://wiki.guildwars.com/wiki/Weapon")
    if not html:
        return []

    weapons = []

    # Find the melee weapon comparison table (look for the h3 heading then the table)
    melee_section = re.search(r'<h3[^>]*>.*?Melee weapon comparison.*?</h3>(.*?)</table>', html, re.DOTALL)
    if not melee_section:
        print("  ⚠️  Could not find melee weapon table")
        return weapons

    melee_html = melee_section.group(1)

    # Parse table rows - handle rowspan for professions
    # Split into TR elements and process sequentially
    tr_pattern = r'<tr>(.*?)</tr>'
    trs = re.findall(tr_pattern, melee_html, re.DOTALL)

    current_profession = None

    for tr_html in trs:
        # Check if this row has a profession (with or without rowspan)
        prof_match = re.search(r'rowspan="(\d+)"[^>]*>.*?<a href="/wiki/(\w+)"[^>]*>(\w+)</a>', tr_html)
        if prof_match:
            current_profession = prof_match.group(3)
        else:
            # Check for profession cell without rowspan (single-weapon professions)
            # Profession cells always have an <img> tag (the profession icon)
            single_prof_match = re.search(r'<td[^>]*>.*?<img[^>]*>.*?<a href="/wiki/(\w+)"[^>]*title="(\w+)">(\w+)</a>', tr_html)
            if single_prof_match and single_prof_match.group(1) == single_prof_match.group(2):
                # Make sure it's a profession link (links to itself) and has an icon
                current_profession = single_prof_match.group(3)

        # Extract weapon data from this row
        weapon_match = re.search(r'<td><a href="/wiki/([^"]+)"[^>]*>([^<]+)</a>\s*</td>', tr_html)
        if weapon_match and current_profession:
            weapon_link = weapon_match.group(1)
            weapon_name = weapon_match.group(2)

            # Extract other cells
            cells = re.findall(r'<td[^>]*>(.*?)</td>', tr_html, re.DOTALL)

            # Check if first cell contains a profession (with or without rowspan)
            has_profession_cell = len(cells) > 0 and re.search(r'(tango-icon|File:[A-Z]\w+-)', cells[0])

            # Need at least 6 cells for melee weapons: [prof], weapon, hands, damage, speed, type, properties
            # With profession cell: 7 cells minimum, without: 6 cells minimum
            min_cells = 7 if has_profession_cell else 6
            if len(cells) >= min_cells:
                # Find indices (skip profession cell if present)
                cell_offset = 1 if has_profession_cell else 0

                hands = clean_sup_tags(cells[cell_offset + 1].strip()).lower()
                damage_str = clean_sup_tags(cells[cell_offset + 2].strip())
                speed_str = clean_sup_tags(cells[cell_offset + 3].strip())
                type_str = clean_sup_tags(cells[cell_offset + 4].strip())
                properties_str = clean_sup_tags(cells[cell_offset + 5].strip()) if len(cells) > cell_offset + 5 else ""

                # Validate that we're actually parsing a weapon stats row (damage should be parseable)
                damage_parsed = parse_damage_range(damage_str)
                if damage_parsed['min'] == 0 and damage_parsed['max'] == 0:
                    # This is likely not a stats row (maybe from the types table), skip it
                    continue

                # Create weapon entry
                # Determine attribute requirement - always use current_profession from table parsing
                attribute = None
                if current_profession:
                    # Use proper attribute names
                    attr_name = f"{weapon_name} Mastery" if weapon_name != "Daggers" else "Dagger Mastery"
                    attribute = {
                        "name": attr_name,
                        "profession": current_profession  # This comes from the HTML table and is always correct
                    }

                weapon = {
                    "name": weapon_name,
                    "category": "martial",
                    "subcategory": "melee",
                    "hands": "one" if hands == "one" else "two",
                    "attribute": attribute,
                    "damage": damage_parsed,
                    "variants": [
                        {
                            "name": weapon_name,
                            "attack_speed": parse_attack_speed(speed_str),
                            "range": None,
                            "flight_time": None,
                            "arc_size": None,
                            "damage_type": parse_damage_type(type_str),
                            "properties": {},
                            "wiki_url": f"https://wiki.guildwars.com/wiki/{weapon_link}",
                            "icon": None
                        }
                    ],
                    "wiki_url": f"https://wiki.guildwars.com/wiki/{weapon_link}"
                }

                # Parse special properties (use UpperCamelCase for dynamic keys)
                if properties_str and properties_str.strip() and properties_str.strip() != '&#160;':
                    props = {}
                    # Double strike chance for daggers
                    if 'double strike' in properties_str.lower():
                        props['DoubleStrikeChancePerRank'] = 0.02
                    # Hits additional foes for scythe
                    if 'additional foes' in properties_str.lower():
                        props['HitsAdditionalFoes'] = 2

                    if props:
                        weapon['variants'][0]['properties'] = props
                weapons.append(weapon)
                print(f"  ✓ {weapon_name}")

    return weapons

def extract_ranged_weapons():
    """Extract ranged weapons from the main weapon page."""
    print("\nFetching ranged weapons...")
    html = fetch_page("https://wiki.guildwars.com/wiki/Weapon")
    if not html:
        return []

    weapons = []

    # Find the ranged weapon comparison table - need to handle nested tables
    # Look from the heading to the next h2/h3 section or DPS comparison
    ranged_start = re.search(r'<h3[^>]*>.*?Ranged weapon comparison.*?</h3>', html, re.DOTALL)
    if not ranged_start:
        print("  ⚠️  Could not find ranged weapon table heading")
        return weapons

    # Find the end - look for the next heading or footnotes section
    start_pos = ranged_start.end()
    end_match = re.search(r'(<h[23][^>]*>|<dl><dd><sup>)', html[start_pos:], re.DOTALL)
    if end_match:
        end_pos = start_pos + end_match.start()
    else:
        end_pos = start_pos + 10000  # Fallback

    ranged_html = html[start_pos:end_pos]

    # Parse table rows - need to handle nested tables properly
    # Use a more robust approach: split by <tr> and match up with </tr> accounting for nesting
    trs = []
    tr_starts = [m.start() for m in re.finditer(r'<tr>', ranged_html)]
    for start in tr_starts:
        # Find the matching </tr> by counting nested tr tags
        depth = 0
        pos = start + 4  # After '<tr>'
        while pos < len(ranged_html):
            if ranged_html[pos:pos+4] == '<tr>':
                depth += 1
                pos += 4
            elif ranged_html[pos:pos+5] == '</tr>':
                if depth == 0:
                    trs.append(ranged_html[start+4:pos])
                    break
                else:
                    depth -= 1
                    pos += 5
            else:
                pos += 1

    # Group bow variants together
    bow_variants = []
    other_weapons = []
    current_profession = None

    for tr_html in trs:
        # Remove nested tables first (they confuse cell extraction)
        tr_clean = re.sub(r'<table[^>]*>.*?</table>', '', tr_html, flags=re.DOTALL)

        # Check if this row has a profession (rowspan cell)
        prof_match = re.search(r'rowspan="(\d+)"[^>]*>.*?<a href="/wiki/(\w+)"[^>]*>(\w+)</a>', tr_html)
        if prof_match:
            current_profession = prof_match.group(3)
        else:
            # Check for profession cell without rowspan (single-weapon professions)
            # Profession cells always have an <img> tag (the profession icon)
            single_prof_match = re.search(r'<td[^>]*>.*?<img[^>]*>.*?<a href="/wiki/(\w+)"[^>]*title="(\w+)">(\w+)</a>', tr_html)
            if single_prof_match and single_prof_match.group(1) == single_prof_match.group(2):
                # Make sure it's a profession link (links to itself) and has an icon
                current_profession = single_prof_match.group(3)

        # Extract weapon data from this row
        weapon_match = re.search(r'<td><a href="/wiki/([^"]+)"[^>]*>([^<]+)</a></td>', tr_clean)
        if weapon_match:
            weapon_link = weapon_match.group(1)
            weapon_name = weapon_match.group(2)

            # Extract other cells from cleaned HTML
            cells = re.findall(r'<td[^>]*>(.*?)</td>', tr_clean, re.DOTALL)
            # Need: weapon, hands, damage, speed, range, flight_time, arc_size, type, properties
            # With profession/rowspan: prof, weapon, hands, damage, speed, range, flight_time, arc_size, type, properties (10 cells)
            # Without profession: weapon, hands, damage, speed, range, flight_time, arc_size, type, properties (9 cells)

            # Determine cell offset - check for profession cell or empty rowspan cell
            has_rowspan_cell = len(cells) > 0 and cells[0].strip() == ''
            has_profession_cell = len(cells) > 0 and re.search(r'(tango-icon|File:[A-Z]\w+-)', cells[0])
            cell_offset = 1 if (prof_match or has_rowspan_cell or has_profession_cell) else 0
            required_cells = 10 if (prof_match or has_rowspan_cell or has_profession_cell) else 9

            if len(cells) >= required_cells:

                hands_str = clean_sup_tags(cells[cell_offset + 1].strip()).lower()
                damage_str = clean_sup_tags(cells[cell_offset + 2].strip())
                speed_str = clean_sup_tags(cells[cell_offset + 3].strip())
                range_str = clean_sup_tags(cells[cell_offset + 4].strip())
                flight_time_str = clean_sup_tags(cells[cell_offset + 5].strip())
                arc_size_str = clean_sup_tags(cells[cell_offset + 6].strip())
                type_str = clean_sup_tags(cells[cell_offset + 7].strip())
                properties_str = clean_sup_tags(cells[cell_offset + 8].strip()) if len(cells) > cell_offset + 8 else ""
                variant = {
            "name": weapon_name,
            "attack_speed": parse_attack_speed(speed_str),
            "range": parse_range(range_str),
            "flight_time": parse_range(flight_time_str),
            "arc_size": arc_size_str.lower() if arc_size_str else None,
            "damage_type": parse_damage_type(type_str),
            "properties": {},
            "wiki_url": f"https://wiki.guildwars.com/wiki/{weapon_link}",
            "icon": None
        }
                # Parse special properties (use UpperCamelCase for dynamic keys)
                if properties_str and properties_str.strip() and properties_str.strip() != '&#160;':
                    props = {}
                    # Armor penetration for Hornbow
                    if 'armor penetration' in properties_str.lower():
                        pen_match = re.search(r'(\d+)%', properties_str)
                        if pen_match:
                            props['ArmorPenetration'] = int(pen_match.group(1)) / 100.0
                    # Energy bonus for staff
                    if 'energy' in properties_str.lower():
                        energy_match = re.search(r'\+(\d+)\.\.\.(\d+)', properties_str)
                        if energy_match:
                            props['EnergyBonus'] = {"min": int(energy_match.group(1)), "max": int(energy_match.group(2))}
                    # HSR for staff/wand
                    if 'hsr' in properties_str.lower() or 'half casting time' in properties_str.lower():
                        hsr_match = re.search(r'(\d+)\.\.\.(\d+)%', properties_str)
                        if hsr_match:
                            props['HalfSkillRecharge'] = {"min": int(hsr_match.group(1)), "max": int(hsr_match.group(2))}

                    if props:
                        variant['properties'] = props

                # Check if it's a bow variant
                if 'bow' in weapon_name.lower() and weapon_name != 'Bow':
                    bow_variants.append((damage_str, hands_str, variant))
                    print(f"  ✓ {weapon_name} (Bow variant)")
                else:
                    # Create standalone weapon
                    # Determine attribute requirement
                    attribute = None
                    if current_profession and weapon_name not in ["Staff", "Wand"]:
                        # Spear uses Spear Mastery
                        attr_name = f"{weapon_name} Mastery"
                        attribute = {
                            "name": attr_name,
                            "profession": current_profession
                        }

                    weapon = {
                        "name": weapon_name,
                        "category": "caster" if weapon_name in ["Staff", "Wand"] else "martial",
                        "subcategory": "ranged",
                        "hands": "one" if hands_str == "one" else "two",
                        "attribute": attribute,
                        "damage": parse_damage_range(damage_str),
                        "variants": [variant],
                        "wiki_url": f"https://wiki.guildwars.com/wiki/{weapon_name}"
                    }
                    other_weapons.append(weapon)
                    print(f"  ✓ {weapon_name}")

    # Create Bow weapon with all variants
    if bow_variants:
        damage = parse_damage_range(bow_variants[0][0])  # All bows have same damage
        hands = bow_variants[0][1]
        bow_weapon = {
            "name": "Bow",
            "category": "martial",
            "subcategory": "ranged",
            "hands": "one" if hands.lower() == "one" else "two",
            "attribute": {
                "name": "Marksmanship",
                "profession": "Ranger"
            },
            "damage": damage,
            "variants": [v[2] for v in bow_variants],
            "wiki_url": "https://wiki.guildwars.com/wiki/Bow"
        }
        weapons.append(bow_weapon)
        print(f"  ✓ Bow (with {len(bow_variants)} variants)")

    weapons.extend(other_weapons)

    return weapons

# Load existing weapons to preserve icon URLs
existing_icons = {}
output_file = 'guild-wars-json-data/data/weapons.json'
if os.path.exists(output_file):
    try:
        with open(output_file, 'r') as f:
            existing_data = json.load(f)
            for weapon in existing_data:
                for variant in weapon.get('variants', []):
                    key = f"{weapon['name']}:{variant['name']}"
                    if variant.get('icon'):
                        existing_icons[key] = variant['icon']
            print(f"Loaded {len(existing_icons)} existing icon URLs to preserve\n")
    except Exception as e:
        print(f"Note: Could not load existing data: {e}\n")

# Main execution
print("=" * 80)
print("Parsing Weapons from Guild Wars Wiki")
print("=" * 80)

# Extract weapons
weapons = []
weapons.extend(extract_melee_weapons())
weapons.extend(extract_ranged_weapons())

# Preserve existing icons
for weapon in weapons:
    for variant in weapon.get('variants', []):
        key = f"{weapon['name']}:{variant['name']}"
        if key in existing_icons:
            variant['icon'] = existing_icons[key]

# Sort by name
weapons.sort(key=lambda x: x['name'])

# Write to JSON file
with open(output_file, 'w') as f:
    json.dump(weapons, f, indent=2)

print("\n" + "=" * 80)
print(f"Generated {len(weapons)} weapons")
print(f"Saved to {output_file}")
