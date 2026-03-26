# Select 选择器

Select 选择器用于当选项过多时，使用下拉菜单展示并选择内容。

## 基础用法

### 基础单选
```vue
<el-select v-model="value" placeholder="请选择">
  <el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value">
  </el-option>
</el-select>

<script>
export default {
  data() {
    return {
      options: [
        { value: '选项1', label: '黄金糕' },
        { value: '选项2', label: '双皮奶' },
        { value: '选项3', label: '蚵仔煎' },
        { value: '选项4', label: '龙须面' },
        { value: '选项5', label: '北京烤鸭' }
      ],
      value: ''
    }
  }
}
</script>
```

### 可清空单选
```vue
<el-select v-model="value" clearable placeholder="请选择">
  <el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value">
  </el-option>
</el-select>
```

### 基础多选
```vue
<el-select v-model="value1" multiple placeholder="请选择">
  <el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value">
  </el-option>
</el-select>

<el-select v-model="value2" multiple collapse-tags placeholder="请选择">
  <el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value">
  </el-option>
</el-select>
```

### 可搜索
```vue
<el-select v-model="value" filterable placeholder="请选择">
  <el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value">
  </el-option>
</el-select>
```

### 分组
```vue
<el-select v-model="value" placeholder="请选择">
  <el-option-group v-for="group in options" :key="group.label" :label="group.label">
    <el-option v-for="item in group.options" :key="item.value" :label="item.label" :value="item.value">
    </el-option>
  </el-option-group>
</el-select>

<script>
export default {
  data() {
    return {
      options: [
        {
          label: '热门城市',
          options: [
            { value: 'Shanghai', label: '上海' },
            { value: 'Beijing', label: '北京' }
          ]
        },
        {
          label: '城市名',
          options: [
            { value: 'Chengdu', label: '成都' },
            { value: 'Shenzhen', label: '深圳' }
          ]
        }
      ],
      value: ''
    }
  }
}
</script>
```

### 远程搜索
```vue
<el-select v-model="value" multiple filterable remote reserve-keyword placeholder="请输入关键词"
  :remote-method="remoteMethod" :loading="loading">
  <el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value">
  </el-option>
</el-select>

<script>
export default {
  data() {
    return {
      options: [],
      value: [],
      list: [],
      loading: false,
      states: ["Alabama", "Alaska", "Arizona", "Arkansas", "California"]
    }
  },
  mounted() {
    this.list = this.states.map(item => {
      return { value: `value:${item}`, label: `label:${item}` };
    });
  },
  methods: {
    remoteMethod(query) {
      if (query !== '') {
        this.loading = true;
        setTimeout(() => {
          this.loading = false;
          this.options = this.list.filter(item => {
            return item.label.toLowerCase().indexOf(query.toLowerCase()) > -1;
          });
        }, 200);
      } else {
        this.options = [];
      }
    }
  }
}
</script>
```

### 创建条目
```vue
<el-select v-model="value" multiple filterable allow-create default-first-option placeholder="请选择文章标签">
  <el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value">
  </el-option>
</el-select>
```

### 可搜索
```vue
<el-select v-model="value" filterable placeholder="请选择">
  <el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value">
  </el-option>
</el-select>
```

### 可清空
```vue
<el-select v-model="value" clearable placeholder="请选择">
  <el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value">
  </el-option>
</el-select>
```

### 基础多选
```vue
<el-select v-model="value1" multiple placeholder="请选择">
  <el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value">
  </el-option>
</el-select>

<el-select v-model="value2" multiple collapse-tags placeholder="请选择">
  <el-option v-for="item in options" :key="item.value" :label="item.label" :value="item.value">
  </el-option>
</el-select>
```

## Select Attributes

| 参数 | 说明 | 类型 | 可选值 | 默认值 |
|------|------|------|--------|--------|
| value / v-model | 绑定值 | boolean/string/number | — | — |
| multiple | 是否多选 | boolean | — | false |
| disabled | 是否禁用 | boolean | — | false |
| value-key | 作为 value 唯一标识的键名 | string | — | value |
| size | 输入框尺寸 | string | medium/small/mini | — |
| clearable | 是否可以清空选项 | boolean | — | false |
| collapse-tags | 多选时是否将选中值按文字的形式展示 | boolean | — | false |
| multiple-limit | 多选时用户最多可以选择的项目数 | number | — | 0 |
| placeholder | 占位符 | string | — | 请选择 |
| filterable | 是否可搜索 | boolean | — | false |
| allow-create | 是否允许用户创建新条目 | boolean | — | false |
| filter-method | 自定义搜索方法 | function | — | — |
| remote | 是否为远程搜索 | boolean | — | false |
| remote-method | 远程搜索方法 | function | — | — |
| loading | 是否正在从远程获取数据 | boolean | — | false |
| loading-text | 远程加载时显示的文字 | string | — | 加载中 |
| no-match-text | 搜索条件无匹配时显示的文字 | string | — | 无匹配数据 |
| no-data-text | 选项为空时显示的文字 | string | — | 无数据 |
| popper-class | Select 下拉框的类名 | string | — | — |
| reserve-keyword | 多选且可搜索时，是否在选中一个选项后保留当前的搜索关键词 | boolean | — | false |
| default-first-option | 在输入框按下回车，选择第一个匹配项 | boolean | — | false |
| popper-append-to-body | 是否将弹出框插入至 body 元素 | boolean | — | true |
| automatic-dropdown | 不可搜索的 Select，是否在输入框获得焦点后自动弹出选项菜单 | boolean | — | false |

## Select Events

| 事件名称 | 说明 | 回调参数 |
|----------|------|----------|
| change | 选中值发生变化时触发 | 目前的选中值 |
| visible-change | 下拉框出现/隐藏时触发 | 出现则为 true，隐藏则为 false |
| remove-tag | 多选模式下移除tag时触发 | 移除的tag值 |
| clear | 可清空的单选模式下用户点击清空按钮时触发 | — |
| blur | 当 input 失去焦点时触发 | (event: Event) |
| focus | 当 input 获得焦点时触发 | (event: Event) |

## Select Slots

| name | 说明 |
|------|------|
| — | Option 组件列表 |
| prefix | Select 组件头部内容 |
| empty | 无选项时的列表 |

## Option Group Attributes

| 参数 | 说明 | 类型 | 可选值 | 默认值 |
|------|------|------|--------|--------|
| label | 分组的组名 | string | — | — |
| disabled | 是否将该分组下所有选项置为禁用 | boolean | — | false |

## Option Attributes

| 参数 | 说明 | 类型 | 可选值 | 默认值 |
|------|------|------|--------|--------|
| value | 选项的值 | string/number/object | — | — |
| label | 选项的标签 | string/number | — | — |
| disabled | 是否禁用该选项 | boolean | — | false |

## Methods

| 方法名 | 说明 | 参数 |
|--------|------|------|
| focus | 使 input 获取焦点 | — |
| blur | 使 input 失去焦点，并隐藏下拉框 | — |

## 最佳实践

1. **对象类型绑定值**：如果 Select 的绑定值为对象类型，请务必指定 `value-key` 作为它的唯一性标识
2. **远程搜索**：远程搜索需要将 `filterable` 和 `remote` 设置为 true，同时传入 `remote-method`
3. **创建条目**：使用 `allow-create` 属性时，`filterable` 必须为 true
4. **多选限制**：使用 `multiple-limit` 限制用户最多可以选择的项目数
5. **自定义模板**：将自定义的 HTML 模板插入 el-option 的 slot 中即可自定义选项样式
