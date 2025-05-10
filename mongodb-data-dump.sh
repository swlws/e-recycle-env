#!/bin/bash

# 远程 MongoDB 配置
MONGODB_HOST="127.0.0.1"
MONGODB_PORT="27017"
MONGODB_USER="swlws"
MONGODB_PASSWORD="swlws@123!!!"
MONGODB_DB="swlws"

# 本地备份目录
BACKUP_BASE_DIR="$HOME/mongo_backups"

# 日期格式：YYYY-MM-DD
DATE=$(date +%F)
BACKUP_DIR="${BACKUP_BASE_DIR}/${MONGODB_DB}_${DATE}"

# 创建备份目录（如果不存在）
mkdir -p "$BACKUP_DIR"

echo "开始备份 MongoDB 数据库：$TARGET_DB（日期：$DATE）"

# 执行备份
mongodump \
  --host $MONGODB_HOST:$MONGODB_PORT \
  --username $MONGODB_USER \
  --password "$MONGODB_PASSWORD" \
  --authenticationDatabase "$MONGODB_DB" \
  --db "$MONGODB_DB" \
  --out "$BACKUP_DIR"

# 检查是否成功
if [ $? -eq 0 ]; then
  echo "✅ 备份成功：$BACKUP_DIR"
else
  echo "❌ 备份失败，请检查连接和权限"
  exit 1
fi
