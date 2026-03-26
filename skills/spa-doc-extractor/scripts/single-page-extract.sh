#!/bin/bash

# SPA 单页面提取脚本
# 用法：./single-page-extract.sh --url <URL> --output <FILE> [OPTIONS]

set -e

# 默认值
DEFAULT_CONTENT_SELECTOR="main"
USE_HEADED=false
SAVE_SCREENSHOT=false

# 解析参数
URL=""
OUTPUT_FILE=""
CONTENT_SELECTOR="$DEFAULT_CONTENT_SELECTOR"

while [[ $# -gt 0 ]]; do
    case $1 in
        --url)
            URL="$2"
            shift 2
            ;;
        --output)
            OUTPUT_FILE="$2"
            shift 2
            ;;
        --content-selector)
            CONTENT_SELECTOR="$2"
            shift 2
            ;;
        --screenshot)
            SAVE_SCREENSHOT=true
            shift
            ;;
        --headed)
            USE_HEADED=true
            shift
            ;;
        -h|--help)
            echo "用法: $0 --url <URL> --output <FILE> [OPTIONS]"
            echo ""
            echo "选项:"
            echo "  --url <URL>              文档页面URL（必需）"
            echo "  --output <FILE>          输出文件路径（必需）"
            echo "  --content-selector <CSS>  内容区域选择器（默认: $DEFAULT_CONTENT_SELECTOR）"
            echo "  --screenshot             同时保存页面截图"
            echo "  --headed                 显示浏览器窗口"
            echo "  -h, --help               显示帮助信息"
            exit 0
            ;;
        *)
            echo "未知选项: $1"
            exit 1
            ;;
    esac
done

# 检查必需参数
if [[ -z "$URL" || -z "$OUTPUT_FILE" ]]; then
    echo "错误: 缺少必需参数"
    echo "用法: $0 --url <URL> --output <FILE> [OPTIONS]"
    echo "使用 -h 或 --help 查看帮助"
    exit 1
fi

# 创建输出目录
OUTPUT_DIR=$(dirname "$OUTPUT_FILE")
mkdir -p "$OUTPUT_DIR"

echo "📖 提取单页面文档"
echo "📁 URL: $URL"
echo "📄 输出文件: $OUTPUT_FILE"
echo ""

# 构建 agent-browser 命令
if [[ "$USE_HEADED" == true ]]; then
    BROWSER_CMD="agent-browser --headed"
else
    BROWSER_CMD="agent-browser"
fi

# 1. 打开页面
echo "⏳ 打开页面..."
$BROWSER_CMD open "$URL"
$BROWSER_CMD wait --load networkidle

# 2. 获取页面结构
echo "🔍 分析页面结构..."
$BROWSER_CMD snapshot -i

# 3. 提取内容
echo "📝 提取内容..."
$BROWSER_CMD get text @content > "$OUTPUT_FILE"

# 4. 可选：保存截图
if [[ "$SAVE_SCREENSHOT" == true ]]; then
    SCREENSHOT_FILE="${OUTPUT_FILE%.*}.png"
    echo "📷 保存截图: $SCREENSHOT_FILE"
    $BROWSER_CMD screenshot --full "$SCREENSHOT_FILE"
fi

# 5. 获取页面标题
TITLE=$($BROWSER_CMD get title)
echo ""
echo "✅ 提取完成！"
echo "📄 标题: $TITLE"
echo "📂 文件保存: $OUTPUT_FILE"
if [[ "$SAVE_SCREENSHOT" == true ]]; then
    echo "🖼️  截图保存: $SCREENSHOT_FILE"
fi