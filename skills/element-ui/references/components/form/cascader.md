# Cascader 级联选择器

当一个数据集合有清晰的层级结构时,可通过级联选择器逐级查看并选择。

## 基础用法

只需为Cascader的`options`属性指定选项数组即可渲染出一个级联选择器,通过`props.expandTrigger`可以定义展开子级菜单的触发方式。

```vue
<el-cascader
  v-model="value"
  :options="options"
  @change="handleChange"></el-cascader>

<script>
export default {
  data() {
    return {
      value: [],
      options: [{
        value: 'guide',
        label: '指南',
        children: [{
          value: 'design',
          label: '设计原则',
          children: [{
            value: 'consistency',
            label: '一致性'
          }, {
            value: 'feedback',
            label: '反馈'
          }]
        }, {
          value: 'component',
          label: '组件',
          children: [{
            value: 'basic',
            label: 'Basic'
          }, {
            value: 'form',
            label: 'Form'
          }]
        }]
      }]
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

## 禁用选项

通过在数据源中设置`disabled`字段来声明该选项是禁用的。

```vue
<el-cascader v-model="value" :options="options"></el-cascader>

<script>
export default {
  data() {
    return {
      value: [],
      options: [{
        value: 'guide',
        label: '指南',
        disabled: true,
        children: [{
          value: 'design',
          label: '设计原则',
          children: [{
            value: 'consistency',
            label: '一致性'
          }]
        }]
      }]
    };
  }
};
</script>
```

## 可清空

通过`clearable`属性设置是否可清空选项。

```vue
<el-cascader v-model="value" :options="options" clearable></el-cascader>
```

## 仅显示最后一级

可以仅在输入框中显示最后一级,使用`props.showAllLevels`属性即可。

```vue
<el-cascader
  v-model="value"
  :options="options"
  :props="{ showAllLevels: false }"></el-cascader>
```

## 多选

可通过`props.multiple`属性开启多选模式。

```vue
<el-cascader
  v-model="value"
  :options="options"
  :props="{ multiple: true }"
  clearable></el-cascader>
```

## 选择任意一级选项

在单选模式下,你只能选择叶子节点;而在多选模式下,勾选父节点实际上选中的是所有子节点。配置`props.checkStrictly`为true后,可以让父子节点取消关联,从而选择任意一级选项。

```vue
<el-cascader
  v-model="value"
  :options="options"
  :props="{ checkStrictly: true }"
  clearable></el-cascader>
```

## 搜索

可以快捷地搜索选项并选择。

```vue
<el-cascader
  v-model="value"
  :options="options"
  :props="{ expandTrigger: 'hover' }"
  filterable></el-cascader>
```

## Attributes

| 参数 | 说明 | 类型 | 可选值 | 默认值 |
|------|------|------|--------|--------|
| value / v-model | 选中项绑定值 | array | — | — |
| options | 可选项数据源,键名可通过`props`属性配置 | array | — | — |
| props | 配置选项,具体见下表 | object | — | — |
| size | 尺寸 | string | medium / small / mini | — |
| placeholder | 输入框占位文本 | string | — | 请选择 |
| disabled | 是否禁用 | boolean | — | false |
| clearable | 是否支持清空选项 | boolean | — | false |
| show-all-levels | 是否显示所有级别的选项 | boolean | — | true |
| collapse-tags | 多选模式下是否折叠Tag | boolean | — | false |
| separator | 选项分隔符 | string | — | 斜杠'/' |
| filterable | 是否可搜索选项 | boolean | — | false |
| filter-method | 自定义搜索逻辑,第一个参数是节点node,第二个参数是搜索关键词keyword,通过返回布尔值表示是否命中 | function | — | — |
| debounce | 搜索关键词输入的去抖延迟,毫秒 | number | — | 300 |
| before-filter | 筛选之前的钩子,参数为输入的值,若返回 false 或者返回 Promise 且被 reject,则停止筛选 | function(value) | — | — |
| popper-class | 自定义浮层类名 | string | — | — |

## Props

| 参数 | 说明 | 类型 | 可选值 | 默认值 |
|------|------|------|--------|--------|
| expandTrigger | 次级菜单的展开方式 | string | click / hover | 'click' |
| multiple | 是否多选 | boolean | — | false |
| checkStrictly | 是否严格的遵守父子节点不互相关联 | boolean | — | false |
| emitPath | 在选中节点改变时,是否返回由该节点所在的各级菜单的值所组成的数组,若设置 false,则只返回该节点的值 | boolean | — | true |
| lazy | 是否动态加载子节点,需与 lazyMethod 方法结合使用 | boolean | — | false |
| lazyMethod | 加载动态数据的方法,仅在 lazy 为 true 时有效 | function(node, resolve),node为当前点击的节点,resolve为数据加载完成的回调(需调用) | — | — |
| value | 指定选项的值字段名 | string | — | value |
| label | 指定选项标签字段名 | string | — | label |
| children | 指定子选项的字段名 | string | — | children |
| disabled | 指定选项的禁用字段名 | string | — | disabled |
| leaf | 指定选项的叶子节点的字段名 | string | — | leaf |

## Events

| 事件名称 | 说明 | 回调参数 |
|----------|------|----------|
| change | 当选中节点变化时触发 | 选中节点的值 |
| expand-change | 当展开节点发生变化时触发 | 各父级选项值组成的数组 |
| visible-change | 下拉框显示/隐藏时触发 | 出现则为 true,消失则为 false |
| remove-tag | 在多选模式下,移除Tag时触发 | 移除的Tag对应的节点的值 |
| blur | 当失去焦点时触发 | (event: Event) |
| focus | 当获得焦点时触发 | (event: Event) |

## Slots

| 名称 | 说明 |
|------|------|
| — | 自定义备选项的节点内容,参数为 { node, data } |
| empty | 无匹配选项时的内容 |

## 最佳实践

1. **数据结构**: 确保options数据结构正确,包含value、label、children等字段
2. **展开方式**: 使用`expandTrigger: 'hover'`实现鼠标悬停展开,提升交互体验
3. **多选模式**: 开启`multiple`实现多选,配合`collapse-tags`折叠Tag节省空间
4. **任意选择**: 设置`checkStrictly: true`允许选择任意一级,不限于叶子节点
5. **搜索功能**: 开启`filterable`支持搜索,使用`filter-method`自定义搜索逻辑
6. **动态加载**: 使用`lazy`和`lazyMethod`实现动态加载子节点,适用于大数据量
7. **清空选项**: 开启`clearable`允许清空已选项,提升用户体验
