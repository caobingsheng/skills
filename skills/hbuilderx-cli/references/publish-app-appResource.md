# CLI uni-app 发行 - App 生成本地打包资源

> HBuilderX cli 命令行工具

通过 CLI 生成本地打包 App 资源，支持 uni-app、Wap2App、5+App 项目。

## 命令说明

### publish app-android

生成本地打包 Android App 资源

**用法：**

```bash
./cli publish app-android --help
./cli publish app-android --type appResource --project xxx
```

**参数：**

| 参数 | 说明 |
|-----|------|
| `--help` | 发行 cli 命令帮助 |
| `--project` | HBuilder X 里导入的项目绝对路径 |
| `--type` | [appResource] 本地打包（生成本地打包 App 资源） |

**使用示例：**

```bash
# 生成本地打包 Android App 资源
./cli publish app-android --type appResource --project 项目名称

# 生成本地打包 Android App 资源（使用绝对路径）
./cli publish app-android --type appResource --project /path/to/project
```

### publish app-ios

生成本地打包 iOS App 资源

**用法：**

```bash
./cli publish app-ios --help
./cli publish app-ios --type appResource --project xxx
```

**参数：**

| 参数 | 说明 |
|-----|------|
| `--help` | 发行 cli 命令帮助 |
| `--project` | HBuilder X 里导入的项目绝对路径 |
| `--type` | [appResource] 本地打包（生成本地打包 App 资源） |

**使用示例：**

```bash
# 生成本地打包 iOS App 资源
./cli publish app-ios --type appResource --project 项目名称

# 生成本地打包 iOS App 资源（使用绝对路径）
./cli publish app-ios --type appResource --project /path/to/project
```

**注意事项：**

> 首先，需要启动 HBuilderX（进入 HBuilderX 安装目录根目录，终端输入 `cli.exe open`）
