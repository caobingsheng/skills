# 分页方案详解

本文档详细说明vk-data-table组件的四种分页方案及其使用场景。

## 分页方案对比

| 方案 | getCount值 | 显示总记录数 | 可跳转任意页 | 性能 | 适用场景 |
|------|-----------|-------------|-------------|------|---------|
| 传统分页 | true | ✅ | ✅ | ⭐⭐⭐ | 非大表 |
| 智能分页 | auto | ✅ | ✅ | ⭐⭐⭐⭐ | 非大表，推荐 |
| 滚动分页 | false | ❌ | ❌ | ⭐⭐⭐⭐⭐ | 大表 |
| 游标分页 | - | ❌ | ❌ | ⭐⭐⭐⭐⭐ | 超大表 |

## 方案一：传统分页

**特点：** 每次查询都执行count请求

**优势：**
- 能显示总记录条数
- 可以跳转到指定页码
- 实现简单

**劣势：**
- 每次都执行count，浪费性能
- 翻页性能有衰减（第10万页明显变慢）

**适用场景：** 非大表（数据量<10万）

**配置：**

```vue
<vk-data-table
  :get-count="true"
  :max-page-count="1000"
></vk-data-table>
```

## 方案二：智能分页（推荐）

**特点：** 首次查询执行count，翻页时缓存总记录数

**优势：**
- 能显示总记录条数
- 可以跳转到指定页码
- 翻页时节省count请求

**劣势：**
- 翻页性能有衰减

**适用场景：** 非大表，大部分场景的首选

**配置：**

```vue
<vk-data-table
  get-count="auto"
  :max-page-count="1000"
></vk-data-table>
```

**getCount处理逻辑：**

```javascript
// 前端getCount为auto时
- 第一页：getCount视为true
- 非第一页：getCount视为false

// 云端getTableData的getCount优先级
- 云端true && 前端true → true
- 云端true && 前端false → false
- 云端false && 前端任意 → false
```

## 方案三：滚动分页

**特点：** 从不执行count请求

**优势：**
- 高性能
- 适合大表

**劣势：**
- 不显示总记录条数
- 只能上一页/下一页
- 翻页性能有衰减

**适用场景：** 大表（数据量>10万）

**配置：**

```vue
<vk-data-table
  :get-count="false"
></vk-data-table>
```

## 方案四：游标分页

**特点：** 使用游标（如_id）代替skip实现分页

**优势：**
- 高性能
- 翻页性能无衰减
- 能完整遍历所有数据

**劣势：**
- 不显示总记录条数
- 只能上一页/下一页
- 必须依赖唯一索引排序
- 限制较多

**适用场景：** 超大表（百万级以上）

**实现原理：**

```javascript
// _id升序排序示例
// 下一页：where _id > 本页最后一条记录的_id
// 上一页：where _id < 本页第一条记录的_id

// _id降序排序示例
// 下一页：where _id < 本页最后一条记录的_id
// 上一页：where _id > 本页第一条记录的_id
```

**注意：** 此方案暂未封装到组件中，需要自行实现

## 分页相关属性

```vue
<vk-data-table
  :pagination="true"
  :page-size="20"
  :page-sizes="[10, 20, 50, 100, 1000]"
  :get-count="'auto'"
  :max-page-count="1000"
></vk-data-table>
```

| 属性 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| pagination | Boolean | false | 是否显示分页器 |
| page-size | Number | 10 | 每页显示数量 |
| page-sizes | Array | [1,5,10,20,50,100,1000] | 每页数量选择列表 |
| get-count | String/Boolean | auto | count执行模式 |
| max-page-count | Number | - | 最大可显示页数 |

## 性能优化建议

### 1. 选择合适的分页方案

```javascript
// 数据量<10万：使用智能分页
get-count="auto"

// 数据量>10万：使用滚动分页
:get-count="false"

// 数据量>100万：考虑游标分页
```

### 2. 限制最大页数

```vue
<vk-data-table
  :max-page-count="1000"
></vk-data-table>
```

### 3. 使用异常重试机制

```vue
<vk-data-table
  :retry-count="3"
  :retry-interval="1000"
></vk-data-table>
```

### 4. 云函数配合使用

```javascript
// 云函数中使用vk.baseDao.getTableData
let res = await vk.baseDao.getTableData({
  dbName: "uni-id-users",
  data: event.data,
  getCount: event.data.getCount  // 前端传递的getCount
});
```

## 分页事件监听

```vue
<vk-data-table
  @pagination-change="onPaginationChange"
></vk-data-table>
```

```javascript
methods: {
  onPaginationChange(paginationData) {
    console.log("当前页：", paginationData.pageIndex);
    console.log("每页条数：", paginationData.pageSize);
  }
}
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
      :pagination="true"
      :page-size="20"
      :page-sizes="[10, 20, 50, 100]"
      get-count="auto"
      :max-page-count="1000"
      :retry-count="3"
      @pagination-change="onPaginationChange"
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
          { key: "nickname", title: "昵称", type: "text", width: 150 },
          { key: "_add_time", title: "添加时间", type: "time", width: 160 }
        ]
      }
    };
  },
  methods: {
    search() {
      this.$refs.table1.search();
    },
    onPaginationChange(paginationData) {
      console.log("分页变化：", paginationData);
    }
  }
};
</script>
```

## 常见问题

### Q1: 为什么翻到后面页数变慢？

**A:** 使用skip+limit分页时，skip值越大性能越差。解决方法：
- 使用滚动分页（getCount="false"）
- 限制最大页数（max-page-count）
- 考虑使用游标分页

### Q2: 如何实现"加载更多"？

**A:** 使用滚动分页，配合虚拟滚动：

```vue
<vk-data-table
  :get-count="false"
  :pagination="false"
  :auto-load-more="true"
></vk-data-table>
```

### Q3: 如何导出所有数据？

**A:** 使用pageSize=-1：

```javascript
this.$refs.table1.exportExcel({
  fileName: "全部数据",
  pageIndex: 1,
  pageSize: -1  // -1表示导出所有
});
```
