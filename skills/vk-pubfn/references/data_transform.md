# 数据转换函数详解

## 数组与树转换

### arrayToTree - 数组转树形结构

```javascript
/**
 * 数组结构转树形结构
 * @param {Array} arrayData 数据源
 * @param {Object} treeProps 树结构配置
 * @return {Array} treeData 树形结构
 */

let arrayData = [
  { _id: "001", name: "手机" },
  { _id: "002", name: "华为", parent_id: "001" },
  { _id: "003", name: "荣耀", parent_id: "002" },
  { _id: "004", name: "苹果", parent_id: "001" },
  { _id: "005", name: "电脑" },
  { _id: "006", name: "联想", parent_id: "005" },
  { _id: "007", name: "小米", parent_id: "005" },
];

let treeProps = {
  id: "_id",
  parent_id: "parent_id",
  children: "children"
};

let treeData = vk.pubfn.arrayToTree(arrayData, treeProps);
// 返回：
[
  {
    "_id": "001",
    "name": "手机",
    "children": [
      {
        "_id": "002",
        "name": "华为",
        "parent_id": "001",
        "children": [
          { "_id": "003", "name": "荣耀", "parent_id": "002" }
        ]
      },
      { "_id": "004", "name": "苹果", "parent_id": "001" }
    ]
  },
  {
    "_id": "005",
    "name": "电脑",
    "children": [
      { "_id": "006", "name": "联想", "parent_id": "005" },
      { "_id": "007", "name": "小米", "parent_id": "005" }
    ]
  }
]
```

### treeToArray - 树转数组

```javascript
/**
 * 树形结构转数组结构
 * @param {Array} treeData 树形数据
 * @param {Object} treeProps 树结构配置
 * @return {Array} arrayData 数组结构
 */

let treeData = [...]; // 树形数据
let treeProps = {
  id: "_id",
  parent_id: "parent_id",
  children: "children"
};
let arrayData = vk.pubfn.treeToArray(treeData, treeProps);
// 返回扁平化数组
```

## 对象操作

### objectAssign - 对象浅拷贝

```javascript
/**
 * 对象属性拷贝(浅拷贝)
 * 将 obj2 的属性赋值给 obj1
 * @param {Object} obj1 目标对象
 * @param {Object} obj2 源对象
 * @return {Object} newObj 合并后的对象
 */

let obj1 = { a: 1, b: 2 };
let obj2 = { b: 3, c: 4 };
let newObj = vk.pubfn.objectAssign(obj1, obj2);
// newObj = { a: 1, b: 3, c: 4 }
// 注意：obj1 也会被修改
```

### copyObject - 浅拷贝对象

```javascript
/**
 * 复制一份对象（浅拷贝，无映射关系）
 * @param {Object} obj 需要被复制的对象
 * @return {Object} newObj 复制后的新对象
 */

let newObj = vk.pubfn.copyObject(obj);
```

### deepClone - 深拷贝对象

```javascript
/**
 * 深度克隆一个对象（无映射关系，支持克隆函数）
 * @param {Object} obj 需要被深度克隆的对象
 * @return {Object} newObj 深度克隆后的新对象
 */

let newObj = vk.pubfn.deepClone(obj);
```

### getNewObject - 提取对象属性

```javascript
/**
 * 从一个对象中取多个属性，并生成一个全新的对象
 * @param {Object} obj 对象
 * @param {Array<String>} keys 键名数组
 * @return {Object} newObj 新对象
 */

let obj = { a: 1, b: 2, c: 3, d: 4 };
let newObj = vk.pubfn.getNewObject(obj, ["a", "c"]);
// newObj = { a: 1, c: 3 }
```

### deleteObjectKeys - 删除对象字段

```javascript
/**
 * 对象删除指定的字段，返回新的对象
 * @param {Object} data 操作对象
 * @param {Array<String>} deleteKeys 需要删除的键名
 * @return {Object} newObj 新对象
 */

let obj = { a: 1, b: 2, c: 3 };
let newObj = vk.pubfn.deleteObjectKeys(obj, ["b"]);
// newObj = { a: 1, c: 3 }
```

### objectKeySort - 对象属性排序

