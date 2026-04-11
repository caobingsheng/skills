---
name: vk-basedao-gettabledata
description: "vk-unicloud框架的vk.baseDao.getTableData方法完整使用指南。Use when working with vk-unicloud-admin framework database queries, especially when: (1) Implementing table data queries with pagination, filtering, and sorting, (2) Using vk-data-table component in admin pages, (3) Writing cloud functions with complex database operations including joins, grouping, and aggregation, (4) Need to understand query parameters, return value structure, and performance optimization."
---

# vk.baseDao.getTableData 使用指南

## Overview

vk.baseDao.getTableData 是 vk-unicloud 框架中用于数据库查询的核心方法,特别适用于万能表格(vk-data-table)组件。它提供了强大的分页、筛选、排序、连表、分组等功能。

## 快速开始

### 基础用法

```javascript
// 云函数中
let res = await vk.baseDao.getTableData({
  dbName: "表名",
  data: {
    pageIndex: 1,
    pageSize: 20,
    formData: {
      nickname: "张飞"
    },
    columns: [
      {
        key: "nickname",
        title: "昵称",
        type: "text",
        width: 160,
        mode: "%%"
      }
    ],
    sortRule: [
      { name: "_add_time", type: "desc" }
    ]
  },
  whereJson: {
    user_id: uid
  }
});
```

### 返回值结构

```javascript
{
  rows: [],      // 数据列表
  total: 0,      // 总记录数
  hasMore: false,// 是否还有下一页
  pagination: {  // 分页信息
    pageIndex: 1,
    pageSize: 20
  },
  getCount: true // 是否执行了count请求
}
```

## 核心功能

### 1. 分页查询

vk.baseDao.getTableData 支持多种分页方案,详见 [分页方案参考](references/pagination_modes.md)

### 2. 条件查询

通过 `data.formData` 和 `data.columns` 实现灵活的条件查询,详见 [条件查询参考](references/query_modes.md)

### 3. 连表查询

支持多表关联查询,详见 [连表查询参考](references/foreign_db.md)

### 4. 分组聚合

支持分组统计和聚合操作,详见 [分组查询参考](references/group_query.md)

## 参数说明

### 基础参数

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| dbName | String | 是 | 主表表名 |
| data | Object | 是 | 查询参数对象 |
| whereJson | Object | 否 | 主表强制where条件 |
| fieldJson | Object | 否 | 字段显示规则 |
| sortArr | Array | 否 | 主表排序规则 |
| foreignDB | Array | 否 | 连表规则 |
| lastWhereJson | Object | 否 | 连表后的where条件 |
| lastSortArr | Array | 否 | 连表后的排序规则 |
| addFields | Object | 否 | 添加自定义字段 |
| getCount | Boolean | 否 | 是否返回总记录数,默认true |
| hasMore | Boolean | 否 | 是否返回精确的hasMore,默认false |

### data参数详解

data参数包含前端传递的查询条件和排序规则:

```javascript
data: {
  pageIndex: 1,      // 第几页
  pageSize: 20,      // 每页数量
  formData: {},      // 查询条件数据源
  columns: [],       // 查询条件字段规则
  sortRule: []       // 排序规则
}
```

## 常见场景

### 场景1: 简单分页查询

```javascript
let res = await vk.baseDao.getTableData({
  dbName: "uni-id-users",
  data: {
    pageIndex: 1,
    pageSize: 20
  },
  whereJson: {
    status: 1
  }
});
```

### 场景2: 带筛选条件的查询

```javascript
let res = await vk.baseDao.getTableData({
  dbName: "订单表",
  data: {
    pageIndex: 1,
    pageSize: 20,
    formData: {
      status: 1,
      createTime: ["2024-01-01", "2024-12-31"]
    },
    columns: [
      { key: "status", title: "状态", type: "radio", mode: "=" },
      { key: "createTime", title: "创建时间", type: "datetimerange", mode: "[]" }
    ]
  }
});
```

### 场景3: 连表查询

```javascript
let res = await vk.baseDao.getTableData({
  dbName: "opendb-mall-comments",
  data: {
    pageIndex: 1,
    pageSize: 10
  },
  foreignDB: [{
    dbName: "uni-id-users",
    localKey: "user_id",
    foreignKey: "_id",
    as: "userInfo",
    limit: 1
  }]
});
```

## 性能优化建议

1. **getCount参数**: 大表查询时建议设置 `getCount: false` 避免count请求性能问题
2. **索引优化**: 为常用查询字段建立索引
3. **限制查询范围**: 使用whereJson先过滤数据,减少连表和分组的数据量
4. **避免lastWhereJson**: 数据量大时,lastWhereJson有严重性能问题
5. **分页限制**: pageIndex * pageSize 最好不要超过300万

## 参考文档

详细的使用说明和示例请查看references目录下的文档:

- [API完整参考](references/api_reference.md) - 所有参数和返回值的详细说明
- [分页方案](references/pagination_modes.md) - 4种分页方案详解
- [查询模式](references/query_modes.md) - 各种查询条件和模式
- [连表查询](references/foreign_db.md) - 多表关联查询完整指南
- [分组聚合](references/group_query.md) - 分组统计和聚合操作
- [性能优化](references/performance.md) - 性能优化最佳实践
