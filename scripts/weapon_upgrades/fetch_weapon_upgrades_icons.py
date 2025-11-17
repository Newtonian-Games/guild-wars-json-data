#!/usr/bin/env python3
"""
Fetch icon URLs for Guild Wars weapon upgrades.
Maps upgrades to appropriate icons based on weapon type compatibility.
"""

import json
import re
import subprocess
import time
from pathlib import Path

# Base URL for wiki
WIKI_BASE = "https://wiki.guildwars.com"

# Data file path
DATA_FILE = Path(__file__).parent.parent.parent / "data" / "weapon_upgrades.json"

# Icon mapping rules
# Inscriptions use category-based icons
INSCRIPTION_ICONS = {
    "all": f"{WIKI_BASE}/images/2/22/Inscription_weapons.png",
    "martial": f"{WIKI_BASE}/images/d/dc/Inscription_martial_weapons.png",
    "spellcasting": f"{WIKI_BASE}/images/f/f0/Inscription_spellcasting_weapons.png",
    "focus": f"{WIKI_BASE}/images/5/59/Inscription_focus_items.png",
    "focus_or_shields": f"{WIKI_BASE}/images/6/61/Inscription_focus_items_or_shields.png",
    "equippable": f"{WIKI_BASE}/images/2/2e/Inscription_equippable_items.png"
}

# Prefix/Suffix use weapon-specific icons
# Map weapon name to lowercase for icon filename
WEAPON_ICON_MAP = {
    "Axe": "axe",
    "Bow": "bow",
    "Daggers": "daggers",
    "Hammer": "hammer",
    "Scythe": "scythe",
    "Spear": "spear",
    "Sword": "sword",
    "Staff": "staff",
    "Wand": "wand",
    "Focus": "focus",
    "Shield": "shield"
}


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


def determine_inscription_icon(attaches_to):
    """Determine which inscription icon to use based on attaches_to list."""
    weapon_set = set(attaches_to)

    # Check for equippable items (all weapons + focus + shield)
    if len(weapon_set) >= 11:  # All weapons, focus, and shield
        return INSCRIPTION_ICONS["equippable"]

    # Check for all weapons (no focus/shield distinction)
    martial_weapons = {"Axe", "Bow", "Daggers", "Hammer", "Scythe", "Spear", "Sword"}
    spellcasting_weapons = {"Staff", "Wand"}

    has_martial = bool(weapon_set & martial_weapons)
    has_spellcasting = bool(weapon_set & spellcasting_weapons)
    has_focus = "Focus" in weapon_set
    has_shield = "Shield" in weapon_set

    # Check if it's all weapons
    if weapon_set == (martial_weapons | spellcasting_weapons):
        return INSCRIPTION_ICONS["all"]

    # Check for focus items or shields
    if has_focus and has_shield and not has_martial and not has_spellcasting:
        return INSCRIPTION_ICONS["focus_or_shields"]

    # Check for focus items only
    if has_focus and not has_shield and not has_martial and not has_spellcasting:
        return INSCRIPTION_ICONS["focus"]

    # Check for martial weapons
    if has_martial and not has_spellcasting:
        return INSCRIPTION_ICONS["martial"]

    # Check for spellcasting weapons
    if has_spellcasting and not has_martial:
        return INSCRIPTION_ICONS["spellcasting"]

    # Default to all weapons icon
    return INSCRIPTION_ICONS["all"]


def determine_prefix_suffix_icon(attaches_to, upgrade_type):
    """Determine icon for prefix/suffix based on primary weapon."""
    if not attaches_to:
        return None

    # Use the first weapon in attaches_to list as the primary
    primary_weapon = attaches_to[0]

    if primary_weapon not in WEAPON_ICON_MAP:
        return None

    weapon_icon_name = WEAPON_ICON_MAP[primary_weapon]

    # Construct icon URL
    icon_type = "Prefix" if upgrade_type == "prefix" else "Suffix"
    return f"{WIKI_BASE}/images/{icon_type}_{weapon_icon_name}.png"


def extract_subtype_from_icon_url(icon_url, upgrade_type):
    """Extract subtype from icon URL."""
    if not icon_url:
        return None

    # Get filename from URL
    filename = icon_url.split('/')[-1]
    # Remove extension
    filename_without_ext = filename.rsplit('.', 1)[0]

    subtype = None
    if upgrade_type == 'inscription':
        # Extract subtype from "Inscription_spellcasting_weapons" -> "spellcasting weapons"
        if filename_without_ext.startswith('Inscription_'):
            subtype = filename_without_ext.replace('Inscription_', '')
    elif upgrade_type in ['prefix', 'suffix']:
        # Extract weapon from "Prefix_axe" or "Suffix_hammer" -> "axe" or "hammer"
        prefix = f"{upgrade_type.capitalize()}_"
        if filename_without_ext.startswith(prefix):
            subtype = filename_without_ext.replace(prefix, '')

    # Replace underscores with spaces for readability
    if subtype:
        subtype = subtype.replace('_', ' ')

    return subtype