```javascript
/**
 * 将对象内的属性按照ASCII字符顺序进行排序
 * @param {Object} obj 需要排序对象
 * @return {Object} newObj 排序后对象
 */

let obj = { c: 1, a: 2, b: 3 };
let newObj = vk.pubfn.objectKeySort(obj);
// newObj = { a: 2, b: 3, c: 1 }
```

## 数组操作

### arr_concat - 数组合并去重

```javascript
/**
 * 两个(元素为对象)的数组合并,并去除重复的数据
 * @param {Array} arr1 第一个数组
 * @param {Array} arr2 第二个数组
 * @param {String} flag 判断标识，默认用id
 * @return {Array} arr 合并后的新数组
 */

let arr1 = [{ _id: "001", name: "张三" }];
let arr2 = [{ _id: "002", name: "李四" }, { _id: "001", name: "张三" }];
let arr = vk.pubfn.arr_concat(arr1, arr2, "_id");
// arr 长度为2，去重后
```

### splitArray - 分割数组

```javascript
/**
 * 将一个大数组拆分成N个小数组
 * @param {Array} array 大数组
 * @param {Number} size 小数组每组最大数量
 * @return {Array} newArray 二维数组
 */

let array = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16];
let newArray = vk.pubfn.splitArray(array, 6);
// 返回：
// [
//   [1,2,3,4,5,6],
//   [7,8,9,10,11,12],
//   [13,14,15,16]
// ]
```

### arrayObjectGetArray - 提取数组字段

```javascript
/**
 * 从数组中提取指定字段形成新的数组
 * @param {Array} list 数据源
 * @param {String} key 键名
 * @return {Array} newList 新数组
 */

let list = [
  { _id: "001", name: "张三" },
  { _id: "002", name: "李四" }
];
let newList = vk.pubfn.arrayObjectGetArray(list, "_id");
// newList = ["001", "002"]
```

### arrayToJson - 数组转JSON对象

```javascript
/**
 * 数组转对象 - 将对象数组转成json
 * @param {Array} list 数据源
 * @param {String} key 键名
 * @return {Object} obj JSON对象
 */

let list = [
  { _id: "001", name: "张三" },
  { _id: "002", name: "李四" }
];
let obj = vk.pubfn.arrayToJson(list, "_id");
// obj = {
//   "001": { _id: "001", name: "张三" },
//   "002": { _id: "002", name: "李四" }
// }
```

## 数据路径操作

### getData - 根据路径获取值

```javascript
/**
 * 根据字符串路径获取对象的值
 * 支持.和[]，任意一个值为undefined时不会报错
 * @param {Object} dataObj 数据源
 * @param {String} name 路径，支持a.b 和 a[b]
 * @param {String} defaultValue 默认值
 * @return {Any} value 值
 */

let obj = { a: { b: { c: [1, 2, 3] } } };
vk.pubfn.getData(obj, "a.b.c[1]"); // 2
vk.pubfn.getData(obj, "a.b.d", "默认值"); // 默认值
```

### setData - 根据路径设置值

```javascript
/**
 * 根据字符串路径设置对象的值
 * 支持.和[]
 * @param {Object} dataObj 数据源
 * @param {String} name 路径
 * @param {String} value 值
 */

let obj = {};
vk.pubfn.setData(obj, "a.b.c", "value");
// obj = { a: { b: { c: "value" } } }
```

## 命名转换

### snake2camel / camel2snake - 字符串转换

```javascript
// 蛇形转驼峰（字符串）
vk.pubfn.snake2camel("user_name"); // "userName"

// 驼峰转蛇形（字符串）
vk.pubfn.camel2snake("userName"); // "user_name"
```

### snake2camelJson / camel2snakeJson - 对象转换

```javascript
// 蛇形转驼峰（对象）
let obj1 = { user_name: "张三", user_age: 25 };
let newObj1 = vk.pubfn.snake2camelJson(obj1);
// newObj1 = { userName: "张三", userAge: 25 }

// 驼峰转蛇形（对象）
let obj2 = { userName: "张三", userAge: 25 };
let newObj2 = vk.pubfn.camel2snakeJson(obj2);
// newObj2 = { user_name: "张三", user_age: 25 }
```

## 数字处理

### string2Number - 字符串转数字

