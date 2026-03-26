# InfiniteScroll 无限滚动

滚动至底部时,加载更多数据。

## 基础用法

在要实现滚动加载的列表上上添加`v-infinite-scroll`,并赋值相应的加载方法,可实现滚动到底部时自动执行加载方法。

```vue
<template>
  <ul class="infinite-list" v-infinite-scroll="load" style="overflow:auto">
    <li v-for="i in count" class="infinite-list-item">{{ i }}</li>
  </ul>
</template>

<script>
export default {
  data () {
    return {
      count: 0
    }
  },
  methods: {
    load () {
      this.count += 2
    }
  }
}
</script>
```

## 禁用加载

```vue
<template>
  <div class="infinite-list-wrapper" style="overflow:auto">
    <ul
      class="list"
      v-infinite-scroll="load"
      infinite-scroll-disabled="disabled">
      <li v-for="i in count" class="list-item">{{ i }}</li>
    </ul>
    <p v-if="loading">加载中...</p>
    <p v-if="noMore">没有更多了</p>
  </div>
</template>

<script>
export default {
  data () {
    return {
      count: 10,
      loading: false
    }
  },
  computed: {
    noMore () {
      return this.count >= 20
    },
    disabled () {
      return this.loading || this.noMore
    }
  },
  methods: {
    load () {
      this.loading = true
      setTimeout(() => {
        this.count += 2
        this.loading = false
      }, 2000)
    }
  }
}
</script>
```

## Attributes

| 参数 | 说明 | 类型 | 可选值 | 默认值 |
|------|------|------|--------|--------|
| infinite-scroll-disabled | 是否禁用 | boolean | — | false |
| infinite-scroll-delay | 节流时延,单位为ms | number | — | 200 |
| infinite-scroll-distance | 触发加载的距离阈值,单位为px | number | — | 0 |
| infinite-scroll-immediate | 是否立即执行加载方法,以防初始状态下内容无法撑满容器。 | boolean | — | true |

## 最佳实践

1. **滚动容器**: 确保滚动容器设置了`overflow:auto`或`overflow:scroll`,否则无法触发滚动事件
2. **禁用加载**: 使用`infinite-scroll-disabled`控制加载状态,避免重复加载或加载中继续触发
3. **节流优化**: 通过`infinite-scroll-delay`设置节流时延,避免频繁触发加载方法
4. **距离阈值**: 使用`infinite-scroll-distance`设置触发加载的距离阈值,提前加载提升体验
5. **立即加载**: 默认`infinite-scroll-immediate`为true,初始内容不足时会立即加载,可设为false禁用
6. **加载状态**: 在加载方法中设置loading状态,配合禁用属性避免重复加载
7. **结束判断**: 通过计算属性判断是否还有更多数据,设置noMore状态并禁用加载
