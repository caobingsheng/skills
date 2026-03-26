# Tree 树形控件

用清晰的层级结构展示信息，可展开或折叠。

## 基础用法

### 基础用法
基础的树形结构展示。

```vue
<el-tree :data="data" :props="defaultProps" @node-click="handleNodeClick"></el-tree>

<script>
export default {
  data() {
    return {
      data: [{
        label: '一级 1',
        children: [{
          label: '二级 1-1',
          children: [{
            label: '三级 1-1-1'
          }]
        }]
      }, {
        label: '一级 2',
        children: [{
          label: '二级 2-1',
          children: [{
            label: '三级 2-1-1'
          }]
        }]
      }],
      defaultProps: {
        children: 'children',
        label: 'label'
      }
    };
  },
  methods: {
    handleNodeClick(data) {
      console.log(data);
    }
  }
};
</script>
```

### 可选择
适用于需要选择层级时使用。本例还展示了动态加载节点数据的方法。

```vue
<el-tree
  :props="props"
  :load="loadNode"
  lazy
  show-checkbox
  @check-change="handleCheckChange">
</el-tree>

<script>
export default {
  data() {
    return {
      props: {
        label: 'name',
        children: 'zones'
      },
      count: 1
    };
  },
  methods: {
    handleCheckChange(data, checked, indeterminate) {
      console.log(data, checked, indeterminate);
    },
    loadNode(node, resolve) {
      if (node.level === 0) {
        return resolve([{ name: 'region1' }, { name: 'region2' }]);
      }
      if (node.level > 3) return resolve([]);
      setTimeout(() => {
        const data = [{ name: 'zone' + this.count++ }, { name: 'zone' + this.count++ }];
        resolve(data);
      }, 500);
    }
  }
};
</script>
```

### 默认展开和默认选中
可将 Tree 的某些节点设置为默认展开或默认选中。需要注意的是，此时必须设置 `node-key`。

```vue
<el-tree
  :data="data"
  show-checkbox
  node-key="id"
  :default-expanded-keys="[2, 3]"
  :default-checked-keys="[5]"
  :props="defaultProps">
</el-tree>

<script>
export default {
  data() {
    return {
      data: [{
        id: 1,
        label: '一级 1',
        children: [{
          id: 4,
          label: '二级 1-1',
          children: [{
            id: 9,
            label: '三级 1-1-1'
          }]
        }]
      }, {
        id: 2,
        label: '一级 2',
        children: [{
          id: 5,
          label: '二级 2-1'
        }]
      }],
      defaultProps: {
        children: 'children',
        label: 'label'
      }
    };
  }
};
</script>
```

### 禁用状态
可将 Tree 的某些节点设置为禁用状态。通过 `disabled` 设置禁用状态。

```vue
<el-tree
  :data="data"
  show-checkbox
  node-key="id"
  :default-expanded-keys="[2, 3]"
  :default-checked-keys="[5]">
</el-tree>

<script>
export default {
  data() {
    return {
      data: [{
        id: 1,
        label: '一级 2',
        children: [{
          id: 3,
          label: '二级 2-1',
          children: [{
            id: 4,
            label: '三级 3-1-1'
          }, {
            id: 5,
            label: '三级 3-1-2',
            disabled: true
          }]
        }]
      }]
    };
  }
};
</script>
```

### 节点过滤
通过关键字过滤树节点。在需要对节点进行过滤时，调用 Tree 实例的 `filter` 方法。

```vue
<el-input
  placeholder="输入关键字进行过滤"
  v-model="filterText">
</el-input>

<el-tree
  class="filter-tree"
  :data="data"
  :props="defaultProps"
  default-expand-all
  :filter-node-method="filterNode"
  ref="tree">
</el-tree>

<script>
export default {
  watch: {
    filterText(val) {
      this.$refs.tree.filter(val);
    }
  },
  methods: {
    filterNode(value, data) {
      if (!value) return true;
      return data.label.indexOf(value) !== -1;
    }
  },
  data() {
    return {
      filterText: '',
      data: [{
        id: 1,
        label: '一级 1',
        children: [{
          id: 4,
          label: '二级 1-1'
        }]
      }],
      defaultProps: {
        children: 'children',
        label: 'label'
      }
    };
  }
};
</script>
```

### 手风琴模式
对于同一级的节点，每次只能展开一个。

