# 性能优化指南

vk.baseDao.getTableData 的性能优化是开发中需要重点关注的问题。本文档提供全面的性能优化建议。

## 性能评估标准

### rows查询耗时

| 耗时 | 说明 |
|------|------|
| [0, 100ms) | 正常 |
| [100ms, 300ms) | 检查索引,优化查询条件 |
| 300ms以上 | 检查索引,优化查询条件,必要时修改业务逻辑 |

### count查询耗时

| 耗时 | 说明 |
|------|------|
| [0, 100ms) | 正常 |
| [100ms, 300ms) | 可选优化 |
| [300ms, 1000ms) | 检查索引,优化查询条件 |
| 1000ms以上 | 检查索引,优化查询条件,必要时修改业务逻辑 |

### 开启调试模式

```javascript
let res = await vk.baseDao.getTableData({
  dbName: "表名",
  data: data,
  debug: true  // 开启调试模式,返回数据库执行耗时
});

console.log(res.debug);  // 查看耗时信息
```

## 优化策略

### 1. getCount参数优化

#### 问题

每次查询都执行count请求会浪费性能,特别是带条件的count请求。

#### 解决方案

**小表(< 1万条)**: 使用 `getCount: true`

```javascript
let res = await vk.baseDao.getTableData({
  dbName: "小表",
  data: data,
  getCount: true
});
```

**中表(1万-100万条)**: 使用 `getCount: "auto"`

```javascript
let res = await vk.baseDao.getTableData({
  dbName: "中表",
  data: data,
  getCount: "auto"  // 首次查询执行count,翻页时不执行
});
```

**大表(> 100万条)**: 使用 `getCount: false`

```javascript
let res = await vk.baseDao.getTableData({
  dbName: "大表",
  data: data,
  getCount: false  // 不执行count请求
});
```

### 2. 索引优化

#### 为常用查询字段建立索引

```javascript
// 云函数中
let db = uniCloud.database();
await db.collection('表名').createIndex({
  user_id: 1,
  status: 1,
  _add_time: -1
});
```

#### 复合索引

```javascript
// 为经常一起查询的字段建立复合索引
await db.collection('订单表').createIndex({
  user_id: 1,
  status: 1,
  _add_time: -1
});
```

#### 索引选择原则

1. **为where条件中的字段建立索引**

```javascript
// good - user_id有索引
whereJson: {
  user_id: uid
}

// bad - user_id无索引
whereJson: {
  user_id: uid
}
```

2. **为排序字段建立索引**

```javascript
// good - _add_time有索引
sortArr: [
  { name: "_add_time", type: "desc" }
]

// bad - _add_time无索引
sortArr: [
  { name: "_add_time", type: "desc" }
]
```

3. **为连表的外键建立索引**

```javascript
// 主表的外键
await db.collection('主表').createIndex({
  user_id: 1
});

// 副表的外键
await db.collection('副表').createIndex({
  _id: 1
});
```

### 3. 查询条件优化

#### 先过滤再连表

```javascript
// bad - 先连表再过滤
let res = await vk.baseDao.getTableData({
  dbName: "评论表",
  foreignDB: [...],
  lastWhereJson: {
    "userInfo.gender": 2
  }
});

// good - 先在主表过滤
let res = await vk.baseDao.getTableData({
  dbName: "评论表",
  whereJson: {
    _add_time: _.gte("2024-01-01")  // 先过滤时间范围
  },
  foreignDB: [...]
});
```

#### 限制查询范围

```javascript
// bad - 查询全表
let res = await vk.baseDao.getTableData({
  dbName: "订单表",
  data: data
});

// good - 限制时间范围
let { monthStart, monthEnd } = vk.pubfn.getCommonTime();
let res = await vk.baseDao.getTableData({
  dbName: "订单表",
  whereJson: {
    _add_time: _.gte(monthStart).lte(monthEnd)  // 只查本月数据
  },
  data: data
});
```

#### 避免模糊查询前缀

```javascript
// bad - %在前,无法使用索引
columns: [
  { key: "nickname", mode: "%%" }  // LIKE "%张三%"
]

// good - %在后,可以使用索引
columns: [
  { key: "nickname", mode: "%*" }  // LIKE "张三%"
]
```

### 4. 字段显示优化

#### 只返回需要的字段

```javascript
// bad - 返回所有字段
let res = await vk.baseDao.getTableData({
  dbName: "用户表",
  data: data
});

// good - 只返回需要的字段
let res = await vk.baseDao.getTableData({
  dbName: "用户表",
  data: data,
  fieldJson: {
    _id: true,
    nickname: true,
    mobile: true,
    token: false,      // 不返回敏感字段
    password: false    // 不返回敏感字段
  }
});
```

#### 连表时限制副表字段

```javascript
foreignDB: [
  {
    dbName: "uni-id-users",
    localKey: "user_id",
    foreignKey: "_id",
    as: "userInfo",
    limit: 1,
    fieldJson: {
      nickname: true,
      avatar: true,
      token: false,    // 不返回敏感字段
      password: false  // 不返回敏感字段
    }
  }
]
```

### 5. 分页优化

#### 限制最大页数

