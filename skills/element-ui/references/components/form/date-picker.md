# DatePicker 日期选择器

用于选择或输入日期。

## 基础用法

### 选择日
以「日」为基本单位，基础的日期选择控件。

```vue
<el-date-picker v-model="value" type="date" placeholder="选择日期">
</el-date-picker>
```

### 其他日期单位
通过扩展基础的日期选择，可以选择周、月、年或多个日期。

```vue
<!-- 周 -->
<el-date-picker v-model="value1" type="week" format="yyyy 第 WW 周" placeholder="选择周">
</el-date-picker>

<!-- 月 -->
<el-date-picker v-model="value2" type="month" placeholder="选择月">
</el-date-picker>

<!-- 年 -->
<el-date-picker v-model="value3" type="year" placeholder="选择年">
</el-date-picker>

<!-- 多个日期 -->
<el-date-picker type="dates" v-model="value4" placeholder="选择一个或多个日期">
</el-date-picker>
```

### 选择日期范围
可在一个选择器中便捷地选择一个时间范围。

```vue
<el-date-picker
  v-model="value"
  type="daterange"
  range-separator="至"
  start-placeholder="开始日期"
  end-placeholder="结束日期">
</el-date-picker>
```

### 选择月份范围
可在一个选择器中便捷地选择一个月份范围。

```vue
<el-date-picker
  v-model="value"
  type="monthrange"
  range-separator="至"
  start-placeholder="开始月份"
  end-placeholder="结束月份">
</el-date-picker>
```

### 日期格式
使用 `format` 指定输入框的格式；使用 `value-format` 指定绑定值的格式。

```vue
<el-date-picker
  v-model="value"
  type="date"
  placeholder="选择日期"
  format="yyyy 年 MM 月 dd 日"
  value-format="yyyy-MM-dd">
</el-date-picker>
```

### 带快捷选项
快捷选项需配置 `picker-options` 对象中的 `shortcuts`。

```vue
<el-date-picker
  v-model="value"
  type="date"
  placeholder="选择日期"
  :picker-options="pickerOptions">
</el-date-picker>

<script>
export default {
  data() {
    return {
      pickerOptions: {
        disabledDate(time) {
          return time.getTime() > Date.now();
        },
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
        }]
      },
      value: ''
    };
  }
};
</script>
```

### 日期范围快捷选项
```vue
<el-date-picker
  v-model="value"
  type="daterange"
  align="right"
  unlink-panels
  range-separator="至"
  start-placeholder="开始日期"
  end-placeholder="结束日期"
  :picker-options="pickerOptions">
</el-date-picker>

<script>
export default {
  data() {
    return {
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
      },
      value: ''
    };
  }
};
</script>
```

## Attributes

| 参数 | 说明 | 类型 | 可选值 | 默认值 |
|------|------|------|--------|--------|
| value / v-model | 绑定值 | date(DatePicker) / array(DateRangePicker) | — | — |
| readonly | 完全只读 | boolean | — | false |
| disabled | 禁用 | boolean | — | false |
| editable | 文本框可输入 | boolean | — | true |
| clearable | 是否显示清除按钮 | boolean | — | true |
| size | 输入框尺寸 | string | large, small, mini | — |
| placeholder | 非范围选择时的占位内容 | string | — | — |
| start-placeholder | 范围选择时开始日期的占位内容 | string | — | — |
| end-placeholder | 范围选择时结束日期的占位内容 | string | — | — |
| type | 显示类型 | string | year/month/date/dates/weeks/months/years week/datetime/datetimerange/daterange/monthrange | date |
| format | 显示在输入框中的格式 | string | 见日期格式 | yyyy-MM-dd |
| align | 对齐方式 | string | left, center, right | left |
| range-separator | 选择范围时的分隔符 | string | — | '-' |
| default-value | 选择器打开时默认显示的时间 | Date | 可被new Date()解析 | — |
| default-time | 范围选择时选中日期所使用的当日内具体时刻 | string[] | 数组，长度为 2，每项值为字符串，形如12:00:00 | — |
| value-format | 可选，绑定值的格式。不指定则绑定值为 Date 对象 | string | 见日期格式 | — |
| unlink-panels | 在范围选择器里取消两个日期面板之间的联动 | boolean | — | false |
| prefix-icon | 自定义头部图标的类名 | string | — | el-icon-date |
| clear-icon | 自定义清空图标的类名 | string | — | el-icon-circle-close |

## Picker Options

| 参数 | 说明 | 类型 | 可选值 | 默认值 |
|------|------|------|--------|--------|
| shortcuts | 设置快捷选项，需要传入 { text, onClick } 对象 | Object[] | — | — |
| disabledDate | 设置禁用状态，参数为当前日期，要求返回 Boolean | Function | — | — |
| cellClassName | 设置日期的 className | Function(Date) | — | — |
| firstDayOfWeek | 周起始日 | Number | 1 到 7 | 7 |
| onPick | 选中日期后会执行的回调，只有当 daterange 或 datetimerange 才生效 | Function({ maxDate, minDate }) | — | — |

## Shortcuts

| 参数 | 说明 | 类型 | 可选值 | 默认值 |
|------|------|------|--------|--------|
| text | 标题文本 | string | — | — |
| onClick | 选中后的回调函数，参数是 vm，可通过触发 'pick' 事件设置选择器的值 | function | — | — |

## Events

| 事件名称 | 说明 | 回调参数 |
|----------|------|----------|
| change | 用户确认选定的值时触发 | 组件绑定值。格式与绑定值一致，可受 value-format 控制 |
| blur | 当 input 失去焦点时触发 | 组件实例 |
| focus | 当 input 获得焦点时触发 | 组件实例 |

## Methods

| 方法名 | 说明 | 参数 |
|--------|------|------|
| focus | 使 input 获取焦点 | — |

## 最佳实践

1. **日期格式化**：使用 `value-format` 属性可以指定绑定值的格式，避免手动转换 Date 对象。

2. **禁用日期**：通过 `picker-options.disabledDate` 可以禁用特定日期，如禁用未来日期。

3. **范围选择**：使用 `unlink-panels` 可以解除左右面板的联动，方便选择跨月的日期范围。

4. **默认时间**：使用 `default-time` 可以指定范围选择时的具体时刻，如 `['00:00:00', '23:59:59']`。

5. **快捷选项**：为常用日期范围设置快捷选项，提升用户体验，如"最近一周"、"最近一个月"等。
