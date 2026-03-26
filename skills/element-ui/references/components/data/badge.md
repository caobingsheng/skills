# Badge 标记

出现在按钮、图标旁的数字或状态标记。

## 基础用法

### 基础用法
展示新消息数量。定义 `value` 属性，它接受 `Number` 或者 `String`。

```vue
<el-badge :value="12" class="item">
  <el-button size="small">评论</el-button>
</el-badge>

<el-badge :value="3" class="item">
  <el-button size="small">回复</el-button>
</el-badge>

<el-badge :value="1" class="item" type="primary">
  <el-button size="small">评论</el-button>
</el-badge>

<el-badge :value="2" class="item" type="warning">
  <el-button size="small">回复</el-button>
</el-badge>

<style>
.item {
  margin-top: 10px;
  margin-right: 40px;
}
</style>
```

### 最大值
可自定义最大值。由 `max` 属性定义，它接受一个 `Number`，需要注意的是，只有当 `value` 为 `Number` 时，它才会生效。

```vue
<el-badge :value="200" :max="99" class="item">
  <el-button size="small">评论</el-button>
</el-badge>

<el-badge :value="100" :max="10" class="item">
  <el-button size="small">回复</el-button>
</el-badge>
```

### 自定义内容
可以显示数字以外的文本内容。定义 `value` 为 `String` 类型是时可以用于显示自定义文本。

```vue
<el-badge value="new" class="item">
  <el-button size="small">评论</el-button>
</el-badge>

<el-badge value="hot" class="item">
  <el-button size="small">回复</el-button>
</el-badge>
```

### 小红点
以红点的形式标注需要关注的内容。除了数字外，设置 `is-dot` 属性，它接受一个 `Boolean`。

```vue
<el-badge is-dot class="item">数据查询</el-badge>

<el-badge is-dot class="item">
  <el-button class="share-button" icon="el-icon-share" type="primary"></el-button>
</el-badge>
```

## Attributes

| 参数 | 说明 | 类型 | 可选值 | 默认值 |
|------|------|------|--------|--------|
| value | 显示值 | string, number | — | — |
| max | 最大值，超过最大值会显示 '{max}+'，要求 value 是 Number 类型 | number | — | — |
| is-dot | 小圆点 | boolean | — | false |
| hidden | 隐藏 badge | boolean | — | false |
| type | 类型 | string | primary / success / warning / danger / info | — |

## 最佳实践

1. **消息提醒**: 使用Badge显示未读消息数量,配合图标或按钮使用
2. **最大值限制**: 使用`max`属性限制显示的最大值,避免数字过大影响布局
3. **自定义内容**: 使用`value`属性传入字符串,显示自定义文本内容
4. **类型区分**: 使用`type`属性区分不同类型的标记(primary/success/warning/danger/info)
5. **位置调整**: Badge会自动定位到元素的右上角,无需手动调整
6. **独立使用**: Badge可以独立使用,不依赖其他组件
7. **动态更新**: 通过绑定变量动态更新Badge的值,实现实时提醒
8. **隐藏标记**: 当value为0时,Badge会自动隐藏,可通过`is-dot`属性显示小圆点

## 使用场景

### 消息提醒
```vue
<el-badge :value="unreadCount" :max="99" class="item">
  <el-button size="small">消息</el-button>
</el-badge>

<el-badge :value="12" class="item">
  <el-button size="small">回复</el-button>
</el-badge>
```

### 导航菜单标记
```vue
<el-menu>
  <el-menu-item index="1">
    <el-badge :value="3" class="badge-item">
      <span>待办事项</span>
    </el-badge>
  </el-menu-item>
  <el-menu-item index="2">
    <el-badge :value="99+" class="badge-item">
      <span>消息通知</span>
    </el-badge>
  </el-menu-item>
</el-menu>
```

### 状态标记
```vue
<el-badge value="new" class="item">
  <el-button>新功能</el-button>
</el-badge>

<el-badge value="hot" class="item" type="danger">
  <el-button>热门</el-button>
</el-badge>
```

### 小圆点标记
```vue
<el-badge is-dot class="item">数据查询</el-badge>
<el-badge is-dot class="item">系统设置</el-badge>
```

### 图标标记
```vue
<el-badge :value="5" class="item">
  <i class="el-icon-bell" style="font-size: 20px;"></i>
</el-badge>

<el-badge :value="12" class="item">
  <i class="el-icon-message" style="font-size: 20px;"></i>
</el-badge>
```
