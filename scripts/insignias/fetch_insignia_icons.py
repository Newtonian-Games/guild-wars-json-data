#!/usr/bin/env python3
"""
Fetch actual icon URLs from Guild Wars Wiki for all insignias.

This script reads the existing insignias.json, fetches each insignia's wiki page,
extracts the actual icon URL, and updates the JSON file.

Usage:
    cd /srv/www/build-wars
    python3 guild-wars-json-data/scripts/insignias/fetch_insignia_icons.py
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
if os.path.basename(os.getcwd()) in ['insignias', 'scripts']:
    os.chdir('/srv/www/build-wars')

def fetch_icon_from_wiki(wiki_url, insignia_name):
    """Fetch the actual icon URL from an insignia's wiki page."""
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
        # Pattern: src="/images/.../...Insignia.png" or src="/images/.../..._Insignia.png"
        # Exclude thumbnails (those with /thumb/ in the path)
        pattern = r'src="(/images/(?!thumb)[^"]+/(?:[^"]*)?Insignia[^"]*\.png)"'
        matches = re.findall(pattern, html)

        if matches:
            # Use the first match (should be the main icon)
            icon_path = matches[0]
            return f"https://wiki.guildwars.com{icon_path}"
        else:
            print(f"  ⚠️  No icon found in HTML")
            return None

    except Exception as e:
        print(f"  ❌ Error: {str(e)}")
        return None

# Load existing insignias
input_file = 'guild-wars-json-data/data/insignias.json'
with open(input_file, 'r') as f:
    insignias = json.load(f)

print("=" * 80)
print("Fetching Insignia Icons from Guild Wars Wiki")
print("=" * 80)
print(f"\nProcessing {len(insignias)} insignias...\n")

updated_count = 0
for i, insignia in enumerate(insignias):
    name = insignia['name']
    wiki_url = insignia.get('wiki_url')

    if not wiki_url:
        print(f"[{i+1}/{len(insignias)}] ⚠️  {name}: No wiki_url")
        continue

    print(f"[{i+1}/{len(insignias)}] {name}")

    icon_url = fetch_icon_from_wiki(wiki_url, name)

    if icon_url:
        insignia['icon'] = icon_url
        updated_count += 1
        print(f"  ✓ {icon_url}")
    else:
        print(f"  ❌ Failed to fetch icon")

    # Be nice to the wiki server
    time.sleep(0.5)

# Save updated JSON
with open(input_file, 'w') as f:
    json.dump(insignias, f, indent=2)

print("\n" + "=" * 80)
print(f"Updated {updated_count}/{len(insignias)} insignias with icon URLs")
print(f"Saved to {input_file}")
