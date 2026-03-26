# 事务操作

## Overview

数据库事务是一组数据库操作的集合，这些操作要么全部成功，要么全部失败回滚。事务主要用于保证数据的一致性，特别是在涉及多个相关联的数据库操作时。

## 注意事项

1. **事务自带锁**：事务操作时会对行进行锁定
2. **时间限制**：事务开始后到提交或回滚之间的时间不能超过10秒，否则报错
3. **锁定时间**：如果事务异常后没有执行回滚操作，会导致记录被锁定约1分钟
4. **表必须存在**：带有事务的API不会执行自动建表操作，必须确保表在事务开始前已存在

## 支持事务的API

1. `vk.baseDao.add`
2. `vk.baseDao.findById`
3. `vk.baseDao.updateById`
4. `vk.baseDao.deleteById`
5. `vk.baseDao.updateAndReturn`
6. `vk.baseDao.setById`

> **注意**：若使用扩展数据库，则全部数据库API都能支持事务。

## 事务隔离级别

- **读**: ReadConcern.SNAPSHOT
- **写**: WriteConcern.MAJORITY

## 转账示例

```javascript
let { data = {}, userInfo, util, originalParam } = event;
let { customUtil, config, pubFun, vk, db, _ } = util;
let res = { code: 0, msg: '' };

// 开启事务
const transaction = await vk.baseDao.startTransaction();
try {
  let dbName = "uni-id-users";
  let money = 100;

  // 查询用户001的余额
  const user001 = await vk.baseDao.findById({
    db: transaction, // 重要：本次数据库语句带上事务对象
    dbName,
    id: "001"
  });

  // 检查余额是否足够
  if (user001.account_balance < money) {
    return await vk.baseDao.rollbackTransaction({
      db: transaction,
      err: {
        code: -1,
        msg: "用户001账户余额不足",
        currentBalance: user001.account_balance
      }
    });
  }

  // 给用户001减100余额
  await vk.baseDao.updateById({
    db: transaction,
    dbName,
    id: "001",
    dataJson: {
      account_balance: _.inc(money * -1)
    }
  });

  // 给用户002加100余额
  await vk.baseDao.updateById({
    db: transaction,
    dbName,
    id: "002",
    dataJson: {
      account_balance: _.inc(money)
    }
  });

  // 提交事务
  await transaction.commit();
  console.log(`transaction succeeded`);

  return {
    code: 0,
    msg: "转账成功"
  }
} catch (err) {
  // 事务回滚
  return await vk.baseDao.rollbackTransaction({
    db: transaction,
    err
  });
}
```

## 简易模板

```javascript
// 开启事务
const transaction = await vk.baseDao.startTransaction();
try {
  // 这里写数据库操作
  // 注意：每个数据库操作都需要带上 db: transaction 参数

  // 提交事务
  await transaction.commit();
  console.log(`transaction succeeded`);
} catch (err) {
  // 事务回滚
  return await vk.baseDao.rollbackTransaction({
    db: transaction,
    err
  });
}
```

## 常见场景

### 订单创建与库存扣减

```javascript
const transaction = await vk.baseDao.startTransaction();
try {
  // 1. 查询商品信息
  const product = await vk.baseDao.findById({
    db: transaction,
    dbName: "products",
    id: productId
  });

  // 2. 检查库存
  if (product.stock < quantity) {
    return await vk.baseDao.rollbackTransaction({
      db: transaction,
      err: { code: -1, msg: "库存不足" }
    });
  }

  // 3. 扣减库存
  await vk.baseDao.updateById({
    db: transaction,
    dbName: "products",
    id: productId,
    dataJson: {
      stock: _.inc(-quantity)
    }
  });

  // 4. 创建订单
  let orderId = await vk.baseDao.add({
    db: transaction,
    dbName: "orders",
    dataJson: {
      product_id: productId,
      quantity: quantity,
      price: product.price,
      user_id: userId,
      status: "pending"
    }
  });

  // 5. 提交事务
  await transaction.commit();
  return { code: 0, msg: "下单成功", orderId };

} catch (err) {
  return await vk.baseDao.rollbackTransaction({
    db: transaction,
    err
  });
}
```

### 资金账户操作

```javascript
const transaction = await vk.baseDao.startTransaction();
try {
  const dbName = "accounts";

  // 转入操作
  await vk.baseDao.updateAndReturn({
    db: transaction,
    dbName,
    whereJson: { user_id: fromUserId },
    dataJson: { balance: _.inc(-amount) }
  });

  // 转出操作
  await vk.baseDao.updateAndReturn({
    db: transaction,
    dbName,
    whereJson: { user_id: toUserId },
    dataJson: { balance: _.inc(amount) }
  });

  // 记录交易日志
  await vk.baseDao.add({
    db: transaction,
    dbName: "transactions",
    dataJson: {
      from_user_id: fromUserId,
      to_user_id: toUserId,
      amount: amount,
      type: "transfer"
    }
  });

  await transaction.commit();
  return { code: 0, msg: "转账成功" };

} catch (err) {
  return await vk.baseDao.rollbackTransaction({
    db: transaction,
    err
  });
}
```

## 最佳实践

1. **事务粒度**：保持事务尽可能短小，减少锁定时间
2. **错误处理**：始终使用 try-catch 包裹事务操作
3. **资源释放**：确保在 catch 块中调用回滚方法
4. **表预创建**：确保事务中使用的表已存在
5. **避免嵌套**：不要在事务中嵌套另一个事务
