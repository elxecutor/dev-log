#!/bin/bash

# Script to format data and update the activity logs (both text and JSON)
# Usage: ./update-log.sh YYYY-MM-DD

set -e

DATE="$1"

if [[ -z "$DATE" ]]; then
    echo "Error: Date parameter required (YYYY-MM-DD format)"
    exit 1
fi

LOG_FILE="activity.log"
JSON_FILE="activity.json"

echo "📝 Updating activity log for $DATE..."

# Read data from temporary files (created by fetch scripts)
WAKATIME_HOURS=$(cat /tmp/wakatime_hours 2>/dev/null || echo "0")
WAKATIME_MINUTES=$(cat /tmp/wakatime_minutes 2>/dev/null || echo "0")

GITHUB_TOTAL=$(cat /tmp/github_total_contributions 2>/dev/null || echo "0")
GITHUB_COMMITS=$(cat /tmp/github_commits 2>/dev/null || echo "0")
GITHUB_ISSUES=$(cat /tmp/github_issues 2>/dev/null || echo "0")
GITHUB_PRS=$(cat /tmp/github_prs 2>/dev/null || echo "0")
GITHUB_REVIEWS=$(cat /tmp/github_reviews 2>/dev/null || echo "0")
GITHUB_REPOS=$(cat /tmp/github_repos 2>/dev/null || echo "0")

# Format the date for display
DISPLAY_DATE=$(date -d "$DATE" '+%A, %B %d, %Y')

# Create the log entry
LOG_ENTRY=$(cat << EOF

[$DATE] - $DISPLAY_DATE
WakaTime: ${WAKATIME_HOURS}h ${WAKATIME_MINUTES}m
GitHub: $GITHUB_TOTAL contributions ($GITHUB_COMMITS commits, $GITHUB_PRS PRs, $GITHUB_ISSUES issues, $GITHUB_REVIEWS reviews, $GITHUB_REPOS repos)
EOF
)

# Check if this date already exists in the log
if grep -q "^\[$DATE\]" "$LOG_FILE"; then
    echo "⚠️  Entry for $DATE already exists. Updating..."
    
    # Create a temporary file with the updated content
    TEMP_FILE=$(mktemp)
    
    # Copy everything before the existing entry
    sed "/^\[$DATE\]/,/^$/d" "$LOG_FILE" > "$TEMP_FILE"
    
    # Add the new entry
    echo "$LOG_ENTRY" >> "$TEMP_FILE"
    echo "" >> "$TEMP_FILE"
    
    # Add everything after the existing entry (if any)
    sed -n "/^\[$DATE\]/,/^$/p" "$LOG_FILE" | tail -n +2 | while read line; do
        if [[ "$line" == "" ]]; then
            break
        fi
    done
    
    # Replace the original file
    mv "$TEMP_FILE" "$LOG_FILE"
else
    echo "➕ Adding new entry for $DATE..."
    
    # Append the new entry to the log file
    echo "$LOG_ENTRY" >> "$LOG_FILE"
    echo "" >> "$LOG_FILE"
fi

# Add a separator line
echo "---" >> "$LOG_FILE"

# Update JSON file
echo "📄 Updating JSON activity log..."

# Initialize JSON file if it doesn't exist
if [[ ! -f "$JSON_FILE" ]]; then
    echo '{"entries": []}' > "$JSON_FILE"
fi

# Create JSON entry
JSON_ENTRY=$(cat << EOF
{
  "date": "$DATE",
  "displayDate": "$DISPLAY_DATE",
  "wakatime": {
    "hours": $WAKATIME_HOURS,
    "minutes": $WAKATIME_MINUTES,
    "totalSeconds": $((WAKATIME_HOURS * 3600 + WAKATIME_MINUTES * 60))
  },
  "github": {
    "totalContributions": $GITHUB_TOTAL,
    "commits": $GITHUB_COMMITS,
    "pullRequests": $GITHUB_PRS,
    "issues": $GITHUB_ISSUES,
    "reviews": $GITHUB_REVIEWS,
    "repositories": $GITHUB_REPOS
  },
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
)

# Check if entry for this date already exists in JSON
if jq -e ".entries[] | select(.date == \"$DATE\")" "$JSON_FILE" > /dev/null 2>&1; then
    echo "⚠️  JSON entry for $DATE already exists. Updating..."
    
    # Remove existing entry and add new one
    TEMP_JSON=$(mktemp)
    jq ".entries |= map(select(.date != \"$DATE\"))" "$JSON_FILE" > "$TEMP_JSON"
    jq ".entries += [$JSON_ENTRY]" "$TEMP_JSON" > "$JSON_FILE"
    rm "$TEMP_JSON"
else
    echo "➕ Adding new JSON entry for $DATE..."
    
    # Add new entry to JSON
    TEMP_JSON=$(mktemp)
    jq ".entries += [$JSON_ENTRY]" "$JSON_FILE" > "$TEMP_JSON"
    mv "$TEMP_JSON" "$JSON_FILE"
fi

# Sort JSON entries by date (newest first)
TEMP_JSON=$(mktemp)
jq '.entries |= sort_by(.date) | reverse' "$JSON_FILE" > "$TEMP_JSON"
mv "$TEMP_JSON" "$JSON_FILE"

echo "✅ Activity logs updated successfully!"

# Display what was logged
echo ""
echo "📊 Logged data:"
echo "   Date: $DISPLAY_DATE"
echo "   WakaTime: ${WAKATIME_HOURS}h ${WAKATIME_MINUTES}m"
echo "   GitHub: $GITHUB_TOTAL contributions"
echo "     - Commits: $GITHUB_COMMITS"
echo "     - Pull Requests: $GITHUB_PRS"
echo "     - Issues: $GITHUB_ISSUES"
echo "     - Reviews: $GITHUB_REVIEWS"
echo "     - New Repositories: $GITHUB_REPOS"
echo ""
echo "📄 Updated files:"
echo "   - $LOG_FILE (human-readable)"
echo "   - $JSON_FILE (machine-readable)"

# Optional: Show detailed information if available
if [[ -f /tmp/wakatime_details ]]; then
    echo ""
    echo "📋 Additional WakaTime details:"
    cat /tmp/wakatime_details
fi

if [[ -f /tmp/github_details ]]; then
    echo "📋 Additional GitHub details:"
    cat /tmp/github_details
fi

# Cleanup temporary files
rm -f /tmp/wakatime_* /tmp/github_*

echo ""
echo "🧹 Temporary files cleaned up"