---
name: jql-unicloud
description: "JQL数据库操作完整使用指南。Use when working with UniCloud JQL database operations, especially when: (1) Using JQL syntax for database queries in clientDB or cloud functions, (2) Implementing complex queries with JQL's simplified syntax (compared to traditional MongoDB), (3) Performing table joins using foreignKey, (4) Using tree queries, grouping, and aggregation, (5) Understanding differences between JQL and vk.baseDao approaches."
---

# JQL 数据库操作完整指南

## Overview

JQL (JavaScript Query Language) 是 UniCloud 提供的一种类 SQL 的数据库查询语法,比传统 MongoDB API 和 SQL 更简单易用。本 skill 提供了 JQL 的完整使用指南,涵盖客户端、云函数、JQL 管理器等所有使用场景。

**核心优势**:
- 类 SQL 语法: `where('age > 18 && status == 1')` 而非复杂的 command 对象
- 简化联表查询: 通过 foreignKey 自动关联,无需手动编写 lookup
- 强大的 DB Schema: 内置权限校验、数据校验、默认值等功能
- 云端一体: 客户端和云函数使用相同的语法

**与 vk.baseDao 对比**:
- JQL: 客户端+云函数,类 SQL 语法,自动权限校验
- vk.baseDao: 仅云函数,JSON 对象语法,手动权限控制

## 快速开始

### 获取 databaseForJQL 实例

**客户端使用:**
```javascript
const db = uniCloud.databaseForJQL()
```

**云函数使用:**
```javascript
const db = uniCloud.databaseForJQL({ 
  clientInfo: context.CLIENT 
})
```

**JQL 数据库管理器:**
```javascript
// 在 HBuilderX 的 JQL 管理器中直接使用 db 变量
db.collection('user').get()
```

### 第一个查询示例

```javascript
const db = uniCloud.databaseForJQL()
const res = await db.collection('user')
  .where('age > 18')
  .field('name,age,email')
  .orderBy('age desc')
  .skip(0)
  .limit(20)
  .get()
```

### 与 vk.baseDao 对比

| 特性 | JQL | vk.baseDao |
|------|-----|------------|
| 使用场景 | 客户端+云函数 | 仅云函数 |
| 语法 | 类 SQL 字符串 | JSON 对象 |
| 联表查询 | 通过 foreignKey 自动关联 | 需要手动编写 lookup |
| 权限校验 | 自动进行 schema 权限校验 | 需要手动编写权限逻辑 |
| 学习成本 | 低,类似 SQL | 中,需要了解 MongoDB |

**选择建议**:
- ✅ 使用 JQL: 客户端查询、简单联表、树形查询、分组统计
- ✅ 使用 vk.baseDao: 云函数复杂查询、MongoDB 聚合管道、细粒度性能控制

## 使用场景对比

JQL 可以在三种场景中使用,不同场景的权限校验和功能支持有所不同。

### 1. 客户端 clientDB

- ✅ 完整的权限校验
- ✅ 支持所有 JQL 语法
- ⚠️ 需要在 DB Schema 中配置 permission 权限

### 2. 云函数内使用 JQL

- ✅ 同 clientDB,但 password 类型数据可配置权限
- ✅ 可以通过 `setUser` 指定用户身份
- ⚠️ 需要在 DB Schema 中配置 permission 权限

### 3. HBuilderX JQL 数据库管理器

- ✅ 不会校验任何权限,相当于数据库管理员身份
- ✅ 不会触发数据库触发器
- ❌ 不可以执行 action 云函数
- ⚠️ 仅用于开发调试

## 详细文档导航

本 skill 采用渐进式披露设计,核心内容在 SKILL.md 中,详细内容在 references/ 目录中。

### 核心操作指南

