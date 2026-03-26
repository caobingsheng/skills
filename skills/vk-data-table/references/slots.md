# 插槽使用指南

本文档详细说明vk-data-table组件的插槽使用方法。

## 插槽概述

vk-data-table组件支持多种插槽，可以实现高度自定义的渲染：

1. **字段插槽** - 自定义每个字段的渲染
2. **展开行插槽** - 自定义展开行内容
3. **表头插槽** - 自定义表头内容

## 字段插槽

### 基本语法

columns中的每个`key`对应一个插槽，插槽名为`v-slot:key`：

```vue
<vk-data-table :columns="table1.columns">
  <!-- 自定义gender字段 -->
  <template v-slot:gender="{ row, column, index }">
    <view>自定义内容：{{ row.gender }}</view>
  </template>
</vk-data-table>
```

**插槽参数：**
- `row` - 当前行数据
- `column` - 当前列配置
- `index` - 行索引

### 文本字段自定义

```vue
<template v-slot:username="{ row, column, index }">
  <el-tag type="primary">{{ row.username }}</el-tag>
</template>
```

### 图片字段自定义

```vue
<template v-slot:avatar="{ row, column, index }">
  <el-avatar :src="row.avatar" :size="50"></el-avatar>
</template>
```

### 标签字段自定义

```vue
<template v-slot:type="{ row, column, index }">
  <el-tag :type="row.type === 1 ? 'success' : 'danger'">
    {{ row.type === 1 ? '收入' : '支出' }}
  </el-tag>
</template>
```

### 开关字段自定义

```vue
<template v-slot:status="{ row, column, index }">
  <el-switch
    v-model="row.status"
    :active-value="true"
    :inactive-value="false"
    @change="handleStatusChange(row)"
  ></el-switch>
</template>
```

### 操作按钮自定义

```vue
<template v-slot:__operation="{ row, column, index }">
  <el-button type="text" @click="handleView(row)">查看</el-button>
  <el-button type="text" @click="handleEdit(row)">编辑</el-button>
  <el-button type="text" @click="handleDelete(row)">删除</el-button>
</template>
```

### 复杂自定义示例

```vue
<template v-slot:userInfo="{ row, column, index }">
  <div class="user-info">
    <el-avatar :src="row.userInfo.avatar" :size="40"></el-avatar>
    <div class="user-detail">
      <div class="username">{{ row.userInfo.username }}</div>
      <div class="nickname">{{ row.userInfo.nickname }}</div>
    </div>
  </div>
</template>

<style lang="scss" scoped>
.user-info {
  display: flex;
  align-items: center;
  gap: 10px;

  .user-detail {
    display: flex;
    flex-direction: column;

    .username {
      font-weight: bold;
    }

    .nickname {
      font-size: 12px;
      color: #999;
    }
  }
}
</style>
```

## 展开行插槽

### 基本语法

展开行插槽名为`v-slot:tableExpand`：

```vue
<vk-data-table :expand="true">
  <template v-slot:tableExpand="{ row }">
    <div>展开内容：{{ row._id }}</div>
  </template>
</vk-data-table>
```

**插槽参数：**
- `row` - 当前行数据

### 简单展开行

```vue
<template v-slot:tableExpand="{ row }">
  <div style="padding: 20px;">
    <p><strong>ID：</strong>{{ row._id }}</p>
    <p><strong>用户名：</strong>{{ row.username }}</p>
    <p><strong>昵称：</strong>{{ row.nickname }}</p>
    <p><strong>手机号：</strong>{{ row.mobile }}</p>
  </div>
</template>
```

### 复杂展开行（嵌套表格）

```vue
<template v-slot:tableExpand="{ row }">
  <div style="padding: 20px;">
    <h4>订单详情</h4>
    <vk-data-table
      :data="row.orderList"
      :columns="orderColumns"
      :pagination="false"
    ></vk-data-table>
  </div>
</template>

<script>
export default {
  data() {
    return {
      orderColumns: [
        { key: "orderNo", title: "订单号", type: "text", width: 200 },
        { key: "amount", title: "金额", type: "money", width: 120 },
        { key: "status", title: "状态", type: "text", width: 100 }
      ]
    };
  }
};
</script>
```

