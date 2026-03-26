# API 参考

本文档提供 vk-unicloud-admin 自定义组件的完整 API 参考。

## 目录

- [Props](#props)
  - [value](#value)
  - [column](#column)
  - [scene](#scene)
- [Events](#events)
  - [input](#input)
  - [change](#change)
- [Column 对象属性](#column-对象属性)
- [Scene 值](#scene-值)

## Props

### value

**类型**：`String | Number | Boolean | Object | Array`

**默认值**：`""`

**描述**：双向绑定的值，用于表单数据绑定和表格数据显示。

**使用场景**：
- **form**：表单输入的当前值
- **table**：表格单元格显示的值
- **detail**：详情页显示的值

**示例**：
```javascript
props: {
  value: {
    type: [String, Number, Boolean, Object, Array],
    default: ""
  }
}
```

### column

**类型**：`Object`

**默认值**：`function() { return {}; }`

**描述**：字段规则配置对象，包含字段的元数据和配置信息。

**常用属性**：
- `key`：字段标识
- `title`：字段标题
- `type`：字段类型（固定为 "custom"）
- `component`：组件名称（如 "custom-aaa"）
- `placeholder`：占位符文本
- `disabled`：是否禁用
- `readonly`：是否只读
- `required`：是否必填
- `rules`：验证规则

**示例**：
```javascript
props: {
  column: {
    type: Object,
    default: function() {
      return {};
    }
  }
}
```

### scene

**类型**：`String`

**默认值**：`"form"`

**描述**：当前组件的使用场景。

**可选值**：
- `"form"`：万能表单场景
- `"table"`：万能表格场景
- `"detail"`：表格详情页场景

**示例**：
```javascript
props: {
  scene: {
    type: String,
    default: "form"
  }
}
```

## Events

### input

**参数**：`value`（任意类型）

**描述**：表单双向绑定必需事件，用于更新父组件的值。

**触发时机**：用户修改输入值时

**触发顺序**：必须在 change 事件之前触发

**示例**：
```javascript
methods: {
  _input(value) {
    this.$emit("input", value);
  }
}
```

### change

**参数**：`value`（任意类型）

**描述**：值变化事件，用于父组件的 watch 监听。

**触发时机**：用户修改输入值时

**触发顺序**：必须在 input 事件之后触发

**示例**：
```javascript
methods: {
  _input(value) {
    this.$emit("input", value);
    this.$emit("change", value);
  }
}
```

## Column 对象属性

### 基础属性

| 属性 | 类型 | 必填 | 描述 |
|------|------|------|------|
| `key` | String | 是 | 字段标识，对应数据对象的键名 |
| `title` | String | 是 | 字段标题，显示在表单标签或表头 |
| `type` | String | 是 | 字段类型，自定义组件固定为 "custom" |
| `component` | String | 是 | 组件名称，格式为 "custom-组件名" |

### 显示属性

| 属性 | 类型 | 默认值 | 描述 |
|------|------|--------|------|
| `placeholder` | String | - | 输入框占位符文本 |
| `disabled` | Boolean | false | 是否禁用 |
| `readonly` | Boolean | false | 是否只读 |
| `hidden` | Boolean | false | 是否隐藏 |

### 验证属性

| 属性 | 类型 | 默认值 | 描述 |
|------|------|--------|------|
| `required` | Boolean | false | 是否必填 |
| `rules` | Array | [] | 验证规则数组 |

### 其他属性

| 属性 | 类型 | 默认值 | 描述 |
|------|------|--------|------|
| `defaultValue` | Any | - | 默认值 |
| `tip` | String | - | 提示信息 |
| `width` | Number | - | 表格列宽度（px） |
| `minWidth` | Number | - | 表格列最小宽度（px） |

## Scene 值

### form（万能表单）

**描述**：组件在万能表单中使用，需要支持用户输入和数据绑定。

**要求**：
- 必须提供 input 事件
- 必须提供 change 事件
- 事件触发顺序：先 input，再 change
- 应支持 disabled、readonly 等状态

**示例**：
```vue
<template>
  <view v-if="scene === 'form'">
    <el-input
      :value="value"
      :disabled="column.disabled"
      :placeholder="column.placeholder"
      @input="_input"
    ></el-input>
  </view>
</template>
```

### table（万能表格）

**描述**：组件在万能表格的单元格中显示，用于展示数据。

**要求**：
- 根据 value 值进行渲染
- 通常不需要交互功能
- 应考虑表格单元格的空间限制

**示例**：
```vue
<template>
  <view v-else-if="scene === 'table'">
    <text>{{ value }}</text>
  </view>
</template>
```

### detail（表格详情）

**描述**：组件在表格详情页中显示，用于展示完整数据。

**要求**：
- 根据 value 值进行渲染
- 可以展示比 table 场景更详细的信息
- 可以包含交互功能（如点击查看详情）

**示例**：
```vue
<template>
  <view v-else-if="scene === 'detail'">
    <text>{{ value }}</text>
  </view>
</template>
```

## 完整组件示例

```vue
<template>
  <!-- 万能表单 -->
  <view v-if="scene === 'form'">
    <el-input
      :value="value"
      :disabled="column.disabled"
      :placeholder="column.placeholder"
      @input="_input"
    ></el-input>
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
    // 当前场景
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
