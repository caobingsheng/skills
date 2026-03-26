# 连表查询详解

vk.baseDao.getTableData 支持强大的多表关联查询功能,通过 `foreignDB` 参数实现。

## 基础概念

### foreignDB 结构

```javascript
foreignDB: [
  {
    dbName: String,        // 副表表名
    localKey: String,      // 主表外键字段名
    foreignKey: String,    // 副表外键字段名
    as: String,            // 副表结果别名
    limit: Number,         // 限制数量
    localKeyType: String,  // 主表外键类型
    foreignKeyType: String,// 副表外键类型
    whereJson: Object,     // 副表where条件
    sortArr: Array,        // 副表排序规则
    fieldJson: Object,     // 副表字段显示规则
    foreignDB: Array       // 副表的副表(嵌套)
  }
]
```

### limit 参数说明

- `limit: 1` - 返回对象形式
- `limit: >1` - 返回数组形式

## 场景1: 1张主表多张副表

### 需求

查询用户信息,同时查询他们的订单记录和VIP信息。

### 主表

- uni-id-users (用户表)

### 副表

- order (用户订单表)
- vip (会员卡表)

### 代码示例

```javascript
let res = await vk.baseDao.getTableData({
  dbName: "uni-id-users",
  getCount: false,
  pageIndex: 1,
  pageSize: 10,
  whereJson: {},
  fieldJson: {
    token: false,
    password: false
  },
  sortArr: [
    { name: "_id", type: "desc" }
  ],
  foreignDB: [
    {
      dbName: "order",
      localKey: "_id",
      foreignKey: "user_id",
      as: "orderList",
      limit: 10,
      whereJson: {},
      fieldJson: {},
      sortArr: [
        { name: "time", type: "desc" }
      ]
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

### 返回结果

```javascript
{
  rows: [
    {
      _id: "001",
      nickname: "张三",
      orderList: [
        { order_id: "1001", amount: 100 },
        { order_id: "1002", amount: 200 }
      ],
      vipInfo: {
        vip_id: "vip001",
        level: 1
      }
    }
  ]
}
```

## 场景2: 副表也有副表(嵌套连表)

### 需求

查询评论信息,同时查询评论发布者信息,再查询他们各自的订单信息。

### 主表

- opendb-mall-comments (评论表)

### 副表

- uni-id-users (用户表)
- opendb-mall-orders (用户订单表)

### 代码示例

```javascript
let res = await vk.baseDao.getTableData({
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
          sortArr: [
            { name: "_add_time", type: "desc" }
          ]
        }
      ]
    }
  ]
});
```

### 返回结果

```javascript
{
  rows: [
    {
      _id: "comment001",
      content: "好评",
      userInfo: {
        _id: "user001",
        nickname: "张三",
        orderList: [
          { order_id: "1001", amount: 100 },
          { order_id: "1002", amount: 200 },
          { order_id: "1003", amount: 300 }
        ]
      }
    }
  ]
}
```

## 场景3: 主表外键是数组

### 需求

查询用户信息,同时带出角色列表。

### 主表

- uni-id-users (用户表)

### 副表

- uni-id-roles (角色表)

### 代码示例

```javascript
let res = await vk.baseDao.getTableData({
  dbName: "uni-id-users",
  getCount: true,
  pageIndex: 1,
  pageSize: 10,
  whereJson: {},
  foreignDB: [
    {
      dbName: "uni-id-roles",
      localKey: "role",
      localKeyType: "array",    // 主表外键是数组
      foreignKey: "role_id",
      as: "roleList",
      limit: 1000
    }
  ]
});
```

### 返回结果

```javascript
{
  rows: [
    {
      _id: "user001",
      nickname: "张三",
      role: ["role001", "role002"],
      roleList: [
        { role_id: "role001", name: "管理员" },
        { role_id: "role002", name: "编辑" }
      ]
    }
  ]
}
```

### 按主表外键的索引顺序排序

```javascript
let res = await vk.baseDao.getTableData({
  dbName: "vk-test",
  getCount: true,
  pageIndex: 1,
  pageSize: 10,
  whereJson: {},
  foreignDB: [
    {
      dbName: "uni-id-users",
      localKey: "user_ids",
      localKeyType: "array",
      localKeyIndex: "index",  // 数组索引以index字段显示
      foreignKey: "_id",
      as: "userList",
      limit: 1000,
      sortArr: [
        { name: "index", type: "asc" }  // 按主表的数组字段索引顺序升序
      ],
      fieldJson: {
        index: false  // 最终结果去除索引字段
      }
    }
  ]
});
```

## 场景4: 副表外键是数组

### 需求

查询角色信息,同时带出拥有该角色的用户列表。

### 主表

- uni-id-roles (角色表)

### 副表

- uni-id-users (用户表)

### 代码示例

```javascript
let res = await vk.baseDao.getTableData({
  dbName: "uni-id-roles",
  getCount: false,
  pageIndex: 1,
  pageSize: 10,
  whereJson: {},
  foreignDB: [
    {
      dbName: "uni-id-users",
      localKey: "role_id",
      foreignKey: "role",
      foreignKeyType: "array",  // 副表外键是数组
      as: "userInfo",
      limit: 1000
    }
  ]
});
```

### 返回结果

```javascript
{
  rows: [
    {
      _id: "role001",
      name: "管理员",
      userInfo: [
        { _id: "user001", nickname: "张三", role: ["role001", "role002"] },
        { _id: "user002", nickname: "李四", role: ["role001"] }
      ]
    }
  ]
}
```

## 场景5: 使用数组下标进行连表

### 需求

查询用户信息,并连表带出第一级分享人信息。

### 代码示例

```javascript
let db = uniCloud.database();
let _ = db.command;
let $ = _.aggregate;

