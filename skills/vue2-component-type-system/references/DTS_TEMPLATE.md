# TypeScript声明文件模板

本文档提供Vue2组件TypeScript声明文件(.d.ts)的完整模板和示例。

## .d.ts文件结构模板

```typescript
/**
 * 组件类型定义
 * @description 为[组件名]组件提供完整的TypeScript类型支持
 */

import Vue from 'vue';

/**
 * 数据对象接口
 * @description 数据对象的详细说明
 */
export interface DataObjectName {
  /** 属性说明 */
  propertyName: propertyType;
}

/**
 * 组件Props接口
 * @description Props的详细说明
 */
export interface ComponentNameProps {
  /** Prop说明 */
  propName: propType;
}

/**
 * 组件Events接口
 * @description Events的详细说明
 */
export interface ComponentNameEvents {
  /** Event说明 */
  eventName: (parameter: parameterType) => void;
}

/**
 * 组件类
 * @description 组件类的详细说明
 */
declare class ComponentNameClass extends Vue {
  /** Props */
  $props: ComponentNameProps;
}

/**
 * 全局组件声明
 * @description 在Vue中全局注册组件
 */
declare module 'vue/types/vue' {
  interface VueConstructor {
    ComponentName: typeof ComponentNameClass;
  }
}

export default ComponentNameClass;
```

## 完整示例：patient-info-viewer.d.ts

```typescript
/**
 * 患者信息展示组件类型定义
 * @description 为patient-info-viewer组件提供完整的TypeScript类型支持
 * @author YourName
 * @since 1.0.0
 */

import Vue from 'vue';

/**
 * 患者信息对象接口
 * @description 包含患者的基本信息
 */
export interface PatientInfo {
  /** 患者姓名 */
  real_name: string;
  /** 性别：1-男，2-女 */
  gender: number;
  /** 年龄 */
  age?: number;
  /** 联系电话 */
  mobile?: string;
  /** 身份证号 */
  identity?: string;
  /** 既往病史 */
  medical_history?: string;
  /** 饮食习惯 */
  eating_habits?: string;
  /** 运动习惯 */
  sprot_habits?: string;
  /** 用药情况 */
  medication_situation?: string;
}

/**
 * 标签主题配置接口
 * @description 单个标签的主题配置
 */
export interface TagTheme {
  /** 标签类型：success/warning/info/danger */
  type?: string;
  /** 主题效果：plain/dark/light */
  effect?: string;
  /** 标签尺寸：medium/small/mini */
  size?: string;
}

/**
 * 组件Props接口
 * @description patient-info-viewer组件的所有props
 */
export interface PatientInfoViewerProps {
  /** 患者信息对象（必需） */
  patient: PatientInfo;
  /** 显示的字段，逗号分隔 */
  patientProps?: string;
  /** 显示模式：text/tags */
  displayMode?: string;
  /** 文本模式分隔符 */
  textModeSeparator?: string;
  /** 文本模式样式 */
  textModeStyle?: Record<string, any>;
  /** 标签模式主题配置 */
  tagsModeTheme?: TagTheme[];
  /** 字段格式化函数 */
  patientPropsFormatter?: (patient: PatientInfo, prop: string) => any;
  /** 是否显示tag弹出框 */
  showPopover?: boolean;
  /** tags模式标题 */
  tagsModeTitle?: string;
  /** 是否显示其他信息 */
  showOtherInfo?: boolean;
}

/**
 * 组件Events接口
 * @description patient-info-viewer组件的所有events
 */
export interface PatientInfoViewerEvents {
  /** 当患者信息被复制时触发 */
  copy: (text: string) => void;
  /** 当全屏对话框打开时触发 */
  fullscreen: (content: string, title: string) => void;
}

/**
 * 组件类
 * @description patient-info-viewer组件类
 */
declare class PatientInfoViewerClass extends Vue {
  /** Props */
  $props: PatientInfoViewerProps;
}

/**
 * 全局组件声明
 * @description 在Vue中全局注册PatientInfoViewer组件
 */
declare module 'vue/types/vue' {
  interface VueConstructor {
    PatientInfoViewer: typeof PatientInfoViewerClass;
  }
}

export default PatientInfoViewerClass;
```

