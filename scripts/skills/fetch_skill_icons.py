#!/usr/bin/env python3
"""
Fetch skill icon URLs from Guild Wars Wiki.

This script:
1. Fetches high-res icons from the gallery page
2. Adds is_high_res_icon boolean field for all skills
3. Handles special variants (e.g., skills with parentheses)
4. Fetches standard-res icons from wiki pages for remaining skills

Usage:
    cd /srv/www/build-wars
    python3 guild-wars-json-data/scripts/skills/fetch_skill_icons.py
"""
import json
import re
import os
import sys
import subprocess
import time

# Ensure we're working from the project root
if os.path.basename(os.getcwd()) in ['skills', 'scripts']:
    os.chdir('/srv/www/build-wars')

GALLERY_URL = 'https://wiki.guildwars.com/wiki/Gallery_of_high_resolution_skill_icons/large'
SKILLS_DIR = 'guild-wars-json-data/data/skills'
SCRIPT_DIR = 'guild-wars-json-data/scripts/skills'

def fetch_gallery_page():
    """Fetch the gallery page HTML using curl."""
    print(f"Fetching gallery page: {GALLERY_URL}")
    print("=" * 80)

    result = subprocess.run(
        ['curl', '-s', GALLERY_URL],
        capture_output=True,
        text=True,
        timeout=30
    )

    if result.returncode != 0:
        print(f"❌ Failed to fetch gallery page")
        return None

    return result.stdout

def parse_skill_icons(html):
    """Parse skill icon URLs from the gallery HTML."""
    skill_icons = {}
    # Note: parentheses in URLs are encoded as %28 and %29
    pattern = r'title="([^"]+)"><img[^>]+src="(/images/thumb/[^"]+%28large%29\.jpg)/\d+px-'

    matches = re.findall(pattern, html)

    for skill_name, thumb_path in matches:
        # Decode HTML entities
        skill_name = skill_name.replace('&#39;', "'")
        skill_name = skill_name.replace('&quot;', '"')
        skill_name = skill_name.replace('&amp;', '&')

        # Convert thumbnail path to full image path
        match = re.match(r'/images/thumb(/[^/]+/[^/]+/[^/]+)$', thumb_path)
        if match:
            full_path = f'/images{match.group(1)}'
        else:
            full_path = thumb_path.replace('/thumb/', '/')

        full_url = f'https://wiki.guildwars.com{full_path}'
        skill_icons[skill_name] = full_url

    return skill_icons

def encode_skill_name_for_url(skill_name):
    """Encode skill name for wiki URL."""
    # Remove (PvP) suffix if present
    name = skill_name.replace(' (PvP)', '')

    # Replace spaces with underscores
    encoded = name.replace(' ', '_')
    # Replace quotes
    encoded = encoded.replace('"', '%22')
    # Replace apostrophes
    encoded = encoded.replace("'", '%27')
    return encoded

def fetch_standard_icon_from_wiki(skill_name):
    """Fetch standard-resolution icon from skill's wiki page."""
    encoded_name = encode_skill_name_for_url(skill_name)
    url = f"https://wiki.guildwars.com/wiki/{encoded_name}"

    try:
        result = subprocess.run(
            ['curl', '-s', '-L', url],
            capture_output=True,
            text=True,
            timeout=10
        )
        if result.returncode != 0:
            return None

        html = result.stdout

        # Look for skill icon in the skill-image div
        # Pattern: <div class="skill-image">...<img src="/images/...jpg"
        pattern = r'<div class="skill-image">.*?src="(/images/[^"]+\.jpg)"'
        match = re.search(pattern, html, re.DOTALL)

        if match:
            icon_path = match.group(1)
            # Skip if it's a thumb or large version
            if '/thumb/' not in icon_path and '(large)' not in icon_path.lower():
                return f"https://wiki.guildwars.com{icon_path}"

        return None
    except Exception:
        return None

def load_skill_files():
    """Load all skill JSON files except skill-types.json."""
    skill_files = {}

    for filename in os.listdir(SKILLS_DIR):
        if filename.endswith('.json') and filename != 'skill-types.json':
            filepath = os.path.join(SKILLS_DIR, filename)
            with open(filepath, 'r') as f:
                skills = json.load(f)
                skill_files[filename] = skills

    return skill_files

