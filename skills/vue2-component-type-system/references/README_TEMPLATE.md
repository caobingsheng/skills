# README文档模板

本文档提供Vue2组件使用指南文档(README.md)的完整模板和示例。

## README.md结构模板

```markdown
# ComponentName 组件中文名称

## 📖 组件概述
组件的详细描述，说明组件的用途、适用场景和主要功能。

## ✨ 主要特性
- 特性1：描述
- 特性2：描述
- 特性3：描述

## 🚀 基本用法
### 场景1
\`\`\`vue
代码示例
\`\`\`

### 场景2
\`\`\`vue
代码示例
\`\`\`

## 📦 Props API
### propName1
- **类型**：`Type`
- **默认值**：`defaultValue`
- **描述**：详细描述
- **示例**：示例值

### propName2
- **类型**：`Type`（必需）
- **描述**：详细描述
- **示例**：示例值

## 🎨 高级用法
### 高级功能1
\`\`\`vue
代码示例
\`\`\`

### 高级功能2
\`\`\`vue
代码示例
\`\`\`

## 🔧 配置选项
### 选项1
| 值 | 说明 |
|----|------|
| value1 | 说明1 |
| value2 | 说明2 |

## 🎯 最佳实践
### 1. 实践1
描述

### 2. 实践2
描述

## ❓ 常见问题
### Q: 问题1？
A: 回答

### Q: 问题2？
A: 回答

## 📝 更新日志
### v1.0.0 (YYYY-MM-DD)
- 初始版本

## 🔗 相关文档
- [相关文档1](链接)
- [相关文档2](链接)
```

## 完整示例：patient-info-viewer/README.md

