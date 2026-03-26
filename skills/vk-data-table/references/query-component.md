# 查询组件完整指南

本文档详细说明vk-data-table-query查询组件的使用方法。

## 组件概述

vk-data-table-query是万能表格的配套查询组件，通过JSON配置实现复杂的查询功能。

## 基础用法

```vue
<template>
  <div>
    <!-- 查询组件 -->
    <vk-data-table-query
      v-model="queryForm1.formData"
      :columns="queryForm1.columns"
      @search="search"
    ></vk-data-table-query>

    <!-- 表格组件 -->
    <vk-data-table
      ref="table1"
      action="admin/user/sys/getList"
      :columns="table1.columns"
      :query-form-param="queryForm1"
    ></vk-data-table>
  </div>
</template>

<script>
export default {
  data() {
    return {
      queryForm1: {
        formData: {},
        columns: [
          { key: "nickname", title: "昵称", type: "text", mode: "%%" }
        ]
      },
      table1: {
        columns: [
          { key: "username", title: "用户名", type: "text", width: 150 },
          { key: "nickname", title: "昵称", type: "text", width: 150 }
        ]
      }
    };
  },
  methods: {
    search() {
      this.$refs.table1.search();
    }
  }
};
</script>
```

## 组件属性

| 属性 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| v-model | Object | - | 绑定查询表单数据源 |
| columns | Array | - | 字段渲染规则 |
| show-reset | Boolean | false | 是否显示重置按钮 |
| main-columns | Array | - | 在页面上直接显示的字段名数组 |
| drawer | Object | - | 高级搜索抽屉属性 |
| search-text | String | 搜索 | 搜索按钮文本 |
| senior-search-text | String | 高级搜索 | 高级搜索按钮文本 |
| auto-search | Boolean | true | 选择型组件触发change时是否自动搜索 |

## columns配置

### 基础属性

```javascript
{
  key: "nickname",        // 字段键名
  title: "昵称",          // 字段标题
  type: "text",           // 组件类型
  width: 160,             // 组件宽度
  placeholder: "请输入昵称", // 占位符
  mode: "%%",             // 查询模式
  fieldName: "nickname",  // 数据库字段名（默认=key）
  lastWhereJson: false,   // 是否是连表后的where条件
  hidden: false,          // 是否隐藏
  show: ["page"],         // 显示位置：page/drawer
  autoSearch: true        // 是否自动搜索
}
```

## 查询模式（mode）

### 精确匹配

```javascript
{
  key: "username",
  title: "用户名",
  type: "text",
  mode: "="  // 完全匹配
}
```

### 模糊匹配

```javascript
{
  key: "nickname",
  title: "昵称",
  type: "text",
  mode: "%%"  // 包含
}
```

### 前缀匹配

```javascript
{
  key: "username",
  title: "用户名",
  type: "text",
  mode: "%*"  // 以xxx开头
}
```

### 后缀匹配

```javascript
{
  key: "email",
  title: "邮箱",
  type: "text",
  mode: "*%"  // 以xxx结尾
}
```

### 数值比较

```javascript
{
  key: "age",
  title: "年龄",
  type: "number",
  mode: ">"  // 大于
}

// mode可选值：
// ">"  - 大于
// ">=" - 大于等于
// "<"  - 小于
// "<=" - 小于等于
```

### 范围查询

```javascript
{
  key: "balance",
  title: "余额",
  type: "money",
  mode: "[]"  // arr[0] <= x <= arr[1]
}

// mode可选值：
// "[]" - [a, b]  闭区间
// "[)" - [a, b)  左闭右开
// "(]" - (a, b]  左开右闭
// "()" - (a, b)  开区间
```

### 数组查询

```javascript
{
  key: "type",
  title: "类型",
  type: "select",
  mode: "in"  // 在数组里
}

// mode可选值：
// "in"  - 在数组里
// "nin" - 不在数组里
```

### 自定义模式

```javascript
{
  key: "custom",
  title: "自定义",
  type: "text",
  mode: "custom"  // 不自动参与where条件
}
```

## 特殊值

```javascript
// 匹配空数组
formData: {
  tags: "___empty-array___"
}

// 匹配空对象
formData: {
  metadata: "___empty-object___"
}

// 字段不存在
formData: {
  nickname: "___non-existent___"
}

// 字段存在
formData: {
  nickname: "___existent___"
}
```

**注意：** 左右各3个下划线

## fieldName参数

用于指定数据库字段名，默认等于key的值。

### 金额范围查询

