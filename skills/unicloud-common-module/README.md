# uniCloud-common-module Skill

## 概述

本 skill 提供了 uniCloud 云函数公共模块的完整使用指南，帮助开发者理解和使用 uniCloud 的公共模块功能。

## 何时使用

当遇到以下场景时，应该使用本 skill：

1. **创建共享工具模块** - 多个云函数需要使用的通用逻辑
2. **代码复用** - 提取重复代码到公共模块
3. **模块化管理** - 组织和管理云函数之间的依赖关系
4. **学习公共模块** - 了解如何创建、上传、更新公共模块

## 主要内容

### 核心文档

- [SKILL.md](./SKILL.md) - 完整的使用指南和最佳实践

### 示例代码

- [db-utils-example.js](./examples/db-utils-example.js) - 数据库工具函数示例
- [auth-helper-example.js](./examples/auth-helper-example.js) - 认证辅助工具示例
- [cloud-function-example.js](./examples/cloud-function-example.js) - 使用公共模块的云函数示例

## 快速开始

### 1. 创建公共模块目录结构

```bash
uniCloud-aliyun/
└─ cloudfunctions/
   ├─ common/              # 公共模块目录
   │  └─ db-utils/         # 数据库工具模块
   │     ├─ index.js       # 入口文件
   │     └─ package.json   # 模块配置
   └─ admin/               # 云函数目录
      └─ patient/
         └─ sys/
            └─ getList.js  # 使用公共模块的云函数
```

### 2. 编写公共模块代码

参考 `examples/db-utils-example.js` 创建你的公共模块。

### 3. 上传公共模块

在 HBuilderX 中右键点击公共模块目录 -> "上传公用模块"

### 4. 管理依赖

在云函数目录右键 -> "管理公共模块依赖" -> 添加需要的公共模块

### 5. 在云函数中使用

```javascript
const dbUtils = require('db-utils')

exports.main = async (event, context) => {
  // 使用公共模块中的函数
  const formattedData = dbUtils.formatRows(data)
  return { code: 0, rows: formattedData }
}
```

## 最佳实践

### ✅ 推荐做法

1. **模块化设计** - 每个公共模块专注于单一职责
2. **清晰命名** - 使用项目前缀 + 功能名，如 `wm-db-utils`
3. **完善文档** - 为每个导出函数添加 JSDoc 注释
4. **错误处理** - 包含完善的错误处理和日志输出
5. **版本管理** - 在 package.json 中维护版本号

### ❌ 避免的做法

1. **不要修改 package.json 的 name 字段**
2. **不要使用 Node.js 内置模块名作为公共模块名**
3. **不要在公共模块中存储敏感信息**
4. **不要忘记重新上传更新后的公共模块**

## 常见问题

### Q: 修改公共模块后其他云函数没有生效？

A: 需要重新上传公共模块，并在云函数上右键选择"更新依赖本模块的云函数"

### Q: 如何处理公共模块之间的依赖？

A: 公共模块可以依赖其他公共模块，使用方式与云函数相同：右键 -> 管理公共模块依赖

### Q: npm install 后软链接失效怎么办？

A: 删除 `node_modules` 和 `package-lock.json`，重新执行 `npm install`

## 相关资源

- [uniCloud 官方文档](https://doc.dcloud.net.cn/uniCloud/cf-common.html)
- [vk-unicloud 框架文档](https://uniadmin.jiangruyi.com/)
- [本项目 AGENTS.md](../../../AGENTS.md)

## 更新日志

- 2026-03-02 - 创建初始版本，包含完整的公共模块使用指南和示例代码
