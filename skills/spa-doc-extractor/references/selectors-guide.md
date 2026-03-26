# 常见文档网站选择器指南

本文档提供了常见技术文档网站的内容选择器和导航选择器。

## VuePress

### 默认主题
```
主内容选择器: .theme-default-content
侧边栏选择器: .sidebar
导航链接: .sidebar-link
标题: h1, h2, h3
```

### VitePress
```
主内容选择器: .VPDoc
侧边栏选择器: .VPDocAside
导航链接: .VPDocAside a
标题: .VPDoc h1, .VPDoc h2
```

## Docusaurus

```
主内容选择器: article
侧边栏选择器: .sidebar
导航链接: .sidebar a
标题: article h1, article h2
```

## GitBook

```
主内容选择器: .page-content
侧边栏选择器: .summary
导航链接: .summary a
标题: .page-content h1, .page-content h2
```

## MkDocs

```
主内容选择器: .md-content
侧边栏选择器: .md-nav
导航链接: .md-nav a
标题: .md-content h1, .md-content h2
```

## ReadTheDocs

```
主内容选择器: .wy-nav-content
侧边栏选择器: .wy-menu-vertical
导航链接: .wy-menu-vertical a
标题: .wy-nav-content h1, .wy-nav-content h2
```

## 通用选择器

当无法确定具体框架时，可以使用以下通用选择器：

### 主内容区域
```
推荐（按优先级）:
- main
- article
- [role="main"]
- .content
- #content
- .main-content
```

### 导航/侧边栏
```
推荐（按优先级）:
- nav
- .sidebar
- [role="navigation"]
- .nav
- .navigation
- aside
```

### 标题层级
```
所有标题: h1, h2, h3, h4, h5, h6
一级标题: h1
二级标题: h2
三级标题: h3
```

### 代码块
```
代码块: pre, code
行号: .line-numbers
语言标记: [class*="language-"]
```

### 表格
```
表格: table
表头: th
表格行: tr
表格单元格: td
```

## 查找选择器的方法

### 1. 使用浏览器开发者工具

```bash
# 使用 --headed 模式打开浏览器
agent-browser --headed open https://example.com/docs

# 在浏览器中：
# 1. 右键点击要提取的内容
# 2. 选择"检查"
# 3. 查看元素的类名和ID
# 4. 复制CSS选择器
```

### 2. 使用 agent-browser 快照

```bash
agent-browser open https://example.com/docs
agent-browser snapshot -i

# 查看输出，找到内容区域的引用（如 @e1, @e2）
# 使用这些引用进行操作
```

### 3. 使用 JavaScript 查询

```bash
agent-browser eval "
// 查找所有可能的容器
const containers = [
  document.querySelector('main'),
  document.querySelector('article'),
  document.querySelector('[role=\"main\"]'),
  document.querySelector('.content')
];

// 找到内容最多的容器
const content = containers.reduce((max, curr) => {
  return (curr && curr.textContent.length > max.textContent.length) ? curr : max;
}, { textContent: '' });

console.log('Best selector:', content.className || content.id || content.tagName);
"
```

## 常见问题

### Q: 内容选择器提取了太多内容（包括侧边栏、页脚等）

**解决方案:**
```bash
# 使用更具体的选择器
# 错误: main
# 正确: main .content, article .markdown-body

# 或者使用 :not() 排除不需要的元素
main > div:not(.sidebar):not(.footer)
```

### Q: 侧边栏选择器包含了嵌套的子链接

**解决方案:**
```bash
# 只选择直接子链接
.sidebar > ul > li > a

# 或者排除嵌套的链接
.sidebar a:not(.sub-link)
```

### Q: 动态加载的内容无法提取

**解决方案:**
```bash
# 等待特定元素出现
agent-browser wait @dynamic-content

# 或者等待特定文本
agent-browser wait --text "内容已加载"

# 或者等待网络空闲
agent-browser wait --load networkidle
```

### Q: 需要滚动才能加载的内容

**解决方案:**
```bash
# 滚动到底部
agent-browser scroll down 10000

# 等待新内容加载
agent-browser wait --load networkidle

# 重新快照
agent-browser snapshot -i
```

## 自定义选择器模式

### 1. 多个备选选择器

```bash
# 使用逗号分隔多个选择器，选择第一个匹配的
main, article, [role="main"], .content
```

### 2. 组合选择器

```bash
# 同时满足多个条件
main.doc-content
article.markdown-body
```

### 3. 属性选择器

```bash
# 根据属性选择
[data-page="docs"]
[role="main"]
[type="text"]
```

### 4. 伪类选择器

```bash
# 第一个元素
.sidebar li:first-child a

# 最后一个元素
.sidebar li:last-child a

# 包含特定文本
.sidebar a:contains("快速开始")
```

## 验证选择器

### 方法1: 使用浏览器控制台

```javascript
// 在浏览器控制台中测试
document.querySelectorAll('your-selector')
```

### 方法2: 使用 agent-browser eval

```bash
agent-browser eval "
document.querySelectorAll('your-selector').length
"
```

### 方法3: 使用 jq 统计

```bash
agent-browser get text @content | wc -l
```

## 最佳实践

1. **优先使用语义化选择器**（main, article, nav）而非类名
2. **选择器越简单越好**，避免过度复杂
3. **使用浏览器开发者工具验证**选择器的准确性
4. **考虑网站响应式设计**，选择器在不同屏幕尺寸下可能不同
5. **保存选择器配置**，方便后续使用

## 选择器配置示例

创建 `selectors.json` 文件：

```json
{
  "vuepress": {
    "content": ".theme-default-content",
    "sidebar": ".sidebar",
    "links": ".sidebar-link"
  },
  "vitepress": {
    "content": ".VPDoc",
    "sidebar": ".VPDocAside",
    "links": ".VPDocAside a"
  },
  "docusaurus": {
    "content": "article",
    "sidebar": ".sidebar",
    "links": ".sidebar a"
  }
}
```

在脚本中使用：

```bash
FRAMEWORK="vitepress"
SELECTORS=$(jq ".${FRAMEWORK}" selectors.json)
CONTENT_SELECTOR=$(echo "$SELECTORS" | jq -r '.content')