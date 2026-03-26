# Divider 分割线

间隔内容的分割线。

## 基础用法

对不同章节的文本段落进行分割。

```vue
<template>
  <div>
    <span>青春是一个短暂的美梦, 当你醒来时, 它早已消失无踪</span>
    <el-divider></el-divider>
    <span>少量的邪恶足以抵消全部高贵的品质, 害得人声名狼藉</span>
  </div>
</template>
```

## 设置文案

可以在分割线上自定义文案内容。

```vue
<template>
  <div>
    <span>头上一片晴天，心中一个想念</span>
    <el-divider content-position="left">少年包青天</el-divider>
    <span>饿了别叫妈, 叫饿了么</span>
    <el-divider><i class="el-icon-mobile-phone"></i></el-divider>
    <span>为了无法计算的价值</span>
    <el-divider content-position="right">阿里云</el-divider>
  </div>
</template>
```

## 垂直分割

```vue
<template>
  <div>
    <span>雨纷纷</span>
    <el-divider direction="vertical"></el-divider>
    <span>旧故里</span>
    <el-divider direction="vertical"></el-divider>
    <span>草木深</span>
  </div>
</template>
```

## Divider Attributes

| 参数 | 说明 | 类型 | 可选值 | 默认值 |
|------|------|------|--------|--------|
| direction | 设置分割线方向 | string | horizontal / vertical | horizontal |
| content-position | 设置分割线文案的位置 | string | left / right / center | center |

## 最佳实践

1. **内容分隔**: 使用Divider分隔不同的内容区块,提升页面可读性
2. **文案设置**: 使用默认插槽设置分隔线上的文案内容
3. **位置控制**: 使用`content-position`属性控制文案位置(left/center/right)
4. **方向设置**: 使用`direction`属性设置分隔线方向(horizontal/vertical)
5. **样式定制**: 通过CSS覆盖默认样式,实现个性化设计
6. **图标使用**: 在插槽中使用图标,增强视觉效果
7. **垂直分隔**: 使用`direction="vertical"`创建垂直分隔线
8. **间距控制**: 通过margin属性控制分隔线的上下间距

## 使用场景

### 基础分隔

```vue
<div>
  <p>第一段内容</p>
  <el-divider></el-divider>
  <p>第二段内容</p>
</div>
```

### 带文案的分隔

```vue
<div>
  <p>第一部分</p>
  <el-divider>基本信息</el-divider>
  <p>第二部分</p>
  <el-divider>详细信息</el-divider>
  <p>第三部分</p>
</div>
```

### 文案位置

```vue
<div>
  <p>内容1</p>
  <el-divider content-position="left">左侧对齐</el-divider>
  <p>内容2</p>
  <el-divider content-position="center">居中对齐</el-divider>
  <p>内容3</p>
  <el-divider content-position="right">右侧对齐</el-divider>
  <p>内容4</p>
</div>
```

### 图标分隔

```vue
<div>
  <p>内容1</p>
  <el-divider>
    <i class="el-icon-star-on"></i>
  </el-divider>
  <p>内容2</p>
  <el-divider>
    <i class="el-icon-s-flag"></i>
  </el-divider>
  <p>内容3</p>
</div>
```

### 垂直分隔

```vue
<div>
  <span>选项1</span>
  <el-divider direction="vertical"></el-divider>
  <span>选项2</span>
  <el-divider direction="vertical"></el-divider>
  <span>选项3</span>
</div>
```

### 表单分隔

```vue
<el-form>
  <el-form-item label="用户名">
    <el-input v-model="form.username"></el-input>
  </el-form-item>
  <el-divider>基本信息</el-divider>
  <el-form-item label="邮箱">
    <el-input v-model="form.email"></el-input>
  </el-form-item>
  <el-form-item label="手机号">
    <el-input v-model="form.phone"></el-input>
  </el-form-item>
  <el-divider>其他信息</el-divider>
  <el-form-item label="地址">
    <el-input v-model="form.address"></el-input>
  </el-form-item>
</el-form>
```

### 卡片分隔

```vue
<el-card>
  <div slot="header">
    <span>用户信息</span>
  </div>
  <div class="user-info">
    <p>姓名: 张三</p>
    <p>年龄: 25</p>
  </div>
  <el-divider>联系方式</el-divider>
  <div class="contact-info">
    <p>邮箱: zhangsan@example.com</p>
    <p>手机: 13800138000</p>
  </div>
</el-card>
```

### 自定义样式

```vue
<el-divider class="custom-divider">自定义样式</el-divider>

<style>
.custom-divider {
  background-color: #409EFF;
}
.custom-divider .el-divider__text {
  background-color: #fff;
  color: #409EFF;
  font-weight: 600;
}
</style>
```
