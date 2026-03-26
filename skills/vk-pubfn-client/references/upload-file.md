# 文件上传完整指南

## 目录

- [接口说明](#接口说明)
- [请求参数](#请求参数)
- [返回值](#返回值)
- [基本用法](#基本用法)
- [云存储配置](#云存储配置)
- [高级用法](#高级用法)
- [小程序域名白名单](#小程序域名白名单)
- [常见问题](#常见问题)

## 接口说明

### vk.uploadFile

前端文件上传接口,支持多种云存储方式。

## 请求参数

| 参数 | 类型 | 必填 | 说明 |
| --- | --- | --- | --- |
| title | String | 否 | 上传时的loading提示语 |
| file | File | 否 | 要上传的文件对象,file与filePath二选一 |
| filePath | String | 否 | 要上传的文件路径,file与filePath二选一 |
| suffix | String | 否 | 指定上传后的文件后缀 |
| provider | String | 否 | 云存储供应商:unicloud/extStorage/aliyun |
| cloudPath | String | 否 | 指定上传后的云端文件路径 |
| cloudDirectory | String | 否 | 指定上传后的云端目录 |
| needSave | Boolean | 否 | 是否需要将图片信息保存到admin素材库 |
| category_id | String | 否 | 素材库分类id |
| uniCloud | cloud | 否 | 上传到其他空间时使用 |
| env | String | 否 | 上传到其他空间时使用 |
| cloudPathAsRealPath | Boolean | 否 | 阿里云目录支持(HBX3.8.5+) |
| cloudPathRemoveChinese | Boolean | 否 | 删除文件名中的中文 |
| onUploadProgress | Function | 否 | 上传进度回调 |
| success | Function | 是 | 上传成功回调 |
| fail | Function | 否 | 上传失败回调 |
| complete | Function | 否 | 完成回调(无论成功失败) |

## 返回值

### vk-unicloud 核心库 ≥ 2.17.0

| 参数名 | 类型 | 说明 |
| --- | --- | --- |
| provider | string | 本次上传的存储供应商 |
| filePath | string | 本地文件路径 |
| cloudPath | string | 云端文件路径 |
| fileID | string | 云端文件ID |
| fileURL | string | 云端文件URL |
| url | string | 云端文件URL(与fileURL一致) |
| extendInfo | object | 扩展存储额外返回的信息 |

**extendInfo** (仅扩展存储,≥2.18.7):

| 参数名 | 类型 | 说明 |
| --- | --- | --- |
| key | string | 等于cloudPath |
| hash | string | 文件的hash值 |
| name | string | 上传前的文件名 |
| size | number | 文件大小(字节) |
| width | number | 图片或视频的宽度 |
| height | number | 图片或视频的高度 |
| format | string | 文件格式 |

### vk-unicloud 核心库 < 2.17.0

| 参数名 | 类型 | 说明 |
| --- | --- | --- |
| fileID | string | 云端文件URL |
| url | string | 云端文件URL(与fileID一致) |

## 基本用法

### 上传图片

```javascript
// 选择图片
uni.chooseImage({
  count: 1,
  sizeType: ['compressed'],
  success: (res) => {
    // 文件上传
    vk.uploadFile({
      title: "上传中...",
      file: res.tempFiles[0],
      success: (res) => {
        // 上传成功
        let url = res.url;
        console.log('url: ', url)
      },
      fail: (err) => {
        // 上传失败
        console.error('上传失败:', err);
      }
    });
  }
});
```

### 上传并保存到素材库

```javascript
uni.chooseImage({
  count: 1,
  sizeType: ['compressed'],
  success: (res) => {
    vk.uploadFile({
      title: "上传中...",
      file: res.tempFiles[0],
      needSave: true, // 保存到admin素材库
      success: (res) => {
        console.log('上传成功:', res.url);
      }
    });
  }
});
```

### 上传到指定分类

```javascript
uni.chooseImage({
  count: 1,
  sizeType: ['compressed'],
  success: (res) => {
    vk.uploadFile({
      title: "上传中...",
      file: res.tempFiles[0],
      needSave: true,
      category_id: "001", // 素材库分类ID
      success: (res) => {
        console.log('上传成功:', res.url);
      }
    });
  }
});
```

### 自定义云端路径

```javascript
uni.chooseImage({
  count: 1,
  sizeType: ['compressed'],
  success: (res) => {
    vk.uploadFile({
      title: "上传中...",
      file: res.tempFiles[0],
      cloudPath: "myPath/aa.png", // 自定义路径(需包含文件后缀名)
      success: (res) => {
        console.log('上传成功:', res.url);
      }
    });
  }
});
```

### 监听上传进度

```javascript
uni.chooseImage({
  count: 1,
  sizeType: ['compressed'],
  success: (res) => {
    vk.uploadFile({
      title: "上传中...",
      file: res.tempFiles[0],
      onUploadProgress: (res) => {
        let { progress } = res;
        console.log(`当前进度:${progress}%`);
      },
      success: (res) => {
        console.log('上传成功:', res.url);
      }
    });
  }
});
```

## 云存储配置

### 默认上传至 unicloud 空间内置存储

在 `app.config.js` 中配置:

```javascript
service: {
  cloudStorage: {
    defaultProvider: "unicloud", // 默认值
  }
}
```

### 默认上传至扩展存储

**版本要求**:
- vk-unicloud 核心库 ≥ 2.17.0
- HBuilderX ≥ 3.99

**配置步骤**:

1. 修改 `cloudfunctions/common/uni-config-center/vk-unicloud/index.js`:

```javascript
"service": {
  "cloudStorage": {
    "defaultProvider": "extStorage",
    "extStorage": {
      "provider": "qiniu", // qiniu: 扩展存储-七牛云
      "domain": "", // 自定义域名(如: cdn.example.com)
      "bucketName": "", // 存储空间名称
      "bucketSecret": "", // 存储空间密钥
      "endpoint": {
        "upload": "", // 上传接口的代理地址(国内上传无需填写)
      }
    }
  }
}
```

2. 修改项目根目录的 `app.config.js`:

```javascript
service: {
  cloudStorage: {
    defaultProvider: "extStorage",
    extStorage: {
      provider: "qiniu",
      dirname: "public", // 根目录名称
      authAction: "user/pub/getUploadFileOptionsForExtStorage",
      domain: "", // 自定义域名
      groupUserId: false, // 是否按用户id分组储存
    }
  }
}
```

3. 复制云函数 `user/pub/getUploadFileOptionsForExtStorage` 到项目

### 默认上传至阿里云 OSS

在 `app.config.js` 中配置:

```javascript
service: {
  cloudStorage: {
    defaultProvider: "aliyun",
    aliyun: {
      uploadData: {
        OSSAccessKeyId: "",
        policy: "",
        signature: "",
      },
      action: "https://xxx.oss-cn-hangzhou.aliyuncs.com",
      dirname: "public",
      host: "https://xxx.xxx.com",
      groupUserId: false,
    }
  }
}
```

**阿里云 OSS 参数生成工具**:
- 下载: https://gitee.com/vk-uni/oss-h5-upload-js-direct.git
- 运行 `index.html` 上传一张图片即可生成配置参数

**OSS 跨域配置**:

允许 Headers:
```
*
access-control-allow-origin
```

暴露 Headers:
```
Etag
x-oss-request-id
```

## 高级用法

### 上传到其他空间

```javascript
vk.uploadFile({
  title: "上传中...",
  file: file,
  uniCloud: {
    provider: "aliyun", // 或 "tencent"
    spaceId: "mp-xxxxx",
    clientSecret: "xxxxx",
    endpoint: "https://xxx.aliyuncs.com"
  },
  success: (res) => {
    console.log('上传成功:', res.url);
  }
});
```

### 删除文件名中的中文

```javascript
vk.uploadFile({
  title: "上传中...",
  file: file,
  cloudPathRemoveChinese: true, // 删除中文
  success: (res) => {
    console.log('上传成功:', res.url);
  }
});
```

## 小程序域名白名单

### 内置存储域名

详见: [小程序域名白名单配置](https://vkdoc.fsq.pub/client/publish/mp-weixin.html#配置小程序域名白名单)

### 扩展存储域名

**上传域名**:
```
https://upload.qiniup.com
```

**下载域名**:
下载域名是你开通扩展存储时绑定的自定义域名

## 常见问题

### Q: 小程序本地可以上传,体验版小程序无法上传?

**A**: 通常都是因为域名白名单没有添加导致的。检查上传域名是否已加入到小程序的 uploadFile 合法域名列表中。

### Q: 上传扩展存储报错,云函数 user/pub/getUploadFileOptionsForExtStorage 不存在?

**A**: 下载最新框架项目,去复制这个云函数到你的项目中。扩展存储上传需要依赖这个云函数来获取上传token。

### Q: 我之前用的 unicloud 内置存储,现在想换成扩展存储,我的 vk.uploadFile 代码是否要修改?

**A**: 不需要。只需要修改配置即可,将 `defaultProvider` 设置成 `extStorage` 则默认 `vk.uploadFile` 都会上传到扩展存储。

### Q: 如何切换不同的云存储?

**A**: 在 `app.config.js` 中修改 `service.cloudStorage.defaultProvider` 的值:
- `"unicloud"` - 空间内置存储
- `"extStorage"` - 扩展存储
- `"aliyun"` - 阿里云 OSS

### Q: 如何获取上传进度?

**A**: 使用 `onUploadProgress` 回调:

```javascript
vk.uploadFile({
  file: file,
  onUploadProgress: (res) => {
    let { progress } = res;
    console.log(`当前进度:${progress}%`);
  },
  success: (res) => {
    console.log('上传完成');
  }
});
```
