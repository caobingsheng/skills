# 表单验证规则详解

## 基础验证

```javascript
rules: {
  fieldName: [
    { required: true, message: "字段不能为空", trigger: ['blur', 'change'] },
    { min: 2, max: 20, message: "长度在2-20之间", trigger: 'blur' }
  ]
}
```

## 内置验证器

```javascript
rules: {
  mobile: [
    { validator: vk.pubfn.validator("mobile"), message: '手机号格式错误', trigger: 'blur' }
  ],
  email: [
    { validator: vk.pubfn.validator("email"), message: '邮箱格式错误', trigger: 'blur' }
  ],
  card: [
    { validator: vk.pubfn.validator("card"), message: '身份证格式错误', trigger: 'blur' }
  ],
  password: [
    { validator: vk.pubfn.validator("password"), message: '密码格式错误', trigger: 'blur' }
  ]
}
```

## 可用验证器类型

| 类型 | 说明 | 示例 |
|------|------|------|
| `mobile` | 手机号 | 15200000001 |
| `email` | 邮箱 | test@example.com |
| `card` | 身份证 | 330154202109301214 |
| `password` | 密码 | 6-18位字母数字下划线 |
| `username` | 用户名 | 字母开头，3-32位 |
| `mobileCode` | 短信验证码 | 6位数字 |
| `payPwd` | 支付密码 | 6位纯数字 |
| `postal` | 邮政编码 | 310000 |
| `QQ` | QQ号 | 123456789 |
| `URL` | URL地址 | https://xxx.com |
| `IP` | IP地址 | 192.168.1.1 |
| `date` | 日期 | 2024-01-01 |
| `time` | 时间 | 12:00:00 |
| `dateTime` | 日期时间 | 2024-01-01 12:00:00 |
| `english` | 英文 | hello |
| `english+number` | 英文数字 | hello123 |
| `english+number+_` | 英文数字下划线 | hello_123 |
| `chinese` | 中文 | 你好 |
| `lower` | 小写字母 | hello |
| `upper` | 大写字母 | HELLO |
| `HTML` | HTML标签 | \<div\> |

## 自定义验证

```javascript
rules: {
  password2: [
    { required: true, message: '密码不能为空', trigger: ['blur', 'change'] },
    {
      validator: (rule, value, callback) => {
        if (value === '') {
          callback(new Error('请再次输入密码'));
        } else if (value !== that.form1.data.password) {
          callback(new Error('两次输入密码不一致!'));
        } else {
          callback();
        }
      },
      trigger: ['blur', 'change']
    }
  ]
}
```

## 数字类型验证

```javascript
rules: {
  money: [
    { required: true, message: "金额不能为空", trigger: ['blur', 'change'] },
    { type: "number", message: "金额必须是数字", trigger: ['blur', 'change'] }
  ]
}
```
