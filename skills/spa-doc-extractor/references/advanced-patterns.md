# 高级提取模式和技巧

本文档介绍了使用 agent-browser 提取 SPA 文档的高级模式和最佳实践。

## 1. 处理认证和授权

### 基本认证

```bash
# 1. 登录并保存状态
agent-browser open https://example.com/login
agent-browser snapshot -i
agent-browser fill @email "user@example.com"
agent-browser fill @password "password"
agent-browser click @submit
agent-browser wait --url "**/dashboard"
agent-browser state save auth.json

# 2. 后续使用保存的状态
agent-browser state load auth.json
agent-browser open https://example.com/docs
agent-browser wait --load networkidle
agent-browser get text @main-content
```

### OAuth 2.0 认证

```bash
# 1. 打开登录页
agent-browser open https://example.com/login
agent-browser snapshot -i

# 2. 点击 OAuth 登录按钮
agent-browser click @oauth-button
agent-browser wait --url "**/oauth/*"

# 3. 在 OAuth 提供商页面登录
agent-browser fill @oauth-username "oauth-user"
agent-browser fill @oauth-password "oauth-pass"
agent-browser click @oauth-submit
agent-browser wait --url "**/dashboard"

# 4. 保存状态
agent-browser state save oauth-auth.json
```

### 会话持久化

```bash
# 使用固定会话名称
agent-browser --session docs-session open https://example.com/docs
agent-browser wait --load networkidle

# 后续操作使用同一会话
agent-browser --session docs-session open https://example.com/docs/advanced
```

## 2. 处理动态内容

### 无限滚动

```bash
agent-browser open https://example.com/docs
agent-browser wait --load networkidle

# 滚动到底部多次
for i in {1..10}; do
    agent-browser scroll down 10000
    agent-browser wait 1000
done

# 提取所有内容
agent-browser get text @content > all-content.md
```

### 懒加载内容

```bash
agent-browser open https://example.com/docs
agent-browser wait --load networkidle

# 等待懒加载内容出现
agent-browser wait --text "加载更多"

# 点击加载更多按钮
while agent-browser is visible @load-more; do
    agent-browser click @load-more
    agent-browser wait --load networkidle
    agent-browser wait 500
done

# 提取所有内容
agent-browser get text @content > full-content.md
```

### 动画等待

```bash
agent-browser open https://example.com/docs
agent-browser wait --load networkidle

# 等待动画完成
agent-browser wait 2000

# 或者等待元素稳定
agent-browser eval "
    const element = document.querySelector('.animated-content');
    const style = window.getComputedStyle(element);
    return style.animationName === 'none';
"
```

## 3. 错误处理和重试

### 基本重试逻辑

```bash
MAX_RETRIES=3
RETRY_COUNT=0

while [[ $RETRY_COUNT -lt $MAX_RETRIES ]]; do
    agent-browser open https://example.com/docs
    agent-browser wait --load networkidle
    
    # 检查页面是否正常加载
    if agent-browser get text @content | grep -q "文档内容"; then
        echo "✅ 页面加载成功"
        break
    else
        echo "❌ 页面加载失败，重试中..."
        RETRY_COUNT=$((RETRY_COUNT + 1))
        agent-browser reload
        agent-browser wait 2000
    fi
done

if [[ $RETRY_COUNT -eq $MAX_RETRIES ]]; then
    echo "❌ 达到最大重试次数，放弃"
    exit 1
fi
```

### 超时处理

```bash
TIMEOUT=30000
START_TIME=$(date +%s%N)

agent-browser open https://example.com/docs

while true; do
    CURRENT_TIME=$(date +%s%N)
    ELAPSED=$(( (CURRENT_TIME - START_TIME) / 1000000 ))
    
    if [[ $ELAPSED -gt $TIMEOUT ]]; then
        echo "❌ 超时: $ELAPSED ms"
        exit 1
    fi
    
    if agent-browser is visible @content; then
        echo "✅ 内容加载完成"
        break
    fi
    
    agent-browser wait 500
done
```

### 错误日志记录

```bash
LOG_FILE="extraction-errors.log"

function log_error {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: $1" >> "$LOG_FILE"
}

agent-browser open https://example.com/docs || {
    log_error "Failed to open URL"
    exit 1
}

agent-browser wait --load networkidle || {
    log_error "Network idle timeout"
    exit 1
}

agent-browser snapshot -i || {
    log_error "Failed to take snapshot"
    exit 1
}
```

## 4. 性能优化

### 并发提取（使用多个会话）

