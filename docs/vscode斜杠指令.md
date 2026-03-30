# VSCode中/create-prompt /create-instructions /create-agent /create-hook /create-skill命令区别与对比分析

## 一、命令核心功能概览

VSCode中的这五个/create-*命令是GitHub Copilot聊天界面的斜杠命令，用于在代理模式下通过AI辅助生成不同类型的自定义配置文件，以满足个性化开发需求。

| 命令 | 生成文件类型 | 核心功能 | 官方定义 |
|------|--------------|----------|----------|
| **/create-prompt** | .prompt.md | 创建可复用的提示词模板 | 定义可通过斜杠命令调用的标准化工作流提示模板 |
| **/create-instructions** | .instructions.md | 创建项目级指令文件 | 定义项目特定的编码规范、架构指南和行为准则 |
| **/create-agent** | .agent.md | 创建专业化自定义代理 | 定义具有特定角色和能力的AI代理，用于处理特定开发任务 |
| **/create-hook** | hooks.json + README.md | 创建代理生命周期钩子 | 在代理执行的关键节点（如会话开始/结束）运行自定义脚本 |
| **/create-skill** | SKILL.md + 资源文件 | 创建领域特定技能包 | 提供完整的工具集，包括指令、脚本、示例和资源，用于特定领域任务 |

## 二、详细功能与场景分析

### 1. /create-prompt：可复用提示模板生成器

**功能特点**：
- 生成`.prompt.md`文件，包含提示内容和可选的元数据（如`applyTo`模式）
- 可在工作区（`.github/prompts`）或用户级别（跨所有工作区）定义
- 通过斜杠命令直接调用，如`/my-prompt`

**适用场景**：
- 频繁使用的标准化查询（如代码解释、重构建议）
- 团队共享的代码审查模板
- 特定框架/语言的最佳实践查询
- 替代重复输入的复杂提示词

**示例**：生成一个用于Vue组件单元测试的提示模板，包含测试框架选择、断言风格和覆盖率要求。

### 2. /create-instructions：项目级指令文件生成器

**功能特点**：
- 生成`.instructions.md`文件，包含`applyTo`模式（控制适用范围）和指令内容
- 自动应用于所有Copilot交互（聊天和内联建议）
- 支持glob模式限制适用文件类型或路径

**适用场景**：
- 强制团队编码规范（如缩进风格、引号类型、命名约定）
- 定义项目架构限制（如禁止使用特定库、必须遵循的设计模式）
- 设置文档标准和注释要求
- 统一错误处理和日志记录策略

**示例**：生成指令文件，要求所有JavaScript文件使用ESLint标准、双引号和2空格缩进，排除测试文件。

### 3. /create-agent：专业化AI代理创建器

**功能特点**：
- 生成`.agent.md`文件，包含代理描述、工具集、子代理和执行流程
- 可定义代理角色（如研究人员、实现者、审查者）
- 支持工具配置和子代理调用，实现复杂任务分工

**适用场景**：
- 复杂功能开发（分解为研究→设计→实现→测试）
- 代码重构和迁移（如从JavaScript到TypeScript）
- 安全审计和性能优化
- 文档生成和维护

**示例**：创建一个"API文档生成器"代理，自动分析代码库中的API端点，生成符合OpenAPI规范的文档。

### 4. /create-hook：代理生命周期钩子生成器

**功能特点**：
- 生成`hooks.json`配置文件和`README.md`说明文档
- 支持多种钩子类型：`sessionStart`、`sessionEnd`、`stepStart`、`stepEnd`、`onErrorOccurred`等
- 可执行bash、PowerShell或Python脚本

**适用场景**：
- 会话开始时初始化环境（如安装依赖、配置环境变量）
- 会话结束时清理临时资源、生成执行报告
- 记录代理活动用于审计和合规性
- 在步骤执行前后验证代码质量或安全性

**示例**：创建一个`sessionStart`钩子，自动检查项目依赖是否最新，并在会话结束时生成代码更改摘要日志。

### 5. /create-skill：领域特定技能包生成器