## 类型定义模式

### 基础类型

```typescript
/** 字符串类型 */
name: string;

/** 数字类型 */
age: number;

/** 布尔类型 */
visible: boolean;

/** 可选属性 */
mobile?: string;

/** 数组类型 */
items: string[];
items: number[];
items: Array<any>;

/** 对象类型 */
config: Record<string, any>;
config: { [key: string]: any };
```

### 联合类型

```typescript
/** 联合类型 */
gender: number | string;
status: 'active' | 'inactive' | 'pending';

/** 多种类型 */
value: string | number | boolean;
```

### 函数类型

```typescript
/** 无参数无返回值 */
handler: () => void;

/** 有参数无返回值 */
onClick: (event: MouseEvent) => void;

/** 有参数有返回值 */
formatter: (value: string) => string;

/** 多参数 */
onSubmit: (data: FormData, options: Options) => Promise<Result>;

/** 可选参数 */
callback: (error?: Error, result?: any) => void;
```

### 复杂对象类型

```typescript
/** 嵌套对象 */
user: {
  name: string;
  age: number;
  address: {
    city: string;
    street: string;
  };
};

/** 对象数组 */
users: Array<{
  name: string;
  age: number;
}>;

/** 使用接口定义 */
interface User {
  name: string;
  age: number;
}
users: User[];
```

### 泛型类型

```typescript
/** 泛型数组 */
items: Array<T>;

/** 泛型对象 */
data: Record<string, T>;

/** 泛型函数 */
transform: <T>(value: T) => T;
```

## 常见Props类型定义

### 字符串Props

```typescript
export interface ComponentProps {
  /** 简单字符串 */
  title: string;

  /** 可选字符串 */
  subtitle?: string;

  /** 字符串联合类型 */
  type: 'text' | 'number' | 'date';

  /** 多行字符串 */
  content: string;
}
```

### 数字Props

```typescript
export interface ComponentProps {
  /** 数字 */
  count: number;

  /** 可选数字 */
  max?: number;

  /** 数字联合类型 */
  size: 1 | 2 | 3 | 4;
}
```

### 布尔Props

```typescript
export interface ComponentProps {
  /** 布尔值 */
  visible: boolean;

  /** 可选布尔值 */
  disabled?: boolean;
}
```

### 数组Props

```typescript
export interface ComponentProps {
  /** 字符串数组 */
  items: string[];

  /** 数字数组 */
  numbers: number[];

  /** 对象数组 */
  list: Array<{
    id: number;
    name: string;
  }>;

  /** 使用接口定义的数组 */
  users: User[];
}
```

### 对象Props

```typescript
export interface ComponentProps {
  /** 简单对象 */
  config: Record<string, any>;

  /** 具体对象 */
  user: {
    name: string;
    age: number;
  };

  /** 使用接口定义的对象 */
  data: UserData;
}
```

### 函数Props

```typescript
export interface ComponentProps {
  /** 点击事件 */
  onClick: (event: MouseEvent) => void;

  /** 变更事件 */
  onChange: (value: string) => void;

  /** 提交事件 */
  onSubmit: (data: FormData) => Promise<Result>;

  /** 格式化函数 */
  formatter: (value: any) => string;

  /** 验证函数 */
  validator: (value: any) => boolean;
}
```

## Events类型定义

### 基础Events

```typescript
export interface ComponentEvents {
  /** 无参数事件 */
  init: () => void;

  /** 单参数事件 */
  change: (value: string) => void;

  /** 多参数事件 */
  update: (id: number, data: any) => void;
}
```

### 常见Events模式

```typescript
export interface ComponentEvents {
  /** 点击事件 */
  click: (event: MouseEvent) => void;

  /** 输入事件 */
  input: (value: string) => void;

  /** 变更事件 */
  change: (value: any) => void;

  /** 提交事件 */
  submit: (data: any) => void;

  /** 取消事件 */
  cancel: () => void;

  /** 错误事件 */
  error: (error: Error) => void;

  /** 成功事件 */
  success: (result: any) => void;
}
```

## 全局声明模式

### Vue 2全局组件声明

