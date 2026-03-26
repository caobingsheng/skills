# CLI uni-app 发行 - 小程序

> HBuilderX cli 命令行工具

通过 CLI 发行到各平台小程序，支持微信、支付宝等平台。

## 命令说明

### publish mp-weixin

发行到小程序 - 微信

**用法：**

```bash
./cli publish mp-weixin --help
./cli publish mp-weixin --project xxx --name xxx --appid wxxxxxxxxxx --upload true --version 0.0.1 --privatekey /Users/xxx/Documents/private.wxxxxxxxxxx.key --description xxxxx
```

**参数：**

| 参数 | 说明 |
|-----|------|
| `--help` | 发行 cli 命令帮助 |
| `--platform` | [MP-WEIXIN] 发行平台 |
| `--project` | HBuilder X 里导入的项目绝对路径 |
| `--name` | 名称（不指定默认为项目名称） |
| `--appid` | 小程序 appid |
| `--subPackage` | 行为混合分包名称（subPackage、upload 只能填其中一） |
| `--upload` | 是否打包后上传到微信平台（subPackage、upload 只能填其中一），取值：true 或 false，默认值为 false |
| `--version` | 要上传小程序的版本号 |
| `--privatekey` | 微信代码上传密钥文件 |
| `--description` | 上传的小程序描述 |
| `--robot` | 指定微信 ci 机器人编号（取值范围：1 ~ 30），默认为 1 |

**使用示例：**

```bash
# 仅编译 uni-app 项目到微信小程序
./cli publish mp-weixin --project 项目名称

# 编译 uni-app 项目到微信小程序，并上传发行小程序到微信平台
./cli publish mp-weixin --project 项目名称 --upload true --appid 小程序appid --description 发布描述 --version 发布版本 --privatekey 小程序上传密钥文件

# 编译 uni-app 项目到微信小程序，并上传发行小程序到微信平台（指定机器人）
./cli publish mp-weixin --project 项目名称 --upload true --appid 小程序appid --description 发布描述 --version 发布版本 --privatekey 小程序上传密钥文件 --robot 2

# 编译 uni-app 项目到微信小程序，发行为混合包
./cli publish mp-weixin --project 项目名称 --subPackage 子包名称

# 编译 uni-app 项目到微信小程序，组合参数：上传 + 指定名称
./cli publish mp-weixin --project 项目名称 --name 项目名称 --upload true --appid 小程序appid --privatekey 小程序上传密钥文件
```

**注意事项：**

> `--robot` 参数，仅支持 HBuilderX 3.6.18+ 版本。同时需要升级 [微信小程序上传 CI 插件](https://ext.dcloud.net.cn/plugin?id=7199)
>
> 请正确填写 `微信小程序 appid` 和 `privatekey`
>
> 如果开启了 `IP 白名单`，请确保微信平台已配置 IP 白名单

### publish mp-alipay

发行到小程序 - 支付宝

**用法：**

```bash
./cli publish mp-alipay --help
./cli publish mp-alipay --project xxx --name xxx --appid wxxxxxxxxxx --upload true --version 0.0.1 --privatekey /Users/xxx/Documents/xxxxxxxxx.json --description xxx
```

**参数：**

| 参数 | 说明 |
|-----|------|
| `--help` | 发行 cli 命令帮助 |
| `--platform` | [MP-ALIPAY] 发行平台 |
| `--project` | HBuilder X 里导入的项目绝对路径 |
| `--name` | 名称（不指定默认为项目名称） |
| `--appid` | 小程序 appid |
| `--subPackage` | 行为混合分包名称（subPackage、upload 只能填其中一） |
| `--upload` | 是否打包后上传到支付宝平台（subPackage、upload 只能填其中一），取值：true 或 false，默认值为 false |
| `--version` | 要上传小程序的版本号 |
| `--privatekey` | 支付宝开发工具密钥文件 |
| `--description` | 上传的小程序描述 |

**使用示例：**

```bash
# 仅编译 uni-app 项目到支付宝小程序
./cli publish mp-alipay --project 项目名称

# 编译 uni-app 项目到支付宝小程序，并上传发行小程序到支付宝平台
./cli publish mp-alipay --project 项目名称 --upload true --appid 小程序appid --description 发布描述 --version 发布版本 --privatekey 支付宝开发工具密钥文件

# 编译 uni-app 项目到支付宝小程序，发行为混合包
./cli publish mp-alipay --project 项目名称 --subPackage 子包名称

# 编译 uni-app 项目到支付宝小程序，组合参数：上传 + 混合包
./cli publish mp-alipay --project 项目名称 --upload true --appid 小程序appid --privatekey 支付宝开发工具密钥文件 --subPackage 子包名称
```

# 发行到支付宝小程序并上传（HBuilderX 4.67-alpha+）
cli publish mp-alipay --project 项目名称 --upload true --appid 小程序 appid --privatekey 支付宝开发工具密钥文件
```

**注意事项：**

> HBuilderX 4.67-alpha 开始 platform 支持 mp-alipay 平台
>
> 请正确填写 `支付宝小程序 appid` 和开发工具密钥

## 小程序代码上传密钥

> HBuilderX 3.3.7+, uni-app 发行到微信小程序，支持自动上传代码到微信平台，无需再通过微信开发者工具上传发行。[详情](/Tutorial/App/uni-app-publish-mp-weixin)
>
> HBuilderX 发行微信小程序，需要提供微信小程序代码上传密钥

通过微信小程序 CI，使用上传密钥上传代码，无需打开微信开发者工具，一键完成微信小程序代码的上传、预览等操作。

### 如何获取微信小程序代码上传密钥？

打开微信公众平台 [官网](https://mp.weixin.qq.com/), 扫码登录，左侧菜单【开发 -> 开发管理】，点击 tab【开发设置】，如下图：

### 下载密钥文件：

## 支付宝开发工具密钥文件

> HBuilderX 3.8.5+, uni-app 发行到支付宝小程序，支持自动上传代码到支付宝平台，无需再通过支付宝开发者工具上传发行。
>
> HBuilderX 发行支付宝小程序，需要提供支付宝开发工具密钥文件

通过支付宝小程序 CLI，使用支付宝开发工具密钥上传代码，无需打开支付宝开发者工具，一键完成支付宝小程序代码的上传操作

### 如何获取支付宝开发工具密钥文件？

打开支付宝开放平台 [开发工具密钥](https://open.alipay.com/develop/manage/tool-key), 扫码登录，左侧菜单【开发工具密钥】, 点击，生成身份密钥，如下图：

### 下载开发工具密钥：
