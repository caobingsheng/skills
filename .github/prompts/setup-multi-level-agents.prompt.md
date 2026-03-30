---
name: setup-multi-level-agents
description: Set up multi-level AGENTS.md discovery mechanism for IDEs
argument-hint: The main AGENTS.md file and any existing directory-level AGENTS.md files
---

## 多级AGENTS.md发现机制设置

为项目设置多级AGENTS.md结构，让不自动支持子目录AGENTS.md的IDE也能识别和使用。

### 实施步骤：

1. **在主AGENTS.md开头添加发现机制**
   - 添加"目录AGENTS.md发现机制"章节
   - 明确说明：处理文件时首先检查该文件所在目录是否存在AGENTS.md
   - 说明子目录AGENTS.md的规范优先级高于根目录AGENTS.md

2. **为子目录AGENTS.md添加标准化头部**
   - 添加 `<!-- DIRECTORY-AGENTS:START -->` 标记
   - 添加"适用范围"章节，明确说明该AGENTS.md适用于哪些文件
   - 使用标准化的说明语言

3. **确保渐进式披露**
   - 避免一次性加载所有AGENTS.md内容
   - 让AI在处理具体文件时就近读取同目录的AGENTS.md

### 预期效果：
- 主AGENTS.md提供全局规范
- 子目录AGENTS.md提供目录特定规范
- AI能够智能发现和使用合适的AGENTS.md
- 上下文占用保持精简
