---
name: vk-data-table
description: "vk-unicloud-admin框架的万能表格组件完整使用指南。Use when working with vk-data-table component for: (1) Creating data tables with JSON configuration, (2) Implementing CRUD operations with table, (3) Using table with cloud functions (vk.baseDao.getTableData), (4) Configuring table columns, buttons, pagination, sorting, filtering, (5) Implementing table events, methods, and slots, (6) Using table query component (vk-data-table-query) for search functionality."
---

# vk-data-table 万能表格组件

## Overview

vk-data-table是vk-unicloud-admin框架的核心表格组件，通过JSON配置实现数据展示、查询、排序、分页、CRUD操作等功能。支持静态数据和动态数据（云函数/HTTP请求），配合vk.baseDao.getTableData可实现高性能的数据查询。

## Quick Start

### 基础用法（静态数据）

```vue
<template>
  <vk-data-table :data="table1.data" :columns="table1.columns"></vk-data-table>
</template>

<script>
export default {
  data() {
    return {
      table1: {
        data: [],
        columns: [
          { key: "_id", title: "ID", type: "text", width: 200 },
          { key: "username", title: "用户名", type: "text", width: 150 },
          { key: "nickname", title: "昵称", type: "text", width: 150 },
          { key: "mobile", title: "手机号", type: "text", width: 150 }
        ]
      }
    };
  }
};
</script>
```

### 动态数据（云函数）

```vue
<template>
  <vk-data-table
    ref="table1"
    action="admin/user/sys/getList"
    :columns="table1.columns"
    :query-form-param="queryForm1"
    :pagination="true"
    :page-size="20"
  ></vk-data-table>
</template>

<script>
export default {
  data() {
    return {
      table1: {
        columns: [
          { key: "username", title: "用户名", type: "text", width: 150 },
          { key: "nickname", title: "昵称", type: "text", width: 150 },
          { key: "_add_time", title: "添加时间", type: "time", width: 160 }
        ]
      },
      queryForm1: {
        formData: {},
        columns: []
      }
    };
  }
};
</script>
```

## Common Configurations

### 1. columns字段配置

columns是表格的核心配置，定义每个字段的显示规则：

```javascript
columns: [
  {
    key: "username",           // 字段键名
    title: "用户名",            // 列标题
    type: "text",              // 字段类型
    width: 150,                // 列宽度
    align: "center",           // 对齐方式：left/center/right
    sortable: "custom",        // 是否可排序
    show: ["row", "detail"],   // 显示场景：row/detail/expand/none
    formatter: (val, row) => { // 自定义格式化
      return val + "（已审核）";
    }
  }
]
```

**常用字段类型：**
- `text` - 文本
- `image` - 图片
- `tag` - 标签
- `switch` - 开关
- `time` - 时间
- `money` - 金额
- `radio/select/checkbox` - 选择类
- `html` - HTML渲染

详见：[字段类型完整列表](references/columns-types.md)

### 2. 右侧操作按钮

```javascript
table1: {
  rightBtns: [
    'detail_auto',  // 自动详情
    {
      mode: 'update',
      title: '编辑',
      type: 'primary',
      show: (item) => {
        // 根据条件显示按钮
        return item.status === 1;
      }
    },
    {
      mode: 'delete',
      title: '删除',
      type: 'danger',
      disabled: (item) => {
        // 根据条件禁用按钮
        return item._id === 'admin';
      }
    },
    'more'  // 更多按钮
  ],
  rightBtnsMore: [
    {
      title: '重置密码',
      onClick: (item) => {
        vk.toast(`重置${item.username}的密码`);
      }
    }
  ]
}
```

### 3. 分页配置

```vue
<vk-data-table
  :pagination="true"
  :page-size="20"
  :page-sizes="[10, 20, 50, 100]"
  :get-count="'auto'"
  :max-page-count="1000"
></vk-data-table>
```

**分页方案：**
- `getCount="true"` - 传统分页（每次都count）
- `getCount="auto"` - 智能分页（默认，首次count）
- `getCount="false"` - 滚动分页（从不count）

详见：[分页方案详解](references/pagination.md)

### 4. 表格查询组件

