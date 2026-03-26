# 事件和方法完整列表

本文档详细说明vk-data-table组件的所有事件和方法。

## 事件（Events）

### 数据加载事件

#### success - 查询成功

```vue
<vk-data-table
  @success="onSuccess"
></vk-data-table>
```

```javascript
methods: {
  onSuccess({ data, list, total }) {
    console.log("原始数据：", data);
    console.log("列表数据：", list);
    console.log("总记录数：", total);
  }
}
```

**参数说明：**
- `data` - 云函数返回的原始数据
- `list` - 表格显示的列表数据
- `total` - 总记录条数

#### fail - 查询失败

```vue
<vk-data-table
  @fail="onFail"
></vk-data-table>
```

```javascript
methods: {
  onFail(err) {
    console.error("查询失败：", err);
  }
}
```

#### complete - 查询完成

```vue
<vk-data-table
  @complete="onComplete"
></vk-data-table>
```

```javascript
methods: {
  onComplete(res) {
    console.log("查询完成（无论成功失败）");
  }
}
```

#### table-mounted - 组件挂载完毕

```vue
<vk-data-table
  @table-mounted="onTableMounted"
></vk-data-table>
```

```javascript
methods: {
  onTableMounted() {
    console.log("表格组件已挂载（此时还没有数据）");
  }
}
```

### 操作按钮事件

#### detail - 查看详情

```vue
<vk-data-table
  @detail="onDetail"
></vk-data-table>
```

```javascript
methods: {
  onDetail({ item, row, open }) {
    // item和row值一样，区别在于修改row会影响表格显示
    console.log("查看详情：", item);
    open(); // 打开详情弹窗
  }
}
```

#### update - 编辑

```vue
<vk-data-table
  @update="onUpdate"
></vk-data-table>
```

```javascript
methods: {
  onUpdate({ item, row }) {
    console.log("编辑：", item);
    // 打开编辑弹窗
    this.form1.data = item;
    this.form1.show = true;
  }
}
```

#### delete - 删除

```vue
<vk-data-table
  @delete="onDelete"
></vk-data-table>
```

```javascript
methods: {
  onDelete({ item, deleteFn }) {
    vk.confirm("确认删除该记录？", () => {
      // 调用删除函数
      deleteFn();
    });
  }
}
```

### 行交互事件

#### current-change - 点击（高亮）某行

```vue
<vk-data-table
  @current-change="onCurrentChange"
></vk-data-table>
```

```javascript
methods: {
  onCurrentChange(row) {
    console.log("当前选中行：", row);
  }
}
```

#### row-click - 单击某行

```vue
<vk-data-table
  @row-click="onRowClick"
></vk-data-table>
```

```javascript
methods: {
  onRowClick(row, column, event) {
    console.log("单击行：", row);
    console.log("单击列：", column);
  }
}
```

#### row-dblclick - 双击某行

```vue
<vk-data-table
  @row-dblclick="onRowDblClick"
></vk-data-table>
```

```javascript
methods: {
  onRowDblClick(row, column, event) {
    console.log("双击行：", row);
  }
}
```

#### row-contextmenu - 右键某行

```vue
<vk-data-table
  @row-contextmenu="onRowContextMenu"
></vk-data-table>
```

```javascript
methods: {
  onRowContextMenu(row, column, event) {
    event.preventDefault(); // 阻止默认右键菜单
    console.log("右键行：", row);
  }
}
```

### 单元格事件

#### cell-click - 单击单元格

```vue
<vk-data-table
  @cell-click="onCellClick"
></vk-data-table>
```

```javascript
methods: {
  onCellClick(row, column, cell, event) {
    console.log("单击单元格：", row[column.property]);
  }
}
```

#### cell-dblclick - 双击单元格

```vue
<vk-data-table
  @cell-dblclick="onCellDblClick"
></vk-data-table>
```

```javascript
methods: {
  onCellDblClick(row, column, cell, event) {
    console.log("双击单元格：", row[column.property]);
  }
}
```

#### cell-mouse-enter - 单元格hover进入

```vue
<vk-data-table
  @cell-mouse-enter="onCellMouseEnter"
></vk-data-table>
```

```javascript
methods: {
  onCellMouseEnter(row, column, cell, event) {
    console.log("鼠标进入单元格");
  }
}
```

#### cell-mouse-leave - 单元格hover退出

```vue
<vk-data-table
  @cell-mouse-leave="onCellMouseLeave"
></vk-data-table>
```

