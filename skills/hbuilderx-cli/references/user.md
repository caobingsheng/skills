# 用户操作

> HBuilderX cli 命令行工具，仅适用于 HBuilderX 3.1.5+ 版本

## 获取 HBuilderX 当前登录的用户信息

```bash
cli user info
```

## 在 HBuilderX 中，登录某个账号

如果登录成功，则返回 `0:user login:OK`

```bash
cli user login --username <用户名> --password <密码>
```

## 退出 HBuilderX 登录账号

如果退出成功，则返回 `0:user logout:OK`

```bash
cli user logout
```

## 登录参数 --global

HBuilderX 4.81+，新增登录参数--global

```bash
# --global, 布尔值，默认为 false
cli user login --global true --username <用户名> --password <密码>
```
