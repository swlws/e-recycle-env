#!/bin/bash

# === 锁文件机制，防止并发运行 ===
LOCK_FILE="/tmp/mongo_restore.lock"

if [ -f "$LOCK_FILE" ]; then
    echo "⚠️ 上一次恢复仍在运行，跳过本次执行：$(date)"
    exit 0
fi

# 设置锁 + 确保退出时删除
trap "rm -f $LOCK_FILE" EXIT
touch "$LOCK_FILE"

# === MongoDB 配置 ===
MONGODB_HOST="127.0.0.1"
MONGODB_PORT="27017"
MONGODB_USER="swlws"
MONGODB_PASSWORD="swlws@123!!!"
AUTH_DB="swlws"
TARGET_DB="swlws"

# === 备份配置 ===
DATE=$(date +%F)
BACKUP_BASE_DIR="$HOME/mongo_backups"
BACKUP_DIR="${BACKUP_BASE_DIR}/${TARGET_DB}_${DATE}"

mkdir -p "$BACKUP_DIR"

echo "开始备份 MongoDB 数据库：$TARGET_DB（日期：$DATE）"

# === 执行备份 ===
mongodump \
  --host "$MONGODB_HOST:$MONGODB_PORT" \
  --username "$MONGODB_USER" \
  --password "$MONGODB_PASSWORD" \
  --authenticationDatabase "$AUTH_DB" \
  --db "$TARGET_DB" \
  --out "$BACKUP_DIR"

if [ $? -eq 0 ]; then
  echo "✅ 备份成功：$BACKUP_DIR"
else
  echo "❌ 备份失败，请检查连接或权限"
  exit 1
fi
