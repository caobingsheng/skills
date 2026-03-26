# app.config.js 配置说明

## 目录

- [完整配置示例](#完整配置示例)
- [核心配置项](#核心配置项)
- [云存储配置](#云存储配置)
- [页面权限配置](#页面权限配置)
- [全局错误码](#全局错误码)
- [自定义拦截器](#自定义拦截器)

## 完整配置示例

```javascript
// 引入自定义公共函数
import myPubFunction from '@/common/function/myPubFunction.js'

export default {
  // 开发模式启用调式模式(请求时会打印日志)
  debug: process.env.NODE_ENV !== 'production',

  // 主云函数名称
  functionName: "router",

  // 登录页面路径
  login: {
    url: '/pages_template/uni-id/login/index/index'
  },

  // 首页页面路径
  index: {
    url: '/pages/index/index'
  },

  // 404 Not Found 错误页面路径
  error: {
    url: '/pages/error/404/404'
  },

  // 前端默认时区(中国为8)
  targetTimezone: 8,

  // 日志风格
  logger: {
    colorArr: ["#0095f8", "#67C23A"]
  },

  /**
   * app主题颜色
   * vk.getVuex('$app.config.color.main')
   * vk.getVuex('$app.config.color.secondary')
   */
  color: {
    main: "#ff4444",
    secondary: "#555555"
  },

  // 需要检查是否登录的页面列表
  checkTokenPages: {
    /**
     * mode = 0: 自动检测
     * mode = 1: list内的页面需要登录,不在list内的页面不需要登录
     * mode = 2: list内的页面不需要登录,不在list内的页面需要登录
     *
     * 注意:
     * 1. list内是通配符表达式,非正则表达式
     * 2. 需要使用 vk.navigateTo 代替 uni.navigateTo 进行页面跳转才会生效
     * 3. tabbar 页面需要手动在 onLoad 里加 vk.pubfn.checkLogin()
     */
    mode: 2,
    list: [
      "/pages_template/*",
      "/pages/login/*",
      "/pages/index/*",
      "/pages/error/*"
    ]
  },

  // 需要检查是否可以分享的页面列表(仅小程序有效)
  checkSharePages: {
    /**
     * mode = 0: 不做处理
     * mode = 1: list内的页面可以被分享,不在list内的页面不可以被分享
     * mode = 2: list内的页面不可以被分享,不在list内的页面可以被分享
     *
     * 注意: list内是通配符表达式,非正则表达式
     */
    mode: 0,
    menus: ['shareAppMessage'],
    list: [
      "/pages/index/*",
      "/pages/goods/*",
      "/pages_template/*",
    ]
  },

  // 需要检查是否哪些请求需要加密通信
  checkEncryptRequest: {
    /**
     * mode = 0: 不做处理
     * mode = 1: list内的云函数或云对象需要加密通信,不在list内的不需要加密通信
     *
     * 注意:
     * 1. list内是正则表达式,非通配符表达式
     * 2. 建议与 router/middleware/modules/encryptFilter.js 内的regExp保持一致
     */
    mode: 1,
    list: [
      "^template/test/pub/testEncryptRequest$",
      "^template/encrypt/(.*)",
    ]
  },

  // 静态文件的资源URL地址
  staticUrl: {
    logo: '/static/logo.png',
  },

  // 自定义公共函数
  // myPubFunction内的函数可通过 vk.myfn.xxx() 调用
  myfn: myPubFunction,

  // 第三方服务配置
  service: {
    // 云储存相关配置
    cloudStorage: {
      /**
       * vk.uploadFile 接口默认使用哪个存储
       * unicloud: 空间内置存储(默认)
       * extStorage: 扩展存储
       * aliyun: 阿里云oss
       */
      defaultProvider: "unicloud",

      // 空间内置存储
      unicloud: {
        // 暂无配置项
      },

      // 扩展存储配置
      extStorage: {
        provider: "qiniu", // qiniu: 扩展存储-七牛云
        dirname: "public", // 根目录名称
        authAction: "user/pub/getUploadFileOptionsForExtStorage", // 鉴权云函数
        domain: "", // 自定义域名
        groupUserId: false, // 是否按用户id分组储存
      },

      // 阿里云oss
      aliyun: {
        // 密钥和签名信息
        uploadData: {
          OSSAccessKeyId: "",
          policy: "",
          signature: "",
        },
        action: "https://xxx.oss-cn-hangzhou.aliyuncs.com", // oss上传地址
        dirname: "public", // 根目录名称
        host: "https://xxx.xxx.com", // oss外网访问地址
        groupUserId: false, // 是否按用户id分组储存
      }
    }
  },

  // 全局异常码自定义提示
  globalErrorCode: {
    "cloudfunction-unusual-timeout": "请求超时,但请求还在执行,请重新进入页面。",
    "cloudfunction-timeout": "请求超时,请重试!",
    "cloudfunction-system-error": "网络开小差了!",
    "cloudfunction-reaches-burst-limit": "系统繁忙,请稍后再试。",
    "cloudfunction-network-unauthorized": "需要进行网络请求许可,若您已授权,请点击确定"
  },

  // 自定义拦截器
  interceptor: {
    // login: function(obj) {
    //   let { vk, params, res } = obj;
    //   if (!params.noAlert) {
    //     vk.alert(res.msg);
    //   }
    //   console.log("跳自己的登录页面");
    // },

    // fail: function(obj) {
    //   let { vk, params, res } = obj;
    //   return false; // 返回false则取消框架内置fail的逻辑
    // }
  }
}
```

## 核心配置项

### debug
- **类型**: Boolean
- **默认值**: `process.env.NODE_ENV !== 'production'`
- **说明**: 开发模式下会打印请求日志

### functionName
- **类型**: String
- **默认值**: `"router"`
- **说明**: 主云函数名称

### login / index / error
- **类型**: Object
- **说明**: 定义登录页、首页、错误页的路径

### targetTimezone
- **类型**: Number
- **默认值**: `8`
- **说明**: 前端默认时区,中国为8

## 云存储配置

### defaultProvider
指定 `vk.uploadFile` 默认使用的存储方式:

- `unicloud`: 空间内置存储(默认)
- `extStorage`: 扩展存储(七牛云等)
- `aliyun`: 阿里云 OSS

### extStorage 配置

```javascript
extStorage: {
  provider: "qiniu", // qiniu: 扩展存储-七牛云
  dirname: "public", // 根目录名称
  authAction: "user/pub/getUploadFileOptionsForExtStorage", // 鉴权云函数
  domain: "", // 自定义域名(如: cdn.example.com)
  groupUserId: false, // 是否按用户id分组储存
}
```

### aliyun 配置

```javascript
aliyun: {
  uploadData: {
    OSSAccessKeyId: "",
    policy: "",
    signature: "",
  },
  action: "https://xxx.oss-cn-hangzhou.aliyuncs.com",
  dirname: "public",
  host: "https://xxx.xxx.com",
  groupUserId: false,
}
```

详见 [文件上传完整指南](upload-file.md)

## 页面权限配置

### checkTokenPages

控制哪些页面需要登录才能访问:

```javascript
checkTokenPages: {
  mode: 2, // 0:自动检测 1:list内需要登录 2:list内不需要登录
  list: [
    "/pages_template/*",
    "/pages/login/*",
  ]
}
```

**注意事项**:
1. list 内是通配符表达式,非正则表达式
2. 需要使用 `vk.navigateTo` 代替 `uni.navigateTo`
3. tabbar 页面需要手动在 `onLoad` 里加 `vk.pubfn.checkLogin()`

### checkSharePages

控制哪些页面可以分享(仅小程序有效):

```javascript
checkSharePages: {
  mode: 0, // 0:不做处理 1:list内可分享 2:list内不可分享
  menus: ['shareAppMessage'],
  list: [
    "/pages/index/*",
    "/pages/goods/*",
  ]
}
```

### checkEncryptRequest

控制哪些请求需要加密通信:

```javascript
checkEncryptRequest: {
  mode: 1, // 0:不做处理 1:list内需要加密
  list: [
    "^template/test/pub/testEncryptRequest$",
    "^template/encrypt/(.*)",
  ]
}
```

**注意**: list 内是正则表达式

## 全局错误码

自定义全局错误码的提示信息:

```javascript
globalErrorCode: {
  "cloudfunction-unusual-timeout": "请求超时,但请求还在执行,请重新进入页面。",
  "cloudfunction-timeout": "请求超时,请重试!",
  "cloudfunction-system-error": "网络开小差了!",
  "cloudfunction-reaches-burst-limit": "系统繁忙,请稍后再试。",
  "cloudfunction-network-unauthorized": "需要进行网络请求许可",
}
```

## 自定义拦截器

### login 拦截器

在需要登录时触发:

```javascript
interceptor: {
  login: function(obj) {
    let { vk, params, res } = obj;
    if (!params.noAlert) {
      vk.alert(res.msg);
    }
    console.log("跳自己的登录页面");
  }
}
```

### fail 拦截器

在请求失败时触发:

```javascript
interceptor: {
  fail: function(obj) {
    let { vk, params, res } = obj;
    // 返回false则取消框架内置fail的逻辑
    return false;
  }
}
```

## 自定义公共函数

引入自定义公共函数,通过 `vk.myfn.xxx()` 调用:

```javascript
// 引入自定义公共函数
import myPubFunction from '@/common/function/myPubFunction.js'

export default {
  // myPubFunction内的函数可通过 vk.myfn.xxx() 调用
  myfn: myPubFunction,
}
```

使用示例:

```javascript
// 调用自定义函数
vk.myfn.myCustomFunction();
```
