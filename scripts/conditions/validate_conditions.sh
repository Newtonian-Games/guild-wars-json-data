#!/bin/bash
# Validate conditions.json data file

set -e

echo "============================================================"
echo "Validating Guild Wars Conditions Data"
echo "============================================================"

DATA_FILE="guild-wars-json-data/data/conditions.json"

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

# Count total conditions
TOTAL_COUNT=$(jq 'length' "$DATA_FILE")
echo "✓ Total conditions: $TOTAL_COUNT"

# Expected count
EXPECTED_COUNT=10
if [ "$TOTAL_COUNT" -eq "$EXPECTED_COUNT" ]; then
    echo "✓ Count matches expected ($EXPECTED_COUNT)"
else
    echo "⚠️  Warning: Expected $EXPECTED_COUNT conditions, found $TOTAL_COUNT"
fi

echo ""
echo "🔍 Checking required fields..."

# Check for required fields
MISSING_NAME=$(jq '[.[] | select(.name == null or .name == "")] | length' "$DATA_FILE")
MISSING_CONCISE=$(jq '[.[] | select(.concise_description == null or .concise_description == "")] | length' "$DATA_FILE")
MISSING_DESC=$(jq '[.[] | select(.description == null)] | length' "$DATA_FILE")
MISSING_WIKI=$(jq '[.[] | select(.wiki_url == null or .wiki_url == "")] | length' "$DATA_FILE")
MISSING_ICON=$(jq '[.[] | select(.icon == null)] | length' "$DATA_FILE")

if [ "$MISSING_NAME" -eq 0 ]; then
    echo "✓ All conditions have 'name' field"
else
    echo "❌ $MISSING_NAME conditions missing 'name' field"
    exit 1
fi

if [ "$MISSING_CONCISE" -eq 0 ]; then
    echo "✓ All conditions have 'concise_description' field"
else
    echo "⚠️  $MISSING_CONCISE conditions missing 'concise_description' field"
fi

if [ "$MISSING_DESC" -eq 0 ]; then
    echo "✓ All conditions have 'description' field"
else
    echo "❌ $MISSING_DESC conditions missing 'description' field"
    exit 1
fi

if [ "$MISSING_WIKI" -eq 0 ]; then
    echo "✓ All conditions have 'wiki_url' field"
else
    echo "❌ $MISSING_WIKI conditions missing 'wiki_url' field"
    exit 1
fi

if [ "$MISSING_ICON" -eq 0 ]; then
    echo "✓ All conditions have 'icon' field populated"
else
    echo "⚠️  $MISSING_ICON conditions missing 'icon' field"
fi

echo ""
echo "🌐 Spot-checking URLs..."

# Check a few random wiki URLs
SAMPLE_URLS=$(jq -r '.[0,4,9] | .wiki_url' "$DATA_FILE")
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
echo "🖼️  Checking icon URLs..."

# Check icon URL format
INVALID_ICONS=$(jq '[.[] | select(.icon != null and (.icon | test("^https://wiki.guildwars.com/images/") | not))] | length' "$DATA_FILE")

if [ "$INVALID_ICONS" -eq 0 ]; then
    echo "✓ All icon URLs have correct format"
else
    echo "⚠️  $INVALID_ICONS icons with invalid URL format"
fi

echo ""
echo "📝 Listing all conditions..."
jq -r '.[] | "  • \(.name)"' "$DATA_FILE"

echo ""
echo "============================================================"
echo "✓ Validation complete!"
echo "============================================================"
echo ""
echo "Summary:"
echo "  • Total conditions: $TOTAL_COUNT"
echo "  • With concise descriptions: $((TOTAL_COUNT - MISSING_CONCISE))"
echo "  • With icons: $((TOTAL_COUNT - MISSING_ICON))"
echo "  • All required fields present: $([ $MISSING_NAME -eq 0 ] && [ $MISSING_DESC -eq 0 ] && [ $MISSING_WIKI -eq 0 ] && echo 'Yes' || echo 'No')"
echo "  • Data quality: $([ $URL_ERRORS -eq 0 ] && [ $INVALID_ICONS -eq 0 ] && [ $MISSING_CONCISE -eq 0 ] && echo '✓ Excellent' || echo '⚠️  Needs attention')"

exit 0
