#!/bin/bash
# ============================================================
# check_all.sh - 全站巡检脚本
# 用途：检查所有站点的HTTP/HTTPS/统计接口状态
# 用法：./check_all.sh
# 依赖：curl
# 作者：小飞
# 日期：2026-07-19
# ============================================================

# 小腾站群
XIAOTENG_SITES="xianheng.org myarticle.com.cn sxzpw.cn e0575.xyz e0575.org omni.shanyin.xyz admin.shanyin.xyz"

# 小马站群
XIAOMA_SITES="shaoda.net xiaodou.net yuezhou.org"

echo "========================================="
echo "全站巡检 - $(date '+%Y-%m-%d %H:%M:%S')"
echo "========================================="

check_site() {
    local site=$1
    local http_code=$(curl -s -o /dev/null -w "%{http_code}" "https://$site/" 2>/dev/null)
    local https_code=$(curl -s -o /dev/null -w "%{http_code}" "https://$site/" -k 2>/dev/null)
    local track_code=$(curl -s -o /dev/null -w "%{http_code}" "https://$site/track.php?path=/" 2>/dev/null)
    
    if [ "$http_code" = "200" ]; then
        http_status="✅ 200"
    else
        http_status="❌ $http_code"
    fi
    
    if [ "$https_code" = "200" ]; then
        https_status="✅ 200"
    else
        https_status="❌ $https_code"
    fi
    
    if [ "$track_code" = "200" ]; then
        track_status="✅ 200"
    else
        track_status="❌ $track_code"
    fi
    
    printf "%-22s HTTP:%s | HTTPS:%s | track:%s\n" "$site" "$http_status" "$https_status" "$track_status"
}

echo ""
echo "【小腾站群】"
for site in $XIAOTENG_SITES; do
    check_site "$site"
done

echo ""
echo "【小马站群】"
for site in $XIAOMA_SITES; do
    check_site "$site"
done

echo ""
echo "巡检完成！"
