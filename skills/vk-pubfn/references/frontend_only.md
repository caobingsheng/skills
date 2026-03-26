# 前端专属函数详解

## getListData - 手机长列表分页加载

```javascript
/**
 * 手机端长列表分页加载数据
 * 自动处理下一页、数据合并、更新数据源
 * @param {Vue页面对象} that 页面数据对象this
 * @param {String} url 请求地址(云函数路径)
 * @param {String} listName 后端返回的list数组字段名，默认rows
 * @param {Object} data 额外数据
 * @param {function} dataPreprocess 数据预处理函数
 */

vk.pubfn.getListData({
  that: this,
  url: "db_test/pub/select",
  listName: "rows",
  data: {
    a: 1
  },
  dataPreprocess: (list) => {
    // 数据预处理
    return list;
  }
});
```

## getComponentsDynamicData - 动态组件数据获取

```javascript
/**
 * 动态组件数据获取
 * @param {Vue页面对象} that 页面数据对象this
 * @param {String} ids 动态数据组件的ID数组
 */

// 1. 在template中使用动态组件
<vk-u-notice-bar :datas='componentsDynamic["notice-bar-01"]'></vk-u-notice-bar>
<vk-u-swiper :datas='componentsDynamic["index-swiper-01"]'></vk-u-swiper>

// 2. 在data中定义componentsDynamic
data() {
  return {
    componentsDynamic: {}
  }
}

// 3. 在onLoad中调用
this.vk.pubfn.getComponentsDynamicData({
  that: this,
  ids: ["notice-bar-01", "index-swiper-01"]
});
```

## getCurrentPage - 获取当前页面实例

```javascript
/**
 * 获取当前页面实例
 * @return {Object} pageInfo
 */

let pageInfo = vk.pubfn.getCurrentPage();
// 返回：
{
  fullPath: "/pages/index/index?id=1",  // 完整路径(带参数)
  options: { id: "1" },                  // 页面参数
  route: "/pages/index/index",          // 页面路径
  $vm: vm                               // 页面vue实例
}
```

## fileToBase64 - 文件转base64

```javascript
/**
 * 文件转base64
 * @param {Object} file 文件对象
 * @param {Function} success 成功回调
 */

vk.pubfn.fileToBase64({
  file: res.tempFiles[0],
  success: (base64) => {
    console.log(base64);
  }
});
```

## base64ToFile - base64转文件

```javascript
/**
 * base64转文件
 * @param {String} base64 base64字符串
 * @param {Function} success 成功回调
 */

vk.pubfn.base64ToFile({
  base64: base64,
  success: (file) => {
    console.log(file);
  }
});
```

## parseXlsxFile - 前端解析Excel

> vk-unicloud核心库版本 >= 2.20.2 仅h5支持

```javascript
/**
 * 解析Excel文件数据（只支持xlsx格式）
 * @param {Object} file Excel文件对象
 * @param {Number} index 工作表索引，默认0
 * @param {Number} mode 返回格式：1-对象数组，2-二维数组
 * @return {Promise} result
 */

vk.pubfn.parseXlsxFile({
  file: file,
  index: 0,
  mode: 1
}).then((result) => {
  console.log(result);
}).catch((err) => {
  console.error(err);
});
```

## request - HTTP请求

### 前端调用

```javascript
vk.request({
  url: "https://www.xxx.com/api/xxxx",
  method: "POST",
  header: {
    "content-type": "application/json; charset=utf-8",
  },
  data: {
    a: 1
  },
  success: (data) => {
    console.log(data);
  },
  fail: (err) => {
    console.error(err);
  }
});
```

### 请求拦截器

```javascript
vk.request({
  url: "https://www.xxx.com/api/xxxx",
  method: "POST",
  data: {},
  interceptor: {
    invoke: (res) => {
      // 发起请求前拦截
      console.log('interceptor-invoke: ', res);
      if (!res.data) res.data = {};
      res.data.a = 1;
    },
    success: (res) => {
      // 成功回调前拦截
      console.log('interceptor-success: ', res);
    },
    fail: (res) => {
      // 失败回调前拦截
      console.log('interceptor-fail: ', res);
    },
    complete: (res) => {
      // 完成回调前拦截
      console.log('interceptor-complete: ', res);
    }
  },
  success: (data) => {},
  fail: (err) => {}
});
```

### 加密通信

```javascript
vk.request({
  url: "https://xxx.bspapp.com/http/router/test/pub/testEncryptRequest",
  encrypt: true, // 开启加密通信
  header: {
    'uni-id-token': '用户token',
    'vk-appid': '__UNI__AppID',
    'vk-platform': 'h5'
  },
  data: {
    a: 1,
    b: "2"
  }
});
```
