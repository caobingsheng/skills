---
name: vk-basedao
description: "vk-unicloud框架的vk.baseDao数据库操作完整使用指南。Use when working with vk-unicloud-admin framework database operations, especially when: (1) Implementing CRUD operations (add, delete, update, query), (2) Performing complex queries with pagination, filtering, and sorting, (3) Implementing table joins and aggregations, (4) Using database transactions, (5) Understanding database command operators (_.command, _.aggregate)."
---

# vk.baseDao 数据库操作完整指南

## Overview

`vk.baseDao` 是 vk-unicloud 框架提供的数据库操作核心API，封装了 MongoDB 的常用操作，提供了简洁的接口进行增删改查、连表查询、分组聚合、事务处理等操作。

## 快速开始

### 变量声明

```javascript
// 云函数中
const vk = uni.vk; // 获取vk实例
const db = uniCloud.database(); // 数据库实例
const _ = db.command; // 数据库操作符
const $ = _.aggregate; // 聚合查询操作符
```

### 基础调用模式

```javascript
// 查询单条记录
let info = await vk.baseDao.findById({
  dbName: "表名",
  id: "记录ID"
});

// 查询多条记录
let res = await vk.baseDao.select({
  dbName: "表名",
  pageIndex: 1,
  pageSize: 20,
  whereJson: {
    status: 1
  }
});

// 新增记录
let id = await vk.baseDao.add({
  dbName: "表名",
  dataJson: {
    name: "测试",
    value: 100
  }
});

// 修改记录
let num = await vk.baseDao.updateById({
  dbName: "表名",
  id: "记录ID",
  dataJson: {
    name: "修改后的名称"
  }
});

// 删除记录
let delNum = await vk.baseDao.deleteById({
  dbName: "表名",
  id: "记录ID"
});
```

## 目录

