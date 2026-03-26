---
name: unicloud-common-module
description: uniCloud 云函数公共模块完整使用指南。Use when working with uniCloud cloud function common modules, especially when: (1) Creating shared utility modules for multiple cloud functions, (2) Implementing common logic extraction and reuse, (3) Managing dependencies between cloud functions and common modules, (4) Understanding how to export and import common modules in uniCloud.
license: Complete terms in LICENSE.txt
---

# uniCloud 云函数公共模块使用指南

## 概述

uniCloud 支持云函数公共模块功能。多个云函数的共享部分可以抽离为公共模块，然后被多个云函数引用，实现代码复用和模块化开发。

## 目录结构

标准的 uniCloud 云函数公共模块目录结构如下：

```
cloudfunctions/
├─ common/                      // 云函数公用模块目录
│  └─ hello-common/             // 云函数公用模块
│     ├─ package.json           // 模块配置（不要修改 name 字段）
│     └─ index.js               // 公用模块代码（可修改文件名）
└─ use-common/                  // 使用公用模块的云函数
   ├─ package.json              // 在 use-common 目录执行 npm init -y 生成
   └─ index.js                  // 云函数入口文件
```

## 创建并引入公共模块

### 步骤 1：创建 common 目录

在 `cloudfunctions` 目录下创建 `common` 目录用于存放所有公共模块。

### 步骤 2：创建公共模块目录

在 `common` 目录下右键创建公共模块目录（如 `hello-common`），系统会自动创建：
- `index.js` - 入口文件
- `package.json` - 模块配置

**重要**：不要修改 `package.json` 中的 `name` 字段。

### 步骤 3：上传公共模块

在公共模块目录上右键，选择"上传公用模块"。

### 步骤 4：管理依赖

在使用公共模块的云函数上右键，选择"管理公共模块依赖"，添加需要依赖的公共模块。

