# CLI uni-app 发行 - WEB

> HBuilderX cli 命令行工具

通过 CLI 发行 uni-app 项目到 H5，支持编译、上传等操作。

## 命令说明

### publish web

发行到 Web/H5

**用法：**

```bash
./cli publish web --help
./cli publish web --project xxx --webTitle xxx --ssr true --webHosting true --provider aliyun --spaceId xxx-xxx-xxx-xxx-xxx
```

**参数：**

| 参数 | 说明 |
|-----|------|
| `--help` | 发行 cli 命令帮助 |
| `--platform` | [Web] 发行平台 |
| `--project` | HBuilder X 里导入的项目绝对路径 |
| `--webTitle` | 网站标题（发行类型为 H5 时可配置此项，不指定默认为项目名称） |
| `--webDomain` | 网站域名（发行类型为 H5 时可配置此项） |
| `--ssr` | 是否 ssr 发行（项目使用 vue3 时配置此项才生效），取值：true 或 false，默认值为 false |
| `--ssrHost` | ssr 发行时，网页托管的服务商绑定多个域名情况下，需指定域名 |
| `--ssrProvider` | ssr 发行时，项目下绑定多个云服务空间时，需指定云函数上传到哪个服务商，可选值为 aliyun、alipay、tcb |
| `--webHosting` | 是否前端网页托管，取值：true 或 false，默认值为 false |
| `--provider` | 服务商代号，取值：aliyun、alipay、tcb，默认值为 aliyun |
| `--spaceId` | 云空间 id |

**使用示例：**

```bash
# 仅编译 uni-app 项目到 H5，不上传 uniCloud 前端网页托管
./cli publish web --project 项目名称

# 编译 uni-app 项目到 H5，并上传到前端网页托管
./cli publish web --project 项目名称 --webHosting true --provider aliyun --spaceId xxxxxxx

# 编译 uni-app 项目到 H5，自定义网站域名和标题
./cli publish web --project 项目名称 --webDomain 域名地址 --webTitle 网站标题

# 编译 uni-app 项目到 H5，SSR 发行
./cli publish web --project 项目名称 --ssr true

# 编译 uni-app 项目到 H5，SSR 发行并指定域名和服务商
./cli publish web --project 项目名称 --ssr true --ssrHost 域名地址 --ssrProvider aliyun

# 编译 uni-app 项目到 H5，组合参数：前端网页托管 + 自定义域名标题
./cli publish web --project 项目名称 --webHosting true --provider aliyun --spaceId xxxxxxx --webDomain 域名地址 --webTitle 网站标题

# 编译 uni-app 项目到 H5，组合参数：SSR + 前端网页托管
./cli publish web --project 项目名称 --ssr true --webHosting true --provider aliyun --spaceId xxxxxxx
```

**注意事项：**

> 使用 CLI 命令，上传文件到前端网页托管，如果云端已存在此文件，会使用本地文件覆盖云端的文件

**扩展阅读：**

- [前端网页托管功能详情](https://uniapp.dcloud.io/uniCloud/hosting)
