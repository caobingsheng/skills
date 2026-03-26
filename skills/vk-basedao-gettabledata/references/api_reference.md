# vk.baseDao.getTableData API 完整参考

## 方法签名

```javascript
await vk.baseDao.getTableData({
  dbName: String,
  data: Object,
  whereJson: Object,
  fieldJson: Object,
  sortArr: Array,
  foreignDB: Array,
  lastWhereJson: Object,
  lastSortArr: Array,
  addFields: Object,
  getCount: Boolean,
  hasMore: Boolean,
  debug: Boolean
})
```

## 参数详解

### 1. dbName (String, 必填)

主表表名

```javascript
dbName: "uni-id-users"
```

### 2. data (Object, 必填)

查询参数对象,包含前端传递的查询条件和排序规则

#### data.pageIndex (Number)

第几页,默认1

```javascript
data: {
  pageIndex: 1
}
```

#### data.pageSize (Number)

每页显示数量,默认10

```javascript
data: {
  pageSize: 20
}
```

#### data.formData (Object)

查询条件数据源

```javascript
data: {
  formData: {
    nickname: "张三",
    status: 1,
    createTime: ["2024-01-01", "2024-12-31"]
  }
}
```

#### data.columns (Array)

查询条件字段规则,定义每个字段的查询模式

```javascript
data: {
  columns: [
    {
      key: "nickname",      // 字段名
      title: "昵称",        // 标题
      type: "text",         // 类型
      width: 160,           // 宽度
      mode: "%%",           // 查询模式
      fieldName: "nickname", // 数据库字段名,默认等于key
      lastWhereJson: false  // 是否是连表后的where条件
    }
  ]
}
```

##### columns参数说明

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| key | String | 是 | 字段名 |
| title | String | 是 | 标题 |
| type | String | 否 | 组件类型 |
| width | Number | 否 | 宽度 |
| mode | String | 否 | 查询模式,默认"=" |
| fieldName | String | 否 | 数据库字段名,默认等于key |
| lastWhereJson | Boolean | 否 | 是否是连表后的where条件,默认false |

#### data.sortRule (Array)

排序规则

```javascript
data: {
  sortRule: [
    { name: "_add_time", type: "desc" },
    { name: "status", type: "asc" }
  ]
}
```

##### sortRule参数说明

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| name | String | 是 | 排序字段名 |
| type | String | 是 | 排序类型: asc(升序) 或 desc(降序) |

### 3. whereJson (Object, 可选)

主表强制where条件,用于设置必须满足的查询条件(如用户权限过滤)

```javascript
whereJson: {
  user_id: uid,
  status: 1
}
```

### 4. fieldJson (Object, 可选)

字段显示规则,控制只显示哪些字段或不显示哪些字段

```javascript
fieldJson: {
  token: false,      // 不显示token字段
  password: false,   // 不显示password字段
  nickname: true     // 显示nickname字段
}
```

### 5. sortArr (Array, 可选)

主表默认排序规则

```javascript
sortArr: [
  { name: "_add_time", type: "desc" }
]
```

### 6. foreignDB (Array, 可选)

连表规则数组,支持多表关联查询

```javascript
foreignDB: [
  {
    dbName: "uni-id-users",     // 副表名
    localKey: "user_id",        // 主表外键
    foreignKey: "_id",          // 副表外键
    as: "userInfo",             // 副表别名
    limit: 1,                   // 限制数量,1=对象形式,>1=数组形式
    whereJson: {},              // 副表where条件
    sortArr: [],                // 副表排序规则
    fieldJson: {},              // 副表字段显示规则
    foreignDB: []               // 副表的副表(支持嵌套)
  }
]
```

#### foreignDB参数说明

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| dbName | String | 是 | 副表表名 |
| localKey | String | 是 | 主表外键字段名 |
| foreignKey | String | 是 | 副表外键字段名 |
| as | String | 是 | 副表结果别名 |
| limit | Number | 否 | 限制数量,1=对象,>1=数组 |
| localKeyType | String | 否 | 主表外键类型: array或默认 |
| foreignKeyType | String | 否 | 副表外键类型: array或默认 |
| whereJson | Object | 否 | 副表where条件 |
| sortArr | Array | 否 | 副表排序规则 |
| fieldJson | Object | 否 | 副表字段显示规则 |
| foreignDB | Array | 否 | 副表的副表(嵌套连表) |

