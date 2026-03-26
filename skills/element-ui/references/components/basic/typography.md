# Typography 字体

Element UI 对字体进行统一规范,力求在各个操作系统下都有最佳展示效果。

## 字体族

```css
font-family: "Helvetica Neue", Helvetica, "PingFang SC", "Hiragino Sans GB", "Microsoft YaHei", "微软雅黑", Arial, sans-serif;
```

## 字号

Element 使用了以下字体大小:

```vue
<div class="el-font-size-extra-large">Extra Large - 20px</div>
<div class="el-font-size-large">Large - 18px</div>
<div class="el-font-size-medium">Medium - 16px</div>
<div class="el-font-size-base">Base - 14px</div>
<div class="el-font-size-small">Small - 13px</div>
<div class="el-font-size-extra-small">Extra Small - 12px</div>
```

**Extra Large**: 20px
**Large**: 18px
**Medium**: 16px
**Base**: 14px
**Small**: 13px
**Extra Small**: 12px

## 行高

```css
line-height: 1.5;
```

## 字重

```vue
<div class="el-font-weight-light">Light - 300</div>
<div class="el-font-weight-regular">Regular - 400</div>
<div class="el-font-weight-medium">Medium - 500</div>
<div class="el-font-weight-bold">Bold - 700</div>
```

**Light**: 300
**Regular**: 400
**Medium**: 500
**Bold**: 700

## 最佳实践

1. **字体族**: 使用Element推荐的字体族,确保跨平台一致性
2. **字号选择**:
   - Extra Large 20px: 页面标题、重要标题
   - Large 18px: 次级标题、卡片标题
   - Medium 16px: 正文内容、重要信息
   - Base 14px: 常规内容、表单标签
   - Small 13px: 辅助文字、提示信息
   - Extra Small 12px: 注释、版权信息
3. **行高**: 使用1.5的行高,保证良好的阅读体验
4. **字重**:
   - Light 300: 轻量级标题、装饰性文字
   - Regular 400: 正文内容、常规文字
   - Medium 500: 次级标题、强调文字
   - Bold 700: 主标题、重要强调
5. **字体层级**: 建立清晰的字体层级,通过字号和字重区分信息重要性
6. **可读性**: 确保文字大小不小于12px,保证可读性
7. **响应式**: 在不同屏幕尺寸下调整字号,保持良好的阅读体验
8. **CSS变量**: 使用CSS变量定义字体样式,方便统一管理和修改
