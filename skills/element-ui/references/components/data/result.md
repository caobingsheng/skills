# Result 结果

用于对用户的操作结果或者异常状态做反馈。

## 基础用法

```vue
<el-row>
  <el-col :sm="12" :lg="6">
    <el-result icon="success" title="成功提示" subTitle="请根据提示进行操作">
      <template slot="extra">
        <el-button type="primary" size="medium">返回</el-button>
      </template>
    </el-result>
  </el-col>
  <el-col :sm="12" :lg="6">
    <el-result icon="warning" title="警告提示" subTitle="请根据提示进行操作">
      <template slot="extra">
        <el-button type="primary" size="medium">返回</el-button>
      </template>
    </el-result>
  </el-col>
  <el-col :sm="12" :lg="6">
    <el-result icon="error" title="错误提示" subTitle="请根据提示进行操作">
      <template slot="extra">
        <el-button type="primary" size="medium">返回</el-button>
      </template>
    </el-result>
  </el-col>
  <el-col :sm="12" :lg="6">
    <el-result icon="info" title="信息提示" subTitle="请根据提示进行操作">
      <template slot="extra">
        <el-button type="primary" size="medium">返回</el-button>
      </template>
    </el-result>
  </el-col>
</el-row>
```

## 自定义内容

```vue
<el-result title="404" subTitle="抱歉，请求错误">
  <template slot="icon">
    <el-image src="https://shadow.elemecdn.com/app/element/hamburger.9cf7b091-55e9-11e9-a976-7f4d0b07eef6.png"></el-image>
  </template>
  <template slot="extra">
    <el-button type="primary" size="medium">返回</el-button>
  </template>
</el-result>
```

## Result Attributes

| 参数 | 说明 | 类型 | 可选值 | 默认值 |
|------|------|------|--------|--------|
| title | 标题 | string | — | — |
| sub-title | 二级标题 | string | — | — |
| icon | 图标类型 | string | success / warning / info / error | info |

## Result Slots

| Name | 说明 |
|------|------|
| icon | 自定义图标 |
| title | 自定义标题 |
| subTitle | 自定义二级标题 |
| extra | 自定义底部额外区域 |

## 最佳实践

1. **结果反馈**: 使用Result组件对用户的操作结果或异常状态做反馈
2. **图标类型**: 使用`icon`属性设置图标类型(success/warning/error/info)
3. **标题设置**: 使用`title`属性设置结果标题,简洁明了
4. **副标题**: 使用`subTitle`属性设置副标题,提供更多细节
5. **操作按钮**: 使用`extra`插槽添加操作按钮,引导用户进行下一步操作
6. **自定义图标**: 使用`icon`插槽自定义图标内容
7. **场景适配**: 根据不同场景选择合适的结果类型
8. **响应式**: 在不同屏幕尺寸下调整布局,保持良好的视觉效果

## 使用场景

### 成功结果
```vue
<el-result
  icon="success"
  title="操作成功"
  subTitle="数据已成功保存到数据库">
  <template slot="extra">
    <el-button type="primary" size="medium">返回列表</el-button>
  </template>
</el-result>
```

### 错误结果
```vue
<el-result
  icon="error"
  title="操作失败"
  subTitle="保存数据时发生错误,请稍后重试">
  <template slot="extra">
    <el-button type="primary" size="medium">重试</el-button>
    <el-button size="medium">取消</el-button>
  </template>
</el-result>
```

### 警告结果
```vue
<el-result
  icon="warning"
  title="警告"
  subTitle="此操作可能会影响系统性能">
  <template slot="extra">
    <el-button type="primary" size="medium">继续</el-button>
    <el-button size="medium">取消</el-button>
  </template>
</el-result>
```

### 信息结果
```vue
<el-result
  icon="info"
  title="提示"
  subTitle="请确认您的操作">
  <template slot="extra">
    <el-button type="primary" size="medium">确认</el-button>
  </template>
</el-result>
```

### 404页面
```vue
<el-result
  icon="error"
  title="404"
  subTitle="抱歉,您访问的页面不存在">
  <template slot="extra">
    <el-button type="primary" size="medium" @click="goHome">返回首页</el-button>
  </template>
</el-result>
```

### 500页面
```vue
<el-result
  icon="error"
  title="500"
  subTitle="抱歉,服务器出错了">
  <template slot="extra">
    <el-button type="primary" size="medium" @click="goHome">返回首页</el-button>
  </template>
</el-result>
```

### 自定义图标
```vue
<el-result
  title="自定义图标"
  subTitle="使用自定义图片作为图标">
  <template slot="icon">
    <el-image
      src="https://shadow.elemecdn.com/app/element/hamburger.9cf7b091-55e9-11e9-a976-7f4d0b07eef6.png"
      style="width: 200px;">
    </el-image>
  </template>
  <template slot="extra">
    <el-button type="primary" size="medium">返回</el-button>
  </template>
</el-result>
```

### 表单提交成功
```vue
<el-result
  icon="success"
  title="提交成功"
  subTitle="您的表单已成功提交,我们将尽快处理">
  <template slot="extra">
    <el-button type="primary" size="medium" @click="goHome">返回首页</el-button>
    <el-button size="medium" @click="viewDetail">查看详情</el-button>
  </template>
</el-result>
```

### 支付成功
```vue
<el-result
  icon="success"
  title="支付成功"
  subTitle="订单号: 202401260001">
  <template slot="extra">
    <el-button type="primary" size="medium" @click="viewOrder">查看订单</el-button>
    <el-button size="medium" @click="continueShopping">继续购物</el-button>
  </template>
</el-result>
```

### 权限不足
```vue
<el-result
  icon="warning"
  title="权限不足"
  subTitle="您没有权限访问此页面">
  <template slot="extra">
    <el-button type="primary" size="medium" @click="goHome">返回首页</el-button>
  </template>
</el-result>
```
