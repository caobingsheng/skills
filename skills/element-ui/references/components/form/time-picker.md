# TimePicker 时间选择器

用于选择或输入时间。

## 固定时间点

提供几个固定的时间点供用户选择。

```vue
<el-time-select
  v-model="value"
  :picker-options="{
    start: '08:30',
    step: '00:15',
    end: '18:30'
  }"
  placeholder="选择时间">
</el-time-select>

<script>
export default {
  data() {
    return {
      value: ''
    }
  }
}
</script>
```

## 任意时间点

可以选择任意时间。

```vue
<el-time-picker
  v-model="value"
  placeholder="任意时间点">
</el-time-picker>

<script>
export default {
  data() {
    return {
      value: new Date()
    }
  }
}
</script>
```

## 固定时间范围

若需要选择时间范围,添加`is-range`属性即可。

```vue
<el-time-select
  placeholder="起始时间"
  v-model="startTime"
  :picker-options="{
    start: '08:30',
    step: '00:15',
    end: '18:30'
  }">
</el-time-select>
<el-time-select
  placeholder="结束时间"
  v-model="endTime"
  :picker-options="{
    start: '08:30',
    step: '00:15',
    end: '18:30',
    minTime: startTime
  }">
</el-time-select>

<script>
export default {
  data() {
    return {
      startTime: '',
      endTime: ''
    }
  }
}
</script>
```

## 任意时间范围

可选择任意的时间范围。

```vue
<el-time-picker
  is-range
  v-model="value"
  range-separator="至"
  start-placeholder="开始时间"
  end-placeholder="结束时间"
  placeholder="选择时间范围">
</el-time-picker>

<script>
export default {
  data() {
    return {
      value: [new Date(2016, 9, 10, 8, 40), new Date(2016, 9, 10, 9, 40)]
    }
  }
}
</script>
```

## Attributes

| 参数 | 说明 | 类型 | 可选值 | 默认值 |
|------|------|------|--------|--------|
| value / v-model | 绑定值 | date(TimePicker) / string(TimeSelect) | — | — |
| readonly | 只读 | boolean | — | false |
| disabled | 禁用 | boolean | — | false |
| editable | 文本框可输入 | boolean | — | true |
| clearable | 是否显示清除按钮 | boolean | — | true |
| size | 输入框尺寸 | string | medium / small / mini | — |
| placeholder | 非范围选择时的占位内容 | string | — | — |
| start-placeholder | 范围选择时开始日期的占位内容 | string | — | 开始日期 |
| end-placeholder | 范围选择时结束日期的占位内容 | string | — | 结束日期 |
| is-range | 是否为时间范围选择 | boolean | — | false |
| arrow-control | 是否使用箭头进行时间选择 | boolean | — | false |
| align | 对齐方式 | string | left / center / right | left |
| popper-class | TimePicker 下拉框的类名 | string | — | — |
| picker-options | 当前时间日期选择器特有的选项参考下表 | object | — | {} |
| range-separator | 选择范围时的分隔符 | string | — | '-' |
| value-format | 可选,绑定值的格式。不指定则绑定值为 Date 对象 | string | 见日期格式化 | — |
| default-value | 可选,选择器打开时默认显示的时间 | Date(TimePicker) / string(TimeSelect) | — | — |
| name | 原生属性 | string | — | — |
| prefix-icon | 自定义头部图标的类名 | string | — | el-icon-time |
| clear-icon | 自定义清空图标的类名 | string | — | el-icon-circle-close |

## TimeSelect Options

| 参数 | 说明 | 类型 | 可选值 | 默认值 |
|------|------|------|--------|--------|
| start | 开始时间 | string | — | 09:00 |
| end | 结束时间 | string | — | 18:00 |
| step | 间隔时间 | string | — | 00:30 |
| minTime | 最小时间,小于该时间的时间段将被禁用 | string | — | 00:00 |
| maxTime | 最大时间,大于该时间的时间段将被禁用 | string | — | — |

## TimePicker Options

| 参数 | 说明 | 类型 | 可选值 | 默认值 |
|------|------|------|--------|--------|
| selectableRange | 可选时间段,例如'18:30:00 - 20:30:00'或者传入数组['09:30:00 - 12:00:00', '14:30:00 - 18:30:00'] | string / array | — | — |
| format | 时间格式化(TimePicker) | string | 小时:minute:second | — |

## Events

| 事件名 | 说明 | 回调参数 |
|--------|------|----------|
| change | 用户确认选定的值时触发 | 组件绑定值 |
| blur | 当 input 失去焦点时触发 | 组件实例 |
| focus | 当 input 获得焦点时触发 | (event: Event) |

## Methods

| 方法名 | 说明 | 参数 |
|--------|------|------|
| focus | 使 input 获取焦点 | — |

## 最佳实践

1. **时间格式**: 使用`value-format`指定绑定值的格式,如'HH:mm:ss'
2. **范围选择**: 使用`is-range`开启范围选择,设置`range-separator`自定义分隔符
3. **固定时间点**: TimeSelect适用于固定时间点选择,使用`picker-options`配置时间范围和步长
4. **任意时间**: TimePicker适用于任意时间选择,支持精确到秒
5. **禁用时间段**: 使用`selectableRange`限制可选时间段
6. **箭头控制**: 开启`arrow-control`使用箭头选择时间,提升操作体验
7. **默认时间**: 使用`default-value`设置选择器打开时默认显示的时间
8. **事件监听**: 监听`change`事件获取用户确认的时间值
