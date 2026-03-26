// common/auth-helper/index.js
/**
 * 认证辅助工具 - 公共模块示例
 * 
 * 使用说明：
 * 1. 在云函数中右键 -> 管理公共模块依赖 -> 添加 auth-helper
 * 2. 使用 require('auth-helper') 引入
 * 3. 调用导出的函数进行权限验证
 */

const vk = require('vk-unicloud')

/**
 * 验证用户是否已登录
 * @param {Object} userInfo - 用户信息
 * @returns {Object} 验证结果
 */
function checkLogin(userInfo) {
  if (!userInfo || !userInfo.uid) {
    return {
      success: false,
      message: '未登录',
      code: -1
    }
  }
  
  return {
    success: true,
    message: '已登录',
    code: 0,
    uid: userInfo.uid
  }
}

/**
 * 验证管理员权限
 * @param {Object} userInfo - 用户信息
 * @returns {Boolean} 是否是管理员
 */
function isAdmin(userInfo) {
  return userInfo && userInfo.role === 'admin'
}

/**
 * 验证操作权限
 * @param {Object} userInfo - 当前用户信息
 * @param {String} targetUserId - 目标用户 ID
 * @param {String} action - 操作类型 (view/edit/delete)
 * @returns {Object} 验证结果
 */
function checkPermission(userInfo, targetUserId, action = 'view') {
  // 检查登录状态
  const loginResult = checkLogin(userInfo)
  if (!loginResult.success) {
    return loginResult
  }
  
  // 管理员拥有所有权限
  if (isAdmin(userInfo)) {
    return {
      success: true,
      message: '有权限',
      code: 0
    }
  }
  
  // 普通用户只能查看和编辑自己的数据
  if (userInfo.uid !== targetUserId) {
    return {
      success: false,
      message: '无权限访问该数据',
      code: 403
    }
  }
  
  // 删除操作需要额外验证
  if (action === 'delete') {
    // 可以添加更多删除权限的验证逻辑
    return {
      success: true,
      message: '有删除权限',
      code: 0
    }
  }
  
  return {
    success: true,
    message: '有权限',
    code: 0
  }
}

/**
 * 获取用户信息（安全版本）
 * 过滤敏感字段
 * @param {Object} userInfo - 原始用户信息
 * @returns {Object} 安全的用户信息
 */
function getSafeUserInfo(userInfo) {
  if (!userInfo) {
    return null
  }
  
  const { 
    uid, 
    username, 
    nickname, 
    avatar, 
    role,
    create_time 
  } = userInfo
  
  return {
    uid,
    username,
    nickname,
    avatar,
    role,
    create_time
  }
}

/**
 * 记录操作日志
 * @param {Object} context - 云函数上下文
 * @param {String} action - 操作类型
 * @param {String} resource - 操作资源
 * @param {Object} data - 操作数据
 */
async function logOperation(context, action, resource, data) {
  try {
    const { userInfo } = context
    
    const logData = {
      user_id: userInfo?.uid || 'anonymous',
      action,
      resource,
      data,
      ip: context.CLIENTIP,
      create_time: new Date().getTime()
    }
    
    // 保存到操作日志集合
    await uniCloud.database()
      .collection('operation_logs')
      .add(logData)
      
  } catch (error) {
    console.error('记录操作日志失败:', error)
    // 不抛出错误，避免影响主流程
  }
}

module.exports = {
  checkLogin,
  isAdmin,
  checkPermission,
  getSafeUserInfo,
  logOperation
}
