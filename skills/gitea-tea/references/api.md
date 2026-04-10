# API 命令参考

> ⚠️ **分页限制**：所有列表端点默认最大每页 50 条，`limit` 参数超过 50 会被静默截断。详见 [pagination.md](pagination.md)。

直接调用 Gitea API，用于高级操作和自定义集成。

## API 文档资源

**Swagger 文档**：`swagger.v1.json` - 包含所有可用 API 端点的完整规范

**搜索 Swagger 文档**：
```bash
# 搜索特定端点
grep -i "issues" swagger.v1.json

# 搜索特定标签（API 分类）
grep -i '"tags"' swagger.v1.json

# 搜索路径模式
grep -i '"/repos/{owner}/{repo}' swagger.v1.json
```

## API 端点分类

### 用户相关
| 端点 | 方法 | 说明 |
|------|------|------|
| `/user` | GET | 获取当前用户信息 |
| `/user/repos` | GET | 列出用户仓库 |
| `/user/followers` | GET | 列出关注者 |
| `/user/following` | GET | 列出关注的人 |
| `/user/starred` | GET | 列出星标仓库 |
| `/users/{username}` | GET | 获取指定用户信息 |

### 仓库相关
| 端点 | 方法 | 说明 |
|------|------|------|
| `/repos/{owner}/{repo}` | GET | 获取仓库信息 |
| `/repos/{owner}/{repo}` | PATCH | 更新仓库 |
| `/repos/{owner}/{repo}` | DELETE | 删除仓库 |
| `/repos/{owner}/{repo}/branches` | GET | 列出分支 |
| `/repos/{owner}/{repo}/collaborators` | GET | 列出协作者 |
| `/repos/{owner}/{repo}/contents/{filepath}` | GET | 获取文件内容 |
| `/repos/{owner}/{repo}/forks` | POST | Fork 仓库 |
| `/repos/search` | GET | 搜索仓库 |

### Issues 相关
| 端点 | 方法 | 说明 |
|------|------|------|
| `/repos/{owner}/{repo}/issues` | GET | 列出 issues |
| `/repos/{owner}/{repo}/issues` | POST | 创建 issue |
| `/repos/{owner}/{repo}/issues/{index}` | GET | 获取 issue |
| `/repos/{owner}/{repo}/issues/{index}` | PATCH | 更新 issue |
| `/repos/{owner}/{repo}/issues/{index}/comments` | GET | 列出评论 |
| `/repos/{owner}/{repo}/issues/{index}/comments` | POST | 添加评论 |
| `/repos/issues/search` | GET | 搜索 issues |

### Pull Requests 相关
| 端点 | 方法 | 说明 |
|------|------|------|
| `/repos/{owner}/{repo}/pulls` | GET | 列出 PRs |
| `/repos/{owner}/{repo}/pulls` | POST | 创建 PR |
| `/repos/{owner}/{repo}/pulls/{index}` | GET | 获取 PR |
| `/repos/{owner}/{repo}/pulls/{index}` | PATCH | 更新 PR |
| `/repos/{owner}/{repo}/pulls/{index}/merge` | POST | 合并 PR |
| `/repos/{owner}/{repo}/pulls/{index}/reviews` | GET | 列出审查 |

### Releases 相关
| 端点 | 方法 | 说明 |
|------|------|------|
| `/repos/{owner}/{repo}/releases` | GET | 列出 releases |
| `/repos/{owner}/{repo}/releases` | POST | 创建 release |
| `/repos/{owner}/{repo}/releases/{id}` | GET | 获取 release |
| `/repos/{owner}/{repo}/releases/{id}` | PATCH | 更新 release |
| `/repos/{owner}/{repo}/releases/{id}` | DELETE | 删除 release |
| `/repos/{owner}/{repo}/releases/{id}/assets` | GET | 列出资源 |

### 组织相关
| 端点 | 方法 | 说明 |
|------|------|------|
| `/orgs/{org}` | GET | 获取组织信息 |
| `/orgs/{org}` | PATCH | 更新组织 |
| `/orgs/{org}/members` | GET | 列出成员 |
| `/orgs/{org}/repos` | GET | 列出组织仓库 |
| `/orgs/{org}/teams` | GET | 列出团队 |
| `/orgs` | POST | 创建组织 |

### Webhooks 相关
| 端点 | 方法 | 说明 |
|------|------|------|
| `/repos/{owner}/{repo}/hooks` | GET | 列出 webhooks |
| `/repos/{owner}/{repo}/hooks` | POST | 创建 webhook |
| `/repos/{owner}/{repo}/hooks/{id}` | GET | 获取 webhook |
| `/repos/{owner}/{repo}/hooks/{id}` | PATCH | 更新 webhook |
| `/repos/{owner}/{repo}/hooks/{id}` | DELETE | 删除 webhook |
| `/repos/{owner}/{repo}/hooks/{id}/tests` | POST | 测试 webhook |

