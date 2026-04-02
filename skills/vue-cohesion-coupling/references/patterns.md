# Vue高内聚低耦合设计模式

## 一、高内聚设计模式

### 1.1 单一职责原则（Single Responsibility Principle）

**定义**：每个组件只负责一个明确的功能或任务。

**实现要点**：
- 组件应该只关注一个业务领域
- 避免在组件中混合多个不相关的功能
- 一个组件应该只有一个改变的理由

**示例场景**：
- ✅ 正确：`UserAvatar.vue` 只负责显示用户头像
- ❌ 错误：`UserComponent.vue` 同时包含头像、用户列表、用户编辑表单

### 1.2 封装内部状态

**定义**：将组件的内部状态和逻辑封装起来，不暴露不必要的细节给外部。

**实现要点**：
- 使用 `data` 管理组件私有状态
- 使用 `computed` 计算派生状态
- 使用 `methods` 封装组件内部逻辑
- 避免直接从外部修改组件内部状态

**最佳实践**：
```javascript
// ✅ 正确：封装内部状态
export default {
  data() {
    return {
      // 私有状态
      internalState: {
        isLoading: false,
        formData: {}
      }
    }
  },
  methods: {
    // 封装内部方法
    async submitForm() {
      this.internalState.isLoading = true;
      // 提交逻辑
      this.$emit('submit', this.internalState.formData);
      this.internalState.isLoading = false;
    }
  }
}
```

### 1.3 明确的接口设计

**定义**：组件应该提供清晰的接口（props和事件）来与外部交互。

**Props设计原则**：
- 使用 `props` 接收父组件传递的数据
- 明确指定 `type`、`required`、`default`
- 使用 `validator` 进行复杂验证

**Events设计原则**：
- 使用 `$emit` 向父组件传递事件
- 事件名使用 kebab-case
- 事件应该描述"发生了什么"，而不是"如何处理"

**示例**：
```javascript
export default {
  props: {
    // 明确的props定义
    userId: {
      type: String,
      required: true,
      validator: (value) => value.length > 0
    },
    userName: {
      type: String,
      default: 'Anonymous'
    }
  },
  methods: {
    handleClick() {
      // 明确的事件命名
      this.$emit('user-clicked', {
        id: this.userId,
        name: this.userName,
        timestamp: Date.now()
      });
    }
  }
}
```

## 二、低耦合设计模式

### 2.1 Props向下传递，Events向上传递

**核心原则**：
- 父组件通过 `props` 向子组件传递数据
- 子组件通过 `$emit` 向父组件传递事件
- 避免子组件直接访问或修改父组件的状态

**通信流程**：
```
父组件
  ↓ props
子组件
  ↑ $emit
父组件
```

**示例**：
```javascript
// 父组件 ParentComponent.vue
<template>
  <ChildComponent
    :user-data="userData"
    @user-updated="handleUserUpdate"
  />
</template>

// 子组件 ChildComponent.vue
<template>
  <div @click="handleClick">{{ userData.name }}</div>
</template>

<script>
export default {
  props: ['userData'],
  methods: {
    handleClick() {
      // 通过事件通知父组件，而不是直接修改
      this.$emit('user-updated', { ...this.userData, active: true });
    }
  }
}
</script>
```

### 2.2 Vuex全局状态管理

**使用场景**：
- 多个组件需要共享状态
- 跨层级组件通信
- 复杂的状态逻辑

**实现要点**：
- 将共享状态提取到 Vuex store
- 使用 `mapState`、`mapGetters`、`mapActions` 简化使用
- 遵循单向数据流原则

**示例结构**：
```javascript
// store/modules/user.js
export default {
  namespaced: true,
  state: {
    currentUser: null,
    userList: []
  },
  getters: {
    activeUsers: (state) => state.userList.filter(u => u.active)
  },
  mutations: {
    SET_CURRENT_USER(state, user) {
      state.currentUser = user;
    }
  },
  actions: {
    async fetchUser({ commit }, userId) {
      const user = await api.getUser(userId);
      commit('SET_CURRENT_USER', user);
    }
  }
}
```

### 2.3 依赖注入模式

