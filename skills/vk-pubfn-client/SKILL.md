---
name: vk-pubfn-client
description: "vk-unicloud框架客户端公共函数完整使用指南。Use when working with vk-unicloud-admin framework client-side utilities, especially when: (1) Using vk.pubfn tool functions for date/time formatting, data validation, string utilities, (2) Implementing localStorage/sessionStorage for data persistence, (3) Configuring app.config.js for global settings, (4) Working with vuex persistent state management, (5) Implementing file upload with vk.uploadFile, (6) Setting global request parameters, (7) Extending icon libraries, (8) Adapting dark theme or special UI effects. Covers vk framework client APIs, configuration patterns, and best practices."
license: MIT
---

# vk-unicloud 客户端公共函数使用指南

## Overview

本 skill 提供 vk-unicloud 框架客户端公共函数(vk.pubfn)的完整使用指南,包括工具函数、存储管理、配置系统、文件上传、状态管理等核心功能。

vk-unicloud 框架在 uni-app 基础上进行了深度封装,提供了丰富的客户端工具函数,帮助开发者快速构建应用。

## Quick Start

### 基础工具函数

```javascript
// 获取vk实例
let vk = uni.vk;

// 日期时间格式化
let dateStr = vk.pubfn.timeUtil.getNowTime();
let timestamp = vk.pubfn.timeUtil.getTimestamp();

// 数据验证
let isPhone = vk.pubfn.testUtil.isPhone("13800138000");
let isEmail = vk.pubfn.testUtil.isEmail("test@example.com");

// 字符串处理
let str = vk.pubfn.strUtil.trim("  hello  ");
```

### 本地存储

```javascript
// 持久化存储
vk.setStorageSync("key", "value");
let value = vk.getStorageSync("key");
vk.removeStorageSync("key");
vk.clearStorageSync();

// 临时会话存储(仅H5)
vk.setSessionStorageSync("key", "value");
let value = vk.getSessionStorageSync("key");
```

### Vuex 状态管理

```javascript
// 获取状态
let userInfo = vk.getVuex("$user.userInfo");

// 更新状态
vk.setVuex("$user.userInfo.avatar", avatar);

// 使用 getters
let data = vk.vuex.getters("$user/getUserInfo", params);
```

## Key Concepts

### vk 实例初始化

在 Vue 组件中正确初始化 vk 实例:

```javascript
let that;
let vk = uni.vk;

export default {
  data() {
    return {};
  },
  onLoad(options) {
    that = this;
    vk = uni.vk;
    that.init(options);
  },
  methods: {
    init(options) {
      // 初始化逻辑
    }
  }
};
```

### 配置系统

app.config.js 是应用的核心配置文件,包含:

- **debug**: 开发模式开关
- **functionName**: 主云函数名称
- **login**: 登录页面路径
- **index**: 首页路径
- **checkTokenPages**: 需要登录验证的页面
- **checkSharePages**: 可分享的页面配置
- **service.cloudStorage**: 云存储配置
- **globalErrorCode**: 全局错误码自定义
- **interceptor**: 自定义拦截器

详见 [app.config.js 配置说明](references/app-config.md)

### 文件上传

vk.uploadFile 支持多种云存储:

- **unicloud**: 空间内置存储(默认)
- **extStorage**: 扩展存储(七牛云等)
- **aliyun**: 阿里云 OSS

详见 [文件上传完整指南](references/upload-file.md)

### 全局请求参数

两种方式设置全局请求参数:

**方式一: setCustomClientInfo** (推荐, vk ≥ 2.19.4)
```javascript
vk.setCustomClientInfo({
  shop_id: "001"
});
```

**方式二: updateRequestGlobalParam**
```javascript
vk.callFunctionUtil.updateRequestGlobalParam({
  "shop-manage": {
    regExp: "^xxx/kh/",
    data: { shop_id: "001" }
  }
});
```

详见 [全局请求参数配置](references/global-request-param.md)

## Workflow

### 1. 使用工具函数

vk.pubfn 提供丰富的工具函数:

- **timeUtil**: 日期时间处理
- **testUtil**: 数据验证
- **strUtil**: 字符串处理
- **arrayUtil**: 数组操作
- **objectUtil**: 对象操作

详见 [vk.pubfn 工具函数完整指南](references/vk-pubfn.md)

### 2. 管理本地存储

根据需求选择存储方式:

- **localStorage**: 持久化存储(所有平台)
- **sessionStorage**: 临时会话存储(仅H5)

详见 [本地存储管理](references/storage.md)

### 3. 配置 Vuex 持久化

Vuex 模块配置示例:

```javascript
// store/modules/$user.js
let lifeData = uni.getStorageSync('lifeData') || {};
let $user = lifeData.$user || {};

export default {
  namespaced: true,
  state: {
    userInfo: $user.userInfo || {},
    permission: $user.permission || []
  }
};
```

详见 [Vuex 持久化配置](references/vuex.md)

### 4. 扩展图标库

支持扩展自定义图标库和使用 admin 端图标:

详见 [图标库扩展指南](references/icon.md)

### 5. UI 特效实现

- **深色模式适配**: 详见 [深色模式适配](references/dark-theme.md)
- **清明节灰色页面**: 详见 [特殊UI效果](references/special-ui.md)

## Best Practices

### 1. 命名规范

- **变量命名**: 使用 camelCase,如 `patientName`
- **常量命名**: 使用 UPPER_SNAKE_CASE,如 `MAX_COUNT`
- **Vue 实例**: 使用 `that`
- **vk 实例**: 使用 `vk`

### 2. 错误处理

使用框架内置的错误处理:

```javascript
// 自定义全局错误码
globalErrorCode: {
  "cloudfunction-unusual-timeout": "请求超时,但请求还在执行,请重新进入页面。",
  "cloudfunction-timeout": "请求超时,请重试!",
  "cloudfunction-system-error": "网络开小差了!"
}
```

### 3. 性能优化

- 避免在模板中使用复杂计算
- 合理使用 computed 和 watch
- 使用 v-show 代替频繁切换的 v-if
- Vuex 数据避免全局混入,影响小程序性能

### 4. 安全注意事项

- 敏感数据加密传输
- 不在前端存储敏感信息
- 使用 vk 框架的权限系统
- 定期更新依赖包

## References

详细文档请查看 references/ 目录:

- [app.config.js 配置说明](references/app-config.md) - 应用配置完整说明
- [文件上传完整指南](references/upload-file.md) - vk.uploadFile API 文档
- [全局请求参数配置](references/global-request-param.md) - 全局参数设置方法
- [vk.pubfn 工具函数](references/vk-pubfn.md) - 工具函数完整列表
- [本地存储管理](references/storage.md) - localStorage/sessionStorage 使用
- [Vuex 持久化配置](references/vuex.md) - Vuex 状态管理
- [图标库扩展](references/icon.md) - 图标库使用指南
- [深色模式适配](references/dark-theme.md) - 深色模式实现
- [特殊UI效果](references/special-ui.md) - 清明节灰色等特效