- **[查询操作](references/01-查询操作.md)** - where、field、orderBy、分页、复杂查询、正则查询、统计查询
- **[联表查询](references/02-联表查询.md)** - foreignKey 配置、虚拟联表、临时表联表、副表 foreignKey 联查
- **[高级查询](references/03-高级查询.md)** - 树形查询、分组统计、数据去重、地理位置查询
- **[增删改操作](references/04-增删改操作.md)** - 新增、更新、删除、事务操作
- **[DB Schema 配置](references/05-DB-Schema配置.md)** - permission 权限、foreignKey 关联、数据校验、默认值
- **[最佳实践](references/06-最佳实践.md)** - 性能优化、错误处理、选择指南、实战案例、调试技巧

### 何时查看详细文档

**查看 [查询操作](references/01-查询操作.md)** 当你需要:
- 使用 where 条件查询(简单条件、多条件、in 查询)
- 使用 field 字段过滤(指定字段、嵌套字段、字段别名)
- 使用 orderBy 排序(单字段、多字段)
- 实现分页查询
- 使用复杂查询条件或正则查询
- 进行统计查询(count、getCount、getOne)

**查看 [联表查询](references/02-联表查询.md)** 当你需要:
- 配置 foreignKey 实现表关联
- 使用虚拟联表查询
- 使用临时表联表查询(性能优化)
- 处理副表 foreignKey 联查
- 理解联表查询的注意事项

**查看 [高级查询](references/03-高级查询.md)** 当你需要:
- 使用树形查询(getTree、getTreePath)
- 使用分组统计(groupBy、groupField)
- 使用数据去重(distinct)
- 使用地理位置查询(geoNear)

**查看 [增删改操作](references/04-增删改操作.md)** 当你需要:
- 新增数据(单条、批量)
- 更新数据(doc 方式、where 方式、嵌套字段、数组元素)
- 删除数据(doc 方式、where 方式)
- 使用事务操作

**查看 [DB Schema 配置](references/05-DB-Schema配置.md)** 当你需要:
- 配置 permission 权限(表级、字段级)
- 配置 foreignKey 关联(一对多、多对多、树形)
- 配置数据校验规则(基础校验、必填字段、枚举值)
- 配置默认值(defaultValue、forceDefaultValue)

**查看 [最佳实践](references/06-最佳实践.md)** 当你需要:
- 优化查询性能(联表查询、字段过滤、分页、索引)
- 处理常见错误(权限错误、语法错误、数据格式错误、索引冲突)
- 选择 JQL 或 vk.baseDao
- 查看实战案例(订单列表、数据统计、树形结构、商品搜索)
- 学习调试技巧

## 常用代码片段

### 基础查询

```javascript
// 简单查询
const db = uniCloud.databaseForJQL()
const res = await db.collection('user')
  .where('age > 18')
  .field('name,age')
  .orderBy('age desc')
  .skip(0)
  .limit(20)
  .get()
```

### 联表查询

```javascript
// 临时表联表查询(推荐)
const order = db.collection('order')
  .where('quantity > 100')
  .getTemp()
const book = db.collection('book')
  .where('title == "三国演义"')
  .getTemp()
const res = await db.collection(order, book).get()
```

### 树形查询

```javascript
// 查询部门树
const res = await db.collection('department')
  .where('status == 0')
  .get({
    getTree: {
      limitLevel: 10
    }
  })
```

### 分组统计

```javascript
// 按日统计订单
const res = await db.collection('order')
  .groupBy('dateToString(add(new Date(0),create_time),"%Y-%m-%d","+0800") as date')
  .groupField('count(*) as order_count,sum(total_amount) as total_amount')
  .get()
```

## 学习路径

1. **掌握基础查询** - where、field、orderBy、分页
2. **学习联表查询** - foreignKey 配置、临时表联表
3. **掌握高级查询** - 树形查询、分组统计、去重
4. **理解 DB Schema** - 权限、校验、默认值
5. **实战项目应用** - 订单列表、数据统计、树形结构

## 相关资源

- [JQL 官方文档](https://doc.dcloud.net.cn/uniCloud/jql.html)
- [DB Schema 文档](https://doc.dcloud.net.cn/uniCloud/schema.html)
- [vk-basedao skill](../vk-basedao/) - vk 框架数据库操作指南
- [vk-data-form skill](../vk-data-form/) - vk 框架表单组件指南
