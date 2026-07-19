#!/bin/bash
# ============================================================
# sitemap_generator.sh - 生成站点sitemap.xml
# 用途：生成指定站点的XML sitemap
# 用法：./sitemap_generator.sh <站点名> <域名> <PHP路径>
# 依赖：curl, mysql/mariadb
# 作者：小飞
# 日期：2026-07-19
# ============================================================

SITE_NAME=${1:-"xianheng"}
DOMAIN=${2:-"xianheng.org"}
PHP_PATH=${3:-"/var/www/html"}

SITEMAP_FILE="${SITE_NAME}_sitemap.xml"

echo "正在生成 ${DOMAIN} 的 sitemap..."

# 检测是否支持PHP
if command -v php &> /dev/null; then
    php ${PHP_PATH}/sitemap.php > /tmp/${SITEMAP_FILE} 2>/dev/null
    if [ $? -eq 0 ]; then
        echo "✅ sitemap生成成功：/tmp/${SITEMAP_FILE}"
        echo "   访问地址：https://${DOMAIN}/sitemap.xml"
    else
        echo "❌ sitemap生成失败"
    fi
else
    echo "❌ 未找到PHP，跳过生成"
fi
