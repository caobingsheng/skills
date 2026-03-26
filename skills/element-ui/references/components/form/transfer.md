# Transfer 穿梭框

穿梭框组件用于在两个列表之间移动数据。

## 基础用法

Transfer的数据通过`data`属性传入。数据需要是一个对象数组,每个对象有以下属性:`key`为数据的唯一标识,`label`为显示文本,`disabled`表示是否禁用。目标列表中的数据项会同步到绑定至`v-model`的变量,值为数据项的`key`集合。当然,如果希望在初始渲染时所有项都默认在目标列表中,可以将`v-model`绑定的变量初始化为`data`的所有`key`组成的数组即可。

```vue
<template>
  <el-transfer
    v-model="value"
    :data="data">
  </el-transfer>
</template>

<script>
export default {
  data() {
    const generateData = _ => {
      const data = [];
      for (let i = 1; i <= 15; i++) {
        data.push({
          key: i,
          label: `备选项 ${ i }`,
          disabled: i % 4 === 0
        });
      }
      return data;
    };
    return {
      data: generateData(),
      value: [1, 4]
    };
  }
};
</script>
```

## 可搜索

在数据很多的情况下,可以对数据进行搜索。

```vue
<el-transfer
  v-model="value"
  filterable
  :filter-method="filterMethod"
  filter-placeholder="请输入城市拼音"
  :data="data">
</el-transfer>

<script>
export default {
  data() {
    const generateData = _ => {
      const data = [];
      const cities = ['上海', '北京', '广州', '深圳', '南京', '武汉', '成都', '西安', '杭州', '长沙'];
      const pinyin = ['shanghai', 'beijing', 'guangzhou', 'shenzhen', 'nanjing', 'wuhan', 'chengdu', 'xian', 'hangzhou', 'changsha'];
      cities.forEach((city, index) => {
        data.push({
          label: city,
          key: index,
          pinyin: pinyin[index]
        });
      });
      return data;
    };
    return {
      data: generateData(),
      value: [],
      filterMethod(query, item) {
        return item.pinyin.indexOf(query) > -1;
      }
    };
  }
};
</script>
```

## 可自定义

可以对列表标题文案、按钮文案、数据项的渲染函数、列表底部的文案等进行自定义。

```vue
<el-transfer
  v-model="value"
  :props="{
    key: 'value',
    label: 'desc'
  }"
  :titles="['Source', 'Target']"
  :button-texts="['To Left', 'To Right']"
  :format="{
    noChecked: '${total}',
    hasChecked: '${checked}/${total}'
  }"
  @change="handleChange"
  :data="data">
  <span slot-scope="{ option }">{{ option.key }} - {{ option.label }}</span>
  <span slot="left-footer" slot-scope="{ option }">Total: {{ data.length }}</span>
  <span slot="right-footer" slot-scope="{ option }">Checked: {{ value.length }}</span>
</el-transfer>

<script>
export default {
  data() {
    const generateData = _ => {
      const data = [];
      for (let i = 1; i <= 15; i++) {
        data.push({
          value: i,
          desc: `Option ${ i }`,
          disabled: i % 4 === 0
        });
      }
      return data;
    };
    return {
      data: generateData(),
      value: [],
      value4: [1],
      renderFunc(h, option) {
        return <span>{ option.key } - { option.label }</span>;
      }
    };
  },
  methods: {
    handleChange(value, direction, movedKeys) {
      console.log(value, direction, movedKeys);
    }
  }
};
</script>
```

## 数据项属性别名

默认情况下,Transfer 仅识别数据项中的`key`、`label`和`disabled`字段。如果你的数据项字段不同,可以使用`props`属性进行别名。

```vue
<el-transfer
  v-model="value"
  :props="{
    key: 'value',
    label: 'desc'
  }"
  :data="data">
</el-transfer>

<script>
export default {
  data() {
    const generateData = _ => {
      const data = [];
      for (let i = 1; i <= 15; i++) {
        data.push({
          value: i,
          desc: `Option ${ i }`,
          disabled: i % 4 === 0
        });
      }
      return data;
    };
    return {
      data: generateData(),
      value: []
    };
  }
};
</script>
```

## Attributes

| 参数 | 说明 | 类型 | 可选值 | 默认值 |
|------|------|------|--------|--------|
| data / v-model | Transfer 的数据源 / 目标列表中被选中的数据项的 key 集合 | array[{ key, label, disabled }] / array | — | [ ] / [ ] |
| filterable | 是否可搜索 | boolean | — | false |
| filter-placeholder | 搜索框占位符 | string | — | 请输入搜索内容 |
| filter-method | 自定义搜索方法 | function | — | — |
| titles | 列表标题文案 | array | — | ['列表 1', '列表 2'] |
| button-texts | 按钮文案 | array | — | [ ] |
| render-content | 自定义数据项渲染函数 | function(h, option) | — | — |
| format | 列表底部勾选状态文案 | object{noChecked, hasChecked} | — | { noChecked: '${checked}/${total}', hasChecked: '${checked}/${total}' } |
| props | 数据源的字段别名 | object{ key, label, disabled } | — | { key: 'key', label: 'label', disabled: 'disabled' } |
| left-default-checked | 初始状态下左侧列表的已勾选项的 key 数组 | array | — | [ ] |
| right-default-checked | 初始状态下右侧列表的已勾选项的 key 数组 | array | — | [ ] |
| target-order | 右侧列表元素的排序策略:若为 original,则保持与数据源相同的顺序;若为 push,则新加入的元素排在最后;若为 unshift,则新加入的元素排在最前 | string | original / push / unshift | original |

## Slots

| name | 说明 |
|------|------|
| — | 自定义数据项的内容,参数为 { option } |
| left-footer | 左侧列表底部的内容 |
| right-footer | 右侧列表底部的内容 |

## Events

| 事件名称 | 说明 | 回调参数 |
|----------|------|----------|
| change | 右侧列表元素变化时触发 | 当前值、数据移动的方向('left' / 'right')、发生移动的数据 key 数组 |
| left-check-change | 左侧列表元素被用户选中/取消选中时触发 | 当前被选中的元素的 key 数组、当前变更的元素的 key 数组 |
| right-check-change | 右侧列表元素被用户选中/取消选中时触发 | 当前被选中的元素的 key 数组、当前变更的元素的 key 数组 |

## Methods

| 方法名 | 说明 | 参数 |
|--------|------|------|
| clearQuery | 清空某个面板的搜索关键词 | 'left' / 'right' |

## 最佳实践

1. **数据结构**: 确保data数据结构正确,包含key、label、disabled等字段
2. **属性别名**: 使用`props`属性自定义字段别名,适配不同的数据结构
3. **搜索功能**: 开启`filterable`支持搜索,使用`filter-method`自定义搜索逻辑
4. **自定义渲染**: 使用`render-content`或默认插槽自定义数据项渲染
5. **排序策略**: 使用`target-order`控制右侧列表元素的排序策略(original/push/unshift)
6. **文案自定义**: 使用`titles`、`button-texts`、`format`自定义文案
7. **底部插槽**: 使用`left-footer`和`right-footer`插槽自定义底部内容
8. **事件监听**: 监听`change`事件获取右侧列表元素变化,`left-check-change`和`right-check-change`监听选中状态变化