```javascript
methods: {
  onCellMouseLeave(row, column, cell, event) {
    console.log("鼠标退出单元格");
  }
}
```

### 表头事件

#### header-click - 点击表头

```vue
<vk-data-table
  @header-click="onHeaderClick"
></vk-data-table>
```

```javascript
methods: {
  onHeaderClick(column, event) {
    console.log("点击表头：", column.property);
  }
}
```

#### header-contextmenu - 右键表头

```vue
<vk-data-table
  @header-contextmenu="onHeaderContextMenu"
></vk-data-table>
```

```javascript
methods: {
  onHeaderContextMenu(row, btn) {
    console.log("右键表头");
  }
}
```

#### header-dragend - 拖动改变列宽

```vue
<vk-data-table
  @header-dragend="onHeaderDragend"
></vk-data-table>
```

```javascript
methods: {
  onHeaderDragend(newWidth, oldWidth, column, event) {
    console.log("列宽改变：", oldWidth, "→", newWidth);
  }
}
```

### 多选事件

#### select - 勾选/取消勾选某行

```vue
<vk-data-table
  :selection="true"
  @select="onSelect"
></vk-data-table>
```

```javascript
methods: {
  onSelect(selection, row) {
    console.log("选中行：", selection);
    console.log("当前操作行：", row);
  }
}
```

#### select-all - 全选/取消全选

```vue
<vk-data-table
  :selection="true"
  @select-all="onSelectAll"
></vk-data-table>
```

```javascript
methods: {
  onSelectAll(selection) {
    console.log("全选状态：", selection);
  }
}
```

#### selection-change - 多选框状态变化

```vue
<vk-data-table
  :selection="true"
  @selection-change="onSelectionChange"
></vk-data-table>
```

```javascript
methods: {
  onSelectionChange(rows) {
    console.log("当前选中：", rows);
  }
}
```

### 分页事件

#### pagination-change - 分页变化

```vue
<vk-data-table
  @pagination-change="onPaginationChange"
></vk-data-table>
```

```javascript
methods: {
  onPaginationChange(paginationData) {
    console.log("当前页：", paginationData.pageIndex);
    console.log("每页条数：", paginationData.pageSize);
  }
}
```

### 自定义按钮事件

#### custom-right-btns - 自定义右侧按钮

```vue
<vk-data-table
  :custom-right-btns="table1.customRightBtns"
  @custom-right-btns="onCustomRightBtns"
></vk-data-table>
```

```javascript
data() {
  return {
    table1: {
      customRightBtns: [
        {
          title: "自定义按钮",
          type: "primary",
          onClick: (item) => {
            console.log("点击自定义按钮：", item);
          }
        }
      ]
    }
  };
}
```

#### right-btns-more - 更多按钮

```vue
<vk-data-table
  :right-btns-more="table1.rightBtnsMore"
  @right-btns-more="onRightBtnsMore"
></vk-data-table>
```

```javascript
data() {
  return {
    table1: {
      rightBtnsMore: [
        {
          title: "更多操作",
          onClick: (item) => {
            console.log("更多操作：", item);
          }
        }
      ]
    }
  };
}
```

## 方法（Methods）

所有方法通过`this.$refs.table1.xxx()`调用。

### 数据操作

#### refresh - 刷新表格

```javascript
this.$refs.table1.refresh();
```

#### search - 查询（搜索）

```javascript
this.$refs.table1.search();
```

#### setTableData - 手动设置表格数据

```javascript
let list = [
  { _id: "001", username: "test" }
];
this.$refs.table1.setTableData(list);
```

### 获取数据

#### getCurrentRow - 获取当前选中行

```javascript
// 获取原始数据（修改会影响表格）
let info = this.$refs.table1.getCurrentRow(true);

// 获取数据副本（修改不影响表格）
let info = this.$refs.table1.getCurrentRow();
```

#### getTableData - 获取整个表格数据

```javascript
// 获取原始数据
let data = this.$refs.table1.getTableData();

// 获取数据副本
let data = vk.pubfn.copyObject(this.$refs.table1.getTableData());
```

#### getTableFormatterData - 获取格式化数据

```javascript
// 获取格式化数据（key为字段名）
let data = this.$refs.table1.getTableFormatterData();

// 获取格式化数据（key为中文标题）
let data = this.$refs.table1.getTableFormatterData({
  key: "title"
});
```