```javascript
columns: [
  {
    key: "balance1",
    title: "最小金额",
    type: "money",
    width: 160,
    placeholder: "请输入最小金额",
    mode: ">=",
    fieldName: "balance"  // 指定数据库字段为balance
  },
  {
    key: "balance2",
    title: "最大金额",
    type: "money",
    width: 160,
    placeholder: "请输入最大金额",
    mode: "<=",
    fieldName: "balance"  // 指定数据库字段为balance
  }
]
```

### lastWhereJson参数

用于连表查询，指定连表后的字段。

```javascript
columns: [
  {
    key: "mobile",
    title: "手机号",
    type: "text",
    width: 160,
    mode: "=",
    fieldName: "userInfo.mobile",  // 连表字段
    lastWhereJson: true  // 标记为连表后的where条件
  }
]
```

## 常用查询类型

### 文本查询

```javascript
{
  key: "username",
  title: "用户名",
  type: "text",
  width: 160,
  mode: "="
}
```

### 日期范围查询

```javascript
{
  key: "_add_time",
  title: "添加时间",
  type: "datetimerange",
  width: 400,
  mode: "[]"
}
```

### 下拉选择查询

```javascript
{
  key: "gender",
  title: "性别",
  type: "radio",
  width: 160,
  mode: "=",
  data: [
    { value: 1, label: "男" },
    { value: 2, label: "女" },
    { value: 0, label: "保密" }
  ]
}
```

### 多选查询

```javascript
{
  key: "tags",
  title: "标签",
  type: "checkbox",
  width: 200,
  mode: "in",
  data: [
    { value: 1, label: "热门" },
    { value: 2, label: "推荐" }
  ]
}
```

### 级联选择查询

```javascript
{
  key: "region",
  title: "地区",
  type: "cascader",
  width: 200,
  mode: "=",
  data: [
    {
      value: "110000",
      label: "北京市",
      children: [
        { value: "110100", label: "北京市" }
      ]
    }
  ]
}
```

## 高级搜索抽屉

当查询字段较多时，可以使用抽屉模式：

```vue
<template>
  <vk-data-table-query
    ref="tableQuery1"
    v-model="queryForm1.formData"
    :columns="queryForm1.columns"
    :main-columns="['username', '_add_time']"
    :drawer="{
      title: '高级搜索',
      size: '30%'
    }"
    @search="search"
  ></vk-data-table-query>
</template>

<script>
export default {
  data() {
    return {
      queryForm1: {
        formData: {},
        columns: [
          // main-columns中的字段显示在页面上
          { key: "username", title: "用户名", type: "text", mode: "%%" },
          { key: "_add_time", title: "添加时间", type: "datetimerange", mode: "[]" },

          // 其他字段显示在抽屉中
          { key: "nickname", title: "昵称", type: "text", mode: "%%" },
          { key: "mobile", title: "手机号", type: "text", mode: "=" },
          { key: "gender", title: "性别", type: "radio", mode: "=" },
          { key: "type", title: "类型", type: "select", mode: "=" }
        ]
      }
    };
  },
  methods: {
    search() {
      this.$refs.table1.search();
    }
  }
};
</script>
```

## 事件

### search - 搜索事件

```vue
<vk-data-table-query
  @search="search"
></vk-data-table-query>
```

```javascript
methods: {
  search() {
    this.$refs.table1.search();
  }
}
```

### reset - 重置事件

```vue
<vk-data-table-query
  :show-reset="true"
  @reset="reset"
></vk-data-table-query>
```

```javascript
methods: {
  reset() {
    this.queryForm1.formData = {};
    this.$refs.table1.search();
  }
}
```

## 完整示例

