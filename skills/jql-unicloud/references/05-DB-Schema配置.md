# DB Schema 配置完整指南

本文档详细说明 DB Schema 的配置方法，包括权限配置、关联配置、数据校验规则、默认值等。

## 目录

- [permission 权限配置](#permission-权限配置)
- [foreignKey 关联配置](#foreignkey-关联配置)
- [数据校验规则](#数据校验规则)
- [默认值配置](#默认值配置)
- [完整 Schema 示例](#完整-schema-示例)

---

## permission 权限配置

### 表级权限

```javascript
// database/user.schema.json
{
  "bsonType": "object",
  "permission": {
    "read": "doc.uid == auth.uid",     // 只能读自己的数据
    "create": false,                   // 禁止新增
    "update": "doc.uid == auth.uid",   // 只能改自己的数据
    "delete": false,                   // 禁止删除
    "count": false                     // 禁止计数
  }
}
```

### 权限表达式说明

- `doc.uid == auth.uid`: 只能操作自己的数据
- `true`: 允许所有人操作
- `false`: 禁止操作
- `doc.status > 1`: 只能操作 status 大于 1 的数据
- `auth.role.indexOf('admin') > -1`: 只有 admin 角色可以操作

### 字段级权限

```javascript
{
  "properties": {
    "password": {
      "bsonType": "string",
      "title": "密码",
      "permission": {
        "read": false,    // 禁止读取密码
        "write": false    // 禁止写入密码
      }
    },
    "mobile": {
      "bsonType": "string",
      "title": "手机号",
      "permission": {
        "read": "auth.uid != null",  // 登录用户可读
        "write": false               // 禁止修改手机号
      }
    },
    "nickname": {
      "bsonType": "string",
      "title": "昵称",
      "permission": {
        "read": true,     // 所有人可读
        "write": true     // 所有人可写
      }
    }
  }
}
```

### 权限校验机制

```javascript
// JQL 会进行两次权限校验
// 1. 预校验: 根据where条件判断是否可能通过权限
// 2. 查库校验: 如果预校验不通过,会查询数据库再校验

// 示例: 可以通过预校验
db.collection('goods').where('status > 1').get()
// schema: "read": "doc.status > 1"
// where 条件包含 status,可以直接判断

// 示例: 需要查库校验
db.collection('goods').where('name == "n3"').get()
// schema: "read": "doc.status > 1"
// where 条件不包含 status,需要查库验证
```

### count 权限控制

```javascript
// 在 HBuilderX 3.1.0 之前,count 操作都会使用表级的 read 权限进行验证
// HBuilderX 3.1.0 及之后的版本,如果配置了 count 权限则会使用表级的 read+count 权限进行校验

{
  "permission": {
    "read": "doc.uid == auth.uid",
    "count": false  // 禁止对本表进行 count 计数
  }
}
```

---

## foreignKey 关联配置

### 基础关联(一对多)

```javascript
// order 表
{
  "properties": {
    "book_id": {
      "bsonType": "string",
      "title": "书籍ID",
      "foreignKey": "book._id"  // 关联到 book 表的 _id
    }
  }
}
```

### 双向关联(多对多)

```javascript
// comment 表
{
  "properties": {
    "article": {
      "bsonType": "string",
      "title": "文章ID",
      "foreignKey": "article.article_id"
    },
    "sender": {
      "bsonType": "string",
      "title": "发送者",
      "foreignKey": "user.uid"
    },
    "receiver": {
      "bsonType": "string",
      "title": "接收者",
      "foreignKey": "user.uid"
    }
  }
}
```

### parentKey 树形关联

```javascript
// department 表
{
  "properties": {
    "parent_id": {
      "bsonType": "string",
      "title": "父级ID",
      "parentKey": "_id"  // 指定父子关系
    }
  }
}
```

---

## 数据校验规则

### 基础校验

```javascript
{
  "properties": {
    "name": {
      "bsonType": "string",
      "title": "姓名",
      "maxLength": 50,           // 最大长度
      "trim": "both"             // 自动去除首尾空格
    },
    "age": {
      "bsonType": "int",
      "title": "年龄",
      "minimum": 0,              // 最小值
      "maximum": 150             // 最大值
    },
    "email": {
      "bsonType": "string",
      "title": "邮箱",
      "format": "email",         // 邮箱格式
      "pattern": "^[\\w-]+(\\.[\\w-]+)*@[\\w-]+(\\.[\\w-]+)+$"
    },
    "mobile": {
      "bsonType": "string",
      "title": "手机号",
      "pattern": "^1[3-9]\\d{9}$"
    }
  }
}
```

### 必填字段

```javascript
{
  "required": ["name", "mobile"],  // 新增数据时必填字段
  "properties": {
    "name": {
      "bsonType": "string",
      "title": "姓名"
    },
    "mobile": {
      "bsonType": "string",
      "title": "手机号"
    },
    "nickname": {
      "bsonType": "string",
      "title": "昵称"
      // 不在 required 中,表示可选
    }
  }
}
```

### 枚举值校验

```javascript
{
  "properties": {
    "status": {
      "bsonType": "int",
      "title": "状态",
      "enum": [0, 1, 2]  // 只能是 0, 1, 2 中的一个
    },
    "gender": {
      "bsonType": "int",
      "title": "性别",
      "enum": [1, 2]  // 1-男, 2-女
    }
  }
}
```

---

## 默认值配置

### defaultValue(可选默认值)

```javascript
{
  "properties": {
    "update_time": {
      "bsonType": "timestamp",
      "title": "更新时间",
      "defaultValue": {
        "$env": "now"  // 如果未传值则使用服务器时间
      }
    },
    "nickname": {
      "bsonType": "string",
      "title": "昵称",
      "defaultValue": "用户"  // 固定默认值
    }
  }
}
```

### forceDefaultValue(强制默认值)

```javascript
{
  "properties": {
    "create_time": {
      "bsonType": "timestamp",
      "title": "创建时间",
      "forceDefaultValue": {
        "$env": "now"  // 强制使用服务器时间,客户端无法覆盖
      }
    },
    "user_id": {
      "bsonType": "string",
      "title": "用户ID",
      "forceDefaultValue": {
        "$env": "uid"  // 强制使用当前用户ID
      }
    }
  }
}
```

### 环境变量说明

- `$env.now`: 服务器当前时间
- `$env.uid`: 当前用户ID
- `$env.clientIP`: 当前客户端IP

---

## 完整 Schema 示例

```javascript
// database/user.schema.json
{
  "bsonType": "object",
  "required": ["name", "mobile"],
  "permission": {
    "read": "doc.uid == auth.uid",
    "create": "doc.uid == auth.uid",
    "update": "doc.uid == auth.uid",
    "delete": false,
    "count": false
  },
  "properties": {
    "_id": {
      "description": "ID,系统自动生成"
    },
    "name": {
      "bsonType": "string",
      "title": "姓名",
      "maxLength": 50,
      "trim": "both"
    },
    "mobile": {
      "bsonType": "string",
      "title": "手机号",
      "pattern": "^1[3-9]\\d{9}$"
    },
    "email": {
      "bsonType": "string",
      "title": "邮箱",
      "format": "email"
    },
    "password": {
      "bsonType": "string",
      "title": "密码",
      "permission": {
        "read": false,
        "write": false
      }
    },
    "status": {
      "bsonType": "int",
      "title": "状态",
      "enum": [0, 1, 2],
      "defaultValue": 1
    },
    "create_time": {
      "bsonType": "timestamp",
      "title": "创建时间",
      "forceDefaultValue": {
        "$env": "now"
      }
    },
    "update_time": {
      "bsonType": "timestamp",
      "title": "更新时间",
      "defaultValue": {
        "$env": "now"
      }
    }
  }
}
```

---

## DB Schema 的作用

DB Schema 是基于 JSON 格式定义的数据结构的规范,具有以下重要作用:

1. **描述数据格式**: 可以一目了然的阅读每个表、每个字段的用途
2. **设定数据操作权限**: 什么样的角色可以读/写哪些数据
3. **设定字段值域规则**: 比如不能为空、需符合指定的正则格式
4. **设置数据的默认值**: 比如服务器当前时间、当前用户id等
5. **设定多个表的字段间映射关系**: 将多个表按一个虚拟联表直接查询
6. **自动生成表单维护界面**: 比如新建页面和编辑页面,自动处理校验规则

---

## 数据库触发器

从 HBuilderX 3.6.11 开始,推荐使用数据库触发器替代 action 云函数。

### 触发器类型

- **before**: 数据操作前触发
- **after**: 数据操作后触发

### 触发器配置

```javascript
// database/user.schema.ext.js
module.exports = {
  // 新增前触发
  beforeAdd: async function({
    clientInfo,
    userInfo,
    addDataList
  }) {
    // addDataList 是数组,包含要新增的数据
    // 可以修改 addDataList 中的数据
    addDataList.forEach(item => {
      item.create_time = Date.now()
    })
  },

  // 新增后触发
  afterAdd: async function({
    clientInfo,
    userInfo,
    addDataList,
    resultIdList
  }) {
    // resultIdList 是新增后的 _id 数组
    // 可以进行后续操作,如发送通知等
  }
}
```

### 注意事项

- 触发器文件名为 `表名.schema.ext.js`
- 触发器在云函数中运行
- 可以使用云函数的所有 API
