# Element UI 文档提取实战案例

本案例展示如何使用 agent-browser 提取 Element UI 官方文档的完整过程。

## 目标

提取 Element UI 快速开始文档：https://element.eleme.cn/#/zh-CN/component/quickstart

## 完整步骤

### 1. 准备工作

确保已安装 Node.js 和 agent-browser：

```bash
# 检查 Node.js
node --version

# 检查 agent-browser（会自动安装）
npx agent-browser --version
```

### 2. 打开页面

```bash
npx agent-browser open https://element.eleme.cn/#/zh-CN/component/quickstart
```

**输出**：
```
✓ 组件 | Element
  https://element.eleme.cn/#/zh-CN/component/quickstart
```

### 3. 等待页面加载

这是最关键的一步！Element UI 是单页应用，内容是动态加载的。

```bash
npx agent-browser wait --load networkidle
```

**说明**：
- `--load networkidle` 等待所有网络请求完成
- 这确保了所有内容都已加载完毕
- 对于 SPA 文档，这一步必不可少

**输出**：
```
✓ Done
```

### 4. 查找内容选择器

在浏览器开发者工具中检查页面结构：

1. 右键点击主内容区域
2. 选择"检查"
3. 查看容器的 class 名称

Element UI 的主内容区域使用：`.page-component__content`

### 5. 提取内容

```bash
npx agent-browser get text .page-component__content > element-quickstart-raw.md
```

**说明**：
- `.page-component__content` 是 Element UI 的主内容容器
- 输出重定向到 `element-quickstart-raw.md`
- 此时得到的是纯文本，包含所有内容但格式需要调整

### 6. 查看原始输出

```bash
cat element-quickstart-raw.md
```

**原始输出示例**：
```
¶ 快速上手本节将介绍如何在项目中使用 Element。¶ 使用 vue-cli@3我们为新版的 vue-cli 准备了相应的 Element 插件...
```

**问题**：
- 标题层级丢失
- 代码块未格式化
- 段落之间缺少空行
- 需要手动格式化

### 7. 格式化输出

手动或使用脚本将纯文本转换为标准 Markdown：

**格式化后的输出**：

```markdown
# Element UI 快速上手

本节将介绍如何在项目中使用 Element。

## 使用 vue-cli@3

我们为新版的 vue-cli 准备了相应的 Element 插件，你可以用它们快速地搭建一个基于 Element 的项目。

## 引入 Element

### 完整引入

在 main.js 中写入以下内容：

```javascript
import Vue from 'vue';
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import App from './App.vue';

Vue.use(ElementUI);

new Vue({
  el: '#app',
  render: h => h(App)
});
```

以上代码便完成了 Element 的引入。需要注意的是，样式文件需要单独引入。
```

## 完整脚本

将以上步骤整合为一个脚本：

```bash
#!/bin/bash
# Element UI 文档提取脚本

echo "开始提取 Element UI 快速开始文档..."

# 1. 打开页面
npx agent-browser open https://element.eleme.cn/#/zh-CN/component/quickstart

# 2. 等待加载
npx agent-browser wait --load networkidle

# 3. 提取内容
npx agent-browser get text .page-component__content > element-quickstart-raw.md

# 4. 格式化（手动或使用脚本）
# 这里需要手动格式化或使用格式化工具

echo "提取完成！"
echo "原始文件: element-quickstart-raw.md"
echo "请手动格式化为标准 Markdown"
```

## 批量提取多个组件

如果需要提取多个组件的文档：

```bash
#!/bin/bash
# 批量提取 Element UI 组件文档

components=(
    "button"
    "input"
    "select"
    "form"
    "table"
    "dialog"
    "message"
    "notification"
)

for comp in "${components[@]}"; do
    echo "提取 $comp 组件..."
    
    npx agent-browser open "https://element.eleme.cn/#/zh-CN/component/$comp"
    npx agent-browser wait --load networkidle
    npx agent-browser get text .page-component__content > "docs/element-$comp.md"
    
    # 添加延迟避免请求过快
    sleep 2
done

echo "所有组件文档提取完成！"
```

## 关键要点

### 1. 必须等待网络空闲

```bash
# ✅ 正确
npx agent-browser wait --load networkidle

# ❌ 错误 - 可能导致内容未加载
# 直接提取
```

### 2. 使用正确的选择器

```bash
# Element UI 特定选择器
.page-component__content

# 通用选择器（可能不准确）
main
.content
```

### 3. 格式化很重要

直接提取的文本需要格式化：
- 添加标题层级（#, ##, ###）
- 将代码包裹在 ``` 中
- 调整段落间距
- 修复列表格式

### 4. 尊重版权

提取的文档应：
- 保留原始版权信息
- 注明来源（Element UI 官方文档）
- 仅用于个人学习和参考
- 不得用于商业用途

## 常见问题

### Q: 提取的内容为空？

**A**: 检查以下几点：
1. 是否使用了 `wait --load networkidle`
2. 选择器是否正确
3. 页面是否完全加载

### Q: 内容不完整？

**A**: 可能的原因：
1. 网络未完全空闲
2. 内容懒加载未触发
3. 选择器范围太小

**解决方案**：
```bash
# 增加等待时间
npx agent-browser wait 5000

# 或等待特定元素
npx agent-browser wait @specific-element
```

### Q: 如何自动化格式化？

**A**: 可以使用以下方法：
1. 编写 JavaScript 格式化脚本
2. 使用 AI 工具辅助格式化
3. 使用 sed/awk 进行简单格式化

## 扩展：提取其他 Element UI 页面

### 提取安装指南

```bash
npx agent-browser open https://element.eleme.cn/#/zh-CN/component/installation
npx agent-browser wait --load networkidle
npx agent-browser get text .page-component__content > element-installation.md
```

### 提取主题定制

```bash
npx agent-browser open https://element.eleme.cn/#/zh-CN/component/theme
npx agent-browser wait --load networkidle
npx agent-browser get text .page-component__content > element-theme.md
```

### 提取所有组件列表

```bash
# 获取所有组件链接
npx agent-browser eval "
Array.from(document.querySelectorAll('.nav-component a'))
  .map(a => a.href)
  .join('\\n')
" > component-list.txt

# 批量提取
while read url; do
    # 提取每个组件...
done < component-list.txt
```

## 总结

提取 Element UI 文档的关键步骤：

1. ✅ 使用 `npx agent-browser` 确保最新版本
2. ✅ 使用 `wait --load networkidle` 等待加载
3. ✅ 使用 `.page-component__content` 选择器
4. ✅ 手动格式化输出内容
5. ✅ 尊重原始版权

这个流程同样适用于其他类似的文档网站！
