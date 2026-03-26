// 使用公共模块的云函数示例
// admin/patient/sys/getList.js

'use strict';

const dbUtils = require('db-utils')
const authHelper = require('auth-helper')

/**
 * 获取患者列表
 * @param {Object} event - 事件对象
 * @param {Object} event.formData - 查询表单数据
 * @param {Array} event.columns - 查询列定义
 * @param {Number} event.pageIndex - 页码
 * @param {Number} event.pageSize - 每页数量
 * @param {Object} context - 云函数上下文
 * @returns {Promise<Object>} 患者列表数据
 */
exports.main = async (event, context) => {
  const vk = require('vk-unicloud')
  
  try {
    // 1. 验证登录状态
    const loginResult = authHelper.checkLogin(context.userInfo)
    if (!loginResult.success) {
      return {
        code: loginResult.code,
        msg: loginResult.message
      }
    }
    
    // 2. 解构参数
    const { formData = {}, columns = [], pageIndex = 1, pageSize = 10 } = event
    
    // 3. 标准化分页参数
    const pagination = dbUtils.normalizePagination(pageIndex, pageSize)
    
    // 4. 构建查询条件
    const whereJson = dbUtils.buildWhereJson(formData, columns)
    
    // 5. 查询数据库
    const result = await vk.baseDao.getTableData({
      data: {
        tableName: 'wm-patients',
        formData: whereJson,
        pageIndex: pagination.pageIndex,
        pageSize: pagination.pageSize,
        orderBy: [{ key: 'create_time', order: 'desc' }]
      }
    })
    
    // 6. 格式化数据
    const formattedRows = dbUtils.formatRows(result.rows || [])
    
    // 7. 返回结果
    return {
      code: 0,
      msg: 'success',
      rows: formattedRows,
      total: result.total || 0,
      pageIndex: pagination.pageIndex,
      pageSize: pagination.pageSize
    }
    
  } catch (error) {
    console.error('获取患者列表失败:', error)
    
    return {
      code: 500,
      msg: '服务器错误：' + error.message
    }
  }
}