```markdown
# PatientInfoViewer 患者信息展示组件

## 📖 组件概述

灵活的患者信息展示组件，支持多种显示模式和信息格式化。适用于需要展示患者基本信息的各种场景。

### 适用场景

- 患者列表页面展示患者基本信息
- 患者详情页面展示完整信息
- 报告页面展示患者摘要信息
- 任何需要展示患者信息的场景

## ✨ 主要特性

- 🎨 **多种显示模式**：支持文本模式和标签模式
- 🔧 **灵活配置**：可自定义显示字段、样式、主题
- 📋 **信息丰富**：支持基本信息、病史、习惯等多维度展示
- 🖱️ **交互友好**：支持双击复制、全屏查看等交互
- 🎯 **类型安全**：完整的TypeScript类型支持
- 📱 **响应式设计**：适配不同屏幕尺寸

## 🚀 基本用法

### 文本模式

文本模式适合空间有限的场景，信息紧凑展示。

\`\`\`vue
<template>
  <patient-info-viewer
    :patient="patientData"
    :patient-props="'real_name,gender,age,mobile'"
    display-mode="text"
    :text-mode-separator="' | '" />
</template>

<script>
export default {
  data() {
    return {
      patientData: {
        real_name: '张三',
        gender: 1,
        age: 30,
        mobile: '13800138000'
      }
    };
  }
};
</script>
\`\`\`

**效果**：`张三 | 男 | 30岁 | 13800138000`

### 标签模式

标签模式适合需要突出显示的场景，视觉层次清晰。

\`\`\`vue
<template>
  <patient-info-viewer
    :patient="patientData"
    :patient-props="'real_name,gender,age'"
    display-mode="tags"
    :show-popover="true"
    tags-mode-title="患者信息" />
</template>

<script>
export default {
  data() {
    return {
      patientData: {
        real_name: '张三',
        gender: 1,
        age: 30
      }
    };
  }
};
</script>
\`\`\`

**效果**：显示三个标签，分别显示姓名、性别、年龄

## 📦 Props API

### patient

- **类型**：`Object`（必需）
- **描述**：患者信息对象，包含患者的基本信息
- **示例**：

\`\`\`javascript
{
  real_name: '张三',
  gender: 1,
  age: 30,
  mobile: '13800138000',
  identity: '110101199001011234',
  medical_history: '无',
  eating_habits: '清淡',
  sprot_habits: '每周3次',
  medication_situation: '无'
}
\`\`\`

### patientProps

- **类型**：`String`
- **默认值**：`'real_name,gender,age,mobile,identity'`
- **描述**：显示的字段列表，逗号分隔的字段名
- **可选值**：
  - `real_name` - 姓名
  - `gender` - 性别
  - `age` - 年龄
  - `mobile` - 联系电话
  - `identity` - 身份证号
  - `medical_history` - 既往病史
  - `eating_habits` - 饮食习惯
  - `sprot_habits` - 运动习惯
  - `medication_situation` - 用药情况
- **示例**：`'real_name,gender,age'`

### displayMode

- **类型**：`String`
- **默认值**：`'text'`
- **描述**：显示模式
- **可选值**：
  - `text` - 文本模式，字段以文本形式展示
  - `tags` - 标签模式，字段以标签形式展示
- **示例**：`'tags'`

### textModeSeparator

- **类型**：`String`
- **默认值**：`' , '`
- **描述**：文本模式下字段之间的分隔符
- **示例**：`' | '` 或 `' / '`

### textModeStyle

- **类型**：`Object`
- **默认值**：`{}`
- **描述**：文本模式下的自定义样式对象
- **示例**：

\`\`\`javascript
{
  fontSize: '14px',
  color: '#333',
  fontWeight: 'bold'
}
\`\`\`

### tagsModeTheme

- **类型**：`Array`
- **默认值**：15种默认主题
- **描述**：标签模式下的主题数组，包含type、effect、size等属性
- **示例**：

\`\`\`javascript
[
  { type: 'success', effect: 'dark', size: 'medium' },
  { type: 'warning', effect: 'plain', size: 'small' },
  { type: 'info', effect: 'light', size: 'mini' }
]
\`\`\`

**可选值**：
- `type`：success/warning/info/danger
- `effect`：plain/dark/light
- `size`：medium/small/mini

### patientPropsFormatter

- **类型**：`Function`
- **默认值**：`null`
- **描述**：自定义字段值的格式化函数
- **参数**：
  - `patient`：患者信息对象
  - `prop`：属性名
- **返回值**：格式化后的值
- **示例**：

\`\`\`javascript
function(patient, prop) {
  if (prop === 'gender') {
    return patient.gender === 1 ? '男' : '女';
  }
  if (prop === 'age') {
    return patient.age + '岁';
  }
  return patient[prop];
}
\`\`\`

### showPopover

- **类型**：`Boolean`
- **默认值**：`false`
- **描述**：是否显示tag的弹出框
- **示例**：`true`

### tagsModeTitle

- **类型**：`String`
- **默认值**：`''`
- **描述**：tags模式下的标题
- **示例**：`'患者信息'`

### showOtherInfo

- **类型**：`Boolean`
- **默认值**：`false`
- **描述**：是否显示其他信息（病史、习惯等）
- **示例**：`true`

## 🎨 高级用法

### 自定义字段格式化

通过`patientPropsFormatter`属性自定义字段值的显示格式。

\`\`\`vue
<template>
  <patient-info-viewer
    :patient="patientData"
    :patient-props="'real_name,gender,age,mobile'"
    :patient-props-formatter="formatPatientProp" />
</template>

<script>
export default {
  data() {
    return {
      patientData: {
        real_name: '张三',
        gender: 1,
        age: 30,
        mobile: '13800138000'
      }
    };
  },
  methods: {
    formatPatientProp(patient, prop) {
      // 格式化性别
      if (prop === 'gender') {
        return patient.gender === 1 ? '男' : '女';
      }
      // 格式化年龄
      if (prop === 'age') {
        return patient.age ? patient.age + '岁' : '未知';
      }
      // 格式化手机号
      if (prop === 'mobile') {
        return patient.mobile ? patient.mobile.replace(/(\d{3})\d{4}(\d{4})/, '$1****$2') : '';
      }
      // 默认返回原值
      return patient[prop];
    }
  }
};
</script>
\`\`\`

### 自定义标签主题

通过`tagsModeTheme`属性自定义标签的颜色、效果和尺寸。

\`\`\`vue
<template>
  <patient-info-viewer
    :patient="patientData"
    :patient-props="'real_name,gender,age'"
    display-mode="tags"
    :tags-mode-theme="customTheme" />
</template>

<script>
export default {
  data() {
    return {
      patientData: {
        real_name: '张三',
        gender: 1,
        age: 30
      },
      customTheme: [
        { type: 'success', effect: 'dark', size: 'medium' },
        { type: 'warning', effect: 'plain', size: 'small' },
        { type: 'info', effect: 'light', size: 'mini' }
      ]
    };
  }
};
</script>
\`\`\`

### 显示完整信息

通过`showOtherInfo`属性显示患者的病史、习惯等详细信息。

\`\`\`vue
<template>
  <patient-info-viewer
    :patient="patientData"
    :patient-props="'real_name,gender,age'"
    display-mode="tags"
    :show-other-info="true" />
</template>

<script>
export default {
  data() {
    return {
      patientData: {
        real_name: '张三',
        gender: 1,
        age: 30,
        medical_history: '高血压',
        eating_habits: '清淡',
        sprot_habits: '每周3次',
        medication_situation: '降压药'
      }
    };
  }
};
</script>
\`\`\`

## 🔧 字段配置

### 支持的字段

| 字段名 | 说明 | 类型 | 示例 | 备注 |
|--------|------|------|------|------|
| real_name | 姓名 | string | '张三' | 必需 |
| gender | 性别 | number | 1 | 1-男，2-女 |
| age | 年龄 | number | 30 | 可选 |
| mobile | 联系电话 | string | '13800138000' | 可选 |
| identity | 身份证号 | string | '110101199001011234' | 可选 |
| medical_history | 既往病史 | string | '高血压' | 可选 |
| eating_habits | 饮食习惯 | string | '清淡' | 可选 |
| sprot_habits | 运动习惯 | string | '每周3次' | 可选 |
| medication_situation | 用药情况 | string | '降压药' | 可选 |

### 字段组合建议

#### 基础信息
\`\`\`vue
:patient-props="'real_name,gender,age'"
\`\`\`
适用于：患者列表、摘要信息

#### 联系信息
\`\`\`vue
:patient-props="'real_name,gender,age,mobile'"
\`\`\`
适用于：联系方式页面

#### 完整信息
\`\`\`vue
:patient-props="'real_name,gender,age,mobile,identity'"
\`\`\`
适用于：患者详情页面

## 🎯 最佳实践

### 1. 选择合适的显示模式

**文本模式**：
- ✅ 适合空间有限的场景
- ✅ 信息紧凑，一目了然
- ✅ 适合列表展示
- ❌ 视觉层次不够突出

**标签模式**：
- ✅ 适合需要突出显示的场景
- ✅ 视觉层次清晰
- ✅ 支持交互（点击、悬浮）
- ❌ 占用空间较大

### 2. 合理配置显示字段

- 根据页面需求选择必要字段，避免信息过载
- 移动端建议显示3-5个核心字段
- PC端可以显示更多字段
- 优先显示用户最关心的信息

### 3. 利用格式化函数

- 对性别、年龄等字段进行格式化，提升可读性
- 对空值进行友好处理
- 对敏感信息进行脱敏处理
- 保持格式化逻辑简洁

### 4. 自定义主题和样式

- 根据页面风格选择合适的主题
- 保持主题风格一致
- 避免使用过多颜色
- 注意可读性

### 5. 处理空值和异常

- 组件会自动处理空值
- 建议在数据层面处理异常值
- 提供友好的占位符
- 避免显示undefined或null

## ❓ 常见问题

### Q: 如何自定义字段的显示顺序？

A: 通过`patientProps`属性控制，字段顺序即显示顺序：

\`\`\`vue
<patient-info-viewer
  :patient="patientData"
  :patient-props="'age,gender,real_name'" />
\`\`\`

显示顺序：年龄 → 性别 → 姓名

### Q: 标签模式下如何自定义标签颜色？

A: 通过`tagsModeTheme`属性配置：

\`\`\`vue
<patient-info-viewer
  :patient="patientData"
  display-mode="tags"
  :tags-mode-theme="[
    { type: 'success', effect: 'dark' },
    { type: 'warning', effect: 'plain' },
    { type: 'info', effect: 'light' }
  ]" />
\`\`\`

### Q: 如何处理患者信息为空的情况？

A: 组件会自动处理空值，显示为占位符或空字符串。也可以在数据层面处理：

\`\`\`javascript
// 数据层面处理
patientData.value = patientData.value || '暂无';
\`\`\`

### Q: 如何实现双击复制功能？

A: 组件内置了双击复制功能，无需额外配置。双击文本或标签即可复制内容。

### Q: 如何在全屏模式下查看详细信息？

A: 设置`showOtherInfo`为true，点击全屏按钮即可查看：

\`\`\`vue
<patient-info-viewer
  :patient="patientData"
  :show-other-info="true" />
\`\`\`

### Q: 组件支持响应式设计吗？

A: 是的，组件支持响应式设计，会自动适配不同屏幕尺寸。

### Q: 如何自定义文本模式的样式？

A: 通过`textModeStyle`属性自定义：

\`\`\`vue
<patient-info-viewer
  :patient="patientData"
  display-mode="text"
  :text-mode-style="{
    fontSize: '16px',
    color: '#333',
    fontWeight: 'bold'
  }" />
\`\`\`

## 📝 更新日志

### v1.0.0 (2026-01-22)
- ✨ 初始版本
- ✨ 支持文本和标签两种显示模式
- ✨ 支持自定义字段和格式化
- ✨ 支持双击复制功能
- ✨ 支持全屏查看详细信息
- 📝 完整的TypeScript类型支持

## 🔗 相关文档

- [组件开发规范](../../AGENTS.md)
- [TypeScript类型定义](./patient-info-viewer.d.ts)
- [项目组件总览](../README.md)
- [vk-unicloud-admin文档](https://vkdoc.fsq.pub/admin/)
- [Element UI文档](https://element.eleme.cn/#/zh-CN)

## 💡 提示

- 组件已全局注册，无需手动引入
- 确保传入的患者数据包含必需字段
- 建议使用计算属性处理患者数据
- 注意处理异步数据加载的情况
```

