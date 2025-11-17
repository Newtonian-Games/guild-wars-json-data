#!/bin/bash
# Validate weapon_upgrades.json data file

set -e

echo "============================================================"
echo "Validating Guild Wars Weapon Upgrades Data"
echo "============================================================"

DATA_FILE="guild-wars-json-data/data/weapon_upgrades.json"

# Check if file exists
if [ ! -f "$DATA_FILE" ]; then
    echo "❌ Error: $DATA_FILE not found"
    exit 1
fi

echo ""
echo "📋 Checking JSON validity..."
if jq empty "$DATA_FILE" 2>/dev/null; then
    echo "✓ JSON is valid"
else
    echo "❌ JSON is invalid"
    exit 1
fi

echo ""
echo "📊 Checking data structure..."

# Count total upgrades
TOTAL_COUNT=$(jq 'length' "$DATA_FILE")
echo "✓ Total upgrades: $TOTAL_COUNT"

# Count by type
INSCRIPTION_COUNT=$(jq '[.[] | select(.type == "inscription")] | length' "$DATA_FILE")
PREFIX_COUNT=$(jq '[.[] | select(.type == "prefix")] | length' "$DATA_FILE")
SUFFIX_COUNT=$(jq '[.[] | select(.type == "suffix")] | length' "$DATA_FILE")

echo "  • Inscriptions: $INSCRIPTION_COUNT"
echo "  • Prefixes: $PREFIX_COUNT"
echo "  • Suffixes: $SUFFIX_COUNT"

echo ""
echo "🔍 Checking required fields..."

# Check for required fields
MISSING_NAME=$(jq '[.[] | select(.name == null or .name == "")] | length' "$DATA_FILE")
MISSING_TYPE=$(jq '[.[] | select(.type == null or .type == "")] | length' "$DATA_FILE")
MISSING_DESC=$(jq '[.[] | select(.description == null or .description == "")] | length' "$DATA_FILE")
MISSING_WIKI=$(jq '[.[] | select(.wiki_url == null or .wiki_url == "")] | length' "$DATA_FILE")
MISSING_ATTACHES=$(jq '[.[] | select(.attaches_to == null)] | length' "$DATA_FILE")

if [ "$MISSING_NAME" -eq 0 ]; then
    echo "✓ All upgrades have 'name' field"
else
    echo "❌ $MISSING_NAME upgrades missing 'name' field"
    exit 1
fi

if [ "$MISSING_TYPE" -eq 0 ]; then
    echo "✓ All upgrades have 'type' field"
else
    echo "❌ $MISSING_TYPE upgrades missing 'type' field"
    exit 1
fi

if [ "$MISSING_DESC" -eq 0 ]; then
    echo "✓ All upgrades have 'description' field"
else
    echo "❌ $MISSING_DESC upgrades missing 'description' field"
    exit 1
fi

if [ "$MISSING_WIKI" -eq 0 ]; then
    echo "✓ All upgrades have 'wiki_url' field"
else
    echo "❌ $MISSING_WIKI upgrades missing 'wiki_url' field"
    exit 1
fi

if [ "$MISSING_ATTACHES" -eq 0 ]; then
    echo "✓ All upgrades have 'attaches_to' field"
else
    echo "❌ $MISSING_ATTACHES upgrades missing 'attaches_to' field"
    exit 1
fi

echo ""
echo "🔧 Checking mustache variables..."

# Count upgrades with variables
WITH_VARIABLES=$(jq '[.[] | select(.variables != null)] | length' "$DATA_FILE")
echo "✓ $WITH_VARIABLES upgrades use mustache variables"

# Check that descriptions with {{}} have corresponding variables
INVALID_VARS=$(jq '[.[] | select((.description | contains("{{")) and .variables == null)] | length' "$DATA_FILE")
if [ "$INVALID_VARS" -eq 0 ]; then
    echo "✓ All mustache variables are properly defined"
else
    echo "⚠️  $INVALID_VARS upgrades have {{}} in description without variables"
