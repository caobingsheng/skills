# Vue高内聚低耦合完整示例

## 示例：Todo应用

### 组件结构设计

```
TodoApp (根组件)
├── AddTodo (添加待办事项)
├── TodoList (待办事项列表)
│   └── TodoItem (单个待办事项)
└── TodoFilter (筛选器)
```

### 1. AddTodo组件（高内聚示例）

**职责**：只负责添加新的待办事项

```vue
<template>
  <div class="add-todo">
    <input
      v-model="newTodo"
      @keyup.enter="addTodo"
      placeholder="添加新的待办事项"
    />
    <button @click="addTodo">添加</button>
  </div>
</template>

<script>
export default {
  name: 'AddTodo',
  data() {
    return {
      // 封装内部状态
      newTodo: ''
    }
  },
  methods: {
    addTodo() {
      if (!this.newTodo.trim()) {
        return;
      }
      // 通过事件向父组件传递数据，而不是直接修改父组件状态
      this.$emit('add-todo', {
        id: Date.now(),
        text: this.newTodo.trim(),
        completed: false
      });
      // 重置内部状态
      this.newTodo = '';
    }
  }
}
</script>

<style scoped>
.add-todo {
  display: flex;
  gap: 10px;
  margin-bottom: 20px;
}

.add-todo input {
  flex: 1;
  padding: 8px;
  border: 1px solid #ddd;
  border-radius: 4px;
}

.add-todo button {
  padding: 8px 16px;
  background: #42b983;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}
</style>
```

**高内聚体现**：
- ✅ 单一职责：只负责添加待办事项
- ✅ 封装内部状态：`newTodo` 是组件私有状态
- ✅ 明确的接口：通过 `add-todo` 事件与外部通信

### 2. TodoItem组件（高内聚示例）

**职责**：只负责显示和操作单个待办事项

```vue
<template>
  <div class="todo-item" :class="{ completed: todo.completed }">
    <input
      type="checkbox"
      :checked="todo.completed"
      @change="toggleComplete"
    />
    <span class="todo-text">{{ todo.text }}</span>
    <button @click="deleteTodo" class="delete-btn">删除</button>
  </div>
</template>

<script>
export default {
  name: 'TodoItem',
  props: {
    // 明确的props定义
    todo: {
      type: Object,
      required: true,
      validator: (value) => {
        return value.id !== undefined && value.text !== undefined;
      }
    }
  },
  methods: {
    toggleComplete() {
      // 通过事件通知父组件，而不是直接修改
      this.$emit('toggle-complete', this.todo.id);
    },
    deleteTodo() {
      this.$emit('delete-todo', this.todo.id);
    }
  }
}
</script>

<style scoped>
.todo-item {
  display: flex;
  align-items: center;
  padding: 10px;
  border-bottom: 1px solid #eee;
  gap: 10px;
}

.todo-item.completed .todo-text {
  text-decoration: line-through;
  color: #999;
}

.todo-text {
  flex: 1;
}

.delete-btn {
  padding: 4px 8px;
  background: #ff4444;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}
</style>
```

**高内聚体现**：
- ✅ 单一职责：只负责单个待办事项的显示和操作
- ✅ 封装内部逻辑：切换完成状态和删除操作
- ✅ 明确的接口：通过 `toggle-complete` 和 `delete-todo` 事件通信

### 3. TodoList组件（低耦合示例）

**职责**：管理待办事项列表

```vue
<template>
  <div class="todo-list">
    <todo-item
      v-for="todo in todos"
      :key="todo.id"
      :todo="todo"
      @toggle-complete="handleToggleComplete"
      @delete-todo="handleDeleteTodo"
    />
  </div>
</template>

<script>
import TodoItem from './TodoItem.vue';

export default {
  name: 'TodoList',
  components: {
    TodoItem
  },
  props: {
    todos: {
      type: Array,
      required: true,
      default: () => []
    }
  },
  methods: {
    handleToggleComplete(todoId) {
      // 转发事件到父组件
      this.$emit('toggle-complete', todoId);
    },
    handleDeleteTodo(todoId) {
      this.$emit('delete-todo', todoId);
    }
  }
}
</script>

<style scoped>
.todo-list {
  border: 1px solid #eee;
  border-radius: 4px;
}
</style>
```

