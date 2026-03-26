# 表单方法与事件

## 方法

### submitForm - 提交表单

```javascript
that.$refs.form1.submitForm({
  data: { extra: "额外参数" },  // 额外提交的数据
  success: (data) => {
    console.log("提交成功", data);
  },
  fail: (data) => {
    console.log("提交失败", data);
  }
});
```

### resetForm - 重置表单

```javascript
that.$refs.form1.resetForm();
```

### clearValidate - 清除验证

```javascript
// 清除整个表单验证
that.$refs.form1.clearValidate();

// 清除指定字段验证
that.$refs.form1.clearValidate("username");
```

### validate - 表单验证

```javascript
that.$refs.form1.validate((valid) => {
  if (valid) {
    console.log("验证通过");
  } else {
    console.log("验证失败");
  }
});
```

### validateField - 部分字段验证

```javascript
that.$refs.form1.validate("username", (errMsg, arr) => {
  if (errMsg) {
    console.log("未验证通过", errMsg);
  } else {
    console.log("验证通过");
  }
});
```

### setResetFormData - 设置重置数据源

```javascript
// 设置重置后的数据
that.$refs.form1.setResetFormData({
  name: "默认值",
  status: 1
});

// 执行重置
that.$refs.form1.resetForm();
```

## 事件

### success - 提交成功

```vue
<vk-data-form @success="onFormSuccess"></vk-data-form>
```

```javascript
methods: {
  onFormSuccess(res) {
    // res = { data, formType }
    console.log("表单提交成功", res.data);
  }
}
```

### fail - 提交失败

```vue
<vk-data-form @fail="onFormFail"></vk-data-form>
```

```javascript
methods: {
  onFormFail(res) {
    // res = { data, formType }
    console.log("表单提交失败", res.data);
  }
}
```

### complete - 提交结束

```vue
<vk-data-form @complete="onFormComplete"></vk-data-form>
```

```javascript
methods: {
  onFormComplete(res) {
    // res = { data, formType }
    console.log("表单提交结束", res.data);
  }
}
```

### cancel - 点击取消

```vue
<vk-data-form @cancel="onFormCancel"></vk-data-form>
```

```javascript
methods: {
  onFormCancel() {
    console.log("用户点击取消");
  }
}
```
