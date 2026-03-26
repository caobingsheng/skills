# 分组聚合查询详解

vk.baseDao.getTableData 支持强大的分组统计和聚合操作,通过 `groupJson` 参数实现。

## 基础概念

### groupJson 结构

```javascript
groupJson: {
  _id: "$分组字段",           // 分组标识(必填)
  字段1: $.聚合函数("$字段1"),  // 聚合字段1
  字段2: $.聚合函数("$字段2"),  // 聚合字段2
  count: $.sum(1)             // 统计每组记录条数
}
```

### 常用聚合函数

| 函数 | 说明 | 示例 |
|------|------|------|
| $.sum() | 求和 | $.sum("$amount") |
| $.avg() | 平均值 | $.avg("$score") |
| $.first() | 第一条记录的值 | $.first("$nickname") |
| $.last() | 最后一条记录的值 | $.last("$nickname") |
| $.max() | 最大值 | $.max("$price") |
| $.min() | 最小值 | $.min("$price") |
| $.push() | 数组形式返回所有值 | $.push("$order_id") |
| $.addToSet() | 数组形式返回唯一值 | $.addToSet("$tag") |

## 场景1: 基础分组统计

### 需求

按用户分组,统计每个用户的消费金额和订单数量。

### 代码示例

```javascript
let res = await vk.baseDao.getTableData({
  dbName: "订单表",
  pageIndex: 1,
  pageSize: 10,
  whereJson: {},
  groupJson: {
    _id: "$user_id",           // 按user_id分组
    user_id: $.first("$user_id"),  // 输出user_id
    payment_amount: $.sum("$payment_amount"),  // 求和支付金额
    count: $.sum(1)            // 统计记录条数
  },
  sortArr: [
    { name: "payment_amount", type: "desc" }  // 按金额降序
  ]
});
```

### 返回结果

```javascript
{
  rows: [
    {
      _id: "user001",
      user_id: "user001",
      payment_amount: 5000,
      count: 10
    },
    {
      _id: "user002",
      user_id: "user002",
      payment_amount: 3000,
      count: 5
    }
  ]
}
```

## 场景2: 分组后连表

### 需求

按用户分组统计消费金额,并连表查询用户信息。

### 代码示例

```javascript
let res = await vk.baseDao.getTableData({
  dbName: "你的消费记录表或订单表",
  pageIndex: 1,
  pageSize: 10,
  whereJson: {},
  groupJson: {
    _id: "$user_id",
    user_id: $.first("$user_id"),
    payment_amount: $.sum("$payment_amount"),
    count: $.sum(1)
  },
  sortArr: [
    { name: "payment_amount", type: "desc" }
  ],
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
    payment_amount: _.gt(1000)  // 筛选金额大于1000的
  }
});
```

### 返回结果

```javascript
{
  rows: [
    {
      _id: "user001",
      user_id: "user001",
      payment_amount: 5000,
      count: 10,
      userInfo: {
        nickname: "张三",
        mobile: "13800138000"
      }
    }
  ]
}
```

**注意**: lastWhereJson在数据量大的情况下有性能问题,建议先在主表where条件中筛选。

## 场景3: 分组统计带条件

### 需求

以班级分组,统计每个班级中数学成绩大于语文成绩的人数。

### 代码示例

```javascript
let db = uniCloud.database();
let _ = db.command;
let $ = _.aggregate;

let res = await vk.baseDao.getTableData({
  dbName: "学生学科成绩表",
  pageIndex: 1,
  pageSize: 1000,
  whereJson: {
    no: "20211201"  // 本期考试编号
  },
  groupJson: {
    _id: "$班级id字段",
    count1: $.sum($.cond({
      if: $.gte(['$数学成绩字段', '$语文成绩字段']),
      then: 1,
      else: 0
    }))
  },
  sortArr: [
    { name: "count1", type: "desc" }
  ]
});
```

### 返回结果

```javascript
{
  rows: [
    {
      _id: "class001",
      count1: 30  // 数学成绩大于语文成绩的人数
    },
    {
      _id: "class002",
      count1: 25
    }
  ]
}
```

## 场景4: 多条件分组

### 需求

按班级和性别分组,统计每组的人数。

### 代码示例

