# 弹窗和页面跳转详解

## 弹窗函数

### alert - 警告弹窗

```javascript
// 简写
vk.alert("内容");

// 完整写法
vk.alert("内容", "提示", "确定", () => {
  // 点击确定后的回调
});

// 多行显示
vk.alert('第一行内容\n第二行内容\n第三行内容');
```

### confirm - 确认弹窗

```javascript
// 简写
vk.confirm("内容", (res) => {
  if (res.confirm) {
    // 点击确定
  }
});

// 完整写法
vk.confirm("内容", "提示", "确定", "取消", (res) => {
  if (res.confirm) {
    // 点击确定
  }
});
```

### prompt - 输入弹窗

```javascript
// 简写
vk.prompt("请输入", (res) => {
  if (res.confirm) {
    console.log(res.content); // 输入的内容
  }
});

// 完整写法
vk.prompt("请输入", "提示", "确定", "取消", (res) => {
  if (res.confirm) {
    console.log(res.content);
  }
}, "初始内容");
```

### toast - 轻提示

```javascript
// 简写
vk.toast("提示内容");

// 带图标
vk.toast("提示内容", "success"); // 成功图标
vk.toast("提示内容", "/static/1.png"); // 自定义图片

// 修改时间延迟
vk.toast("提示内容", "none", 1000); // 1秒

// 带回调函数
vk.toast("提示内容", "none", () => {
  // 提示结束后回调
});

// 去除遮罩
vk.toast("提示内容", "none", false);

// 全参数完整写法
vk.toast("提示内容", "none", 1000, true, () => {
  // 回调
});
```

### showActionSheet - 操作菜单

```javascript
vk.showActionSheet({
  title: "", // 可选
  list: ["选项1", "选项2", "选项3"],
  color: "#000000",
  success: (res) => {
    if (res.index === 0) {
      // 点击选项1
    } else if (res.index === 1) {
      // 点击选项2
    }
  }
});
```

### showLoading / hideLoading

```javascript
// 显示加载
vk.showLoading("加载中...");

// 隐藏加载
vk.hideLoading();
```

## 页面跳转函数

> 使用 vk.navigateTo 系列函数会自动检测是否需要登录

### navigateTo - 跳转页面

```javascript
// 基础跳转
vk.navigateTo("/pages/user/detail");

// 带参数
vk.navigateTo("/pages/user/detail?id=1&name=张三");

// 页面间通信
vk.navigateTo({
  url: "/pages/user/detail",
  events: {
    // 监听被打开页面传送的数据
    updateData: (data) => {
      console.log("收到数据:", data);
    }
  },
  success: (res) => {
    // 通过eventChannel向被打开页面传送数据
    res.eventChannel.emit("sendData", { a: 1 });
  }
});
```

### redirectTo - 关闭当前页跳转

```javascript
vk.redirectTo("/pages/user/detail");
```

### reLaunch - 关闭所有页面跳转

```javascript
vk.reLaunch("/pages/index/index");
```

### switchTab - 跳转tabBar页面

```javascript
vk.switchTab("/pages/index/index");
```

### navigateBack - 返回上一页

```javascript
vk.navigateBack(); // 返回一层
vk.navigateBack({ delta: 2 }); // 返回两层
```

### navigateToHome - 跳转到首页

```javascript
vk.navigateToHome();
```

### navigateToLogin - 跳转到登录页

```javascript
// 默认：关闭所有页面，跳转到登录页
vk.navigateToLogin();

// 不关闭页面，直接跳转到登录页，登录成功自动返回当前页面
vk.navigateToLogin({
  mode: "navigateTo"
});

// 带参数
vk.navigateToLogin({
  mode: "navigateTo",
  query: "a=1&b=2",
  events: {
    loginSuccess: () => {
      console.log("登录成功");
    }
  }
});

// 关闭所有页面，登录成功返回当前页面
vk.navigateToLogin({
  needBack: true
});

// 关闭所有页面，登录成功返回指定页面
vk.navigateToLogin({
  redirectUrl: "/pages/index/index"
});
```

### checkLogin - 检测是否需要登录

```javascript
// 在首页检测
setTimeout(() => {
  vk.pubfn.checkLogin();
}, 0);
```

## 页面间通信详解

### A页面跳转B页面并通信

```javascript
// A页面
vk.navigateTo({
  url: "/pages/detail/detail",
  events: {
    // 监听B页面返回时传送的数据
    onBackData: (data) => {
      console.log("收到B页面数据:", data);
    }
  },
  success: (res) => {
    // 向B页面传送数据
    res.eventChannel.emit("fromA", { a: 1 });
  }
});

// B页面 onLoad中接收
onLoad(options = {}) {
  const eventChannel = this.getOpenerEventChannel();
  // 监听A页面传送的数据
  eventChannel.on("fromA", (data) => {
    console.log("收到A页面数据:", data);
  });
}

// B页面返回时触发A页面逻辑
const eventChannel = this.getOpenerEventChannel();
if (eventChannel.emit) {
  eventChannel.emit("onBackData", { b: 2 });
}
vk.navigateBack();
```

## 事件函数

### notifyEventReady - 通知事件就绪

```javascript
vk.notifyEventReady("事件名", {
  a: 1,
  b: "2"
});
```

### awaitEventReady - 等待事件执行

```javascript
// 回调形式
vk.awaitEventReady("事件名", (data) => {
  console.log(data);
});

// Promise形式
vk.awaitEventReady("事件名").then((data) => {
  console.log(data);
});

// async/await形式
let data = await vk.awaitEventReady("事件名");
```

### checkEventReady - 检查事件是否就绪

```javascript
if (vk.checkEventReady("事件名")) {
  console.log("已就绪");
} else {
  console.log("未就绪");
}
```

### getEventReadyData - 获取事件就绪数据

```javascript
let data = vk.getEventReadyData("事件名");
console.log(data); // 未就绪返回null
```

## 全局配置

### getConfig - 获取配置

```javascript
// 获取所有配置
let config = vk.getConfig();

// 获取指定配置
let url = vk.getConfig("login.url");
```
