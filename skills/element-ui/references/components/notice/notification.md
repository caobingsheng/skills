# Notification 通知

悬浮出现在页面角落，显示全局的通知提醒消息。

## 基础用法

### 基本用法
适用性广泛的通知栏。Notification 组件提供通知功能，Element 注册了 `$notify` 方法，接收一个 `options` 字面量参数。

```vue
<template>
  <el-button plain @click="open1">可自动关闭</el-button>
  <el-button plain @click="open2">不会自动关闭</el-button>
</template>

<script>
export default {
  methods: {
    open1() {
      const h = this.$createElement;
      this.$notify({
        title: '标题名称',
        message: h('i', { style: 'color: teal'}, '这是提示文案')
      });
    },
    open2() {
      this.$notify({
        title: '提示',
        message: '这是一条不会自动关闭的消息',
        duration: 0
      });
    }
  }
};
</script>
```

### 带有倾向性
带有 icon，常用来显示「成功、警告、消息、错误」类的系统消息。Element 为 Notification 组件准备了四种通知类型：`success`, `warning`, `info`, `error`。

```vue
<template>
  <el-button plain @click="open1">成功</el-button>
  <el-button plain @click="open2">警告</el-button>
  <el-button plain @click="open3">消息</el-button>
  <el-button plain @click="open4">错误</el-button>
</template>

<script>
export default {
  methods: {
    open1() {
      this.$notify({
        title: '成功',
        message: '这是一条成功的提示消息',
        type: 'success'
      });
    },
    open2() {
      this.$notify({
        title: '警告',
        message: '这是一条警告的提示消息',
        type: 'warning'
      });
    },
    open3() {
      this.$notify.info({
        title: '消息',
        message: '这是一条消息的提示消息'
      });
    },
    open4() {
      this.$notify.error({
        title: '错误',
        message: '这是一条错误的提示消息'
      });
    }
  }
};
</script>
```

### 自定义弹出位置
可以让 Notification 从屏幕四角中的任意一角弹出。使用 `position` 属性定义 Notification 的弹出位置，支持四个选项：`top-right`、`top-left`、`bottom-right`、`bottom-left`，默认为 `top-right`。

```vue
<template>
  <el-button plain @click="open1">右上角</el-button>
  <el-button plain @click="open2">右下角</el-button>
  <el-button plain @click="open3">左下角</el-button>
  <el-button plain @click="open4">左上角</el-button>
</template>

<script>
export default {
  methods: {
    open1() {
      this.$notify({
        title: '自定义位置',
        message: '右上角弹出的消息'
      });
    },
    open2() {
      this.$notify({
        title: '自定义位置',
        message: '右下角弹出的消息',
        position: 'bottom-right'
      });
    },
    open3() {
      this.$notify({
        title: '自定义位置',
        message: '左下角弹出的消息',
        position: 'bottom-left'
      });
    },
    open4() {
      this.$notify({
        title: '自定义位置',
        message: '左上角弹出的消息',
        position: 'top-left'
      });
    }
  }
};
</script>
```

### 带有偏移
让 Notification 偏移一些位置。Notification 提供设置偏移量的功能，通过设置 `offset` 字段，可以使弹出的消息距屏幕边缘偏移一段距离。

```vue
<template>
  <el-button plain @click="open">偏移的消息</el-button>
</template>

<script>
export default {
  methods: {
    open() {
      this.$notify({
        title: '偏移',
        message: '这是一条带有偏移的提示消息',
        offset: 100
      });
    }
  }
};
</script>
```

### 隐藏关闭按钮
可以不显示关闭按钮。将 `showClose` 属性设置为 `false` 即可隐藏关闭按钮。

```vue
<template>
  <el-button plain @click="open">隐藏关闭按钮</el-button>
</template>

<script>
export default {
  methods: {
    open() {
      this.$notify.success({
        title: 'Info',
        message: '这是一条没有关闭按钮的消息',
        showClose: false
      });
    }
  }
};
</script>
```

## Options

