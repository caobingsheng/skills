# 树状结构查询

## Overview

通过 `treeProps` 参数可以实现树状结构查询，自动将子节点合并到父节点的 `children` 字段中。

## treeProps 参数说明

| 参数名 | 类型 | 必填 | 默认值 | 说明 |
|--------|------|------|--------|------|
| id | String | 否 | `_id` | 唯一标识字段 |
| parent_id | String | 否 | `parent_id` | 父级标识字段 |
| children | String | 否 | `children` | 自定义返回的下级字段名 |
| level | Number | 否 | 10 | 查询返回的树的最大层级，最大15，最小1 |
| limit | Number | 否 | - | 每一级最大返回的数据量 |
| sortArr | Array | 否 | - | 所有子节点的排序规则 |
| whereJson | Object | 否 | - | 子节点的查询条件 |

## 基础示例

### 树状结构

```javascript
res = await vk.baseDao.selects({
  dbName: "opendb-admin-menus",
  pageIndex: 1,
  pageSize: 500,
  whereJson: {
    enable: true,
    parent_id: _.in([null, ""]),
    menu_id: _.exists(true)
  },
  sortArr: [{ name: "sort", type: "asc" }],
  treeProps: {
    id: "menu_id",
    parent_id: "parent_id",
    children: "children",
    level: 3,
    limit: 500,
    sortArr: [{ name: "sort", type: "asc" }],
    whereJson: {
      enable: true
    }
  }
});
```

## 树状结构 + or 查询条件

```javascript
let selectsRes = await vk.baseDao.selects({
  dbName: "opendb-admin-menus",
  pageIndex: 1,
  pageSize: 500,
  whereJson: {
    enable: true,
    parent_id: _.in([null, ""]),
    menu_id: _.exists(true)
  },
  sortArr: [{ name: "sort", type: "asc" }],
  treeProps: {
    id: "menu_id",
    parent_id: "parent_id",
    children: "children",
    level: 3,
    limit: 500,
    sortArr: [{ name: "sort", type: "asc" }],
    whereJson: $.or([
      {
        menu_id: _.eq("sys-user-manage")
      },
      {
        menu_id: _.exists(false)
      }
    ])
  }
});
```

## 树状结构 + and + or 查询条件

```javascript
let selectsRes = await vk.baseDao.selects({
  dbName: "opendb-admin-menus",
  pageIndex: 1,
  pageSize: 500,
  whereJson: {
    enable: true,
    parent_id: _.in([null, ""]),
    menu_id: _.exists(true)
  },
  sortArr: [{ name: "sort", type: "asc" }],
  treeProps: {
    id: "menu_id",
    parent_id: "parent_id",
    children: "children",
    level: 3,
    limit: 500,
    sortArr: [{ name: "sort", type: "asc" }],
    whereJson: $.and([
      {
        menu_id: _.eq("sys-user-manage")
      },
      $.or([
        {
          menu_id: _.eq("sys-user-manage2")
        },
        {
          menu_id: _.exists(true)
        }
      ])
    ])
  }
});
```

## 树状结构 + 连表

```javascript
res = await vk.baseDao.selects({
  dbName: "opendb-admin-menus",
  pageIndex: 1,
  pageSize: 500,
  whereJson: {
    enable: true,
    parent_id: _.in([null, ""]),
    menu_id: _.exists(true)
  },
  sortArr: [{ name: "sort", type: "asc" }],
  treeProps: {
    id: "menu_id",
    parent_id: "parent_id",
    children: "children",
    level: 3,
    limit: 500,
    sortArr: [{ name: "sort", type: "asc" }],
    whereJson: {
      enable: true
    }
  },
  foreignDB: [
    {
      dbName: "opendb-admin-roles",
      localKey: "role_id",
      foreignKey: "role_id",
      as: "role_info",
      limit: 1
    },
    {
      dbName: "uni-id-users",
      localKey: "create_user_id",
      foreignKey: "_id",
      as: "create_user_info",
      limit: 1
    }
  ]
});
```

## 树状结构 + 推广关系

```javascript
res = await vk.baseDao.selects({
  dbName: "uni-id-users",
  pageIndex: 1,
  pageSize: 1000,
  whereJson: {
    inviter_uid: _.exists(false)
  },
  treeProps: {
    id: "_id",
    parent_id: $.arrayElemAt(['$inviter_uid', 0]),
    children: "children",
    level: 2,
    limit: 1000,
    whereJson: {}
  }
});
```

## 返回数据格式示例

```json
{
  "code": 0,
  "msg": "查询成功",
  "rows": [
    {
      "_id": "menu001",
      "menu_id": "sys-user",
      "name": "用户管理",
      "sort": 1,
      "enable": true,
      "children": [
        {
          "_id": "menu001-01",
          "menu_id": "sys-user-list",
          "parent_id": "sys-user",
          "name": "用户列表",
          "sort": 1,
          "enable": true,
          "children": []
        },
        {
          "_id": "menu001-02",
          "menu_id": "sys-user-add",
          "parent_id": "sys-user",
          "name": "新增用户",
          "sort": 2,
          "enable": true,
          "children": []
        }
      ]
    },
    {
      "_id": "menu002",
      "menu_id": "sys-role",
      "name": "角色管理",
      "sort": 2,
      "enable": true,
      "children": [
        {
          "_id": "menu002-01",
          "menu_id": "sys-role-list",
          "parent_id": "sys-role",
          "name": "角色列表",
          "sort": 1,
          "enable": true,
          "children": []
        }
      ]
    }
  ],
  "total": 2
}
```

## 注意事项

1. `treeProps` 内的 `whereJson` 若需要用到 `or` 和 `and` 条件时：
   - `_.or` 需写成 `$.or`
   - `_.and` 需写成 `$.and`
   - 不支持流式语法，只支持对象语法

2. level 最大值为15，最小值为1

3. foreignDB 属性只需写在主表下，无需写在 `treeProps` 内，子表会继承主表的 `foreignDB` 属性
