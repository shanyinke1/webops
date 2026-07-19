#!/bin/bash
# ============================================================
# security_scan.sh - PHP危险函数扫描
# 用途：扫描所有PHP文件是否有 exec/shell_exec/system/popen 危险调用
# 用法：./security_scan.sh <目录>
# 依赖：grep, find
# 作者：小飞
# 日期：2026-07-19
# ============================================================

TARGET=${1:-"/home/ubuntu/webapps"}
echo "扫描目录: $TARGET"
echo "========================================="

# 危险函数模式（排除 escapeshellarg 保护的）
pattern='(exec\s*\(|shell_exec\s*\(|system\s*\(|popen\s*\()'

# 找所有PHP文件，忽略 vendor/node_modules/backup
echo ""
echo "【高危：直接拼用户输入】"
echo "（shell命令 + 用户输入 且 未用 escapeshellarg）"
echo "---"
grep -rn 'shell_exec\|exec\s*(|system\s*(|popen\s*(' "$TARGET" --include="*.php" 2>/dev/null | \
    grep -v 'escapeshellarg' | \
    grep -v '//\|#' | \
    grep -E '\$_(GET|POST|REQUEST|COOKIE|SERVER)' | \
    head -20

echo ""
echo "【中危：有危险函数但无 escapeshellarg】"
echo "（可能没事，但需要人工确认）"
echo "---"
grep -rn 'shell_exec\|exec\s*(|system\s*\(|popen\s*(' "$TARGET" --include="*.php" 2>/dev/null | \
    grep -v 'escapeshellarg' | \
    grep -v '//\|#' | \
    grep -v '\$_' | \
    head -20

echo ""
echo "扫描完成"
