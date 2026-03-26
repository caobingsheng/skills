# Alert 警告

Alert 警告用于页面中展示重要的提示信息。

## 基础用法

### 基本用法
```vue
<template>
  <el-alert title="成功提示的文案" type="success"></el-alert>
  <el-alert title="消息提示的文案" type="info"></el-alert>
  <el-alert title="警告提示的文案" type="warning"></el-alert>
  <el-alert title="错误提示的文案" type="error"></el-alert>
</template>
```

### 主题
```vue
<template>
  <el-alert title="成功提示的文案" type="success" effect="dark"></el-alert>
  <el-alert title="消息提示的文案" type="info" effect="dark"></el-alert>
  <el-alert title="警告提示的文案" type="warning" effect="dark"></el-alert>
  <el-alert title="错误提示的文案" type="error" effect="dark"></el-alert>
</template>
```

### 自定义关闭按钮
```vue
<template>
  <el-alert title="不可关闭的 alert" type="success" :closable="false"></el-alert>
  <el-alert title="自定义 close-text" type="info" close-text="知道了"></el-alert>
  <el-alert title="设置了回调的 alert" type="warning" @close="hello"></el-alert>
</template>

<script>
export default {
  methods: {
    hello() {
      alert('Hello World!');
    }
  }
}
</script>
```

### 带有 icon
```vue
<template>
  <el-alert title="成功提示的文案" type="success" show-icon></el-alert>
  <el-alert title="消息提示的文案" type="info" show-icon></el-alert>
  <el-alert title="警告提示的文案" type="warning" show-icon></el-alert>
  <el-alert title="错误提示的文案" type="error" show-icon></el-alert>
</template>
```

### 文字居中
```vue
<template>
  <el-alert title="成功提示的文案" type="success" center show-icon></el-alert>
  <el-alert title="消息提示的文案" type="info" center show-icon></el-alert>
  <el-alert title="警告提示的文案" type="warning" center show-icon></el-alert>
  <el-alert title="错误提示的文案" type="error" center show-icon></el-alert>
</template>
```

### 带有辅助性文字介绍
```vue
<template>
  <el-alert title="带辅助性文字介绍" type="success"
    description="这是一句绕口令：黑灰化肥会挥发发灰黑化肥挥发；灰黑化肥会挥发发黑灰化肥发挥。 黑灰化肥会挥发发灰黑化肥黑灰挥发化为灰……">
  </el-alert>
</template>
```

### 带有 icon 和辅助性文字介绍
```vue
<template>
  <el-alert title="成功提示的文案" type="success" description="文字说明文字说明文字说明文字说明文字说明文字说明" show-icon></el-alert>
  <el-alert title="消息提示的文案" type="info" description="文字说明文字说明文字说明文字说明文字说明文字说明" show-icon></el-alert>
  <el-alert title="警告提示的文案" type="warning" description="文字说明文字说明文字说明文字说明文字说明文字说明" show-icon></el-alert>
  <el-alert title="错误提示的文案" type="error" description="文字说明文字说明文字说明文字说明文字说明文字说明" show-icon></el-alert>
</template>
```

## Attributes

| 参数 | 说明 | 类型 | 可选值 | 默认值 |
|------|------|------|--------|--------|
| title | 标题 | string | — | — |
| type | 主题 | string | success/warning/info/error | info |
| description | 辅助性文字。也可通过默认 slot 传入 | string | — | — |
| closable | 是否可关闭 | boolean | — | true |
| center | 文字是否居中 | boolean | — | true |
| close-text | 关闭按钮自定义文本 | string | — | — |
| show-icon | 是否显示图标 | boolean | — | false |
| effect | 选择提供的主题 | string | light/dark | light |

## Slot

| Name | Description |
|------|-------------|
| — | 描述 |
| title | 标题的内容 |

## Events

| 事件名称 | 说明 | 回调参数 |
|----------|------|----------|
| close | 关闭alert时触发的事件 | — |

## 最佳实践

1. **类型选择**: 使用`type`属性选择合适的类型(success/warning/info/error)
2. **主题样式**: 使用`effect`属性设置主题(light/dark)
3. **关闭控制**: 使用`closable`属性控制是否显示关闭按钮
4. **关闭文本**: 使用`close-text`属性自定义关闭按钮文本
5. **图标显示**: 使用`show-icon`属性显示图标,提升视觉效果
6. **关闭事件**: 使用`@close`事件监听关闭操作,执行相应逻辑
7. **描述信息**: 使用`description`属性添加描述信息,提供更多细节
8. **居中显示**: 使用`center`属性使内容居中显示

## 使用场景

### 操作成功提示
```vue
<el-alert
  title="操作成功"
  type="success"
  description="数据已成功保存到数据库"
  show-icon
  :closable="false">
</el-alert>
```

### 表单验证错误
```vue
<el-alert
  title="表单验证失败"
  type="error"
  description="请检查以下字段:用户名不能为空,邮箱格式不正确"
  show-icon
  @close="handleClose">
</el-alert>
```

### 系统通知
```vue
<el-alert
  title="系统维护通知"
  type="warning"
  description="系统将于今晚22:00-24:00进行维护,请提前保存数据"
  show-icon
  center>
</el-alert>
```

### 信息提示
```vue
<el-alert
  title="新功能上线"
  type="info"
  description="我们新增了数据导出功能,支持Excel和PDF格式"
  show-icon
  close-text="知道了">
</el-alert>
```

### 暗色主题
```vue
<el-alert
  title="重要提示"
  type="warning"
  effect="dark"
  description="此操作不可撤销,请谨慎操作"
  show-icon>
</el-alert>
```

### 可关闭的提示
```vue
<el-alert
  v-for="alert in alerts"
  :key="alert.id"
  :title="alert.title"
  :type="alert.type"
  :description="alert.description"
  show-icon
  @close="removeAlert(alert.id)">
</el-alert>
```

### 带图标的提示
```vue
<el-alert
  title="成功"
  type="success"
  show-icon>
  <template slot="title">
    <i class="el-icon-success"></i>
    <span>操作成功</span>
  </template>
</el-alert>
```
