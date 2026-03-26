# Vuex 持久化配置

## 目录

- [概述](#概述)
- [什么是持久化Vuex](#什么是持久化vuex)
- [Vuex模块配置](#vuex模块配置)
- [使用方式](#使用方式)
- [监听数据变化](#监听数据变化)
- [版本升级](#版本升级)
- [最佳实践](#最佳实践)

## 概述

vk-unicloud 框架在 Vuex 的基础上进行了深度封装,使 Vuex 具有**持久化存储**能力。

**什么是 Vuex?**

Vuex 可以用来做全局状态(数据)的管理。

**什么是持久化 Vuex?**

持久化 Vuex 是 VK 框架在 Vuex 的基础上进行的深度封装,使 Vuex 具有**持久化存储**,需要先配置 Vuex。

## 什么是持久化 Vuex

传统 Vuex 的数据存储在内存中,刷新页面后数据会丢失。持久化 Vuex 会自动将数据保存到本地存储,刷新页面后数据仍然存在。

**优势**:
1. 数据持久化,刷新不丢失
2. 自动同步到本地存储
3. 简化状态管理代码

## Vuex 模块配置

### 配置文件位置

Vuex 配置文件在根目录的 `store/modules/` 目录下,每一个 `.js` 文件都是一个 Vuex 模块。

如 `$user.js` 代表用户模块。

### 模块结构

```javascript
/**
 * vuex 用户状态管理模块
 */
let lifeData = uni.getStorageSync('lifeData') || {};
let $user = lifeData.$user || {};

export default {
  // 通过添加 namespaced: true 的方式使其成为带命名空间的模块
  namespaced: true,
  
  /**
   * vuex的基本数据,用来存储变量
   */
  state: {
    userInfo: $user.userInfo || {},
    permission: $user.permission || [],
  }
}
```

**重要提示**:
- 所有变量名**必须提前声明**,这样才能持久化存储
- 变量名从 `lifeData` 中读取,如果不存在则使用默认值

### 模块示例

#### 用户模块 ($user.js)

```javascript
let lifeData = uni.getStorageSync('lifeData') || {};
let $user = lifeData.$user || {};

export default {
  namespaced: true,
  state: {
    userInfo: $user.userInfo || {},
    token: $user.token || "",
    permission: $user.permission || [],
  }
}
```

#### 应用模块 ($app.js)

```javascript
let lifeData = uni.getStorageSync('lifeData') || {};
let $app = lifeData.$app || {};

export default {
  namespaced: true,
  state: {
    config: $app.config || {},
    theme: $app.theme || "light",
  }
}
```

## 使用方式

vk-unicloud 框架提供了两种方式操作 Vuex 数据:

### 方式一: 简化写法(推荐)

如果只是获取或更新 Vuex 数据,推荐使用方式一的写法。

#### 获取数据

```javascript
// 获取 Vuex 数据
let userInfo = vk.getVuex('$user.userInfo');

// 获取嵌套属性
let avatar = vk.getVuex('$user.userInfo.avatar');

// 获取数组元素
let permission = vk.getVuex('$user.permission[0]');
```

#### 更新数据

```javascript
// 更新整个对象
vk.setVuex('$user.userInfo', {
  id: 1,
  name: "张三"
});

// 更新嵌套属性
vk.setVuex('$user.userInfo.avatar', avatar);

// 更新数组元素
vk.setVuex('$user.permission[0]', "read");
```

### 方式二: 完整写法

如果需要用到 `getters`、`commit`、`dispatch`,则用方式二写法(可以与方式一混用)。

#### 获取数据

```javascript
// 获取 Vuex 数据
let userInfo = vk.vuex.get('$user.userInfo');

// 获取 Vuex getters 数据
let data = vk.vuex.getters('$user/getUserInfo');

// 获取 Vuex getters 数据(带参数)
let data = vk.vuex.getters('$user/getUserInfo', params);
```

#### 更新数据

```javascript
// 更新 Vuex 数据
vk.vuex.set('$user.userInfo.avatar', avatar);
```

#### 提交 Mutations

```javascript
// 提交 Vuex mutations
vk.vuex.commit('$user/addFootprint', data);
```

#### 触发 Actions

```javascript
// 触发 Vuex actions
vk.vuex.dispatch('$user/addFootprint', data);
```

### 两种方式对比

| 功能 | 方式一 | 方式二 |
| --- | --- | --- |
| **获取数据** | `vk.getVuex()` | `vk.vuex.get()` |
| **更新数据** | `vk.setVuex()` | `vk.vuex.set()` |
| **Getters** | 不支持 | `vk.vuex.getters()` |
| **Mutations** | 不支持 | `vk.vuex.commit()` |
| **Actions** | 不支持 | `vk.vuex.dispatch()` |
| **适用场景** | 简单数据读写 | 复杂状态管理 |

### 优势说明

使用 `vk.getVuex()` 和 `vk.setVuex()` 比原生 Vuex 写法的优势:

#### 优势一: 避免异常

原生写法当某一级属性为 `undefined` 时,js 会报异常:

```javascript
// 原生写法(可能报错)
let avatar = this.$store.state.$user.userInfo.avatar;
// 如果 $user 或 userInfo 为 undefined,会报错

// vk写法(安全)
let avatar = vk.getVuex('$user.userInfo.avatar');
// 如果某一级为 undefined,不会报异常,直接返回空
```

#### 优势二: 避免警告

原生写法获取到的值如果在外部赋值,严格模式下控制台会有黄色警告:

```javascript
// 原生写法(可能有警告)
let userInfo = this.$store.state.$user.userInfo;
userInfo.name = "张三"; // 严格模式下会有警告

// vk写法(无警告)
let userInfo = vk.getVuex('$user.userInfo');
userInfo.name = "张三"; // 不会有警告
```

## 监听数据变化

### 在 Vue 页面中监听

使用 `watch` 监听 Vuex 数据变化:

```javascript
export default {
  data() {
    return {
      watchStr: ""
    };
  },
  watch: {
    "$store.state.$user.test": {
      deep: true, // 如果是对象,需要深度监听设置为 true
      handler: function(newVal, oldVal) {
        this.watchStr = `数据发生变化啦,值从 ${oldVal} 变为 ${newVal}`;
        console.log(this.watchStr);
      }
    }
  }
}
```

### 完整示例

```vue
<template>
  <view class="app">
    <view>
      <text>当前的 $user.test 值:</text>
      <text>{{ vk.getVuex("$user.test") }}</text>
    </view>
    <view>
      <button @click="vk.setVuex('$user.test', 1)">设置值为1</button>
      <button @click="vk.setVuex('$user.test', 2)">设置值为2</button>
      <button @click="vk.setVuex('$user.test', 3)">设置值为3</button>
    </view>
    <view v-if="watchStr">
      <text>{{ watchStr }}</text>
    </view>
  </view>
</template>

<script>
let vk = uni.vk;

export default {
  data() {
    return {
      watchStr: ""
    };
  },
  onLoad(options) {
    vk = uni.vk;
  },
  watch: {
    "$store.state.$user.test": {
      deep: true,
      handler: function(newVal, oldVal) {
        this.watchStr = `数据发生变化啦,值从 ${oldVal} 变为 ${newVal}`;
        console.log(this.watchStr);
      }
    }
  }
};
</script>
```

## 版本升级

### 老版本 Vuex 如何升级新版本 Vuex

Vuex 非框架必须集成,若你的 Vuex 有很多页面在使用,可能升级起来比较复杂,也可选择不升级。

#### main.js 变动

**老版本**:
```javascript
import storeUtil from './store/lib/index'

Vue.prototype.vk.init({
  Vue,
  config,
  store: storeUtil, // vuex简写法则
});
```

**新版本**:
```javascript
Vue.prototype.vk.init({
  Vue,
  config,
  // 不需要 store 参数
});
```

#### 文件变动

删除以下目录:
- `/store/lib` 目录
- `/store/mixin` 目录

#### 代码变动

**获取数据**:
```javascript
// 老版本
vk.state('$user').userInfo.avatar;

// 新版本
vk.getVuex('$user.userInfo.avatar');
// 或
vk.vuex.get('$user.userInfo.avatar');
```

**更新数据**:
```javascript
// 老版本
vk.vuex('$user.userInfo.avatar', avatar);

// 新版本
vk.setVuex('$user.userInfo.avatar', avatar);
// 或
vk.vuex.set('$user.userInfo.avatar', avatar);
```

**模板中使用**:
```javascript
// 老版本
{{ $user.userInfo.avatar }}

// 新版本
{{ vk.getVuex('$user.userInfo.avatar') }}
// 或
{{ vk.vuex.get('$user.userInfo.avatar') }}
```

## Getters 使用

### 定义 Getters

在 Vuex 模块中定义 getters:

```javascript
export default {
  namespaced: true,
  state: {
    userInfo: {},
    permission: [],
  },
  getters: {
    // 不带参数的 getter
    getUserInfo: (state) => {
      return state.userInfo;
    },
    
    // 带参数的 getter
    getPermissionById: (state) => (id) => {
      return state.permission.find(item => item.id === id);
    }
  }
}
```

### 使用 Getters

#### 在 JavaScript 中使用

```javascript
// 不带参数
let userInfo = vk.vuex.getters('$user/getUserInfo');

// 带参数
let permission = vk.vuex.getters('$user/getPermissionById', '001');
```

#### 在模板中使用

```vue
<template>
  <view>
    <!-- 不带参数 -->
    <text>{{ vk.vuex.getters('$user/getUserInfo') }}</text>
    
    <!-- 带参数 -->
    <text>{{ vk.vuex.getters('$user/getPermissionById', '001') }}</text>
  </view>
</template>
```

## 最佳实践

### 1. 模块划分

按功能模块划分 Vuex 状态:

```
store/modules/
├── $user.js       # 用户模块
├── $app.js        # 应用模块
├── $cart.js       # 购物车模块
└── $order.js      # 订单模块
```

### 2. 命名规范

```javascript
// 好的命名: 清晰、有层次
vk.getVuex('$user.userInfo.avatar');
vk.getVuex('$app.config.theme');

// 避免: 过于简短或无层次
vk.getVuex('avatar');
vk.getVuex('theme');
```

### 3. 数据初始化

```javascript
// 在模块中声明所有变量
export default {
  namespaced: true,
  state: {
    // 必须提前声明所有变量
    userInfo: {},
    token: "",
    permission: [],
    // 不要在使用时动态添加
  }
}
```

### 4. 避免过度使用

```javascript
// 不推荐: 所有数据都放 Vuex
vk.setVuex('$user.allData', {
  userInfo: {},
  orderList: [],
  cartList: [],
  // ...
});

// 推荐: 只放全局共享的数据
vk.setVuex('$user.userInfo', userInfo);
// 其他数据放在组件 data 中
```

### 5. 性能优化

**为什么新版本去除了全局混入的方式?**

全局混入的方式虽然使用起来更加方便,但是会严重影响小程序端的渲染性能。

经过极端测试,若 1 个页面有 1000 个自定义组件(比如 1000 个 `u-button` 组件),此时若 Vuex 内的数据有 20kb,则这个页面的渲染数据达 1000 * 20KB 接近 20MB,测试下来,渲染时间要 5 秒左右,严重影响小程序页面加载时间。

而使用新方案,则不会影响页面加载时间。

## 常见问题

### Q: Vuex 模块文件保存在哪里?

**A**: 保存在 `/store/modules/` 目录下。

### Q: 如何演示 Vuex 功能?

**A**: 示例页面在 `/pages_template/vk-vuex/vk-vuex.vue`。

### Q: getters 内的属性如何带参数?

**A**: 返回一个函数:

```javascript
getters: {
  getUserInfo: (state) => (a, b) => {
    console.log("参数", a, b);
    return state.userInfo;
  }
}
```

使用:
```javascript
// template 内
<text>{{ vk.vuex.getters('$user/getUserInfo', 1, 2) }}</text>

// js 内
vk.vuex.getters('$user/getUserInfo', 1, 2);
```

### Q: 如何清空 Vuex 数据?

**A**: 清空本地存储:

```javascript
uni.removeStorageSync('lifeData');
```

### Q: Vuex 数据会占用多少存储空间?

**A**: 取决于存储的数据量。建议只存储必要的全局数据,避免存储大量数据。

### Q: 如何在云函数中访问 Vuex 数据?

**A**: Vuex 是客户端状态管理,云函数无法直接访问。如需在云函数中使用,需要通过请求参数传递。
