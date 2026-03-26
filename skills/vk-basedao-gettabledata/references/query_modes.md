# 查询模式详解

vk.baseDao.getTableData 通过 `data.columns` 中的 `mode` 参数来定义查询模式。

## mode 参数列表

| mode值 | 说明 | 示例 |
|--------|------|------|
| = | 完全匹配 | nickname = "张三" |
| != | 不等于 | status != 1 |
| %% | 模糊匹配 | nickname LIKE "%张三%" |
| %* | 以xxx开头 | nickname LIKE "张三%" |
| *% | 以xxx结尾 | nickname LIKE "%张三" |
| > | 大于 | age > 18 |
| >= | 大于等于 | age >= 18 |
| < | 小于 | age < 60 |
| <= | 小于等于 | age <= 60 |
| in | 在数组里 | status IN [1, 2, 3] |
| nin | 不在数组里 | status NOT IN [0, -1] |
| [] | 范围 arr[0] <= x <= arr[1] | price BETWEEN 100 AND 200 |
| [) | 范围 arr[0] <= x < arr[1] | price >= 100 AND price < 200 |
| (] | 范围 arr[0] < x <= arr[1] | price > 100 AND price <= 200 |
| () | 范围 arr[0] < x < arr[1] | price > 100 AND price < 200 |
| custom | 声明此字段不自动参与where条件 | - |

## 基础查询模式

### 1. 完全匹配 (=)

```javascript
data: {
  formData: {
    status: 1
  },
  columns: [
    { key: "status", title: "状态", type: "radio", mode: "=" }
  ]
}
```

生成的查询条件:
```javascript
whereJson: {
  status: 1
}
```

### 2. 不等于 (!=)

```javascript
data: {
  formData: {
    status: 0
  },
  columns: [
    { key: "status", title: "状态", type: "radio", mode: "!=" }
  ]
}
```

生成的查询条件:
```javascript
whereJson: {
  status: _.neq(0)
}
```

### 3. 模糊匹配 (%%)

```javascript
data: {
  formData: {
    nickname: "张三"
  },
  columns: [
    { key: "nickname", title: "昵称", type: "text", mode: "%%" }
  ]
}
```

生成的查询条件:
```javascript
whereJson: {
  nickname: new RegExp("张三")
}
```

### 4. 以xxx开头 (%*)

```javascript
data: {
  formData: {
    mobile: "138"
  },
  columns: [
    { key: "mobile", title: "手机号", type: "text", mode: "%*" }
  ]
}
```

生成的查询条件:
```javascript
whereJson: {
  mobile: new RegExp("^138")
}
```

### 5. 以xxx结尾 (*%)

```javascript
data: {
  formData: {
    email: "@qq.com"
  },
  columns: [
    { key: "email", title: "邮箱", type: "text", mode: "*%" }
  ]
}
```

生成的查询条件:
```javascript
whereJson: {
  email: new RegExp("@qq.com$")
}
```

## 比较查询模式

### 6. 大于 (>)

```javascript
data: {
  formData: {
    age: 18
  },
  columns: [
    { key: "age", title: "年龄", type: "number", mode: ">" }
  ]
}
```

生成的查询条件:
```javascript
whereJson: {
  age: _.gt(18)
}
```

### 7. 大于等于 (>=)

```javascript
data: {
  formData: {
    balance: 100
  },
  columns: [
    { key: "balance", title: "余额", type: "number", mode: ">=" }
  ]
}
```

生成的查询条件:
```javascript
whereJson: {
  balance: _.gte(100)
}
```

### 8. 小于 (<)

```javascript
data: {
  formData: {
    age: 60
  },
  columns: [
    { key: "age", title: "年龄", type: "number", mode: "<" }
  ]
}
```

生成的查询条件:
```javascript
whereJson: {
  age: _.lt(60)
}
```

### 9. 小于等于 (<=)

```javascript
data: {
  formData: {
    price: 1000
  },
  columns: [
    { key: "price", title: "价格", type: "number", mode: "<=" }
  ]
}
```

生成的查询条件:
```javascript
whereJson: {
  price: _.lte(1000)
}
```

## 数组查询模式

### 10. 在数组里 (in)

```javascript
data: {
  formData: {
    status: [1, 2, 3]
  },
  columns: [
    { key: "status", title: "状态", type: "checkbox", mode: "in" }
  ]
}
```

生成的查询条件:
```javascript
whereJson: {
  status: _.in([1, 2, 3])
}
```

### 11. 不在数组里 (nin)

```javascript
data: {
  formData: {
    status: [0, -1]
  },
  columns: [
    { key: "status", title: "状态", type: "checkbox", mode: "nin" }
  ]
}
```

生成的查询条件:
```javascript
whereJson: {
  status: _.nin([0, -1])
}
```

## 范围查询模式

### 12. 闭区间 []

```javascript
data: {
  formData: {
    price: [100, 200]
  },
  columns: [
    { key: "price", title: "价格", type: "text", mode: "[]" }
  ]
}
```

生成的查询条件:
```javascript
whereJson: {
  price: _.gte(100).lte(200)
}
```

### 13. 左闭右开 [)

```javascript
data: {
  formData: {
    price: [100, 200]
  },
  columns: [
    { key: "price", title: "价格", type: "text", mode: "[)" }
  ]
}
```

生成的查询条件:
```javascript
whereJson: {
  price: _.gte(100).lt(200)
}
```

