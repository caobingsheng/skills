# CLI uni-app 运行日志 - uniCloud

> 需 HBuilderX 4.87+ 版本

通过 CLI 查看运行到 uniCloud 的日志。

[HBuilderX CLI](/cli/README?id=cli)

您可以将 cli 加入到环境变量，这样您就可以在任意目录、任意终端上，随时随地调用 cli，而无需通过输入 cli 绝对路径的方式来使用它。[详情](/cli/env)

## 命令说明

### logcat unicloud

查看运行到 uniCloud 日志

**用法：**

```bash
./cli logcat unicloud --project 项目名称
```

**参数：**

| 参数名称 | 描述 |
|---------|------|
| `--project` | HBuilder X 里导入的项目名称或绝对路径 |

**cli 实际使用示例：**

```bash
# Mac 电脑 使用 cli 查看 hello-uni-app-x 项目 uniCloud 日志
/Applications/HBuilderX.app/Contents/MacOS/cli logcat unicloud --project hello-uni-app-x

# Mac 电脑 --project 传递绝对路径
/Applications/HBuilderX.app/Contents/MacOS/cli logcat unicloud --project /User/apple/Desktop/hello-uni-app-x

# Windows 电脑：使用 cli 查看 hello-uni-app-x 项目 uniCloud 日志
D:\ide\HBuilderX\cli.exe logcat unicloud --project hello-uni-app-x
```
