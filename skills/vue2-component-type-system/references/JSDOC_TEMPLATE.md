# JSDoc注释模板

本文档提供Vue2组件JSDoc注释的完整模板和示例。

## 组件级注释模板

在组件定义前添加组件级JSDoc注释：

```javascript
/**
 * 组件中文名称
 * @component ComponentName
 * @description 组件的详细描述，说明组件的用途和主要功能
 * @author [作者名字]
 * @since 1.0.0
 * @see {@link [相对路径到README.md] 完整使用指南}
 * @example
 * <component-name
 *   :prop1="value1"
 *   :prop2="value2"
 *   @event1="handler1" />
 */
export default {
    name: 'ComponentName',
    props: { /* ... */ }
}
```

### 实际示例

```javascript
/**
 * 患者信息展示组件
 * @component PatientInfo
 * @description 灵活的患者信息展示组件，支持多种显示模式和信息格式化
 * @author YourName
 * @since 1.0.0
 * @see {@link ./README.md 完整使用指南}
 * @example
 * <patient-info-viewer
 *   :patient="patientData"
 *   :patient-props="'real_name,gender,age'"
 *   display-mode="tags"
 *   :show-popover="true" />
 */
export default {
    name: 'PatientInfo',
    props: { /* ... */ }
}
```

## Prop级注释模板

### 基础类型prop

```javascript
/**
 * 属性名称
 * @description 属性的详细描述
 * @type {string}
 * @default '默认值'
 * @example '示例值'
 * @tutorial [使用指南](./README.md#相关章节)
 */
propName: {
    type: String,
    default: '默认值'
}
```

### 对象类型prop

```javascript
/**
 * 对象属性名称
 * @description 对象的详细描述
 * @type {Object}
 * @required
 * @property {string} name - 名称
 * @property {number} value - 数值
 * @property {boolean} flag - 标志
 * @example { name: '示例', value: 100, flag: true }
 * @tutorial [使用指南](./README.md#相关章节)
 */
objectProp: {
    type: Object,
    required: true
}
```

### 数组类型prop

```javascript
/**
 * 数组属性名称
 * @description 数组的详细描述
 * @type {Array}
 * @default []
 * @example ['item1', 'item2']
 * @tutorial [使用指南](./README.md#相关章节)
 */
arrayProp: {
    type: Array,
    default: () => []
}
```

### 函数类型prop

```javascript
/**
 * 函数属性名称
 * @description 函数的详细描述
 * @type {Function}
 * @param {Type1} param1 - 参数1说明
 * @param {Type2} param2 - 参数2说明
 * @returns {ReturnType} 返回值说明
 * @example (value) => value * 2
 * @tutorial [使用指南](./README.md#相关章节)
 */
functionProp: {
    type: Function,
    default: null
}
```

## 完整示例：patient-info-viewer组件

```javascript
/**
 * 患者信息展示组件
 * @component PatientInfo
 * @description 灵活的患者信息展示组件，支持多种显示模式和信息格式化
 * @author YourName
 * @since 1.0.0
 * @see {@link ./README.md 完整使用指南}
 * @example
 * <patient-info-viewer
 *   :patient="patientData"
 *   :patient-props="'real_name,gender,age'"
 *   display-mode="tags"
 *   :show-popover="true" />
 */
export default {
    name: 'PatientInfo',
    props: {
        /**
         * 患者信息对象
         * @description 包含患者的基本信息，如姓名、性别、年龄等
         * @type {Object}
         * @required
         * @property {string} real_name - 患者姓名
         * @property {number} gender - 性别：1-男，2-女
         * @property {number} age - 年龄
         * @property {string} mobile - 联系电话
         * @property {string} identity - 身份证号
         * @property {string} medical_history - 既往病史
         * @property {string} eating_habits - 饮食习惯
         * @property {string} sprot_habits - 运动习惯
         * @property {string} medication_situation - 用药情况
         * @example { real_name: '张三', gender: 1, age: 30, mobile: '13800138000' }
         * @tutorial [基本用法](./README.md#基本用法)
         */
        patient: {
            type: Object,
            required: true
        },

        /**
         * 显示的字段列表
         * @description 逗号分隔的字段名，控制显示哪些患者信息
         * @type {string}
         * @default 'real_name,gender,age,mobile,identity'
         * @example 'real_name,gender,age'
         * @tutorial [字段配置](./README.md#字段配置)
         */
        patientProps: {
            type: String,
            default: 'real_name,gender,age,mobile,identity'
        },

        /**
         * 显示模式
         * @description 控制组件的显示模式
         * @type {string}
         * @default 'text'
         * @example 'tags'
         * @tutorial [显示模式](./README.md#显示模式)
         */
        displayMode: {
            type: String,
            default: 'text'
        },

        /**
         * 文本模式分隔符
         * @description 文本模式下字段之间的分隔符
         * @type {string}
         * @default ' , '
         * @example ' | '
         */
        textModeSeparator: {
            type: String,
            default: ' , '
        },

        /**
         * 文本模式样式
         * @description 文本模式下的自定义样式对象
         * @type {Object}
         * @default {}
         * @example { fontSize: '14px', color: '#333' }
         */
        textModeStyle: {
            type: Object,
            default: () => ({})
        },

        /**
         * 标签模式主题配置
         * @description 标签模式下的主题数组，包含type、effect、size等属性
         * @type {Array}
         * @default 15种默认主题
         * @example [{ type: 'success', effect: 'dark', size: 'medium' }]
         * @tutorial [自定义主题](./README.md#自定义主题)
         */
        tagsModeTheme: {
            type: Array,
            default: () => [
                { type: 'success', effect: 'dark', size: 'medium' },
                { type: 'warning', effect: 'plain', size: 'small' },
                // ... 更多主题
            ]
        },

        /**
         * 字段格式化函数
         * @description 自定义字段值的格式化函数
         * @type {Function}
         * @param {Object} patient - 患者信息对象
         * @param {string} prop - 属性名
         * @returns {any} 格式化后的值
         * @example (patient, prop) => prop === 'gender' ? (patient.gender === 1 ? '男' : '女') : patient[prop]
         * @tutorial [自定义格式化](./README.md#自定义格式化)
         */
        patientPropsFormatter: {
            type: Function,
            default: null
        },

        /**
         * 是否显示tag弹出框
         * @description 控制标签模式下是否显示弹出框
         * @type {boolean}
         * @default false
         * @example true
         */
        showPopover: {
            type: Boolean,
            default: false
        },

        /**
         * tags模式标题
         * @description 标签模式下显示的标题
         * @type {string}
         * @default ''
         * @example '患者信息'
         */
        tagsModeTitle: {
            type: String,
            default: ''
        },

        /**
         * 是否显示其他信息
         * @description 控制是否显示病史、习惯等其他信息
         * @type {boolean}
         * @default false
         * @example true
         * @tutorial [其他信息](./README.md#其他信息)
         */
        showOtherInfo: {
            type: Boolean,
            default: false
        }
    }
}
```

