# Tea CLI 辅助脚本

本目录包含用于增强 Tea CLI 功能的辅助脚本。

## tea_paginate.py - 通用分页工具

自动处理 Tea CLI 列表命令的分页逻辑，获取全部数据。

### 为什么需要这个脚本？

Tea CLI 所有列表命令受 Gitea API 服务端限制，**最大每页 50 条**：
- `--limit` 参数超过 50 会被静默截断
- 不会有任何错误提示或警告
- 容易导致数据丢失而不自知

这个脚本自动处理分页逻辑，确保获取全部数据。

### 快速开始

```bash
# 获取全部 labels
python tea_paginate.py --command "labels list" --repo "owner/repo"

# 获取全部 issues（包括已关闭的）
python tea_paginate.py --command "issues list --state all" --repo "owner/repo"

# 获取全部 Pull Requests
python tea_paginate.py --command "pulls list --state all" --repo "owner/repo"
```

### 完整用法

```bash
python tea_paginate.py --command <命令> [--repo <仓库>] [--login <登录名>] [--debug]
```

#### 参数说明

| 参数 | 必需 | 说明 | 示例 |
|------|------|------|------|
| `--command`, `-c` | ✅ | tea 子命令 | `"issues list --state all"` |
| `--repo`, `-r` | ❌ | 仓库标识 | `owner/repo` |
| `--login`, `-l` | ❌ | Gitea 登录名 | `my-gitea` |
| `--page-size`, `-s` | ❌ | 每页大小（默认 50，最大 50） | `30` |
| `--debug` | ❌ | 打印详细调试信息 | - |

#### 退出码

| 退出码 | 说明 |
|--------|------|
| 0 | 成功 |
| 1 | 参数错误 |
| 2 | Tea CLI 不可用或未登录 |
| 3 | 分页过程中发生错误 |

### 使用示例

#### 示例 1：获取全部 issues

```bash
python tea_paginate.py \
  --command "issues list --state all" \
  --repo owner/repo \
  --debug

# 输出（stderr）：
# [状态] tea CLI 已就绪，当前用户: username
# [开始] 分页获取命令: tea issues list --state all
# [仓库] owner/repo
# [分页] 正在获取第 1 页...
# [分页] 第 1 页获取 50 条，累计 50 条
# [分页] 正在获取第 2 页...
# [分页] 第 2 页获取 32 条，累计 82 条
# [完成] 共获取 82 条数据，2 页

# 输出（stdout）：
# [
#   {"index": 1, "title": "...", ...},
#   {"index": 2, "title": "...", ...},
#   ...
# ]
```

#### 示例 2：获取全部 labels

```bash
python tea_paginate.py --command "labels list" --repo owner/repo

# 输出（JSON 数组）
```

#### 示例 3：获取全部 Pull Requests

```bash
python tea_paginate.py \
  --command "pulls list --state all" \
  --repo owner/repo
```

#### 示例 4：使用指定登录名（多账号场景）

```bash
python tea_paginate.py \
  --command "repos list" \
  --login my-gitea
```

### 输出格式

脚本输出到两个地方：

**stdout（标准输出）**：
- JSON 数组，包含所有分页的合并结果
- 格式化输出（带缩进），便于阅读

**stderr（标准错误）**：
- 调试信息（使用 `--debug` 参数）
- 统计信息（总条数、估算页数）
- 错误信息

### 错误处理

脚本会检测并报告以下错误：

```bash
# Tea CLI 未安装
python tea_paginate.py --command "issues list"
# stderr: {"error": "tea CLI 未安装。安装方式：..."}

# Tea CLI 未登录
python tea_paginate.py --command "issues list"
# stderr: {"error": "tea CLI 未登录。请运行: tea login add"}

# tea 命令执行失败
python tea_paginate.py --command "issues list" --repo nonexistent/repo
# stderr: {"error": "tea 命令执行失败（第 1 页）:\n  命令: ...\n  错误: ..."}
```

### 与其他工具集成

#### 保存到文件

```bash
python tea_paginate.py --command "issues list" --repo owner/repo > issues.json
```

#### 使用 jq 处理

```bash
# 统计总数
python tea_paginate.py --command "issues list" --repo owner/repo | jq 'length'

# 提取特定字段
python tea_paginate.py --command "issues list" --repo owner/repo | \
  jq '.[].title'

# 过滤数据
python tea_paginate.py --command "issues list" --repo owner/repo | \
  jq '.[] | select(.state == "open")'
```

### 常见问题

#### Q: 为什么 --limit 参数会被忽略？

A: 这是 Gitea 服务端的硬限制，不是脚本的限制。脚本自动将 `page_size` 限制为 50，并通过循环分页获取全部数据。

详见：[../references/pagination.md](../references/pagination.md)

#### Q: 如何获取特定状态的 issues？

A: 在 `--command` 参数中添加过滤条件：

```bash
python tea_paginate.py \
  --command "issues list --state closed" \
  --repo owner/repo
```

#### Q: 支持哪些 tea 命令？

A: 所有返回列表的 tea 命令：
- `issues list`
- `pulls list`
- `labels list`
- `releases list`
- `milestones list`
- `branches list`
- `repos list`
- `orgs list`
- `notifications list`
- 等等

#### Q: 如何查看分页过程？

A: 使用 `--debug` 参数：

```bash
python tea_paginate.py --command "issues list" --repo owner/repo --debug
```

## 相关文档

- [分页限制详解](../references/pagination.md)
- [Tea CLI 主文档](../SKILL.md)
- [Gitea API 文档](https://docs.gitea.com/development/api-usage)