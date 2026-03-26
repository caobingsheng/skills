# Radio 单选框

Radio 单选框用于在一组备选项中进行单选。

## 基础用法

### 基础用法
```vue
<template>
  <el-radio v-model="radio" label="1">备选项</el-radio>
  <el-radio v-model="radio" label="2">备选项</el-radio>
</template>

<script>
export default {
  data () {
    return {
      radio: '1'
    };
  }
}
</script>
```

### 禁用状态
```vue
<template>
  <el-radio disabled v-model="radio" label="禁用">备选项</el-radio>
  <el-radio disabled v-model="radio" label="选中且禁用">备选项</el-radio>
</template>

<script>
export default {
  data () {
    return {
      radio: '选中且禁用'
    };
  }
}
</script>
```

### 单选框组
```vue
<template>
  <el-radio-group v-model="radio">
    <el-radio :label="3">备选项</el-radio>
    <el-radio :label="6">备选项</el-radio>
    <el-radio :label="9">备选项</el-radio>
  </el-radio-group>
</template>

<script>
export default {
  data () {
    return {
      radio: 3
    };
  }
}
</script>
```

### 按钮样式
```vue
<template>
  <div>
    <el-radio-group v-model="radio1">
      <el-radio-button label="上海"></el-radio-button>
      <el-radio-button label="北京"></el-radio-button>
      <el-radio-button label="广州"></el-radio-button>
      <el-radio-button label="深圳"></el-radio-button>
    </el-radio-group>
  </div>

  <div style="margin-top: 20px">
    <el-radio-group v-model="radio2" size="medium">
      <el-radio-button label="上海"></el-radio-button>
      <el-radio-button label="北京"></el-radio-button>
      <el-radio-button label="广州"></el-radio-button>
      <el-radio-button label="深圳"></el-radio-button>
    </el-radio-group>
  </div>

  <div style="margin-top: 20px">
    <el-radio-group v-model="radio3" size="small">
      <el-radio-button label="上海"></el-radio-button>
      <el-radio-button label="北京" disabled></el-radio-button>
      <el-radio-button label="广州"></el-radio-button>
      <el-radio-button label="深圳"></el-radio-button>
    </el-radio-group>
  </div>

  <div style="margin-top: 20px">
    <el-radio-group v-model="radio4" disabled size="mini">
      <el-radio-button label="上海"></el-radio-button>
      <el-radio-button label="北京"></el-radio-button>
      <el-radio-button label="广州"></el-radio-button>
      <el-radio-button label="深圳"></el-radio-button>
    </el-radio-group>
  </div>
</template>

<script>
export default {
  data () {
    return {
      radio1: '上海',
      radio2: '上海',
      radio3: '上海',
      radio4: '上海'
    };
  }
}
</script>
```

### 带有边框
```vue
<template>
  <div>
    <el-radio v-model="radio1" label="1" border>备选项1</el-radio>
    <el-radio v-model="radio1" label="2" border>备选项2</el-radio>
  </div>

  <div style="margin-top: 20px">
    <el-radio v-model="radio2" label="1" border size="medium">备选项1</el-radio>
    <el-radio v-model="radio2" label="2" border size="medium">备选项2</el-radio>
  </div>

  <div style="margin-top: 20px">
    <el-radio-group v-model="radio3" size="small">
      <el-radio label="1" border>备选项1</el-radio>
      <el-radio label="2" border disabled>备选项2</el-radio>
    </el-radio-group>
  </div>

  <div style="margin-top: 20px">
    <el-radio-group v-model="radio4" size="mini" disabled>
      <el-radio label="1" border>备选项1</el-radio>
      <el-radio label="2" border>备选项2</el-radio>
    </el-radio-group>
  </div>
</template>

<script>
export default {
  data () {
    return {
      radio1: '1',
      radio2: '1',
      radio3: '1',
      radio4: '1'
    };
  }
}
</script>
```

## Radio Attributes

| 参数 | 说明 | 类型 | 可选值 | 默认值 |
|------|------|------|--------|--------|
| value / v-model | 绑定值 | string / number / boolean | — | — |
| label | Radio 的 value | string / number / boolean | — | — |
| disabled | 是否禁用 | boolean | — | false |
| border | 是否显示边框 | boolean | — | false |
| size | Radio 的尺寸，仅在 border 为真时有效 | string | medium / small / mini | — |
| name | 原生 name 属性 | string | — | — |

## Radio Events

| 事件名称 | 说明 | 回调参数 |
|----------|------|----------|
| input | 绑定值变化时触发的事件 | 选中的 Radio label 值 |

## Radio-group Attributes

| 参数 | 说明 | 类型 | 可选值 | 默认值 |
|------|------|------|--------|--------|
| value / v-model | 绑定值 | string / number / boolean | — | — |
| size | 单选框组尺寸 | string | medium / small / mini | — |
| disabled | 是否禁用 | boolean | — | false |
| text-color | 按钮形式的 Radio 激活时的文本颜色 | string | — | #ffffff |
| fill | 按钮形式的 Radio 激活时的填充色和边框色 | string | — | #409EFF |

## Radio-group Events

| 事件名称 | 说明 | 回调参数 |
|----------|------|----------|
| input | 绑定值变化时触发的事件 | 选中的 Radio label 值 |

## Radio-button Attributes

| 参数 | 说明 | 类型 | 可选值 | 默认值 |
|------|------|------|--------|--------|
| label | Radio 的 value | string / number | — | — |
| disabled | 是否禁用 | boolean | — | false |
| name | 原生 name 属性 | string | — | — |

## 最佳实践

1. **选项数量**：由于选项默认可见，不宜过多，若选项过多，建议使用 Select 选择器
2. **label 属性**：label 可以是 String、Number 或 Boolean
3. **单选框组**：结合 el-radio-group 元素和子元素 el-radio 可以实现单选组，无需给每一个 el-radio 绑定变量
4. **按钮样式**：只需要把 el-radio 元素换成 el-radio-button 元素即可实现按钮样式
5. **边框样式**：设置 border 属性可以渲染为带有边框的单选框
