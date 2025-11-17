#!/usr/bin/env python3
"""
Validate runes data against Guild Wars Wiki pages.

This script requires beautifulsoup4 and requests:
    pip install beautifulsoup4 requests

Usage:
    cd /srv/www/build-wars
    python3 guild-wars-json-data/scripts/runes/validate_runes.py

Note: This is a more thorough Python-based validator. For a simpler
validation that doesn't require extra dependencies, use validate_runes.sh
"""
import json
import requests
from bs4 import BeautifulSoup
import time
import re
import os

# Ensure we're working from the project root
if os.path.basename(os.getcwd()) in ['runes', 'scripts']:
    os.chdir('/srv/www/build-wars')

# Load runes data
with open('guild-wars-json-data/data/runes.json', 'r') as f:
    runes = json.load(f)

print(f"Validating {len(runes)} runes...")
print("=" * 80)

errors = []
warnings = []
validated_count = 0

for i, rune in enumerate(runes):
    name = rune['name']
    wiki_url = rune['wiki_url']

    print(f"\n[{i+1}/{len(runes)}] Validating: {name}")
    print(f"  URL: {wiki_url}")

    try:
        # Fetch the wiki page
        response = requests.get(wiki_url, timeout=10)

        if response.status_code == 404:
            errors.append(f"❌ {name}: Page not found (404)")
            print(f"  ❌ Page not found (404)")
            continue
        elif response.status_code != 200:
            errors.append(f"❌ {name}: HTTP {response.status_code}")
            print(f"  ❌ HTTP {response.status_code}")
            continue

        # Parse HTML
        soup = BeautifulSoup(response.text, 'html.parser')

        # Find the infobox
        infobox = soup.find('table', class_='item-infobox')

        if not infobox:
            warnings.append(f"⚠️  {name}: No infobox found on page")
            print(f"  ⚠️  No infobox found")
            continue

        # Extract rarity from the page
        page_rarity = None
        rarity_cell = infobox.find('th', string=re.compile('Rarity', re.I))
        if rarity_cell:
            rarity_td = rarity_cell.find_next_sibling('td')
            if rarity_td:
                rarity_text = rarity_td.get_text(strip=True)
                # Map wiki rarity names to our system
                if 'Common' in rarity_text or 'Blue' in rarity_text or 'Minor' in rarity_text:
                    page_rarity = 'common'
                elif 'Uncommon' in rarity_text or 'Purple' in rarity_text or 'Major' in rarity_text:
                    page_rarity = 'uncommon'
                elif 'Rare' in rarity_text or 'Gold' in rarity_text or 'Superior' in rarity_text:
                    page_rarity = 'rare'

        # Validate rarity
        if page_rarity and page_rarity != rune['rarity']:
            errors.append(f"❌ {name}: Rarity mismatch - JSON has '{rune['rarity']}', wiki has '{page_rarity}'")
            print(f"  ❌ Rarity mismatch: JSON='{rune['rarity']}', wiki='{page_rarity}'")
        elif page_rarity:
            print(f"  ✓ Rarity: {page_rarity}")

        # Extract effects from description in the page
        page_text = soup.get_text()

        # Check for health bonus/penalty
        if 'healthBonus' in rune.get('effects', {}):
            health_bonus = rune['effects']['healthBonus']
            if f"Health +{health_bonus}" not in page_text:
                warnings.append(f"⚠️  {name}: Health bonus +{health_bonus} not found in page text")
                print(f"  ⚠️  Health bonus +{health_bonus} not verified")
            else:
                print(f"  ✓ Health bonus: +{health_bonus}")

        if 'healthPenalty' in rune.get('effects', {}):
            health_penalty = abs(rune['effects']['healthPenalty'])
            if f"Health -{health_penalty}" not in page_text and f"Health-{health_penalty}" not in page_text:
                warnings.append(f"⚠️  {name}: Health penalty -{health_penalty} not found in page text")
                print(f"  ⚠️  Health penalty -{health_penalty} not verified")
            else:
                print(f"  ✓ Health penalty: -{health_penalty}")

        # Check for attribute bonus
        if 'attributeBonus' in rune.get('effects', {}):
            attr_bonus = rune['effects']['attributeBonus']
            attribute = rune.get('attribute', '')
            if attribute and f"+{attr_bonus}" in page_text:
                print(f"  ✓ Attribute bonus: {attribute} +{attr_bonus}")
            else:
                warnings.append(f"⚠️  {name}: Attribute bonus +{attr_bonus} not clearly verified")

        # Check for energy bonus
        if 'energyBonus' in rune.get('effects', {}):
            energy_bonus = rune['effects']['energyBonus']
            if f"Energy +{energy_bonus}" not in page_text:
                warnings.append(f"⚠️  {name}: Energy bonus +{energy_bonus} not found in page text")
                print(f"  ⚠️  Energy bonus +{energy_bonus} not verified")
            else:
                print(f"  ✓ Energy bonus: +{energy_bonus}")

        # Check for damage reduction
        if 'damageReduction' in rune.get('effects', {}):
            dmg_reduction = rune['effects']['damageReduction']
            if f"damage by {dmg_reduction}" in page_text.lower():
                print(f"  ✓ Damage reduction: {dmg_reduction}")
            else:
                warnings.append(f"⚠️  {name}: Damage reduction {dmg_reduction} not clearly verified")

        # Check for bag slots
        if 'bagSlots' in rune.get('effects', {}):
            bag_slots = rune['effects']['bagSlots']
            if f"+{bag_slots}" in page_text or f"by {bag_slots}" in page_text:
                print(f"  ✓ Bag slots: +{bag_slots}")
            else:
                warnings.append(f"⚠️  {name}: Bag slots +{bag_slots} not clearly verified")

        validated_count += 1

        # Be nice to the wiki server
        time.sleep(0.5)

    except requests.exceptions.Timeout:
        errors.append(f"❌ {name}: Request timeout")
        print(f"  ❌ Request timeout")
    except requests.exceptions.RequestException as e:
        errors.append(f"❌ {name}: Request error - {str(e)}")
        print(f"  ❌ Request error: {str(e)}")
    except Exception as e:
        errors.append(f"❌ {name}: Unexpected error - {str(e)}")
        print(f"  ❌ Unexpected error: {str(e)}")

print("\n" + "=" * 80)
print(f"\nValidation Summary:")
print(f"  Total runes: {len(runes)}")
print(f"  Successfully validated: {validated_count}")
print(f"  Errors: {len(errors)}")
print(f"  Warnings: {len(warnings)}")

if errors:
    print(f"\n❌ ERRORS ({len(errors)}):")
    for error in errors[:20]:  # Show first 20 errors
        print(f"  {error}")
    if len(errors) > 20:
        print(f"  ... and {len(errors) - 20} more errors")

if warnings:
    print(f"\n⚠️  WARNINGS ({len(warnings)}):")
    for warning in warnings[:20]:  # Show first 20 warnings
        print(f"  {warning}")
    if len(warnings) > 20:
        print(f"  ... and {len(warnings) - 20} more warnings")

if not errors and not warnings:
    print("\n✅ All runes validated successfully!")
elif not errors:
    print("\n✅ All runes validated with some warnings")
else:
    print(f"\n⚠️  Validation completed with {len(errors)} errors and {len(warnings)} warnings")

# Save detailed results
results = {
    "total": len(runes),
    "validated": validated_count,
    "errors": errors,
    "warnings": warnings
}

with open('/tmp/rune_validation_results.json', 'w') as f:
    json.dump(results, f, indent=2)

print(f"\nDetailed results saved to /tmp/rune_validation_results.json")
