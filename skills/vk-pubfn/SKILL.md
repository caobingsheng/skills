---
name: vk-pubfn
description: "vk-unicloud框架的vk.pubfn工具函数完整使用指南。Use when working with vk-unicloud-admin framework utility functions, especially when: (1) Date/time formatting and manipulation, (2) Array/object data transformation, (3) Data validation and testing, (4) String/format utilities, (5) Frontend-only functions like page navigation and dialogs."
---

# vk.pubfn 工具函数使用指南

## Overview

`vk.pubfn` 是 vk-unicloud 框架提供的通用工具函数集，可在 JS 和 template 模板中使用（在 template 中可用简写法 `$fn` 代替 `vk.pubfn`）。

## 使用方式

```javascript
// JS中使用
let vk = uni.vk;
let result = vk.pubfn.timeFormat(new Date());

// template中使用
<view>{{ vk.pubfn.hidden("15200000001", 3, 4) }}</view>
<view>{{ $fn.hidden("15200000001", 3, 4) }}</view>
```

## 函数分类

### 1. 前后端通用函数

| 分类 | 函数 | 说明 |
|------|------|------|
| 函数控制 | `debounce` | 防抖函数 |
| 函数控制 | `throttle` | 节流函数 |
| 数据转换 | `arrayToTree` | 数组转树形结构 |
| 数据转换 | `treeToArray` | 树形结构转数组 |
| 时间控制 | `sleep` | 进程休眠(毫秒) |
| 时间格式化 | `timeFormat` | 日期时间格式化 |
| 时间解析 | `getDateInfo` | 解析日期对象属性 |
| 时间范围 | `getCommonTime` | 获取时间范围 |
| 时间偏移 | `getOffsetTime` | 获取偏移后的时间戳 |
| 时间偏移 | `getHourOffsetStartAndEnd` | 小时的起止时间 |
| 时间偏移 | `getDayOffsetStartAndEnd` | 天的起止时间 |
| 时间偏移 | `getWeekOffsetStartAndEnd` | 周的起止时间 |
| 时间偏移 | `getMonthOffsetStartAndEnd` | 月的起止时间 |
| 时间偏移 | `getQuarterOffsetStartAndEnd` | 季度的起止时间 |
| 时间偏移 | `getYearOffsetStartAndEnd` | 年的起止时间 |
| 数据验证 | `test` | 检测文本格式 |
| 对象操作 | `objectAssign` | 对象属性浅拷贝 |
| 对象操作 | `copyObject` | 复制对象(浅拷贝) |
| 对象操作 | `deepClone` | 深度克隆对象 |
| 数组操作 | `arr_concat` | 数组合并去重 |
| 数据获取 | `getData` | 根据路径获取对象值 |
| 数据设置 | `setData` | 根据路径设置对象值 |
| 空值检测 | `isNull` | 参数是否为空 |
| 空值检测 | `isNotNull` | 参数是否不为空 |
| 空值检测 | `isNullOne` | 是否至少有一个为空 |
| 空值检测 | `isNullAll` | 是否全部为空 |
| 空值检测 | `isNotNullAll` | 是否全部都不为空 |
| 空值检测 | `isNullOneByObject` | 对象是否有空值属性 |
| 数组查找 | `getListItem` | 从数组获取指定对象 |
| 数组查找 | `getListIndex` | 从数组获取指定索引 |
| 数组查找 | `getListItemIndex` | 获取对象和索引 |
| 数组转换 | `arrayToJson` | 对象数组转JSON |
| 数组提取 | `arrayObjectGetArray` | 提取指定字段 |
| 随机数 | `random` | 产生随机数 |
| 字符串 | `hidden` | 隐藏中间字段 |
| 数组判断 | `checkArrayIntersection` | 两数组是否有交集 |
| 业务计算 | `calcFreights` | 计算运费 |
| 对象提取 | `getNewObject` | 提取对象指定属性 |
| 对象删除 | `deleteObjectKeys` | 删除对象指定字段 |
| 时间工具 | `timeUtil.isLeapYear` | 判断闰年 |
| 时间工具 | `timeUtil.isQingming` | 判断清明节 |
| 单位换算 | `calcSize` | 单位进制换算 |
| 类型判断 | `isArray` | 判断是否数组 |
| 类型判断 | `isObject` | 判断是否对象 |
| 订单号 | `createOrderNo` | 产生订单号 |
| 命名转换 | `snake2camelJson` | 蛇形转驼峰(对象) |
| 命名转换 | `camel2snakeJson` | 驼峰转蛇形(对象) |
| 命名转换 | `snake2camel` | 蛇形转驼峰(字符串) |
| 命名转换 | `camel2snake` | 驼峰转蛇形(字符串) |
| 数字转换 | `string2Number` | 字符串转数字 |
| 数字格式化 | `toDecimal` | 保留小数 |
| 金额过滤 | `priceFilter` | 金额显示(分转元) |
| 百分比 | `percentageFilter` | 百分比显示 |
| 折扣显示 | `discountFilter` | 折扣显示 |
| 时间差 | `dateDiff` | 显示1秒前/1天前 |
| 时间差 | `dateDiff2` | 显示剩余时间 |
| 数字转中文 | `numStr` | 大数字转中文 |
| 数组分割 | `splitArray` | 分割数组 |
| 对象排序 | `objectKeySort` | 对象属性排序 |
| HTTP请求 | `request` | 请求HTTP接口 |

