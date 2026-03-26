# 前端网页托管

前端网页托管基于 uniCloud 的能力，为开发者的 html 网页提供更快速、更安全、更省心、更便宜的网站发布。

- **更快速**：不经过 web server，页面和资源直接上 cdn，就近访问，速度更快。
- **更安全**：不存在传统服务器各种操作系统、web server 的漏洞，不用天天想着打补丁。不怕 DDoS 攻击，永远打不垮的服务。
- **更省心**：无需再购买虚拟机、安装操作系统、配置 web 服务器、处理负载均衡、处理大并发、处理 DDoS 攻击......您什么都不用管，只需上传您写的页面文件
- **更便宜**：uniCloud 由 DCloud 联合阿里云和腾讯云推出，其中阿里云版本完全免费。

[前端网页托管功能详情](https://uniapp.dcloud.io/uniCloud/hosting)

### CLI 注意事项

- HBuilderX 3.4.18 及之前的版本仅支持阿里云；HBuilderX 3.5.1-alpha 起，支持腾讯云。
- 所有操作，均需要 HBuilderX 处于登录状态
- uniCloud 前端网页托管功能，需要处于开通状态。[如何开通前端网页托管？](https://uniapp.dcloud.io/uniCloud/hosting?id=%e5%bc%80%e9%80%9a)

### 上传项目或文件

```bash
cli hosting deploy [--prj 项目名称] --space 云空间名称或 id --provider 服务商代号 [--source 指定项目下源目录] [--prefix 指定云空间目录前缀]
```

**说明:**

- 当指定了项目名称 (--prj), --source 参数不填则从项目的根目录上传所有内容
- 如果没有指定项目名称，则--source 必须为文件或目录的全路径

**示例**

```bash
# 上传特定路径文件到云端，并重命名
cli hosting deploy --provider aliyun --space spacename --source /a.txt --prefix /b.txt

# 上传特定路径文件到云端特定目录下 (比如 static 目录)
cli hosting deploy --provider aliyun --space spacename --source /a.txt --prefix /static/

# 上传目录到云端根目录
cli hosting deploy --provider aliyun --space spacename --source /Users/hx/test/ --prefix /

# 上传项目 (比如 test-project) 到云端根目录
cli hosting deploy --provider aliyun --space spacename --prj test-project --prefix /
```

### 列举云空间下的文件及文件夹

```bash
cli hosting list --space 云空间名称或 id --provider 服务商代号 [--prefix 指定云空间目录前缀]
```

**示例**

```bash
# 列表根目录下的文件
cli hosting list --provider aliyun --space spacename

# 列表指定目录下的文件
cli hosting list --provider aliyun --space spacename --prefix /img/
```

### 删除云空间下的文件及文件夹

```bash
cli hosting delete --space 云空间名称或 id --provider 服务商代号 --path 云空间文件或文件夹路径，文件夹须以/结尾
```

**示例**

```bash
# 删除文件夹
cli hosting delete --provider aliyun --space spacename --path /img/

# 删除指定文件
cli hosting delete --provider aliyun --space spacename --path /img/1.png
```