- [增删改查 (CRUD)](#增删改查)
- [连表查询 (selects)](#连表查询)
- [查询单条记录](#查询单条记录)
- [树状结构查询](#树状结构查询)
- [常见查询场景](#常见查询场景)
- [数据库操作符](#数据库操作符)
- [事务操作](#事务操作)
- [DAO层封装](#dao层封装)
- [扩展数据库](#扩展数据库)

---

# 增删改查

## 新增

### vk.baseDao.add（单条记录增加）

```javascript
let id = await vk.baseDao.add({
  dbName: "vk-test", // 表名
  dataJson: { // 需要新增的数据
    money: Math.floor(Math.random() * 9 + 1)
  },
  cancelAddTime: false, // 取消自动生成 _add_time 字段，默认false
  cancelAddTimeStr: false // 取消自动生成 _add_time_str 字段，默认false
});
```

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| dbName | String | 是 | 表名 |
| dataJson | Object | 是 | 需要添加的数据 |
| cancelAddTime | Boolean | 否 | 取消自动生成 `_add_time` 和 `_add_time_str` 字段 |
| cancelAddTimeStr | Boolean | 否 | 取消自动生成 `_add_time_str` 字段 |
| db | DB | 否 | 指定数据库实例 |

**返回值**：返回值为添加数据的`_id`，添加失败则返回null

### vk.baseDao.adds（批量增加）

```javascript
let ids = await vk.baseDao.adds({
  dbName: "vk-test", // 表名
  dataJson: [
    { money: 10 },
    { money: 20 }
  ],
  needReturnIds: true, // 是否需要返回ids数组，默认dataJson.length ≤10万则true
  cancelAddTime: false
});
```

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| dbName | String | 是 | 表名 |
| dataJson | Array | 是 | 需要批量添加的数据 |
| needReturnIds | Boolean | 否 | 是否需要返回ids数组 |
| cancelAddTime | Boolean | 否 | 取消自动生成时间字段 |

**返回值**：返回值为添加数据的`_id`数组，添加失败则返回null

> **注意**：`add` 和 `adds` 默认会自动加上 `_add_time` 字段，记录添加时间。

---

## 删除

### vk.baseDao.del（批量删除）

```javascript
// 返回被删除的记录条数
let num = await vk.baseDao.del({
  dbName: "vk-test",
  whereJson: {
    money: 1
  }
});
```

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| dbName | String | 是 | 表名 |
| whereJson | Object | 是 | where 条件 |
| db | DB | 否 | 指定数据库实例 |

**返回值**：返回值是删除的记录数量

**删除全部数据**

```javascript
await vk.baseDao.del({
  dbName: "vk-test",
  whereJson: {
    _id: _.exists(true),
  }
});
```

### vk.baseDao.deleteById（根据ID删除）

```javascript
let num = await vk.baseDao.deleteById({
  dbName: "vk-test",
  id: "记录ID"
});
```

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| dbName | String | 是 | 表名 |
| id | String | 是 | 记录的`_id` |
| db | DB | 否 | 指定数据库实例 |

**返回值**：返回值是删除的记录数量

---

## 修改

### vk.baseDao.update（批量修改）

```javascript
let num = await vk.baseDao.update({
  dbName: "vk-test", // 表名
  whereJson: { // 条件
    _id: "5f3a14823d11c6000106ff5c",
    money: _.gte(100)
  },
  dataJson: { // 需要修改的数据
    money: _.inc(-100) // 自减100
  }
});
```

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| dbName | String | 是 | 表名 |
| whereJson | Object | 是 | where 条件 |
| dataJson | Object | 是 | 需要修改的数据 |
| db | DB | 否 | 指定数据库实例 |

**返回值**：返回值是受影响的行数

**修改全部数据**

```javascript
let num = await vk.baseDao.update({
  dbName: "vk-test",
  whereJson: {
    _id: _.exists(true),
  },
  dataJson: {
    money: _.inc(-1)
  }
});
```

### vk.baseDao.updateById（根据ID修改）

```javascript
let newInfo = await vk.baseDao.updateById({
  dbName: "vk-test",
  id: _id,
  dataJson: {
    money: 1
  },
  getUpdateData: true // 是否返回修改后的数据，默认false
});
```

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| dbName | String | 是 | 表名 |
| id | String | 是 | 记录的`_id` |
| dataJson | Object | 是 | 需要修改的数据 |
| getUpdateData | Boolean | 否 | 是否返回修改后的数据 |
| db | DB | 否 | 指定数据库实例 |

**返回值**：默认返回值是受影响的行数，`getUpdateData:true`时返回修改后的数据对象

### vk.baseDao.updateAndReturn（更新并返回，原子操作）

```javascript
let newInfo = await vk.baseDao.updateAndReturn({
  dbName: "vk-test",
  whereJson: {
    _id: _id
  },
  dataJson: {
    money: _.inc(1) // 自增1
  }
});
console.log("自增后的值：", newInfo.money);
```

**特性**：
- 原子操作，只计一次写操作
- 支持事务
- 可实现id自增、阅读数自增等功能

### vk.baseDao.setById（根据ID判断存在则替换，不存在则添加）

```javascript
let setRes = await vk.baseDao.setById({
  dbName: "vk-test",
  dataJson: {
    _id: "666",
    money: 1
  },
  id: "666" // 可选，与dataJson中的_id判断是否一致
});
```

**返回值**

| 参数名 | 类型 | 说明 |
|--------|------|------|
| type | String | add添加 / update修改 |
| id | String | 若type=add，则返回新增的id |

---

## 查询

### vk.baseDao.findById（根据id获取单条记录）

```javascript
let info = await vk.baseDao.findById({
  dbName: "vk-test",
  id: "5f3a125b3d11c6000106d338",
  fieldJson: { // 字段显示规则
    _id: true,
    money: true
  }
});
```

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| dbName | String | 是 | 表名 |
| id | String | 是 | 记录的`_id` |
| fieldJson | Object | 否 | 字段显示规则 |
| db | DB | 否 | 指定数据库实例 |

**返回值**：返回值是该条记录数据

### vk.baseDao.findByWhereJson（根据条件获取单条记录）

```javascript
let info = await vk.baseDao.findByWhereJson({
  dbName: "vk-test",
  whereJson: {
    _id: "5f3a125b3d11c6000106d338",
  },
  fieldJson: {},
  sortArr: [{ name: "_id", type: "desc" }]
});
```

**返回值**：返回值是该条记录数据（只返回第一条）

### vk.baseDao.select（查多条记录，分页功能）

```javascript
let res = await vk.baseDao.select({
  dbName: "vk-test",
  getCount: false, // 是否返回总数，默认false
  getMain: false, // 是否只返回rows，默认false
  getOne: false, // 是否只返回第一条，默认false
  pageIndex: 1,
  pageSize: 20,
  whereJson: {
    money: _.gte(0)
  },
  fieldJson: { // 字段显示规则
    _id: true,
    money: true
  },
  sortArr: [{ name: "_id", type: "desc" }],
  debug: false // 是否返回调试参数
});
```

**pageSize说明**

- 默认最大查询1000条，可设置`pageSize: 10000`突破限制
- `pageSize:-1`查询全部数据（谨慎使用）
- `pageSize > 1000`时使用游标查询，性能更佳

**返回值**

| 参数名 | 类型 | 说明 |
|--------|------|------|
| rows | Array | 数据列表 |
| total | Number | 满足条件的记录总数 |
| hasMore | Boolean | 是否还有下一页 |
| pagination | Object | 分页参数 |
| getCount | Boolean | 是否执行过getCount |

### vk.baseDao.count（获取记录总条数）

```javascript
// 不带条件
let num = await vk.baseDao.count({
  dbName: "vk-test"
});

// 带条件
let num = await vk.baseDao.count({
  dbName: "vk-test",
  whereJson: {
    status: 1
  }
});

// 判断用户名是否存在
let num = await vk.baseDao.count({
  dbName: "uni-id-users",
  whereJson: {
    username: "admin"
  }
});
if (num > 0) {
  // 用户名存在
}
```

**返回值**：返回值是满足条件的记录总数

### vk.baseDao.sum（求和）

```javascript
let sum = await vk.baseDao.sum({
  dbName: "vk-test",
  fieldName: "money",
  whereJson: {}
});
```

### vk.baseDao.max（取最大值）

```javascript
let max = await vk.baseDao.max({
  dbName: "vk-test",
  fieldName: "money",
  whereJson: {}
});
```

### vk.baseDao.min（取最小值）

```javascript
let min = await vk.baseDao.min({
  dbName: "vk-test",
  fieldName: "money",
  whereJson: {}
});
```

### vk.baseDao.avg（取平均值）

```javascript
let avg = await vk.baseDao.avg({
  dbName: "vk-test",
  fieldName: "money",
  whereJson: {}
});
```

### vk.baseDao.sample（随机取N条数据）

```javascript
let list = await vk.baseDao.sample({
  dbName: "vk-test",
  size: 1,
  whereJson: {},
  fieldJson: {}
});
```

---

# 连表查询

## vk.baseDao.selects（万能连表查询）

```javascript
let res = await vk.baseDao.selects({
  dbName: "主表表名",
  getCount: false,
  pageIndex: 1,
  pageSize: 20,
  whereJson: {},
  fieldJson: {},
  sortArr: [{ name: "_id", type: "desc" }],
  foreignDB: [
    {
      dbName: "副表表名",
      localKey: "主表外键名",
      foreignKey: "副表外键名",
      as: "副表as字段",
      limit: 1 // limit=1以对象形式返回，否则以数组形式返回
    }
  ]
});
```

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| dbName | String | 是 | 主表表名 |
| whereJson | Object | 否 | 主表where条件 |
| pageIndex | Number | 否 | 第几页，默认1 |
| pageSize | Number | 否 | 每页数量，默认10 |
| getCount | Boolean | 否 | 是否返回总数，默认false |
| hasMore | Boolean | 否 | 是否返回精确hasMore |
| getOne | Boolean | 否 | 是否只返回第一条，默认false |
| getMain | Boolean | 否 | 是否只返回rows数组，默认false |
| groupJson | Object | 否 | 主表分组规则 |
| sortArr | Array | 否 | 主表排序规则 |
| foreignDB | Array | 否 | 连表规则 |
| lastWhereJson | Object | 否 | 连表后的where条件 |
| lastSortArr | Array | 否 | 连表后的排序条件 |
| addFields | Object | 否 | 添加自定义字段 |
| fieldJson | Object | 否 | 字段显示规则 |
| db | DB | 否 | 指定数据库实例 |
| debug | Boolean | 否 | 是否返回调试参数 |

## foreignDB 连表规则

```javascript
foreignDB: [
  {
    dbName: "副表表名",
    localKey: "主表外键名",
    foreignKey: "副表外键名",
    as: "副表as字段",
    limit: 1, // limit=1以对象形式返回
    localKeyType: "array", // 主表外键类型，array代表数组
    foreignKeyType: "array", // 副表外键类型
    localKeyIndex: "index", // 当localKeyType为array时有效
    whereJson: {}, // 副表where条件
    sortArr: [], // 副表排序规则
    foreignDB: [], // 副表的副表（最多15层）
    addFields: {}, // 副表添加自定义字段
    fieldJson: {} // 副表字段显示规则
  }
]
```

## 场景示例

### 场景1：1张主表多张副表

```javascript
res = await vk.baseDao.selects({
  dbName: "uni-id-users",
  pageIndex: 1,
  pageSize: 10,
  fieldJson: {
    token: false,
    password: false
  },
  sortArr: [{ name: "_id", type: "desc" }],
  foreignDB: [
    {
      dbName: "order",
      localKey: "_id",
      foreignKey: "user_id",
      as: "orderList",
      limit: 10,
      sortArr: [{ name: "time", type: "desc" }]
    },
    {
      dbName: "vip",
      localKey: "_id",
      foreignKey: "user_id",
      as: "vipInfo",
      limit: 1
    }
  ]
});
```

### 场景3：副表不满足条件则主表记录不获取

```javascript
res = await vk.baseDao.selects({
  dbName: "opendb-mall-comments",
  pageIndex: 1,
  pageSize: 10,
  foreignDB: [
    {
      dbName: "uni-id-users",
      localKey: "user_id",
      foreignKey: "_id",
      as: "userInfo",
      limit: 1
    }
  ],
  lastWhereJson: {
    "userInfo.gender": 2 // 只查询女性用户的评论
  }
});
```

### 场景5：主表外键是数组，查询数组内的每个记录详情

```javascript
res = await vk.baseDao.selects({
  dbName: "uni-id-users",
  pageIndex: 1,
  pageSize: 10,
  foreignDB: [{
    dbName: "uni-id-roles",
    localKey: "role",
    localKeyType: "array",
    foreignKey: "role_id",
    as: "roleList",
    limit: 1000
  }]
});
```

### 场景7：分组查询

```javascript
res = await vk.baseDao.selects({
  dbName: "订单表",
  pageIndex: 1,
  pageSize: 10,
  whereJson: {},
  groupJson: {
    _id: "$user_id", // 按user_id分组
    user_id: $.first("$user_id"),
    payment_amount: $.sum("$payment_amount"), // 支付金额求和
    count: $.sum(1) // 记录条数
  },
  sortArr: [{ name: "payment_amount", type: "desc" }],
  foreignDB: [{
    dbName: "uni-id-users",
    localKey: "user_id",
    foreignKey: "_id",
    as: "userInfo",
    limit: 1
  }],
  lastWhereJson: {
    payment_amount: _.gt(1000) // 分组后筛选
  }
});
```

### 场景13：按日期分组统计

```javascript
let { yearStart, yearEnd } = vk.pubfn.getCommonTime();
res = await vk.baseDao.selects({
  dbName: "uni-id-users",
  pageIndex: 1,
  pageSize: 1000,
  whereJson: {
    register_date: _.gte(yearStart).lte(yearEnd)
  },
  groupJson: {
    _id: $.dateToString({
      date: $.add([new Date(0), "$register_date"]),
      format: "%Y-%m", // 按年月分组
      timezone: "+08:00"
    }),
    count: $.sum(1)
  },
  sortArr: [{ name: "_id", type: "desc" }]
});
```

---

# 查询单条记录

## 连表返回单条记录

```javascript
let info = await vk.baseDao.selects({
  dbName: "uni-id-users",
  getOne: true, // 只返回第一条数据
  getMain: true, // 直接返回数据，不带code等参数
  whereJson: {
    _id: "001"
  },
  fieldJson: {
    token: false,
    password: false
  },
  foreignDB: [
    {
      dbName: "order",
      localKey: "_id",
      foreignKey: "user_id",
      as: "orderList",
      limit: 10
    },
    {
      dbName: "vip",
      localKey: "_id",
      foreignKey: "user_id",
      as: "vipInfo",
      limit: 1
    }
  ]
});
// 返回格式：{"_id":"001","name":"xxx","orderList":[...],"vipInfo":{...}}
```

---

# 树状结构查询

## treeProps 参数说明

| 参数名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | String | 否 | `_id` | 唯一标识字段 |
| parent_id | String | 否 | `parent_id` | 父级标识字段 |
| children | String | 否 | `children` | 子节点字段名 |
| level | Number | 否 | 10 | 最大层级，最大15 |
| limit | Number | 否 | - | 每一级最大返回数量 |
| sortArr | Array | 否 | - | 子节点排序规则 |
| whereJson | Object | 否 | - | 子节点查询条件 |

## 树状结构查询

```javascript
res = await vk.baseDao.selects({
  dbName: "opendb-admin-menus",
  pageIndex: 1,
  pageSize: 500,
  whereJson: {
    enable: true,
    parent_id: _.in([null, ""]),
    menu_id: _.exists(true)
  },
  sortArr: [{ name: "sort", type: "asc" }],
  treeProps: {
    id: "menu_id",
    parent_id: "parent_id",
    children: "children",
    level: 3,
    limit: 500,
    sortArr: [{ name: "sort", type: "asc" }],
    whereJson: {
      enable: true
    }
  }
});
```

## 树状结构 + 连表

```javascript
res = await vk.baseDao.selects({
  dbName: "opendb-admin-menus",
  pageIndex: 1,
  pageSize: 500,
  whereJson: {
    enable: true,
    parent_id: _.in([null, ""])
  },
  sortArr: [{ name: "sort", type: "asc" }],
  treeProps: {
    id: "menu_id",
    parent_id: "parent_id",
    children: "children",
    level: 3
  },
  foreignDB: [
    {
      dbName: "opendb-admin-roles",
      localKey: "role_id",
      foreignKey: "role_id",
      as: "role_info",
      limit: 1
    }
  ]
});
```

---

# 常见查询场景

## and / or 条件

```javascript
// num >=0 and num <= 10
whereJson: {
  num: _.gte(0).lte(10)
}

// num <=0 or num >= 10
whereJson: {
  num: _.or(_.lte(0), _.gte(10))
}

// num >50 and name = 'test'
whereJson: _.and([
  { num: _.gt(50) },
  { name: 'test' }
])

// num >50 and (name = 'test' or sex = 1)
whereJson: _.and([
  { num: _.gt(50) },
  _.or([
    { name: 'test' },
    { sex: 1 }
  ])
])
```

## in / nin / neq

```javascript
// _id = "1" or "2" or "3"
whereJson: {
  _id: _.in(["1", "2", "3"])
}

// _id != "1" and "2" and "3"
whereJson: {
  _id: _.nin(["1", "2", "3"])
}

// num != 1
whereJson: {
  num: _.neq(1)
}
```

## 大于小于

```javascript
whereJson: {
  num: _.gt(0),    // 大于
  num: _.gte(0),   // 大于等于
  num: _.lt(0),    // 小于
  num: _.lte(0)    // 小于等于
}
```

## 模糊查询

```javascript
// 包含xxx
whereJson: {
  nickname: new RegExp(searchvalue)
}

// 以xxx开头
whereJson: {
  nickname: new RegExp('^' + searchvalue)
}

// 以xxx结尾
whereJson: {
  nickname: new RegExp(searchvalue + '$')
}

// 包含 xxx 或 yyy
whereJson: {
  nickname: new RegExp(`xxx|yyy`)
}
```

## 多字段模糊搜索or

```javascript
let whereJson = {};
let andArr = [];
if (searchvalue) {
  try {
    let regExp = new RegExp(searchvalue);
    let orObj = _.or([
      { "username": regExp },
      { "nickname": regExp },
      { "mobile": regExp }
    ]);
    andArr.push(orObj);
  } catch (err) {
    return { code: -1, msg: '请输入合法的查询内容' };
  }
}
if (andArr.length > 0) {
  whereJson = _.and(andArr);
}
```

## 字段是否存在

```javascript
whereJson: {
  nickname: _.exists(true) // true：存在，false：不存在
}
```

## 数组字段包含某个值

```javascript
whereJson: {
  role: roleId // 查询数组内包含roleId的数据
}
```

## 字段比较

```javascript
// 字段a等于字段b
whereJson: _.expr($.and([
  $.eq(['$a', '$b'])
]))
```

## 字段自增

```javascript
let newInfo = await vk.baseDao.updateAndReturn({
  dbName: "vk-test",
  whereJson: {
    _id: _id
  },
  dataJson: {
    money: _.inc(1)
  }
});
```

## 删除字段

```javascript
await vk.baseDao.update({
  dbName: "vk-test",
  whereJson: {
    _id: "5f3a14823d11c6000106ff5c"
  },
  dataJson: {
    money: _.remove() // 删除money字段
  }
});
```

## 字段重命名

```javascript
await vk.baseDao.update({
  dbName: "vk-test",
  dataJson: {
    money: _.rename('money2') // 将money字段重命名为money2
  }
});
```

## 排序

```javascript
sortArr: [
  { name: "register_date", type: "desc" }, // 按注册时间降序
  { name: "_id", type: "desc" } // _id降序
]
```

## 字段显示规则

```javascript
// 只取指定字段
fieldJson: {
  username: true,
  nickname: true
}

// 排除指定字段
fieldJson: {
  token: false,
  password: false
}
```

## 获取今日注册用户

```javascript
let { todayStart, todayEnd } = vk.pubfn.getCommonTime();
let selectRes = await vk.baseDao.select({
  dbName: "uni-id-users",
  pageIndex: 1,
  pageSize: 20,
  whereJson: {
    register_date: _.gte(todayStart).lte(todayEnd)
  }
});
```

---

# 数据库操作符

## 变量说明

```javascript
const db = uniCloud.database();     // 数据库实例
const _ = db.command;               // 数据库操作符
const $ = _.aggregate;              // 聚合查询操作符
```

> **注意**：文档中出现的 `$` 在云函数若不可用，则可写成 `_.$`

## 常用操作符

| 操作符 | 说明 |
|--------|------|
| `_.gt(x)` | 大于 x |
| `_.gte(x)` | 大于等于 x |
| `_.lt(x)` | 小于 x |
| `_.lte(x)` | 小于等于 x |
| `_.eq(x)` | 等于 x |
| `_.neq(x)` | 不等于 x |
| `_.in(arr)` | 在数组中 |
| `_.nin(arr)` | 不在数组中 |
| `_.exists(bool)` | 字段是否存在 |
| `_.inc(n)` | 自增 n |
| `_.remove()` | 删除字段 |
| `_.rename(name)` | 重命名字段 |
| `_.or([...])` | 或条件 |
| `_.and([...])` | 且条件 |
| `_.expr(expr)` | 表达式 |

## 聚合操作符

| 操作符 | 说明 |
|--------|------|
| `$.sum(expr)` | 求和 |
| `$.avg(expr)` | 平均值 |
| `$.first(expr)` | 取第一个 |
| `$.last(expr)` | 取最后一个 |
| `$.max(expr)` | 最大值 |
| `$.min(expr)` | 最小值 |
| `$.addToSet(expr)` | 添加到集合 |
| `$.size(expr)` | 数组大小 |
| `$.cond({if, then, else})` | 条件判断 |
| `$.dateToString(...)` | 日期转字符串 |
| `$.arrayElemAt(arr, index)` | 数组元素 |
| `$.geoNear(...)` | 地理位置near查询 |

---

# 事务操作

## 注意事项

1. 事务自带锁，操作时会对行进行锁定
2. 事务时间不能超过10秒，否则报错
3. 异常后未执行回滚会锁定记录约1分钟
4. 事务中操作不存在的表会直接抛出异常

## 支持事务的API

1. `vk.baseDao.add`
2. `vk.baseDao.findById`
3. `vk.baseDao.updateById`
4. `vk.baseDao.deleteById`
5. `vk.baseDao.updateAndReturn`
6. `vk.baseDao.setById`

## 转账示例

```javascript
const transaction = await vk.baseDao.startTransaction();
try {
  let dbName = "uni-id-users";
  let money = 100;

  // 查询用户001的余额
  const user001 = await vk.baseDao.findById({
    db: transaction, // 重要：带上事务对象
    dbName,
    id: "001"
  });

  // 检查余额
  if (user001.account_balance < money) {
    return await vk.baseDao.rollbackTransaction({
      db: transaction,
      err: { code: -1, msg: "余额不足" }
    });
  }

  // 用户001减100
  await vk.baseDao.updateById({
    db: transaction,
    dbName,
    id: "001",
    dataJson: {
      account_balance: _.inc(money * -1)
    }
  });

  // 用户002加100
  await vk.baseDao.updateById({
    db: transaction,
    dbName,
    id: "002",
    dataJson: {
      account_balance: _.inc(money)
    }
  });

  // 提交事务
  await transaction.commit();
  return { code: 0, msg: "转账成功" };

} catch (err) {
  // 回滚事务
  return await vk.baseDao.rollbackTransaction({
    db: transaction,
    err
  });
}
```

## 简易模板

```javascript
const transaction = await vk.baseDao.startTransaction();
try {
  // 数据库操作...

  await transaction.commit();
} catch (err) {
  await vk.baseDao.rollbackTransaction({
    db: transaction,
    err
  });
}
```

---

# DAO层封装

## DAO层作用

1. 复用数据库API，减少重复代码
2. 积木式开发，业务逻辑与数据访问分离
3. 可脱离业务编写，数据库表名确定即可开发

## 命名规范

| 操作 | 前缀 |
|------|------|
| 查单条 | find / get |
| 查多条 | list |
| 统计 | count |
| 新增 | add / save |
| 删除 | delete / remove |
| 修改 | update |

## 示例

```javascript
// router/dao/modules/userDao.js
module.exports = {
  // 根据ID获取用户
  findById(id) {
    return vk.baseDao.findById({
      dbName: "uni-id-users",
      id
    });
  },
  // 根据手机号获取用户
  findByMobile(mobile) {
    return vk.baseDao.findByWhereJson({
      dbName: "uni-id-users",
      whereJson: { mobile }
    });
  },
  // 根据状态获取用户列表
  listByStatus(status, pageIndex = 1, pageSize = 20) {
    return vk.baseDao.select({
      dbName: "uni-id-users",
      pageIndex,
      pageSize,
      whereJson: { status }
    });
  },
  // 新增用户
  add(data) {
    return vk.baseDao.add({
      dbName: "uni-id-users",
      dataJson: data
    });
  },
  // 根据ID删除用户
  deleteById(id) {
    return vk.baseDao.deleteById({
      dbName: "uni-id-users",
      id
    });
  },
  // 根据ID修改用户
  updateById(id, data) {
    return vk.baseDao.updateById({
      dbName: "uni-id-users",
      id,
      dataJson: data
    });
  }
};
```

## 调用方式

```javascript
// 云函数中
let user = await vk.daoCenter.userDao.findById(userId);
let list = await vk.daoCenter.userDao.listByStatus(1);
```

---

# 扩展数据库

## 切换数据库实例

```javascript
const newDb = uniCloud.database({
  id: "数据库实例ID"
});

let info = await vk.baseDao.findById({
  db: newDb, // 指定数据库实例
  dbName: "vk-test",
  id: "xxx"
});
```

## 切换数据库

```javascript
const newDb = uniCloud.database({
  database: "数据库实例下的数据库名称"
});
```

## 同时切换实例和库

```javascript
const newDb = uniCloud.database({
  id: "数据库实例ID",
  database: "数据库名称"
});
```

---

# 参考文档

详细使用说明请查看 references 目录：

- [API完整参考](references/api.md) - 所有API参数和返回值
- [连表查询详解](references/selects.md) - selects和foreignDB完整指南
- [树状结构查询](references/tree.md) - treeProps参数和示例
- [常见问题解答](references/faq.md) - 数据库操作常见问题
- [事务操作](references/transaction.md) - 事务使用详解
- [DAO层封装](references/dao.md) - DAO层命名规范和示例
- [扩展数据库](references/ext_database.md) - 多数据库操作
