# Popconfirm 气泡确认框

点击元素，弹出气泡确认框。

## 基础用法

Popconfirm 的属性与 Popover 很类似，因此对于重复属性，请参考 Popover 的文档，在此文档中不做详尽解释。

在 Popconfirm 中，只有 `title` 属性可用，`content` 属性不会被展示。

```vue
<template>
  <el-popconfirm title="这是一段内容确定删除吗？">
    <el-button slot="reference">删除</el-button>
  </el-popconfirm>
</template>
```

## 自定义

可以在 Popconfirm 中自定义内容。

```vue
<template>
  <el-popconfirm
    confirm-button-text='好的'
    cancel-button-text='不用了'
    icon="el-icon-info"
    icon-color="red"
    title="这是一段内容确定删除吗？">
    <el-button slot="reference">删除</el-button>
  </el-popconfirm>
</template>
```

## Attributes

| 参数 | 说明 | 类型 | 可选值 | 默认值 |
|------|------|------|--------|--------|
| title | 标题 | String | — | — |
| confirm-button-text | 确认按钮文字 | String | — | — |
| cancel-button-text | 取消按钮文字 | String | — | — |
| confirm-button-type | 确认按钮类型 | String | — | Primary |
| cancel-button-type | 取消按钮类型 | String | — | Text |
| icon | Icon | String | — | el-icon-question |
| icon-color | Icon 颜色 | String | — | #f90 |
| hide-icon | 是否隐藏 Icon | Boolean | — | false |

## Slot

| 参数 | 说明 |
|------|------|
| reference | 触发 Popconfirm 显示的 HTML 元素 |

## Events

| 事件名称 | 说明 | 回调参数 |
|----------|------|----------|
| confirm | 点击确认按钮时触发 | — |
| cancel | 点击取消按钮时触发 | — |

## 最佳实践

1. **确认操作**: 使用Popconfirm进行危险操作的二次确认,如删除、取消等
2. **自定义文本**: 使用`title`属性设置确认文本,清晰说明操作后果
3. **按钮文本**: 使用`confirm-button-text`和`cancel-button-text`自定义按钮文本
4. **按钮类型**: 使用`confirm-button-type`和`cancel-button-type`设置按钮类型
5. **图标设置**: 使用`icon`属性设置图标,`icon-color`设置图标颜色
6. **事件处理**: 使用`@confirm`和`@cancel`事件处理确认和取消操作
7. **禁用状态**: 使用`disabled`属性禁用确认框
8. **宽度设置**: 使用`width`属性设置确认框宽度

## 使用场景

### 删除确认
```vue
<el-popconfirm
  title="确定删除这条数据吗?"
  @confirm="handleDelete"
  @cancel="handleCancel">
  <el-button slot="reference" type="danger" size="small">删除</el-button>
</el-popconfirm>

<script>
export default {
  methods: {
    handleDelete() {
      this.$message.success('删除成功');
    },
    handleCancel() {
      this.$message.info('已取消删除');
    }
  }
}
</script>
```

### 自定义按钮文本
```vue
<el-popconfirm
  title="确定要退出登录吗?"
  confirm-button-text="确定退出"
  cancel-button-text="继续使用"
  @confirm="handleLogout">
  <el-button slot="reference">退出登录</el-button>
</el-popconfirm>
```

### 自定义图标
```vue
<el-popconfirm
  title="此操作不可恢复,确定继续吗?"
  icon="el-icon-warning"
  icon-color="#f56c6c"
  @confirm="handleConfirm">
  <el-button slot="reference" type="warning">危险操作</el-button>
</el-popconfirm>
```

### 带描述的确认
```vue
<el-popconfirm
  title="确定删除吗?"
  confirm-button-text="确定"
  cancel-button-text="取消"
  icon="el-icon-info"
  icon-color="#409EFF">
  <div slot="reference">
    <el-button type="danger">删除</el-button>
  </div>
  <template>
    <p>删除后将无法恢复,请谨慎操作</p>
  </template>
</el-popconfirm>
```

### 表格操作
```vue
<el-table :data="tableData">
  <el-table-column prop="name" label="姓名"></el-table-column>
  <el-table-column label="操作" width="200">
    <template slot-scope="scope">
      <el-popconfirm
        title="确定删除吗?"
        @confirm="handleDelete(scope.row)">
        <el-button slot="reference" type="text" size="small">删除</el-button>
      </el-popconfirm>
    </template>
  </el-table-column>
</el-table>
```

### 禁用状态
```vue
<el-popconfirm
  title="确定删除吗?"
  :disabled="!canDelete"
  @confirm="handleDelete">
  <el-button slot="reference" type="danger" :disabled="!canDelete">删除</el-button>
</el-popconfirm>
```

### 自定义宽度
```vue
<el-popconfirm
  title="确定要执行此操作吗?此操作可能会影响系统性能,建议在非高峰期执行。"
  width="300"
  @confirm="handleConfirm">
  <el-button slot="reference">执行操作</el-button>
</el-popconfirm>
```