```vue
<template>
  <!-- 查询组件 -->
  <vk-data-table-query
    v-model="queryForm1.formData"
    :columns="queryForm1.columns"
    @search="search"
  ></vk-data-table-query>

  <!-- 表格组件 -->
  <vk-data-table
    :query-form-param="queryForm1"
  ></vk-data-table>
</template>

<script>
export default {
  data() {
    return {
      queryForm1: {
        formData: {
          nickname: "",
          _add_time: []
        },
        columns: [
          { key: "nickname", title: "昵称", type: "text", mode: "%%" },
          { key: "_add_time", title: "添加时间", type: "datetimerange", mode: "[]" }
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

**查询模式（mode）：**
- `=` - 精确匹配
- `%%` - 模糊匹配
- `>` / `>=` / `<` / `<=` - 数值比较
- `[]` - 范围查询
- `in` / `nin` - 在/不在数组中

详见：[查询组件完整指南](references/query-component.md)

## Events & Methods

### 常用事件

```vue
<vk-data-table
  @success="onSuccess"
  @detail="onDetail"
  @update="onUpdate"
  @delete="onDelete"
  @row-click="onRowClick"
></vk-data-table>
```

```javascript
methods: {
  onSuccess({ data, list, total }) {
    console.log("查询成功", list);
  },
  onDetail({ item, row }) {
    console.log("查看详情", item);
  },
  onUpdate({ item, row }) {
    console.log("编辑", item);
  },
  onDelete({ item, deleteFn }) {
    vk.confirm("确认删除？", () => {
      deleteFn(); // 调用删除函数
    });
  }
}
```

### 常用方法

```javascript
// 刷新表格
this.$refs.table1.refresh();

// 查询
this.$refs.table1.search();

// 显示详情
this.$refs.table1.showDetail(item);

// 获取选中行
let row = this.$refs.table1.getCurrentRow();

// 获取多选数据
let rows = this.$refs.table1.getMultipleSelection();

// 导出Excel
this.$refs.table1.exportExcel({
  fileName: "用户列表",
  pageIndex: 1,
  pageSize: -1  // -1表示导出所有数据
});
```

详见：[事件和方法完整列表](references/events-methods.md)

## Slots

### 自定义字段渲染

```vue
<vk-data-table>
  <!-- 自定义gender字段 -->
  <template v-slot:gender="{ row, column, index }">
    <el-tag :type="row.gender === 1 ? 'primary' : 'success'">
      {{ row.gender === 1 ? '男' : '女' }}
    </el-tag>
  </template>

  <!-- 展开行 -->
  <template v-slot:tableExpand="{ row }">
    <div>展开内容：{{ row._id }}</div>
  </template>

  <!-- 表头插槽 -->
  <template v-slot:header_nickname="{ column }">
    <el-input v-model="queryForm1.formData.nickname" placeholder="搜索昵称"></el-input>
  </template>
</vk-data-table>
```

详见：[插槽使用指南](references/slots.md)

## Best Practices

### 1. 与vk.baseDao.getTableData配合

**前端传递columns参数：**

```javascript
vk.callFunction({
  url: "admin/user/sys/getList",
  data: {
    columns: [{
      key: "nickname",
      type: "text",
      mode: "%%"  // 必须指定mode
    }],
    formData: { nickname: "张" },
    pageIndex: 1,
    pageSize: 20
  }
});
```

**云函数使用getTableData：**

```javascript
let res = await vk.baseDao.getTableData({
  dbName: "uni-id-users",
  data: event.data,  // 前端传来的data
  whereJson: {
    is_delete: false  // 强制条件
  }
});
```

### 2. 性能优化

- **大表使用滚动分页**：`getCount="false"`
- **限制最大页数**：`max-page-count="1000"`
- **使用异常重试**：`retry-count="3"`
- **避免复杂计算**：使用formatter而非computed

### 3. 权限控制

```javascript
rightBtns: [
  {
    mode: 'delete',
    title: '删除',
    show: (item) => {
      return this.$hasRole("admin") || this.$hasPermission("user-delete");
    }
  }
]
```

### 4. 数据预处理

```javascript
table1: {
  dataPreprocess: (list) => {
    return list.map(item => {
      item.fullname = item.firstname + " " + item.lastname;
      return item;
    });
  }
}
```

## When to Consult References

查看详细参考文档的场景：

- **[columns-types.md](references/columns-types.md)** - 需要了解所有字段类型（30+种）的详细配置
- **[pagination.md](references/pagination.md)** - 需要深入理解分页方案选择和性能优化
- **[events-methods.md](references/events-methods.md)** - 需要完整的事件列表和方法API
- **[slots.md](references/slots.md)** - 需要使用复杂的插槽自定义
- **[query-component.md](references/query-component.md)** - 需要实现复杂的查询功能（连表、范围查询等）
