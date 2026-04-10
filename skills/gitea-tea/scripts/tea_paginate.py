#!/usr/bin/env python3
"""
Tea CLI 通用分页获取工具

用途：自动处理 Tea CLI 列表命令的分页逻辑，获取全部数据。
背景：Tea CLI 所有列表命令受 Gitea API 服务端限制，最大每页 50 条。
      --limit 参数超过 50 会被静默截断，不报错也不提示。
      因此任何需要全量数据的场景都必须循环分页获取。

用法：
    # 基础用法
    python tea_paginate.py --command "labels list" --repo "owner/repo"

    # 获取全部 issues（包括已关闭的）
    python tea_paginate.py --command "issues list --state all" --repo "owner/repo"

    # 获取全部 Pull Requests
    python tea_paginate.py --command "pulls list --state all" --repo "owner/repo"

    # 指定登录名（多账号场景）
    python tea_paginate.py --command "repos list" --login my-gitea

    # 调试模式（查看分页过程）
    python tea_paginate.py --command "issues list" --repo "owner/repo" --debug

输出：JSON 数组（stdout），包含所有分页的合并结果

退出码：
    0  成功
    1  参数错误
    2  Tea CLI 不可用或未登录
    3  分页过程中发生错误（部分数据可能已输出）

支持的命令：
    所有返回列表的 tea 命令，例如：
    - issues list
    - pulls list
    - labels list
    - releases list
    - milestones list
    - branches list
    - repos list
    - orgs list
    - notifications list
    - 等等
"""

import subprocess
import json
import argparse
import sys
from typing import List, Dict, Any, Optional


def run_tea(args: List[str], debug: bool = False) -> subprocess.CompletedProcess:
    """
    执行 tea 命令

    Args:
        args: tea 命令参数列表
        debug: 是否打印执行的命令

    Returns:
        subprocess.CompletedProcess 对象
    """
    cmd = ["tea"] + args
    if debug:
        print(f"[执行] tea {' '.join(args)}", file=sys.stderr)

    return subprocess.run(
        cmd,
        capture_output=True,
        text=True,
        encoding="utf-8",
        errors="replace"
    )


def check_tea_available() -> tuple[bool, str]:
    """
    检查 tea CLI 是否可用且已登录

    Returns:
        (是否可用, 状态消息)
    """
    # 检查 tea 是否安装
    result = run_tea(["--version"])
    if result.returncode != 0:
        return False, "tea CLI 未安装。安装方式：\n" \
                      "  - macOS: brew install tea\n" \
                      "  - Linux: curl -sL https://dl.gitea.io/tea/main/tea-main-linux-amd64 -o tea && chmod +x tea && sudo mv tea /usr/local/bin/\n" \
                      "  - Windows: scoop install tea"

    # 检查是否已登录
    result = run_tea(["whoami"])
    if result.returncode != 0:
        return False, "tea CLI 未登录。请运行: tea login add"

    return True, f"tea CLI 已就绪，当前用户: {result.stdout.strip()}"


def paginate(
    command_parts: List[str],
    repo: Optional[str] = None,
    login: Optional[str] = None,
    page_size: int = 50,
    debug: bool = False
) -> List[Dict[str, Any]]:
    """
    通用分页获取函数

    Args:
        command_parts: tea 子命令列表，如 ["labels", "list"] 或 ["issues", "list", "--state", "all"]
        repo: 仓库标识，如 "owner/repo"（可选，tea 可自动检测）
        login: 指定登录名（可选）
        page_size: 每页大小，默认 50（Tea CLI 硬上限）
        debug: 是否打印调试信息到 stderr

    Returns:
        合并后的全部结果列表

    Raises:
        RuntimeError: Tea CLI 不可用或执行失败
    """
    # 强制限制 page_size 不超过 50
    if page_size > 50:
        original_size = page_size
        page_size = 50
        if debug:
            print(
                f"[警告] page_size={original_size} 超过 Tea CLI 硬上限 50，已自动调整为 50",
                file=sys.stderr
            )

    all_results: List[Dict[str, Any]] = []
    page = 1
    total_fetched = 0

    if debug:
        print(f"[开始] 分页获取命令: tea {' '.join(command_parts)}", file=sys.stderr)
        if repo:
            print(f"[仓库] {repo}", file=sys.stderr)

    while True:
        # 构建完整命令
        args = list(command_parts)

        if repo:
            args.extend(["--repo", repo])

        if login:
            args.extend(["--login", login])

        args.extend([
            "--limit", str(page_size),
            "--page", str(page),
            "--output", "json"
        ])

        if debug:
            print(f"\n[分页] 正在获取第 {page} 页...", file=sys.stderr)

        # 执行 tea 命令
        result = run_tea(args, debug=False)

        if result.returncode != 0:
            error_msg = result.stderr.strip() or "Unknown error"
            raise RuntimeError(
                f"tea 命令执行失败（第 {page} 页）:\n"
                f"  命令: tea {' '.join(args)}\n"
                f"  错误: {error_msg}"
            )

        # 解析 JSON 输出
        stdout = result.stdout.strip()
        if not stdout:
            if debug:
                print(f"[分页] 第 {page} 页返回空结果，停止分页", file=sys.stderr)
            break

        try:
            page_data = json.loads(stdout)
        except json.JSONDecodeError as e:
            raise RuntimeError(
                f"JSON 解析失败（第 {page} 页）:\n"
                f"  错误: {e}\n"
                f"  原始输出（前 200 字符）: {stdout[:200]}"
            )

        # 处理返回结果
        if not page_data:
            if debug:
                print(f"[分页] 第 {page} 页无数据，停止分页", file=sys.stderr)
            break

        # 某些命令可能返回单个对象而非数组，包装为数组
        if not isinstance(page_data, list):
            page_data = [page_data]

        # 累加结果
        all_results.extend(page_data)
        total_fetched += len(page_data)

        if debug:
            print(
                f"[分页] 第 {page} 页获取 {len(page_data)} 条，累计 {total_fetched} 条",
                file=sys.stderr
            )

        # 如果返回数量 < page_size，说明是最后一页
        if len(page_data) < page_size:
            if debug:
                print(
                    f"[分页] 第 {page} 页返回 {len(page_data)} 条 < {page_size}，为最后一页",
                    file=sys.stderr
                )
            break

        page += 1

        # 安全限制：防止无限循环（虽然不太可能）
        if page > 10000:
            raise RuntimeError(
                f"分页超过 10000 页，可能存在问题。\n"
                f"已获取 {total_fetched} 条数据。"
            )

    if debug:
        print(f"\n[完成] 共获取 {total_fetched} 条数据，{page} 页", file=sys.stderr)

    return all_results


