# 其他命令参考

> ⚠️ **分页限制**：所有列表命令的 `--limit` 参数最大值 50，超过会被静默截断。详见 [pagination.md](pagination.md)。

涵盖 labels、milestones、branches、organizations、notifications、times、comments 等命令。

## Labels（标签）

```bash
# 列出标签
tea labels list [--repo <owner/repo>] [--save]

# 创建标签
tea labels create <name> --color <color> --description <desc>

# 更新标签
tea labels update <name> [--name <new-name>] [--color <color>]

# 删除标签
tea labels delete <name>
```

**颜色格式**：`#ff0000` 或 `255,0,0`

**示例**：
```bash
tea labels create bug --color "#ff0000" --description "Bug report"
tea labels create enhancement --color "0,255,0" --description "New feature"
tea labels update bug --color "#cc0000"
```

## Milestones（里程碑）

```bash
# 列出里程碑
tea milestones list [--state <open|closed|all>]

# 查看里程碑中的 issues
tea milestones issues <name> [--kind <issues|pull>] [--state <state>]

# 管理 issues
tea milestones issues add <name> <issue-index>
tea milestones issues remove <name> <issue-index>

# 创建里程碑
tea milestones create <name> [--description <desc>] [--deadline <date>]

# 关闭/重新打开
tea milestones close <name>
tea milestones reopen <name>

# 删除
tea milestones delete <name>
```

**示例**：
```bash
tea milestones create "v2.0.0" --description "Major release" --deadline "2024-12-31"
tea milestones issues add "v2.0.0" 42
tea milestones issues "v2.0.0" --kind issues
tea milestones close "v1.0.0"
```

## Branches（分支）

```bash
# 列出分支
tea branches list [--output <format>]

# 查看分支详情
tea branches <branch-name>

# 保护分支
tea branches protect <branch-name>

# 取消保护
tea branches unprotect <branch-name>
```

**示例**：
```bash
tea branches list --output json
tea branches main
tea branches protect main
```

## Organizations（组织）

```bash
# 列出组织
tea organizations list

# 查看组织详情
tea organizations <org-name>

# 创建组织
tea organizations create <org-name>

# 删除组织
tea organizations delete <org-name>
```

## Notifications（通知）

```bash
# 列出通知
tea notifications list [--mine] [--types <types>] [--states <states>]

# 标记已读/未读
tea notifications read [<id>]
tea notifications unread <id>

# 固定/取消固定
tea notifications pin <id>
tea notifications unpin <id>
```

**类型**：issue, pull, commit, repository
**状态**：unread, read, pinned

**示例**：
```bash
tea notifications list --mine
tea notifications list --types issue,pull --states unread
tea notifications read  # 全部标记已读
tea notifications pin 123
```

## Times（时间跟踪）

```bash
# 列出时间记录
tea times list [--issue <index>] [--user <user>] [--mine]
tea times list --from <date> --until <date> --total

# 添加时间
tea times add <issue-index> <duration>

# 删除记录
tea times delete <issue-index> --id <time-id>

# 重置
tea times reset <issue-index>
```

**时长格式**：`2h`, `1h30m`, `45m`

**示例**：
```bash
tea times list --mine --total
tea times add 42 "2h"
tea times add 42 "1h30m"
tea times delete 42 --id 123
```

## Comments（评论）

```bash
# 添加评论
tea comment <issue-or-pr-index> <comment-text> [--repo <owner/repo>]
```

**示例**：
```bash
tea comment 42 "This is a comment"
tea comment 15 "LGTM!" --repo owner/repo
```

## Repositories（仓库）

```bash
# 列出仓库
tea repos list [--owner <org>] [--watched] [--starred] [--type <type>]

# 搜索仓库
tea repos search <keyword>

# 查看详情
tea repos <owner/repo>

# 创建仓库
tea repos create --name <name> [--owner <org>] [--private] [--init]

# Fork
tea repos fork --repo <owner/repo>

# Clone
tea clone <owner/repo> [target-dir]
```

**仓库类型**：fork, mirror, source

**示例**：
```bash
tea repos list --watched
tea repos create --name myrepo --private --init --license MIT
tea repos fork --repo owner/repo
tea clone owner/repo
```