### 展开行配合show属性

```javascript
// columns配置
columns: [
  {
    key: "detail",
    title: "详情",
    type: "text",
    width: 100,
    show: ["expand"]  // 只在展开行显示
  }
]
```

## 表头插槽

### 基本语法

表头插槽名为`v-slot:header_字段名`：

```vue
<vk-data-table>
  <template v-slot:header_nickname="{ column, index }">
    <el-input
      v-model="queryForm1.formData.nickname"
      size="mini"
      placeholder="搜索昵称"
      @keyup.enter.native="search"
    ></el-input>
  </template>
</vk-data-table>
```

**插槽参数：**
- `column` - 当前列配置
- `index` - 列索引

### 表头搜索框

```vue
<template v-slot:header_nickname="{ column, index }">
  <el-input
    v-model="queryForm1.formData.nickname"
    size="mini"
    placeholder="输入关键字搜索"
    clearable
    @keyup.enter.native="search"
    @clear="search"
  >
    <el-button
      slot="append"
      icon="el-icon-search"
      @click="search"
    ></el-button>
  </el-input>
</template>
```

### 表头日期选择

```vue
<template v-slot:header_time="{ column, index }">
  <el-date-picker
    v-model="queryForm1.formData.time"
    type="daterange"
    size="mini"
    range-separator="至"
    start-placeholder="开始日期"
    end-placeholder="结束日期"
    @change="search"
  ></el-date-picker>
</template>
```

### 表头下拉筛选

```vue
<template v-slot:header_type="{ column, index }">
  <el-select
    v-model="queryForm1.formData.type"
    size="mini"
    placeholder="选择类型"
    clearable
    @change="search"
  >
    <el-option label="全部" value=""></el-option>
    <el-option label="收入" :value="1"></el-option>
    <el-option label="支出" :value="2"></el-option>
  </el-select>
</template>
```

### 操作列表头插槽

操作列的表头插槽名为`v-slot:header___operation`（三个下划线）：

```vue
<template v-slot:header___operation="{ column, index }">
  <el-button
    type="primary"
    size="mini"
    icon="el-icon-plus"
    @click="handleAdd"
  >
    新增
  </el-button>
</template>
```

## 完整示例

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
      :selection="true"
      :expand="true"
      @selection-change="onSelectionChange"
    >
      <!-- 自定义性别字段 -->
      <template v-slot:gender="{ row }">
        <el-tag :type="row.gender === 1 ? 'primary' : 'success'">
          {{ row.gender === 1 ? '男' : '女' }}
        </el-tag>
      </template>

      <!-- 自定义状态字段 -->
      <template v-slot:status="{ row }">
        <el-switch
          v-model="row.status"
          :active-value="1"
          :inactive-value="0"
          @change="handleStatusChange(row)"
        ></el-switch>
      </template>

      <!-- 自定义操作列 -->
      <template v-slot:__operation="{ row }">
        <el-button type="text" @click="handleView(row)">查看</el-button>
        <el-button type="text" @click="handleEdit(row)">编辑</el-button>
        <el-button type="text" @click="handleDelete(row)">删除</el-button>
      </template>

      <!-- 展开行 -->
      <template v-slot:tableExpand="{ row }">
        <div style="padding: 20px;">
          <el-descriptions title="用户详情" :column="2" border>
            <el-descriptions-item label="用户ID">{{ row._id }}</el-descriptions-item>
            <el-descriptions-item label="用户名">{{ row.username }}</el-descriptions-item>
            <el-descriptions-item label="昵称">{{ row.nickname }}</el-descriptions-item>
            <el-descriptions-item label="手机号">{{ row.mobile }}</el-descriptions-item>
            <el-descriptions-item label="邮箱">{{ row.email }}</el-descriptions-item>
            <el-descriptions-item label="注册时间">{{ row._add_time }}</el-descriptions-item>
          </el-descriptions>
        </div>
      </template>

      <!-- 表头插槽 -->
      <template v-slot:header_nickname="{ column }">
        <el-input
          v-model="queryForm1.formData.nickname"
          size="mini"
          placeholder="搜索昵称"
          clearable
          @keyup.enter.native="search"
        ></el-input>
      </template>

      <template v-slot:header___operation="{ column }">
        <el-button
          type="primary"
          size="mini"
          icon="el-icon-plus"
          @click="handleAdd"
        >
          新增
        </el-button>
      </template>
    </vk-data-table>
  </div>