```javascript
// 前端
<vk-data-table :max-page-count="1000"></vk-data-table>
```

#### 使用游标分页

对于大表,使用游标分页代替传统分页:

```javascript
// 传统分页 - 性能随页码增加而降低
let res = await vk.baseDao.getTableData({
  dbName: "大表",
  data: {
    pageIndex: 10000,  // 第10000页,性能很差
    pageSize: 20
  }
});

// 游标分页 - 性能稳定
let lastId = "上一页最后一条记录的_id";
let res = await vk.baseDao.getTableData({
  dbName: "大表",
  data: {
    pageSize: 20
  },
  whereJson: {
    _id: _.gt(lastId)  // 使用游标
  },
  sortArr: [
    { name: "_id", type: "asc" }
  ],
  getCount: false
});
```

### 6. 连表优化

#### 限制副表数据量

```javascript
foreignDB: [
  {
    dbName: "副表",
    localKey: "user_id",
    foreignKey: "_id",
    as: "userInfo",
    limit: 1,  // 只取1条
    whereJson: {
      status: 1  // 副表先过滤
    }
  }
]
```

#### 避免深层嵌套

```javascript
// bad - 3层嵌套
foreignDB: [
  {
    dbName: "副表1",
    foreignDB: [
      {
        dbName: "副表2",
        foreignDB: [
          {
            dbName: "副表3"
          }
        ]
      }
    ]
  }
]

// good - 1层嵌套
foreignDB: [
  {
    dbName: "副表1"
  }
]
```

#### 避免lastWhereJson和lastSortArr

```javascript
// bad - 使用lastWhereJson
let res = await vk.baseDao.getTableData({
  dbName: "评论表",
  foreignDB: [...],
  lastWhereJson: {
    "userInfo.gender": 2  // 性能差
  }
});

// good - 先在主表过滤
let res = await vk.baseDao.getTableData({
  dbName: "评论表",
  whereJson: {
    user_id: _.in(femaleUserIds)  // 先筛选出女性用户ID
  },
  foreignDB: [...]
});
```

### 7. 分组优化

#### 先过滤再分组

```javascript
// bad - 先分组再过滤
let res = await vk.baseDao.getTableData({
  dbName: "订单表",
  groupJson: {
    _id: "$user_id",
    total_amount: $.sum("$amount")
  },
  lastWhereJson: {
    total_amount: _.gt(1000)  // 性能差
  }
});

// good - 先过滤再分组
let res = await vk.baseDao.getTableData({
  dbName: "订单表",
  whereJson: {
    _add_time: _.gte("2024-01-01")  // 先过滤时间范围
  },
  groupJson: {
    _id: "$user_id",
    total_amount: $.sum("$amount")
  }
});
```

#### 为分组字段建立索引

```javascript
await db.collection('订单表').createIndex({
  user_id: 1
});
```

#### 限制分组数量

```javascript
let res = await vk.baseDao.getTableData({
  dbName: "订单表",
  pageIndex: 1,
  pageSize: 100,  // 限制返回的分组数量
  groupJson: {
    _id: "$user_id",
    total_amount: $.sum("$amount")
  }
});
```

## 性能测试

### 测试方法

1. **连接云端云函数测试**

本地云函数由于是外网访问数据库,很慢,不准。必须连接云端云函数测试。

2. **多次测试取稳定值**

```javascript
// 测试5次,取平均值
let times = [];
for (let i = 0; i < 5; i++) {
  let res = await vk.baseDao.getTableData({
    dbName: "表名",
    data: data,
    debug: true
  });
  times.push(res.debug.time);
}
let avgTime = times.reduce((a, b) => a + b) / times.length;
console.log('平均耗时:', avgTime, 'ms');
```

### 性能分析

```javascript
let res = await vk.baseDao.getTableData({
  dbName: "表名",
  data: data,
  debug: true
});

console.log('总耗时:', res.debug.time, 'ms');
console.log('rows耗时:', res.debug.rowsTime, 'ms');
console.log('count耗时:', res.debug.countTime, 'ms');
```

## 常见性能问题

### 问题1: count请求超时

**原因**: 带whereJson条件的count请求,匹配的记录数太多。

**解决方案**:

1. 设置 `getCount: false`
2. 限制查询条件范围
3. 为where条件字段建立索引

```javascript
// bad
let res = await vk.baseDao.getTableData({
  dbName: "大表",
  data: {
    formData: {
      status: 1
    }
  },
  getCount: true  // count请求可能超时
});

// good
let res = await vk.baseDao.getTableData({
  dbName: "大表",
  whereJson: {
    _add_time: _.gte("2024-01-01")  // 先限制时间范围
  },
  data: {
    formData: {
      status: 1
    }
  },
  getCount: false  // 不执行count
});
```

### 问题2: 翻页性能衰减

**原因**: 使用skip+limit分页,skip值越大,性能越差。

**解决方案**:

1. 限制最大页数
2. 使用游标分页

