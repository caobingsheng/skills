# Drawer 抽屉

有些时候,Dialog对话框并不满足我们的需求,比如你的表单很长,亦或是你需要临时展示一些文档,Drawer抽屉式导航从屏幕边缘滑出,可以让你完成更多的任务。

## 基础用法

点击按钮唤出抽屉。

```vue
<el-button type="text" @click="drawer = true">打开</el-button>

<el-drawer
  title="我是标题"
  :visible.sync="drawer"
  direction="rtl"
  size="50%">
  <span>我来啦!</span>
</el-drawer>

<script>
export default {
  data() {
    return {
      drawer: false
    };
  }
};
</script>
```

## 不添加 Title

当你不需要标题时,可以通过设置`with-header`属性为`false`来隐藏标题栏。

```vue
<el-button type="text" @click="drawer = true">打开</el-button>

<el-drawer
  :visible.sync="drawer"
  :with-header="false">
  <span>我来啦!</span>
</el-drawer>

<script>
export default {
  data() {
    return {
      drawer: false
    };
  }
};
</script>
```

## 自定义内容

Drawer的内容可以是任何内容,比如表单、表格等。

```vue
<el-button type="text" @click="drawer = true">打开</el-button>

<el-drawer
  title="我是标题"
  :visible.sync="drawer"
  size="50%">
  <el-form :model="form">
    <el-form-item label="活动名称">
      <el-input v-model="form.name"></el-input>
    </el-form-item>
    <el-form-item label="活动区域">
      <el-select v-model="form.region" placeholder="请选择活动区域">
        <el-option label="区域一" value="shanghai"></el-option>
        <el-option label="区域二" value="beijing"></el-option>
      </el-select>
    </el-form-item>
  </el-form>
  <div class="demo-drawer__footer">
    <el-button @click="drawer = false">取 消</el-button>
    <el-button type="primary" @click="drawer = false">确 定</el-button>
  </div>
</el-drawer>

<script>
export default {
  data() {
    return {
      drawer: false,
      form: {
        name: '',
        region: ''
      }
    };
  }
};
</script>
```

## Attributes

| 参数 | 说明 | 类型 | 可选值 | 默认值 |
|------|------|------|--------|--------|
| append-to-body | Drawer自身是否插入至 body 元素上。嵌套的Drawer必须指定该属性并赋值为 true | boolean | — | false |
| before-close | 关闭前的回调,会暂停Drawer的关闭 | function(done),done用于关闭Drawer | — | — |
| close-on-press-escape | 是否可以通过按下 ESC 关闭 Drawer | boolean | — | true |
| custom-class | Drawer的自定义类名 | string | — | — |
| destroy-on-close | 关闭时销毁Drawer中的元素 | boolean | — | false |
| modal | 是否需要遮罩层 | boolean | — | true |
| modal-append-to-body | 遮罩层是否插入至 body 元素上,若为false,则遮罩层会插入至Drawer的父元素上 | boolean | — | true |
| direction | Drawer打开的方向 | Direction | rtl / ltr / ttb / btt | rtl |
| show-close | 是否显示关闭按钮 | boolean | — | true |
| size | Drawer的大小,当使用number类型时,以像素为单位,当使用string类型时,请传入'x%',否则,以字符串形式传入,如'30%' | number / string | — | '30%' |
| title | Drawer的标题,也可通过具名slot传入 | string | — | — |
| visible | 是否显示Drawer,支持.sync修饰符 | boolean | — | false |
| wrapperClosable | 点击遮罩层是否可以关闭Drawer | boolean | — | true |
| with-header | 控制是否显示header栏 | boolean | — | true |

## Slots

| name | 说明 |
|------|------|
| — | Drawer的内容 |
| title | Drawer标题区的内容 |

## Events

| 事件名称 | 说明 | 回调参数 |
|----------|------|----------|
| open | Drawer打开的回调 | — |
| opened | Drawer打开动画结束时的回调 | — |
| close | Drawer关闭的回调 | — |
| closed | Drawer关闭动画结束时的回调 | — |

## 最佳实践

1. **方向选择**: 根据页面布局选择合适的`direction`(rtl右侧、ltr左侧、ttb顶部、btt底部)
2. **尺寸控制**: 使用`size`属性控制Drawer大小,支持像素值和百分比
3. **嵌套使用**: 嵌套Drawer时必须设置`append-to-body`为true
4. **关闭控制**: 通过`before-close`实现关闭前的确认逻辑
5. **遮罩层**: 使用`modal`和`wrapperClosable`控制遮罩层显示和点击关闭行为
6. **销毁元素**: 设置`destroy-on-close`在关闭时销毁Drawer中的元素,避免内存泄漏
7. **自定义样式**: 使用`custom-class`添加自定义类名,实现样式定制