**使用场景**：
- 深层嵌套组件需要访问祖先组件的数据
- 跨多层级组件通信
- 避免props逐层传递（props drilling）

**实现方式**：
```javascript
// 祖先组件
export default {
  provide() {
    return {
      theme: this.theme,
      updateTheme: this.updateTheme
    }
  },
  data() {
    return {
      theme: 'light'
    }
  },
  methods: {
    updateTheme(newTheme) {
      this.theme = newTheme;
    }
  }
}

// 后代组件
export default {
  inject: ['theme', 'updateTheme'],
  methods: {
    changeTheme() {
      this.updateTheme('dark');
    }
  }
}
```

### 2.4 插槽（Slots）解耦

**使用场景**：
- 父组件需要自定义子组件的部分内容
- 组件需要提供灵活的内容分发

**示例**：
```javascript
// 基础组件 BaseCard.vue
<template>
  <div class="card">
    <div class="card-header">
      <slot name="header">
        <h3>默认标题</h3>
      </slot>
    </div>
    <div class="card-body">
      <slot></slot>
    </div>
    <div class="card-footer">
      <slot name="footer"></slot>
    </div>
  </div>
</template>

// 使用组件
<base-card>
  <template #header>
    <h2>自定义标题</h2>
  </template>
  <p>卡片内容</p>
  <template #footer>
    <button>操作按钮</button>
  </template>
</base-card>
```

## 三、组件拆分策略

### 3.1 按功能拆分

**原则**：将复杂的组件按功能模块拆分成多个小组件。

**示例**：
```
UserManagement.vue (复杂组件)
├── UserList.vue (用户列表)
├── UserFilter.vue (筛选器)
├── UserPagination.vue (分页)
└── UserDetail.vue (用户详情)
```

### 3.2 按层级拆分

**原则**：按照UI层级结构拆分组件。

**示例**：
```
App.vue
├── Header.vue
│   ├── Logo.vue
│   └── Navigation.vue
├── MainContent.vue
│   ├── Sidebar.vue
│   └── ContentArea.vue
└── Footer.vue
```

### 3.3 容器组件与展示组件分离

**容器组件（Container Components）**：
- 负责数据获取和状态管理
- 包含业务逻辑
- 不关注UI细节

**展示组件（Presentational Components）**：
- 负责UI渲染
- 通过props接收数据
- 通过events触发操作

**示例**：
```javascript
// 容器组件 UserListContainer.vue
export default {
  data() {
    return {
      users: [],
      loading: false
    }
  },
  async created() {
    await this.fetchUsers();
  },
  methods: {
    async fetchUsers() {
      this.loading = true;
      this.users = await api.getUsers();
      this.loading = false;
    },
    handleUserClick(user) {
      // 业务逻辑处理
      router.push(`/users/${user.id}`);
    }
  }
}

// 展示组件 UserList.vue
<template>
  <div v-if="loading">加载中...</div>
  <ul v-else>
    <li
      v-for="user in users"
      :key="user.id"
      @click="$emit('user-clicked', user)"
    >
      {{ user.name }}
    </li>
  </ul>
</template>

<script>
export default {
  props: {
    users: {
      type: Array,
      required: true
    },
    loading: {
      type: Boolean,
      default: false
    }
  }
}
</script>
```

## 四、常见反模式

### 4.1 过度耦合

**问题表现**：
- 组件直接访问其他组件的实例
- 通过 `$parent`、`$children` 访问组件
- 在组件中直接修改Vuex状态而不通过action

**解决方案**：
- 使用props和events进行通信
- 使用Vuex进行全局状态管理
- 使用事件总线（Event Bus）进行跨组件通信

### 4.2 职责不清

**问题表现**：
- 一个组件包含多个不相关的功能
- 组件名称模糊（如 `ManagerComponent`、`HandlerComponent`）
- 组件代码超过500行

**解决方案**：
- 遵循单一职责原则
- 拆分组件，每个组件只负责一个功能
- 使用明确的组件命名

### 4.3 重复逻辑

**问题表现**：
- 多个组件包含相同的逻辑代码
- 复制粘贴代码而不是复用

**解决方案**：
- 提取公共逻辑到 mixins
- 使用组合式函数（Composition API）
- 创建工具函数或工具类
