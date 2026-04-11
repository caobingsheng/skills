---
name: vk-data-form
description: "vk-unicloud-admin框架的万能表单组件完整使用指南。Use when working with vk-data-form component for: (1) Creating dynamic forms with JSON configuration, (2) Form validation and submission, (3) Complex field types like select, date, upload, (4) Conditional field display and disabled rules, (5) Dialog form and standalone form components."
---

# vk-data-form 万能表单组件指南

## Overview

`vk-data-form` 是 vk-unicloud-admin 框架提供的万能表单组件，通过 JSON 配置自动渲染表单字段。

## 快速开始

```vue
<vk-data-dialog v-model="form1.props.show" title="表单标题" width="600px" mode="form">
  <vk-data-form
    ref="form1"
    v-model="form1.data"
    :action="form1.props.action"
    :columns="form1.props.columns"
    :rules="form1.props.rules"
    :form-type="form1.props.formType"
    :loading.sync="form1.props.loading"
    label-width="140px"
    @success="onFormSuccess"
  ></vk-data-form>
</vk-data-dialog>
```

```javascript
export default {
  data() {
    return {
      form1: {
        data: {
          radio: 1,
          checkbox: [1, 2]
        },
        props: {
          action: "admin/xxx/sys/add",
          columns: [
            { key: "text", title: "文本", type: "text" },
            { key: "number", title: "数字", type: "number" },
            { key: "radio", title: "单选", type: "radio", data: [
              { value: 1, label: "选项一" },
              { value: 2, label: "选项二" }
            ]}
          ],
          rules: {
            text: [{ required: true, message: "文本不能为空", trigger: "change" }]
          },
          formType: "add",
          loading: false,
          show: false
        }
      }
    };
  },
  methods: {
    onFormSuccess(res) {
      console.log("表单提交成功", res);
    }
  }
}
```

## 字段类型 (columns.type)

| 分类 | 类型 | 说明 |
|------|------|------|
| 基础 | `text` | 单行文本 |
| 基础 | `textarea` | 多行文本 |
| 基础 | `number` | 数字输入 |
| 基础 | `money` | 金额(分转元) |
| 基础 | `percentage` | 百分比 |
| 基础 | `discount` | 折扣 |
| 选择 | `radio` | 单选框 |
| 选择 | `checkbox` | 多选框 |
| 选择 | `select` | 下拉选择 |
| 选择 | `switch` | 开关 |
| 选择 | `rate` | 评分 |
| 选择 | `slider` | 滑块 |
| 选择 | `color` | 颜色选择 |
| 日期 | `date` | 日期选择 |
| 日期 | `time` | 时间选择 |
| 日期 | `datetime` | 日期时间 |
| 上传 | `image` | 图片上传 |
| 远程 | `remote-select` | 远程搜索 |
| 远程 | `table-select` | 表格选择 |
| 远程 | `cascader` | 级联选择 |
| 远程 | `address` | 地址选择 |
| 布局 | `group` | 分组布局 |
| 布局 | `object` | 对象嵌套 |
| 布局 | `bar-title` | 分组标题 |
| 展示 | `text-view` | 文本展示 |
| 展示 | `money-view` | 金额展示 |
| 展示 | `html` | HTML展示 |
| 展示 | `editor` | 富文本 |

## 高级配置

### 条件显示 (showRule)
```javascript
{
  key: "mode", title: "模式", type: "radio",
  data: [{ value: 1, label: "覆盖" }, { value: 2, label: "新增" }],
  showRule: "login_appid_type==1"  // 当 login_appid_type=1 时显示
}
```

### 条件禁用 (disabled)
```javascript
{
  key: "mode", title: "模式", type: "radio",
  disabled: "login_appid_type==0"  // 当 login_appid_type=0 时禁用
}
```

### 监听值变化 (watch)
```javascript
{
  key: "text", title: "文本", type: "text",
  watch: (res) => {
    console.log("值改变", res);
  }
}
```

## 表单方法

| 方法 | 说明 |
|------|------|
| `submitForm()` | 提交表单(自动验证) |
| `resetForm()` | 重置表单 |
| `clearValidate()` | 清除验证 |
| `validate()` | 表单验证 |
| `validateField(prop)` | 部分字段验证 |

```javascript
// 提交表单
that.$refs.form1.submitForm({
  data: { extra: "额外参数" },
  success: (data) => { console.log("成功", data); },
  fail: (data) => { console.log("失败", data); }
});
```

## 事件

| 事件 | 说明 | 回调参数 |
|------|------|----------|
| `success` | 提交成功 | { data, formType } |
| `fail` | 提交失败 | { data, formType } |
| `complete` | 提交结束 | { data, formType } |
| `cancel` | 点击取消 | - |

## 插槽使用

### 自定义字段渲染
```vue
<vk-data-form ref="form1" v-model="form1.data" :columns="form1.props.columns">
  <template v-slot:rate="{ form, keyName }">
    <el-rate v-model="form[keyName]"></el-rate>
  </template>
</vk-data-form>
```

### 自定义底部按钮
```vue
<vk-data-form ref="form1" v-model="form1.data" :columns="form1.props.columns">
  <template v-slot:footer="{ loading }">
    <el-button :loading="loading" type="primary" @click="customSubmit">自定义提交</el-button>
  </template>
</vk-data-form>
```

## HTTP 请求模式

```vue
<vk-data-form
  action="https://www.xxx.com/api/form"
  :is-request="true"
  :request-header="{ 'content-type': 'application/json' }"
  :columns="form1.props.columns"
></vk-data-form>
```

## 自定义 Function 请求

```javascript
form1: {
  props: {
    action: (obj = {}) => {
      let { data, success, fail, complete } = obj;
      vk.callFunction({
        url: "admin/xxx/sys/add",
        data: data,
        success: (res) => { if (typeof success === "function") success(res); },
        fail: (res) => { if (typeof fail === "function") fail(res); }
      });
    }
  }
}
```

## 弹窗表单独立组件

### 打开弹窗
```javascript
vk.pubfn.openForm('bindRole', { item: rowData }, this);
```

### 组件模板
```vue
<template>
  <vk-data-dialog v-model="value.show" :title="page.title" mode="form" @open="onOpen">
    <vk-data-form
      ref="form1"
      :form-type="value.mode"
      v-model="form1.data"
      :action="form1.props.action"
      :columns="form1.props.columns"
      @success="onFormSuccess"
    ></vk-data-form>
  </vk-data-dialog>
</template>
```

## 参考文档

- [基础用法与columns配置](references/basic_usage.md)
- [验证规则详解](references/validation.md)
- [表单方法与事件](references/methods_events.md)
- [插槽使用](references/slots.md)
- [HTTP与自定义请求](references/http_mode.md)
- [弹窗表单组件](references/dialog_form.md)
