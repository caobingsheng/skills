# API完整参考

## 新增操作

### vk.baseDao.add

**功能**：单条记录增加

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| dbName | String | 是 | 表名 |
| dataJson | Object | 是 | 需要添加的数据 |
| cancelAddTime | Boolean | 否 | 取消自动生成 `_add_time` 和 `_add_time_str` 字段 |
| cancelAddTimeStr | Boolean | 否 | 取消自动生成 `_add_time_str` 字段 |
| db | DB | 否 | 指定数据库实例 |

**返回值**：返回值为添加数据的`_id`，添加失败则返回null

**示例**
```javascript
let id = await vk.baseDao.add({
  dbName: "vk-test",
  dataJson: {
    money: Math.floor(Math.random() * 9 + 1)
  }
});
```

---

### vk.baseDao.adds

**功能**：批量增加

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| dbName | String | 是 | 表名 |
| dataJson | Array | 是 | 需要批量添加的数据 |
| needReturnIds | Boolean | 否 | 是否需要返回ids数组 |
| cancelAddTime | Boolean | 否 | 取消自动生成时间字段 |
| db | DB | 否 | 指定数据库实例 |

**返回值**：返回值为添加数据的`_id`数组，添加失败则返回null

**示例**
```javascript
let ids = await vk.baseDao.adds({
  dbName: "vk-test",
  dataJson: [
    { money: 10 },
    { money: 20 }
  ],
  needReturnIds: true
});
```

---

## 删除操作

### vk.baseDao.del

**功能**：批量删除

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| dbName | String | 是 | 表名 |
| whereJson | Object | 是 | where 条件 |
| db | DB | 否 | 指定数据库实例 |

**返回值**：返回值是删除的记录数量

**示例**
```javascript
let num = await vk.baseDao.del({
  dbName: "vk-test",
  whereJson: {
    money: 1
  }
});
```

---

### vk.baseDao.deleteById

**功能**：根据ID删除数据

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| dbName | String | 是 | 表名 |
| id | String | 是 | 记录的`_id` |
| db | DB | 否 | 指定数据库实例 |

**返回值**：返回值是删除的记录数量

**示例**
```javascript
let num = await vk.baseDao.deleteById({
  dbName: "vk-test",
  id: "5f3a125b3d11c6000106d338"
});
```

---

## 修改操作

### vk.baseDao.update

**功能**：批量修改

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| dbName | String | 是 | 表名 |
| whereJson | Object | 是 | where 条件 |
| dataJson | Object | 是 | 需要修改的数据 |
| db | DB | 否 | 指定数据库实例 |

**返回值**：返回值是受影响的行数

**示例**
```javascript
let num = await vk.baseDao.update({
  dbName: "vk-test",
  whereJson: {
    _id: "5f3a14823d11c6000106ff5c",
    money: _.gte(100)
  },
  dataJson: {
    money: _.inc(-100)
  }
});
```

---

### vk.baseDao.updateById

**功能**：根据ID修改数据

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| dbName | String | 是 | 表名 |
| id | String | 是 | 记录的`_id` |
| dataJson | Object | 是 | 需要修改的数据 |
| getUpdateData | Boolean | 否 | 是否返回修改后的数据 |
| db | DB | 否 | 指定数据库实例 |

**返回值**：默认返回值是受影响的行数，`getUpdateData:true`时返回修改后的数据对象

**示例**
```javascript
let newInfo = await vk.baseDao.updateById({
  dbName: "vk-test",
  id: _id,
  dataJson: {
    money: 1
  },
  getUpdateData: true
});
```

---

### vk.baseDao.updateAndReturn

**功能**：更新并返回更新后的数据（原子操作）

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| dbName | String | 是 | 表名 |
| whereJson | Object | 是 | where 条件 |
| dataJson | Object | 是 | 需要修改的数据 |
| db | DB | 否 | 指定数据库实例 |

**返回值**：默认返回值是修改后的数据对象

**示例**
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

---

### vk.baseDao.setById

