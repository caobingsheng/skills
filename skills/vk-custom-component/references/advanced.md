# 高级用法和最佳实践

本文档提供 vk-unicloud-admin 自定义组件的高级用法和最佳实践。

## 目录

- [复杂组件开发技巧](#复杂组件开发技巧)
- [与其他 VK 组件集成](#与其他-vk-组件集成)
- [性能优化策略](#性能优化策略)
- [常见问题和解决方案](#常见问题和解决方案)
- [组件测试方法](#组件测试方法)
- [组件发布和分享](#组件发布和分享)

## 复杂组件开发技巧

### 1. 使用计算属性优化渲染

当组件需要根据 value 或 column 进行动态计算时，使用计算属性可以提高性能。

```javascript
computed: {
  // 计算显示值
  displayValue() {
    if (!this.value) return "";
    if (this.column.formatter) {
      return this.column.formatter(this.value);
    }
    return this.value;
  },
  // 计算是否禁用
  isDisabled() {
    return this.column.disabled || this.column.readonly;
  }
}
```

### 2. 使用监听器响应外部变化

当需要监听 value 或 column 的变化时，使用 watch 监听器。

```javascript
watch: {
  value: {
    handler(newVal, oldVal) {
      if (newVal !== oldVal) {
        this.loadData();
      }
    },
    immediate: true
  },
  "column.action": {
    handler(newVal) {
      if (newVal) {
        this.loadRemoteData();
      }
    },
    immediate: true
  }
}
```

### 3. 使用生命周期钩子初始化组件

在 mounted 钩子中进行组件初始化，如加载数据、注册事件等。

```javascript
mounted() {
  // 加载初始数据
  if (this.column.action) {
    this.loadRemoteData();
  }
  // 注册全局事件
  if (this.column.eventName) {
    this.$on(this.column.eventName, this.handleEvent);
  }
},
beforeDestroy() {
  // 清理事件监听
  if (this.column.eventName) {
    this.$off(this.column.eventName, this.handleEvent);
  }
}
```

### 4. 使用 provide/inject 实现跨层级通信

当组件需要与父组件或祖先组件通信时，可以使用 provide/inject。

```javascript
// 祖先组件
export default {
  provide() {
    return {
      customComponentContext: this
    };
  }
}

// 后代组件
export default {
  inject: ["customComponentContext"],
  methods: {
    callParentMethod() {
      if (this.customComponentContext) {
        this.customComponentContext.parentMethod();
      }
    }
  }
}
```

### 5. 使用插槽增强组件灵活性

通过插槽让父组件可以自定义组件的部分内容。

```vue
<template>
  <view v-if="scene === 'form'">
    <el-input :value="value" @input="_input">
      <!-- 前置插槽 -->
      <template v-if="$slots.prepend" slot="prepend">
        <slot name="prepend"></slot>
      </template>
      <!-- 后置插槽 -->
      <template v-if="$slots.append" slot="append">
        <slot name="append"></slot>
      </template>
    </el-input>
  </view>
</template>
```

## 与其他 VK 组件集成

### 1. 与 vk-data-form 集成

自定义组件可以与 vk-data-form 无缝集成，享受表单验证、数据绑定等功能。

```javascript
// 在表单配置中使用
form1: {
  props: {
    columns: [
      {
        key: "custom_field",
        title: "自定义字段",
        type: "custom",
        component: "custom-my-component",
        rules: [
          { required: true, message: "该字段为必填项" }
        ]
      }
    ]
  }
}
```

### 2. 与 vk-data-table 集成

自定义组件可以在表格的列配置中使用，实现自定义显示。

```javascript
// 在表格配置中使用
table1: {
  columns: [
    {
      key: "custom_field",
      title: "自定义列",
      type: "custom",
      component: "custom-my-component",
      width: 150
    }
  ]
}
```

### 3. 与 vk-unicloud 云函数集成

自定义组件可以调用云函数获取数据或提交数据。

```javascript
methods: {
  async loadRemoteData() {
    try {
      const res = await vk.callFunction({
        url: this.column.action,
        data: {
          query: this.searchQuery
        }
      });
      this.options = res.list;
    } catch (error) {
      vk.toast("加载数据失败");
    }
  }
}
```

### 4. 与 Vuex 状态管理集成

自定义组件可以访问和修改 Vuex 状态。

```javascript
computed: {
  // 从 Vuex 获取状态
  userInfo() {
    return vk.getVuex("$user.userInfo");
  }
},
methods: {
  // 修改 Vuex 状态
  updateState() {
    vk.setVuex("$app.customData", this.value);
  }
}
```

## 性能优化策略

### 1. 避免不必要的重新渲染

使用 v-once 指令渲染静态内容，避免不必要的更新。

```vue
<template>
  <view v-if="scene === 'table'">
    <text v-once>{{ staticLabel }}</text>
  </view>
</template>
```

### 2. 使用 Object.freeze 冻结不需要响应式的数据

对于大型数据集，使用 Object.freeze 可以提高性能。

```javascript
data() {
  return {
    options: Object.freeze(largeDataArray)
  };
}
```

### 3. 使用函数式组件

对于简单的展示型组件，使用函数式组件可以提高性能。

```javascript
export default {
  functional: true,
  render(h, { props }) {
    return h("text", props.value);
  }
}
```

### 4. 防抖和节流

对于频繁触发的事件（如输入、滚动），使用防抖和节流。

```javascript
import { debounce } from "lodash";

export default {
  methods: {
    search: debounce(function(query) {
      this.loadRemoteData(query);
    }, 300)
  }
}
```

### 5. 懒加载和按需加载

对于复杂的组件，可以使用懒加载和按需加载。

```javascript
// 懒加载组件
components: {
  HeavyComponent: () => import("./HeavyComponent.vue")
}
```

## 常见问题和解决方案

### 问题1：事件不触发

**症状**：修改输入值后，表单数据没有更新。

**原因**：没有正确触发 input 和 change 事件，或者触发顺序错误。

**解决方案**：
```javascript
// 错误示例
methods: {
  _input(value) {
    this.$emit("change", value); // 错误：先触发了 change
    this.$emit("input", value);
  }
}

// 正确示例
methods: {
  _input(value) {
    this.$emit("input", value); // 正确：先触发 input
    this.$emit("change", value);
  }
}
```

### 问题2：表格显示异常

**症状**：组件在表格中显示不正常，影响布局。

**原因**：组件在 table 场景下没有正确处理样式或布局。

**解决方案**：
```vue
<template>
  <view v-else-if="scene === 'table'">
    <!-- 使用内联样式控制布局 -->
    <text :style="{ maxWidth: column.width + 'px' }">{{ value }}</text>
  </view>
</template>

<style lang="scss" scoped>
// 避免使用影响布局的样式
text {
  display: inline-block;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
</style>
```

### 问题3：数据类型不匹配

**症状**：组件接收到的 value 类型与预期不符。

**原因**：没有正确定义 props 的类型，或者父组件传递的数据类型错误。

**解决方案**：
```javascript
props: {
  value: {
    type: [String, Number, Boolean, Object, Array], // 支持多种类型
    default: ""
  }
}
```

### 问题4：异步数据加载失败

**症状**：组件无法正确加载远程数据。

**原因**：没有正确处理异步操作或错误。

**解决方案**：
```javascript
methods: {
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
}
```

### 问题5：组件样式冲突

**症状**：组件样式被全局样式覆盖或影响其他组件。

**原因**：没有正确使用 scoped 或样式优先级不够。

**解决方案**：
```vue
<style lang="scss" scoped>
// 使用 scoped 限制样式作用域
.custom-component {
  // 使用 ::v-deep 修改子组件样式
  ::v-deep .el-input__inner {
    border-color: #409eff;
  }
}
</style>
```

## 组件测试方法

### 1. 单元测试

使用 Jest 或 Mocha 进行单元测试。

```javascript
import { mount } from "@vue/test-utils";
import CustomComponent from "./custom-component.vue";

describe("CustomComponent", () => {
  it("应该正确触发 input 事件", async () => {
    const wrapper = mount(CustomComponent, {
      propsData: {
        value: "",
        scene: "form"
      }
    });

    await wrapper.vm._input("test");
    expect(wrapper.emitted("input")).toBeTruthy();
    expect(wrapper.emitted("input")[0]).toEqual(["test"]);
  });
});
```

### 2. 集成测试

在实际页面中测试组件的集成效果。

```javascript
// 在测试页面中使用
{
  key: "test_field",
  title: "测试字段",
  type: "custom",
  component: "custom-test-component"
}
```

### 3. 手动测试清单

- [ ] 表单场景：输入值是否正确绑定
- [ ] 表单场景：input 和 change 事件是否按顺序触发
- [ ] 表单场景：disabled、readonly 状态是否生效
- [ ] 表单场景：验证规则是否生效
- [ ] 表格场景：值是否正确显示
- [ ] 表格场景：样式是否正常
- [ ] 表格场景：是否影响表格布局
- [ ] 详情场景：值是否正确显示
- [ ] 详情场景：样式是否正常
- [ ] 边界情况：空值处理
- [ ] 边界情况：undefined、null 处理
- [ ] 边界情况：异常值处理

## 组件发布和分享

### 1. 组件文档

为组件编写完整的文档，包括：
- 组件功能说明
- Props 说明
- Events 说明
- 使用示例
- 注意事项

### 2. 组件示例

提供完整的使用示例，包括：
- 基础用法
- 高级用法
- 常见场景

### 3. 组件测试

确保组件经过充分测试，包括：
- 单元测试
- 集成测试
- 手动测试

### 4. 组件发布

将组件发布到 GitHub 或 Gitee，并提交到 vk-unicloud 文档仓库。

**提交地址**：https://gitee.com/vk-uni/vk-unicloud-docs/edit/master/docs/admin/custom-components/custom-components-list.md

**提交格式**：
```markdown
### 组件名称

**作者**：你的名字或昵称
**仓库**：https://github.com/your-repo/custom-component
**描述**：组件功能描述

#### 功能特性

- 功能1
- 功能2
- 功能3

#### 使用示例

\`\`\`javascript
{
  key: "field_name",
  title: "字段标题",
  type: "custom",
  component: "custom-component-name"
}
\`\`\`
```

### 5. 组件维护

- 及时修复 bug
- 添加新功能
- 更新文档
- 回应用户问题

## 最佳实践总结

1. **命名规范**：组件目录和文件必须使用 `custom-组件名` 格式
2. **事件顺序**：必须先触发 input 事件，再触发 change 事件
3. **场景判断**：使用 scene 属性判断当前场景，提供不同的实现
4. **类型定义**：正确定义 props 的类型，支持多种数据类型
5. **错误处理**：正确处理异步操作和错误情况
6. **性能优化**：使用计算属性、防抖节流等技术优化性能
7. **样式隔离**：使用 scoped 限制样式作用域
8. **文档完善**：提供完整的文档和示例
9. **充分测试**：进行单元测试、集成测试和手动测试
10. **持续维护**：及时修复 bug，添加新功能，更新文档
