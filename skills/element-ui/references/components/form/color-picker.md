# ColorPicker 颜色选择器

用于颜色选择,支持多种格式。

## 基础用法

使用 v-model 与 ColorPicker 绑定,默认情况下,ColorPicker 使用 hex 格式。

```vue
<div class="block">
  <span class="demonstration">有默认值</span>
  <el-color-picker v-model="color1"></el-color-picker>
</div>
<div class="block">
  <span class="demonstration">无默认值</span>
  <el-color-picker v-model="color2"></el-color-picker>
</div>

<script>
export default {
  data() {
    return {
      color1: '#409EFF',
      color2: null
    }
  }
}
</script>
```

## 选择透明度

ColorPicker 支持普通颜色,也支持带 Alpha 通道的颜色,通过 `show-alpha` 属性即可控制是否支持透明度的选择。

```vue
<el-color-picker v-model="color" show-alpha></el-color-picker>

<script>
export default {
  data() {
    return {
      color: 'rgba(19, 206, 102, 0.8)'
    }
  }
}
</script>
```

## 预定义颜色

ColorPicker 支持预定义颜色。

```vue
<el-color-picker
  v-model="color"
  show-alpha
  :predefine="predefineColors">
</el-color-picker>

<script>
export default {
  data() {
    return {
      color: 'rgba(255, 69, 0, 0.68)',
      predefineColors: [
        '#ff4500',
        '#ff8c00',
        '#ffd700',
        '#90ee90',
        '#00ced1',
        '#1e90ff',
        '#c71585',
        'rgba(255, 69, 0, 0.68)',
        'rgb(255, 120, 0)',
        'hsv(51, 100, 98)',
        'hsva(120, 40, 94, 0.5)',
        'hsl(181, 100%, 37%)',
        'hsla(209, 100%, 56%, 0.73)',
        '#c7158577'
      ]
    }
  }
}
</script>
```

## 尺寸

```vue
<el-color-picker v-model="color"></el-color-picker>
<el-color-picker v-model="color" size="medium"></el-color-picker>
<el-color-picker v-model="color" size="small"></el-color-picker>
<el-color-picker v-model="color" size="mini"></el-color-picker>

<script>
export default {
  data() {
    return {
      color: '#409EFF'
    }
  }
}
</script>
```

## Attributes

| 参数 | 说明 | 类型 | 可选值 | 默认值 |
|------|------|------|--------|--------|
| value / v-model | 绑定值 | string | — | — |
| disabled | 是否禁用 | boolean | — | false |
| size | 尺寸 | string | medium / small / mini | — |
| show-alpha | 是否支持透明度选择 | boolean | — | false |
| color-format | 绑定值的格式 | string | hsl / hsv / hex / rgb | hex(当 show-alpha 为 false)/ rgb(当 show-alpha 为 true) |
| popper-class | ColorPicker 下拉框的类名 | string | — | — |
| predefine | 预定义颜色 | array | — | — |

## Events

| 事件名称 | 说明 | 回调参数 |
|----------|------|----------|
| change | 当绑定值变化时触发 | 当前值 |
| active-change | 面板中当前显示的颜色发生改变时触发 | 当前值 |

## 最佳实践

1. **透明度支持**: 开启`show-alpha`支持透明度选择,适用于需要半透明颜色的场景
2. **颜色格式**: 使用`color-format`指定绑定值的格式(hex/rgb/hsl/hsv)
3. **预定义颜色**: 使用`predefine`提供常用颜色选项,提升用户体验
4. **尺寸选择**: 根据页面布局选择合适的尺寸(medium/small/mini)
5. **禁用状态**: 使用`disabled`禁用颜色选择器,适用于只读场景
6. **事件监听**: 监听`change`事件获取最终选择的颜色,`active-change`实时获取面板颜色变化
7. **默认值**: 设置默认值,避免初始状态为空
8. **RGBA格式**: 支持RGBA格式,可以精确控制透明度
