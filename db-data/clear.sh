#!/bin/bash

# 连接信息
MONGODB_HOST="127.0.0.1"
MONGODB_PORT="27017"
MONGODB_USER="swlws"
MONGODB_PASSWORD="swlws@123!!!"
MONGODB_DB="swlws"

echo "开始清理 MongoDB 数据..."

# 要删除的集合列表，用逗号分隔
COLLECTION_LIST="test,demo"

# 清理数据
mongosh --host $MONGODB_HOST:$MONGODB_PORT \
  --username $MONGODB_USER \
  --password "$MONGODB_PASSWORD" \
  --authenticationDatabase "$MONGODB_DB" \
  --eval "
    const db = db.getSiblingDB('swlws');
    const collections = '${COLLECTION_LIST}'.split(',');
    
    print('准备删除以下集合：', collections);
    
    collections.forEach(collection => {
      try {
        print('正在删除集合：' + collection);
        db[collection].drop();
        print('成功删除集合：' + collection);
      } catch (error) {
        print('删除集合失败：' + collection + '，错误：' + error.message);
      }
    });
    
    print('所有集合删除操作完成！');
  "

echo "MongoDB 数据清理完成！"
