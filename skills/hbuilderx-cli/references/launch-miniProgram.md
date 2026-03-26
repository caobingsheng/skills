# CLI uni-app 运行 - 小程序

> 需 HBuilderX 5.0+ 版本

您也可以通过 npm 包使用此功能：[@dcloudio/hbuilderx-cli](https://www.npmjs.com/package/@dcloudio/hbuilderx-cli)

通过 CLI 运行到各平台小程序的 uni-app 应用，支持微信、支付宝、百度、字节跳动、QQ、360、京东、快手、飞书、小红书、鸿蒙元服务、快应用等平台。

[HBuilderX CLI](/cli/README?id=cli)

## 命令说明

### launch mp-weixin

运行到微信小程序

**用法：**

```bash
./cli launch mp-weixin --help
```

**参数：**

| 参数名称 | 描述 |
|---------|------|
| `--help` | 显示 cli 命令帮助 |
| `--project` | HBuilder X 里导入的项目名称或绝对路径 |
| `--compile` | 编译模式运行（只编译代码），取值：true 或 false，默认值为 false |
| `--continue-on-error` | 编译错误后继续运行，取值：true 或 false，默认值为 false |
| `--runtime-log` | 回显运行时日志，取值：true 或 false，默认值为 false |

**使用示例：**

```bash
# 运行到微信小程序
./cli launch mp-weixin --project 项目名称

# 运行到微信小程序（编译模式）
./cli launch mp-weixin --project 项目名称 --compile true

# 运行到微信小程序（回显运行时日志）
./cli launch mp-weixin --project 项目名称 --runtime-log true

# 运行到微信小程序（编译错误后继续运行）
./cli launch mp-weixin --project 项目名称 --continue-on-error true

# 运行到微信小程序（组合参数：编译模式 + 回显运行时日志）
./cli launch mp-weixin --project 项目名称 --compile true --runtime-log true
```

### launch mp-alipay

运行到支付宝小程序

**用法：**

```bash
./cli launch mp-alipay --help
```

**参数：** 与 mp-weixin 相同

**使用示例：**

```bash
# 运行到支付宝小程序
./cli launch mp-alipay --project 项目名称

# 运行到支付宝小程序（编译模式）
./cli launch mp-alipay --project 项目名称 --compile true
```

### launch mp-baidu

运行到百度小程序

**用法：**

```bash
./cli launch mp-baidu --help
```

**参数：** 与 mp-weixin 相同

**使用示例：**

```bash
# 运行到百度小程序
./cli launch mp-baidu --project 项目名称

# 运行到百度小程序（编译模式）
./cli launch mp-baidu --project 项目名称 --compile true
```

### launch mp-toutiao

运行到抖音小程序

**用法：**

```bash
./cli launch mp-toutiao --help
```

**参数：** 与 mp-weixin 相同

**使用示例：**

```bash
# 运行到抖音小程序
./cli launch mp-toutiao --project 项目名称

# 运行到抖音小程序（编译模式）
./cli launch mp-toutiao --project 项目名称 --compile true
```

### launch mp-qq

运行到 QQ 小程序

**用法：**

```bash
./cli launch mp-qq --help
```

**参数：**

| 参数名称 | 描述 |
|---------|------|
| `--help` | 显示 cli 命令帮助 |
| `--project` | HBuilder X 里导入的项目名称或绝对路径 |
| `--compile` | 编译模式运行（只编译代码），取值：true 或 false，默认值为 false |
| `--continue-on-error` | 编译错误后继续运行，取值：true 或 false，默认值为 false |

**使用示例：**

```bash
# 运行到 QQ 小程序
./cli launch mp-qq --project 项目名称

# 运行到 QQ 小程序（编译模式）
./cli launch mp-qq --project 项目名称 --compile true
```

### launch mp-360

运行到 360 小程序

**用法：**

```bash
./cli launch mp-360 --help
```

**参数：** 与 mp-qq 相同

**使用示例：**

```bash
# 运行到 360 小程序
./cli launch mp-360 --project 项目名称
```

### launch mp-jd

运行到京东小程序

**用法：**

```bash
./cli launch mp-jd --help
```

**参数：** 与 mp-weixin 相同

**使用示例：**

```bash
# 运行到京东小程序
./cli launch mp-jd --project 项目名称
```

### launch mp-kuaishou

运行到快手小程序

**用法：**

```bash
./cli launch mp-kuaishou --help
```

**参数：** 与 mp-weixin 相同

**使用示例：**

```bash
# 运行到快手小程序
./cli launch mp-kuaishou --project 项目名称
```

### launch mp-lark

运行到飞书小程序

**用法：**

```bash
./cli launch mp-lark --help
```

**参数：** 与 mp-weixin 相同

**使用示例：**

```bash
# 运行到飞书小程序
./cli launch mp-lark --project 项目名称
```

### launch mp-xhs

运行到小红书小程序

**用法：**

```bash
./cli launch mp-xhs --help
```

**参数：** 与 mp-weixin 相同

**使用示例：**

```bash
# 运行到小红书小程序
./cli launch mp-xhs --project 项目名称
```
