# 弹窗表单独立组件

## 概述

将表单拆分为独立组件，便于维护和复用。

## 创建弹窗表单组件

### 1. 创建组件文件

在页面目录下创建 `form/bindRole.vue`：

```vue
<template>
  <vk-data-dialog
    v-model="value.show"
    :title="page.title"
    :top="page.top"
    :width="page.width"
    mode="form"
    @open="onOpen"
    @closed="onClose"
  >
    <vk-data-form
      ref="form1"
      :form-type="value.mode"
      v-loading="page.loading"
      v-model="form1.data"
      :rules="form1.props.rules"
      :action="form1.props.action"
      :columns="form1.props.columns"
      :loading.sync="form1.props.loading"
      :label-width="form1.props.labelWidth"
      :show-cancel="page.showCancel"
      :cancel-text="page.cancelText"
      :submit-text="page.submitText"
      @success="onFormSuccess"
    >
      <template v-slot:user_id>
        <view style="display: flex; align-items: center;">
          <el-avatar v-if="data.avatar" :src="data.avatar" fit="cover"></el-avatar>
          <text style="margin-left: 10px;">{{ data.nickname }}（ID：{{ data._id }}）</text>
        </view>
      </template>
    </vk-data-form>
  </vk-data-dialog>
</template>

<script>
let that;
let vk = uni.vk;

export default {
  props: {
    value: {
      type: Object,
      default: function() {
        return {
          show: false,
          mode: "",
          item: ""
        };
      }
    }
  },
  data: function() {
    return {
      page: {
        title: "角色绑定",
        submitText: "绑定",
        cancelText: "关闭",
        showCancel: true,
        top: "7vh",
        width: "820px",
        loading: false
      },
      data: {},
      form1: {
        data: {
          user_id: "",
          roleList: [],
          reset: true
        },
        props: {
          action: "admin/system/user/sys/bindRole",
          columns: [
            { key: "user_id", title: "用户", type: "text" },
            {
              key: "roleList",
              title: "角色列表",
              type: "table-select",
              placeholder: "选择角色",
              action: "admin/system/role/sys/getList",
              columns: [
                { key: "role_name", title: "角色昵称", type: "text", nameKey: true },
                { key: "role_id", title: "角色标识", type: "text", idKey: true }
              ],
              multiple: true
            }
          ],
          rules: {
            user_id: [{ required: true, message: "user_id不能为空", trigger: "change" }]
          },
          labelWidth: "100px",
          labelPosition: "left"
        }
      }
    };
  },
  mounted() {
    that = this;
    that.init();
  },
  methods: {
    init() {
      let { value } = that;
      that.$emit("input", value);
    },
    onOpen() {
      that = this;
      let { value } = that;
      let { role = [], _id } = value.item;
      that.data = value.item;
      that.form1.props.show = true;
      that.form1.data.user_id = _id;
      that.form1.data.roleList = role;
    },
    onClose() {
      that.$refs.form1.resetForm();
    },
    onFormSuccess() {
      that.$set(that.value.item, "role", that.form1.data.roleList);
      that.value.show = false;
      that.$emit("success");
    }
  }
};
</script>
```

## 父页面使用

### 1. 引入组件

```javascript
import bindRole from './form/bindRole'

export default {
  components: {
    bindRole
  },
  data() {
    return {
      formDatas: {}
    }
  }
}
```

### 2. 模板中使用

```vue
<el-button type="primary" size="small" icon="el-icon-s-tools" @click="bindRoleBtn">
  角色绑定
</el-button>

<bindRole v-model="formDatas.bindRole"></bindRole>
```

### 3. 打开弹窗

```javascript
methods: {
  bindRoleBtn() {
    let item = this.getCurrentRow(true);
    vk.pubfn.openForm('bindRole', { item });
  }
}
```

## vk.pubfn.openForm API

```javascript
vk.pubfn.openForm(name, value, this);
```

### 参数

| 参数 | 说明 | 类型 | 默认值 |
|------|------|------|--------|
| name | 弹窗表单组件名 | String | - |
| value | 传给表单的数据 | Object | { item: 当前行数据 } |
| this | 页面或组件实例 | Object | 当前页面实例 |

### 示例

```javascript
// 打开角色绑定弹窗
vk.pubfn.openForm('bindRole', { item: rowData });

// 带 mode 参数
vk.pubfn.openForm('editUser', { item: rowData, mode: 'edit' });
```
