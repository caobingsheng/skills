# CLI uni-app 发行 - App 制作应用 wgt 包

> HBuilderX cli 命令行工具

通过 CLI 导出 wgt 包，支持 uni-app、Wap2App、5+App 项目。

## 命令说明

### publish app

制作应用 wgt 包

**用法：**

```bash
./cli publish app --help
./cli publish app --type wgt --project xxx --name test.wgt --confuse true
```

**参数：**

| 参数 | 说明 |
|-----|------|
| `--help` | 发行 cli 命令帮助 |
| `--platform` | [APP] 发行平台 |
| `--project` | HBuilder X 里导入的项目绝对路径 |
| `--type` | [wgt] 制作应用 wgt 包 |
| `--name` | 导出名称 (不指定默认为：AppID) |
| `--path` | 导出路径 (不指定默认为：项目根路径/unpackage/release) |
| `--confuse` | 是否对配置的 js/nvue 文件进行原生混淆，取值：true 或 false，默认值为 false |
| `--sourceMap` | 生成 SourceMap，取值：true 或 false，默认值为 false |

**使用示例：**

```bash
# 导出 wgt 包，默认选项
./cli publish app --type wgt --project 项目名称

# 导出 wgt 包，对配置的 js/nvue 文件进行原生混淆
./cli publish app --type wgt --project 项目名称 --confuse true

# 导出 wgt 包，自定义导出名称
./cli publish app --type wgt --project 项目名称 --name test.wgt

# 导出 wgt 包，自定义导出路径
./cli publish app --type wgt --project 项目名称 --path /path/to/output

# 导出 wgt 包，自定义导出路径和名称
./cli publish app --type wgt --project 项目名称 --path /path/to/output --name test.wgt

# 导出 wgt 包，生成 SourceMap
./cli publish app --type wgt --project 项目名称 --sourceMap true

# 导出 wgt 包，组合参数：原生混淆 + 自定义导出路径和名称
./cli publish app --type wgt --project 项目名称 --confuse true --path /path/to/output --name test.wgt

# 导出 wgt 包，组合参数：原生混淆 + SourceMap
./cli publish app --type wgt --project 项目名称 --confuse true --sourceMap true
```

**注意事项：**

> HBuilderX 4.67-alpha 开始支持 app-ios/app-android/app-harmony 平台
>
> 使用 `cli publish app-ios --type wgt`、`cli publish app-android --type wgt` 或 `cli publish app-harmony --type wgt` 可以针对特定平台导出 wgt 包
