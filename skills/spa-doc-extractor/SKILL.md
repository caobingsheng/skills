---
name: spa-doc-extractor
description: 自动化提取单页应用（SPA）技术文档内容的工具。使用agent-browser进行浏览器自动化，支持动态内容加载、多页面爬取、结构化数据提取和截图保存。适用于需要从Vue/React/Angular等框架构建的文档网站（如官方文档、API文档、技术教程）提取内容的场景。
---

# SPA 文档提取器

## 概述

使用 agent-browser 自动化从 SPA（单页应用）网站提取技术文档内容，支持处理动态加载内容、导航多个页面、提取结构化数据和保存截图。

## 快速开始

```bash
# 1. 打开文档网站并等待加载
agent-browser open https://example.com/docs
agent-browser wait --load networkidle

# 2. 获取页面结构
agent-browser snapshot -i

# 3. 提取内容
agent-browser get text @main-content > output.md

# 4. 截图（可选）
agent-browser screenshot --full output.png
```

## 核心工作流

### 1. 单页面提取

适用于提取单个文档页面的内容。

```bash
# 打开页面
agent-browser open https://example.com/docs/introduction
agent-browser wait --load networkidle

# 获取元素引用
agent-browser snapshot -i

# 提取文本内容
agent-browser get text @main-content > docs/introduction.md

# 保存截图
agent-browser screenshot --full docs/introduction.png
```

### 2. 多页面批量提取

适用于爬取整个文档网站。

使用脚本：`scripts/batch-extract.sh`

```bash
./scripts/batch-extract.sh https://example.com/docs ./output
```

### 3. 结构化数据提取

使用 JavaScript 提取文档结构。

```bash
agent-browser open https://example.com/docs
agent-browser wait --load networkidle

# 提取所有章节标题和链接
agent-browser eval "
Array.from(document.querySelectorAll('nav a')).map(a => ({
    title: a.textContent.trim(),
    href: a.href
}))
" > structure.json
```

## 常见场景

### 场景1：快速提取单页文档（推荐）

最简单的方式，直接提取并保存为Markdown：

```bash
# 打开页面并等待加载
npx agent-browser open https://element.eleme.cn/#/zh-CN/component/quickstart
npx agent-browser wait --load networkidle

# 直接提取文本内容
npx agent-browser get text .page-component__content > element-quickstart.md
```

**关键点**：
- 使用 `npx agent-browser` 确保使用最新版本
- `wait --load networkidle` 等待所有网络请求完成
- 直接使用CSS选择器提取内容区域
- 输出重定向到 `.md` 文件

### 场景2：提取完整文档

```bash
# 使用批量提取脚本
./scripts/batch-extract.sh \
  --url https://example.com/docs \
  --output ./extracted-docs \
  --selector ".sidebar a" \
  --content-selector "main"
```

### 场景3：提取特定章节

```bash
agent-browser open https://example.com/docs
agent-browser wait --load networkidle
agent-browser snapshot -i

# 点击侧边栏导航到特定章节
agent-browser find text "快速开始" click
agent-browser wait --load networkidle

# 提取内容
agent-browser get text @main-content > quick-start.md
```

### 场景4：带认证的文档提取

```bash
# 登录并保存状态
agent-browser open https://app.example.com/login
agent-browser snapshot -i
agent-browser fill @email "user@example.com"
agent-browser fill @password "password"
agent-browser click @submit
agent-browser wait --url "**/dashboard"
agent-browser state save auth.json

# 后续使用保存的状态
agent-browser state load auth.json
agent-browser open https://app.example.com/docs
agent-browser wait --load networkidle
agent-browser get text @main-content > docs.md
```

### 场景5：Element UI 文档提取实战

完整示例：提取 Element UI 快速开始文档

```bash
# 1. 打开页面
npx agent-browser open https://element.eleme.cn/#/zh-CN/component/quickstart

# 2. 等待页面完全加载（重要！）
npx agent-browser wait --load networkidle

# 3. 提取内容（Element UI 使用 .page-component__content 作为主容器）
npx agent-browser get text .page-component__content > element-quickstart-raw.md

# 4. 手动格式化（如果需要）
# 将纯文本转换为结构化的 Markdown，添加标题层级、代码块等
```

