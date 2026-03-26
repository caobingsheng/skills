# MessageBox 弹框

模拟系统的消息提示框而实现的一套模态对话框组件，用于消息提示、确认消息和提交内容。

## 基础用法

### 消息提示
当用户进行操作时会被触发，该对话框中断用户操作，直到用户确认知晓后才可关闭。调用 `$alert` 方法即可打开消息提示。

```vue
<template>
  <el-button type="text" @click="open">点击打开 Message Box</el-button>
</template>

<script>
export default {
  methods: {
    open() {
      this.$alert('这是一段内容', '标题名称', {
        confirmButtonText: '确定',
        callback: action => {
          this.$message({
            type: 'info',
            message: `action: ${ action }`
          });
        }
      });
    }
  }
};
</script>
```

### 确认消息
提示用户确认其已经触发的动作，并询问是否进行此操作时会用到此对话框。调用 `$confirm` 方法即可打开消息提示。

```vue
<template>
  <el-button type="text" @click="open">点击打开 Message Box</el-button>
</template>

<script>
export default {
  methods: {
    open() {
      this.$confirm('此操作将永久删除该文件, 是否继续?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.$message({
          type: 'success',
          message: '删除成功!'
        });
      }).catch(() => {
        this.$message({
          type: 'info',
          message: '已取消删除'
        });
      });
    }
  }
};
</script>
```

### 提交内容
当用户进行操作时会被触发，中断用户操作，提示用户进行输入的对话框。调用 `$prompt` 方法即可打开消息提示。

```vue
<template>
  <el-button type="text" @click="open">点击打开 Message Box</el-button>
</template>

<script>
export default {
  methods: {
    open() {
      this.$prompt('请输入邮箱', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        inputPattern: /[\w!#$%&'*+/=?^_`{|}~-]+(?:\.[\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\w](?:[\w-]*[\w])?\.)+[\w](?:[\w-]*[\w])?/,
        inputErrorMessage: '邮箱格式不正确'
      }).then(({ value }) => {
        this.$message({
          type: 'success',
          message: '你的邮箱是: ' + value
        });
      }).catch(() => {
        this.$message({
          type: 'info',
          message: '取消输入'
        });
      });
    }
  }
};
</script>
```

### 居中布局
内容支持居中布局。将 `center` 设置为 `true` 即可开启居中布局。

```vue
<template>
  <el-button type="text" @click="open">点击打开 Message Box</el-button>
</template>

<script>
export default {
  methods: {
    open() {
      this.$confirm('此操作将永久删除该文件, 是否继续?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
        center: true
      }).then(() => {
        this.$message({
          type: 'success',
          message: '删除成功!'
        });
      }).catch(() => {
        this.$message({
          type: 'info',
          message: '已取消删除'
        });
      });
    }
  }
};
</script>
```

## Options

| 参数 | 说明 | 类型 | 可选值 | 默认值 |
|------|------|------|--------|--------|
| title | MessageBox 标题 | string | — | — |
| message | MessageBox 消息正文内容 | string / VNode | — | — |
| dangerouslyUseHTMLString | 是否将 message 属性作为 HTML 片段处理 | boolean | — | false |
| type | 消息类型，用于显示图标 | string | success / info / warning / error | — |
| iconClass | 自定义图标的类名，会覆盖 type | string | — | — |
| customClass | MessageBox 的自定义类名 | string | — | — |
| callback | 若不使用 Promise，可以使用此参数指定 MessageBox 关闭后的回调 | function(action, instance) | — | — |
| showClose | MessageBox 是否显示右上角关闭按钮 | boolean | — | true |
| beforeClose | MessageBox 关闭前的回调，会暂停实例的关闭 | function(action, instance, done) | — | — |
| distinguishCancelAndClose | 是否将取消（点击取消按钮）与关闭（点击关闭按钮或遮罩层、按下 ESC 键）进行区分 | boolean | — | false |
| lockScroll | 是否在 MessageBox 出现时将 body 滚动锁定 | boolean | — | true |
| showCancelButton | 是否显示取消按钮 | boolean | — | false |
| showConfirmButton | 是否显示确定按钮 | boolean | — | true |
| cancelButtonText | 取消按钮的文本内容 | string | — | 取消 |
| confirmButtonText | 确定按钮的文本内容 | string | — | 确定 |
| cancelButtonClass | 取消按钮的自定义类名 | string | — | — |
| confirmButtonClass | 确定按钮的自定义类名 | string | — | — |
| closeOnClickModal | 是否可通过点击遮罩关闭 MessageBox | boolean | — | true |
| closeOnPressEscape | 是否可通过按下 ESC 键关闭 MessageBox | boolean | — | true |
| closeOnHashChange | 是否在 hashchange 时关闭 MessageBox | boolean | — | true |
| showInput | 是否显示输入框 | boolean | — | false |
| inputPlaceholder | 输入框的占位符 | string | — | — |
| inputType | 输入框的类型 | string | — | text |
| inputValue | 输入框的初始文本 | string | — | — |
| inputPattern | 输入框的校验表达式 | regexp | — | — |
| inputValidator | 输入框的校验函数 | function | — | — |
| inputErrorMessage | 校验未通过时的提示文本 | string | — | 输入的数据不合法! |
| center | 是否居中布局 | boolean | — | false |
| roundButton | 是否使用圆角按钮 | boolean | — | false |

## 全局方法

如果你完整引入了 Element，它会为 Vue.prototype 添加如下全局方法：`$msgbox`, `$alert`, `$confirm` 和 `$prompt`。

调用参数为：
- `$msgbox(options)`
- `$alert(message, title, options)` 或 `$alert(message, options)`
- `$confirm(message, title, options)` 或 `$confirm(message, options)`
- `$prompt(message, title, options)` 或 `$prompt(message, options)`

## 单独引用

如果单独引入 MessageBox：

```javascript
import { MessageBox } from 'element-ui';
```

那么对应于上述四个全局方法的调用方法依次为：`MessageBox`, `MessageBox.alert`, `MessageBox.confirm` 和 `MessageBox.prompt`，调用参数与全局方法相同。

## 最佳实践

1. **方法调用**: 使用`this.$alert()`、`this.$confirm()`、`this.$prompt()`方法调用
2. **确认操作**: 使用`this.$confirm()`进行危险操作的二次确认
3. **输入内容**: 使用`this.$prompt()`获取用户输入
4. **自定义按钮**: 使用`confirmButtonText`和`cancelButtonText`自定义按钮文本
5. **类型设置**: 使用`type`属性设置对话框类型(success/warning/info/error)
6. **Promise处理**: 使用Promise的then和catch处理用户选择
7. **回调函数**: 使用`callback`属性设置确认按钮的回调函数
8. **自定义内容**: 使用`message`属性设置消息内容,支持HTML
9. **关闭前确认**: 使用`beforeClose`属性在关闭前执行确认逻辑

## 使用场景

### 删除确认
```vue
<el-button @click="handleDelete">删除</el-button>