def update_skill_icons(skill_files, skill_icons):
    """Update skill JSON files with icon URLs and is_high_res_icon field."""
    stats = {
        'total_skills': 0,
        'already_had_icon': 0,
        'high_res_matched': 0,
        'monster_generic': 0,
        'special_variant': 0,
        'standard_res_fetched': 0,
        'still_null': 0
    }

    # Track which icons from the gallery matched any skill name
    matched_icon_names = set()

    # Create a case-insensitive lookup for skill_icons
    skill_icons_lower = {k.lower(): k for k in skill_icons.keys()}

    # First pass: build a map of all skills for variant matching
    all_skills_by_name = {}
    for filename, skills in skill_files.items():
        for skill in skills:
            all_skills_by_name[skill['name']] = skill

    for filename, skills in skill_files.items():
        # Special handling for monster.json - all use generic monster icon
        if filename == 'monster.json':
            monster_icon_url = 'https://wiki.guildwars.com/images/9/92/Monster_skill.jpg'
            for skill in skills:
                stats['total_skills'] += 1
                # Check if icon is already populated
                if skill.get('icon') and skill['icon'] != '':
                    stats['already_had_icon'] += 1
                else:
                    # Set to generic monster icon
                    skill['icon'] = monster_icon_url
                    stats['monster_generic'] += 1
                skill['is_high_res_icon'] = False
            continue

        # Regular handling for non-monster skills
        for skill in skills:
            stats['total_skills'] += 1
            skill_name = skill['name']

            # Check if already has icon
            if skill.get('icon') and skill['icon'] != '':
                # Add is_high_res_icon field based on current icon
                # If it's from gallery (has (large)), it's high-res
                skill['is_high_res_icon'] = '%28large%29' in skill.get('icon', '') or '(large)' in skill.get('icon', '')
                stats['already_had_icon'] += 1
                continue

            # Try to find matching icon
            icon_url = None
            is_high_res = False
            matched_key = None

            # Check if this is a special variant (has parentheses)
            variant_match = re.match(r'^(.+?)\s+\([^)]+\)$', skill_name)
            if variant_match:
                base_name = variant_match.group(1)
                # Try to find the base skill's icon
                if base_name in all_skills_by_name:
                    base_skill = all_skills_by_name[base_name]
                    if base_skill.get('icon'):
                        icon_url = base_skill['icon']
                        is_high_res = base_skill.get('is_high_res_icon', False)
                        stats['special_variant'] += 1
                        skill['icon'] = icon_url
                        skill['is_high_res_icon'] = is_high_res
                        continue

            # Try exact match (case-sensitive) in gallery
            if skill_name in skill_icons:
                icon_url = skill_icons[skill_name]
                matched_key = skill_name
                is_high_res = True
            else:
                # Build list of variations to try
                variations = []

                # If skill name has (PvP), try the base skill name without (PvP)
                if ' (PvP)' in skill_name:
                    base_skill_name = skill_name.replace(' (PvP)', '')
                    variations.append(base_skill_name)
                    # Also try with quotes stripped/added
                    if base_skill_name.startswith('"') and base_skill_name.endswith('"'):
                        variations.append(base_skill_name[1:-1])
                    else:
                        variations.append(f'"{base_skill_name}"')

                # If skill name has quotes, try without quotes
                if skill_name.startswith('"') and skill_name.endswith('"'):
                    skill_name_no_quotes = skill_name[1:-1]
                    variations.append(skill_name_no_quotes)
                # If no quotes, try with quotes
                else:
                    skill_name_with_quotes = f'"{skill_name}"'
                    variations.append(skill_name_with_quotes)

                # Try all variations (case-insensitive)
                for variant in [skill_name] + variations:
                    variant_lower = variant.lower()
                    if variant_lower in skill_icons_lower:
                        actual_key = skill_icons_lower[variant_lower]
                        icon_url = skill_icons[actual_key]
                        matched_key = actual_key
                        is_high_res = True
                        break

            # If we found a gallery match
            if icon_url and is_high_res:
                matched_icon_names.add(matched_key)
                skill['icon'] = icon_url
                skill['is_high_res_icon'] = True
                stats['high_res_matched'] += 1
            else:
                # Try to fetch standard-res icon from wiki
                print(f"  Fetching standard icon for: {skill_name}")
                standard_icon = fetch_standard_icon_from_wiki(skill_name)

                if standard_icon:
                    skill['icon'] = standard_icon
                    skill['is_high_res_icon'] = False
                    stats['standard_res_fetched'] += 1
                else:
                    # Leave as null
                    skill['icon'] = None
                    skill['is_high_res_icon'] = False
                    stats['still_null'] += 1

                # Small delay to be respectful to wiki server
                time.sleep(0.3)

    # Calculate unused icons
    stats['unused_icons'] = set(skill_icons.keys()) - matched_icon_names
    stats['matched_icon_names'] = matched_icon_names

    return stats

