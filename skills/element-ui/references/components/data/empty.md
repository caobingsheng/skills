# Empty 空状态

空状态时的占位提示。

## 基础用法

```vue
<el-empty description="描述文字"></el-empty>
```

## 自定义图片

通过设置 `image` 属性传入图片 URL。

```vue
<el-empty image="https://shadow.elemecdn.com/app/element/hamburger.9cf7b091-55e9-11e9-a976-7f4d0b07eef6.png"></el-empty>
```

## 图片尺寸

通过设置 `image-size` 属性来控制图片大小。

```vue
<el-empty :image-size="200"></el-empty>
```

## 底部内容

使用默认插槽可在底部插入内容。

```vue
<el-empty>
  <el-button type="primary">按钮</el-button>
</el-empty>
```

## Empty Attributes

| 参数 | 说明 | 类型 | 可选值 | 默认值 |
|------|------|------|--------|--------|
| image | 图片地址 | string | — | — |
| image-size | 图片大小（宽度） | number | — | — |
| description | 文本描述 | string | — | — |

## Empty Slots

| Name | 说明 |
|------|------|
| default | 自定义底部内容 |
| image | 自定义图片 |
| description | 自定义描述文字 |

## 最佳实践

1. **空状态提示**: 使用Empty组件展示空状态,提供友好的用户提示
2. **自定义图片**: 使用`image`属性设置自定义图片,提升视觉效果
3. **图片尺寸**: 使用`image-size`属性设置图片大小,适应不同场景
4. **描述文本**: 使用`description`属性设置描述文本,说明空状态原因
5. **操作按钮**: 使用默认插槽添加操作按钮,引导用户进行下一步操作
6. **自定义图片**: 使用`image`插槽自定义图片内容
7. **场景适配**: 根据不同场景选择合适的空状态提示
8. **加载状态**: 结合Loading组件,先显示Loading,加载完成后显示Empty

## 使用场景

### 基础空状态

```vue
<el-empty description="暂无数据"></el-empty>
```

### 自定义图片

```vue
<el-empty
  image="https://shadow.elemecdn.com/app/element/hamburger.9cf7b091-55e9-11e9-a976-7f4d0b07eef6.png"
  description="暂无数据">
</el-empty>
```

### 带操作按钮

```vue
<el-empty description="暂无数据">
  <el-button type="primary" @click="handleAdd">添加数据</el-button>
</el-empty>
```

### 搜索无结果

```vue
<el-empty description="未找到相关结果">
  <el-button @click="handleReset">重置搜索</el-button>
</el-empty>
```

### 权限不足

```vue
<el-empty description="您没有权限访问此页面">
  <el-button type="primary" @click="handleBack">返回首页</el-button>
</el-empty>
```

### 自定义图片尺寸

```vue
<el-empty :image-size="200" description="暂无数据"></el-empty>
```

### 表格空状态

```vue
<el-table :data="tableData">
  <el-table-column prop="name" label="姓名"></el-table-column>
  <template slot="empty">
    <el-empty description="暂无数据"></el-empty>
  </template>
</el-table>
```

### 列表空状态

```vue
<el-empty description="暂无收藏">
  <el-button type="primary" @click="handleBrowse">去浏览</el-button>
</el-empty>
```

### 自定义内容

```vue
<el-empty description="暂无数据">
  <template slot="image">
    <img src="https://example.com/custom-empty.png" style="width: 200px;">
  </template>
  <p>这里还没有任何内容</p>
  <p>您可以点击下方按钮添加</p>
  <el-button type="primary" @click="handleAdd">添加</el-button>
</el-empty>
```

### 加载失败

```vue
<el-empty description="加载失败,请重试">
  <el-button @click="handleReload">重新加载</el-button>
</el-empty>
```

### 网络错误

```vue
<el-empty
  image="https://shadow.elemecdn.com/app/element/error.9cf7b091-55e9-11e9-a976-7f4d0b07eef6.png"
  description="网络连接失败">
  <el-button type="primary" @click="handleRetry">重试</el-button>
</el-empty>
```
