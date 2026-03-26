# Color 色彩

Element UI 为了避免视觉传达差异,使用一套特定的调色板来规定颜色,为你所搭建的产品提供一致的外观视觉感受。

## 主色

Element 主要品牌颜色是鲜艳、友好的蓝色。

```vue
<div class="el-color-primary">Primary Color</div>
```

**Blue**: #409EFF

## 辅助色

除了主色外的场景色,需要在不同的场景中使用(例如危险色表示危险的操作)。

```vue
<div class="el-color-success">Success</div>
<div class="el-color-warning">Warning</div>
<div class="el-color-danger">Danger</div>
<div class="el-color-info">Info</div>
```

**Success**: #67C23A
**Warning**: #E6A23C
**Danger**: #F56C6C
**Info**: #909399

## 中性色

中性色用于文本、背景和边框颜色,通过运用不同的中性色,来表现层次结构。

```vue
<div class="el-color-text-primary">主要文字</div>
<div class="el-color-text-regular">常规文字</div>
<div class="el-color-text-secondary">次要文字</div>
<div class="el-color-text-placeholder">占位文字</div>
```

**主要文字**: #303133
**常规文字**: #606266
**次要文字**: #909399
**占位文字**: #C0C4CC

**边框颜色**: #DCDFE6 (一级边框)
**边框颜色**: #E4E7ED (二级边框)
**边框颜色**: #EBEEF5 (三级边框)
**边框颜色**: #F2F6FC (四级边框)

**背景颜色**: #F5F7FA

## 最佳实践

1. **主色使用**: 主色#409EFF用于品牌标识、主要按钮、链接等核心元素
2. **辅助色使用**:
   - Success #67C23A: 成功状态、成功提示
   - Warning #E6A23C: 警告状态、警告提示
   - Danger #F56C6C: 危险操作、错误提示
   - Info #909399: 信息提示、中性状态
3. **文字颜色**:
   - 主要文字 #303133: 标题、重要信息
   - 常规文字 #606266: 正文内容
   - 次要文字 #909399: 辅助说明
   - 占位文字 #C0C4CC: 输入框占位符
4. **边框颜色**: 使用不同层级的边框颜色创建视觉层次
5. **背景颜色**: #F5F7FA用于页面背景、卡片背景等
6. **颜色变量**: 在项目中定义CSS变量,方便统一管理和修改
7. **色彩对比**: 确保文字与背景有足够的对比度,保证可读性
8. **主题定制**: 根据品牌需求调整主色和辅助色,保持整体风格一致