def main():
    parser = argparse.ArgumentParser(
        description="Tea CLI 通用分页获取工具 - 自动获取所有分页数据",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
示例：
  # 获取全部 labels
  %(prog)s --command "labels list" --repo "owner/repo"

  # 获取全部 issues（包括已关闭的）
  %(prog)s --command "issues list --state all" --repo "owner/repo"

  # 获取全部 Pull Requests
  %(prog)s --command "pulls list --state all" --repo "owner/repo"

  # 使用调试模式查看分页过程
  %(prog)s --command "issues list" --repo "owner/repo" --debug

  # 指定登录名（多账号场景）
  %(prog)s --command "repos list" --login my-gitea

支持的命令：
  所有返回列表的 tea 命令：issues list, pulls list, labels list,
  releases list, milestones list, repos list, orgs list 等

注意事项：
  - Tea CLI 有服务端硬限制，最大每页 50 条数据
  - --limit 参数超过 50 会被静默截断，不会有任何提示
  - 本脚本自动处理分页逻辑，确保获取全部数据

更多帮助：
  参见 ../references/pagination.md
        """
    )

    parser.add_argument(
        "--command", "-c",
        required=True,
        help='tea 子命令，如 "labels list" 或 "issues list --state all"'
    )
    parser.add_argument(
        "--repo", "-r",
        help="仓库标识，如 owner/repo（可选，tea 可自动检测）"
    )
    parser.add_argument(
        "--login", "-l",
        help="指定 Gitea 登录名（可选，多账号场景）"
    )
    parser.add_argument(
        "--page-size", "-s",
        type=int,
        default=50,
        help="每页大小（默认 50，最大 50，超出自动调整）"
    )
    parser.add_argument(
        "--debug",
        action="store_true",
        help="打印详细调试信息到 stderr"
    )

    args = parser.parse_args()

    # 检查 tea 可用性
    available, msg = check_tea_available()
    if not available:
        print(json.dumps({"error": msg}, ensure_ascii=False), file=sys.stderr)
        sys.exit(2)

    if args.debug:
        print(f"[状态] {msg}", file=sys.stderr)

    # 解析命令字符串为列表
    command_parts = args.command.split()

    # 验证命令是否是列表命令（简单检查）
    if len(command_parts) < 2 or command_parts[-1] != "list":
        print(
            json.dumps({
                "warning": f"命令 '{args.command}' 可能不是列表命令，请确认是否需要分页"
            }, ensure_ascii=False),
            file=sys.stderr
        )

    try:
        results = paginate(
            command_parts=command_parts,
            repo=args.repo,
            login=args.login,
            page_size=args.page_size,
            debug=args.debug
        )

        # 输出 JSON 数组到 stdout（格式化，便于阅读）
        print(json.dumps(results, ensure_ascii=False, indent=2))

        # 输出统计信息到 stderr（如果不在调试模式，也输出基本统计）
        if not args.debug and len(results) > 0:
            print(
                json.dumps({
                    "total": len(results),
                    "pages": (len(results) + 49) // 50  # 估算页数
                }, ensure_ascii=False),
                file=sys.stderr
            )

        sys.exit(0)

    except RuntimeError as e:
        print(json.dumps({"error": str(e)}, ensure_ascii=False), file=sys.stderr)
        sys.exit(3)

    except KeyboardInterrupt:
        print(json.dumps({"error": "用户中断"}, ensure_ascii=False), file=sys.stderr)
        sys.exit(130)


if __name__ == "__main__":
    main()