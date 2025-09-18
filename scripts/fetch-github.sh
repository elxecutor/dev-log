#!/bin/bash

# Script to fetch daily GitHub contributions using GraphQL API
# Usage: ./fetch-github.sh YYYY-MM-DD

set -e

DATE="$1"

if [[ -z "$DATE" ]]; then
    echo "Error: Date parameter required (YYYY-MM-DD format)"
    exit 1
fi

if [[ -z "$GITHUB_TOKEN" ]]; then
    echo "Error: GITHUB_TOKEN environment variable is required"
    exit 1
fi

if [[ -z "$GITHUB_USERNAME" ]]; then
    echo "Error: GITHUB_USERNAME environment variable is required"
    exit 1
fi

echo "🐙 Fetching GitHub contributions for $GITHUB_USERNAME on $DATE..."

# Create temporary file for GitHub data
GITHUB_DATA_FILE="/tmp/github_data.json"

# Calculate the start and end of the day in ISO format
START_DATE="${DATE}T00:00:00Z"
END_DATE="${DATE}T23:59:59Z"

# GraphQL query to get contributions for the specific date
GRAPHQL_QUERY=$(cat << EOF
{
  "query": "query(\$username: String!, \$from: DateTime!, \$to: DateTime!) {
    user(login: \$username) {
      contributionsCollection(from: \$from, to: \$to) {
        totalCommitContributions
        totalIssueContributions
        totalPullRequestContributions
        totalPullRequestReviewContributions
        totalRepositoryContributions
        contributionCalendar {
          totalContributions
          weeks {
            contributionDays {
              contributionCount
              date
            }
          }
        }
      }
    }
  }",
  "variables": {
    "username": "$GITHUB_USERNAME",
    "from": "$START_DATE",
    "to": "$END_DATE"
  }
}
EOF
)

# Make the GraphQL API call
curl -s -H "Authorization: bearer $GITHUB_TOKEN" \
     -H "Content-Type: application/json" \
     -X POST \
     -d "$GRAPHQL_QUERY" \
     https://api.github.com/graphql \
     -o "$GITHUB_DATA_FILE"

# Check if the API call was successful
if [[ $? -ne 0 ]]; then
    echo "Error: Failed to fetch data from GitHub API"
    exit 1
fi

# Check if we got valid JSON response
if ! jq empty "$GITHUB_DATA_FILE" 2>/dev/null; then
    echo "Error: Invalid JSON response from GitHub API"
    cat "$GITHUB_DATA_FILE"
    exit 1
fi

# Check for GraphQL errors
ERRORS=$(jq -r '.errors[]?.message // empty' "$GITHUB_DATA_FILE")
if [[ -n "$ERRORS" ]]; then
    echo "Error: GitHub API returned errors:"
    echo "$ERRORS"
    exit 1
fi

# Extract contribution data
CONTRIBUTIONS_DATA=$(jq -r '.data.user.contributionsCollection' "$GITHUB_DATA_FILE")

if [[ "$CONTRIBUTIONS_DATA" == "null" ]]; then
    echo "Error: No contribution data found. Check username and token permissions."
    exit 1
fi

# Extract specific contribution counts
TOTAL_COMMITS=$(echo "$CONTRIBUTIONS_DATA" | jq -r '.totalCommitContributions')
TOTAL_ISSUES=$(echo "$CONTRIBUTIONS_DATA" | jq -r '.totalIssueContributions')
TOTAL_PRS=$(echo "$CONTRIBUTIONS_DATA" | jq -r '.totalPullRequestContributions')
TOTAL_REVIEWS=$(echo "$CONTRIBUTIONS_DATA" | jq -r '.totalPullRequestReviewContributions')
TOTAL_REPOS=$(echo "$CONTRIBUTIONS_DATA" | jq -r '.totalRepositoryContributions')

# Get the total contribution count for the specific date
TOTAL_CONTRIBUTIONS=$(echo "$CONTRIBUTIONS_DATA" | jq -r '.contributionCalendar.weeks[].contributionDays[] | select(.date == "'"$DATE"'") | .contributionCount' | head -1)

# Handle case where no contributions found for the date
if [[ -z "$TOTAL_CONTRIBUTIONS" || "$TOTAL_CONTRIBUTIONS" == "null" ]]; then
    TOTAL_CONTRIBUTIONS=0
fi

echo "✅ GitHub contributions for $DATE:"
echo "   Total: $TOTAL_CONTRIBUTIONS"
echo "   Commits: $TOTAL_COMMITS"
echo "   Issues: $TOTAL_ISSUES"
echo "   Pull Requests: $TOTAL_PRS"
echo "   Reviews: $TOTAL_REVIEWS"
echo "   New Repositories: $TOTAL_REPOS"

# Save to temporary files for the main script
echo "$TOTAL_CONTRIBUTIONS" > /tmp/github_total_contributions
echo "$TOTAL_COMMITS" > /tmp/github_commits
echo "$TOTAL_ISSUES" > /tmp/github_issues
echo "$TOTAL_PRS" > /tmp/github_prs
echo "$TOTAL_REVIEWS" > /tmp/github_reviews
echo "$TOTAL_REPOS" > /tmp/github_repos

# Save detailed data for optional inclusion in logs
{
    echo "=== GitHub Details ==="
    echo "Total Contributions: $TOTAL_CONTRIBUTIONS"
    echo "Commits: $TOTAL_COMMITS"
    echo "Issues: $TOTAL_ISSUES"
    echo "Pull Requests: $TOTAL_PRS"
    echo "Reviews: $TOTAL_REVIEWS"
    echo "New Repositories: $TOTAL_REPOS"
    echo ""
} > /tmp/github_details

echo "📝 GitHub data saved to temporary files"

# Cleanup
rm -f "$GITHUB_DATA_FILE"