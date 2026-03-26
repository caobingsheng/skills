---
name: hbuilderx-cli
description: HBuilderX CLI 命令行工具完整使用指南。Use when working with HBuilderX CLI commands, especially when: (1) Running uni-app projects on web, app, or mini-program platforms, (2) Packaging apps for Harmony OS or other platforms, (3) Publishing projects to various platforms, (4) Viewing logs for debugging, (5) Managing uniCloud services, (6) Listing devices for deployment. Covers launch, pack, publish, logcat, project, uniCloud, and device management commands.
---

# HBuilderX CLI

HBuilderX CLI 是 HBuilderX 的命令行工具，支持项目运行、打包、发布、日志查看等操作。

## Quick Start

### 基本命令结构

```bash
# 查看帮助
./cli --help

# 运行 Web 项目
./cli launch web --project 项目名称

# 运行微信小程序
./cli launch mp-weixin --project 项目名称

# 打包鸿蒙应用
./cli pack app-harmony --project 项目名称

# 发布到 Web
./cli publish web --project 项目名称
```

## Key Concepts

### 命令分类

HBuilderX CLI 命令分为以下几类：

1. **运行调试**：launch 命令族
2. **打包构建**：pack 命令族
3. **发布部署**：publish 命令族
4. **日志查看**：logcat 命令族
5. **项目管理**：project 命令族
6. **云函数**：uniCloud 命令族
7. **设备管理**：devices 命令族

### 平台类型

- Web: `web`
- 小程序：`mp-weixin`, `mp-alipay`, `mp-harmony` 等
- App: `app-android`, `app-ios`, `app-harmony`

## Workflow

### 1. 运行项目

#### 运行 Web 项目

```bash
# 基本用法
./cli launch web --project 项目名称

# 指定浏览器
./cli launch web --project 项目名称 --browser Chrome

# 编译模式运行
./cli launch web --project 项目名称 --compile true

# 显示帮助
./cli launch web --help
```

#### 运行 App

```bash
# 运行到 Android 设备
./cli launch app-android --project 项目名称

# 运行到 iOS 设备
./cli launch app-ios --project 项目名称

# 运行到鸿蒙设备
./cli launch app-harmony --project 项目名称

# 显示帮助
./cli launch app-android --help
./cli launch app-ios --help
./cli launch app-harmony --help
```

#### 运行小程序

```bash
# 运行到微信小程序
./cli launch mp-weixin --project 项目名称

# 运行到支付宝小程序
./cli launch mp-alipay --project 项目名称

# 运行到鸿蒙元服务
./cli launch mp-harmony --project 项目名称

# 显示帮助
./cli launch mp-weixin --help
./cli launch mp-alipay --help
./cli launch mp-harmony --help
```
```

### 2. 打包应用

#### App 打包

```bash
# 云打包（Android/iOS）
./cli pack --project 项目名称 --platform android

# 显示帮助
./cli pack --help
```

#### Harmony 打包

```bash
# 打包 Harmony App（本地打包）
./cli pack app-harmony --project 项目名称

# 打包 Harmony 元服务
./cli pack mp-harmony --project 项目名称

# 显示帮助
./cli pack app-harmony --help
./cli pack mp-harmony --help
```

### 3. 发布项目

#### 发布 Web

```bash
# 发布 Web 项目
./cli publish web --project 项目名称

# 显示帮助
./cli publish web --help
```

#### 发布小程序

```bash
# 发布到微信小程序
./cli publish mp-weixin --project 项目名称

# 发布到支付宝小程序
./cli publish mp-alipay --project 项目名称

# 显示帮助
./cli publish mp-weixin --help
./cli publish mp-alipay --help
```

#### 发布 App

```bash
# 发布 App 资源（Android）
./cli publish app-android --project 项目名称 --type appResource

# 发布 App 资源（iOS）
./cli publish app-ios --project 项目名称 --type appResource

# 发布 Harmony App 资源
./cli publish app-harmony --project 项目名称 --type appResource

# 发布 WGT 包
./cli publish app --project 项目名称 --type wgt

# 显示帮助
./cli publish app-android --help
./cli publish app-harmony --help
./cli publish app --help
```

### 4. 查看日志

#### Web 日志

```bash
# 查看 Web 日志
./cli logcat web --project 项目名称

