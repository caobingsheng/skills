# 常见问题解答

## and / or 条件

### 针对同一个字段的and和or

```javascript
// num >=0 and num <= 10
num: _.gte(0).lte(10)
num: _.gte(0).and(_.lte(10))
num: _.and(_.gte(0), _.lte(10))

// num <=0 or num >= 10
num: _.or(_.lte(0), _.gte(10))
num: _.lte(0).or(_.gte(10))

// num <=0 or (num > 10 and num <20)
num: _.lte(0).or(_.gt(10).and(_.lt(20)))
```

### 跨字段的and和or

```javascript
// num >50 and name = 'test'
whereJson: _.and([
  { num: _.gt(50) },
  { name: 'test' }
])

// num >50 or name = 'test'
whereJson: _.or([
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
_id: _.in(["1", "2", "3"])

// _id != "1" and _id != "2" and _id != "3"
_id: _.nin(["1", "2", "3"])

// num != 1
num: _.neq(1)
```

## 大于小于

```javascript
// num > 0
num: _.gt(0)

// num >= 0
num: _.gte(0)

// num < 0
num: _.lt(0)

// num <= 0
num: _.lte(0)

// num >=0 and num <= 10
num: _.gte(0).lte(10)
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
      { "mobile": regExp },
      { "_id": searchvalue }
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

## 模糊查询

```javascript
// 以xxxx开头
nickname: new RegExp('^' + searchvalue)

// 以xxxx结尾
nickname: new RegExp(searchvalue + '$')

// 包含xxxx
nickname: new RegExp(searchvalue)

// 包含 xxxx 或 yyyy
nickname: new RegExp(`xxxx|yyyy`)
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
  role: roleId // role在数据库中是数组，如["roleid1","roleid2"]
}
```

## 字段比较（a等于b）

```javascript
whereJson: _.expr($.and([
  $.eq(['$a', '$b'])
]))
```

## 字段自增

```javascript
let newInfo = await vk.baseDao.updateAndReturn({
  dbName: "vk-test",
  whereJson: { _id: _id },
  dataJson: { money: _.inc(1) }
});
console.log("自增后的值：", newInfo.money);
```

## 删除字段

```javascript
await vk.baseDao.update({
  dbName: "vk-test",
  whereJson: { _id: "xxx" },
  dataJson: { money: _.remove() }
});
```

## 字段重命名

```javascript
await vk.baseDao.update({
  dbName: "vk-test",
  dataJson: { money: _.rename('money2') }
});
```

## 排序

```javascript
// 升序
sortArr: [{ name: "register_date", type: "asc" }]

// 降序
sortArr: [{ name: "register_date", type: "desc" }]

// 多个排序条件
sortArr: [
  { name: "register_date", type: "desc" },
  { name: "_id", type: "desc" }
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

## 数组时间范围判断

```javascript
let time = Date.now();
let selectRes = await vk.baseDao.select({
  dbName: "表名",
  pageIndex: 1,
  pageSize: 20,
  whereJson: {
    "arr.0": _.lte(time), // 第一个元素是开始时间
    "arr.1": _.gte(time)  // 第二个元素是结束时间
  }
});
```

## 返回字段别名

```javascript
let selectRes = await vk.baseDao.selects({
  dbName: "uni-id-users",
  pageIndex: 1,
  pageSize: 20,
  fieldJson: {
    user_id: "$_id", // 将_id映射为user_id
    nickname: true
  },
  whereJson: {}
});
```

## 分组count

```javascript
// 本月登录用户数（去重）
let { monthStart, monthEnd } = vk.pubfn.getCommonTime(new Date());
let selectRes = await vk.baseDao.count({
  dbName: "登录日志表",
  whereJson: {
    _add_time: _.gte(monthStart).lte(monthEnd)
  },
  groupJson: {
    _id: "$user_id"
  }
});

// 每个日期登录用户数量
let selectRes = await vk.baseDao.selects({
  dbName: "登录日志表",
  pageIndex: 1,
  pageSize: 10,
  whereJson: {},
  groupJson: {
    _id: "$date_str",
    count: $.addToSet("$user_id")
  },
  sortArr: [{ name: "_id", type: "desc" }],
  addFields: {
    count: $.size("$count")
  }
});
```

## 按日期分组统计

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

### 日期格式说明符

**常用**

| 说明符 | 描述 | 合法值 |
|--------|------|--------|
| %Y | 年份（4位数） | 0000 - 9999 |
| %m | 月份（2位数） | 01 - 12 |
| %d | 日期（2位数） | 01 - 31 |
| %H | 小时（24小时制） | 00 - 23 |
| %M | 分钟 | 00 - 59 |
| %S | 秒 | 00 - 60 |
| %L | 毫秒 | 000 - 999 |
| %w | 星期几 | 1 - 7 |
| %j | 一年中的一天 | 001 - 366 |
| %U | 一年中的一周 | 00 - 53 |

## findById如何连表

`findById` 和 `findByWhereJson` 不支持连表，可以用 `selects + getOne + getMain` 代替：

```javascript
let info = await vk.baseDao.selects({
  dbName: "用户表",
  getOne: true,
  getMain: true,
  whereJson: { _id: "001" },
  foreignDB: [
    {
      dbName: "vip",
      localKey: "vip_id",
      foreignKey: "user_id",
      as: "vipInfo",
      limit: 1
    }
  ]
});
```

## 如何实现自增id

```javascript
// 先创建id-inc表并添加一条数据
let newInfo = await vk.baseDao.updateAndReturn({
  dbName: "id-inc",
  whereJson: { _id: "001" },
  dataJson: { "my-orders": _.inc(1) }
});
let newId = newInfo['my-orders'];

await vk.baseDao.add({
  dbName: "my-orders",
  dataJson: {
    id: newId, // 使用自增id
    // ...其他字段
  }
});
```

## 性能优化建议

1. **getCount**: 大表查询时设置 `getCount: false` 避免count请求性能问题
2. **索引优化**: 为常用查询字段建立索引
3. **限制查询范围**: 使用whereJson先过滤数据
4. **避免lastWhereJson**: 数据量大时有严重性能问题
5. **分页限制**: pageIndex * pageSize 最好不要超过300万
6. **count性能**: 带条件的count请求，匹配记录越多性能越差
