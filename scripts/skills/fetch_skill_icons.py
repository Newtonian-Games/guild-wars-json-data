#!/usr/bin/env python3
"""
Fetch high-res skill icon URLs from Guild Wars Wiki gallery page.

This script reads the gallery page, extracts skill icon URLs, and updates
all skill JSON files with matching icons (except monster.json).

Usage:
    cd /srv/www/build-wars
    python3 guild-wars-json-data/scripts/skills/fetch_skill_icons.py
"""
import json
import re
import os
import sys
import subprocess

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
    # Pattern: class="image" title="Skill Name"><img alt="..." src="/images/thumb/.../File_(large).jpg/100px-..."

    skill_icons = {}

    # Find all image links with titles
    # Match: class="image" title="Skill Name"><img ... src="/images/thumb/.../filename.jpg/100px-..."
    # Note: parentheses in URLs are encoded as %28 and %29
    pattern = r'title="([^"]+)"><img[^>]+src="(/images/thumb/[^"]+%28large%29\.jpg)/\d+px-'

    matches = re.findall(pattern, html)

    for skill_name, thumb_path in matches:
        # Decode HTML entities
        skill_name = skill_name.replace('&#39;', "'")
        skill_name = skill_name.replace('&quot;', '"')
        skill_name = skill_name.replace('&amp;', '&')

        # Convert thumbnail path to full image path
        # /images/thumb/a/b/File_(large).jpg -> /images/a/b/File_(large).jpg
        # Extract the filename parts after /images/thumb/
        match = re.match(r'/images/thumb(/[^/]+/[^/]+/[^/]+)$', thumb_path)
        if match:
            full_path = f'/images{match.group(1)}'
        else:
            # Fallback: just remove /thumb/
            full_path = thumb_path.replace('/thumb/', '/')

        full_url = f'https://wiki.guildwars.com{full_path}'

        skill_icons[skill_name] = full_url

    return skill_icons

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
    """Update skill JSON files with icon URLs."""
    stats = {
        'total_skills': 0,
        'matched': 0,
        'already_had_icon': 0,
        'updated': 0,
        'not_found': 0
    }

    # Track which icons from the gallery matched any skill name
    matched_icon_names = set()

    # Create a case-insensitive lookup for skill_icons
    skill_icons_lower = {k.lower(): k for k in skill_icons.keys()}

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
                    stats['updated'] += 1
                stats['matched'] += 1
            continue

        # Regular handling for non-monster skills
        for skill in skills:
            stats['total_skills'] += 1
            skill_name = skill['name']

            # Try to find matching icon
            icon_url = None
            matched_key = None

            # Try exact match (case-sensitive)
            if skill_name in skill_icons:
                icon_url = skill_icons[skill_name]
                matched_key = skill_name
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
                        break

            # Check if we found a match
            if icon_url:
                matched_icon_names.add(matched_key)

                # Check if icon is already populated (not empty string or null)
                if skill.get('icon') and skill['icon'] != '':
                    stats['already_had_icon'] += 1
                else:
                    # Update the icon
                    skill['icon'] = icon_url
                    stats['updated'] += 1

                stats['matched'] += 1
            else:
                # Leave as null if not found (don't use empty string)
                if 'icon' in skill and skill['icon'] == '':
                    skill['icon'] = None
                stats['not_found'] += 1

    # Calculate unused icons (icons on gallery that didn't match any skill)
    stats['unused_icons'] = set(skill_icons.keys()) - matched_icon_names
    stats['matched_icon_names'] = matched_icon_names

    return stats

def save_skill_files(skill_files):
    """Save updated skill JSON files."""
    for filename, skills in skill_files.items():
        filepath = os.path.join(SKILLS_DIR, filename)
        with open(filepath, 'w') as f:
            json.dump(skills, f, indent=2)

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
    print("Fetching skill icons from wiki gallery...")
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
    print(f"Matched and updated:        {stats['updated']}")
    print(f"Not found in gallery:       {stats['not_found']}")
    print()
    print(f"✓ Successfully matched {stats['matched']} skills")
    print(f"⚠️  {stats['not_found']} skills still need icons")
    print()
    print(f"📋 Gallery icons matched: {len(stats.get('matched_icon_names', set()))}")
    print(f"📋 Gallery icons unused: {len(stats.get('unused_icons', set()))}")
    print()
    print(f"📄 See {log_path} for detailed matched/unused icon lists")
    print("=" * 80)

    return 0

if __name__ == '__main__':
    sys.exit(main())
