// common/db-utils/index.js
/**
 * 数据库工具函数 - 公共模块示例
 * 
 * 使用说明：
 * 1. 在云函数中右键 -> 管理公共模块依赖 -> 添加 db-utils
 * 2. 使用 require('db-utils') 引入
 * 3. 调用导出的函数
 */

const vk = require('vk-unicloud')

/**
 * 格式化查询结果
 * @param {Array} rows - 原始数据
 * @returns {Array} 格式化后的数据
 */
function formatRows(rows) {
  if (!rows || !Array.isArray(rows)) {
    return []
  }
  
  return rows.map(row => {
    // 格式化日期字段
    if (row.create_time) {
      row.create_time = new Date(row.create_time).toLocaleString('zh-CN')
    }
    if (row.update_time) {
      row.update_time = new Date(row.update_time).toLocaleString('zh-CN')
    }
    return row
  })
}

/**
 * 验证用户权限
 * @param {Object} userInfo - 用户信息
 * @param {String} targetUserId - 目标用户 ID
 * @returns {Boolean} 是否有权限
 */
function hasPermission(userInfo, targetUserId) {
  if (!userInfo) {
    return false
  }
  
  // 管理员拥有所有权限
  if (userInfo.role === 'admin') {
    return true
  }
  
  // 普通用户只能操作自己的数据
  return userInfo.uid === targetUserId
}

/**
 * 处理分页参数
 * @param {Number} pageIndex - 页码
 * @param {Number} pageSize - 每页数量
 * @returns {Object} 标准化的分页参数
 */
function normalizePagination(pageIndex, pageSize) {
  const page = Math.max(1, parseInt(pageIndex) || 1)
  const size = Math.min(100, Math.max(1, parseInt(pageSize) || 10))
  
  return {
    pageIndex: page,
    pageSize: size
  }
}

/**
 * 构建查询条件
 * @param {Object} formData - 表单数据
 * @param {Array} columns - 列定义
 * @returns {Object} 查询条件对象
 */
function buildWhereJson(formData, columns) {
  if (!formData || !columns) {
    return {}
  }
  
  const whereJson = {}
  
  columns.forEach(column => {
    const { key, mode } = column
    const value = formData[key]
    
    if (value === undefined || value === null || value === '') {
      return
    }
    
    // 根据 mode 构建不同的查询条件
    switch (mode) {
      case '=':
        whereJson[key] = value
        break
      case '%%':
        whereJson[key] = new RegExp(value, 'i')
        break
      case '[]':
        if (Array.isArray(value) && value.length === 2) {
          whereJson[key] = {
            $gte: value[0],
            $lte: value[1]
          }
        }
        break
      default:
        whereJson[key] = value
    }
  })
  
  return whereJson
}

module.exports = {
  formatRows,
  hasPermission,
  normalizePagination,
  buildWhereJson
}
