# PageHeader 页头

如果页面的路径比较简单，推荐使用页头组件而非面包屑组件。

## 基础

```vue
<el-page-header @back="goBack" content="详情页面">
</el-page-header>

<script>
export default {
  methods: {
    goBack() {
      console.log('go back');
    }
  }
};
</script>
```

## Attributes

| 参数 | 说明 | 类型 | 可选值 | 默认值 |
|------|------|------|--------|--------|
| title | 标题 | string | — | 返回 |
| content | 内容 | string | — | — |

## Events

| 事件名称 | 说明 | 回调参数 |
|----------|------|----------|
| back | 点击左侧区域触发 | — |

## Slots

| 事件名称 | 说明 |
|----------|------|
| title | 标题内容 |
| content | 内容 |

## 最佳实践

1. **简单路径**: 当页面路径比较简单时,推荐使用页头组件而非面包屑组件
2. **返回功能**: 使用`@back`事件处理返回操作,通常用于返回上一页
3. **自定义标题**: 使用`title`属性或插槽自定义标题内容
4. **自定义内容**: 使用`content`属性或插槽自定义内容
5. **样式定制**: 通过CSS覆盖默认样式,实现个性化设计
6. **路由集成**: 结合Vue Router使用,实现页面导航
7. **权限控制**: 根据用户权限控制返回按钮的显示
8. **移动端适配**: 在移动端调整样式,提升用户体验

## 使用场景

### 基础页头

```vue
<el-page-header @back="goBack" content="详情页面">
</el-page-header>

<script>
export default {
  methods: {
    goBack() {
      this.$router.go(-1);
    }
  }
}
</script>
```

### 自定义标题

```vue
<el-page-header @back="goBack" title="返回" content="用户详情">
</el-page-header>
```

### 插槽自定义

```vue
<el-page-header @back="goBack">
  <template slot="title">
    <i class="el-icon-arrow-left"></i>
    <span>返回列表</span>
  </template>
  <template slot="content">
    <span>用户详情 - {{ userName }}</span>
  </template>
</el-page-header>

<script>
export default {
  data() {
    return {
      userName: '张三'
    }
  }
}
</script>
```

### 带操作按钮

```vue
<el-page-header @back="goBack" content="用户详情">
  <template slot="extra">
    <el-button type="primary" size="small" @click="handleEdit">编辑</el-button>
    <el-button type="danger" size="small" @click="handleDelete">删除</el-button>
  </template>
</el-page-header>
```

### 面包屑组合

```vue
<el-page-header @back="goBack">
  <template slot="content">
    <el-breadcrumb separator="/">
      <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
      <el-breadcrumb-item :to="{ path: '/users' }">用户管理</el-breadcrumb-item>
      <el-breadcrumb-item>用户详情</el-breadcrumb-item>
    </el-breadcrumb>
  </template>
</el-page-header>
```

### 自定义样式

```vue
<el-page-header @back="goBack" content="详情页面" class="custom-page-header">
</el-page-header>

<style>
.custom-page-header {
  background-color: #f5f7fa;
  padding: 20px;
  margin-bottom: 20px;
}
.custom-page-header .el-page-header__title {
  font-size: 18px;
  font-weight: 600;
}
</style>
```

### 权限控制

```vue
<el-page-header @back="goBack" content="用户详情">
  <template slot="extra" v-if="hasEditPermission">
    <el-button type="primary" size="small" @click="handleEdit">编辑</el-button>
  </template>
</el-page-header>

<script>
export default {
  computed: {
    hasEditPermission() {
      return this.$store.getters.hasPermission('user:edit');
    }
  }
}
</script>
```
