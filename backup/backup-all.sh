#!/bin/bash
#=========================================
# 小腾服务器全自动备份脚本
# 备份内容：数据库 + 代码 + Nginx配置
# 保留策略：每日保留7天
#=========================================

set -euo pipefail
BACKUP_ROOT="/home/ubuntu/backups"
DATE=$(date +%Y%m%d_%H%M%S)
LOG="$BACKUP_ROOT/backup.log"
MYSQL_ROOT="Shanyinke2026!"
WEBROOT="/home/admin/web"

# 确保备份目录存在
mkdir -p "$BACKUP_ROOT/db" "$BACKUP_ROOT/code" "$BACKUP_ROOT/nginx"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG"
}

log "========== 备份开始 =========="

#-----------------------------------------------
# 1. 数据库备份（7个库）
#-----------------------------------------------
declare -A DBS=(
  ["article_cms"]="xianheng.org"
  ["sxzpw"]="sxzpw.cn"
  ["sxzpw_lifecycle"]="e0575.xyz"
  ["nav_db"]="e0575.org"
  ["myarticle"]="myarticle.com.cn"
  ["omni_db"]="omni.shanyin.xyz"
  ["server_admin"]="admin.shanyin.xyz"
)

for db in "${!DBS[@]}"; do
  site="${DBS[$db]}"
  out="$BACKUP_ROOT/db/${db}_${DATE}.sql.gz"
  log "备份数据库: $db ($site)"
  mysqldump -uroot -p"$MYSQL_ROOT" --single-transaction "$db" 2>/dev/null | gzip > "$out" || {
    log "ERROR: 数据库 $db 备份失败"
    continue
  }
  # 清理7天前
  find "$BACKUP_ROOT/db" -name "${db}_*.sql.gz" -mtime +7 -delete 2>/dev/null || true
done

#-----------------------------------------------
# 2. 代码备份（7个站点）
#-----------------------------------------------
SITES=(
  "xianheng.org"
  "sxzpw.cn"
  "e0575.xyz"
  "e0575.org"
  "myarticle.com.cn"
  "omni.shanyin.xyz"
  "admin.shanyin.xyz"
)

for site in "${SITES[@]}"; do
  srcdir="$WEBROOT/$site/public_html"
  out="$BACKUP_ROOT/code/${site}_${DATE}.tar.gz"
  if [ -d "$srcdir" ]; then
    log "备份代码: $site"
    sudo tar -czf "$out" -C "$srcdir" . 2>/dev/null
    find "$BACKUP_ROOT/code" -name "${site}_*.tar.gz" -mtime +7 -delete 2>/dev/null || true
  else
    log "跳过代码: $site (目录不存在)"
  fi
done

#-----------------------------------------------
# 3. Nginx 配置备份
#-----------------------------------------------
log "备份 Nginx 配置"
sudo tar -czf "$BACKUP_ROOT/nginx/nginx_conf_${DATE}.tar.gz" \
  /etc/nginx/conf.d/ \
  /etc/letsencrypt/ \
  /home/ubuntu/webapps/ 2>/dev/null
find "$BACKUP_ROOT/nginx" -name "nginx_conf_*.tar.gz" -mtime +7 -delete 2>/dev/null || true

log "========== 备份完成 =========="
log "备份占用空间:"
du -sh "$BACKUP_ROOT"/* | tee -a "$LOG"