**低耦合体现**：
- ✅ 通过props接收数据
- ✅ 通过events传递操作
- ✅ 不直接修改父组件状态

### 4. TodoApp根组件（协调者）

**职责**：协调子组件，管理应用状态

```vue
<template>
  <div class="todo-app">
    <h1>待办事项</h1>
    <add-todo @add-todo="addTodo" />
    <todo-list
      :todos="filteredTodos"
      @toggle-complete="toggleComplete"
      @delete-todo="deleteTodo"
    />
    <todo-filter
      :filter="filter"
      @filter-change="filter = $event"
    />
  </div>
</template>

<script>
import AddTodo from './AddTodo.vue';
import TodoList from './TodoList.vue';
import TodoFilter from './TodoFilter.vue';

export default {
  name: 'TodoApp',
  components: {
    AddTodo,
    TodoList,
    TodoFilter
  },
  data() {
    return {
      todos: [],
      filter: 'all' // all, active, completed
    }
  },
  computed: {
    filteredTodos() {
      switch (this.filter) {
        case 'active':
          return this.todos.filter(todo => !todo.completed);
        case 'completed':
          return this.todos.filter(todo => todo.completed);
        default:
          return this.todos;
      }
    }
  },
  methods: {
    addTodo(todo) {
      this.todos.push(todo);
    },
    toggleComplete(todoId) {
      const todo = this.todos.find(t => t.id === todoId);
      if (todo) {
        todo.completed = !todo.completed;
      }
    },
    deleteTodo(todoId) {
      this.todos = this.todos.filter(t => t.id !== todoId);
    }
  }
}
</script>

<style scoped>
.todo-app {
  max-width: 600px;
  margin: 0 auto;
  padding: 20px;
}

h1 {
  text-align: center;
  color: #42b983;
}
</style>
```

**协调者角色**：
- ✅ 管理应用状态
- ✅ 处理子组件事件
- ✅ 向子组件传递数据

## 示例：用户管理组件（使用Vuex）

### 组件结构

```
UserManagement (容器组件)
├── UserList (展示组件)
├── UserDetail (展示组件)
└── UserForm (展示组件)
```

### 1. Vuex Store配置

```javascript
// store/modules/user.js
export default {
  namespaced: true,
  state: {
    users: [],
    currentUser: null,
    loading: false,
    error: null
  },
  getters: {
    activeUsers: (state) => state.users.filter(user => user.active),
    userById: (state) => (id) => state.users.find(user => user.id === id),
    isLoading: (state) => state.loading
  },
  mutations: {
    SET_USERS(state, users) {
      state.users = users;
    },
    SET_CURRENT_USER(state, user) {
      state.currentUser = user;
    },
    SET_LOADING(state, loading) {
      state.loading = loading;
    },
    SET_ERROR(state, error) {
      state.error = error;
    },
    ADD_USER(state, user) {
      state.users.push(user);
    },
    UPDATE_USER(state, updatedUser) {
      const index = state.users.findIndex(user => user.id === updatedUser.id);
      if (index !== -1) {
        state.users.splice(index, 1, updatedUser);
      }
    },
    DELETE_USER(state, userId) {
      state.users = state.users.filter(user => user.id !== userId);
    }
  },
  actions: {
    async fetchUsers({ commit }) {
      commit('SET_LOADING', true);
      try {
        const users = await api.getUsers();
        commit('SET_USERS', users);
      } catch (error) {
        commit('SET_ERROR', error.message);
      } finally {
        commit('SET_LOADING', false);
      }
    },
    async fetchUser({ commit }, userId) {
      commit('SET_LOADING', true);
      try {
        const user = await api.getUser(userId);
        commit('SET_CURRENT_USER', user);
      } catch (error) {
        commit('SET_ERROR', error.message);
      } finally {
        commit('SET_LOADING', false);
      }
    },
    async createUser({ commit }, userData) {
      commit('SET_LOADING', true);
      try {
        const user = await api.createUser(userData);
        commit('ADD_USER', user);
        return user;
      } catch (error) {
        commit('SET_ERROR', error.message);
        throw error;
      } finally {
        commit('SET_LOADING', false);
      }
    },
    async updateUser({ commit }, userData) {
      commit('SET_LOADING', true);
      try {
        const user = await api.updateUser(userData);
        commit('UPDATE_USER', user);
        return user;
      } catch (error) {
        commit('SET_ERROR', error.message);
        throw error;
      } finally {
        commit('SET_LOADING', false);
      }
    },
    async deleteUser({ commit }, userId) {
      commit('SET_LOADING', true);
      try {
        await api.deleteUser(userId);
        commit('DELETE_USER', userId);
      } catch (error) {
        commit('SET_ERROR', error.message);
        throw error;
      } finally {
        commit('SET_LOADING', false);
      }
    }
  }
}
```

