# 完整示例

本文档提供 vk-unicloud-admin 自定义组件的完整示例代码。

## 目录

- [示例1：简单文本输入组件](#示例1简单文本输入组件)
- [示例2：复杂选择器组件](#示例2复杂选择器组件)
- [示例3：文件上传组件](#示例3文件上传组件)
- [示例4：富文本编辑器组件](#示例4富文本编辑器组件)
- [示例5：日期时间选择组件](#示例5日期时间选择组件)

## 示例1：简单文本输入组件

**组件名称**：`custom-simple-input`

**功能**：一个简单的文本输入组件，支持前缀和后缀显示。

**文件路径**：`components/custom-simple-input/custom-simple-input.vue`

```vue
<template>
  <!-- 万能表单 -->
  <view v-if="scene === 'form'">
    <el-input
      :value="value"
      :disabled="column.disabled"
      :readonly="column.readonly"
      :placeholder="column.placeholder || '请输入'"
      @input="_input"
    >
      <template v-if="column.prefix" slot="prepend">{{ column.prefix }}</template>
      <template v-if="column.suffix" slot="append">{{ column.suffix }}</template>
    </el-input>
  </view>
  <!-- 万能表格 -->
  <view v-else-if="scene === 'table'">
    <text>{{ formatValue(value) }}</text>
  </view>
  <!-- 万能表格详情 -->
  <view v-else-if="scene === 'detail'">
    <text>{{ formatValue(value) }}</text>
  </view>
</template>

<script>
export default {
  props: {
    value: {
      type: String,
      default: ""
    },
    column: {
      type: Object,
      default: function() {
        return {};
      }
    },
    scene: {
      type: String,
      default: "form"
    }
  },
  data() {
    return {};
  },
  methods: {
    _input(value) {
      this.$emit("input", value);
      this.$emit("change", value);
    },
    formatValue(value) {
      const prefix = this.column.prefix || "";
      const suffix = this.column.suffix || "";
      return prefix + value + suffix;
    }
  }
};
</script>

<style lang="scss" scoped>
</style>
```

**使用方式**：
```javascript
// 在表单配置中
{
  key: "username",
  title: "用户名",
  type: "custom",
  component: "custom-simple-input",
  placeholder: "请输入用户名",
  prefix: "@",
  suffix: "@example.com"
}
```

## 示例2：复杂选择器组件

**组件名称**：`custom-advanced-select`

**功能**：一个支持搜索、远程数据加载的选择器组件。

**文件路径**：`components/custom-advanced-select/custom-advanced-select.vue`

```vue
<template>
  <!-- 万能表单 -->
  <view v-if="scene === 'form'">
    <el-select
      :value="value"
      :disabled="column.disabled"
      :remote-method="remoteMethod"
      :loading="loading"
      :multiple="column.multiple"
      :placeholder="column.placeholder || '请选择'"
      filterable
      remote
      reserve-keyword
      @change="_change"
    >
      <el-option
        v-for="item in options"
        :key="item.value"
        :label="item.label"
        :value="item.value"
      ></el-option>
    </el-select>
  </view>
  <!-- 万能表格 -->
  <view v-else-if="scene === 'table'">
    <text>{{ getLabel(value) }}</text>
  </view>
  <!-- 万能表格详情 -->
  <view v-else-if="scene === 'detail'">
    <text>{{ getLabel(value) }}</text>
  </view>
</template>

<script>
export default {
  props: {
    value: {
      type: [String, Number, Array],
      default: ""
    },
    column: {
      type: Object,
      default: function() {
        return {};
      }
    },
    scene: {
      type: String,
      default: "form"
    }
  },
  data() {
    return {
      loading: false,
      options: []
    };
  },
  mounted() {
    // 如果有静态数据源，直接加载
    if (this.column.data) {
      this.options = this.column.data;
    }
    // 如果有远程数据源，加载数据
    if (this.column.action) {
      this.loadRemoteData();
    }
  },
  methods: {
    _change(value) {
      this.$emit("input", value);
      this.$emit("change", value);
    },
    async loadRemoteData(query = "") {
      if (!this.column.action) return;

      this.loading = true;
      try {
        const res = await vk.callFunction({
          url: this.column.action,
          data: {
            query: query,
            ...this.column.params
          }
        });
        this.options = res.list || [];
      } catch (error) {
        console.error("加载数据失败：", error);
      } finally {
        this.loading = false;
      }
    },
    remoteMethod(query) {
      if (query !== "") {
        this.loadRemoteData(query);
      } else {
        this.options = [];
      }
    },
    getLabel(value) {
      if (!value && value !== 0) return "";
      if (this.column.multiple && Array.isArray(value)) {
        return value.map(v => this.findLabel(v)).join(", ");
      }
      return this.findLabel(value);
    },
    findLabel(value) {
      const option = this.options.find(item => item.value === value);
      return option ? option.label : value;
    }
  }
};
</script>

<style lang="scss" scoped>
</style>
```

**使用方式**：
```javascript
// 静态数据
{
  key: "status",
  title: "状态",
  type: "custom",
  component: "custom-advanced-select",
  data: [
    { value: 1, label: "启用" },
    { value: 0, label: "禁用" }
  ]
}

// 远程数据
{
  key: "user_id",
  title: "用户",
  type: "custom",
  component: "custom-advanced-select",
  action: "admin/user/sys/getList",
  params: {
    pageSize: 100
  }
}
```

## 示例3：文件上传组件

**组件名称**：`custom-file-upload`

**功能**：支持图片预览、文件大小限制的文件上传组件。

**文件路径**：`components/custom-file-upload/custom-file-upload.vue`

```vue
<template>
  <!-- 万能表单 -->
  <view v-if="scene === 'form'">
    <el-upload
      :action="uploadUrl"
      :headers="uploadHeaders"
      :file-list="fileList"
      :disabled="column.disabled"
      :limit="column.limit || 1"
      :accept="column.accept"
      :before-upload="beforeUpload"
      :on-success="onSuccess"
      :on-remove="onRemove"
      list-type="picture-card"
    >
      <i class="el-icon-plus"></i>
    </el-upload>
  </view>
  <!-- 万能表格 -->
  <view v-else-if="scene === 'table'">
    <el-image
      v-if="isImage(value)"
      :src="value"
      :preview-src-list="[value]"
      style="width: 50px; height: 50px"
      fit="cover"
    ></el-image>
    <el-link v-else :href="value" target="_blank" type="primary">查看文件</el-link>
  </view>
  <!-- 万能表格详情 -->
  <view v-else-if="scene === 'detail'">
    <el-image
      v-if="isImage(value)"
      :src="value"
      :preview-src-list="[value]"
      style="width: 200px; height: 200px"
      fit="cover"
    ></el-image>
    <el-link v-else :href="value" target="_blank" type="primary">查看文件</el-link>
  </view>
</template>

<script>
export default {
  props: {
    value: {
      type: [String, Array],
      default: ""
    },
    column: {
      type: Object,
      default: function() {
        return {};
      }
    },
    scene: {
      type: String,
      default: "form"
    }
  },
  data() {
    return {
      uploadUrl: "",
      uploadHeaders: {},
      fileList: []
    };
  },
  mounted() {
    // 初始化上传配置
    this.uploadUrl = vk.getVuex("$app.config.cloudPath") || "";
    this.uploadHeaders = {
      "uni-id-token": vk.getVuex("$user.token")
    };
    // 初始化文件列表
    this.initFileList();
  },
  watch: {
    value: {
      handler() {
        this.initFileList();
      },
      immediate: true
    }
  },
  methods: {
    initFileList() {
      if (!this.value) {
        this.fileList = [];
        return;
      }
      if (Array.isArray(this.value)) {
        this.fileList = this.value.map(url => ({ name: this.getFileName(url), url }));
      } else {
        this.fileList = [{ name: this.getFileName(this.value), url: this.value }];
      }
    },
    getFileName(url) {
      const parts = url.split("/");
      return parts[parts.length - 1];
    },
    isImage(url) {
      if (!url) return false;
      const imageExts = [".jpg", ".jpeg", ".png", ".gif", ".bmp", ".webp"];
      const ext = url.substring(url.lastIndexOf(".")).toLowerCase();
      return imageExts.includes(ext);
    },
    beforeUpload(file) {
      // 文件大小限制
      const maxSize = this.column.maxSize || 10 * 1024 * 1024; // 默认10MB
      if (file.size > maxSize) {
        vk.toast(`文件大小不能超过 ${maxSize / 1024 / 1024} MB`);
        return false;
      }
      return true;
    },
    onSuccess(response, file, fileList) {
      if (response.code === 0) {
        const url = response.data.url;
        if (this.column.limit === 1) {
          this.$emit("input", url);
          this.$emit("change", url);
        } else {
          const urls = fileList.map(f => f.response?.data?.url || f.url).filter(Boolean);
          this.$emit("input", urls);
          this.$emit("change", urls);
        }
        vk.toast("上传成功");
      } else {
        vk.toast(response.msg || "上传失败");
      }
    },
    onRemove(file, fileList) {
      if (this.column.limit === 1) {
        this.$emit("input", "");
        this.$emit("change", "");
      } else {
        const urls = fileList.map(f => f.response?.data?.url || f.url).filter(Boolean);
        this.$emit("input", urls);
        this.$emit("change", urls);
      }
    }
  }
};
</script>

<style lang="scss" scoped>
</style>
```

**使用方式**：
```javascript
// 单文件上传
{
  key: "avatar",
  title: "头像",
  type: "custom",
  component: "custom-file-upload",
  accept: "image/*",
  maxSize: 2 * 1024 * 1024, // 2MB
  limit: 1
}

// 多文件上传
{
  key: "images",
  title: "图片集",
  type: "custom",
  component: "custom-file-upload",
  accept: "image/*",
  maxSize: 5 * 1024 * 1024, // 5MB
  limit: 9
}
```

## 示例4：富文本编辑器组件

**组件名称**：`custom-rich-editor`

**功能**：基于 TinyMCE 的富文本编辑器组件。

**文件路径**：`components/custom-rich-editor/custom-rich-editor.vue`

```vue
<template>
  <!-- 万能表单 -->
  <view v-if="scene === 'form'">
    <custom-editor-tinymce
      :value="value"
      :disabled="column.disabled"
      :height="column.height || 400"
      @input="_input"
    ></custom-editor-tinymce>
  </view>
  <!-- 万能表格 -->
  <view v-else-if="scene === 'table'">
    <text>{{ getPlainText(value) }}</text>
  </view>
  <!-- 万能表格详情 -->
  <view v-else-if="scene === 'detail'">
    <view v-html="value" class="rich-content"></view>
  </view>
</template>

<script>
export default {
  props: {
    value: {
      type: String,
      default: ""
    },
    column: {
      type: Object,
      default: function() {
        return {};
      }
    },
    scene: {
      type: String,
      default: "form"
    }
  },
  methods: {
    _input(value) {
      this.$emit("input", value);
      this.$emit("change", value);
    },
    getPlainText(html) {
      if (!html) return "";
      // 移除 HTML 标签，返回纯文本
      return html.replace(/<[^>]+>/g, "").substring(0, 100);
    }
  }
};
</script>

<style lang="scss" scoped>
.rich-content {
  // 富文本内容样式
  ::v-deep img {
    max-width: 100%;
  }
  ::v-deep p {
    margin: 8px 0;
  }
}
</style>
```

**使用方式**：
```javascript
{
  key: "content",
  title: "内容",
  type: "custom",
  component: "custom-rich-editor",
  height: 500
}
```

## 示例5：日期时间选择组件

**组件名称**：`custom-datetime-picker`

**功能**：支持日期时间选择的组件。

**文件路径**：`components/custom-datetime-picker/custom-datetime-picker.vue`

```vue
<template>
  <!-- 万能表单 -->
  <view v-if="scene === 'form'">
    <el-date-picker
      :value="value"
      :type="column.dateType || 'datetime'"
      :disabled="column.disabled"
      :placeholder="column.placeholder || '请选择'"
      :format="column.format || 'yyyy-MM-dd HH:mm:ss'"
      :value-format="column.valueFormat || 'yyyy-MM-dd HH:mm:ss'"
      @change="_change"
    ></el-date-picker>
  </view>
  <!-- 万能表格 -->
  <view v-else-if="scene === 'table'">
    <text>{{ formatValue(value) }}</text>
  </view>
  <!-- 万能表格详情 -->
  <view v-else-if="scene === 'detail'">
    <text>{{ formatValue(value) }}</text>
  </view>
</template>

<script>
export default {
  props: {
    value: {
      type: [String, Date],
      default: ""
    },
    column: {
      type: Object,
      default: function() {
        return {};
      }
    },
    scene: {
      type: String,
      default: "form"
    }
  },
  methods: {
    _change(value) {
      this.$emit("input", value);
      this.$emit("change", value);
    },
    formatValue(value) {
      if (!value) return "";
      // 如果是日期对象，格式化为字符串
      if (value instanceof Date) {
        const year = value.getFullYear();
        const month = String(value.getMonth() + 1).padStart(2, "0");
        const day = String(value.getDate()).padStart(2, "0");
        const hours = String(value.getHours()).padStart(2, "0");
        const minutes = String(value.getMinutes()).padStart(2, "0");
        const seconds = String(value.getSeconds()).padStart(2, "0");
        return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
      }
      return value;
    }
  }
};
</script>

<style lang="scss" scoped>
</style>
```

**使用方式**：
```javascript
// 日期时间选择
{
  key: "create_time",
  title: "创建时间",
  type: "custom",
  component: "custom-datetime-picker",
  dateType: "datetime",
  format: "yyyy-MM-dd HH:mm:ss",
  valueFormat: "yyyy-MM-dd HH:mm:ss"
}

// 日期选择
{
  key: "birthday",
  title: "生日",
  type: "custom",
  component: "custom-datetime-picker",
  dateType: "date",
  format: "yyyy-MM-dd",
  valueFormat: "yyyy-MM-dd"
}

// 时间选择
{
  key: "work_time",
  title: "工作时间",
  type: "custom",
  component: "custom-datetime-picker",
  dateType: "time",
  format: "HH:mm:ss",
  valueFormat: "HH:mm:ss"
}
```

## 组件测试建议

在创建自定义组件后，建议进行以下测试：

1. **表单场景测试**：
   - 输入值是否正确绑定
   - input 和 change 事件是否按顺序触发
   - disabled、readonly 状态是否生效
   - 验证规则是否生效

2. **表格场景测试**：
   - 值是否正确显示
   - 样式是否正常
   - 是否影响表格布局

3. **详情场景测试**：
   - 值是否正确显示
   - 样式是否正常
   - 交互功能是否正常

4. **边界情况测试**：
   - 空值处理
   - undefined、null 处理
   - 异常值处理
