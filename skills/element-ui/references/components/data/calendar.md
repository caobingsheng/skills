# Calendar 日历

显示日期,用于选择或查看日期。

## 基本用法

通过设置`value`来指定当前显示的月份。如果`value`未指定,则显示当月。`value`支持`v-model`双向绑定。

```vue
<el-calendar v-model="value"></el-calendar>

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

## 自定义内容

通过设置名为`dateCell`的`scoped-slot`来自定义日历单元格中显示的内容。在`scoped-slot`可以获取到date(当前单元格的日期),data(包括type,isSelected,day属性)。

```vue
<el-calendar>
  <template slot="dateCell" slot-scope="{date, data}">
    <p :class="data.isSelected ? 'is-selected' : ''">
      {{ data.day.split('-').slice(1).join('-') }}
      {{ data.isSelected ? '✔️' : ''}}
    </p>
  </template>
</el-calendar>

<style>
.is-selected {
  color: #1989FA;
}
</style>
```

## 自定义范围

设置`range`属性指定日历的显示范围。开始时间必须是周起始日,结束时间必须是周结束日,且时间跨度不能超过两个月。

```vue
<el-calendar :range="['2019-03-04', '2019-03-24']"></el-calendar>
```

## Attributes

| 参数 | 说明 | 类型 | 可选值 | 默认值 |
|------|------|------|--------|--------|
| value / v-model | 绑定值 | Date/string/number | — | — |
| range | 时间范围,包括开始时间与结束时间。开始时间必须是周一,结束时间必须是周日,且时间跨度不能超过两个月。 | Array | — | — |
| first-day-of-week | 周起始日 | Number | 1 到 7 | 1 |

## dateCell scoped slot 参数

| 参数 | 说明 | 类型 | 可选值 | 默认值 |
|------|------|------|--------|--------|
| date | 单元格代表的日期 | Date | — | — |
| data | { type, isSelected, day},type表示该日期的所属月份,可选值有prev-month,current-month,next-month;isSelected标明该日期是否被选中;day是格式化的日期,格式为yyyy-MM-dd | Object | — | — |

## 最佳实践

1. **日期格式化**: 使用`data.day`获取格式化的日期字符串(yyyy-MM-dd),便于显示和处理
2. **自定义样式**: 通过`data.isSelected`判断选中状态,添加自定义样式
3. **月份区分**: 使用`data.type`区分上个月、当前月、下个月的日期,可以给不同月份的日期添加不同样式
4. **范围限制**: 使用`range`属性时,确保开始时间是周一,结束时间是周日,且跨度不超过两个月
5. **周起始日**: 通过`first-day-of-week`设置周起始日,适应不同地区的习惯