## 章节说明

### 📖 组件概述

简要描述组件的用途、功能和适用场景。

**内容要点**：
- 组件的主要功能
- 适用场景
- 解决的问题

### ✨ 主要特性

列出组件的核心特性，使用emoji图标增强可读性。

**内容要点**：
- 3-6个核心特性
- 每个特性一句话描述
- 使用emoji图标

### 🚀 基本用法

提供组件的基本使用示例，涵盖常见场景。

**内容要点**：
- 2-3个常见场景
- 完整的代码示例
- 清晰的效果说明

### 📦 Props API

详细说明所有props的用法。

**内容要点**：
- 按字母顺序或逻辑顺序排列
- 包含类型、默认值、描述、示例
- 复杂props提供详细说明

### 🎨 高级用法

提供高级功能和定制化用法。

**内容要点**：
- 2-3个高级场景
- 完整的代码示例
- 详细的实现说明

### 🔧 配置选项

提供可配置的选项和参数。

**内容要点**：
- 使用表格展示
- 包含值和说明
- 提供示例

### 🎯 最佳实践

提供使用组件的最佳实践和建议。

**内容要点**：
- 3-5个实践建议
- 每个实践包含说明和理由
- 提供正面和反面示例

### ❓ 常见问题

提供常见问题的解答。