**功能特点**：
- 生成`SKILL.md`文件和相关资源（脚本、示例、配置）
- 采用agentskills.io开放标准，跨平台兼容（VSCode、Copilot CLI和Copilot编码代理）
- 任务特定，按需加载，不影响其他任务执行

**适用场景**：
- 特定技术栈的开发工作流（如React Native移动应用开发）
- 数据库迁移和查询优化
- 容器化部署和CI/CD配置
- 安全漏洞扫描和修复建议

**示例**：创建一个"Web安全技能包"，包含OWASP Top 10漏洞检测规则、修复示例和自动化扫描脚本。

## 三、关键区别对比分析

### 1. 作用范围对比

| 命令 | 作用范围 | 应用时机 | 可移植性 |
|------|----------|----------|----------|
| /create-prompt | 单个查询/任务 | 手动调用时 | 仅限VSCode和Copilot CLI |
| /create-instructions | 项目全局 | 自动应用 | 仅限VSCode和GitHub.com |
| /create-agent | 特定任务流程 | 手动委托时 | 跨VSCode、Copilot CLI和Copilot编码代理 |
| /create-hook | 代理生命周期 | 自动触发 | 跨VSCode、Copilot CLI和Copilot编码代理 |
| /create-skill | 特定领域任务 | 自动匹配时 | 跨VSCode、Copilot CLI和Copilot编码代理 |

### 2. 功能定位对比

- **/create-prompt**：专注于**输入优化**，提供标准化提示模板，提升查询效率
- **/create-instructions**：专注于**行为约束**，定义项目规则，确保一致性和合规性
- **/create-agent**：专注于**任务分工**，创建专业化角色，处理复杂开发流程
- **/create-hook**：专注于**流程自动化**，在关键节点执行脚本，扩展代理能力
- **/create-skill**：专注于**能力增强**，提供完整工具集，解决特定领域问题

### 3. 技术实现对比

| 命令 | 文件格式 | 核心元素 | 执行方式 |
|------|----------|----------|----------|
| /create-prompt | Markdown | 提示内容、元数据 | 手动斜杠命令调用 |
| /create-instructions | Markdown | applyTo模式、指令内容 | 自动应用（基于glob匹配） |
| /create-agent | Markdown | 代理描述、工具、子代理 | 手动委托或斜杠命令调用 |
| /create-hook | JSON + Markdown | 钩子类型、脚本内容 | 自动触发（生命周期事件） |
| /create-skill | Markdown + 资源 | 技能描述、工具、示例 | 自动匹配或手动调用 |

## 四、使用建议与最佳实践

1. **按需求选择命令**：
   - 需要重复使用的提示词 → 使用**/create-prompt**
   - 项目级规范和指南 → 使用**/create-instructions**
   - 复杂任务流程自动化 → 使用**/create-agent**
   - 代理执行流程扩展 → 使用**/create-hook**
   - 领域特定能力增强 → 使用**/create-skill**

2. **组合使用策略**：
   - 为自定义代理创建配套技能包和提示模板
   - 使用指令文件定义基础规则，用钩子实现自动化验证
   - 通过技能包共享领域知识，通过代理实现任务专业化分工

## 五、数据引用来源

1. VSCode官方文档 - GitHub Copilot自定义概述：https://code.visualstudio.com/docs/copilot/customization/overview
2. VSCode官方文档 - 提示文件指南：https://code.visualstudio.com/docs/copilot/customization/prompt-files
3. VSCode官方文档 - 自定义指令指南：https://code.visualstudio.com/docs/copilot/customization/custom-instructions
4. VSCode官方文档 - 自定义代理指南：https://code.visualstudio.com/docs/copilot/customization/custom-agents
5. VSCode官方文档 - Agent Skills指南：https://code.visualstudio.com/docs/copilot/customization/agent-skills
6. GitHub官方文档 - Hooks配置参考：https://docs.github.com/en/copilot/reference/hooks-configuration
7. VSCode官方文档 - Copilot功能备忘单：https://code.visualstudio.com/docs/copilot/copilot-vscode-features

