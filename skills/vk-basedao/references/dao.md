# DAO层封装

## Overview

DAO层是数据访问对象层，负责封装数据库操作，实现业务逻辑与数据访问的分离。

## DAO层作用

1. **复用数据库API**：减少重复代码
2. **积木式开发**：业务逻辑与数据访问分离
3. **独立开发**：可脱离业务编写，数据库表名确定即可开发
4. **易于维护**：修改数据库字段或名称只需修改少量代码

## baseDao与dao的区别

- `baseDao`：相当于万能dao，是最基础的零件
- `dao`：是利用零件组装不同形状和规则的积木，供service层使用

## 命名规范

### 前缀 + 条件类型（单表操作）

| 操作 | 前缀 | 示例 |
|------|------|------|
| 查单条 | find / get | findById, findByMobile |
| 查多条 | list | listByStatus, listByWhereJson |
| 统计 | count | countByStatus |
| 新增 | add / save | add, saveUser |
| 删除 | delete / remove | deleteById, removeByWhereJson |
| 修改 | update | updateById, updateByWhereJson |

### 前缀 + 表名 + 条件类型（多表操作）

| 操作 | 前缀 | 示例 |
|------|------|------|
| 查单条 | find | findUserById, findOrderByNo |
| 查多条 | list | listUserByStatus |
| 统计 | count | countOrderByUserId |
| 新增 | add | addUser, addOrder |
| 删除 | delete | deleteUserById |
| 修改 | update | updateUserById |

## 目录结构

```
cloudfunctions/
├── router/
│   ├── dao/
│   │   └── modules/
│   │       ├── userDao.js
│   │       ├── orderDao.js
│   │       └── productDao.js
│   └── service/
│       └── user/
│           └── userService.js
```

## 示例代码

### userDao.js

```javascript
// router/dao/modules/userDao.js
module.exports = {
  // ==================== 查询 ====================

  // 根据ID获取用户
  findById(id) {
    return vk.baseDao.findById({
      dbName: "uni-id-users",
      id,
      fieldJson: {
        token: false,
        password: false
      }
    });
  },

  // 根据手机号获取用户
  findByMobile(mobile) {
    return vk.baseDao.findByWhereJson({
      dbName: "uni-id-users",
      whereJson: { mobile }
    });
  },

  // 根据用户名获取用户
  findByUsername(username) {
    return vk.baseDao.findByWhereJson({
      dbName: "uni-id-users",
      whereJson: { username }
    });
  },

  // 根据条件获取单条记录
  findByWhereJson(whereJson, fieldJson = {}) {
    return vk.baseDao.findByWhereJson({
      dbName: "uni-id-users",
      whereJson,
      fieldJson: {
        token: false,
        password: false,
        ...fieldJson
      }
    });
  },

  // 根据状态获取用户列表
  listByStatus(status, pageIndex = 1, pageSize = 20) {
    return vk.baseDao.select({
      dbName: "uni-id-users",
      pageIndex,
      pageSize,
      whereJson: { status },
      fieldJson: {
        token: false,
        password: false
      },
      sortArr: [{ name: "_add_time", type: "desc" }]
    });
  },

  // 根据条件获取用户列表
  listByWhereJson(whereJson, pageIndex = 1, pageSize = 20) {
    return vk.baseDao.select({
      dbName: "uni-id-users",
      pageIndex,
      pageSize,
      whereJson,
      fieldJson: {
        token: false,
        password: false
      },
      sortArr: [{ name: "_add_time", type: "desc" }]
    });
  },

  // 获取所有用户
  listAll(whereJson = {}) {
    return vk.baseDao.select({
      dbName: "uni-id-users",
      pageIndex: 1,
      pageSize: 1000,
      whereJson,
      fieldJson: {
        token: false,
        password: false
      }
    });
  },

  // 统计用户数量
  count(whereJson = {}) {
    return vk.baseDao.count({
      dbName: "uni-id-users",
      whereJson
    });
  },

  // ==================== 新增 ====================

  // 新增用户
  add(data) {
    return vk.baseDao.add({
      dbName: "uni-id-users",
      dataJson: data
    });
  },

  // 批量新增用户
  addBatch(dataList) {
    return vk.baseDao.adds({
      dbName: "uni-id-users",
      dataJson: dataList
    });
  },

  // ==================== 修改 ====================

  // 根据ID修改用户
  updateById(id, data) {
    return vk.baseDao.updateById({
      dbName: "uni-id-users",
      id,
      dataJson: data
    });
  },

  // 根据ID修改用户（返回修改后的数据）
  updateByIdAndReturn(id, data) {
    return vk.baseDao.updateById({
      dbName: "uni-id-users",
      id,
      dataJson: data,
      getUpdateData: true
    });
  },

  // 根据条件修改用户
  updateByWhereJson(whereJson, data) {
    return vk.baseDao.update({
      dbName: "uni-id-users",
      whereJson,
      dataJson: data
    });
  },

  // 用户积分自增
  incrementPoints(userId, points) {
    return vk.baseDao.updateAndReturn({
      dbName: "uni-id-users",
      whereJson: { _id: userId },
      dataJson: { points: _.inc(points) }
    });
  },

  // ==================== 删除 ====================

  // 根据ID删除用户
  deleteById(id) {
    return vk.baseDao.deleteById({
      dbName: "uni-id-users",
      id
    });
  },

  // 根据条件删除用户
  deleteByWhereJson(whereJson) {
    return vk.baseDao.del({
      dbName: "uni-id-users",
      whereJson
    });
  },

  // ==================== 连表查询 ====================

  // 获取用户列表（带角色信息）
  listWithRole(pageIndex = 1, pageSize = 20) {
    return vk.baseDao.selects({
      dbName: "uni-id-users",
      pageIndex,
      pageSize,
      whereJson: {},
      fieldJson: {
        token: false,
        password: false
      },
      sortArr: [{ name: "_add_time", type: "desc" }],
      foreignDB: [
        {
          dbName: "uni-id-roles",
          localKey: "role",
          localKeyType: "array",
          foreignKey: "role_id",
          as: "roles",
          limit: 10
        }
      ]
    });
  },

  // 获取单个用户（带角色信息）
  findByIdWithRole(id) {
    return vk.baseDao.selects({
      dbName: "uni-id-users",
      getOne: true,
      getMain: true,
      whereJson: { _id: id },
      fieldJson: {
        token: false,
        password: false
      },
      foreignDB: [
        {
          dbName: "uni-id-roles",
          localKey: "role",
          localKeyType: "array",
          foreignKey: "role_id",
          as: "roles",
          limit: 10
        }
      ]
    });
  }
};
```

