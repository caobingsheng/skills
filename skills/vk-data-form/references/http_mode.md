# HTTP请求模式与自定义Function

## HTTP请求模式

设置 `is-request=true` 使用 HTTP 请求。

```vue
<vk-data-form
  ref="form1"
  v-model="form1.data"
  action="https://www.xxx.com/api/form"
  :is-request="true"
  :request-header="{ 'content-type': 'application/json; charset=utf-8' }"
  :columns="form1.props.columns"
  @success="onFormSuccess"
></vk-data-form>
```

## 自定义Function请求

### 云函数请求

```javascript
form1: {
  props: {
    action: (obj = {}) => {
      let { data, success, fail, complete } = obj;
      vk.callFunction({
        url: "admin/xxx/sys/add",
        data: data,
        success: (res) => {
          if (typeof success === "function") success(res);
        },
        fail: (res) => {
          if (typeof fail === "function") fail(res);
        },
        complete: (res) => {
          if (typeof complete === "function") complete(res);
        }
      });
    }
  }
}
```

### HTTP请求

```javascript
form1: {
  props: {
    action: (obj = {}) => {
      let { data, success, fail, complete } = obj;
      vk.request({
        url: `https://www.xxx.com/api/form`,
        method: "POST",
        header: {
          "content-type": "application/json; charset=utf-8",
        },
        data: data,
        success: (res) => {
          if (typeof success === "function") success(res);
        },
        fail: (res) => {
          if (typeof fail === "function") fail(res);
        },
        complete: (res) => {
          if (typeof complete === "function") complete(res);
        }
      });
    }
  }
}
```

## before-action 请求前拦截

在提交前修改表单数据或阻止提交。

```vue
<vk-data-form
  :before-action="form1.props.beforeAction"
  :columns="form1.props.columns"
></vk-data-form>
```

```javascript
form1: {
  props: {
    beforeAction: (formData) => {
      // 修改表单数据
      formData.updated_at = Date.now();
      // 返回修改后的数据
      return formData;
      // 如果 return false，则阻止提交
      // return false;
    }
  }
}
```
