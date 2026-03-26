# CLI uni-app 发行 - App-Harmony 本地打包 App 资源

> HBuilderX cli 命令行工具

通过 CLI 对鸿蒙平台生成本地打包 App 资源或 wgt 包，支持 uni-app (x) 项目。

## 命令说明

### publish app-harmony

生成本地打包 App 资源或 wgt 包

**用法：**

```bash
./cli publish app-harmony --help
./cli publish app-harmony --project demo-app --type appResource
./cli publish app-harmony --project demo-app --type wgt
```

**参数：**

| 参数 | 说明 |
|-----|------|
| `--help` | cli 命令帮助 |
| `--project` | HBuilder X 里导入的项目绝对路径或目录名 |
| `--type` | [appResource|wgt] 本地打包（生成本地打包 App 资源）或制作 wgt 包 |

**使用示例：**

```bash
# 生成本地打包 App 资源
./cli publish app-harmony --type appResource --project 项目名称

# 生成本地打包 wgt 包
./cli publish app-harmony --type wgt --project 项目名称

# 使用项目目录名
./cli publish app-harmony --project demo-app --type appResource

# 组合参数：指定项目路径和类型
./cli publish app-harmony --project /path/to/project --type wgt
```

**注意事项：**

> 首先，需要启动 HBuilderX（进入 HBuilderX 安装目录根目录，终端输入 `cli.exe open`）
>
> `--type appResource` 生成本地打包 App 资源
>
> `--type wgt` 制作应用 wgt 包
