# dev-log

A comprehensive development activity tracking tool that aggregates data from GitHub and WakaTime to generate detailed daily productivity summaries and maintain activity logs.
[![📊 Daily Activity Logger](https://github.com/elxecutor/dev-log/actions/workflows/daily-log.yml/badge.svg)](https://github.com/elxecutor/dev-log/actions/workflows/daily-log.yml)
## Table of Contents
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [File Overview](#file-overview)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

## Features
- **GitHub Integration**: Fetches daily contribution data including commits, pull requests, issues, and reviews
- **WakaTime Integration**: Retrieves coding time statistics and language/project breakdowns
- **Automated Summaries**: Generates markdown summaries with productivity insights and ratings
- **Dual Log Formats**: Maintains both human-readable text logs and machine-readable JSON data
- **Daily Reports**: Creates detailed daily activity reports with visualizations and metrics

## Installation
Clone the repository and ensure required dependencies are installed:

```bash
git clone https://github.com/elxecutor/dev-log.git
cd dev-log

# Make scripts executable
chmod +x scripts/*.sh

# Ensure required tools are installed
# curl (for API calls)
# jq (for JSON processing)
# These are typically pre-installed on most Linux systems
```

## Usage
1. Set up environment variables:
   ```bash
   export GITHUB_TOKEN="your_github_token"
   export PAT="your_personal_access_token"  # Alternative to GITHUB_TOKEN
   export GITHUB_USERNAME="your_github_username"
   export GIT_USER_NAME="your_git_user_name"
   export GIT_USER_EMAIL="your_git_user_email"
   export WAKATIME_API_KEY="your_wakatime_api_key"
   ```

2. Run the update script for a specific date:
   ```bash
   ./scripts/update-log.sh 2025-01-15
   ```

   This will:
   - Fetch GitHub contribution data
   - Fetch WakaTime coding statistics
   - Generate a daily summary markdown file
   - Update the activity logs

## File Overview
- `scripts/fetch-github.sh` - Fetches GitHub contribution data via GraphQL API
- `scripts/fetch-wakatime.sh` - Retrieves WakaTime coding time statistics
- `scripts/generate-daily-summary.sh` - Creates formatted markdown summaries
- `scripts/update-log.sh` - Main script that orchestrates data fetching and logging
- `activity.log` - Human-readable activity log
- `activity.json` - Machine-readable JSON activity data
- `summaries/` - Directory containing daily markdown summary files

## Contributing
We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) and [Code of Conduct](CODE_OF_CONDUCT.md) for details.

## License
This project is licensed under the [MIT License](LICENSE).

## Contact
For questions or support, please open an issue or contact the maintainer via [X](https://x.com/elxecutor/).
