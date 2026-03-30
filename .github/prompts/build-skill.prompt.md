---
description: 根据网页文档创建skill，包含获取内容、头脑风暴分析和严格按照skill规范创建的完整流程。
---

$ARGUMENTS
<!-- OPENSPEC:START -->

**护栏规则**
- 必须严格按照skill-creator规范创建skill，确保SKILL.md结构完整
- 优先使用简洁的表达方式，避免冗长的解释
- 确保skill的name和description清晰准确，这是AI判断何时使用skill的唯一依据
- 遵循渐进式披露原则，保持SKILL.md精简（<500行），详细内容放入references/
- 不要创建额外的文档文件（README.md、INSTALLATION_GUIDE.md等），只包含必要的skill文件
- 所有输出必须使用中文，除非明确要求使用英文

**工作流步骤**

## 阶段1：获取文档内容（Document Fetching）

1. **识别文档来源**：
   - 从用户输入中提取文档URL或文件路径
   - 确定文档类型（网页、PDF、Markdown等）
   - 识别文档的语言和主题领域

2. **获取文档内容**：
   - 使用fetch或browser-mcp(SPA)或爬虫等工具获取网页内容
   - 如果是本地文件，使用`read_file`工具读取
   - 提取文档的主要内容和结构
   - 保存原始内容到临时文件供后续分析

3. **内容预处理**：
   - 清理HTML标签和无关内容（如广告、导航栏）
   - 提取标题、章节、代码示例等关键信息
   - 识别文档的核心主题和覆盖范围
   - 生成文档摘要（200-300字）

## 阶段2：头脑风暴分析（Brainstorming Analysis）

4. **加载brainstorming skill**：
   - 使用brainstorming skill进行需求分析
   - 一次只问一个问题，避免信息过载
   - 优先使用多选题，减少开放式问题

5. **理解skill目的**：
   - 询问：这个skill的主要用途是什么？（多选）
     - A. 提供特定领域的工作流程指导
     - B. 集成特定工具或API的使用方法
     - C. 封装公司特定的知识或业务逻辑
     - D. 提供可重复使用的脚本或模板
   - 询问：skill的目标用户是谁？（开放）
   - 询问：skill应该解决什么具体问题？（开放）

6. **探索设计选项**：
   - 提出2-3种不同的skill结构方案
   - 说明每种方案的优缺点
   - 推荐最佳方案并说明理由
   - 询问：你倾向于哪种方案？（多选）

7. **确定skill范围**：
   - 询问：skill需要包含哪些bundled resources？（多选）
     - A. scripts/（可执行脚本）
     - B. references/（参考文档）
     - C. assets/（输出资源文件）
     - D. 仅SKILL.md（无需额外资源）
   - 识别哪些内容应该放在SKILL.md，哪些应该放在references/
   - 确定skill的自由度级别（高/中/低）

8. **验证设计**：
   - 分段呈现设计（每段200-300字）
   - 每段后询问：这部分看起来正确吗？
   - 涵盖：skill结构、核心工作流程、错误处理、测试策略
   - 准备回溯澄清任何不清楚的地方

## 阶段3：创建skill（Skill Creation）

9. **加载skill-creator skill**：
   - 严格遵循skill-creator规范
   - 确保SKILL.md包含必需的frontmatter（name、description）
   - 编写清晰、准确的description，说明何时使用此skill

10. **创建SKILL.md**：
    - **Frontmatter**（必需）：
      ```yaml
      ---
      name: skill-name
      description: 清晰描述skill用途和使用场景，包含触发关键词
      license: MIT（或其他适用许可证）
      ---
      ```
    - **Body**结构：
      - ## Overview（简短概述，1-2段）
      - ## Quick Start（快速开始，包含基本用法示例）
      - ## Key Concepts（核心概念，仅包含Claude不知道的知识）
      - ## Workflow（工作流程，分步骤说明）
      - ## Best Practices（最佳实践）
      - ## References（指向references/文件的链接）
    - 保持SKILL.md精简（<500行），详细内容放入references/

