# Backtop 回到顶部

返回页面顶部的操作按钮。

## 基础用法

滑动页面即可看到右下方的按钮。

```vue
<template>
  Scroll down to see the bottom-right button.
  <el-backtop target=".page-component__scroll .el-scrollbar__wrap"></el-backtop>
</template>
```

## 自定义显示内容

显示区域被固定为 40px * 40px 的区域, 其中的内容可支持自定义。

```vue
<template>
  Scroll down to see the bottom-right button.
  <el-backtop target=".page-component__scroll .el-scrollbar__wrap" :bottom="100">
    <div
      style="{
        height: 100%;
        width: 100%;
        background-color: #f2f5f6;
        box-shadow: 0 0 6px rgba(0,0,0, .12);
        text-align: center;
        line-height: 40px;
        color: #1989fa;
      }"
    >
      UP
    </div>
  </el-backtop>
</template>
```

## Attributes

| 参数 | 说明 | 类型 | 可选值 | 默认值 |
|------|------|------|--------|--------|
| target | 触发滚动的对象 | string | — | — |
| visibility-height | 滚动高度达到此参数值才出现 | number | — | 200 |
| right | 控制其显示位置, 距离页面右边距 | number | — | 40 |
| bottom | 控制其显示位置, 距离页面底部距离 | number | — | 40 |

## Events

| 事件名 | 说明 | 回调参数 |
|--------|------|----------|
| click | 点击按钮触发的事件 | 点击事件 |

## 最佳实践

1. **滚动容器**: 使用`target`属性指定滚动容器,确保Backtop能正确监听滚动事件
2. **显示阈值**: 通过`visibility-height`调整按钮出现的滚动高度,默认200px
3. **位置调整**: 使用`right`和`bottom`属性调整按钮位置,避免遮挡重要内容
4. **自定义样式**: 通过默认插槽自定义按钮内容,支持图标、文字等自定义样式
5. **固定尺寸**: 注意显示区域固定为40px * 40px,自定义内容时需考虑尺寸限制
6. **性能优化**: Backtop只在滚动时显示,不影响页面初始加载性能
