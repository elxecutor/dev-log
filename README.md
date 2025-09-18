
# Development Activity Logger

An automated system that tracks and logs daily development activities by collecting data from WakaTime and GitHub, maintaining comprehensive logs of coding time and contributions.

## Table of Contents
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [File Overview](#file-overview)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

## Features
- **Daily activity tracking**: Automated collection of WakaTime and GitHub data
- **Dual logging**: Both human-readable (`activity.log`) and machine-readable (`activity.json`) formats
- **WakaTime integration**: Fetches daily coding time, languages, and projects automatically
- **GitHub contributions tracking**: Monitors commits, PRs, issues, reviews, and repositories
- **Daily summaries**: Markdown reports generated for each day with detailed breakdowns
- **Automated workflows**: Daily data collection and logging via GitHub Actions
- **Manual controls**: Run scripts manually for testing or immediate updates

## Installation
Fork or clone this repository and configure the required secrets:

```bash
git clone https://github.com/elxecutor/dev-log.git
cd dev-log
```

### Setup Steps:

1. **Configure GitHub Secrets** (Settings → Secrets and variables → Actions):
   - `WAKATIME_API_KEY`: Get from https://wakatime.com/api-key
   - `GITHUB_TOKEN`: Usually provided automatically by GitHub Actions

2. **Enable GitHub Actions** in repository settings

3. **Verify the setup**:
   ```bash
   # Make scripts executable
   chmod +x scripts/*.sh
   
   # Test manually (optional)
   ./scripts/update-log.sh $(date +%Y-%m-%d)
   ```

## Usage
The system runs automatically via GitHub Actions:

1. **Daily Process** (11:59 PM UTC+1 / 10:59 PM UTC):
   ```bash
   # Automated workflow that:
   # 1. Fetches WakaTime data for the day
   # 2. Fetches GitHub contributions for the day
   # 3. Updates activity.log and activity.json
   # 4. Generates daily summary markdown
   # 5. Commits and pushes changes to repository
   ```

2. **Manual Testing**:
   ```bash
   # Set environment variables
   export WAKATIME_API_KEY="your_key"
   export GITHUB_TOKEN="your_token"
   export GITHUB_USERNAME="your_username"
   
   # Test individual components
   ./scripts/fetch-wakatime.sh "2025-09-18"
   ./scripts/fetch-github.sh "2025-09-18"
   ./scripts/update-log.sh "2025-09-18"
   ```

## File Overview

```
.
├── .github/workflows/
│   └── daily-log.yml              # Daily activity logging workflow
├── scripts/
│   ├── fetch-wakatime.sh          # WakaTime API integration
│   ├── fetch-github.sh            # GitHub API integration
│   ├── update-log.sh              # Main logging script (text + JSON)
│   └── generate-daily-summary.sh  # Daily markdown summary generator
├── activity.log                   # Human-readable daily entries
├── activity.json                  # Machine-readable structured data
└── summaries/                     # Daily summary markdown files
    └── YYYY-MM-DD.md
```

### Key Components:
- **Daily Automation**: GitHub Actions workflow runs daily at 11:58 PM UTC+1
- **Dual Logging**: Both human and machine-readable formats for flexibility
- **API Integration**: Fetches data from WakaTime and GitHub APIs
- **Daily Summaries**: Individual markdown files for each day with detailed breakdowns

## Contributing
We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) and [Code of Conduct](CODE_OF_CONDUCT.md) for details.

## License
This project is licensed under the [MIT License](LICENSE).

## Contact
For questions or support, please open an issue or contact the maintainer via [X](https://x.com/elxecutor/).
