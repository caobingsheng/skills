# Tea CLI 分页限制详解

## 技术根源

Tea CLI 的分页限制来自 **Gitea 服务端配置**，不是 Tea CLI 的 bug。

### 服务端配置

Gitea 服务端配置文件 `app.ini`：

```ini
[api]
MAX_RESPONSE_ITEMS = 50        # 最大每页条数（默认 50）
DEFAULT_PAGING_NUM = 30        # 默认每页条数（默认 30）
```

### 静默截断行为

```
用户请求：tea issues list --limit 1000
           ↓
Tea CLI 发送：GET /api/v1/repos/owner/repo/issues?limit=1000
           ↓
Gitea Server 检查配置：limit = min(1000, MAX_RESPONSE_ITEMS) = 50
           ↓
返回数据：只返回前 50 条，无任何警告或错误
           ↓
结果：用户误以为获取了全部数据，实际丢失了 950 条
```

**关键问题**：静默截断，无任何提示！

## 受影响的命令

### 完整列表

| 命令 | 说明 | 风险等级 |
|------|------|---------|
| `tea issues list` | 列出 issues | 🔴 高 |
| `tea pulls list` | 列出 Pull Requests | 🔴 高 |
| `tea labels list` | 列出标签 | 🟡 中 |
| `tea releases list` | 列出 releases | 🟡 中 |
| `tea milestones list` | 列出里程碑 | 🟡 中 |
| `tea branches list` | 列出分支 | 🟡 中 |
| `tea repos list` | 列出仓库 | 🔴 高 |
| `tea orgs list` | 列出组织 | 🟡 中 |
| `tea notifications list` | 列出通知 | 🟡 中 |
| `tea times list` | 列出时间记录 | 🟢 低 |

**风险等级说明**：
- 🔴 高：数据量大，超过 50 条很常见
- 🟡 中：数据量中等，部分场景会超过 50 条
- 🟢 低：数据量小，通常不会超过 50 条

### 如何判断是否受影响

**规则**：如果命令有以下特征，则受影响：
1. 命令名称包含 `list`
2. 支持 `--limit` 参数
3. 返回多条数据（数组）

## 解决方案

### 方案 1：使用辅助脚本（推荐）

项目已提供 `tea_paginate.py` 脚本，自动处理分页逻辑：

```bash
# 基础用法
python .claude/skills/gitea-tea/scripts/tea_paginate.py \
  --command "issues list --state all" \
  --repo owner/repo

# 高级用法
python .claude/skills/gitea-tea/scripts/tea_paginate.py \
  --command "pulls list --state all" \
  --repo owner/repo \
  --login my-gitea \
  --debug
```

**优点**：
- ✅ 自动分页，无需手动处理
- ✅ 返回合并后的完整 JSON 数据
- ✅ 提供调试模式查看进度
- ✅ 错误处理完善

### 方案 2：手动分页（Bash）

```bash
#!/bin/bash
# 获取全部 issues 并合并

all_issues="[]"
page=1

while true; do
    result=$(tea issues list --limit 50 --page $page --output json)

    if [ -z "$result" ] || [ "$result" = "null" ]; then
        break
    fi

    all_issues=$(echo "$all_issues $result" | jq -s 'add')

    # 检查是否最后一页
    count=$(echo "$result" | jq 'length')
    if [ "$count" -lt 50 ]; then
        break
    fi

    ((page++))
done

echo "$all_issues"
```

### 方案 3：手动分页（Python）

```python
import subprocess
import json

def fetch_all_issues(repo):
    all_issues = []
    page = 1

    while True:
        cmd = [
            "tea", "issues", "list",
            "--repo", repo,
            "--limit", "50",
            "--page", str(page),
            "--output", "json"
        ]

        result = subprocess.run(cmd, capture_output=True, text=True)
        if result.returncode != 0:
            raise RuntimeError(f"Failed: {result.stderr}")

        data = json.loads(result.stdout)
        if not data:
            break

        all_issues.extend(data)

        if len(data) < 50:
            break

        page += 1

    return all_issues

# 使用
issues = fetch_all_issues("owner/repo")
print(f"Total issues: {len(issues)}")
```

### 方案 4：使用 tea api 直接调用

```bash
# 使用 tea api 命令直接调用 Gitea API
for page in 1 2 3 4 5; do
    tea api /repos/owner/repo/issues \
        --limit 50 --page $page \
        --output json
done | jq -s 'add'
```

## 针对管理员的解决方案

如果你是 Gitea 服务端管理员，可以修改配置提高限制：

```ini
# 编辑 Gitea 配置文件（通常在 /etc/gitea/app.ini）
[api]
MAX_RESPONSE_ITEMS = 500       # 提高到 500
DEFAULT_PAGING_NUM = 100       # 默认每页 100
```

修改后重启 Gitea 服务：
```bash
sudo systemctl restart gitea
```

**注意**：
- ⚠️ 提高限制会增加服务器负载和响应时间
- ⚠️ 需要评估服务器性能和网络带宽
- ⚠️ 建议不要设置过高（如 1000+）

## 最佳实践

### 1. 始终使用辅助脚本

```bash
# ✅ 推荐
python tea_paginate.py --command "issues list" --repo owner/repo

# ❌ 不推荐（容易遗漏数据）
tea issues list --limit 100
```

### 2. 数据量预估

在编写脚本前，预估数据量：
- < 50 条：可以直接使用 `--limit 50`
- 50-500 条：建议使用分页脚本
- > 500 条：必须使用分页脚本

### 3. 增量获取

对于频繁更新的数据，考虑增量获取：

```bash
# 只获取最近 30 天的 issues（可能 < 50 条）
tea issues list --created-since "2024-01-01" --limit 50

# 如果超过 50 条，再使用分页
```

### 4. 调试模式

开发阶段使用 `--debug` 查看分页过程：

```bash
python tea_paginate.py \
  --command "issues list" \
  --repo owner/repo \
  --debug

# 输出示例：
# [分页] 第 1 页，命令: tea issues list --repo owner/repo --limit 50 --page 1 --output json
# [分页] 第 1 页获取 50 条，累计 50 条
# [分页] 第 2 页，命令: tea issues list --repo owner/repo --limit 50 --page 2 --output json
# [分页] 第 2 页获取 32 条，累计 82 条
# [分页] 完成，共 82 条，2 页
```

## 相关资源

- [Gitea API 文档 - Pagination](https://docs.gitea.com/development/api-usage)
- [Gitea 配置说明](https://docs.gitea.com/administration/config-cheat-sheet)
- [项目辅助脚本](../scripts/tea_paginate.py)