**内容要点**：
- 5-10个常见问题
- 每个问题包含清晰的回答
- 提供代码示例

### 📝 更新日志

记录组件的版本更新历史。

**内容要点**：
- 按时间倒序排列
- 使用emoji标记变更类型
- 简洁描述变更内容

### 🔗 相关文档

提供相关文档的链接。

**内容要点**：
- 内部文档链接
- 外部文档链接
- 相关资源链接

## 编写规范

### 1. 使用emoji图标

为每个章节添加合适的emoji图标，增强可读性：

```markdown
📖 组件概述
✨ 主要特性
🚀 基本用法
📦 Props API
🎨 高级用法
🔧 配置选项
🎯 最佳实践
❓ 常见问题
📝 更新日志
🔗 相关文档
```

### 2. 代码示例

- 使用完整的代码示例
- 包含template和script部分
- 添加必要的注释
- 确保代码可运行

### 3. 表格使用

- 使用表格展示配置选项
- 包含值、说明、示例等列
- 保持表格简洁清晰

### 4. 链接使用

- 使用相对路径链接内部文档
- 使用绝对路径链接外部文档
- 确保链接有效

### 5. 格式统一

- 使用统一的章节结构
- 使用统一的代码格式
- 使用统一的标点符号

## 检查清单

在完成README.md后，检查以下项目：

- [ ] 包含所有必需章节
- [ ] 代码示例完整可运行
- [ ] Props API完整准确
- [ ] 最佳实践实用可行
- [ ] 常见问题覆盖全面
- [ ] 更新日志记录完整
- [ ] 相关文档链接有效
- [ ] 格式统一规范
- [ ] 无错别字和语法错误
- [ ] 与JSDoc和.d.ts信息一致
