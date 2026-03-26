#!/bin/bash

# SPA 结构化数据提取脚本
# 用法：./structured-extract.sh --url <URL> --output <JSON_FILE> [OPTIONS]

set -e

# 默认值
DEFAULT_NAV_SELECTOR=".sidebar a"
USE_HEADED=false

# 解析参数
URL=""
OUTPUT_FILE=""
NAV_SELECTOR="$DEFAULT_NAV_SELECTOR"

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
        --nav-selector)
            NAV_SELECTOR="$2"
            shift 2
            ;;
        --headed)
            USE_HEADED=true
            shift
            ;;
        -h|--help)
            echo "用法: $0 --url <URL> --output <FILE> [OPTIONS]"
            echo ""
            echo "选项:"
            echo "  --url <URL>              文档网站URL（必需）"
            echo "  --output <FILE>          输出JSON文件路径（必需）"
            echo "  --nav-selector <CSS>     导航链接选择器（默认: $DEFAULT_NAV_SELECTOR）"
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

echo "🔍 结构化数据提取"
echo "📁 URL: $URL"
echo "📄 输出文件: $OUTPUT_FILE"
echo ""

# 构建 agent-browser 命令
if [[ "$USE_HEADED" == true ]]; then
    BROWSER_CMD="agent-browser --headed"
else
    BROWSER_CMD="agent-browser"
fi

# 1. 打开文档首页
echo "⏳ 打开文档首页..."
$BROWSER_CMD open "$URL"
$BROWSER_CMD wait --load networkidle

# 2. 提取文档结构
echo "📊 提取文档结构..."
STRUCTURE_JSON=$($BROWSER_CMD eval "
(() => {
    // 提取导航结构
    const navLinks = Array.from(document.querySelectorAll('$NAV_SELECTOR')).map(a => ({
        title: a.textContent.trim(),
        href: a.href,
        id: a.href.split('/').filter(Boolean).pop()
    }));
    
    // 提取页面元数据
    const metadata = {
        title: document.title,
        url: window.location.href,
        description: document.querySelector('meta[name=\"description\"]')?.content || '',
        language: document.documentElement.lang || 'unknown'
    };
    
    // 提取当前页面的标题层级结构
    const headings = Array.from(document.querySelectorAll('h1, h2, h3, h4, h5, h6')).map(h => ({
        level: parseInt(h.tagName.substring(1)),
        text: h.textContent.trim(),
        id: h.id
    }));
    
    return {
        metadata,
        navigation: navLinks,
        current_page: {
            headings
        }
    };
})()
")

# 保存结构化数据
echo "$STRUCTURE_JSON" | jq '.' > "$OUTPUT_FILE"

# 显示摘要
NAV_COUNT=$(echo "$STRUCTURE_JSON" | jq '.navigation | length')
HEADING_COUNT=$(echo "$STRUCTURE_JSON" | jq '.current_page.headings | length')
TITLE=$(echo "$STRUCTURE_JSON" | jq -r '.metadata.title')

echo ""
echo "✅ 提取完成！"
echo "📄 页面标题: $TITLE"
echo "🔗 导航链接数: $NAV_COUNT"
echo "📑 标题层级数: $HEADING_COUNT"
echo "📂 文件保存: $OUTPUT_FILE"

# 显示JSON结构预览
echo ""
echo "📋 数据结构预览:"
echo "$STRUCTURE_JSON" | jq 'keys'