## 关键技巧

### 处理动态加载内容

SPA 必须等待内容完全加载：

```bash
# 等待网络空闲（推荐）
agent-browser wait --load networkidle

# 等待特定文本出现
agent-browser wait --text "文档已加载"

# 等待特定元素出现
agent-browser wait @content-area

# 等待 URL 匹配模式
agent-browser wait --url "**/docs/*"
```

### 更新元素引用

页面变化后必须重新快照：

```bash
# 页面1
agent-browser open page1.html
agent-browser snapshot -i
agent-browser click @next-page

# 必须重新快照获取新引用
agent-browser wait --load networkidle
agent-browser snapshot -i
agent-browser get text @main-content  # 使用新的引用
```

### 处理分页

```bash
while true; do
    # 提取当前页
    agent-browser get text @content > "page$page.md"
    
    # 检查是否有下一页
    if ! agent-browser is visible @next-button; then
        break
    fi
    
    # 点击下一页
    agent-browser click @next-button
    agent-browser wait --load networkidle
    agent-browser snapshot -i
    
    page=$((page + 1))
done
```

## 调试和故障排除

### 显示浏览器窗口

```bash
agent-browser --headed open https://example.com/docs
```

### 查看页面错误

```bash
agent-browser errors
```

### 检查元素状态

```bash
agent-browser is visible @element
agent-browser is enabled @element
```

### 高亮元素

```bash
agent-browser highlight @element
```

## 高级功能

### 自定义提取脚本

参见 `scripts/` 目录中的示例脚本：

- `batch-extract.sh` - 批量提取多个页面
- `single-page-extract.sh` - 单页面提取模板
- `structured-extract.sh` - 结构化数据提取

### 选择器指南

常见的内容选择器：

| 网站类型 | 主内容选择器 | 侧边栏选择器 | 示例网站 |
|---------|------------|------------|----------|
| VuePress | `.theme-default-content` | `.sidebar` | Vue.js 官方文档 |
| VitePress | `.VPDoc` | `.VPDocAside` | Vite 官方文档 |
| Docusaurus | `article` | `.sidebar` | React 官方文档 |
| GitBook | `.page-content` | `.summary` | 各种 GitBook 文档 |
| Element UI | `.page-component__content` | `.nav-component` | element.eleme.cn |
| Ant Design | `.markdown` | `.aside-container` | ant.design |
| Vue Router | `.content` | `.sidebar` | router.vuejs.org |
| Vuex | `.content` | `.sidebar` | vuex.vuejs.org |
| 通用 | `main`, `article`, `#content` | `.nav`, `.sidebar`, `[role="navigation"]` | - |

**中文技术文档常见选择器**：

```bash
# Element UI / Element Plus
.page-component__content

# Ant Design / Ant Design Vue
.markdown, .markdown-api

# Vue 生态系统
.content, .theme-default-content

# 通用中文文档
main, article, .doc-content, .page-content
```

**如何找到正确的选择器**：

```bash
# 1. 打开页面并快照
npx agent-browser open https://example.com/docs
npx agent-browser wait --load networkidle
npx agent-browser snapshot -i

# 2. 在浏览器开发者工具中检查元素
# 右键点击主内容区域 -> 检查 -> 查看容器的 class 或 id

# 3. 测试选择器是否正确
npx agent-browser eval "document.querySelector('.your-selector').textContent"
```

### 性能优化

```bash
# 使用状态保存加速重复访问
agent-browser state save session.json

# 添加延迟避免被限速
agent-browser wait 1000

# 使用 JSON 输出解析结果
agent-browser get text @content --json | jq -r '.content' > output.txt
```

## 格式化和后处理

### 提取后的格式化

直接提取的文本通常是纯文本，需要手动或自动格式化：

**方法1：手动格式化（推荐用于重要文档）**