# 显示帮助
./cli logcat web --help
```

#### App 日志

```bash
# 查看 Android App 日志
./cli logcat app-android --project 项目名称

# 查看 iOS App 日志
./cli logcat app-ios --project 项目名称

# 查看鸿蒙 App 日志
./cli logcat app-harmony --project 项目名称

# 显示帮助
./cli logcat app-android --help
./cli logcat app-ios --help
./cli logcat app-harmony --help
```

#### 小程序日志

```bash
# 查看微信小程序日志
./cli logcat mp-weixin --project 项目名称

# 查看支付宝小程序日志
./cli logcat mp-alipay --project 项目名称

# 查看鸿蒙元服务日志
./cli logcat mp-harmony --project 项目名称

# 显示帮助
./cli logcat mp-weixin --help
./cli logcat mp-alipay --help
./cli logcat mp-harmony --help
```

#### 云函数日志

```bash
# 查看云函数日志
./cli logcat unicloud --project 项目名称

# 显示帮助
./cli logcat unicloud --help
```

### 5. 项目管理

#### 项目操作

```bash
# 列举所有项目
./cli project list

# 导入项目
./cli project open --path 项目绝对路径

# 关闭项目
./cli project close --path 项目绝对路径

# 显示帮助
./cli project list --help
```

#### 文件操作

```bash
# 打开指定文件
./cli open file --file 文件路径

# 显示帮助
./cli open file --help
```

#### uniModules

```bash
# 查看 uniModules 帮助
./cli uni_modules --help

# 显示已安装的插件列表
./cli uni_modules --list --project 项目路径

# 下载插件
./cli uni_modules --download 插件ID --project 项目路径

# 更新插件
./cli uni_modules --upgrade 插件ID --project 项目路径
```

### 6. 云函数管理

#### 云函数操作

```bash
# 查看云函数帮助
./cli cloud functions --help

# 获取云函数列表（本地）
./cli cloud functions --list cloudfunction --prj 项目名称 --provider aliyun

# 获取云函数列表（云端）
./cli cloud functions --list cloudfunction --prj 项目名称 --provider aliyun --cloud

# 上传云函数
./cli cloud functions --upload cloudfunction --prj 项目名称 --provider aliyun --name 云函数名称

# 下载云函数
./cli cloud functions --download cloudfunction --prj 项目名称 --provider aliyun --name 云函数名称

# 上传所有云函数
./cli cloud functions --upload allcloudfunctions --prj 项目名称 --provider aliyun

# 下载所有云函数
./cli cloud functions --download all --prj 项目名称 --provider aliyun
```

#### 云托管

```bash
# 前端网页托管
./cli hosting deploy --prj 项目名称 --space 云空间ID --provider aliyun

# 获取云空间文件列表
./cli hosting list --space 云空间ID --provider aliyun

# 删除云空间文件
./cli hosting delete --space 云空间ID --provider aliyun --path 文件路径

# 显示帮助
./cli hosting deploy --help
./cli hosting list --help
```

### 7. 用户管理

```bash
# 用户登录
./cli user login --username 用户名 --password 密码

# 当前用户登出
./cli user logout

# 查看当前登录用户信息
./cli user info

# 显示帮助
./cli user login --help
```

### 8. 设备管理

#### 获取设备列表

```bash
# 获取 Android 设备列表（默认）
./cli devices list

# 获取指定平台设备列表
./cli devices list --platform android

# 获取 iPhone 设备列表
./cli devices list --platform ios-iPhone

# 获取 iOS 模拟器列表
./cli devices list --platform ios-simulator

# 获取鸿蒙元服务设备列表
./cli devices list --platform mp-harmony

# 获取鸿蒙 App 设备列表
./cli devices list --platform app-harmony

# 显示帮助
./cli devices list --help
```

#### 设备类型参数

`--platform` 参数可选值：
- `android` - Android 设备
- `ios-iPhone` - iPhone 设备
- `ios-simulator` - iOS 模拟器
- `mp-harmony` - 鸿蒙元服务设备
- `app-harmony` - 鸿蒙 App 设备

### 9. 截屏功能

```bash
# Android App 截屏
./cli screencap app-android --project 项目名称 --deviceId 设备序列号 --saveFile 保存路径.png

# iOS App 截屏
./cli screencap app-ios --project 项目名称 --deviceId 设备序列号 --saveFile 保存路径.png