### 2. 前端专属函数

| 函数 | 说明 |
|------|------|
| `getListData` | 手机长列表分页加载 |
| `getComponentsDynamicData` | 动态组件数据获取 |
| `getCurrentPage` | 获取当前页面实例 |
| `fileToBase64` | 文件转base64 |
| `base64ToFile` | base64转文件 |
| `parseXlsxFile` | 前端解析Excel |

### 3. 弹窗函数

| 函数 | 说明 |
|------|------|
| `alert` | 警告弹窗 |
| `confirm` | 确认弹窗 |
| `prompt` | 输入弹窗 |
| `toast` | 轻提示 |
| `showActionSheet` | 操作菜单 |
| `showLoading` | 显示加载 |
| `hideLoading` | 隐藏加载 |

### 4. 页面跳转函数

| 函数 | 说明 |
|------|------|
| `navigateTo` | 跳转页面(带登录检测) |
| `redirectTo` | 关闭当前页跳转 |
| `reLaunch` | 关闭所有页跳转 |
| `switchTab` | 跳转tabBar页 |
| `navigateBack` | 返回上一页 |
| `navigateToHome` | 跳转到首页 |
| `navigateToLogin` | 跳转到登录页 |
| `pubfn.checkLogin` | 检测是否需要登录 |

### 5. 云函数专属函数

| 函数 | 说明 |
|------|------|
| `batchRun` | 并发执行异步函数 |
| `getUniCloudRequestId` | 获取请求ID |
| `randomAsync` | 产生不重复随机数 |

## 常用场景示例

### 日期时间格式化

```javascript
// 标准格式
vk.pubfn.timeFormat(new Date()); // 2024-01-01 10:10:10
// 自定义格式
vk.pubfn.timeFormat(new Date(), "yyyy年MM月dd日");
// 带毫秒
vk.pubfn.timeFormat(new Date(), "yyyy-MM-dd hh:mm:ss.S");
// 带季度
vk.pubfn.timeFormat(new Date(), "yyyy-MM-dd hh:mm:ss（第q季度）");
```

### 获取时间范围

```javascript
let { todayStart, todayEnd, monthStart, monthEnd } = vk.pubfn.getCommonTime(new Date());
```

### 数组转树

```javascript
let treeData = vk.pubfn.arrayToTree(arrayData, {
  id: "_id",
  parent_id: "parent_id",
  children: "children"
});
```

### 数据验证

```javascript
// 验证手机号
vk.pubfn.test("15200000001", "mobile"); // true/false
// 验证邮箱
vk.pubfn.test("test@example.com", "email");
// 验证身份证
vk.pubfn.test("330154202109301214", "card");
```

### 字符串隐藏

```javascript
// 手机号隐藏中间4位
vk.pubfn.hidden("15200000001", 3, 4); // 152****0001
```

### 对象深拷贝

```javascript
let newObj = vk.pubfn.deepClone(originalObj);
```

### 弹窗提示

```javascript
vk.toast("操作成功");
vk.alert("提示内容");
vk.confirm("确定删除吗？", (res) => {
  if (res.confirm) console.log("确认");
});
```

## 参考文档

详细使用说明请查看 references 目录：

- [时间函数详解](references/time_functions.md) - 所有时间相关函数
- [数据转换函数](references/data_transform.md) - 数组/对象转换
- [验证测试函数](references/validation.md) - 数据验证和测试
- [前端专属函数](references/frontend_only.md) - 前端专用功能
- [弹窗和跳转](references/ui_functions.md) - 弹窗和页面跳转