| 参数 | 说明 | 类型 | 可选值 | 默认值 |
|------|------|------|--------|--------|
| title | 标题 | string | — | — |
| message | 说明文字 | string/Vue.VNode | — | — |
| dangerouslyUseHTMLString | 是否将 message 属性作为 HTML 片段处理 | boolean | — | false |
| type | 主题样式，如果不在可选值内将被忽略 | string | success/warning/info/error | — |
| iconClass | 自定义图标的类名。若设置了 type，则 iconClass 会被覆盖 | string | — | — |
| customClass | 自定义类名 | string | — | — |
| duration | 显示时间, 毫秒。设为 0 则不会自动关闭 | number | — | 4500 |
| position | 自定义弹出位置 | string | top-right/top-left/bottom-right/bottom-left | top-right |
| showClose | 是否显示关闭按钮 | boolean | — | true |
| onClose | 关闭时的回调函数 | function | — | — |
| onClick | 点击 Notification 时的回调函数 | function | — | — |
| offset | 偏移的距离，在同一时刻，所有的 Notification 实例应当具有一个相同的偏移量 | number | — | 0 |

## 方法

| 方法名 | 说明 |
|--------|------|
| close | 关闭当前的 Notification |

## 全局方法

Element 为 `Vue.prototype` 添加了全局方法 `$notify`。因此在 vue instance 中可以采用本页面中的方式调用 Notification。

## 单独引用

单独引入 Notification：

```javascript
import { Notification } from 'element-ui';
```

此时调用方法为 `Notification(options)`。我们也为每个 type 定义了各自的方法，如 `Notification.success(options)`。并且可以调用 `Notification.closeAll()` 手动关闭所有实例。

## 最佳实践

1. **方法调用**: 使用`this.$notify()`方法调用通知
2. **类型选择**: 使用`type`属性选择合适的类型(success/warning/info/error)
3. **位置设置**: 使用`position`属性设置通知位置(top-right/top-left/bottom-right/bottom-left)
4. **显示时长**: 使用`duration`属性设置显示时长,0表示不自动关闭
5. **自定义内容**: 使用`message`属性设置消息内容,支持VNode
6. **关闭回调**: 使用`onClose`属性设置关闭时的回调函数
7. **多个通知**: 可以同时显示多个通知,会自动堆叠
8. **手动关闭**: 使用`close()`方法手动关闭通知

## 使用场景

### 成功通知
```vue
<el-button @click="open1">成功</el-button>

<script>
export default {
  methods: {
    open1() {
      this.$notify({
        title: '成功',
        message: '这是一条成功的通知消息',
        type: 'success'
      });
    }
  }
}
</script>
```

### 警告通知
```vue
<el-button @click="open2">警告</el-button>

<script>
export default {
  methods: {
    open2() {
      this.$notify({
        title: '警告',
        message: '这是一条警告的通知消息',
        type: 'warning'
      });
    }
  }
}
</script>
```

### 信息通知
```vue
<el-button @click="open3">信息</el-button>

<script>
export default {
  methods: {
    open3() {
      this.$notify.info({
        title: '消息',
        message: '这是一条消息的通知'
      });
    }
  }
}
</script>
```

### 错误通知
```vue
<el-button @click="open4">错误</el-button>

<script>
export default {
  methods: {
    open4() {
      this.$notify.error({
        title: '错误',
        message: '这是一条错误的通知消息'
      });
    }
  }
}
</script>
```

### 自定义位置
```vue
<el-button @click="open5">右下角</el-button>

<script>
export default {
  methods: {
    open5() {
      this.$notify({
        title: '自定义位置',
        message: '这是一条位于右下角的消息',
        position: 'bottom-right'
      });
    }
  }
}
</script>
```

### 带有偏移
```vue
<el-button @click="open6">带有偏移</el-button>

<script>
export default {
  methods: {
    open6() {
      this.$notify({
        title: '偏移',
        message: '这是一条带有偏移的消息',
        offset: 100
      });
    }
  }
}
</script>
```

### 使用HTML片段
```vue
<el-button @click="open7">HTML片段</el-button>

<script>
export default {
  methods: {
    open7() {
      this.$notify({
        title: 'HTML片段',
        dangerouslyUseHTMLString: true,
        message: '<strong>这是 <i>HTML</i> 片段</strong>'
      });
    }
  }
}
</script>
```

### 隐藏关闭按钮
```vue
<el-button @click="open8">隐藏关闭</el-button>

<script>
export default {
  methods: {
    open8() {
      this.$notify({
        title: 'Info',
        message: '这是一条没有关闭按钮的消息',
        duration: 0,
        showClose: false
      });
    }
  }
};
</script>
```
