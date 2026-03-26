# Breadcrumb 面包屑

显示当前页面的路径，快速返回之前的任意页面。

## 基础用法

适用广泛的基础用法。

在 `el-breadcrumb` 中使用 `el-breadcrumb-item` 标签表示从首页开始的每一级。Element 提供了一个 `separator` 属性，在 `el-breadcrumb` 标签中设置它来决定分隔符，它只能是字符串，默认为斜杠 `/`。

```vue
<el-breadcrumb separator="/">
  <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
  <el-breadcrumb-item><a href="/">活动管理</a></el-breadcrumb-item>
  <el-breadcrumb-item>活动列表</el-breadcrumb-item>
  <el-breadcrumb-item>活动详情</el-breadcrumb-item>
</el-breadcrumb>
```

## 图标分隔符

通过设置 `separator-class` 可使用相应的 `iconfont` 作为分隔符，注意这将使 `separator` 设置失效。

```vue
<el-breadcrumb separator-class="el-icon-arrow-right">
  <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
  <el-breadcrumb-item>活动管理</el-breadcrumb-item>
  <el-breadcrumb-item>活动列表</el-breadcrumb-item>
  <el-breadcrumb-item>活动详情</el-breadcrumb-item>
</el-breadcrumb>
```

## Breadcrumb Attributes

| 参数 | 说明 | 类型 | 可选值 | 默认值 |
|------|------|------|--------|--------|
| separator | 分隔符 | string | — | 斜杠'/' |
| separator-class | 图标分隔符 class | string | — | - |

## Breadcrumb Item Attributes

| 参数 | 说明 | 类型 | 可选值 | 默认值 |
|------|------|------|--------|--------|
| to | 路由跳转对象，同 vue-router 的 to | string/object | — | — |
| replace | 在使用 to 进行路由跳转时，启用 replace 将不会向 history 添加新记录 | boolean | — | false |

## 最佳实践

1. **分隔符**: 使用`separator`属性设置分隔符,默认为斜杠`/`
2. **图标分隔符**: 使用`separator-class`属性使用图标作为分隔符
3. **路由跳转**: 使用`to`属性进行路由跳转,支持字符串和对象
4. **replace模式**: 使用`replace`属性启用replace模式,不添加历史记录
5. **层级控制**: 控制面包屑的层级,一般不超过5级
6. **当前页**: 最后一项通常不添加链接,表示当前页面
7. **响应式**: 在移动端可以考虑隐藏中间层级,只显示首尾
8. **可点击**: 除当前页外,其他层级都应该可以点击跳转

## 使用场景

### 基础面包屑

```vue
<el-breadcrumb separator="/">
  <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
  <el-breadcrumb-item>活动管理</el-breadcrumb-item>
  <el-breadcrumb-item>活动列表</el-breadcrumb-item>
  <el-breadcrumb-item>活动详情</el-breadcrumb-item>
</el-breadcrumb>
```

### 图标分隔符

```vue
<el-breadcrumb separator-class="el-icon-arrow-right">
  <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
  <el-breadcrumb-item>用户管理</el-breadcrumb-item>
  <el-breadcrumb-item>用户列表</el-breadcrumb-item>
</el-breadcrumb>
```

### 带图标的面包屑

```vue
<el-breadcrumb separator="/">
  <el-breadcrumb-item :to="{ path: '/' }">
    <i class="el-icon-s-home"></i> 首页
  </el-breadcrumb-item>
  <el-breadcrumb-item>
    <i class="el-icon-menu"></i> 系统管理
  </el-breadcrumb-item>
  <el-breadcrumb-item>
    <i class="el-icon-setting"></i> 系统设置
  </el-breadcrumb-item>
</el-breadcrumb>
```

### 动态面包屑

```vue
<el-breadcrumb separator="/">
  <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
  <el-breadcrumb-item
    v-for="(item, index) in breadcrumbs"
    :key="index"
    :to="index < breadcrumbs.length - 1 ? { path: item.path } : null">
    {{ item.title }}
  </el-breadcrumb-item>
</el-breadcrumb>

<script>
export default {
  data() {
    return {
      breadcrumbs: [
        { title: '用户管理', path: '/users' },
        { title: '用户列表', path: '/users/list' },
        { title: '用户详情', path: null }
      ]
    }
  }
}
</script>
```

### 可点击的面包屑

```vue
<el-breadcrumb separator="/">
  <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
  <el-breadcrumb-item :to="{ path: '/products' }">产品管理</el-breadcrumb-item>
  <el-breadcrumb-item :to="{ path: '/products/list' }">产品列表</el-breadcrumb-item>
  <el-breadcrumb-item>产品详情</el-breadcrumb-item>
</el-breadcrumb>
```

### 自定义样式

```vue
<el-breadcrumb separator="/" class="custom-breadcrumb">
  <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
  <el-breadcrumb-item>系统管理</el-breadcrumb-item>
  <el-breadcrumb-item>用户管理</el-breadcrumb-item>
</el-breadcrumb>

<style>
.custom-breadcrumb .el-breadcrumb__inner {
  color: #409EFF;
  font-weight: 500;
}
.custom-breadcrumb .el-breadcrumb__inner:hover {
  color: #66b1ff;
}
</style>
```