### 7. lastWhereJson (Object, 可选)

连表后的where条件,对连表或分组后的结果进行筛选

**注意**: 数据量大时有性能问题,慎用

```javascript
lastWhereJson: {
  "userInfo.gender": 2,
  "payment_amount": _.gt(1000)
}
```

### 8. lastSortArr (Array, 可选)

连表后的排序条件,通过副表字段排序

**注意**: 数据量大时有性能问题,慎用

```javascript
lastSortArr: [
  { name: "userInfo._add_time", type: "desc" }
]
```

### 9. addFields (Object, 可选)

添加自定义字段规则,用于添加虚拟字段

```javascript
addFields: {
  a: "$userInfo.a",      // 将副表的a字段赋值给主表的a字段
  b: "$userInfo.b"       // 将副表的b字段赋值给主表的b字段
}
```

### 10. getCount (Boolean, 可选)

是否返回满足条件的记录总数

- 默认值: true (getTableData), false (selects)
- 设置为true会多一次count请求
- 大表查询时建议设置为false

```javascript
getCount: false
```

### 11. hasMore (Boolean, 可选)

是否返回精确的hasMore值

- 默认值: false
- 设置为true会多查一条数据来判断是否还有下一页
- 若getCount为true,则忽略此参数

```javascript
hasMore: true
```

### 12. debug (Boolean, 可选)

是否返回调试信息

- 默认值: false
- 设置为true会返回数据库执行耗时(单位ms)

```javascript
debug: true
```

## 返回值结构

```javascript
{
  rows: [],           // Array: 数据列表
  total: 0,           // Number: 总记录数
  hasMore: false,     // Boolean: 是否还有下一页
  pagination: {       // Object: 当前分页参数
    pageIndex: 1,     // Number: 当前页码
    pageSize: 20      // Number: 每页大小
  },
  getCount: true      // Boolean: 是否执行了count请求
}
```

### 返回值说明

| 字段 | 类型 | 说明 |
|------|------|------|
| rows | Array | 数据列表,没有数据时返回空数组 |
| total | Number | 满足条件的记录总数。若getCount为false,则total = (pageIndex-1) * pageSize + rows.length |
| hasMore | Boolean | 是否还有下一页 |
| pagination | Object | 当前分页参数 |
| pagination.pageIndex | Number | 当前页码 |
| pagination.pageSize | Number | 每页大小 |
| getCount | Boolean | 是否执行了count请求 |

## 特殊值说明

### formData中的特殊值

| 值 | 说明 |
|---|---|
| `___empty-array___` | 匹配空数组 |
| `___empty-object___` | 匹配空对象 |
| `___non-existent___` | 字段不存在 |
| `___existent___` | 字段存在 |

**注意**: 左右各3个下划线

```javascript
formData: {
  roleList: "___empty-array___"  // 查询roleList为空数组的记录
}
```

## 完整示例

```javascript
let res = await vk.baseDao.getTableData({
  dbName: "opendb-mall-comments",
  data: {
    pageIndex: 1,
    pageSize: 20,
    formData: {
      content: "好评",
      _add_time: ["2024-01-01", "2024-12-31"]
    },
    columns: [
      { key: "content", title: "内容", type: "text", mode: "%%" },
      { key: "_add_time", title: "时间", type: "datetimerange", mode: "[]" }
    ],
    sortRule: [
      { name: "_add_time", type: "desc" }
    ]
  },
  whereJson: {
    status: 1
  },
  fieldJson: {
    _id: true,
    content: true,
    _add_time: true
  },
  sortArr: [
    { name: "_add_time", type: "desc" }
  ],
  foreignDB: [
    {
      dbName: "uni-id-users",
      localKey: "user_id",
      foreignKey: "_id",
      as: "userInfo",
      limit: 1,
      fieldJson: {
        nickname: true,
        avatar: true
      }
    }
  ],
  getCount: true,
  hasMore: true
});

console.log(res.rows);      // 数据列表
console.log(res.total);     // 总记录数
console.log(res.hasMore);   // 是否还有下一页
```
