---
name: element-ui
description: Element UI 2.15.14 完整组件文档(el-开头的组件)和最佳实践指南。包含 60+ 组件的 API、示例代码和使用场景。适用于 Vue 2 + Element UI 项目开发。当用户需要：查找组件用法、查看组件 API、学习最佳实践、解决组件使用问题时触发。
---

# Element UI 组件指南

Element UI 是一套为开发者、设计师和产品经理准备的基于 Vue 2.0 的桌面端组件库。

## 快速开始

### 如何使用本 Skill

1. **查找组件**：根据需求选择查找方式
   - 按分类查找：了解组件属于哪个分类（Basic、Form、Data、Notice、Navigation、Others）
   - 按名称查找：直接搜索组件名称（如 el-button、el-table）
   - 按场景查找：根据使用场景选择合适的组件

2. **加载文档**：根据组件分类加载对应的 reference 文件
   - 具体组件 → `references/components/<分类>/<组件名>.md`
   - 分类概览 → `references/categories/<分类名>.md`
   - 完整索引 → `references/index.md`

3. **快速索引**：需要查看完整组件列表时，加载 `references/index.md`

## 组件分类概览

### Basic（基础组件）
- Layout 布局、Container 布局容器、Color 色彩、Typography 字体、Border 边框、Icon 图标、Button 按钮、Link 文字链接

### Form（表单组件）
- Radio 单选框、Checkbox 多选框、Input 输入框、InputNumber 计数器、Select 选择器、Cascader 级联选择器、Switch 开关、Slider 滑块、TimePicker 时间选择器、DatePicker 日期选择器、DateTimePicker 日期时间选择器、Upload 上传、Rate 评分、ColorPicker 颜色选择器、Transfer 穿梭框、Form 表单

### Data（数据展示）
- Table 表格、Tag 标签、Progress 进度条、Tree 树形控件、Pagination 分页、Badge 标记、Avatar 头像、Skeleton 骨架屏、Empty 空状态、Descriptions 描述列表、Result 结果、Statistic 统计数值、Calendar 日历、Image 图片、Backtop 回到顶部、InfiniteScroll 无限滚动

### Notice（通知）
- Alert 警告、Loading 加载、Message 消息提示、MessageBox 弹框、Notification 通知

### Navigation（导航）
- NavMenu 导航菜单、Tabs 标签页、Breadcrumb 面包屑、PageHeader 页头、Dropdown 下拉菜单、Steps 步骤条

### Others（其他）
- Dialog 对话框、Tooltip 文字提示、Popover 弹出框、Popconfirm 气泡确认框、Card 卡片、Carousel 走马灯、Collapse 折叠面板、Timeline 时间线、Divider 分割线、Drawer 抽屉

## 何时加载 Reference 文件

### 加载 index.md
- 需要查看完整的组件列表
- 不确定组件属于哪个分类
- 需要快速浏览所有可用组件

### 加载分类文件（categories/*.md）
- 用户明确提到某个分类的组件（如"表单组件"、"数据展示"）
- 用户询问某个分类下的组件选择建议

### 加载组件文件（components/**/*.md）
- 用户提到具体组件名称（如"el-button"、"el-table"）
- 用户询问具体组件的用法、API 或示例

### 不需要加载的情况
- 用户只是简单询问 Element UI 是什么
- 用户询问的是 Vue 相关问题而非 Element UI 组件
- 用户询问的是其他 UI 框架（如 Ant Design、Vuetify）

## 文档内容标准

每个组件文档包含：
- **组件简介**（50-100 字）：组件用途和特点
- **核心示例**（1-2 个）：最常用的使用场景
- **API 摘要**：关键属性、事件、插槽
- **最佳实践**（1-2 条）：使用建议和注意事项

## 常见使用场景

### 表单开发
加载 `references/categories/form.md`，重点查看：Input、Select、Form 组件

### 数据表格
加载 `references/categories/data.md`，重点查看：Table、Pagination 组件

### 弹窗交互
加载 `references/categories/others.md`，重点查看：Dialog、Drawer 组件

### 消息提示
加载 `references/categories/notice.md`，重点查看：Message、Notification 组件

### 导航菜单
加载 `references/categories/navigation.md`，重点查看：Menu、Tabs 组件

## 最佳实践

1. **组件选择**：根据使用场景选择最合适的组件，避免过度设计
2. **属性配置**：优先使用组件的默认配置，只在必要时自定义
3. **样式定制**：使用 Element UI 的主题定制功能，避免直接修改组件样式
4. **性能优化**：大数据量场景使用虚拟滚动（Table、Tree 组件）
5. **国际化**：使用 Element UI 的 i18n 支持多语言

## 相关资源

- Element UI 官方文档：https://element.eleme.cn/#/zh-CN
- Element UI GitHub：https://github.com/ElemeFE/element
- Element UI 版本：2.15.14


