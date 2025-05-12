#!/bin/bash

# 连接信息
MONGODB_HOST="127.0.0.1"
MONGODB_PORT="27017"
MONGODB_USER="swlws"
MONGODB_PASSWORD="swlws@123!!!"
MONGODB_DB="swlws"

echo "开始初始化 MongoDB 测试数据..."

# 初始化测试数据
mongosh --host $MONGODB_HOST:$MONGODB_PORT \
  --username $MONGODB_USER \
  --password "$MONGODB_PASSWORD" \
  --authenticationDatabase "$MONGODB_DB" \
  --file "$PWD/db-data/scripts/init.js"

echo "MongoDB 测试数据初始化完成！"
