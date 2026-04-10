# Issues 命令参考

## 列表命令

```bash
# 列出 issues
tea issues list [--options]

# 常用选项
--state <state>          # 状态过滤：all|open|closed (默认: open)
--labels <labels>        # 标签过滤（逗号分隔）
--milestone <ms>         # 里程碑过滤
--assignee <user>        # 负责人过滤
--keyword <text>         # 关键词搜索
--fields <fields>        # 显示字段（逗号分隔）
--output <format>        # 输出格式：simple|table|csv|tsv|yaml|json
--limit <num>            # 每页数量 (默认: 30)
--repo <owner/repo>      # 指定仓库
```

**可用字段**：index, state, kind, author, author-id, url, title, body, created, updated, deadline, assignees, milestone, labels, comments, owner, repo

**示例**：
```bash
tea issues list --state all --labels bug,critical
tea issues list --assignee username --milestone "v1.0.0"
tea issues list --fields index,title,state,author --output json
tea issues list --keyword "authentication" --limit 50
```

## 查看命令

```bash
# 查看 issue 详情
tea issues <index> [--comments=false]

# 在浏览器中打开
tea open <index>
```

## 创建命令

```bash
# 交互式创建
tea issues create

# 带参数创建
tea issues create \
  --title <title> \
  --body <body> \
  --labels <labels> \
  --assignee <user> \
  --milestone <ms>

# 从文件读取内容
tea issues create --title "Feature" --body "$(cat description.md)"
```

## 修改命令

```bash
# 关闭 issue
tea issues close <index>

# 重新打开
tea issues reopen <index>

# 编辑
tea issues edit <index> \
  --title <new-title> \
  --assignee <user> \
  --add-labels <labels>
```

## 非交互模式（AI Agent）

```bash
# 必须提供所有参数
tea issues create --title "Bug" --body "Description"
tea issues list --output json
tea issues close 42 --repo owner/repo
```