### Actions 相关
| 端点 | 方法 | 说明 |
|------|------|------|
| `/repos/{owner}/{repo}/actions/secrets` | GET | 列出密钥 |
| `/repos/{owner}/{repo}/actions/secrets/{secretname}` | PUT | 创建/更新密钥 |
| `/repos/{owner}/{repo}/actions/secrets/{secretname}` | DELETE | 删除密钥 |
| `/repos/{owner}/{repo}/actions/variables` | GET | 列出变量 |
| `/repos/{owner}/{repo}/actions/variables/{variablename}` | PUT | 创建/更新变量 |
| `/repos/{owner}/{repo}/actions/runs` | GET | 列出运行 |

### 通知相关
| 端点 | 方法 | 说明 |
|------|------|------|
| `/notifications` | GET | 列出通知 |
| `/notifications/threads/{id}` | GET | 获取通知详情 |
| `/notifications/threads/{id}` | PATCH | 标记为已读 |
| `/notifications/new` | GET | 检查新通知 |

### 管理员相关（需要管理员权限）
| 端点 | 方法 | 说明 |
|------|------|------|
| `/admin/users` | GET | 列出用户 |
| `/admin/users` | POST | 创建用户 |
| `/admin/users/{username}` | DELETE | 删除用户 |
| `/admin/orgs` | GET | 列出组织 |
| `/admin/hooks` | GET | 列出全局 webhooks |
| `/admin/cron` | GET | 列出定时任务 |
| `/admin/cron/{task}` | POST | 运行定时任务 |

## 基本语法

```bash
tea api <endpoint> [--options]
```

**端点格式**：
- 如果不以 `/api/` 或 `http(s)://` 开头，会自动添加 `/api/v1/` 前缀
- 支持占位符 `{owner}` 和 `{repo}`（从当前仓库上下文自动填充）

**示例**：
```bash
tea api /repos/{owner}/{repo}/issues
# 等同于：/api/v1/repos/actual-owner/actual-repo/issues

tea api /user
# 等同于：/api/v1/user
```

## 使用 Swagger 文档

**Swagger 文档位置**：`swagger.v1.json`

### 搜索 API 端点

**搜索特定功能**：
```bash
# 搜索所有 issue 相关端点
grep -n "issues" swagger.v1.json | head -20

# 搜索特定路径模式
grep -n '"/repos/{owner}/{repo}/issues' swagger.v1.json

# 搜索特定 HTTP 方法
grep -A 5 '"post"' swagger.v1.json | grep -B 2 -A 3 "issues"

# 搜索特定标签（API 分类）
grep -A 2 '"tags"' swagger.v1.json | grep "issues"
```

**查看端点详情**：
```bash
# 查看特定端点的完整定义
jq '.paths."/repos/{owner}/{repo}/issues".post' swagger.v1.json

# 查看所有可用端点
jq '.paths | keys' swagger.v1.json | head -50

# 查看特定端点的参数
jq '.paths."/repos/{owner}/{repo}/issues".post.parameters' swagger.v1.json
```

**在线文档**：
- Gitea 官方 API 文档：https://docs.gitea.io/en-us/api-usage/
- Swagger UI（如果 Gitea 实例启用）：`https://your-gitea-instance/api/swagger`

## HTTP 方法

```bash
# 默认 GET
tea api /repos/{owner}/{repo}/issues

# 指定方法
tea api /repos/{owner}/{repo}/issues \
  --method POST \
  -f title="New Issue" \
  -f body="Description"

# 支持的方法
--method GET     # 查询
--method POST    # 创建
--method PUT     # 更新（完整替换）
--method PATCH   # 更新（部分更新）
--method DELETE  # 删除
```

## 字段参数

### 字符串字段 (-f)

```bash
# 单个字段
tea api /repos/{owner}/{repo}/issues -f title="Bug Report"

# 多个字段
tea api /repos/{owner}/{repo}/issues \
  -f title="Bug" \
  -f body="Description" \
  -f state="open"
```

### 类型化字段 (-F)

支持类型：数字、布尔值、null、JSON 数组/对象

```bash
# 布尔值
tea api /repos/{owner}/{repo} -F private=true

# 数字
tea api /repos/{owner}/{repo}/issues -F milestone=5

# null 值（清除字段）
tea api /repos/{owner}/{repo}/issues/42 -X PATCH -F assignee=null

# JSON 数组
tea api /repos/{owner}/{repo}/issues -F labels="[1,2,3]"

# JSON 对象
tea api /repos/{owner}/{repo}/issues -F extra='{"key":"value"}'
```

