# Input 输入框

通过鼠标或键盘输入字符。Input 为受控组件，它总会显示 Vue 绑定值。

## 基础用法

```vue
<el-input v-model="input" placeholder="请输入内容"></el-input>

<script>
export default {
  data() {
    return {
      input: ''
    }
  }
}
</script>
```

## 禁用状态

```vue
<el-input placeholder="请输入内容" v-model="input" :disabled="true"></el-input>
```

## 可清空

```vue
<el-input placeholder="请输入内容" v-model="input" clearable></el-input>
```

## 密码框

```vue
<el-input placeholder="请输入密码" v-model="input" show-password></el-input>
```

## 带 icon 的输入框

```vue
<!-- 属性方式 -->
<el-input placeholder="请选择日期" suffix-icon="el-icon-date" v-model="input1"></el-input>
<el-input placeholder="请输入内容" prefix-icon="el-icon-search" v-model="input2"></el-input>

<!-- slot 方式 -->
<el-input placeholder="请选择日期" v-model="input3">
  <i slot="suffix" class="el-input__icon el-icon-date"></i>
</el-input>
<el-input placeholder="请输入内容" v-model="input4">
  <i slot="prefix" class="el-input__icon el-icon-search"></i>
</el-input>
```

## 文本域

```vue
<el-input type="textarea" :rows="2" placeholder="请输入内容" v-model="textarea"></el-input>
```

## 可自适应文本高度的文本域

```vue
<el-input type="textarea" autosize placeholder="请输入内容" v-model="textarea1"></el-input>
<el-input type="textarea" :autosize="{ minRows: 2, maxRows: 4}" placeholder="请输入内容" v-model="textarea2"></el-input>
```

## 复合型输入框

```vue
<el-input placeholder="请输入内容" v-model="input1">
  <template slot="prepend">Http://</template>
</el-input>

<el-input placeholder="请输入内容" v-model="input2">
  <template slot="append">.com</template>
</el-input>

<el-input placeholder="请输入内容" v-model="input3" class="input-with-select">
  <el-select v-model="select" slot="prepend" placeholder="请选择">
    <el-option label="餐厅名" value="1"></el-option>
    <el-option label="订单号" value="2"></el-option>
  </el-select>
  <el-button slot="append" icon="el-icon-search"></el-button>
</el-input>
```

## 尺寸

```vue
<el-input placeholder="请输入内容" v-model="input1"></el-input>
<el-input size="medium" placeholder="请输入内容" v-model="input2"></el-input>
<el-input size="small" placeholder="请输入内容" v-model="input3"></el-input>
<el-input size="mini" placeholder="请输入内容" v-model="input4"></el-input>
```

## 输入长度限制

```vue
<el-input type="text" placeholder="请输入内容" v-model="text" maxlength="10" show-word-limit></el-input>
<el-input type="textarea" placeholder="请输入内容" v-model="textarea" maxlength="30" show-word-limit></el-input>
```

## Attributes

| 参数 | 说明 | 类型 | 可选值 | 默认值 |
|------|------|------|--------|--------|
| type | 类型 | string | text, textarea 和其他原生 input 的 type 值 | text |
| value / v-model | 绑定值 | string / number | — | — |
| maxlength | 原生属性，最大输入长度 | number | — | — |
| minlength | 原生属性，最小输入长度 | number | — | — |
| show-word-limit | 是否显示输入字数统计 | boolean | — | false |
| placeholder | 输入框占位文本 | string | — | — |
| clearable | 是否可清空 | boolean | — | false |
| show-password | 是否显示切换密码图标 | boolean | — | false |
| disabled | 禁用 | boolean | — | false |
| size | 输入框尺寸 | string | medium / small / mini | — |
| prefix-icon | 输入框头部图标 | string | — | — |
| suffix-icon | 输入框尾部图标 | string | — | — |
| rows | 输入框行数（只对 textarea 有效） | number | — | 2 |
| autosize | 自适应内容高度（只对 textarea 有效） | boolean / object | — | false |
| name | 原生属性 | string | — | — |
| readonly | 原生属性，是否只读 | boolean | — | false |
| max | 原生属性，设置最大值 | — | — | — |
| min | 原生属性，设置最小值 | — | — | — |
| step | 原生属性，设置输入字段的合法数字间隔 | — | — | — |
| resize | 控制是否能被用户缩放 | string | none, both, horizontal, vertical | — |
| autofocus | 原生属性，自动获取焦点 | boolean | true, false | false |
| validate-event | 输入时是否触发表单的校验 | boolean | — | true |

## Slots

| name | 说明 |
|------|------|
| prefix | 输入框头部内容（只对 type="text" 有效） |
| suffix | 输入框尾部内容（只对 type="text" 有效） |
| prepend | 输入框前置内容（只对 type="text" 有效） |
| append | 输入框后置内容（只对 type="text" 有效） |

## Events

| 事件名称 | 说明 | 回调参数 |
|---------|------|----------|
| blur | 在 Input 失去焦点时触发 | (event: Event) |
| focus | 在 Input 获得焦点时触发 | (event: Event) |
| change | 仅在输入框失去焦点或用户按下回车时触发 | (value: string \| number) |
| input | 在 Input 值改变时触发 | (value: string \| number) |
| clear | 在点击由 clearable 属性生成的清空按钮时触发 | — |

## Methods

| 方法名 | 说明 | 参数 |
|--------|------|------|
| focus | 使 input 获取焦点 | — |
| blur | 使 input 失去焦点 | — |
| select | 选中 input 中的文字 | — |

## 最佳实践

- 使用 `v-model` 双向绑定输入值
- 表单验证使用 `validate-event` 属性
- 密码输入使用 `show-password` 属性
- 长文本输入使用 `type="textarea"`
- 需要限制输入长度时使用 `maxlength` 和 `show-word-limit`
