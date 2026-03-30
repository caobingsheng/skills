---
name: gitea-tea
description: Manage Gitea via CLI. Use when user mentions "tea", "gitea cli", or needs terminal-based Gitea operations.
version: 2.0.0
---

# Gitea CLI (tea)

## Overview

Official command-line interface for Gitea. Manage issues, PRs, releases, workflows, webhooks, and repos from terminal.

**Version**: tea 0.12.0+ with Gitea API v0.23.2

## Quick Reference

| Category | Commands |
|----------|----------|
| **Issues** | `tea issues`, `tea i` |
| **Pull Requests** | `tea pulls`, `tea pr` |
| **Releases** | `tea releases`, `tea r` |
| **Labels** | `tea labels` |
| **Milestones** | `tea milestones`, `tea ms` |
| **Gitea Actions** | `tea actions` ⭐ |
| **Webhooks** | `tea webhooks`, `tea hooks` ⭐ |
| **Repositories** | `tea repos` |
| **Branches** | `tea branches`, `tea b` |
| **Organizations** | `tea orgs`, `tea org` |
| **Time Tracking** | `tea times`, `tea t` |
| **Notifications** | `tea notifications`, `tea n` |
| **Comments** | `tea comment`, `tea c` |
| **API** | `tea api` |
| **Admin** | `tea admin`, `tea a` |

## Instructions

1. **Verify authentication**: Run `tea whoami` to confirm login
2. **Check context**: Run in git repo for auto-detection, or use `--repo owner/repo`
3. **Use non-interactive mode**: Always use `--output` flag and provide all arguments
4. **Choose operation**: See command reference sections below

## Installation

```bash
# macOS
brew install tea

# Linux (binary)
curl -sL https://dl.gitea.io/tea/main/tea-main-linux-amd64 -o tea
chmod +x tea && sudo mv tea /usr/local/bin/

# Windows (via Scoop)
scoop install tea

# From source
go install code.gitea.io/tea@latest
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

# Delete login
tea login delete gitea.example.com

# Verify
tea whoami
```

## Issues

### List Issues
```bash
# Open issues in current repo
tea issues list

# All issues (including closed)
tea issues list --state all

# Filter by milestone
tea issues list --milestone "v1.0.0"

# Filter by assignee and labels
tea issues list --assignee username --labels bug,critical

# Custom fields
tea issues list --fields index,title,state,author,labels,created

# Search by keyword
tea issues list --keyword "authentication"

# Filter by date range
tea issues list --from "2024-01-01" --until "2024-12-31"

# From specific repo
tea issues list --repo owner/repo --login gitea.com

# Output formats
tea issues list --output json
tea issues list --output yaml
```

### View Issue
```bash
# View issue with comments
tea issues 42

# Without comments
tea issues 42 --comments=false

# Open in browser
tea open 42
```

### Create Issue
```bash
# Interactive
tea issues create

# With arguments
tea issues create \
  --title "Fix authentication bug" \
  --body "Users cannot login with special characters" \
  --labels bug,security \
  --assignee developer1 \
  --milestone "v1.2.0"

# From file
tea issues create \
  --title "Feature request" \
  --body "$(cat feature-request.md)"
```

### Modify Issues
```bash
# Close issue
tea issues close 42

# Reopen issue
tea issues reopen 42

# Edit issue
tea issues edit 42 \
  --title "Updated title" \
  --assignee newdev \
  --add-labels "enhancement"
```

## Pull Requests

### List PRs
```bash
# Open PRs
tea pulls list

# Closed PRs
tea pulls list --state closed

# Filter by reviewer and labels
tea pulls list --reviewer username --labels "needs-review"

# Custom fields
tea pulls list --fields index,title,state,author,base,head,mergeable

# Output formats
tea pulls list --output json
```

### View PR
```bash
# View PR details
tea pulls 15

# Without comments
tea pulls 15 --comments=false

# Open in browser
tea open 15
```

### Create PR
```bash
# Interactive
tea pulls create

# With arguments
tea pulls create \
  --title "Implement user authentication" \
  --description "Adds OAuth and JWT support" \
  --base main \
  --head feature/auth \
  --assignee reviewer1,reviewer2 \
  --labels "enhancement"

# Description from file
tea pulls create \
  --title "Major refactor" \
  --description "$(cat pr-description.md)"
```

### Checkout PR
```bash
# Checkout PR locally
tea pulls checkout 20

# Custom branch name
tea pulls checkout 20 pr-20-custom-name

# Clean up checked out PRs
tea pulls clean
```

