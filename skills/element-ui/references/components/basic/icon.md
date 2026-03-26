# Icon 图标

提供了一套常用的图标集合。

## 基础用法

### 使用方法
直接通过设置类名为 `el-icon-iconName` 来使用即可。

```vue
<i class="el-icon-edit"></i>
<i class="el-icon-share"></i>
<i class="el-icon-delete"></i>
<el-button type="primary" icon="el-icon-search">搜索</el-button>
```

### 图标集合
Element UI 提供了丰富的图标集合，包括：

**基础图标：**
- `el-icon-edit` - 编辑
- `el-icon-delete` - 删除
- `el-icon-search` - 搜索
- `el-icon-setting` - 设置
- `el-icon-user` - 用户
- `el-icon-phone` - 电话
- `el-icon-more` - 更多
- `el-icon-star-on` - 星星（实心）
- `el-icon-star-off` - 星星（空心）

**操作图标：**
- `el-icon-plus` - 加号
- `el-icon-minus` - 减号
- `el-icon-check` - 对勾
- `el-icon-close` - 关闭
- `el-icon-success` - 成功
- `el-icon-error` - 错误
- `el-icon-warning` - 警告
- `el-icon-info` - 信息
- `el-icon-question` - 问号

**方向图标：**
- `el-icon-arrow-left` - 左箭头
- `el-icon-arrow-right` - 右箭头
- `el-icon-arrow-up` - 上箭头
- `el-icon-arrow-down` - 下箭头
- `el-icon-back` - 返回
- `el-icon-right` - 前进
- `el-icon-top` - 顶部
- `el-icon-bottom` - 底部

**文件图标：**
- `el-icon-folder` - 文件夹
- `el-icon-folder-opened` - 打开的文件夹
- `el-icon-document` - 文档
- `el-icon-document-add` - 新建文档
- `el-icon-document-delete` - 删除文档
- `el-icon-document-copy` - 复制文档

**媒体图标：**
- `el-icon-picture` - 图片
- `el-icon-video-camera` - 摄像机
- `el-icon-microphone` - 麦克风
- `el-icon-headset` - 耳机
- `el-icon-camera` - 相机

**其他图标：**
- `el-icon-loading` - 加载中
- `el-icon-refresh` - 刷新
- `el-icon-date` - 日期
- `el-icon-time` - 时间
- `el-icon-location` - 位置
- `el-icon-message` - 消息
- `el-icon-bell` - 铃铛
- `el-icon-lock` - 锁
- `el-icon-unlock` - 解锁

## 最佳实践

1. **图标使用**：在按钮、输入框等组件中使用 `icon` 属性添加图标。

2. **图标大小**：通过 CSS 的 `font-size` 属性控制图标大小。

3. **图标颜色**：通过 CSS 的 `color` 属性控制图标颜色。

4. **图标对齐**：使用 `vertical-align` 属性调整图标的对齐方式。

5. **自定义图标**：如果需要自定义图标，可以使用 `iconClass` 属性或自定义 CSS 类名。
