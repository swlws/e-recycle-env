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
  --eval '
    const db = db.getSiblingDB("swlws");

    // 删除已存在的集合
    print("正在删除已存在的集合...");
    db.test.drop();
    
    // 插入测试数据
    print("正在插入测试数据...");
    const result = db.test.insertMany([
      {
        "id": 1,
        "name": "测试数据1",
        "description": "这是第一条测试数据",
        "createTime": new Date(),
        "updateTime": new Date()
      },
    ]);
    
    // 验证插入结果
    const count = db.test.countDocuments();
    print("成功插入数据数量：" + count);
    
    if(count > 0) {
      print("插入的数据：");
      db.test.find().forEach(printjson);
    } else {
      print("警告：未成功插入数据！");
    }
  '

echo "MongoDB 测试数据初始化完成！"