### orderDao.js

```javascript
// router/dao/modules/orderDao.js
module.exports = {
  // 根据ID获取订单
  findById(id) {
    return vk.baseDao.findById({
      dbName: "orders",
      id
    });
  },

  // 根据订单号获取订单
  findByOrderNo(orderNo) {
    return vk.baseDao.findByWhereJson({
      dbName: "orders",
      whereJson: { order_no: orderNo }
    });
  },

  // 根据用户ID获取订单列表
  listByUserId(userId, pageIndex = 1, pageSize = 20) {
    return vk.baseDao.select({
      dbName: "orders",
      pageIndex,
      pageSize,
      whereJson: { user_id: userId },
      sortArr: [{ name: "_add_time", type: "desc" }]
    });
  },

  // 根据状态获取订单列表
  listByStatus(status, pageIndex = 1, pageSize = 20) {
    return vk.baseDao.select({
      dbName: "orders",
      pageIndex,
      pageSize,
      whereJson: { status },
      sortArr: [{ name: "_add_time", type: "desc" }]
    });
  },

  // 创建订单
  add(data) {
    return vk.baseDao.add({
      dbName: "orders",
      dataJson: {
        order_no: vk.pubfn.createOrderNo(),
        status: "pending",
        ...data
      }
    });
  },

  // 更新订单状态
  updateStatus(id, status) {
    return vk.baseDao.updateById({
      dbName: "orders",
      id,
      dataJson: { status }
    });
  },

  // 订单支付（原子操作）
  pay(id) {
    return vk.baseDao.updateAndReturn({
      dbName: "orders",
      whereJson: { _id: id, status: "pending" },
      dataJson: {
        status: "paid",
        pay_time: Date.now()
      }
    });
  },

  // 统计用户订单金额
  sumAmountByUserId(userId) {
    return vk.baseDao.sum({
      dbName: "orders",
      fieldName: "pay_amount",
      whereJson: {
        user_id: userId,
        status: "paid"
      }
    });
  },

  // 统计订单数量
  count(whereJson = {}) {
    return vk.baseDao.count({
      dbName: "orders",
      whereJson
    });
  }
};
```

## 调用方式

### 在service层调用

```javascript
// router/service/user/userService.js
module.exports = {
  // 获取用户详情
  getUserDetail(id) {
    return vk.daoCenter.userDao.findById(id);
  },

  // 获取用户列表
  getUserList(query, pageIndex = 1, pageSize = 20) {
    return vk.daoCenter.userDao.listByWhereJson(query, pageIndex, pageSize);
  },

  // 创建用户
  createUser(data) {
    // 检查用户名是否已存在
    let exist = await vk.daoCenter.userDao.findByUsername(data.username);
    if (exist) {
      return { code: -1, msg: "用户名已存在" };
    }
    // 检查手机号是否已存在
    let mobileExist = await vk.daoCenter.userDao.findByMobile(data.mobile);
    if (mobileExist) {
      return { code: -1, msg: "手机号已注册" };
    }
    // 创建用户
    let id = await vk.daoCenter.userDao.add(data);
    return { code: 0, msg: "创建成功", id };
  },

  // 更新用户
  updateUser(id, data) {
    return vk.daoCenter.userDao.updateById(id, data);
  },

  // 删除用户
  deleteUser(id) {
    return vk.daoCenter.userDao.deleteById(id);
  }
};
```

## 自定义DAO目录

如果需要在非router云函数中使用DAO层：

1. 在 `cloudfunctions/common` 目录新建公共模块 `router-common`
2. 将 `router/dao` 目录移动到 `router-common` 下
3. 替换 `router-common/index.js`：

```javascript
module.exports = {
  daoCenter: require('./dao/index.js')
};
```

4. 修改 `router/config.js`：

```javascript
const routeCommon = require('router-common');
const initConfig = {
  baseDir: __dirname,
  requireFn: require,
  daoCenter: routeCommon.daoCenter,
  customUtil: {}
};
module.exports = initConfig;
```

5. 在其他云函数中引入：

```javascript
const vkCloud = require('vk-unicloud');
const routeCommon = require('router-common');
const vk = vkCloud.createInstance({
  baseDir: __dirname,
  requireFn: require,
  daoCenter: routeCommon.daoCenter
});
```

## 注意事项

1. DAO层代码应尽量只写数据库交互逻辑，少写业务逻辑
2. 文件名必须以 `Dao.js` 结尾
3. 如果新建dao层代码后运行提示不存在，需要重新运行项目