### Review & Merge
```bash
# Approve PR
tea pulls approve 20 --comment "LGTM!"

# Request changes
tea pulls reject 20 --comment "Please add tests"

# Leave comment
tea pulls review 20 \
  --state comment \
  --comment "Consider refactoring this section"

# Merge PR (squash)
tea pulls merge 20 --style squash --message "feat: implement auth"

# Merge PR (rebase)
tea pulls merge 20 --style rebase

# Close PR
tea pulls close 20

# Reopen PR
tea pulls reopen 20
```

## Releases

### List Releases
```bash
tea releases list
tea releases list --limit 10
tea releases list --repo owner/project
tea releases list --output json
```

### Create Release
```bash
# Basic release
tea releases create v1.0.0 \
  --title "Version 1.0.0" \
  --note "First stable release"

# From changelog file
tea releases create v1.2.0 \
  --title "Version 1.2.0" \
  --note-file CHANGELOG.md

# Draft release
tea releases create v2.0.0-beta \
  --title "Beta Release" \
  --draft \
  --note "Beta for testing"

# With assets
tea releases create v1.1.0-rc1 \
  --title "Release Candidate 1" \
  --prerelease \
  --asset dist/binary-linux-amd64 \
  --asset dist/binary-darwin-amd64

# Create tag + release
tea releases create v1.3.0 \
  --target main \
  --title "Version 1.3.0" \
  --note "New features"
```

### Manage Release Assets
```bash
# List assets
tea releases assets list v1.0.0

# Add asset to existing release
tea releases assets create v1.0.0 --asset dist/binary.exe

# Delete asset
tea releases assets delete v1.0.0 binary.exe
```

### Edit/Delete Release
```bash
# Update release
tea releases edit v1.0.0 \
  --title "Version 1.0.0 - Updated" \
  --note-file NEW-NOTES.md

# Publish draft
tea releases edit v2.0.0 --draft=false

# Delete release
tea releases delete v0.9.0
tea releases delete v1.0.0-beta --confirm
```

## Labels

```bash
# List labels
tea labels list
tea labels list --repo owner/project
tea labels list --save  # Save labels to file

# Create label
tea labels create bug \
  --color "#ff0000" \
  --description "Something isn't working"

tea labels create enhancement \
  --color "0,255,0" \
  --description "New feature"

# Update label
tea labels update bug --color "#cc0000"
tea labels update old-name --name new-name

# Delete label
tea labels delete bug
```

## Milestones

```bash
# List milestones
tea milestones list
tea milestones list --state open
tea milestones list --state closed

# View milestone issues
tea milestones issues "v1.0.0"
tea milestones issues "v1.0.0" --kind pull  # Only PRs
tea milestones issues "v1.0.0" --state all

# Add issue/PR to milestone
tea milestones issues add "v1.0.0" 42

# Remove issue/PR from milestone
tea milestones issues remove "v1.0.0" 42

# Create milestone
tea milestones create "v2.0.0" \
  --description "Major version release" \
  --deadline "2024-12-31"

# Close milestone
tea milestones close "v1.0.0"

# Reopen milestone
tea milestones reopen "v1.0.0"

# Delete milestone
tea milestones delete "v0.9.0"
```

## Repositories

```bash
# List repos
tea repos list
tea repos list --owner myorg
tea repos list --watched  # Watched repos
tea repos list --starred  # Starred repos
tea repos list --type fork  # Filter: fork, mirror, source
tea repos list --output yaml

# Search repos
tea repos search "keyword" --login gitea.com

# View repo details
tea repos owner/repo

# Create repo
tea repos create --name myrepo --private --init
tea repos create \
  --name myrepo \
  --owner myorg \
  --description "My project" \
  --private \
  --init \
  --gitignores Go \
  --license MIT

# Create from template
tea repos create-from-template \
  --template owner/template-repo \
  --name new-repo

# Fork repo
tea repos fork --repo owner/repo
tea repos fork --repo owner/repo --owner myorg

# Migrate repo
tea repos migrate \
  --name migrated-repo \
  --clone-url https://github.com/user/repo.git

# Edit repo
tea repos edit owner/repo --description "Updated description"

# Delete repo
tea repos delete owner/repo

# Clone repo (without git)
tea clone owner/repo
tea clone owner/repo ./target-dir
tea clone gitea.com/owner/repo  # With host
```

## Branches

```bash
# List branches
tea branches list
tea branches list --output json

# View branch details
tea branches main

# Protect branch
tea branches protect main

# Unprotect branch
tea branches unprotect main
```

