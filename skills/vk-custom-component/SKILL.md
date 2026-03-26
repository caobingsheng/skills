---
name: vk-custom-component
description: "Use when developing custom components for vk-unicloud-admin framework's universal table and form system. Especially when: (1) Creating new custom components with `custom-` prefix, (2) Implementing components that work across form/table/detail scenarios, (3) Understanding component props (value, column, scene), events (input, change), and lifecycle requirements. Covers component structure, naming conventions, scenario-specific implementations, and integration with vk-data-form and vk-data-table."
license: MIT
---

# VK Custom Component Development

## Overview

本 skill 提供 vk-unicloud-admin 框架自定义组件开发的完整指导。vk-unicloud-admin 框架的万能表单和万能表格支持通过自定义组件扩展功能，开发者可以创建满足特定业务需求的组件。

自定义组件支持三种使用场景：
- **form**：在万能表单中使用，需要支持用户输入和数据绑定
- **table**：在万能表格的单元格中显示，用于展示数据
- **detail**：在表格详情页中显示，可以展示更详细的信息

## Quick Start

### 1. 创建组件文件

在项目根目录的 `components` 目录下创建组件文件，文件名必须使用 `custom-组件名` 格式：

```
components/
  custom-aaa/
    custom-aaa.vue
```

### 2. 基础组件模板

```vue
<template>
  <!-- 万能表单 -->
  <view v-if="scene === 'form'">
    <el-input :value="value" @input="_input"></el-input>
  </view>
  <!-- 万能表格 -->
  <view v-else-if="scene === 'table'">
    <text>{{ value }}</text>
  </view>
  <!-- 万能表格详情 -->
  <view v-else-if="scene === 'detail'">
    <text>{{ value }}</text>
  </view>
</template>

<script>
export default {
  props: {
    // 双向绑定的值
    value: {
      type: [String, Number, Boolean, Object, Array],
      default: ""
    },
    // 字段规则
    column: {
      type: Object,
      default: function() {
        return {};
      }
    },
    // 当前场景：form/table/detail
    scene: {
      type: String,
      default: "form"
    }
  },
  data() {
    return {};
  },
  mounted() {},
  methods: {
    _input(value) {
      // 固定顺序：先 input，再 change
      this.$emit("input", value);
      this.$emit("change", value);
    }
  },
  watch: {},
  computed: {}
};
</script>

<style lang="scss" scoped>
</style>
```

### 3. 在表单或表格中使用

在 vk-data-form 或 vk-data-table 的 columns 配置中使用：

```javascript
{
  key: "key1",
  title: "我是自定义组件",
  type: "custom",
  component: "custom-aaa"
}
```

## Key Concepts

### 命名规范

组件目录和文件必须使用 `custom-组件名` 格式：
- 目录：`components/custom-aaa/`
- 文件：`custom-aaa.vue`
- 组件名：`custom-aaa`

### 三种场景

组件需要支持三种使用场景：

1. **form（万能表单）**
   - 需要支持用户输入
   - 必须提供 `input` 和 `change` 事件
   - 事件触发顺序：先 `input`，再 `change`
   - 应支持 `disabled`、`readonly` 等状态

2. **table（万能表格）**
   - 根据 `value` 值进行渲染
   - 通常不需要交互功能
   - 应考虑表格单元格的空间限制

3. **detail（表格详情）**
   - 根据 `value` 值进行渲染
   - 可以展示比 table 场景更详细的信息
   - 可以包含交互功能

### Props

自定义组件接收以下 props：

| Prop | 类型 | 默认值 | 描述 |
|------|------|--------|------|
| `value` | Any | `""` | 双向绑定的值 |
| `column` | Object | `{}` | 字段规则配置对象 |
| `scene` | String | `"form"` | 当前场景（form/table/detail） |

### Events

自定义组件需要触发以下事件：

| Event | 参数 | 描述 | 触发时机 |
|-------|------|------|----------|
| `input` | value | 表单双向绑定必需事件 | 用户修改输入值时 |
| `change` | value | 值变化事件 | 用户修改输入值时 |

**重要**：事件触发顺序必须是先 `input`，再 `change`。

## Workflow

### 步骤1：创建组件文件

在 `components` 目录下创建组件目录和文件：

```
components/
  custom-组件名/
    custom-组件名.vue
```

### 步骤2：实现组件模板

根据三种场景实现组件模板：

```vue
<template>
  <!-- form 场景 -->
  <view v-if="scene === 'form'">
    <!-- 表单输入组件 -->
  </view>
  <!-- table 场景 -->
  <view v-else-if="scene === 'table'">
    <!-- 表格显示组件 -->
  </view>
  <!-- detail 场景 -->
  <view v-else-if="scene === 'detail'">
    <!-- 详情显示组件 -->
  </view>
</template>
```

### 步骤3：实现组件逻辑

1. 定义 props（value、column、scene）
2. 实现 data、computed、watch
3. 实现 methods（包括 _input 或 _change 方法）
4. 在 mounted 中初始化组件

