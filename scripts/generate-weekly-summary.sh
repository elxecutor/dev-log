#!/bin/bash

# Script to generate weekly summary from activity.json
# Usage: ./generate-weekly-summary.sh [YYYY-MM-DD]

set -e

# Use provided date or current date for week calculation
REFERENCE_DATE=${1:-$(date '+%Y-%m-%d')}

# Calculate week boundaries (Monday to Sunday)
WEEK_START=$(date -d "$REFERENCE_DATE monday this week" '+%Y-%m-%d')
WEEK_END=$(date -d "$REFERENCE_DATE sunday this week" '+%Y-%m-%d')

SUMMARY_FILE="weekly-summary.md"
JSON_FILE="activity.json"

echo "📊 Generating weekly summary for week: $WEEK_START to $WEEK_END"

# Check if JSON file exists
if [[ ! -f "$JSON_FILE" ]]; then
    echo "⚠️  No activity.json found. Creating empty summary."
    echo '{"entries": []}' > "$JSON_FILE"
fi

# Extract week data from JSON
WEEK_DATA=$(jq --arg start "$WEEK_START" --arg end "$WEEK_END" '
.entries[] | select(.date >= $start and .date <= $end)
' "$JSON_FILE")

if [[ -z "$WEEK_DATA" ]]; then
    echo "ℹ️  No activity data found for this week"
    TOTAL_HOURS=0
    TOTAL_MINUTES=0
    TOTAL_CONTRIBUTIONS=0
    ACTIVE_DAYS=0
else
    # Calculate totals
    TOTALS=$(echo "$WEEK_DATA" | jq -s '
    {
        totalHours: map(.wakatime.hours) | add,
        totalMinutes: map(.wakatime.minutes) | add,
        totalContributions: map(.github.totalContributions) | add,
        activeDays: length,
        totalCommits: map(.github.commits) | add,
        totalPRs: map(.github.pullRequests) | add,
        totalIssues: map(.github.issues) | add,
        totalReviews: map(.github.reviews) | add
    }')
    
    TOTAL_HOURS=$(echo "$TOTALS" | jq -r '.totalHours // 0')
    TOTAL_MINUTES=$(echo "$TOTALS" | jq -r '.totalMinutes // 0')
    TOTAL_CONTRIBUTIONS=$(echo "$TOTALS" | jq -r '.totalContributions // 0')
    ACTIVE_DAYS=$(echo "$TOTALS" | jq -r '.activeDays // 0')
    TOTAL_COMMITS=$(echo "$TOTALS" | jq -r '.totalCommits // 0')
    TOTAL_PRS=$(echo "$TOTALS" | jq -r '.totalPRs // 0')
    TOTAL_ISSUES=$(echo "$TOTALS" | jq -r '.totalIssues // 0')
    TOTAL_REVIEWS=$(echo "$TOTALS" | jq -r '.totalReviews // 0')
fi

# Convert total minutes to hours and minutes
EXTRA_HOURS=$((TOTAL_MINUTES / 60))
TOTAL_HOURS=$((TOTAL_HOURS + EXTRA_HOURS))
REMAINING_MINUTES=$((TOTAL_MINUTES % 60))

# Calculate week info
WEEK_NUMBER=$(date -d "$WEEK_START" '+%U')
YEAR=$(date -d "$WEEK_START" '+%Y')
WEEK_DISPLAY=$(date -d "$WEEK_START" '+%B %d') - $(date -d "$WEEK_END" '+%B %d, %Y')

# Generate summary
cat > "$SUMMARY_FILE" << EOF
# 📊 Weekly Summary

**Week $WEEK_NUMBER, $YEAR** | $WEEK_DISPLAY

---

## 🎯 Overview

| Metric | Value |
|--------|-------|
| **Total Coding Time** | ${TOTAL_HOURS}h ${REMAINING_MINUTES}m |
| **Total Contributions** | $TOTAL_CONTRIBUTIONS |
| **Active Days** | $ACTIVE_DAYS/7 |
| **Streak Status** | $(if [[ $TOTAL_CONTRIBUTIONS -ge 3 ]]; then echo "✅ Maintained"; else echo "⚠️ At Risk"; fi) |

---

## 📈 Detailed Breakdown

### GitHub Activity
| Type | Count |
|------|-------|
| Commits | $TOTAL_COMMITS |
| Pull Requests | $TOTAL_PRS |
| Issues | $TOTAL_ISSUES |
| Reviews | $TOTAL_REVIEWS |

### Daily Activity

| Date | Day | WakaTime | GitHub Contributions |
|------|-----|----------|---------------------|
EOF

# Add daily breakdown
if [[ -n "$WEEK_DATA" ]]; then
    echo "$WEEK_DATA" | jq -r '
    . as $entry |
    .date as $date |
    ($date | strptime("%Y-%m-%d") | strftime("%A")) as $day |
    "| \($date) | \($day) | \(.wakatime.hours)h \(.wakatime.minutes)m | \(.github.totalContributions) |"
    ' | sort >> "$SUMMARY_FILE"
else
    for i in {0..6}; do
        DAY_DATE=$(date -d "$WEEK_START + $i days" '+%Y-%m-%d')
        DAY_NAME=$(date -d "$DAY_DATE" '+%A')
        echo "| $DAY_DATE | $DAY_NAME | 0h 0m | 0 |" >> "$SUMMARY_FILE"
    done
fi

cat >> "$SUMMARY_FILE" << EOF

---

## 🎯 Streak Analysis

$(if [[ $TOTAL_CONTRIBUTIONS -ge 3 ]]; then
    echo "✅ **Streak Maintained** - You have $TOTAL_CONTRIBUTIONS contributions this week (≥3 required)"
else
    NEEDED=$((3 - TOTAL_CONTRIBUTIONS))
    echo "⚠️ **Streak at Risk** - You need $NEEDED more contributions to maintain your streak"
fi)

$(if [[ $ACTIVE_DAYS -ge 3 ]]; then
    echo "💪 **Active Week** - You were active on $ACTIVE_DAYS days this week"
else
    echo "😴 **Quiet Week** - You were only active on $ACTIVE_DAYS days this week"
fi)

---

## 📝 Notes

- This summary covers the week from $WEEK_START to $WEEK_END
- Data is automatically generated from \`activity.json\`
- Streak maintenance requires ≥3 contributions per week
- Generated on: $(date '+%Y-%m-%d %H:%M:%S UTC')

EOF

echo "✅ Weekly summary generated: $SUMMARY_FILE"
echo "📊 Week stats:"
echo "   - Total coding time: ${TOTAL_HOURS}h ${REMAINING_MINUTES}m"
echo "   - Total contributions: $TOTAL_CONTRIBUTIONS"
echo "   - Active days: $ACTIVE_DAYS/7"
echo "   - Streak status: $(if [[ $TOTAL_CONTRIBUTIONS -ge 3 ]]; then echo "Maintained ✅"; else echo "At Risk ⚠️"; fi)"