**功能**：根据ID判断存在则替换，不存在则添加

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| dbName | String | 是 | 表名 |
| dataJson | Object | 是 | 需要替换或新增的完整数据（必须包含`_id`） |
| id | String | 否 | 如果传了id参数，则会与dataJson中的`_id`判断是否一致 |
| db | DB | 否 | 指定数据库实例 |

**返回值**

| 参数名 | 类型 | 说明 |
|--------|------|------|
| type | String | add添加 / update修改 |
| id | String | 若type=add，则返回新增的id |

**示例**
```javascript
let setRes = await vk.baseDao.setById({
  dbName: "vk-test",
  dataJson: {
    _id: "666",
    money: 1
  }
});
```

---

## 查询操作

### vk.baseDao.findById

**功能**：根据id获取单条记录

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| dbName | String | 是 | 表名 |
| id | String | 是 | 记录的`_id` |
| fieldJson | Object | 否 | 字段显示规则 |
| db | DB | 否 | 指定数据库实例 |

**返回值**：返回值是该条记录数据

**示例**
```javascript
let info = await vk.baseDao.findById({
  dbName: "vk-test",
  id: "5f3a125b3d11c6000106d338"
});
```

---

### vk.baseDao.findByWhereJson

**功能**：根据条件获取单条记录

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| dbName | String | 是 | 表名 |
| whereJson | Object | 是 | where 条件 |
| fieldJson | Object | 否 | 字段显示规则 |
| sortArr | Array | 否 | 排序规则 |
| db | DB | 否 | 指定数据库实例 |

**返回值**：返回值是该条记录数据（只返回第一条数据的内容）

**示例**
```javascript
let info = await vk.baseDao.findByWhereJson({
  dbName: "vk-test",
  whereJson: {
    _id: "5f3a125b3d11c6000106d338",
  }
});
```

---

### vk.baseDao.select

**功能**：查多条记录（具有分页功能）

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| dbName | String | 是 | 表名 |
| getCount | Boolean | 否 | 是否返回满足条件的记录总数，默认false |
| hasMore | Boolean | 否 | 是否返回精确的是否还有下一页，默认false |
| getMain | Boolean | 否 | 是否只返回rows数组，默认false |
| getOne | Boolean | 否 | 是否只返回第一条数据，默认false |
| pageIndex | Number | 否 | 第几页，默认1 |
| pageSize | Number | 否 | 每页显示数量，默认10 |
| whereJson | Object | 否 | where 条件 |
| fieldJson | Object | 否 | 字段显示规则 |
| sortArr | Array | 否 | 排序规则 |
| db | DB | 否 | 指定数据库实例 |
| debug | Boolean | 否 | 是否返回调试参数，默认false |

**返回值**

| 参数名 | 类型 | 说明 |
|--------|------|------|
| rows | Array | 数据列表，没有数据时返回空数组 |
| total | Number | 满足条件的记录总数 |
| hasMore | Boolean | 是否还有下一页 |
| pagination | Object | 当前分页参数 |
| getCount | Boolean | 是否有执行过getCount |

**pagination对象属性**

| 参数名 | 类型 | 说明 |
|--------|------|------|
| pageIndex | Number | 当前分页的页码 |
| pageSize | Number | 每页显示的大小 |

**示例**
```javascript
let res = await vk.baseDao.select({
  dbName: "vk-test",
  getCount: false,
  pageIndex: 1,
  pageSize: 20,
  whereJson: {
    money: _.gte(0)
  },
  fieldJson: {
    _id: true,
    money: true
  },
  sortArr: [
    { name: "_id", type: "desc" }
  ]
});
```

---

### vk.baseDao.selects

