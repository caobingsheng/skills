# Link 文字链接

文字超链接。

## 基础用法

```vue
<el-link href="https://element.eleme.io" target="_blank">默认链接</el-link>
<el-link type="primary">主要链接</el-link>
<el-link type="success">成功链接</el-link>
<el-link type="warning">警告链接</el-link>
<el-link type="danger">危险链接</el-link>
<el-link type="info">信息链接</el-link>
```

## 禁用状态

```vue
<el-link disabled>默认链接</el-link>
<el-link type="primary" disabled>主要链接</el-link>
<el-link type="success" disabled>成功链接</el-link>
```

## 下划线

```vue
<el-link :underline="false">无下划线</el-link>
<el-link>有下划线</el-link>
```

## 图标

```vue
<el-link icon="el-icon-edit">编辑</el-link>
<el-link>查看<i class="el-icon-view el-icon--right"></i></el-link>
```

## Attributes

| 参数 | 说明 | 类型 | 可选值 | 默认值 |
|------|------|------|--------|--------|
| type | 类型 | string | primary / success / warning / danger / info | default |
| underline | 是否下划线 | boolean | — | true |
| disabled | 是否禁用状态 | boolean | — | false |
| href | 原生 href 属性 | string | — | - |
| icon | 图标类名 | string | — | - |

## 最佳实践

1. **语义区分**: 使用 `type` 属性区分链接的语义（主要、成功、警告、危险）
2. **下划线控制**: 使用 `underline` 属性控制是否显示下划线
3. **禁用状态**: 使用 `disabled` 属性禁用链接
4. **图标使用**: 使用 `icon` 属性添加图标,提升视觉效果
5. **外部链接**: 使用 `href` 和 `target="_blank"` 打开外部链接
6. **路由跳转**: 结合 Vue Router 使用 `to` 属性进行路由跳转
7. **链接组合**: 在表格、列表中使用链接,提供快速导航
8. **文本提示**: 使用链接提供更多信息的入口,如"查看详情"、"了解更多"等

## 使用场景

### 表格操作链接

```vue
<el-table :data="tableData">
  <el-table-column prop="name" label="姓名"></el-table-column>
  <el-table-column label="操作">
    <template slot-scope="scope">
      <el-link type="primary" @click="handleView(scope.row)">查看</el-link>
      <el-divider direction="vertical"></el-divider>
      <el-link type="primary" @click="handleEdit(scope.row)">编辑</el-link>
    </template>
  </el-table-column>
</el-table>
```

### 文档链接

```vue
<div class="help-links">
  <el-link type="primary" href="/docs" target="_blank">使用文档</el-link>
  <el-link type="info" href="/faq" target="_blank">常见问题</el-link>
  <el-link type="success" href="/contact" target="_blank">联系我们</el-link>
</div>
```

### 下载链接

```vue
<el-link icon="el-icon-download" :href="downloadUrl" :download="fileName">
  下载文件
</el-link>
```

### 路由跳转

```vue
<el-link :to="{ name: 'UserDetail', params: { id: userId }}" type="primary">
  查看用户详情
</el-link>
```