</template>

<script>
export default {
  data() {
    return {
      queryForm1: {
        formData: {
          nickname: ""
        },
        columns: [
          { key: "nickname", title: "昵称", type: "text", mode: "%%" }
        ]
      },
      table1: {
        columns: [
          { key: "username", title: "用户名", type: "text", width: 150 },
          { key: "nickname", title: "昵称", type: "text", width: 150 },
          { key: "gender", title: "性别", type: "radio", width: 100 },
          { key: "status", title: "状态", type: "switch", width: 100 },
          { key: "_add_time", title: "注册时间", type: "time", width: 160 }
        ]
      }
    };
  },
  methods: {
    search() {
      this.$refs.table1.search();
    },
    onSelectionChange(rows) {
      console.log("选中：", rows);
    },
    handleStatusChange(row) {
      vk.callFunction({
        url: "admin/user/sys/update",
        data: {
          _id: row._id,
          status: row.status
        },
        success: () => {
          vk.toast("状态更新成功");
          this.$refs.table1.refresh();
        }
      });
    },
    handleView(row) {
      this.$refs.table1.showDetail(row);
    },
    handleEdit(row) {
      console.log("编辑：", row);
    },
    handleDelete(row) {
      vk.confirm("确认删除？", () => {
        console.log("删除：", row);
      });
    },
    handleAdd() {
      console.log("新增");
    }
  }
};
</script>
```

## 插槽最佳实践

### 1. 保持插槽简洁

```vue
<!-- ❌ 不好：过于复杂 -->
<template v-slot:userInfo="{ row }">
  <div>
    <div v-if="row.userInfo">
      <img :src="row.userInfo.avatar" />
      <span>{{ row.userInfo.username }}</span>
      <span>{{ row.userInfo.nickname }}</span>
      <span v-if="row.userInfo.mobile">{{ row.userInfo.mobile }}</span>
      <span v-if="row.userInfo.email">{{ row.userInfo.email }}</span>
    </div>
    <div v-else>
      暂无信息
    </div>
  </div>
</template>

<!-- ✅ 好：提取为组件 -->
<template v-slot:userInfo="{ row }">
  <user-info-display :info="row.userInfo"></user-info-display>
</template>
```

### 2. 使用formatter优先

```javascript
// ❌ 不好：使用插槽做简单格式化
<template v-slot:time="{ row }">
  {{ formatDate(row._add_time) }}
</template>

// ✅ 好：使用formatter
{
  key: "_add_time",
  title: "时间",
  type: "time",
  formatter: (val) => {
    return vk.pubfn.timeFormat(val, "yyyy-MM-dd hh:mm:ss");
  }
}
```

### 3. 合理使用插槽

```javascript
// ❌ 不好：能用配置实现的用插槽
<template v-slot:gender="{ row }">
  {{ row.gender === 1 ? '男' : '女' }}
</template>

// ✅ 好：使用type配置
{
  key: "gender",
  title: "性别",
  type: "radio",
  data: [
    { value: 1, label: "男" },
    { value: 2, label: "女" }
  ]
}
```

## 常见问题

### Q1: 插槽不生效？

**A:** 检查以下几点：
1. 插槽名是否正确（v-slot:key）
2. columns中是否有对应的key
3. 是否在正确的组件内使用

### Q2: 如何在插槽中调用方法？

**A:** 插槽可以访问组件的所有方法和数据：

```vue
<template v-slot:__operation="{ row }">
  <el-button @click="handleEdit(row)">编辑</el-button>
</template>

<script>
export default {
  methods: {
    handleEdit(row) {
      console.log("编辑：", row);
    }
  }
};
</script>
```

### Q3: 插槽性能问题？

**A:** 插槽会在每行渲染时执行，注意性能：
1. 避免在插槽中进行复杂计算
2. 使用v-once优化静态内容
3. 提取复杂逻辑为子组件
