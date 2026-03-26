# Border 边框

Element UI 对边框进行统一规范,用于区分不同区域、分隔内容。

## 边框样式

```vue
<div class="el-border-solid">实线边框</div>
<div class="el-border-dashed">虚线边框</div>
<div class="el-border-dotted">点线边框</div>
```

## 边框圆角

```vue
<div class="el-border-radius-none">无圆角</div>
<div class="el-border-radius-small">小圆角 2px</div>
<div class="el-border-radius-base">基础圆角 4px</div>
<div class="el-border-radius-large">大圆角 8px</div>
<div class="el-border-radius-circle">圆形</div>
```

## 边框颜色

```vue
<div class="el-border-color-base">基础边框 #DCDFE6</div>
<div class="el-border-color-light">浅色边框 #E4E7ED</div>
<div class="el-border-color-lighter">更浅边框 #EBEEF5</div>
<div class="el-border-color-extra-light">极浅边框 #F2F6FC</div>
```

## 边框宽度

```vue
<div class="el-border-width-thin">细边框 1px</div>
<div class="el-border-width-base">基础边框 1px</div>
<div class="el-border-width-thick">粗边框 2px</div>
```

## 最佳实践

1. **边框样式**:
   - Solid: 常规边框、分隔线
   - Dashed: 虚线分隔、辅助线
   - Dotted: 点线装饰、辅助线
2. **边框圆角**:
   - None: 无圆角,适用于需要直角的场景
   - Small 2px: 小圆角,适用于按钮、标签
   - Base 4px: 基础圆角,适用于卡片、输入框
   - Large 8px: 大圆角,适用于对话框、弹窗
   - Circle: 圆形,适用于头像、图标
3. **边框颜色**:
   - Base #DCDFE6: 一级边框,主要分隔线
   - Light #E4E7ED: 二级边框,次要分隔线
   - Lighter #EBEEF5: 三级边框,辅助分隔线
   - Extra Light #F2F6FC: 四级边框,装饰性边框
4. **边框宽度**:
   - Thin 1px: 细边框,适用于精细分隔
   - Base 1px: 基础边框,常规使用
   - Thick 2px: 粗边框,强调分隔
5. **视觉层次**: 使用不同颜色和宽度的边框创建视觉层次
6. **一致性**: 在整个项目中保持边框样式的一致性
7. **圆角统一**: 同一类型的组件使用相同的圆角大小
8. **CSS变量**: 使用CSS变量定义边框样式,方便统一管理和修改