## Gitea Actions ⭐

Manage CI/CD workflows, secrets, and variables.

### Secrets
```bash
# List secrets
tea actions secrets list
tea actions secrets list --repo owner/repo

# Create secret
tea actions secrets create SECRET_NAME "secret-value"

# Create secret from file
tea actions secrets create SECRET_NAME --file secret.txt

# Create secret from stdin
echo "secret-value" | tea actions secrets create SECRET_NAME --stdin

# Delete secret
tea actions secrets delete SECRET_NAME
```

### Variables
```bash
# List variables
tea actions variables list

# Set variable
tea actions variables set VAR_NAME "variable-value"

# Set variable from file
tea actions variables set VAR_NAME --file variable.txt

# Set variable from stdin
echo "variable-value" | tea actions variables set VAR_NAME --stdin

# Delete variable
tea actions variables delete VAR_NAME
```

### Workflow Runs
```bash
# List runs
tea actions runs list

# View run details
tea actions runs view <run-id>

# Re-run workflow
tea actions runs rerun <run-id>

# Cancel run
tea actions runs cancel <run-id>

# View logs
tea actions runs logs <run-id>
```

### Workflows
```bash
# List workflows
tea actions workflows list

# View workflow details
tea actions workflows view <workflow-id>
```

## Webhooks ⭐

Manage repository, organization, or global webhooks.

```bash
# List webhooks
tea webhooks list
tea webhooks list --repo owner/repo
tea webhooks list --org myorg
tea webhooks list --global

# Create webhook
tea webhooks create https://example.com/webhook \
  --events push,pull_request \
  --secret "webhook-secret"

# With filters
tea webhooks create https://example.com/webhook \
  --events push \
  --branch-filter "main,develop" \
  --active

# Update webhook
tea webhooks update <webhook-id> \
  --url https://new-url.com/webhook \
  --active false

# Delete webhook
tea webhooks delete <webhook-id>
```

## Time Tracking

```bash
# List time entries
tea times list
tea times list --issue 42
tea times list --user username
tea times list --from "2024-01-01" --until "2024-12-31"
tea times list --mine  # All your times across all repos

# Add time
tea times add 42 "2h"
tea times add 42 "1h30m"

# Delete entry
tea times delete 42 --id 123

# Reset all time on issue
tea times reset 42

# Show total
tea times list --total
```

## Notifications

```bash
# List notifications (current repo)
tea notifications list

# List all notifications
tea notifications list --mine

# Filter by type
tea notifications list --types issue,pull

# Filter by state
tea notifications list --states unread,pinned

# Custom fields
tea notifications list --fields id,status,title,repository

# Mark as read
tea notifications read  # All filtered
tea notifications read 123  # Specific ID

# Mark as unread
tea notifications unread 123

# Pin/unpin
tea notifications pin 123
tea notifications unpin 123
```

## Organizations

```bash
# List organizations
tea organizations list

# View organization details
tea organizations myorg

# Create organization
tea organizations create myorg

# Delete organization
tea organizations delete myorg
```

## Comments

```bash
# Add comment to issue or PR
tea comment 42 "This is my comment"

# From specific repo
tea comment 42 "Comment text" --repo owner/repo
```

## API & Advanced Usage ⭐

Make authenticated API requests directly.

### Basic Requests
```bash
# GET request
tea api /repos/{owner}/{repo}/issues

# With pagination
tea api '/repos/{owner}/{repo}/issues?state=open&page=1&limit=50'

# POST request
tea api /repos/{owner}/{repo}/issues \
  --method POST \
  -f title="API Created Issue" \
  -f body="Created via API"

# Custom headers
tea api /user \
  -H "Accept: application/json"
```

### Typed Fields (-F)
```bash
# Boolean field
tea api /repos/{owner}/{repo} \
  -F private=true

# Number field
tea api /repos/{owner}/{repo}/issues \
  -F milestone=5

# Null value
tea api /repos/{owner}/{repo}/issues/42 \
  -X PATCH \
  -F assignee=null

# JSON array/object
tea api /repos/{owner}/{repo}/issues \
  -F labels="[1,2,3]"

# Read from file
tea api /repos/{owner}/{repo}/issues \
  -F body=@issue-body.txt

# Read from stdin
cat issue-body.txt | tea api /repos/{owner}/{repo}/issues \
  -F body=@-
```

