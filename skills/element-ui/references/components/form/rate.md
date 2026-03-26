# Rate 评分

评分组件。

## 基础用法

评分被分为三个等级,可以利用颜色数组对分数及情绪倾向进行分级(默认情况下不区分颜色)。三种颜色分别为:#F7BA2A、#FF9900、#FF5900。

```vue
<div class="block">
  <span class="demonstration">默认不区分颜色</span>
  <el-rate v-model="value1"></el-rate>
</div>
<div class="block">
  <span class="demonstration">区分颜色</span>
  <el-rate
    v-model="value2"
    :colors="['#99A9BF', '#F7BA2A', '#FF9900']">
  </el-rate>
</div>

<script>
export default {
  data() {
    return {
      value1: null,
      value2: null
    }
  }
}
</script>
```

## 辅助文字

用辅助文字直接地表达对应分数。

```vue
<el-rate
  v-model="value"
  show-text>
</el-rate>

<script>
export default {
  data() {
    return {
      value: null
    }
  }
}
</script>
```

## 其它 icon

当有多层评价时,可以使用不同类型的 icon 区分评分层级。

```vue
<el-rate
  v-model="value"
  :icon-classes="iconClasses"
  void-icon-class="icon-rate-face-off"
  :colors="['#99A9BF', '#F7BA2A', '#FF9900']">
</el-rate>

<script>
export default {
  data() {
    return {
      value: null,
      iconClasses: ['icon-rate-face-1', 'icon-rate-face-2', 'icon-rate-face-3']
    }
  }
}
</script>
```

## 只读

只读的评分用来展示分数,允许出现半星。

```vue
<el-rate
  v-model="value"
  disabled
  show-score
  text-color="#ff9900"
  score-template="{value}">
</el-rate>

<script>
export default {
  data() {
    return {
      value: 3.7
    }
  }
}
</script>
```

## Attributes

| 参数 | 说明 | 类型 | 可选值 | 默认值 |
|------|------|------|--------|--------|
| value / v-model | 绑定值 | number | — | 0 |
| max | 最大分值 | number | — | 5 |
| disabled | 是否为只读 | boolean | — | false |
| allow-half | 是否允许半选 | boolean | — | false |
| low-threshold | 低分和中等分数的界限值,值本身被划分在低分中 | number | — | 2 |
| high-threshold | 高分和中等分数的界限值,值本身被划分在高分中 | number | — | 4 |
| colors | icon 的颜色数组,共有 3 个元素,为 3 个分段所对应的颜色 | array | — | ['#F7BA2A', '#F7BA2A', '#F7BA2A'] |
| void-color | 未选中 icon 的颜色 | string | — | #C6D1DE |
| disabled-void-color | 只读时未选中 icon 的颜色 | string | — | #EFF2F7 |
| icon-classes | icon 的类名数组,共有 3 个元素,为 3 个分段所对应的类名 | array | — | ['el-icon-star-on', 'el-icon-star-on', 'el-icon-star-on'] |
| void-icon-class | 未选中 icon 的类名 | string | — | el-icon-star-off |
| disabled-void-icon-class | 只读时未选中 icon 的类名 | string | — | el-icon-star-on |
| show-text | 是否显示辅助文字,若为真,则会从 texts 数组中选取当前分数对应的文字 | boolean | — | false |
| show-score | 是否显示当前分数,show-score 和 show-text 不能同时为真 | boolean | — | false |
| text-color | 辅助文字的颜色 | string | — | #1F2D3D |
| texts | 辅助文字数组 | array | — | ['极差', '失望', '一般', '满意', '惊喜'] |
| score-template | 分数显示模板 | string | — | {value} |

## Events

| 事件名称 | 说明 | 回调参数 |
|----------|------|----------|
| change | 分值改变时触发 | 改变后的分数 |

## 最佳实践

1. **颜色分级**: 使用`colors`属性设置不同分数段的颜色,直观表达评价等级
2. **辅助文字**: 开启`show-text`显示辅助文字,使用`texts`自定义文字内容
3. **显示分数**: 开启`show-score`显示当前分数,使用`score-template`自定义显示格式
4. **半星评分**: 开启`allow-half`允许半星评分,提供更精细的评价
5. **只读模式**: 使用`disabled`设置只读模式,适用于展示场景
6. **自定义图标**: 使用`icon-classes`自定义不同分数段的图标
7. **分数阈值**: 使用`low-threshold`和`high-threshold`设置分数分段阈值
8. **事件监听**: 监听`change`事件获取用户评分变化
