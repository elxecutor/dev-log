#!/bin/bash

# Script to check weekly commit count and determine if we should commit
# Usage: ./check-weekly-threshold.sh

set -e

echo "📊 Checking weekly commit threshold..."

# Get the start of the current week (Monday)
WEEK_START=$(date -d 'monday this week' '+%Y-%m-%d')
WEEK_END=$(date '+%Y-%m-%d')

echo "🗓️  Week: $WEEK_START to $WEEK_END"

# Get commit count for this week
WEEKLY_COMMITS=$(git log --since="$WEEK_START 00:00:00" --until="$WEEK_END 23:59:59" --oneline --author="GitHub Action" | wc -l)

echo "📈 Current weekly commits by GitHub Action: $WEEKLY_COMMITS"

# Minimum commits per week for streak maintenance
MIN_WEEKLY_COMMITS=3

if [[ $WEEKLY_COMMITS -ge $MIN_WEEKLY_COMMITS ]]; then
    echo "✅ Weekly threshold met ($WEEKLY_COMMITS >= $MIN_WEEKLY_COMMITS)"
    echo "🎯 Streak maintenance: SKIP commit (quota satisfied)"
    echo "false" > /tmp/should_commit
else
    REMAINING=$((MIN_WEEKLY_COMMITS - WEEKLY_COMMITS))
    echo "⚠️  Weekly threshold not met ($WEEKLY_COMMITS < $MIN_WEEKLY_COMMITS)"
    echo "🎯 Streak maintenance: COMMIT needed ($REMAINING more required)"
    echo "true" > /tmp/should_commit
fi

# Always log the data regardless of commit decision
echo "📝 Data will be logged regardless of commit decision"

# Save weekly stats for potential use
echo "$WEEKLY_COMMITS" > /tmp/weekly_commits
echo "$MIN_WEEKLY_COMMITS" > /tmp/min_weekly_commits
echo "$WEEK_START" > /tmp/week_start
echo "$WEEK_END" > /tmp/week_end