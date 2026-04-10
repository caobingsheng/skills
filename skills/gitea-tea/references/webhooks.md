# Webhooks 命令参考

> ⚠️ **分页限制**：`--limit` 参数最大值 50，超过会被静默截断。详见 [pagination.md](pagination.md)。

管理仓库、组织或全局 Webhooks。

## 列表命令

```bash
# 列出 webhooks
tea webhooks list [--options]

# 常用选项
--repo <owner/repo>      # 仓库 webhook
--org <org>              # 组织 webhook
--global                 # 全局 webhook（需要管理员权限）
--limit <num>            # 数量限制
--output <format>        # 输出格式
```

**示例**：
```bash
tea webhooks list --repo owner/repo
tea webhooks list --org myorg
tea webhooks list --global
```

## 创建命令

```bash
# 创建 webhook
tea webhooks create <url> [--options]

# 常用选项
--events <events>        # 触发事件（逗号分隔）
--secret <secret>        # Webhook 密钥
--branch-filter <filter> # 分支过滤
--active                 # 是否激活
```

**可用事件**：push, pull_request, issues, release, create, delete, fork, watch, etc.

**示例**：
```bash
# 基本 webhook
tea webhooks create https://example.com/webhook \
  --events push,pull_request \
  --secret "webhook-secret"

# 带分支过滤
tea webhooks create https://example.com/webhook \
  --events push \
  --branch-filter "main,develop" \
  --active

# Slack 集成
tea webhooks create https://hooks.slack.com/services/YOUR/WEBHOOK/URL \
  --events push,pull_request \
  --secret "slack-secret"
```

## 更新命令

```bash
# 更新 webhook
tea webhooks update <webhook-id> [--options]

# 常用选项
--url <new-url>          # 新 URL
--events <events>        # 新事件列表
--active <true|false>    # 激活状态
--secret <secret>        # 新密钥
```

**示例**：
```bash
tea webhooks update 123 --url https://new-url.com/webhook --active false
tea webhooks update 123 --events push,release
```

## 删除命令

```bash
# 删除 webhook
tea webhooks delete <webhook-id>
```

## 工作流程

```bash
# 为团队通知创建 webhook
tea webhooks create https://hooks.slack.com/services/XXX/YYY/ZZZ \
  --events push,pull_request,issues \
  --secret "team-webhook-secret"

# 创建 CI webhook
tea webhooks create https://ci.example.com/webhook \
  --events push,pull_request \
  --branch-filter "main,develop" \
  --active
```