### 从文件读取

```bash
# 从文件读取字段值
tea api /repos/{owner}/{repo}/issues -F body=@issue-body.txt

# 从 stdin 读取
cat issue-body.txt | tea api /repos/{owner}/{repo}/issues -F body=@-
```

## 原始 JSON 体

```bash
# 从文件发送 JSON
tea api /repos/{owner}/{repo}/issues \
  --method POST \
  --data @issue.json

# 从 stdin 发送
cat issue.json | tea api /repos/{owner}/{repo}/issues \
  --method POST \
  --data @-

# 内联 JSON
tea api /repos/{owner}/{repo}/issues \
  --method POST \
  --data '{"title":"Bug","body":"Description"}'
```

**注意**：`--data` 不能与 `-f` 或 `-F` 同时使用。

## 输出选项

```bash
# 保存到文件
tea api /repos/{owner}/{repo} --output repo.json

# 包含 HTTP 响应头（输出到 stderr）
tea api /repos/{owner}/{repo} --include

# 结合使用
tea api /repos/{owner}/{repo}/issues --include --output issues.json
```

## 自定义请求头

```bash
# 添加自定义头
tea api /user -H "Accept: application/json"

# 多个请求头
tea api /repos/{owner}/{repo}/issues \
  -H "Accept: application/json" \
  -H "X-Custom-Header: value"
```

## 高级示例

```bash
# 创建带标签的 issue
tea api /repos/{owner}/{repo}/issues \
  --method POST \
  -f title="Feature Request" \
  -f body="Description" \
  -F labels="[1,2]"

# 更新 issue（部分更新）
tea api /repos/{owner}/{repo}/issues/42 \
  --method PATCH \
  -f title="Updated Title" \
  -F assignee=null

# 查询带分页
tea api '/repos/{owner}/{repo}/issues?state=open&page=1&limit=50'

# 批量操作
for i in {1..10}; do
  tea api /repos/{owner}/{repo}/issues \
    --method POST \
    -f title="Issue $i" \
    -f body="Automated issue $i"
done
```

## 常用 API 示例

### 用户操作

```bash
# 获取当前用户信息
tea api /user

# 获取用户仓库列表
tea api /user/repos --output json

# 获取指定用户信息
tea api /users/username

# 检查是否关注某用户
tea api /user/following/username

# 关注用户
tea api /user/following/username --method PUT

# 取消关注
tea api /user/following/username --method DELETE
```

### 仓库操作

```bash
# 获取仓库信息
tea api /repos/{owner}/{repo}

# 更新仓库描述
tea api /repos/{owner}/{repo} \
  --method PATCH \
  -f description="New description"

# 列出分支
tea api /repos/{owner}/{repo}/branches

# 列出协作者
tea api /repos/{owner}/{repo}/collaborators

# 添加协作者
tea api /repos/{owner}/{repo}/collaborators/username \
  --method PUT \
  -F permission="write"

# 获取文件内容
tea api /repos/{owner}/{repo}/contents/README.md

# 创建文件
tea api /repos/{owner}/{repo}/contents/README.md \
  --method POST \
  -f message="Add README" \
  -f content="$(echo 'Base64 content' | base64)" \
  -f branch="main"
```

### Issue 操作

```bash
# 搜索 issues
tea api '/repos/issues/search?q=bug&state=open'

# 列出仓库 issues
tea api '/repos/{owner}/{repo}/issues?state=open&labels=bug'

# 创建 issue
tea api /repos/{owner}/{repo}/issues \
  --method POST \
  -f title="Bug report" \
  -f body="Description" \
  -f labels="bug,help wanted"

# 添加评论
tea api /repos/{owner}/{repo}/issues/42/comments \
  --method POST \
  -f body="Comment text"

# 关闭 issue
tea api /repos/{owner}/{repo}/issues/42 \
  --method PATCH \
  -f state="closed"

# 添加标签
tea api /repos/{owner}/{repo}/issues/42/labels \
  --method POST \
  -F labels='[1, 2, 3]'
```

### Pull Request 操作

```bash
# 列出 PRs
tea api '/repos/{owner}/{repo}/pulls?state=open'

# 创建 PR
tea api /repos/{owner}/{repo}/pulls \
  --method POST \
  -f title="Feature" \
  -f body="Description" \
  -f head="feature-branch" \
  -f base="main"

# 合并 PR
tea api /repos/{owner}/{repo}/pulls/20/merge \
  --method POST \
  -f Do="merge" \
  -f merge_title="Merge PR #20"

# 请求审查
tea api /repos/{owner}/{repo}/pulls/20/requested_reviewers \
  --method POST \
  -F reviewers='["username1", "username2"]'
```

