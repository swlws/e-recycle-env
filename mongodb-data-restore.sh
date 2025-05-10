#!/bin/bash

# === MongoDB 配置 ===
MONGODB_HOST="127.0.0.1"
MONGODB_PORT="27017"
MONGODB_USER="swlws"
MONGODB_PASSWORD="swlws@123!!!"
AUTH_DB="swlws"
TARGET_DB="swlws"

# === 备份目录配置 ===
BACKUP_BASE_DIR="$HOME/mongo_backups"

# 查找最新备份目录
LATEST_BACKUP=$(ls -td "${BACKUP_BASE_DIR}/${TARGET_DB}_"* 2>/dev/null | head -n1)
if [ -z "$LATEST_BACKUP" ]; then
    echo "❌ 未找到任何备份目录，退出"
    exit 1
fi

BACKUP_DATA_DIR="$LATEST_BACKUP"

# 确保数据库子目录存在
if [ ! -d "${BACKUP_DATA_DIR}/${TARGET_DB}" ]; then
    echo "❌ 数据库目录不存在：${BACKUP_DATA_DIR}/${TARGET_DB}"
    exit 1
fi

# 可选：清理非 bson/metadata.json 文件（如 prelude.json）
echo "🧹 清理非 BSON 文件..."
find "${BACKUP_DATA_DIR}/${TARGET_DB}" -type f ! -name "*.bson" ! -name "*.metadata.json" -delete

# === 开始恢复 ===
echo "♻️  开始从 ${BACKUP_DATA_DIR} 恢复 MongoDB 数据..."

mongorestore \
  --host "$MONGODB_HOST" \
  --port "$MONGODB_PORT" \
  --username "$MONGODB_USER" \
  --password "$MONGODB_PASSWORD" \
  --authenticationDatabase "$AUTH_DB" \
  --drop \
  --dir="$BACKUP_DATA_DIR"

# 判断结果
if [ $? -eq 0 ]; then
    echo "✅ 数据恢复成功"
else
    echo "❌ 数据恢复失败，请检查日志"
    exit 1
fi
