# 全局请求参数配置

## 目录

- [什么是全局请求参数](#什么是全局请求参数)
- [方式一: setCustomClientInfo](#方式一-setcustomclientinfo)
- [方式二: updateRequestGlobalParam](#方式二-updaterequestglobalparam)
- [两种方式对比](#两种方式对比)
- [使用场景](#使用场景)

## 什么是全局请求参数

每次请求云函数都会额外带上这些参数。

**典型场景**: 多店系统中,每次请求都要带上 `shop_id`,就可以将 `shop_id` 设置为全局请求参数。设置后,就不需要在每个请求中手动传 `shop_id` 了。

## 方式一: setCustomClientInfo

**版本要求**: vk-unicloud ≥ 2.19.4

**特点**:
1. 全局参数与用户请求参数隔离,互不干扰,确保业务参数完整性
2. 云函数和云对象的获取方式有一定区别

### 前端设置方式

```javascript
// 设置示例(shop_id 为自定义字段,可按需修改字段名和值)
vk.setCustomClientInfo({
  shop_id: "001" // 此处仅为示例值,请替换为实际业务值
});
```

**重要提醒**:
- 重复调用时,**最后一次**设置的参数会覆盖之前的值
- 设置后所有 `vk.callFunction` 请求自动携带最新参数

### 云端获取方式

#### 云函数中获取

```javascript
// 通过 originalParam.context 获取自定义信息
const customClientInfo = originalParam.context.customInfo;
console.log('当前店铺ID:', customClientInfo.shop_id);
```

#### 云对象中获取

```javascript
// 使用 this.getCustomClientInfo() 获取参数
const customClientInfo = this.getCustomClientInfo();
console.log('当前店铺ID:', customClientInfo.shop_id);
```

#### 中间件中获取

```javascript
// 在中间件(过滤器、拦截器)中使用跟云函数一样的方式获取
const customClientInfo = originalParam.context.customInfo;
console.log('当前店铺ID:', customClientInfo.shop_id);
```

## 方式二: updateRequestGlobalParam

**特点**:
1. 基于正则表达式实现 URL 路由匹配,支持为不同接口路径动态配置差异化全局参数
2. 注入参数显式追加至 data,请求日志完整记录参数明细,确保传输过程可观测、可追溯
3. 云端获取参数的方式一致,均在 data 中获取

### 前端设置方式

```javascript
// 设置以 xxx/kh/ 开头的云函数 自动带上shop_id参数
vk.callFunctionUtil.updateRequestGlobalParam({
  "shop-manage": {
    regExp: "^xxx/kh/",
    data: {
      shop_id: shop_id
    }
  }
});
```

执行完上面的代码后,之后执行 `vk.callFunction` 时,如果 url 满足上面的正则表达式,则这些请求会自动带上 `shop_id` 参数。

**执行位置**: 写哪都可以,主要能执行就行

### 参数说明

| 参数 | 类型 | 必填 | 说明 |
| --- | --- | --- | --- |
| 配置标识 | String | 是 | 自定义命名空间,用于在单个请求中引用该配置 |
| regExp | RegExp、Array | 是 | 匹配云函数URL的正则表达式,支持数组形式 |
| data | Object | 是 | 需要自动添加的公共参数对象 |

### 特殊场景处理

对于不符合正则规则的云函数,在调用时添加 `globalParamName` 参数即可应用公共参数:

```javascript
vk.callFunction({
  url: 'xxx/xxxxxx',
  title: '请求中...',
  globalParamName: "shop-manage", // 引用配置标识
  data: {

  },
  success: (data) => {

  }
});
```

### 注意事项

1. **执行时机**: 确保 `updateRequestGlobalParam` 在云函数调用前执行
2. **参数合并**: 请求中的 data 参数会与全局参数自动合并,同名参数以请求参数优先
3. **多配置支持**: 可以同时配置多个不同的参数组,通过不同标识区分

### 云端获取方式

方式二的全局请求参数是和正常请求的 data 参数合并的,因此云端获取方式是一致的,均在 data 变量内获取即可。

```javascript
// 云函数中直接从 data 获取
const shop_id = data.shop_id;
```

## 两种方式对比

| 特性 | setCustomClientInfo | updateRequestGlobalParam |
| --- | --- | --- |
| **版本要求** | vk-unicloud ≥ 2.19.4 | 无版本限制 |
| **参数隔离** | 是,与业务参数分离 | 否,合并到 data 中 |
| **路由匹配** | 不支持,所有请求生效 | 支持,基于正则表达式 |
| **日志记录** | 不在请求日志中显示 | 在请求日志中完整显示 |
| **云端获取** | `originalParam.context.customInfo` | 直接从 `data` 获取 |
| **适用场景** | 简单全局参数 | 复杂路由匹配需求 |

## 使用场景

### 场景1: 多店系统

**需求**: 所有请求都需要带上 `shop_id`

**推荐**: 使用 `setCustomClientInfo`

```javascript
// 登录成功后设置
vk.setCustomClientInfo({
  shop_id: "001"
});

// 之后所有请求自动携带 shop_id
vk.callFunction({
  url: 'admin/order/sys/getList',
  data: {
    pageIndex: 1,
    pageSize: 10
  },
  success: (data) => {
    // 请求自动携带 shop_id
  }
});
```

### 场景2: 不同模块使用不同参数

**需求**: 客户管理模块用 `client_id`,商品管理模块用 `product_id`

**推荐**: 使用 `updateRequestGlobalParam`

```javascript
// 设置不同模块的全局参数
vk.callFunctionUtil.updateRequestGlobalParam({
  "client-manage": {
    regExp: "^admin/client/",
    data: { client_id: "001" }
  },
  "product-manage": {
    regExp: "^admin/product/",
    data: { product_id: "002" }
  }
});

// 客户管理请求自动携带 client_id
vk.callFunction({
  url: 'admin/client/sys/getList',
  data: { pageIndex: 1 },
  success: (data) => {}
});

// 商品管理请求自动携带 product_id
vk.callFunction({
  url: 'admin/product/sys/getList',
  data: { pageIndex: 1 },
  success: (data) => {}
});
```

### 场景3: 特定请求使用全局参数

**需求**: 大部分请求不需要全局参数,只有特定请求需要

**推荐**: 使用 `updateRequestGlobalParam` + `globalParamName`

```javascript
// 配置全局参数
vk.callFunctionUtil.updateRequestGlobalParam({
  "special-request": {
    regExp: "^admin/special/",
    data: { special_param: "value" }
  }
});

// 不匹配正则的请求,使用 globalParamName 引用
vk.callFunction({
  url: 'admin/other/action',
  globalParamName: "special-request", // 引用配置
  data: { /* 业务参数 */ },
  success: (data) => {}
});
```

### 场景4: 云对象中使用全局参数

**需求**: 在云对象中获取全局参数

**推荐**: 使用 `setCustomClientInfo`

```javascript
// 前端设置
vk.setCustomClientInfo({
  user_id: "123",
  shop_id: "456"
});

// 云对象中获取
module.exports = {
  _before() {
    // 获取全局参数
    const customInfo = this.getCustomClientInfo();
    console.log('用户ID:', customInfo.user_id);
    console.log('店铺ID:', customInfo.shop_id);
  },

  async getOrder() {
    // 使用全局参数
    const customInfo = this.getCustomClientInfo();
    const shopId = customInfo.shop_id;
    // 业务逻辑...
  }
}
```

## 最佳实践

### 1. 选择合适的方式

- **简单场景**: 使用 `setCustomClientInfo`
- **复杂路由**: 使用 `updateRequestGlobalParam`
- **云对象**: 使用 `setCustomClientInfo`

### 2. 参数命名规范

```javascript
// 好的命名: 清晰、有语义
vk.setCustomClientInfo({
  shop_id: "001",
  user_id: "123",
  platform: "app"
});

// 避免: 过于简短或无意义
vk.setCustomClientInfo({
  id: "001",
  p: "app"
});
```

### 3. 及时清理参数

```javascript
// 登出时清理全局参数
vk.setCustomClientInfo({});
```

### 4. 参数验证

```javascript
// 设置前验证参数
function setShopId(shopId) {
  if (!shopId) {
    console.error('shop_id 不能为空');
    return;
  }
  vk.setCustomClientInfo({ shop_id: shopId });
}
```

## 常见问题

### Q: 两种方式可以混用吗?

**A**: 可以,但不推荐。建议根据项目需求选择一种方式统一使用。

### Q: 全局参数会被覆盖吗?

**A**:
- `setCustomClientInfo`: 重复调用会覆盖
- `updateRequestGlobalParam`: 请求参数与全局参数合并时,请求参数优先

### Q: 如何查看当前设置的全局参数?

**A**: 可以在云函数中打印查看:

```javascript
// setCustomClientInfo 方式
console.log('全局参数:', originalParam.context.customInfo);

// updateRequestGlobalParam 方式
console.log('请求参数:', data);
```

### Q: 全局参数会影响性能吗?

**A**: 不会。全局参数在请求发送时自动注入,对性能影响可忽略不计。
