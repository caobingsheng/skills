# 扩展数据库

## Overview

vk框架支持扩展数据库，可以连接不同的数据库实例和数据库，无需改动代码，只需添加扩展库的依赖即可。

## 启用扩展数据库

在HBuilderX中右键router云函数 → 添加管理依赖 → 勾选扩展数据库的扩展库即可。

## 相关文档

- [产品介绍](https://doc.dcloud.net.cn/uniCloud/ext-mongodb/intro.html)
- [开通教程](https://doc.dcloud.net.cn/uniCloud/ext-mongodb/service.html)
- [费用说明](https://doc.dcloud.net.cn/uniCloud/ext-mongodb/price.html)
- [开发文档](https://doc.dcloud.net.cn/uniCloud/ext-mongodb/dev.html)
- [控制台地址](https://unicloud.dcloud.net.cn/pages/ext-mongodb/home)

## 切换数据库实例

**注意**：需要先在扩展数据库控制台授权空间后，此空间才能使用。

```javascript
// 返回的newDb对象就是连接指定数据库实例的db对象
const newDb = uniCloud.database({
  id: "数据库实例ID"
});

let info = await vk.baseDao.findById({
  db: newDb, // 这里多加一个参数db即可
  dbName: "vk-test",
  id: "5f3a125b3d11c6000106d338"
});
```

## 切换数据库

```javascript
// 返回的newDb对象就是连接指定库名的db对象
const newDb = uniCloud.database({
  database: "数据库实例下的数据库名称"
});

let info = await vk.baseDao.findById({
  db: newDb,
  dbName: "vk-test",
  id: "5f3a125b3d11c6000106d338"
});
```

## 同时切换数据库实例和库

```javascript
// 返回的newDb对象就是连接指定数据库实例且指定了库名的db对象
const newDb = uniCloud.database({
  id: "数据库实例ID",
  database: "数据库实例下的数据库名称"
});

let info = await vk.baseDao.findById({
  db: newDb,
  dbName: "vk-test",
  id: "5f3a125b3d11c6000106d338"
});
```

## 完整示例

### 查询扩展数据库中的数据

```javascript
// 云函数中
const vk = uni.vk;

// 切换到指定数据库实例
const newDb = uniCloud.database({
  id: "your-database-instance-id",
  database: "your-database-name"
});

// 查询数据
let info = await vk.baseDao.findById({
  db: newDb,
  dbName: "your-table-name",
  id: "record-id"
});

// 查询列表
let list = await vk.baseDao.select({
  db: newDb,
  dbName: "your-table-name",
  pageIndex: 1,
  pageSize: 20,
  whereJson: {
    status: 1
  }
});

// 新增数据
let id = await vk.baseDao.add({
  db: newDb,
  dbName: "your-table-name",
  dataJson: {
    name: "测试",
    value: 100
  }
});

// 修改数据
await vk.baseDao.updateById({
  db: newDb,
  dbName: "your-table-name",
  id: "record-id",
  dataJson: {
    name: "修改后的名称"
  }
});

// 删除数据
await vk.baseDao.deleteById({
  db: newDb,
  dbName: "your-table-name",
  id: "record-id"
});
```

### 连表查询（扩展数据库）

```javascript
const newDb = uniCloud.database({
  id: "your-database-instance-id",
  database: "your-database-name"
});

let res = await vk.baseDao.selects({
  db: newDb,
  dbName: "main-table",
  pageIndex: 1,
  pageSize: 20,
  foreignDB: [
    {
      dbName: "sub-table",
      localKey: "main_key",
      foreignKey: "sub_key",
      as: "subInfo",
      limit: 1
    }
  ]
});
```

### 事务操作（扩展数据库）

```javascript
const newDb = uniCloud.database({
  id: "your-database-instance-id",
  database: "your-database-name"
});

const transaction = await vk.baseDao.startTransaction();
try {
  // 查询
  const user = await vk.baseDao.findById({
    db: transaction,
    dbName: "users",
    id: "user-id"
  });

  // 修改
  await vk.baseDao.updateById({
    db: transaction,
    dbName: "users",
    id: "user-id",
    dataJson: {
      balance: _.inc(-100)
    }
  });

  await transaction.commit();
  return { code: 0, msg: "操作成功" };
} catch (err) {
  return await vk.baseDao.rollbackTransaction({
    db: transaction,
    err
  });
}
```

## 注意事项

1. **权限设置**：需要在扩展数据库控制台授权空间后才能使用
2. **事务支持**：使用扩展数据库时，全部数据库API都支持事务，包括批量操作
3. **表创建**：扩展数据库不会自动建表，需要手动创建
4. **连接复用**：建议在同一个请求中复用同一个数据库连接

## 常见场景

### 多租户架构

```javascript
// 根据租户ID切换数据库
function getDbByTenant(tenantId) {
  const tenantConfig = {
    "tenant1": { id: "instance-1", database: "db1" },
    "tenant2": { id: "instance-2", database: "db2" }
  };
  const config = tenantConfig[tenantId];
  if (!config) return null;
  return uniCloud.database(config);
}

// 在云函数中使用
let db = getDbByTenant(tenantId);
if (!db) return { code: -1, msg: "租户不存在" };

let list = await vk.baseDao.select({
  db,
  dbName: "orders",
  pageIndex: 1,
  pageSize: 20
});
```

### 历史数据归档

```javascript
// 查询历史数据库
const historyDb = uniCloud.database({
  id: "history-instance-id",
  database: "history-db"
});

let historyData = await vk.baseDao.select({
  db: historyDb,
  dbName: "orders",
  pageIndex: 1,
  pageSize: 1000,
  whereJson: {
    _add_time: _.lt(oneYearAgo)
  }
});
```
