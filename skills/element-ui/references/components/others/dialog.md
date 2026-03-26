# Dialog 对话框

Dialog 对话框用于在保留当前页面状态的情况下，告知用户并承载相关操作。

## 基础用法

### 基本用法
```vue
<el-button type="text" @click="dialogVisible = true">点击打开 Dialog</el-button>

<el-dialog title="提示" :visible.sync="dialogVisible" width="30%" :before-close="handleClose">
  <span>这是一段信息</span>
  <span slot="footer" class="dialog-footer">
    <el-button @click="dialogVisible = false">取 消</el-button>
    <el-button type="primary" @click="dialogVisible = false">确 定</el-button>
  </span>
</el-dialog>

<script>
export default {
  data() {
    return {
      dialogVisible: false
    };
  },
  methods: {
    handleClose(done) {
      this.$confirm('确认关闭？')
        .then(_ => {
          done();
        })
        .catch(_ => {});
    }
  }
};
</script>
```

### 自定义内容（嵌套表格）
```vue
<el-button type="text" @click="dialogTableVisible = true">打开嵌套表格的 Dialog</el-button>

<el-dialog title="收货地址" :visible.sync="dialogTableVisible">
  <el-table :data="gridData">
    <el-table-column property="date" label="日期" width="150"></el-table-column>
    <el-table-column property="name" label="姓名" width="200"></el-table-column>
    <el-table-column property="address" label="地址"></el-table-column>
  </el-table>
</el-dialog>

<script>
export default {
  data() {
    return {
      gridData: [
        { date: '2016-05-02', name: '王小虎', address: '上海市普陀区金沙江路 1518 弄' },
        { date: '2016-05-04', name: '王小虎', address: '上海市普陀区金沙江路 1518 弄' }
      ],
      dialogTableVisible: false
    };
  }
};
</script>
```

### 自定义内容（嵌套表单）
```vue
<el-button type="text" @click="dialogFormVisible = true">打开嵌套表单的 Dialog</el-button>

<el-dialog title="收货地址" :visible.sync="dialogFormVisible">
  <el-form :model="form">
    <el-form-item label="活动名称" :label-width="formLabelWidth">
      <el-input v-model="form.name" autocomplete="off"></el-input>
    </el-form-item>
    <el-form-item label="活动区域" :label-width="formLabelWidth">
      <el-select v-model="form.region" placeholder="请选择活动区域">
        <el-option label="区域一" value="shanghai"></el-option>
        <el-option label="区域二" value="beijing"></el-option>
      </el-select>
    </el-form-item>
  </el-form>
  <div slot="footer" class="dialog-footer">
    <el-button @click="dialogFormVisible = false">取 消</el-button>
    <el-button type="primary" @click="dialogFormVisible = false">确 定</el-button>
  </div>
</el-dialog>

<script>
export default {
  data() {
    return {
      dialogFormVisible: false,
      form: {
        name: '',
        region: ''
      },
      formLabelWidth: '120px'
    };
  }
};
</script>
```

### 嵌套的 Dialog
```vue
<el-button type="text" @click="outerVisible = true">点击打开外层 Dialog</el-button>

<el-dialog title="外层 Dialog" :visible.sync="outerVisible">
  <el-dialog width="30%" title="内层 Dialog" :visible.sync="innerVisible" append-to-body>
  </el-dialog>
  <div slot="footer" class="dialog-footer">
    <el-button @click="outerVisible = false">取 消</el-button>
    <el-button type="primary" @click="innerVisible = true">打开内层 Dialog</el-button>
  </div>
</el-dialog>

<script>
export default {
  data() {
    return {
      outerVisible: false,
      innerVisible: false
    };
  }
};
</script>
```

### 居中布局
```vue
<el-button type="text" @click="centerDialogVisible = true">点击打开 Dialog</el-button>

<el-dialog title="提示" :visible.sync="centerDialogVisible" width="30%" center>
  <span>需要注意的是内容是默认不居中的</span>
  <span slot="footer" class="dialog-footer">
    <el-button @click="centerDialogVisible = false">取 消</el-button>
    <el-button type="primary" @click="centerDialogVisible = false">确 定</el-button>
  </span>
</el-dialog>

<script>
export default {
  data() {
    return {
      centerDialogVisible: false
    };
  }
};
</script>
```

### 嵌套的 Dialog
如果需要在一个 Dialog 内部嵌套另一个 Dialog，必须使用 `append-to-body` 属性。