![管理公共模块依赖](https://doc.dcloud.net.cn/uniCloud/cf-common.html)

### 步骤 5：更新依赖模块

如果需要更新所有依赖某公共模块的云函数，可以在 `common` 目录下的公共模块目录右键，选择"更新依赖本模块的云函数"。

![更新公共模块](https://doc.dcloud.net.cn/uniCloud/cf-common.html)

## 使用示例

### 示例 1：导出多个函数和变量

**公共模块代码** (`common/hello-common/index.js`)：

```javascript
function getVersion() {
  return '0.0.1'
}

function getSecret() {
  return 'your secret'
}

module.exports = {
  getVersion,
  getSecret
}
```

**使用公共模块的云函数** (`use-common/index.js`)：

```javascript
'use strict';
const { getSecret, getVersion } = require('hello-common')

exports.main = async (event, context) => {
  let version = getVersion()
  let secret = getSecret()
  
  return {
    secret,
    version
  }
}
```

### 示例 2：导出单个函数

如果仅需要导出一个 function，可以使用以下写法：

**公共模块代码** (`common/hello-common/index.js`)：

```javascript
module.exports = function(e) {
  return e
}
```

**使用公共模块的云函数** (`use-common/index.js`)：

```javascript
'use strict';
const echo = require('hello-common')

exports.main = async (event, context) => {
  let eventEcho = echo(event)
  return {
    eventEcho
  }
}
```

### 示例 3：在实际项目中使用

在 vk-unicloud 框架中，公共模块可以用于：

```javascript
// common/db-utils/index.js
/**
 * 数据库工具函数
 */

/**
 * 格式化查询结果
 * @param {Array} rows - 原始数据
 * @returns {Array} 格式化后的数据
 */
function formatRows(rows) {
  if (!rows || !Array.isArray(rows)) {
    return []
  }
  
  return rows.map(row => {
    // 格式化日期字段
    if (row.create_time) {
      row.create_time = new Date(row.create_time).toLocaleString('zh-CN')
    }
    return row
  })
}

/**
 * 验证用户权限
 * @param {Object} userInfo - 用户信息
 * @param {String} userId - 目标用户 ID
 * @returns {Boolean} 是否有权限
 */
function hasPermission(userInfo, userId) {
  return userInfo && (userInfo.role === 'admin' || userInfo.uid === userId)
}

module.exports = {
  formatRows,
  hasPermission
}
```

**在云函数中使用**：

```javascript
// admin/patient/sys/getList.js
'use strict';
const dbUtils = require('db-utils')

exports.main = async (event, context) => {
  const db = uniCloud.database()
  const collection = db.collection('wm-patients')
  
  // 查询数据
  const { data } = await collection.where({
    status: 'normal'
  }).orderBy('create_time', 'desc').limit(10).get()
  
  // 使用公共模块格式化数据
  const formattedData = dbUtils.formatRows(data)
  
  return {
    code: 0,
    msg: 'success',
    rows: formattedData,
    total: data.length
  }
}
```

## 注意事项

### ⚠️ 重要提醒

1. **命名冲突**：公共模块命名不可与 Node.js 内置模块重名
   - ❌ 避免使用：`fs`, `path`, `http`, `util` 等
   - ✅ 推荐使用：项目前缀 + 功能名，如 `db-utils`, `auth-helper`

2. **package.json 限制**：
   - ❌ 不要修改 `package.json` 的 `name` 字段
   - ✅ 保持自动生成的名称不变

3. **软链接问题**：从插件市场导入或其他地方复制项目可能会导致 `npm install` 创建的软链接失效
   - 如果遇到这种情况，请删除 `node_modules` 和 `package-lock.json`
   - 重新执行 `npm install`

4. **模块依赖**：
   - 公共模块可以依赖其他公共模块
   - 使用方式相同：右键管理依赖

5. **更新策略**：
   - 修改公共模块后，必须重新上传
   - 使用"更新依赖本模块的云函数"功能批量更新

## 最佳实践

### 1. 模块化设计

将通用功能抽象为独立的公共模块：

- **数据库工具**：`db-utils` - 通用查询、格式化、验证
- **认证工具**：`auth-helper` - 权限验证、token 处理
- **业务逻辑**：`patient-service` - 患者相关业务逻辑
- **工具函数**：`common-utils` - 日期格式化、字符串处理等

### 2. 清晰的接口定义

公共模块应该提供清晰的 API 接口：

```javascript
/**
 * 患者服务模块
 * @module patient-service
 */

/**
 * 获取患者基本信息
 * @param {String} patientId - 患者 ID
 * @returns {Promise<Object>} 患者信息
 */
async function getPatientInfo(patientId) {
  // 实现...
}

/**
 * 验证患者身份
 * @param {String} patientId - 患者 ID
 * @param {String} mobile - 手机号
 * @returns {Promise<Boolean>} 验证结果
 */
async function verifyPatient(patientId, mobile) {
  // 实现...
}

module.exports = {
  getPatientInfo,
  verifyPatient
}
```

### 3. 错误处理

公共模块应包含完善的错误处理：

```javascript
async function getPatientInfo(patientId) {
  try {
    if (!patientId) {
      throw new Error('患者 ID 不能为空')
    }
    
    const db = uniCloud.database()
    const result = await db.collection('wm-patients')
      .doc(patientId)
      .get()
    
    if (!result.data) {
      throw new Error('患者不存在')
    }
    
    return result.data
  } catch (error) {
    console.error('获取患者信息失败:', error)
    throw error
  }
}
```

### 4. 文档注释

为公共模块添加详细的 JSDoc 注释：

```javascript
/**
 * 计算 BMI 指数
 * @param {Number} weight - 体重（kg）
 * @param {Number} height - 身高（m）
 * @returns {Object} BMI 计算结果
 * @returns {Number} returns.bmi - BMI 值
 * @returns {String} returns.category - BMI 分类（偏瘦/正常/超重/肥胖）
 */
function calculateBMI(weight, height) {
  const bmi = weight / (height * height)
  let category
  
  if (bmi < 18.5) {
    category = '偏瘦'
  } else if (bmi < 24) {
    category = '正常'
  } else if (bmi < 28) {
    category = '超重'
  } else {
    category = '肥胖'
  }
  
  return {
    bmi: parseFloat(bmi.toFixed(2)),
    category
  }
}
```

## 与 vk.baseDao 结合使用

在 vk-unicloud-admin 框架中，可以将 vk.baseDao 的通用操作封装为公共模块：

```javascript
// common/vk-dao-helper/index.js
const vk = require('vk-unicloud')

/**
 * 通用数据访问助手
 */

/**
 * 根据 ID 查询单条记录
 * @param {String} dbName - 集合名称
 * @param {String} id - 记录 ID
 * @returns {Promise<Object|null>} 查询结果
 */
async function findById(dbName, id) {
  return await vk.baseDao.findById({
    dbName,
    id
  })
}

/**
 * 分页查询
 * @param {String} dbName - 集合名称
 * @param {Object} whereJson - 查询条件
 * @param {Number} pageIndex - 页码
 * @param {Number} pageSize - 每页数量
 * @returns {Promise<Object>} 查询结果
 */
async function getPageList(dbName, whereJson, pageIndex = 1, pageSize = 10) {
  return await vk.baseDao.getTableData({
    data: {
      tableName: dbName,
      formData: whereJson,
      pageIndex,
      pageSize
    }
  })
}

module.exports = {
  findById,
  getPageList
}
```

## 调试技巧

1. **本地测试**：在上传前先在本地测试公共模块的功能
2. **日志输出**：使用 `console.log` 输出关键信息
3. **版本管理**：在公共模块中添加版本号便于追踪
4. **依赖检查**：定期检查依赖关系是否正确

## 相关资源

- [uniCloud 官方文档 - 云函数公共模块](https://doc.dcloud.net.cn/uniCloud/cf-common.html)
- [vk-unicloud 框架文档](https://uniadmin.jiangruyi.com/)
- [Node.js 模块系统](https://nodejs.org/api/modules.html)
