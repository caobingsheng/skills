# vk.pubfn 工具函数完整指南

## 目录

- [概述](#概述)
- [timeUtil - 日期时间工具](#timeutil---日期时间工具)
- [testUtil - 数据验证工具](#testutil---数据验证工具)
- [strUtil - 字符串工具](#strutil---字符串工具)
- [arrayUtil - 数组工具](#arrayutil---数组工具)
- [objectUtil - 对象工具](#objectutil---对象工具)
- [其他工具函数](#其他工具函数)

## 概述

vk.pubfn 是 vk-unicloud 框架提供的客户端工具函数库,包含日期时间处理、数据验证、字符串处理等常用功能。

**使用方式**:

```javascript
let vk = uni.vk;

// 调用工具函数
vk.pubfn.timeUtil.getNowTime();
vk.pubfn.testUtil.isPhone("13800138000");
```

## timeUtil - 日期时间工具

### 获取当前时间

```javascript
// 获取当前时间字符串
let timeStr = vk.pubfn.timeUtil.getNowTime();
// 返回: "2024-01-23 12:00:00"

// 获取当前时间戳
let timestamp = vk.pubfn.timeUtil.getTimestamp();
// 返回: 1705977600000
```

### 时间格式化

```javascript
// 格式化时间戳
let dateStr = vk.pubfn.timeUtil.formatTime(1705977600000);
// 返回: "2024-01-23 12:00:00"

// 自定义格式
let dateStr = vk.pubfn.timeUtil.formatTime(1705977600000, "YYYY-MM-DD");
// 返回: "2024-01-23"
```

### 时间判断

```javascript
// 判断是否是清明节
let isQingming = vk.pubfn.timeUtil.isQingming();
// 返回: true 或 false

// 判断是否是今天
let isToday = vk.pubfn.timeUtil.isToday("2024-01-23");
// 返回: true 或 false
```

### 时间计算

```javascript
// 获取几天前的时间
let dateStr = vk.pubfn.timeUtil.getBeforeDate(7);
// 返回: 7天前的日期字符串

// 获取几天后的时间
let dateStr = vk.pubfn.timeUtil.getAfterDate(7);
// 返回: 7天后的日期字符串
```

## testUtil - 数据验证工具

### 手机号验证

```javascript
// 验证手机号
let isPhone = vk.pubfn.testUtil.isPhone("13800138000");
// 返回: true

let isPhone = vk.pubfn.testUtil.isPhone("12345");
// 返回: false
```

### 邮箱验证

```javascript
// 验证邮箱
let isEmail = vk.pubfn.testUtil.isEmail("test@example.com");
// 返回: true

let isEmail = vk.pubfn.testUtil.isEmail("test@example");
// 返回: false
```

### 身份证验证

```javascript
// 验证身份证号
let isIdCard = vk.pubfn.testUtil.isIdCard("110101199001011234");
// 返回: true

let isIdCard = vk.pubfn.testUtil.isIdCard("123456");
// 返回: false
```

### URL 验证

```javascript
// 验证URL
let isUrl = vk.pubfn.testUtil.isUrl("https://www.example.com");
// 返回: true

let isUrl = vk.pubfn.testUtil.isUrl("www.example.com");
// 返回: false
```

### 数字验证

```javascript
// 验证是否为数字
let isNumber = vk.pubfn.testUtil.isNumber("123");
// 返回: true

let isNumber = vk.pubfn.testUtil.isNumber("123abc");
// 返回: false

// 验证是否为整数
let isInt = vk.pubfn.testUtil.isInt("123");
// 返回: true

let isInt = vk.pubfn.testUtil.isInt("123.45");
// 返回: false
```

### 其他验证

```javascript
// 验证是否为空
let isEmpty = vk.pubfn.testUtil.isEmpty("");
// 返回: true

let isEmpty = vk.pubfn.testUtil.isEmpty("123");
// 返回: false

// 验证是否为中文
let isChinese = vk.pubfn.testUtil.isChinese("中文");
// 返回: true

let isChinese = vk.pubfn.testUtil.isChinese("abc");
// 返回: false
```

## strUtil - 字符串工具

### 去除空格

```javascript
// 去除首尾空格
let str = vk.pubfn.strUtil.trim("  hello  ");
// 返回: "hello"

// 去除所有空格
let str = vk.pubfn.strUtil.trimAll("  he ll o  ");
// 返回: "hello"
```

### 字符串截取

```javascript
// 截取字符串
let str = vk.pubfn.strUtil.substring("hello world", 0, 5);
// 返回: "hello"

// 按字节截取
let str = vk.pubfn.strUtil.substringByte("hello world", 5);
// 返回: "hello"
```

### 字符串转换

```javascript
// 转大写
let str = vk.pubfn.strUtil.toUpperCase("hello");
// 返回: "HELLO"

// 转小写
let str = vk.pubfn.strUtil.toLowerCase("HELLO");
// 返回: "hello"

// 首字母大写
let str = vk.pubfn.strUtil.capitalize("hello");
// 返回: "Hello"
```

### 字符串判断

```javascript
// 判断是否包含
let hasStr = vk.pubfn.strUtil.contains("hello world", "world");
// 返回: true

// 判断是否以...开头
let startsWith = vk.pubfn.strUtil.startsWith("hello world", "hello");
// 返回: true

// 判断是否以...结尾
let endsWith = vk.pubfn.strUtil.endsWith("hello world", "world");
// 返回: true
```

## arrayUtil - 数组工具

### 数组去重

```javascript
// 数组去重
let arr = vk.pubfn.arrayUtil.unique([1, 2, 2, 3, 3, 4]);
// 返回: [1, 2, 3, 4]
```

### 数组排序

```javascript
// 数组排序
let arr = vk.pubfn.arrayUtil.sort([3, 1, 2]);
// 返回: [1, 2, 3]

// 数组倒序
let arr = vk.pubfn.arrayUtil.reverse([1, 2, 3]);
// 返回: [3, 2, 1]
```

### 数组查找

```javascript
// 查找元素索引
let index = vk.pubfn.arrayUtil.indexOf([1, 2, 3], 2);
// 返回: 1

// 查找元素
let item = vk.pubfn.arrayUtil.find([{id: 1}, {id: 2}], {id: 2});
// 返回: {id: 2}
```

### 数组操作

```javascript
// 数组求和
let sum = vk.pubfn.arrayUtil.sum([1, 2, 3, 4, 5]);
// 返回: 15

// 数组最大值
let max = vk.pubfn.arrayUtil.max([1, 2, 3, 4, 5]);
// 返回: 5

// 数组最小值
let min = vk.pubfn.arrayUtil.min([1, 2, 3, 4, 5]);
// 返回: 1

// 数组平均值
let avg = vk.pubfn.arrayUtil.avg([1, 2, 3, 4, 5]);
// 返回: 3
```

## objectUtil - 对象工具

### 对象合并

```javascript
// 对象合并
let obj = vk.pubfn.objectUtil.assign({a: 1}, {b: 2});
// 返回: {a: 1, b: 2}

// 深度合并
let obj = vk.pubfn.objectUtil.merge({a: {b: 1}}, {a: {c: 2}});
// 返回: {a: {b: 1, c: 2}}
```

### 对象克隆

```javascript
// 浅克隆
let obj = vk.pubfn.objectUtil.clone({a: 1, b: 2});
// 返回: {a: 1, b: 2}

// 深克隆
let obj = vk.pubfn.objectUtil.deepClone({a: {b: 1}});
// 返回: {a: {b: 1}}
```

### 对象操作

```javascript
// 获取对象所有键
let keys = vk.pubfn.objectUtil.keys({a: 1, b: 2});
// 返回: ["a", "b"]

// 获取对象所有值
let values = vk.pubfn.objectUtil.values({a: 1, b: 2});
// 返回: [1, 2]

// 判断对象是否为空
let isEmpty = vk.pubfn.objectUtil.isEmpty({});
// 返回: true

let isEmpty = vk.pubfn.objectUtil.isEmpty({a: 1});
// 返回: false
```

## 其他工具函数

### 检查登录

```javascript
// 检查是否登录
vk.pubfn.checkLogin();
// 如果未登录,会跳转到登录页面
```

### 页面跳转

```javascript
// 页面跳转(带登录检查)
vk.pubfn.navigateTo("/pages/index/index");

// 页面重定向(带登录检查)
vk.pubfn.redirectTo("/pages/login/index");
```

### 提示信息

```javascript
// 成功提示
vk.pubfn.success("操作成功");

// 错误提示
vk.pubfn.error("操作失败");

// 警告提示
vk.pubfn.warn("请注意");

// 信息提示
vk.pubfn.info("提示信息");
```

### 确认对话框

```javascript
// 确认对话框
vk.pubfn.confirm("确定要删除吗?", (confirm) => {
  if (confirm) {
    // 点击确定
  } else {
    // 点击取消
  }
});
```

### 加载提示

```javascript
// 显示加载
vk.pubfn.loading("加载中...");

// 隐藏加载
vk.pubfn.hideLoading();
```

## 使用示例

### 综合示例: 表单验证

```javascript
export default {
  methods: {
    submitForm() {
      let that = this;
      let vk = uni.vk;

      // 验证手机号
      if (!vk.pubfn.testUtil.isPhone(that.form.phone)) {
        vk.pubfn.error("请输入正确的手机号");
        return;
      }

      // 验证邮箱
      if (!vk.pubfn.testUtil.isEmail(that.form.email)) {
        vk.pubfn.error("请输入正确的邮箱");
        return;
      }

      // 提交表单
      vk.pubfn.loading("提交中...");
      vk.callFunction({
        url: "admin/user/sys/add",
        data: that.form,
        success: (data) => {
          vk.pubfn.hideLoading();
          vk.pubfn.success("提交成功");
        },
        fail: (err) => {
          vk.pubfn.hideLoading();
          vk.pubfn.error("提交失败");
        }
      });
    }
  }
}
```

### 综合示例: 数据处理

```javascript
export default {
  methods: {
    processData(list) {
      let vk = uni.vk;

      // 数组去重
      let uniqueList = vk.pubfn.arrayUtil.unique(list);

      // 按某个字段排序
      let sortedList = vk.pubfn.arrayUtil.sort(uniqueList, "createTime");

      // 格式化时间
      sortedList.forEach(item => {
        item.createTimeStr = vk.pubfn.timeUtil.formatTime(item.createTime);
      });

      return sortedList;
    }
  }
}
```

## 最佳实践

### 1. 统一使用 vk 实例

```javascript
let vk = uni.vk;

// 推荐
vk.pubfn.testUtil.isPhone("13800138000");

// 不推荐
uni.vk.pubfn.testUtil.isPhone("13800138000");
```

### 2. 链式调用

```javascript
// 支持
vk.pubfn.strUtil.trim("  hello  ").toUpperCase();
// 返回: "HELLO"
```

### 3. 参数校验

```javascript
// 使用前校验参数
function validatePhone(phone) {
  if (!phone) {
    console.error("手机号不能为空");
    return false;
  }
  return vk.pubfn.testUtil.isPhone(phone);
}
```

### 4. 错误处理

```javascript
// 捕获异常
try {
  let result = vk.pubfn.jsonParse(jsonString);
} catch (e) {
  console.error("JSON解析失败:", e);
}
```

## 常见问题

### Q: vk.pubfn 和原生 API 有什么区别?

**A**: vk.pubfn 是 vk-unicloud 框架封装的工具函数,提供了更丰富的功能和更好的跨平台兼容性。

### Q: 如何扩展自定义工具函数?

**A**: 可以在 `app.config.js` 中配置自定义公共函数:

```javascript
import myPubFunction from '@/common/function/myPubFunction.js'

export default {
  myfn: myPubFunction,
}

// 使用
vk.myfn.myCustomFunction();
```

### Q: 工具函数支持 TypeScript 吗?

**A**: vk-unicloud 框架主要使用 JavaScript,但可以通过声明文件提供类型提示。

### Q: 如何查看所有可用的工具函数?

**A**: 可以在控制台打印查看:

```javascript
console.log(vk.pubfn);
```
