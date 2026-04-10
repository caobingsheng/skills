---
name: gitea-tea
description: Manage Gitea via CLI. Use when user mentions "tea", "gitea cli", "tea command", or needs terminal-based Gitea operations (create/view/manage issues, PRs, releases, webhooks, actions, labels, milestones). Triggers on: 'tea issues', 'tea pulls', 'tea releases', 'tea create', 'tea list', 'gitea command', '管理 Gitea issue', '创建 PR', '发布 release'.
---

# Gitea CLI (tea)

Official command-line interface for Gitea. Manage issues, PRs, releases, workflows, webhooks, and repos from terminal.

**Version**: tea 0.12.0+ | Gitea API v0.23.2

## Quick Start

```bash
# Install (macOS)
brew install tea

# Install (Linux)
curl -sL https://dl.gitea.io/tea/main/tea-main-linux-amd64 -o tea
chmod +x tea && sudo mv tea /usr/local/bin/

# Authenticate (interactive)
tea login add

# Verify
tea whoami
```

## Authentication

```bash
# Interactive login (recommended)
tea login add
# Select: Application Token
# Enter Gitea URL and token from User Settings → Applications

# List logins
tea login list

# Set default
tea login default gitea.example.com

# Verify
tea whoami
```

## Command Reference

### Core Operations

| Category | Commands | Details |
|----------|----------|---------|
| **Issues** | 	ea issues, 	ea i | See [issues.md](references/issues.md) |
| **Pull Requests** | 	ea pulls, 	ea pr | See [pulls.md](references/pulls.md) |
| **Releases** | 	ea releases, 	ea r | See [releases.md](references/releases.md) |
| **Actions** | 	ea actions | See [actions.md](references/actions.md) |
| **Webhooks** | 	ea webhooks, 	ea hooks | See [webhooks.md](references/webhooks.md) |
| **API** | 	ea api | See [api.md](references/api.md) |
| **Others** | labels, milestones, branches, orgs, notifications, times, comments | See [misc.md](references/misc.md) |

### Common Patterns

**List entities**:
```bash
tea issues list --output json
tea pulls list --state closed --limit 50
tea releases list --repo owner/repo
```

**Create entities**:
```bash
tea issues create --title "Bug" --body "Description" --labels bug
tea pulls create --title "Feature" --base main --head feature-branch
tea releases create v1.0.0 --title "v1.0.0" --note "Release notes"
```

**View entities**:
```bash
tea issues 42
tea pulls 20
tea open 42  # Open in browser
```

## Non-Interactive Mode (Required for AI Agents)

**IMPORTANT**: In AI agent environments (no TTY), always use explicit flags:

```bash
# Specify output format
tea issues list --output simple
tea pulls list --output json

# Provide ALL arguments
tea issues create --title "Bug" --body "Description"
tea pulls create --title "PR" --head feature --base main

# Use --yes for confirmations
tea pulls merge 5 --yes
tea releases delete v0.9.0 --yes

# Set default login
tea login default <login-name>

# Always specify repo when outside git directory
tea issues list --repo owner/repo

# Use simple output for parsing
tea issues list --output simple --fields index,title,state
```

**Prefer explicit flags over interactive prompts.**

## Common Workflows

### Feature Branch → PR
```bash
git checkout -b feature/new-feature
git add . && git commit -m "feat: add feature"
git push -u origin feature/new-feature
tea pulls create --title "Add feature" --base main --head feature/new-feature
```

### Review & Merge PR
```bash
tea pulls checkout 20
tea pulls approve 20 --comment "LGTM!"
tea pulls merge 20 --style squash --message "feat: feature"
```

### Create Release with Assets
```bash
git tag v1.0.0
git push origin v1.0.0
tea releases create v1.0.0 \
  --title "v1.0.0" \
  --note-file CHANGELOG.md \
  --asset dist/app-linux \
  --asset dist/app-darwin
```

### Setup CI/CD Secrets
```bash
tea actions secrets create DOCKER_USERNAME "myuser"
tea actions secrets create DOCKER_PASSWORD "mypass"
tea actions variables set DEPLOY_ENV "production"
```

### Create Webhook for Notifications
```bash
tea webhooks create https://hooks.slack.com/services/YOUR/WEBHOOK/URL \
  --events push,pull_request \
  --secret "webhook-secret"
```

## Global Options

```bash
--debug, --vvv       Enable debug mode
--help, -h           Show help
--version, -v        Print version
--repo <owner/repo>  Override repository
--login <name>       Use specific login
--output <format>    Output: simple|table|csv|tsv|yaml|json
```

## Button-up Principle (PUA)

Before claiming failure:
1. **Verify authentication**: 	ea whoami
2. **Check repository context**: Ensure in git repo or use --repo
3. **Use non-interactive flags**: --output, --yes, explicit arguments
4. **Try alternatives**: Check 	ea <command> --help for all options
5. **Test with API**: Use 	ea api for advanced operations

## Troubleshooting

**"login not found"**:
```bash
tea login list
tea login default <login-name>
```

**"repository not found"**:
```bash
# Specify repo explicitly
tea issues list --repo owner/repo

# Or run inside git repository
```

**Interactive prompts blocking**:
```bash
# Always use explicit flags
tea <command> --output simple --yes
```

**API rate limits**:
```bash
# Use pagination
tea issues list --limit 100 --page 1
```