```bash
# 启动多个并发提取
agent-browser --session session1 open https://example.com/docs/page1 &
PID1=$!

agent-browser --session session2 open https://example.com/docs/page2 &
PID2=$!

agent-browser --session session3 open https://example.com/docs/page3 &
PID3=$!

# 等待所有进程完成
wait $PID1 $PID2 $PID3
```

### 批量操作优化

```bash
# 预加载所有链接
LINKS=$(agent-browser eval "
    Array.from(document.querySelectorAll('.sidebar a'))
        .map(a => a.href)
        .join('\n')
")

# 批量处理
echo "$LINKS" | while read -r url; do
    {
        agent-browser open "$url"
        agent-browser wait --load networkidle
        agent-browser get text @content > "docs/$(basename "$url").md"
    } &
    
    # 限制并发数
    if (( $(jobs -r | wc -l) >= 3 )); then
        wait -n
    fi
done

wait
```

### 内存管理

```bash
# 定期清理浏览器状态
MAX_PAGES=100
PAGE_COUNT=0

while IFS= read -r url; do
    agent-browser open "$url"
    agent-browser wait --load networkidle
    agent-browser get text @content > "docs/page${PAGE_COUNT}.md"
    
    PAGE_COUNT=$((PAGE_COUNT + 1))
    
    # 每提取 100 页重启浏览器
    if (( PAGE_COUNT % MAX_PAGES == 0 )); then
        echo "🔄 重启浏览器..."
        agent-browser close
        sleep 2000
    fi
done < links.txt
```

## 5. 数据清洗和处理

### 提取后处理

```bash
# 提取原始内容
agent-browser get text @content > raw.txt

# 清理内容
sed 's/\[edit\]//g' raw.txt | \
sed '/^$/d' | \
sed 's/^[[:space:]]*//' | \
fold -w 80 -s > clean.txt
```

### JSON 数据提取

```bash
# 提取结构化数据
agent-browser eval "
(() => {
    const sections = [];
    document.querySelectorAll('h2').forEach(h2 => {
        const content = [];
        let current = h2.nextElementSibling;
        while (current && current.tagName !== 'H2') {
            if (current.textContent.trim()) {
                content.push(current.textContent.trim());
            }
            current = current.nextElementSibling;
        }
        sections.push({
            title: h2.textContent.trim(),
            content: content.join('\n')
        });
    });
    return JSON.stringify(sections, null, 2);
})()
" > structured-data.json
```

### Markdown 转换

```bash
# 提取内容并转换为 Markdown
agent-browser get html @content | \
pandoc -f html -t markdown -o output.md
```

## 6. 高级导航模式

### 面包屑导航

```bash
# 提取面包屑路径
BREADCRUMBS=$(agent-browser eval "
    Array.from(document.querySelectorAll('.breadcrumb a'))
        .map(a => a.textContent.trim())
        .join(' > ')
")

echo "📍 导航路径: $BREADCRUMBS"
```

### 侧边栏导航树

```bash
# 提取完整的导航树结构
agent-browser eval "
(() => {
    function buildTree(element) {
        const items = [];
        element.children.forEach(child => {
            const link = child.querySelector('a');
            if (link) {
                const item = {
                    title: link.textContent.trim(),
                    href: link.href,
                    children: []
                };
                const subMenu = child.querySelector('.submenu');
                if (subMenu) {
                    item.children = buildTree(subMenu);
                }
                items.push(item);
            }
        });
        return items;
    }
    return JSON.stringify(buildTree(document.querySelector('.sidebar')), null, 2);
})()
" > navigation-tree.json
```

### 标签页导航

```bash
# 在多个标签页中提取
agent-browser tab new https://example.com/docs/page1
agent-browser tab new https://example.com/docs/page2
agent-browser tab new https://example.com/docs/page3

# 切换标签页并提取
for i in 1 2 3; do
    agent-browser tab $i
    agent-browser wait --load networkidle
    agent-browser get text @content > "docs/page${i}.md"
done

# 关闭所有标签页
agent-browser tab close 2
agent-browser tab close 1
```

## 7. 高级调试技巧

### 网络请求监控

```bash
# 监控网络请求
agent-browser open https://example.com/docs

# 执行操作...
agent-browser click @load-more

# 查看网络请求
agent-browser network requests --filter api
```

### 性能分析

```bash
# 记录性能追踪
agent-browser trace start

# 执行操作...
agent-browser open https://example.com/docs
agent-browser wait --load networkidle

# 停止追踪
agent-browser trace stop performance.zip

# 分析追踪文件
# 使用 Chrome DevTools 打开 performance.zip
```

### 控制台日志捕获

