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

export PATH=/usr/local/mongotools:$PATH

# === MongoDB 配置 ===
MONGODB_HOST="swlws.site"
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
  
  # 定义不带日期的备份目录
  BACKUP_DIR_NO_DATE="${BACKUP_BASE_DIR}/${TARGET_DB}"
  
  # 创建不带日期的备份目录
  mkdir -p "$BACKUP_DIR_NO_DATE"
  
  # 清空不带日期的备份目录
  rm -rf "$BACKUP_DIR_NO_DATE"/*
  
  # 拷贝带日期的备份到不带日期的目录
  cp -r "$BACKUP_DIR"/* "$BACKUP_DIR_NO_DATE"
  
  if [ $? -eq 0 ]; then
    echo "✅ 成功将备份拷贝到不带日期的目录：$BACKUP_DIR_NO_DATE"
  else
    echo "❌ 拷贝备份到不带日期的目录失败"
    exit 1
  fi
else
  echo "❌ 备份失败，请检查连接或权限"
  exit 1
fi
