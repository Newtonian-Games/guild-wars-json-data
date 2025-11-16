#!/bin/bash
#
# Validate runes data against Guild Wars Wiki pages
#
# Usage:
#   guild-wars-json-data/scripts/runes/validate_runes.sh
#
# This script automatically changes to the project root directory
# and validates a sample of runes by fetching their wiki pages.
#

cd /srv/www/build-wars

echo "Validating runes against wiki..."
echo "========================================"

total_runes=$(jq '. | length' guild-wars-json-data/data/runes.json)
echo "Total runes to validate: $total_runes"
echo ""

errors=0
warnings=0
validated=0

# Sample a few runes to validate
sample_runes=(
  "Rune of Minor Air Magic"
  "Rune of Major Air Magic"
  "Rune of Superior Air Magic"
  "Rune of Minor Vigor"
  "Rune of Major Vigor"
  "Rune of Superior Vigor"
  "Warrior Rune of Minor Absorption"
  "Warrior Rune of Major Absorption"
  "Warrior Rune of Superior Absorption"
  "Rune of Attunement"
  "Rune of Vitae"
  "Rune of Clarity"
  "Rune of Holding"
  "Superior Rune of Holding"
  "Rune of Belt Holding"
)

for rune_name in "${sample_runes[@]}"; do
  echo "Validating: $rune_name"

  # Get rune data from JSON
  rune_data=$(jq --arg name "$rune_name" '.[] | select(.name == $name)' guild-wars-json-data/data/runes.json)

  if [ -z "$rune_data" ]; then
    echo "  ❌ Rune not found in JSON"
    ((errors++))
    continue
  fi

  wiki_url=$(echo "$rune_data" | jq -r '.wiki_url')
  rarity=$(echo "$rune_data" | jq -r '.rarity')

  echo "  URL: $wiki_url"

  # Fetch wiki page
  wiki_content=$(curl -s "$wiki_url")
  http_code=$(curl -s -o /dev/null -w "%{http_code}" "$wiki_url")

  if [ "$http_code" == "404" ]; then
    echo "  ❌ Page not found (404)"
    ((errors++))
    continue
  elif [ "$http_code" != "200" ]; then
    echo "  ❌ HTTP error: $http_code"
    ((errors++))
    continue
  fi

  # Check rarity
  case "$rarity" in
    "common")
      if echo "$wiki_content" | grep -qi "Common\|Blue\|Minor / Blue"; then
        echo "  ✓ Rarity: common"
      else
        echo "  ⚠️  Rarity 'common' not clearly verified"
        ((warnings++))
      fi
      ;;
    "uncommon")
      if echo "$wiki_content" | grep -qi "Uncommon\|Purple\|Major / Purple"; then
        echo "  ✓ Rarity: uncommon"
      else
        echo "  ⚠️  Rarity 'uncommon' not clearly verified"
        ((warnings++))
      fi
      ;;
    "rare")
      if echo "$wiki_content" | grep -qi "Rare\|Gold\|Superior / Gold"; then
        echo "  ✓ Rarity: rare"
      else
        echo "  ⚠️  Rarity 'rare' not clearly verified"
        ((warnings++))
      fi
      ;;
  esac

  # Check effects
  health_bonus=$(echo "$rune_data" | jq -r '.effects.healthBonus // empty')
  if [ -n "$health_bonus" ]; then
    if echo "$wiki_content" | grep -q "Health +$health_bonus"; then
      echo "  ✓ Health bonus: +$health_bonus"
    else
      echo "  ⚠️  Health bonus +$health_bonus not verified"
      ((warnings++))
    fi
  fi

  health_penalty=$(echo "$rune_data" | jq -r '.effects.healthPenalty // empty')
  if [ -n "$health_penalty" ]; then
    penalty_value=${health_penalty#-}
    if echo "$wiki_content" | grep -q "Health -$penalty_value\|Health-$penalty_value"; then
      echo "  ✓ Health penalty: -$penalty_value"
    else
      echo "  ⚠️  Health penalty -$penalty_value not verified"
      ((warnings++))
    fi
  fi

  attribute_bonus=$(echo "$rune_data" | jq -r '.effects.attributeBonus // empty')
  if [ -n "$attribute_bonus" ]; then
    attribute=$(echo "$rune_data" | jq -r '.attribute // empty')
    if echo "$wiki_content" | grep -q "$attribute +$attribute_bonus\|+$attribute_bonus"; then
      echo "  ✓ Attribute bonus: +$attribute_bonus"
    else
      echo "  ⚠️  Attribute bonus +$attribute_bonus not clearly verified"
      ((warnings++))
    fi
  fi

  ((validated++))
  echo ""

  # Be nice to the server
  sleep 0.5
done

echo "========================================"
echo "Validation Summary:"
echo "  Validated: $validated/${#sample_runes[@]}"
echo "  Errors: $errors"
echo "  Warnings: $warnings"

if [ $errors -eq 0 ] && [ $warnings -eq 0 ]; then
  echo ""
  echo "✅ Sample validation passed!"
elif [ $errors -eq 0 ]; then
  echo ""
  echo "✅ Sample validation passed with warnings"
else
  echo ""
  echo "⚠️  Sample validation completed with errors"
fi
