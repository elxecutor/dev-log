#!/bin/bash

# Script to fetch daily coding activity from WakaTime API
# Usage: ./fetch-wakatime.sh YYYY-MM-DD

set -e

DATE="$1"

if [[ -z "$DATE" ]]; then
    echo "Error: Date parameter required (YYYY-MM-DD format)"
    exit 1
fi

if [[ -z "$WAKATIME_API_KEY" ]]; then
    echo "Error: WAKATIME_API_KEY environment variable is required"
    exit 1
fi

echo "🕐 Fetching WakaTime data for $DATE..."

# Create temporary file for WakaTime data
WAKATIME_DATA_FILE="/tmp/wakatime_data.json"

# Fetch summaries for the specific date
curl -s -H "Authorization: Bearer $WAKATIME_API_KEY" \
     "https://wakatime.com/api/v1/users/current/summaries?start=$DATE&end=$DATE" \
     -o "$WAKATIME_DATA_FILE"

# Check if the API call was successful
if [[ $? -ne 0 ]]; then
    echo "Error: Failed to fetch data from WakaTime API"
    exit 1
fi

# Check if we got valid JSON response
if ! jq empty "$WAKATIME_DATA_FILE" 2>/dev/null; then
    echo "Error: Invalid JSON response from WakaTime API"
    cat "$WAKATIME_DATA_FILE"
    exit 1
fi

# Extract total seconds from the response
TOTAL_SECONDS=$(jq -r '.data[0].grand_total.total_seconds // 0' "$WAKATIME_DATA_FILE")

if [[ "$TOTAL_SECONDS" == "null" || "$TOTAL_SECONDS" == "0" ]]; then
    echo "⚠️  No WakaTime data found for $DATE"
    echo "0" > /tmp/wakatime_hours
    echo "0" > /tmp/wakatime_minutes
else
    # Convert seconds to hours and minutes
    HOURS=$((TOTAL_SECONDS / 3600))
    MINUTES=$(((TOTAL_SECONDS % 3600) / 60))
    
    echo "✅ WakaTime: ${HOURS}h ${MINUTES}m (${TOTAL_SECONDS}s total)"
    
    # Save to temporary files for the main script
    echo "$HOURS" > /tmp/wakatime_hours
    echo "$MINUTES" > /tmp/wakatime_minutes
fi

# Extract additional activity data for detailed logging
LANGUAGES=$(jq -r '.data[0].languages[]? | "\(.name): \(.text)"' "$WAKATIME_DATA_FILE" 2>/dev/null | head -5)
PROJECTS=$(jq -r '.data[0].projects[]? | "\(.name): \(.text)"' "$WAKATIME_DATA_FILE" 2>/dev/null | head -3)

# Save detailed data for optional inclusion in logs
{
    echo "=== WakaTime Details ==="
    echo "Total Time: ${HOURS}h ${MINUTES}m"
    if [[ -n "$LANGUAGES" ]]; then
        echo "Top Languages:"
        echo "$LANGUAGES"
    fi
    if [[ -n "$PROJECTS" ]]; then
        echo "Top Projects:"
        echo "$PROJECTS"
    fi
    echo ""
} > /tmp/wakatime_details

echo "📝 WakaTime data saved to temporary files"

# Cleanup
rm -f "$WAKATIME_DATA_FILE"