```bash
# 提取原始文本
npx agent-browser get text .page-component__content > raw.md

# 使用编辑器手动格式化：
# 1. 添加标题层级（#, ##, ###）
# 2. 将代码块包裹在 ``` 中
# 3. 调整列表格式
# 4. 添加适当的空行
```

**方法2：使用脚本自动格式化**

创建格式化脚本 `format-doc.js`：

```javascript
// 简单的 Markdown 格式化脚本
const fs = require('fs');
const content = fs.readFileSync('raw.md', 'utf8');

// 1. 识别标题（全大写或特殊格式的行）
let formatted = content.replace(/^([A-Z\s]{10,})$/gm, '\n## $1\n');

// 2. 识别代码块（缩进或特殊标记）
formatted = formatted.replace(/    (.+)/g, '    $1');

// 3. 修复列表格式
formatted = formatted.replace(/^(\d+)\.\s+/gm, '$1. ');

fs.writeFileSync('formatted.md', formatted);
```

**方法3：使用 AI 辅助格式化**

```bash
# 提取后让 AI 帮助格式化
npx agent-browser get text .page-component__content > raw.md

# 使用 AI 工具（如 ChatGPT, Claude）进行格式化
# 提示词：请将以下文本格式化为标准的 Markdown 文档，包括标题层级、代码块、列表等
```

### 常见格式问题及解决方案

| 问题 | 原因 | 解决方案 |
|------|------|----------|
| 标题丢失 | 选择器未包含标题层级 | 使用更精确的选择器或手动添加 |
| 代码块未格式化 | 纯文本提取丢失格式 | 手动添加 ``` 包裹 |
| 列表混乱 | 嵌套列表缩进问题 | 调整缩进或使用 Markdown 列表语法 |
| 空行过多 | 多个连续空行 | 使用正则替换：`\n{3,}` → `\n\n` |
| 特殊字符丢失 | HTML 实体未解码 | 手动替换或使用解码工具 |

### 格式化最佳实践

```bash
# 完整工作流
npx agent-browser open https://example.com/docs
npx agent-browser wait --load networkidle
npx agent-browser get text .content > docs-raw.md

# 使用 sed/awk 进行简单格式化
# 1. 删除多余空行
sed -i '' '/^$/N;/^\n$/D' docs-raw.md

# 2. 添加标题标记
sed -i '' 's/^第一章/# 第一章/' docs-raw.md

# 3. 识别代码块（假设代码以 4 个空格开头）
sed -i '' 's/^    /```javascript\n&/' docs-raw.md
```

## 实战案例

### 案例1：Element UI 快速开始文档

**目标**：提取 https://element.eleme.cn/#/zh-CN/component/quickstart

**步骤**：

```bash
# 1. 打开页面
npx agent-browser open https://element.eleme.cn/#/zh-CN/component/quickstart

# 2. 等待页面完全加载
npx agent-browser wait --load networkidle

# 3. 提取内容
npx agent-browser get text .page-component__content > element-quickstart-raw.md

# 4. 手动格式化（添加标题层级、代码块等）
# 最终输出：element-ui-quickstart.md
```

**关键发现**：
- Element UI 使用 `.page-component__content` 作为主内容容器
- 必须使用 `wait --load networkidle` 等待所有内容加载
- 提取的文本包含所有内容，但需要手动格式化

**输出示例**：

```markdown
# Element UI 快速上手

本节将介绍如何在项目中使用 Element。

## 使用 vue-cli@3

我们为新版的 vue-cli 准备了相应的 Element 插件...

## 引入 Element

### 完整引入

在 main.js 中写入以下内容：

```javascript
import Vue from 'vue';
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
```
```

### 案例2：Vue Router 官方文档

```bash
# 打开 Vue Router 指南
npx agent-browser open https://router.vuejs.org/zh/guide/
npx agent-browser wait --load networkidle

# VuePress 使用 .theme-default-content
npx agent-browser get text .theme-default-content > vue-router-guide.md
```

### 案例3：Ant Design Vue 文档

```bash
# 打开 Ant Design Vue 快速开始
npx agent-browser open https://antdv.com/docs/vue/getting-started-cn/
npx agent-browser wait --load networkidle

