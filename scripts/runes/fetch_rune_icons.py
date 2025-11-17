#!/usr/bin/env python3
"""
Fetch actual icon URLs from Guild Wars Wiki for all runes.

This script reads the existing runes.json, fetches each rune's wiki page,
extracts the actual icon URL, and updates the JSON file.

Usage:
    cd /srv/www/build-wars
    python3 guild-wars-json-data/scripts/runes/fetch_rune_icons.py
"""
import json
import re
import time
import os
import sys

try:
    import requests
except ImportError:
    print("Error: requests module not found. Using curl fallback.")
    import subprocess

# Ensure we're working from the project root
if os.path.basename(os.getcwd()) in ['runes', 'scripts']:
    os.chdir('/srv/www/build-wars')

def fetch_icon_from_wiki(wiki_url, rune_name):
    """Fetch the actual icon URL from a rune's wiki page."""
    try:
        # Try using requests if available
        try:
            response = requests.get(wiki_url, timeout=10)
            if response.status_code != 200:
                print(f"  ⚠️  HTTP {response.status_code}")
                return None
            html = response.text
        except NameError:
            # Fallback to curl if requests not available
            result = subprocess.run(
                ['curl', '-s', wiki_url],
                capture_output=True,
                text=True,
                timeout=10
            )
            if result.returncode != 0:
                print(f"  ⚠️  curl failed")
                return None
            html = result.stdout

        # Look for the icon in the infobox
        # Pattern: src="/images/.../Rune_...png" or src="/images/.../...Holding.png"
        # Exclude thumbnails (those with /thumb/ in the path)
        pattern = r'src="(/images/(?!thumb)[^"]+/(?:Rune|Superior)[^"]*\.png)"'
        matches = re.findall(pattern, html)

        if matches:
            # For attribute runes, the page shows Minor, Major, and Superior variants
            # We need to pick the correct one based on the rune name
            if "Superior" in rune_name:
                # Look for _Sup.png
                for match in matches:
                    if "_Sup.png" in match or "Superior" in match:
                        return f"https://wiki.guildwars.com{match}"
            elif "Major" in rune_name:
                # Look for _Major.png
                for match in matches:
                    if "_Major.png" in match or "Major" in match:
                        return f"https://wiki.guildwars.com{match}"
            elif "Minor" in rune_name:
                # Look for _Minor.png
                for match in matches:
                    if "_Minor.png" in match or "Minor" in match:
                        return f"https://wiki.guildwars.com{match}"

            # If no specific match, use the first one
            icon_path = matches[0]
            return f"https://wiki.guildwars.com{icon_path}"
        else:
            print(f"  ⚠️  No icon found in HTML")
            return None

    except Exception as e:
        print(f"  ❌ Error: {str(e)}")
        return None

# Load existing runes data
print("Loading runes.json...")
with open('guild-wars-json-data/data/runes.json', 'r') as f:
    runes = json.load(f)

print(f"Fetching icon URLs for {len(runes)} runes...")
print("=" * 80)

updated_count = 0
failed_count = 0

for i, rune in enumerate(runes):
    name = rune['name']
    wiki_url = rune.get('wiki_url')

    print(f"\n[{i+1}/{len(runes)}] {name}")

    if not wiki_url:
        print(f"  ⚠️  No wiki_url found")
        failed_count += 1
        continue

    # Fetch the actual icon URL from the wiki
    icon_url = fetch_icon_from_wiki(wiki_url, name)

    if icon_url:
        rune['icon'] = icon_url
        print(f"  ✓ {icon_url}")
        updated_count += 1
    else:
        # Keep the old icon if it exists, otherwise set to None
        if 'icon' not in rune:
            rune['icon'] = None
        failed_count += 1

    # Be nice to the wiki server
    time.sleep(0.3)

print("\n" + "=" * 80)
print(f"\nResults:")
print(f"  Successfully fetched: {updated_count}/{len(runes)}")
print(f"  Failed: {failed_count}/{len(runes)}")

# Write updated data back to file
output_file = 'guild-wars-json-data/data/runes.json'
with open(output_file, 'w') as f:
    json.dump(runes, f, indent=2)

print(f"\n✅ Updated runes.json saved to {output_file}")
