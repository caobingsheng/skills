# DateTimePicker 日期时间选择器

在同一个选择器里选择日期和时间。

## 日期和时间点

选择一个或者多个日期和时间点。

```vue
<template>
  <div class="container">
    <div class="block">
      <span class="demonstration">默认</span>
      <el-date-picker
        v-model="value1"
        type="datetime"
        placeholder="选择日期时间">
      </el-date-picker>
    </div>
    <div class="block">
      <span class="demonstration">带快捷选项</span>
      <el-date-picker
        v-model="value2"
        type="datetime"
        placeholder="选择日期时间"
        align="right"
        :picker-options="pickerOptions">
      </el-date-picker>
    </div>
    <div class="block">
      <span class="demonstration">设置默认时间</span>
      <el-date-picker
        v-model="value3"
        type="datetime"
        placeholder="选择日期时间"
        default-time="12:00:00">
      </el-date-picker>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      value1: '',
      value2: '',
      value3: '',
      pickerOptions: {
        shortcuts: [{
          text: '今天',
          onClick(picker) {
            picker.$emit('pick', new Date());
          }
        }, {
          text: '昨天',
          onClick(picker) {
            const date = new Date();
            date.setTime(date.getTime() - 3600 * 1000 * 24);
            picker.$emit('pick', date);
          }
        }, {
          text: '一周前',
          onClick(picker) {
            const date = new Date();
            date.setTime(date.getTime() - 3600 * 1000 * 24 * 7);
            picker.$emit('pick', date);
          }
        }]
      }
    };
  }
};
</script>
```

## 日期和时间范围

可在一个选择器中便捷地选择一个时间范围。

```vue
<template>
  <div class="container">
    <div class="block">
      <span class="demonstration">默认</span>
      <el-date-picker
        v-model="value1"
        type="datetimerange"
        range-separator="至"
        start-placeholder="开始日期"
        end-placeholder="结束日期">
      </el-date-picker>
    </div>
    <div class="block">
      <span class="demonstration">带快捷选项</span>
      <el-date-picker
        v-model="value2"
        type="datetimerange"
        range-separator="至"
        start-placeholder="开始日期"
        end-placeholder="结束日期"
        :picker-options="pickerOptions">
      </el-date-picker>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      value1: '',
      value2: '',
      pickerOptions: {
        shortcuts: [{
          text: '最近一周',
          onClick(picker) {
            const end = new Date();
            const start = new Date();
            start.setTime(start.getTime() - 3600 * 1000 * 24 * 7);
            picker.$emit('pick', [start, end]);
          }
        }, {
          text: '最近一个月',
          onClick(picker) {
            const end = new Date();
            const start = new Date();
            start.setTime(start.getTime() - 3600 * 1000 * 24 * 30);
            picker.$emit('pick', [start, end]);
          }
        }, {
          text: '最近三个月',
          onClick(picker) {
            const end = new Date();
            const start = new Date();
            start.setTime(start.getTime() - 3600 * 1000 * 24 * 90);
            picker.$emit('pick', [start, end]);
          }
        }]
      }
    };
  }
};
</script>
```

## Attributes

| 参数 | 说明 | 类型 | 可选值 | 默认值 |
|------|------|------|--------|--------|
| value / v-model | 绑定值 | Date / [Date, Date] / string / [string, string] | — | — |
| readonly | 完全只读 | boolean | — | false |
| disabled | 禁用 | boolean | — | false |
| editable | 文本框可输入 | boolean | — | true |
| clearable | 是否显示清除按钮 | boolean | — | true |
| size | 输入框尺寸 | string | large, medium, small, mini | — |
| placeholder | 非范围选择时的占位内容 | string | — | — |
| start-placeholder | 范围选择时开始日期的占位内容 | string | — | 开始日期 |
| end-placeholder | 范围选择时结束日期的占位内容 | string | — | 结束日期 |
| type | 显示类型 | string | year/month/date/dates/week/datetime/datetimerange/daterange | date |
| format | 显示在输入框中的格式 | string | 见日期格式化 | yyyy-MM-dd HH:mm:ss |
| align | 对齐方式 | string | left, center, right | left |
| popper-class | DatePicker 下拉框的类名 | string | — | — |
| picker-options | 当前时间日期选择器特有的选项参考下表 | object | — | {} |
| range-separator | 选择范围时的分隔符 | string | — | '-' |
| default-value | 可选,选择器打开时默认显示的时间 | Date | — | — |
| default-time | 可选,选择日期后默认选择的时间 | Date[] | — | — |
| value-format | 可选,绑定值的格式。不指定则绑定值为 Date 对象 | string | 见日期格式化 | — |
| name | 原生属性 | string | — | — |
| unlink-panels | 在范围选择器里取消两个日期面板之间的联动 | boolean | — | false |
| prefix-icon | 自定义头部图标的类名 | string | — | el-icon-date |
| clear-icon | 自定义清空图标的类名 | string | — | el-icon-circle-close |
| validate-event | 是否触发表单验证 | boolean | — | true |

## Picker Options

| 参数 | 说明 | 类型 | 可选值 | 默认值 |
|------|------|------|--------|--------|
| shortcuts | 设置快捷选项,需要传入 { text, onClick } 对象用法参考 demo 或下表 | Object[] | — | — |
| disabledDate | 设置禁用状态,参数为当前日期,要求返回 Boolean 禁用该日期 | Function | — | — |
| onPick | 选中日期后会执行的回调,只有当 daterange 或 datetimerange 才生效 | Function({ maxDate, minDate }) | — | — |
| firstDayOfWeek | 周起始日 | Number | 1 到 7 | 7 |

## Events

| 事件名 | 说明 | 回调参数 |
|--------|------|----------|
| change | 用户确认选定的值时触发 | 组件绑定值 |
| blur | 当 input 失去焦点时触发 | 组件实例 |
| focus | 当 input 获得焦点时触发 | (event: Event) |
| calendar-change | 日历面板显示/隐藏时触发 | 显示为true,隐藏为false |

## Methods

| 方法名 | 说明 | 参数 |
|--------|------|------|
| focus | 使 input 获取焦点 | — |

## 最佳实践

1. **时间格式**: 使用`value-format`指定绑定值的格式,如'yyyy-MM-dd HH:mm:ss'
2. **快捷选项**: 使用`pickerOptions.shortcuts`添加快捷选项,提升用户体验
3. **默认时间**: 使用`default-time`设置选择日期后默认选择的时间
4. **范围选择**: 使用`type="datetimerange"`实现日期时间范围选择
5. **禁用日期**: 使用`disabledDate`限制可选日期范围
6. **取消联动**: 使用`unlink-panels`取消两个日期面板之间的联动
7. **对齐方式**: 使用`align`设置选择器对齐方式(left/center/right)
8. **事件监听**: 监听`change`事件获取用户确认的日期时间值
