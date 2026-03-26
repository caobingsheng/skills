# 插槽使用

## 字段插槽

columns 中每个 key 都可以作为插槽名来自定义渲染。

### 自定义 rate 评分组件

```vue
<vk-data-form
  ref="form1"
  v-model="form1.data"
  :columns="form1.props.columns"
>
  <template v-slot:rate="{ form, keyName }">
    <el-rate v-model="form[keyName]"></el-rate>
  </template>
</vk-data-form>
```

### 自定义 select 组件

```vue
<vk-data-form
  ref="form1"
  v-model="form1.data"
  :columns="form1.props.columns"
>
  <template v-slot:city="{ form, keyName }">
    <el-select v-model="form[keyName]" placeholder="请选择城市">
      <el-option label="上海" value="shanghai"></el-option>
      <el-option label="北京" value="beijing"></el-option>
    </el-select>
  </template>
</vk-data-form>
```

## 底部插槽 (footer)

自定义提交按钮区域。

### 自定义审核按钮

```vue
<vk-data-form
  ref="form1"
  v-model="form1.data"
  :columns="form1.props.columns"
  :loading.sync="form1.props.loading"
>
  <template v-slot:footer="{ loading }">
    <view style="text-align: center;">
      <el-button
        :loading="loading"
        type="danger"
        size="small"
        @click="adopt(-1)"
      >拒绝</el-button>
      <el-button
        :loading="loading"
        type="success"
        size="small"
        @click="adopt(1)"
      >通过</el-button>
    </view>
  </template>
</vk-data-form>
```

```javascript
methods: {
  adopt(status) {
    that.$refs.form1.submitForm({
      data: { status: status },
      success: (data) => {
        console.log("审核完成");
      }
    });
  }
}
```

### 自定义保存按钮

```vue
<vk-data-form
  ref="form1"
  v-model="form1.data"
  :columns="form1.props.columns"
>
  <template v-slot:footer="{ loading }">
    <el-button type="primary" :loading="loading" @click="saveDraft">
      保存草稿
    </el-button>
    <el-button :loading="loading" @click="submitForm">
      正式提交
    </el-button>
  </template>
</vk-data-form>
```

## 插槽参数说明

| 参数 | 说明 |
|------|------|
| `form` | 表单数据对象 |
| `keyName` | 当前字段的 key |
| `loading` | 提交状态 |
