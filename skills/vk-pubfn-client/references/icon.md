# 图标库扩展指南

## 目录

- [概述](#概述)
- [扩展自定义图标库](#扩展自定义图标库)
- [使用 admin 端图标库](#使用-admin-端图标库)
- [使用示例](#使用示例)
- [最佳实践](#最佳实践)

## 概述

vk-unicloud 框架支持扩展自定义图标库,也可以使用 admin 端的内置图标库。

## 扩展自定义图标库

### 下载安装图标

#### 1. 生成图标库 CSS 文件

从 [https://www.iconfont.cn](https://www.iconfont.cn/) 网站上生成图标库 CSS 文件。

**注意命名格式**:

```
FontClass前缀: vk-xxx-icon-
Font Family: vk-xxx-icon
```

你只改动 `xxx`,如:

```
FontClass前缀: vk-aaa-icon-
Font Family: vk-aaa-icon
```

#### 2. 下载至本地

下载文件并解压。

#### 3. 复制 CSS 文件

将 `iconfont.css` 文件复制到项目根目录的 `static` 目录,并将 `iconfont.css` 改名为 `vk-custom-icon.css`。

目录结构:
```
static/
└── vk-custom-icon.css
```

#### 4. 在 App.vue 中引入图标

```vue
<style lang="scss">
@import "@/static/vk-custom-icon.css";
</style>
```

### 使用自定义图标

#### 基本用法

假设你的某个图标是 `vk-custom-icon-update`,则 `vk-custom-icon-update` 就是图标的 `name`,也是图标的值。

```vue
<template>
  <view>
    <!-- 显示图标 -->
    <text class="vk-custom-icon vk-custom-icon-update" style="font-size: 20px; color: #000000;"></text>
  </view>
</template>
```

#### 使用 vk-uview-ui 组件库

如果你使用了 `vk-uview-ui` 组件库,则可以这样显示图标:

```vue
<template>
  <view>
    <u-icon name="vk-custom-icon-update" size="20px" color="#000000"></u-icon>
  </view>
</template>
```

## 使用 admin 端图标库

admin 端的图标库有 2 个:
1. Element 内置的图标库
2. vk 内置的图标库

### Element 内置的图标库

#### 安装教程

在项目根目录的 `static` 目录新建文件 `el-icon.css`,文件内容如下:

```css
@font-face {
  font-family: element-icons;
  src: url('data:application/font-woff;base64,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') format('woff2');
}

.vk-icon {
  font-family: "vk-icon" !important;
  font-size: 16px;
  font-style: normal;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

.vk-icon-douyin1:before {
  content: "\e605";
}

.vk-icon-weixin:before {
  content: "\e601";
}

.vk-icon-zhifubaozhifu:before {
  content: "\e67f";
}

/* ... 更多图标 ... */
```

并在 `App.vue` 文件内添加代码:

```vue
<style lang="scss">
@import "./static/el-icon.css";
</style>
```

### vk 内置的图标库

vk 内置图标库的使用方式与 Element 图标库相同,只需将 CSS 文件复制到 `static` 目录并引入即可。

详见: [admin端扩展图标教程](https://vkdoc.fsq.pub/admin/components2/1%E3%80%81vk-data-icon.html#%E5%A6%82%E4%BD%95%E6%89%A9%E5%B1%95%E5%9B%BE%E6%A0%87%E5%BA%93)

## 使用示例

### 基本用法

```vue
<template>
  <view>
    <!-- 使用 text 标签 -->
    <text class="vk-icon vk-icon-file" style="font-size: 20px; color: #000000;"></text>
    
    <!-- 使用 u-icon 组件 -->
    <u-icon name="vk-icon-file" size="20px" color="#000000"></u-icon>
  </view>
</template>
```

### 自定义图标

```vue
<template>
  <view>
    <!-- 使用自定义图标 -->
    <text class="vk-custom-icon vk-custom-icon-update" style="font-size: 20px; color: #000000;"></text>
    
    <!-- 使用 u-icon 组件 -->
    <u-icon name="vk-custom-icon-update" size="20px" color="#000000"></u-icon>
  </view>
</template>
```

### 动态图标

```vue
<template>
  <view>
    <!-- 动态切换图标 -->
    <text :class="['vk-icon', iconName]" style="font-size: 20px;"></text>
  </view>
</template>

<script>
export default {
  data() {
    return {
      iconName: "vk-icon-file"
    };
  },
  methods: {
    toggleIcon() {
      this.iconName = "vk-icon-folder";
    }
  }
}
</script>
```

## 最佳实践

### 1. 图标命名规范

```css
/* 好的命名: 清晰、有前缀 */
.vk-custom-icon-update:before { content: "\e001"; }
.vk-custom-icon-delete:before { content: "\e002"; }

/* 避免: 过于简短或无前缀 */
.icon-update:before { content: "\e001"; }
.update:before { content: "\e001"; }
```

### 2. 图标大小控制

```vue
<template>
  <view>
    <!-- 使用 style 控制大小 -->
    <text class="vk-icon vk-icon-file" style="font-size: 16px;"></text>
    <text class="vk-icon vk-icon-file" style="font-size: 20px;"></text>
    <text class="vk-icon vk-icon-file" style="font-size: 24px;"></text>
    
    <!-- 使用 u-icon 组件 -->
    <u-icon name="vk-icon-file" size="16px"></u-icon>
    <u-icon name="vk-icon-file" size="20px"></u-icon>
    <u-icon name="vk-icon-file" size="24px"></u-icon>
  </view>
</template>
```

### 3. 图标颜色控制

```vue
<template>
  <view>
    <!-- 使用 style 控制颜色 -->
    <text class="vk-icon vk-icon-file" style="color: #ff0000;"></text>
    <text class="vk-icon vk-icon-file" style="color: #00ff00;"></text>
    <text class="vk-icon vk-icon-file" style="color: #0000ff;"></text>
    
    <!-- 使用 u-icon 组件 -->
    <u-icon name="vk-icon-file" color="#ff0000"></u-icon>
    <u-icon name="vk-icon-file" color="#00ff00"></u-icon>
    <u-icon name="vk-icon-file" color="#0000ff"></u-icon>
  </view>
</template>
```

### 4. 图标点击事件

```vue
<template>
  <view>
    <!-- text 标签点击 -->
    <text class="vk-icon vk-icon-file" @click="handleClick"></text>
    
    <!-- u-icon 组件点击 -->
    <u-icon name="vk-icon-file" @click="handleClick"></u-icon>
  </view>
</template>

<script>
export default {
  methods: {
    handleClick() {
      console.log("图标被点击");
    }
  }
}
</script>
```

### 5. 图标加载优化

```css
/* 使用 font-display 优化字体加载 */
@font-face {
  font-family: "vk-icon";
  src: url('...');
  font-display: swap; /* 或 fallback */
}
```

## 常见问题

### Q: 图标不显示怎么办?

**A**: 检查以下几点:
1. CSS 文件是否正确引入
2. 图标类名是否正确
3. 字体文件路径是否正确
4. 是否有样式冲突

### Q: 如何添加更多图标?

**A**:
1. 在 iconfont.cn 项目中添加新图标
2. 重新下载 CSS 文件
3. 替换项目中的 CSS 文件

### Q: 图标在不同平台显示不一致?

**A**: 不同平台对字体渲染可能有差异,建议:
1. 使用 u-icon 组件统一显示
2. 测试不同平台的显示效果
3. 调整字体大小和颜色

### Q: 如何使用 SVG 图标?

**A**: vk-unicloud 框架主要支持字体图标,如需使用 SVG 图标:
1. 将 SVG 文件转换为字体图标
2. 或直接使用 image 标签显示 SVG

### Q: 图标文件太大怎么办?

**A**:
1. 只选择需要的图标,不要全部下载
2. 使用字体压缩工具压缩字体文件
3. 考虑使用 SVG 图标替代
