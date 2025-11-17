#!/usr/bin/env python3
"""
Fetch weapon icon URLs from Guild Wars Wiki.

This script should be run from the project root directory:
    cd /srv/www/build-wars
    python3 guild-wars-json-data/scripts/weapons/fetch_weapon_icons.py
"""
import json
import re
import subprocess
import os

# Ensure we're working from the project root
if os.path.basename(os.getcwd()) in ['weapons', 'scripts']:
    os.chdir('/srv/www/build-wars')

def convert_thumb_to_full_url(img_src):
    """Convert a thumbnail URL to full image URL."""
    if '/thumb/' in img_src:
        # Extract the full path: /images/thumb/a/b/File.jpg/123px-File.jpg -> /images/a/b/File.jpg
        parts = img_src.split('/thumb/')
        if len(parts) == 2:
            # Get the path after thumb and remove the size suffix
            path_parts = parts[1].split('/')
            if len(path_parts) >= 3:
                # Reconstruct: /images/ + path + / + filename
                full_path = f"/images/{path_parts[0]}/{path_parts[1]}/{path_parts[2]}"
                return f"https://wiki.guildwars.com{full_path}"
    else:
        # Already a full image
        return f"https://wiki.guildwars.com{img_src}"
    return None

def fetch_html(url):
    """Fetch HTML from a URL."""
    result = subprocess.run(
        ['curl', '-s', url],
        capture_output=True,
        text=True,
        timeout=10
    )
    if result.returncode == 0:
        return result.stdout
    return None

def fetch_icon_from_wiki(wiki_url, weapon_name):
    """Fetch the actual icon URL from a weapon's wiki page."""
    try:
        html = fetch_html(wiki_url)
        if not html:
            print(f"  ⚠️  curl failed for {weapon_name}")
            return None

        # Check if this is a disambiguation page and follow the link to the actual weapon page
        disambig_match = re.search(r'For the weapon (?:of|with) the same name, see <a href="/wiki/([^"]+)"', html)
        if disambig_match:
            weapon_page = disambig_match.group(1)
            new_url = f"https://wiki.guildwars.com/wiki/{weapon_page}"
            print(f"    → Following disambiguation to {weapon_page}")
            html = fetch_html(new_url)
            if not html:
                print(f"  ⚠️  Failed to fetch disambiguation target")
                return None

        # Priority 1: Look for gallery images (usually the best weapon images)
        gallery_pattern = r'<ul class="gallery[^"]*">.*?</ul>'
        gallery_match = re.search(gallery_pattern, html, re.DOTALL)
        if gallery_match:
            gallery_html = gallery_match.group(0)
            # Find the first image in the gallery
            first_gallery_img = re.search(r'<a href="/wiki/File:([^"]+\.(?:jpg|png))"[^>]*class="image"[^>]*><img[^>]+src="([^"]+)"', gallery_html, re.IGNORECASE)
            if first_gallery_img:
                file_name = first_gallery_img.group(1)
                img_src = first_gallery_img.group(2)
                # Skip icons
                if not any(x in file_name.lower() for x in ['icon', 'tango', '-icon-']):
                    icon_url = convert_thumb_to_full_url(img_src)
                    if icon_url:
                        return icon_url

        # Priority 2: Look for weapon images in floatright divs or infoboxes
        pattern1 = r'<a href="/wiki/File:([^"]+)" class="image"[^>]*><img[^>]+src="(/images/[^"]+\.(?:png|jpg))"'
        matches = re.findall(pattern1, html)

        for file_name, img_src in matches:
            # Skip icons and UI elements
            if any(x in file_name.lower() for x in ['icon', 'tango', '-icon-']):
                continue

            icon_url = convert_thumb_to_full_url(img_src)
            if icon_url:
                return icon_url

        # Priority 3: Direct image sources (non-thumbnail)
        pattern2 = r'src="(/images/(?!thumb)[^"]+\.(?:png|jpg))"'
        matches = re.findall(pattern2, html)

        for match in matches:
            if all(x not in match.lower() for x in ['icon', 'tango', 'ui-', 'powered', 'arenanet']):
                return f"https://wiki.guildwars.com{match}"

        print(f"  ⚠️  No icon found for {weapon_name}")
        return None

    except Exception as e:
        print(f"  ❌ Error fetching {weapon_name}: {str(e)}")
        return None

print("=" * 80)
print("Fetching Weapon Icons from Guild Wars Wiki")
print("=" * 80)

# Load weapons.json
weapons_file = 'guild-wars-json-data/data/weapons.json'
with open(weapons_file, 'r') as f:
    weapons = json.load(f)

# Fetch icons for each weapon variant
total_fetched = 0
total_variants = 0

for weapon in weapons:
    print(f"\nProcessing: {weapon['name']}")

    for variant in weapon.get('variants', []):
        total_variants += 1
        variant_name = variant['name']
        wiki_url = variant.get('wiki_url')

        # Skip if icon already exists and is not the ArenaNet logo
        existing_icon = variant.get('icon')
        if existing_icon and 'arenanet' not in existing_icon.lower():
            print(f"  ✓ {variant_name} (already has icon)")
            total_fetched += 1
            continue

        if not wiki_url:
            print(f"  ⚠️  {variant_name} (no wiki URL)")
            continue

        if existing_icon and 'arenanet' in existing_icon.lower():
            print(f"  Re-fetching icon for {variant_name} (has placeholder)...")
        else:
            print(f"  Fetching icon for {variant_name}...")

        icon_url = fetch_icon_from_wiki(wiki_url, variant_name)

        if icon_url:
            variant['icon'] = icon_url
            total_fetched += 1
            print(f"  ✓ {variant_name}")
        else:
            variant['icon'] = None
            print(f"  ✗ {variant_name} (failed)")

        # Be nice to the wiki server
        import time
        time.sleep(0.5)

# Save updated weapons.json
with open(weapons_file, 'w') as f:
    json.dump(weapons, f, indent=2)

print("\n" + "=" * 80)
print(f"Fetched {total_fetched}/{total_variants} weapon variant icons")
print(f"Saved to {weapons_file}")
print("=" * 80)
