# Card 卡片

将信息聚合在卡片容器中展示。

## 基础用法

### 基础用法
包含标题，内容和操作。Card 组件包括 `header` 和 `body` 部分，`header` 部分需要有显式具名 slot 分发，同时也是可选的。

```vue
<el-card class="box-card">
  <div slot="header" class="clearfix">
    <span>卡片名称</span>
    <el-button style="float: right; padding: 3px 0" type="text">操作按钮</el-button>
  </div>
  <div v-for="o in 4" :key="o" class="text item">
    {{'列表内容 ' + o }}
  </div>
</el-card>

<style>
.text {
  font-size: 14px;
}
.item {
  margin-bottom: 18px;
}
.clearfix:before,
.clearfix:after {
  display: table;
  content: "";
}
.clearfix:after {
  clear: both
}
.box-card {
  width: 480px;
}
</style>
```

### 简单卡片
卡片可以只有内容区域。

```vue
<el-card class="box-card">
  <div v-for="o in 4" :key="o" class="text item">
    {{'列表内容 ' + o }}
  </div>
</el-card>

<style>
.text {
  font-size: 14px;
}
.item {
  padding: 18px 0;
}
.box-card {
  width: 480px;
}
</style>
```

### 带图片
可配置定义更丰富的内容展示。配置 `body-style` 属性来自定义 `body` 部分的 `style`。

```vue
<el-row>
  <el-col :span="8" v-for="(o, index) in 2" :key="o" :offset="index > 0 ? 2 : 0">
    <el-card :body-style="{ padding: '0px' }">
      <img src="https://shadow.elemecdn.com/app/element/hamburger.9cf7b091-55e9-11e9-a976-7f4d0b07eef6.png" class="image">
      <div style="padding: 14px;">
        <span>好吃的汉堡</span>
        <div class="bottom clearfix">
          <time class="time">{{ currentDate }}</time>
          <el-button type="text" class="button">操作按钮</el-button>
        </div>
      </div>
    </el-card>
  </el-col>
</el-row>

<style>
.time {
  font-size: 13px;
  color: #999;
}
.bottom {
  margin-top: 13px;
  line-height: 12px;
}
.button {
  padding: 0;
  float: right;
}
.image {
  width: 100%;
  display: block;
}
.clearfix:before,
.clearfix:after {
  display: table;
  content: "";
}
.clearfix:after {
  clear: both
}
</style>

<script>
export default {
  data() {
    return {
      currentDate: new Date()
    };
  }
};
</script>
```

### 卡片阴影
可对阴影的显示进行配置。通过 `shadow` 属性设置卡片阴影出现的时机：`always`、`hover` 或 `never`。

```vue
<el-row :gutter="12">
  <el-col :span="8">
    <el-card shadow="always">
      总是显示
    </el-card>
  </el-col>
  <el-col :span="8">
    <el-card shadow="hover">
      鼠标悬浮时显示
    </el-card>
  </el-col>
  <el-col :span="8">
    <el-card shadow="never">
      从不显示
    </el-card>
  </el-col>
</el-row>
```

## Attributes

| 参数 | 说明 | 类型 | 可选值 | 默认值 |
|------|------|------|--------|--------|
| header | 设置 header，也可以通过 slot#header 传入 DOM | string | — | — |
| body-style | 设置 body 的样式 | object | — | { padding: '20px' } |
| shadow | 设置阴影显示时机 | string | always / hover / never | always |

## Slots

| Name | 说明 |
|------|------|
| header | 卡片标题内容 |

## 最佳实践

1. **卡片布局**：使用 `el-row` 和 `el-col` 组件实现卡片的网格布局。

2. **图片卡片**：设置 `body-style` 为 `{ padding: '0px' }` 实现图片铺满卡片的效果。

3. **阴影效果**：根据使用场景选择合适的阴影显示时机，`hover` 适合交互性强的场景。

4. **卡片内容**：在卡片中使用列表、表格、表单等组件，构建丰富的内容展示。

5. **响应式设计**：结合栅格系统实现卡片的响应式布局，适配不同屏幕尺寸。
