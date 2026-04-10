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
| **API** | 	ea api | 直接调用Gitea原生API，支持所有高级操作，常用用法见下方，详细参考 [api.md](references/api.md) |
| **Others** | labels, milestones, branches, orgs, notifications, times, comments | See [misc.md](references/misc.md) |

---

### API 命令（高级操作）
当tea内置命令无法满足需求时，可直接通过`tea api`调用Gitea所有原生API接口：

#### 基础语法
```bash
tea api <endpoint> [--options]
```
- 端点自动补全：`/repos/{owner}/{repo}` 占位符会从当前git仓库上下文自动填充
- 默认前缀：不以`/api/`或`http`开头的端点会自动添加`/api/v1/`前缀

#### 常用示例
```bash
# 查询当前仓库所有issue
tea api /repos/{owner}/{repo}/issues

# 创建新issue（POST方法）
tea api /repos/{owner}/{repo}/issues \
  --method POST \
  -f title="Bug修复请求" \
  -f body="登录页面验证码不显示" \
  -f labels="bug,high-priority"

# 更新issue状态（PATCH方法）
tea api /repos/{owner}/{repo}/issues/42 \
  --method PATCH \
  -f state="closed"

# 获取当前用户信息
tea api /user

# 列出组织所有仓库
tea api /orgs/your-org/repos --limit 100

# 删除指定release
tea api /repos/{owner}/{repo}/releases/10 --method DELETE
```

#### 核心常用端点速查
| 场景 | 端点 | 方法 |
|------|------|------|
| 查询issue | `/repos/{owner}/{repo}/issues/{index}` | GET |
| 创建PR | `/repos/{owner}/{repo}/pulls` | POST |
| 合并PR | `/repos/{owner}/{repo}/pulls/{index}/merge` | POST |
| 查询仓库协作者 | `/repos/{owner}/{repo}/collaborators` | GET |
| 获取文件内容 | `/repos/{owner}/{repo}/contents/{filepath}` | GET |
| 列出Actions密钥 | `/repos/{owner}/{repo}/actions/secrets` | GET |
| 创建Webhook | `/repos/{owner}/{repo}/hooks` | POST |
| 标记通知已读 | `/notifications/threads/{id}` | PATCH |

> 💡 完整API参考：
> - 本地详细文档：[api.md](references/api.md)（包含100+端点分类、参数说明、Swagger文档使用方法）
> - 官方在线文档：https://docs.gitea.io/en-us/api-usage/

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

# API 命令非交互模式
tea api /repos/{owner}/{repo}/issues --output json
tea api /repos/{owner}/{repo}/issues \
  --method POST \
  -f title="New Issue" \
  -f body="Description" \
  --output yaml
```

**Prefer explicit flags over interactive prompts.**

#### API 调试技巧
```bash
# 启用调试模式，查看完整请求/响应
tea api /user --debug

# 自定义请求头
tea api /repos/{owner}/{repo}/issues \
  --header "Accept: application/json" \
  --header "X-Custom-Header: value"

# 从文件读取请求体
tea api /repos/{owner}/{repo}/issues \
  --method POST \
  --input issue.json
```

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
