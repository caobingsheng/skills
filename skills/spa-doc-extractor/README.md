# SPA 文档提取器 - 使用指南

本技能提供了完整的 SPA（单页应用）文档提取解决方案，使用 agent-browser 进行浏览器自动化。

## 快速开始

### 方法1：使用快速提取脚本（推荐）

```bash
# 提取 Element UI 快速开始文档
./.claude/skills/spa-doc-extractor/scripts/quick-extract.sh \
  https://element.eleme.cn/#/zh-CN/component/quickstart \
  .page-component__content \
  element-quickstart.md
```

### 方法2：手动执行命令

```bash
# 1. 打开页面
npx agent-browser open https://element.eleme.cn/#/zh-CN/component/quickstart

# 2. 等待加载
npx agent-browser wait --load networkidle

# 3. 提取内容
npx agent-browser get text .page-component__content > output.md
```

## 文件结构

```
spa-doc-extractor/
├── skill.md                          # 主技能文档
├── scripts/                          # 实用脚本
│   ├── quick-extract.sh             # 快速提取脚本
│   ├── batch-extract.sh             # 批量提取脚本
│   ├── single-page-extract.sh       # 单页面提取模板
│   └── structured-extract.sh        # 结构化数据提取
└── references/                       # 参考文档
    ├── selectors-guide.md           # 选择器指南
    ├── advanced-patterns.md         # 高级模式
    └── element-ui-case-study.md     # Element UI 实战案例
```

## 核心概念

### 1. 等待网络空闲

对于 SPA 文档，必须等待所有内容加载完成：

```bash
npx agent-browser wait --load networkidle
```

### 2. 使用正确的选择器

不同的文档网站使用不同的选择器：

| 网站 | 选择器 |
|------|--------|
| Element UI | `.page-component__content` |
| VuePress | `.theme-default-content` |
| VitePress | `.VPDoc` |
| Ant Design | `.markdown` |
| 通用 | `main`, `article`, `.content` |

详见 [选择器指南](references/selectors-guide.md)

### 3. 格式化输出

直接提取的文本需要格式化为标准 Markdown：

- 添加标题层级（#, ##, ###）
- 将代码包裹在 ``` 中
- 调整段落间距
- 修复列表格式

## 常见场景

### 场景1：提取单个文档页面

```bash
npx agent-browser open https://example.com/docs/introduction
npx agent-browser wait --load networkidle
npx agent-browser get text .content > introduction.md
```

### 场景2：批量提取多个页面

```bash
#!/bin/bash
pages=("intro" "guide" "api" "examples")

for page in "${pages[@]}"; do
    npx agent-browser open "https://example.com/docs/$page"
    npx agent-browser wait --load networkidle
    npx agent-browser get text .content > "$page.md"
    sleep 2
done
```

### 场景3：提取需要登录的文档

```bash
# 先登录并保存状态
npx agent-browser open https://example.com/login
# ... 登录操作 ...
npx agent-browser state save auth.json

# 后续使用保存的状态
npx agent-browser state load auth.json
npx agent-browser open https://example.com/docs
npx agent-browser wait --load networkidle
npx agent-browser get text .content > docs.md
```

## 实战案例

完整的 Element UI 文档提取案例，请参考：
- [Element UI 实战案例](references/element-ui-case-study.md)

## 脚本使用

### quick-extract.sh

快速提取单个文档页面：

```bash
./scripts/quick-extract.sh <URL> <SELECTOR> [OUTPUT_FILE]
```

**示例**：

```bash
# 提取 Element UI 快速开始
./scripts/quick-extract.sh \
  https://element.eleme.cn/#/zh-CN/component/quickstart \
  .page-component__content \
  element-quickstart.md

# 提取 Vue Router 指南
./scripts/quick-extract.sh \
  https://router.vuejs.org/zh/guide/ \
  .content \
  vue-router-guide.md
```

**特性**：
- ✅ 自动检查依赖
- ✅ 彩色输出提示
- ✅ 错误处理
- ✅ 进度显示

## 故障排除

### 问题1：内容为空

**原因**：页面未完全加载

**解决方案**：
```bash
# 确保使用 networkidle
npx agent-browser wait --load networkidle

# 或增加等待时间
npx agent-browser wait 5000
```

### 问题2：选择器不正确

**解决方案**：
```bash
# 使用浏览器开发者工具查找正确的选择器
# 1. 右键点击内容区域
# 2. 选择"检查"
# 3. 查看容器的 class 或 id
```

### 问题3：中文乱码

**解决方案**：
```bash
# 确保使用 UTF-8 编码
export LANG=zh_CN.UTF-8

# 检查文件编码
file -I output.md

# 转换编码
iconv -f GBK -t UTF-8 input.md > output.md
```

## 最佳实践

1. **始终使用 npx** - 确保使用最新版本的 agent-browser
2. **必须等待加载** - SPA 文档必须使用 `wait --load networkidle`
3. **添加延迟** - 批量提取时添加延迟避免被封禁
4. **测试选择器** - 先测试选择器是否正确
5. **格式化输出** - 手动或自动格式化提取的文本
6. **尊重版权** - 保留原始版权信息，仅用于学习

## 进阶技巧

### 提取文档结构

```bash
npx agent-browser eval "
Array.from(document.querySelectorAll('h1, h2, h3')).map(h => ({
  level: h.tagName,
  text: h.textContent.trim()
}))
" > structure.json
```

### 提取所有链接

```bash
npx agent-browser eval "
Array.from(document.querySelectorAll('.sidebar a')).map(a => ({
  title: a.textContent.trim(),
  href: a.href
}))
" > links.json
```

### 自动化格式化

创建格式化脚本：

```javascript
// format-doc.js
const fs = require('fs');
const content = fs.readFileSync('raw.md', 'utf8');

// 识别标题
let formatted = content.replace(/^([A-Z\s]{10,})$/gm, '\n## $1\n');

// 识别代码块
formatted = formatted.replace(/    (.+)/g, '```javascript\n$1\n```');

fs.writeFileSync('formatted.md', formatted);
```

## 资源链接

- [agent-browser 文档](https://github.com/agent-browser/agent-browser)
- [选择器指南](references/selectors-guide.md)
- [Element UI 实战案例](references/element-ui-case-study.md)
- [高级模式](references/advanced-patterns.md)

## 贡献

如果你有新的提取技巧或发现新的文档网站选择器，欢迎贡献！

## 许可

本技能仅供学习和个人使用。提取的文档请遵守原始网站的版权和使用条款。