```vue
<template>
  <div>
    <!-- 查询组件 -->
    <vk-data-table-query
      ref="tableQuery1"
      v-model="queryForm1.formData"
      :columns="queryForm1.columns"
      :main-columns="['username', '_add_time']"
      :show-reset="true"
      :drawer="{ title: '高级搜索', size: '30%' }"
      @search="search"
      @reset="reset"
    ></vk-data-table-query>

    <!-- 表格组件 -->
    <vk-data-table
      ref="table1"
      action="admin/user/sys/getList"
      :columns="table1.columns"
      :query-form-param="queryForm1"
      :pagination="true"
      :page-size="20"
    ></vk-data-table>
  </div>
</template>

<script>
export default {
  data() {
    return {
      queryForm1: {
        formData: {
          username: "",
          nickname: "",
          mobile: "",
          gender: "",
          type: "",
          _add_time: []
        },
        columns: [
          // 页面显示字段
          {
            key: "username",
            title: "用户名",
            type: "text",
            width: 160,
            mode: "%%",
            placeholder: "请输入用户名"
          },
          {
            key: "_add_time",
            title: "添加时间",
            type: "datetimerange",
            width: 400,
            mode: "[]",
            placeholder: "选择时间范围"
          },

          // 抽屉显示字段
          {
            key: "nickname",
            title: "昵称",
            type: "text",
            width: 160,
            mode: "%%",
            placeholder: "请输入昵称",
            show: ["drawer"]
          },
          {
            key: "mobile",
            title: "手机号",
            type: "text",
            width: 160,
            mode: "=",
            placeholder: "请输入手机号",
            show: ["drawer"]
          },
          {
            key: "gender",
            title: "性别",
            type: "radio",
            width: 160,
            mode: "=",
            defaultValue: "",
            data: [
              { value: "", label: "全部" },
              { value: 1, label: "男" },
              { value: 2, label: "女" },
              { value: 0, label: "保密" }
            ],
            show: ["drawer"]
          },
          {
            key: "type",
            title: "用户类型",
            type: "select",
            width: 160,
            mode: "=",
            defaultValue: "",
            data: [
              { value: "", label: "全部" },
              { value: 1, label: "普通用户" },
              { value: 2, label: "VIP用户" }
            ],
            show: ["drawer"]
          }
        ]
      },
      table1: {
        columns: [
          { key: "username", title: "用户名", type: "text", width: 150 },
          { key: "nickname", title: "昵称", type: "text", width: 150 },
          { key: "mobile", title: "手机号", type: "text", width: 150 },
          { key: "gender", title: "性别", type: "radio", width: 100 },
          { key: "type", title: "用户类型", type: "select", width: 120 },
          { key: "_add_time", title: "添加时间", type: "time", width: 160 }
        ]
      }
    };
  },
  methods: {
    search() {
      this.$refs.table1.search();
    },
    reset() {
      this.queryForm1.formData = {
        username: "",
        nickname: "",
        mobile: "",
        gender: "",
        type: "",
        _add_time: []
      };
      this.$refs.table1.search();
    }
  }
};
</script>
```

## 云函数配合

### 前端传递columns

```javascript
vk.callFunction({
  url: "admin/user/sys/getList",
  data: {
    columns: [{
      key: "nickname",
      type: "text",
      mode: "%%"
    }],
    formData: {
      nickname: "张"
    },
    pageIndex: 1,
    pageSize: 20
  }
});
```

### 云函数使用getTableData

```javascript
'use strict';
exports.main = async (event, context) => {
  let { data } = event;

  let res = await vk.baseDao.getTableData({
    dbName: "uni-id-users",
    data: data,  // 包含columns、formData等
    whereJson: {
      is_delete: false  // 强制条件
    }
  });

  return res;
};
```

## 最佳实践

### 1. 合理设置mode

```javascript
// ❌ 不好：所有字段都用模糊查询
{
  key: "mobile",
  title: "手机号",
  type: "text",
  mode: "%%"  // 手机号应该精确匹配
}

// ✅ 好：根据字段特点选择mode
{
  key: "mobile",
  title: "手机号",
  type: "text",
  mode: "="  // 精确匹配
}
```

### 2. 使用fieldName处理范围查询

```javascript
// ❌ 不好：使用两个不同的key
{
  key: "balance_min",
  title: "最小余额",
  mode: ">="
},
{
  key: "balance_max",
  title: "最大余额",
  mode: "<="
}

// ✅ 好：使用fieldName指定同一字段
{
  key: "balance1",
  title: "最小余额",
  mode: ">=",
  fieldName: "balance"
},
{
  key: "balance2",
  title: "最大余额",
  mode: "<=",
  fieldName: "balance"
}
```

### 3. 合理使用抽屉模式

```javascript
// ❌ 不好：所有字段都显示在页面上
columns: [
  // 20个字段...
]

// ✅ 好：常用字段在页面，其他在抽屉
:main-columns="['username', '_add_time']"
```

## 常见问题

### Q1: 查询条件不生效？

**A:** 检查以下几点：
1. columns中是否配置了mode
2. fieldName是否正确
3. 云函数是否正确处理columns参数

### Q2: 如何实现默认查询条件？

**A:** 在formData中设置默认值：

```javascript
queryForm1: {
  formData: {
    status: 1  // 默认查询状态为1的数据
  },
  columns: [
    { key: "status", title: "状态", type: "select", mode: "=" }
  ]
}
```

### Q3: 如何实现复杂查询？

**A:** 使用mode="custom"配合云函数自定义逻辑：

```javascript
// 前端
columns: [
  {
    key: "custom",
    title: "自定义",
    type: "text",
    mode: "custom"  // 不自动参与where
  }
]

// 云函数
let custom = event.data.formData.custom;
// 自定义查询逻辑
```
