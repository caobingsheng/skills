# Message 消息提示

Message 消息提示常用于主动操作后的反馈提示。与 Notification 的区别是后者更多用于系统级通知的被动提醒。

## 基础用法

### 基础用法
```vue
<template>
  <el-button :plain="true" @click="open">打开消息提示</el-button>
</template>

<script>
export default {
  methods: {
    open() {
      this.$message('这是一条消息提示');
    }
  }
}
</script>
```

### 不同状态
```vue
<template>
  <el-button :plain="true" @click="open1">消息</el-button>
  <el-button :plain="true" @click="open2">成功</el-button>
  <el-button :plain="true" @click="open3">警告</el-button>
  <el-button :plain="true" @click="open4">错误</el-button>
</template>

<script>
export default {
  methods: {
    open1() {
      this.$message('这是一条消息提示');
    },
    open2() {
      this.$message({
        message: '恭喜你，这是一条成功消息',
        type: 'success'
      });
    },
    open3() {
      this.$message({
        message: '警告哦，这是一条警告消息',
        type: 'warning'
      });
    },
    open4() {
      this.$message.error('错了哦，这是一条错误消息');
    }
  }
}
</script>
```

### 可关闭
```vue
<template>
  <el-button :plain="true" @click="open1">消息</el-button>
  <el-button :plain="true" @click="open2">成功</el-button>
  <el-button :plain="true" @click="open3">警告</el-button>
  <el-button :plain="true" @click="open4">错误</el-button>
</template>

<script>
export default {
  methods: {
    open1() {
      this.$message({
        showClose: true,
        message: '这是一条消息提示'
      });
    },
    open2() {
      this.$message({
        showClose: true,
        message: '恭喜你，这是一条成功消息',
        type: 'success'
      });
    },
    open3() {
      this.$message({
        showClose: true,
        message: '警告哦，这是一条警告消息',
        type: 'warning'
      });
    },
    open4() {
      this.$message({
        showClose: true,
        message: '错了哦，这是一条错误消息',
        type: 'error'
      });
    }
  }
}
</script>
```

### 文字居中
```vue
<template>
  <el-button :plain="true" @click="openCenter">文字居中</el-button>
</template>

<script>
export default {
  methods: {
    openCenter() {
      this.$message({
        message: '居中的文字',
        center: true
      });
    }
  }
}
</script>
```

### 使用 HTML 片段
```vue
<template>
  <el-button :plain="true" @click="openHTML">使用 HTML 片段</el-button>
</template>

<script>
export default {
  methods: {
    openHTML() {
      this.$message({
        dangerouslyUseHTMLString: true,
        message: '<strong>这是 <i>HTML</i> 片段</strong>'
      });
    }
  }
}
</script>
```

## Options

| 参数 | 说明 | 类型 | 可选值 | 默认值 |
|------|------|------|--------|--------|
| message | 消息文字 | string / VNode | — | — |
| type | 主题 | string | success/warning/info/error | info |
| iconClass | 自定义图标的类名 | string | — | — |
| dangerouslyUseHTMLString | 是否将 message 属性作为 HTML 片段处理 | boolean | — | false |
| customClass | 自定义类名 | string | — | — |
| duration | 显示时间, 毫秒。设为 0 则不会自动关闭 | number | — | 3000 |
| showClose | 是否显示关闭按钮 | boolean | — | false |
| center | 文字是否居中 | boolean | — | false |
| onClose | 关闭时的回调函数 | function | — | — |
| offset | Message 距离窗口顶部的偏移量 | number | — | 20 |

## 方法

| 方法名 | 说明 |
|--------|------|
| close | 关闭当前的 Message |

## 全局方法

Element 为 Vue.prototype 添加了全局方法 `$message`。因此在 vue instance 中可以采用本页面中的方式调用 Message。

## 单独引用

```javascript
import { Message } from 'element-ui';
```

此时调用方法为 `Message(options)`。我们也为每个 type 定义了各自的方法，如 `Message.success(options)`。并且可以调用 `Message.closeAll()` 手动关闭所有实例。

## 最佳实践

1. **方法调用**: 使用`this.$message()`方法调用消息提示
2. **类型选择**: 使用`type`属性选择合适的类型(success/warning/info/error)
3. **自定义内容**: 使用`message`属性设置消息内容,支持HTML
4. **显示时长**: 使用`duration`属性设置显示时长,0表示不自动关闭
5. **关闭回调**: 使用`onClose`属性设置关闭时的回调函数
6. **偏移位置**: 使用`offset`属性设置消息距离顶部的偏移量
7. **多个消息**: 可以同时显示多个消息,会自动堆叠
8. **手动关闭**: 使用`close()`方法手动关闭消息

## 使用场景

### 操作成功提示
```vue
<el-button @click="handleSuccess">成功</el-button>

<script>
export default {
  methods: {
    handleSuccess() {
      this.$message({
        message: '操作成功',
        type: 'success'
      });
    }
  }
}
</script>
```

### 表单验证提示
```vue
<el-button @click="handleError">错误</el-button>

<script>
export default {
  methods: {
    handleError() {
      this.$message.error('表单验证失败,请检查输入');
    }
  }
}
</script>
```

### 警告提示
```vue
<el-button @click="handleWarning">警告</el-button>

<script>
export default {
  methods: {
    handleWarning() {
      this.$message({
        message: '此操作可能影响系统性能',
        type: 'warning'
      });
    }
  }
}
</script>
```

### 持久显示
```vue
<el-button @click="handlePersistent">持久显示</el-button>

<script>
export default {
  methods: {
    handlePersistent() {
      this.$message({
        message: '此消息不会自动关闭',
        duration: 0,
        showClose: true
      });
    }
  }
}
</script>
```

### HTML内容
```vue
<el-button @click="handleHtml">HTML内容</el-button>

<script>
export default {
  methods: {
    handleHtml() {
      this.$message({
        dangerouslyUseHTMLString: true,
        message: '<strong>这是 <span style="color: red">HTML</span> 内容</strong>'
      });
    }
  }
}
</script>
```

### 关闭回调
```vue
<el-button @click="handleCallback">关闭回调</el-button>

<script>
export default {
  methods: {
    handleCallback() {
      this.$message({
        message: '消息将在3秒后关闭',
        duration: 3000,
        onClose: () => {
          console.log('消息已关闭');
        }
      });
    }
  }
}
</script>
```

### 偏移位置
```vue
<el-button @click="handleOffset">偏移位置</el-button>

<script>
export default {
  methods: {
    handleOffset() {
      this.$message({
        message: '距离顶部100px',
        offset: 100
      });
    }
  }
}
</script>
```