### Raw JSON Body
```bash
# Send JSON from file
tea api /repos/{owner}/{repo}/issues \
  --method POST \
  --data @issue.json

# Send JSON from stdin
cat issue.json | tea api /repos/{owner}/{repo}/issues \
  --method POST \
  --data @-

# Inline JSON
tea api /repos/{owner}/{repo}/issues \
  --method POST \
  --data '{"title":"Issue title","body":"Issue body"}'
```

### Output Options
```bash
# Save response to file
tea api /repos/{owner}/{repo} --output repo.json

# Include HTTP headers
tea api /repos/{owner}/{repo} --include
```

### Placeholders
```bash
# {owner} and {repo} are auto-filled from context
tea api /repos/{owner}/{repo}/issues
# Becomes: /repos/actual-owner/actual-repo/issues
```

## Admin (requires admin access)

```bash
# List users
tea admin users list
tea admin users list --output json
```

## Non-Interactive Mode (AI Agents)

**IMPORTANT:** When using tea in AI agent environments (no TTY), avoid interactive prompts:

```bash
# Use --output to disable interactive mode
tea issues list --output simple
tea pulls list --output json

# Provide ALL required arguments upfront
tea issues create --title "Bug title" --body "Description here"
tea pulls create --title "PR title" --head feature-branch --base main

# Use -y or --yes for confirmations
tea pulls merge 5 --yes
tea releases delete v0.9.0 --yes

# Set default login to avoid prompts
tea login default <login-name>

# Always specify repo when outside git directory
tea issues list --repo owner/repo

# Use simple output for parsing
tea issues list --output simple --fields index,title,state
```

**Always prefer explicit flags over interactive prompts.**

## Common Workflows

### Feature Branch → PR
```bash
git checkout -b feature/new-feature
# ... make changes ...
git add . && git commit -m "feat: add new feature"
git push -u origin feature/new-feature
tea pulls create --title "Add new feature" --base main --head feature/new-feature
```

### Review & Merge PR
```bash
tea pulls checkout 20
# ... review code ...
tea pulls approve 20 --comment "LGTM!"
tea pulls merge 20 --style squash
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
# Add secrets for CI
tea actions secrets create DOCKER_USERNAME "myuser"
tea actions secrets create DOCKER_PASSWORD "mypass"

# Set variables
tea actions variables set DEPLOY_ENV "production"
```

### Webhook for Notifications
```bash
tea webhooks create https://hooks.slack.com/services/YOUR/WEBHOOK/URL \
  --events push,pull_request \
  --secret "webhook-secret"
```

### Bulk Issue Management
```bash
# List all open bugs
tea issues list --labels bug --output json > bugs.json

# Create multiple issues from script
for i in {1..5}; do
  tea issues create --title "Issue $i" --body "Description for issue $i"
done
```

## Output Formats

All list commands support multiple output formats:

```bash
--output simple    # Plain text (default for TTY)
--output table     # ASCII table
--output csv       # Comma-separated values
--output tsv       # Tab-separated values
--output yaml      # YAML format
--output json      # JSON format
```

## Guidelines

### Do
- Use `--output simple` or `--output json` for non-interactive mode
- Provide all required arguments upfront to avoid prompts
- Run `tea whoami` to verify authentication before operations
- Use `tea open <number>` to quickly view in browser
- Use `--fields` to customize output columns
- Use `tea api` for advanced operations not covered by commands

### Don't
- Use interactive commands in AI agent context (no TTY)
- Forget `--repo owner/repo` when outside git repository
- Skip `--yes` flag for destructive operations in scripts
- Use `tea login add` interactively (configure beforehand)
- Assume default output format in scripts (always specify --output)

## Troubleshooting

### Authentication Issues
```bash
# Check current login
tea whoami

# List all logins
tea login list

# Switch login
tea login default <login-name>
```

### Repo Not Found
```bash
# Specify repo explicitly
tea issues list --repo owner/repo

# Or use remote detection
tea issues list --remote origin
```

### No Output / Empty Results
```bash
# Check filters
tea issues list --state all  # Include closed

# Check permissions
tea whoami  # Verify user has access

# Use debug mode
tea --debug issues list
```

## Environment Variables

```bash
# Config directory (default: $XDG_CONFIG_HOME/tea)
export TEA_CONFIG=~/.config/tea

# Debug mode
export TEA_DEBUG=1
```

## Further Reading

- Official Documentation: https://gitea.io
- Tea Repository: https://gitea.com/gitea/tea
- Gitea API Documentation: https://docs.gitea.io/en-us/api-usage/
