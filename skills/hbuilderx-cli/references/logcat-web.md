# CLI uni-app 运行日志 - WEB

> 需 HBuilderX 4.87+ 版本

您也可以通过 npm 包使用此功能：[@dcloudio/hbuilderx-cli](https://www.npmjs.com/package/@dcloudio/hbuilderx-cli)

通过 CLI 查看运行到 Web 或手机 H5 的 uni-app 应用日志。

您可以将 cli 加入到环境变量，这样您就可以在任意目录、任意终端上，随时随地调用 cli，而无需通过输入 cli 绝对路径的方式来使用它。[详情](/cli/env)

## 命令说明

### logcat web

查看运行到 Web 或手机 H5 日志

**用法：**

```bash
./cli logcat web --help
```

**参数：**

| 参数名称 | 描述 |
|---------|------|
| `--help` | 显示 cli 命令帮助 |
| `--project` | HBuilder X 里导入的项目名称或绝对路径 |
| `--browser` | 浏览器类型，取值：Built、Chrome、Firefox、Ie、Edge、Safari，默认值为 Built(HBuilderX 内置浏览器) |
| `--mode` | 日志模式，取值：full、lastBuild、prevBuild，默认值为 prevBuild |

**使用示例：**

```bash
# 查看 Web 日志（使用默认浏览器）
./cli logcat web --project 项目名称

# 查看 Web 日志（指定 Chrome 浏览器）
./cli logcat web --project 项目名称 --browser Chrome

# 查看 Web 日志（指定 Firefox 浏览器）
./cli logcat web --project 项目名称 --browser Firefox

# 查看 Web 日志（指定 Edge 浏览器）
./cli logcat web --project 项目名称 --browser Edge

# 查看 Web 日志（指定 Safari 浏览器）
./cli logcat web --project 项目名称 --browser Safari

# 查看 Web 日志（指定 IE 浏览器）
./cli logcat web --project 项目名称 --browser Ie

# 查看 Web 日志（指定日志模式）
./cli logcat web --project 项目名称 --mode full

# 查看 Web 日志（组合参数：指定浏览器 + 日志模式）
./cli logcat web --project 项目名称 --browser Chrome --mode lastBuild
```

**cli 实际使用示例：**

```bash
# Mac 电脑 使用 cli 查看 hello-uni-app-x 项目 运行到 chrome 日志
/Applications/HBuilderX.app/Contents/MacOS/cli logcat web --project hello-uni-app-x --browser Chrome

# Mac 电脑 --project 传递绝对路径
/Applications/HBuilderX.app/Contents/MacOS/cli logcat web --project /User/apple/Desktop/hello-uni-app-x --browser Chrome

# Windows 电脑：使用 cli 查看 hello-uni-app-x 项目 运行到 chrome 日志
D:\ide\HBuilderX\cli.exe logcat web --project hello-uni-app-x --browser Chrome
```

## 通过 npm scripts 使用 CLI

我们需要在项目中安装 [@dcloudio/hbuilderx-cli](https://www.npmjs.com/package/@dcloudio/hbuilderx-cli)，它是一个桥梁，让我们可以通过命令行来调用 HBuilderX 的强大功能（如启动测试流程）。

### 添加 npm 脚本支持

```bash
# 首先，请确保你的项目根目录下有 package.json 文件。如果没有，可以通过以下命令快速生成：
npm init -y

# 然后，安装 hbuilderx-cli 作为开发依赖：
npm install @dcloudio/hbuilderx-cli --save-dev
```

### 使用 npm 命令查看日志

```bash
# 查看 uni-app(x) HBuilderX 内置浏览器 运行日志
npm run logcat:web

# 查看 uni-app(x) Chrome 运行日志
npm run logcat:web -- --browser Chrome

# 查看 uni-app(x) Safari 运行日志
npm run logcat:web -- --browser Safari
```