### 步骤4：实现 form 场景

form 场景需要：
- 支持用户输入
- 触发 input 和 change 事件
- 支持 disabled、readonly 等状态

```javascript
methods: {
  _input(value) {
    this.$emit("input", value);
    this.$emit("change", value);
  }
}
```

### 步骤5：实现 table 和 detail 场景

table 和 detail 场景需要：
- 根据 value 值进行渲染
- 考虑显示空间和样式

```vue
<view v-else-if="scene === 'table'">
  <text>{{ value }}</text>
</view>
```

### 步骤6：测试组件

在表单或表格中测试组件：
- form 场景：输入值是否正确绑定
- table 场景：值是否正确显示
- detail 场景：值是否正确显示
- 边界情况：空值、undefined、null 处理

### 步骤7：集成到项目

在 vk-data-form 或 vk-data-table 的 columns 配置中使用组件：

```javascript
// 表单配置
form1: {
  props: {
    columns: [
      {
        key: "field_name",
        title: "字段标题",
        type: "custom",
        component: "custom-组件名"
      }
    ]
  }
}

// 表格配置
table1: {
  columns: [
    {
      key: "field_name",
      title: "列标题",
      type: "custom",
      component: "custom-组件名",
      width: 150
    }
  ]
}
```

## Scenario Implementation

### Form 场景实现

form 场景用于万能表单，需要支持用户输入和数据绑定。

**要求**：
- 必须提供 `input` 事件
- 必须提供 `change` 事件
- 事件触发顺序：先 `input`，再 `change`
- 应支持 `disabled`、`readonly` 等状态

**示例**：
```vue
<view v-if="scene === 'form'">
  <el-input
    :value="value"
    :disabled="column.disabled"
    :readonly="column.readonly"
    :placeholder="column.placeholder"
    @input="_input"
  ></el-input>
</view>
```

### Table 场景实现

table 场景用于万能表格的单元格，用于展示数据。

**要求**：
- 根据 `value` 值进行渲染
- 通常不需要交互功能
- 应考虑表格单元格的空间限制

**示例**：
```vue
<view v-else-if="scene === 'table'">
  <text>{{ value }}</text>
</view>
```

### Detail 场景实现

detail 场景用于表格详情页，可以展示更详细的信息。

**要求**：
- 根据 `value` 值进行渲染
- 可以展示比 table 场景更详细的信息
- 可以包含交互功能

**示例**：
```vue
<view v-else-if="scene === 'detail'">
  <text>{{ value }}</text>
</view>
```

## Best Practices

### 1. 事件触发顺序

必须先触发 `input` 事件，再触发 `change` 事件：

```javascript
// ✅ 正确
methods: {
  _input(value) {
    this.$emit("input", value);
    this.$emit("change", value);
  }
}

// ❌ 错误
methods: {
  _input(value) {
    this.$emit("change", value);
    this.$emit("input", value);
  }
}
```

### 2. 命名规范

组件目录和文件必须使用 `custom-组件名` 格式：

```
✅ 正确：custom-aaa/custom-aaa.vue
❌ 错误：aaa/aaa.vue
❌ 错误：custom-aaa/aaa.vue
```

### 3. Props 类型定义

正确定义 props 的类型，支持多种数据类型：

```javascript
props: {
  value: {
    type: [String, Number, Boolean, Object, Array],
    default: ""
  }
}
```

### 4. 样式隔离

使用 `scoped` 限制样式作用域：

```vue
<style lang="scss" scoped>
.custom-component {
  // 组件样式
}
</style>
```

### 5. 错误处理

正确处理异步操作和错误情况：

```javascript
async loadRemoteData() {
  this.loading = true;
  try {
    const res = await vk.callFunction({
      url: this.column.action,
      data: {}
    });
    if (res.code === 0) {
      this.options = res.list;
    } else {
      vk.toast(res.msg || "加载失败");
    }
  } catch (error) {
    console.error("加载失败：", error);
    vk.toast("加载失败");
  } finally {
    this.loading = false;
  }
}
```

### 6. 性能优化

使用计算属性、防抖节流等技术优化性能：

```javascript
computed: {
  displayValue() {
    if (!this.value) return "";
    if (this.column.formatter) {
      return this.column.formatter(this.value);
    }
    return this.value;
  }
}
```

## References

### API 详细参考

完整的 Props、Events、Column 对象属性说明，参见 [API 参考](references/api.md)。

### 完整示例代码

包含以下组件的完整实现代码：
- 简单文本输入组件
- 复杂选择器组件
- 文件上传组件
- 富文本编辑器组件
- 日期时间选择组件

参见 [完整示例](references/examples.md)。

### 高级用法和最佳实践

包含以下内容：
- 复杂组件开发技巧
- 与其他 VK 组件集成
- 性能优化策略
- 常见问题和解决方案
- 组件测试方法
- 组件发布和分享

参见 [高级用法](references/advanced.md)。