**功能**：万能连表查询

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| dbName | String | 是 | 主表表名 |
| whereJson | Object | 否 | 主表 where 条件 |
| pageIndex | Number | 否 | 第几页，默认1 |
| pageSize | Number | 否 | 每页显示数量，默认10 |
| getCount | Boolean | 否 | 是否返回满足条件的记录总数，默认false |
| hasMore | Boolean | 否 | 是否返回精确的是否还有下一页，默认false |
| getOne | Boolean | 否 | 是否只返回第一条数据，默认false |
| getMain | Boolean | 否 | 是否只返回rows数组，默认false |
| groupJson | Object | 否 | 主表分组规则 |
| sortArr | Array | 否 | 主表排序规则 |
| foreignDB | Array | 否 | 连表规则 |
| lastWhereJson | Object | 否 | 连表后的查询条件 |
| lastSortArr | Array | 否 | 连表后的排序条件 |
| addFields | Object | 否 | 添加自定义字段规则 |
| fieldJson | Object | 否 | 字段显示规则 |
| db | DB | 否 | 指定数据库实例 |
| debug | Boolean | 否 | 是否返回调试参数，默认false |

**返回值**：同select

---

### vk.baseDao.count

**功能**：获取记录总条数

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| dbName | String | 是 | 表名 |
| whereJson | Object | 否 | where 条件 |
| foreignDB | Array | 否 | 连表规则 |
| groupJson | Object | 否 | 分组规则 |
| lastWhereJson | Object | 否 | 连表后的where条件 |
| db | DB | 否 | 指定数据库实例 |

**返回值**：返回值是满足条件的记录总数

**示例**
```javascript
let num = await vk.baseDao.count({
  dbName: "vk-test",
  whereJson: {
    status: 1
  }
});
```

---

### vk.baseDao.sum

**功能**：求和

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| dbName | String | 是 | 表名 |
| fieldName | String | 是 | 求和的字段名 |
| whereJson | Object | 否 | where 条件 |
| db | DB | 否 | 指定数据库实例 |

**返回值**：返回值是求和的值

**示例**
```javascript
let sum = await vk.baseDao.sum({
  dbName: "vk-test",
  fieldName: "money",
  whereJson: {}
});
```

---

### vk.baseDao.max

**功能**：取最大值

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| dbName | String | 是 | 表名 |
| fieldName | String | 是 | 求最大值的字段名 |
| whereJson | Object | 否 | where 条件 |
| db | DB | 否 | 指定数据库实例 |

**返回值**：返回值是最大值

---

### vk.baseDao.min

**功能**：取最小值

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| dbName | String | 是 | 表名 |
| fieldName | String | 是 | 求最小值的字段名 |
| whereJson | Object | 否 | where 条件 |
| db | DB | 否 | 指定数据库实例 |

**返回值**：返回值是最小值

---

### vk.baseDao.avg

**功能**：取平均值

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| dbName | String | 是 | 表名 |
| fieldName | String | 是 | 求平均值的字段名 |
| whereJson | Object | 否 | where 条件 |
| db | DB | 否 | 指定数据库实例 |

**返回值**：返回值是平均值

---

### vk.baseDao.sample

**功能**：随机取N条数据

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| dbName | String | 是 | 表名 |
| size | Number | 是 | 随机获取的记录数量 |
| whereJson | Object | 否 | where 条件 |
| fieldJson | Object | 否 | 字段显示规则 |
| db | DB | 否 | 指定数据库实例 |

**返回值**：返回值是随机获取的记录数组

**示例**
```javascript
let list = await vk.baseDao.sample({
  dbName: "vk-test",
  size: 1,
  whereJson: {}
});
```

---

## 事务操作

### vk.baseDao.startTransaction

**功能**：开启事务

**返回值**：事务对象

---

### vk.baseDao.rollbackTransaction

**功能**：回滚事务

**请求参数**

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| db | Object | 是 | 事务对象 |
| err | Object | 否 | 错误信息 |

---

## 扩展数据库

### 切换数据库实例

```javascript
const newDb = uniCloud.database({
  id: "数据库实例ID"
});
```

### 切换数据库

```javascript
const newDb = uniCloud.database({
  database: "数据库实例下的数据库名称"
});
```

### 同时切换实例和库

```javascript
const newDb = uniCloud.database({
  id: "数据库实例ID",
  database: "数据库名称"
});
```