```javascript
/**
 * 将能转成数字的字符串转数字
 * @param {Any} obj 数据源
 * @param {Object} option 排除选项
 * @return {Any} newObj 新数据
 */

// 默认排除手机号、身份证、以0开头的字符串
vk.pubfn.string2Number("123"); // 123
vk.pubfn.string2Number({ a: "1", b: "2" }); // { a: 1, b: 2 }
```

### toDecimal - 保留小数

```javascript
/**
 * 保留小数
 * @param {Number} val 原值
 * @param {Number} precision 精度
 * @return {Number} newVal 保留小数后的值
 */

vk.pubfn.toDecimal(1.56555, 2); // 1.57
```

### priceFilter - 金额过滤

```javascript
/**
 * 金额显示过滤器（以分为单位，转成元）
 * @param {Number} money 金额（分）
 * @return {Number} newVal 转换后的值（元）
 */

vk.pubfn.priceFilter(100); // 1
vk.pubfn.priceFilter(1234); // 12.34
```

### percentageFilter - 百分比过滤

```javascript
/**
 * 百分比显示过滤器
 * @param {Number} value 百分比值
 * @param {Boolean} needShowSymbol 显示%符号
 * @param {String | Number} defaultValue 默认值
 * @return {Number} newVal 转换后的值
 */

vk.pubfn.percentageFilter(0.1); // 10%
vk.pubfn.percentageFilter(0.1, true); // 10%
vk.pubfn.percentageFilter(1); // 100%
```

### discountFilter - 折扣过滤

```javascript
/**
 * 折扣显示过滤器
 * @param {Number} value 折扣值
 * @param {Boolean} needShowSymbol 显示"折"字
 * @param {String | Number} defaultValue 默认值
 * @return {Number} newVal 转换后的值
 */

vk.pubfn.discountFilter(0.7); // 7折
vk.pubfn.discountFilter(1); // 原价
vk.pubfn.discountFilter(0); // 免费
```

### numStr - 数字转中文

```javascript
/**
 * 将大数字转中文（用于浏览量等不需要精确显示的场景）
 * @param {Number} n 数字
 * @return {String} newStr 转换后的值
 */

vk.pubfn.numStr(3210); // "3千"
vk.pubfn.numStr(31210); // "3万"
vk.pubfn.numStr(1523412); // "1百万"
vk.pubfn.numStr(15234120); // "1千万"
```

### calcSize - 单位换算

```javascript
/**
 * 单位进制换算
 * @param {Number} length 大小
 * @param {Array<String>} arr 进制数组
 * @param {Number} ary 进制
 * @param {Number} precision 精度
 * @return {Number} size 换算后的值
 */

vk.pubfn.calcSize(1024, ["B","KB","MB","GB"], 1024, 2); // 1.00 KB
vk.pubfn.calcSize(1048576, ["B","KB","MB","GB"], 1024, 2); // 1.00 MB
```

## 随机数

### random - 随机数

```javascript
/**
 * 产生指定位数的随机数
 * @param {Number} length 随机数固定位数
 * @param {String} range 随机范围字符串
 * @param {Array} arr 排除的数组
 * @return {Number} n 随机数
 */

// 纯数字6位
vk.pubfn.random(6);

// 指定字符范围
vk.pubfn.random(6, "abcdefghijklmnopqrstuvwxyz0123456789");

// 排除重复
vk.pubfn.random(1, "123456789", ["1", "2", "3"]);
```

### createOrderNo - 订单号

```javascript
/**
 * 产生订单号（不依赖数据库，高并发性能高）
 * @param {String} prefix 前缀
 * @param {Number} count 位数（建议25-30）
 * @return {String} no 订单号
 */

vk.pubfn.createOrderNo("NO"); // "NOxxxxxxxxxxxxx"
vk.pubfn.createOrderNo("NO", 25);
```

## calcFreights - 运费计算

```javascript
/**
 * 计算运费
 * @param {Object} freightsItem 运费模板
 * @param {Number} weight 重量（KG）
 * @return {Number} freights 运费金额
 */

let freights = vk.pubfn.calcFreights({
  first_weight: 1,           // 首重
  first_weight_price: 6,     // 首重价格
  continuous_weight: 1,      // 续重
  continuous_weight_price: 2 // 续重价格
}, 10); // 重量10KG
// 计算：首重6 + 续重9*2 = 24
```
