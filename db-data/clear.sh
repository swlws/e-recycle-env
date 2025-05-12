#!/bin/bash

# 连接信息
MONGODB_HOST="127.0.0.1"
MONGODB_PORT="27017"
MONGODB_USER="swlws"
MONGODB_PASSWORD="swlws@123!!!"
MONGODB_DB="swlws"

echo "开始清理 MongoDB 数据..."

# 要删除的集合列表，用逗号分隔
COLLECTION_LIST="test,t_log"

# 清理数据
mongosh --host $MONGODB_HOST:$MONGODB_PORT \
  --username $MONGODB_USER \
  --password "$MONGODB_PASSWORD" \
  --authenticationDatabase "$MONGODB_DB" \
  --file "$PWD/db-data/scripts/clear.js"

echo "MongoDB 数据清理完成！"
