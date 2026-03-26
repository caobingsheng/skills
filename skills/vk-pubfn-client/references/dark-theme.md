# 深色模式适配

## 目录

- [概述](#概述)
- [为什么要适配深色模式](#为什么要适配深色模式)
- [适配方案](#适配方案)
- [实现步骤](#实现步骤)
- [最佳实践](#最佳实践)

## 概述

本文将介绍 uni-app 如何适配深色模式,文章内容通俗易懂,非常适合新手小白上手,从此再也不用担心如何适配深色模式了。

## 为什么要适配深色模式

1. **部分应用商店上架强制要求**,如鸿蒙
2. **提升用户体验**
3. **符合现代应用设计趋势**

[点击查看详细介绍](https://ask.dcloud.net.cn/article/42222)

## 适配方案

### 方案概述

uni-app 提供了完整的深色模式支持,主要包括:

1. **系统级深色模式检测**
2. **主题切换功能**
3. **样式适配**

### 核心概念

- **系统深色模式**: 操作系统提供的深色模式设置
- **应用主题**: 应用内部的主题设置(可独立于系统)
- **样式适配**: 根据主题切换不同的样式

## 实现步骤

### 1. 检测系统深色模式

使用 `uni.getSystemInfoSync()` 获取系统主题设置:

```javascript
// 获取系统信息
let systemInfo = uni.getSystemInfoSync();

// 检测是否为深色模式
let isDark = systemInfo.theme === 'dark';

console.log('当前主题:', systemInfo.theme); // light 或 dark
console.log('是否深色模式:', isDark);
```

### 2. 监听主题变化

使用 `uni.onThemeChange()` 监听系统主题变化:

```javascript
// 监听主题变化
uni.onThemeChange((res) => {
  console.log('主题变化:', res.theme);
  
  // res.theme: 'light' 或 'dark'
  if (res.theme === 'dark') {
    // 切换到深色主题
    that.switchTheme('dark');
  } else {
    // 切换到浅色主题
    that.switchTheme('light');
  }
});
```

### 3. 定义主题样式

在 SCSS 中定义主题变量:

```scss
// 定义主题变量
$theme-light: (
  bg-color: #ffffff,
  text-color: #333333,
  border-color: #e0e0e0,
  primary-color: #007aff
);

$theme-dark: (
  bg-color: #1a1a1a,
  text-color: #ffffff,
  border-color: #333333,
  primary-color: #0a84ff
);

// 混入函数
@mixin theme-style($theme) {
  background-color: map-get($theme, bg-color);
  color: map-get($theme, text-color);
  border-color: map-get($theme, border-color);
}
```

### 4. 应用主题样式

根据当前主题应用不同的样式:

```vue
<template>
  <view :class="['container', themeClass]">
    <text class="title">标题</text>
    <text class="content">内容</text>
  </view>
</template>

<script>
export default {
  data() {
    return {
      theme: 'light'
    };
  },
  computed: {
    themeClass() {
      return `theme-${this.theme}`;
    }
  },
  onLoad() {
    // 检测系统主题
    let systemInfo = uni.getSystemInfoSync();
    this.theme = systemInfo.theme === 'dark' ? 'dark' : 'light';
    
    // 监听主题变化
    uni.onThemeChange((res) => {
      this.theme = res.theme === 'dark' ? 'dark' : 'light';
    });
  }
}
</script>

<style lang="scss" scoped>
.container {
  padding: 20px;
  
  &.theme-light {
    background-color: #ffffff;
    color: #333333;
  }
  
  &.theme-dark {
    background-color: #1a1a1a;
    color: #ffffff;
  }
}

.title {
  font-size: 18px;
  font-weight: bold;
}

.content {
  font-size: 14px;
  margin-top: 10px;
}
</style>
```

### 5. 使用 CSS 变量

使用 CSS 变量实现主题切换:

```vue
<template>
  <view class="container" :style="containerStyle">
    <text class="title">标题</text>
    <text class="content">内容</text>
  </view>
</template>

<script>
export default {
  data() {
    return {
      theme: 'light'
    };
  },
  computed: {
    containerStyle() {
      return {
        '--bg-color': this.theme === 'dark' ? '#1a1a1a' : '#ffffff',
        '--text-color': this.theme === 'dark' ? '#ffffff' : '#333333',
        '--border-color': this.theme === 'dark' ? '#333333' : '#e0e0e0'
      };
    }
  },
  onLoad() {
    let systemInfo = uni.getSystemInfoSync();
    this.theme = systemInfo.theme === 'dark' ? 'dark' : 'light';
    
    uni.onThemeChange((res) => {
      this.theme = res.theme === 'dark' ? 'dark' : 'light';
    });
  }
}
</script>

<style lang="scss" scoped>
.container {
  background-color: var(--bg-color);
  color: var(--text-color);
  border: 1px solid var(--border-color);
  padding: 20px;
}

.title {
  font-size: 18px;
  font-weight: bold;
}

.content {
  font-size: 14px;
  margin-top: 10px;
}
</style>
```

### 6. 使用 Vuex 管理主题

将主题状态存储在 Vuex 中:

```javascript
// store/modules/$app.js
let lifeData = uni.getStorageSync('lifeData') || {};
let $app = lifeData.$app || {};

export default {
  namespaced: true,
  state: {
    theme: $app.theme || 'light' // 'light' 或 'dark'
  }
}
```

在组件中使用:

```vue
<template>
  <view :class="['container', `theme-${theme}`]">
    <text class="title">标题</text>
  </view>
</template>

<script>
let vk = uni.vk;

export default {
  computed: {
    theme() {
      return vk.getVuex('$app.theme');
    }
  },
  onLoad() {
    // 初始化主题
    this.initTheme();
    
    // 监听系统主题变化
    uni.onThemeChange((res) => {
      vk.setVuex('$app.theme', res.theme === 'dark' ? 'dark' : 'light');
    });
  },
  methods: {
    initTheme() {
      let systemInfo = uni.getSystemInfoSync();
      let theme = systemInfo.theme === 'dark' ? 'dark' : 'light';
      
      // 如果用户没有手动设置过主题,则跟随系统
      if (!vk.getVuex('$app.userTheme')) {
        vk.setVuex('$app.theme', theme);
      }
    },
    
    // 手动切换主题
    toggleTheme() {
      let newTheme = this.theme === 'light' ? 'dark' : 'light';
      vk.setVuex('$app.theme', newTheme);
      vk.setVuex('$app.userTheme', newTheme); // 记录用户手动设置
    }
  }
}
</script>
```

## 最佳实践

### 1. 主题切换动画

添加平滑的主题切换动画:

```scss
.container {
  transition: background-color 0.3s ease, color 0.3s ease;
  
  &.theme-light {
    background-color: #ffffff;
    color: #333333;
  }
  
  &.theme-dark {
    background-color: #1a1a1a;
    color: #ffffff;
  }
}
```

### 2. 图片适配

为不同主题准备不同的图片:

```vue
<template>
  <view>
    <!-- 根据主题显示不同图片 -->
    <image :src="theme === 'dark' ? darkImage : lightImage"></image>
  </view>
</template>

<script>
export default {
  data() {
    return {
      theme: 'light',
      lightImage: '/static/logo-light.png',
      darkImage: '/static/logo-dark.png'
    };
  }
}
</script>
```

### 3. 组件库适配

如果使用了 Element UI 或其他组件库,需要适配其深色模式:

```scss
// 深色模式下的 Element UI 样式
.theme-dark {
  ::v-deep .el-button {
    background-color: #333;
    border-color: #444;
    color: #fff;
  }
  
  ::v-deep .el-input__inner {
    background-color: #333;
    border-color: #444;
    color: #fff;
  }
}
```

### 4. 第三方库适配

对于第三方库,可能需要额外的样式适配:

```scss
// 适配第三方库
.theme-dark {
  ::v-deep .third-party-component {
    background-color: #1a1a1a;
    color: #ffffff;
  }
}
```

### 5. 主题持久化

将用户选择的主题保存到本地:

```javascript
// 保存主题
function saveTheme(theme) {
  vk.setStorageSync('userTheme', theme);
  vk.setVuex('$app.theme', theme);
}

// 读取主题
function loadTheme() {
  let userTheme = vk.getStorageSync('userTheme');
  if (userTheme) {
    return userTheme;
  }
  
  // 如果没有用户设置,则跟随系统
  let systemInfo = uni.getSystemInfoSync();
  return systemInfo.theme === 'dark' ? 'dark' : 'light';
}
```

### 6. 主题切换按钮

提供主题切换按钮:

```vue
<template>
  <view class="theme-toggle" @click="toggleTheme">
    <text class="icon">{{ themeIcon }}</text>
  </view>
</template>

<script>
let vk = uni.vk;

export default {
  computed: {
    theme() {
      return vk.getVuex('$app.theme');
    },
    themeIcon() {
      return this.theme === 'light' ? '🌙' : '☀️';
    }
  },
  methods: {
    toggleTheme() {
      let newTheme = this.theme === 'light' ? 'dark' : 'light';
      vk.setVuex('$app.theme', newTheme);
      vk.setStorageSync('userTheme', newTheme);
    }
  }
}
</script>

<style lang="scss" scoped>
.theme-toggle {
  padding: 10px;
  cursor: pointer;
  
  .icon {
    font-size: 20px;
  }
}
</style>
```

## 常见问题

### Q: 如何在 H5 端适配深色模式?

**A**: H5 端同样支持深色模式,使用 `uni.getSystemInfoSync()` 和 `uni.onThemeChange()` 即可。

### Q: 如何在小程序端适配深色模式?

**A**: 小程序端也支持深色模式,但需要注意:
1. 微信小程序: 支持 `uni.getSystemInfoSync()` 和 `uni.onThemeChange()`
2. 其他小程序: 请查看对应平台的文档

### Q: 如何在 App 端适配深色模式?

**A**: App 端同样支持深色模式,使用方式与其他平台一致。

### Q: 如何处理不支持深色模式的旧版本?

**A**: 检测 API 是否可用:

```javascript
if (uni.onThemeChange) {
  // 支持深色模式
  uni.onThemeChange((res) => {
    console.log('主题变化:', res.theme);
  });
} else {
  // 不支持深色模式
  console.log('当前平台不支持深色模式');
}
```

### Q: 如何适配第三方组件库?

**A**: 使用深度选择器覆盖第三方组件的样式:

```scss
.theme-dark {
  ::v-deep .third-party-component {
    background-color: #1a1a1a;
    color: #ffffff;
  }
}
```

### Q: 如何优化深色模式的性能?

**A**:
1. 使用 CSS 变量而不是动态 class
2. 避免频繁切换主题
3. 使用 transition 添加平滑动画
4. 减少不必要的样式计算

### Q: 如何在开发时测试深色模式?

**A**:
1. 在系统设置中切换深色模式
2. 使用主题切换按钮手动切换
3. 在开发者工具中模拟不同主题
