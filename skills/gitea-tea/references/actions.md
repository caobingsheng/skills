# Actions 命令参考

管理 Gitea Actions CI/CD 工作流、密钥和变量。

## Secrets（密钥）

```bash
# 列出密钥
tea actions secrets list [--repo <owner/repo>]

# 创建密钥
tea actions secrets create <NAME> <value>
tea actions secrets create <NAME> --file <file>
echo "value" | tea actions secrets create <NAME> --stdin

# 删除密钥
tea actions secrets delete <NAME>
```

**示例**：
```bash
tea actions secrets create DOCKER_USERNAME "myuser"
tea actions secrets create DOCKER_PASSWORD --file password.txt
tea actions secrets create API_KEY "$(cat api-key.txt)"
```

## Variables（变量）

```bash
# 列出变量
tea actions variables list [--repo <owner/repo>]

# 设置变量
tea actions variables set <NAME> <value>
tea actions variables set <NAME> --file <file>
echo "value" | tea actions variables set <NAME> --stdin

# 删除变量
tea actions variables delete <NAME>
```

**示例**：
```bash
tea actions variables set DEPLOY_ENV "production"
tea actions variables set BUILD_VERSION "1.0.0"
tea actions variables set CONFIG --file config.json
```

## Workflow Runs（工作流运行）

```bash
# 列出运行
tea actions runs list [--repo <owner/repo>]

# 查看详情
tea actions runs view <run-id>

# 重新运行
tea actions runs rerun <run-id>

# 取消运行
tea actions runs cancel <run-id>

# 查看日志
tea actions runs logs <run-id>
```

## Workflows（工作流）

```bash
# 列出工作流
tea actions workflows list [--repo <owner/repo>]

# 查看详情
tea actions workflows view <workflow-id>
```

## 工作流程

```bash
# 设置 CI/CD 密钥
tea actions secrets create DOCKER_USERNAME "myuser"
tea actions secrets create DOCKER_PASSWORD "mypass"

# 设置环境变量
tea actions variables set DEPLOY_ENV "production"
tea actions variables set REGISTRY "registry.example.com"

# 查看运行状态
tea actions runs list --repo owner/repo
tea actions runs logs <run-id>
```