```vue
<el-button type="text" @click="outerVisible = true">点击打开外层 Dialog</el-button>

<el-dialog title="外层 Dialog" :visible.sync="outerVisible">
  <el-dialog width="30%" title="内层 Dialog" :visible.sync="innerVisible" append-to-body>
  </el-dialog>
  <div slot="footer" class="dialog-footer">
    <el-button @click="outerVisible = false">取 消</el-button>
    <el-button type="primary" @click="innerVisible = true">打开内层 Dialog</el-button>
  </div>
</el-dialog>

<script>
export default {
  data() {
    return {
      outerVisible: false,
      innerVisible: false
    };
  }
};
</script>
```

### 自定义内容
```vue
<el-button type="text" @click="dialogVisible = true">点击打开 Dialog</el-button>

<el-dialog title="收货地址" :visible.sync="dialogVisible">
  <el-form :model="form">
    <el-form-item label="活动名称" :label-width="formLabelWidth">
      <el-input v-model="form.name" autocomplete="off"></el-input>
    </el-form-item>
    <el-form-item label="活动区域" :label-width="formLabelWidth">
      <el-select v-model="form.region" placeholder="请选择活动区域">
        <el-option label="区域一" value="shanghai"></el-option>
        <el-option label="区域二" value="beijing"></el-option>
      </el-select>
    </el-form-item>
  </el-form>
  <div slot="footer" class="dialog-footer">
    <el-button @click="dialogVisible = false">取 消</el-button>
    <el-button type="primary" @click="dialogVisible = false">确 定</el-button>
  </div>
</el-dialog>

<script>
export default {
  data() {
    return {
      dialogVisible: false,
      form: {
        name: '',
        region: ''
      },
      formLabelWidth: '120px'
    };
  }
};
</script>
```

## Attributes

| 参数 | 说明 | 类型 | 可选值 | 默认值 |
|------|------|------|--------|--------|
| visible | 是否显示 Dialog，支持 .sync 修饰符 | boolean | — | false |
| title | Dialog 的标题 | string | — | — |
| width | Dialog 的宽度 | string | — | 50% |
| fullscreen | 是否为全屏 Dialog | boolean | — | false |
| top | Dialog CSS 中的 margin-top 值 | string | — | 15vh |
| modal | 是否需要遮罩层 | boolean | — | true |
| modal-append-to-body | 遮罩层是否插入至 body 元素上 | boolean | — | true |
| append-to-body | Dialog 自身是否插入至 body 元素上 | boolean | — | false |
| lock-scroll | 是否在 Dialog 出现时将 body 滚动锁定 | boolean | — | true |
| custom-class | Dialog 的自定义类名 | string | — | — |
| close-on-click-modal | 是否可以通过点击 modal 关闭 Dialog | boolean | — | true |
| close-on-press-escape | 是否可以通过按下 ESC 关闭 Dialog | boolean | — | true |
| show-close | 是否显示关闭按钮 | boolean | — | true |
| before-close | 关闭前的回调 | function(done) | — | — |
| center | 是否对头部和底部采用居中布局 | boolean | — | false |
| destroy-on-close | 关闭时销毁 Dialog 中的元素 | boolean | — | false |

## Slot

| name | 说明 |
|------|------|
| — | Dialog 的内容 |
| title | Dialog 标题区的内容 |
| footer | Dialog 按钮操作区的内容 |

## Events

| 事件名称 | 说明 | 回调参数 |
|----------|------|----------|
| open | Dialog 打开的回调 | — |
| opened | Dialog 打开动画结束时的回调 | — |
| close | Dialog 关闭的回调 | — |
| closed | Dialog 关闭动画结束时的回调 | — |

## 最佳实践

1. **嵌套 Dialog**：如果需要在一个 Dialog 内部嵌套另一个 Dialog，必须使用 `append-to-body` 属性
2. **懒渲染**：Dialog 的内容是懒渲染的，第一次打开之前 slot 不会被渲染到 DOM 上
3. **DOM 操作**：如果需要执行 DOM 操作或通过 ref 获取组件，请在 `open` 事件回调中进行
4. **Vuex 绑定**：如果 visible 属性绑定的变量位于 Vuex 的 store 内，需要去除 .sync 修饰符，监听 open 和 close 事件
5. **居中布局**：`center` 属性仅影响标题和底部区域，内容需要自行添加 CSS 实现居中