### 14. 左开右闭 (]

```javascript
data: {
  formData: {
    price: [100, 200]
  },
  columns: [
    { key: "price", title: "价格", type: "text", mode: "(]" }
  ]
}
```

生成的查询条件:
```javascript
whereJson: {
  price: _.gt(100).lte(200)
}
```

### 15. 开区间 ()

```javascript
data: {
  formData: {
    price: [100, 200]
  },
  columns: [
    { key: "price", title: "价格", type: "text", mode: "()" }
  ]
}
```

生成的查询条件:
```javascript
whereJson: {
  price: _.gt(100).lt(200)
}
```

## 日期时间范围查询

### 日期时间范围

```javascript
data: {
  formData: {
    createTime: ["2024-01-01 00:00:00", "2024-12-31 23:59:59"]
  },
  columns: [
    {
      key: "createTime",
      title: "创建时间",
      type: "datetimerange",
      mode: "[]"
    }
  ]
}
```

生成的查询条件:
```javascript
whereJson: {
  createTime: _.gte("2024-01-01 00:00:00").lte("2024-12-31 23:59:59")
}
```

### 日期范围

```javascript
data: {
  formData: {
    createDate: ["2024-01-01", "2024-12-31"]
  },
  columns: [
    {
      key: "createDate",
      title: "创建日期",
      type: "daterange",
      mode: "[]"
    }
  ]
}
```

## 金额范围查询

### 金额范围(使用两个字段)

```javascript
data: {
  formData: {
    balance1: 100,  // 最小金额
    balance2: 1000  // 最大金额
  },
  columns: [
    {
      key: "balance1",
      title: "最小金额",
      type: "money",
      mode: ">=",
      fieldName: "balance"
    },
    {
      key: "balance2",
      title: "最大金额",
      type: "money",
      mode: "<=",
      fieldName: "balance"
    }
  ]
}
```

生成的查询条件:
```javascript
whereJson: {
  balance: _.gte(100).lte(1000)
}
```

## 自定义查询模式

### custom 模式

声明此字段不自动参与where条件,可以在云函数中手动处理。

```javascript
data: {
  formData: {
    customField: "value"
  },
  columns: [
    {
      key: "customField",
      title: "自定义字段",
      type: "text",
      mode: "custom"
    }
  ]
}
```

## fieldName 参数

### 作用

指定数据库字段名,默认等于key的值。

### 使用场景

1. **连表查询时指定副表字段**

```javascript
columns: [
  {
    key: "mobile",
    title: "手机号",
    type: "text",
    mode: "=",
    fieldName: "userInfo.mobile",  // 指定副表字段
    lastWhereJson: true            // 标记为连表后的条件
  }
]
```

2. **字段名与显示名不同**

```javascript
columns: [
  {
    key: "userName",        // 前端使用的字段名
    title: "用户名",
    type: "text",
    mode: "%%",
    fieldName: "user_name"  // 数据库实际字段名
  }
]
```

## lastWhereJson 参数

### 作用

标记该字段是连表后的where条件。

### 使用场景

连表查询时,需要根据副表字段进行筛选。

```javascript
data: {
  formData: {
    mobile: "138"
  },
  columns: [
    {
      key: "mobile",
      title: "手机号",
      type: "text",
      mode: "=",
      fieldName: "userInfo.mobile",
      lastWhereJson: true  // 标记为连表后的条件
    }
  ]
}
```

生成的查询条件:
```javascript
lastWhereJson: {
  "userInfo.mobile": "138"
}
```

**注意**: lastWhereJson在数据量大的情况下有性能问题,慎用。

## 组合查询

### 多条件AND查询

```javascript
data: {
  formData: {
    nickname: "张三",
    status: 1,
    age: 25
  },
  columns: [
    { key: "nickname", title: "昵称", type: "text", mode: "%%" },
    { key: "status", title: "状态", type: "radio", mode: "=" },
    { key: "age", title: "年龄", type: "number", mode: ">=" }
  ]
}
```

生成的查询条件:
```javascript
whereJson: {
  nickname: new RegExp("张三"),
  status: 1,
  age: _.gte(25)
}
```

### 多条件OR查询

需要在云函数中手动处理,使用 `_.or()`:

```javascript
let res = await vk.baseDao.getTableData({
  dbName: "表名",
  data: data,
  whereJson: {
    $or: [
      { nickname: new RegExp("张三") },
      { mobile: new RegExp("138") }
    ]
  }
});
```

## 特殊值查询

### 空数组查询

```javascript
data: {
  formData: {
    roleList: "___empty-array___"
  },
  columns: [
    { key: "roleList", title: "角色列表", type: "text", mode: "=" }
  ]
}
```

### 空对象查询

```javascript
data: {
  formData: {
    userInfo: "___empty-object___"
  },
  columns: [
    { key: "userInfo", title: "用户信息", type: "text", mode: "=" }
  ]
}
```

### 字段不存在查询

```javascript
data: {
  formData: {
    deleteTime: "___non-existent___"
  },
  columns: [
    { key: "deleteTime", title: "删除时间", type: "text", mode: "=" }
  ]
}
```

### 字段存在查询

```javascript
data: {
  formData: {
    avatar: "___existent___"
  },
  columns: [
    { key: "avatar", title: "头像", type: "text", mode: "=" }
  ]
}
```

**注意**: 左右各3个下划线
