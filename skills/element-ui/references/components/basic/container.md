# Container 布局容器

用于布局的容器组件,方便快速搭建页面的基本结构。

## 常见页面布局

```vue
<el-container>
  <el-header>Header</el-header>
  <el-container>
    <el-aside width="200px">Aside</el-aside>
    <el-container>
      <el-main>Main</el-main>
      <el-footer>Footer</el-footer>
    </el-container>
  </el-container>
</el-container>
```

## 示例

```vue
<el-container>
  <el-header>Header</el-header>
  <el-main>Main</el-main>
</el-container>

<el-container>
  <el-header>Header</el-header>
  <el-main>Main</el-main>
  <el-footer>Footer</el-footer>
</el-container>

<el-container>
  <el-aside width="200px">Aside</el-aside>
  <el-main>Main</el-main>
</el-container>

<el-container>
  <el-header>Header</el-header>
  <el-container>
    <el-aside width="200px">Aside</el-aside>
    <el-main>Main</el-main>
  </el-container>
</el-container>

<el-container>
  <el-header>Header</el-header>
  <el-container>
    <el-aside width="200px">Aside</el-aside>
    <el-container>
      <el-main>Main</el-main>
      <el-footer>Footer</el-footer>
    </el-container>
  </el-container>
</el-container>
```

## Container Attributes

| 参数 | 说明 | 类型 | 可选值 | 默认值 |
|------|------|------|--------|--------|
| direction | 子元素的排列方向 | string | horizontal / vertical | 子元素中有 `el-header` 或 `el-footer` 时为 vertical,否则为 horizontal |

## Header Attributes

| 参数 | 说明 | 类型 | 可选值 | 默认值 |
|------|------|------|--------|--------|
| height | 顶栏高度 | string | — | 60px |

## Aside Attributes

| 参数 | 说明 | 类型 | 可选值 | 默认值 |
|------|------|------|--------|--------|
| width | 侧边栏宽度 | string | — | 300px |

## Main Attributes

| 参数 | 说明 | 类型 | 可选值 | 默认值 |
|------|------|------|--------|--------|
| — | — | — | — | — |

## Footer Attributes

| 参数 | 说明 | 类型 | 可选值 | 默认值 |
|------|------|------|--------|--------|
| height | 底栏高度 | string | — | 60px |

## 最佳实践

1. **嵌套结构**: Container可以嵌套使用,创建复杂的页面布局
2. **方向控制**: 使用`direction`属性控制子元素排列方向(horizontal/vertical)
3. **高度设置**: 使用`height`属性设置Header和Footer的高度
4. **宽度设置**: 使用`width`属性设置Aside的宽度
5. **响应式**: 配合Layout组件的响应式属性,实现自适应布局
6. **语义化**: 使用Container组件创建语义化的页面结构
7. **布局组合**: 灵活组合Header、Aside、Main、Footer,满足不同布局需求
8. **样式定制**: 通过CSS覆盖默认样式,实现个性化设计