def assign_icon_to_upgrade(upgrade):
    """Assign appropriate icon URL to an upgrade based on its type and weapons."""
    upgrade_type = upgrade.get('type', '')
    attaches_to = upgrade.get('attaches_to', [])

    if upgrade_type == 'inscription':
        return determine_inscription_icon(attaches_to)
    elif upgrade_type in ['prefix', 'suffix']:
        return determine_prefix_suffix_icon(attaches_to, upgrade_type)

    return None


def assign_icons_and_subtypes(upgrades):
    """Assign icon URLs and subtypes to all upgrades based on their weapon compatibility."""
    updated_count = 0

    for upgrade in upgrades:
        # Check if subtype needs updating (missing or has underscores)
        current_subtype = upgrade.get('subtype')
        needs_subtype_update = not current_subtype or '_' in (current_subtype or '')

        if upgrade.get('icon') and not needs_subtype_update:
            # Skip if already has icon and subtype doesn't need updating
            continue

        icon_url = assign_icon_to_upgrade(upgrade)

        if icon_url:
            upgrade['icon'] = icon_url

            # Extract and set subtype from icon URL
            subtype = extract_subtype_from_icon_url(icon_url, upgrade['type'])
            if subtype:
                upgrade['subtype'] = subtype

            updated_count += 1
            subtype_str = f" → subtype: {subtype}" if subtype else ""
            print(f"  ✓ {upgrade['name']} ({upgrade['type']}): {icon_url}{subtype_str}")
        else:
            print(f"  ⚠️  {upgrade['name']} ({upgrade['type']}): No icon determined")

    return updated_count


def save_upgrades(upgrades):
    """Save upgrades to JSON file."""
    with open(DATA_FILE, 'w', encoding='utf-8') as f:
        json.dump(upgrades, f, indent=2, ensure_ascii=False)

    print(f"\n✓ Saved upgrades to {DATA_FILE}")


def main():
    """Main function."""
    print("=" * 60)
    print("Assigning Guild Wars Weapon Upgrade Icons")
    print("=" * 60)

    # Load existing data
    print("\n📋 Loading upgrades data...")

    if not DATA_FILE.exists():
        print("❌ weapon_upgrades.json not found. Run parse_weapon_upgrades.py first.")
        return

    with open(DATA_FILE, 'r', encoding='utf-8') as f:
        upgrades = json.load(f)

    print(f"✓ Loaded {len(upgrades)} upgrades")

    # Count upgrades without icons or subtypes, and subtypes needing format update
    missing_icons = sum(1 for u in upgrades if not u.get('icon'))
    missing_subtypes = sum(1 for u in upgrades if not u.get('subtype'))
    subtypes_with_underscores = sum(1 for u in upgrades if u.get('subtype') and '_' in u.get('subtype'))
    print(f"  • {missing_icons} without icons")
    print(f"  • {missing_subtypes} without subtypes")
    print(f"  • {subtypes_with_underscores} with snake_case subtypes (need conversion)")

    if missing_icons == 0 and missing_subtypes == 0 and subtypes_with_underscores == 0:
        print("\n✓ All upgrades already have icons and subtypes!")
        return

    # Assign icons and subtypes
    print("\n🎨 Assigning icons and subtypes based on weapon compatibility...")
    updated_count = assign_icons_and_subtypes(upgrades)

    # Save data
    print("\n💾 Saving data...")
    save_upgrades(upgrades)

    print("\n" + "=" * 60)
    print("✓ Icon assignment complete!")
    print("=" * 60)

    # Summary
    print("\nSummary:")
    print(f"  • Icons assigned: {updated_count}")
    print(f"  • Total with icons: {sum(1 for u in upgrades if u.get('icon'))}/{len(upgrades)}")

    # Show icon distribution
    print("\nIcon distribution:")
    icon_counts = {}
    for upgrade in upgrades:
        icon = upgrade.get('icon')
        if icon:
            icon_name = icon.split('/')[-1]
            icon_counts[icon_name] = icon_counts.get(icon_name, 0) + 1

    for icon_name in sorted(icon_counts.keys()):
        print(f"  • {icon_name}: {icon_counts[icon_name]} upgrades")

    if updated_count > 0:
        print(f"\nNext step:")
        print(f"  • Run validate_weapon_upgrades.sh to verify data")


if __name__ == "__main__":
    main()
