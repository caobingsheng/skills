# 连表查询详解

## Overview

`vk.baseDao.selects` 是 vk-unicloud 框架提供的万能连表查询API，支持多表关联、分组聚合、排序筛选等功能。

## 基础调用

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
      limit: 1
    }
  ]
});
```

## foreignDB 连表规则

### 参数说明

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| dbName | String | 是 | 副表表名 |
| localKey | String | 是 | 主表外键名 |
| foreignKey | String | 是 | 副表外键名 |
| as | String | 是 | 副表连表结果的别名 |
| localKeyType | String | 否 | 主表外键类型，可选：array |
| foreignKeyType | String | 否 | 副表外键类型，可选：array |
| localKeyIndex | String | 否 | 当localKeyType为array时有效 |
| whereJson | Object | 否 | 副表where条件 |
| sortArr | Array | 否 | 副表排序规则 |
| limit | Number | 否 | 副表限制取多少条数据 |
| foreignDB | Array | 否 | 副表连表规则 |
| addFields | Object | 否 | 副表添加自定义字段规则 |
| fieldJson | Object | 否 | 副表字段显示规则 |

### 基础示例

```javascript
foreignDB: [
  {
    dbName: "order",
    localKey: "_id",
    foreignKey: "user_id",
    as: "orderList",
    limit: 10
  }
]
```

### 嵌套连表

```javascript
foreignDB: [
  {
    dbName: "uni-id-users",
    localKey: "user_id",
    foreignKey: "_id",
    as: "userInfo",
    limit: 1,
    foreignDB: [
      {
        dbName: "opendb-mall-orders",
        localKey: "_id",
        foreignKey: "user_id",
        as: "orderList",
        limit: 3
      }
    ]
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

### 场景2：副表也有副表

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
      limit: 1,
      foreignDB: [
        {
          dbName: "opendb-mall-orders",
          localKey: "_id",
          foreignKey: "user_id",
          as: "orderList",
          limit: 3,
          sortArr: [{ name: "_add_time", type: "desc" }]
        }
      ]
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
    "userInfo.gender": 2
  }
});
```

### 场景4：地理位置排序

```javascript
res = await vk.baseDao.selects({
  dbName: "vk-test",
  getCount: true,
  pageIndex: 1,
  pageSize: 10,
  whereJson: {
    location: _.geoNear({
      geometry: new db.Geo.Point(120.12792, 30.228932),
      maxDistance: 4000,
      minDistance: 0,
      distanceMultiplier: 1,
      distanceField: "distance"
    })
  },
  foreignDB: [
    {
      dbName: "uni-id-users",
      localKey: "user_id",
      foreignKey: "_id",
      as: "userInfo",
      limit: 1
    }
  ]
});
```

### 场景5：主表外键是数组

```javascript
res = await vk.baseDao.selects({
  dbName: "uni-id-users",
  pageIndex: 1,
  pageSize: 10,
  foreignDB: [
    {
      dbName: "uni-id-roles",
      localKey: "role",
      localKeyType: "array",
      foreignKey: "role_id",
      as: "roleList",
      limit: 1000
    }
  ]
});
```

### 场景6：副表外键是数组

```javascript
res = await vk.baseDao.selects({
  dbName: "uni-id-roles",
  pageIndex: 1,
  pageSize: 10,
  foreignDB: [
    {
      dbName: "uni-id-users",
      localKey: "role_id",
      foreignKey: "role",
      foreignKeyType: "array",
      as: "userInfo",
      limit: 1000
    }
  ]
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
    _id: "$user_id",
    user_id: $.first("$user_id"),
    payment_amount: $.sum("$payment_amount"),
    count: $.sum(1)
  },
  sortArr: [{ name: "payment_amount", type: "desc" }],
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
    payment_amount: _.gt(1000)
  }
});
```

### 场景8：分组统计带if

```javascript
res = await vk.baseDao.selects({
  dbName: "学生学科成绩表",
  pageIndex: 1,
  pageSize: 1000,
  whereJson: {
    no: "20211201"
  },
  groupJson: {
    _id: "$班级id字段",
    count1: $.sum($.cond({
      if: $.gte(['$数学成绩字段', '$语文成绩字段']),
      then: 1,
      else: 0
    })),
    count2: $.sum($.cond({
      if: $.lt(['$物理成绩字段', '$化学成绩字段']),
      then: 1,
      else: 0
    }))
  },
  sortArr: [{ name: "count1", type: "desc" }]
});
```

### 场景10：去重查询

```javascript
res = await vk.baseDao.selects({
  dbName: "表名",
  pageIndex: 1,
  pageSize: 10,
  whereJson: {},
  groupJson: {
    _id: "$key1",
    key1: $.first("$key1"),
    key2: $.first("$key2"),
    key3: $.first("$key3"),
    count: $.sum(1)
  },
  sortArr: [{ name: "count", type: "desc" }]
});
```

### 场景11：数组下标连表

```javascript
// 第一个元素
res = await vk.baseDao.selects({
  dbName: "uni-id-users",
  pageIndex: 1,
  pageSize: 5,
  fieldJson: { token: false, password: false },
  foreignDB: [
    {
      dbName: "uni-id-users",
      localKey: $.arrayElemAt(['$inviter_uid', 0]),
      foreignKey: "_id",
      as: "inviterUserInfo",
      limit: 1
    }
  ]
});

// 最后一个元素
res = await vk.baseDao.selects({
  dbName: "uni-id-users",
  pageIndex: 1,
  pageSize: 5,
  fieldJson: { token: false, password: false },
  foreignDB: [
    {
      dbName: "uni-id-users",
      localKey: $.arrayElemAt(['$inviter_uid', -1]),
      foreignKey: "_id",
      as: "lastInviterUserInfo",
      limit: 1
    }
  ]
});
```

### 场景12：通过副表字段排序

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
  lastSortArr: [{ name: "userInfo._add_time", type: "desc" }]
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
      format: "%Y-%m",
      timezone: "+08:00"
    }),
    count: $.sum(1)
  },
  sortArr: [{ name: "_id", type: "desc" }]
});
```

## addFields 和 fieldJson 组合使用

```javascript
res = await vk.baseDao.selects({
  dbName: "表名",
  pageIndex: 1,
  pageSize: 20,
  whereJson: {},
  addFields: {
    a: "$副表as字段.a",
    b: "$副表as字段.b"
  },
  fieldJson: {
    副表as字段: false
  },
  sortArr: [{ name: "_id", type: "desc" }],
  foreignDB: [
    {
      dbName: "副表表名",
      localKey: "主表外键名",
      foreignKey: "副表外键名",
      as: "副表as字段",
      limit: 1
    }
  ]
});
```

## getCount 性能说明

| 耗时 | 说明 |
|------|------|
| [0,100ms) | 正常 |
| [100ms,300ms) | 检查索引 |
| 300ms以上 | 需要优化 |

## hasMore 精确计算

设置 `hasMore: true` 会多查一条数据来精确判断是否有下一页。

## lastWhereJson 和 lastSortArr 性能

这两个参数在数据量大时有性能问题，建议先在主表的where条件中进行筛选。