let res = await vk.baseDao.getTableData({
  dbName: "uni-id-users",
  getCount: false,
  pageIndex: 1,
  pageSize: 5,
  fieldJson: {
    token: false,
    password: false
  },
  foreignDB: [
    {
      dbName: "uni-id-users",
      localKey: $.arrayElemAt(['$inviter_uid', 0]),  // 取数组第一个元素
      foreignKey: "_id",
      as: "inviterUserInfo",
      limit: 1,
      fieldJson: {
        token: false,
        password: false
      }
    }
  ]
});
```

### 取最后一个元素

```javascript
localKey: $.arrayElemAt(['$inviter_uid', -1])
```

## 场景6: 连表后筛选

### 需求

查询女性用户的评论信息。

### 代码示例

```javascript
let res = await vk.baseDao.getTableData({
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
    "userInfo.gender": 2  // 筛选性别为女的用户
  }
});
```

**注意**: lastWhereJson在数据量大的情况下有性能问题,慎用。

## 场景7: 连表后排序

### 需求

查询评论信息,且优先展示新用户的评论。

### 代码示例

```javascript
let res = await vk.baseDao.getTableData({
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
  lastSortArr: [
    { name: "userInfo._add_time", type: "desc" }
  ]
});
```

**注意**: lastSortArr在数据量大的情况下有性能问题,慎用。

## 场景8: 将副表字段提升到顶层

### 需求

副表层级过深,将副表字段拆分到顶层显示。

### 代码示例

```javascript
let res = await vk.baseDao.getTableData({
  dbName: "表名",
  getCount: false,
  pageIndex: 1,
  pageSize: 20,
  whereJson: {},
  addFields: {
    a: "$副表as字段.a",      // 将副表的a字段赋值给主表的a字段
    b: "$副表as字段.b"       // 将副表的b字段赋值给主表的b字段
  },
  fieldJson: {
    副表as字段: false  // 不显示副表的字段
  },
  sortArr: [
    { name: "_id", type: "desc" }
  ],
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

### 返回结果

```javascript
{
  rows: [
    {
      _id: "001",
      a: "副表的a值",  // 直接在顶层
      b: "副表的b值"   // 直接在顶层
    }
  ]
}
```

## 性能优化建议

### 1. 限制副表数据量

```javascript
foreignDB: [
  {
    dbName: "副表名",
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

### 2. 避免深层嵌套

云数据库限制最多可以嵌套15层,但建议不超过3层。

### 3. 使用fieldJson减少返回字段

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
      token: false,      // 不返回敏感字段
      password: false
    }
  }
]
```

### 4. 避免lastWhereJson和lastSortArr

数据量大时,先在主表的where条件中筛选,减少连表后的数据量。

```javascript
// 不推荐
let res = await vk.baseDao.getTableData({
  dbName: "评论表",
  foreignDB: [...],
  lastWhereJson: {
    "userInfo.gender": 2
  }
});

// 推荐
let res = await vk.baseDao.getTableData({
  dbName: "评论表",
  whereJson: {
    _add_time: _.gte("2024-01-01")  // 先在主表过滤
  },
  foreignDB: [...]
});
```

## 常见问题

### 1. 连表查询最多支持多少层?

最多支持15层嵌套,但建议不超过3层。

### 2. limit参数的作用?

- `limit: 1` - 返回对象形式
- `limit: >1` - 返回数组形式
- 不设置limit - 默认返回数组形式

### 3. 如何实现左连接?

vk.baseDao.getTableData默认就是左连接,主表记录一定会返回,副表数据可能为空。

### 4. 如何实现内连接?

使用lastWhereJson对副表字段进行筛选,但性能较差,建议在主表where条件中先过滤。

### 5. 连表查询的性能如何?

连表查询的性能取决于:
- 数据量大小
- 索引是否合理
- 是否使用了lastWhereJson/lastSortArr
- 嵌套层数

建议:
- 数据量大时先在主表过滤
- 为外键字段建立索引
- 避免使用lastWhereJson和lastSortArr
- 控制嵌套层数
