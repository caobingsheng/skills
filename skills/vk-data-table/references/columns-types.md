# columns字段类型完整列表

本文档详细说明vk-data-table组件中columns配置的所有字段类型。

## 基础类型

### text - 文本

```javascript
{
  key: "username",
  title: "用户名",
  type: "text",
  width: 150,
  defaultValue: "未设置",
  formatter: (val, row, column, index) => {
    return val + "（已审核）";
  }
}
```

### html - HTML渲染

```javascript
{
  key: "content",
  title: "内容",
  type: "html",
  width: 200,
  formatter: (val, row, column, index) => {
    return `<span style="color: red">${val}</span>`;
  }
}
```

### money - 金额

```javascript
{
  key: "balance",
  title: "余额",
  type: "money",
  width: 120
}
```

### percentage - 百分比

```javascript
{
  key: "rate",
  title: "占比",
  type: "percentage",
  width: 120
}
```

## 图片与媒体

### image - 图片

```javascript
{
  key: "avatar",
  title: "头像",
  type: "image",
  width: 120,
  imageWidth: 60,  // 图片宽度
  imageHeight: 60, // 图片高度
  preview: true    // 是否可预览
}
```

### avatar - 头像

```javascript
{
  key: "avatar",
  title: "头像",
  type: "avatar",
  width: 80,
  imageWidth: 40,
  shape: "circle"  // circle圆形 / square方形
}
```

## 选择与状态

### radio - 单选

```javascript
{
  key: "gender",
  title: "性别",
  type: "radio",
  width: 120,
  defaultValue: 0,
  data: [
    { value: 1, label: "男" },
    { value: 2, label: "女" },
    { value: 0, label: "保密" }
  ]
}
```

### select - 下拉选择

```javascript
{
  key: "type",
  title: "类型",
  type: "select",
  width: 120,
  data: [
    { value: 1, label: "收入" },
    { value: 2, label: "支出" }
  ]
}
```

### checkbox - 多选

```javascript
{
  key: "tags",
  title: "标签",
  type: "checkbox",
  width: 200,
  defaultValue: [],
  data: [
    { value: 1, label: "热门" },
    { value: 2, label: "推荐" }
  ]
}
```

### switch - 开关

```javascript
{
  key: "status",
  title: "状态",
  type: "switch",
  width: 120,
  activeValue: true,   // 开时的值
  inactiveValue: false // 关时的值
}
```

### tag - 标签

```javascript
{
  key: "type",
  title: "类型",
  type: "tag",
  width: 120,
  size: "small",  // medium / small / mini
  data: [
    { value: 1, label: "收入", tagType: "success" },
    { value: 2, label: "支出", tagType: "danger" }
  ]
}
```

### rate - 评分

```javascript
{
  key: "score",
  title: "评分",
  type: "rate",
  width: 120,
  max: 5,
  disabled: true
}
```

## 时间与日期

### time - 时间

```javascript
{
  key: "_add_time",
  title: "添加时间",
  type: "time",
  width: 160,
  valueFormat: "yyyy-MM-dd hh:mm:ss"
}
```

### dateDiff - 距离现在

```javascript
{
  key: "_add_time",
  title: "距离现在",
  type: "dateDiff",
  width: 120
}
```

### dateDiff2 - 倒计时

```javascript
{
  key: "exp_time",
  title: "到期剩",
  type: "dateDiff2",
  width: 80,
  endText: "已到期",
  defaultValue: "永久",
  sortable: "custom"
}
```

## 复杂类型

### userInfo - 用户信息

```javascript
{
  key: "userInfo",
  title: "用户",
  type: "userInfo",
  width: 120
}
// 值需有avatar和nickname字段
```

### group - 分组显示

```javascript
{
  key: "",
  title: "分组显示",
  type: "group",
  minWidth: 290,
  align: "left",
  columns: [
    { key: "_id", title: "ID", type: "text" },
    { key: "avatar", title: "头像", type: "avatar" },
    { key: "nickname", title: "昵称", type: "text" }
  ]
}
```

### object - 对象字段

```javascript
{
  key: "object1",
  title: "对象字段",
  type: "object",
  width: 180,
  align: "left",
  columns: [
    { key: "key1", title: "对象内字段1", type: "text" },
    { key: "key2", title: "对象内字段2", type: "text" }
  ]
}
```

### table - 对象数组字段

```javascript
{
  key: "arr1",
  title: "对象数组字段",
  type: "table",
  width: 200,
  show: ["detail"],  // 建议只在详情页展示
  rowHeight: 50,
  columns: [
    { key: "key1", title: "字段1", type: "text", width: 120 },
    { key: "key2", title: "字段2", type: "text", width: 120 }
  ]
}
```

### json - JSON字段

```javascript
{
  key: "metadata",
  title: "元数据",
  type: "json",
  width: 120,
  maxHeight: 300
}
```

### icon - 图标

```javascript
{
  key: "icon",
  title: "图标",
  type: "icon",
  width: 120,
  data: [
    { value: 1, icon: "vk-icon-activityfill" },
    { value: 2, icon: "vk-icon-crownfill" }
  ]
}
```

### address - 地址

```javascript
{
  key: "address",
  title: "地址",
  type: "address",
  width: 200
}
```

## columns通用属性

所有字段类型都支持以下属性：

| 属性 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| key | String | - | 字段键名（必填） |
| title | String | - | 列标题（必填） |
| type | String | - | 字段类型（必填） |
| width | Number | - | 列宽度 |
| minWidth | Number | - | 最小宽度（自动填充） |
| align | String | center | 对齐方式：left/center/right |
| headerAlign | String | center | 表头对齐方式 |
| sortable | String | - | 是否排序：custom/true/false |
| fixed | String/Boolean | - | 固定列：true/left/right |
| show | Array | ["detail","row","expand"] | 显示场景 |
| defaultValue | Any | - | 默认值 |
| formatter | Function | - | 自定义格式化函数 |
| buttons | Array | - | 扩展按钮列表 |
| filter | Object | - | 本地数据过滤器 |

## show字段显示规则

```javascript
// 只在详情弹窗显示
show: ["detail"]

// 只在表格行内显示
show: ["row"]

// 只在展开行显示
show: ["expand"]

// 多个场景显示
show: ["row", "detail"]

// 不显示
show: ["none"]
```

## buttons字段扩展按钮

```javascript
{
  key: "nickname",
  title: "昵称",
  type: "text",
  width: 200,
  buttonsPosition: "right",  // left/right/bottom/top
  buttons: [
    {
      title: "修改",
      type: "text",  // primary/success/warning/danger/info/text
      mode: "update",  // update/default
      show: ["row", "detail"],
      showRule: (formData) => {
        return formData.key2 !== 1;
      },
      click: (options) => {
        // options.value: 当前字段值
        // options.formData: 当前行数据
        // options.success: 成功回调
        vk.callFunction({
          url: 'template/test/pub/test',
          data: options.formData,
          success: (data) => {
            options.success({ msg: "修改成功" });
          }
        });
      }
    }
  ]
}
```

## filter本地数据过滤器

```javascript
{
  key: "remark",
  title: "备注",
  type: "text",
  width: 200,
  filter: {
    data: [
      { text: '备注1', value: '备注1' },
      { text: '备注2', value: '备注2' }
    ],
    multiple: true,
    method: (value, row, column) => {
      return value === row.remark;
    },
    defaultValue: []
  }
}
```