fi

# Check for generic "value" variable names (should be semantic)
GENERIC_VARS=$(jq '[.[] | select(.variables != null) | select(.variables | keys[] | test("^[a-z]|value"))] | length' "$DATA_FILE")
if [ "$GENERIC_VARS" -eq 0 ]; then
    echo "✓ All variable names use UpperCamelCase (semantic)"
else
    echo "⚠️  $GENERIC_VARS upgrades use generic variable names"
fi

echo ""
echo "📦 Checking attaches_to field..."

# Count upgrades with empty attaches_to
EMPTY_ATTACHES=$(jq '[.[] | select(.attaches_to == [] or (.attaches_to | length) == 0)] | length' "$DATA_FILE")
EMPTY_INSCRIPTIONS=$(jq '[.[] | select(.type == "inscription" and (.attaches_to | length) == 0)] | length' "$DATA_FILE")
EMPTY_PREFIXES=$(jq '[.[] | select(.type == "prefix" and (.attaches_to | length) == 0)] | length' "$DATA_FILE")
EMPTY_SUFFIXES=$(jq '[.[] | select(.type == "suffix" and (.attaches_to | length) == 0)] | length' "$DATA_FILE")

echo "  • Empty attaches_to: $EMPTY_ATTACHES total"
echo "    - Inscriptions: $EMPTY_INSCRIPTIONS"
echo "    - Prefixes: $EMPTY_PREFIXES"
echo "    - Suffixes: $EMPTY_SUFFIXES"

if [ "$EMPTY_INSCRIPTIONS" -eq 0 ] && [ "$EMPTY_PREFIXES" -eq 0 ]; then
    echo "✓ All inscriptions and prefixes have weapon compatibility data"
else
    echo "⚠️  Some inscriptions or prefixes missing weapon compatibility"
fi

echo ""
echo "🌐 Spot-checking URLs..."

# Check a few random wiki URLs
SAMPLE_URLS=$(jq -r '.[0,15,50] | .wiki_url' "$DATA_FILE")
URL_ERRORS=0

for url in $SAMPLE_URLS; do
    if [ -z "$url" ]; then
        continue
    fi

    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" -L "$url" || echo "000")

    if [ "$HTTP_CODE" = "200" ]; then
        echo "  ✓ $url"
    else
        echo "  ❌ $url (HTTP $HTTP_CODE)"
        URL_ERRORS=$((URL_ERRORS + 1))
    fi
done

if [ "$URL_ERRORS" -eq 0 ]; then
    echo "✓ Sample URLs are accessible"
else
    echo "⚠️  $URL_ERRORS sample URLs had errors"
fi

echo ""
echo "📝 Sample upgrades by type..."
echo ""
echo "Inscription:"
jq -r '.[] | select(.type == "inscription") | "  • \(.name): \(.description)"' "$DATA_FILE" | head -3

echo ""
echo "Prefix:"
jq -r '.[] | select(.type == "prefix") | "  • \(.name): \(.description)"' "$DATA_FILE" | head -3

echo ""
echo "Suffix:"
jq -r '.[] | select(.type == "suffix") | "  • \(.name): \(.description)"' "$DATA_FILE" | head -3

echo ""
echo "============================================================"
echo "✓ Validation complete!"
echo "============================================================"
echo ""
echo "Summary:"
echo "  • Total upgrades: $TOTAL_COUNT"
echo "  • Inscriptions: $INSCRIPTION_COUNT"
echo "  • Prefixes: $PREFIX_COUNT"
echo "  • Suffixes: $SUFFIX_COUNT"
echo "  • With variables: $WITH_VARIABLES"
echo "  • All required fields present: Yes"
echo "  • Data quality: $([ $URL_ERRORS -eq 0 ] && [ $INVALID_VARS -eq 0 ] && echo '✓ Excellent' || echo '⚠️  Needs attention')"
echo ""
echo "Note: Weapon upgrades do not have visual icons on the wiki"

exit 0
