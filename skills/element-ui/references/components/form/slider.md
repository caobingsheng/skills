# Slider 滑块

通过拖动滑块在一个固定区间内进行选择。

## 基础用法

在拖动滑块时,显示当前值。

```vue
<template>
  <div class="block">
    <span class="demonstration">默认</span>
    <el-slider v-model="value1"></el-slider>
  </div>
  <div class="block">
    <span class="demonstration">自定义初始值</span>
    <el-slider v-model="value2"></el-slider>
  </div>
  <div class="block">
    <span class="demonstration">隐藏 Tooltip</span>
    <el-slider v-model="value3" :show-tooltip="false"></el-slider>
  </div>
  <div class="block">
    <span class="demonstration">格式化 Tooltip</span>
    <el-slider v-model="value4" :format-tooltip="formatTooltip"></el-slider>
  </div>
  <div class="block">
    <span class="demonstration">禁用</span>
    <el-slider v-model="value5" disabled></el-slider>
  </div>
</template>

<script>
export default {
  data() {
    return {
      value1: 0,
      value2: 50,
      value3: 36,
      value4: 48,
      value5: 42
    }
  },
  methods: {
    formatTooltip(val) {
      return val / 100;
    }
  }
}
</script>
```

## 离散值

选项可以是离散的。

```vue
<el-slider
  v-model="value"
  :step="10"></el-slider>
```

## 带有输入框

通过输入框可以精确控制数值。

```vue
<el-slider
  v-model="value"
  show-input></el-slider>
```

## 范围选择

支持选择某一个数值范围。

```vue
<el-slider
  v-model="value"
  range
  show-stops
  :max="10"
  :step="1"></el-slider>

<script>
export default {
  data() {
    return {
      value: [4, 8]
    }
  }
}
</script>
```

## 竖向模式

```vue
<el-slider
  v-model="value"
  vertical
  height="200px"></el-slider>
```

## 显示标记

```vue
<el-slider
  v-model="value"
  :marks="marks"></el-slider>

<script>
export default {
  data() {
    return {
      value: 30,
      marks: {
        0: '0°C',
        26: '26°C',
        37: '37°C',
        100: {
          style: {
            color: '#1989FA'
          },
          label: this.$createElement('strong', '100°C')
        }
      }
    }
  }
}
</script>
```

## Attributes

| 参数 | 说明 | 类型 | 可选值 | 默认值 |
|------|------|------|--------|--------|
| value / v-model | 绑定值 | number | — | 0 |
| min | 最小值 | number | — | 0 |
| max | 最大值 | number | — | 100 |
| disabled | 是否禁用 | boolean | — | false |
| step | 步长 | number | — | 1 |
| show-input | 是否显示输入框,仅在非范围选择时有效 | boolean | — | false |
| show-input-controls | 在显示输入框的情况下,是否显示输入框的控制按钮 | boolean | — | true |
| show-stops | 是否显示间断点 | boolean | — | false |
| show-tooltip | 是否显示 tooltip | boolean | — | true |
| format-tooltip | 格式化 tooltip message | function(value) | — | — |
| range | 是否为范围选择 | boolean | — | false |
| vertical | 是否竖向模式 | boolean | — | false |
| height | Slider 高度,竖向模式时必填 | string | — | — |
| label | 屏幕阅读器标签 | string | — | — |
| debounce | 输入时的去抖延迟,毫秒,仅在`show-input`等于true时有效 | number | — | 300 |
| tooltip-class | tooltip 的自定义类名 | string | — | — |
| marks | 标记, key 的类型必须为 number 且取值在闭区间 [min, max] 内,每个标记可以自定义样式 | object | — | — |

## Events

| 事件名称 | 说明 | 回调参数 |
|----------|------|----------|
| change | 值改变时触发(使用鼠标拖曳时,只在松开鼠标后触发) | 改变后的值 |
| input | 数据改变时触发(使用鼠标拖曳时,活动过程实时触发) | 改变后的值 |

## Methods

| 方法名 | 说明 | 参数 |
|--------|------|------|
| setPosition | 设置 Slider 滑块的位置 | percentage: 0-100 之间的数值 |

## 最佳实践

1. **步长控制**: 使用`step`属性设置步长,`show-stops`显示间断点
2. **范围选择**: 开启`range`实现范围选择,适用于价格区间、时间范围等场景
3. **输入框**: 使用`show-input`显示输入框,支持精确输入数值
4. **竖向模式**: 使用`vertical`和`height`实现竖向滑块,适用于音量、亮度等场景
5. **标记显示**: 使用`marks`添加标记点,支持自定义样式和标签
6. **格式化提示**: 使用`format-tooltip`自定义tooltip显示内容
7. **禁用状态**: 使用`disabled`禁用滑块,适用于只读场景
8. **事件监听**: 监听`change`和`input`事件,`change`在松开鼠标后触发,`input`实时触发
