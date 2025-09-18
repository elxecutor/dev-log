
# 🚀 GitHub Contribution Streak Keeper

An intelligent automated system that maintains your GitHub contribution streak by ensuring **at least 3 days of coding activity per week** while keeping logs meaningful.

## Table of Contents
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [File Overview](#file-overview)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

## Features
- **Smart streak maintenance**: Only commits when needed (≥3/week threshold)
- **Dual logging**: Both human-readable (`activity.log`) and machine-readable (`activity.json`) formats
- **WakaTime integration**: Fetches daily coding time and activity automatically
- **GitHub contributions tracking**: Monitors commits, PRs, issues, reviews, and repositories
- **Weekly summaries**: Comprehensive reports generated every Sunday with analytics
- **Intelligent workflows**: Daily data collection with threshold-based commits
- **Manual controls**: Force commits or generate summaries on demand

## Installation
Fork or clone this repository and configure the required secrets:

```bash
git clone https://github.com/elxecutor/dev-log.git
cd dev-log
```

### Setup Steps:

1. **Configure GitHub Secrets** (Settings → Secrets and variables → Actions):
   - `WAKATIME_API_KEY`: Get from https://wakatime.com/api-key
   - `GITHUB_TOKEN`: Usually provided automatically by GitHub

2. **Enable GitHub Actions** in repository settings

3. **Verify the setup**:
   ```bash
   # Make scripts executable
   chmod +x scripts/*.sh
   
   # Manually trigger the workflow from GitHub Actions tab to test
   ```

## Usage
The system runs automatically with smart streak maintenance logic:

1. **Daily Process** (00:00 UTC):
   ```bash
   # Automated workflow that:
   # 1. Fetches WakaTime and GitHub data
   # 2. Checks weekly commit threshold
   # 3. Updates activity.log and activity.json
   # 4. Commits only if needed for streak maintenance
   ```

2. **Weekly Process** (01:00 UTC Sundays):
   ```bash
   # Generates comprehensive weekly summary:
   # - Coding time totals and breakdowns
   # - Contribution analytics and trends
   # - Streak status and recommendations
   ```

3. **Manual Testing**:
   ```bash
   # Set environment variables
   export WAKATIME_API_KEY="your_key"
   export GITHUB_TOKEN="your_token"
   export GITHUB_USERNAME="your_username"
   
   # Test individual components
   ./scripts/check-weekly-threshold.sh
   ./scripts/fetch-wakatime.sh "2025-09-17"
   ./scripts/update-log.sh "2025-09-17"
   ```

## File Overview

```
.
├── .github/workflows/
│   └── daily-log.yml              # Enhanced workflow with threshold logic
├── scripts/
│   ├── fetch-wakatime.sh          # WakaTime API integration
│   ├── fetch-github.sh            # GitHub GraphQL API integration
│   ├── update-log.sh              # Dual logging (text + JSON)
│   ├── check-weekly-threshold.sh  # Weekly commit threshold checker
│   └── generate-weekly-summary.sh # Weekly summary generator
├── activity.log                   # Human-readable daily entries
├── activity.json                  # Machine-readable structured data
└── weekly-summary.md              # Auto-generated weekly reports
```

### Key Components:
- **Threshold Logic**: Maintains streak with minimum necessary commits (≥3/week)
- **Dual Logging**: Both human and machine-readable formats for flexibility
- **Smart Workflows**: Automated daily collection with intelligent commit decisions
- **Weekly Analytics**: Comprehensive reports with streak status and insights

## Contributing
We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) and [Code of Conduct](CODE_OF_CONDUCT.md) for details.

## License
This project is licensed under the [MIT License](LICENSE).

## Contact
For questions or support, please open an issue or contact the maintainer via [X](https://x.com/elxecutor/).