```javascript
// bad - 性能随页码增加而降低
let res = await vk.baseDao.getTableData({
  dbName: "大表",
  data: {
    pageIndex: 10000,
    pageSize: 20
  }
});

// good - 使用游标分页
let res = await vk.baseDao.getTableData({
  dbName: "大表",
  data: {
    pageSize: 20
  },
  whereJson: {
    _id: _.gt(lastId)
  },
  sortArr: [
    { name: "_id", type: "asc" }
  ],
  getCount: false
});
```

### 问题3: 连表查询慢

**原因**:
- 没有为外键建立索引
- 使用了lastWhereJson或lastSortArr
- 副表数据量太大

**解决方案**:

1. 为外键建立索引
2. 避免使用lastWhereJson和lastSortArr
3. 限制副表数据量

```javascript
// bad
let res = await vk.baseDao.getTableData({
  dbName: "评论表",
  foreignDB: [...],
  lastWhereJson: {
    "userInfo.gender": 2  // 性能差
  }
});

// good
let res = await vk.baseDao.getTableData({
  dbName: "评论表",
  whereJson: {
    user_id: _.in(femaleUserIds)  // 先筛选
  },
  foreignDB: [
    {
      dbName: "uni-id-users",
      localKey: "user_id",
      foreignKey: "_id",
      as: "userInfo",
      limit: 1,
      whereJson: {
        gender: 2  // 副表过滤
      }
    }
  ]
});
```

### 问题4: 分组查询慢

**原因**:
- 分组前没有过滤数据
- 没有为分组字段建立索引
- 使用了lastWhereJson

**解决方案**:

1. 先过滤再分组
2. 为分组字段建立索引
3. 避免使用lastWhereJson

```javascript
// bad
let res = await vk.baseDao.getTableData({
  dbName: "订单表",
  groupJson: {
    _id: "$user_id",
    total_amount: $.sum("$amount")
  },
  lastWhereJson: {
    total_amount: _.gt(1000)  // 性能差
  }
});

// good
let res = await vk.baseDao.getTableData({
  dbName: "订单表",
  whereJson: {
    _add_time: _.gte("2024-01-01")  // 先过滤
  },
  groupJson: {
    _id: "$user_id",
    total_amount: $.sum("$amount")
  }
});
```

## 性能优化检查清单

### 查询前

- [ ] 确认表数据量大小
- [ ] 确认是否需要count请求
- [ ] 确认查询条件是否合理
- [ ] 确认是否需要建立索引

### 查询中

- [ ] 使用whereJson先过滤数据
- [ ] 使用fieldJson限制返回字段
- [ ] 避免使用lastWhereJson和lastSortArr
- [ ] 限制副表数据量
- [ ] 限制分组数量
- [ ] 限制最大页数

### 查询后

- [ ] 检查查询耗时
- [ ] 分析慢查询原因
- [ ] 优化索引
- [ ] 优化查询条件

## 最佳实践

### 1. 小表优化

```javascript
let res = await vk.baseDao.getTableData({
  dbName: "小表",
  data: {
    pageIndex: 1,
    pageSize: 20
  },
  getCount: true,  // 可以执行count
  whereJson: {},
  fieldJson: {}    // 返回所有字段
});
```

### 2. 中表优化

```javascript
let { monthStart, monthEnd } = vk.pubfn.getCommonTime();
let res = await vk.baseDao.getTableData({
  dbName: "中表",
  data: {
    pageIndex: 1,
    pageSize: 20
  },
  getCount: "auto",  // 智能count
  whereJson: {
    _add_time: _.gte(monthStart).lte(monthEnd)  // 限制时间范围
  },
  fieldJson: {
    _id: true,
    name: true
  }
});
```

### 3. 大表优化

```javascript
let lastId = "上一页最后一条记录的_id";
let res = await vk.baseDao.getTableData({
  dbName: "大表",
  data: {
    pageSize: 20
  },
  getCount: false,  // 不执行count
  whereJson: {
    _id: _.gt(lastId),  // 游标分页
    _add_time: _.gte("2024-01-01")  // 限制时间范围
  },
  fieldJson: {
    _id: true,
    name: true
  },
  sortArr: [
    { name: "_id", type: "asc" }
  ]
});
```

### 4. 连表优化

```javascript
let res = await vk.baseDao.getTableData({
  dbName: "主表",
  data: {
    pageIndex: 1,
    pageSize: 20
  },
  getCount: false,
  whereJson: {
    _add_time: _.gte("2024-01-01")  // 先过滤
  },
  foreignDB: [
    {
      dbName: "副表",
      localKey: "user_id",
      foreignKey: "_id",
      as: "userInfo",
      limit: 1,  // 只取1条
      whereJson: {
        status: 1  // 副表过滤
      },
      fieldJson: {
        nickname: true,
        avatar: true
      }
    }
  ]
});
```

### 5. 分组优化

```javascript
let res = await vk.baseDao.getTableData({
  dbName: "订单表",
  data: {
    pageIndex: 1,
    pageSize: 100
  },
  getCount: false,
  whereJson: {
    _add_time: _.gte("2024-01-01")  // 先过滤
  },
  groupJson: {
    _id: "$user_id",
    total_amount: $.sum("$amount"),
    count: $.sum(1)
  },
  sortArr: [
    { name: "total_amount", type: "desc" }
  ]
});
```
