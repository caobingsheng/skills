# 本地存储管理

## 目录

- [概述](#概述)
- [localStorage - 持久化存储](#localstorage---持久化存储)
- [sessionStorage - 临时会话存储](#sessionstorage---临时会话存储)
- [两种存储方式对比](#两种存储方式对比)
- [使用场景](#使用场景)
- [最佳实践](#最佳实践)

## 概述

vk-unicloud 框架提供了两种本地存储方式:

1. **localStorage**: 持久化存储(所有平台)
2. **sessionStorage**: 临时会话存储(仅H5)

## localStorage - 持久化存储

localStorage 是持久化的本地存储,数据会一直保存,除非用户主动删除或超过一定时间被自动清理。

### 基本用法

```javascript
// 存储数据
vk.setStorageSync("key", "value");

// 获取数据
let value = vk.getStorageSync("key");

// 删除数据
vk.removeStorageSync("key");

// 清空所有数据
vk.clearStorageSync();

// 清除键值为指定字符串开头的缓存
vk.clearStorageSync("user_"); // 清除所有 user_ 开头的缓存

// 获取缓存信息
let storageInfo = vk.getStorageInfoSync();
console.log(storageInfo);
// 返回: { keys: ["key1", "key2"], currentSize: 1024, limitSize: 10240 }
```

### 存储对象

```javascript
// 存储对象(会自动转换为JSON)
vk.setStorageSync("userInfo", {
  id: 1,
  name: "张三",
  age: 25
});

// 获取对象(会自动解析JSON)
let userInfo = vk.getStorageSync("userInfo");
console.log(userInfo);
// 返回: { id: 1, name: "张三", age: 25 }
```

### 存储数组

```javascript
// 存储数组
vk.setStorageSync("list", [1, 2, 3, 4, 5]);

// 获取数组
let list = vk.getStorageSync("list");
console.log(list);
// 返回: [1, 2, 3, 4, 5]
```

### 异步API

```javascript
// 异步存储
vk.setStorage({
  key: "key",
  data: "value",
  success: () => {
    console.log("存储成功");
  }
});

// 异步获取
vk.getStorage({
  key: "key",
  success: (res) => {
    console.log("获取成功:", res.data);
  }
});

// 异步删除
vk.removeStorage({
  key: "key",
  success: () => {
    console.log("删除成功");
  }
});

// 异步清空
vk.clearStorage({
  success: () => {
    console.log("清空成功");
  }
});
```

## sessionStorage - 临时会话存储

sessionStorage 是临时会话存储,仅在当前会话期间有效,关闭页面或浏览器后数据会被清除。

**注意**: 仅H5端支持,其他端均不支持。

### 基本用法

```javascript
// 存储数据
vk.setSessionStorageSync("key", "value");

// 获取数据
let value = vk.getSessionStorageSync("key");

// 删除数据
vk.removeSessionStorageSync("key");

// 清空所有数据
vk.clearSessionStorageSync();

// 清除键值为指定字符串开头的缓存
vk.clearSessionStorageSync("temp_"); // 清除所有 temp_ 开头的缓存
```

### 异步API

```javascript
// 异步存储
vk.setSessionStorage({
  key: "key",
  data: "value",
  success: () => {
    console.log("存储成功");
  }
});

// 异步获取
vk.getSessionStorage({
  key: "key",
  success: (res) => {
    console.log("获取成功:", res.data);
  }
});
```

## 两种存储方式对比

| 特性 | localStorage | sessionStorage |
| --- | --- | --- |
| **生命周期** | 持久化,除非主动删除 | 临时会话,关闭页面后清除 |
| **作用域** | 同源下所有页面共享 | 仅当前页面窗口可用 |
| **平台支持** | 所有平台(H5/App/小程序) | 仅H5端 |
| **存储大小** | H5: 5MB, App: 无限制, 小程序: 10MB | H5: 5MB |
| **使用场景** | 用户设置、登录信息等 | 临时数据、表单草稿等 |

## 使用场景

### localStorage 适用场景

#### 1. 用户登录信息

```javascript
// 登录成功后存储token
vk.setStorageSync("token", res.token);
vk.setStorageSync("userInfo", res.userInfo);

// 后续请求携带token
vk.callFunction({
  url: "admin/user/sys/getInfo",
  data: {
    token: vk.getStorageSync("token")
  },
  success: (data) => {}
});
```

#### 2. 用户设置

```javascript
// 保存用户设置
vk.setStorageSync("userSettings", {
  theme: "dark",
  language: "zh-CN",
  fontSize: 16
});

// 读取用户设置
let settings = vk.getStorageSync("userSettings");
if (settings) {
  // 应用设置
  that.theme = settings.theme;
  that.language = settings.language;
}
```

#### 3. 缓存数据

```javascript
// 缓存列表数据
vk.setStorageSync("cacheList", list, {
  expire: 3600000 // 1小时后过期(需要自己实现过期逻辑)
});

// 读取缓存
let cacheList = vk.getStorageSync("cacheList");
if (cacheList) {
  // 检查是否过期
  if (Date.now() - cacheList.timestamp < 3600000) {
    that.list = cacheList.data;
  } else {
    vk.removeStorageSync("cacheList");
  }
}
```

#### 4. 购物车

```javascript
// 添加到购物车
let cart = vk.getStorageSync("cart") || [];
cart.push({
  id: productId,
  name: productName,
  price: productPrice,
  quantity: 1
});
vk.setStorageSync("cart", cart);

// 读取购物车
let cart = vk.getStorageSync("cart") || [];
```

### sessionStorage 适用场景

#### 1. 表单草稿

```javascript
// 保存表单草稿
vk.setSessionStorageSync("formDraft", that.form);

// 页面加载时恢复草稿
let formDraft = vk.getSessionStorageSync("formDraft");
if (formDraft) {
  that.form = formDraft;
}
```

#### 2. 临时状态

```javascript
// 保存临时状态
vk.setSessionStorageSync("tempState", {
  step: 1,
  data: {}
});

// 读取临时状态
let tempState = vk.getSessionStorageSync("tempState");
```

#### 3. 页面间传递数据

```javascript
// 页面A存储数据
vk.setSessionStorageSync("pageData", {
  id: 123,
  name: "测试"
});

// 跳转到页面B
vk.navigateTo("/pages/pageB/index");

// 页面B读取数据
let pageData = vk.getSessionStorageSync("pageData");
```

## 最佳实践

### 1. 键名规范

```javascript
// 好的键名: 清晰、有层次
vk.setStorageSync("user_token", token);
vk.setStorageSync("user_info", userInfo);
vk.setStorageSync("app_settings", settings);

// 避免: 过于简短或无意义
vk.setStorageSync("t", token);
vk.setStorageSync("d", data);
```

### 2. 数据验证

```javascript
// 存储前验证数据
function setUserInfo(userInfo) {
  if (!userInfo || typeof userInfo !== "object") {
    console.error("用户信息格式错误");
    return;
  }
  vk.setStorageSync("user_info", userInfo);
}

// 获取后验证数据
function getUserInfo() {
  let userInfo = vk.getStorageSync("user_info");
  if (!userInfo) {
    return null;
  }
  return userInfo;
}
```

### 3. 错误处理

```javascript
// 捕获存储异常
try {
  vk.setStorageSync("key", value);
} catch (e) {
  console.error("存储失败:", e);
  // 可能是存储空间已满
  vk.pubfn.error("存储空间已满,请清理缓存");
}
```

### 4. 数据加密

```javascript
// 敏感数据加密存储
import CryptoJS from "crypto-js";

// 加密存储
function setSecureData(key, data) {
  let encrypted = CryptoJS.AES.encrypt(JSON.stringify(data), "secret-key").toString();
  vk.setStorageSync(key, encrypted);
}

// 解密读取
function getSecureData(key) {
  let encrypted = vk.getStorageSync(key);
  if (!encrypted) return null;
  
  let decrypted = CryptoJS.AES.decrypt(encrypted, "secret-key");
  return JSON.parse(decrypted.toString(CryptoJS.enc.Utf8));
}
```

### 5. 过期策略

```javascript
// 带过期时间的存储
function setStorageWithExpire(key, data, expireTime) {
  let value = {
    data: data,
    timestamp: Date.now(),
    expire: expireTime // 过期时间(毫秒)
  };
  vk.setStorageSync(key, value);
}

// 获取时检查过期
function getStorageWithExpire(key) {
  let value = vk.getStorageSync(key);
  if (!value) return null;
  
  if (Date.now() - value.timestamp > value.expire) {
    vk.removeStorageSync(key);
    return null;
  }
  
  return value.data;
}
```

### 6. 存储空间管理

```javascript
// 检查存储空间
function checkStorageSpace() {
  let info = vk.getStorageInfoSync();
  let usage = (info.currentSize / info.limitSize) * 100;
  
  if (usage > 80) {
    console.warn("存储空间不足:", usage + "%");
    vk.pubfn.warn("存储空间不足,建议清理缓存");
  }
  
  return usage;
}

// 清理过期缓存
function clearExpiredCache() {
  let keys = vk.getStorageInfoSync().keys;
  keys.forEach(key => {
    let value = vk.getStorageSync(key);
    if (value && value.expire && Date.now() - value.timestamp > value.expire) {
      vk.removeStorageSync(key);
    }
  });
}
```

## 平台差异

### H5 平台

- localStorage: 5MB 大小限制
- sessionStorage: 5MB 大小限制
- 数据存储在浏览器中,可能被清理

### App 平台

- localStorage: 使用原生 plus.storage,无大小限制
- sessionStorage: 不支持
- 数据持久化存储,不会被清理

### 微信小程序

- localStorage: 单个 key 最大 1MB,总共 10MB
- sessionStorage: 不支持
- 数据生命周期与小程序一致

### 支付宝小程序

- localStorage: 单条数据最大 200KB,总共 10MB
- sessionStorage: 不支持
- 数据生命周期与小程序一致

### 百度/抖音小程序

- localStorage: 策略详见官方文档
- sessionStorage: 不支持

## 常见问题

### Q: localStorage 和 sessionStorage 可以混用吗?

**A**: 可以,但要注意 sessionStorage 仅在H5端有效,其他端会报错。建议使用前判断平台:

```javascript
// #ifdef H5
vk.setSessionStorageSync("key", "value");
// #endif

// #ifndef H5
vk.setStorageSync("key", "value");
// #endif
```

### Q: 如何清除所有缓存?

**A**: 使用 `vk.clearStorageSync()` 清除所有 localStorage 数据:

```javascript
vk.clearStorageSync();
```

### Q: 存储空间满了怎么办?

**A**:
1. 清理不必要的缓存数据
2. 使用过期策略自动清理
3. 考虑将部分数据存储到云端

### Q: 如何监听存储变化?

**A**: vk-unicloud 框架没有提供监听API,但可以通过定时轮询实现:

```javascript
setInterval(() => {
  let value = vk.getStorageSync("key");
  if (value !== that.lastValue) {
    that.lastValue = value;
    // 处理变化
  }
}, 1000);
```

### Q: 存储的数据会被同步到其他设备吗?

**A**: 不会。localStorage 和 sessionStorage 都是本地存储,不会跨设备同步。如需同步,请使用云数据库。

### Q: 非App平台清空Storage会导致什么问题?

**A**: 会导致 `uni.getSystemInfo` 获取到的 `deviceId` 改变。如果业务依赖 `deviceId`,需要注意。
