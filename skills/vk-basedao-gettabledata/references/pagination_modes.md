# 分页方案详解

vk.baseDao.getTableData 支持4种分页方案,每种方案有不同的优缺点和适用场景。

## 方案对比

| 方案 | getCount | 显示总数 | 可跳页 | 性能 | 适用场景 |
|------|----------|----------|--------|------|----------|
| 传统分页 | true | ✓ | ✓ | 中等 | 非大表 |
| 智能分页 | auto | ✓ | ✓ | 较好 | 非大表,想节省count请求 |
| 滚动分页 | false | ✗ | ✗ | 好 | 大表 |
| 游标分页 | - | ✗ | ✗ | 最好 | 大表,需唯一索引排序 |

## 方案1: 传统分页

### 描述

每次请求同时查询 rows(当前页数据) 和 total(总记录条数),前端显示当前页数据以及分页器,分页器支持直接跳到任意页面。

### 优势

1. 能显示总记录条数
2. 可以跳转到指定的页码
3. 实现起来最简单方便

### 劣势

1. 每次查询都会进行count请求,有点浪费性能
2. 性能在翻页过程中有衰减,如翻到第10万页时性能明显降低

### 适用场景

非大表

### 使用方法

```javascript
// 前端
<vk-data-table :getCount="true"></vk-data-table>

// 云函数
let res = await vk.baseDao.getTableData({
  dbName: "表名",
  data: {
    pageIndex: 1,
    pageSize: 20
  },
  getCount: true
});
```

## 方案2: 智能分页 (推荐)

### 描述

在方案一的基础上进行了优化,在查询条件没变的情况下,翻页时不进行count请求(即缓存首次查询时的总记录条数)。

### 优势

1. 能显示总记录条数
2. 可以跳转到指定的页码
3. 翻页的时候可以节省一次count请求

### 劣势

1. 性能在翻页过程中有衰减
2. 首次查询仍需count请求

### 适用场景

1. 非大表
2. 想节省count请求

### 使用方法

```javascript
// 前端
<vk-data-table getCount="auto"></vk-data-table>

// 云函数
let res = await vk.baseDao.getTableData({
  dbName: "表名",
  data: {
    pageIndex: 1,
    pageSize: 20
  },
  getCount: "auto"  // 或不设置,默认也是auto
});
```

### getCount处理逻辑

1. 前端getCount为auto时:
   - 加载第一页时getCount视为true
   - 分页加载非第一页时getCount视为false

2. 前端getCount为true时:
   - 前端每次查询getCount均视为true

3. 前端getCount为false时:
   - 前端每次查询getCount均视为false

4. 云端vk.baseDao.getTableData不指定getCount时:
   - 若查询语句含有lastWhereJson或lastSortArr,则getCount视为false
   - 不含则视为true

5. 云端vk.baseDao.getTableData指定getCount时:
   - 按指定的值决定

### 云端和前端getCount不一致时的策略

1. 云端true + 前端true → 最终getCount视为true
2. 云端true + 前端false → 最终getCount视为false
3. 云端false + 前端不管true还是false → 最终getCount均视为false

## 方案3: 滚动分页

### 描述

从不执行count请求,但翻页只能下一页或上一页,且不显示总记录条数。

### 优势

1. 高性能

### 劣势

1. 不显示总记录条数
2. 翻页只能下一页或上一页,不能跳转到指定的页码
3. 性能在翻页过程中有衰减

### 适用场景

大表

### 使用方法

```javascript
// 前端
<vk-data-table :getCount="false"></vk-data-table>

// 云函数
let res = await vk.baseDao.getTableData({
  dbName: "表名",
  data: {
    pageIndex: 1,
    pageSize: 20
  },
  getCount: false
});
```

## 方案4: 游标分页

### 描述

不使用skip而是使用一个游标(通常是记录的唯一标识符,比如_id)来确定从哪里开始获取下一页的数据。

### 实现原理

以_id升序排序为例:

- **下一页**: where _id > 本页的最后一条记录,且_id升序排序
- **上一页**: where _id < 本页的第一条记录,且_id降序排序

以_id降序排序为例:

- **下一页**: where _id < 本页的最后一条记录,且_id降序排序
- **上一页**: where _id > 本页的第一条记录,且_id升序排序

### 优势

1. 高性能
2. 性能在翻页过程中无衰减,无论翻多少页基本都一样快
3. 能完整遍历完表内所有数据

### 劣势

1. 不显示总记录条数
2. 翻页只能下一页或上一页,不能跳转到指定的页码
3. 必须依赖唯一索引排序,不可按其他字段排序,限制较多

### 适用场景

大表

### 使用方法

此方案暂未封装到组件中,需要手动实现。

### 示例代码

```javascript
// 下一页
let lastId = "最后一条记录的_id";
let res = await vk.baseDao.getTableData({
  dbName: "表名",
  data: {
    pageSize: 20
  },
  whereJson: {
    _id: _.gt(lastId)  // 大于上一页最后一条记录的_id
  },
  sortArr: [
    { name: "_id", type: "asc" }
  ],
  getCount: false
});

// 上一页
let firstId = "第一条记录的_id";
let res = await vk.baseDao.getTableData({
  dbName: "表名",
  data: {
    pageSize: 20
  },
  whereJson: {
    _id: _.lt(firstId)  // 小于下一页第一条记录的_id
  },
  sortArr: [
    { name: "_id", type: "desc" }
  ],
  getCount: false
});
```

## 分页限制

### 最大页数限制

可以通过设置 `max-page-count` 来限制最大可显示的页数:

```javascript
// 前端
<vk-data-table :max-page-count="1000"></vk-data-table>
```

### 性能建议

- pageIndex * pageSize 的值最好不要超过300万
- 如每页显示10条,则建议最多让用户查看到第30万页
- 超过此限制应考虑使用游标分页或其他优化方案

## hasMore 参数

### 作用

返回精确的是否还有下一页的值。

### 默认行为

若请求参数hasMore不传,默认情况下:
```
hasMore = rows.length >= pageSize ? true : false
```

这种计算方式下,会出现返回值hasMore为true,但请求下一页其实已经没有数据的情况。

### 精确hasMore

设置 `hasMore: true` 时,框架会返回精确的hasMore,原理是通过多查一条数据实现的:

- 本次要查10条数据,框架实际查了11条
- 接口返回的rows还是10条
- 如果存在第11条数据,代表一定还有下一页
- 否则代表没有下一页了

### 与getCount的关系

若请求参数getCount已经设置为true时,会忽略参数hasMore,因为:
- 此时返回值total是满足查询条件的总数量
- 通过 `最大页数 = Math.ceil(total / pageSize)` 可以求出最大页数
- hasMore的计算方式: `hasMore = pageIndex < Math.ceil(total / pageSize) ? true : false`

## 选择建议

### 小表 (< 1万条)

使用 **方案2: 智能分页**

```javascript
getCount: "auto"
```

### 中表 (1万-100万条)

使用 **方案2: 智能分页** + **限制查询范围**

```javascript
getCount: "auto"
// 在whereJson中限制时间范围,如只查本月数据
whereJson: {
  _add_time: _.gte(monthStart).lte(monthEnd)
}
```

### 大表 (> 100万条)

使用 **方案3: 滚动分页** 或 **方案4: 游标分页**

```javascript
getCount: false
// 或使用游标分页
```
