#!/bin/bash

# 检查是否为 root 用户
if [ "$EUID" -ne 0 ]; then
    echo "请使用 root 用户运行此脚本"
    exit 1
fi

chmod +x install-db/*.sh
chmod +x db-data/*.sh
chmod +x db-dump-restore/*.sh

echo "开始安装 MongoDB 环境..."

# 1. 安装 MongoDB 工具
echo "1. 安装 MongoDB 工具..."
./install-db/mongodb-tools.sh
if [ $? -ne 0 ]; then
    echo "❌ MongoDB 工具安装失败"
    exit 1
fi

# 2. 安装 MongoDB Shell
echo "2. 安装 MongoDB Shell..."
./install-db/mongosh.sh
if [ $? -ne 0 ]; then
    echo "❌ MongoDB Shell 安装失败"
    exit 1
fi

# 3. 安装 MongoDB
echo "3. 安装 MongoDB..."
./install-db/mongodb.sh
if [ $? -ne 0 ]; then
    echo "❌ MongoDB 安装失败"
    exit 1
fi

# 4. 初始化测试数据
echo "4. 初始化测试数据..."
./db-data/init.sh
if [ $? -ne 0 ]; then
    echo "❌ 测试数据初始化失败"
    exit 1
fi

echo "✅ MongoDB 环境安装完成！"
echo "你可以使用以下命令连接数据库："
echo "应用用户连接: mongosh --host 127.0.0.1:27017 --username swlws --password 'swlws@123!!!' --authenticationDatabase swlws"