### 2. 容器组件 UserManagement.vue

```vue
<template>
  <div class="user-management">
    <h1>用户管理</h1>
    <user-list
      :users="users"
      :loading="loading"
      @user-selected="handleUserSelected"
      @user-deleted="handleUserDeleted"
    />
    <user-detail
      v-if="selectedUser"
      :user="selectedUser"
      @user-updated="handleUserUpdated"
    />
    <user-form
      @user-created="handleUserCreated"
    />
  </div>
</template>

<script>
import { mapState, mapGetters, mapActions } from 'vuex';
import UserList from './UserList.vue';
import UserDetail from './UserDetail.vue';
import UserForm from './UserForm.vue';

export default {
  name: 'UserManagement',
  components: {
    UserList,
    UserDetail,
    UserForm
  },
  data() {
    return {
      selectedUserId: null
    }
  },
  computed: {
    ...mapState('user', ['users', 'loading']),
    ...mapGetters('user', ['userById']),
    selectedUser() {
      return this.selectedUserId ? this.userById(this.selectedUserId) : null;
    }
  },
  async created() {
    await this.fetchUsers();
  },
  methods: {
    ...mapActions('user', [
      'fetchUsers',
      'createUser',
      'updateUser',
      'deleteUser'
    ]),
    handleUserSelected(user) {
      this.selectedUserId = user.id;
    },
    async handleUserCreated(userData) {
      try {
        await this.createUser(userData);
        this.$message.success('用户创建成功');
      } catch (error) {
        this.$message.error('用户创建失败');
      }
    },
    async handleUserUpdated(userData) {
      try {
        await this.updateUser(userData);
        this.$message.success('用户更新成功');
      } catch (error) {
        this.$message.error('用户更新失败');
      }
    },
    async handleUserDeleted(userId) {
      try {
        await this.deleteUser(userId);
        this.$message.success('用户删除成功');
        if (this.selectedUserId === userId) {
          this.selectedUserId = null;
        }
      } catch (error) {
        this.$message.error('用户删除失败');
      }
    }
  }
}
</script>
```

### 3. 展示组件 UserList.vue

```vue
<template>
  <div class="user-list">
    <div v-if="loading" class="loading">加载中...</div>
    <table v-else>
      <thead>
        <tr>
          <th>ID</th>
          <th>姓名</th>
          <th>邮箱</th>
          <th>状态</th>
          <th>操作</th>
        </tr>
      </thead>
      <tbody>
        <tr
          v-for="user in users"
          :key="user.id"
          :class="{ active: selectedUserId === user.id }"
        >
          <td>{{ user.id }}</td>
          <td>{{ user.name }}</td>
          <td>{{ user.email }}</td>
          <td>{{ user.active ? '激活' : '未激活' }}</td>
          <td>
            <button @click="$emit('user-selected', user)">查看</button>
            <button @click="confirmDelete(user)">删除</button>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
export default {
  name: 'UserList',
  props: {
    users: {
      type: Array,
      required: true
    },
    loading: {
      type: Boolean,
      default: false
    }
  },
  methods: {
    confirmDelete(user) {
      if (confirm(`确定要删除用户 ${user.name} 吗？`)) {
        this.$emit('user-deleted', user.id);
      }
    }
  }
}
</script>

<style scoped>
.user-list {
  margin-bottom: 20px;
}

table {
  width: 100%;
  border-collapse: collapse;
}

th, td {
  padding: 10px;
  text-align: left;
  border-bottom: 1px solid #eee;
}

tr.active {
  background-color: #f0f9ff;
}

.loading {
  text-align: center;
  padding: 20px;
}
</style>
```

**设计优势**：
- ✅ 展示组件不包含业务逻辑
- ✅ 所有数据通过props传入
- ✅ 所有操作通过events触发
- ✅ 组件可独立测试和复用