#### getMultipleSelection - 获取多选数据

```javascript
let rows = this.$refs.table1.getMultipleSelection();
console.log("选中的行：", rows);
```

### 详情操作

#### showDetail - 显示详情页

```javascript
this.$refs.table1.showDetail(item);
```

#### closeDetail - 关闭详情页

```javascript
this.$refs.table1.closeDetail();
```

### 行操作

#### deleteRows - 删除指定行（不删数据库）

```javascript
this.$refs.table1.deleteRows({
  ids: ["001", "002"],
  success: () => {
    vk.toast("删除成功");
  }
});
```

#### updateRows - 更新指定行（不更新数据库）

```javascript
// mode: update - 局部字段更新
this.$refs.table1.updateRows({
  mode: "update",
  rows: [
    { _id: "001", nickname: "新昵称" }
  ],
  success: () => {
    vk.toast("更新成功");
  }
});

// mode: set - 覆盖字段更新
this.$refs.table1.updateRows({
  mode: "set",
  rows: [
    { _id: "001", nickname: "新昵称" }
  ]
});
```

#### toggleRowSelection - 批量修改多选状态

```javascript
let arr = [];
let uTreeData = this.$refs.table1.getUTreeData();

arr.push({
  row: uTreeData[0],
  selected: true
});
arr.push({
  row: uTreeData[1],
  selected: false
});

this.$refs.table1.toggleRowSelection(arr);
```

#### getRowIndex - 获取指定行的index

```javascript
let index = this.$refs.table1.getRowIndex(item);
console.log("行索引：", index);
```

### 导出操作

#### exportExcel - 导出Excel

```javascript
// 导出当前页数据（含序号）
this.$refs.table1.exportExcel();

// 导出当前页数据（不含序号）
this.$refs.table1.exportExcel({
  showNo: false
});

// 表格首行锁定+可筛选
this.$refs.table1.exportExcel({
  freezeHeader: true,
  autoFilter: true
});

// 自定义导出
this.$refs.table1.exportExcel({
  fileName: "用户列表",
  original: false,
  columns: [
    { key: "_id", title: "ID", type: "text" },
    { key: "username", title: "用户名", type: "text" }
  ]
});

// 导出所有数据
this.$refs.table1.exportExcel({
  fileName: "全部数据",
  pageIndex: 1,
  pageSize: -1  // -1表示导出所有
});

// 导出自定义数据
this.$refs.table1.exportExcel({
  fileName: "自定义数据",
  data: [
    { a: 1, b: 2 },
    { a: 11, b: 22 }
  ],
  columns: [
    { key: "a", title: "标题A", type: "text" },
    { key: "b", title: "标题B", type: "text" }
  ]
});
```

## 完整示例

```vue
<template>
  <div>
    <vk-data-table
      ref="table1"
      action="admin/user/sys/getList"
      :columns="table1.columns"
      :selection="true"
      :pagination="true"
      @success="onSuccess"
      @detail="onDetail"
      @update="onUpdate"
      @delete="onDelete"
      @row-click="onRowClick"
      @selection-change="onSelectionChange"
    >
      <!-- 自定义按钮 -->
      <template v-slot:__operation="{ row }">
        <el-button @click="handleCustomClick(row)">自定义</el-button>
      </template>
    </vk-data-table>
  </div>
</template>

<script>
export default {
  data() {
    return {
      table1: {
        columns: [
          { key: "username", title: "用户名", type: "text", width: 150 },
          { key: "nickname", title: "昵称", type: "text", width: 150 }
        ]
      }
    };
  },
  methods: {
    // 事件处理
    onSuccess({ data, list, total }) {
      console.log("查询成功");
    },
    onDetail({ item }) {
      this.$refs.table1.showDetail(item);
    },
    onUpdate({ item }) {
      console.log("编辑：", item);
    },
    onDelete({ deleteFn }) {
      vk.confirm("确认删除？", () => {
        deleteFn();
      });
    },
    onRowClick(row) {
      console.log("单击行：", row);
    },
    onSelectionChange(rows) {
      console.log("选中：", rows);
    },
    handleCustomClick(row) {
      console.log("自定义按钮：", row);
    },
    // 方法调用
    refreshTable() {
      this.$refs.table1.refresh();
    },
    exportData() {
      this.$refs.table1.exportExcel({
        fileName: "用户列表",
        pageSize: -1
      });
    }
  }
};
</script>
```
