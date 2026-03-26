# 数据验证函数详解

## test - 文本格式检测

```javascript
/**
 * 检测文本是否满足指定格式
 * @param {String} str 需要检测的文本
 * @param {String} type 检测类型（忽略大小写）
 * @param {Boolean} allowEmpty 是否允许为空
 * @return {Boolean} true/false
 */

// 验证手机号
vk.pubfn.test("15200000001", "mobile"); // true

// 验证邮箱
vk.pubfn.test("test@example.com", "email"); // true

// 验证身份证
vk.pubfn.test("330154202109301214", "card"); // true

// 允许为空
vk.pubfn.test("", "mobile", true); // true（空值也通过）
vk.pubfn.test("", "mobile", false); // false（空值不通过）
```

### 支持的验证类型

| 类型 | 说明 | 示例 |
|------|------|------|
| `mobile` | 手机号 | 15200000001 |
| `tel` | 座机 | 010-12345678 |
| `card` | 身份证 | 330154202109301214 |
| `mobileCode` | 6位数字验证码 | 123456 |
| `username` | 账号（字母开头，3-32位，字母数字下划线） | user_name_123 |
| `pwd` / `password` | 密码（6-18位，字母数字下划线） | password123 |
| `paypwd` | 支付密码（6位纯数字） | 123456 |
| `postal` | 邮政编码 | 310000 |
| `qq` | QQ号 | 123456789 |
| `email` | 邮箱 | test@example.com |
| `money` | 金额（小数点最多2位） | 123.45 |
| `url` | 网址 | https://example.com |
| `ip` | IP地址 | 192.168.1.1 |
| `date` | 日期 | 2024-01-01 |
| `time` | 时间 | 12:12:12 |
| `dateTime` | 日期+时间 | 2024-01-01 12:12:12 |
| `number` | 纯数字 | 12345 |
| `english` | 纯英文 | hello |
| `chinese` | 纯中文 | 你好 |
| `english+number` | 英文+数字 | hello123 |
| `english+number+_` | 英文+数字+下划线 | hello_123 |
| `english+number+_-` | 英文+数字+下划线+中划线 | hello-123_ |
| `lower` | 小写 | hello |
| `upper` | 大写 | HELLO |
| `version` | 版本号（xx.xx.xx） | 1.2.3 |
| `html` | HTML格式 | \<div\>test\</div\> |
| `image` | 图片格式 | .jpg/.png/.gif |
| `video` | 视频格式 | .mp4/.avi |
| `audio` | 音频格式 | .mp3/.wav |

## 空值检测

### isNull - 是否为空

```javascript
/**
 * 检测参数是否为空
 * undefined、null、{}、[]、"" 均为空值
 * @param {Any} value 要检测的值
 * @return {Boolean} true=空值 false=有值
 */

vk.pubfn.isNull(undefined); // true
vk.pubfn.isNull(null); // true
vk.pubfn.isNull({}); // true
vk.pubfn.isNull([]); // true
vk.pubfn.isNull(""); // true
vk.pubfn.isNull("0"); // false（有值）
vk.pubfn.isNull(0); // false（有值）
```

### isNotNull - 是否不为空

```javascript
/**
 * 检测参数是否不为空
 * 结果与 isNull 相反
 */

vk.pubfn.isNotNull("hello"); // true
vk.pubfn.isNotNull(""); // false
```

### isNullOne - 是否至少有一个为空

```javascript
/**
 * 检测所有参数 - 是否至少有一个为空
 */

vk.pubfn.isNullOne("a", "b", ""); // true（有1个为空）
vk.pubfn.isNullOne("a", "b", "c"); // false（全部有值）
```

### isNullAll - 是否全部为空

```javascript
/**
 * 检测所有参数 - 是否全部为空
 */

vk.pubfn.isNullAll("", null, undefined); // true
vk.pubfn.isNullAll("", "a", "b"); // false
```

### isNotNullAll - 是否全部都不为空

```javascript
/**
 * 检测所有参数 - 是否全部都不为空
 */

vk.pubfn.isNotNullAll("a", "b", "c"); // true
vk.pubfn.isNotNullAll("a", "", "c"); // false
```

### isNullOneByObject - 对象是否有空值属性

```javascript
/**
 * 检测整个对象是否没有一个属性是空值
 * 如果有空值，返回首个空值属性名
 * 如果没有空值，返回undefined
 */

let nullKey = vk.pubfn.isNullOneByObject({
  title: "标题",
  content: "",
  avatar: null
});
// nullKey = "content"

// 业务使用示例
let nullKey = vk.pubfn.isNullOneByObject({ title, content, avatar });
if (nullKey) {
  return { code: -1, msg: `${nullKey}不能为空` };
}
```

## 类型判断

### isArray - 判断数组

```javascript
/**
 * 判断变量是否是数组
 * @param {Any} obj 变量
 * @return {Boolean} true/false
 */

vk.pubfn.isArray([]); // true
vk.pubfn.isArray({}); // false
```

### isObject - 判断对象

```javascript
/**
 * 判断变量是否是对象
 * @param {Any} obj 变量
 * @return {Boolean} true/false
 */

vk.pubfn.isObject({}); // true
vk.pubfn.isObject([]); // true（数组也是对象）
vk.pubfn.isObject(null); // false
```

## 数组判断

### checkArrayIntersection - 两数组是否有交集

```javascript
/**
 * 判断数组A是否至少有一个元素在数组B中存在
 * @param {Array} arr1 数组A
 * @param {Array} arr2 数组B
 * @return {Boolean} true=有交集 false=无交集
 */

vk.pubfn.checkArrayIntersection([1, 2, 3], [3, 4, 5]); // true
vk.pubfn.checkArrayIntersection([1, 2, 3], [4, 5, 6]); // false
```

## 数组查找

### getListItem - 从数组获取对象

```javascript
/**
 * 获取对象数组中的某一个item
 * @param {Array} list 数据源
 * @param {String} key 键名
 * @param {String} value 键值
 * @return {Any} item 找到的对象
 */

let list = [
  { _id: "001", name: "张三" },
  { _id: "002", name: "李四" }
];
let item = vk.pubfn.getListItem(list, "_id", "001");
// item = { _id: "001", name: "张三" }
```

### getListIndex - 从数组获取索引

```javascript
/**
 * 获取对象数组中某个元素的index
 * @param {Array} list 数据源
 * @param {String} key 键名
 * @param {String} value 键值
 * @return {Number} index 索引
 */

let index = vk.pubfn.getListIndex(list, "_id", "001");
// index = 0
```

### getListItemIndex - 获取对象和索引

```javascript
/**
 * 获取对象数组中某个元素的对象和index
 * @param {Array} list 数据源
 * @param {String} key 键名
 * @param {String} value 键值
 * @return {Object} { item, index }
 */

let { item, index } = vk.pubfn.getListItemIndex(list, "_id", "001");
// item = {...}, index = 0
```

## 字符串处理

### hidden - 隐藏中间字段

```javascript
/**
 * 将手机号、账号等隐藏中间字段
 * @param {String} str 需要转换的字符串
 * @param {Number} first 前面显示的字符数量
 * @param {Number} last 后面显示的字符数量
 * @return {String} newStr 转换后的值
 */

vk.pubfn.hidden("15200000001", 3, 4); // 152****0001
vk.pubfn.hidden("15200000001", 0, 0); // ***********
vk.pubfn.hidden("张三", 1, 0); // 张*
```
