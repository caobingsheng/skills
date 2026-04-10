# Pull Requests 命令参考

> ⚠️ **分页限制**：`--limit` 参数最大值 50，超过会被静默截断。详见 [pagination.md](pagination.md)。

## 列表命令

```bash
# 列出 PRs
tea pulls list [--options]

# 常用选项
--state <state>          # 状态：all|open|closed (默认: open)
--labels <labels>        # 标签过滤
--reviewer <user>        # 审查者过滤
--fields <fields>        # 显示字段
--output <format>        # 输出格式
--limit <num>            # 每页数量
--repo <owner/repo>      # 指定仓库
```

**可用字段**：index, state, author, author-id, url, title, body, mergeable, base, base-commit, head, diff, patch, created, updated, deadline, assignees, milestone, labels, comments

**示例**：
```bash
tea pulls list --state closed
tea pulls list --reviewer username --labels needs-review
tea pulls list --fields index,title,base,head,mergeable --output json
```

## 查看命令

```bash
# 查看 PR 详情
tea pulls <index> [--comments=false]

# 在浏览器中打开
tea open <index>
```

## 创建命令

```bash
# 交互式创建
tea pulls create

# 带参数创建
tea pulls create \
  --title <title> \
  --description <desc> \
  --base <branch> \
  --head <branch> \
  --assignee <users> \
  --labels <labels>

# 从文件读取描述
tea pulls create --title "PR" --description "$(cat pr-desc.md)"
```

## Checkout 命令

```bash
# 检出 PR 到本地
tea pulls checkout <index> [branch-name]

# 清理已检出的 PR 分支
tea pulls clean
```

## 审查命令

```bash
# 批准 PR
tea pulls approve <index> --comment "LGTM!"

# 请求修改
tea pulls reject <index> --comment "Please add tests"

# 评论
tea pulls review <index> --state comment --comment "Text"
```

## 合并命令

```bash
# 合并 PR（支持不同风格）
tea pulls merge <index> --style <merge|squash|rebase> --message <msg>

# 关闭 PR
tea pulls close <index>

# 重新打开
tea pulls reopen <index>
```

## 工作流程

```bash
# 标准流程
git checkout -b feature/new-feature
# ... 开发 ...
git push -u origin feature/new-feature
tea pulls create --title "Feature" --base main --head feature/new-feature

# 审查流程
tea pulls checkout 20
# ... 审查 ...
tea pulls approve 20 --comment "Approved"
tea pulls merge 20 --style squash
```
