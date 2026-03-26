# Button 按钮

常用的操作按钮。

## 基础用法

```vue
<el-button>默认按钮</el-button>
<el-button type="primary">主要按钮</el-button>
<el-button type="success">成功按钮</el-button>
<el-button type="info">信息按钮</el-button>
<el-button type="warning">警告按钮</el-button>
<el-button type="danger">危险按钮</el-button>
```

## 朴素按钮

```vue
<el-button plain>朴素按钮</el-button>
<el-button type="primary" plain>主要按钮</el-button>
<el-button type="success" plain>成功按钮</el-button>
```

## 圆角按钮

```vue
<el-button round>圆角按钮</el-button>
<el-button type="primary" round>主要按钮</el-button>
```

## 圆形按钮

```vue
<el-button icon="el-icon-search" circle></el-button>
<el-button type="primary" icon="el-icon-edit" circle></el-button>
```

## 禁用状态

```vue
<el-button disabled>默认按钮</el-button>
<el-button type="primary" disabled>主要按钮</el-button>
```

## 文字按钮

```vue
<el-button type="text">文字按钮</el-button>
<el-button type="text" disabled>文字按钮</el-button>
```

## 图标按钮

```vue
<el-button type="primary" icon="el-icon-edit"></el-button>
<el-button type="primary" icon="el-icon-search">搜索</el-button>
<el-button type="primary">上传<i class="el-icon-upload el-icon--right"></i></el-button>
```

## 按钮组

```vue
<el-button-group>
  <el-button type="primary" icon="el-icon-arrow-left">上一页</el-button>
  <el-button type="primary">下一页<i class="el-icon-arrow-right el-icon--right"></i></el-button>
</el-button-group>
```

## 加载中

```vue
<el-button type="primary" :loading="true">加载中</el-button>
```

## 不同尺寸

```vue
<el-button>默认按钮</el-button>
<el-button size="medium">中等按钮</el-button>
<el-button size="small">小型按钮</el-button>
<el-button size="mini">超小按钮</el-button>
```

## Attributes

| 参数 | 说明 | 类型 | 可选值 | 默认值 |
|------|------|------|--------|--------|
| size | 尺寸 | string | medium / small / mini | — |
| type | 类型 | string | primary / success / warning / danger / info / text | — |
| plain | 是否朴素按钮 | boolean | — | false |
| round | 是否圆角按钮 | boolean | — | false |
| circle | 是否圆形按钮 | boolean | — | false |
| loading | 是否加载中状态 | boolean | — | false |
| disabled | 是否禁用状态 | boolean | — | false |
| icon | 图标类名 | string | — | — |
| autofocus | 是否默认聚焦 | boolean | — | false |
| native-type | 原生 type 属性 | string | button / submit / reset | button |

## 最佳实践

- 使用 `type` 属性区分按钮的语义（主要、成功、警告、危险）
- 长时间操作使用 `loading` 状态提供用户反馈
- 表单提交按钮使用 `native-type="submit"`
- 图标按钮使用 `circle` 属性可以节省空间