# Ant Design 使用 .markdown
npx agent-browser get text .markdown > ant-design-vue-quickstart.md
```

### 案例4：批量提取多个页面

```bash
#!/bin/bash
# 批量提取 Element UI 组件文档

components=("button" "input" "select" "form" "table")

for comp in "${components[@]}"; do
  echo "提取 $comp 组件文档..."
  npx agent-browser open "https://element.eleme.cn/#/zh-CN/component/$comp"
  npx agent-browser wait --load networkidle
  npx agent-browser get text .page-component__content > "docs/element-$comp.md"
  sleep 2  # 避免请求过快
done

echo "提取完成！"
```

## 注意事项

1. **遵守 robots.txt** - 检查网站的爬取规则
2. **添加延迟** - 避免因请求过快被封禁
3. **错误处理** - 检查元素是否存在再操作
4. **引用更新** - 页面变化后重新快照
5. **网络等待** - SPA 必须使用 `wait --load networkidle`
6. **中文编码** - 确保输出文件使用 UTF-8 编码
7. **版权声明** - 提取的文档应保留原始版权信息

## 资源

### scripts/
- `batch-extract.sh` - 批量提取多个文档页面
- `single-page-extract.sh` - 单页面提取脚本
- `structured-extract.sh` - 结构化数据提取脚本

### references/
- `selectors-guide.md` - 常见文档网站选择器指南
- `advanced-patterns.md` - 高级提取模式和技巧

## 故障排除

### 内容为空
- 确保使用了 `wait --load networkidle`
- 检查选择器是否正确
- 使用 `--headed` 模式查看实际渲染

### 元素未找到
- 重新运行 `snapshot -i` 更新引用
- 检查页面是否完全加载
- 使用不同的选择器策略

### 被网站封禁
- 添加请求延迟
- 使用代理：`agent-browser --proxy http://proxy.com:8080`
- 降低请求频率

### 中文乱码
- 确保终端使用 UTF-8 编码：`export LANG=zh_CN.UTF-8`
- 检查输出文件编码：`file -I output.md`
- 转换编码：`iconv -f GBK -t UTF-8 input.md > output.md`

## 快速参考

### 常用命令速查

```bash
# 基础流程
npx agent-browser open <URL>                    # 打开页面
npx agent-browser wait --load networkidle       # 等待加载
npx agent-browser get text <selector> > file.md # 提取内容

# 调试命令
npx agent-browser --headed open <URL>           # 显示浏览器窗口
npx agent-browser snapshot -i                   # 获取元素引用
npx agent-browser screenshot --full file.png    # 截图

# 状态管理
npx agent-browser state save session.json       # 保存状态
npx agent-browser state load session.json       # 加载状态
```

### 常见文档网站选择器速查

```bash
# Vue 生态系统
VuePress:        .theme-default-content
VitePress:       .VPDoc
Vue Router:      .content
Vuex:            .content

# UI 组件库
Element UI:      .page-component__content
Ant Design:      .markdown
Ant Design Vue:  .markdown
Element Plus:    .content

# 通用选择器
main, article, .content, .doc-content, .page-content
```

### 完整工作流模板

```bash
#!/bin/bash
# SPA 文档提取模板

URL="https://example.com/docs"
SELECTOR=".content"
OUTPUT="output.md"

# 1. 打开页面
npx agent-browser open "$URL"

# 2. 等待加载
npx agent-browser wait --load networkidle

# 3. 提取内容
npx agent-browser get text "$SELECTOR" > "$OUTPUT"

# 4. 清理和格式化
# 删除多余空行
sed -i '' '/^$/N;/^\n$/D' "$OUTPUT"

echo "文档已提取到: $OUTPUT"
```

## 最佳实践总结

1. **始终使用 `npx agent-browser`** - 确保使用最新版本
2. **必须等待网络空闲** - `wait --load networkidle` 是关键
3. **先测试选择器** - 使用浏览器开发者工具验证
4. **批量提取添加延迟** - 避免被封禁
5. **保留原始版权** - 尊重原作者权益
6. **手动格式化重要文档** - 确保质量
7. **使用脚本自动化** - 提高效率