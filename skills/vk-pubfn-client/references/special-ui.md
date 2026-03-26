# 特殊UI效果

## 目录

- [概述](#概述)
- [清明灰页效果](#清明灰页效果)
- [其他特殊效果](#其他特殊效果)
- [最佳实践](#最佳实践)

## 概述

本文将介绍一些特殊的 UI 效果实现,如清明节的灰色页面效果等。页面灰色有多种实现方案,这里只讲一种比较简单的方案。

## 清明灰页效果

### 方案概述

清明节期间,很多网站会将页面变为灰色以示哀悼。实现页面灰色有多种方案,这里介绍一种简单有效的方案:使用 CSS 的 `filter` 属性。

### 实现步骤

#### 1. 全局样式方案

在全局样式中添加灰色滤镜:

```scss
// 在 common/css/app.scss 中添加
.gray-page {
  filter: grayscale(100%);
  -webkit-filter: grayscale(100%);
  -moz-filter: grayscale(100%);
  -ms-filter: grayscale(100%);
  -o-filter: grayscale(100%);
}
```

#### 2. 动态切换方案

通过动态添加/移除 class 来控制页面灰色:

```vue
<template>
  <view :class="{ 'gray-page': isGray }">
    <!-- 页面内容 -->
  </view>
</template>

<script>
export default {
  data() {
    return {
      isGray: false
    };
  },
  onLoad() {
    // 检查是否需要显示灰色页面
    this.checkGrayPage();
  },
  methods: {
    checkGrayPage() {
      // 检查当前日期是否为清明节
      let today = new Date();
      let month = today.getMonth() + 1;
      let day = today.getDate();
      
      // 清明节通常在 4 月 4 日或 5 日
      if (month === 4 && (day === 4 || day === 5)) {
        this.isGray = true;
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.gray-page {
  filter: grayscale(100%);
  -webkit-filter: grayscale(100%);
  -moz-filter: grayscale(100%);
  -ms-filter: grayscale(100%);
  -o-filter: grayscale(100%);
}
</style>
```

#### 3. 使用 Vuex 控制全局灰色

将灰色状态存储在 Vuex 中:

```javascript
// store/modules/$app.js
let lifeData = uni.getStorageSync('lifeData') || {};
let $app = lifeData.$app || {};

export default {
  namespaced: true,
  state: {
    isGrayPage: $app.isGrayPage || false
  }
}
```

在 App.vue 中应用:

```vue
<template>
  <view :class="{ 'gray-page': isGrayPage }">
    <!-- 应用内容 -->
  </view>
</template>

<script>
let vk = uni.vk;

export default {
  computed: {
    isGrayPage() {
      return vk.getVuex('$app.isGrayPage');
    }
  },
  onLaunch() {
    // 检查是否需要显示灰色页面
    this.checkGrayPage();
  },
  methods: {
    checkGrayPage() {
      let today = new Date();
      let month = today.getMonth() + 1;
      let day = today.getDate();
      
      // 清明节通常在 4 月 4 日或 5 日
      if (month === 4 && (day === 4 || day === 5)) {
        vk.setVuex('$app.isGrayPage', true);
      } else {
        vk.setVuex('$app.isGrayPage', false);
      }
    }
  }
}
</script>

<style lang="scss">
.gray-page {
  filter: grayscale(100%);
  -webkit-filter: grayscale(100%);
  -moz-filter: grayscale(100%);
  -ms-filter: grayscale(100%);
  -o-filter: grayscale(100%);
}
</style>
```

#### 4. 服务器控制方案

通过服务器返回配置来控制是否显示灰色页面:

```javascript
// 在应用启动时获取配置
export default {
  onLaunch() {
    this.getAppConfig();
  },
  methods: {
    getAppConfig() {
      vk.callFunction({
        url: 'client/config/sys/get',
        data: {},
        success: (data) => {
          if (data.isGrayPage) {
            vk.setVuex('$app.isGrayPage', true);
          }
        }
      });
    }
  }
}
```

### 高级用法

#### 1. 部分灰色

只对部分内容应用灰色效果:

```vue
<template>
  <view>
    <view class="normal-content">
      <!-- 正常内容 -->
    </view>
    
    <view class="gray-content">
      <!-- 灰色内容 -->
    </view>
  </view>
</template>

<style lang="scss" scoped>
.gray-content {
  filter: grayscale(100%);
  -webkit-filter: grayscale(100%);
}
</style>
```

#### 2. 渐变灰色

使用渐变效果实现更柔和的灰色:

```scss
.gray-page {
  filter: grayscale(80%);
  -webkit-filter: grayscale(80%);
  transition: filter 0.5s ease;
}
```

#### 3. 淡入淡出效果

添加淡入淡出动画:

```vue
<template>
  <view :class="{ 'gray-page': isGray, 'gray-transition': true }">
    <!-- 页面内容 -->
  </view>
</template>

<style lang="scss" scoped>
.gray-transition {
  transition: filter 0.5s ease;
}

.gray-page {
  filter: grayscale(100%);
  -webkit-filter: grayscale(100%);
}
</style>
```

## 其他特殊效果

### 1. 悼念模式

除了灰色页面,还可以实现其他悼念效果:

```scss
// 降低亮度
.mourning-mode {
  filter: brightness(0.7) grayscale(100%);
  -webkit-filter: brightness(0.7) grayscale(100%);
}

// 降低饱和度
.mourning-mode-2 {
  filter: saturate(0.3);
  -webkit-filter: saturate(0.3);
}

// 棕褐色调
.sepia-mode {
  filter: sepia(100%);
  -webkit-filter: sepia(100%);
}
```

### 2. 节日特效

根据不同节日应用不同效果:

```javascript
// 节日特效配置
const festivalEffects = {
  qingming: {
    name: '清明节',
    effect: 'grayscale(100%)',
    date: [4, 4] // 4月4日
  },
  national: {
    name: '国庆节',
    effect: 'brightness(1.1) saturate(1.2)',
    date: [10, 1] // 10月1日
  },
  spring: {
    name: '春节',
    effect: 'brightness(1.1) saturate(1.3)',
    date: [1, 1] // 1月1日(简化)
  }
};

// 检查节日并应用特效
function checkFestivalEffect() {
  let today = new Date();
  let month = today.getMonth() + 1;
  let day = today.getDate();
  
  for (let key in festivalEffects) {
    let festival = festivalEffects[key];
    if (festival.date[0] === month && festival.date[1] === day) {
      vk.setVuex('$app.festivalEffect', festival.effect);
      return;
    }
  }
  
  vk.setVuex('$app.festivalEffect', '');
}
```

### 3. 夜间模式增强

在夜间模式下应用额外效果:

```vue
<template>
  <view :class="['container', themeClass, { 'night-enhanced': isNightEnhanced }]">
    <!-- 页面内容 -->
  </view>
</template>

<script>
export default {
  data() {
    return {
      theme: 'light',
      isNightEnhanced: false
    };
  },
  computed: {
    themeClass() {
      return `theme-${this.theme}`;
    }
  },
  onLoad() {
    this.checkTheme();
  },
  methods: {
    checkTheme() {
      let systemInfo = uni.getSystemInfoSync();
      this.theme = systemInfo.theme === 'dark' ? 'dark' : 'light';
      
      // 夜间模式下增强护眼效果
      if (this.theme === 'dark') {
        this.isNightEnhanced = true;
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.container {
  transition: all 0.3s ease;
}

.theme-dark {
  background-color: #1a1a1a;
  color: #ffffff;
}

.night-enhanced {
  filter: brightness(0.9) contrast(0.95);
  -webkit-filter: brightness(0.9) contrast(0.95);
}
</style>
```

### 4. 无障碍模式

为视力障碍用户提供无障碍模式:

```vue
<template>
  <view :class="{ 'accessibility-mode': isAccessibilityMode }">
    <!-- 页面内容 -->
  </view>
</template>

<style lang="scss" scoped>
.accessibility-mode {
  // 增大字体
  font-size: 1.2em;
  
  // 增加对比度
  filter: contrast(1.2);
  -webkit-filter: contrast(1.2);
  
  // 增加行高
  line-height: 1.8;
  
  // 增加间距
  letter-spacing: 0.05em;
}
```

## 最佳实践

### 1. 性能优化

使用 CSS filter 可能会影响性能,需要注意:

```scss
// 只在必要时应用
.gray-page {
  will-change: filter;
  filter: grayscale(100%);
  -webkit-filter: grayscale(100%);
}

// 使用硬件加速
.gray-page {
  transform: translateZ(0);
  filter: grayscale(100%);
  -webkit-filter: grayscale(100%);
}
```

### 2. 兼容性处理

处理不同浏览器的兼容性:

```scss
.gray-page {
  // 标准语法
  filter: grayscale(100%);
  
  // Webkit 前缀
  -webkit-filter: grayscale(100%);
  
  // Mozilla 前缀
  -moz-filter: grayscale(100%);
  
  // MS 前缀
  -ms-filter: grayscale(100%);
  
  // Opera 前缀
  -o-filter: grayscale(100%);
}
```

### 3. 用户体验

提供开关让用户控制特殊效果:

```vue
<template>
  <view>
    <el-switch
      v-model="isGray"
      active-text="灰色模式"
      @change="toggleGrayMode"
    ></el-switch>
  </view>
</template>

<script>
let vk = uni.vk;

export default {
  data() {
    return {
      isGray: false
    };
  },
  onLoad() {
    // 读取用户设置
    this.isGray = vk.getStorageSync('userGrayMode') || false;
  },
  methods: {
    toggleGrayMode(value) {
      vk.setVuex('$app.isGrayPage', value);
      vk.setStorageSync('userGrayMode', value);
    }
  }
}
</script>
```

### 4. 配置化管理

将特殊效果配置化,便于管理:

```javascript
// app.config.js
module.exports = {
  specialEffects: {
    grayPage: {
      enabled: true,
      auto: true, // 自动检测日期
      dates: [
        { month: 4, day: 4, name: '清明节' },
        { month: 12, day: 13, name: '南京大屠杀死难者国家公祭日' }
      ]
    },
    festivalEffect: {
      enabled: true,
      effects: {
        qingming: 'grayscale(100%)',
        national: 'brightness(1.1) saturate(1.2)'
      }
    }
  }
}
```

### 5. 测试和调试

提供调试工具方便测试:

```javascript
// 开发模式下提供调试工具
if (process.env.NODE_ENV === 'development') {
  window.toggleGrayPage = () => {
    let current = vk.getVuex('$app.isGrayPage');
    vk.setVuex('$app.isGrayPage', !current);
    console.log('灰色页面:', !current);
  };
  
  window.toggleFestivalEffect = (effect) => {
    vk.setVuex('$app.festivalEffect', effect);
    console.log('节日特效:', effect);
  };
}
```

## 常见问题

### Q: CSS filter 会影响性能吗?

**A**: 是的,CSS filter 会影响性能,特别是在移动设备上。建议:
1. 只在必要时使用
2. 使用 `will-change: filter` 提示浏览器优化
3. 避免频繁切换效果
4. 考虑使用 CSS 变量代替 filter

### Q: 如何在小程序中使用 filter?

**A**: 小程序对 CSS filter 的支持有限,建议:
1. 使用小程序支持的 filter 属性
2. 或者使用图片预处理的方式
3. 或者使用 canvas 绘制灰色效果

### Q: 如何在 H5 端实现灰色页面?

**A**: H5 端完全支持 CSS filter,可以直接使用:

```css
.gray-page {
  filter: grayscale(100%);
  -webkit-filter: grayscale(100%);
}
```

### Q: 如何在 App 端实现灰色页面?

**A**: App 端也支持 CSS filter,使用方式与 H5 端一致。

### Q: 如何实现部分灰色?

**A**: 只对需要灰色的元素应用 filter:

```vue
<template>
  <view>
    <view class="normal">正常内容</view>
    <view class="gray">灰色内容</view>
  </view>
</template>

<style lang="scss" scoped>
.gray {
  filter: grayscale(100%);
  -webkit-filter: grayscale(100%);
}
</style>
```

### Q: 如何实现渐变灰色?

**A**: 使用 transition 实现渐变效果:

```scss
.gray-page {
  transition: filter 0.5s ease;
  filter: grayscale(100%);
  -webkit-filter: grayscale(100%);
}
```

### Q: 如何实现其他特殊效果?

**A**: CSS filter 支持多种效果:

```scss
// 模糊
.blur {
  filter: blur(5px);
}

// 亮度
.brightness {
  filter: brightness(0.5);
}

// 对比度
.contrast {
  filter: contrast(2);
}

// 饱和度
.saturate {
  filter: saturate(0.5);
}

// 色相旋转
.hue-rotate {
  filter: hue-rotate(90deg);
}

// 反色
.invert {
  filter: invert(1);
}

// 棕褐色
.sepia {
  filter: sepia(1);
}
```

### Q: 如何组合多个 filter 效果?

**A**: 使用空格分隔多个 filter:

```scss
.combined {
  filter: grayscale(100%) brightness(0.8) contrast(1.2);
  -webkit-filter: grayscale(100%) brightness(0.8) contrast(1.2);
}
```

### Q: 如何移除 filter 效果?

**A**: 将 filter 设置为 none:

```scss
.no-filter {
  filter: none;
  -webkit-filter: none;
}
```

### Q: 如何检测浏览器是否支持 filter?

**A**: 使用 JavaScript 检测:

```javascript
function supportsFilter() {
  const div = document.createElement('div');
  div.style.filter = 'grayscale(100%)';
  return div.style.filter !== '';
}

if (supportsFilter()) {
  console.log('支持 CSS filter');
} else {
  console.log('不支持 CSS filter');
}
```
