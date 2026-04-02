# Vue高内聚低耦合最佳实践

## 一、组件设计原则

### 1.1 单一职责原则（SRP）

**原则**：一个组件应该只有一个改变的理由。

**实践要点**：
- 每个组件只负责一个功能模块
- 组件名称应该清晰描述其职责
- 避免在组件中混合多个不相关的功能

**检查清单**：
- [ ] 组件名称是否清晰描述其功能？
- [ ] 组件是否只包含一个业务逻辑？
- [ ] 组件是否可以独立测试？
- [ ] 组件是否可以在其他地方复用？

### 1.2 开闭原则（OCP）

**原则**：组件应该对扩展开放，对修改关闭。

**实践要点**：
- 使用插槽（slots）提供扩展点
- 使用props提供配置选项
- 使用作用域插槽增强灵活性

**示例**：
```vue
<!-- 基础按钮组件 -->
<template>
  <button :class="buttonClass" @click="handleClick">
    <slot name="icon"></slot>
    <slot>{{ text }}</slot>
  </button>
</template>

<script>
export default {
  props: {
    type: {
      type: String,
      default: 'default',
      validator: (value) => ['default', 'primary', 'danger'].includes(value)
    },
    text: String
  },
  computed: {
    buttonClass() {
      return `btn btn-${this.type}`;
    }
  },
  methods: {
    handleClick() {
      this.$emit('click');
    }
  }
}
</script>
```

### 1.3 依赖倒置原则（DIP）

**原则**：依赖抽象而不是具体实现。

**实践要点**：
- 使用props注入依赖
- 使用依赖注入（provide/inject）
- 使用工厂模式创建对象

## 二、组件通信最佳实践

### 2.1 Props通信

**最佳实践**：
```javascript
export default {
  props: {
    // ✅ 明确类型
    userId: {
      type: String,
      required: true
    },
    // ✅ 提供默认值
    userName: {
      type: String,
      default: 'Anonymous'
    },
    // ✅ 自定义验证
    email: {
      type: String,
      validator: (value) => {
        return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value);
      }
    },
    // ✅ 对象/数组默认值使用函数
    userInfo: {
      type: Object,
      default: () => ({})
    }
  }
}
```

**避免的做法**：
```javascript
export default {
  props: {
    // ❌ 不指定类型
    userData: null,
    // ❌ 对象默认值直接使用
    options: {
      type: Object,
      default: {} // 错误！会导致所有实例共享同一个对象
    }
  }
}
```

### 2.2 Events通信

**最佳实践**：
```javascript
export default {
  methods: {
    // ✅ 事件名使用 kebab-case
    handleSubmit() {
      this.$emit('form-submit', {
        id: this.userId,
        data: this.formData
      });
    },
    // ✅ 提供清晰的事件数据
    handleUserClick(user) {
      this.$emit('user-clicked', {
        userId: user.id,
        userName: user.name,
        timestamp: Date.now()
      });
    }
  }
}
```

**事件命名规范**：
- 使用 kebab-case
- 描述"发生了什么"，而不是"如何处理"
- ✅ `user-clicked`、`form-submit`、`data-loaded`
- ❌ `handleUserClick`、`submitForm`、`onDataLoad`

### 2.3 v-model使用

**自定义v-model组件**：
```vue
<template>
  <input
    :value="value"
    @input="$emit('input', $event.target.value)"
  />
</template>

<script>
export default {
  props: ['value']
}
</script>

<!-- Vue 2.2+ 可以自定义 prop 和 event -->
<script>
export default {
  model: {
    prop: 'checked',
    event: 'change'
  },
  props: {
    checked: Boolean
  }
}
</script>
```

### 2.4 .sync修饰符

**适用场景**：需要双向绑定，但不想使用v-model

```vue
<!-- 父组件 -->
<template>
  <child-component :user-name.sync="userName" />
</template>

<!-- 子组件 -->
<script>
export default {
  props: ['userName'],
  methods: {
    updateName(newName) {
      this.$emit('update:userName', newName);
    }
  }
}
</script>
```

## 三、状态管理最佳实践

### 3.1 何时使用Vuex

**应该使用Vuex的场景**：
- 多个组件需要共享状态
- 跨层级组件通信
- 需要持久化状态
- 复杂的状态逻辑

**不需要使用Vuex的场景**：
- 简单的父子组件通信
- 兄弟组件通信（使用事件总线）
- 临时状态

### 3.2 Vuex模块化

**目录结构**：
```
store/
├── index.js
└── modules/
    ├── user.js
    ├── product.js
    └── cart.js
```

**模块定义**：
```javascript
// store/modules/user.js
export default {
  namespaced: true, // 使用命名空间
  state: {
    currentUser: null,
    userList: []
  },
  getters: {
    // 使用命名空间后，getters是局部的
    activeUsers: (state) => state.userList.filter(u => u.active)
  },
  mutations: {
    SET_CURRENT_USER(state, user) {
      state.currentUser = user;
    }
  },
  actions: {
    async login({ commit }, credentials) {
      const user = await api.login(credentials);
      commit('SET_CURRENT_USER', user);
    }
  }
}
```

### 3.3 状态持久化

**使用vuex-persistedstate**：
```javascript
import Vue from 'vue';
import Vuex from 'vuex';
import createPersistedState from 'vuex-persistedstate';

Vue.use(Vuex);

export default new Vuex.Store({
  plugins: [
    createPersistedState({
      key: 'my-app',
      paths: ['user.currentUser', 'settings.theme'] // 只持久化部分状态
    })
  ]
});
```