11. **创建Bundled Resources**（如需要）：
    - **scripts/**：可执行代码
      - 仅当需要确定性可靠性或代码被重复重写时
      - 使用Python/Bash等脚本语言
      - 包含清晰的注释和使用说明
    - **references/**：参考文档
      - API文档、数据模式、领域知识
      - 详细的配置示例和模式
      - 每个文件专注于特定主题
      - 包含目录结构（>100行时）
    - **assets/**：输出资源文件
      - 模板、图标、样例文件
      - 不加载到context，仅在输出中使用

12. **应用渐进式披露原则**：
    - **Level 1**：Metadata（name + description）始终在context中
    - **Level 2**：SKILL.md body在skill触发时加载（<5k words）
    - **Level 3**：Bundled resources按需加载
    - 避免重复信息：内容要么在SKILL.md，要么在references/，不要两者都有
    - 保持SKILL.md精简，只包含核心工作流程和选择指导

13. **验证skill质量**：
    - 检查SKILL.md frontmatter是否完整
    - 验证description是否清晰说明使用场景
    - 确保SKILL.md < 500行
    - 检查references/文件是否有清晰的目录结构
    - 验证所有链接和引用是否正确
    - 确保没有创建额外的文档文件（README.md等）

14. **测试skill**：
    - 模拟使用场景，验证skill是否按预期工作
    - 检查所有工作流程步骤是否清晰
    - 验证示例代码是否正确
    - 确保错误处理和边界情况已覆盖

**实施指南**

### 文档内容提取策略

```markdown
## 网页文档处理
- 使用fetch或browser-mcp(SPA)或爬虫等工具获取内容

## PDF文档处理
- 使用pdfplumber提取文本
- 保留文档结构和章节标题
- 提取表格和图表数据
- 识别代码块和技术示例

## Markdown文档处理
- 直接读取文件内容
- 保留原有的格式和结构
- 提取代码块和链接
- 识别frontmatter元数据
```

### Skill结构选择决策树

```
是否有可重复使用的脚本？
├─ 是 → 包含scripts/目录
└─ 否 → 跳过

是否有大量参考文档（>5k words）？
├─ 是 → 包含references/目录
│   ├─ 按主题分割（如finance.md, sales.md）
│   └─ 在SKILL.md中添加链接
└─ 否 → 保留在SKILL.md中

是否有输出模板或资源文件？
├─ 是 → 包含assets/目录
└─ 否 → 跳过
```

### Description编写最佳实践

```markdown
好的description示例：
---
description: "Use when working with vk-unicloud-admin framework database operations, especially when: (1) Implementing CRUD operations, (2) Performing complex queries with pagination, (3) Using database transactions. Covers vk.baseDao API, query operators, and best practices."
---

不好的description示例：
---
description: "A skill for database operations."
---

关键区别：
- 好的description明确说明使用场景和触发条件
- 包含具体的使用情况列表
- 提及覆盖的功能和最佳实践
- 使用关键词便于AI检索
```

### 渐进式披露模式示例

**模式1：高层指导+引用**
```markdown
# PDF Processing

## Quick start
Extract text with pdfplumber:
[code example]

## Advanced features
- **Form filling**: See [FORMS.md](references/FORMS.md)
- **API reference**: See [REFERENCE.md](references/REFERENCE.md)
- **Examples**: See [EXAMPLES.md](references/EXAMPLES.md)
```

**模式2：领域特定组织**
```markdown
# BigQuery Analytics

## Quick start
Basic query pattern:
[code example]

## Domain-specific guides
- **Finance metrics**: See [references/finance.md](references/finance.md)
- **Sales data**: See [references/sales.md](references/sales.md)
- **Product analytics**: See [references/product.md](references/product.md)
```

**模式3：条件性细节**
```markdown
# DOCX Processing

## Creating documents
Use docx-js for new documents.

## Editing documents
For simple edits, modify the XML directly.

**For tracked changes**: See [references/REDLINING.md](references/REDLINING.md)
**For OOXML details**: See [references/OOXML.md](references/OOXML.md)
```

### 质量检查清单

创建skill后，使用此清单验证质量：

- [ ] Frontmatter包含name和description
- [ ] Description清晰说明使用场景和触发条件
- [ ] SKILL.md < 500行
- [ ] SKILL.md包含Overview、Quick Start、Workflow等核心章节
- [ ] 详细内容已移至references/文件
- [ ] references/文件有清晰的目录结构（>100行时）
- [ ] 所有链接和引用正确
- [ ] 没有创建额外的文档文件（README.md等）
- [ ] scripts/包含可执行代码（如适用）
- [ ] assets/包含输出资源（如适用）
- [ ] 已测试skill在模拟场景中的工作效果
- [ ] 所有示例代码正确且可运行
- [ ] 错误处理和边界情况已覆盖

**参考资源**

- Skill创建规范：`.claude/skills/skill-creator/SKILL.md`
- 头脑风暴流程：`.claude/skills/brainstorming/SKILL.md`
- 现有skill示例：`.claude/skills/`
- 项目文档规范：`openspec/AGENTS.md`

**常见问题**

**Q: 如何确定skill的自由度级别？**
A: 根据任务的脆弱性和可变性：
- 高自由度（文本指令）：多种方法有效，决策依赖上下文
- 中自由度（伪代码/脚本）：有首选模式，某些变化可接受
- 低自由度（特定脚本）：操作易错，一致性关键

**Q: 何时将内容放入references/？**
A: 当满足以下任一条件：
- SKILL.md接近500行限制
- 内容是详细的参考材料（API文档、模式等）
- 内容仅在特定场景下需要
- 内容按主题/框架/变体组织

**Q: 如何避免信息重复？**
A: 遵循"单一来源"原则：
- 核心工作流程和选择指导 → SKILL.md
- 详细参考材料、模式、示例 → references/
- 不要在两个地方包含相同信息

**Q: 如何编写有效的description？**
A: 包含以下元素：
- 明确的使用场景（"Use when..."）
- 具体的触发条件（"especially when..."）
- 覆盖的功能列表
- 关键词便于AI检索

<!-- OPENSPEC:END -->