def save_skill_files(skill_files):
    """Save updated skill JSON files."""
    for filename, skills in skill_files.items():
        filepath = os.path.join(SKILLS_DIR, filename)
        with open(filepath, 'w') as f:
            json.dump(skills, f, indent=2)
            f.write('\n')

def write_log_file(stats, skill_icons):
    """Write matched and unused icons to a log file."""
    log_path = os.path.join(SCRIPT_DIR, 'fetch_skill_icons.log')

    matched_icons = stats.get('matched_icon_names', set())
    unused_icons = stats.get('unused_icons', set())

    with open(log_path, 'w') as f:
        f.write("=" * 80 + "\n")
        f.write("SKILL ICON FETCH RESULTS\n")
        f.write("=" * 80 + "\n\n")

        f.write(f"Total icons in gallery: {len(skill_icons)}\n")
        f.write(f"Matched icons: {len(matched_icons)}\n")
        f.write(f"Unused icons: {len(unused_icons)}\n\n")

        f.write("=" * 80 + "\n")
        f.write(f"MATCHED ICONS ({len(matched_icons)} total)\n")
        f.write("=" * 80 + "\n")
        f.write("These icons from the gallery matched skill names:\n\n")
        for icon_name in sorted(matched_icons):
            f.write(f"  ✓ {icon_name}\n")
            f.write(f"    {skill_icons[icon_name]}\n")

        f.write("\n" + "=" * 80 + "\n")
        f.write(f"UNUSED ICONS ({len(unused_icons)} total)\n")
        f.write("=" * 80 + "\n")
        f.write("These icons were on the gallery page but didn't match any skills:\n\n")
        for icon_name in sorted(unused_icons):
            f.write(f"  ✗ {icon_name}\n")
            f.write(f"    {skill_icons[icon_name]}\n")

    return log_path

def main():
    print("Fetching skill icons from wiki...")
    print()

    # Fetch and parse gallery
    html = fetch_gallery_page()
    if not html:
        print("❌ Failed to fetch gallery page")
        return 1

    print("✓ Gallery page fetched")
    print()

    # Parse icons
    print("Parsing skill icons from gallery...")
    skill_icons = parse_skill_icons(html)
    print(f"✓ Found {len(skill_icons)} skill icons in gallery")
    print()

    # Load skill files
    print("Loading skill JSON files...")
    skill_files = load_skill_files()
    file_count = len(skill_files)
    print(f"✓ Loaded {file_count} skill files")
    print()

    # Update skills
    print("Updating skill icons...")
    print("=" * 80)
    stats = update_skill_icons(skill_files, skill_icons)
    print("=" * 80)
    print()

    # Save files
    print("Saving updated JSON files...")
    save_skill_files(skill_files)
    print("✓ All files saved")
    print()

    # Write log file
    print("Writing log file...")
    log_path = write_log_file(stats, skill_icons)
    print(f"✓ Log file written to: {log_path}")
    print()

    # Report statistics
    print("=" * 80)
    print("RESULTS:")
    print("=" * 80)
    print(f"Total skills processed:     {stats['total_skills']}")
    print(f"Already had icons:          {stats['already_had_icon']}")
    print(f"High-res matched:           {stats['high_res_matched']}")
    print(f"Monster generic icons:      {stats['monster_generic']}")
    print(f"Special variants:           {stats['special_variant']}")
    print(f"Standard-res fetched:       {stats['standard_res_fetched']}")
    print(f"Still null:                 {stats['still_null']}")
    print()
    print(f"📋 Gallery icons matched: {len(stats.get('matched_icon_names', set()))}")
    print(f"📋 Gallery icons unused: {len(stats.get('unused_icons', set()))}")
    print()
    print(f"📄 See {log_path} for detailed matched/unused icon lists")
    print("=" * 80)

    return 0

if __name__ == '__main__':
    sys.exit(main())
