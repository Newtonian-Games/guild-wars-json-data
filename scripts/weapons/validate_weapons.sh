#!/bin/bash
# Validate weapons.json against Guild Wars Wiki

cd /srv/www/build-wars

echo "=========================================="
echo "Validating Weapons Data"
echo "=========================================="

# Check if weapons.json exists
if [ ! -f "guild-wars-json-data/data/weapons.json" ]; then
    echo "❌ Error: weapons.json not found"
    exit 1
fi

# Count weapons
weapon_count=$(jq 'length' guild-wars-json-data/data/weapons.json)
echo "✓ Found $weapon_count weapons"

# Count total variants
variant_count=$(jq '[.[].variants | length] | add' guild-wars-json-data/data/weapons.json)
echo "✓ Found $variant_count total weapon variants"

# Check for required fields
echo ""
echo "Checking required fields..."

missing_fields=0

# Check each weapon has required top-level fields
for weapon in $(jq -r '.[].name' guild-wars-json-data/data/weapons.json); do
    # Get the weapon object
    weapon_obj=$(jq --arg name "$weapon" '.[] | select(.name == $name)' guild-wars-json-data/data/weapons.json)

    # Check required fields
    if ! echo "$weapon_obj" | jq -e '.category' > /dev/null 2>&1; then
        echo "  ❌ $weapon: missing 'category'"
        ((missing_fields++))
    fi

    if ! echo "$weapon_obj" | jq -e '.subcategory' > /dev/null 2>&1; then
        echo "  ❌ $weapon: missing 'subcategory'"
        ((missing_fields++))
    fi

    if ! echo "$weapon_obj" | jq -e '.hands' > /dev/null 2>&1; then
        echo "  ❌ $weapon: missing 'hands'"
        ((missing_fields++))
    fi

    if ! echo "$weapon_obj" | jq -e '.damage' > /dev/null 2>&1; then
        echo "  ❌ $weapon: missing 'damage'"
        ((missing_fields++))
    fi

    if ! echo "$weapon_obj" | jq -e '.variants' > /dev/null 2>&1; then
        echo "  ❌ $weapon: missing 'variants'"
        ((missing_fields++))
    fi

    # Check variants
    # Use array to handle names with spaces
    while IFS= read -r variant; do
        [ -z "$variant" ] && continue
        variant_obj=$(echo "$weapon_obj" | jq --arg vname "$variant" '.variants[] | select(.name == $vname)')

        if ! echo "$variant_obj" | jq -e '.attack_speed' > /dev/null 2>&1; then
            echo "  ❌ $weapon -> $variant: missing 'attack_speed'"
            ((missing_fields++))
        fi

        if ! echo "$variant_obj" | jq -e '.damage_type' > /dev/null 2>&1; then
            echo "  ❌ $weapon -> $variant: missing 'damage_type'"
            ((missing_fields++))
        fi

        if ! echo "$variant_obj" | jq -e '.wiki_url' > /dev/null 2>&1; then
            echo "  ❌ $weapon -> $variant: missing 'wiki_url'"
            ((missing_fields++))
        fi
    done < <(echo "$weapon_obj" | jq -r '.variants[].name')
done

if [ $missing_fields -eq 0 ]; then
    echo "✓ All required fields present"
else
    echo "❌ Found $missing_fields missing fields"
fi

# Check for icon URLs
echo ""
echo "Checking icon URLs..."
icons_present=$(jq '[.[].variants[] | select(.icon != null)] | length' guild-wars-json-data/data/weapons.json)
echo "✓ $icons_present/$variant_count variants have icons"

# Sample a few weapons to check wiki URLs are valid
echo ""
echo "Spot-checking wiki URLs..."
sample_urls=$(jq -r '.[0:3] | .[].variants[].wiki_url' guild-wars-json-data/data/weapons.json)

for url in $sample_urls; do
    status=$(curl -s -o /dev/null -w "%{http_code}" "$url")
    if [ "$status" = "200" ]; then
        echo "  ✓ $url"
    else
        echo "  ❌ $url (HTTP $status)"
    fi
done

echo ""
echo "=========================================="
echo "Validation Complete"
echo "=========================================="
