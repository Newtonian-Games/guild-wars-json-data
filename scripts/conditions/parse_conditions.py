#!/usr/bin/env python3
"""
Parse Guild Wars conditions from the wiki.
Extracts condition data from https://wiki.guildwars.com/wiki/Condition
"""

import json
import re
import subprocess
import time
from pathlib import Path

# Base URL for wiki
WIKI_BASE = "https://wiki.guildwars.com"
CONDITION_PAGE = f"{WIKI_BASE}/wiki/Condition"

# Output file path
OUTPUT_FILE = Path(__file__).parent.parent.parent / "data" / "conditions.json"


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

    # Clean whitespace
    text = re.sub(r'\s+', ' ', text).strip()

    return text


def fetch_concise_description(wiki_url, condition_name):
    """Fetch concise description from individual condition page."""
    print(f"  Fetching concise description for {condition_name}...")
    html = fetch_page(wiki_url)

    if not html:
        return ""

    # Look for the concise description in the blockquote section
    # Pattern: <p><b>Concise description:</b> actual description</p>
    desc_match = re.search(
        r'<p><b>Concise description:</b>\s*(.*?)</p>',
        html,
        re.DOTALL
    )

    if desc_match:
        description = clean_text(desc_match.group(1))
        return description

    return ""


def parse_conditions(html):
    """Parse condition data from the wiki page."""
    conditions = []

    # Find the "List of conditions" section
    # Extract each condition from the bulleted list
    list_section = re.search(
        r'<h3>.*?List of conditions.*?</h3>(.*?)<h3',
        html,
        re.DOTALL | re.IGNORECASE
    )

    if not list_section:
        print("⚠️  Could not find conditions list section")
        return conditions

    list_html = list_section.group(1)

    # Extract list items
    list_items = re.findall(
        r'<li>(.*?)</li>',
        list_html,
        re.DOTALL
    )

    for item in list_items:
        # Extract condition name from the link
        name_match = re.search(r'title="([^"]+)"', item)
        if not name_match:
            continue

        name = name_match.group(1)

        # Skip if it's not a valid condition
        if name == "Condition":
            continue

        # Extract description from the list item (text after the em-dash)
        # Em-dash can be &#8212;, &mdash;, or —
        desc_match = re.search(r'(?:&#8212;|&mdash;|—)\s*(.*?)$', item, re.DOTALL)
        description = clean_text(desc_match.group(1)) if desc_match else ""

        # Build wiki URL
        wiki_url = f"{WIKI_BASE}/wiki/{name.replace(' ', '_')}"

        # Fetch concise description from individual page
        concise_description = fetch_concise_description(wiki_url, name)

        conditions.append({
            "name": name,
            "concise_description": concise_description,
            "description": description,
            "wiki_url": wiki_url,
            "icon": None
        })

        # Rate limit
        time.sleep(0.5)

    return conditions


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


def merge_existing_data(conditions, existing_data):
    """Merge existing data (icons, etc.) into parsed data."""
    for condition in conditions:
        condition_name = condition['name']
        if condition_name in existing_data:
            existing = existing_data[condition_name]
            # Preserve icon if it exists
            if existing.get('icon'):
                condition['icon'] = existing['icon']
            # Preserve concise_description if it exists and we didn't fetch a new one
            if not condition.get('concise_description') and existing.get('concise_description'):
                condition['concise_description'] = existing['concise_description']


def save_conditions(conditions):
    """Save conditions to JSON file."""
    # Sort by name for consistency
    conditions.sort(key=lambda x: x['name'])

    with open(OUTPUT_FILE, 'w', encoding='utf-8') as f:
        json.dump(conditions, f, indent=2, ensure_ascii=False)

    print(f"✓ Saved {len(conditions)} conditions to {OUTPUT_FILE}")


def main():
    """Main parsing function."""
    print("=" * 60)
    print("Parsing Guild Wars Conditions")
    print("=" * 60)

    # Load existing data
    print("\n📋 Loading existing data...")
    existing_data = load_existing_data()
    print(f"✓ Found {len(existing_data)} existing items")

    # Fetch main page
    print(f"\n🌐 Fetching {CONDITION_PAGE}...")
    html = fetch_page(CONDITION_PAGE)

    if not html:
        print("❌ Failed to fetch condition page")
        return

    print("✓ Page fetched successfully")

    # Parse conditions
    print("\n📊 Parsing conditions...")
    conditions = parse_conditions(html)

    if not conditions:
        print("❌ No conditions parsed")
        return

    print(f"✓ Parsed {len(conditions)} conditions")

    # Merge existing data
    print("\n🔗 Merging existing data...")
    merge_existing_data(conditions, existing_data)
    icons_preserved = sum(1 for c in conditions if c.get('icon'))
    concise_count = sum(1 for c in conditions if c.get('concise_description'))
    print(f"✓ Preserved {icons_preserved} icon URLs")
    print(f"✓ Fetched/preserved {concise_count} concise descriptions")

    # Save data
    print("\n💾 Saving data...")
    save_conditions(conditions)

    print("\n" + "=" * 60)
    print("✓ Parsing complete!")
    print("=" * 60)

    # Summary
    print("\nSummary:")
    print(f"  • Total conditions: {len(conditions)}")
    print(f"  • With icons: {sum(1 for c in conditions if c.get('icon'))}")
    print(f"  • Without icons: {sum(1 for c in conditions if not c.get('icon'))}")
    print(f"\nNext steps:")
    print(f"  1. Run fetch_conditions_icons.py to fetch missing icons")
    print(f"  2. Run validate_conditions.sh to verify data")


if __name__ == "__main__":
    main()