<script>
export default {
  methods: {
    handleDelete() {
      this.$confirm('此操作将永久删除该文件, 是否继续?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.$message({
          type: 'success',
          message: '删除成功!'
        });
      }).catch(() => {
        this.$message({
          type: 'info',
          message: '已取消删除'
        });
      });
    }
  }
}
</script>
```

### 输入对话框
```vue
<el-button @click="handlePrompt">输入</el-button>

<script>
export default {
  methods: {
    handlePrompt() {
      this.$prompt('请输入邮箱', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        inputPattern: /[\w!#$%&'*+/=?^_`{|}~-]+(?:\.[\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\w](?:[\w-]*[\w])?\.)+[\w](?:[\w-]*[\w])?/,
        inputErrorMessage: '邮箱格式不正确'
      }).then(({ value }) => {
        this.$message({
          type: 'success',
          message: '你的邮箱是: ' + value
        });
      }).catch(() => {
        this.$message({
          type: 'info',
          message: '取消输入'
        });
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
      this.$alert('<strong>这是 <i>HTML</i> 片段</strong>', 'HTML 片段', {
        dangerouslyUseHTMLString: true
      });
    }
  }
}
</script>
```

### 自定义按钮
```vue
<el-button @click="handleCustom">自定义按钮</el-button>

<script>
export default {
  methods: {
    handleCustom() {
      this.$confirm('检测到未保存的内容, 是否离开?', '提示', {
        confirmButtonText: '离开',
        cancelButtonText: '取消',
        type: 'warning',
        distinguishCancelAndClose: true,
        confirmButtonClass: 'el-button--primary'
      }).then(() => {
        // 离开逻辑
      }).catch((action) => {
        if (action === 'cancel') {
          // 取消逻辑
        } else if (action === 'close') {
          // 关闭逻辑
        }
      });
    }
  }
}
</script>
```

### 消息提示
```vue
<el-button @click="handleAlert">消息提示</el-button>

<script>
export default {
  methods: {
    handleAlert() {
      this.$alert('这是一段内容', '标题名称', {
        confirmButtonText: '确定',
        callback: action => {
          this.$message({
            type: 'info',
            message: `action: ${action}`
          });
        }
      });
    }
  }
}
</script>
```

### 居中显示
```vue
<el-button @click="handleCenter">居中显示</el-button>

<script>
export default {
  methods: {
    handleCenter() {
      this.$confirm('此操作将永久删除该文件, 是否继续?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
        center: true
      });
    }
  }
}
</script>
```