```javascript
let res = await vk.baseDao.getTableData({
  dbName: "学生表",
  pageIndex: 1,
  pageSize: 100,
  whereJson: {},
  groupJson: {
    _id: {
      class: "$class_id",  // 班级
      gender: "$gender"    // 性别
    },
    class_id: $.first("$class_id"),
    gender: $.first("$gender"),
    count: $.sum(1)
  },
  sortArr: [
    { name: "count", type: "desc" }
  ]
});
```

### 返回结果

```javascript
{
  rows: [
    {
      _id: { class: "class001", gender: 1 },
      class_id: "class001",
      gender: 1,
      count: 25
    },
    {
      _id: { class: "class001", gender: 2 },
      class_id: "class001",
      gender: 2,
      count: 20
    }
  ]
}
```

## 场景5: 日期分组统计

### 需求

统计本年度每月注册用户的数量。

### 代码示例

```javascript
let db = uniCloud.database();
let _ = db.command;
let $ = _.aggregate;

let { yearStart, yearEnd } = vk.pubfn.getCommonTime();

let res = await vk.baseDao.getTableData({
  dbName: "uni-id-users",
  pageIndex: 1,
  pageSize: 1000,
  whereJson: {
    register_date: _.gte(yearStart).lte(yearEnd)  // 只查询本年
  },
  groupJson: {
    _id: $.dateToString({
      date: $.add([new Date(0), "$register_date"]),
      format: "%Y-%m",
      timezone: "+08:00",
      onNull: null
    }),
    count: $.sum(1)
  },
  sortArr: [
    { name: "_id", type: "desc" }
  ]
});
```

### 返回结果

```javascript
{
  rows: [
    { _id: "2024-12", count: 150 },
    { _id: "2024-11", count: 120 },
    { _id: "2024-10", count: 100 }
  ]
}
```

### 日期格式说明符

| 说明符 | 描述 | 合法值 |
|--------|------|--------|
| %Y | 年份(4位数) | 0000-9999 |
| %m | 月份(2位数) | 01-12 |
| %d | 日期(2位数) | 01-31 |
| %H | 小时(2位数,24小时制) | 00-23 |
| %M | 分钟(2位数) | 00-59 |
| %S | 秒(2位数) | 00-60 |
| %L | 毫秒(3位数) | 000-999 |
| %w | 星期几 | 1-7 |
| %j | 一年中的一天(3位数) | 001-366 |
| %U | 一年中的一周(2位数) | 00-53 |

## 场景6: 去重分组

### 需求

按指定字段去重查询。

### 代码示例

```javascript
let res = await vk.baseDao.getTableData({
  dbName: "表名",
  pageIndex: 1,
  pageSize: 10,
  whereJson: {},
  groupJson: {
    _id: "$key1",              // 按key1分组
    key1: $.first("$key1"),    // 显示key1
    key2: $.first("$key2"),    // 显示key2
    key3: $.first("$key3"),    // 显示key3
    count: $.sum(1)            // 统计每组记录条数
  },
  sortArr: [
    { name: "count", type: "desc" }
  ]
});
```

### 多字段组合去重

```javascript
let res = await vk.baseDao.getTableData({
  dbName: "表名",
  pageIndex: 1,
  pageSize: 10,
  whereJson: {},
  groupJson: {
    _id: {
      key1: "$key1",
      key2: "$key2"
    },
    key1: $.first("$key1"),
    key2: $.first("$key2"),
    key3: $.first("$key3"),
    count: $.sum(1)
  },
  sortArr: [
    { name: "count", type: "desc" }
  ]
});
```

## 场景7: 地理位置分组

### 需求

按地理位置分组,统计每个区域的用户数量。

### 代码示例

```javascript
let db = uniCloud.database();
let _ = db.command;
let $ = _.aggregate;

let res = await vk.baseDao.getTableData({
  dbName: "用户表",
  pageIndex: 1,
  pageSize: 100,
  whereJson: {},
  groupJson: {
    _id: "$province",           // 按省份分组
    province: $.first("$province"),
    count: $.sum(1)
  },
  sortArr: [
    { name: "count", type: "desc" }
  ]
});
```

## 聚合函数详解

### $.sum() - 求和

```javascript
groupJson: {
  _id: "$user_id",
  total_amount: $.sum("$amount")  // 求和金额字段
}
```

