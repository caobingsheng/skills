# Releases 命令参考

> ⚠️ **分页限制**：`--limit` 参数最大值 50，超过会被静默截断。详见 [pagination.md](pagination.md)。

## 列表命令

```bash
# 列出 releases
tea releases list [--options]

# 常用选项
--limit <num>            # 数量限制
--output <format>        # 输出格式
--repo <owner/repo>      # 指定仓库
```

## 创建命令

```bash
# 基本 release
tea releases create <tag> --title <title> --note <note>

# 从文件读取发布说明
tea releases create <tag> --title <title> --note-file <file>

# 创建 draft
tea releases create <tag> --title <title> --draft --note <note>

# 创建预发布
tea releases create <tag> --title <title> --prerelease --note <note>

# 带资源文件
tea releases create <tag> --title <title> --note <note> \
  --asset <file1> --asset <file2>

# 创建 tag 并发布
tea releases create <tag> --target <branch> --title <title> --note <note>
```

**示例**：
```bash
tea releases create v1.0.0 --title "v1.0.0" --note "First release"
tea releases create v1.2.0 --title "v1.2.0" --note-file CHANGELOG.md
tea releases create v2.0.0-beta --title "Beta" --prerelease --note "Beta release"
tea releases create v1.1.0 --title "v1.1.0" --note "Update" \
  --asset dist/app-linux --asset dist/app-darwin
```

## 管理资源

```bash
# 列出资源
tea releases assets list <tag>

# 添加资源
tea releases assets create <tag> --asset <file>

# 删除资源
tea releases assets delete <tag> <asset-name>
```

## 编辑和删除

```bash
# 更新 release
tea releases edit <tag> --title <new-title> --note-file <file>

# 发布 draft
tea releases edit <tag> --draft=false

# 删除 release
tea releases delete <tag> [--confirm]
```

## 工作流程

```bash
# 标准 release 流程
git tag v1.0.0
git push origin v1.0.0
tea releases create v1.0.0 \
  --title "Version 1.0.0" \
  --note-file CHANGELOG.md \
  --asset dist/binary-linux \
  --asset dist/binary-darwin
```
