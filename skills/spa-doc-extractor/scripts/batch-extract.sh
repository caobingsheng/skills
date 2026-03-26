#!/bin/bash

# SPA 文档批量提取脚本
# 用法：./batch-extract.sh --url <URL> --output <DIR> [OPTIONS]

set -e

# 默认值
DEFAULT_SELECTOR=".sidebar a"
DEFAULT_CONTENT_SELECTOR="main"
DEFAULT_DELAY=1000

# 解析参数
URL=""
OUTPUT_DIR=""
SELECTOR="$DEFAULT_SELECTOR"
CONTENT_SELECTOR="$DEFAULT_CONTENT_SELECTOR"
DELAY="$DEFAULT_DELAY"
USE_HEADED=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --url)
            URL="$2"
            shift 2
            ;;
        --output)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        --selector)
            SELECTOR="$2"
            shift 2
            ;;
        --content-selector)
            CONTENT_SELECTOR="$2"
            shift 2
            ;;
        --delay)
            DELAY="$2"
            shift 2
            ;;
        --headed)
            USE_HEADED=true
            shift
            ;;
        -h|--help)
            echo "用法: $0 --url <URL> --output <DIR> [OPTIONS]"
            echo ""
            echo "选项:"
            echo "  --url <URL>              文档网站URL（必需）"
            echo "  --output <DIR>            输出目录（必需）"
            echo "  --selector <CSS>          侧边栏链接选择器（默认: $DEFAULT_SELECTOR）"
            echo "  --content-selector <CSS>  内容区域选择器（默认: $DEFAULT_CONTENT_SELECTOR）"
            echo "  --delay <ms>              请求延迟毫秒数（默认: $DEFAULT_DELAY）"
            echo "  --headed                  显示浏览器窗口"
            echo "  -h, --help                显示帮助信息"
            exit 0
            ;;
        *)
            echo "未知选项: $1"
            exit 1
            ;;
    esac
done

# 检查必需参数
if [[ -z "$URL" || -z "$OUTPUT_DIR" ]]; then
    echo "错误: 缺少必需参数"
    echo "用法: $0 --url <URL> --output <DIR> [OPTIONS]"
    echo "使用 -h 或 --help 查看帮助"
    exit 1
fi

# 创建输出目录
mkdir -p "$OUTPUT_DIR"

echo "🚀 开始提取文档"
echo "📁 URL: $URL"
echo "📂 输出目录: $OUTPUT_DIR"
echo ""

# 构建 agent-browser 命令
if [[ "$USE_HEADED" == true ]]; then
    BROWSER_CMD="agent-browser --headed"
else
    BROWSER_CMD="agent-browser"
fi

# 1. 打开文档首页
echo "📖 打开文档首页..."
$BROWSER_CMD open "$URL"
$BROWSER_CMD wait --load networkidle

# 2. 获取所有文档链接
echo "🔗 获取文档链接结构..."
LINKS_JSON=$($BROWSER_CMD eval "
Array.from(document.querySelectorAll('$SELECTOR')).map(a => ({
    title: a.textContent.trim(),
    href: a.href
}))
")

# 保存链接列表
echo "$LINKS_JSON" | jq '.' > "$OUTPUT_DIR/links.json"
LINK_COUNT=$(echo "$LINKS_JSON" | jq 'length')
echo "✅ 发现 $LINK_COUNT 个文档页面"

# 3. 遍历每个链接并提取内容
echo ""
echo "📝 开始提取文档内容..."

for i in $(seq 0 $((LINK_COUNT - 1))); do
    LINK=$(echo "$LINKS_JSON" | jq ".[$i]")
    TITLE=$(echo "$LINK" | jq -r '.title')
    HREF=$(echo "$LINK" | jq -r '.href')
    
    # 清理标题作为文件名
    FILENAME=$(echo "$TITLE" | sed 's/[^a-zA-Z0-9\u4e00-\u9fa5]/_/g' | tr -s '_')
    
    echo "  [$((i+1))/$LINK_COUNT] 提取: $TITLE"
    
    # 导航到页面
    $BROWSER_CMD open "$HREF"
    $BROWSER_CMD wait --load networkidle
    $BROWSER_CMD snapshot -i
    
    # 提取内容
    $BROWSER_CMD get text @content > "$OUTPUT_DIR/${FILENAME}.md"
    
    # 截图
    $BROWSER_CMD screenshot "$OUTPUT_DIR/${FILENAME}.png"
    
    # 添加延迟
    sleep $((DELAY / 1000))
done

echo ""
echo "✅ 提取完成！"
echo "📊 共提取 $LINK_COUNT 个文档页面"
echo "📂 文件保存在: $OUTPUT_DIR"