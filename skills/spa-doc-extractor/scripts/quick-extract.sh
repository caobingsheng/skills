#!/bin/bash
# SPA 文档快速提取脚本
# 使用方法: ./quick-extract.sh <URL> <SELECTOR> [OUTPUT_FILE]

set -e

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 显示帮助信息
show_help() {
    echo "SPA 文档快速提取工具"
    echo ""
    echo "使用方法:"
    echo "  $0 <URL> <SELECTOR> [OUTPUT_FILE]"
    echo ""
    echo "参数:"
    echo "  URL          - 要提取的文档网址"
    echo "  SELECTOR     - CSS 选择器（主内容区域）"
    echo "  OUTPUT_FILE  - 输出文件名（可选，默认为 output.md）"
    echo ""
    echo "示例:"
    echo "  $0 https://element.eleme.cn/#/zh-CN/component/quickstart .page-component__content"
    echo "  $0 https://router.vuejs.org/zh/guide/ .theme-default-content vue-router.md"
    echo ""
    echo "常见选择器:"
    echo "  Element UI:      .page-component__content"
    echo "  Ant Design:      .markdown"
    echo "  VuePress:        .theme-default-content"
    echo "  VitePress:       .VPDoc"
    echo "  通用:            main, article, .content"
}

# 检查参数
if [ $# -lt 2 ]; then
    show_help
    exit 1
fi

URL="$1"
SELECTOR="$2"
OUTPUT="${3:-output.md}"

echo -e "${BLUE}=== SPA 文档提取工具 ===${NC}"
echo ""
echo "URL:      $URL"
echo "选择器:   $SELECTOR"
echo "输出文件: $OUTPUT"
echo ""

# 检查 npx 是否可用
if ! command -v npx &> /dev/null; then
    echo -e "${RED}错误: 未找到 npx 命令${NC}"
    echo "请先安装 Node.js: https://nodejs.org/"
    exit 1
fi

# 检查 agent-browser 是否可用
echo -e "${BLUE}[1/4]${NC} 检查 agent-browser..."
if ! npx agent-browser --version &> /dev/null; then
    echo -e "${RED}错误: agent-browser 不可用${NC}"
    echo "正在安装 agent-browser..."
    npx -y agent-browser@latest
fi
echo -e "${GREEN}✓${NC} agent-browser 已就绪"
echo ""

# 打开页面
echo -e "${BLUE}[2/4]${NC} 打开页面..."
npx agent-browser open "$URL"
echo -e "${GREEN}✓${NC} 页面已打开"
echo ""

# 等待加载
echo -e "${BLUE}[3/4]${NC} 等待页面加载..."
npx agent-browser wait --load networkidle
echo -e "${GREEN}✓${NC} 页面加载完成"
echo ""

# 提取内容
echo -e "${BLUE}[4/4]${NC} 提取内容..."
npx agent-browser get text "$SELECTOR" > "$OUTPUT"

# 检查输出
if [ -s "$OUTPUT" ]; then
    FILE_SIZE=$(wc -c < "$OUTPUT" | tr -d ' ')
    echo -e "${GREEN}✓${NC} 内容已提取 ($FILE_SIZE 字节)"
    echo ""
    echo -e "${GREEN}提取完成！${NC}"
    echo "文件已保存到: $OUTPUT"
    echo ""
    echo "提示: 输出文件可能需要手动格式化"
else
    echo -e "${RED}✗${NC} 提取失败或内容为空"
    echo "请检查:"
    echo "  1. URL 是否正确"
    echo "  2. 选择器是否正确"
    echo "  3. 页面是否完全加载"
    rm -f "$OUTPUT"
    exit 1
fi
