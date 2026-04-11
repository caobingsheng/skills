---
name: vue2-component-type-system
description: "Vue2组件类型提示系统 - 为Vue2组件建立完整的类型提示系统，使AI能够准确理解组件的props、events、slots等API。Use when: (1) 为Vue2组件添加JSDoc注释，(2) 创建TypeScript声明文件(.d.ts)，(3) 编写组件使用指南文档(README.md)，(4) AI需要理解Vue2组件的props信息，(5) 生成、修改或调试使用Vue2组件的代码。适用于Vue 2 + JavaScript项目，特别是使用vk-unicloud-admin框架的项目。"
---

# Vue2组件类型提示系统

为Vue2组件建立完整的类型提示系统，通过**JSDoc注释 + TypeScript声明文件 + 使用指南文档**三层架构，使AI能够准确理解组件API。

## 快速开始

### 为组件添加类型提示

当需要为Vue2组件添加类型提示时，按以下顺序操作：

1. **添加JSDoc注释** - 在.vue文件中添加详细的JSDoc注释
2. **创建.d.ts文件** - 在组件目录下创建TypeScript声明文件
3. **编写README.md** - 创建详细的使用指南文档

详细模板和示例见下文。

## 核心概念

### 三层架构

```
.vue文件 (JSDoc注释)  →  .d.ts文件 (类型定义)  →  README.md (使用指南)
     ↓                        ↓                        ↓
  人类可见              AI准确理解              详细文档
```

**为什么需要三层？**
- **JSDoc**：人类开发者直接可见，维护方便
- **.d.ts**：提供准确的类型定义，AI和IDE都能理解
- **README**：完整的文档，便于学习和查阅

## 工作流程

### 场景1：为新组件添加类型提示

1. **参考数据库Schema**（如适用）- 查看`uniCloud-aliyun/database/`目录下相关的schema文件，了解数据结构
2. **添加JSDoc注释** - 在.vue文件中添加详细的JSDoc注释（见[JSDOC_TEMPLATE.md](references/JSDOC_TEMPLATE.md)）
3. **创建.d.ts文件** - 在组件目录下创建TypeScript声明文件（见[DTS_TEMPLATE.md](references/DTS_TEMPLATE.md)）
4. **编写README.md** - 创建详细的使用指南文档（见[README_TEMPLATE.md](references/README_TEMPLATE.md)）
5. **在`components/types/index.d.ts`中添加导出**

### 数据库Schema参考

当组件涉及数据库数据时，应参考`uniCloud-aliyun/database/`目录下的schema文件：

**常用Schema文件：**
- `wm-patients.schema.json` - 患者信息
- `wm-charge-projects.schema.json` - 收费项目
- `wm-history-results.schema.json` - 历史结果
- `wm-weight-plan.schema.json` - 体重计划
- `wm-components-dynamic.schema.json` - 动态组件

**参考Schema的好处：**
- 确保props类型与数据库字段类型一致
- 了解字段约束（required、maxLength等）
- 获取准确的字段描述和注释
- 保持前后端数据结构一致性

### 场景2：AI理解组件props

AI会自动读取：
1. .vue文件中的JSDoc注释
2. .d.ts文件中的类型定义
3. README.md中的详细说明（通过@tutorial链接）

### 场景3：生成使用组件的代码

AI根据类型信息生成：
- 正确的prop名称
- 正确的数据类型
- 合适的默认值
- 完整的示例代码

## 模板和参考

### JSDoc注释模板

完整的JSDoc注释模板和示例，见：[JSDOC_TEMPLATE.md](references/JSDOC_TEMPLATE.md)

**关键要点**：
- 组件级注释：@component, @description, @example
- Prop级注释：@type, @required/@optional, @default, @example, @tutorial
- 使用@tutorial链接到README.md

### TypeScript声明文件模板

完整的.d.ts文件模板和示例，见：[DTS_TEMPLATE.md](references/DTS_TEMPLATE.md)

**关键要点**：
- 定义数据对象接口（如PatientInfo）
- 定义Props接口（如PatientInfoViewerProps）
- 定义Events接口（如PatientInfoViewerEvents）
- 导出组件类和全局声明

### 使用指南文档模板

完整的README.md模板和示例，见：[README_TEMPLATE.md](references/README_TEMPLATE.md)

**关键要点**：
- 组件概述和主要特性
- 基本用法和高级用法
- Props API详细说明
- 最佳实践和常见问题

### 完整设计方案

详细的设计方案和实施计划，见：[DESIGN.md](references/DESIGN.md)

包含：
- 背景和目标
- 整体架构设计
- 详细的规范说明
- 实施计划和验证标准

## 最佳实践

### 1. 保持一致性

- 所有组件使用相同的JSDoc注释格式
- 所有.d.ts文件使用相同的结构
- 所有README.md使用相同的章节结构

### 2. 完整性优先

- 每个prop都必须有JSDoc注释
- .d.ts文件必须覆盖所有props、events、slots
- README.md必须包含完整的示例和说明

### 3. 链接文档

- 在JSDoc中使用@tutorial链接到README.md
- 在README.md中链接到.d.ts文件和相关文档
- 保持三者信息一致

### 4. 渐进式实施

- 优先处理高频使用的组件
- 先完成一个组件，验证效果后再推广
- 根据实际使用情况调整模板

### 5. 参考数据库Schema

- 当组件涉及数据库数据时，参考`uniCloud-aliyun/database/`下的schema文件
- 确保props类型与数据库字段类型一致
- 利用schema中的字段约束和描述信息
- 保持前后端数据结构一致性

## 常见问题

### Q: 必须同时创建JSDoc、.d.ts和README吗？

A: 强烈建议。三者各有作用：
- JSDoc：人类开发者直接可见
- .d.ts：AI和IDE准确理解
- README：详细文档和示例

### Q: 如何处理组件更新？

A: 同步更新三层：
1. 修改.vue文件中的props
2. 更新JSDoc注释
3. 更新.d.ts文件
4. 更新README.md

### Q: AI还是无法理解组件怎么办？

A: 检查：
1. JSDoc注释是否完整
2. .d.ts文件是否准确
3. 是否有@tutorial链接
4. README.md是否详细

## 验证标准

### AI理解能力

- ✅ 优秀：AI准确回答所有props信息
- ✅ 良好：AI回答大部分props信息
- ✅ 合格：AI回答核心props信息
- ❌ 不合格：AI无法准确理解

### 代码生成质量

- ✅ 优秀：生成的代码完全符合API，无需修改
- ✅ 良好：生成的代码基本正确，少量调整
- ✅ 合格：生成的代码可用，较多修改
- ❌ 不合格：生成的代码无法使用

## 相关资源

- [vk-unicloud-admin框架文档](https://vkdoc.fsq.pub/admin/)
- [Vue2官方文档](https://v2.vuejs.org/)
- [JSDoc官方文档](https://jsdoc.app/)
- [TypeScript官方文档](https://www.typescriptlang.org/docs/handbook/declaration-files/do-s-and-don-ts.html)