```bash
# 捕获控制台日志
agent-browser open https://example.com/docs

# 执行操作...

# 查看控制台消息
agent-browser console

# 清空控制台
agent-browser console --clear
```

## 8. 自定义代理和 Headers

### 使用代理

```bash
# HTTP 代理
agent-browser --proxy http://proxy.com:8080 open https://example.com/docs

# SOCKS5 代理
agent-browser --proxy socks5://proxy.com:1080 open https://example.com/docs

# 带认证的代理
agent-browser --proxy http://user:pass@proxy.com:8080 open https://example.com/docs
```

### 自定义 Headers

```bash
# 添加自定义 Headers
agent-browser --headers '{"Authorization":"Bearer token"}' open https://example.com/docs

# 或者使用 JSON 文件
echo '{"User-Agent":"Custom-Agent","Accept":"application/json"}' > headers.json
agent-browser --headers "$(cat headers.json)" open https://example.com/docs
```

## 9. 视频录制和演示

### 完整工作流录制

```bash
# 开始录制
agent-browser record start ./workflow-demo.webm

# 执行工作流
agent-browser open https://example.com/docs
agent-browser wait --load networkidle
agent-browser snapshot -i
agent-browser find text "快速开始" click
agent-browser wait --load networkidle
agent-browser get text @main-content

# 停止录制
agent-browser record stop
```

### 截图对比

```bash
# 提取前截图
agent-browser open https://example.com/docs
agent-browser wait --load networkidle
agent-browser screenshot before.png

# 执行操作...
agent-browser click @refresh-button
agent-browser wait --load networkidle

# 提取后截图
agent-browser screenshot after.png

# 对比差异
diff before.png after.png || echo "页面发生变化"
```

## 10. 完整示例：生产级提取脚本

```bash
#!/bin/bash

# 生产级文档提取脚本
# 功能：并发提取、错误重试、进度跟踪、日志记录

set -e

# 配置
URL="https://example.com/docs"
OUTPUT_DIR="./extracted-docs"
MAX_RETRIES=3
DELAY=1000
CONCURRENT=3
LOG_FILE="extraction.log"

# 初始化
mkdir -p "$OUTPUT_DIR"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] 开始提取" | tee -a "$LOG_FILE"

# 提取函数
extract_page() {
    local url=$1
    local output=$2
    local retry=0
    
    while [[ $retry -lt $MAX_RETRIES ]]; do
        if agent-browser open "$url" && \
           agent-browser wait --load networkidle && \
           agent-browser snapshot -i && \
           agent-browser get text @content > "$output"; then
            echo "✅ 提取成功: $(basename "$output")"
            return 0
        else
            echo "❌ 提取失败，重试 $((retry + 1))/$MAX_RETRIES"
            retry=$((retry + 1))
            sleep $((DELAY / 1000))
        fi
    done
    
    echo "❌ 最终失败: $url" | tee -a "$LOG_FILE"
    return 1
}

# 获取所有链接
echo "🔗 获取文档链接..."
agent-browser open "$URL"
agent-browser wait --load networkidle

LINKS=$(agent-browser eval "
    Array.from(document.querySelectorAll('.sidebar a'))
        .map(a => a.href)
        .join('\n')
")

LINK_COUNT=$(echo "$LINKS" | wc -l)
echo "📊 发现 $LINK_COUNT 个页面"

# 并发提取
echo "🚀 开始并发提取（并发数: $CONCURRENT）..."
SUCCESS=0
FAILED=0

while IFS= read -r url; do
    filename="docs/$(basename "$url").md"
    
    extract_page "$url" "$OUTPUT_DIR/$filename" &
    
    # 限制并发数
    if (( $(jobs -r | wc -l) >= CONCURRENT )); then
        wait -n
    fi
    
    sleep $((DELAY / 1000))
done < <(echo "$LINKS")

# 等待所有任务完成
wait

echo ""
echo "✅ 提取完成"
echo "📁 输出目录: $OUTPUT_DIR"
echo "📝 日志文件: $LOG_FILE"
```

## 最佳实践总结

1. **始终使用 `wait --load networkidle`** 等待 SPA 完全加载
2. **定期保存浏览器状态** 以便恢复和调试
3. **实现错误重试机制** 提高提取可靠性
4. **添加适当的延迟** 避免被网站封禁
5. **使用日志记录** 便于问题排查
6. **考虑并发提取** 提高大规模提取效率
7. **定期清理浏览器状态** 防止内存泄漏
8. **使用代理和 Headers** 绕过反爬虫机制
9. **录制操作视频** 便于演示和调试
10. **验证提取结果** 确保数据完整性