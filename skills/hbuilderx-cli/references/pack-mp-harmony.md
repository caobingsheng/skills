# CLI uni-app 发行 - 鸿蒙元服务打包

> HBuilderX cli 命令行工具

通过 CLI 对鸿蒙元服务平台进行本地打包，支持 uni-app 项目。

## 命令说明

### pack mp-harmony

对鸿蒙元服务平台进行本地打包（仅适用于 uni-app）

**用法：**

```bash
cli pack mp-harmony --help
cli pack mp-harmony --project D:/projects/demo-app
cli pack mp-harmony --project demo-app
```

**参数：**

| 参数 | 说明 |
|-----|------|
| `--help` | cli 命令帮助 |
| `--project` | HBuilder X 里导入的项目绝对路径或目录名 |

**使用示例：**

```bash
# 查看命令帮助
cli pack mp-harmony --help

# 对鸿蒙元服务平台进行本地打包（使用绝对路径）
cli pack mp-harmony --project D:/projects/demo-app

# 对鸿蒙元服务平台进行本地打包（使用目录名）
cli pack mp-harmony --project demo-app
```

**注意事项：**

> 首先，需要启动 HBuilderX（进入 HBuilderX 安装目录根目录，终端输入 `cli.exe open`）
>
> 此命令仅适用于 uni-app 项目
