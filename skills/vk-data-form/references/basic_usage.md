# 基础用法与columns配置

## 基础模板结构

```vue
<template>
  <vk-data-dialog
    v-model="form1.props.show"
    title="表单标题"
    width="600px"
    mode="form"
  >
    <vk-data-form
      ref="form1"
      v-model="form1.data"
      :action="form1.props.action"
      :columns="form1.props.columns"
      :rules="form1.props.rules"
      :form-type="form1.props.formType"
      :loading.sync="form1.props.loading"
      label-width="140px"
      @success="onFormSuccess"
    ></vk-data-form>
  </vk-data-dialog>
</template>

<script>
let that;
let vk = uni.vk;

export default {
  data() {
    return {
      form1: {
        data: {},
        props: {
          action: "admin/xxx/sys/add",
          columns: [],
          rules: {},
          formType: "add",
          loading: false,
          show: false
        }
      }
    };
  },
  onLoad(options) {
    that = this;
    vk = that.vk;
    that.init(options);
  },
  methods: {
    init(options) {},
    onFormSuccess(res) {}
  }
}
</script>
```

## columns 完整配置

### 基础字段

```javascript
columns: [
  // 单行文本
  { key: "nickname", title: "昵称", type: "text", placeholder: "请输入昵称" },
  // 多行文本
  {
    key: "remark", title: "备注", type: "textarea",
    autosize: { minRows: 4, maxRows: 10 },
    maxlength: 200,
    showWordLimit: true
  },
  // 数字
  { key: "age", title: "年龄", type: "number", precision: 0, min: 0, max: 150 },
  // 金额 (100 = 1元)
  { key: "price", title: "价格", type: "money", tips: "100 = 1元" },
  // 百分比 (1 = 1%)
  { key: "rate", title: "比率", type: "percentage", precision: 0 },
  // 折扣 (1 = 10%)
  { key: "discount", title: "折扣", type: "discount" },
  // 带前后缀
  { key: "url", title: "网址", type: "text", prepend: "http://", suffixIcon: "el-icon-link" }
]
```

### 选择型字段

```javascript
columns: [
  // 单选
  {
    key: "gender", title: "性别", type: "radio",
    data: [
      { value: 1, label: "男" },
      { value: 2, label: "女" }
    ]
  },
  // 多选
  {
    key: "hobby", title: "爱好", type: "checkbox",
    data: [
      { value: 1, label: "阅读" },
      { value: 2, label: "运动" },
      { value: 3, label: "音乐" }
    ]
  },
  // 下拉选择
  {
    key: "city", title: "城市", type: "select",
    data: [
      { value: "shanghai", label: "上海" },
      { value: "beijing", label: "北京" }
    ]
  },
  // 开关
  { key: "status", title: "状态", type: "switch" },
  // 评分
  { key: "score", title: "评分", type: "rate", allowHalf: false },
  // 滑块
  { key: "progress", title: "进度", type: "slider" },
  // 颜色
  { key: "color", title: "颜色", type: "color" },
  // 颜色(带透明度)
  { key: "colorAlpha", title: "颜色", type: "color", showAlpha: true }
]
```

### 日期时间字段

```javascript
columns: [
  // 日期
  { key: "birthday", title: "生日", type: "date", dateType: "date" },
  // 日期时间
  { key: "createTime", title: "创建时间", type: "date", dateType: "datetime" },
  // 日期范围
  { key: "dateRange", title: "日期范围", type: "date", dateType: "daterange" },
  // 日期时间范围
  { key: "dateTimeRange", title: "时间范围", type: "date", dateType: "datetimerange" },
  // 时间
  { key: "time", title: "时间", type: "time" },
  // 时间范围
  { key: "timeRange", title: "时间范围", type: "time", isRange: true }
]
```

### 远程数据字段

```javascript
columns: [
  // 用户选择器
  {
    key: "user_id", title: "用户", type: "remote-select",
    placeholder: "请输入用户账号/昵称",
    action: "admin/select/kh/user"
  },
  // 表格选择器(单选)
  {
    key: "role_id", title: "角色", type: "table-select",
    placeholder: "请选择角色",
    action: "admin/system/role/sys/getList",
    columns: [
      { key: "role_name", title: "角色名称", type: "text", nameKey: true },
      { key: "role_id", title: "角色ID", type: "text", idKey: true }
    ]
  },
  // 表格选择器(多选)
  {
    key: "role_ids", title: "角色", type: "table-select",
    placeholder: "请选择角色",
    action: "admin/system/role/sys/getList",
    columns: [
      { key: "role_name", title: "角色名称", type: "text", nameKey: true },
      { key: "role_id", title: "角色ID", type: "text", idKey: true }
    ],
    multiple: true
  },
  // 级联选择
  {
    key: "category", title: "分类", type: "cascader",
    action: "admin/system/permission/sys/getAll",
    props: {
      list: "rows",
      value: "permission_id",
      label: "label",
      children: "children",
      multiple: true
    }
  },
  // 地址选择
  { key: "address", title: "地址", type: "address" }
]
```

### 布局字段

```javascript
columns: [
  // 分组标题
  { key: "", title: "基本信息", type: "bar-title" },
  // 分组布局
  {
    key: "", title: "", type: "group", justify: "start",
    columns: [
      { key: "name", title: "姓名", type: "text" },
      { key: "age", title: "年龄", type: "number" }
    ]
  },
  // 对象嵌套
  {
    key: "contact", title: "联系方式", type: "object",
    columns: [
      { key: "phone", title: "电话", type: "text" },
      { key: "email", title: "邮箱", type: "text" }
    ]
  }
]
```

### 展示字段

```javascript
columns: [
  // 文本展示
  { key: "textView", title: "文本", type: "text-view" },
  // 金额展示
  { key: "moneyView", title: "金额", type: "money-view" },
  // HTML展示
  { key: "htmlView", title: "HTML", type: "html" },
  // 富文本
  { key: "content", title: "内容", type: "editor" }
]
```

### 文件上传

```javascript
columns: [
  { key: "images", title: "图片", type: "image", limit: 6 }
]
```

## columns 属性说明

| 属性 | 说明 | 类型 | 默认值 |
|------|------|------|--------|
| key | 字段名 | String | - |
| title | 字段标题 | String | - |
| type | 组件类型 | String | - |
| width | 宽度(px) | Number | - |
| placeholder | 占位符 | String | - |
| tips | 提示信息 | String/Array | - |
| labelWidth | 单独设置label宽度 | Number | - |
| showLabel | 是否显示label | Boolean | true |
| show | 复用时的显示规则 | Array | - |
| showRule | 自定义显示规则 | String/Function | - |
| disabled | 禁用规则 | Boolean/String/Function | false |
| watch | 监听值变化 | Function | - |
| oneLine | 强制单独一行 | Boolean | false |
