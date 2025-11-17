#!/usr/bin/env python3
"""
Fetch icon URLs for Guild Wars conditions.
Updates the conditions.json file with icon URLs from wiki pages.
"""

import json
import re
import subprocess
import time
from pathlib import Path

# Base URL for wiki
WIKI_BASE = "https://wiki.guildwars.com"

# Data file path
DATA_FILE = Path(__file__).parent.parent.parent / "data" / "conditions.json"


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


def extract_icon_url(html, condition_name):
    """Extract icon URL from condition page."""
    # Look for the condition icon in the infobox or main content
    # Pattern: Look for images with the condition name in the alt text

    # Try multiple variations of the condition name
    name_variations = [
        condition_name,  # "Cracked Armor"
        condition_name.replace(' ', '_'),  # "Cracked_Armor"
    ]

    for name_var in name_variations:
        # Try to find the condition icon (typically 64x64 or similar)
        # Look for images in the page that match the condition name
        icon_pattern = rf'<img[^>]*alt="{re.escape(name_var)}"[^>]*src="([^"]+)"'
        matches = re.findall(icon_pattern, html, re.IGNORECASE)

        if not matches:
            # Alternative: Look for File:{condition_name}.jpg links
            file_pattern = rf'<a[^>]*href="(/wiki/File:{re.escape(name_var)}\.(?:jpg|png|gif))"'
            file_matches = re.findall(file_pattern, html, re.IGNORECASE)

            if file_matches:
                # Fetch the file page to get the actual image URL
                file_url = f"{WIKI_BASE}{file_matches[0]}"
                file_html = fetch_page(file_url)

                if file_html:
                    # Extract the full image URL from the file page
                    full_img_pattern = r'<div class="fullImageLink"[^>]*>.*?<a href="([^"]+)"'
                    full_img_match = re.search(full_img_pattern, file_html, re.DOTALL)

                    if full_img_match:
                        img_url = full_img_match.group(1)
                        if img_url.startswith('/'):
                            img_url = f"{WIKI_BASE}{img_url}"
                        return img_url

        if matches:
            # Convert thumbnail URL to full image URL
            img_url = matches[0]

            # Remove thumbnail sizing from URL
            # /images/thumb/a/b/File.jpg/25px-File.jpg -> /images/a/b/File.jpg
            img_url = re.sub(r'/thumb(/[^/]+/[^/]+/[^/]+)/\d+px-[^/]+$', r'\1', img_url)

            # Ensure full URL
            if img_url.startswith('/'):
                img_url = f"{WIKI_BASE}{img_url}"

            return img_url

    return None


def fetch_icons(conditions):
    """Fetch icon URLs for conditions that don't have them."""
    updated_count = 0

    for condition in conditions:
        # Skip if already has icon
        if condition.get('icon'):
            print(f"  ✓ {condition['name']}: Already has icon")
            continue

        print(f"  🔍 {condition['name']}: Fetching icon...")

        # Fetch the condition page
        html = fetch_page(condition['wiki_url'])

        if not html:
            print(f"    ⚠️  Failed to fetch page")
            continue

        # Extract icon URL
        icon_url = extract_icon_url(html, condition['name'])

        if icon_url:
            condition['icon'] = icon_url
            updated_count += 1
            print(f"    ✓ Found: {icon_url}")
        else:
            print(f"    ⚠️  No icon found")

        # Rate limit
        time.sleep(0.5)

    return updated_count


def save_conditions(conditions):
    """Save conditions to JSON file."""
    with open(DATA_FILE, 'w', encoding='utf-8') as f:
        json.dump(conditions, f, indent=2, ensure_ascii=False)

    print(f"\n✓ Saved conditions to {DATA_FILE}")


def main():
    """Main function."""
    print("=" * 60)
    print("Fetching Guild Wars Condition Icons")
    print("=" * 60)

    # Load existing data
    print("\n📋 Loading conditions data...")

    if not DATA_FILE.exists():
        print("❌ conditions.json not found. Run parse_conditions.py first.")
        return

    with open(DATA_FILE, 'r', encoding='utf-8') as f:
        conditions = json.load(f)

    print(f"✓ Loaded {len(conditions)} conditions")

    # Count conditions without icons
    missing_icons = sum(1 for c in conditions if not c.get('icon'))
    print(f"  • {missing_icons} without icons")

    if missing_icons == 0:
        print("\n✓ All conditions already have icons!")
        return

    # Fetch icons
    print("\n🌐 Fetching icons...")
    updated_count = fetch_icons(conditions)

    # Save data
    print("\n💾 Saving data...")
    save_conditions(conditions)

    print("\n" + "=" * 60)
    print("✓ Icon fetching complete!")
    print("=" * 60)

    # Summary
    print("\nSummary:")
    print(f"  • Icons updated: {updated_count}")
    print(f"  • Total with icons: {sum(1 for c in conditions if c.get('icon'))}/{len(conditions)}")

    if updated_count > 0:
        print(f"\nNext step:")
        print(f"  • Run validate_conditions.sh to verify data")


if __name__ == "__main__":
    main()
