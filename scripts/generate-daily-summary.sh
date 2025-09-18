#!/bin/bash

# Script to generate daily markdown summary
# Usage: ./generate-daily-summary.sh YYYY-MM-DD

set -e

DATE="$1"

if [[ -z "$DATE" ]]; then
    echo "Error: Date parameter required (YYYY-MM-DD format)"
    exit 1
fi

echo "📝 Generating daily summary for $DATE..."

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
DAY_OF_WEEK=$(date -d "$DATE" '+%A')

# Create daily summary markdown file
DAILY_MD="summaries/${DATE}.md"

# Create summaries directory if it doesn't exist
mkdir -p summaries

# Check if summary already exists
if [[ -f "$DAILY_MD" ]]; then
    echo "⚠️  Summary for $DATE already exists. Overwriting..."
else
    echo "➕ Creating new summary for $DATE..."
fi

# Generate daily summary
cat > "$DAILY_MD" << EOF
# $DISPLAY_DATE

---

## 📈 Productivity Insights

$(if [[ $WAKATIME_HOURS -gt 2 ]]; then
    echo "🔥 **High Productivity Day** - Great coding session with ${WAKATIME_HOURS}h ${WAKATIME_MINUTES}m!"
elif [[ $WAKATIME_HOURS -gt 0 || $WAKATIME_MINUTES -gt 30 ]]; then
    echo "✅ **Productive Day** - Good coding time with ${WAKATIME_HOURS}h ${WAKATIME_MINUTES}m"
else
    echo "😴 **Quiet Day** - Limited coding activity today"
fi)

$(if [[ $GITHUB_TOTAL -gt 3 ]]; then
    echo "🚀 **Active GitHub Day** - $GITHUB_TOTAL contributions made!"
elif [[ $GITHUB_TOTAL -gt 0 ]]; then
    echo "📝 **GitHub Activity** - $GITHUB_TOTAL contributions"
else
    echo "💤 **No GitHub Activity** - No contributions today"
fi)

---

## 🎯 Day Rating

$(
    TOTAL_SCORE=0
    
    # WakaTime scoring (0-5 points)
    if [[ $WAKATIME_HOURS -ge 3 ]]; then
        TOTAL_SCORE=$((TOTAL_SCORE + 5))
    elif [[ $WAKATIME_HOURS -ge 2 ]]; then
        TOTAL_SCORE=$((TOTAL_SCORE + 4))
    elif [[ $WAKATIME_HOURS -ge 1 ]]; then
        TOTAL_SCORE=$((TOTAL_SCORE + 3))
    elif [[ $WAKATIME_MINUTES -ge 30 ]]; then
        TOTAL_SCORE=$((TOTAL_SCORE + 2))
    elif [[ $WAKATIME_MINUTES -gt 0 ]]; then
        TOTAL_SCORE=$((TOTAL_SCORE + 1))
    fi
    
    # GitHub scoring (0-5 points)
    if [[ $GITHUB_TOTAL -ge 5 ]]; then
        TOTAL_SCORE=$((TOTAL_SCORE + 5))
    elif [[ $GITHUB_TOTAL -ge 3 ]]; then
        TOTAL_SCORE=$((TOTAL_SCORE + 4))
    elif [[ $GITHUB_TOTAL -ge 2 ]]; then
        TOTAL_SCORE=$((TOTAL_SCORE + 3))
    elif [[ $GITHUB_TOTAL -eq 1 ]]; then
        TOTAL_SCORE=$((TOTAL_SCORE + 2))
    fi
    
    # Display rating
    if [[ $TOTAL_SCORE -ge 8 ]]; then
        echo "⭐⭐⭐⭐⭐ **Excellent Day** (${TOTAL_SCORE}/10)"
    elif [[ $TOTAL_SCORE -ge 6 ]]; then
        echo "⭐⭐⭐⭐ **Great Day** (${TOTAL_SCORE}/10)"
    elif [[ $TOTAL_SCORE -ge 4 ]]; then
        echo "⭐⭐⭐ **Good Day** (${TOTAL_SCORE}/10)"
    elif [[ $TOTAL_SCORE -ge 2 ]]; then
        echo "⭐⭐ **Okay Day** (${TOTAL_SCORE}/10)"
    elif [[ $TOTAL_SCORE -eq 1 ]]; then
        echo "⭐ **Light Day** (${TOTAL_SCORE}/10)"
    else
        echo "😴 **Rest Day** (${TOTAL_SCORE}/10)"
    fi
)

---

## 📝 Notes

- **Date**: $DATE ($DAY_OF_WEEK)
- **Generated**: $(date '+%Y-%m-%d %H:%M:%S UTC')
- **Data Source**: WakaTime API & GitHub API

$(if [[ -f /tmp/wakatime_details ]]; then
    echo ""
    echo "### ⏱️ Coding Time Breakdown"
    echo ""
    echo "\`\`\`"
    echo "Total Time: ${WAKATIME_HOURS}h ${WAKATIME_MINUTES}m"
    echo "\`\`\`"
    echo ""
    echo "### 💻 Programming Languages"
    echo ""
    echo "\`\`\`"
    # Extract just the languages section without the "Top Languages:" header
    sed -n '/Top Languages:/,/Top Projects:/p' /tmp/wakatime_details | sed '$d' | tail -n +2
    echo "\`\`\`"
    echo ""
    echo "### 📂 Projects Worked On"
    echo ""
    echo "\`\`\`"
    # Extract just the projects section without the "Top Projects:" header
    sed -n '/Top Projects:/,$p' /tmp/wakatime_details | tail -n +2
    echo "\`\`\`"
fi)

$(if [[ -f /tmp/github_details ]]; then
    echo ""
    echo "### 🐙 GitHub Contributions"
    echo ""
    echo "| Type | Count |"
    echo "|------|-------|"
    echo "| **Total Contributions** | $GITHUB_TOTAL |"
    echo "| **Commits** | $GITHUB_COMMITS |"
    echo "| **Pull Requests** | $GITHUB_PRS |"
    echo "| **Issues** | $GITHUB_ISSUES |"
    echo "| **Reviews** | $GITHUB_REVIEWS |"
    echo "| **New Repositories** | $GITHUB_REPOS |"
fi)

EOF

echo "✅ Daily summary generated: $DAILY_MD"
echo "📊 Summary stats:"
echo "   - Coding time: ${WAKATIME_HOURS}h ${WAKATIME_MINUTES}m"
echo "   - GitHub contributions: $GITHUB_TOTAL"
echo "   - File: $DAILY_MD"