### $.avg() - 平均值

```javascript
groupJson: {
  _id: "$class_id",
  avg_score: $.avg("$score")  // 平均分
}
```

### $.first() - 第一条记录的值

```javascript
groupJson: {
  _id: "$user_id",
  nickname: $.first("$nickname"),  // 取第一条记录的nickname
  mobile: $.first("$mobile")
}
```

### $.last() - 最后一条记录的值

```javascript
groupJson: {
  _id: "$user_id",
  last_login: $.last("$login_time")  // 取最后一条记录的登录时间
}
```

### $.max() - 最大值

```javascript
groupJson: {
  _id: "$class_id",
  max_score: $.max("$score")  // 最高分
}
```

### $.min() - 最小值

```javascript
groupJson: {
  _id: "$class_id",
  min_score: $.min("$score")  // 最低分
}
```

### $.push() - 数组形式返回所有值

```javascript
groupJson: {
  _id: "$user_id",
  order_ids: $.push("$order_id")  // 所有订单ID组成的数组
}
```

### $.addToSet() - 数组形式返回唯一值

```javascript
groupJson: {
  _id: "$user_id",
  tags: $.addToSet("$tag")  // 所有唯一标签组成的数组
}
```

## 条件聚合

### $.cond() - 条件判断

```javascript
groupJson: {
  _id: "$class_id",
  pass_count: $.sum($.cond({
    if: $.gte(['$score', 60]),  // 如果分数>=60
    then: 1,                    // 则加1
    else: 0                     // 否则加0
  }))
}
```

### 多条件判断

```javascript
groupJson: {
  _id: "$class_id",
  excellent_count: $.sum($.cond({
    if: $.gte(['$score', 90]),
    then: 1,
    else: 0
  })),
  pass_count: $.sum($.cond({
    if: $.and([
      $.gte(['$score', 60]),
      $.lt(['$score', 90])
    ]),
    then: 1,
    else: 0
  })),
  fail_count: $.sum($.cond({
    if: $.lt(['$score', 60]),
    then: 1,
    else: 0
  }))
}
```

## 性能优化建议

### 1. 先过滤再分组

```javascript
// 不推荐
let res = await vk.baseDao.getTableData({
  dbName: "订单表",
  groupJson: {...},
  lastWhereJson: {
    payment_amount: _.gt(1000)  // 分组后再过滤
  }
});

// 推荐
let res = await vk.baseDao.getTableData({
  dbName: "订单表",
  whereJson: {
    _add_time: _.gte("2024-01-01")  // 先在主表过滤
  },
  groupJson: {...}
});
```

### 2. 为分组字段建立索引

```javascript
// 为user_id字段建立索引
db.collection('订单表').createIndex({
  user_id: 1
});
```

### 3. 限制分组数量

```javascript
let res = await vk.baseDao.getTableData({
  dbName: "订单表",
  pageIndex: 1,
  pageSize: 100,  // 限制返回的分组数量
  groupJson: {...}
});
```

### 4. 避免使用lastWhereJson

数据量大时,lastWhereJson有严重的性能问题。

## 常见问题

### 1. 分组后如何显示其他字段?

使用 `$.first()` 函数:

```javascript
groupJson: {
  _id: "$user_id",
  nickname: $.first("$nickname"),  // 显示该组第一条记录的nickname
  mobile: $.first("$mobile")
}
```

### 2. 如何实现多字段分组?

在_id中使用对象:

```javascript
groupJson: {
  _id: {
    field1: "$field1",
    field2: "$field2"
  }
}
```

### 3. 分组查询的性能如何?

取决于:
- 分组后的数据量
- 是否使用了lastWhereJson
- 索引是否合理

建议:
- 先在whereJson中过滤数据
- 为分组字段建立索引
- 避免使用lastWhereJson
- 限制返回的分组数量

### 4. 如何实现HAVING功能?

使用lastWhereJson:

```javascript
let res = await vk.baseDao.getTableData({
  dbName: "订单表",
  groupJson: {
    _id: "$user_id",
    total_amount: $.sum("$amount")
  },
  lastWhereJson: {
    total_amount: _.gt(1000)  // HAVING total_amount > 1000
  }
});
```

**注意**: lastWhereJson在数据量大时有性能问题。