# 鸿蒙 App 截屏
./cli screencap app-harmony --project 项目名称 --deviceId 设备序列号 --saveFile 保存路径.png

# 显示帮助
./cli screencap app-android --help
./cli screencap app-ios --help
./cli screencap app-harmony --help
```

## Best Practices

### 开发流程

1. **开发阶段**：使用 `launch` 命令运行项目进行开发
   - Web: `./cli launch web --project 项目名称`
   - 小程序：`./cli launch mp-weixin --project 项目名称`
   - App: `./cli launch app-android --project 项目名称`

2. **调试阶段**：使用 `logcat` 命令查看日志
   - Web 日志：`./cli logcat web --project 项目名称`
   - App 日志：`./cli logcat app-android --project 项目名称`
   - 云函数日志：`./cli logcat unicloud --project 项目名称`

3. **打包阶段**：使用 `pack` 命令打包应用
   - App 云打包：`./cli pack --project 项目名称 --platform android`
   - Harmony 打包：`./cli pack app-harmony --project 项目名称`

4. **发布阶段**：使用 `publish` 命令发布应用
   - Web 发布：`./cli publish web --project 项目名称`
   - 小程序发布：`./cli publish mp-weixin --project 项目名称`
   - App 发布：`./cli publish app --project 项目名称 --type wgt`

### 常见问题

#### 命令不识别

确保 CLI 工具路径正确，并且有执行权限。

#### 设备未识别

使用 `./cli devices list` 检查设备连接状态。

#### 编译错误

使用 `--continue-on-error` 参数继续运行：
```bash
./cli launch web --project 项目名称 --continue-on-error true
```

#### 查看详细日志

使用 `--runtime-log` 或 `--native-log` 参数：
```bash
# 小程序运行时日志
./cli launch mp-weixin --project 项目名称 --runtime-log true

# Android 原生日志
./cli launch app-android --project 项目名称 --native-log true
```

### 帮助系统

所有命令都支持 `--help` 参数查看帮助：

```bash
# 查看命令帮助
./cli <command> --help

# 示例
./cli launch web --help
./cli pack --help
./cli publish mp-weixin --help
./cli logcat app-android --help
./cli cloud functions --help
```

## References

详细内容请参考以下文档：

### 运行调试类

- [运行 Web 项目](references/launch-web.md) - Web 项目运行配置和参数
- [运行 App](references/launch-app.md) - App 运行到设备和模拟器
- [运行小程序](references/launch-miniProgram.md) - 小程序运行到开发者工具

### 打包构建类

- [打包应用](references/pack.md) - 通用打包命令和参数
- [Harmony App 打包](references/pack-app-harmony.md) - 鸿蒙应用打包
- [Harmony 元服务打包](references/pack-mp-harmony.md) - 鸿蒙元服务打包

### 发布部署类

- [发布 Web](references/publish-h5.md) - Web/H5 项目发布
- [发布小程序](references/publish-miniProgram.md) - 小程序发布到各平台
- [发布 App 资源](references/publish-app-appResource.md) - App 资源配置发布
- [发布 Harmony App](references/publish-app-harmony.md) - 鸿蒙应用发布
- [发布 WGT 包](references/publish-app-wgt.md) - WGT 包发布

### 日志查看类

- [Web 日志](references/logcat-web.md) - Web 项目日志查看
- [App 日志](references/logcat-app.md) - App 运行时日志
- [小程序日志](references/logcat-miniProgram.md) - 小程序日志
- [云函数日志](references/logcat-unicloud.md) - uniCloud 云函数日志

### 项目管理类

- [项目命令](references/project.md) - 项目管理相关命令
- [文件命令](references/file.md) - 文件操作命令
- [uniModules](references/uniModules.md) - uniModules 管理

### 云函数类

- [云函数命令](references/uniCloud.md) - uniCloud 相关命令
- [云托管](references/uniCloud-hosting.md) - 云托管服务管理

### 用户和设备类

- [用户命令](references/user.md) - 用户账户管理
- [设备列表](references/devices-list.md) - 获取可用设备列表

### 其他工具

- [App 截屏](references/screencap-app.md) - App 截屏功能


### cli --help

- [完整帮助文档](references/hbuilderx-cli--help.txt) - cli --help完整帮助文档