```vue
<el-tree
  :data="data"
  :props="defaultProps"
  accordion
  @node-click="handleNodeClick">
</el-tree>
```

### 可拖拽
通过 draggable 属性开启拖拽功能。

```vue
<el-tree
  :data="data"
  node-key="id"
  default-expand-all
  @node-drag-start="handleDragStart"
  @node-drag-enter="handleDragEnter"
  @node-drag-leave="handleDragLeave"
  @node-drag-over="handleDragOver"
  @node-drag-end="handleDragEnd"
  @node-drop="handleDrop"
  draggable
  :allow-drop="allowDrop"
  :allow-drag="allowDrag">
</el-tree>

<script>
export default {
  data() {
    return {
      data: [{
        id: 1,
        label: '一级 1',
        children: [{
          id: 4,
          label: '二级 1-1',
          children: [{
            id: 9,
            label: '三级 1-1-1'
          }, {
            id: 10,
            label: '三级 1-1-2'
          }]
        }]
      }, {
        id: 2,
        label: '一级 2',
        children: [{
          id: 5,
          label: '二级 2-1'
        }, {
          id: 6,
          label: '二级 2-2'
        }]
      }, {
        id: 3,
        label: '一级 3',
        children: [{
          id: 7,
          label: '二级 3-1'
        }, {
          id: 8,
          label: '二级 3-2'
        }]
      }],
      defaultProps: {
        children: 'children',
        label: 'label'
      }
    };
  },
  methods: {
    handleDragStart(node, event) {
      console.log('drag start', node);
    },
    handleDragEnter(draggingNode, dropNode, event) {
      console.log('tree drag enter: ', dropNode.label);
    },
    handleDragLeave(draggingNode, dropNode, event) {
      console.log('tree drag leave: ', dropNode.label);
    },
    handleDragOver(draggingNode, dropNode, event) {
      console.log('tree drag over: ', dropNode.label);
    },
    handleDragEnd(draggingNode, dropNode, dropType, event) {
      console.log('tree drag end: ', dropNode && dropNode.label, dropType);
    },
    handleDrop(draggingNode, dropNode, dropType, event) {
      console.log('tree drop: ', dropNode.label, dropType);
    },
    allowDrop(draggingNode, dropNode, type) {
      if (dropNode.data.label === '一级 1') {
        return type !== 'inner';
      }
      return true;
    },
    allowDrag(draggingNode) {
      return draggingNode.data.label.indexOf('三级 3-1') === -1;
    }
  }
};
</script>
```

## Attributes

| 参数 | 说明 | 类型 | 可选值 | 默认值 |
|------|------|------|--------|--------|
| data | 展示数据 | array | — | — |
| empty-text | 内容为空的时候展示的文本 | String | — | — |
| node-key | 每个树节点用来作为唯一标识的属性，整棵树应该是唯一的 | String | — | — |
| props | 配置选项，具体看下表 | object | — | — |
| render-after-expand | 是否在第一次展开某个树节点后才渲染其子节点 | boolean | — | true |
| load | 加载子树数据的方法，仅当 lazy 属性为true 时生效 | function(node, resolve) | — | — |
| render-content | 树节点的内容区的渲染 Function | Function(h, { node, data, store }) | — | — |
| highlight-current | 是否高亮当前选中节点 | boolean | — | false |
| default-expand-all | 是否默认展开所有节点 | boolean | — | false |
| expand-on-click-node | 是否在点击节点的时候展开或者收缩节点 | boolean | — | true |
| check-on-click-node | 是否在点击节点的时候选中节点 | boolean | — | false |
| auto-expand-parent | 展开子节点的时候是否自动展开父节点 | boolean | — | true |
| default-expanded-keys | 默认展开的节点的 key 的数组 | array | — | — |
| show-checkbox | 节点是否可被选择 | boolean | — | false |
| check-strictly | 在显示复选框的情况下，是否严格的遵循父子不互相关联的做法 | boolean | — | false |
| default-checked-keys | 默认勾选的节点的 key 的数组 | array | — | — |
| current-node-key | 当前选中的节点 | string, number | — | — |
| filter-node-method | 对树节点进行筛选时执行的方法 | Function(value, data, node) | — | — |
| accordion | 是否每次只打开一个同级树节点展开 | boolean | — | false |
| indent | 相邻级节点间的水平缩进，单位为像素 | number | — | 16 |
| icon-class | 自定义树节点的图标 | string | — | — |
| lazy | 是否懒加载子节点，需与 load 方法结合使用 | boolean | — | false |
| draggable | 是否开启拖拽节点功能 | boolean | — | false |
| allow-drag | 判断节点能否被拖拽 | Function(node) | — | — |
| allow-drop | 拖拽时判定目标节点能否被放置 | Function(draggingNode, dropNode, type) | — | — |

