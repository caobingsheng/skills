# 时间函数详解

## timeFormat - 日期时间格式化

```javascript
/**
 * 日期时间格式化
 * @param {Date || Number} date 需要格式化的时间
 * @param {String} format 时间格式 默认 "yyyy-MM-dd hh:mm:ss"
 * @param {Number} targetTimezone 时区 默认东8区
 * @return {String} 格式化后的字符串
 */

// 标准格式
vk.pubfn.timeFormat(new Date()); // 2024-01-01 10:10:10

// 自定义格式
vk.pubfn.timeFormat(new Date(), "yyyy年MM月dd日 hh时mm分ss秒");
// 2024年01月01日 10时10分10秒

// 带毫秒
vk.pubfn.timeFormat(new Date(), "yyyy-MM-dd hh:mm:ss.S");
// 2024-01-01 10:10:10.900

// 带季度
vk.pubfn.timeFormat(new Date(), "yyyy-MM-dd hh:mm:ss（第q季度）");
// 2024-01-01 10:10:10（第1季度）

// 指定时区
vk.pubfn.timeFormat(new Date(), "yyyy-MM-dd hh:mm:ss", 8); // 东8区

// 显示时区
vk.pubfn.timeFormat(new Date(), "yyyy-MM-ddThh:mm:ssZ", 8);
// 2024-01-01T10:10:10+08:00
```

**格式符说明：**
- `yyyy` - 年
- `MM` - 月（补零）
- `dd` - 日（补零）
- `hh` - 时（12小时制）
- `HH` - 时（24小时制）
- `mm` - 分（补零）
- `ss` - 秒（补零）
- `S` - 毫秒
- `q` - 季度

## getDateInfo - 解析日期对象

```javascript
let dateObj = vk.pubfn.getDateInfo(new Date());
// 返回：
{
  year: 2022,        // 年
  month: 11,         // 月
  day: 11,           // 日
  hour: 19,          // 时
  minute: 52,        // 分
  second: 28,        // 秒
  millisecond: 282,  // 毫秒
  week: 5,           // 星期几（0代表星期日）
  quarter: 4         // 季度
}
```

## getCommonTime - 获取时间范围

```javascript
let timeObj = vk.pubfn.getCommonTime(new Date(), 8);
// 返回：
{
  todayStart: 1706726400000,   // 今日开始时间（时间戳）
  todayEnd: 1706812799999,     // 今日结束时间（时间戳）
  today12End: 1706767200000,   // 今日上午结束时间
  monthStart: 1704067200000,   // 本月开始时间
  monthEnd: 1706659199999,     // 本月结束时间
  yearStart: 1672531200000,    // 本年开始时间
  yearEnd: 1704067199999,      // 本年结束时间
  weekStart: 1706208000000,    // 本周开始时间
  weekEnd: 1706812799999,      // 本周结束时间
  hourStart: 1706809200000,    // 当前小时开始时间
  hourEnd: 1706812799999,      // 当前小时结束时间
  yesterdayStart: 1706640000000, // 昨天开始时间
  yesterdayEnd: 1706726399999,   // 昨天结束时间
  lastMonthStart: 1704067200000, // 上月开始时间
  lastMonthEnd: 1706659199999,   // 上月结束时间
  now: Date.now(),               // 现在的时间点
  months: { /* 本年度每月起止 */ },
  days: { /* 本月每日起止 */ }
}

// 解构使用
let { todayStart, todayEnd, monthStart, monthEnd } = vk.pubfn.getCommonTime();
```

## getOffsetTime - 时间偏移

```javascript
/**
 * 获得指定时间偏移 year年 month月 day天 hours时 minutes分 seconds秒前或后的时间戳
 * @param {Date} date 日期对象
 * @param {Object} offsetObj 偏移参数
 * @param {String} mode "after" 之后 / "before" 之前
 */

// 1小时后
let timestamp = vk.pubfn.getOffsetTime(new Date(), {
  hour: 1,
  mode: "after"
});

// 1小时30分钟之前
let timestamp = vk.pubfn.getOffsetTime(new Date(), {
  hour: 1,
  minutes: 30,
  mode: "before"
});

// 完整参数
let timestamp = vk.pubfn.getOffsetTime(new Date(), {
  year: 0,
  month: 0,
  day: 0,
  hours: 0,
  minutes: 0,
  seconds: 0,
  mode: "after"
});
```

## 时间偏移起止函数

### getHourOffsetStartAndEnd - 小时起止

```javascript
/**
 * 获得相对当前时间的偏移 count 小时的起止日期
 * @param {Number} count 0=当前小时 -1=上一小时 1=下一小时
 * @param {Date || Number} date 指定时间节点
 * @return {Object} { startTime, endTime }
 */

let timeObj = vk.pubfn.getHourOffsetStartAndEnd(0);
let { startTime, endTime } = vk.pubfn.getHourOffsetStartAndEnd(-1, new Date());
```

### getDayOffsetStartAndEnd - 天起止

```javascript
/**
 * 获得相对当前时间的偏移 count 天的起止日期
 * @param {Number} count 0=今日 -1=昨日 1=明日
 */

let timeObj = vk.pubfn.getDayOffsetStartAndEnd(0);
let { startTime, endTime } = vk.pubfn.getDayOffsetStartAndEnd(-1, new Date());
```

### getWeekOffsetStartAndEnd - 周起止

```javascript
/**
 * 获得相对当前时间的偏移 count 周的起止日期
 * @param {Number} count 0=本周 -1=上周 1=下周
 */
```

### getMonthOffsetStartAndEnd - 月起止

```javascript
/**
 * 获得相对当前时间的偏移 count 月的起止日期
 * @param {Number} count 0=本月 -1=上月 1=下月
 */
```

### getQuarterOffsetStartAndEnd - 季度起止

```javascript
/**
 * 获得相对当前时间的偏移 count 季度的起止日期
 * @param {Number} count 0=本季度 -1=上季度 1=下季度
 */
```

### getYearOffsetStartAndEnd - 年起止

```javascript
/**
 * 获得相对当前时间的偏移 count 年的起止日期
 * @param {Number} count 0=今年 -1=去年 1=明年
 */
```

## sleep - 进程休眠

```javascript
/**
 * 进程强制等待，休眠（单位毫秒）
 */
await vk.pubfn.sleep(1000); // 等待1秒
```

## timeUtil - 时间工具

```javascript
// 判断闰年
vk.pubfn.timeUtil.isLeapYear(2021); // false
vk.pubfn.timeUtil.isLeapYear(2020); // true

// 判断清明节
vk.pubfn.timeUtil.isQingming(new Date());
```

## dateDiff - 时间差显示

```javascript
/**
 * 将时间显示成1秒前、1天前
 * @param {String || Number} startTime 需要计算的时间
 * @param {String} suffix 后缀，默认"前"
 */

vk.pubfn.dateDiff(Date.now() - 1000); // 1秒前
vk.pubfn.dateDiff(Date.now() - 1000*3600*24); // 1天前
vk.pubfn.dateDiff(Date.now() - 1000, ""); // 1秒（无后缀）
```

## dateDiff2 - 剩余时间显示

```javascript
/**
 * 将时间显示成1秒、1天（endTime - 当前时间）
 * @param {String || Number} endTime 需要计算的时间
 * @param {String} endText 到期时显示的文字
 */

vk.pubfn.dateDiff2(Date.now() + 1000*3600*24); // 23小时59分（剩余）
vk.pubfn.dateDiff2(Date.now() + 1000*3600*24, "已到期"); // 已到期
```