### Release 操作

```bash
# 列出 releases
tea api /repos/{owner}/{repo}/releases

# 创建 release
tea api /repos/{owner}/{repo}/releases \
  --method POST \
  -f tag_name="v1.0.0" \
  -f name="Version 1.0.0" \
  -f body="Release notes" \
  -F draft=false \
  -F prerelease=false

# 更新 release
tea api /repos/{owner}/{repo}/releases/1 \
  --method PATCH \
  -f body="Updated notes"

# 上传资源
tea api /repos/{owner}/{repo}/releases/1/assets \
  --method POST \
  -f name="binary.tar.gz" \
  --data @binary.tar.gz
```

### Webhook 操作

```bash
# 列出 webhooks
tea api /repos/{owner}/{repo}/hooks

# 创建 webhook
tea api /repos/{owner}/{repo}/hooks \
  --method POST \
  -f type="gitea" \
  -f config='{"url":"https://example.com/webhook","content_type":"json"}' \
  -F events='["push", "pull_request"]' \
  -F active=true

# 测试 webhook
tea api /repos/{owner}/{repo}/hooks/1/tests --method POST
```

### 组织操作

```bash
# 获取组织信息
tea api /orgs/myorg

# 列出组织成员
tea api /orgs/myorg/members

# 列出组织仓库
tea api /orgs/myorg/repos

# 创建组织
tea api /orgs \
  --method POST \
  -f username="neworg" \
  -f full_name="New Organization"
```

### Actions 操作

```bash
# 列出密钥
tea api /repos/{owner}/{repo}/actions/secrets

# 创建密钥
tea api /repos/{owner}/{repo}/actions/secrets/MY_SECRET \
  --method PUT \
  -f encrypted_value="encrypted-value-here" \
  -f key_id="key-id"

# 列出变量
tea api /repos/{owner}/{repo}/actions/variables

# 设置变量
tea api /repos/{owner}/{repo}/actions/variables/MY_VAR \
  --method PUT \
  -f value="variable-value"

# 列出运行
tea api /repos/{owner}/{repo}/actions/runs
```

## 分页和过滤

```bash
# 使用分页
tea api '/repos/{owner}/{repo}/issues?page=2&limit=50'

# 过滤结果
tea api '/repos/{owner}/{repo}/issues?state=closed&labels=bug&milestone=5'

# 排序
tea api '/repos/{owner}/{repo}/issues?sort=updated&order=desc'

# 时间范围
tea api '/repos/{owner}/{repo}/issues?since=2024-01-01T00:00:00Z'
```

## 错误处理

```bash
# 检查 API 响应
tea api /repos/{owner}/{repo} --include 2>&1 | grep "HTTP/"

# 查看错误详情
tea api /repos/nonexistent/repo 2>&1

# 使用 debug 模式
tea --debug api /repos/{owner}/{repo}
```

## 速率限制

```bash
# 检查速率限制
tea api /rate-limit --include 2>&1 | grep "X-RateLimit"

# 常见的速率限制响应头
# X-RateLimit-Limit: 请求限制
# X-RateLimit-Remaining: 剩余请求数
# X-RateLimit-Reset: 重置时间（Unix 时间戳）
```

## 最佳实践

1. **使用 --output 保存响应**：避免终端输出过长
2. **使用 --include 查看响应头**：调试时很有用
3. **使用 jq 处理 JSON**：`tea api /user | jq '.login'`
4. **批量操作时添加延迟**：避免触发速率限制
5. **使用环境变量存储敏感信息**：`-f token=$API_TOKEN`
6. **先测试再执行**：使用 dry-run 或先在测试仓库验证

## 常见问题

**Q: 如何获取 label ID？**
```bash
tea api /repos/{owner}/{repo}/labels | jq '.[] | {id, name}'
```

**Q: 如何获取 milestone ID？**
```bash
tea api /repos/{owner}/{repo}/milestones | jq '.[] | {id, title}'
```

**Q: 如何处理分页？**
```bash
# 获取所有页面的数据
page=1
while true; do
  result=$(tea api "/repos/{owner}/{repo}/issues?page=$page&limit=100")
  if [ -z "$result" ] || [ "$result" = "[]" ]; then
    break
  fi
  echo "$result" >> all-issues.json
  ((page++))
done
```

**Q: 如何上传文件？**
```bash
# 方法1：使用 base64 编码
content=$(base64 -w 0 file.txt)
tea api /repos/{owner}/{repo}/contents/file.txt \
  --method POST \
  -f message="Add file" \
  -f content="$content"

# 方法2：使用 --data
tea api /repos/{owner}/{repo}/releases/1/assets \
  --method POST \
  --data @file.txt
```
