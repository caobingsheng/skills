# CLI uni-app 运行 - WEB

> 需 HBuilderX 5.0+ 版本

您也可以通过 npm 包使用此功能：[@dcloudio/hbuilderx-cli](https://www.npmjs.com/package/@dcloudio/hbuilderx-cli)

通过 CLI 运行到 Web 或手机 H5 的 uni-app 应用。

[HBuilderX CLI](/cli/README?id=cli)

## 命令说明

### launch web

运行到 Web 或手机 H5

**用法：**

```bash
./cli launch web --help
```

**参数：**

| 参数名称 | 描述 |
|---------|------|
| `--help` | 显示 cli 命令帮助 |
| `--project` | HBuilder X 里导入的项目名称或绝对路径 |
| `--compile` | 编译模式运行（只编译代码），取值：true 或 false，默认值为 false |
| `--browser` | 浏览器类型，取值：Built、Chrome、Firefox、Ie、Edge、Safari，默认值为 Built |
| `--continue-on-error` | 编译错误后继续运行，取值：true 或 false，默认值为 false |

**使用示例：**

```bash
# 运行到 Web
./cli launch web --project 项目名称

# 运行到 Web（指定浏览器）
./cli launch web --project 项目名称 --browser Chrome

# 运行到 Web（编译模式）
./cli launch web --project 项目名称 --compile true

# 运行到 Web（编译错误后继续运行）
./cli launch web --project 项目名称 --continue-on-error true

# 运行到 Web（组合参数：指定浏览器 + 编译模式）
./cli launch web --project 项目名称 --browser Chrome --compile true

# 运行到 Web（组合参数：编译模式 + 编译错误后继续运行）
./cli launch web --project 项目名称 --compile true --continue-on-error true
```