## JSDoc标签说明

### 常用标签

| 标签 | 用途 | 示例 |
|------|------|------|
| `@component` | 组件名称 | `@component PatientInfo` |
| `@description` | 详细描述 | `@description 患者信息展示组件` |
| `@type` | 数据类型 | `@type {Object}` |
| `@required` | 必需属性 | `@required` |
| `@optional` | 可选属性 | `@optional` |
| `@default` | 默认值 | `@default 'text'` |
| `@example` | 示例值 | `@example { name: '张三' }` |
| `@property` | 对象属性 | `@property {string} name - 姓名` |
| `@param` | 函数参数 | `@param {string} name - 姓名` |
| `@returns` | 返回值 | `@returns {string} 格式化后的值` |
| `@tutorial` | 链接教程 | `@tutorial [使用指南](./README.md)` |
| `@see` | 参考链接 | `@see {@link ./README.md}` |
| `@since` | 版本信息 | `@since 1.0.0` |
| `@deprecated` | 废弃标记 | `@deprecated 请使用新方法` |
| `@author` | 作者 | `@author 张三` |

### 类型标注

```javascript
// 基础类型
@type {string}
@type {number}
@type {boolean}
@type {Object}
@type {Array}
@type {Function}

// 联合类型
@type {string|number}

// 对象类型
@type {Object}
@property {string} name - 名称
@property {number} age - 年龄

// 数组类型
@type {Array<string>}
@type {number[]}

// 函数类型
@type {Function}
@param {string} name - 参数名
@returns {boolean} 返回值
```

## 最佳实践

### 1. 完整性

每个prop都必须有JSDoc注释，包括：
- 描述（@description）
- 类型（@type）
- 默认值（@default）
- 示例（@example）
- 链接（@tutorial）

### 2. 一致性

- 使用统一的注释格式
- 使用统一的标签顺序
- 使用统一的示例风格

### 3. 准确性

- 类型必须与实际代码一致
- 默认值必须与实际代码一致
- 示例必须真实可用

### 4. 链接性

- 使用@tutorial链接到README.md
- 使用@see链接到相关文档
- 保持链接有效性

### 5. 可读性

- 描述清晰简洁
- 示例真实有用
- 避免冗余信息

## 常见错误

### ❌ 错误示例1：缺少注释

```javascript
props: {
    patient: {
        type: Object,
        required: true
    }
}
```

### ✅ 正确示例1：完整注释

```javascript
props: {
    /**
     * 患者信息对象
     * @description 包含患者的基本信息
     * @type {Object}
     * @required
     * @example { real_name: '张三', gender: 1 }
     */
    patient: {
        type: Object,
        required: true
    }
}
```

### ❌ 错误示例2：类型不准确

```javascript
/**
 * @type {any}
 */
value: {
    type: String
}
```

### ✅ 正确示例2：类型准确

```javascript
/**
 * @type {string}
 */
value: {
    type: String
}
```

### ❌ 错误示例3：缺少示例

```javascript
/**
 * @description 患者信息
 * @type {Object}
 */
patient: {
    type: Object,
    required: true
}
```

### ✅ 正确示例3：包含示例

```javascript
/**
 * 患者信息对象
 * @description 包含患者的基本信息
 * @type {Object}
 * @required
 * @example { real_name: '张三', gender: 1, age: 30 }
 */
patient: {
    type: Object,
    required: true
}
```

## 检查清单

在完成JSDoc注释后，检查以下项目：

- [ ] 每个prop都有JSDoc注释
- [ ] 组件有组件级JSDoc注释
- [ ] 所有@type与实际代码一致
- [ ] 所有@default与实际代码一致
- [ ] 所有@example真实可用
- [ ] 所有@tutorial链接有效
- [ ] 描述清晰简洁
- [ ] 格式统一一致
