#!/bin/bash
#
# Validate insignias data against Guild Wars Wiki pages
#
# Usage:
#   guild-wars-json-data/scripts/insignias/validate_insignias.sh
#
# This script automatically changes to the project root directory
# and validates a sample of insignias by fetching their wiki pages.
#

cd /srv/www/build-wars

echo "Validating insignias against wiki..."
echo "========================================"

total_insignias=$(jq '. | length' guild-wars-json-data/data/insignias.json)
echo "Total insignias to validate: $total_insignias"
echo ""

errors=0
warnings=0
validated=0

# Sample a few insignias to validate
sample_insignias=(
  "Survivor Insignia"
  "Radiant Insignia"
  "Stalwart Insignia"
  "Brawler's Insignia"
  "Knight's Insignia"
  "Lieutenant's Insignia"
  "Sentinel's Insignia"
  "Stonefist Insignia"
  "Dreadnought Insignia"
  "Beastmaster's Insignia"
  "Wanderer's Insignia"
  "Disciple's Insignia"
)

for insignia_name in "${sample_insignias[@]}"; do
  echo "Validating: $insignia_name"

  # Get insignia data from JSON
  insignia_data=$(jq --arg name "$insignia_name" '.[] | select(.name == $name)' guild-wars-json-data/data/insignias.json)

  if [ -z "$insignia_data" ]; then
    echo "  ❌ ERROR: Insignia not found in JSON"
    errors=$((errors + 1))
    echo ""
    continue
  fi

  # Extract wiki URL
  wiki_url=$(echo "$insignia_data" | jq -r '.wiki_url')

  if [ -z "$wiki_url" ] || [ "$wiki_url" == "null" ]; then
    echo "  ❌ ERROR: No wiki_url found"
    errors=$((errors + 1))
    echo ""
    continue
  fi

  # Fetch wiki page
  wiki_content=$(curl -s "$wiki_url")

  if [ -z "$wiki_content" ]; then
    echo "  ⚠️  WARNING: Could not fetch wiki page"
    warnings=$((warnings + 1))
    echo ""
    continue
  fi

  # Check if page exists (not a 404 or redirect)
  if echo "$wiki_content" | grep -q "does not exist\|was not found"; then
    echo "  ❌ ERROR: Wiki page does not exist"
    errors=$((errors + 1))
    echo ""
    continue
  fi

  # Extract profession from JSON
  profession=$(echo "$insignia_data" | jq -r '.profession // "null"')

  # Check profession if specified
  if [ "$profession" != "null" ] && [ -n "$profession" ]; then
    if echo "$wiki_content" | grep -qi "$profession"; then
      echo "  ✓ Profession matches: $profession"
    else
      echo "  ⚠️  WARNING: Profession '$profession' not found on wiki page"
      warnings=$((warnings + 1))
    fi
  else
    # Check if it's supposed to be universal (Any profession)
    if echo "$wiki_content" | grep -qi "any\|universal"; then
      echo "  ✓ Universal insignia confirmed"
    fi
  fi

  # Check requirements
  requirements=$(echo "$insignia_data" | jq -r '.requirements // "null"')
  if [ "$requirements" != "null" ] && [ "$requirements" != "{}" ]; then
    req_attr=$(echo "$insignia_data" | jq -r '.requirements.attribute // "null"')
    req_val=$(echo "$insignia_data" | jq -r '.requirements.value // "null"')
    if [ "$req_attr" != "null" ] && [ "$req_val" != "null" ]; then
      if echo "$wiki_content" | grep -qi "Requires.*$req_val.*$req_attr"; then
        echo "  ✓ Requirements match: $req_val $req_attr"
      else
        echo "  ⚠️  WARNING: Requirements not found on wiki page"
        warnings=$((warnings + 1))
      fi
    fi
  fi

  # Check effects
  effects=$(echo "$insignia_data" | jq -r '.effects // "{}"')
  if [ "$effects" != "{}" ] && [ "$effects" != "null" ]; then
    effect_count=$(echo "$insignia_data" | jq '.effects | length')
    echo "  ✓ Found $effect_count effect(s)"

    # Check for Health bonus
    if echo "$insignia_data" | jq -e '.effects.HealthBonus' > /dev/null 2>&1; then
      if echo "$wiki_content" | grep -qi "Health.*\+"; then
        echo "    ✓ Health bonus found on wiki"
      else
        echo "    ⚠️  WARNING: Health bonus not found on wiki"
        warnings=$((warnings + 1))
      fi
    fi

    # Check for Energy bonus
    if echo "$insignia_data" | jq -e '.effects.EnergyBonus' > /dev/null 2>&1; then
      if echo "$wiki_content" | grep -qi "Energy.*\+"; then
        echo "    ✓ Energy bonus found on wiki"
      else
        echo "    ⚠️  WARNING: Energy bonus not found on wiki"
        warnings=$((warnings + 1))
      fi
    fi

    # Check for Armor bonus
    if echo "$insignia_data" | jq -e '.effects | keys[] | select(startswith("ArmorBonus"))' > /dev/null 2>&1; then
      if echo "$wiki_content" | grep -qi "Armor.*\+"; then
        echo "    ✓ Armor bonus found on wiki"
      else
        echo "    ⚠️  WARNING: Armor bonus not found on wiki"
        warnings=$((warnings + 1))
      fi
    fi
  else
    echo "  ⚠️  WARNING: No effects found"
    warnings=$((warnings + 1))
  fi

  validated=$((validated + 1))
  echo ""
done

echo "========================================"
echo "Validation Summary:"
echo "  Validated: $validated"
echo "  Warnings: $warnings"
echo "  Errors: $errors"
echo ""

if [ $errors -eq 0 ] && [ $warnings -eq 0 ]; then
  echo "✓ All validations passed!"
  exit 0
elif [ $errors -eq 0 ]; then
  echo "⚠️  Validation completed with warnings"
  exit 0
else
  echo "❌ Validation failed with errors"
  exit 1
fi