## 四、组件复用策略

### 4.1 Mixins

**适用场景**：
- 多个组件共享相同的逻辑
- 逻辑不需要响应式数据

**示例**：
```javascript
// mixins/pagination.js
export default {
  data() {
    return {
      currentPage: 1,
      pageSize: 10,
      total: 0
    }
  },
  computed: {
    totalPages() {
      return Math.ceil(this.total / this.pageSize);
    }
  },
  methods: {
    goToPage(page) {
      this.currentPage = page;
      this.$emit('page-changed', page);
    }
  }
}

// 使用mixin
import pagination from '@/mixins/pagination';

export default {
  mixins: [pagination],
  data() {
    return {
      items: []
    }
  }
}
```

**注意事项**：
- 避免命名冲突
- 不要过度使用
- 考虑使用组合式函数（Composition API）替代

### 4.2 组合式函数（Composition API）

**Vue 2.7+ 或 Vue 3**：
```javascript
// composables/usePagination.js
import { ref, computed } from 'vue';

export function usePagination(options = {}) {
  const currentPage = ref(1);
  const pageSize = ref(options.pageSize || 10);
  const total = ref(0);

  const totalPages = computed(() => Math.ceil(total.value / pageSize.value));

  const goToPage = (page) => {
    currentPage.value = page;
  };

  return {
    currentPage,
    pageSize,
    total,
    totalPages,
    goToPage
  };
}

// 使用
import { usePagination } from '@/composables/usePagination';

export default {
  setup() {
    const { currentPage, totalPages, goToPage } = usePagination({
      pageSize: 20
    });

    return {
      currentPage,
      totalPages,
      goToPage
    };
  }
}
```

### 4.3 插槽（Slots）

**基础插槽**：
```vue
<!-- 基础组件 -->
<template>
  <div class="card">
    <slot></slot>
  </div>
</template>

<!-- 使用 -->
<base-card>
  <p>卡片内容</p>
</base-card>
```

**具名插槽**：
```vue
<template>
  <div class="modal">
    <div class="modal-header">
      <slot name="header">
        <h3>默认标题</h3>
      </slot>
    </div>
    <div class="modal-body">
      <slot></slot>
    </div>
    <div class="modal-footer">
      <slot name="footer">
        <button @click="$emit('close')">关闭</button>
      </slot>
    </div>
  </div>
</template>
```

**作用域插槽**：
```vue
<!-- 列表组件 -->
<template>
  <ul>
    <li v-for="item in items" :key="item.id">
      <slot :item="item" :index="index">
        {{ item.name }}
      </slot>
    </li>
  </ul>
</template>

<!-- 使用 -->
<template>
  <smart-list :items="users">
    <template #default="{ item, index }">
      <span>{{ index + 1 }}. {{ item.name }} ({{ item.email }})</span>
    </template>
  </smart-list>
</template>
```

## 五、性能优化

### 5.1 计算属性缓存

```javascript
export default {
  data() {
    return {
      firstName: 'John',
      lastName: 'Doe'
    }
  },
  computed: {
    // ✅ 使用计算属性（有缓存）
    fullName() {
      console.log('计算 fullName');
      return `${this.firstName} ${this.lastName}`;
    }
  },
  methods: {
    // ❌ 使用方法（无缓存，每次都重新计算）
    getFullName() {
      console.log('调用 getFullName');
      return `${this.firstName} ${this.lastName}`;
    }
  }
}
```

### 5.2 v-if vs v-show

```vue
<!-- v-if：真正的条件渲染，有更高的切换开销 -->
<template>
  <heavy-component v-if="showComponent" />
</template>

<!-- v-show：简单的CSS切换，有更高的初始渲染开销 -->
<template>
  <heavy-component v-show="showComponent" />
</template>

<!-- 使用建议 -->
<!-- 频繁切换：使用 v-show -->
<!-- 很少改变：使用 v-if -->
```

### 5.3 列表渲染优化

```vue
<template>
  <!-- ✅ 使用 key -->
  <div v-for="item in items" :key="item.id">
    {{ item.name }}
  </div>

  <!-- ❌ 不要使用 index 作为 key（除非列表是静态的） -->
  <div v-for="(item, index) in items" :key="index">
    {{ item.name }}
  </div>
</template>
```

### 5.4 组件懒加载

```javascript
// 路由懒加载
const UserList = () => import('./views/UserList.vue');

const router = new VueRouter({
  routes: [
    { path: '/users', component: UserList }
  ]
});

// 组件懒加载
export default {
  components: {
    HeavyComponent: () => import('./HeavyComponent.vue')
  }
}
```

## 六、代码审查检查清单

### 组件设计
- [ ] 组件职责是否单一？
- [ ] 组件名称是否清晰？
- [ ] Props定义是否完整（type、required、default）？
- [ ] Events命名是否规范？

### 代码质量
- [ ] 是否避免了直接修改props？
- [ ] 是否避免了`this.$parent`和`this.$children`？
- [ ] 是否使用了计算属性而不是方法？
- [ ] 是否正确使用了key？

### 性能
- [ ] 是否合理使用了v-if和v-show？
- [ ] 是否对大型列表进行了优化？
- [ ] 是否使用了组件懒加载？

### 可维护性
- [ ] 代码是否有清晰的注释？
- [ ] 组件是否易于测试？
- [ ] 是否避免了重复代码？
- [ ] 是否遵循了项目代码规范？
