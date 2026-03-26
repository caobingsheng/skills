# InputNumber 计数器

仅允许输入标准的数字值,可定义范围。

## 基础用法

要使用它,只需要在`el-input-number`元素中使用`v-model`绑定变量即可,变量的初始值即为默认值。

```vue
<el-input-number v-model="num" @change="handleChange" :min="1" :max="10"></el-input-number>

<script>
export default {
  data() {
    return {
      num: 1
    };
  },
  methods: {
    handleChange(value) {
      console.log(value);
    }
  }
};
</script>
```

## 禁用状态

`disabled`属性接受一个`Boolean`,设置为`true`即可禁用整个组件。

```vue
<el-input-number v-model="num" :disabled="true"></el-input-number>
```

## 步数

允许定义步长。

```vue
<el-input-number v-model="num" :step="2"></el-input-number>
```

## 严格步数

`step-strictly`属性接受一个`Boolean`。如果这个属性被设置为`true`,则只能输入步数的倍数。

```vue
<el-input-number v-model="num" :step="2" step-strictly></el-input-number>
```

## 精度

设置`precision`属性可以控制数值的精度,接收一个`Number`。

```vue
<el-input-number v-model="num" :precision="2" :step="0.1" :max="10"></el-input-number>
```

## 尺寸

额外提供了`medium`、`small`、`mini`三种尺寸的数字输入框。

```vue
<el-input-number v-model="num1"></el-input-number>
<el-input-number size="medium" v-model="num2"></el-input-number>
<el-input-number size="small" v-model="num3"></el-input-number>
<el-input-number size="mini" v-model="num4"></el-input-number>

<script>
export default {
  data() {
    return {
      num1: 1,
      num2: 1,
      num3: 1,
      num4: 1
    };
  }
};
</script>
```

## 按钮位置

设置`controls-position`属性可以控制按钮位置。

```vue
<el-input-number v-model="num" controls-position="right" @change="handleChange" :min="1" :max="10"></el-input-number>
```

## Attributes

| 参数 | 说明 | 类型 | 可选值 | 默认值 |
|------|------|------|--------|--------|
| value / v-model | 绑定值 | number | — | 0 |
| min | 设置计数器允许的最小值 | number | — | -Infinity |
| max | 设置计数器允许的最大值 | number | — | Infinity |
| step | 计数器步长 | number | — | 1 |
| step-strictly | 是否只能输入 step 的倍数 | boolean | — | false |
| precision | 数值精度 | number | — | — |
| size | 计数器尺寸 | string | large, medium, small, mini | — |
| disabled | 是否禁用计数器 | boolean | — | false |
| controls | 是否使用控制按钮 | boolean | — | true |
| controls-position | 控制按钮位置 | string | right | — |
| name | 原生属性 | string | — | — |
| label | 输入框关联的label文字 | string | — | — |
| placeholder | 输入框默认 placeholder | string | — | — |

## Events

| 事件名称 | 说明 | 回调参数 |
|----------|------|----------|
| change | 绑定值被改变时触发 | currentValue, oldValue |
| focus | 在 Input 获得焦点时触发 | (event: Event) |
| blur | 在 Input 失去焦点时触发 | (event: Event) |

## Methods

| 方法名 | 说明 | 参数 |
|--------|------|------|
| focus | 使 input 获取焦点 | — |
| select | 选中 input 中的文字 | — |

## 最佳实践

1. **范围限制**: 使用`min`和`max`属性限制输入范围,确保数据有效性
2. **步长控制**: 通过`step`属性设置步长,`step-strictly`确保只能输入步长的倍数
3. **精度控制**: 使用`precision`属性控制小数位数,避免浮点数精度问题
4. **按钮位置**: `controls-position="right"`将按钮放在右侧,节省横向空间
5. **禁用状态**: 使用`disabled`属性禁用组件,适用于只读场景
6. **尺寸选择**: 根据页面布局选择合适的尺寸(large/medium/small/mini)
7. **事件监听**: 监听`change`事件获取数值变化,`focus`和`blur`事件处理焦点状态