## props

| 参数 | 说明 | 类型 | 可选值 | 默认值 |
|------|------|------|--------|--------|
| label | 指定节点标签为节点对象的某个属性值 | string, function(data, node) | — | — |
| children | 指定子树为节点对象的某个属性值 | string | — | — |
| disabled | 指定节点选择框是否禁用为节点对象的某个属性值 | boolean, function(data, node) | — | — |
| isLeaf | 指定节点是否为叶子节点，仅在指定了 lazy 属性的情况下生效 | boolean, function(data, node) | — | — |

## 方法

| 方法名 | 说明 | 参数 |
|--------|------|------|
| filter | 对树节点进行筛选操作 | 接收一个任意类型的参数 |
| getCheckedNodes | 返回目前被选中的节点所组成的数组 | (leafOnly, includeHalfChecked) |
| setCheckedNodes | 设置目前勾选的节点 | (nodes) 接收勾选节点数据的数组 |
| getCheckedKeys | 返回目前被选中的节点的 key 所组成的数组 | (leafOnly) |
| setCheckedKeys | 通过 keys 设置目前勾选的节点 | (keys, leafOnly) |
| setChecked | 通过 key / data 设置某个节点的勾选状态 | (key/data, checked, deep) |
| getCurrentKey | 获取当前被选中节点的 key | — |
| getCurrentNode | 获取当前被选中节点的 data | — |
| setCurrentKey | 通过 key 设置某个节点的当前选中状态 | (key) |
| setCurrentNode | 通过 node 设置某个节点的当前选中状态 | (node) |
| getNode | 根据 data 或者 key 拿到 Tree 组件中的 node | (data) |
| remove | 删除 Tree 中的一个节点 | (data) |
| append | 为 Tree 中的一个节点追加一个子节点 | (data, parentNode) |
| insertBefore | 为 Tree 的一个节点的前面增加一个节点 | (data, refNode) |
| insertAfter | 为 Tree 的一个节点的后面增加一个节点 | (data, refNode) |

## Events

| 事件名称 | 说明 | 回调参数 |
|----------|------|----------|
| node-click | 节点被点击时的回调 | 共三个参数：节点对象、Node 对象、节点组件本身 |
| node-contextmenu | 当某一节点被鼠标右键点击时会触发该事件 | 共四个参数：event、节点对象、Node 对象、节点组件本身 |
| check-change | 节点选中状态发生变化时的回调 | 共三个参数：节点对象、是否被选中、子树中是否有被选中的节点 |
| check | 当复选框被点击的时候触发 | 共两个参数：节点对象、树目前的选中状态对象 |
| current-change | 当前选中节点变化时触发的事件 | 共两个参数：当前节点的数据，当前节点的 Node 对象 |
| node-expand | 节点被展开时触发的事件 | 共三个参数：节点对象、Node 对象、节点组件本身 |
| node-collapse | 节点被关闭时触发的事件 | 共三个参数：节点对象、Node 对象、节点组件本身 |
| node-drag-start | 节点开始拖拽时触发的事件 | 共两个参数：被拖拽节点对应的 Node、event |
| node-drop | 拖拽成功完成时触发的事件 | 共四个参数：被拖拽节点、目标节点、放置位置、event |

## Scoped Slot

| name | 说明 |
|------|------|
| — | 自定义树节点的内容，参数为 { node, data } |

## 最佳实践

1. **懒加载**：使用 `lazy` 和 `load` 属性实现懒加载，提升大数据量场景的性能。

2. **节点过滤**：使用 `filter` 方法和 `filter-node-method` 实现节点过滤功能。

3. **节点选择**：使用 `show-checkbox` 和相关方法实现节点的选择和获取。

4. **自定义内容**：使用 `render-content` 或 scoped slot 自定义节点内容。

5. **拖拽功能**：使用 `draggable`、`allow-drop` 和 `allow-drag` 实现节点的拖拽功能。