```typescript
declare module 'vue/types/vue' {
  interface VueConstructor {
    /** 组件名称 */
    ComponentName: typeof ComponentNameClass;
  }
}
```

### Vue插件声明

```typescript
declare module 'vue/types/vue' {
  interface Vue {
    /** 插件属性 */
    $plugin: PluginType;
  }
}
```

### 全局变量声明

```typescript
declare global {
  /** 全局变量 */
  const GLOBAL_CONFIG: ConfigType;
}
```

## 索引文件模板

### components/types/index.d.ts

```typescript
/**
 * 组件类型统一导出
 * @description 集中导出所有组件的TypeScript类型定义
 * @author YourName
 * @since 1.0.0
 */

// 导出所有组件类型
export { PatientInfo, PatientInfoViewerProps, PatientInfoViewerEvents, default as PatientInfoViewer } from '../patient-info-viewer/patient-info-viewer.d.ts';
export { default as PatientSearch } from '../patient-search/patient-search.d.ts';
export { default as ProjectInfoViewer } from '../project-info-viewer/project-info-viewer.d.ts';
export { default as WmDataForm } from '../wm-data-form/wm-data-form.d.ts';

// 全局组件声明
declare module 'vue/types/vue' {
  interface VueConstructor {
    PatientInfoViewer: any;
    PatientSearch: any;
    ProjectInfoViewer: any;
    WmDataForm: any;
  }
}
```

## 最佳实践

### 1. 完整性

- 为所有props定义类型
- 为所有events定义类型
- 为复杂对象定义接口

### 2. 准确性

- 类型必须与.vue文件中的props定义一致
- 可选属性使用`?`标记
- 函数参数和返回值必须准确

### 3. 可读性

- 为每个接口和属性添加注释
- 使用有意义的类型名称
- 保持代码格式整洁

### 4. 组织性

- 相关接口放在一起
- 按照逻辑顺序排列
- 使用清晰的命名

### 5. 导出性

- 在index.d.ts中统一导出
- 使用全局声明注册组件
- 保持导出结构一致

## 常见错误

### ❌ 错误示例1：缺少注释

```typescript
export interface PatientInfo {
  real_name: string;
  gender: number;
}
```

### ✅ 正确示例1：添加注释

```typescript
/**
 * 患者信息对象接口
 * @description 包含患者的基本信息
 */
export interface PatientInfo {
  /** 患者姓名 */
  real_name: string;
  /** 性别：1-男，2-女 */
  gender: number;
}
```

### ❌ 错误示例2：类型不准确

```typescript
export interface ComponentProps {
  /** 年龄 */
  age: any;
}
```

### ✅ 正确示例2：类型准确

```typescript
export interface ComponentProps {
  /** 年龄 */
  age: number;
}
```

### ❌ 错误示例3：缺少必需标记

```typescript
export interface ComponentProps {
  /** 患者信息 */
  patient: PatientInfo;
}
```

### ✅ 正确示例3：正确标记可选

```typescript
export interface ComponentProps {
  /** 患者信息（必需） */
  patient: PatientInfo;
  /** 标题（可选） */
  title?: string;
}
```

## 检查清单

在完成.d.ts文件后，检查以下项目：

- [ ] 所有props都有类型定义
- [ ] 所有events都有类型定义
- [ ] 复杂对象都有接口定义
- [ ] 所有接口和属性都有注释
- [ ] 类型与.vue文件一致
- [ ] 可选属性使用`?`标记
- [ ] 函数类型准确
- [ ] 在index.d.ts中导出
- [ ] 全局声明正确

## 工具支持

### VSCode配置

在项目根目录创建`jsconfig.json`：

```json
{
  "compilerOptions": {
    "baseUrl": ".",
    "paths": {
      "@/*": ["*"],
      "components/*": ["components/*"]
    },
    "include": [
      "components/**/*.d.ts",
      "components/types/index.d.ts"
    ]
  },
  "include": [
    "components/**/*",
    "components/**/**/*.d.ts"
  ]
}
```

### 类型检查

使用TypeScript编译器检查类型定义：

```bash
# 安装TypeScript
npm install -g typescript

# 检查类型定义
tsc --noEmit components/**/*.d.ts
```
